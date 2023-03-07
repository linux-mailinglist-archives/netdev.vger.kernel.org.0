Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C46016AE253
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 15:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjCGO1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 09:27:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbjCGO1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 09:27:33 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA2925973;
        Tue,  7 Mar 2023 06:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=aaS0Jt6Mb7Lc0+qLFOpJDYYFIi00EAG/KuvtIBx67/o=; b=ZMwdLwQKO7fk9047lKOM/ZmNeM
        l3XgsGcDnfRZFIbf8ktbv07YJQSiQAsihdjvswzhhgfbmVtmqFCRIa2m711/GHLc7CDBJJXDNM4nk
        Vzv5JDGDFQyAsNRNZCVZ8kvMGuFnVkQ5kxVZCkjFZetbOGn6BQY7/E5d9yLRPMvCjqXY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pZYDG-006fXK-80; Tue, 07 Mar 2023 15:22:46 +0100
Date:   Tue, 7 Mar 2023 15:22:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: mdio: Add netlink interface
Message-ID: <7a02294e-bf50-4399-9e68-1235ba24a381@lunn.ch>
References: <20230306204517.1953122-1-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306204517.1953122-1-sean.anderson@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> To prevent userspace phy drivers, writes are disabled by default, and can
> only be enabled by editing the source. This is the same strategy used by
> regmap for debugfs writes. Unfortunately, this disallows several useful
> features, including
> 
> - Register writes (obviously)
> - C45-over-C22

You could add C45-over-C22 as another op.

This tool is dangerous, even in its read only mode, just like the
IOCTL interface. Interrupt status registers are often clear on read,
so you can loose interrupts. Statistics counters are sometimes clear
on read. BMSR link bit is also latching, so a read of it could mean
you miss link events, etc. Adding C45-over-C22 is just as dangerous,
you can mess up MDIO switches which use the registers for other
things, but by deciding to use this tool you have decided to take the
risk of blowing your foot off.

> - Atomic access to paged registers
> - Better MDIO emulation for e.g. QEMU
> 
> However, the read-only interface remains broadly useful for debugging.

I would say it is broadly useful for PHYs. But not Ethernet switches,
when in read only mode. 

> +static int mdio_nl_open(struct mdio_nl_xfer *xfer);
> +static int mdio_nl_close(struct mdio_nl_xfer *xfer, bool last, int xerr);

I guess i never did a proper review of this code before, due to not
liking the concept....

Move the code around so these are not needed, unless there are
functions which are mutually recursive.

> +static inline u16 *__arg_r(u32 arg, u16 *regs)
> +{
> +	WARN_ON_ONCE(arg >> 16 != MDIO_NL_ARG_REG);
> +
> +	return &regs[arg & 0x7];
> +}

No inline functions in C files. Leave the compiler to decide.

> +static int mdio_nl_eval(struct mdio_nl_xfer *xfer)
> +{
> +	struct mdio_nl_insn *insn;
> +	unsigned long timeout;
> +	u16 regs[8] = { 0 };
> +	int pc, ret = 0;
> +	int phy_id, reg, prtad, devad, val;
> +
> +	timeout = jiffies + msecs_to_jiffies(xfer->timeout_ms);
> +
> +	mutex_lock(&xfer->mdio->mdio_lock);

Should timeout be set inside the lock, for when you have two
applications running in parallel and each take a while?

> +
> +	for (insn = xfer->prog, pc = 0;
> +	     pc < xfer->prog_len;
> +	     insn = &xfer->prog[++pc]) {
> +		if (time_after(jiffies, timeout)) {
> +			ret = -ETIMEDOUT;
> +			break;
> +		}
> +
> +		switch ((enum mdio_nl_op)insn->op) {
> +		case MDIO_NL_OP_READ:
> +			phy_id = __arg_ri(insn->arg0, regs);
> +			prtad = mdio_phy_id_prtad(phy_id);
> +			devad = mdio_phy_id_devad(phy_id);
> +			reg = __arg_ri(insn->arg1, regs);
> +
> +			if (mdio_phy_id_is_c45(phy_id))
> +				ret = __mdiobus_c45_read(xfer->mdio, prtad,
> +							 devad, reg);
> +			else
> +				ret = __mdiobus_read(xfer->mdio, phy_id, reg);

The application should say if it want to do C22 or C45. As you said in
the cover note, the ioctl interface is limiting when there is no PHY,
so you are artificially adding the same restriction here. Also, you
might want to do C45 on a C22 PHY, e.g. to access EEE registers. Plus
you could consider adding C45 over C22 here.

> +
> +			if (ret < 0)
> +				goto exit;
> +			*__arg_r(insn->arg2, regs) = ret;
> +			ret = 0;
> +			break;
> +
> +		case MDIO_NL_OP_WRITE:
> +			phy_id = __arg_ri(insn->arg0, regs);
> +			prtad = mdio_phy_id_prtad(phy_id);
> +			devad = mdio_phy_id_devad(phy_id);
> +			reg = __arg_ri(insn->arg1, regs);
> +			val = __arg_ri(insn->arg2, regs);
> +
> +#ifdef MDIO_NETLINK_ALLOW_WRITE
> +			add_taint(TAINT_USER, LOCKDEP_STILL_OK);

I don't know, but maybe taint on read as well.

> +			if (mdio_phy_id_is_c45(phy_id))
> +				ret = __mdiobus_c45_write(xfer->mdio, prtad,
> +							  devad, reg, val
> +			else
> +				ret = __mdiobus_write(xfer->mdio, dev, reg,
> +						      val);
> +#else
> +			ret = -EPERM;

EPERM is odd, EOPNOTSUPP would be better. EPERM suggests you can run
it as root and it should work.

   Andrew
