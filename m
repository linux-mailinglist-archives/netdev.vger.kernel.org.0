Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF623571FA
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 21:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfFZTsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 15:48:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34600 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726227AbfFZTsH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 15:48:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=w8AJTcPs0a2CKfDemTMlmKB6cu1Jrxc0HMLki1VW+ZA=; b=g6O2cwzgnI11pasJLx3Vc8g1pc
        N4zfSYMdyIRKcFVpkEqsZuxxgv1/M09Ws0W+1kR8l7NJBt8OmmPetW7unoN3QaVprhb1kR4rLtNLC
        Qge99jwAcRMct/ZeUwSvCKRd68eo7TmDeBPBwRT/c5JExx6PAuOk7WLRbHsFuR9ZMiMs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hgDtl-0003mg-CI; Wed, 26 Jun 2019 21:48:05 +0200
Date:   Wed, 26 Jun 2019 21:48:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Catherine Sullivan <csully@google.com>
Cc:     netdev@vger.kernel.org, Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>
Subject: Re: [net-next 4/4] gve: Add ethtool support
Message-ID: <20190626194805.GG27733@lunn.ch>
References: <20190626185251.205687-1-csully@google.com>
 <20190626185251.205687-5-csully@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626185251.205687-5-csully@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int gve_get_sset_count(struct net_device *netdev, int sset)
> +{
> +	struct gve_priv *priv = netdev_priv(netdev);
> +
> +	if (!netif_carrier_ok(netdev))
> +		return 0;

That is pretty unusual. What goes wrong if there is no carrier and
statistics are returned?

> +static void
> +gve_get_ethtool_stats(struct net_device *netdev,
> +		      struct ethtool_stats *stats, u64 *data)
> +{
> +	struct gve_priv *priv = netdev_priv(netdev);
> +	u64 rx_pkts, rx_bytes, tx_pkts, tx_bytes;
> +	int ring;
> +	int i;
> +
> +	ASSERT_RTNL();
> +
> +	if (!netif_carrier_ok(netdev))
> +		return;
> +
> +	for (rx_pkts = 0, rx_bytes = 0, ring = 0;
> +	     ring < priv->rx_cfg.num_queues; ring++) {
> +		rx_pkts += priv->rx[ring].rpackets;
> +		rx_bytes += priv->rx[ring].rbytes;
> +	}
> +	for (tx_pkts = 0, tx_bytes = 0, ring = 0;
> +	     ring < priv->tx_cfg.num_queues; ring++) {
> +		tx_pkts += priv->tx[ring].pkt_done;
> +		tx_bytes += priv->tx[ring].bytes_done;
> +	}
> +	memset(data, 0, GVE_MAIN_STATS_LEN * sizeof(*data));

Maybe you should do this memset when the carrier is off?

      Andrew
