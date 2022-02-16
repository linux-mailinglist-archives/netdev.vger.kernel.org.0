Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 174694B8A75
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 14:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbiBPNjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 08:39:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234008AbiBPNje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 08:39:34 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8C02ABD13;
        Wed, 16 Feb 2022 05:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tjvtg6e6rfEBajxf7gEQ25jMTSa3cr331jVbNJooOA0=; b=fRzh+dlUNwjRlxwNg3p81SGp3B
        iStgmRxGiJO6bKTyqJwOLl8g3KNUsuNbBJrLRQ7UilHK2F8X5sVUfqqLvgT4IA+wsrJTra5I0v0qY
        dyZ7dqySINcTzpwqnM0bGq/bbzCr879Q3scd+JS3+0YPwLeEp9erYpO0YXsup7ValRWBOpdquQBjz
        iFOyTAvMnuNfMkyx+WuYaKrh39IiHrhOcAKz5cLMGwOkIAMjOHDgej31lVHn85+QZtw0iya38+4ti
        pbyviRSYF7YV5Wuln6MXHB4eQXiXuZyPeAkYP2kV5rkjGEdQPeho+Dsp3yOU3Ccq5Yqw6OonUeJHf
        BSJUVR5g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57284)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nKKWP-0003ue-5J; Wed, 16 Feb 2022 13:39:05 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nKKWK-00006Q-7J; Wed, 16 Feb 2022 13:39:00 +0000
Date:   Wed, 16 Feb 2022 13:39:00 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [RFC net-next 9/9] net: dsa: mv88e6xxx: MST Offloading
Message-ID: <Ygz+dNz1YvyiFpxa@shell.armlinux.org.uk>
References: <20220216132934.1775649-1-tobias@waldekranz.com>
 <20220216132934.1775649-10-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216132934.1775649-10-tobias@waldekranz.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Feb 16, 2022 at 02:29:34PM +0100, Tobias Waldekranz wrote:
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

Do you need these set_bit() operations to be atomic? Would __set_bit()
produce better code?

> +
> +	*sid = find_first_zero_bit(busy, MV88E6XXX_N_SID);
> +
> +	return (*sid >= mv88e6xxx_max_sid(chip)) ? -ENOSPC : 0;

Hmm. Let's hope that mv88e6xxx_max_sid() never returns a value larger
than MV88E6XXX_N_SID.

> +}
> +
...
> +static int mv88e6xxx_sid_get(struct mv88e6xxx_chip *chip, struct net_device *br,
> +			     u16 mstid, u8 *sid)
> +{
> +	struct mv88e6xxx_mst *mst;
> +	int err;
> +
> +	if (!br)
> +		return 0;
> +
> +	if (!mv88e6xxx_has_stu(chip))
> +		return -EOPNOTSUPP;
> +
> +	list_for_each_entry(mst, &chip->msts, node) {
> +		if (mst->br == br && mst->mstid == mstid) {
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
> +
> +	INIT_LIST_HEAD(&mst->node);

There is no need to initialise the node if you're then going to be
adding it to the list.

> +	refcount_set(&mst->refcnt, 1);
> +	mst->br = br;
> +	mst->mstid = mstid;
> +	mst->stu.valid = true;
> +	mst->stu.sid = *sid;
> +	list_add_tail(&mst->node, &chip->msts);
> +	return mv88e6xxx_stu_loadpurge(chip, &mst->stu);

I haven't checked what the locking is here - I hope it's not possible
for two of these to run concurrently.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
