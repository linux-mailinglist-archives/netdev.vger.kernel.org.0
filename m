Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 876254D4CFB
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 16:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234415AbiCJP0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 10:26:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbiCJP0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 10:26:52 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6D7157219;
        Thu, 10 Mar 2022 07:25:51 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id p15so12859013ejc.7;
        Thu, 10 Mar 2022 07:25:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hyr8lchvSxJvVZvNNPRmAWrg1/xZg5k7PwIJtfWhQPA=;
        b=bB7/5s/t/KzBLjcRGi2a9yGaVZ4RKGv+dQSLbu4MBPn2IvdV6nEbbtK+IJEVEUhFrU
         AEQWAVL3khsmCLwMf/oY50KBGMhO3I/P4yeEqz1MAOY2jvDFMxiGncvs8dmVgqH8IOh6
         Q9vKmIyt8Ece8Ho2qaJ5DKEhdjtnUGbnEQVe4+sf5JKK2ccoFbV6tzCDVOBhdgTcwzy+
         9at2DIXGe3+rklhwUjtkbp1MK0hTrg0VRt6VqcJiRQ3fnFj54dX6Ou4mjD0Ifg9X/yKq
         CpeeKl/hZnZWHIh88lDfqVJM6mjuAOWJXOvrkanPpYYwe37q/ivX5qI4eBJX12+UgyDy
         kgZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hyr8lchvSxJvVZvNNPRmAWrg1/xZg5k7PwIJtfWhQPA=;
        b=3fN0/Mpq5cgBehkCvAnBXrlUreucjDK0vFbkJZjeCcdFesNK4vHmQKUFrqX5R3QOJ2
         XPqJClf7b3Wld/uU1N4AHNZYI1mwLwoykxYFfOi+8bObu80OeSBzQNwR7kEpdQ21cbGn
         CeyK8Y8shQuL9HJnHYstkQKcu7XcByXNDJjH9/B6ltS+uJ2qst1e19lAy7difsMQUwWk
         +kYp7XnjulLD2UoljkOJDfxJVw75rqEZ+jDso867m1f4tOBbFH0aF1DHVug5wBpqJwz4
         +GiW1BHNAiALxp54Lbe0kSEIWzC7HEBdeuMES3oM28k7+hVC5KAMYZh4/zkdanObIC4P
         GxRw==
X-Gm-Message-State: AOAM531/w8dZRqNRN9t1HBVgP/s0mw5hxLd/zxHCKpJqSRWuMOIguQhd
        8GIjv5PWhGbyW6Ofvk48Pr8=
X-Google-Smtp-Source: ABdhPJyeyXIwnxx7GpXcIqMRyfd7KwZ2in6ydXgLTZ+VY3mJEJDH9hq+D3/8NJaRPmbwCXUcwrRYFw==
X-Received: by 2002:a17:907:7711:b0:6ce:e03c:e1e2 with SMTP id kw17-20020a170907771100b006cee03ce1e2mr4707576ejc.769.1646925949456;
        Thu, 10 Mar 2022 07:25:49 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id y14-20020a056402440e00b00416046b623csm2297799eda.2.2022.03.10.07.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 07:25:48 -0800 (PST)
Date:   Thu, 10 Mar 2022 17:25:47 +0200
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
Message-ID: <20220310152547.etuov6kpqotnyv2p@skbuf>
References: <20220301100321.951175-1-tobias@waldekranz.com>
 <20220301100321.951175-11-tobias@waldekranz.com>
 <20220303222658.7ykn6grkkp6htm7a@skbuf>
 <87k0d1n8ko.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0d1n8ko.fsf@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 04:14:31PM +0100, Tobias Waldekranz wrote:
> On Fri, Mar 04, 2022 at 00:26, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Tue, Mar 01, 2022 at 11:03:21AM +0100, Tobias Waldekranz wrote:
> >> Allocate a SID in the STU for each MSTID in use by a bridge and handle
> >> the mapping of MSTIDs to VLANs using the SID field of each VTU entry.
> >> 
> >> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> >> ---
> >>  drivers/net/dsa/mv88e6xxx/chip.c | 178 +++++++++++++++++++++++++++++++
> >>  drivers/net/dsa/mv88e6xxx/chip.h |  13 +++
> >>  2 files changed, 191 insertions(+)
> >> 
> >> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> >> index c14a62aa6a6c..4fb4ec1dff79 100644
> >> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> >> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> >> @@ -1818,6 +1818,137 @@ static int mv88e6xxx_stu_setup(struct mv88e6xxx_chip *chip)
> >>  	return mv88e6xxx_stu_loadpurge(chip, &stu);
> >>  }
> >>  
> >> +static int mv88e6xxx_sid_new(struct mv88e6xxx_chip *chip, u8 *sid)
> >> +{
> >> +	DECLARE_BITMAP(busy, MV88E6XXX_N_SID) = { 0 };
> >> +	struct mv88e6xxx_mst *mst;
> >> +
> >> +	set_bit(0, busy);
> >> +
> >> +	list_for_each_entry(mst, &chip->msts, node) {
> >> +		set_bit(mst->stu.sid, busy);
> >> +	}
> >> +
> >> +	*sid = find_first_zero_bit(busy, MV88E6XXX_N_SID);
> >> +
> >> +	return (*sid >= mv88e6xxx_max_sid(chip)) ? -ENOSPC : 0;
> >> +}
> >> +
> >> +static int mv88e6xxx_sid_put(struct mv88e6xxx_chip *chip, u8 sid)
> >> +{
> >> +	struct mv88e6xxx_mst *mst, *tmp;
> >> +	int err = 0;
> >> +
> >> +	list_for_each_entry_safe(mst, tmp, &chip->msts, node) {
> >> +		if (mst->stu.sid == sid) {
> >> +			if (refcount_dec_and_test(&mst->refcnt)) {
> >> +				mst->stu.valid = false;
> >> +				err = mv88e6xxx_stu_loadpurge(chip, &mst->stu);
> >
> > It is interesting what to do if this fails. Possibly not this, because
> > the entry remains in hardware but not in software.
> 
> True, I will let the error bubble up and keep the SW state in sync with
> the hardware.

Ok. For what it's worth, if you bump a refcount from 0 to 1 as part of
the error handling here, you need to do so using refcount_set(1), not
refcount_inc(). I found this out in commit 232deb3f9567 ("net: dsa:
avoid refcount warnings when ->port_{fdb,mdb}_del returns error").
Just thought I'd mention it in case you didn't know, to avoid a future
respin for that reason.

> >> +				list_del(&mst->node);
> >> +				kfree(mst);
> >> +			}
> >> +
> >> +			return err;
> >> +		}
> >> +	}
> >> +
> >> +	return -ENOENT;
> >> +}
> >> +
> >> +static int mv88e6xxx_sid_get(struct mv88e6xxx_chip *chip, struct net_device *br,
> >> +			     u16 msti, u8 *sid)
> >> +{
> >> +	struct mv88e6xxx_mst *mst;
> >> +	int err, i;
> >> +
> >> +	if (!br)
> >> +		return 0;
> >
> > Is this condition possible?
> 
> Removing.
> 
> >> +
> >> +	if (!mv88e6xxx_has_stu(chip))
> >> +		return -EOPNOTSUPP;
> >> +
> >> +	list_for_each_entry(mst, &chip->msts, node) {
> >> +		if (mst->br == br && mst->msti == msti) {
> >> +			refcount_inc(&mst->refcnt);
> >> +			*sid = mst->stu.sid;
> >> +			return 0;
> >> +		}
> >> +	}
> >> +
> >> +	err = mv88e6xxx_sid_new(chip, sid);
> >> +	if (err)
> >> +		return err;
> >> +
> >> +	mst = kzalloc(sizeof(*mst), GFP_KERNEL);
> >> +	if (!mst)
> >> +		return -ENOMEM;
> >
> > This leaks the new SID.
> 
> I don't think so, the SID is just calculated based on what is in
> chip->msts. However:
> 
> - The naming is bad. Will change.

I see now. My bad. What are you renaming it to? If it isn't as concise
you could still keep it sid_new(). I see atu_new() is based on the same
find_first_zero_bit() concept.

> >> +
> >> +	INIT_LIST_HEAD(&mst->node);
> >> +	refcount_set(&mst->refcnt, 1);
> >> +	mst->br = br;
> >> +	mst->msti = msti;
> >> +	mst->stu.valid = true;
> >> +	mst->stu.sid = *sid;
> >> +
> >> +	/* The bridge starts out all ports in the disabled state. But
> >> +	 * a STU state of disabled means to go by the port-global
> >> +	 * state. So we set all user port's initial state to blocking,
> >> +	 * to match the bridge's behavior.
> >> +	 */
> >> +	for (i = 0; i < mv88e6xxx_num_ports(chip); i++)
> >> +		mst->stu.state[i] = dsa_is_user_port(chip->ds, i) ?
> >> +			MV88E6XXX_PORT_CTL0_STATE_BLOCKING :
> >> +			MV88E6XXX_PORT_CTL0_STATE_DISABLED;
> >> +
> >> +	list_add_tail(&mst->node, &chip->msts);
> >> +	return mv88e6xxx_stu_loadpurge(chip, &mst->stu);
> >
> > And this doesn't behave too well on failure (the MSTID exists in
> > software but not in hardware).
> 
> Yes, fixing in v3.
> 
> >> +}
> >> +
> >> +static int mv88e6xxx_port_mst_state_set(struct dsa_switch *ds, int port,
> >> +					const struct switchdev_mst_state *st)
> >> +{
> >> +	struct dsa_port *dp = dsa_to_port(ds, port);
> >> +	struct mv88e6xxx_chip *chip = ds->priv;
> >> +	struct mv88e6xxx_mst *mst;
> >> +	u8 state;
> >> +	int err;
> >> +
> >> +	if (!mv88e6xxx_has_stu(chip))
> >> +		return -EOPNOTSUPP;
> >> +
> >> +	switch (st->state) {
> >> +	case BR_STATE_DISABLED:
> >> +	case BR_STATE_BLOCKING:
> >> +	case BR_STATE_LISTENING:
> >> +		state = MV88E6XXX_PORT_CTL0_STATE_BLOCKING;
> >> +		break;
> >> +	case BR_STATE_LEARNING:
> >> +		state = MV88E6XXX_PORT_CTL0_STATE_LEARNING;
> >> +		break;
> >> +	case BR_STATE_FORWARDING:
> >> +		state = MV88E6XXX_PORT_CTL0_STATE_FORWARDING;
> >> +		break;
> >> +	default:
> >> +		return -EINVAL;
> >> +	}
> >> +
> >> +	list_for_each_entry(mst, &chip->msts, node) {
> >> +		if (mst->br == dsa_port_bridge_dev_get(dp) &&
> >> +		    mst->msti == st->msti) {
> >> +			if (mst->stu.state[port] == state)
> >> +				return 0;
> >> +
> >> +			mst->stu.state[port] = state;
> >> +			mv88e6xxx_reg_lock(chip);
> >> +			err = mv88e6xxx_stu_loadpurge(chip, &mst->stu);
> >> +			mv88e6xxx_reg_unlock(chip);
> >> +			return err;
> >> +		}
> >> +	}
> >> +
> >> +	return -ENOENT;
> >> +}
> >> +
> >>  static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
> >>  					u16 vid)
> >>  {
> >> @@ -2437,6 +2568,12 @@ static int mv88e6xxx_port_vlan_leave(struct mv88e6xxx_chip *chip,
> >>  	if (err)
> >>  		return err;
> >>  
> >> +	if (!vlan.valid && vlan.sid) {
> >> +		err = mv88e6xxx_sid_put(chip, vlan.sid);
> >> +		if (err)
> >> +			return err;
> >> +	}
> >> +
> >>  	return mv88e6xxx_g1_atu_remove(chip, vlan.fid, port, false);
> >>  }
> >>  
> >> @@ -2482,6 +2619,44 @@ static int mv88e6xxx_port_vlan_del(struct dsa_switch *ds, int port,
> >>  	return err;
> >>  }
> >>  
> >> +static int mv88e6xxx_vlan_msti_set(struct dsa_switch *ds,
> >> +				   const struct switchdev_attr *attr)
> >> +{
> >> +	const struct switchdev_vlan_attr *vattr = &attr->u.vlan_attr;
> >> +	struct mv88e6xxx_chip *chip = ds->priv;
> >> +	struct mv88e6xxx_vtu_entry vlan;
> >> +	u8 new_sid;
> >> +	int err;
> >> +
> >> +	mv88e6xxx_reg_lock(chip);
> >> +
> >> +	err = mv88e6xxx_vtu_get(chip, vattr->vid, &vlan);
> >> +	if (err)
> >> +		goto unlock;
> >> +
> >> +	if (!vlan.valid) {
> >> +		err = -EINVAL;
> >> +		goto unlock;
> >> +	}
> >> +
> >> +	err = mv88e6xxx_sid_get(chip, attr->orig_dev, vattr->msti, &new_sid);
> >> +	if (err)
> >> +		goto unlock;
> >> +
> >> +	if (vlan.sid) {
> >> +		err = mv88e6xxx_sid_put(chip, vlan.sid);
> >> +		if (err)
> >> +			goto unlock;
> >> +	}
> >> +
> >> +	vlan.sid = new_sid;
> >> +	err = mv88e6xxx_vtu_loadpurge(chip, &vlan);
> >
> > Maybe you could move mv88e6xxx_sid_put() after this succeeds?
> 
> Yep. Also made sure to avoid needless updates of the VTU entry if it
> already belonged to the correct SID.
> 
> Thanks for the great review!

I realize I gave you conflicting advice here, first with inverting the
refcount_inc() with the refcount_dec(), then with having fast handling
of noop-changes to vlan.sid. I hope you're able to make some sense out
of that and avoid the obvious issue with the refcount temporarily
dropping to zero before going back to 1, which makes the sanity checker
complain.
