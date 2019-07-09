Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB2D62DF6
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 04:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbfGICO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 22:14:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33884 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbfGICO3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 22:14:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=AJVgNjw3TI9fH3EHaTH7i6fUBzgPllTi/zXw3dFIF8c=; b=yidFyMJfsevAX6s4HfqhhO8UYH
        ulrl2du8zkP+/b9niiC0YBilq5SzLRH+M8/dwb9rmGJAELif4JFs26db+UaZ+j8xnGIm0TpqGgXuN
        LHCGNnJahR8/SPF1GjhUOWejFayrqC++okYyBsVFMOtUIfECKiHu/d5nRwHCMxSTvCJY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hkfeE-0006SC-TR; Tue, 09 Jul 2019 04:14:26 +0200
Date:   Tue, 9 Jul 2019 04:14:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 13/19] ionic: Add initial ethtool support
Message-ID: <20190709021426.GA5835@lunn.ch>
References: <20190708192532.27420-1-snelson@pensando.io>
 <20190708192532.27420-14-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708192532.27420-14-snelson@pensando.io>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int ionic_set_pauseparam(struct net_device *netdev,
> +				struct ethtool_pauseparam *pause)
> +{
> +	struct lif *lif = netdev_priv(netdev);
> +	struct ionic *ionic = lif->ionic;
> +	struct ionic_dev *idev = &lif->ionic->idev;
> +
> +	u32 requested_pause;
> +	u32 cur_autoneg;
> +	int err;
> +
> +	cur_autoneg = idev->port_info->config.an_enable ? AUTONEG_ENABLE :
> +								AUTONEG_DISABLE;
> +	if (pause->autoneg != cur_autoneg) {
> +		netdev_info(netdev, "Please use 'ethtool -s ...' to change autoneg\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	/* change both at the same time */
> +	requested_pause = PORT_PAUSE_TYPE_LINK;
> +	if (pause->rx_pause)
> +		requested_pause |= IONIC_PAUSE_F_RX;
> +	if (pause->tx_pause)
> +		requested_pause |= IONIC_PAUSE_F_TX;
> +
> +	if (requested_pause == idev->port_info->config.pause_type)
> +		return 0;
> +
> +	idev->port_info->config.pause_type = requested_pause;
> +
> +	mutex_lock(&ionic->dev_cmd_lock);
> +	ionic_dev_cmd_port_pause(idev, requested_pause);
> +	err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
> +	mutex_unlock(&ionic->dev_cmd_lock);
> +	if (err)
> +		return err;

Hi Shannon

I've no idea what the firmware black box is doing, but this looks
wrong.

pause->autoneg is about if the results of auto-neg should be used or
not. If false, just configure the MAC with the pause settings and you
are done. If the interface is being forced, so autoneg in general is
disabled, just configure the MAC and you are done.

If pause->autoneg is true and the interface is using auto-neg as a
whole, you pass the pause values to the PHY for it to advertise and
trigger an auto-neg. Once autoneg has completed, and the resolved
settings are available, the MAC is configured with the resolved
values.

Looking at this code, i don't see any difference between configuring
the MAC or configuring the PHY. I would expect pause->autoneg to be
part of requested_pause somehow, so the firmware knows what is should
do.

	Andrew
