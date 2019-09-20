Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04589B884D
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 02:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406259AbfITAF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 20:05:29 -0400
Received: from mail-ua1-f68.google.com ([209.85.222.68]:46912 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404681AbfITAF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 20:05:29 -0400
Received: by mail-ua1-f68.google.com with SMTP id m21so1666632ual.13;
        Thu, 19 Sep 2019 17:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=QkUwz5xhRo/9F03n5Bte1Vs+BpiUIhnebbo6RmVEJCo=;
        b=mb0zuXXO/KC+zwN2J28aOzAKQ0IqXXLFdTY2w15Rsm+Rb6i6hlEy6RSgGxSbqfM1Y1
         i+hKv5LIqT0M3cWK6IrUXOgiAZEJtnvP6E3DCCOsds1w5AD1zFQqJJaXAWkvnppN1J3m
         u1/a0frdNND4TQ4LuwvWcUZshwig3f1P+2iJx1NLaowos67GFNTXTM+xEOqaP3LFGN0Z
         2xHjLS7KzVEnH5tTi8YHxT6QVYxxkoW8LJw1tJWBaF8xzQcijO5RkIWI77oTMyYoteSQ
         mYvFkn/S2t8vHk8lrCEk0te3STsM2ppdeC9QfsjwBNf/6Bwckyljqj6G2i7l2MV7JMIW
         yNwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=QkUwz5xhRo/9F03n5Bte1Vs+BpiUIhnebbo6RmVEJCo=;
        b=ua2ho7zZ81+9NmHEZZ1PzxewG4aBKRKliN/U4+E/0Mr0USOF1h/AmFUMnC0krSgZgr
         k377wBROykv4KUCx8XhLh4NycC2GCga2Qq7oSF8hATXVG2svJfgs9SgC/gJ0tE249mxU
         zoTjZcbUlozkbCjv/cV/oP5v7I/vuIwrDQCysArwmlSpUNuTjlOn1/mEpzB7ZUSlymkx
         yElIuyG/5h5M/2b8JdeuIF2ioEEXJEAoflvlm1raqrW2kdEk0wt5w/z4qvUyeSj60wpV
         ObtPBXuoZ1Uq6nNn9lNM/M66NEqWoT14J6w8Q7JRo83b/R3o/mI0RAMiRR7ZEJfoFHcd
         KyRA==
X-Gm-Message-State: APjAAAXCnq4yUKkg1EPGW9pVv2OLdNpBsDbjHN1RONQOJOtD+9v8/1iz
        +T/HxpvFL9pulbwdIz2NJ4hgGA/tECr7+w2Nh2k=
X-Google-Smtp-Source: APXvYqzWFeN82a7ivnSWhCyirgskp8rj3ehrKDRc8JWhj3hT8rf8PKbZJUkogOPRht2T5ymsjVoV6Pgdup3xVtIANAA=
X-Received: by 2002:ab0:224e:: with SMTP id z14mr5425489uan.36.1568937925776;
 Thu, 19 Sep 2019 17:05:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190919224458.91422-1-matthew.cover@stackpath.com>
In-Reply-To: <20190919224458.91422-1-matthew.cover@stackpath.com>
From:   Matt Cover <werekraken@gmail.com>
Date:   Thu, 19 Sep 2019 17:05:14 -0700
Message-ID: <CAGyo_hrkUPxBAOttpo+xqcUHr89i2N5BOV4_rYFh=dRPkYVPGA@mail.gmail.com>
Subject: Re: [RFC {net,iproute2}-next 0/2] Introduce an eBPF hookpoint for tx
 queue selection in the XPS (Transmit Packet Steering) code.
To:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        nikolay@cumulusnetworks.com, sd@queasysnail.net,
        sbrivio@redhat.com, vincent@bernat.ch, kda@linux-powerpc.org,
        Matthew Cover <matthew.cover@stackpath.com>, jiri@mellanox.com,
        Eric Dumazet <edumazet@google.com>, pabeni@redhat.com,
        idosch@mellanox.com, petrm@mellanox.com, f.fainelli@gmail.com,
        stephen@networkplumber.org, dsahern@gmail.com,
        christian@brauner.io, jakub.kicinski@netronome.com,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        johannes.berg@intel.com, mkubecek@suse.cz, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 3:45 PM Matthew Cover <werekraken@gmail.com> wrote:
>
> WORK IN PROGRESS:
>   * bpf program loading works!
>   * txq steering via bpf program return code works!
>   * bpf program unloading not working.
>   * bpf program attached query not working.
>
> This patch set provides a bpf hookpoint with goals similar to, but a more
> generic implementation than, TUNSETSTEERINGEBPF; userspace supplied tx queue
> selection policy.
>
> TUNSETSTEERINGEBPF is a useful bpf hookpoint, but has some drawbacks.
>
> First, it only works on tun/tap devices.
>
> Second, there is no way in the current TUNSETSTEERINGEBPF implementation
> to bail out or load a noop bpf prog and fallback to the no prog tx queue
> selection method.
>
> Third, the TUNSETSTEERINGEBPF interface seems to require possession of existing
> or creation of new queues/fds.
>
> This most naturally fits in the "wire" implementation since possession of fds
> is ensured. However, it also means the various "wire" implementations (e.g.
> qemu) have to all be made aware of TUNSETSTEERINGEBPF and expose an interface
> to load/unload a bpf prog (or provide a mechanism to pass an fd to another
> program).
>
> Alternatively, you can spin up an extra queue and immediately disable via
> IFF_DETACH_QUEUE, but this seems unsafe; packets could be enqueued to this
> extra file descriptor which is part of our bpf prog loader, not our "wire".
>
> Placing this in the XPS code and leveraging iproute2 and rtnetlink to provide
> our bpf prog loader in a similar manner to xdp gives us a nice way to separate
> the tap "wire" and the loading of tx queue selection policy. It also lets us
> use this hookpoint for any device traversing XPS.
>
> This patch only introduces the new hookpoint to the XPS code and will not yet
> be used by tun/tap devices using the intree tun.ko (which implements an
> .ndo_select_queue and does not traverse the XPS code).
>
> In a future patch set, we can optionally refactor tun.ko to traverse this call
> to bpf_prog_run_clear_cb() and bpf prog storage. tun/tap devices could then
> leverage iproute2 as a generic loader. The TUNSETSTEERINGEBPF interface could
> at this point be optionally deprecated/removed.
>
> Both patches in this set have been tested using a rebuilt tun.ko with no
> .ndo_select_queue.
>
>   sed -i '/\.ndo_select_queue.*=/d' drivers/net/tun.c
>
> The tap device was instantiated using tap_mq_pong.c, supporting scripts, and
> wrapping service found here:
>
>   https://github.com/stackpath/rxtxcpu/tree/v1.2.6/helpers
>
> The bpf prog source and test scripts can be found here:
>
>   https://github.com/werekraken/xps_ebpf
>
> In nstxq, netsniff-ng using PACKET_FANOUT_QM is leveraged to check the
> queue_mapping.
>
> With no prog loaded, the tx queue selection is adhering our xps_cpus
> configuration.
>
>   [vagrant@localhost ~]$ grep . /sys/class/net/tap0/queues/tx-*/xps_cpus; ./nstxq; sudo timeout 1 cat /sys/kernel/debug/tracing/trace_pipe;
>   /sys/class/net/tap0/queues/tx-0/xps_cpus:1
>   /sys/class/net/tap0/queues/tx-1/xps_cpus:2
>   cpu0: ping: 64 bytes from 169.254.254.1: icmp_seq=1 ttl=64 time=0.146 ms
>   cpu0: qm0:  > tap0 98 Unknown => Unknown IPv4 169.254.254.2/169.254.254.1 Len 84 Type 8 Code 0
>   cpu1: ping: 64 bytes from 169.254.254.1: icmp_seq=1 ttl=64 time=0.121 ms
>   cpu1: qm1:  > tap0 98 Unknown => Unknown IPv4 169.254.254.2/169.254.254.1 Len 84 Type 8 Code 0
>
> With a return 0 bpg prog, our tx queue is 0 (despite xps_cpus).
>
>   [vagrant@localhost ~]$ sudo ip link set dev tap0 xps obj hello0.o sec hello && { ./nstxq; sudo timeout 1 cat /sys/kernel/debug/tracing/trace_pipe; }
>   cpu0: ping: 64 bytes from 169.254.254.1: icmp_seq=1 ttl=64 time=0.160 ms
>   cpu0: qm0:  > tap0 98 Unknown => Unknown IPv4 169.254.254.2/169.254.254.1 Len 84 Type 8 Code 0
>   cpu1: ping: 64 bytes from 169.254.254.1: icmp_seq=1 ttl=64 time=0.124 ms
>   cpu1: qm0:  > tap0 98 Unknown => Unknown IPv4 169.254.254.2/169.254.254.1 Len 84 Type 8 Code 0
>               ping-4852  [000] ....  2691.633260: 0: xps (RET 0): Hello, World!
>               ping-4869  [001] ....  2695.753588: 0: xps (RET 0): Hello, World!
>
> With a return 1 bpg prog, our tx queue is 1.
>
>   [vagrant@localhost ~]$ sudo ip link set dev tap0 xps obj hello1.o sec hello && { ./nstxq; sudo timeout 1 cat /sys/kernel/debug/tracing/trace_pipe; }
>   cpu0: ping: 64 bytes from 169.254.254.1: icmp_seq=1 ttl=64 time=0.193 ms
>   cpu0: qm1:  > tap0 98 Unknown => Unknown IPv4 169.254.254.2/169.254.254.1 Len 84 Type 8 Code 0
>   cpu1: ping: 64 bytes from 169.254.254.1: icmp_seq=1 ttl=64 time=0.135 ms
>   cpu1: qm1:  > tap0 98 Unknown => Unknown IPv4 169.254.254.2/169.254.254.1 Len 84 Type 8 Code 0
>               ping-4894  [000] ....  2710.652080: 0: xps (RET 1): Hello, World!
>               ping-4911  [001] ....  2714.774608: 0: xps (RET 1): Hello, World!
>
> With a return 2 bpg prog, our tx queue is 0 (we only have 2 tx queues).
>
>   [vagrant@localhost ~]$ sudo ip link set dev tap0 xps obj hello2.o sec hello && { ./nstxq; sudo timeout 1 cat /sys/kernel/debug/tracing/trace_pipe; }
>   cpu0: ping: 64 bytes from 169.254.254.1: icmp_seq=1 ttl=64 time=1.20 ms
>   cpu0: qm0:  > tap0 98 Unknown => Unknown IPv4 169.254.254.2/169.254.254.1 Len 84 Type 8 Code 0
>   cpu1: ping: 64 bytes from 169.254.254.1: icmp_seq=1 ttl=64 time=0.986 ms
>   cpu1: qm0:  > tap0 98 Unknown => Unknown IPv4 169.254.254.2/169.254.254.1 Len 84 Type 8 Code 0
>               ping-4936  [000] ....  2729.442668: 0: xps (RET 2): Hello, World!
>               ping-4953  [001] ....  2733.614558: 0: xps (RET 2): Hello, World!
>
> With a return -1 bpf prog, our tx queue selection is once again determined by
> xps_cpus. Any negative return should work the same and provides a nice
> mechanism to bail out or have a noop bpf prog at this hookpoint.
>
>   [vagrant@localhost ~]$ sudo ip link set dev tap0 xps obj hello_neg1.o sec hello && { ./nstxq; sudo timeout 1 cat /sys/kernel/debug/tracing/trace_pipe; }
>   cpu0: ping: 64 bytes from 169.254.254.1: icmp_seq=1 ttl=64 time=0.628 ms
>   cpu0: qm0:  > tap0 98 Unknown => Unknown IPv4 169.254.254.2/169.254.254.1 Len 84 Type 8 Code 0
>   cpu1: ping: 64 bytes from 169.254.254.1: icmp_seq=1 ttl=64 time=0.322 ms
>   cpu1: qm1:  > tap0 98 Unknown => Unknown IPv4 169.254.254.2/169.254.254.1 Len 84 Type 8 Code 0
>               ping-4981  [000] ....  2763.510760: 0: xps (RET -1): Hello, World!
>               ping-4998  [001] ....  2767.632583: 0: xps (RET -1): Hello, World!
>
> bpf prog unloading is not yet working and neither does `ip link show` report
> when an "xps" bpf prog is attached. This is my first time touching iproute2 or
> rtnetlink, so it may be something obvious to those more familiar.

Adding Jason... sorry for missing that the first time.
