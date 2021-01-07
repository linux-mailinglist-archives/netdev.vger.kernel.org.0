Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886762EE696
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 21:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbhAGUMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 15:12:05 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55736 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726864AbhAGUMF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 15:12:05 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kxbcv-00Gjvd-G3; Thu, 07 Jan 2021 21:11:21 +0100
Date:   Thu, 7 Jan 2021 21:11:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     M Chetan Kumar <m.chetan.kumar@intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        johannes@sipsolutions.net, krishna.c.sudi@intel.com
Subject: Re: [PATCH 16/18] net: iosm: net driver
Message-ID: <X/dq6WFBBEbp6xkq@lunn.ch>
References: <20210107170523.26531-1-m.chetan.kumar@intel.com>
 <20210107170523.26531-17-m.chetan.kumar@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107170523.26531-17-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int ipc_wwan_add_vlan(struct iosm_wwan *ipc_wwan, u16 vid)
> +{
> +	if (vid >= 512 || !ipc_wwan->vlan_devs)
> +		return -EINVAL;
> +
> +	if (vid == WWAN_ROOT_VLAN_TAG)
> +		return 0;
> +
> +	mutex_lock(&ipc_wwan->if_mutex);
> +
> +	/* get channel id */
> +	ipc_wwan->vlan_devs[ipc_wwan->vlan_devs_nr].ch_id =
> +		imem_sys_wwan_open(ipc_wwan->ops_instance, vid);
> +
> +	if (ipc_wwan->vlan_devs[ipc_wwan->vlan_devs_nr].ch_id < 0) {
> +		dev_err(ipc_wwan->dev,
> +			"cannot connect wwan0 & id %d to the IPC mem layer",
> +			vid);

Since this is a network interface, you should be using netdev_err(),
netdev_dbg() etc.

> +static int ipc_wwan_open(struct net_device *netdev)
> +{
> +	/* Octets in one ethernet addr */
> +	if (netdev->addr_len < ETH_ALEN) {
> +		pr_err("cannot build the Ethernet address for \"%s\"",
> +		       netdev->name);

checkpatch should of warned about pr_err().

Also, it seems odd you have got as far as open() without a MAC
address. You normally sort this out in probe().

> +int ipc_wwan_receive(struct iosm_wwan *ipc_wwan, struct sk_buff *skb_arg,
> +		     bool dss)
> +{
> +	struct sk_buff *skb = skb_arg;
> +	struct ethhdr *eth = (struct ethhdr *)skb->data;
> +	u16 tag;

Reverse christmas tree.

> +
> +	if (unlikely(!eth)) {
> +		dev_err(ipc_wwan->dev, "ethernet header info error");
> +		dev_kfree_skb(skb);
> +		return -1;
> +	}
> +
> +	ether_addr_copy(eth->h_dest, ipc_wwan->netdev->dev_addr);
> +	ether_addr_copy(eth->h_source, ipc_wwan->netdev->dev_addr);
> +	eth->h_source[ETH_ALEN - 1] ^= 0x01; /* src is us xor 1 */

You are receiving frames without a valid Ethernet header?

> +	/* set the ethernet payload type: ipv4 or ipv6 or Dummy type
> +	 * for 802.3 frames
> +	 */
> +	eth->h_proto = htons(ETH_P_802_3);

And without a valid ether type?

> +	if (!dss) {
> +		if ((skb->data[ETH_HLEN] & 0xF0) == 0x40)
> +			eth->h_proto = htons(ETH_P_IP);
> +		else if ((skb->data[ETH_HLEN] & 0xF0) == 0x60)
> +			eth->h_proto = htons(ETH_P_IPV6);
> +	}

Is this really looking at the first byte after the Ethernet header? If
it finds a 4 it must be IPv4 and a 6 means IPv6?

> +/* Transmit a packet (called by the kernel) */
> +static int ipc_wwan_transmit(struct sk_buff *skb, struct net_device *netdev)
> +{
> +	struct iosm_wwan *ipc_wwan = netdev_priv(netdev);
> +	bool is_ip = false;
> +	int ret = -EINVAL;
> +	int header_size;
> +	int idx = 0;
> +	u16 tag = 0;
> +
> +	vlan_get_tag(skb, &tag);
> +
> +	/* If the SKB is of WWAN root device then don't send it to device.
> +	 * Free the SKB and then return.
> +	 */
> +	if (unlikely(tag == WWAN_ROOT_VLAN_TAG))
> +		goto exit;
> +
> +	/* Discard the Ethernet header or VLAN Ethernet header depending
> +	 * on the protocol.
> +	 */

O.K. I have to ask. If this thing does not use an Ethernet header, why
are you writing an Ethernet driver? I assume you also don't use ARP?

It seems a driver more like slip, plip, hdlc, etc would be more
appropriate.

> +static int ipc_wwan_change_mtu(struct net_device *dev, int new_mtu)
> +{
> +	struct iosm_wwan *ipc_wwan = netdev_priv(dev);
> +	unsigned long flags = 0;
> +
> +	if (unlikely(new_mtu < IPC_MEM_MIN_MTU_SIZE ||
> +		     new_mtu > IPC_MEM_MAX_MTU_SIZE)) {

If you set netdev->min_mtu and max_mtu, the core will do this for you.

> +		dev_err(ipc_wwan->dev, "mtu %d out of range %d..%d", new_mtu,
> +			IPC_MEM_MIN_MTU_SIZE, IPC_MEM_MAX_MTU_SIZE);
> +		return -EINVAL;
> +	}
> +
> +	spin_lock_irqsave(&ipc_wwan->lock, flags);
> +	dev->mtu = new_mtu;
> +	spin_unlock_irqrestore(&ipc_wwan->lock, flags);
> +	return 0;
> +}
> +
> +static int ipc_wwan_change_mac_addr(struct net_device *dev, void *sock_addr)
> +{
> +	struct iosm_wwan *ipc_wwan = netdev_priv(dev);
> +	struct sockaddr *addr = sock_addr;
> +	unsigned long flags = 0;
> +	int result = 0;
> +	u8 *sock_data;
> +
> +	sock_data = (u8 *)addr->sa_data;
> +
> +	spin_lock_irqsave(&ipc_wwan->lock, flags);
> +
> +	if (is_zero_ether_addr(sock_data)) {
> +		dev->addr_len = 1;
> +		memset(dev->dev_addr, 0, 6);
> +		goto exit;
> +	}

It appears you don't have an Ethernet header on the frames. So why do
you need a MAC address?

> +static int ipc_wwan_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
> +{
> +	if (cmd != SIOCSIFHWADDR ||
> +	    !access_ok((void __user *)ifr, sizeof(struct ifreq)) ||
> +	    dev->addr_len > sizeof(struct sockaddr))
> +		return -EINVAL;
> +
> +	return ipc_wwan_change_mac_addr(dev, &ifr->ifr_hwaddr);
> +}

Why not use ndo_set_mac_address() and let the core handle this ioctl?

    Andrew
