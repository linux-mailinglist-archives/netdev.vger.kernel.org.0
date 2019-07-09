Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA0C62FE8
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 07:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbfGIFZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 01:25:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:51038 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726010AbfGIFZn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 01:25:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 75046AD29;
        Tue,  9 Jul 2019 05:25:41 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 2402BE0E06; Tue,  9 Jul 2019 07:25:41 +0200 (CEST)
Date:   Tue, 9 Jul 2019 07:25:41 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 13/19] ionic: Add initial ethtool support
Message-ID: <20190709052541.GB16610@unicorn.suse.cz>
References: <20190708192532.27420-1-snelson@pensando.io>
 <20190708192532.27420-14-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708192532.27420-14-snelson@pensando.io>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 08, 2019 at 12:25:26PM -0700, Shannon Nelson wrote:
> Add in the basic ethtool callbacks for device information
> and control.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>  drivers/net/ethernet/pensando/ionic/Makefile  |   2 +-
>  .../net/ethernet/pensando/ionic/ionic_dev.h   |   3 +
>  .../ethernet/pensando/ionic/ionic_ethtool.c   | 509 ++++++++++++++++++
>  .../ethernet/pensando/ionic/ionic_ethtool.h   |   9 +
>  .../net/ethernet/pensando/ionic/ionic_lif.c   |   2 +
>  .../net/ethernet/pensando/ionic/ionic_lif.h   |   8 +
>  6 files changed, 532 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
>  create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_ethtool.h
...
> +static int ionic_set_link_ksettings(struct net_device *netdev,
> +				    const struct ethtool_link_ksettings *ks)
> +{
> +	struct lif *lif = netdev_priv(netdev);
> +	struct ionic *ionic = lif->ionic;
> +	struct ionic_dev *idev = &lif->ionic->idev;
> +	u8 fec_type = PORT_FEC_TYPE_NONE;
> +	u32 req_rs, req_fc;
> +	int err = 0;
> +
> +	/* set autoneg */
> +	if (ks->base.autoneg != idev->port_info->config.an_enable) {
> +		mutex_lock(&ionic->dev_cmd_lock);
> +		ionic_dev_cmd_port_autoneg(idev, ks->base.autoneg);
> +		err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
> +		mutex_unlock(&ionic->dev_cmd_lock);
> +		if (err)
> +			return err;
> +
> +		idev->port_info->config.an_enable = ks->base.autoneg;
> +	}
> +
> +	/* set speed */
> +	if (ks->base.speed != le32_to_cpu(idev->port_info->config.speed)) {
> +		mutex_lock(&ionic->dev_cmd_lock);
> +		ionic_dev_cmd_port_speed(idev, ks->base.speed);
> +		err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
> +		mutex_unlock(&ionic->dev_cmd_lock);
> +		if (err)
> +			return err;
> +
> +		idev->port_info->config.speed = cpu_to_le32(ks->base.speed);
> +	}
> +
> +	/* set FEC */
> +	req_rs = ethtool_link_ksettings_test_link_mode(ks, advertising, FEC_RS);
> +	req_fc = ethtool_link_ksettings_test_link_mode(ks, advertising, FEC_BASER);
> +	if (req_rs && req_fc) {
> +		netdev_info(netdev, "Only select one FEC mode at a time\n");
> +		return -EINVAL;
> +
> +	} else if (req_fc &&
> +		   idev->port_info->config.fec_type != PORT_FEC_TYPE_FC) {
> +		fec_type = PORT_FEC_TYPE_FC;
> +	} else if (req_rs &&
> +		   idev->port_info->config.fec_type != PORT_FEC_TYPE_RS) {
> +		fec_type = PORT_FEC_TYPE_RS;
> +	} else if (!(req_rs | req_fc) &&
> +		 idev->port_info->config.fec_type != PORT_FEC_TYPE_NONE) {
> +		fec_type = PORT_FEC_TYPE_NONE;
> +	}
> +
> +	if (fec_type != idev->port_info->config.fec_type) {
> +		mutex_lock(&ionic->dev_cmd_lock);
> +		ionic_dev_cmd_port_fec(idev, PORT_FEC_TYPE_NONE);

The second argument should be fec_type, I believe.

> +		err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
> +		mutex_unlock(&ionic->dev_cmd_lock);
> +		if (err)
> +			return err;
> +
> +		idev->port_info->config.fec_type = fec_type;
> +	}
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

You can use is_power_of_2() here (it wouldn't allow 0 but you probably
don't want to allow that either).

Michal

> +
> +	/* if nothing to do return success */
> +	if (ring->tx_pending == lif->ntxq_descs &&
> +	    ring->rx_pending == lif->nrxq_descs)
> +		return 0;
> +
> +	while (test_and_set_bit(LIF_QUEUE_RESET, lif->state))
> +		usleep_range(200, 400);
> +
> +	running = test_bit(LIF_UP, lif->state);
> +	if (running)
> +		ionic_stop(netdev);
> +
> +	lif->ntxq_descs = ring->tx_pending;
> +	lif->nrxq_descs = ring->rx_pending;
> +
> +	if (running)
> +		ionic_open(netdev);
> +	clear_bit(LIF_QUEUE_RESET, lif->state);
> +
> +	return 0;
> +}
