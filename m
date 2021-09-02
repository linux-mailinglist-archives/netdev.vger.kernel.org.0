Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF333FF7B4
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 01:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347864AbhIBXSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 19:18:07 -0400
Received: from mga05.intel.com ([192.55.52.43]:48167 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231232AbhIBXSG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 19:18:06 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10095"; a="304839030"
X-IronPort-AV: E=Sophos;i="5.85,263,1624345200"; 
   d="scan'208";a="304839030"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 16:17:06 -0700
X-IronPort-AV: E=Sophos;i="5.85,263,1624345200"; 
   d="scan'208";a="542997009"
Received: from mmesnie-mobl1.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.212.253.223])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 16:17:05 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        robh+dt@kernel.org, michal.simek@xilinx.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: Re: [PATCH net-next v2 3/3] tsnep: Add TSN endpoint Ethernet MAC
 driver
In-Reply-To: <20210831193425.26193-4-gerhard@engleder-embedded.com>
References: <20210831193425.26193-1-gerhard@engleder-embedded.com>
 <20210831193425.26193-4-gerhard@engleder-embedded.com>
Date:   Thu, 02 Sep 2021 16:17:04 -0700
Message-ID: <874kb21sb3.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gerhard Engleder <gerhard@engleder-embedded.com> writes:

> The TSN endpoint Ethernet MAC is a FPGA based network device for
> real-time communication.
>
> It is integrated as Ethernet controller with ethtool and PTP support.
> For real-time communcation TC_SETUP_QDISC_TAPRIO is supported.
>
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---

[...]

> +static int tsnep_netdev_open(struct net_device *netdev)
> +{
> +	struct tsnep_adapter *adapter = netdev_priv(netdev);
> +	void *addr;
> +	int i;
> +	int retval;
> +
> +	retval = tsnep_phy_open(adapter);
> +	if (retval)
> +		return retval;
> +
> +	for (i = 0; i < adapter->num_tx_queues; i++) {
> +		addr = adapter->addr + TSNEP_QUEUE(i);
> +		retval = tsnep_tx_open(adapter, &adapter->tx[i], addr);
> +		if (retval)
> +			goto tx_failed;
> +	}
> +	retval = netif_set_real_num_tx_queues(adapter->netdev,
> +					      adapter->num_tx_queues);
> +	if (retval)
> +		goto tx_failed;
> +	for (i = 0; i < adapter->num_rx_queues; i++) {
> +		addr = adapter->addr + TSNEP_QUEUE(i);
> +		retval = tsnep_rx_open(adapter, &adapter->rx[i], addr);
> +		if (retval)
> +			goto rx_failed;
> +	}
> +	retval = netif_set_real_num_rx_queues(adapter->netdev,
> +					      adapter->num_rx_queues);
> +	if (retval)
> +		goto rx_failed;
> +
> +	netif_napi_add(adapter->netdev, &adapter->napi, tsnep_rx_napi_poll, 64);

I know that you only have support for 1 queue for now. But having
"tx[0]" and "rx[0]" hardcoded in tsnep_rx_napi_poll() seems less than
ideal if you want to support more queues in the future.

And I think that moving 'struct napi_struct' to be closer to the queues
now will help make that future transition to multiqueue to be cleaner.

> +	napi_enable(&adapter->napi);
> +
> +	tsnep_enable_irq(adapter, ECM_INT_TX_0 | ECM_INT_RX_0);
> +
> +	return 0;
> +
> +rx_failed:
> +	for (i = 0; i < adapter->num_rx_queues; i++)
> +		tsnep_rx_close(&adapter->rx[i]);
> +tx_failed:
> +	for (i = 0; i < adapter->num_tx_queues; i++)
> +		tsnep_tx_close(&adapter->tx[i]);
> +	tsnep_phy_close(adapter);
> +	return retval;
> +}
> +
> +static int tsnep_netdev_close(struct net_device *netdev)
> +{
> +	struct tsnep_adapter *adapter = netdev_priv(netdev);
> +	int i;
> +
> +	tsnep_disable_irq(adapter, ECM_INT_TX_0 | ECM_INT_RX_0);
> +
> +	napi_disable(&adapter->napi);
> +	netif_napi_del(&adapter->napi);
> +
> +	for (i = 0; i < adapter->num_rx_queues; i++)
> +		tsnep_rx_close(&adapter->rx[i]);
> +	for (i = 0; i < adapter->num_tx_queues; i++)
> +		tsnep_tx_close(&adapter->tx[i]);
> +
> +	tsnep_phy_close(adapter);
> +
> +	return 0;
> +}
> +
> +static netdev_tx_t tsnep_netdev_xmit_frame(struct sk_buff *skb,
> +					   struct net_device *netdev)
> +{
> +	struct tsnep_adapter *adapter = netdev_priv(netdev);
> +	u16 queue_mapping = skb_get_queue_mapping(skb);
> +
> +	if (queue_mapping >= adapter->num_tx_queues)
> +		queue_mapping = 0;
> +
> +	return tsnep_xmit_frame_ring(skb, &adapter->tx[queue_mapping]);
> +}
> +
> +static int tsnep_netdev_ioctl(struct net_device *netdev, struct ifreq *ifr,
> +			      int cmd)
> +{
> +	if (!netif_running(netdev))
> +		return -EINVAL;
> +	if (cmd == SIOCSHWTSTAMP || cmd == SIOCGHWTSTAMP)
> +		return tsnep_ptp_ioctl(netdev, ifr, cmd);
> +	return phy_mii_ioctl(netdev->phydev, ifr, cmd);
> +}
> +
> +static void tsnep_netdev_set_multicast(struct net_device *netdev)
> +{
> +	struct tsnep_adapter *adapter = netdev_priv(netdev);
> +
> +	u16 rx_filter = 0;
> +
> +	/* configured MAC address and broadcasts are never filtered */
> +	if (netdev->flags & IFF_PROMISC) {
> +		rx_filter |= TSNEP_RX_FILTER_ACCEPT_ALL_MULTICASTS;
> +		rx_filter |= TSNEP_RX_FILTER_ACCEPT_ALL_UNICASTS;
> +	} else if (!netdev_mc_empty(netdev) || (netdev->flags & IFF_ALLMULTI)) {
> +		rx_filter |= TSNEP_RX_FILTER_ACCEPT_ALL_MULTICASTS;
> +	}
> +	iowrite16(rx_filter, adapter->addr + TSNEP_RX_FILTER);
> +}
> +
> +static void tsnep_netdev_get_stats64(struct net_device *netdev,
> +				     struct rtnl_link_stats64 *stats)
> +{
> +	struct tsnep_adapter *adapter = netdev_priv(netdev);
> +	u32 reg;
> +	u32 val;
> +	int i;
> +
> +	for (i = 0; i < adapter->num_tx_queues; i++) {
> +		stats->tx_packets += adapter->tx[i].packets;
> +		stats->tx_bytes += adapter->tx[i].bytes;
> +		stats->tx_dropped += adapter->tx[i].dropped;
> +	}
> +	for (i = 0; i < adapter->num_rx_queues; i++) {
> +		stats->rx_packets += adapter->rx[i].packets;
> +		stats->rx_bytes += adapter->rx[i].bytes;
> +		stats->rx_dropped += adapter->rx[i].dropped;
> +		stats->multicast += adapter->rx[i].multicast;
> +
> +		reg = ioread32(adapter->addr + TSNEP_QUEUE(i) +
> +			       TSNEP_RX_STATISTIC);
> +		val = (reg & TSNEP_RX_STATISTIC_NO_DESC_MASK) >>
> +		      TSNEP_RX_STATISTIC_NO_DESC_SHIFT;
> +		stats->rx_dropped += val;
> +		val = (reg & TSNEP_RX_STATISTIC_BUFFER_TOO_SMALL_MASK) >>
> +		      TSNEP_RX_STATISTIC_BUFFER_TOO_SMALL_SHIFT;
> +		stats->rx_dropped += val;
> +		val = (reg & TSNEP_RX_STATISTIC_FIFO_OVERFLOW_MASK) >>
> +		      TSNEP_RX_STATISTIC_FIFO_OVERFLOW_SHIFT;
> +		stats->rx_errors += val;
> +		stats->rx_fifo_errors += val;
> +		val = (reg & TSNEP_RX_STATISTIC_INVALID_FRAME_MASK) >>
> +		      TSNEP_RX_STATISTIC_INVALID_FRAME_SHIFT;
> +		stats->rx_errors += val;
> +		stats->rx_frame_errors += val;
> +	}
> +
> +	reg = ioread32(adapter->addr + ECM_STAT);
> +	val = (reg & ECM_STAT_RX_ERR_MASK) >> ECM_STAT_RX_ERR_SHIFT;
> +	stats->rx_errors += val;
> +	val = (reg & ECM_STAT_INV_FRM_MASK) >> ECM_STAT_INV_FRM_SHIFT;
> +	stats->rx_errors += val;
> +	stats->rx_crc_errors += val;
> +	val = (reg & ECM_STAT_FWD_RX_ERR_MASK) >> ECM_STAT_FWD_RX_ERR_SHIFT;
> +	stats->rx_errors += val;
> +}
> +
> +static void tsnep_mac_set_address(struct tsnep_adapter *adapter, u8 *addr)
> +{
> +	iowrite32(*(u32 *)addr, adapter->addr + TSNEP_MAC_ADDRESS_LOW);
> +	iowrite16(*(u16 *)(addr + sizeof(u32)),
> +		  adapter->addr + TSNEP_MAC_ADDRESS_HIGH);
> +
> +	ether_addr_copy(adapter->mac_address, addr);
> +	netif_info(adapter, drv, adapter->netdev, "MAC address set to %pM\n",
> +		   addr);
> +}
> +
> +static int tsnep_netdev_set_mac_address(struct net_device *netdev, void *addr)
> +{
> +	struct tsnep_adapter *adapter = netdev_priv(netdev);
> +	struct sockaddr *sock_addr = addr;
> +	int retval;
> +
> +	retval = eth_prepare_mac_addr_change(netdev, sock_addr);
> +	if (retval)
> +		return retval;
> +	ether_addr_copy(netdev->dev_addr, sock_addr->sa_data);
> +	tsnep_mac_set_address(adapter, sock_addr->sa_data);
> +
> +	return 0;
> +}
> +
> +static const struct net_device_ops tsnep_netdev_ops = {
> +	.ndo_open = tsnep_netdev_open,
> +	.ndo_stop = tsnep_netdev_close,
> +	.ndo_start_xmit = tsnep_netdev_xmit_frame,
> +	.ndo_eth_ioctl = tsnep_netdev_ioctl,
> +	.ndo_set_rx_mode = tsnep_netdev_set_multicast,
> +
> +	.ndo_get_stats64 = tsnep_netdev_get_stats64,
> +	.ndo_set_mac_address = tsnep_netdev_set_mac_address,
> +	.ndo_setup_tc = tsnep_tc_setup,
> +};
> +
> +static int tsnep_mac_init(struct tsnep_adapter *adapter)
> +{
> +	int retval;
> +
> +	/* initialize RX filtering, at least configured MAC address and
> +	 * broadcast are not filtered
> +	 */
> +	iowrite16(0, adapter->addr + TSNEP_RX_FILTER);
> +
> +	/* try to get MAC address in the following order:
> +	 * - device tree
> +	 * - MAC address register if valid
> +	 * - random MAC address
> +	 */
> +	retval = of_get_mac_address(adapter->pdev->dev.of_node,
> +				    adapter->mac_address);
> +	if (retval == -EPROBE_DEFER)
> +		return retval;
> +	if (retval) {
> +		*(u32 *)adapter->mac_address =
> +			ioread32(adapter->addr + TSNEP_MAC_ADDRESS_LOW);
> +		*(u16 *)(adapter->mac_address + sizeof(u32)) =
> +			ioread16(adapter->addr + TSNEP_MAC_ADDRESS_HIGH);
> +		if (!is_valid_ether_addr(adapter->mac_address))
> +			eth_random_addr(adapter->mac_address);
> +	}
> +
> +	tsnep_mac_set_address(adapter, adapter->mac_address);
> +	ether_addr_copy(adapter->netdev->dev_addr, adapter->mac_address);
> +
> +	return 0;
> +}
> +
> +static int tsnep_mdio_init(struct tsnep_adapter *adapter)
> +{
> +	struct device_node *node;
> +	int retval;
> +
> +	node = of_get_child_by_name(adapter->pdev->dev.of_node, "mdio");
> +	if (!node)
> +		return 0;
> +
> +	adapter->mdiobus = devm_mdiobus_alloc(&adapter->pdev->dev);
> +	if (!adapter->mdiobus) {
> +		retval = -ENOMEM;
> +
> +		goto out;
> +	}
> +
> +	adapter->mdiobus->priv = (void *)adapter;
> +	adapter->mdiobus->parent = &adapter->pdev->dev;
> +	adapter->mdiobus->read = tsnep_mdiobus_read;
> +	adapter->mdiobus->write = tsnep_mdiobus_write;
> +	adapter->mdiobus->name = TSNEP "-mdiobus";
> +	snprintf(adapter->mdiobus->id, MII_BUS_ID_SIZE, "%s",
> +		 adapter->pdev->name);
> +
> +	retval = of_mdiobus_register(adapter->mdiobus, node);
> +out:
> +	of_node_put(node);
> +
> +	return retval;
> +}
> +
> +static int tsnep_phy_init(struct tsnep_adapter *adapter)
> +{
> +	struct device_node *dn;
> +	int retval;
> +
> +	retval = of_get_phy_mode(adapter->pdev->dev.of_node,
> +				 &adapter->phy_mode);
> +	if (retval)
> +		adapter->phy_mode = PHY_INTERFACE_MODE_GMII;
> +
> +	dn = of_parse_phandle(adapter->pdev->dev.of_node, "phy-handle", 0);
> +	adapter->phydev = of_phy_find_device(dn);
> +	of_node_put(dn);
> +	if (!adapter->phydev && adapter->mdiobus)
> +		adapter->phydev = phy_find_first(adapter->mdiobus);
> +	if (!adapter->phydev)
> +		return -EIO;
> +
> +	return 0;
> +}
> +
> +static int tsnep_probe(struct platform_device *pdev)
> +{
> +	struct tsnep_adapter *adapter;
> +	struct net_device *netdev;
> +	struct resource *io;
> +	u32 type;
> +	int revision;
> +	int version;
> +	int queue_count;
> +	int retval;
> +
> +	netdev = devm_alloc_etherdev_mqs(&pdev->dev,
> +					 sizeof(struct tsnep_adapter),
> +					 TSNEP_MAX_QUEUES, TSNEP_MAX_QUEUES);
> +	if (!netdev)
> +		return -ENODEV;
> +	SET_NETDEV_DEV(netdev, &pdev->dev);
> +	adapter = netdev_priv(netdev);
> +	platform_set_drvdata(pdev, adapter);
> +	adapter->pdev = pdev;
> +	adapter->netdev = netdev;
> +	adapter->msg_enable = NETIF_MSG_DRV | NETIF_MSG_PROBE |
> +			      NETIF_MSG_LINK | NETIF_MSG_IFUP |
> +			      NETIF_MSG_IFDOWN | NETIF_MSG_TX_QUEUED;
> +
> +	netdev->min_mtu = ETH_MIN_MTU;
> +	netdev->max_mtu = TSNEP_MAX_FRAME_SIZE;
> +
> +	spin_lock_init(&adapter->irq_lock);
> +	init_waitqueue_head(&adapter->md_wait);
> +	mutex_init(&adapter->gate_control_lock);
> +
> +	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	adapter->addr = devm_ioremap_resource(&pdev->dev, io);
> +	if (IS_ERR(adapter->addr))
> +		return PTR_ERR(adapter->addr);
> +	adapter->size = io->end - io->start + 1;
> +	adapter->irq = platform_get_irq(pdev, 0);
> +	netdev->mem_start = io->start;
> +	netdev->mem_end = io->end;
> +	netdev->irq = adapter->irq;
> +
> +	type = ioread32(adapter->addr + ECM_TYPE);
> +	revision = (type & ECM_REVISION_MASK) >> ECM_REVISION_SHIFT;
> +	version = (type & ECM_VERSION_MASK) >> ECM_VERSION_SHIFT;
> +	queue_count = (type & ECM_QUEUE_COUNT_MASK) >> ECM_QUEUE_COUNT_SHIFT;
> +	adapter->gate_control = type & ECM_GATE_CONTROL;
> +
> +	adapter->num_tx_queues = TSNEP_QUEUES;
> +	adapter->num_rx_queues = TSNEP_QUEUES;
> +
> +	iowrite32(0, adapter->addr + ECM_INT_ENABLE);
> +	retval = devm_request_irq(&adapter->pdev->dev, adapter->irq, tsnep_irq,
> +				  0, TSNEP, adapter);
> +	if (retval != 0) {
> +		dev_err(&adapter->pdev->dev, "can't get assigned irq %d.",
> +			adapter->irq);
> +		return retval;
> +	}
> +	tsnep_enable_irq(adapter, ECM_INT_MD | ECM_INT_LINK);
> +
> +	retval = tsnep_mac_init(adapter);
> +	if (retval)
> +		goto mac_init_failed;
> +
> +	retval = tsnep_mdio_init(adapter);
> +	if (retval)
> +		goto mdio_init_failed;
> +
> +	retval = tsnep_phy_init(adapter);
> +	if (retval)
> +		goto phy_init_failed;
> +
> +	retval = tsnep_ptp_init(adapter);
> +	if (retval)
> +		goto ptp_init_failed;
> +
> +	retval = tsnep_tc_init(adapter);
> +	if (retval)
> +		goto tc_init_failed;
> +
> +	netdev->netdev_ops = &tsnep_netdev_ops;
> +	netdev->ethtool_ops = &tsnep_ethtool_ops;
> +	netdev->features = NETIF_F_SG;
> +	netdev->hw_features = netdev->features;
> +
> +	/* carrier off reporting is important to ethtool even BEFORE open */
> +	netif_carrier_off(netdev);
> +
> +	retval = register_netdev(netdev);
> +	if (retval)
> +		goto register_failed;
> +
> +	dev_info(&adapter->pdev->dev, "device version %d.%02d\n", version,
> +		 revision);
> +	if (adapter->gate_control)
> +		dev_info(&adapter->pdev->dev, "gate control detected\n");
> +
> +	return 0;
> +
> +	unregister_netdev(adapter->netdev);
> +register_failed:
> +	tsnep_tc_cleanup(adapter);
> +tc_init_failed:
> +	tsnep_ptp_cleanup(adapter);
> +ptp_init_failed:
> +phy_init_failed:
> +	if (adapter->mdiobus)
> +		mdiobus_unregister(adapter->mdiobus);
> +mdio_init_failed:
> +mac_init_failed:
> +	return retval;
> +}
> +
> +static int tsnep_remove(struct platform_device *pdev)
> +{
> +	struct tsnep_adapter *adapter = platform_get_drvdata(pdev);
> +
> +	unregister_netdev(adapter->netdev);
> +
> +	tsnep_tc_cleanup(adapter);
> +
> +	tsnep_ptp_cleanup(adapter);
> +
> +	if (adapter->mdiobus)
> +		mdiobus_unregister(adapter->mdiobus);
> +
> +	iowrite32(0, adapter->addr + ECM_INT_ENABLE);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id tsnep_of_match[] = {
> +	{ .compatible = "engleder,tsnep", },
> +{ },
> +};
> +MODULE_DEVICE_TABLE(of, tsnep_of_match);
> +
> +static struct platform_driver tsnep_driver = {
> +	.driver = {
> +		.name = TSNEP,
> +		.owner = THIS_MODULE,
> +		.of_match_table = of_match_ptr(tsnep_of_match),
> +	},
> +	.probe = tsnep_probe,
> +	.remove = tsnep_remove,
> +};
> +module_platform_driver(tsnep_driver);
> +
> +MODULE_AUTHOR("Gerhard Engleder <gerhard@engleder-embedded.com>");
> +MODULE_DESCRIPTION("TSN endpoint Ethernet MAC driver");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/net/ethernet/engleder/tsnep_ptp.c b/drivers/net/ethernet/engleder/tsnep_ptp.c
> new file mode 100644
> index 000000000000..4bfb4d8508f5
> --- /dev/null
> +++ b/drivers/net/ethernet/engleder/tsnep_ptp.c
> @@ -0,0 +1,221 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (C) 2021 Gerhard Engleder <gerhard@engleder-embedded.com> */
> +
> +#include "tsnep.h"
> +
> +void tsnep_get_system_time(struct tsnep_adapter *adapter, u64 *time)
> +{
> +	u32 high_before;
> +	u32 low;
> +	u32 high;
> +
> +	/* read high dword twice to detect overrun */
> +	high = ioread32(adapter->addr + ECM_SYSTEM_TIME_HIGH);
> +	do {
> +		low = ioread32(adapter->addr + ECM_SYSTEM_TIME_LOW);
> +		high_before = high;
> +		high = ioread32(adapter->addr + ECM_SYSTEM_TIME_HIGH);
> +	} while (high != high_before);
> +	*time = (((u64)high) << 32) | ((u64)low);
> +}
> +
> +int tsnep_ptp_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
> +{
> +	struct tsnep_adapter *adapter = netdev_priv(netdev);
> +	struct hwtstamp_config config;
> +
> +	if (!ifr)
> +		return -EINVAL;
> +
> +	if (cmd == SIOCSHWTSTAMP) {
> +		if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
> +			return -EFAULT;
> +
> +		if (config.flags)
> +			return -EINVAL;
> +
> +		switch (config.tx_type) {
> +		case HWTSTAMP_TX_OFF:
> +		case HWTSTAMP_TX_ON:
> +			break;
> +		default:
> +			return -ERANGE;
> +		}
> +
> +		switch (config.rx_filter) {
> +		case HWTSTAMP_FILTER_NONE:
> +			break;
> +		case HWTSTAMP_FILTER_ALL:
> +		case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
> +		case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
> +		case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
> +		case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
> +		case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
> +		case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
> +		case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
> +		case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
> +		case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
> +		case HWTSTAMP_FILTER_PTP_V2_EVENT:
> +		case HWTSTAMP_FILTER_PTP_V2_SYNC:
> +		case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
> +		case HWTSTAMP_FILTER_NTP_ALL:
> +			config.rx_filter = HWTSTAMP_FILTER_ALL;
> +			break;
> +		default:
> +			return -ERANGE;
> +		}
> +
> +		memcpy(&adapter->hwtstamp_config, &config,
> +		       sizeof(adapter->hwtstamp_config));
> +	}
> +
> +	if (copy_to_user(ifr->ifr_data, &adapter->hwtstamp_config,
> +			 sizeof(adapter->hwtstamp_config)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +static int tsnep_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
> +{
> +	struct tsnep_adapter *adapter = container_of(ptp, struct tsnep_adapter,
> +						     ptp_clock_info);
> +	bool negative = false;
> +	u64 rate_offset;
> +
> +	if (scaled_ppm < 0) {
> +		scaled_ppm = -scaled_ppm;
> +		negative = true;
> +	}
> +
> +	/* convert from 16 bit to 32 bit binary fractional, divide by 1000000 to
> +	 * eliminate ppm, multiply with 8 to compensate 8ns clock cycle time,
> +	 * simplify calculation because 15625 * 8 = 1000000 / 8
> +	 */
> +	rate_offset = scaled_ppm;
> +	rate_offset <<= 16 - 3;
> +	rate_offset = div_u64(rate_offset, 15625);
> +
> +	rate_offset &= ECM_CLOCK_RATE_OFFSET_MASK;
> +	if (negative)
> +		rate_offset |= ECM_CLOCK_RATE_OFFSET_SIGN;
> +	iowrite32(rate_offset & 0xFFFFFFFF, adapter->addr + ECM_CLOCK_RATE);
> +
> +	return 0;
> +}
> +
> +static int tsnep_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
> +{
> +	struct tsnep_adapter *adapter = container_of(ptp, struct tsnep_adapter,
> +						     ptp_clock_info);
> +	u64 system_time;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&adapter->ptp_lock, flags);
> +
> +	tsnep_get_system_time(adapter, &system_time);
> +
> +	system_time += delta;
> +
> +	/* high dword is buffered in hardware and synchronously written to
> +	 * system time when low dword is written
> +	 */
> +	iowrite32(system_time >> 32, adapter->addr + ECM_SYSTEM_TIME_HIGH);
> +	iowrite32(system_time & 0xFFFFFFFF,
> +		  adapter->addr + ECM_SYSTEM_TIME_LOW);
> +
> +	spin_unlock_irqrestore(&adapter->ptp_lock, flags);
> +
> +	return 0;
> +}
> +
> +static int tsnep_ptp_gettimex64(struct ptp_clock_info *ptp,
> +				struct timespec64 *ts,
> +				struct ptp_system_timestamp *sts)
> +{
> +	struct tsnep_adapter *adapter = container_of(ptp, struct tsnep_adapter,
> +						     ptp_clock_info);
> +	u32 high_before;
> +	u32 low;
> +	u32 high;
> +	u64 system_time;
> +
> +	/* read high dword twice to detect overrun */
> +	high = ioread32(adapter->addr + ECM_SYSTEM_TIME_HIGH);
> +	do {
> +		ptp_read_system_prets(sts);
> +		low = ioread32(adapter->addr + ECM_SYSTEM_TIME_LOW);
> +		ptp_read_system_postts(sts);
> +		high_before = high;
> +		high = ioread32(adapter->addr + ECM_SYSTEM_TIME_HIGH);
> +	} while (high != high_before);
> +	system_time = (((u64)high) << 32) | ((u64)low);
> +
> +	*ts = ns_to_timespec64(system_time);
> +
> +	return 0;
> +}
> +
> +static int tsnep_ptp_settime64(struct ptp_clock_info *ptp,
> +			       const struct timespec64 *ts)
> +{
> +	struct tsnep_adapter *adapter = container_of(ptp, struct tsnep_adapter,
> +						     ptp_clock_info);
> +	u64 system_time = timespec64_to_ns(ts);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&adapter->ptp_lock, flags);
> +
> +	/* high dword is buffered in hardware and synchronously written to
> +	 * system time when low dword is written
> +	 */
> +	iowrite32(system_time >> 32, adapter->addr + ECM_SYSTEM_TIME_HIGH);
> +	iowrite32(system_time & 0xFFFFFFFF,
> +		  adapter->addr + ECM_SYSTEM_TIME_LOW);
> +
> +	spin_unlock_irqrestore(&adapter->ptp_lock, flags);
> +
> +	return 0;
> +}
> +
> +int tsnep_ptp_init(struct tsnep_adapter *adapter)
> +{
> +	int retval = 0;
> +
> +	adapter->hwtstamp_config.rx_filter = HWTSTAMP_FILTER_NONE;
> +	adapter->hwtstamp_config.tx_type = HWTSTAMP_TX_OFF;
> +
> +	snprintf(adapter->ptp_clock_info.name, 16, "%s", TSNEP);
> +	adapter->ptp_clock_info.owner = THIS_MODULE;
> +	/* at most 2^-1ns adjustment every clock cycle for 8ns clock cycle time,
> +	 * stay slightly below because only bits below 2^-1ns are supported
> +	 */
> +	adapter->ptp_clock_info.max_adj = (500000000 / 8 - 1);
> +	adapter->ptp_clock_info.adjfine = tsnep_ptp_adjfine;
> +	adapter->ptp_clock_info.adjtime = tsnep_ptp_adjtime;
> +	adapter->ptp_clock_info.gettimex64 = tsnep_ptp_gettimex64;
> +	adapter->ptp_clock_info.settime64 = tsnep_ptp_settime64;
> +
> +	spin_lock_init(&adapter->ptp_lock);
> +
> +	adapter->ptp_clock = ptp_clock_register(&adapter->ptp_clock_info,
> +						&adapter->pdev->dev);
> +	if (IS_ERR(adapter->ptp_clock)) {
> +		netdev_err(adapter->netdev, "ptp_clock_register failed\n");
> +
> +		retval = PTR_ERR(adapter->ptp_clock);
> +		adapter->ptp_clock = NULL;
> +	} else if (adapter->ptp_clock) {
> +		netdev_info(adapter->netdev, "PHC added\n");
> +	}
> +
> +	return retval;
> +}
> +
> +void tsnep_ptp_cleanup(struct tsnep_adapter *adapter)
> +{
> +	if (adapter->ptp_clock) {
> +		ptp_clock_unregister(adapter->ptp_clock);
> +		netdev_info(adapter->netdev, "PHC removed\n");
> +	}
> +}
> diff --git a/drivers/net/ethernet/engleder/tsnep_tc.c b/drivers/net/ethernet/engleder/tsnep_tc.c
> new file mode 100644
> index 000000000000..2b88c1e2eb2c
> --- /dev/null
> +++ b/drivers/net/ethernet/engleder/tsnep_tc.c
> @@ -0,0 +1,442 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (C) 2021 Gerhard Engleder <gerhard@engleder-embedded.com> */
> +
> +#include "tsnep.h"
> +
> +#include <net/pkt_sched.h>
> +
> +/* save one operation at the end for additional operation at list change */
> +#define TSNEP_MAX_GCL_NUM (TSNEP_GCL_COUNT - 1)
> +
> +static int tsnep_validate_gcl(struct tc_taprio_qopt_offload *qopt)
> +{
> +	int i;
> +	u64 cycle_time;
> +
> +	if (!qopt->cycle_time)
> +		return -ERANGE;
> +	if (qopt->num_entries > TSNEP_MAX_GCL_NUM)
> +		return -EINVAL;
> +	cycle_time = 0;
> +	for (i = 0; i < qopt->num_entries; i++) {
> +		if (qopt->entries[i].command != TC_TAPRIO_CMD_SET_GATES)
> +			return -EINVAL;
> +		if (qopt->entries[i].gate_mask & ~TSNEP_GCL_MASK)
> +			return -EINVAL;
> +		if (qopt->entries[i].interval < TSNEP_GCL_MIN_INTERVAL)
> +			return -EINVAL;
> +		cycle_time += qopt->entries[i].interval;
> +	}
> +	if (qopt->cycle_time != cycle_time)
> +		return -EINVAL;
> +	if (qopt->cycle_time_extension >= qopt->cycle_time)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static void tsnep_write_gcl_operation(struct tsnep_gcl *gcl, int index,
> +				      u32 properties, u32 interval, bool flush)
> +{
> +	void *addr = gcl->addr + sizeof(struct tsnep_gcl_operation) * index;
> +
> +	gcl->operation[index].properties = properties;
> +	gcl->operation[index].interval = interval;
> +
> +	iowrite32(properties, addr);
> +	iowrite32(interval, addr + sizeof(u32));
> +
> +	if (flush) {
> +		/* flush write with read access */
> +		ioread32(addr);
> +	}
> +}
> +
> +static u64 tsnep_change_duration(struct tsnep_gcl *gcl, int index)
> +{
> +	u64 duration;
> +	int count;
> +
> +	/* change needs to be triggered one or two operations before start of
> +	 * new gate control list
> +	 * - change is triggered at start of operation (minimum one operation)
> +	 * - operation with adjusted interval is inserted on demand to exactly
> +	 *   meet the start of the new gate control list (optional)
> +	 *
> +	 * additionally properties are read directly after start of previous
> +	 * operation
> +	 *
> +	 * therefore, three operations needs to be considered for the limit
> +	 */
> +	duration = 0;
> +	count = 3;
> +	while (count) {
> +		duration += gcl->operation[index].interval;
> +
> +		index--;
> +		if (index < 0)
> +			index = gcl->count - 1;
> +
> +		count--;
> +	}
> +
> +	return duration;
> +}
> +
> +static void tsnep_write_gcl(struct tsnep_gcl *gcl,
> +			    struct tc_taprio_qopt_offload *qopt)
> +{
> +	int i;
> +	u32 properties;
> +	u64 extend;
> +	u64 cut;
> +
> +	gcl->base_time = ktime_to_ns(qopt->base_time);
> +	gcl->cycle_time = qopt->cycle_time;
> +	gcl->cycle_time_extension = qopt->cycle_time_extension;
> +
> +	for (i = 0; i < qopt->num_entries; i++) {
> +		properties = qopt->entries[i].gate_mask;
> +		if (i == (qopt->num_entries - 1))
> +			properties |= TSNEP_GCL_LAST;
> +
> +		tsnep_write_gcl_operation(gcl, i, properties,
> +					  qopt->entries[i].interval, true);
> +	}
> +	gcl->count = qopt->num_entries;
> +
> +	/* calculate change limit; i.e., the time needed between enable and
> +	 * start of new gate control list
> +	 */
> +
> +	/* case 1: extend cycle time for change
> +	 * - change duration of last operation
> +	 * - cycle time extension
> +	 */
> +	extend = tsnep_change_duration(gcl, gcl->count - 1);
> +	extend += gcl->cycle_time_extension;
> +
> +	/* case 2: cut cycle time for change
> +	 * - maximum change duration
> +	 */
> +	cut = 0;
> +	for (i = 0; i < gcl->count; i++)
> +		cut = max(cut, tsnep_change_duration(gcl, i));
> +
> +	/* use maximum, because the actual case (extend or cut) can be
> +	 * determined only after limit is known (chicken-and-egg problem)
> +	 */
> +	gcl->change_limit = max(extend, cut);
> +}
> +
> +static u64 tsnep_gcl_start_after(struct tsnep_gcl *gcl, u64 limit)
> +{
> +	u64 start = gcl->base_time;
> +	u64 n;
> +
> +	if (start <= limit) {
> +		n = div64_u64(limit - start, gcl->cycle_time);
> +		start += (n + 1) * gcl->cycle_time;
> +	}
> +
> +	return start;
> +}
> +
> +static u64 tsnep_gcl_start_before(struct tsnep_gcl *gcl, u64 limit)
> +{
> +	u64 start = gcl->base_time;
> +	u64 n;
> +
> +	n = div64_u64(limit - start, gcl->cycle_time);
> +	start += n * gcl->cycle_time;
> +	if (start == limit)
> +		start -= gcl->cycle_time;
> +
> +	return start;
> +}
> +
> +static u64 tsnep_set_gcl_change(struct tsnep_gcl *gcl, int index, u64 change,
> +				bool insert)
> +{
> +	/* previous operation triggers change and properties are evaluated at
> +	 * start of operation
> +	 */
> +	if (index == 0)
> +		index = gcl->count - 1;
> +	else
> +		index = index - 1;
> +	change -= gcl->operation[index].interval;
> +
> +	/* optionally change to new list with additional operation in between */
> +	if (insert) {
> +		void *addr = gcl->addr +
> +			     sizeof(struct tsnep_gcl_operation) * index;
> +
> +		gcl->operation[index].properties |= TSNEP_GCL_INSERT;
> +		iowrite32(gcl->operation[index].properties, addr);
> +	}
> +
> +	return change;
> +}
> +
> +static void tsnep_clean_gcl(struct tsnep_gcl *gcl)
> +{
> +	int i;
> +	u32 mask = TSNEP_GCL_LAST | TSNEP_GCL_MASK;
> +	void *addr;
> +
> +	/* search for insert operation and reset properties */
> +	for (i = 0; i < gcl->count; i++) {
> +		if (gcl->operation[i].properties & ~mask) {
> +			addr = gcl->addr +
> +			       sizeof(struct tsnep_gcl_operation) * i;
> +
> +			gcl->operation[i].properties &= mask;
> +			iowrite32(gcl->operation[i].properties, addr);
> +
> +			break;
> +		}
> +	}
> +}
> +
> +static u64 tsnep_insert_gcl_operation(struct tsnep_gcl *gcl, int ref,
> +				      u64 change, u32 interval)
> +{
> +	u32 properties;
> +
> +	properties = gcl->operation[ref].properties & TSNEP_GCL_MASK;
> +	/* change to new list directly after inserted operation */
> +	properties |= TSNEP_GCL_CHANGE;
> +
> +	/* last operation of list is reserved to insert operation */
> +	tsnep_write_gcl_operation(gcl, TSNEP_GCL_COUNT - 1, properties,
> +				  interval, false);
> +
> +	return tsnep_set_gcl_change(gcl, ref, change, true);
> +}
> +
> +static u64 tsnep_extend_gcl(struct tsnep_gcl *gcl, u64 start, u32 extension)
> +{
> +	int ref = gcl->count - 1;
> +	u32 interval = gcl->operation[ref].interval + extension;
> +
> +	start -= gcl->operation[ref].interval;
> +
> +	return tsnep_insert_gcl_operation(gcl, ref, start, interval);
> +}
> +
> +static u64 tsnep_cut_gcl(struct tsnep_gcl *gcl, u64 start, u64 cycle_time)
> +{
> +	u64 sum = 0;
> +	int i;
> +
> +	/* find operation which shall be cutted */
> +	for (i = 0; i < gcl->count; i++) {
> +		u64 sum_tmp = sum + gcl->operation[i].interval;
> +		u64 interval;
> +
> +		/* sum up operations as long as cycle time is not exceeded */
> +		if (sum_tmp > cycle_time)
> +			break;
> +
> +		/* remaining interval must be big enough for hardware */
> +		interval = cycle_time - sum_tmp;
> +		if (interval > 0 && interval < TSNEP_GCL_MIN_INTERVAL)
> +			break;
> +
> +		sum = sum_tmp;
> +	}
> +	if (sum == cycle_time) {
> +		/* no need to cut operation itself or whole cycle
> +		 * => change exactly at operation
> +		 */
> +		return tsnep_set_gcl_change(gcl, i, start + sum, false);
> +	}
> +	return tsnep_insert_gcl_operation(gcl, i, start + sum,
> +					  cycle_time - sum);
> +}
> +
> +static int tsnep_enable_gcl(struct tsnep_adapter *adapter,
> +			    struct tsnep_gcl *gcl, struct tsnep_gcl *curr)
> +{
> +	u64 system_time;
> +	u64 timeout;
> +	u64 limit;
> +
> +	/* estimate timeout limit after timeout enable, actually timeout limit
> +	 * in hardware will be earlier than estimate so we are on the safe side
> +	 */
> +	tsnep_get_system_time(adapter, &system_time);
> +	timeout = system_time + TSNEP_GC_TIMEOUT;
> +
> +	if (curr)
> +		limit = timeout + curr->change_limit;
> +	else
> +		limit = timeout;
> +
> +	gcl->start_time = tsnep_gcl_start_after(gcl, limit);
> +
> +	/* gate control time register is only 32bit => time shall be in the near
> +	 * future (no driver support for far future implemented)
> +	 */
> +	if ((gcl->start_time - system_time) >= U32_MAX)
> +		return -EAGAIN;
> +
> +	if (curr) {
> +		/* change gate control list */
> +		u64 last;
> +		u64 change;
> +
> +		last = tsnep_gcl_start_before(curr, gcl->start_time);
> +		if ((last + curr->cycle_time) == gcl->start_time)
> +			change = tsnep_cut_gcl(curr, last,
> +					       gcl->start_time - last);
> +		else if (((gcl->start_time - last) <=
> +			  curr->cycle_time_extension) ||
> +			 ((gcl->start_time - last) <= TSNEP_GCL_MIN_INTERVAL))
> +			change = tsnep_extend_gcl(curr, last,
> +						  gcl->start_time - last);
> +		else
> +			change = tsnep_cut_gcl(curr, last,
> +					       gcl->start_time - last);
> +
> +		WARN_ON(change <= timeout);
> +		gcl->change = true;
> +		iowrite32(change & 0xFFFFFFFF, adapter->addr + TSNEP_GC_CHANGE);
> +	} else {
> +		/* start gate control list */
> +		WARN_ON(gcl->start_time <= timeout);
> +		gcl->change = false;
> +		iowrite32(gcl->start_time & 0xFFFFFFFF,
> +			  adapter->addr + TSNEP_GC_TIME);
> +	}
> +
> +	return 0;
> +}
> +
> +static int tsnep_taprio(struct tsnep_adapter *adapter,
> +			struct tc_taprio_qopt_offload *qopt)
> +{
> +	struct tsnep_gcl *gcl;
> +	struct tsnep_gcl *curr;
> +	int retval;
> +
> +	if (!adapter->gate_control)
> +		return -EOPNOTSUPP;
> +
> +	if (!qopt->enable) {
> +		/* disable gate control if active */
> +		mutex_lock(&adapter->gate_control_lock);
> +
> +		if (adapter->gate_control_active) {
> +			iowrite8(TSNEP_GC_DISABLE, adapter->addr + TSNEP_GC);
> +			adapter->gate_control_active = false;
> +		}
> +
> +		mutex_unlock(&adapter->gate_control_lock);
> +
> +		return 0;
> +	}
> +
> +	retval = tsnep_validate_gcl(qopt);
> +	if (retval)
> +		return retval;
> +
> +	mutex_lock(&adapter->gate_control_lock);
> +
> +	gcl = &adapter->gcl[adapter->next_gcl];
> +	tsnep_write_gcl(gcl, qopt);
> +
> +	/* select current gate control list if active */
> +	if (adapter->gate_control_active) {
> +		if (adapter->next_gcl == 0)
> +			curr = &adapter->gcl[1];
> +		else
> +			curr = &adapter->gcl[0];
> +	} else {
> +		curr = NULL;
> +	}
> +
> +	for (;;) {
> +		/* start timeout which discards late enable, this helps ensuring
> +		 * that start/change time are in the future at enable
> +		 */
> +		iowrite8(TSNEP_GC_ENABLE_TIMEOUT, adapter->addr + TSNEP_GC);
> +
> +		retval = tsnep_enable_gcl(adapter, gcl, curr);
> +		if (retval) {
> +			mutex_unlock(&adapter->gate_control_lock);
> +
> +			return retval;
> +		}
> +
> +		/* enable gate control list */
> +		if (adapter->next_gcl == 0)
> +			iowrite8(TSNEP_GC_ENABLE_A, adapter->addr + TSNEP_GC);
> +		else
> +			iowrite8(TSNEP_GC_ENABLE_B, adapter->addr + TSNEP_GC);
> +
> +		/* done if timeout did not happen */
> +		if (!(ioread32(adapter->addr + TSNEP_GC) &
> +		      TSNEP_GC_TIMEOUT_SIGNAL))
> +			break;
> +
> +		/* timeout is acknowledged with any enable */
> +		iowrite8(TSNEP_GC_ENABLE_A, adapter->addr + TSNEP_GC);
> +
> +		if (curr)
> +			tsnep_clean_gcl(curr);
> +
> +		/* retry because of timeout */
> +	}
> +
> +	adapter->gate_control_active = true;
> +
> +	if (adapter->next_gcl == 0)
> +		adapter->next_gcl = 1;
> +	else
> +		adapter->next_gcl = 0;
> +
> +	mutex_unlock(&adapter->gate_control_lock);
> +
> +	return 0;
> +}
> +
> +int tsnep_tc_setup(struct net_device *netdev, enum tc_setup_type type,
> +		   void *type_data)
> +{
> +	struct tsnep_adapter *adapter = netdev_priv(netdev);
> +
> +	switch (type) {
> +	case TC_SETUP_QDISC_TAPRIO:
> +		return tsnep_taprio(adapter, type_data);
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +
> +int tsnep_tc_init(struct tsnep_adapter *adapter)
> +{
> +	if (!adapter->gate_control)
> +		return 0;
> +
> +	/* open all gates */
> +	iowrite8(TSNEP_GC_DISABLE, adapter->addr + TSNEP_GC);
> +	iowrite32(TSNEP_GC_OPEN | TSNEP_GC_NEXT_OPEN, adapter->addr + TSNEP_GC);
> +
> +	adapter->gcl[0].addr = adapter->addr + TSNEP_GCL_A;
> +	adapter->gcl[1].addr = adapter->addr + TSNEP_GCL_B;
> +
> +	return 0;
> +}
> +
> +void tsnep_tc_cleanup(struct tsnep_adapter *adapter)
> +{
> +	if (!adapter->gate_control)
> +		return;
> +
> +	if (adapter->gate_control_active) {
> +		iowrite8(TSNEP_GC_DISABLE, adapter->addr + TSNEP_GC);
> +		adapter->gate_control_active = false;
> +	}
> +}
> diff --git a/drivers/net/ethernet/engleder/tsnep_test.c b/drivers/net/ethernet/engleder/tsnep_test.c
> new file mode 100644
> index 000000000000..1581d6b22232
> --- /dev/null
> +++ b/drivers/net/ethernet/engleder/tsnep_test.c
> @@ -0,0 +1,811 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (C) 2021 Gerhard Engleder <gerhard@engleder-embedded.com> */
> +
> +#include "tsnep.h"
> +
> +#include <net/pkt_sched.h>
> +
> +enum tsnep_test {
> +	TSNEP_TEST_ENABLE = 0,
> +	TSNEP_TEST_TAPRIO,
> +	TSNEP_TEST_TAPRIO_CHANGE,
> +	TSNEP_TEST_TAPRIO_EXTENSION,
> +};
> +
> +static const char tsnep_test_strings[][ETH_GSTRING_LEN] = {
> +	"Enable timeout        (offline)",
> +	"TAPRIO                (offline)",
> +	"TAPRIO change         (offline)",
> +	"TAPRIO extension      (offline)",
> +};
> +
> +#define TSNEP_TEST_COUNT (sizeof(tsnep_test_strings) / ETH_GSTRING_LEN)
> +
> +static bool enable_gc_timeout(struct tsnep_adapter *adapter)
> +{
> +	iowrite8(TSNEP_GC_ENABLE_TIMEOUT, adapter->addr + TSNEP_GC);
> +	if (!(ioread32(adapter->addr + TSNEP_GC) & TSNEP_GC_TIMEOUT_ACTIVE))
> +		return false;
> +
> +	return true;
> +}
> +
> +static bool gc_timeout_signaled(struct tsnep_adapter *adapter)
> +{
> +	if (ioread32(adapter->addr + TSNEP_GC) & TSNEP_GC_TIMEOUT_SIGNAL)
> +		return true;
> +
> +	return false;
> +}
> +
> +static bool ack_gc_timeout(struct tsnep_adapter *adapter)
> +{
> +	iowrite8(TSNEP_GC_ENABLE_TIMEOUT, adapter->addr + TSNEP_GC);
> +	if (ioread32(adapter->addr + TSNEP_GC) &
> +	    (TSNEP_GC_TIMEOUT_ACTIVE | TSNEP_GC_TIMEOUT_SIGNAL))
> +		return false;
> +	return true;
> +}
> +
> +static bool enable_gc(struct tsnep_adapter *adapter, bool a)
> +{
> +	u8 enable;
> +	u8 active;
> +
> +	if (a) {
> +		enable = TSNEP_GC_ENABLE_A;
> +		active = TSNEP_GC_ACTIVE_A;
> +	} else {
> +		enable = TSNEP_GC_ENABLE_B;
> +		active = TSNEP_GC_ACTIVE_B;
> +	}
> +
> +	iowrite8(enable, adapter->addr + TSNEP_GC);
> +	if (!(ioread32(adapter->addr + TSNEP_GC) & active))
> +		return false;
> +
> +	return true;
> +}
> +
> +static bool disable_gc(struct tsnep_adapter *adapter)
> +{
> +	iowrite8(TSNEP_GC_DISABLE, adapter->addr + TSNEP_GC);
> +	if (ioread32(adapter->addr + TSNEP_GC) &
> +	    (TSNEP_GC_ACTIVE_A | TSNEP_GC_ACTIVE_B))
> +		return false;
> +
> +	return true;
> +}
> +
> +static bool gc_delayed_enable(struct tsnep_adapter *adapter, bool a, int delay)
> +{
> +	u64 before, after;
> +	u32 time;
> +	bool enabled;
> +
> +	if (!disable_gc(adapter))
> +		return false;
> +
> +	before = ktime_get_ns();
> +
> +	if (!enable_gc_timeout(adapter))
> +		return false;
> +
> +	/* for start time after timeout, the timeout can guarantee, that enable
> +	 * is blocked if too late
> +	 */
> +	time = ioread32(adapter->addr + ECM_SYSTEM_TIME_LOW);
> +	time += TSNEP_GC_TIMEOUT;
> +	iowrite32(time, adapter->addr + TSNEP_GC_TIME);
> +
> +	ndelay(delay);
> +
> +	enabled = enable_gc(adapter, a);
> +	after = ktime_get_ns();
> +
> +	if (delay > TSNEP_GC_TIMEOUT) {
> +		/* timeout must have blocked enable */
> +		if (enabled)
> +			return false;
> +	} else if ((after - before) < TSNEP_GC_TIMEOUT * 14 / 16) {
> +		/* timeout must not have blocked enable */
> +		if (!enabled)
> +			return false;
> +	}
> +
> +	if (enabled) {
> +		if (gc_timeout_signaled(adapter))
> +			return false;
> +	} else {
> +		if (!gc_timeout_signaled(adapter))
> +			return false;
> +		if (!ack_gc_timeout(adapter))
> +			return false;
> +	}
> +
> +	if (!disable_gc(adapter))
> +		return false;
> +
> +	return true;
> +}
> +
> +static bool tsnep_test_gc_enable(struct tsnep_adapter *adapter)
> +{
> +	int i;
> +
> +	iowrite32(0x80000001, adapter->addr + TSNEP_GCL_A + 0);
> +	iowrite32(100000, adapter->addr + TSNEP_GCL_A + 4);
> +
> +	for (i = 0; i < 200000; i += 100) {
> +		if (!gc_delayed_enable(adapter, true, i))
> +			return false;
> +	}
> +
> +	iowrite32(0x80000001, adapter->addr + TSNEP_GCL_B + 0);
> +	iowrite32(100000, adapter->addr + TSNEP_GCL_B + 4);
> +
> +	for (i = 0; i < 200000; i += 100) {
> +		if (!gc_delayed_enable(adapter, false, i))
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
> +static void delay_base_time(struct tsnep_adapter *adapter,
> +			    struct tc_taprio_qopt_offload *qopt, s64 ms)
> +{
> +	u64 system_time;
> +	u64 base_time = ktime_to_ns(qopt->base_time);
> +	u64 n;
> +
> +	tsnep_get_system_time(adapter, &system_time);
> +	system_time += ms * 1000000;
> +	n = div64_u64(system_time - base_time, qopt->cycle_time);
> +
> +	qopt->base_time = ktime_add_ns(qopt->base_time,
> +				       (n + 1) * qopt->cycle_time);
> +}
> +
> +static void get_gate_state(struct tsnep_adapter *adapter, u32 *gc, u32 *gc_time,
> +			   u64 *system_time)
> +{
> +	u32 time_high_before;
> +	u32 time_low;
> +	u32 time_high;
> +	u32 gc_time_before;
> +
> +	time_high = ioread32(adapter->addr + ECM_SYSTEM_TIME_HIGH);
> +	*gc_time = ioread32(adapter->addr + TSNEP_GC_TIME);
> +	do {
> +		time_low = ioread32(adapter->addr + ECM_SYSTEM_TIME_LOW);
> +		*gc = ioread32(adapter->addr + TSNEP_GC);
> +
> +		gc_time_before = *gc_time;
> +		*gc_time = ioread32(adapter->addr + TSNEP_GC_TIME);
> +		time_high_before = time_high;
> +		time_high = ioread32(adapter->addr + ECM_SYSTEM_TIME_HIGH);
> +	} while ((time_high != time_high_before) ||
> +		 (*gc_time != gc_time_before));
> +
> +	*system_time = (((u64)time_high) << 32) | ((u64)time_low);
> +}
> +
> +static int get_operation(struct tsnep_gcl *gcl, u64 system_time, u64 *next)
> +{
> +	u64 n = div64_u64(system_time - gcl->base_time, gcl->cycle_time);
> +	u64 cycle_start = gcl->base_time + gcl->cycle_time * n;
> +	int i;
> +
> +	*next = cycle_start;
> +	for (i = 0; i < gcl->count; i++) {
> +		*next += gcl->operation[i].interval;
> +		if (*next > system_time)
> +			break;
> +	}
> +
> +	return i;
> +}
> +
> +static bool check_gate(struct tsnep_adapter *adapter)
> +{
> +	u32 gc_time;
> +	u32 gc;
> +	u64 system_time;
> +	struct tsnep_gcl *curr;
> +	struct tsnep_gcl *prev;
> +	u64 next_time;
> +	u8 gate_open;
> +	u8 next_gate_open;
> +
> +	get_gate_state(adapter, &gc, &gc_time, &system_time);
> +
> +	if (gc & TSNEP_GC_ACTIVE_A) {
> +		curr = &adapter->gcl[0];
> +		prev = &adapter->gcl[1];
> +	} else if (gc & TSNEP_GC_ACTIVE_B) {
> +		curr = &adapter->gcl[1];
> +		prev = &adapter->gcl[0];
> +	} else {
> +		return false;
> +	}
> +	if (curr->start_time <= system_time) {
> +		/* GCL is already active */
> +		int index;
> +
> +		index = get_operation(curr, system_time, &next_time);
> +		gate_open = curr->operation[index].properties & TSNEP_GCL_MASK;
> +		if (index == curr->count - 1)
> +			index = 0;
> +		else
> +			index++;
> +		next_gate_open =
> +			curr->operation[index].properties & TSNEP_GCL_MASK;
> +	} else if (curr->change) {
> +		/* operation of previous GCL is active */
> +		int index;
> +		u64 start_before;
> +		u64 n;
> +
> +		index = get_operation(prev, system_time, &next_time);
> +		next_time = curr->start_time;
> +		start_before = prev->base_time;
> +		n = div64_u64(curr->start_time - start_before,
> +			      prev->cycle_time);
> +		start_before += n * prev->cycle_time;
> +		if (curr->start_time == start_before)
> +			start_before -= prev->cycle_time;
> +		if (((start_before + prev->cycle_time_extension) >=
> +		     curr->start_time) &&
> +		    (curr->start_time - prev->cycle_time_extension <=
> +		     system_time)) {
> +			/* extend */
> +			index = prev->count - 1;
> +		}
> +		gate_open = prev->operation[index].properties & TSNEP_GCL_MASK;
> +		next_gate_open =
> +			curr->operation[0].properties & TSNEP_GCL_MASK;
> +	} else {
> +		/* GCL is waiting for start */
> +		next_time = curr->start_time;
> +		gate_open = 0xFF;
> +		next_gate_open = curr->operation[0].properties & TSNEP_GCL_MASK;
> +	}
> +
> +	if (gc_time != (next_time & 0xFFFFFFFF)) {
> +		dev_err(&adapter->pdev->dev, "gate control time 0x%x!=0x%llx\n",
> +			gc_time, next_time);
> +		return false;
> +	}
> +	if (((gc & TSNEP_GC_OPEN) >> TSNEP_GC_OPEN_SHIFT) != gate_open) {
> +		dev_err(&adapter->pdev->dev,
> +			"gate control open 0x%02x!=0x%02x\n",
> +			((gc & TSNEP_GC_OPEN) >> TSNEP_GC_OPEN_SHIFT),
> +			gate_open);
> +		return false;
> +	}
> +	if (((gc & TSNEP_GC_NEXT_OPEN) >> TSNEP_GC_NEXT_OPEN_SHIFT) !=
> +	    next_gate_open) {
> +		dev_err(&adapter->pdev->dev,
> +			"gate control next open 0x%02x!=0x%02x\n",
> +			((gc & TSNEP_GC_NEXT_OPEN) >> TSNEP_GC_NEXT_OPEN_SHIFT),
> +			next_gate_open);
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +static bool check_gate_duration(struct tsnep_adapter *adapter, s64 ms)
> +{
> +	ktime_t start = ktime_get();
> +
> +	do {
> +		if (!check_gate(adapter))
> +			return false;
> +	} while (ktime_ms_delta(ktime_get(), start) < ms);
> +
> +	return true;
> +}
> +
> +static bool enable_check_taprio(struct tsnep_adapter *adapter,
> +				struct tc_taprio_qopt_offload *qopt, s64 ms)
> +{
> +	int retval;
> +
> +	retval = tsnep_tc_setup(adapter->netdev, TC_SETUP_QDISC_TAPRIO, qopt);
> +	if (retval)
> +		return false;
> +
> +	if (!check_gate_duration(adapter, ms))
> +		return false;
> +
> +	return true;
> +}
> +
> +static bool disable_taprio(struct tsnep_adapter *adapter)
> +{
> +	struct tc_taprio_qopt_offload qopt;
> +	int retval;
> +
> +	memset(&qopt, 0, sizeof(qopt));
> +	qopt.enable = 0;
> +	retval = tsnep_tc_setup(adapter->netdev, TC_SETUP_QDISC_TAPRIO, &qopt);
> +	if (retval)
> +		return false;
> +
> +	return true;
> +}
> +
> +static bool run_taprio(struct tsnep_adapter *adapter,
> +		       struct tc_taprio_qopt_offload *qopt, s64 ms)
> +{
> +	if (!enable_check_taprio(adapter, qopt, ms))
> +		return false;
> +
> +	if (!disable_taprio(adapter))
> +		return false;
> +
> +	return true;
> +}
> +
> +static bool tsnep_test_taprio(struct tsnep_adapter *adapter)
> +{
> +	struct tc_taprio_qopt_offload *qopt;
> +	int i;
> +
> +	qopt = kzalloc(struct_size(qopt, entries, 255), GFP_KERNEL);
> +	if (!qopt)
> +		return false;
> +	for (i = 0; i < 255; i++)
> +		qopt->entries[i].command = TC_TAPRIO_CMD_SET_GATES;
> +
> +	qopt->enable = 1;
> +	qopt->base_time = ktime_set(0, 0);
> +	qopt->cycle_time = 1500000;
> +	qopt->cycle_time_extension = 0;
> +	qopt->entries[0].gate_mask = 0x02;
> +	qopt->entries[0].interval = 200000;
> +	qopt->entries[1].gate_mask = 0x03;
> +	qopt->entries[1].interval = 800000;
> +	qopt->entries[2].gate_mask = 0x07;
> +	qopt->entries[2].interval = 240000;
> +	qopt->entries[3].gate_mask = 0x01;
> +	qopt->entries[3].interval = 80000;
> +	qopt->entries[4].gate_mask = 0x04;
> +	qopt->entries[4].interval = 70000;
> +	qopt->entries[5].gate_mask = 0x06;
> +	qopt->entries[5].interval = 60000;
> +	qopt->entries[6].gate_mask = 0x0F;
> +	qopt->entries[6].interval = 50000;
> +	qopt->num_entries = 7;
> +	if (!run_taprio(adapter, qopt, 100))
> +		goto failed;
> +
> +	qopt->enable = 1;
> +	qopt->base_time = ktime_set(0, 0);
> +	qopt->cycle_time = 411854;
> +	qopt->cycle_time_extension = 0;
> +	qopt->entries[0].gate_mask = 0x17;
> +	qopt->entries[0].interval = 23842;
> +	qopt->entries[1].gate_mask = 0x16;
> +	qopt->entries[1].interval = 13482;
> +	qopt->entries[2].gate_mask = 0x15;
> +	qopt->entries[2].interval = 49428;
> +	qopt->entries[3].gate_mask = 0x14;
> +	qopt->entries[3].interval = 38189;
> +	qopt->entries[4].gate_mask = 0x13;
> +	qopt->entries[4].interval = 92321;
> +	qopt->entries[5].gate_mask = 0x12;
> +	qopt->entries[5].interval = 71239;
> +	qopt->entries[6].gate_mask = 0x11;
> +	qopt->entries[6].interval = 69932;
> +	qopt->entries[7].gate_mask = 0x10;
> +	qopt->entries[7].interval = 53421;
> +	qopt->num_entries = 8;
> +	if (!run_taprio(adapter, qopt, 100))
> +		goto failed;
> +
> +	qopt->enable = 1;
> +	qopt->base_time = ktime_set(0, 0);
> +	delay_base_time(adapter, qopt, 12);
> +	qopt->cycle_time = 125000;
> +	qopt->cycle_time_extension = 0;
> +	qopt->entries[0].gate_mask = 0x27;
> +	qopt->entries[0].interval = 15000;
> +	qopt->entries[1].gate_mask = 0x26;
> +	qopt->entries[1].interval = 15000;
> +	qopt->entries[2].gate_mask = 0x25;
> +	qopt->entries[2].interval = 12500;
> +	qopt->entries[3].gate_mask = 0x24;
> +	qopt->entries[3].interval = 17500;
> +	qopt->entries[4].gate_mask = 0x23;
> +	qopt->entries[4].interval = 10000;
> +	qopt->entries[5].gate_mask = 0x22;
> +	qopt->entries[5].interval = 11000;
> +	qopt->entries[6].gate_mask = 0x21;
> +	qopt->entries[6].interval = 9000;
> +	qopt->entries[7].gate_mask = 0x20;
> +	qopt->entries[7].interval = 10000;
> +	qopt->entries[8].gate_mask = 0x20;
> +	qopt->entries[8].interval = 12500;
> +	qopt->entries[9].gate_mask = 0x20;
> +	qopt->entries[9].interval = 12500;
> +	qopt->num_entries = 10;
> +	if (!run_taprio(adapter, qopt, 100))
> +		goto failed;
> +
> +	kfree(qopt);
> +
> +	return true;
> +
> +failed:
> +	disable_taprio(adapter);
> +	kfree(qopt);
> +
> +	return false;
> +}
> +
> +static bool tsnep_test_taprio_change(struct tsnep_adapter *adapter)
> +{
> +	struct tc_taprio_qopt_offload *qopt;
> +	int i;
> +
> +	qopt = kzalloc(struct_size(qopt, entries, 255), GFP_KERNEL);
> +	if (!qopt)
> +		return false;
> +	for (i = 0; i < 255; i++)
> +		qopt->entries[i].command = TC_TAPRIO_CMD_SET_GATES;
> +
> +	qopt->enable = 1;
> +	qopt->base_time = ktime_set(0, 0);
> +	qopt->cycle_time = 100000;
> +	qopt->cycle_time_extension = 0;
> +	qopt->entries[0].gate_mask = 0x30;
> +	qopt->entries[0].interval = 20000;
> +	qopt->entries[1].gate_mask = 0x31;
> +	qopt->entries[1].interval = 80000;
> +	qopt->num_entries = 2;
> +	if (!enable_check_taprio(adapter, qopt, 100))
> +		goto failed;
> +
> +	/* change to identical */
> +	if (!enable_check_taprio(adapter, qopt, 100))
> +		goto failed;
> +	delay_base_time(adapter, qopt, 17);
> +	if (!enable_check_taprio(adapter, qopt, 100))
> +		goto failed;
> +
> +	/* change to same cycle time */
> +	qopt->base_time = ktime_set(0, 0);
> +	qopt->entries[0].gate_mask = 0x42;
> +	qopt->entries[1].gate_mask = 0x43;
> +	delay_base_time(adapter, qopt, 2);
> +	if (!enable_check_taprio(adapter, qopt, 100))
> +		goto failed;
> +	qopt->base_time = ktime_set(0, 0);
> +	qopt->entries[0].gate_mask = 0x54;
> +	qopt->entries[0].interval = 33333;
> +	qopt->entries[1].gate_mask = 0x55;
> +	qopt->entries[1].interval = 66667;
> +	delay_base_time(adapter, qopt, 23);
> +	if (!enable_check_taprio(adapter, qopt, 100))
> +		goto failed;
> +	qopt->base_time = ktime_set(0, 0);
> +	qopt->entries[0].gate_mask = 0x66;
> +	qopt->entries[0].interval = 50000;
> +	qopt->entries[1].gate_mask = 0x67;
> +	qopt->entries[1].interval = 25000;
> +	qopt->entries[2].gate_mask = 0x68;
> +	qopt->entries[2].interval = 25000;
> +	qopt->num_entries = 3;
> +	delay_base_time(adapter, qopt, 11);
> +	if (!enable_check_taprio(adapter, qopt, 100))
> +		goto failed;
> +
> +	/* change to multiple of cycle time */
> +	qopt->base_time = ktime_set(0, 0);
> +	qopt->cycle_time = 200000;
> +	qopt->entries[0].gate_mask = 0x79;
> +	qopt->entries[0].interval = 50000;
> +	qopt->entries[1].gate_mask = 0x7A;
> +	qopt->entries[1].interval = 150000;
> +	qopt->num_entries = 2;
> +	delay_base_time(adapter, qopt, 11);
> +	if (!enable_check_taprio(adapter, qopt, 100))
> +		goto failed;
> +	qopt->base_time = ktime_set(0, 0);
> +	qopt->cycle_time = 1000000;
> +	qopt->entries[0].gate_mask = 0x7B;
> +	qopt->entries[0].interval = 125000;
> +	qopt->entries[1].gate_mask = 0x7C;
> +	qopt->entries[1].interval = 250000;
> +	qopt->entries[2].gate_mask = 0x7D;
> +	qopt->entries[2].interval = 375000;
> +	qopt->entries[3].gate_mask = 0x7E;
> +	qopt->entries[3].interval = 250000;
> +	qopt->num_entries = 4;
> +	delay_base_time(adapter, qopt, 3);
> +	if (!enable_check_taprio(adapter, qopt, 100))
> +		goto failed;
> +
> +	/* change to shorter cycle time */
> +	qopt->base_time = ktime_set(0, 0);
> +	qopt->cycle_time = 333333;
> +	qopt->entries[0].gate_mask = 0x8F;
> +	qopt->entries[0].interval = 166666;
> +	qopt->entries[1].gate_mask = 0x80;
> +	qopt->entries[1].interval = 166667;
> +	qopt->num_entries = 2;
> +	delay_base_time(adapter, qopt, 11);
> +	if (!enable_check_taprio(adapter, qopt, 100))
> +		goto failed;
> +	qopt->base_time = ktime_set(0, 0);
> +	qopt->cycle_time = 62500;
> +	qopt->entries[0].gate_mask = 0x81;
> +	qopt->entries[0].interval = 31250;
> +	qopt->entries[1].gate_mask = 0x82;
> +	qopt->entries[1].interval = 15625;
> +	qopt->entries[2].gate_mask = 0x83;
> +	qopt->entries[2].interval = 15625;
> +	qopt->num_entries = 3;
> +	delay_base_time(adapter, qopt, 1);
> +	if (!enable_check_taprio(adapter, qopt, 100))
> +		goto failed;
> +
> +	/* change to longer cycle time */
> +	qopt->base_time = ktime_set(0, 0);
> +	qopt->cycle_time = 400000;
> +	qopt->entries[0].gate_mask = 0x84;
> +	qopt->entries[0].interval = 100000;
> +	qopt->entries[1].gate_mask = 0x85;
> +	qopt->entries[1].interval = 100000;
> +	qopt->entries[2].gate_mask = 0x86;
> +	qopt->entries[2].interval = 100000;
> +	qopt->entries[3].gate_mask = 0x87;
> +	qopt->entries[3].interval = 100000;
> +	qopt->num_entries = 4;
> +	delay_base_time(adapter, qopt, 7);
> +	if (!enable_check_taprio(adapter, qopt, 100))
> +		goto failed;
> +	qopt->base_time = ktime_set(0, 0);
> +	qopt->cycle_time = 1700000;
> +	qopt->entries[0].gate_mask = 0x88;
> +	qopt->entries[0].interval = 200000;
> +	qopt->entries[1].gate_mask = 0x89;
> +	qopt->entries[1].interval = 300000;
> +	qopt->entries[2].gate_mask = 0x8A;
> +	qopt->entries[2].interval = 600000;
> +	qopt->entries[3].gate_mask = 0x8B;
> +	qopt->entries[3].interval = 100000;
> +	qopt->entries[4].gate_mask = 0x8C;
> +	qopt->entries[4].interval = 500000;
> +	qopt->num_entries = 5;
> +	delay_base_time(adapter, qopt, 6);
> +	if (!enable_check_taprio(adapter, qopt, 100))
> +		goto failed;
> +
> +	if (!disable_taprio(adapter))
> +		goto failed;
> +
> +	kfree(qopt);
> +
> +	return true;
> +
> +failed:
> +	disable_taprio(adapter);
> +	kfree(qopt);
> +
> +	return false;
> +}
> +
> +static bool tsnep_test_taprio_extension(struct tsnep_adapter *adapter)
> +{
> +	struct tc_taprio_qopt_offload *qopt;
> +	int i;
> +
> +	qopt = kzalloc(struct_size(qopt, entries, 255), GFP_KERNEL);
> +	if (!qopt)
> +		return false;
> +	for (i = 0; i < 255; i++)
> +		qopt->entries[i].command = TC_TAPRIO_CMD_SET_GATES;
> +
> +	qopt->enable = 1;
> +	qopt->base_time = ktime_set(0, 0);
> +	qopt->cycle_time = 100000;
> +	qopt->cycle_time_extension = 50000;
> +	qopt->entries[0].gate_mask = 0x90;
> +	qopt->entries[0].interval = 20000;
> +	qopt->entries[1].gate_mask = 0x91;
> +	qopt->entries[1].interval = 80000;
> +	qopt->num_entries = 2;
> +	if (!enable_check_taprio(adapter, qopt, 100))
> +		goto failed;
> +
> +	/* change to different phase */
> +	qopt->base_time = ktime_set(0, 50000);
> +	qopt->entries[0].gate_mask = 0x92;
> +	qopt->entries[0].interval = 33000;
> +	qopt->entries[1].gate_mask = 0x93;
> +	qopt->entries[1].interval = 67000;
> +	qopt->num_entries = 2;
> +	delay_base_time(adapter, qopt, 2);
> +	if (!enable_check_taprio(adapter, qopt, 100))
> +		goto failed;
> +
> +	/* change to different phase and longer cycle time */
> +	qopt->base_time = ktime_set(0, 0);
> +	qopt->cycle_time = 1000000;
> +	qopt->cycle_time_extension = 700000;
> +	qopt->entries[0].gate_mask = 0x94;
> +	qopt->entries[0].interval = 400000;
> +	qopt->entries[1].gate_mask = 0x95;
> +	qopt->entries[1].interval = 600000;
> +	qopt->num_entries = 2;
> +	delay_base_time(adapter, qopt, 7);
> +	if (!enable_check_taprio(adapter, qopt, 100))
> +		goto failed;
> +	qopt->base_time = ktime_set(0, 700000);
> +	qopt->cycle_time = 2000000;
> +	qopt->cycle_time_extension = 1900000;
> +	qopt->entries[0].gate_mask = 0x96;
> +	qopt->entries[0].interval = 400000;
> +	qopt->entries[1].gate_mask = 0x97;
> +	qopt->entries[1].interval = 1600000;
> +	qopt->num_entries = 2;
> +	delay_base_time(adapter, qopt, 9);
> +	if (!enable_check_taprio(adapter, qopt, 100))
> +		goto failed;
> +
> +	/* change to different phase and shorter cycle time */
> +	qopt->base_time = ktime_set(0, 0);
> +	qopt->cycle_time = 1500000;
> +	qopt->cycle_time_extension = 700000;
> +	qopt->entries[0].gate_mask = 0x98;
> +	qopt->entries[0].interval = 400000;
> +	qopt->entries[1].gate_mask = 0x99;
> +	qopt->entries[1].interval = 600000;
> +	qopt->entries[2].gate_mask = 0x9A;
> +	qopt->entries[2].interval = 500000;
> +	qopt->num_entries = 3;
> +	delay_base_time(adapter, qopt, 3);
> +	if (!enable_check_taprio(adapter, qopt, 100))
> +		goto failed;
> +	qopt->base_time = ktime_set(0, 100000);
> +	qopt->cycle_time = 500000;
> +	qopt->cycle_time_extension = 300000;
> +	qopt->entries[0].gate_mask = 0x9B;
> +	qopt->entries[0].interval = 150000;
> +	qopt->entries[1].gate_mask = 0x9C;
> +	qopt->entries[1].interval = 350000;
> +	qopt->num_entries = 2;
> +	delay_base_time(adapter, qopt, 9);
> +	if (!enable_check_taprio(adapter, qopt, 100))
> +		goto failed;
> +
> +	/* change to different cycle time */
> +	qopt->base_time = ktime_set(0, 0);
> +	qopt->cycle_time = 1000000;
> +	qopt->cycle_time_extension = 700000;
> +	qopt->entries[0].gate_mask = 0xAD;
> +	qopt->entries[0].interval = 400000;
> +	qopt->entries[1].gate_mask = 0xAE;
> +	qopt->entries[1].interval = 300000;
> +	qopt->entries[2].gate_mask = 0xAF;
> +	qopt->entries[2].interval = 300000;
> +	qopt->num_entries = 3;
> +	if (!enable_check_taprio(adapter, qopt, 100))
> +		goto failed;
> +	qopt->base_time = ktime_set(0, 0);
> +	qopt->cycle_time = 400000;
> +	qopt->cycle_time_extension = 100000;
> +	qopt->entries[0].gate_mask = 0xA0;
> +	qopt->entries[0].interval = 200000;
> +	qopt->entries[1].gate_mask = 0xA1;
> +	qopt->entries[1].interval = 200000;
> +	qopt->num_entries = 2;
> +	delay_base_time(adapter, qopt, 19);
> +	if (!enable_check_taprio(adapter, qopt, 100))
> +		goto failed;
> +	qopt->base_time = ktime_set(0, 0);
> +	qopt->cycle_time = 500000;
> +	qopt->cycle_time_extension = 499999;
> +	qopt->entries[0].gate_mask = 0xB2;
> +	qopt->entries[0].interval = 100000;
> +	qopt->entries[1].gate_mask = 0xB3;
> +	qopt->entries[1].interval = 100000;
> +	qopt->entries[2].gate_mask = 0xB4;
> +	qopt->entries[2].interval = 100000;
> +	qopt->entries[3].gate_mask = 0xB5;
> +	qopt->entries[3].interval = 200000;
> +	qopt->num_entries = 4;
> +	delay_base_time(adapter, qopt, 19);
> +	if (!enable_check_taprio(adapter, qopt, 100))
> +		goto failed;
> +	qopt->base_time = ktime_set(0, 0);
> +	qopt->cycle_time = 6000000;
> +	qopt->cycle_time_extension = 5999999;
> +	qopt->entries[0].gate_mask = 0xC6;
> +	qopt->entries[0].interval = 1000000;
> +	qopt->entries[1].gate_mask = 0xC7;
> +	qopt->entries[1].interval = 1000000;
> +	qopt->entries[2].gate_mask = 0xC8;
> +	qopt->entries[2].interval = 1000000;
> +	qopt->entries[3].gate_mask = 0xC9;
> +	qopt->entries[3].interval = 1500000;
> +	qopt->entries[4].gate_mask = 0xCA;
> +	qopt->entries[4].interval = 1500000;
> +	qopt->num_entries = 5;
> +	delay_base_time(adapter, qopt, 1);
> +	if (!enable_check_taprio(adapter, qopt, 100))
> +		goto failed;
> +
> +	if (!disable_taprio(adapter))
> +		goto failed;
> +
> +	kfree(qopt);
> +
> +	return true;
> +
> +failed:
> +	disable_taprio(adapter);
> +	kfree(qopt);
> +
> +	return false;
> +}
> +
> +int tsnep_ethtool_get_test_count(void)
> +{
> +	return TSNEP_TEST_COUNT;
> +}
> +
> +void tsnep_ethtool_get_test_strings(u8 *data)
> +{
> +	memcpy(data, tsnep_test_strings, sizeof(tsnep_test_strings));
> +}
> +
> +void tsnep_ethtool_self_test(struct net_device *netdev,
> +			     struct ethtool_test *eth_test, u64 *data)
> +{
> +	struct tsnep_adapter *adapter = netdev_priv(netdev);
> +
> +	eth_test->len = TSNEP_TEST_COUNT;
> +
> +	if (eth_test->flags != ETH_TEST_FL_OFFLINE) {
> +		/* no tests are done online */
> +		data[TSNEP_TEST_ENABLE] = 0;
> +		data[TSNEP_TEST_TAPRIO] = 0;
> +		data[TSNEP_TEST_TAPRIO_CHANGE] = 0;
> +		data[TSNEP_TEST_TAPRIO_EXTENSION] = 0;
> +
> +		return;
> +	}
> +
> +	if (tsnep_test_gc_enable(adapter)) {
> +		data[TSNEP_TEST_ENABLE] = 0;
> +	} else {
> +		eth_test->flags |= ETH_TEST_FL_FAILED;
> +		data[TSNEP_TEST_ENABLE] = 1;
> +	}
> +
> +	if (tsnep_test_taprio(adapter)) {
> +		data[TSNEP_TEST_TAPRIO] = 0;
> +	} else {
> +		eth_test->flags |= ETH_TEST_FL_FAILED;
> +		data[TSNEP_TEST_TAPRIO] = 1;
> +	}
> +
> +	if (tsnep_test_taprio_change(adapter)) {
> +		data[TSNEP_TEST_TAPRIO_CHANGE] = 0;
> +	} else {
> +		eth_test->flags |= ETH_TEST_FL_FAILED;
> +		data[TSNEP_TEST_TAPRIO_CHANGE] = 1;
> +	}
> +
> +	if (tsnep_test_taprio_extension(adapter)) {
> +		data[TSNEP_TEST_TAPRIO_EXTENSION] = 0;
> +	} else {
> +		eth_test->flags |= ETH_TEST_FL_FAILED;
> +		data[TSNEP_TEST_TAPRIO_EXTENSION] = 1;
> +	}
> +}

I liked these tests :-)


Cheers,
-- 
Vinicius
