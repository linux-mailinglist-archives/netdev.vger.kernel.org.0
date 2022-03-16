Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2727B4DB579
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 16:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239076AbiCPP54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 11:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343799AbiCPP5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 11:57:50 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4695F4F4;
        Wed, 16 Mar 2022 08:56:35 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id t1so3307241edc.3;
        Wed, 16 Mar 2022 08:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fYTwMwhaHOqu+6/k3NuAGC+IM8WS6lvggjF69KksFcc=;
        b=YJ2CaPzJEfD37I6Ai3c4Ko6Wv97okVB45+r1aq5NulG4CwQJpehDWgudC1HRo3fUsC
         ikCSGKWUvXOdTeNsZuYaFRDkqPLKKFPkU9NVlx+kVCMeTWxCFtlWyaYJO1LCBIyuJ2Gm
         gY8d7XkMBK4U5I1Skm6uq79RlHF6b5v3muY2WqYs29Uj3tpuMmkdeagV8iemMfJ4TU9f
         TR8VQgK4HWijhUqG5Pi4yrGpXY+1Ji2M536cTXmRQEo4H5R9+GHNe8pPV7+Uq9v+HFFj
         M4Lv8zX0ZdZu/tHjjfdQ4JhFfFu4sbe89fD5GBKALHwf3FOMETdmAzs4hWIMkQoClOME
         VOcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fYTwMwhaHOqu+6/k3NuAGC+IM8WS6lvggjF69KksFcc=;
        b=mtvB2rByO5sHp+DE8X0ogTB5TKYDmZYcf/n0bXHFHESjMy+aV/kprBoK0IVzyrdrTj
         +h+fbMC5gGbN4zThT9ff1AKCzqEqli4CeQwroFvUkBHa2lB+XPiUygBPSepKxblz7EXI
         S7X1PC9dxzO1P1VS5XRFa+MDlQZGrMDgMLoMrmGMG3Z27Z1gq8WpMCfcqsE7tEzGxg1W
         USInQlut9VCJCYs0lI9Ptewq/x6uEzNBPxkvFy9xsAg4Q5aT+MekVev88LdarovvM8Kp
         /NLBaZN5TNAi3VuWesf1GYdsvmQt2yUGZMBbnGzGsOcM8gjWbu4QYsHk7Rnf9YwShjN8
         KOKA==
X-Gm-Message-State: AOAM532w8F0yP9Os0U/hcP+dcYjy9rYQ/HxLCExHDD7hWWjUjVy6EVqb
        95vToVkPXC2AJhXyRSkURWQ=
X-Google-Smtp-Source: ABdhPJwSepmnpUGTKr+8iCQn9Bc9XYcJmkSqhFDpz1nTJIKvKN2Sxt+sapuJ2PNJISfCy74JD7svrQ==
X-Received: by 2002:a05:6402:370b:b0:413:3bcd:3d0e with SMTP id ek11-20020a056402370b00b004133bcd3d0emr181832edb.178.1647446193518;
        Wed, 16 Mar 2022 08:56:33 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id y12-20020a056402358c00b00418d7f02d63sm1166978edc.53.2022.03.16.08.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 08:56:33 -0700 (PDT)
Date:   Wed, 16 Mar 2022 17:56:31 +0200
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
Subject: Re: [PATCH v5 net-next 12/15] net: dsa: Handle MST state changes
Message-ID: <20220316155631.h5e6kls2d5gpk3p4@skbuf>
References: <20220316150857.2442916-1-tobias@waldekranz.com>
 <20220316150857.2442916-13-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316150857.2442916-13-tobias@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 16, 2022 at 04:08:54PM +0100, Tobias Waldekranz wrote:
> Add the usual trampoline functionality from the generic DSA layer down
> to the drivers for MST state changes.
> 
> When a state changes to disabled/blocking/listening, make sure to fast
> age any dynamic entries in the affected VLANs (those controlled by the
> MSTI in question).
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

>  include/net/dsa.h  |  3 ++
>  net/dsa/dsa_priv.h |  3 ++
>  net/dsa/port.c     | 85 +++++++++++++++++++++++++++++++++++++++++-----
>  net/dsa/slave.c    |  6 ++++
>  4 files changed, 89 insertions(+), 8 deletions(-)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 644fda2293a2..06cdefd3b9dd 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -957,7 +957,10 @@ struct dsa_switch_ops {
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
> index d90b4cf0c9d2..5d3f4a67dce1 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -215,6 +215,9 @@ static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
>  void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
>  			       const struct dsa_device_ops *tag_ops);
>  int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age);
> +int dsa_port_set_mst_state(struct dsa_port *dp,
> +			   const struct switchdev_mst_state *state,
> +			   struct netlink_ext_ack *extack);
>  int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy);
>  int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy);
>  void dsa_port_disable_rt(struct dsa_port *dp);
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index 3ac114f6fc22..32d472a82241 100644
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
> @@ -118,6 +152,42 @@ static void dsa_port_set_state_now(struct dsa_port *dp, u8 state,
>  		pr_err("DSA: failed to set STP state %u (%d)\n", state, err);
>  }
>  
> +int dsa_port_set_mst_state(struct dsa_port *dp,
> +			   const struct switchdev_mst_state *state,
> +			   struct netlink_ext_ack *extack)
> +{
> +	struct dsa_switch *ds = dp->ds;
> +	u8 prev_state;
> +	int err;
> +
> +	if (!ds->ops->port_mst_state_set)
> +		return -EOPNOTSUPP;
> +
> +	err = br_mst_get_state(dsa_port_to_bridge_port(dp), state->msti,
> +			       &prev_state);
> +	if (err)
> +		return err;
> +
> +	err = ds->ops->port_mst_state_set(ds, dp->index, state);
> +	if (err)
> +		return err;
> +
> +	if (!(dp->learning &&
> +	      (prev_state == BR_STATE_LEARNING ||
> +	       prev_state == BR_STATE_FORWARDING) &&
> +	      (state->state == BR_STATE_DISABLED ||
> +	       state->state == BR_STATE_BLOCKING ||
> +	       state->state == BR_STATE_LISTENING)))
> +		return 0;
> +
> +	err = dsa_port_msti_fast_age(dp, state->msti);
> +	if (err)
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "Unable to flush associated VLANs");
> +
> +	return 0;
> +}
> +
>  int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy)
>  {
>  	struct dsa_switch *ds = dp->ds;
> @@ -326,6 +396,8 @@ static bool dsa_port_supports_mst(struct dsa_port *dp)
>  	struct dsa_switch *ds = dp->ds;
>  
>  	return ds->ops->vlan_msti_set &&
> +		ds->ops->port_mst_state_set &&
> +		ds->ops->port_vlan_fast_age &&
>  		dsa_port_can_configure_learning(dp);
>  }
>  
> @@ -749,10 +821,7 @@ int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock)
>  int dsa_port_mst_enable(struct dsa_port *dp, bool on,
>  			struct netlink_ext_ack *extack)
>  {
> -	if (!on)
> -		return 0;
> -
> -	if (!dsa_port_supports_mst(dp)) {
> +	if (on && !dsa_port_supports_mst(dp)) {

You fixed up a different patch by accident (not the one which originally
introduced dsa_port_mst_enable).

Anyway, this is a complete non-issue because the code ends up looking as
discussed during the previous review, and the fixup is only cosmetic in
any case.

>  		NL_SET_ERR_MSG_MOD(extack, "Hardware does not support MST");
>  		return -EINVAL;
>  	}
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 1b3e792d0327..17615b706359 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -451,6 +451,12 @@ static int dsa_slave_port_attr_set(struct net_device *dev, const void *ctx,
>  
>  		ret = dsa_port_set_state(dp, attr->u.stp_state, true);
>  		break;
> +	case SWITCHDEV_ATTR_ID_PORT_MST_STATE:
> +		if (!dsa_port_offloads_bridge_port(dp, attr->orig_dev))
> +			return -EOPNOTSUPP;
> +
> +		ret = dsa_port_set_mst_state(dp, &attr->u.mst_state, extack);
> +		break;
>  	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
>  		if (!dsa_port_offloads_bridge_dev(dp, attr->orig_dev))
>  			return -EOPNOTSUPP;
> -- 
> 2.25.1
> 
