Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B034C40CEB0
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 23:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbhIOVSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 17:18:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43122 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230382AbhIOVSb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 17:18:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=r86CNqldwDEtT67/MPxr+lwRy10J2msOmuDKCgTFsHA=; b=Am1/doWwxRfmJugYmt746kUzi2
        m/4EPXqeca+ZsOZGRhMDWkPqhbZ0UlQ7VUWfneEXaVAau35yEHLQY3ZXiNul3WZaux6VuZlJMS05K
        lbCW5X8QMJ9Cl1ZVpQEQgr5o10FOpcndhBlCUxWLJMTq7Z20PW+wiJNLo7YzZ959FYDA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mQcHB-006oEm-4f; Wed, 15 Sep 2021 23:17:05 +0200
Date:   Wed, 15 Sep 2021 23:17:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stefan Wahren <stefan.wahren@i2se.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Heimpold <michael.heimpold@in-tech.com>,
        jimmy.shen@vertexcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH RFC 3/3] net: vertexcom: Add MSE102x SPI support
Message-ID: <YUJi0cVawjyiteEx@lunn.ch>
References: <20210914151717.12232-1-stefan.wahren@i2se.com>
 <20210914151717.12232-4-stefan.wahren@i2se.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210914151717.12232-4-stefan.wahren@i2se.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/netdevice.h>
> +#include <linux/etherdevice.h>
> +#include <linux/ethtool.h>
> +#include <linux/cache.h>
> +#include <linux/debugfs.h>
> +#include <linux/seq_file.h>
> +
> +#include <linux/spi/spi.h>
> +#include <linux/of_net.h>
> +
> +#define MSG_DEFAULT	(NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_LINK | \
> +			 NETIF_MSG_TIMER)
> +
> +#define DRV_NAME	"mse102x"
> +
> +#define DET_CMD		0x0001
> +#define DET_SOF		0x0002
> +#define DET_DFT		0x55AA
> +
> +#define CMD_SHIFT	12
> +#define CMD_RTS		(0x1 << CMD_SHIFT)
> +#define CMD_CTR		(0x2 << CMD_SHIFT)
> +
> +#define CMD_MASK	GENMASK(15, CMD_SHIFT)
> +#define LEN_MASK	GENMASK(CMD_SHIFT - 1, 0)
> +
> +#define	DET_CMD_LEN	4
> +#define	DET_SOF_LEN	2
> +#define	DET_DFT_LEN	2

Looks like these tabs should be spaces?

> +static int msg_enable;
> +module_param_named(message, msg_enable, int, 0);
> +MODULE_PARM_DESC(message, "Message verbosity level (0=none, 31=all)");

I know a lot of drivers do this, but module parameters are not
liked. There is a well used ethtool setting for this, msglvl, which
should be used instead. Which in fact, you have support for.

> +static void mse102x_init_mac(struct mse102x_net *mse, struct device_node *np)
> +{
> +	struct net_device *ndev = mse->ndev;
> +	int ret = of_get_mac_address(np, ndev->dev_addr);
> +
> +	if (ret) {
> +		eth_hw_addr_random(ndev);
> +		netdev_err(ndev, "Using random MAC address: %pM\n",
> +			   ndev->dev_addr);
> +	}
> +}

No need to tell the hardware? Does it work in promiscuous mode by
default?

> +static int mse102x_net_stop(struct net_device *ndev)
> +{
> +	struct mse102x_net *mse = netdev_priv(ndev);
> +	struct mse102x_net_spi *mses = to_mse102x_spi(mse);
> +
> +	netif_info(mse, ifdown, ndev, "shutting down\n");
> +
> +	netif_stop_queue(ndev);
> +
> +	/* stop any outstanding work */
> +	flush_work(&mses->tx_work);
> +
> +	/* ensure any queued tx buffers are dumped */
> +	while (!skb_queue_empty(&mse->txq)) {
> +		struct sk_buff *txb = skb_dequeue(&mse->txq);
> +
> +		netif_dbg(mse, ifdown, ndev,
> +			  "%s: freeing txb %p\n", __func__, txb);
> +
> +		dev_kfree_skb(txb);
> +	}
> +
> +	free_irq(ndev->irq, mse);
> +
> +	return 0;

Maybe a netif_carrier_off() in there, to be symmetric with open?

> +/* ethtool support */
> +
> +static void mse102x_get_drvinfo(struct net_device *ndev,
> +				struct ethtool_drvinfo *di)
> +{
> +	strscpy(di->driver, DRV_NAME, sizeof(di->driver));
> +	strscpy(di->version, "1.00", sizeof(di->version));
> +	strscpy(di->bus_info, dev_name(ndev->dev.parent), sizeof(di->bus_info));
> +}

Version is pretty pointless. We suggest you don't use it. The ethtool
core will then fill it with the kernel version, 

> +static int mse102x_probe_spi(struct spi_device *spi)
> +{

...

> +	netif_carrier_off(mse->ndev);
> +	ndev->if_port = IF_PORT_10BASET;

That is not correct. Maybe you should add a IF_PORT_HOMEPLUG ?

> +	ndev->netdev_ops = &mse102x_netdev_ops;
> +	ndev->ethtool_ops = &mse102x_ethtool_ops;
> +
> +	mse102x_init_mac(mse, dev->of_node);
> +
> +	ret = register_netdev(ndev);
> +	if (ret) {
> +		dev_err(dev, "failed to register network device: %d\n", ret);
> +		return ret;
> +	}
> +
> +	mse102x_init_device_debugfs(mses);
> +
> +	return 0;
> +}

> +static const struct of_device_id mse102x_match_table[] = {
> +	{ .compatible = "vertexcom,mse1021" },
> +	{ .compatible = "vertexcom,mse1022" },

Is there an ID register you can read to determine what device you
actually have? If so, i suggest you verify the correct compatible is
used.

	Andrew
