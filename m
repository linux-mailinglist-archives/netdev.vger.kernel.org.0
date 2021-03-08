Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57544331A0D
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 23:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbhCHWOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 17:14:41 -0500
Received: from www62.your-server.de ([213.133.104.62]:35552 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbhCHWOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 17:14:40 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lJO99-0001bM-Dr; Mon, 08 Mar 2021 23:14:39 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lJO99-000SmB-6d; Mon, 08 Mar 2021 23:14:39 +0100
Subject: Re: [PATCH bpf-next V2 1/2] bpf: BPF-helper for MTU checking add
 length input
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        john.fastabend@gmail.com,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Marek Majtyka <alardam@gmail.com>
References: <161364896576.1250213.8059418482723660876.stgit@firesoul>
 <161364899856.1250213.17435782167100828617.stgit@firesoul>
 <e339303d-1d95-e8d4-565c-920eb1a3eca8@iogearbox.net>
 <20210227113741.5cd5a03d@carbon>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d4b9d966-6079-107e-de4e-f4405dd9404c@iogearbox.net>
Date:   Mon, 8 Mar 2021 23:14:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210227113741.5cd5a03d@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26102/Mon Mar  8 13:03:13 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/27/21 11:37 AM, Jesper Dangaard Brouer wrote:
> On Sat, 27 Feb 2021 00:36:02 +0100
> Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 2/18/21 12:49 PM, Jesper Dangaard Brouer wrote:
>>> The FIB lookup example[1] show how the IP-header field tot_len
>>> (iph->tot_len) is used as input to perform the MTU check.
>>>
>>> This patch extend the BPF-helper bpf_check_mtu() with the same ability
>>> to provide the length as user parameter input, via mtu_len parameter.
>>>
>>> [1] samples/bpf/xdp_fwd_kern.c
>>>
>>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>>> Acked-by: John Fastabend <john.fastabend@gmail.com>
[...]
>> Btw, one more note on the whole bpf_*_check_mtu() helper... Last week I implemented
>> PMTU discovery support for clients for Cilium's XDP stand-alone LB in DSR mode, so I
>> was briefly considering whether to use the bpf_xdp_check_mtu() helper for retrieving
>> the device MTU, but then I thought to myself why having an unnecessary per-packet cost
>> for an extra helper call if I could just pass it in via constant instead. So I went
>> with the latter instead of the helper with the tradeoff to restart the Cilium agent
>> if someone actually changes MTU in prod which is a rare event anyway.
>>
>> Looking at what bpf_xdp_check_mtu() for example really offers is retrieval of dev->mtu
>> as well as dev->hard_header_len and the rest can all be done inside the BPF prog itself
>> w/o the helper overhead. Why am I mentioning this.. because the above change is a similar
>> case of what could have been done /inside/ the BPF prog anyway (especially on XDP where
>> extra overhead should be cut where possible).
> 
> The XDP case looks super simple now, but I thinking ahead.  When
> Lorenzo adds multi-buff support, then we can/must update this helper to
> use another XDP length value, based on the multi-buff jumbo-frame len.
> 
> Maybe we need another helper or what you propose below. BUT we could
> also allow this helper (via flag?) to ALSO check if dev support
> multi-buff XDP transmit (besides MTU limit with multi-buff len).  Then
> the BPF-programmer can know this packet cannot be redirected to the
> device.

Whether a XDP program is running on a device with multi-buff support or without
it should be transparent to this helper, in other words, the helper would have
to figure this out internally so that programs wouldn't have to be changed (in
the ideal case).

Overall, I still think that especially for the XDP case where performance matters
most, all this could have been done inside the program itself w/o the overhead of
the helper call as outlined earlier with struct bpf_dev ; adding more flags like
querying if a device supports multi-buff XDP transmit has not much to do with the
original purpose of bpf_xdp_check_mtu() anymore (aka do one thing/do it well mantra),
maybe the API should have been named bpf_xdp_check_forwardable() instead if it goes
beyond MTU .. But similarly here, struct bpf_dev property could also solve this
case if the prog developer needs more sanity checks when it is not clear whether
both devs support it, which can then also be /compiled out/ for the situation when
it /is/ known a-priori.

>> I think it got lost somewhere in the many versions of the original set where it was
>> mentioned before, but allowing to retrieve the dev object into BPF context and then
>> exposing it similarly to how we handle the case of struct bpf_tcp_sock would have been
>> much cleaner approach, e.g. the prog from XDP and tc context would be able to do:
>>
>>     struct bpf_dev *dev = ctx->dev;
>>
>> And we expose initially, for example:
>>
>>     struct bpf_dev {
>>       __u32 mtu;
>>       __u32 hard_header_len;
>>       __u32 ifindex;
>>       __u32 rx_queues;
>>       __u32 tx_queues;
>>     };
>>
>> And we could also have a BPF helper for XDP and tc that would fetch a /different/ dev
>> given we're under RCU context anyway, like ...
>>
>> BPF_CALL_2(bpf_get_dev, struct xdp_buff *, xdp, u32, ifindex)
>> {
>> 	return dev_get_by_index_rcu(dev_net(xdp->rxq->dev), index);
>> }
>>
>> ... returning a new dev_or_null type. With this flexibility everything else can be done
>> inside the prog, and later on it easily allows to expose more from dev side. Actually,
>> I'm inclined to code it up ...
> 
> I love the idea to retrieve the dev object into BPF context.  It is
> orthogonal, and doesn't replace the MTU helpers as the packet ctx
> objects (SKB and xdp_buff) are more complex, and the helper allows us
> to extend them without users have to update their BPF-code (as desc
> above).
> 
> I do think it makes a lot of sense to expose/retrieve dev object into
> BPF context.  As I hinted about, when we implement XDP multi-buff, then
> the bpf_redirect BPF-helper cannot check if the remote device support
> multi-buff transmit (as it don't have packet ctx).  If we have the dev
> object, the we could expose XDP features that allow us (BPF-programmer)
> to check this prior to doing the redirect.

Yep, that would be cleaner.

Thanks,
Daniel
