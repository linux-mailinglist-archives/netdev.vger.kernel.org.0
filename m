Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB6FF88320
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 21:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407357AbfHITFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 15:05:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48640 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726377AbfHITFJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 15:05:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yT9TTYBbUJ1kqIjfr4bG19UrlJGhnjWwwhQsTiNMy3Y=; b=aAH7bmxwrsr5Gw8T8rwqpJiD7M
        VkpciKjluC5GMjAV3bU9D9OkPZd54dkgMLGHnOYYOhBO4oQNfzL78kPi6PpvS/iAukTtz/6aahaX1
        W5iupEH8xqk41A1V0bXE1d651MvrIEY113OmICAIbNDJw9CJNsLQ4SZ6H54Dfm4mFBAE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hwACB-0003uR-Em; Fri, 09 Aug 2019 21:04:59 +0200
Date:   Fri, 9 Aug 2019 21:04:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        f.fainelli@gmail.com, ruxandra.radulescu@nxp.com
Subject: Re: [PATCH] dpaa2-ethsw: move the DPAA2 Ethernet Switch driver out
 of staging
Message-ID: <20190809190459.GW27917@lunn.ch>
References: <1565366213-20063-1-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1565366213-20063-1-git-send-email-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ioana

> +static int
> +ethsw_get_link_ksettings(struct net_device *netdev,
> +			 struct ethtool_link_ksettings *link_ksettings)
> +{
> +	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
> +	struct dpsw_link_state state = {0};
> +	int err = 0;
> +
> +	err = dpsw_if_get_link_state(port_priv->ethsw_data->mc_io, 0,
> +				     port_priv->ethsw_data->dpsw_handle,
> +				     port_priv->idx,
> +				     &state);
> +	if (err) {
> +		netdev_err(netdev, "ERROR %d getting link state", err);
> +		goto out;
> +	}
> +
> +	/* At the moment, we have no way of interrogating the DPMAC
> +	 * from the DPSW side or there may not exist a DPMAC at all.

What use is a switch port without a MAC?

> +	 * Report only autoneg state, duplexity and speed.
> +	 */
> +	if (state.options & DPSW_LINK_OPT_AUTONEG)
> +		link_ksettings->base.autoneg = AUTONEG_ENABLE;
> +	if (!(state.options & DPSW_LINK_OPT_HALF_DUPLEX))
> +		link_ksettings->base.duplex = DUPLEX_FULL;
> +	link_ksettings->base.speed = state.rate;
> +
> +out:
> +	return err;
> +}
> +
> +static int
> +ethsw_set_link_ksettings(struct net_device *netdev,
> +			 const struct ethtool_link_ksettings *link_ksettings)
> +{
> +	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
> +	struct dpsw_link_cfg cfg = {0};
> +	int err = 0;
> +
> +	netdev_dbg(netdev, "Setting link parameters...");
> +
> +	/* Due to a temporary MC limitation, the DPSW port must be down
> +	 * in order to be able to change link settings. Taking steps to let
> +	 * the user know that.
> +	 */
> +	if (netif_running(netdev)) {
> +		netdev_info(netdev, "Sorry, interface must be brought down first.\n");
> +		return -EACCES;
> +	}

This is quite common. The Marvell switches require the port is
disabled while reconfiguring the port. So we just disable it,
reconfigure it, and enable it again.

Why are you making the user do this?

> +
> +	cfg.rate = link_ksettings->base.speed;
> +	if (link_ksettings->base.autoneg == AUTONEG_ENABLE)
> +		cfg.options |= DPSW_LINK_OPT_AUTONEG;
> +	else
> +		cfg.options &= ~DPSW_LINK_OPT_AUTONEG;
> +	if (link_ksettings->base.duplex  == DUPLEX_HALF)
> +		cfg.options |= DPSW_LINK_OPT_HALF_DUPLEX;
> +	else
> +		cfg.options &= ~DPSW_LINK_OPT_HALF_DUPLEX;
> +
> +	err = dpsw_if_set_link_cfg(port_priv->ethsw_data->mc_io, 0,
> +				   port_priv->ethsw_data->dpsw_handle,
> +				   port_priv->idx,
> +				   &cfg);
> +	if (err)
> +		/* ethtool will be loud enough if we return an error; no point
> +		 * in putting our own error message on the console by default
> +		 */
> +		netdev_dbg(netdev, "ERROR %d setting link cfg", err);

Why even bother with a dbg message?

> +static void ethsw_ethtool_get_stats(struct net_device *netdev,
> +				    struct ethtool_stats *stats,
> +				    u64 *data)
> +{
> +	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
> +	int i, err;
> +
> +	memset(data, 0,
> +	       sizeof(u64) * ETHSW_NUM_COUNTERS);

Is this really needed? It seems like the core should be doing this?

> +static int ethsw_add_vlan(struct ethsw_core *ethsw, u16 vid)
> +{
> +	int err;
> +
> +	struct dpsw_vlan_cfg	vcfg = {
> +		.fdb_id = 0,
> +	};
> +
> +	if (ethsw->vlans[vid]) {
> +		dev_err(ethsw->dev, "VLAN already configured\n");
> +		return -EEXIST;
> +	}

Can this happen? It seems like the core should be preventing this.

> +
> +	err = dpsw_vlan_add(ethsw->mc_io, 0,
> +			    ethsw->dpsw_handle, vid, &vcfg);
> +	if (err) {
> +		dev_err(ethsw->dev, "dpsw_vlan_add err %d\n", err);
> +		return err;
> +	}
> +	ethsw->vlans[vid] = ETHSW_VLAN_MEMBER;
> +
> +	return 0;
> +}
> +
> +static int ethsw_port_set_pvid(struct ethsw_port_priv *port_priv, u16 pvid)
> +{
> +	struct ethsw_core *ethsw = port_priv->ethsw_data;
> +	struct net_device *netdev = port_priv->netdev;
> +	struct dpsw_tci_cfg tci_cfg = { 0 };
> +	bool is_oper;
> +	int err, ret;
> +
> +	err = dpsw_if_get_tci(ethsw->mc_io, 0, ethsw->dpsw_handle,
> +			      port_priv->idx, &tci_cfg);
> +	if (err) {
> +		netdev_err(netdev, "dpsw_if_get_tci err %d\n", err);
> +		return err;
> +	}
> +
> +	tci_cfg.vlan_id = pvid;
> +
> +	/* Interface needs to be down to change PVID */
> +	is_oper = netif_oper_up(netdev);
> +	if (is_oper) {
> +		err = dpsw_if_disable(ethsw->mc_io, 0,
> +				      ethsw->dpsw_handle,
> +				      port_priv->idx);
> +		if (err) {
> +			netdev_err(netdev, "dpsw_if_disable err %d\n", err);
> +			return err;
> +		}
> +	}

Is this not inconsistent with ethsw_set_link_ksettings()?

> +
> +	err = dpsw_if_set_tci(ethsw->mc_io, 0, ethsw->dpsw_handle,
> +			      port_priv->idx, &tci_cfg);
> +	if (err) {
> +		netdev_err(netdev, "dpsw_if_set_tci err %d\n", err);
> +		goto set_tci_error;
> +	}
> +
> +	/* Delete previous PVID info and mark the new one */
> +	port_priv->vlans[port_priv->pvid] &= ~ETHSW_VLAN_PVID;
> +	port_priv->vlans[pvid] |= ETHSW_VLAN_PVID;
> +	port_priv->pvid = pvid;
> +
> +set_tci_error:
> +	if (is_oper) {
> +		ret = dpsw_if_enable(ethsw->mc_io, 0,
> +				     ethsw->dpsw_handle,
> +				     port_priv->idx);
> +		if (ret) {
> +			netdev_err(netdev, "dpsw_if_enable err %d\n", ret);
> +			return ret;
> +		}
> +	}
> +
> +	return err;
> +}
> +
> +static int ethsw_set_learning(struct ethsw_core *ethsw, u8 flag)
> +{

Seems like a bool would be better than u8 for flag. An call it enable?

> +	enum dpsw_fdb_learning_mode learn_mode;
> +	int err;
> +
> +	if (flag)
> +		learn_mode = DPSW_FDB_LEARNING_MODE_HW;
> +	else
> +		learn_mode = DPSW_FDB_LEARNING_MODE_DIS;
> +
> +	err = dpsw_fdb_set_learning_mode(ethsw->mc_io, 0, ethsw->dpsw_handle, 0,
> +					 learn_mode);
> +	if (err) {
> +		dev_err(ethsw->dev, "dpsw_fdb_set_learning_mode err %d\n", err);
> +		return err;
> +	}
> +	ethsw->learning = !!flag;
> +
> +	return 0;
> +}
> +
> +static int ethsw_port_set_flood(struct ethsw_port_priv *port_priv, u8 flag)
> +{

Another bool?

> +static int port_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
> +			struct net_device *dev, const unsigned char *addr,
> +			u16 vid, u16 flags,
> +			struct netlink_ext_ack *extack)
> +{
> +	if (is_unicast_ether_addr(addr))
> +		return ethsw_port_fdb_add_uc(netdev_priv(dev),
> +					     addr);
> +	else
> +		return ethsw_port_fdb_add_mc(netdev_priv(dev),
> +					     addr);

Do you need to do anything special with link local MAC addresses?
Often they are considered as UC addresses.

> +static int port_carrier_state_sync(struct net_device *netdev)
> +{
> +	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
> +	struct dpsw_link_state state;
> +	int err;
> +
> +	err = dpsw_if_get_link_state(port_priv->ethsw_data->mc_io, 0,
> +				     port_priv->ethsw_data->dpsw_handle,
> +				     port_priv->idx, &state);
> +	if (err) {
> +		netdev_err(netdev, "dpsw_if_get_link_state() err %d\n", err);
> +		return err;
> +	}
> +
> +	WARN_ONCE(state.up > 1, "Garbage read into link_state");
> +
> +	if (state.up != port_priv->link_state) {
> +		if (state.up)
> +			netif_carrier_on(netdev);
> +		else
> +			netif_carrier_off(netdev);
> +		port_priv->link_state = state.up;
> +	}
> +	return 0;
> +}
> +
> +static int port_open(struct net_device *netdev)
> +{
> +	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
> +	int err;
> +
> +	/* No need to allow Tx as control interface is disabled */
> +	netif_tx_stop_all_queues(netdev);
> +
> +	err = dpsw_if_enable(port_priv->ethsw_data->mc_io, 0,
> +			     port_priv->ethsw_data->dpsw_handle,
> +			     port_priv->idx);
> +	if (err) {
> +		netdev_err(netdev, "dpsw_if_enable err %d\n", err);
> +		return err;
> +	}
> +
> +	/* sync carrier state */
> +	err = port_carrier_state_sync(netdev);
> +	if (err) {
> +		netdev_err(netdev,`<
> +			   "port_carrier_state_sync err %d\n", err);

port_carrier_state_sync() already does a netdev_err(). There are a lot
of netdev_err() in this code. I wonder how many are really needed? And
how often you get a cascade of error message like this?

I think many of them can be downgraded to netdev_dbg(), or removed.

> +		goto err_carrier_sync;
> +	}
> +
> +	return 0;
> +
> +err_carrier_sync:
> +	dpsw_if_disable(port_priv->ethsw_data->mc_io, 0,
> +			port_priv->ethsw_data->dpsw_handle,
> +			port_priv->idx);
> +	return err;
> +}
> +
> +static int port_stop(struct net_device *netdev)
> +{
> +	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
> +	int err;
> +
> +	err = dpsw_if_disable(port_priv->ethsw_data->mc_io, 0,
> +			      port_priv->ethsw_data->dpsw_handle,
> +			      port_priv->idx);
> +	if (err) {
> +		netdev_err(netdev, "dpsw_if_disable err %d\n", err);
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
> +static netdev_tx_t port_dropframe(struct sk_buff *skb,
> +				  struct net_device *netdev)
> +{
> +	/* we don't support I/O for now, drop the frame */
> +	dev_kfree_skb_any(skb);
> +

Ah. Does this also mean it cannot receive?

That makes some of this code pointless and untested.

I'm not sure we would be willing to move this out of staging until it
can transmit and receive. The whole idea is that switch ports are just
linux interfaces. Some actions can be accelerated using hardware, and
what cannot be accelerated the network stack does. However, if you
cannot receive and transmit, you break that whole model. The network
stack is mostly pointless.

> +static void ethsw_links_state_update(struct ethsw_core *ethsw)
> +{
> +	int i;
> +
> +	for (i = 0; i < ethsw->sw_attr.num_ifs; i++)
> +		port_carrier_state_sync(ethsw->ports[i]->netdev);
> +}
> +
> +static irqreturn_t ethsw_irq0_handler_thread(int irq_num, void *arg)
> +{
> +	struct device *dev = (struct device *)arg;
> +	struct ethsw_core *ethsw = dev_get_drvdata(dev);
> +
> +	/* Mask the events and the if_id reserved bits to be cleared on read */
> +	u32 status = DPSW_IRQ_EVENT_LINK_CHANGED | 0xFFFF0000;
> +	int err;
> +
> +	err = dpsw_get_irq_status(ethsw->mc_io, 0, ethsw->dpsw_handle,
> +				  DPSW_IRQ_INDEX_IF, &status);
> +	if (err) {
> +		dev_err(dev, "Can't get irq status (err %d)", err);
> +
> +		err = dpsw_clear_irq_status(ethsw->mc_io, 0, ethsw->dpsw_handle,
> +					    DPSW_IRQ_INDEX_IF, 0xFFFFFFFF);
> +		if (err)
> +			dev_err(dev, "Can't clear irq status (err %d)", err);
> +		goto out;
> +	}
> +
> +	if (status & DPSW_IRQ_EVENT_LINK_CHANGED)
> +		ethsw_links_state_update(ethsw);

So there are no per-port events? You have no idea which port went
up/down, you have to poll them all?

> +
> +out:
> +	return IRQ_HANDLED;
> +}
> +
> +static int port_lookup_address(struct net_device *netdev, int is_uc,
> +			       const unsigned char *addr)
> +{
> +	struct netdev_hw_addr_list *list = (is_uc) ? &netdev->uc : &netdev->mc;
> +	struct netdev_hw_addr *ha;
> +
> +	netif_addr_lock_bh(netdev);
> +	list_for_each_entry(ha, &list->list, list) {
> +		if (ether_addr_equal(ha->addr, addr)) {
> +			netif_addr_unlock_bh(netdev);
> +			return 1;
> +		}
> +	}
> +	netif_addr_unlock_bh(netdev);
> +	return 0;

I know i have shot myself in the foot a few times with this structure
of returning in the middle of a loop while holding a lock, forgetting
to unlock, and then later deadlocking. I always do something like:

	ret = 0;
	netif_addr_lock_bh(netdev);
	list_for_each_entry(ha, &list->list, list) {
		if (ether_addr_equal(ha->addr, addr)) {
			ret = 1;
			break;
		}
	}
	netif_addr_unlock_bh(netdev);

	return ret;
}

Also, this function should probably return a bool, not int.

> +}
> +
> +static int port_mdb_add(struct net_device *netdev,
> +			const struct switchdev_obj_port_mdb *mdb,
> +			struct switchdev_trans *trans)
> +{
> +	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
> +	int err;
> +
> +	if (switchdev_trans_ph_prepare(trans))
> +		return 0;
> +
> +	/* Check if address is already set on this port */
> +	if (port_lookup_address(netdev, 0, mdb->addr))
> +		return -EEXIST;

You are looking at core data structures to determine if the address is
already on the port. Is it possible for the core to ask you to add
this address, if the core has the information needed to determine
itself if the port already has the address.

This seems to be a general theme in this code. You don't trust the
core. If you have real examples of the core doing the wrong thing,
please point them out.

> +/* For the moment, only flood setting needs to be updated */
> +static int port_bridge_join(struct net_device *netdev,
> +			    struct net_device *upper_dev)
> +{
> +	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
> +	struct ethsw_core *ethsw = port_priv->ethsw_data;
> +	int i, err;
> +
> +	for (i = 0; i < ethsw->sw_attr.num_ifs; i++)
> +		if (ethsw->ports[i]->bridge_dev &&
> +		    (ethsw->ports[i]->bridge_dev != upper_dev)) {
> +			netdev_err(netdev,
> +				   "Another switch port is connected to %s\n",
> +				   ethsw->ports[i]->bridge_dev->name);
> +			return -EINVAL;
> +		}

Am i reading this correct? You only support a single bridge?  The
error message is not very informative. Also, i think you should be
returning EOPNOTSUPP, indicating the offload is not possible. Linux
will then do it in software. If it could actually receive/transmit the
frames....

> +static int ethsw_open(struct ethsw_core *ethsw)
> +{
> +	struct ethsw_port_priv *port_priv = NULL;
> +	int i, err;
> +
> +	err = dpsw_enable(ethsw->mc_io, 0, ethsw->dpsw_handle);
> +	if (err) {
> +		dev_err(ethsw->dev, "dpsw_enable err %d\n", err);
> +		return err;
> +	}
> +
> +	for (i = 0; i < ethsw->sw_attr.num_ifs; i++) {
> +		port_priv = ethsw->ports[i];
> +		err = dev_open(port_priv->netdev, NULL);
> +		if (err) {
> +			netdev_err(port_priv->netdev, "dev_open err %d\n", err);
> +			return err;
> +		}
> +	}

Why is this needed? When the user configures the interface up, won't
the core call dev_open()?

> +
> +	return 0;
> +}
> +
> +static int ethsw_stop(struct ethsw_core *ethsw)
> +{
> +	struct ethsw_port_priv *port_priv = NULL;
> +	int i, err;
> +
> +	for (i = 0; i < ethsw->sw_attr.num_ifs; i++) {
> +		port_priv = ethsw->ports[i];
> +		dev_close(port_priv->netdev);
> +	}
> +
> +	err = dpsw_disable(ethsw->mc_io, 0, ethsw->dpsw_handle);
> +	if (err) {
> +		dev_err(ethsw->dev, "dpsw_disable err %d\n", err);
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
> +static int ethsw_init(struct fsl_mc_device *sw_dev)
> +{
> +	stp_cfg.vlan_id = DEFAULT_VLAN_ID;
> +	stp_cfg.state = DPSW_STP_STATE_FORWARDING;
> +
> +	for (i = 0; i < ethsw->sw_attr.num_ifs; i++) {
> +		err = dpsw_if_set_stp(ethsw->mc_io, 0, ethsw->dpsw_handle, i,
> +				      &stp_cfg);

Maybe you should actually configure the STP state to blocked? You can
move it to forwarding when the interface is opened.

> +static int ethsw_port_init(struct ethsw_port_priv *port_priv, u16 port)
> +{
> +	const char def_mcast[ETH_ALEN] = {0x01, 0x00, 0x5e, 0x00, 0x00, 0x01};

There should be some explanation about what the MAC address is, and
why it needs adding.

> +static int ethsw_probe_port(struct ethsw_core *ethsw, u16 port_idx)
> +{
> +	struct ethsw_port_priv *port_priv;
> +	struct device *dev = ethsw->dev;
> +	struct net_device *port_netdev;
> +	int err;
> +
> +	port_netdev = alloc_etherdev(sizeof(struct ethsw_port_priv));
> +	if (!port_netdev) {
> +		dev_err(dev, "alloc_etherdev error\n");
> +		return -ENOMEM;
> +	}
> +
> +	port_priv = netdev_priv(port_netdev);
> +	port_priv->netdev = port_netdev;
> +	port_priv->ethsw_data = ethsw;
> +
> +	port_priv->idx = port_idx;
> +	port_priv->stp_state = BR_STATE_FORWARDING;
> +
> +	/* Flooding is implicitly enabled */
> +	port_priv->flood = true;
> +
> +	SET_NETDEV_DEV(port_netdev, dev);
> +	port_netdev->netdev_ops = &ethsw_port_ops;
> +	port_netdev->ethtool_ops = &ethsw_port_ethtool_ops;
> +
> +	/* Set MTU limits */
> +	port_netdev->min_mtu = ETH_MIN_MTU;
> +	port_netdev->max_mtu = ETHSW_MAX_FRAME_LENGTH;
> +
> +	err = register_netdev(port_netdev);
> +	if (err < 0) {
> +		dev_err(dev, "register_netdev error %d\n", err);
> +		goto err_register_netdev;
> +	}

At this point, the interface if live.

> +
> +	ethsw->ports[port_idx] = port_priv;
> +
> +	err = ethsw_port_init(port_priv, port_idx);
> +	if (err)
> +		goto err_ethsw_port_init;

What would happen if the interface was asked to do something before
these two happen? You should only call register_netdev() when you
really are ready to go.

> +static int ethsw_probe(struct fsl_mc_device *sw_dev)
> +{
> +
> +	/* Switch starts up enabled */
> +	rtnl_lock();
> +	err = ethsw_open(ethsw);
> +	rtnl_unlock();

What exactly do you mean by that?

     Andrew
