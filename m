Return-Path: <netdev+bounces-632-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CD8A6F8A79
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 22:58:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 359452810F6
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 20:58:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B767D2FB;
	Fri,  5 May 2023 20:58:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5030E2F33;
	Fri,  5 May 2023 20:58:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A1DC433D2;
	Fri,  5 May 2023 20:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683320289;
	bh=bIcl3jMwwIwDnX5GHYrzaNcHs2ilD1TkEoemVZMj9CQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AFIKpcpgvdWAjm55IdBzYmlnrjMGxAYJuE8nBqxiXqydS0HO93oZf6KgLYe57U4fL
	 1tgMyo4t0eEvwJdxfojQEZjAL5arnP+1e7KlhquLjjR36zlPoBP4HwwqOkboswGKOG
	 JH/QUZ/zGeogfJsoXd8yl4GI8DalXeRDRn9k7d0aqPS7Q5SHf5rKrYsgyQ1sJUVUZc
	 aSq+zfsTThsO0xPVEyYe+F6Coa7KYhlrqZc1L59hlUteo+scPisVCvNtRhd+tnXAgT
	 5EfUTAoAynXEZLTkcPh0gKUxnk8aJCSCYeY/7XniOfbxTALCMq8w3jOku5IZSiSA/I
	 U+KngOtYcPiAw==
Date: Fri, 5 May 2023 13:58:08 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Chuck Lever <cel@kernel.org>
Cc: kernel-tls-handshake@lists.linux.dev, netdev@vger.kernel.org,
 dan.carpenter@linaro.org
Subject: Re: [PATCH 2/5] net/handshake: Fix handshake_dup() ref counting
Message-ID: <20230505135808.6992113b@kernel.org>
In-Reply-To: <168321389545.16695.14828237648251844351.stgit@oracle-102.nfsv4bat.org>
References: <168321371754.16695.4217960864733718685.stgit@oracle-102.nfsv4bat.org>
	<168321389545.16695.14828237648251844351.stgit@oracle-102.nfsv4bat.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 04 May 2023 11:25:05 -0400 Chuck Lever wrote:
> From: Chuck Lever <chuck.lever@oracle.com>
> 
> If get_unused_fd_flags() fails, we ended up calling fput(sock->file)
> twice.
> 
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handling handshake requests")
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>

> diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
> index 7ec8a76c3c8a..3508bc3e661d 100644
> --- a/net/handshake/netlink.c
> +++ b/net/handshake/netlink.c
> @@ -96,17 +96,13 @@ EXPORT_SYMBOL(handshake_genl_put);
>   */
>  static int handshake_dup(struct socket *sock)
>  {
> -	struct file *file;
>  	int newfd;
>  
> -	file = get_file(sock->file);
>  	newfd = get_unused_fd_flags(O_CLOEXEC);
> -	if (newfd < 0) {
> -		fput(file);
> +	if (newfd < 0)
>  		return newfd;
> -	}
>  
> -	fd_install(newfd, file);
> +	fd_install(newfd, sock->file);

I'm not vfs expert but doesn't this mean that we will now have the file
installed in the fd table, under newfd, before we incremented the
refcount?  Can't another thread close(newfd) and make sock->file
get freed?

>  	return newfd;
>  }
>  
> @@ -143,11 +139,11 @@ int handshake_nl_accept_doit(struct sk_buff *skb, struct genl_info *info)
>  		goto out_complete;
>  
>  	trace_handshake_cmd_accept(net, req, req->hr_sk, fd);
> +	get_file(sock->file);	/* released by DONE */

What if DONE does not get called?

>  	return 0;
>  
>  out_complete:
>  	handshake_complete(req, -EIO, NULL);

We don't want to release the fd here?

> -	fput(sock->file);
>  out_status:
>  	trace_handshake_cmd_accept_err(net, req, NULL, err);
>  	return err;
-- 
pw-bot: cr

