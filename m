Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 658A54DF22
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 04:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfFUCcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 22:32:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:35360 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725911AbfFUCcI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 22:32:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 37826AD5E;
        Fri, 21 Jun 2019 02:32:06 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id BA20DE2473; Fri, 21 Jun 2019 04:32:05 +0200 (CEST)
Date:   Fri, 21 Jun 2019 04:32:05 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: Re: [PATCH net-next 13/18] ionic: Add initial ethtool support
Message-ID: <20190621023205.GD21796@unicorn.suse.cz>
References: <20190620202424.23215-1-snelson@pensando.io>
 <20190620202424.23215-14-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620202424.23215-14-snelson@pensando.io>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 20, 2019 at 01:24:19PM -0700, Shannon Nelson wrote:
> Add in the basic ethtool callbacks for device information
> and control.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
...
> +static int ionic_get_link_ksettings(struct net_device *netdev,
> +				    struct ethtool_link_ksettings *ks)
> +{
> +	struct lif *lif = netdev_priv(netdev);
> +	struct ionic_dev *idev = &lif->ionic->idev;
> +	int copper_seen = 0;
> +
> +	ethtool_link_ksettings_zero_link_mode(ks, supported);
> +	ethtool_link_ksettings_zero_link_mode(ks, advertising);
> +
> +	if (ionic_is_mnic(lif->ionic)) {
> +		ethtool_link_ksettings_add_link_mode(ks, supported, Backplane);
> +		ethtool_link_ksettings_add_link_mode(ks, advertising, Backplane);
> +	} else {
> +		ethtool_link_ksettings_add_link_mode(ks, supported, FIBRE);
> +		ethtool_link_ksettings_add_link_mode(ks, advertising, FIBRE);
> +
> +		if (ionic_is_pf(lif->ionic)) {
> +			ethtool_link_ksettings_add_link_mode(ks, supported,
> +							     Autoneg);
> +			ethtool_link_ksettings_add_link_mode(ks, advertising,
> +							     Autoneg);
> +		}
> +	}
> +
> +	switch (le16_to_cpu(idev->port_info->status.xcvr.pid)) {
> +		/* Copper */
> +	case XCVR_PID_QSFP_100G_CR4:
> +		ethtool_link_ksettings_add_link_mode(ks, supported,
> +						     100000baseCR4_Full);
> +		ethtool_link_ksettings_add_link_mode(ks, advertising,
> +						     100000baseCR4_Full);
> +		copper_seen++;
> +		break;
> +	case XCVR_PID_QSFP_40GBASE_CR4:
> +		ethtool_link_ksettings_add_link_mode(ks, supported,
> +						     40000baseCR4_Full);
> +		ethtool_link_ksettings_add_link_mode(ks, advertising,
> +						     40000baseCR4_Full);
> +		copper_seen++;
> +		break;
> +	case XCVR_PID_SFP_25GBASE_CR_S:
> +	case XCVR_PID_SFP_25GBASE_CR_L:
> +	case XCVR_PID_SFP_25GBASE_CR_N:
> +		ethtool_link_ksettings_add_link_mode(ks, supported,
> +						     25000baseCR_Full);
> +		ethtool_link_ksettings_add_link_mode(ks, advertising,
> +						     25000baseCR_Full);
> +		copper_seen++;
> +		break;
> +	case XCVR_PID_SFP_10GBASE_AOC:
> +	case XCVR_PID_SFP_10GBASE_CU:
> +		ethtool_link_ksettings_add_link_mode(ks, supported,
> +						     10000baseCR_Full);
> +		ethtool_link_ksettings_add_link_mode(ks, advertising,
> +						     10000baseCR_Full);
> +		copper_seen++;
> +		break;
> +
> +		/* Fibre */
> +	case XCVR_PID_QSFP_100G_SR4:
> +	case XCVR_PID_QSFP_100G_AOC:
> +		ethtool_link_ksettings_add_link_mode(ks, supported,
> +						     100000baseSR4_Full);
> +		ethtool_link_ksettings_add_link_mode(ks, advertising,
> +						     100000baseSR4_Full);
> +		break;
> +	case XCVR_PID_QSFP_100G_LR4:
> +		ethtool_link_ksettings_add_link_mode(ks, supported,
> +						     100000baseLR4_ER4_Full);
> +		ethtool_link_ksettings_add_link_mode(ks, advertising,
> +						     100000baseLR4_ER4_Full);
> +		break;
> +	case XCVR_PID_QSFP_100G_ER4:
> +		ethtool_link_ksettings_add_link_mode(ks, supported,
> +						     100000baseLR4_ER4_Full);
> +		ethtool_link_ksettings_add_link_mode(ks, advertising,
> +						     100000baseLR4_ER4_Full);
> +		break;
> +	case XCVR_PID_QSFP_40GBASE_SR4:
> +	case XCVR_PID_QSFP_40GBASE_AOC:
> +		ethtool_link_ksettings_add_link_mode(ks, supported,
> +						     40000baseSR4_Full);
> +		ethtool_link_ksettings_add_link_mode(ks, advertising,
> +						     40000baseSR4_Full);
> +		break;
> +	case XCVR_PID_QSFP_40GBASE_LR4:
> +		ethtool_link_ksettings_add_link_mode(ks, supported,
> +						     40000baseLR4_Full);
> +		ethtool_link_ksettings_add_link_mode(ks, advertising,
> +						     40000baseLR4_Full);
> +		break;
> +	case XCVR_PID_SFP_25GBASE_SR:
> +	case XCVR_PID_SFP_25GBASE_AOC:
> +		ethtool_link_ksettings_add_link_mode(ks, supported,
> +						     25000baseSR_Full);
> +		ethtool_link_ksettings_add_link_mode(ks, advertising,
> +						     25000baseSR_Full);
> +		break;
> +	case XCVR_PID_SFP_10GBASE_SR:
> +		ethtool_link_ksettings_add_link_mode(ks, supported,
> +						     10000baseSR_Full);
> +		ethtool_link_ksettings_add_link_mode(ks, advertising,
> +						     10000baseSR_Full);
> +		break;
> +	case XCVR_PID_SFP_10GBASE_LR:
> +		ethtool_link_ksettings_add_link_mode(ks, supported,
> +						     10000baseLR_Full);
> +		ethtool_link_ksettings_add_link_mode(ks, advertising,
> +						     10000baseLR_Full);
> +		break;
> +	case XCVR_PID_SFP_10GBASE_LRM:
> +		ethtool_link_ksettings_add_link_mode(ks, supported,
> +						     10000baseLRM_Full);
> +		ethtool_link_ksettings_add_link_mode(ks, advertising,
> +						     10000baseLRM_Full);
> +		break;
> +	case XCVR_PID_SFP_10GBASE_ER:
> +		ethtool_link_ksettings_add_link_mode(ks, supported,
> +						     10000baseER_Full);
> +		ethtool_link_ksettings_add_link_mode(ks, advertising,
> +						     10000baseER_Full);
> +		break;
> +	case XCVR_PID_QSFP_100G_ACC:
> +	case XCVR_PID_QSFP_40GBASE_ER4:
> +	case XCVR_PID_SFP_25GBASE_LR:
> +	case XCVR_PID_SFP_25GBASE_ER:
> +		dev_info(lif->ionic->dev, "no decode bits for xcvr type pid=%d / 0x%x\n",
> +			 idev->port_info->status.xcvr.pid,
> +			 idev->port_info->status.xcvr.pid);
> +		break;

Maybe you should rather add these modes so that they can be shown and
set.

> +	case XCVR_PID_UNKNOWN:
> +		break;
> +	default:
> +		dev_info(lif->ionic->dev, "unknown xcvr type pid=%d / 0x%x\n",
> +			 idev->port_info->status.xcvr.pid,
> +			 idev->port_info->status.xcvr.pid);
> +		break;
> +	}

Up to this point, you always set each bit in both supported and
advertised modes. Thus you could set the modes in only one of the
bitmaps and copy it to the other here.

> +
> +	ethtool_link_ksettings_add_link_mode(ks, supported, Pause);
> +	if (idev->port_info->config.pause_type)
> +		ethtool_link_ksettings_add_link_mode(ks, advertising, Pause);
> +
> +	if (idev->port_info->config.fec_type == PORT_FEC_TYPE_FC)
> +		ethtool_link_ksettings_add_link_mode(ks, advertising, FEC_BASER);
> +	else if (idev->port_info->config.fec_type == PORT_FEC_TYPE_RS)
> +		ethtool_link_ksettings_add_link_mode(ks, advertising, FEC_RS);
> +	else
> +		ethtool_link_ksettings_add_link_mode(ks, advertising, FEC_NONE);

Is it correct to set these FEC bits only in advertising and not in
supported?

> +static int ionic_set_link_ksettings(struct net_device *netdev,
> +				    const struct ethtool_link_ksettings *ks)
> +{
> +	struct lif *lif = netdev_priv(netdev);
> +	struct ionic *ionic = lif->ionic;
> +	struct ionic_dev *idev = &lif->ionic->idev;
> +	u8 fec_type = PORT_FEC_TYPE_NONE;
> +	u32 req_rs, req_b;
> +	int err = 0;
> +
> +	/* set autoneg */
> +	if (ks->base.autoneg != idev->port_info->config.an_enable) {
> +		idev->port_info->config.an_enable = ks->base.autoneg;

IMHO you should only save the value if the command below succeeds,
otherwise next time you will be comparing against the value which wasn't
actually set.

> +		mutex_lock(&ionic->dev_cmd_lock);
> +		ionic_dev_cmd_port_autoneg(idev, ks->base.autoneg);
> +		err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
> +		mutex_unlock(&ionic->dev_cmd_lock);
> +		if (err)
> +			return err;
> +	}
> +
> +	/* set speed */
> +	if (ks->base.speed != le32_to_cpu(idev->port_info->config.speed)) {
> +		idev->port_info->config.speed = cpu_to_le32(ks->base.speed);

Same here.

> +		mutex_lock(&ionic->dev_cmd_lock);
> +		ionic_dev_cmd_port_speed(idev, ks->base.speed);
> +		err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
> +		mutex_unlock(&ionic->dev_cmd_lock);
> +		if (err)
> +			return err;
> +	}
> +
> +	/* set FEC */
> +	req_rs = ethtool_link_ksettings_test_link_mode(ks, advertising, FEC_RS);
> +	req_b = ethtool_link_ksettings_test_link_mode(ks, advertising, FEC_BASER);
> +	if (req_rs && req_b) {
> +		netdev_info(netdev, "Only select one FEC mode at a time\n");
> +		return -EINVAL;
> +
> +	} else if (req_b &&
> +		   idev->port_info->config.fec_type != PORT_FEC_TYPE_FC) {
> +		fec_type = PORT_FEC_TYPE_FC;
> +	} else if (req_rs &&
> +		   idev->port_info->config.fec_type != PORT_FEC_TYPE_RS) {
> +		fec_type = PORT_FEC_TYPE_RS;
> +	} else if (!(req_rs | req_b) &&
> +		 idev->port_info->config.fec_type != PORT_FEC_TYPE_NONE) {
> +		fec_type = PORT_FEC_TYPE_NONE;
> +	}

AFAICS if userspace requests a mode which is already set, you end up
with fec_type = PORT_FEC_TYPE_NONE here. This doesn't seem right.
I assume you would rather want to skip the setting below in such case.

> +
> +	idev->port_info->config.fec_type = fec_type;
> +	mutex_lock(&ionic->dev_cmd_lock);
> +	ionic_dev_cmd_port_fec(idev, PORT_FEC_TYPE_NONE);

Shouldn't the argument be fec_type here?

> +	err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
> +	mutex_unlock(&ionic->dev_cmd_lock);
> +	if (err)
> +		return err;
> +
> +	return 0;
> +}
...
> +static int ionic_set_ringparam(struct net_device *netdev,
> +			       struct ethtool_ringparam *ring)
> +{
> +	struct lif *lif = netdev_priv(netdev);
> +	bool running;
> +	int i, j;
> +
> +	if (ring->rx_mini_pending || ring->rx_jumbo_pending) {
> +		netdev_info(netdev, "Changing jumbo or mini descriptors not supported\n");
> +		return -EINVAL;
> +	}
> +
> +	i = ring->tx_pending & (ring->tx_pending - 1);
> +	j = ring->rx_pending & (ring->rx_pending - 1);
> +	if (i || j) {
> +		netdev_info(netdev, "Descriptor count must be a power of 2\n");
> +		return -EINVAL;
> +	}
> +
> +	if (ring->tx_pending > IONIC_MAX_TXRX_DESC ||
> +	    ring->tx_pending < IONIC_MIN_TXRX_DESC ||
> +	    ring->rx_pending > IONIC_MAX_TXRX_DESC ||
> +	    ring->rx_pending < IONIC_MIN_TXRX_DESC) {
> +		netdev_info(netdev, "Descriptors count must be in the range [%d-%d]\n",
> +			    IONIC_MIN_TXRX_DESC, IONIC_MAX_TXRX_DESC);
> +		return -EINVAL;
> +	}

The upper bounds have been already checked in ethtool_set_ringparam() so
that the two conditions can never be satisfied here.

...
> +static int ionic_set_channels(struct net_device *netdev,
> +			      struct ethtool_channels *ch)
> +{
> +	struct lif *lif = netdev_priv(netdev);
> +	bool running;
> +
> +	if (!ch->combined_count || ch->other_count ||
> +	    ch->rx_count || ch->tx_count)
> +		return -EINVAL;
> +
> +	if (ch->combined_count > lif->ionic->ntxqs_per_lif)
> +		return -EINVAL;

This has been already checked in ethtool_set_channels().

Michal Kubecek
