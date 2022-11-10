Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B9D624287
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 13:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiKJMpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 07:45:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiKJMpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 07:45:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E27359858;
        Thu, 10 Nov 2022 04:45:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C8EEB820D1;
        Thu, 10 Nov 2022 12:45:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F148FC433D6;
        Thu, 10 Nov 2022 12:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668084338;
        bh=8atFlyKmDuSYROj014wFR2Xn4bzuBEPoctVPElHn4dg=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=H7dA71swSXiOQWlEQ5D8LlchEqPvvbmTnoc5dnt9wb5ecSdI0cyyCQdGNqa61MEta
         khZsMgCTxuBBS+rz7WbCFJvVzgtaWJGELBflfn2s2gqbo/Zlyx63+9pXVPv82GiyGq
         MLpsM7pThcBw+7YozmQ7ouRYu9vJUWjPklB75JZKSszjjgJQ3flRukytBtolW7s0/W
         rSRewG/0StN+Fe66kptbvpUgAN2z2KsXdw4CC0B8I83wnde3PWqtCWsg3pEgCUNj7H
         ZmNHcYw1BcBRBK4LxNlKTfvDaMy1x19d8ZSpS69URiW5AbMsO7SmtXuBT0LoT8J5eN
         t7RQ/Q/Tip+YQ==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B50D27826AB; Thu, 10 Nov 2022 13:45:35 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@meta.com>,
        John Fastabend <john.fastabend@gmail.com>, hawk@kernel.org,
        daniel@iogearbox.net, kuba@kernel.org, davem@davemloft.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, sdf@google.com
Subject: Re: [1/2 bpf-next] bpf: expose net_device from xdp for metadata
In-Reply-To: <636c5f21d82c1_13fe5e208e9@john.notmuch>
References: <20221109215242.1279993-1-john.fastabend@gmail.com>
 <20221109215242.1279993-2-john.fastabend@gmail.com>
 <0697cf41-eaa0-0181-b5c0-7691cb316733@meta.com>
 <636c5f21d82c1_13fe5e208e9@john.notmuch>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 10 Nov 2022 13:45:35 +0100
Message-ID: <87cz9vyo40.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend <john.fastabend@gmail.com> writes:

> Yonghong Song wrote:
>> 
>> 
>> On 11/9/22 1:52 PM, John Fastabend wrote:
>> > Allow xdp progs to read the net_device structure. Its useful to extract
>> > info from the dev itself. Currently, our tracing tooling uses kprobes
>> > to capture statistics and information about running net devices. We use
>> > kprobes instead of other hooks tc/xdp because we need to collect
>> > information about the interface not exposed through the xdp_md structures.
>> > This has some down sides that we want to avoid by moving these into the
>> > XDP hook itself. First, placing the kprobes in a generic function in
>> > the kernel is after XDP so we miss redirects and such done by the
>> > XDP networking program. And its needless overhead because we are
>> > already paying the cost for calling the XDP program, calling yet
>> > another prog is a waste. Better to do everything in one hook from
>> > performance side.
>> > 
>> > Of course we could one-off each one of these fields, but that would
>> > explode the xdp_md struct and then require writing convert_ctx_access
>> > writers for each field. By using BTF we avoid writing field specific
>> > convertion logic, BTF just knows how to read the fields, we don't
>> > have to add many fields to xdp_md, and I don't have to get every
>> > field we will use in the future correct.
>> > 
>> > For reference current examples in our code base use the ifindex,
>> > ifname, qdisc stats, net_ns fields, among others. With this
>> > patch we can now do the following,
>> > 
>> >          dev = ctx->rx_dev;
>> >          net = dev->nd_net.net;
>> > 
>> > 	uid.ifindex = dev->ifindex;
>> > 	memcpy(uid.ifname, dev->ifname, NAME);
>> >          if (net)
>> > 		uid.inum = net->ns.inum;
>> > 
>> > to report the name, index and ns.inum which identifies an
>> > interface in our system.
>> 
>> In
>> https://lore.kernel.org/bpf/ad15b398-9069-4a0e-48cb-4bb651ec3088@meta.com/
>> Namhyung Kim wanted to access new perf data with a helper.
>> I proposed a helper bpf_get_kern_ctx() which will get
>> the kernel ctx struct from which the actual perf data
>> can be retrieved. The interface looks like
>> 	void *bpf_get_kern_ctx(void *)
>> the input parameter needs to be a PTR_TO_CTX and
>> the verifer is able to return the corresponding kernel
>> ctx struct based on program type.
>> 
>> The following is really hacked demonstration with
>> some of change coming from my bpf_rcu_read_lock()
>> patch set https://lore.kernel.org/bpf/20221109211944.3213817-1-yhs@fb.com/
>> 
>> I modified your test to utilize the
>> bpf_get_kern_ctx() helper in your test_xdp_md.c.
>> 
>> With this single helper, we can cover the above perf
>> data use case and your use case and maybe others
>> to avoid new UAPI changes.
>
> hmm I like the idea of just accessing the xdp_buff directly
> instead of adding more fields. I'm less convinced of the
> kfunc approach. What about a terminating field *self in the
> xdp_md. Then we can use existing convert_ctx_access to make
> it BPF inlined and no verifier changes needed.
>
> Something like this quickly typed up and not compiled, but
> I think shows what I'm thinking.
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 94659f6b3395..10ebd90d6677 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -6123,6 +6123,10 @@ struct xdp_md {
>         __u32 rx_queue_index;  /* rxq->queue_index  */
>  
>         __u32 egress_ifindex;  /* txq->dev->ifindex */
> +       /* Last xdp_md entry, for new types add directly to xdp_buff and use
> +        * BTF access. Reading this gives BTF access to xdp_buff.
> +        */
> +       __bpf_md_ptr(struct xdp_buff *, self);
>  };

xdp_md is UAPI; I really don't think it's a good idea to add "unstable"
BTF fields like this to it, that's just going to confuse people. Tying
this to a kfunc for conversion is more consistent with the whole "kfunc
and BTF are its own thing" expectation.

The kfunc doesn't actually have to execute any instructions either, it
can just be collapsed into a type conversion to BTF inside the verifier,
no?

-Toke
