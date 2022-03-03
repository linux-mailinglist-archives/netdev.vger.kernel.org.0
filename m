Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D414CC8BE
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 23:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236811AbiCCWVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 17:21:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233740AbiCCWVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 17:21:46 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A032D17E1B;
        Thu,  3 Mar 2022 14:20:59 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id r13so13683595ejd.5;
        Thu, 03 Mar 2022 14:20:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gchagVopNK8lmXE/dkbZYMIikzp69AM9bvHk1ChOAQA=;
        b=qWRmlJ2fPXogBs3j2JktggbX6j0t1oXRPsEPUnSyHm8Hy/mU5DPP8AVpkc6eU4NelK
         chyNggX00dEnNCQwmvTLg+O+/VpzWqxaTnumSLEcTQxdHqDzApsDTSVuyzsQaTHN8D35
         pVotLn1icc7iF1b97Q2Igfj4NMZ4PD1vFUDjRaKel4RbUL6A1tX+n19GQAA/5FE8W+v+
         l+sQei0jtQT/vVDTUHLifzfgROroWTvBO/2sCNbwcgDvYY0amKoHYY3i3QzDRX2+WnRo
         kxGyqZMFBkJX3uwClRPPQJTy5BJlVXUVI7eqZN0CDroroIa8cn8fazt22IsXsaMXZJGk
         LLUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gchagVopNK8lmXE/dkbZYMIikzp69AM9bvHk1ChOAQA=;
        b=HbNsuQ+qquWBFIEEmIRvFniDl9Rijifm9EOSjgLklXq/0pZdquZB2pflfT2UZqoCkU
         TvNblpulT0O8QbiVhOz7qzsFcOwzGLQ2Gkvkg8A5To/oElC/XA+vmC/oj+R6TkoONJ+0
         yz+O/KZca2iIerr0D8mHOspKCRdVB7lFc/DdBSK5tjkE9xwEvThnfsBIEbouFT2qC+72
         /3PtQ6xD8kPXxXNbIRXnHx1Fbuxh2ZPVx3sJVX4FtysFrIq0BtlzSWcLQQN/LCpRtlvy
         XgT2aQMyB+E//QNjVLAxbVGuT+yH6jcfzSWKb8R6AfvCPYDtmlT+Lte/zKQXR+rdlw88
         WYiQ==
X-Gm-Message-State: AOAM530dv6JmdlwDHEFW/Y6lemhGOSjoUhRvN7EKDdrPv7bc+ZbWntJt
        kslFNHt8snamKTjKOeyGG2E=
X-Google-Smtp-Source: ABdhPJxQOQZDEmlNo+GcmZzyqTNIMuj7IzqaKDUPvcpwpcyRb3JqcG4D0HpGIRC0RoStk3DKQdH/Uw==
X-Received: by 2002:a17:907:7e90:b0:6da:49e4:c7be with SMTP id qb16-20020a1709077e9000b006da49e4c7bemr8261187ejc.493.1646346057991;
        Thu, 03 Mar 2022 14:20:57 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id y12-20020a50eb8c000000b00410f02e577esm1401544edr.7.2022.03.03.14.20.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 14:20:57 -0800 (PST)
Date:   Fri, 4 Mar 2022 00:20:55 +0200
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
Subject: Re: [PATCH v2 net-next 07/10] net: dsa: Pass MST state changes to
 driver
Message-ID: <20220303222055.7a5pr4la3wmuuekc@skbuf>
References: <20220301100321.951175-1-tobias@waldekranz.com>
 <20220301100321.951175-8-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301100321.951175-8-tobias@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 01, 2022 at 11:03:18AM +0100, Tobias Waldekranz wrote:
> Add the usual trampoline functionality from the generic DSA layer down
> to the drivers for MST state changes.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  include/net/dsa.h  |  2 ++
>  net/dsa/dsa_priv.h |  2 ++
>  net/dsa/port.c     | 30 ++++++++++++++++++++++++++++++
>  net/dsa/slave.c    |  6 ++++++
>  4 files changed, 40 insertions(+)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index cc8acb01bd9b..096e6e3a8e1e 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -943,6 +943,8 @@ struct dsa_switch_ops {
>  				     struct dsa_bridge bridge);
>  	void	(*port_stp_state_set)(struct dsa_switch *ds, int port,
>  				      u8 state);
> +	int	(*port_mst_state_set)(struct dsa_switch *ds, int port,
> +				      const struct switchdev_mst_state *state);
>  	void	(*port_fast_age)(struct dsa_switch *ds, int port);
>  	int	(*port_pre_bridge_flags)(struct dsa_switch *ds, int port,
>  					 struct switchdev_brport_flags flags,
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index 87ec0697e92e..a620e079ebc5 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -198,6 +198,8 @@ static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
>  void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
>  			       const struct dsa_device_ops *tag_ops);
>  int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age);
> +int dsa_port_set_mst_state(struct dsa_port *dp,
> +			   const struct switchdev_mst_state *state);
>  int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy);
>  int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy);
>  void dsa_port_disable_rt(struct dsa_port *dp);
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index 5f45cb7d70ba..26cfbc8ab499 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -108,6 +108,36 @@ int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age)
>  	return 0;
>  }
>  
> +int dsa_port_set_mst_state(struct dsa_port *dp,
> +			   const struct switchdev_mst_state *state)
> +{
> +	struct dsa_switch *ds = dp->ds;
> +	int err, port = dp->index;
> +
> +	if (!ds->ops->port_mst_state_set)
> +		return -EOPNOTSUPP;
> +
> +	err = ds->ops->port_mst_state_set(ds, port, state);
> +	if (err)
> +		return err;
> +
> +	if (!dsa_port_can_configure_learning(dp) || dp->learning) {
> +		switch (state->state) {
> +		case BR_STATE_DISABLED:
> +		case BR_STATE_BLOCKING:
> +		case BR_STATE_LISTENING:
> +			/* Ideally we would only fast age entries
> +			 * belonging to VLANs controlled by this
> +			 * MST.
> +			 */
> +			dsa_port_fast_age(dp);

Does mv88e6xxx support this? If it does, you might just as well
introduce another variant of ds->ops->port_fast_age() for an msti.

And since it is new code, you could require that drivers _do_ support
configuring learning before they could support MSTP. After all, we don't
want to keep legacy mechanisms in place forever.

> +			break;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  static void dsa_port_set_state_now(struct dsa_port *dp, u8 state,
>  				   bool do_fast_age)
>  {
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index c6ffcd782b5a..32b006a5b778 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -288,6 +288,12 @@ static int dsa_slave_port_attr_set(struct net_device *dev, const void *ctx,
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
