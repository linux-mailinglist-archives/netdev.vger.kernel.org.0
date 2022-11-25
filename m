Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB2C0639023
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 20:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiKYTC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 14:02:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiKYTC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 14:02:57 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83CCD2F009
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 11:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6T/Q4WFoXHQ6RmYERX27lAjeGjyEHdN7GJcOWISil5U=; b=AtG1+5QYrSlZKVqdCeh26qrfLr
        Le4UmmfSJjnxeYbpQFNThB++faM8fGUD7vOS/YqdS5kmBmkXpGQ0Cu1E+T4NG+/SLKuQqxjoQQII9
        fucRVWTVWayiLLIHYDVZnMDljl8qlFwx9AOWvGe2DE7q3GgBQ9l7DOWbcuHnL0C//t9s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oydyM-003SSg-9H; Fri, 25 Nov 2022 20:02:50 +0100
Date:   Fri, 25 Nov 2022 20:02:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     netdev@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        yc-core@yandex-team.ru, lvc-project@linuxtesting.org
Subject: Re: [PATCH v1 1/3] net/ethtool/ioctl: return -EOPNOTSUPP if we have
 no phy stats
Message-ID: <Y4ERWsV1vo1o7F2d@lunn.ch>
References: <20221125164913.360082-1-d-tatianin@yandex-team.ru>
 <20221125164913.360082-2-d-tatianin@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125164913.360082-2-d-tatianin@yandex-team.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 25, 2022 at 07:49:11PM +0300, Daniil Tatianin wrote:
> It's not very useful to copy back an empty ethtool_stats struct and
> return 0 if we didn't actually have any stats. This also allows for
> further simplification of this function in the future commits.
> 
> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
> ---
>  net/ethtool/ioctl.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> index 57e7238a4136..071e9bf16007 100644
> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
> @@ -2089,11 +2089,15 @@ static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
>  		n_stats = phy_ops->get_sset_count(phydev);
>  	else
>  		n_stats = ops->get_sset_count(dev, ETH_SS_PHY_STATS);
> +
>  	if (n_stats < 0)

Please don't make unneeded white space changes. It just distracts from
the real change being made here.

>  		return n_stats;
>  	if (n_stats > S32_MAX / sizeof(u64))
>  		return -ENOMEM;
> -	WARN_ON_ONCE(!n_stats);
> +	if (!n_stats) {
> +		WARN_ON_ONCE(1);
> +		return -EOPNOTSUPP;
> +	}

WARN_ON_ONCE() returns the result of the comparison being made. so you can do:

	if (WARN_ON_ONCE(!n_stats))
		return -EOPNOTSUPP;

	Andrew		

