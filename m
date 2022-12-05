Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3B3B6428F6
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 14:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbiLENJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 08:09:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbiLENJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 08:09:09 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96DF8A1A6;
        Mon,  5 Dec 2022 05:09:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3E9FcPQDI7bPZ255hKk57f3TXlANaaL8bsVQQYZBxfk=; b=H3W0F2G0qz07EGeQxDgzMgV8ES
        CLwTjXStmef444wLkIk30LhDaQtAvTqJ98Hd+DdgUKrZlbgAzIX+qeLT1fROqXuB1r+Er3sYZOs+G
        mCr8SSidT9p2Hq9UtIdWQBU4FMLRUQ/Y+LoHTyi0jziRP0SPi0CQ8h04rotd4THqi1p4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p2BCH-004PAy-Ig; Mon, 05 Dec 2022 14:07:49 +0100
Date:   Mon, 5 Dec 2022 14:07:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/4] net/ethtool: add netlink interface for
 the PLCA RS
Message-ID: <Y43tJRergPBflphQ@lunn.ch>
References: <fc3ac4f2d0c28d9c24b909e97791d1f784502a4a.1670204277.git.piergiorgio.beruto@gmail.com>
 <20221205060057.GA10297@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205060057.GA10297@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 07:00:57AM +0100, Oleksij Rempel wrote:
> Hi Beruto,

> On Mon, Dec 05, 2022 at 02:41:35AM +0100, Piergiorgio Beruto wrote:
> > Add support for configuring the PLCA Reconciliation Sublayer on
> > multi-drop PHYs that support IEEE802.3cg-2019 Clause 148 (e.g.,
> > 10BASE-T1S). This patch adds the appropriate netlink interface
> > to ethtool.
> > 
> > Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
> > ---
> >  MAINTAINERS                          |   6 +
> >  drivers/net/phy/phy.c                |  34 ++++
> >  drivers/net/phy/phy_device.c         |   3 +
> >  include/linux/ethtool.h              |  11 +
> >  include/linux/phy.h                  |  64 ++++++
> >  include/uapi/linux/ethtool_netlink.h |  25 +++
> >  net/ethtool/Makefile                 |   2 +-
> >  net/ethtool/netlink.c                |  30 +++
> >  net/ethtool/netlink.h                |   6 +
> >  net/ethtool/plca.c                   | 290 +++++++++++++++++++++++++++
> >  10 files changed, 470 insertions(+), 1 deletion(-)
> >  create mode 100644 net/ethtool/plca.c
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 955c1be1efb2..7952243e4b43 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -16396,6 +16396,12 @@ S:	Maintained
> >  F:	Documentation/devicetree/bindings/iio/chemical/plantower,pms7003.yaml
> >  F:	drivers/iio/chemical/pms7003.c
> >  
> > +PLCA RECONCILIATION SUBLAYER (IEEE802.3 Clause 148)
> > +M:	Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
> > +L:	netdev@vger.kernel.org
> > +S:	Maintained
> > +F:	net/ethtool/plca.c
> > +
> >  PLDMFW LIBRARY
> >  M:	Jacob Keller <jacob.e.keller@intel.com>
> >  S:	Maintained
> > diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> > index e5b6cb1a77f9..99e3497b6aa1 100644
> > --- a/drivers/net/phy/phy.c
> > +++ b/drivers/net/phy/phy.c
> > @@ -543,6 +543,40 @@ int phy_ethtool_get_stats(struct phy_device *phydev,
> >  }
> >  EXPORT_SYMBOL(phy_ethtool_get_stats);
> >  
> > +/**
> > + *
> > + */
> > +int phy_ethtool_get_plca_cfg(struct phy_device *dev,
> > +			     struct phy_plca_cfg *plca_cfg)
> > +{
> > +	// TODO
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(phy_ethtool_get_plca_cfg);
> > +
> > +/**
> > + *
> > + */
> > +int phy_ethtool_set_plca_cfg(struct phy_device *dev,
> > +			     struct netlink_ext_ack *extack,
> > +			     const struct phy_plca_cfg *plca_cfg)
> > +{
> > +	// TODO
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(phy_ethtool_set_plca_cfg);
> > +
> > +/**
> > + *
> > + */
> > +int phy_ethtool_get_plca_status(struct phy_device *dev,
> > +				struct phy_plca_status *plca_st)
> > +{
> > +	// TODO
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(phy_ethtool_get_plca_status);
> > +
> >  /**
> >   * phy_start_cable_test - Start a cable test
> >   *
> > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > index 716870a4499c..f248010c403d 100644
> > --- a/drivers/net/phy/phy_device.c
> > +++ b/drivers/net/phy/phy_device.c
> > @@ -3262,6 +3262,9 @@ static const struct ethtool_phy_ops phy_ethtool_phy_ops = {
> >  	.get_sset_count		= phy_ethtool_get_sset_count,
> >  	.get_strings		= phy_ethtool_get_strings,
> >  	.get_stats		= phy_ethtool_get_stats,
> > +	.get_plca_cfg		= phy_ethtool_get_plca_cfg,
> > +	.set_plca_cfg		= phy_ethtool_set_plca_cfg,
> > +	.get_plca_status	= phy_ethtool_get_plca_status,
> >  	.start_cable_test	= phy_start_cable_test,
> >  	.start_cable_test_tdr	= phy_start_cable_test_tdr,
> >  };
> > diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
> > index 9e0a76fc7de9..4bfe95ec1f0a 100644
> > --- a/include/linux/ethtool.h
> > +++ b/include/linux/ethtool.h
> > @@ -802,12 +802,16 @@ int ethtool_virtdev_set_link_ksettings(struct net_device *dev,
> >  
> >  struct phy_device;
> >  struct phy_tdr_config;
> > +struct phy_plca_cfg;
> > +struct phy_plca_status;
> >  
> >  /**
> >   * struct ethtool_phy_ops - Optional PHY device options
> >   * @get_sset_count: Get number of strings that @get_strings will write.
> >   * @get_strings: Return a set of strings that describe the requested objects
> >   * @get_stats: Return extended statistics about the PHY device.
> > + * @get_plca_cfg: Return PLCA configuration.
> > + * @set_plca_cfg: Set PLCA configuration.
> >   * @start_cable_test: Start a cable test
> >   * @start_cable_test_tdr: Start a Time Domain Reflectometry cable test
> >   *
> > @@ -819,6 +823,13 @@ struct ethtool_phy_ops {
> >  	int (*get_strings)(struct phy_device *dev, u8 *data);
> >  	int (*get_stats)(struct phy_device *dev,
> >  			 struct ethtool_stats *stats, u64 *data);
> > +	int (*get_plca_cfg)(struct phy_device *dev,
> > +			    struct phy_plca_cfg *plca_cfg);
> > +	int (*set_plca_cfg)(struct phy_device *dev,
> > +			    struct netlink_ext_ack *extack,
> > +			    const struct phy_plca_cfg *plca_cfg);
> > +	int (*get_plca_status)(struct phy_device *dev,
> > +			       struct phy_plca_status *plca_st);
> >  	int (*start_cable_test)(struct phy_device *phydev,
> >  				struct netlink_ext_ack *extack);
> >  	int (*start_cable_test_tdr)(struct phy_device *phydev,
> > diff --git a/include/linux/phy.h b/include/linux/phy.h
> > index 71eeb4e3b1fd..ab2c134d0a05 100644
> > --- a/include/linux/phy.h
> > +++ b/include/linux/phy.h
> > @@ -765,6 +765,63 @@ struct phy_tdr_config {
> >  };
> >  #define PHY_PAIR_ALL -1
> >  
> > +/**
> > + * struct phy_plca_cfg - Configuration of the PLCA (Physical Layer Collision
> > + * Avoidance) Reconciliation Sublayer.
> > + *
> > + * @version: read-only PLCA register map version. 0 = not available. Ignored
> > + *   when setting the configuration. Format is the same as reported by the PLCA
> > + *   IDVER register (31.CA00). -1 = not available.
> > + * @enabled: PLCA configured mode (enabled/disabled). -1 = not available / don't
> > + *   set. 0 = disabled, anything else = enabled.
> > + * @node_id: the PLCA local node identifier. -1 = not available / don't set.
> > + *   Allowed values [0 .. 254]. 255 = node disabled.
> > + * @node_cnt: the PLCA node count (maximum number of nodes having a TO). Only
> > + *   meaningful for the coordinator (node_id = 0). -1 = not available / don't
> > + *   set. Allowed values [0 .. 255].
> > + * @to_tmr: The value of the PLCA to_timer in bit-times, which determines the
> > + *   PLCA transmit opportunity window opening. See IEEE802.3 Clause 148 for
> > + *   more details. The to_timer shall be set equal over all nodes.
> > + *   -1 = not available / don't set. Allowed values [0 .. 255].
> > + * @burst_cnt: controls how many additional frames a node is allowed to send in
> > + *   single transmit opportunity (TO). The default value of 0 means that the
> > + *   node is allowed exactly one frame per TO. A value of 1 allows two frames
> > + *   per TO, and so on. -1 = not available / don't set.
> > + *   Allowed values [0 .. 255].
> > + * @burst_tmr: controls how many bit times to wait for the MAC to send a new
> > + *   frame before interrupting the burst. This value should be set to a value
> > + *   greater than the MAC inter-packet gap (which is typically 96 bits).
> > + *   -1 = not available / don't set. Allowed values [0 .. 255].
> > + *
> > + * A structure containing configuration parameters for setting/getting the PLCA
> > + * RS configuration. The driver does not need to implement all the parameters,
> > + * but should report what is actually used.
> > + */
> > +struct phy_plca_cfg {
> > +	s32 version;
> > +	s16 enabled;
> > +	s16 node_id;
> > +	s16 node_cnt;
> > +	s16 to_tmr;
> > +	s16 burst_cnt;
> > +	s16 burst_tmr;
> > +};
> > +
> > +/**
> > + * struct phy_plca_status - Status of the PLCA (Physical Layer Collision
> > + * Avoidance) Reconciliation Sublayer.
> > + *
> > + * @pst: The PLCA status as reported by the PST bit in the PLCA STATUS
> > + *	register(31.CA03), indicating BEACON activity.
> > + *
> > + * A structure containing status information of the PLCA RS configuration.
> > + * The driver does not need to implement all the parameters, but should report
> > + * what is actually used.
> > + */
> > +struct phy_plca_status {
> > +	bool pst;
> > +};
> > +
> >  /**
> >   * struct phy_driver - Driver structure for a particular PHY type
> >   *
> > @@ -1775,6 +1832,13 @@ int phy_ethtool_get_strings(struct phy_device *phydev, u8 *data);
> >  int phy_ethtool_get_sset_count(struct phy_device *phydev);
> >  int phy_ethtool_get_stats(struct phy_device *phydev,
> >  			  struct ethtool_stats *stats, u64 *data);
> > +int phy_ethtool_get_plca_cfg(struct phy_device *dev,
> > +			     struct phy_plca_cfg *plca_cfg);
> > +int phy_ethtool_set_plca_cfg(struct phy_device *dev,
> > +			     struct netlink_ext_ack *extack,
> > +			     const struct phy_plca_cfg *plca_cfg);
> > +int phy_ethtool_get_plca_status(struct phy_device *dev,
> > +				struct phy_plca_status *plca_st);
> >  
> >  static inline int phy_package_read(struct phy_device *phydev, u32 regnum)
> >  {
> > diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
> > index aaf7c6963d61..81e3d7b42d0f 100644
> > --- a/include/uapi/linux/ethtool_netlink.h
> > +++ b/include/uapi/linux/ethtool_netlink.h
> > @@ -51,6 +51,9 @@ enum {
> >  	ETHTOOL_MSG_MODULE_SET,
> >  	ETHTOOL_MSG_PSE_GET,
> >  	ETHTOOL_MSG_PSE_SET,
> > +	ETHTOOL_MSG_PLCA_GET_CFG,
> > +	ETHTOOL_MSG_PLCA_SET_CFG,
> > +	ETHTOOL_MSG_PLCA_GET_STATUS,
> >  
> >  	/* add new constants above here */
> >  	__ETHTOOL_MSG_USER_CNT,
> > @@ -97,6 +100,9 @@ enum {
> >  	ETHTOOL_MSG_MODULE_GET_REPLY,
> >  	ETHTOOL_MSG_MODULE_NTF,
> >  	ETHTOOL_MSG_PSE_GET_REPLY,
> > +	ETHTOOL_MSG_PLCA_GET_CFG_REPLY,
> > +	ETHTOOL_MSG_PLCA_GET_STATUS_REPLY,
> > +	ETHTOOL_MSG_PLCA_NTF,
> >  
> >  	/* add new constants above here */
> >  	__ETHTOOL_MSG_KERNEL_CNT,
> > @@ -880,6 +886,25 @@ enum {
> >  	ETHTOOL_A_PSE_MAX = (__ETHTOOL_A_PSE_CNT - 1)
> >  };
> >  
> > +/* PLCA */
> > +

Hi Oleksij
 
Please trim the text when replying. It is possible to miss comments
when having to page down, page down, page down all the time.

Thanks
	Andrew
