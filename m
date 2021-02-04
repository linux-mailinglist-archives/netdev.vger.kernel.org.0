Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6829230E87E
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 01:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233905AbhBDA3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 19:29:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:35158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233702AbhBDA32 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 19:29:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 280FA64DAF;
        Thu,  4 Feb 2021 00:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612398527;
        bh=zD2l0UjA1q+ASc/JvfPwKEcmrFFE1IsTq9HetqkNVTY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qvbtyNIB+U347rqUQYvn8lAveJpjU/PwnZj0Y4EoNnmHDNe717tfhtI5sAv3RgTpw
         iTK2hGxvC+LoVV68YKWeTvKHtSUv56EowEH9YWjrm6biIsx+ZrRal9oI6DYDyy50Tl
         /pe+BHe4pD3GGxNB4j+1v5/YNjPQ9p+UlXLUxgf7zE8njI5FD85IQtq4IpG+ShDqIH
         sNTcszrh3cEDDC+DmKv14rVTl6SvyUFkhIEar+kF5EHNxWbV3eDZsX5erTTbMY3/d5
         5fkGRuANjZlE0mlw48FXcsvwa69n79xMTatsi29dznaEJqPDQXXNB599aR8FnlU+rD
         iuEIw050TksZQ==
Date:   Wed, 3 Feb 2021 16:28:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+c2a7e5c5211605a90865@syzkaller.appspotmail.com
Subject: Re: [PATCH] net/qrtr: restrict user-controlled length in
 qrtr_tun_write_iter()
Message-ID: <20210203162846.56a90288@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210202092059.1361381-1-snovitoll@gmail.com>
References: <20210202092059.1361381-1-snovitoll@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  2 Feb 2021 15:20:59 +0600 Sabyrzhan Tasbolatov wrote:
> syzbot found WARNING in qrtr_tun_write_iter [1] when write_iter length
> exceeds KMALLOC_MAX_SIZE causing order >= MAX_ORDER condition.
> 
> Additionally, there is no check for 0 length write.
> 
> [1]
> WARNING: mm/page_alloc.c:5011
> [..]
> Call Trace:
>  alloc_pages_current+0x18c/0x2a0 mm/mempolicy.c:2267
>  alloc_pages include/linux/gfp.h:547 [inline]
>  kmalloc_order+0x2e/0xb0 mm/slab_common.c:837
>  kmalloc_order_trace+0x14/0x120 mm/slab_common.c:853
>  kmalloc include/linux/slab.h:557 [inline]
>  kzalloc include/linux/slab.h:682 [inline]
>  qrtr_tun_write_iter+0x8a/0x180 net/qrtr/tun.c:83
>  call_write_iter include/linux/fs.h:1901 [inline]
> 
> Reported-by: syzbot+c2a7e5c5211605a90865@syzkaller.appspotmail.com
> Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
> ---
>  net/qrtr/tun.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/qrtr/tun.c b/net/qrtr/tun.c
> index 15ce9b642b25..b238c40a9984 100644
> --- a/net/qrtr/tun.c
> +++ b/net/qrtr/tun.c
> @@ -80,6 +80,12 @@ static ssize_t qrtr_tun_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  	ssize_t ret;
>  	void *kbuf;
>  
> +	if (!len)
> +		return -EINVAL;
> +
> +	if (len > KMALLOC_MAX_SIZE)
> +		return -ENOMEM;
> +
>  	kbuf = kzalloc(len, GFP_KERNEL);

For potential, separate clean up - this is followed 
by copy_from_iter_full(len) kzalloc() can probably 
be replaced by kmalloc()?

>  	if (!kbuf)
>  		return -ENOMEM;
