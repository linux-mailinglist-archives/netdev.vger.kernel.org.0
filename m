Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB6043615AA
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 00:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236050AbhDOWrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 18:47:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235576AbhDOWrR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 18:47:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B59A6008E;
        Thu, 15 Apr 2021 22:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618526813;
        bh=IAlibXGIUG8sEK3BybIH1OBjmXjEgIlz6HsUcC9idlQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=F3jdQ/Z0bFQn3EvncfboDAcBhwyclQOA+RXU378yEEi/Sx0kyAVtZJjBD/57oqlr2
         j1GWI0jdjdYNF5WKeswy7rV+/ctQ1vZ3G5eEoJGhy4Sxx8zAjpZ64WbwquGI2XDLz8
         KfvwFmWvX1I9UQhYgvm/HC3a050H6KX5+Bo1/9RjKDH5nKaeZ0+5bbtKKbeoE4oShL
         vJ8/YAuSEMpTtt3Pe2lvW4mDvnzm04N3ZoSKpEtfsIDa/qgbGCS0BrbIftTYzNOuMP
         vPxi2UejopgQDXhl1smfvb7ir/GaUYpxlIJPOY+npMwcnr/BUCvgOUobxyx7sEcL5C
         PSYDzt8iYLGgg==
Message-ID: <7e82c145335a2cdd080cf9bcb731a315ca317fb3.camel@kernel.org>
Subject: Re: [RFC net-next 4/6] ethtool: add interface to read standard MAC
 stats
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, idosch@nvidia.com
Date:   Thu, 15 Apr 2021 15:46:52 -0700
In-Reply-To: <20210415083837.6dfc0af9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210414202325.2225774-1-kuba@kernel.org>
         <20210414202325.2225774-5-kuba@kernel.org>
         <335639a79d72cec4abb3775bc84336f8390a57b7.camel@kernel.org>
         <20210415083837.6dfc0af9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-04-15 at 08:38 -0700, Jakub Kicinski wrote:
> On Wed, 14 Apr 2021 23:12:52 -0700 Saeed Mahameed wrote:
> > On Wed, 2021-04-14 at 13:23 -0700, Jakub Kicinski wrote:
> > > Most of the MAC statistics are included in
> > > struct rtnl_link_stats64, but some fields
> > > are aggregated. Besides it's good to expose
> > > these clearly hardware stats separately.
> > > 
> > > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> > > +/* Basic IEEE 802.3 MAC statistics (30.3.1.1.*), not otherwise
> > > exposed
> > > + * via a more targeted API.
> > > + */
> > > +struct ethtool_eth_mac_stats {
> > > +       u64 FramesTransmittedOK;
> > > +       u64 SingleCollisionFrames;
> > > +       u64 MultipleCollisionFrames;
> > > +       u64 FramesReceivedOK;
> > > +       u64 FrameCheckSequenceErrors;
> > > +       u64 AlignmentErrors;
> > > +       u64 OctetsTransmittedOK;
> > > +       u64 FramesWithDeferredXmissions;
> > > +       u64 LateCollisions;
> > > +       u64 FramesAbortedDueToXSColls;
> > > +       u64 FramesLostDueToIntMACXmitError;
> > > +       u64 CarrierSenseErrors;
> > > +       u64 OctetsReceivedOK;
> > > +       u64 FramesLostDueToIntMACRcvError;
> > > +       u64 MulticastFramesXmittedOK;
> > > +       u64 BroadcastFramesXmittedOK;
> > > +       u64 FramesWithExcessiveDeferral;
> > > +       u64 MulticastFramesReceivedOK;
> > > +       u64 BroadcastFramesReceivedOK;
> > > +       u64 InRangeLengthErrors;
> > > +       u64 OutOfRangeLengthField;
> > > +       u64 FrameTooLongErrors;
> > > +};
> > > +
> > >  /* Basic IEEE 802.3 PHY statistics (30.3.2.1.*), not otherwise
> > > exposed
> > >   * via a more targeted API.
> > >   */
> > > @@ -495,6 +523,7 @@ struct ethtool_module_eeprom {
> > >   *     specified page. Returns a negative error code or the
> > > amount of
> > > bytes
> > >   *     read.
> > >   * @get_eth_phy_stats: Query some of the IEEE 802.3 PHY
> > > statistics.
> > > + * @get_eth_mac_stats: Query some of the IEEE 802.3 MAC
> > > statistics.
> > >   *
> > >   * All operations are optional (i.e. the function pointer may be
> > > set
> > >   * to %NULL) and callers must take this into account.  Callers
> > > must
> > > @@ -607,6 +636,8 @@ struct ethtool_ops {
> > >                                              struct
> > > netlink_ext_ack
> > > *extack);
> > >         void    (*get_eth_phy_stats)(struct net_device *dev,
> > >                                      struct ethtool_eth_phy_stats
> > > *phy_stats);
> > > +       void    (*get_eth_mac_stats)(struct net_device *dev,
> > > +                                    struct ethtool_eth_mac_stats
> > > *mac_stats);  
> > 
> > too many callbacks.. I understand the point of having explicit
> > structs
> > per stats group, but it can be achievable with one generic ethtool
> > calback function with the help of a flexible struct:
> > 
> > void (*get_std_stats)(struct net_device *dev, struct *std_stats)
> > 
> > 
> > union stats_groups {
> >     struct ethtool_eth_phy_stats eth_phy;
> >     struct ethtool_eth_mac_stats eth_mac;
> >     ...
> > }
> > 
> > struct std_stats {
> >      u16 type;
> >      union stats_groups stats[0];
> > }
> > 
> > where std_stats.stats is allocated dynamically according to
> > std_stats.type
> > 
> > and driver can just access the corresponding stats according to
> > type
> > 
> > e.g: 
> > std_stats.stats.eth_phy
> 
> Kinda expected you'd say this :) The mux make life simpler for
> drivers
> with a lot of layers of abstraction. Separate ops make life simpler
> for
> simpler drivers.
> 
> Basic Ethernet driver goes from this:
> 
> get_mac_stats()
> {
>         priv = netdev_priv()
> 
>         stat->x = readl(priv->regs + REG_X);
>         stat->z = readl(priv->regs + REG_Y);
>         stat->y = readl(priv->regs + REG_Z);
> }
> 
> to:
> 
> get_std_stats()
> {
>         priv = netdev_priv();
> 
>         switch (stats->type) {
>         case MAC:
>                 stat->x = readl(priv->regs + REG_X);
>                 stat->z = readl(priv->regs + REG_Y);
>                 stat->y = readl(priv->regs + REG_Z);
>                 break;
>         }
> }
> 
> or likely:
> 
> get_std_stats()
> {
>         priv = netdev_priv();
> 
>         switch (stats->type) {
>         case MAC:
>                 return get_mac_stats(priv..);
>         }
> }
> 
> I prefer to keep the callbacks separate, there isn't that many of
> them.
> 

Ack, i don't like switch cases, but i also don't like long structs with
pages and pages of callbacks..

> > > +static int stats_put_mac_stats(struct sk_buff *skb,
> > > +                              const struct stats_reply_data
> > > *data)
> > > +{
> > > +       if (stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_2_TX_PKT,
> > > +                    data->mac_stats.FramesTransmittedOK) ||
> > > +           stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_3_SINGLE_COL,
> > > +                    data->mac_stats.SingleCollisionFrames) ||
> > > +           stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_4_MULTI_COL,
> > > +                    data->mac_stats.MultipleCollisionFrames) ||
> > > +           stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_5_RX_PKT,
> > > +                    data->mac_stats.FramesReceivedOK) ||
> > > +           stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_6_FCS_ERR,
> > > +                    data->mac_stats.FrameCheckSequenceErrors) ||
> > > +           stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_7_ALIGN_ERR,
> > > +                    data->mac_stats.AlignmentErrors) ||
> > > +           stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_8_TX_BYTES,
> > > +                    data->mac_stats.OctetsTransmittedOK) ||
> > > +           stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_9_TX_DEFER,
> > > +                    data->mac_stats.FramesWithDeferredXmissions)
> > > ||
> > > +           stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_10_LATE_COL,
> > > +                    data->mac_stats.LateCollisions) ||
> > > +           stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_11_XS_COL,
> > > +                    data->mac_stats.FramesAbortedDueToXSColls)
> > > ||
> > > +           stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_12_TX_INT_ERR,
> > > +                    data-
> > > >mac_stats.FramesLostDueToIntMACXmitError) ||
> > > +           stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_13_CS_ERR,
> > > +                    data->mac_stats.CarrierSenseErrors) ||
> > > +           stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_14_RX_BYTES,
> > > +                    data->mac_stats.OctetsReceivedOK) ||
> > > +           stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_15_RX_INT_ERR,
> > > +                    data-
> > > >mac_stats.FramesLostDueToIntMACRcvError) ||
> > > +           stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_18_TX_MCAST,
> > > +                    data->mac_stats.MulticastFramesXmittedOK) ||
> > > +           stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_19_TX_BCAST,
> > > +                    data->mac_stats.BroadcastFramesXmittedOK) ||
> > > +           stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_20_XS_DEFER,
> > > +                    data->mac_stats.FramesWithExcessiveDeferral)
> > > ||
> > > +           stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_21_RX_MCAST,
> > > +                    data->mac_stats.MulticastFramesReceivedOK)
> > > ||
> > > +           stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_22_RX_BCAST,
> > > +                    data->mac_stats.BroadcastFramesReceivedOK)
> > > ||
> > > +           stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_23_IR_LEN_ERR,
> > > +                    data->mac_stats.InRangeLengthErrors) ||
> > > +           stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_24_OOR_LEN,
> > > +                    data->mac_stats.OutOfRangeLengthField) ||
> > > +           stat_put(skb,
> > > ETHTOOL_A_STATS_ETH_MAC_25_TOO_LONG_ERR,
> > > +                    data->mac_stats.FrameTooLongErrors))
> > > +               return -EMSGSIZE;  
> > 
> > lots of repetition, someone might forget to add the new stat in one
> > of
> > these places .. 
> 
> If someone forgets to add a stat to the place they are dumped?
> They will immediately realize it's not getting dumped...
> 

kinda my point, I wouldn't count on this.. 

> > best practice here is to centralize all the data structures and
> > information definitions in one place, you define the stat id,
> > string,
> > and value offset, then a generic loop can generate the strset and
> > fill
> > up values in the correct offset.
> > 
> > similar implementation is already in mlx5:
> > 
> > see pport_802_3_stats_desc:
> >   
> > https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c#L682
> > 
> > the "pport_802_3_stats_desc" has a description of the strings and
> > offsets of all stats in this stats group
> > and the fill/put functions are very simple and they just iterate
> > over
> > the array/group and fill up according to the descriptor.
> 
> We can maybe save 60 lines if we generate stats_eth_mac_names 
> in a initcall, is it really worth it? I prefer the readability 
> / grepability.

I don't think readability will be an issue if the infrastructure is
generic enough.. 

This just a preference, of course you can go with the current code.
My point is that someone doesn't need to change multiple places and
possibly files every time they need to expose a new stat, you just
update some central database of the new data you want to expose.



