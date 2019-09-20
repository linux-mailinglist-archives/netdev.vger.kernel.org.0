Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85C1AB88FC
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 03:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391957AbfITBm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 21:42:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43778 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731387AbfITBm6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 21:42:58 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2E5873082E44;
        Fri, 20 Sep 2019 01:42:57 +0000 (UTC)
Received: from [10.72.12.88] (ovpn-12-88.pek2.redhat.com [10.72.12.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D79885D6B0;
        Fri, 20 Sep 2019 01:42:45 +0000 (UTC)
Subject: Re: [RFC {net,iproute2}-next 0/2] Introduce an eBPF hookpoint for tx
 queue selection in the XPS (Transmit Packet Steering) code.
To:     Matt Cover <werekraken@gmail.com>, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, nikolay@cumulusnetworks.com,
        sd@queasysnail.net, sbrivio@redhat.com, vincent@bernat.ch,
        kda@linux-powerpc.org, Matthew Cover <matthew.cover@stackpath.com>,
        jiri@mellanox.com, Eric Dumazet <edumazet@google.com>,
        pabeni@redhat.com, idosch@mellanox.com, petrm@mellanox.com,
        f.fainelli@gmail.com, stephen@networkplumber.org,
        dsahern@gmail.com, christian@brauner.io,
        jakub.kicinski@netronome.com,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        johannes.berg@intel.com, mkubecek@suse.cz, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20190919224458.91422-1-matthew.cover@stackpath.com>
 <CAGyo_hrkUPxBAOttpo+xqcUHr89i2N5BOV4_rYFh=dRPkYVPGA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <fa17e10b-d61b-00c3-b3eb-02cf6a197b78@redhat.com>
Date:   Fri, 20 Sep 2019 09:42:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAGyo_hrkUPxBAOttpo+xqcUHr89i2N5BOV4_rYFh=dRPkYVPGA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 20 Sep 2019 01:42:58 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/20 上午8:05, Matt Cover wrote:
> On Thu, Sep 19, 2019 at 3:45 PM Matthew Cover <werekraken@gmail.com> wrote:
>> WORK IN PROGRESS:
>>    * bpf program loading works!
>>    * txq steering via bpf program return code works!
>>    * bpf program unloading not working.
>>    * bpf program attached query not working.
>>
>> This patch set provides a bpf hookpoint with goals similar to, but a more
>> generic implementation than, TUNSETSTEERINGEBPF; userspace supplied tx queue
>> selection policy.


One point that I introduce TUNSETSTEERINGEBPF instead of using a generic 
way like cls/act bpf is that I need make sure to have a consistent API 
with macvtap.

In the case of macvtap, TX means transmit from userspace to kernel, but 
for TUN, it means transmit from kernel to userspace.


>>
>> TUNSETSTEERINGEBPF is a useful bpf hookpoint, but has some drawbacks.
>>
>> First, it only works on tun/tap devices.
>>
>> Second, there is no way in the current TUNSETSTEERINGEBPF implementation
>> to bail out or load a noop bpf prog and fallback to the no prog tx queue
>> selection method.


I believe it expect that eBPF should take all the parts (even the 
fallback part).


>>
>> Third, the TUNSETSTEERINGEBPF interface seems to require possession of existing
>> or creation of new queues/fds.


That's the way TUN work for past +10 years because ioctl is the only way 
to do configuration and it requires a fd to carry that. David suggest to 
implement netlink but nobody did that.


>>
>> This most naturally fits in the "wire" implementation since possession of fds
>> is ensured. However, it also means the various "wire" implementations (e.g.
>> qemu) have to all be made aware of TUNSETSTEERINGEBPF and expose an interface
>> to load/unload a bpf prog (or provide a mechanism to pass an fd to another
>> program).


The load/unload of ebpf program is standard bpf() syscall. Ioctl just 
attach that to TUN. This idea is borrowed from packet socket which the 
bpf program was attached through setsockopt().


>>
>> Alternatively, you can spin up an extra queue and immediately disable via
>> IFF_DETACH_QUEUE, but this seems unsafe; packets could be enqueued to this
>> extra file descriptor which is part of our bpf prog loader, not our "wire".


You can use you 'wire' queue to do ioctl, but we can invent other API.


>>
>> Placing this in the XPS code and leveraging iproute2 and rtnetlink to provide
>> our bpf prog loader in a similar manner to xdp gives us a nice way to separate
>> the tap "wire" and the loading of tx queue selection policy. It also lets us
>> use this hookpoint for any device traversing XPS.
>>
>> This patch only introduces the new hookpoint to the XPS code and will not yet
>> be used by tun/tap devices using the intree tun.ko (which implements an
>> .ndo_select_queue and does not traverse the XPS code).
>>
>> In a future patch set, we can optionally refactor tun.ko to traverse this call
>> to bpf_prog_run_clear_cb() and bpf prog storage. tun/tap devices could then
>> leverage iproute2 as a generic loader. The TUNSETSTEERINGEBPF interface could
>> at this point be optionally deprecated/removed.


As described above, we need it for macvtap and you propose here can not 
work for that.

I'm not against this proposal, just want to clarify some considerations 
when developing TUNSETSTEERINGEPF. The main goal is for VM to implement 
sophisticated steering policy like RSS without touching kernel.

Thanks


>>
>> Both patches in this set have been tested using a rebuilt tun.ko with no
>> .ndo_select_queue.
>>
>>    sed -i '/\.ndo_select_queue.*=/d' drivers/net/tun.c
>>
>> The tap device was instantiated using tap_mq_pong.c, supporting scripts, and
>> wrapping service found here:
>>
>>    https://github.com/stackpath/rxtxcpu/tree/v1.2.6/helpers
>>
>> The bpf prog source and test scripts can be found here:
>>
>>    https://github.com/werekraken/xps_ebpf
>>
>> In nstxq, netsniff-ng using PACKET_FANOUT_QM is leveraged to check the
>> queue_mapping.
>>
>> With no prog loaded, the tx queue selection is adhering our xps_cpus
>> configuration.
>>
>>    [vagrant@localhost ~]$ grep . /sys/class/net/tap0/queues/tx-*/xps_cpus; ./nstxq; sudo timeout 1 cat /sys/kernel/debug/tracing/trace_pipe;
>>    /sys/class/net/tap0/queues/tx-0/xps_cpus:1
>>    /sys/class/net/tap0/queues/tx-1/xps_cpus:2
>>    cpu0: ping: 64 bytes from 169.254.254.1: icmp_seq=1 ttl=64 time=0.146 ms
>>    cpu0: qm0:  > tap0 98 Unknown => Unknown IPv4 169.254.254.2/169.254.254.1 Len 84 Type 8 Code 0
>>    cpu1: ping: 64 bytes from 169.254.254.1: icmp_seq=1 ttl=64 time=0.121 ms
>>    cpu1: qm1:  > tap0 98 Unknown => Unknown IPv4 169.254.254.2/169.254.254.1 Len 84 Type 8 Code 0
>>
>> With a return 0 bpg prog, our tx queue is 0 (despite xps_cpus).
>>
>>    [vagrant@localhost ~]$ sudo ip link set dev tap0 xps obj hello0.o sec hello && { ./nstxq; sudo timeout 1 cat /sys/kernel/debug/tracing/trace_pipe; }
>>    cpu0: ping: 64 bytes from 169.254.254.1: icmp_seq=1 ttl=64 time=0.160 ms
>>    cpu0: qm0:  > tap0 98 Unknown => Unknown IPv4 169.254.254.2/169.254.254.1 Len 84 Type 8 Code 0
>>    cpu1: ping: 64 bytes from 169.254.254.1: icmp_seq=1 ttl=64 time=0.124 ms
>>    cpu1: qm0:  > tap0 98 Unknown => Unknown IPv4 169.254.254.2/169.254.254.1 Len 84 Type 8 Code 0
>>                ping-4852  [000] ....  2691.633260: 0: xps (RET 0): Hello, World!
>>                ping-4869  [001] ....  2695.753588: 0: xps (RET 0): Hello, World!
>>
>> With a return 1 bpg prog, our tx queue is 1.
>>
>>    [vagrant@localhost ~]$ sudo ip link set dev tap0 xps obj hello1.o sec hello && { ./nstxq; sudo timeout 1 cat /sys/kernel/debug/tracing/trace_pipe; }
>>    cpu0: ping: 64 bytes from 169.254.254.1: icmp_seq=1 ttl=64 time=0.193 ms
>>    cpu0: qm1:  > tap0 98 Unknown => Unknown IPv4 169.254.254.2/169.254.254.1 Len 84 Type 8 Code 0
>>    cpu1: ping: 64 bytes from 169.254.254.1: icmp_seq=1 ttl=64 time=0.135 ms
>>    cpu1: qm1:  > tap0 98 Unknown => Unknown IPv4 169.254.254.2/169.254.254.1 Len 84 Type 8 Code 0
>>                ping-4894  [000] ....  2710.652080: 0: xps (RET 1): Hello, World!
>>                ping-4911  [001] ....  2714.774608: 0: xps (RET 1): Hello, World!
>>
>> With a return 2 bpg prog, our tx queue is 0 (we only have 2 tx queues).
>>
>>    [vagrant@localhost ~]$ sudo ip link set dev tap0 xps obj hello2.o sec hello && { ./nstxq; sudo timeout 1 cat /sys/kernel/debug/tracing/trace_pipe; }
>>    cpu0: ping: 64 bytes from 169.254.254.1: icmp_seq=1 ttl=64 time=1.20 ms
>>    cpu0: qm0:  > tap0 98 Unknown => Unknown IPv4 169.254.254.2/169.254.254.1 Len 84 Type 8 Code 0
>>    cpu1: ping: 64 bytes from 169.254.254.1: icmp_seq=1 ttl=64 time=0.986 ms
>>    cpu1: qm0:  > tap0 98 Unknown => Unknown IPv4 169.254.254.2/169.254.254.1 Len 84 Type 8 Code 0
>>                ping-4936  [000] ....  2729.442668: 0: xps (RET 2): Hello, World!
>>                ping-4953  [001] ....  2733.614558: 0: xps (RET 2): Hello, World!
>>
>> With a return -1 bpf prog, our tx queue selection is once again determined by
>> xps_cpus. Any negative return should work the same and provides a nice
>> mechanism to bail out or have a noop bpf prog at this hookpoint.
>>
>>    [vagrant@localhost ~]$ sudo ip link set dev tap0 xps obj hello_neg1.o sec hello && { ./nstxq; sudo timeout 1 cat /sys/kernel/debug/tracing/trace_pipe; }
>>    cpu0: ping: 64 bytes from 169.254.254.1: icmp_seq=1 ttl=64 time=0.628 ms
>>    cpu0: qm0:  > tap0 98 Unknown => Unknown IPv4 169.254.254.2/169.254.254.1 Len 84 Type 8 Code 0
>>    cpu1: ping: 64 bytes from 169.254.254.1: icmp_seq=1 ttl=64 time=0.322 ms
>>    cpu1: qm1:  > tap0 98 Unknown => Unknown IPv4 169.254.254.2/169.254.254.1 Len 84 Type 8 Code 0
>>                ping-4981  [000] ....  2763.510760: 0: xps (RET -1): Hello, World!
>>                ping-4998  [001] ....  2767.632583: 0: xps (RET -1): Hello, World!
>>
>> bpf prog unloading is not yet working and neither does `ip link show` report
>> when an "xps" bpf prog is attached. This is my first time touching iproute2 or
>> rtnetlink, so it may be something obvious to those more familiar.
> Adding Jason... sorry for missing that the first time.
