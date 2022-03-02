Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C29D4CAE79
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244230AbiCBTSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 14:18:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240728AbiCBTSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:18:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034DAA187;
        Wed,  2 Mar 2022 11:17:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FB0D61632;
        Wed,  2 Mar 2022 19:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C94DC004E1;
        Wed,  2 Mar 2022 19:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646248653;
        bh=/Z9NL1R6Uwfmg3+ggDEmUITGmY/PGsenpQnwgnFGBCw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CT5/d8lrPSRXqPX3lQErLUXiAvTtxI0LrBVyWTYAZJSadHlCNSL9UHC63GXIEfF3+
         tn+JRjIlHyvZhm4YxvbKZdayrrlH4OqaO9mdT04sir14vOKJwJaIFvme/ViMx28R78
         0LpPIahWyc/GU9aHeE/SyUaGVxsBs4YKHj03oheh1n2SPWneZq4gNqH79j+NaJxbYV
         TfD83doSTWw0kascuOG3ef/Mhh6TzhBhPKNUQ9Gpj3LZK++pu5C108VY71TaNz+NYU
         mzHMcrLo+BBQmKFDdA5u1tvaXL9p02Zwz/7nv9sbaGgC1RhHzV31Fw6Q/oF/vY7q4V
         OnpVqa5bYKBkA==
Date:   Wed, 2 Mar 2022 11:17:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, edumazet@google.com
Subject: Re: [PATCH net-next v4 4/4] net: tun: track dropped skb via
 kfree_skb_reason()
Message-ID: <20220302111731.00746020@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <ca81687c-4943-6d58-34f9-fb0a858f6887@oracle.com>
References: <20220226084929.6417-1-dongli.zhang@oracle.com>
        <20220226084929.6417-5-dongli.zhang@oracle.com>
        <20220301185021.7cba195d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <ca81687c-4943-6d58-34f9-fb0a858f6887@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Mar 2022 10:19:30 -0800 Dongli Zhang wrote:
> On 3/1/22 6:50 PM, Jakub Kicinski wrote:
> > On Sat, 26 Feb 2022 00:49:29 -0800 Dongli Zhang wrote:  
> >> +	SKB_DROP_REASON_SKB_PULL,	/* failed to pull sk_buff data */
> >> +	SKB_DROP_REASON_SKB_TRIM,	/* failed to trim sk_buff data */  
> > 
> > IDK if these are not too low level and therefore lacking meaning.
> > 
> > What are your thoughts David?
> > 
> > Would it be better to up level the names a little bit and call SKB_PULL
> > something like "HDR_TRUNC" or "HDR_INV" or "HDR_ERR" etc or maybe
> > "L2_HDR_ERR" since in this case we seem to be pulling off ETH_HLEN?  
> 
> This is for device driver and I think for most of cases the people understanding
> source code will be involved. I think SKB_PULL is more meaningful to people
> understanding source code.
> 
> The functions to pull data to skb is commonly used with the same pattern, and
> not only for ETH_HLEN. E.g., I randomly found below in kernel source code.
> 
> 1071 static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
> 1072 {
> ... ...
> 1102         pulled_sci = pskb_may_pull(skb, macsec_extra_len(true));
> 1103         if (!pulled_sci) {
> 1104                 if (!pskb_may_pull(skb, macsec_extra_len(false)))
> 1105                         goto drop_direct;
> 1106         }
> ... ...
> 1254 drop_direct:
> 1255         kfree_skb(skb);
> 1256         *pskb = NULL;
> 1257         return RX_HANDLER_CONSUMED;
> 
> 
> About 'L2_HDR_ERR', I am curious what the user/administrator may do as next
> step, while the 'SKB_PULL' will be very clear to the developers which kernel
> operation (e.g., to pull some protocol/hdr data to sk_buff data) is with the issue.
> 
> I may use 'L2_HDR_ERR' if you prefer.

We don't have to break it out per layer if you prefer. Let's call it
HDR_TRUNC.

I don't like SKB_PULL, people using these trace points are as likely 
to be BPF developers as kernel developers and skb_pull will not be
meaningful to them. Besides the code can check if header is not
truncated in other ways than pskb_may_pull(). And calling things 
by the name of the helper that failed is bad precedent.

> > For SKB_TRIM the error comes from allocation failures, there may be
> > a whole bunch of skb helpers which will fail only under mem pressure,
> > would it be better to identify them and return some ENOMEM related
> > reason, since, most likely, those will be noise to whoever is tracking
> > real errors?  
> 
> The reasons I want to use SKB_TRIM:
> 
> 1. To have SKB_PULL and SKB_TRIM (perhaps more SKB_XXX in the future in the same
> set).
> 
> 2. Although so that SKB_TRIM is always caused by ENOMEM, suppose if there is new
> return values by pskb_trim(), the reason is not going to be valid any longer.
> 
> 
> I may use SKB_DROP_REASON_NOMEM if you prefer.
> 
> Another concern is that many functions may return -ENOMEM. It is more likely
> that if there are two "goto drop" to return -ENOMEM, we will not be able to tell
> from which function the sk_buff is dropped, e.g.,
> 
> if (function_A()) {
>     reason = -ENOMEM;
>     goto drop;
> }
> 
> if (function_B()) {
>     reason = -ENOMEM;
>     goto drop;
> }

Are you saying that you're intending to break out skb drop reasons 
by what entity failed to allocate memory? I'd think "skb was dropped
because of OOM" is what should be reported. What we were trying to
allocate is not very relevant (and can be gotten from the stack trace 
if needed).

> >>  	SKB_DROP_REASON_DEV_HDR,	/* there is something wrong with
> >>  					 * device driver specific header
> >>  					 */
> >> +	SKB_DROP_REASON_DEV_READY,	/* device is not ready */  
> > 
> > What is ready? link is not up? peer not connected? can we expand?
> 
> In this patchset, it is for either:
> 
> - tun->tfiles[txq] is not set, or
> 
> - !(tun->dev->flags & IFF_UP)
> 
> I want to make it very generic so that the sk_buff dropped due to any device
> level data structure that is not up/ready/initialized/allocated will use this
> reason in the future.

Let's expand the documentation so someone reading thru the enum can
feel confident if they are using this reason correctly.

Side note - you may want to switch to inline comments to make writing
more verbose documentation, I mean:

	/* This is the explanation of reason one which explains what
	 * reason ones means, and how it should be used. We can make
	 * use of full line width this way.
         */
	SKB_DROP_REASON_ONE,
	/* And this is an explanation for reason two. */
	SKB_DROP_REASON_TWO,
