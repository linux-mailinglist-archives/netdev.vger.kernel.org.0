Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B38030FC02
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 19:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239511AbhBDSxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 13:53:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:49158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239320AbhBDSwq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 13:52:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3ADA64DE1;
        Thu,  4 Feb 2021 18:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612464726;
        bh=qnAiIbx34W0pnAsKo8HBm1otWZZrK8SH9ZuNPeFejTU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P4iz5A5AzSfOq/4EsW9x2h9Pot8QiWhHHmleg3reZCyuEk6hcsRFtk5GDs4oZIh2z
         VmCyQgMIsRt7g3R3mPC1WuXPFTOJiqQlD96JJ7boNHqaJRwMsZk5f1I67MXWytC7lp
         iDXtjsmOeS9x/1ChfYE3pIeOlDN1FUAVLIpAjMw/mO3HhoSNrLzdT69u1L2Ezo2GJ1
         1BinHcyJOOpOfO4ek/MApl5fFfOpqIaan75S1G1s68qHkXQBjGGrvRiG6JaZt9x/ab
         yt5BK0iYLSOwHK1mSpZZrgOVLi7/dm+tajj0qizW1i9wdBz3y0p/gkTggWLPAWUgUv
         j/fYfwxFfr4mQ==
Date:   Thu, 4 Feb 2021 10:51:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+c2a7e5c5211605a90865@syzkaller.appspotmail.com
Subject: Re: [PATCH] net/qrtr: replaced useless kzalloc with kmalloc in
 qrtr_tun_write_iter()
Message-ID: <20210204105159.2ae254b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210204090230.1794169-1-snovitoll@gmail.com>
References: <20210203162846.56a90288@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210204090230.1794169-1-snovitoll@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  4 Feb 2021 15:02:30 +0600 Sabyrzhan Tasbolatov wrote:
> Replaced kzalloc() with kmalloc(), there is no need for zeroed-out
> memory for simple void *kbuf.

There is no need for zeroed-out memory because it's immediately
overwritten by copy_from_iter...

> >For potential, separate clean up - this is followed 
> >by copy_from_iter_full(len) kzalloc() can probably 
> >be replaced by kmalloc()?
> >  
> >>  	if (!kbuf)
> >>  		return -ENOMEM;  
> 
> Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
> ---
>  net/qrtr/tun.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/qrtr/tun.c b/net/qrtr/tun.c
> index b238c40a9984..9b607c7614de 100644
> --- a/net/qrtr/tun.c
> +++ b/net/qrtr/tun.c
> @@ -86,7 +86,7 @@ static ssize_t qrtr_tun_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  	if (len > KMALLOC_MAX_SIZE)
>  		return -ENOMEM;
>  
> -	kbuf = kzalloc(len, GFP_KERNEL);
> +	kbuf = kmalloc(len, GFP_KERNEL);
>  	if (!kbuf)
>  		return -ENOMEM;
>  

