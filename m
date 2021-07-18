Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF22C3CC870
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 12:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbhGRKpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 06:45:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:58810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230461AbhGRKpz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Jul 2021 06:45:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CCB96113D;
        Sun, 18 Jul 2021 10:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626604977;
        bh=XHYiGCB7BFoBQaLsMUEaVYK3yF6fmDUK9zms1YeaP1E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b4KB43F8+DVXSCb+y+cuxXnAE/ZvLCHi7u05iaNnXxO2O8segAdTOmjjGDO7H+Qxg
         dWd4OuJ4/SYKV8jQuBJJQGaocUE+2a4vHx81YhapryQBNZTzBOWeOcF0dKVOLvT2nq
         kyPk8xLbhA51hVsulPyzGjBE+btl8gZH0UsHYbPt5EWNKxVbYUsb0tdB6ijeqOykaJ
         tcucoIAYt1BpeICUV1ZeKOWcuHlkeuHOpAxkgUAJypQ6rC2dzsnu9ZxVey6zQUh/9Y
         wN0dczatn6FdoD53LkHFDlFVgvaN6HhoI8nx5VeGWapG+T0thB5NHE+xvbImGyyhrh
         yigZyZRtxdN6g==
Date:   Sun, 18 Jul 2021 13:42:53 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc:     Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yuanxzhang@fudan.edu.cn,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: Re: [PATCH] cxgb3: Convert from atomic_t to refcount_t on
 l2t_entry->refcnt
Message-ID: <YPQFrf7/VYhW47mF@unreal>
References: <1626516975-42566-1-git-send-email-xiyuyang19@fudan.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1626516975-42566-1-git-send-email-xiyuyang19@fudan.edu.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 17, 2021 at 06:16:15PM +0800, Xiyu Yang wrote:
> refcount_t type and corresponding API can protect refcounters from
> accidental underflow and overflow and further use-after-free situations.
> 
> Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
> ---
>  drivers/net/ethernet/chelsio/cxgb3/l2t.c | 15 ++++++++-------
>  drivers/net/ethernet/chelsio/cxgb3/l2t.h | 10 +++++++---
>  2 files changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/chelsio/cxgb3/l2t.c b/drivers/net/ethernet/chelsio/cxgb3/l2t.c
> index 9749d1239f58..0f2a47bc20d8 100644
> --- a/drivers/net/ethernet/chelsio/cxgb3/l2t.c
> +++ b/drivers/net/ethernet/chelsio/cxgb3/l2t.c
> @@ -225,10 +225,11 @@ static struct l2t_entry *alloc_l2e(struct l2t_data *d)
>  
>  	/* there's definitely a free entry */
>  	for (e = d->rover, end = &d->l2tab[d->nentries]; e != end; ++e)
> -		if (atomic_read(&e->refcnt) == 0)
> +		if (refcount_read(&e->refcnt) == 0)

All those atomic_t to refcount_t patches can't be right, refcount_t can't be 0.

Thanks
