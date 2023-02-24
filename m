Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1196A1BD8
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 13:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbjBXMGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 07:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjBXMGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 07:06:33 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B452E66945;
        Fri, 24 Feb 2023 04:06:25 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pVWpy-0005Tw-Nt; Fri, 24 Feb 2023 13:06:06 +0100
Date:   Fri, 24 Feb 2023 13:06:06 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     borisp@nvidia.com, john.fastabend@gmail.com, kuba@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        davejwatson@fb.com, aviadye@mellanox.com, ilyal@mellanox.com,
        sd@queasysnail.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tls: fix possible race condition between
 do_tls_getsockopt_conf() and do_tls_setsockopt_conf()
Message-ID: <20230224120606.GI26596@breakpoint.cc>
References: <20230224105811.27467-1-hbh25y@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224105811.27467-1-hbh25y@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangyu Hua <hbh25y@gmail.com> wrote:
> ctx->crypto_send.info is not protected by lock_sock in
> do_tls_getsockopt_conf(). A race condition between do_tls_getsockopt_conf()
> and do_tls_setsockopt_conf() can cause a NULL point dereference or
> use-after-free read when memcpy.

Its good practice to quote the relevant parts of the splat here.

> Fixes: 3c4d7559159b ("tls: kernel TLS support")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
>  net/tls/tls_main.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> index 3735cb00905d..4956f5149b8e 100644
> --- a/net/tls/tls_main.c
> +++ b/net/tls/tls_main.c
> @@ -374,6 +374,7 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
>  	}
>  
>  	/* get user crypto info */
> +	lock_sock(sk);
>  	if (tx) {
>  		crypto_info = &ctx->crypto_send.info;
>  		cctx = &ctx->tx;
> @@ -381,6 +382,7 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
>  		crypto_info = &ctx->crypto_recv.info;
>  		cctx = &ctx->rx;
>  	}
> +	release_sock(sk);

Could you elaborate how this fixes a UAF bug?

AFAIU do_tls_setsockopt_conf uses ctx-> as scratch space, but this means
that getsockopt can see partial states.

If so, can the setsockopt part be changed so that reads only see
consistent states?
