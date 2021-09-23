Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2EB34161FA
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 17:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241972AbhIWP0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 11:26:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233143AbhIWP00 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 11:26:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7626960EE5;
        Thu, 23 Sep 2021 15:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632410694;
        bh=f+5asWyNTWseSfBfZnx/nBGPKc4I/06OBpr0rbMbwaU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jUfFyfM+uoB0k7AsO0dZfeYv85TOxpDWqpfBYh++KbegIwOPm8CJExRXrKO95vrRm
         Tq2dyxwlJsAR+76gAH2SUd/1gSuy1ka0KjEGmjsjMkKV5eVDC4R7k+CbJHHmvmfpzU
         N5k3kpZTGi80XV2mhjqMPBxP1eE21SsVj3K4hLflZq+RBeGdJZIBBUGbnBn8Bfw9L8
         Sem7xnCrVcYvTGVoiEeo6jfwyuBqmvOYSfitWzRdwj9+XLuALKePCA7ZoR3I6iMffS
         oXWGGHgrTlc/RmNZ25m4OHSixIFJFrUSFBRX0Sd4EtowOwnHJvOVIPogcL81OqmRfy
         lKDABhlJXiVfQ==
Date:   Thu, 23 Sep 2021 08:24:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: socket: integrate sockfd_lookup() and
 sockfd_lookup_light()
Message-ID: <20210923082453.42096cc7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210922063106.4272-1-yajun.deng@linux.dev>
References: <20210922063106.4272-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Sep 2021 14:31:06 +0800 Yajun Deng wrote:
> As commit 6cb153cab92a("[NET]: use fget_light() in net/socket.c") said,
> sockfd_lookup_light() is lower load than sockfd_lookup(). So we can
> remove sockfd_lookup() but keep the name. As the same time, move flags
> to sockfd_put().

You just assume that each caller of sockfd_lookup() already meets the
criteria under which sockfd_lookup_light() can be used? Am I reading
this right?

Please extend the commit message clearly walking us thru why this is
safe now (and perhaps why it wasn't in the past).

>  static ssize_t sockfs_listxattr(struct dentry *dentry, char *buffer,
>  				size_t size)
> @@ -1680,9 +1659,9 @@ int __sys_bind(int fd, struct sockaddr __user *umyaddr, int addrlen)
>  {
>  	struct socket *sock;
>  	struct sockaddr_storage address;
> -	int err, fput_needed;
> +	int err;
>  
> -	sock = sockfd_lookup_light(fd, &err, &fput_needed);
> +	sock = sockfd_lookup(fd, &err);
>  	if (sock) {
>  		err = move_addr_to_kernel(umyaddr, addrlen, &address);
>  		if (!err) {
> @@ -1694,7 +1673,7 @@ int __sys_bind(int fd, struct sockaddr __user *umyaddr, int addrlen)
>  						      (struct sockaddr *)
>  						      &address, addrlen);
>  		}
> -		fput_light(sock->file, fput_needed);
> +		sockfd_put(sock);

And we just replace fput_light() with fput() even tho the reference was
taken with fdget()? fdget() == __fget_light().

Maybe you missed fget() vs fdget()?

All these changes do not immediately strike me as correct.

>  	}
>  	return err;
>  }
