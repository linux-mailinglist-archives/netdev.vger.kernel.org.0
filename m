Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA034DA047
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 17:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348064AbiCOQoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 12:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243203AbiCOQoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 12:44:06 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9822513D64;
        Tue, 15 Mar 2022 09:42:53 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id qt6so42697212ejb.11;
        Tue, 15 Mar 2022 09:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JTamCaodq8DZUWmddvJHCsZnxodFkrvUwlDWEYIddxk=;
        b=SO7mcUUQ5cuBsZf9cd40zo2ap7CxGJuBFRP/tytpIQGmHroj5Tou4gqfqNCjmWyA0+
         wt4z/0kdHSzD2MkqGAlZ/1HvJVKlDU9IoL8fb9zXZ8YCaBjUCEW/nSJV5J8ykJ9Y7Eqr
         GSPTOxdCWtgJ9GvJCH9g2TjV7oWH1lxkqLITdTRvMIVDJsT/vLRdBIwHn/t4iBnm/6Oq
         8PfjwXHepmyJSnz6Vw1HcmgAQIC0sS/e3MFd3vOW+qvLns7qK4Ds1b9xCA4lsEgPstab
         +XndbzWtRFASkQGI1FoBNrZFY98tIjemATjyJMSfnKkJM/VpHIosqV9wab+DKRp2sAQ0
         9OXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JTamCaodq8DZUWmddvJHCsZnxodFkrvUwlDWEYIddxk=;
        b=4cxG/xlOCtU96eSvvXXRpUn0KoN+oR/JFqRcfuVhBIKkoP4WgJC55d0ghnLpm9qACH
         0PKkEqaMAHGCVP18VmyIhKK9pltbIgyl8c4A9swLBytGQjEh7jYo2WZol1Hskoq6lKQs
         Ec0U3HE/+8kAf3DnpmQJYpGvh3tkD1y3+Cg0X9Zu9wDc89iLaHfq2aNsCpFEGwnIN7Y9
         vvDTFyE2HO86CAEBf0X2Guyj5bAlEozFeL/GQ2Z0u0wfpPhOPHfLxph3T+t78wLPFoHh
         ob5QQr8GNHRPyNafQLJCwqiUysADrYX65pk7qbRwFlHiRpZtX4Xk8aZb/3f4+fWFMiwV
         weLA==
X-Gm-Message-State: AOAM530+WxYGgvdk0UzwnBl3DutW1CsLKhrllaKdHAp+i2HL2Vwy1Mqv
        SXNKC9LUGeyx3YjuLSsiEAFZE3azDdo=
X-Google-Smtp-Source: ABdhPJzBg4qLl3NT0Ey6hst3IsaKJ5JT4da7UjACMRj4esDB10emUeIU1LGp76PgHGgivefVRFyZ1g==
X-Received: by 2002:a17:907:6daa:b0:6d7:27b2:409 with SMTP id sb42-20020a1709076daa00b006d727b20409mr23460815ejc.409.1647362571914;
        Tue, 15 Mar 2022 09:42:51 -0700 (PDT)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id gv54-20020a1709072bf600b006da7953530bsm8311416ejc.104.2022.03.15.09.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 09:42:51 -0700 (PDT)
Date:   Tue, 15 Mar 2022 18:42:49 +0200
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
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH v4 net-next 12/15] net: dsa: Handle MST state changes
Message-ID: <20220315164249.sjgi6wbdpgehc6m6@skbuf>
References: <20220315002543.190587-1-tobias@waldekranz.com>
 <20220315002543.190587-13-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315002543.190587-13-tobias@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 01:25:40AM +0100, Tobias Waldekranz wrote:
> Add the usual trampoline functionality from the generic DSA layer down
> to the drivers for MST state changes.
> 
> When a state changes to disabled/blocking/listening, make sure to fast
> age any dynamic entries in the affected VLANs (those controlled by the
> MSTI in question).
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  include/net/dsa.h  |  3 ++
>  net/dsa/dsa_priv.h |  2 ++
>  net/dsa/port.c     | 70 +++++++++++++++++++++++++++++++++++++++++++---
>  net/dsa/slave.c    |  6 ++++
>  4 files changed, 77 insertions(+), 4 deletions(-)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 1ddaa2cc5842..0f369f2e9a97 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -945,7 +945,10 @@ struct dsa_switch_ops {
>  				     struct dsa_bridge bridge);
>  	void	(*port_stp_state_set)(struct dsa_switch *ds, int port,
>  				      u8 state);
> +	int	(*port_mst_state_set)(struct dsa_switch *ds, int port,
> +				      const struct switchdev_mst_state *state);
>  	void	(*port_fast_age)(struct dsa_switch *ds, int port);
> +	int	(*port_vlan_fast_age)(struct dsa_switch *ds, int port, u16 vid);
>  	int	(*port_pre_bridge_flags)(struct dsa_switch *ds, int port,
>  					 struct switchdev_brport_flags flags,
>  					 struct netlink_ext_ack *extack);
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index d90b4cf0c9d2..2ae8996cf7c8 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -215,6 +215,8 @@ static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
>  void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
>  			       const struct dsa_device_ops *tag_ops);
>  int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age);
> +int dsa_port_set_mst_state(struct dsa_port *dp,
> +			   const struct switchdev_mst_state *state);
>  int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy);
>  int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy);
>  void dsa_port_disable_rt(struct dsa_port *dp);
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index 3ac114f6fc22..a2a817bb77b1 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -30,12 +30,11 @@ static int dsa_port_notify(const struct dsa_port *dp, unsigned long e, void *v)
>  	return dsa_tree_notify(dp->ds->dst, e, v);
>  }
>  
> -static void dsa_port_notify_bridge_fdb_flush(const struct dsa_port *dp)
> +static void dsa_port_notify_bridge_fdb_flush(const struct dsa_port *dp, u16 vid)
>  {
>  	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
>  	struct switchdev_notifier_fdb_info info = {
> -		/* flush all VLANs */
> -		.vid = 0,
> +		.vid = vid,
>  	};
>  
>  	/* When the port becomes standalone it has already left the bridge.
> @@ -57,7 +56,42 @@ static void dsa_port_fast_age(const struct dsa_port *dp)
>  
>  	ds->ops->port_fast_age(ds, dp->index);
>  
> -	dsa_port_notify_bridge_fdb_flush(dp);
> +	/* flush all VLANs */
> +	dsa_port_notify_bridge_fdb_flush(dp, 0);
> +}
> +
> +static int dsa_port_vlan_fast_age(const struct dsa_port *dp, u16 vid)
> +{
> +	struct dsa_switch *ds = dp->ds;
> +	int err;
> +
> +	if (!ds->ops->port_vlan_fast_age)
> +		return -EOPNOTSUPP;
> +
> +	err = ds->ops->port_vlan_fast_age(ds, dp->index, vid);
> +
> +	if (!err)
> +		dsa_port_notify_bridge_fdb_flush(dp, vid);
> +
> +	return err;
> +}
> +
> +static int dsa_port_msti_fast_age(const struct dsa_port *dp, u16 msti)
> +{
> +	DECLARE_BITMAP(vids, VLAN_N_VID) = { 0 };
> +	int err, vid;
> +
> +	err = br_mst_get_info(dsa_port_bridge_dev_get(dp), msti, vids);
> +	if (err)
> +		return err;
> +
> +	for_each_set_bit(vid, vids, VLAN_N_VID) {
> +		err = dsa_port_vlan_fast_age(dp, vid);
> +		if (err)
> +			return err;
> +	}
> +
> +	return 0;
>  }
>  
>  static bool dsa_port_can_configure_learning(struct dsa_port *dp)
> @@ -118,6 +152,32 @@ static void dsa_port_set_state_now(struct dsa_port *dp, u8 state,
>  		pr_err("DSA: failed to set STP state %u (%d)\n", state, err);
>  }
>  
> +int dsa_port_set_mst_state(struct dsa_port *dp,
> +			   const struct switchdev_mst_state *state)
> +{
> +	struct dsa_switch *ds = dp->ds;
> +	int err;
> +
> +	if (!ds->ops->port_mst_state_set)
> +		return -EOPNOTSUPP;
> +
> +	err = ds->ops->port_mst_state_set(ds, dp->index, state);
> +	if (err)
> +		return err;
> +
> +	if (dp->learning) {
> +		switch (state->state) {
> +		case BR_STATE_DISABLED:
> +		case BR_STATE_BLOCKING:
> +		case BR_STATE_LISTENING:

Is there a requirement in br_mst_set_state() to put the switchdev
notifier at the end instead of at the beginning?

I'm tempted to ask you to introduce br_mst_get_state(), then assign
old_state = br_mst_get_state(dsa_port_bridge_dev_get(dp), state->msti),
then perform the VLAN fast age only on the appropriate state transitions,
just like the regular fast age.

> +			err = dsa_port_msti_fast_age(dp, state->msti);
> +			break;
> +		}
> +	}
> +
> +	return err;
> +}
> +
>  int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy)
>  {
>  	struct dsa_switch *ds = dp->ds;
> @@ -326,6 +386,8 @@ static bool dsa_port_supports_mst(struct dsa_port *dp)
>  	struct dsa_switch *ds = dp->ds;
>  
>  	return ds->ops->vlan_msti_set &&
> +		ds->ops->port_mst_state_set &&
> +		ds->ops->port_vlan_fast_age &&
>  		dsa_port_can_configure_learning(dp);
>  }
>  
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 5e986cdeaae5..4300fc76f3af 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -450,6 +450,12 @@ static int dsa_slave_port_attr_set(struct net_device *dev, const void *ctx,
>  
>  		ret = dsa_port_set_state(dp, attr->u.stp_state, true);
>  		break;
> +	case SWITCHDEV_ATTR_ID_PORT_MST_STATE:
> +		if (!dsa_port_offloads_bridge_port(dp, attr->orig_dev))
> +			return -EOPNOTSUPP;
> +
> +		ret = dsa_port_set_mst_state(dp, &attr->u.mst_state);
> +		break;
>  	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
>  		if (!dsa_port_offloads_bridge_dev(dp, attr->orig_dev))
>  			return -EOPNOTSUPP;
> -- 
> 2.25.1
> 

