Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA9634DBF12
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 07:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiCQGOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 02:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiCQGOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 02:14:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C454B29B11A;
        Wed, 16 Mar 2022 22:52:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D1D66163F;
        Thu, 17 Mar 2022 03:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA2CCC340E9;
        Thu, 17 Mar 2022 03:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647489369;
        bh=5PovTOie4Ne7kUgZI017LKAk1GE61eZmSH3QhkYpREU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=LOF3IooWRG4kYt9Q+R/P5OHk+bxaFTn87J/jFg3dge9px4Xw+pNO8eaVtUQk+f3p8
         9wXOyAyQzxKDYby09YvxeBXJwGktJoKUntbzqwo5qdKb5Bz4j2Ng6A+IiKdH/j2a0d
         +ZOLnJH4DaCwUaPo9wZydoneV7UqMwF6+sCok46pOq40mGkhfzatLQyz6MHOYTobux
         xYCnt86ROzyGNQ5OzJi4SVoPmjhzGHgreZQ9ImZDOcpPLXgD1E3re1txSQYFUhb55S
         0/UoPNIHROtpsnvf2m47sUZIyoUZoNxI48iVHAxU5JrvwUEmqHS5ftkAo/OKH7IXCG
         FkTcG4owv/wfA==
Message-ID: <f6c1dbe5-ba6f-6e68-aa3b-4fe018d5092f@kernel.org>
Date:   Wed, 16 Mar 2022 21:56:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH net-next v3 2/3] net: icmp: introduce
 __ping_queue_rcv_skb() to report drop reasons
Content-Language: en-US
To:     menglong8.dong@gmail.com, kuba@kernel.org, pabeni@redhat.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, xeb@mail.ru,
        davem@davemloft.net, yoshfuji@linux-ipv6.org,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org, alobakin@pm.me,
        flyingpeng@tencent.com, mengensun@tencent.com,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, benbjiang@tencent.com
References: <20220316063148.700769-1-imagedong@tencent.com>
 <20220316063148.700769-3-imagedong@tencent.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220316063148.700769-3-imagedong@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/16/22 12:31 AM, menglong8.dong@gmail.com wrote:
> diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
> index 3ee947557b88..9a1ea6c263f8 100644
> --- a/net/ipv4/ping.c
> +++ b/net/ipv4/ping.c
> @@ -934,16 +934,24 @@ int ping_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
>  }
>  EXPORT_SYMBOL_GPL(ping_recvmsg);
>  
> -int ping_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
> +static enum skb_drop_reason __ping_queue_rcv_skb(struct sock *sk,
> +						 struct sk_buff *skb)
>  {
> +	enum skb_drop_reason reason;
> +
>  	pr_debug("ping_queue_rcv_skb(sk=%p,sk->num=%d,skb=%p)\n",
>  		 inet_sk(sk), inet_sk(sk)->inet_num, skb);
> -	if (sock_queue_rcv_skb(sk, skb) < 0) {
> -		kfree_skb(skb);
> +	if (sock_queue_rcv_skb_reason(sk, skb, &reason) < 0) {
> +		kfree_skb_reason(skb, reason);
>  		pr_debug("ping_queue_rcv_skb -> failed\n");
> -		return -1;
> +		return reason;
>  	}
> -	return 0;
> +	return SKB_NOT_DROPPED_YET;
> +}
> +
> +int ping_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
> +{
> +	return __ping_queue_rcv_skb(sk, skb) ?: -1;
>  }
>  EXPORT_SYMBOL_GPL(ping_queue_rcv_skb);
>  

This is a generic proto callback and you are now changing its return
code in a way that seems to conflict with existing semantics
