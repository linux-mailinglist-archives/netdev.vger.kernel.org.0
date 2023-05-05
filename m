Return-Path: <netdev+bounces-644-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B44C6F8CCB
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 01:28:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 721691C219D2
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 23:28:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75FDD101ED;
	Fri,  5 May 2023 23:28:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD92C8C5;
	Fri,  5 May 2023 23:28:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D51AC433D2;
	Fri,  5 May 2023 23:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683329331;
	bh=dyd0xHbZ9X8zYdkDTSfwS85xmCeKxlgE5JeN7Mg8yYE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B6SKYXM8jAeM98qRVRa/NhfxTm7jKFX3jEhMooNyYBcUsr4SloyJrTjv0fPgQuMXB
	 iyqQPxspVSX2ZJnobLW3n5V8sNx/BkLT/4/K0ie9h0uOtjqxgrl2kvdjCaNyjp+Wzb
	 W0IfmK1cJRMUdy3ZjFzySS55L5r2z02vbHhgWe15jJ4uP1IwnAJ6JD0IgwuHwB9B4D
	 xtJCAdyPyA0Ytffig9v2H8PMHJBMrBVJcf6kRUxUxKfb5MMp5FZZApvCdPvW/Av03J
	 wO6KB/ly0nBu5Ls10PyanGI84pMlvzrbg5ljLLMPeX7Twum4qMePPwJoKk7FjhfpGe
	 YLgSnsS1p7lCQ==
Date: Fri, 5 May 2023 19:28:49 -0400
From: Chuck Lever <cel@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: kernel-tls-handshake@lists.linux.dev, netdev@vger.kernel.org,
	dan.carpenter@linaro.org
Subject: Re: [PATCH 2/5] net/handshake: Fix handshake_dup() ref counting
Message-ID: <ZFWRMWQKYovhu4g5@manet.1015granger.net>
References: <168321371754.16695.4217960864733718685.stgit@oracle-102.nfsv4bat.org>
 <168321389545.16695.14828237648251844351.stgit@oracle-102.nfsv4bat.org>
 <20230505135808.6992113b@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230505135808.6992113b@kernel.org>

On Fri, May 05, 2023 at 01:58:08PM -0700, Jakub Kicinski wrote:
> On Thu, 04 May 2023 11:25:05 -0400 Chuck Lever wrote:
> > From: Chuck Lever <chuck.lever@oracle.com>
> > 
> > If get_unused_fd_flags() fails, we ended up calling fput(sock->file)
> > twice.
> > 
> > Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> > Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handling handshake requests")
> > Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> 
> > diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
> > index 7ec8a76c3c8a..3508bc3e661d 100644
> > --- a/net/handshake/netlink.c
> > +++ b/net/handshake/netlink.c
> > @@ -96,17 +96,13 @@ EXPORT_SYMBOL(handshake_genl_put);
> >   */
> >  static int handshake_dup(struct socket *sock)
> >  {
> > -	struct file *file;
> >  	int newfd;
> >  
> > -	file = get_file(sock->file);
> >  	newfd = get_unused_fd_flags(O_CLOEXEC);
> > -	if (newfd < 0) {
> > -		fput(file);
> > +	if (newfd < 0)
> >  		return newfd;
> > -	}
> >  
> > -	fd_install(newfd, file);
> > +	fd_install(newfd, sock->file);
> 
> I'm not vfs expert but doesn't this mean that we will now have the file
> installed in the fd table, under newfd, before we incremented the
> refcount?  Can't another thread close(newfd) and make sock->file
> get freed?

I suppose. I can rework it and send a refresh.


> >  	return newfd;
> >  }
> >  
> > @@ -143,11 +139,11 @@ int handshake_nl_accept_doit(struct sk_buff *skb, struct genl_info *info)
> >  		goto out_complete;
> >  
> >  	trace_handshake_cmd_accept(net, req, req->hr_sk, fd);
> > +	get_file(sock->file);	/* released by DONE */
> 
> What if DONE does not get called?

A correctly-coded kernel caller has a timeout that is supposed to
release the socket via handshake_req_cancel(). I see that it doesn't
put sock->file, though... perhaps it should use sockfd_put() instead
of sock_release().


> >  	return 0;
> >  
> >  out_complete:
> >  	handshake_complete(req, -EIO, NULL);
> 
> We don't want to release the fd here?

Not any more, since we don't do the get_file() until everything
else has succeeded. But the rework will likely restore the fput
here.


> > -	fput(sock->file);
> >  out_status:
> >  	trace_handshake_cmd_accept_err(net, req, NULL, err);
> >  	return err;
> -- 
> pw-bot: cr

