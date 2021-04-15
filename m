Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1DEC36114C
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 19:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbhDORor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 13:44:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233134AbhDORom (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 13:44:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 246D06115B;
        Thu, 15 Apr 2021 17:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618508659;
        bh=FQz0pD4kv15nu6Gh8jeOf7Ip6Z3DdOPGbJ6/uOkYSmc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fECi0I1N7U6/gNqBXmbNEU9TdnsRDZvWE680GsvE78zRk2D5aamSbkRiFxFGpMhOo
         GzT0+4mWV4vASYHFP/1zhIKgmT3l0UCFkLCMuHbuB1m/rarLZ+aJzCwEiKR3kfXF3g
         1TgTfl9pFvDWRcSLGJZg5Hsbj43sGlVITCHktJX0xdDL7mdle9gMJfGx8Yov9Zj9kg
         nQW17bAZE+WJqSWCEDHkFF4mYRvwiniKKEAX5NrIJtPaCtJ4quwtofDzI9HVKdD44i
         a2JDMZI86qYDwD4E2+qWjdlm4mGPD9NuK3OnMYvT51t1mg+leMzqGdUWl7RYKtjVE0
         kgAhCnrSNvvKA==
Date:   Thu, 15 Apr 2021 10:44:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     davem@davemloft.net, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, liuwe@microsoft.com,
        netdev@vger.kernel.org, leon@kernel.org, andrew@lunn.ch,
        bernd@petrovitsch.priv.at, rdunlap@infradead.org,
        shacharr@microsoft.com, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v6 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Message-ID: <20210415104417.6269cd9a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210415054519.12944-1-decui@microsoft.com>
References: <20210415054519.12944-1-decui@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Apr 2021 22:45:19 -0700 Dexuan Cui wrote:
> +	buf = dma_alloc_coherent(gmi->dev, length, &dma_handle,
> +				 GFP_KERNEL | __GFP_ZERO);

No need for GFP_ZERO, dma_alloc_coherent() zeroes the memory these days.

> +static int mana_gd_register_irq(struct gdma_queue *queue,
> +				const struct gdma_queue_spec *spec)
> ...
> +	struct gdma_irq_context *gic;
> +
> +	struct gdma_context *gc;

Why the empty line?

> +	queue = kzalloc(sizeof(*queue), GFP_KERNEL);
> +	if (!queue)
> +		return -ENOMEM;
> +
> +	gmi = &queue->mem_info;
> +	err = mana_gd_alloc_memory(gc, spec->queue_size, gmi);
> +	if (err)
> +		return err;

Leaks the memory from 'queue'?

Same code in mana_gd_create_mana_eq(), ...wq_cq(), etc.

> +int mana_do_attach(struct net_device *ndev, enum mana_attach_caller caller)
> +{
> +	struct mana_port_context *apc = netdev_priv(ndev);
> +	struct gdma_dev *gd = apc->ac->gdma_dev;
> +	u32 max_txq, max_rxq, max_queues;
> +	int port_idx = apc->port_idx;
> +	u32 num_indirect_entries;
> +	int err;
> +
> +	if (caller == MANA_OPEN)
> +		goto start_open;
> +
> +	err = mana_init_port_context(apc);
> +	if (err)
> +		return err;
> +
> +	err = mana_query_vport_cfg(apc, port_idx, &max_txq, &max_rxq,
> +				   &num_indirect_entries);
> +	if (err) {
> +		netdev_err(ndev, "Failed to query info for vPort 0\n");
> +		goto reset_apc;
> +	}
> +
> +	max_queues = min_t(u32, max_txq, max_rxq);
> +	if (apc->max_queues > max_queues)
> +		apc->max_queues = max_queues;
> +
> +	if (apc->num_queues > apc->max_queues)
> +		apc->num_queues = apc->max_queues;
> +
> +	memcpy(ndev->dev_addr, apc->mac_addr, ETH_ALEN);
> +
> +	if (caller == MANA_PROBE)
> +		return 0;
> +
> +start_open:

Why keep this as a single function, there is no overlap between what's
done for OPEN and PROBE, it seems.

Similarly detach should probably be split into clearly distinct parts.

> +	err = mana_create_eq(apc);
> +	if (err)
> +		goto reset_apc;
> +
> +	err = mana_create_vport(apc, ndev);
> +	if (err)
> +		goto destroy_eq;
> +
> +	err = netif_set_real_num_tx_queues(ndev, apc->num_queues);
> +	if (err)
> +		goto destroy_vport;
> +
> +	err = mana_add_rx_queues(apc, ndev);
> +	if (err)
> +		goto destroy_vport;
> +
> +	apc->rss_state = apc->num_queues > 1 ? TRI_STATE_TRUE : TRI_STATE_FALSE;
> +
> +	err = netif_set_real_num_rx_queues(ndev, apc->num_queues);
> +	if (err)
> +		goto destroy_vport;
> +
> +	mana_rss_table_init(apc);
> +
> +	err = mana_config_rss(apc, TRI_STATE_TRUE, true, true);
> +	if (err)
> +		goto destroy_vport;
> +
> +	return 0;
> +
> +destroy_vport:
> +	mana_destroy_vport(apc);
> +destroy_eq:
> +	mana_destroy_eq(gd->gdma_context, apc);
> +reset_apc:
> +	if (caller == MANA_OPEN)
> +		return err;
> +	kfree(apc->rxqs);
> +	apc->rxqs = NULL;
> +	return err;
> +}
> +
> +int mana_attach(struct net_device *ndev)
> +{
> +	struct mana_port_context *apc = netdev_priv(ndev);
> +	int err;
> +
> +	ASSERT_RTNL();
> +
> +	err = mana_do_attach(ndev, MANA_ATTACH);
> +	if (err)
> +		return err;
> +
> +	netif_device_attach(ndev);
> +
> +	apc->port_is_up = apc->port_st_save;
> +
> +	/* Ensure port state updated before txq state */
> +	smp_wmb();
> +
> +	if (apc->port_is_up) {
> +		netif_carrier_on(ndev);
> +		netif_tx_wake_all_queues(ndev);
> +	}
> +
> +	return 0;
> +}
