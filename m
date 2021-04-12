Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E10035D02B
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 20:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244767AbhDLSVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 14:21:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:50566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230336AbhDLSVb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 14:21:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 518B061220;
        Mon, 12 Apr 2021 18:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618251673;
        bh=Pxinurmgz0bTNDq+FpM3BVONUcDXYcGZywCD/Ij7L4Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N3S9s2+a09C9YKW1Xf8cZ5jKUAZEuyzU5G1NBBbaYwka3sT0f5TLm7gnVydkxeTXA
         k86779A6BtjYVOmMsE2TXzJ/LMnD04icepcemO/bbvkxLN4pgo4OavUKpCkR52H6JB
         OmpEd4wbih0qvqEQDh8y1b7RMXlUqr/iSg9F2KaybeSDaauqsyHvj5LCAFAWAbcazF
         z7QdQ1nEeDuSPCJubh5c0h9RYn/tZZEH7Did9zf/H2+GQVwaADBzVUJfhPl0PTY4WH
         5+ALUu5POwQMiIyCLZZ9LSXt2M8qn+gJYb6ogGEpPgjTq6xdSDtDr4qujVmiH5nUKE
         MWkV7EpZYv5WQ==
Date:   Mon, 12 Apr 2021 11:21:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     davem@davemloft.net, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, liuwe@microsoft.com,
        netdev@vger.kernel.org, leon@kernel.org, andrew@lunn.ch,
        bernd@petrovitsch.priv.at, rdunlap@infradead.org,
        shacharr@microsoft.com, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v4 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Message-ID: <20210412112109.145faac8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210412023455.45594-1-decui@microsoft.com>
References: <20210412023455.45594-1-decui@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 11 Apr 2021 19:34:55 -0700 Dexuan Cui wrote:
> +	for (i = 0; i < ANA_INDIRECT_TABLE_SIZE; i++)
> +		apc->indir_table[i] = i % apc->num_queues;

ethtool_rxfh_indir_default()

> +	err = mana_cfg_vport_steering(apc, rx, true, update_hash, update_tab);
> +	return err;

return mana_...

please fix everywhere.

> +	netif_set_real_num_tx_queues(ndev, apc->num_queues);
> +
> +	err = mana_add_rx_queues(apc, ndev);
> +	if (err)
> +		goto destroy_vport;
> +
> +	apc->rss_state = apc->num_queues > 1 ? TRI_STATE_TRUE : TRI_STATE_FALSE;
> +
> +	netif_set_real_num_rx_queues(ndev, apc->num_queues);

netif_set_real_num_.. can fail.

> +	rtnl_lock();
> +
> +	netdev_lockdep_set_classes(ndev);
> +
> +	ndev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
> +	ndev->hw_features |= NETIF_F_RXCSUM;
> +	ndev->hw_features |= NETIF_F_TSO | NETIF_F_TSO6;
> +	ndev->hw_features |= NETIF_F_RXHASH;
> +	ndev->features = ndev->hw_features;
> +	ndev->vlan_features = 0;
> +
> +	err = register_netdevice(ndev);
> +	if (err) {
> +		netdev_err(ndev, "Unable to register netdev.\n");
> +		goto destroy_vport;
> +	}
> +
> +	rtnl_unlock();
> +
> +	return 0;
> +destroy_vport:
> +	rtnl_unlock();

Why do you take rtnl_lock() explicitly around this code?

> +static int mana_set_channels(struct net_device *ndev,
> +			     struct ethtool_channels *channels)
> +{
> +	struct ana_port_context *apc = netdev_priv(ndev);
> +	unsigned int new_count;
> +	unsigned int old_count;
> +	int err, err2;
> +
> +	new_count = channels->combined_count;
> +	old_count = apc->num_queues;
> +
> +	if (new_count < 1 || new_count > apc->max_queues ||
> +	    channels->rx_count || channels->tx_count || channels->other_count)

All these checks should be done by the core already.

> +		return -EINVAL;
> +
> +	if (new_count == old_count)
> +		return 0;

And so is this one.

> +	err = mana_detach(ndev);
> +	if (err) {
> +		netdev_err(ndev, "mana_detach failed: %d\n", err);
> +		return err;
> +	}
