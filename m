Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCCE24C63D
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 21:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgHTTZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 15:25:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:34408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726702AbgHTTZR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 15:25:17 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D4F5207BB;
        Thu, 20 Aug 2020 19:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597951516;
        bh=V1aWMg+xtiMStjO4PPnYgGhTjG+MOKqJVN3GZijnzxs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WnYMnWeMLSNQ0QZqzlArCVIYFJGOxo2OL6bvSJY8jeyb3MVKAFLlGWBetHJip9sgi
         ilO8rk2vesf4geXh/UqCeJsOcNCaH00hXkWdQRSZY0Wl189XVbPeBDMdZ3Dwd7SLv+
         o03C/D9Mj11g+wifaVMyHN7ukptYMruktcf4lgEY=
Date:   Thu, 20 Aug 2020 12:25:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Thompson <davthompson@nvidia.com>
Cc:     David Thompson <dthompson@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Asmaa Mnebhi <Asmaa@mellanox.com>
Subject: Re: [PATCH net-next v2] Add Mellanox BlueField Gigabit Ethernet
 driver
Message-ID: <20200820122514.5b552e42@kicinski-fedora-PC1C0HJN>
In-Reply-To: <MN2PR12MB2975DAA7292C27DEB0B518A8C75A0@MN2PR12MB2975.namprd12.prod.outlook.com>
References: <1596149638-23563-1-git-send-email-dthompson@mellanox.com>
        <20200730173059.7440e21c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <MN2PR12MB2975DAA7292C27DEB0B518A8C75A0@MN2PR12MB2975.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Aug 2020 18:51:39 +0000 David Thompson wrote:
> > > +	for (i = 0; i < priv->rx_q_entries; i++) {
> > > +		/* Allocate a receive buffer for this RX WQE. The DMA
> > > +		 * form (dma_addr_t) of the receive buffer address is
> > > +		 * stored in the RX WQE array (via 'rx_wqe_ptr') where
> > > +		 * it is accessible by the GigE device. The VA form of
> > > +		 * the receive buffer is stored in 'rx_buf[]' array in
> > > +		 * the driver private storage for housekeeping.
> > > +		 */
> > > +		priv->rx_buf[i] = dma_alloc_coherent(priv->dev,
> > > +  
> > MLXBF_GIGE_DEFAULT_BUF_SZ,  
> > > +						     &rx_buf_dma,
> > > +						     GFP_KERNEL);  
> > 
> > Do the buffers have to be in coherent memory? That's kinda strange.
> >   
> 
> Yes, the mlxbf_gige silicon block needs to be programmed with the
> buffer's physical address so that the silicon logic can DMA incoming
> packet data into the buffer.  The kernel API "dma_alloc_coherent()"
> meets the driver's requirements in that it returns a CPU-useable address
> as well as a bus/physical address (used by silicon).

It's highly unusual, all drivers I know use the streaming DMA interface.
IDK what the performance implications for using coherent mappings on
your platforms are, but I'd prefer if you took the more common approach.

> > > +static void mlxbf_gige_get_ethtool_stats(struct net_device *netdev,
> > > +					 struct ethtool_stats *estats,
> > > +					 u64 *data)
> > > +{
> > > +	struct mlxbf_gige *priv = netdev_priv(netdev);
> > > +	unsigned long flags;
> > > +
> > > +	spin_lock_irqsave(&priv->lock, flags);  
> > 
> > Why do you take a lock around stats?
> 
> I wrote the logic with a lock so that it implements an atomic "snapshot"
> of the driver's statistics.  This is useful since the standard TX/RX stats
> are being incremented in packet completion logic triggered by the 
> NAPI framework.  Do you see a disadvantage to using a lock here?

The Linux APIs don't provide any "snapshot" guarantees, and you're
stalling the datapath to read stats.

> > > +static const struct net_device_ops mlxbf_gige_netdev_ops = {
> > > +	.ndo_open		= mlxbf_gige_open,
> > > +	.ndo_stop		= mlxbf_gige_stop,
> > > +	.ndo_start_xmit		= mlxbf_gige_start_xmit,
> > > +	.ndo_set_mac_address	= eth_mac_addr,
> > > +	.ndo_validate_addr	= eth_validate_addr,
> > > +	.ndo_do_ioctl		= mlxbf_gige_do_ioctl,
> > > +	.ndo_set_rx_mode        = mlxbf_gige_set_rx_mode,  
> > 
> > You must report standard stats.
> 
> Are you referring to the three possible methods that a driver
> must use the implement support of standard stats reporting:
> 
> From include/linux/netdevice.h -->
> * void (*ndo_get_stats64)(struct net_device *dev,
>  *                         struct rtnl_link_stats64 *storage);
>  * struct net_device_stats* (*ndo_get_stats)(struct net_device *dev);
>  *      Called when a user wants to get the network device usage
>  *      statistics. Drivers must do one of the following:
>  *      1. Define @ndo_get_stats64 to fill in a zero-initialised
>  *         rtnl_link_stats64 structure passed by the caller.
>  *      2. Define @ndo_get_stats to update a net_device_stats structure
>  *         (which should normally be dev->stats) and return a pointer to
>  *         it. The structure may be changed asynchronously only if each
>  *         field is written atomically.
>  *      3. Update dev->stats asynchronously and atomically, and define
>  *         neither operation.
> 
> The mlxbf_gige driver has implemented #3 above, as there is logic
> in the RX and TX completion handlers that increments RX/TX packet
> and byte counts in the net_device->stats structure.  Is that sufficient
> for support of standard stats?

You only update the basic stats. Please take a look at all members,
some of the hw stats will probably fit there, and other HW errors need
to be added to the cumulative rx/tx error stats.
