Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99FCE4DBD6C
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 04:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbiCQDUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 23:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiCQDUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 23:20:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B6321255;
        Wed, 16 Mar 2022 20:18:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE8C761336;
        Thu, 17 Mar 2022 03:18:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315FEC340EC;
        Thu, 17 Mar 2022 03:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647487135;
        bh=gvE3+/ElSE9yvoZpZIsRKB6D9Lnqy5SmG41P0Reg/AU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZQVy5cIVgYdNDSu0mjNhiXNloQ+KBPGaUD2ENJxZvAA59CDLtPeunLeckpW124o+J
         wlRSAWRSyFdGkK8n7AKV6Eif59zXOjnma/q+ySUcIqVLalvwDtnKiC8GhT16erK85i
         ljp3ocnqtPoDNb+JcXWb6T62KDc/59EaETsSQbebrvjLlq8rm1KdA4IzawX8JkhP24
         3N9rPf3Rowsn/XTbXwaKWnVlolzUqG+0zNQ4wkSoVW0Se8YWq+AJYkWpTpNWn2ZkN4
         2FyYVyAAol5MyPzajWMtZ9wVWYv+eRtxCDjtgksamYtWvdoc7FXES3sM9i2d19c1Xh
         QrEqoshZefUFg==
Date:   Wed, 16 Mar 2022 20:18:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com, dsahern@kernel.org
Cc:     pabeni@redhat.com, rostedt@goodmis.org, mingo@redhat.com,
        xeb@mail.ru, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org, alobakin@pm.me,
        flyingpeng@tencent.com, mengensun@tencent.com,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, benbjiang@tencent.com
Subject: Re: [PATCH net-next v3 3/3] net: icmp: add reasons of the skb drops
 to icmp protocol
Message-ID: <20220316201853.0734280f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220316063148.700769-4-imagedong@tencent.com>
References: <20220316063148.700769-1-imagedong@tencent.com>
        <20220316063148.700769-4-imagedong@tencent.com>
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

On Wed, 16 Mar 2022 14:31:48 +0800 menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> Replace kfree_skb() used in icmp_rcv() and icmpv6_rcv() with
> kfree_skb_reason().
> 
> In order to get the reasons of the skb drops after icmp message handle,
> we change the return type of 'handler()' in 'struct icmp_control' from
> 'bool' to 'enum skb_drop_reason'. This may change its original
> intention, as 'false' means failure, but 'SKB_NOT_DROPPED_YET' means
> success now. Therefore, all 'handler' and the call of them need to be
> handled. Following 'handler' functions are involved:
> 
> icmp_unreach()
> icmp_redirect()
> icmp_echo()
> icmp_timestamp()
> icmp_discard()
> 
> And following new drop reasons are added:
> 
> SKB_DROP_REASON_ICMP_CSUM
> SKB_DROP_REASON_ICMP_TYPE
> SKB_DROP_REASON_ICMP_BROADCAST
> 
> Reviewed-by: Hao Peng <flyingpeng@tencent.com>
> Reviewed-by: Jiang Biao <benbjiang@tencent.com>
> Signed-off-by: Menglong Dong <imagedong@tencent.com>

I guess this set raises the follow up question to Dave if adding 
drop reasons to places with MIB exception stats means improving 
the granularity or one MIB stat == one reason?

> -bool ping_rcv(struct sk_buff *skb)
> +enum skb_drop_reason ping_rcv(struct sk_buff *skb)
>  {
> +	enum skb_drop_reason reason = SKB_DROP_REASON_NO_SOCKET;
>  	struct sock *sk;
>  	struct net *net = dev_net(skb->dev);
>  	struct icmphdr *icmph = icmp_hdr(skb);
> -	bool rc = false;
>  
>  	/* We assume the packet has already been checked by icmp_rcv */
>  
> @@ -980,15 +980,17 @@ bool ping_rcv(struct sk_buff *skb)
>  		struct sk_buff *skb2 = skb_clone(skb, GFP_ATOMIC);
>  
>  		pr_debug("rcv on socket %p\n", sk);
> -		if (skb2 && !ping_queue_rcv_skb(sk, skb2))
> -			rc = true;
> +		if (skb2)
> +			reason = __ping_queue_rcv_skb(sk, skb2);
> +		else
> +			reason = SKB_DROP_REASON_NOMEM;
>  		sock_put(sk);
>  	}
>  
> -	if (!rc)
> +	if (reason)
>  		pr_debug("no socket, dropping\n");

This is going to be printed on memory allocation failures now as well.
