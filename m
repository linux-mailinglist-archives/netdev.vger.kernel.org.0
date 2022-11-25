Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B782B639032
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 20:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiKYTL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 14:11:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiKYTL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 14:11:27 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43BA554E9
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 11:11:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=h2IMaFgpNSdsJ1rGIHvoKNZ57R9UKUVXMn68UyQWECk=; b=pSwqi9UB4DKveqdSjw+RX+sAQA
        vLajWR3yjzFXVYO6dpMw3Crn4TScz7cfwZoV0RgTnnvczKh5sUmj1ToCEsKTJQh3WTuD0Ozzv2cJa
        Kp4Nas5U81RnQsjkc7NcmO0dNygOganSwndYCZdSr3r2ahkfGBVl9PA0XzCT+Vc602XI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oye6f-003SUS-5W; Fri, 25 Nov 2022 20:11:25 +0100
Date:   Fri, 25 Nov 2022 20:11:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     netdev@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        yc-core@yandex-team.ru, lvc-project@linuxtesting.org
Subject: Re: [PATCH v1 3/3] net/ethtool/ioctl: correct & simplify
 ethtool_get_phy_stats if checks
Message-ID: <Y4ETXbZn3wSnZbfh@lunn.ch>
References: <20221125164913.360082-1-d-tatianin@yandex-team.ru>
 <20221125164913.360082-4-d-tatianin@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125164913.360082-4-d-tatianin@yandex-team.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 25, 2022 at 07:49:13PM +0300, Daniil Tatianin wrote:
> ops->get_ethtool_phy_stats was getting called in an else branch
> of ethtool_get_phy_stats() unconditionally without making sure
> it was actually present.
> 
> Refactor the if checks so that it's more obvious what's going on and
> avoid accidental NULL derefs.
> 
> Found by Linux Verification Center (linuxtesting.org) with the SVACE
> static analysis tool.
> 
> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
> ---
>  net/ethtool/ioctl.c | 23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> index f83118c68e20..2b01e0042e6e 100644
> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
> @@ -2076,25 +2076,27 @@ static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
>  {
>  	const struct ethtool_phy_ops *phy_ops = ethtool_phy_ops;
>  	const struct ethtool_ops *ops = dev->ethtool_ops;
> +	bool has_phy_stats_ops = ops->get_ethtool_phy_stats != NULL;
>  	struct phy_device *phydev = dev->phydev;
>  	struct ethtool_stats stats;
>  	u64 *data;
>  	int ret, n_stats;
>  
> -	if (!phydev && (!ops->get_ethtool_phy_stats || !ops->get_sset_count))
> -		return -EOPNOTSUPP;
> +	if (!phydev || !phy_ops) {
> +		if (!ops->get_sset_count)
> +			return -EOPNOTSUPP;
>  
> -	if (phydev && !ops->get_ethtool_phy_stats &&
> -	    phy_ops && phy_ops->get_sset_count)
> -		n_stats = phy_ops->get_sset_count(phydev);
> -	else
>  		n_stats = ops->get_sset_count(dev, ETH_SS_PHY_STATS);
> +	} else {
> +		n_stats = phy_ops->get_sset_count(phydev);
> +		has_phy_stats_ops |= phy_ops->get_stats != NULL;

I'm not sure this is actually any clearer. You are mixing together
ethtool ops and phy ops.

This is part of why i suggested splitting phydev and !phydev into
helpers. The tests become a lot simpler. Please try it and see what
the resulting code looks like.

    Andrew
