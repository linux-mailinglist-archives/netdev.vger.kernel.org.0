Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 615CB5BBEA8
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 17:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiIRPa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 11:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiIRPa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 11:30:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7651AD92
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 08:30:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04B1FB81057
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 15:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62464C433C1;
        Sun, 18 Sep 2022 15:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663515022;
        bh=EQ3FUZipllq04TfMzQSP7mtwHMu+ssXrH9a3NQtDCSo=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=LkJ+44f9dGLyXfS97f9qbK/ohyvU0eO3+0+u5Ixwi8eDTp1thp7mkHB/AEHdfCDs0
         BYFsnugivhlG8bQYtNoRysF3IBN3+vp0k3o6ThMb680RfAVwcOpJGCLa0fkBrD0di5
         EgstcPBQ9w523uqiydnDKr/7x6QwFEaWFZNeD8Go8T08E7+3xdXdS/MWpU3oPrynib
         oPfB/I1jDxlD3Fb7bUDD1IaaOKjqtnYtO4wufGAugzlCwQG/t5iuMuj6LYkmpUCVJA
         olLIHZwaeDpWzXhDCubbeydwpwe+elMm6Ea1oCOTY4ZOekS6BKiFyRfExjg6vznu1r
         jTy9PNSGrG0Tg==
Message-ID: <69a43dc8-c545-1187-7185-4b85215b726d@kernel.org>
Date:   Sun, 18 Sep 2022 09:30:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH] ipv4: ping: Fix potential use-after-free bug
Content-Language: en-US
To:     Liang He <windhl@126.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
References: <20220916100727.4096852-1-windhl@126.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220916100727.4096852-1-windhl@126.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/16/22 4:07 AM, Liang He wrote:
> In ping_unhash(), we should move sock_put(sk) after any possible
> access point as the put function may free the object.

unhash handlers are called from sk_common_release which still has a
reference on the sock, so not really going to hit a UAF.

I do agree that it does not read correctly to 'put' a reference then
continue using the object. ie., the put should be moved to the end like
you have here. This is more of a tidiness exercise than a need to
backport to stable kernels.

> 
> Fixes: c319b4d76b9e ("net: ipv4: add IPPROTO_ICMP socket kind")
> Signed-off-by: Liang He <windhl@126.com>
> ---
> 
>  I have found other places containing similar code patterns.
> 
>  net/ipv4/ping.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
> index b83c2bd9d722..f90c86d37ffc 100644
> --- a/net/ipv4/ping.c
> +++ b/net/ipv4/ping.c
> @@ -157,10 +157,10 @@ void ping_unhash(struct sock *sk)
>  	spin_lock(&ping_table.lock);
>  	if (sk_hashed(sk)) {
>  		hlist_nulls_del_init_rcu(&sk->sk_nulls_node);
> -		sock_put(sk);
>  		isk->inet_num = 0;
>  		isk->inet_sport = 0;
>  		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
> +		sock_put(sk);
>  	}
>  	spin_unlock(&ping_table.lock);
>  }

