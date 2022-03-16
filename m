Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03B7D4DA8C4
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 04:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345836AbiCPDKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 23:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237407AbiCPDKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 23:10:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF1C29801;
        Tue, 15 Mar 2022 20:08:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4ECF76170A;
        Wed, 16 Mar 2022 03:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A4EC340E8;
        Wed, 16 Mar 2022 03:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647400129;
        bh=YxVaQ81qWMMCHBR2Z78VIwf3VDaaQfI9AxYKFAfkqkE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bXACU91+ilz2LBst6Tet4eds/MUmpWRgRJcdIW49ao2fj2EpXKUBBONd8Acy2qEd/
         ajne8Pe0OmCJqXqIY3PUdVXINhOGTMNtEb3SOEjQUls30drkvzqAVPC9VwieVW3Y1n
         Yuo4mVW1caLwVbHk8xYYV9CQFzE4zkPmyrxYCqOIz9oGTBC39bMho3o5E5kHb1wnVk
         vf+I9G0BF74iOKFQ42d3PJXQy1iVt4K1P7CBWw3ZRL9kPJrLmbyjGVFh6tcHEI9W2/
         gJHIeSrKYg2UdTkVkbCX0S9qeCib8K7LJYyt/+F4IBXLshfwCUSCMfy0cV8l0r2xvF
         2dsstVmEwPVkg==
Date:   Tue, 15 Mar 2022 20:08:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     dsahern@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        xeb@mail.ru, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org, alobakin@pm.me,
        flyingpeng@tencent.com, mengensun@tencent.com,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Biao Jiang <benbjiang@tencent.com>
Subject: Re: [PATCH net-next 1/3] net: gre_demux: add skb drop reasons to
 gre_rcv()
Message-ID: <20220315200847.68c2efee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220314133312.336653-2-imagedong@tencent.com>
References: <20220314133312.336653-1-imagedong@tencent.com>
        <20220314133312.336653-2-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Mar 2022 21:33:10 +0800 menglong8.dong@gmail.com wrote:
> +	reason = SKB_DROP_REASON_NOT_SPECIFIED;
>  	if (!pskb_may_pull(skb, 12))
>  		goto drop;

REASON_HDR_TRUNC ?

>  	ver = skb->data[1]&0x7f;
> -	if (ver >= GREPROTO_MAX)
> +	if (ver >= GREPROTO_MAX) {
> +		reason = SKB_DROP_REASON_GRE_VERSION;

TBH I'm still not sure what level of granularity we should be shooting
for with the reasons. I'd throw all unexpected header values into one 
bucket, not go for a reason per field, per protocol. But as I'm said
I'm not sure myself, so we can keep what you have..

>  		goto drop;
> +	}
>  
>  	rcu_read_lock();
>  	proto = rcu_dereference(gre_proto[ver]);
> -	if (!proto || !proto->handler)
> +	if (!proto || !proto->handler) {
> +		reason = SKB_DROP_REASON_GRE_NOHANDLER;

I think the ->handler check is defensive programming, there's no
protocol upstream which would leave handler NULL.

This is akin to SKB_DROP_REASON_PTYPE_ABSENT, we can reuse that or add
a new reason, but I'd think the phrasing should be kept similar.

>  		goto drop_unlock;
> +	}
>  	ret = proto->handler(skb);
