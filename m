Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B23983CC872
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 12:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbhGRKrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 06:47:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:59022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231836AbhGRKrc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Jul 2021 06:47:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77A7D6113D;
        Sun, 18 Jul 2021 10:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626605074;
        bh=iB4eNeNXHNll8Y3BVbUqYop9nEpXbiTMg0YmXxECg8o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QPJPApJVh1YrLpjr4XfwBQHxiIjeHYti7s6G1qX3zXx5CPGJ7ZhjwhQT43lqXsLMx
         tI/rpCsL8+Zdf7/Okm734xvP/BEQCtjkr6LCezCdby16jfKCZkr9MTD3V4BwupYmXn
         umYehu+63v2hvLGtWN6yOOGmwqSX8X12btY803O3ZEFYQTNuiYLx/+B3OsFIlqehux
         HmfStzkMhiJzbAwXbD/Sr43ewNhB/x7Q65iUlwrGt3+l3bNH30WW7G/h6mbvYLouyt
         KZuIMvP1vN/S8R/ZuROGxggFr5Wnd+EqTOuptmPRFro1BZewusxnBNv4ka5v5wgsPm
         B4AQn/Fi9DXGg==
Date:   Sun, 18 Jul 2021 13:44:30 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc:     Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yuanxzhang@fudan.edu.cn,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: Re: [PATCH] cxgb4: Convert from atomic_t to refcount_t on
 l2t_entry->refcnt
Message-ID: <YPQGDqQZS2WinPQH@unreal>
References: <1626517014-42631-1-git-send-email-xiyuyang19@fudan.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1626517014-42631-1-git-send-email-xiyuyang19@fudan.edu.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 17, 2021 at 06:16:54PM +0800, Xiyu Yang wrote:
> refcount_t type and corresponding API can protect refcounters from
> accidental underflow and overflow and further use-after-free situations.
> 
> Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
> ---
>  drivers/net/ethernet/chelsio/cxgb4/l2t.c | 31 ++++++++++++++++---------------
>  drivers/net/ethernet/chelsio/cxgb4/l2t.h |  3 ++-
>  2 files changed, 18 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/l2t.c b/drivers/net/ethernet/chelsio/cxgb4/l2t.c
> index a10a6862a9a4..cb26a5e315b1 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/l2t.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/l2t.c
> @@ -69,7 +69,8 @@ static inline unsigned int vlan_prio(const struct l2t_entry *e)
>  
>  static inline void l2t_hold(struct l2t_data *d, struct l2t_entry *e)
>  {
> -	if (atomic_add_return(1, &e->refcnt) == 1)  /* 0 -> 1 transition */
> +	refcount_inc(&e->refcnt);
> +	if (refcount_read(&e->refcnt) == 1)  /* 0 -> 1 transition */
>  		atomic_dec(&d->nfree);
>  }
>  
> @@ -270,10 +271,10 @@ static struct l2t_entry *alloc_l2e(struct l2t_data *d)
>  
>  	/* there's definitely a free entry */
>  	for (e = d->rover, end = &d->l2tab[d->l2t_size]; e != end; ++e)
> -		if (atomic_read(&e->refcnt) == 0)
> +		if (refcount_read(&e->refcnt) == 0)

This is wrong.

Thanks
