Return-Path: <netdev+bounces-741-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 132196F97AB
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 10:26:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D90C71C21C1A
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 08:26:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A7A4210C;
	Sun,  7 May 2023 08:26:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537BE1C04;
	Sun,  7 May 2023 08:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D17C433D2;
	Sun,  7 May 2023 08:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683447960;
	bh=0wsNTu7LsavpGGGr5snRBur0Ud90g8FpS4A90LBgEuM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RKr1Zf4XyzyMeJd2gKHIvo6FS6atVocDBCtThCJWbUu1As9EauFIMf5CUus2ZCLqD
	 N0oMAuXTjuFahtAKoOmjLgT9K8kmJ76C5qzbVJ+h7Polni7etYSixcSV0/Np/LF5ZP
	 tForQxAUEESfNZvPyws+Aa32EaCNASMmXwyTIqcsxeeyVvqL3Wijqb9p26tF5q9Xjj
	 XxeJBMoOqgsEVCrNGUDbulXOTmdFe9GmBawcr2W3UJUT4ZYhF9KXlFpug16XzmQr6p
	 8dFmzwjhhESdF1JFma2D+Cl552FPh1y3eNRZSUV9iOXJY/A/ptY8vktMX2VD2CrR+u
	 oZAA+wgW/sXVQ==
Date: Sun, 7 May 2023 11:25:56 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Chuck Lever <cel@kernel.org>
Cc: kernel-tls-handshake@lists.linux.dev, netdev@vger.kernel.org,
	dan.carpenter@linaro.org
Subject: Re: [PATCH v2 2/6] net/handshake: Fix handshake_dup() ref counting
Message-ID: <20230507082556.GG525452@unreal>
References: <168333373851.7813.11884763481187785511.stgit@oracle-102.nfsv4bat.org>
 <168333395123.7813.7077088598355438510.stgit@oracle-102.nfsv4bat.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168333395123.7813.7077088598355438510.stgit@oracle-102.nfsv4bat.org>

On Fri, May 05, 2023 at 08:46:01PM -0400, Chuck Lever wrote:
> From: Chuck Lever <chuck.lever@oracle.com>
> 
> If get_unused_fd_flags() fails, we ended up calling fput(sock->file)
> twice.
> 
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handling handshake requests")
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ---
>  net/handshake/netlink.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
> index 7ec8a76c3c8a..032d96152e2f 100644
> --- a/net/handshake/netlink.c
> +++ b/net/handshake/netlink.c
> @@ -101,10 +101,8 @@ static int handshake_dup(struct socket *sock)
>  
>  	file = get_file(sock->file);
>  	newfd = get_unused_fd_flags(O_CLOEXEC);
> -	if (newfd < 0) {
> -		fput(file);
> +	if (newfd < 0)
>  		return newfd;

IMHO, the better way to fix it is to change handshake_nl_accept_doit()
do not call to fput(sock->file) in error case. It is not right thing
to have a call to handshake_dup() and rely on elevated get_file()
for failure too as it will be problematic for future extension of
handshake_dup().

Thanks

> -	}
>  
>  	fd_install(newfd, file);
>  	return newfd;
> 
> 
> 

