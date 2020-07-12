Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D72A21CB97
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 23:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729460AbgGLVge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 17:36:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729020AbgGLVgd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jul 2020 17:36:33 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 229BA20674;
        Sun, 12 Jul 2020 21:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594589793;
        bh=LaukERu2pv75LoRhGqzTdKknNVP0Uslzw4bshPJDjGU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kyM2cyiEITBrG5oIVpYyR4sxM6ZHAlQtrGYEedEQtuZUVF8OxssMF9d/SiWt2H7Bx
         W7xyNnYvIxxfOVRxpUNs1t5hO9OZcEQorI5Qbom3a1RV3HcJwby6lDBJU2Fa+riMch
         TW88A8oZWfecMj0VbvXNhDGfRK9kXwhaKsRQsXSc=
Date:   Sun, 12 Jul 2020 14:36:31 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH net] qrtr: Fix ZERO_SIZE_PTR deref
 in qrtr_tun_write_iter()
Message-ID: <20200712213631.GA809@sol.localdomain>
References: <20200712210300.200399-1-yepeilin.cs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200712210300.200399-1-yepeilin.cs@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 12, 2020 at 05:03:00PM -0400, Peilin Ye wrote:
> qrtr_tun_write_iter() is dereferencing `ZERO_SIZE_PTR`s when `from->count`
> equals to zero. Fix it by rejecting zero-length kzalloc() requests.
> 
> This patch fixes the following syzbot bug:
> 
>     https://syzkaller.appspot.com/bug?id=f56bbe6668873ee245986bbd23312b895fa5a50a
> 
> Reported-by: syzbot+03e343dbccf82a5242a2@syzkaller.appspotmail.com
> Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> ---
>  net/qrtr/tun.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/qrtr/tun.c b/net/qrtr/tun.c
> index 15ce9b642b25..5465e94ba8e5 100644
> --- a/net/qrtr/tun.c
> +++ b/net/qrtr/tun.c
> @@ -80,6 +80,9 @@ static ssize_t qrtr_tun_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  	ssize_t ret;
>  	void *kbuf;
>  
> +	if (!len)
> +		return -EINVAL;
> +
>  	kbuf = kzalloc(len, GFP_KERNEL);
>  	if (!kbuf)
>  		return -ENOMEM;

Wasn't this already fixed by:

    commit 8ff41cc21714704ef0158a546c3c4d07fae2c952
    Author: Dan Carpenter <dan.carpenter@oracle.com>
    Date:   Tue Jun 30 14:46:15 2020 +0300

        net: qrtr: Fix an out of bounds read qrtr_endpoint_post()
