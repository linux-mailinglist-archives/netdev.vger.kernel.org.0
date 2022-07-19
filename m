Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 452BD57959B
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 10:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237129AbiGSIxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 04:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237132AbiGSIxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 04:53:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0355FD22
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 01:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658220795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QL/LjGp6/hhB5X9obZ921/tJRebrcy/JjzbVt5Qel7c=;
        b=d3mHcaKlOY2ZqIwpZaximT0j7rREur0UDllQ7XAPZd5VGkCB/bgZGE950V5byW+kJjxyCN
        dyZMq13EgLSyyUhRoQOKquXyROTevGvuoiVucs/xx0M6nixAHZ2ZmSZ/8Sszp5QxU3kb43
        v3WeCCTyA9yOhdVAuFonVgjeUaLcJ8s=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-BRoQiyD7P6mAl-M09NejQQ-1; Tue, 19 Jul 2022 04:53:08 -0400
X-MC-Unique: BRoQiyD7P6mAl-M09NejQQ-1
Received: by mail-wr1-f71.google.com with SMTP id s16-20020adf9790000000b0021e36810385so227301wrb.15
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 01:53:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=QL/LjGp6/hhB5X9obZ921/tJRebrcy/JjzbVt5Qel7c=;
        b=Z/OQHFjMoVM6fKMEDND2v2naVOCAUtYv5jeaczmWcTxwlyKnmH9FXMqQtIiHdronqD
         HbVErFRcjxtLrIYj/FiOvD8SDv/rdrfQIIVH06A95n000B6ublFEEmCIi3WgYCOkSaOR
         LFhRxuzmO0louVmhmo+FzL8pB4nByUEkTzkx9909aLsUKYR6ORPyysvH3UURVwSj2pRJ
         9EVdBdJGyfTnsJUv2t1kUGX5LaJ/4Re/WIGSfbta9G2pubHm7KQBr6T++PPqa9JMqEs9
         W59OKVmkzQVAkFnaAXbHmRuWT+Hy8V42/ufylw22JuWXNX8rU+MJGyBvzVzS7tcWzrVs
         0xQA==
X-Gm-Message-State: AJIora+wI+iL9XsozAFeZ6k9027ovvJlUzVXCZ9z007tjZOfbtmehAKs
        di1JSlO8A5RG0sIKn3AsYbdG5Jt742ssp/4upmak/olqjPIMd7ronRMZEJ4xWF0lGF8nPGnGFwD
        p4OZkznXi8ZALQPj8
X-Received: by 2002:a05:6000:1152:b0:21d:7646:a976 with SMTP id d18-20020a056000115200b0021d7646a976mr26119506wrx.416.1658220787648;
        Tue, 19 Jul 2022 01:53:07 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tlCLY7icpfT1gNd5AcqscJgumEDLXWU9pewSVipJ9rqgFYiEmaj9vwUxMAADEoFR8Z+5VMbA==
X-Received: by 2002:a05:6000:1152:b0:21d:7646:a976 with SMTP id d18-20020a056000115200b0021d7646a976mr26119483wrx.416.1658220787273;
        Tue, 19 Jul 2022 01:53:07 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-164.dyn.eolo.it. [146.241.104.164])
        by smtp.gmail.com with ESMTPSA id a13-20020a05600c348d00b003a31d200a7dsm5368485wmq.9.2022.07.19.01.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 01:53:06 -0700 (PDT)
Message-ID: <660684000d6820524c61d733fb076225202dad8e.camel@redhat.com>
Subject: Re: [PATCH V4 net-next] net: marvell: prestera: add phylink support
From:   Paolo Abeni <pabeni@redhat.com>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, yevhen.orlov@plvision.eu,
        taras.chornyi@plvision.eu, linux@armlinux.org.uk, andrew@lunn.ch
Date:   Tue, 19 Jul 2022 10:53:05 +0200
In-Reply-To: <20220715193454.7627-1-oleksandr.mazur@plvision.eu>
References: <20220715193454.7627-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-07-15 at 22:34 +0300, Oleksandr Mazur wrote:
> For SFP port prestera driver will use kernel
> phylink infrastucture to configure port mode based on
> the module that has beed inserted
> 
> Co-developed-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
> Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
> Co-developed-by: Taras Chornyi <taras.chornyi@plvision.eu>
> Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> ---
> PATCH V4:
>   - move changelog under threeline separator.
>   - add small comment that explains reason for
>     empty pcs 'an_restart' function.
> PATCH V3:
>   - force inband mode for SGMII
>   - fix >80 chars warning of checkpatch where possible (2/5)
>   - structure phylink_mac_change alongside phylink-related if-clause;
> PATCH V2:
>   - fix mistreat of bitfield values as if they were bools.
>   - remove phylink_config ifdefs.
>   - remove obsolete phylink pcs / mac callbacks;
>   - rework mac (/pcs) config to not look for speed / duplex
>     parameters while link is not yet set up.
>   - remove unused functions.
>   - add phylink select cfg to prestera Kconfig.
> 
>  drivers/net/ethernet/marvell/prestera/Kconfig |   1 +
>  .../net/ethernet/marvell/prestera/prestera.h  |   9 +
>  .../marvell/prestera/prestera_ethtool.c       |  28 +-
>  .../marvell/prestera/prestera_ethtool.h       |   3 -
>  .../ethernet/marvell/prestera/prestera_main.c | 353 ++++++++++++++++--
>  5 files changed, 332 insertions(+), 62 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/prestera/Kconfig b/drivers/net/ethernet/marvell/prestera/Kconfig
> index b6f20e2034c6..f2f7663c3d10 100644
> --- a/drivers/net/ethernet/marvell/prestera/Kconfig
> +++ b/drivers/net/ethernet/marvell/prestera/Kconfig
> @@ -8,6 +8,7 @@ config PRESTERA
>  	depends on NET_SWITCHDEV && VLAN_8021Q
>  	depends on BRIDGE || BRIDGE=n
>  	select NET_DEVLINK
> +	select PHYLINK
>  	help
>  	  This driver supports Marvell Prestera Switch ASICs family.
>  
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
> index bff9651f0a89..832c27e0c284 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera.h
> +++ b/drivers/net/ethernet/marvell/prestera/prestera.h
> @@ -7,6 +7,7 @@
>  #include <linux/notifier.h>
>  #include <linux/skbuff.h>
>  #include <linux/workqueue.h>
> +#include <linux/phylink.h>
>  #include <net/devlink.h>
>  #include <uapi/linux/if_ether.h>
>  
> @@ -92,6 +93,7 @@ struct prestera_lag {
>  struct prestera_flow_block;
>  
>  struct prestera_port_mac_state {
> +	bool valid;
>  	u32 mode;
>  	u32 speed;
>  	bool oper;
> @@ -151,6 +153,12 @@ struct prestera_port {
>  	struct prestera_port_phy_config cfg_phy;
>  	struct prestera_port_mac_state state_mac;
>  	struct prestera_port_phy_state state_phy;
> +
> +	struct phylink_config phy_config;
> +	struct phylink *phy_link;
> +	struct phylink_pcs phylink_pcs;
> +
> +	rwlock_t state_mac_lock;
>  };
>  
>  struct prestera_device {
> @@ -291,6 +299,7 @@ struct prestera_switch {
>  	u32 mtu_min;
>  	u32 mtu_max;
>  	u8 id;
> +	struct device_node *np;
>  	struct prestera_router *router;
>  	struct prestera_lag *lags;
>  	struct prestera_counter *counter;
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
> index 40d5b89573bb..1da7ff889417 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
> @@ -521,6 +521,9 @@ prestera_ethtool_get_link_ksettings(struct net_device *dev,
>  	ecmd->base.speed = SPEED_UNKNOWN;
>  	ecmd->base.duplex = DUPLEX_UNKNOWN;
>  
> +	if (port->phy_link)
> +		return phylink_ethtool_ksettings_get(port->phy_link, ecmd);
> +
>  	ecmd->base.autoneg = port->autoneg ? AUTONEG_ENABLE : AUTONEG_DISABLE;
>  
>  	if (port->caps.type == PRESTERA_PORT_TYPE_TP) {
> @@ -648,6 +651,9 @@ prestera_ethtool_set_link_ksettings(struct net_device *dev,
>  	u8 adver_fec;
>  	int err;
>  
> +	if (port->phy_link)
> +		return phylink_ethtool_ksettings_set(port->phy_link, ecmd);
> +
>  	err = prestera_port_type_set(ecmd, port);
>  	if (err)
>  		return err;
> @@ -782,28 +788,6 @@ static int prestera_ethtool_nway_reset(struct net_device *dev)
>  	return -EINVAL;
>  }
>  
> -void prestera_ethtool_port_state_changed(struct prestera_port *port,
> -					 struct prestera_port_event *evt)
> -{
> -	struct prestera_port_mac_state *smac = &port->state_mac;
> -
> -	smac->oper = evt->data.mac.oper;
> -
> -	if (smac->oper) {
> -		smac->mode = evt->data.mac.mode;
> -		smac->speed = evt->data.mac.speed;
> -		smac->duplex = evt->data.mac.duplex;
> -		smac->fc = evt->data.mac.fc;
> -		smac->fec = evt->data.mac.fec;
> -	} else {
> -		smac->mode = PRESTERA_MAC_MODE_MAX;
> -		smac->speed = SPEED_UNKNOWN;
> -		smac->duplex = DUPLEX_UNKNOWN;
> -		smac->fc = 0;
> -		smac->fec = 0;
> -	}
> -}
> -
>  const struct ethtool_ops prestera_ethtool_ops = {
>  	.get_drvinfo = prestera_ethtool_get_drvinfo,
>  	.get_link_ksettings = prestera_ethtool_get_link_ksettings,
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.h b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.h
> index 9eb18e99dea6..bd5600886bc6 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.h
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.h
> @@ -11,7 +11,4 @@ struct prestera_port;
>  
>  extern const struct ethtool_ops prestera_ethtool_ops;
>  
> -void prestera_ethtool_port_state_changed(struct prestera_port *port,
> -					 struct prestera_port_event *evt);
> -
>  #endif /* _PRESTERA_ETHTOOL_H_ */
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
> index ea5bd5069826..192ab706e45e 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
> @@ -9,6 +9,7 @@
>  #include <linux/of.h>
>  #include <linux/of_net.h>
>  #include <linux/if_vlan.h>
> +#include <linux/phylink.h>
>  
>  #include "prestera.h"
>  #include "prestera_hw.h"
> @@ -142,18 +143,24 @@ static int prestera_port_open(struct net_device *dev)
>  	struct prestera_port_mac_config cfg_mac;
>  	int err = 0;
>  
> -	if (port->caps.transceiver == PRESTERA_PORT_TCVR_SFP) {
> -		err = prestera_port_cfg_mac_read(port, &cfg_mac);
> -		if (!err) {
> -			cfg_mac.admin = true;
> -			err = prestera_port_cfg_mac_write(port, &cfg_mac);
> -		}
> +	if (port->phy_link) {
> +		phylink_start(port->phy_link);
>  	} else {
> -		port->cfg_phy.admin = true;
> -		err = prestera_hw_port_phy_mode_set(port, true, port->autoneg,
> -						    port->cfg_phy.mode,
> -						    port->adver_link_modes,
> -						    port->cfg_phy.mdix);
> +		if (port->caps.transceiver == PRESTERA_PORT_TCVR_SFP) {
> +			err = prestera_port_cfg_mac_read(port, &cfg_mac);
> +			if (!err) {
> +				cfg_mac.admin = true;
> +				err = prestera_port_cfg_mac_write(port,
> +								  &cfg_mac);
> +			}
> +		} else {
> +			port->cfg_phy.admin = true;
> +			err = prestera_hw_port_phy_mode_set(port, true,
> +							    port->autoneg,
> +							    port->cfg_phy.mode,
> +							    port->adver_link_modes,
> +							    port->cfg_phy.mdix);
> +		}
>  	}
>  
>  	netif_start_queue(dev);
> @@ -169,23 +176,260 @@ static int prestera_port_close(struct net_device *dev)
>  
>  	netif_stop_queue(dev);
>  
> -	if (port->caps.transceiver == PRESTERA_PORT_TCVR_SFP) {
> +	if (port->phy_link) {
> +		phylink_stop(port->phy_link);
> +		phylink_disconnect_phy(port->phy_link);
>  		err = prestera_port_cfg_mac_read(port, &cfg_mac);
>  		if (!err) {
>  			cfg_mac.admin = false;
>  			prestera_port_cfg_mac_write(port, &cfg_mac);
>  		}
>  	} else {
> -		port->cfg_phy.admin = false;
> -		err = prestera_hw_port_phy_mode_set(port, false, port->autoneg,
> -						    port->cfg_phy.mode,
> -						    port->adver_link_modes,
> -						    port->cfg_phy.mdix);
> +		if (port->caps.transceiver == PRESTERA_PORT_TCVR_SFP) {
> +			err = prestera_port_cfg_mac_read(port, &cfg_mac);
> +			if (!err) {
> +				cfg_mac.admin = false;
> +				prestera_port_cfg_mac_write(port, &cfg_mac);
> +			}
> +		} else {
> +			port->cfg_phy.admin = false;
> +			err = prestera_hw_port_phy_mode_set(port, false, port->autoneg,
> +							    port->cfg_phy.mode,
> +							    port->adver_link_modes,
> +							    port->cfg_phy.mdix);
> +		}
>  	}
>  
>  	return err;
>  }
>  
> +static void
> +prestera_port_mac_state_cache_read(struct prestera_port *port,
> +				   struct prestera_port_mac_state *state)
> +{
> +	read_lock(&port->state_mac_lock);
> +	*state = port->state_mac;
> +	read_unlock(&port->state_mac_lock);

read locks are subject to some non fair behavior. That can hurts when
the relevant lock is accessed quite often/is under contention - likely
not here, right? - but perhaps a plain spinlock would be nicer.

> +}
> +
> +static void
> +prestera_port_mac_state_cache_write(struct prestera_port *port,
> +				    struct prestera_port_mac_state *state)
> +{
> +	write_lock(&port->state_mac_lock);
> +	port->state_mac = *state;
> +	write_unlock(&port->state_mac_lock);
> +}
> +
> +static struct prestera_port *prestera_pcs_to_port(struct phylink_pcs *pcs)
> +{
> +	return container_of(pcs, struct prestera_port, phylink_pcs);
> +}
> +
> +static void prestera_mac_config(struct phylink_config *config,
> +				unsigned int an_mode,
> +				const struct phylink_link_state *state)
> +{
> +}
> +
> +static void prestera_mac_link_down(struct phylink_config *config,
> +				   unsigned int mode, phy_interface_t interface)
> +{
> +	struct net_device *ndev = to_net_dev(config->dev);
> +	struct prestera_port *port = netdev_priv(ndev);
> +	struct prestera_port_mac_state state_mac;
> +
> +	/* Invalidate. Parameters will update on next link event. */
> +	memset(&state_mac, 0, sizeof(state_mac));
> +	state_mac.valid = false;
> +	prestera_port_mac_state_cache_write(port, &state_mac);
> +}
> +
> +static void prestera_mac_link_up(struct phylink_config *config,
> +				 struct phy_device *phy,
> +				 unsigned int mode, phy_interface_t interface,
> +				 int speed, int duplex,
> +				 bool tx_pause, bool rx_pause)
> +{
> +}
> +
> +static struct phylink_pcs *
> +prestera_mac_select_pcs(struct phylink_config *config,
> +			phy_interface_t interface)
> +{
> +	struct net_device *dev = to_net_dev(config->dev);
> +	struct prestera_port *port = netdev_priv(dev);
> +
> +	return &port->phylink_pcs;
> +}
> +
> +static void prestera_pcs_get_state(struct phylink_pcs *pcs,
> +				   struct phylink_link_state *state)
> +{
> +	struct prestera_port *port = container_of(pcs, struct prestera_port,
> +						  phylink_pcs);
> +	struct prestera_port_mac_state smac;
> +
> +	prestera_port_mac_state_cache_read(port, &smac);
> +
> +	if (smac.valid) {
> +		state->link = smac.oper ? 1 : 0;
> +		/* AN is completed, when port is up */
> +		state->an_complete = (smac.oper && port->autoneg) ? 1 : 0;
> +		state->speed = smac.speed;
> +		state->duplex = smac.duplex;
> +	} else {
> +		state->link = 0;
> +		state->an_complete = 0;
> +	}
> +}
> +
> +static int prestera_pcs_config(struct phylink_pcs *pcs,
> +			       unsigned int mode,
> +			       phy_interface_t interface,
> +			       const unsigned long *advertising,
> +			       bool permit_pause_to_mac)
> +{
> +	struct prestera_port *port = port = prestera_pcs_to_port(pcs);
> +	struct prestera_port_mac_config cfg_mac;
> +	int err;
> +
> +	err = prestera_port_cfg_mac_read(port, &cfg_mac);
> +	if (err)
> +		return err;
> +
> +	cfg_mac.admin = true;
> +	cfg_mac.fec = PRESTERA_PORT_FEC_OFF;
> +
> +	switch (interface) {
> +	case PHY_INTERFACE_MODE_10GBASER:
> +		cfg_mac.speed = SPEED_10000;
> +		cfg_mac.inband = 0;
> +		cfg_mac.mode = PRESTERA_MAC_MODE_SR_LR;
> +		break;
> +	case PHY_INTERFACE_MODE_2500BASEX:
> +		cfg_mac.speed = SPEED_2500;
> +		cfg_mac.duplex = DUPLEX_FULL;
> +		cfg_mac.inband = test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
> +					  advertising);
> +		cfg_mac.mode = PRESTERA_MAC_MODE_SGMII;
> +		break;
> +	case PHY_INTERFACE_MODE_SGMII:
> +		cfg_mac.inband = 1;
> +		cfg_mac.mode = PRESTERA_MAC_MODE_SGMII;
> +		break;
> +	case PHY_INTERFACE_MODE_1000BASEX:
> +	default:
> +		cfg_mac.speed = SPEED_1000;
> +		cfg_mac.duplex = DUPLEX_FULL;
> +		cfg_mac.inband = test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
> +					  advertising);
> +		cfg_mac.mode = PRESTERA_MAC_MODE_1000BASE_X;
> +		break;
> +	}
> +
> +	err = prestera_port_cfg_mac_write(port, &cfg_mac);
> +	if (err)
> +		return err;
> +
> +	return 0;
> +}
> +
> +static void prestera_pcs_an_restart(struct phylink_pcs *pcs)
> +{
> +	/*
> +	 * TODO: add 100basex AN restart support

Possibly typo above ? s/100basex/1000basex/


Cheers,

Paolo

