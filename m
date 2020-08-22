Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1D124E4F7
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 05:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgHVDv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 23:51:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:52638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726734AbgHVDv4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 23:51:56 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B6E720720;
        Sat, 22 Aug 2020 03:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598068315;
        bh=3hIC6oRMGaUVHp80xG0vx5OQ9SD78ONNbz0W0ALeSwg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b7FxcmUVmfN2xqBPz340ulOe/XVSHR1MiU9xpeeaPdZHxS9vz4pUHKgNOmHzMsWdI
         329/g50Jv8wzcvUyrJ6y7b7lCfOXhfTqhhQ+F8qGxN56DpcoWHovn+DqN4azIYpKWe
         R849KB9bd5vjxDb+inkYQypN25eBC2PbnWxzixOw=
Date:   Fri, 21 Aug 2020 20:51:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Pascal Bouchareine <kalou@tfz.net>
Cc:     linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Alexey Dobriyan" <adobriyan@gmail.com>,
        "Al Viro" <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2 1/2] mm: add GFP mask param to strndup_user
Message-Id: <20200821205154.365e230dbf6f2b93a47443c4@linux-foundation.org>
In-Reply-To: <20200822032827.6386-1-kalou@tfz.net>
References: <20200815182344.7469-1-kalou@tfz.net>
        <20200822032827.6386-1-kalou@tfz.net>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Aug 2020 20:28:26 -0700 Pascal Bouchareine <kalou@tfz.net> wrote:

> Let caller specify allocation.
> Preserve existing calls with GFP_USER.
> 
>  21 files changed, 65 insertions(+), 43 deletions(-)

Why change all existing callsites so that one callsite can pass in a
different gfp_t?

> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 1ca609f66fdf..3d94ba811f4b 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -326,7 +326,7 @@ static __poll_t dma_buf_poll(struct file *file, poll_table *poll)
>   */
>  static long dma_buf_set_name(struct dma_buf *dmabuf, const char __user *buf)
>  {
> -	char *name = strndup_user(buf, DMA_BUF_NAME_LEN);
> +	char *name = strndup_user(buf, DMA_BUF_NAME_LEN, GFP_USER);
>  	long ret = 0;

Wouldn't

#include <linux/gfp.h>

char *__strndup_user(const char __user *s, long n, gfp_t gfp);

static inline char *strndup_user(const char __user *s, long n)
{
	return __strndup_user(s, n, GFP_USER);
}

be simpler?



Also...

why does strndup_user() use GFP_USER?  Nobody will be mapping the
resulting strings into user pagetables (will they?).  This was done by
Al's 6c2c97a24f096e32, which doesn't have a changelog :(


In [patch 2/2],

+	desc = strndup_user(user_desc, SK_MAX_DESC_SIZE, GFP_KERNEL_ACCOUNT);

if GFP_USER is legit then shouldn't this be GFP_USER_ACCOUNT (ie,
GFP_USER|__GFP_ACCOUNT)?

