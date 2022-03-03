Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0344A4CC8D9
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 23:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236878AbiCCW17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 17:27:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236876AbiCCW1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 17:27:48 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CD74F47B;
        Thu,  3 Mar 2022 14:27:01 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id qx21so13635117ejb.13;
        Thu, 03 Mar 2022 14:27:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yvBR6/IvUTAy1bANbbpXGC5z72LIKH1nIGX4oOMhaMU=;
        b=BpJwGAQW84cLVk8DEMKXYdh8j2QwEz6jVgV+BnTce2pFxdFHGfZBUAZwvnzx/wTrpI
         9nXa2RhFC5pmDw9rH1aDK8Glad9PhfEOTUjund4zkZBeaUYnal5Dx3U9zBuDnfptMIkS
         uZjXYJIV2gIin4p04fPJAzMdvKfjD5RhXG9jbH8uwwmWeOorV+RXBx/uOXK5A3AOH3iS
         CRQ1nzT1uRd57fkm9T06gKCdA9vr3JKEfDlKBAviDvriP9Qi3ohY77q6Y+v+4C9H1c6e
         TflPaTgH8mjrM7nBittLR7iH1RTNRIiANGObgS0mp5N7sZbvowQpdpLlfEScUlsoAjf9
         gYZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yvBR6/IvUTAy1bANbbpXGC5z72LIKH1nIGX4oOMhaMU=;
        b=rAt1wuKp474+XG1Gqo6yIRCLV/B9ZewYxjw+RPIttwdmESyayNaE8feAmJq0wy2G7/
         WAcN+yLeMqnE7XvVQVX3hUbsIH2j8In24vFsFCgnxJRYKI8+sYuE7XGJkswIlpiHccwr
         demLwtsuEwVhTBmy+ozpqNd7GUwDbZ+sPQRXqvVznx4/lqe35TFPnm3lI4ClABwMRDdO
         k55++MNnAxSu3mdfcRRa3wguczfP16y8RzDnqs7Daq+9QH3baNnteySozQGOx/LJMNWU
         f2plvawBkfGGOyOwB90wEhasTcJ0xrDdGuVR7z0FHysC5CGM4kNqn7Wh2hg2PeLfN007
         rimA==
X-Gm-Message-State: AOAM532rJ+pFSQiQ6c+JSt849vaXs2me90dnOrX48QXJscpR/H/C+A6X
        Yd/XdpbU8QUR7PjBEyQ0E0w=
X-Google-Smtp-Source: ABdhPJzjQlx/66STW0OwxgQk/AE0IiAOzrzsJ3GXgzshil/20yI3D+SRLP7P4pCCtI68Fdg9MC49FQ==
X-Received: by 2002:a17:907:7f0d:b0:6d6:f910:5136 with SMTP id qf13-20020a1709077f0d00b006d6f9105136mr11800918ejc.736.1646346420166;
        Thu, 03 Mar 2022 14:27:00 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id y12-20020a50eb8c000000b00410f02e577esm1405990edr.7.2022.03.03.14.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 14:26:59 -0800 (PST)
Date:   Fri, 4 Mar 2022 00:26:58 +0200
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
Subject: Re: [PATCH v2 net-next 10/10] net: dsa: mv88e6xxx: MST Offloading
Message-ID: <20220303222658.7ykn6grkkp6htm7a@skbuf>
References: <20220301100321.951175-1-tobias@waldekranz.com>
 <20220301100321.951175-11-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301100321.951175-11-tobias@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 01, 2022 at 11:03:21AM +0100, Tobias Waldekranz wrote:
> Allocate a SID in the STU for each MSTID in use by a bridge and handle
> the mapping of MSTIDs to VLANs using the SID field of each VTU entry.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 178 +++++++++++++++++++++++++++++++
>  drivers/net/dsa/mv88e6xxx/chip.h |  13 +++
>  2 files changed, 191 insertions(+)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index c14a62aa6a6c..4fb4ec1dff79 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -1818,6 +1818,137 @@ static int mv88e6xxx_stu_setup(struct mv88e6xxx_chip *chip)
>  	return mv88e6xxx_stu_loadpurge(chip, &stu);
>  }
>  
> +static int mv88e6xxx_sid_new(struct mv88e6xxx_chip *chip, u8 *sid)
> +{
> +	DECLARE_BITMAP(busy, MV88E6XXX_N_SID) = { 0 };
> +	struct mv88e6xxx_mst *mst;
> +
> +	set_bit(0, busy);
> +
> +	list_for_each_entry(mst, &chip->msts, node) {
> +		set_bit(mst->stu.sid, busy);
> +	}
> +
> +	*sid = find_first_zero_bit(busy, MV88E6XXX_N_SID);
> +
> +	return (*sid >= mv88e6xxx_max_sid(chip)) ? -ENOSPC : 0;
> +}
> +
> +static int mv88e6xxx_sid_put(struct mv88e6xxx_chip *chip, u8 sid)
> +{
> +	struct mv88e6xxx_mst *mst, *tmp;
> +	int err = 0;
> +
> +	list_for_each_entry_safe(mst, tmp, &chip->msts, node) {
> +		if (mst->stu.sid == sid) {
> +			if (refcount_dec_and_test(&mst->refcnt)) {
> +				mst->stu.valid = false;
> +				err = mv88e6xxx_stu_loadpurge(chip, &mst->stu);

It is interesting what to do if this fails. Possibly not this, because
the entry remains in hardware but not in software.

> +				list_del(&mst->node);
> +				kfree(mst);
> +			}
> +
> +			return err;
> +		}
> +	}
> +
> +	return -ENOENT;
> +}
> +
> +static int mv88e6xxx_sid_get(struct mv88e6xxx_chip *chip, struct net_device *br,
> +			     u16 msti, u8 *sid)
> +{
> +	struct mv88e6xxx_mst *mst;
> +	int err, i;
> +
> +	if (!br)
> +		return 0;

Is this condition possible?

> +
> +	if (!mv88e6xxx_has_stu(chip))
> +		return -EOPNOTSUPP;
> +
> +	list_for_each_entry(mst, &chip->msts, node) {
> +		if (mst->br == br && mst->msti == msti) {
> +			refcount_inc(&mst->refcnt);
> +			*sid = mst->stu.sid;
> +			return 0;
> +		}
> +	}
> +
> +	err = mv88e6xxx_sid_new(chip, sid);
> +	if (err)
> +		return err;
> +
> +	mst = kzalloc(sizeof(*mst), GFP_KERNEL);
> +	if (!mst)
> +		return -ENOMEM;

This leaks the new SID.

> +
> +	INIT_LIST_HEAD(&mst->node);
> +	refcount_set(&mst->refcnt, 1);
> +	mst->br = br;
> +	mst->msti = msti;
> +	mst->stu.valid = true;
> +	mst->stu.sid = *sid;
> +
> +	/* The bridge starts out all ports in the disabled state. But
> +	 * a STU state of disabled means to go by the port-global
> +	 * state. So we set all user port's initial state to blocking,
> +	 * to match the bridge's behavior.
> +	 */
> +	for (i = 0; i < mv88e6xxx_num_ports(chip); i++)
> +		mst->stu.state[i] = dsa_is_user_port(chip->ds, i) ?
> +			MV88E6XXX_PORT_CTL0_STATE_BLOCKING :
> +			MV88E6XXX_PORT_CTL0_STATE_DISABLED;
> +
> +	list_add_tail(&mst->node, &chip->msts);
> +	return mv88e6xxx_stu_loadpurge(chip, &mst->stu);

And this doesn't behave too well on failure (the MSTID exists in
software but not in hardware).

> +}
> +
> +static int mv88e6xxx_port_mst_state_set(struct dsa_switch *ds, int port,
> +					const struct switchdev_mst_state *st)
> +{
> +	struct dsa_port *dp = dsa_to_port(ds, port);
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +	struct mv88e6xxx_mst *mst;
> +	u8 state;
> +	int err;
> +
> +	if (!mv88e6xxx_has_stu(chip))
> +		return -EOPNOTSUPP;
> +
> +	switch (st->state) {
> +	case BR_STATE_DISABLED:
> +	case BR_STATE_BLOCKING:
> +	case BR_STATE_LISTENING:
> +		state = MV88E6XXX_PORT_CTL0_STATE_BLOCKING;
> +		break;
> +	case BR_STATE_LEARNING:
> +		state = MV88E6XXX_PORT_CTL0_STATE_LEARNING;
> +		break;
> +	case BR_STATE_FORWARDING:
> +		state = MV88E6XXX_PORT_CTL0_STATE_FORWARDING;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	list_for_each_entry(mst, &chip->msts, node) {
> +		if (mst->br == dsa_port_bridge_dev_get(dp) &&
> +		    mst->msti == st->msti) {
> +			if (mst->stu.state[port] == state)
> +				return 0;
> +
> +			mst->stu.state[port] = state;
> +			mv88e6xxx_reg_lock(chip);
> +			err = mv88e6xxx_stu_loadpurge(chip, &mst->stu);
> +			mv88e6xxx_reg_unlock(chip);
> +			return err;
> +		}
> +	}
> +
> +	return -ENOENT;
> +}
> +
>  static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
>  					u16 vid)
>  {
> @@ -2437,6 +2568,12 @@ static int mv88e6xxx_port_vlan_leave(struct mv88e6xxx_chip *chip,
>  	if (err)
>  		return err;
>  
> +	if (!vlan.valid && vlan.sid) {
> +		err = mv88e6xxx_sid_put(chip, vlan.sid);
> +		if (err)
> +			return err;
> +	}
> +
>  	return mv88e6xxx_g1_atu_remove(chip, vlan.fid, port, false);
>  }
>  
> @@ -2482,6 +2619,44 @@ static int mv88e6xxx_port_vlan_del(struct dsa_switch *ds, int port,
>  	return err;
>  }
>  
> +static int mv88e6xxx_vlan_msti_set(struct dsa_switch *ds,
> +				   const struct switchdev_attr *attr)
> +{
> +	const struct switchdev_vlan_attr *vattr = &attr->u.vlan_attr;
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +	struct mv88e6xxx_vtu_entry vlan;
> +	u8 new_sid;
> +	int err;
> +
> +	mv88e6xxx_reg_lock(chip);
> +
> +	err = mv88e6xxx_vtu_get(chip, vattr->vid, &vlan);
> +	if (err)
> +		goto unlock;
> +
> +	if (!vlan.valid) {
> +		err = -EINVAL;
> +		goto unlock;
> +	}
> +
> +	err = mv88e6xxx_sid_get(chip, attr->orig_dev, vattr->msti, &new_sid);
> +	if (err)
> +		goto unlock;
> +
> +	if (vlan.sid) {
> +		err = mv88e6xxx_sid_put(chip, vlan.sid);
> +		if (err)
> +			goto unlock;
> +	}
> +
> +	vlan.sid = new_sid;
> +	err = mv88e6xxx_vtu_loadpurge(chip, &vlan);

Maybe you could move mv88e6xxx_sid_put() after this succeeds?

> +
> +unlock:
> +	mv88e6xxx_reg_unlock(chip);
> +	return err;
> +}
> +
>  static int mv88e6xxx_port_fdb_add(struct dsa_switch *ds, int port,
>  				  const unsigned char *addr, u16 vid,
>  				  struct dsa_db db)
> @@ -6008,6 +6183,7 @@ static struct mv88e6xxx_chip *mv88e6xxx_alloc_chip(struct device *dev)
>  	mutex_init(&chip->reg_lock);
>  	INIT_LIST_HEAD(&chip->mdios);
>  	idr_init(&chip->policies);
> +	INIT_LIST_HEAD(&chip->msts);
>  
>  	return chip;
>  }
> @@ -6540,10 +6716,12 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
>  	.port_pre_bridge_flags	= mv88e6xxx_port_pre_bridge_flags,
>  	.port_bridge_flags	= mv88e6xxx_port_bridge_flags,
>  	.port_stp_state_set	= mv88e6xxx_port_stp_state_set,
> +	.port_mst_state_set	= mv88e6xxx_port_mst_state_set,
>  	.port_fast_age		= mv88e6xxx_port_fast_age,
>  	.port_vlan_filtering	= mv88e6xxx_port_vlan_filtering,
>  	.port_vlan_add		= mv88e6xxx_port_vlan_add,
>  	.port_vlan_del		= mv88e6xxx_port_vlan_del,
> +	.vlan_msti_set		= mv88e6xxx_vlan_msti_set,
>  	.port_fdb_add           = mv88e6xxx_port_fdb_add,
>  	.port_fdb_del           = mv88e6xxx_port_fdb_del,
>  	.port_fdb_dump          = mv88e6xxx_port_fdb_dump,
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
> index 6d4daa24d3e5..6a0b66354e1d 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.h
> +++ b/drivers/net/dsa/mv88e6xxx/chip.h
> @@ -297,6 +297,16 @@ struct mv88e6xxx_region_priv {
>  	enum mv88e6xxx_region_id id;
>  };
>  
> +struct mv88e6xxx_mst {
> +	struct list_head node;
> +
> +	refcount_t refcnt;
> +	struct net_device *br;
> +	u16 msti;
> +
> +	struct mv88e6xxx_stu_entry stu;
> +};
> +
>  struct mv88e6xxx_chip {
>  	const struct mv88e6xxx_info *info;
>  
> @@ -397,6 +407,9 @@ struct mv88e6xxx_chip {
>  
>  	/* devlink regions */
>  	struct devlink_region *regions[_MV88E6XXX_REGION_MAX];
> +
> +	/* Bridge MST to SID mappings */
> +	struct list_head msts;
>  };
>  
>  struct mv88e6xxx_bus_ops {
> -- 
> 2.25.1
> 
