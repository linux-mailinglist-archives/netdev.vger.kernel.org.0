Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 007D53FBB1A
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 19:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238243AbhH3RhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 13:37:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238117AbhH3RhD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 13:37:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43AA760F3A;
        Mon, 30 Aug 2021 17:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630344969;
        bh=mBCLjTq+slwrTN0PgRGiG1Cp1vN3TjIt/HY5SniWLqQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hy9jp3yXzE1HgymdQKBR/PeDFaOgNrUzsLvzBVUFBRls/iFFxm3UdobZzNaGwIUp0
         vajsKv1I/8925Q/dPpfxQFXnJ/JgUFigEjw+ue4fdEwSrjq8Mw5OAUGq22ODoYE1MK
         k3igzx6eYB46j+K3vbaUvs49Z8oSSWu8SdNQLoO0KtQw09cQblCGd2bK61sf+UrK5+
         Tn2Iy9pk83qPZB9DGCturzWGZSKk2Fkd0yVCNw6RBbPb2THjVpH3uEmN+ckFO8Hx3d
         aahrWmRDgeWW0Wj8KbwMyaEn3fmTWnNeIMQF8rMZ7VyceT7/OuWky9zojOjkbB3SAA
         ckVewkbRHjLmA==
Date:   Mon, 30 Aug 2021 10:36:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     CGEL <cgel.zte@gmail.com>
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Changcheng Deng <deng.changcheng@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] net: bonding: bond_alb: Replace if (cond)
 BUG() with BUG_ON()
Message-ID: <20210830103608.5e0394f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210828010230.11022-1-deng.changcheng@zte.com.cn>
References: <20210828010230.11022-1-deng.changcheng@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Aug 2021 18:02:30 -0700 CGEL wrote:
> From: Changcheng Deng <deng.changcheng@zte.com.cn>
> 
> Fix the following coccinelle reports:
> 
> ./drivers/net/bonding/bond_alb.c:976:3-6 WARNING: Use BUG_ON instead of
> if condition followed by BUG.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
> ---
>  drivers/net/bonding/bond_alb.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
> index 7d3752c..3288022 100644
> --- a/drivers/net/bonding/bond_alb.c
> +++ b/drivers/net/bonding/bond_alb.c
> @@ -972,8 +972,7 @@ static int alb_upper_dev_walk(struct net_device *upper,
>  	 */
>  	if (netif_is_macvlan(upper) && !strict_match) {
>  		tags = bond_verify_device_path(bond->dev, upper, 0);
> -		if (IS_ERR_OR_NULL(tags))
> -			BUG();
> +		BUG_ON(IS_ERR_OR_NULL(tags));
>  		alb_send_lp_vid(slave, upper->dev_addr,
>  				tags[0].vlan_proto, tags[0].vlan_id);
>  		kfree(tags);

The fact this code using is BUG() in the first place is more problematic
than not using BUG_ON(). Can it be converted to WARN_ON() + return?
Looks like alb_upper_dev_walk() returns int.
