Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 297391BFDD
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 01:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfEMXfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 19:35:01 -0400
Received: from mga04.intel.com ([192.55.52.120]:39736 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726511AbfEMXfB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 19:35:01 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 May 2019 16:30:58 -0700
X-ExtLoop1: 1
Received: from samudral-mobl1.amr.corp.intel.com (HELO [134.134.177.79]) ([134.134.177.79])
  by orsmga007.jf.intel.com with ESMTP; 13 May 2019 16:30:58 -0700
Subject: Re: [RFC bpf-next 0/7] busy poll support for AF_XDP sockets
To:     Jonathan Lemon <bsd@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
References: <1556786363-28743-1-git-send-email-magnus.karlsson@intel.com>
 <20190506163135.blyqrxitmk5yrw7c@ast-mbp>
 <CAJ8uoz2MFtoXwuhAp5A0teMmwU2v623pHf2k0WSFi0kovJYjtw@mail.gmail.com>
 <20190507182435.6f2toprk7jus6jid@ast-mbp>
 <D40B5C89-53F8-4EC1-AB35-FB7C395864DE@fb.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Message-ID: <d55253dd-42b4-9cb1-ddc9-4f74c06ec845@intel.com>
Date:   Mon, 13 May 2019 16:30:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <D40B5C89-53F8-4EC1-AB35-FB7C395864DE@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/13/2019 1:42 PM, Jonathan Lemon wrote:
> Tossing in my .02 cents:
> 
> 
> I anticipate that most users of AF_XDP will want packet processing
> for a given RX queue occurring on a single core - otherwise we end
> up with cache delays.  The usual model is one thread, one socket,
> one core, but this isn't enforced anywhere in the AF_XDP code and is
> up to the user to set this up.

AF_XDP with busypoll should allow a single thread to poll a given RX
queue and use a single core.

> 
> On 7 May 2019, at 11:24, Alexei Starovoitov wrote:
>> I'm not saying that we shouldn't do busy-poll. I'm saying it's
>> complimentary, but in all cases single core per af_xdp rq queue
>> with user thread pinning is preferred.
> 
> So I think we're on the same page here.
> 
>> Stack rx queues and af_xdp rx queues should look almost the same from
>> napi point of view. Stack -> normal napi in softirq. af_xdp -> new
>> kthread
>> to work with both poll and busy-poll. The only difference between
>> poll and busy-poll will be the running context: new kthread vs user
>> task.
> ...
>> A burst of 64 packets on stack queues or some other work in softirqd
>> will spike the latency for af_xdp queues if softirq is shared.
> 
> True, but would it be shared?  This goes back to the current model,
> which
> as used by Intel is:
> 
>      (channel == RX, TX, softirq)
> 
> MLX, on the other hand, wants:
> 
>      (channel == RX.stack, RX.AF_XDP, TX.stack, TX.AF_XDP, softirq)
> 
> Which would indeed lead to sharing.  The more I look at the above, the
> stronger I start to dislike it.  Perhaps this should be disallowed?
> 
> I believe there was some mention at LSF/MM that the 'channel' concept
> was something specific to HW and really shouldn't be part of the SW API.
> 
>> Hence the proposal for new napi_kthreads:
>> - user creates af_xdp socket and binds to _CPU_ X then
>> - driver allocates single af_xdp rq queue (queue ID doesn't need to be
>> exposed)
>> - spawns kthread pinned to cpu X
>> - configures irq for that af_xdp queue to fire on cpu X
>> - user space with the help of libbpf pins its processing thread to
>> that cpu X
>> - repeat above for as many af_xdp sockets as there as cpus
>>    (its also ok to pick the same cpu X for different af_xdp socket
>>    then new kthread is shared)
>> - user space configures hw to RSS to these set of af_xdp sockets.
>>    since ethtool api is a mess I propose to use af_xdp api to do this
>> rss config
> 
> 
>   From a high level point of view, this sounds quite sensible, but does
> need
> some details ironed out.  The model above essentially enforces a model
> of:
> 
>      (af_xdp = RX.af_xdp + bound_cpu)
>        (bound_cpu = hw.cpu + af_xdp.kthread + hw.irq)
> 
> (temporarily ignoring TX for right now)
> 
> 
> I forsee two issues with the above approach:
>     1. hardware limitations in the number of queues/rings
>     2. RSS/steering rules
> 
>> - user creates af_xdp socket and binds to _CPU_ X then
>> - driver allocates single af_xdp rq queue (queue ID doesn't need to be
>> exposed)
> 
> Here, the driver may not be able to create an arbitrary RQ, but may need
> to
> tear down/reuse an existing one used by the stack.  This may not be an
> issue
> for modern hardware.
> 
>> - user space configures hw to RSS to these set of af_xdp sockets.
>>    since ethtool api is a mess I propose to use af_xdp api to do this
>> rss config
> 
> Currently, RSS only steers default traffic.  On a system with shared
> stack/af_xdp queues, there should be a way to split the traffic types,
> unless we're talking about a model where all traffic goes to AF_XDP.
> 
> This classification has to be done by the NIC, since it comes before RSS
> steering - which currently means sending flow match rules to the NIC,
> which
> is less than ideal.  I agree that the ethtool interface is non optimal,
> but
> it does make things clear to the user what's going on.

'tc' provides another interface to split NIC queues into groups of
queues each with its own RSS. For ex:
tc qdisc add dev <i/f> root mqprio num_tc 3 map 0 1 2 queues 2@0 32@2 
8@34 hw 1 mode channel
will split NIC queues into 3 groups of 2, 32 and 8 queues.

By default all the packets goto only the first queue group with 2 
queues. Filters can be added to redirect packets to the other queues groups.

tc filter add dev <i/f> protocol ip ingress prio 1 flower dst_ip 
192.168.0.2 ip_proto tcp dst_port 1234 skip_sw hw_tc 1
tc filter add dev <i/f> protocol ip ingress prio 1 flower dst_ip 
192.168.0.3 ip_proto tcp dst_port 1234 skip_sw hw_tc 2

Here hw_tc indicates the queue group.

It should be possible to run AF_XDP on queue group 3 by creating 8 
af-xdp sockets and binding them to queues 34-42.

Does this look like a reasonable model to use a subset of nic queues for 
af-xdp applications?


> 
> Perhaps an af_xdp library that does some bookkeeping:
>     - open af_xdp socket
>     - define af_xdp_set as (classification, steering rules, other?)
>     - bind socket to (cpu, af_xdp_set)
>     - kernel:
>       - pins calling thread to cpu
>       - creates kthread if one doesn't exist, binds to irq and cpu
>       - has driver create RQ.af_xdp, possibly replacing RQ.stack
>       - applies (af_xdp_set) to NIC.
> 
> Seems workable, but a little complicated?  The complexity could be moved
> into a separate library.
> 
> 
>> imo that would be the simplest and performant way of using af_xdp.
>> All configuration apis are under libbpf (or libxdp if we choose to
>> fork it)
>> End result is one af_xdp rx queue - one napi - one kthread - one user
>> thread.
>> All pinned to the same cpu with irq on that cpu.
>> Both poll and busy-poll approaches will not bounce data between cpus.
>> No 'shadow' queues to speak of and should solve the issues that
>> folks were bringing up in different threads.
> 
> Sounds like a sensible model from my POV.
> 
