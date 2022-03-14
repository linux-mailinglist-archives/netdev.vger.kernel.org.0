Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFA604D8906
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 17:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242983AbiCNQ2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 12:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239747AbiCNQ2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 12:28:30 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF19B6325;
        Mon, 14 Mar 2022 09:27:19 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id y22so20735480eds.2;
        Mon, 14 Mar 2022 09:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9yrn1+pWYLFNK3LpjVPRAgU6sL03BaCGB5nJqvDYuGY=;
        b=dkIg/S2eIn4VcnjGne0ysx6FqVS93jehn4bRooOVIBe5RgxR36hvMC//PcKdoJH4eg
         uIRl5E7W11dPp9gX0DZHcVQGL3V8houx5HIJQWgDjVyUCX7ad+mvjUTmPU+oGdn1MLGA
         Eyx2Uiv4LTNuRhzjWIu1RchSXc8AkK2b9IKvermApodN4fxA1b+W8s7x+iV8kHZvswef
         Ibj9H0s9jKxZG/mjIgM26rj8aOq6OfnRkh7CS2PFpvWwIksgXroqnH+V6tPSj7tJgGmX
         4RWaEGSXDslrzi/Ved8xIhzHkJycZhMaRR6/FR98A3GdQoHPUOuO4+A5BgOxRUM+gmhr
         r5eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9yrn1+pWYLFNK3LpjVPRAgU6sL03BaCGB5nJqvDYuGY=;
        b=xRQ72CgQ6YAjLB283tIwZO4tfYj/u+Z6OXU3sBCRUGfiHcug0rGqs45y62vuBQBbjH
         WsLRaeoMZSzViiT50uwrn1IdI/fEWxg1glnwlLqLSGkjw+XjtArVQPwlK3GJmEuAZ+Em
         QvN4qzjcaYqHL68GhCEFOkr+03A39gh3SoY+m85ZcDXvscZjms0ElC8zubjm2ZgBIPky
         YFuMNDY2Fi9WHEVftxhqTZxbG2TQFvlPNMQgySWvyjTQDYPKWkkuGi7oIj7viUA4zrmM
         crnH+4380zADCPALksjIdq3tlqSGdY3M/jqI/CnXc5Isv5SXF3qY8Xop899pu1cuk7CN
         8U/A==
X-Gm-Message-State: AOAM5312Lb/P5mhy2lN2hwywqZyolwH9JPjg3zGwlzu6ZRp2Pvt41aYk
        xgyOG6LBL+9eWIkssEZ43Q4=
X-Google-Smtp-Source: ABdhPJwDx5IBzWsln/W0OlCddZmEz42ZQdy4vLm5bWAawT6t2f8AsCedff0q9L0p20aXVyddE0TrGQ==
X-Received: by 2002:a50:e60f:0:b0:415:9509:32a2 with SMTP id y15-20020a50e60f000000b00415950932a2mr21373909edm.235.1647275238137;
        Mon, 14 Mar 2022 09:27:18 -0700 (PDT)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id e18-20020a50ec92000000b0041852b30c9esm5157503edr.27.2022.03.14.09.27.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 09:27:17 -0700 (PDT)
Date:   Mon, 14 Mar 2022 18:27:16 +0200
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
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Cooper Lees <me@cooperlees.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH v3 net-next 14/14] net: dsa: mv88e6xxx: MST Offloading
Message-ID: <20220314162716.fm4tpkdi4b4ak3th@skbuf>
References: <20220314095231.3486931-1-tobias@waldekranz.com>
 <20220314095231.3486931-15-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314095231.3486931-15-tobias@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 10:52:31AM +0100, Tobias Waldekranz wrote:
> Allocate a SID in the STU for each MSTID in use by a bridge and handle
> the mapping of MSTIDs to VLANs using the SID field of each VTU entry.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 251 ++++++++++++++++++++++++++++++-
>  drivers/net/dsa/mv88e6xxx/chip.h |  13 ++
>  2 files changed, 257 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index c14a62aa6a6c..c23dbf37aeec 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -1667,24 +1667,32 @@ static int mv88e6xxx_pvt_setup(struct mv88e6xxx_chip *chip)
>  	return 0;
>  }
>  
> -static void mv88e6xxx_port_fast_age(struct dsa_switch *ds, int port)
> +static void mv88e6xxx_port_fast_age_fid(struct mv88e6xxx_chip *chip, int port,
> +					u16 fid)
>  {
> -	struct mv88e6xxx_chip *chip = ds->priv;
>  	int err;
>  
> -	if (dsa_to_port(ds, port)->lag)
> +	if (dsa_to_port(chip->ds, port)->lag)
>  		/* Hardware is incapable of fast-aging a LAG through a
>  		 * regular ATU move operation. Until we have something
>  		 * more fancy in place this is a no-op.
>  		 */
>  		return;
>  
> -	mv88e6xxx_reg_lock(chip);
> -	err = mv88e6xxx_g1_atu_remove(chip, 0, port, false);
> -	mv88e6xxx_reg_unlock(chip);
> +	err = mv88e6xxx_g1_atu_remove(chip, fid, port, false);
>  
>  	if (err)
> -		dev_err(ds->dev, "p%d: failed to flush ATU\n", port);
> +		dev_err(chip->ds->dev, "p%d: failed to flush ATU (FID %u)\n",
> +			port, fid);
> +}
> +
> +static void mv88e6xxx_port_fast_age(struct dsa_switch *ds, int port)
> +{
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +
> +	mv88e6xxx_reg_lock(chip);
> +	mv88e6xxx_port_fast_age_fid(chip, port, 0);
> +	mv88e6xxx_reg_unlock(chip);
>  }
>  
>  static int mv88e6xxx_vtu_setup(struct mv88e6xxx_chip *chip)
> @@ -1818,6 +1826,159 @@ static int mv88e6xxx_stu_setup(struct mv88e6xxx_chip *chip)
>  	return mv88e6xxx_stu_loadpurge(chip, &stu);
>  }
>  
> +static int mv88e6xxx_sid_get(struct mv88e6xxx_chip *chip, u8 *sid)
> +{
> +	DECLARE_BITMAP(busy, MV88E6XXX_N_SID) = { 0 };
> +	struct mv88e6xxx_mst *mst;
> +
> +	set_bit(0, busy);

__set_bit

> +
> +	list_for_each_entry(mst, &chip->msts, node) {
> +		set_bit(mst->stu.sid, busy);
> +	}

Up to you, but parentheses are generally not used for single-line blocks.

> +
> +	*sid = find_first_zero_bit(busy, MV88E6XXX_N_SID);
> +
> +	return (*sid >= mv88e6xxx_max_sid(chip)) ? -ENOSPC : 0;
> +}
> +
> +static int mv88e6xxx_mst_put(struct mv88e6xxx_chip *chip, u8 sid)
> +{
> +	struct mv88e6xxx_mst *mst, *tmp;
> +	int err;
> +
> +	if (!sid)
> +		return 0;

Very minor nitpick: since mv88e6xxx_mst_put already checks this, could
you drop the "!sid" check from callers?

> +
> +	list_for_each_entry_safe(mst, tmp, &chip->msts, node) {
> +		if (mst->stu.sid != sid)
> +			continue;
> +
> +		if (!refcount_dec_and_test(&mst->refcnt))
> +			return 0;
> +
> +		mst->stu.valid = false;
> +		err = mv88e6xxx_stu_loadpurge(chip, &mst->stu);
> +		if (err)

Should we bother with a refcount_set(&mst->refcount, 1) on error?

> +			return err;
> +
> +		list_del(&mst->node);
> +		kfree(mst);
> +		return 0;
> +	}
> +
> +	return -ENOENT;
> +}
> +
> +static int mv88e6xxx_mst_get(struct mv88e6xxx_chip *chip, struct net_device *br,
> +			     u16 msti, u8 *sid)
> +{
> +	struct mv88e6xxx_mst *mst;
> +	int err, i;
> +
> +	if (!mv88e6xxx_has_stu(chip)) {
> +		err = -EOPNOTSUPP;
> +		goto err;
> +	}
> +
> +	if (!msti) {
> +		*sid = 0;
> +		return 0;
> +	}
> +
> +	list_for_each_entry(mst, &chip->msts, node) {
> +		if (mst->br == br && mst->msti == msti) {
> +			refcount_inc(&mst->refcnt);
> +			*sid = mst->stu.sid;
> +			return 0;
> +		}
> +	}
> +
> +	err = mv88e6xxx_sid_get(chip, sid);
> +	if (err)
> +		goto err;
> +
> +	mst = kzalloc(sizeof(*mst), GFP_KERNEL);
> +	if (!mst) {
> +		err = -ENOMEM;
> +		goto err;
> +	}
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
> +	err = mv88e6xxx_stu_loadpurge(chip, &mst->stu);
> +	if (err)
> +		goto err_free;
> +
> +	list_add_tail(&mst->node, &chip->msts);
> +	return 0;
> +
> +err_free:
> +	kfree(mst);
> +err:
> +	return err;
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
> @@ -2437,6 +2598,12 @@ static int mv88e6xxx_port_vlan_leave(struct mv88e6xxx_chip *chip,
>  	if (err)
>  		return err;
>  
> +	if (!vlan.valid && vlan.sid) {
> +		err = mv88e6xxx_mst_put(chip, vlan.sid);
> +		if (err)
> +			return err;
> +	}
> +
>  	return mv88e6xxx_g1_atu_remove(chip, vlan.fid, port, false);
>  }
>  
> @@ -2482,6 +2649,72 @@ static int mv88e6xxx_port_vlan_del(struct dsa_switch *ds, int port,
>  	return err;
>  }
>  
> +static void mv88e6xxx_port_vlan_fast_age(struct dsa_switch *ds, int port, u16 vid)
> +{
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +	struct mv88e6xxx_vtu_entry vlan;
> +	int err;
> +
> +	mv88e6xxx_reg_lock(chip);
> +
> +	err = mv88e6xxx_vtu_get(chip, vid, &vlan);
> +	if (err)
> +		goto unlock;
> +
> +	mv88e6xxx_port_fast_age_fid(chip, port, vlan.fid);
> +
> +unlock:
> +	mv88e6xxx_reg_unlock(chip);
> +
> +	if (err)
> +		dev_err(ds->dev, "p%d: failed to flush ATU in VID %u\n",
> +			port, vid);

This error message actually corresponds to an mv88e6xxx_vtu_get() error,
so the message is kind of incorrect. mv88e6xxx_port_fast_age_fid(),
whose error code isn't propagated here, has its own "failed to flush ATU"
error message.

> +}

Otherwise this looks pretty good.
