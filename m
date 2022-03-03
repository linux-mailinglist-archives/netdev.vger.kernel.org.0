Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E95C34CC777
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 21:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236392AbiCCVAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 16:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235783AbiCCVAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 16:00:12 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42F310B8;
        Thu,  3 Mar 2022 12:59:25 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id i11so8196812eda.9;
        Thu, 03 Mar 2022 12:59:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2jvymI+YIK1YP+SxTJS86Vk86ZHIqmMtl8I6cmHaozU=;
        b=kDg72aUsPanwwxkWPEPBy1iRsw+wks3Vhk4NCYeXPs/EAzXBlPMvIjPof6RBPJsJf3
         HF9+w9KlJawyapd8l2fK7mtPCAU2dcB/O38pPtexE2F5xY7qUfJ5yue9FkLjowtGJ2uH
         Zzyb7j2SjnqMtB67PcX2vVyjZt7XPF7aWnPeuZwIR/9eRKyVu7w/sX3VgcSBx7a2ySOT
         W3vOG31+oIb/kASH4ij62Vy7bFFcJIvHj58HdOivJc4yGJaugDfe0r/U+iwGc37Us65C
         neC8g+HHL8LOMaEedVeaU8MmTws01LWq4Xs2t+XdCDay84Ja4Z881/GWy7WLpWDpwm9J
         RGWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2jvymI+YIK1YP+SxTJS86Vk86ZHIqmMtl8I6cmHaozU=;
        b=uXWIxnNlLoi/oN+NHNjeuQf9o9LHYOQZf6G4yrH8pFrEDnDNRHeqSRvr8nny49MEwt
         vtpd6k5eQWWlbBA3nxYJH4Tb2hbCvYNQmVC7lvRUPlMg91ONge5UIo8hF6WXUWWqjMnw
         hdKUquzGC2BFK0dDP+EmDjGTUB+TB/isFfOdtsPb9hiKkwsfxMyiA2cw5flgVewpm4Fq
         pa8s58SEGJ80UiyQHb5t0Bgm6DmrRZ6FYJSo9VujH26gUulwJ0ndyKBZq+PwLo9U1nrc
         h/qte1C7aKPbldj9j2vw1RJvFRyP1tHzLHE6uNndxC363LY7SpuXWcdImzdmOj5MFWrJ
         uSFw==
X-Gm-Message-State: AOAM533GGDC006mG6UbkJDU467r9DiXI+qg8Ba/4DoiHqBLqkp+Oiyax
        MDBGCxlTDw7wwXdR+f6x5WJCHQ9HuF8=
X-Google-Smtp-Source: ABdhPJxjcPWCZpP0bxm044IN0jLhnsfPMNP+rk0+qlnl7pDYiRve/ioLDHwyXutjCmOg9H+WuSVn7Q==
X-Received: by 2002:aa7:cac8:0:b0:410:cc6c:6512 with SMTP id l8-20020aa7cac8000000b00410cc6c6512mr36024932edt.408.1646341164152;
        Thu, 03 Mar 2022 12:59:24 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id cf10-20020a0564020b8a00b00412b19c1aaesm1247433edb.12.2022.03.03.12.59.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 12:59:23 -0800 (PST)
Date:   Thu, 3 Mar 2022 22:59:21 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Cooper Lees <me@cooperlees.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH v2 net-next 04/10] net: bridge: mst: Notify switchdev
 drivers of VLAN MSTI migrations
Message-ID: <20220303205921.sxb52jzw4jcdj6m7@skbuf>
References: <20220301100321.951175-1-tobias@waldekranz.com>
 <20220301100321.951175-5-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301100321.951175-5-tobias@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 01, 2022 at 11:03:15AM +0100, Tobias Waldekranz wrote:
> Whenever a VLAN moves to a new MSTI, send a switchdev notification so
> that switchdevs can...
> 
> ...either refuse the migration if the hardware does not support
> offloading of MST...
> 
> ..or track a bridge's VID to MSTI mapping when offloading is
> supported.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  include/net/switchdev.h   | 10 +++++++
>  net/bridge/br_mst.c       | 15 +++++++++++
>  net/bridge/br_switchdev.c | 57 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 82 insertions(+)
> 
> diff --git a/include/net/switchdev.h b/include/net/switchdev.h
> index 3e424d40fae3..39e57aa5005a 100644
> --- a/include/net/switchdev.h
> +++ b/include/net/switchdev.h
> @@ -28,6 +28,7 @@ enum switchdev_attr_id {
>  	SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED,
>  	SWITCHDEV_ATTR_ID_BRIDGE_MROUTER,
>  	SWITCHDEV_ATTR_ID_MRP_PORT_ROLE,
> +	SWITCHDEV_ATTR_ID_VLAN_MSTI,
>  };
>  
>  struct switchdev_brport_flags {
> @@ -35,6 +36,14 @@ struct switchdev_brport_flags {
>  	unsigned long mask;
>  };
>  
> +struct switchdev_vlan_attr {
> +	u16 vid;
> +
> +	union {
> +		u16 msti;
> +	};

Do you see other VLAN attributes that would be added in the future, such
as to justify making this a single-element union from the get-go?
Anyway if that is the case, we're lacking an id for the attribute type,
so we'd end up needing to change drivers when a second union element
appears. Otherwise they'd all expect an u16 msti.

> +};
> +
>  struct switchdev_attr {
>  	struct net_device *orig_dev;
>  	enum switchdev_attr_id id;
> @@ -50,6 +59,7 @@ struct switchdev_attr {
>  		u16 vlan_protocol;			/* BRIDGE_VLAN_PROTOCOL */
>  		bool mc_disabled;			/* MC_DISABLED */
>  		u8 mrp_port_role;			/* MRP_PORT_ROLE */
> +		struct switchdev_vlan_attr vlan_attr;	/* VLAN_* */
>  	} u;
>  };
>  
> diff --git a/net/bridge/br_mst.c b/net/bridge/br_mst.c
> index 8dea8e7257fd..aba603675165 100644
> --- a/net/bridge/br_mst.c
> +++ b/net/bridge/br_mst.c
> @@ -7,6 +7,7 @@
>   */
>  
>  #include <linux/kernel.h>
> +#include <net/switchdev.h>
>  
>  #include "br_private.h"
>  
> @@ -65,9 +66,23 @@ static void br_mst_vlan_sync_state(struct net_bridge_vlan *pv, u16 msti)
>  
>  int br_mst_vlan_set_msti(struct net_bridge_vlan *mv, u16 msti)
>  {
> +	struct switchdev_attr attr = {
> +		.id = SWITCHDEV_ATTR_ID_VLAN_MSTI,
> +		.flags = SWITCHDEV_F_DEFER,

Is the bridge spinlock held (atomic context), or otherwise why is
SWITCHDEV_F_DEFER needed here?

> +		.orig_dev = mv->br->dev,
> +		.u.vlan_attr = {
> +			.vid = mv->vid,
> +			.msti = msti,
> +		},
> +	};
>  	struct net_bridge_vlan_group *vg;
>  	struct net_bridge_vlan *pv;
>  	struct net_bridge_port *p;
> +	int err;
> +
> +	err = switchdev_port_attr_set(mv->br->dev, &attr, NULL);

Treating a "VLAN attribute" as a "port attribute of the bridge" is
pushing the taxonomy just a little, but I don't have a better suggestion.

> +	if (err && err != -EOPNOTSUPP)
> +		return err;
>  
>  	mv->msti = msti;
>  
> diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> index 6f6a70121a5e..160d7659f88a 100644
> --- a/net/bridge/br_switchdev.c
> +++ b/net/bridge/br_switchdev.c
> @@ -428,6 +428,57 @@ static int br_switchdev_vlan_replay(struct net_device *br_dev,
>  	return 0;
>  }
>  
> +static int br_switchdev_mst_replay(struct net_device *br_dev,
> +				   const void *ctx, bool adding,
> +				   struct notifier_block *nb,
> +				   struct netlink_ext_ack *extack)

"bool adding" is unused, and replaying the VLAN to MSTI associations
before deleting them makes little sense anyway.

I understand the appeal of symmetry, so maybe put an

	if (adding) {
		err = br_switchdev_vlan_attr_replay(...);
		if (err && err != -EOPNOTSUPP)
			return err;
	}

at the end of br_switchdev_vlan_replay()?

> +{
> +	struct switchdev_notifier_port_attr_info attr_info = {
> +		.info = {
> +			.dev = br_dev,
> +			.extack = extack,
> +			.ctx = ctx,
> +		},
> +	};
> +	struct net_bridge *br = netdev_priv(br_dev);
> +	struct net_bridge_vlan_group *vg;
> +	struct net_bridge_vlan *v;
> +	int err;
> +
> +	ASSERT_RTNL();
> +
> +	if (!nb)
> +		return 0;
> +
> +	if (!netif_is_bridge_master(br_dev))
> +		return -EINVAL;
> +
> +	vg = br_vlan_group(br);
> +
> +	list_for_each_entry(v, &vg->vlan_list, vlist) {
> +		struct switchdev_attr attr = {
> +			.id = SWITCHDEV_ATTR_ID_VLAN_MSTI,
> +			.flags = SWITCHDEV_F_DEFER,

I don't think SWITCHDEV_F_DEFER has any effect on a replay.

> +			.orig_dev = br_dev,
> +			.u.vlan_attr = {
> +				.vid = v->vid,
> +				.msti = v->msti,
> +			}
> +		};
> +
> +		if (!v->msti)
> +			continue;
> +
> +		attr_info.attr = &attr;
> +		err = nb->notifier_call(nb, SWITCHDEV_PORT_ATTR_SET, &attr_info);
> +		err = notifier_to_errno(err);
> +		if (err)
> +			return err;
> +	}
> +
> +	return 0;
> +}
> +
>  #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
>  struct br_switchdev_mdb_complete_info {
>  	struct net_bridge_port *port;
> @@ -695,6 +746,10 @@ static int nbp_switchdev_sync_objs(struct net_bridge_port *p, const void *ctx,
>  	if (err && err != -EOPNOTSUPP)
>  		return err;
>  
> +	err = br_switchdev_mst_replay(br_dev, ctx, true, blocking_nb, extack);
> +	if (err && err != -EOPNOTSUPP)
> +		return err;
> +
>  	err = br_switchdev_mdb_replay(br_dev, dev, ctx, true, blocking_nb,
>  				      extack);
>  	if (err && err != -EOPNOTSUPP)
> @@ -719,6 +774,8 @@ static void nbp_switchdev_unsync_objs(struct net_bridge_port *p,
>  
>  	br_switchdev_mdb_replay(br_dev, dev, ctx, false, blocking_nb, NULL);
>  
> +	br_switchdev_mst_replay(br_dev, ctx, false, blocking_nb, NULL);
> +
>  	br_switchdev_vlan_replay(br_dev, ctx, false, blocking_nb, NULL);
>  }
>  
> -- 
> 2.25.1
> 

