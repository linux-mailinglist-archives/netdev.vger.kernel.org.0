Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7486E345321
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 00:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhCVXjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 19:39:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41772 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230009AbhCVXil (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 19:38:41 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lOU7e-00CUJd-OG; Tue, 23 Mar 2021 00:38:10 +0100
Date:   Tue, 23 Mar 2021 00:38:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] net: ethernet: actions: Add Actions Semi Owl
 Ethernet MAC driver
Message-ID: <YFkqYqgwDhV/bBlc@lunn.ch>
References: <cover.1616368101.git.cristian.ciocaltea@gmail.com>
 <ab25bd143589d3c1894cdb3189670efa62ed1440.1616368101.git.cristian.ciocaltea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab25bd143589d3c1894cdb3189670efa62ed1440.1616368101.git.cristian.ciocaltea@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void owl_emac_set_multicast(struct net_device *netdev, int count)
> +{
> +	struct owl_emac_priv *priv = netdev_priv(netdev);
> +	struct netdev_hw_addr *ha;
> +	int index = 0;
> +
> +	if (count <= 0) {
> +		priv->mcaddr_list.count = 0;
> +		return;
> +	}
> +
> +	netdev_for_each_mc_addr(ha, netdev) {
> +		if (!is_multicast_ether_addr(ha->addr))
> +			continue;

Is this possible?

> +
> +		WARN_ON(index >= OWL_EMAC_MAX_MULTICAST_ADDRS);
> +		ether_addr_copy(priv->mcaddr_list.addrs[index++], ha->addr);
> +	}
> +
> +	priv->mcaddr_list.count = index;
> +
> +	owl_emac_setup_frame_xmit(priv);
> +}
> +
> +static void owl_emac_ndo_set_rx_mode(struct net_device *netdev)
> +{
> +	struct owl_emac_priv *priv = netdev_priv(netdev);
> +	u32 status, val = 0;
> +	int mcast_count = 0;
> +
> +	if (netdev->flags & IFF_PROMISC) {
> +		val = OWL_EMAC_BIT_MAC_CSR6_PR;
> +	} else if (netdev->flags & IFF_ALLMULTI) {
> +		val = OWL_EMAC_BIT_MAC_CSR6_PM;
> +	} else if (netdev->flags & IFF_MULTICAST) {
> +		mcast_count = netdev_mc_count(netdev);
> +
> +		if (mcast_count > OWL_EMAC_MAX_MULTICAST_ADDRS) {
> +			val = OWL_EMAC_BIT_MAC_CSR6_PM;
> +			mcast_count = 0;
> +		}
> +	}
> +
> +	spin_lock_bh(&priv->lock);
> +
> +	/* Temporarily stop DMA TX & RX. */
> +	status = owl_emac_dma_cmd_stop(priv);
> +
> +	/* Update operation modes. */
> +	owl_emac_reg_update(priv, OWL_EMAC_REG_MAC_CSR6,
> +			    OWL_EMAC_BIT_MAC_CSR6_PR | OWL_EMAC_BIT_MAC_CSR6_PM,
> +			    val);
> +
> +	/* Restore DMA TX & RX status. */
> +	owl_emac_dma_cmd_set(priv, status);
> +
> +	spin_unlock_bh(&priv->lock);
> +
> +	/* Set/reset multicast addr list. */
> +	owl_emac_set_multicast(netdev, mcast_count);
> +}

I think this can be simplified. At least, you had me going around in
circles a while trying to see if WARN_ON() could be triggered from
user space.

If you have more than OWL_EMAC_MAX_MULTICAST_ADDRS MC addresses, you
go into promisc mode. Can you then skip calling
owl_emac_set_multicast(), which appears not to do too much useful when
passed 0?

       Andrew
