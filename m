Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 411D63400B0
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 09:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhCRIOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 04:14:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229454AbhCRIOY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 04:14:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B151664F04;
        Thu, 18 Mar 2021 08:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616055264;
        bh=lIluJSl7BAktteo3lXWTWv4jITCh1L+JcnjAe33GBvQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VXVJYN7XGEb23i1vob61kUo8podqJ+4SGupEUnRJB6eZhyMjEb/JtTaR3LNlbZftJ
         CHU0v0wMYugkmM5ikIO2B9GvGPSd3mLiS+bA5BxQY8CWPhelil1wwZw0hBhtwgGxAF
         2ST6IJVZknpSiApaG62QZIWghoJ9ySg3R95h4xx816YT2AMluzzsU33KT/b8LuGdCC
         P85zdILFeRJJfNCgyIh18lVZhGcUJL/k6G/Lm4RI48VrnC4wW7wTbwOpgRBHkKqM/f
         7HLtzIwfndtkjYlz6Q+EDGvpymgQh9HJ3g+X8axx5usQh6gBraHYPuiS2Lw6grICwn
         dsAjw7J8lMrLg==
Date:   Thu, 18 Mar 2021 10:14:20 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     dhowells@redhat.com, davem@davemloft.net, kuba@kernel.org,
        linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rxrpc: rxkad: replace if (cond) BUG() with BUG_ON()
Message-ID: <YFML3Dqpyc4Gcg2U@unreal>
References: <1615952318-4861-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1615952318-4861-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 11:38:38AM +0800, Jiapeng Chong wrote:
> Fix the following coccicheck warnings:
>
> ./net/rxrpc/rxkad.c:1140:2-5: WARNING: Use BUG_ON instead of if
> condition followed by BUG.
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  net/rxrpc/rxkad.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
> index e2e9e9b..bfa3d9a 100644
> --- a/net/rxrpc/rxkad.c
> +++ b/net/rxrpc/rxkad.c
> @@ -1135,9 +1135,8 @@ static void rxkad_decrypt_response(struct rxrpc_connection *conn,
>  	       ntohl(session_key->n[0]), ntohl(session_key->n[1]));
>
>  	mutex_lock(&rxkad_ci_mutex);
> -	if (crypto_sync_skcipher_setkey(rxkad_ci, session_key->x,
> -					sizeof(*session_key)) < 0)
> -		BUG();
> +	BUG_ON(crypto_sync_skcipher_setkey(rxkad_ci, session_key->x,
> +					sizeof(*session_key)) < 0);

It will be better to delete this BUG_ON() or find a way to ensure
that it doesn't happen and delete after that.

Thanks

>
>  	memcpy(&iv, session_key, sizeof(iv));
>
> --
> 1.8.3.1
>
