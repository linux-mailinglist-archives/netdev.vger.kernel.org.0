Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8FBA334213
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 16:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233232AbhCJPu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 10:50:58 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:49916 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233150AbhCJPuw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 10:50:52 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lK16j-00ACNx-B7; Wed, 10 Mar 2021 16:50:45 +0100
Date:   Wed, 10 Mar 2021 16:50:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        linux@armlinux.org.uk, mw@semihalf.com, rmk+kernel@armlinux.org.uk,
        atenart@kernel.org, rabeeh@solid-run.com
Subject: Re: [net-next] net: mvpp2: Add reserved port private flag
 configuration
Message-ID: <YEjq1eehhA+8MYwH@lunn.ch>
References: <1615369329-9389-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1615369329-9389-1-git-send-email-stefanc@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  static void mvpp2_ethtool_get_strings(struct net_device *netdev, u32 sset,
>  				      u8 *data)
>  {
>  	struct mvpp2_port *port = netdev_priv(netdev);
>  	int i, q;
>  
> -	if (sset != ETH_SS_STATS)
> -		return;
> +	switch (sset) {
> +	case ETH_SS_STATS:
> +		for (i = 0; i < ARRAY_SIZE(mvpp2_ethtool_mib_regs); i++) {
> +			strscpy(data, mvpp2_ethtool_mib_regs[i].string,
> +				ETH_GSTRING_LEN);
> +			data += ETH_GSTRING_LEN;
> +		}

Hi Stefan

Maybe rename the existing function to
mvpp2_ethtool_get_strings_stats() and turn it into a helper. Add a new
mvpp2_ethtool_get_strings_priv() helper. And a new
mvpp2_ethtool_get_strings() which just calls the two helpers. Overall
the patch should be smaller and much easier to review.

    Andrew
