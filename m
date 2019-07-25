Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3B8174F69
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 15:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730039AbfGYN2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 09:28:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37158 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727670AbfGYN2u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 09:28:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=d2TBFYSox5r5coVXRv7vGh7GJRiOOtP+rHZcaGSwKpA=; b=TyuzjwrNxQVkfZWtSvJXEdwnsh
        4gKBqjadfNJmsTbYa9IBNv+41fzprxeiQ4KldbsbvP5i3wkm8vHmZFDW3m3v6qwNMWNr5WVLvn+dE
        xSs79UPUBM3scEcF2XoHCrhetlLoJ8lKOMxPavOn2e/fUFsKrGcUeGxc4+4dmkniprlE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hqdnZ-00066I-JS; Thu, 25 Jul 2019 15:28:45 +0200
Date:   Thu, 25 Jul 2019 15:28:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v4 net-next 13/19] ionic: Add initial ethtool support
Message-ID: <20190725132845.GC21952@lunn.ch>
References: <20190722214023.9513-1-snelson@pensando.io>
 <20190722214023.9513-14-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190722214023.9513-14-snelson@pensando.io>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 22, 2019 at 02:40:17PM -0700, Shannon Nelson wrote:

> +static void ionic_get_pauseparam(struct net_device *netdev,
> +				 struct ethtool_pauseparam *pause)
> +{
> +	struct lif *lif = netdev_priv(netdev);
> +	struct ionic_dev *idev = &lif->ionic->idev;
> +	uint8_t pause_type = idev->port_info->config.pause_type;
> +
> +	pause->autoneg = 0;
> +
> +	if (pause_type) {
> +		pause->rx_pause = pause_type & IONIC_PAUSE_F_RX ? 1 : 0;
> +		pause->tx_pause = pause_type & IONIC_PAUSE_F_TX ? 1 : 0;
> +	}
> +}
> +
> +static int ionic_set_pauseparam(struct net_device *netdev,
> +				struct ethtool_pauseparam *pause)
> +{
> +	struct lif *lif = netdev_priv(netdev);
> +	struct ionic *ionic = lif->ionic;
> +	struct ionic_dev *idev = &lif->ionic->idev;
> +	u32 requested_pause;
> +	int err;
> +
> +	if (pause->autoneg == AUTONEG_ENABLE) {
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

Hi Shannon

This not what i was expecting, and i'm guessing what you have here is
not right.

So you don't support the case of pause->autoneg ==
AUTONEG_ENABLE. That implies that setting pause values directly
configures the MAC. The values from auto-neg are always ignored. Then
why did you set PAUSE in the get ksettings function?

If you always ignore the values from auto-neg, then your info message
also makes no sense.

What really does the firmware do?

     Andrew
