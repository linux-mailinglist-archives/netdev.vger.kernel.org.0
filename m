Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A06D66AD1F7
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 23:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjCFWtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 17:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjCFWtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 17:49:14 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FFD96A77;
        Mon,  6 Mar 2023 14:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Nj3vMJ/ctllkbeLpBt41rftvOwSQFABnTEwJIKhBS/A=; b=b1jXXo78VNTfEO7+sYEviZTy6u
        qelJqGE+xM6EkhMOK5Cih5h9wBa9JcQ+n89YUWXB3lR3i4p1y+EQ449wdPMyh247qb4WUGslVoQ/T
        LsWTPmYcff+p++jMB13T3zaIrtGSHtsUfZXeLZOhqAJQSuBfMUa/GK3nIlbm1JXc9LBl7x8Jwvpq3
        6S0VpmNesJbN1ydjl2x+fNJRWSNzAwLYjU1YZrmDniNBdo1TMjxOaxYy98ynjYFIR1JIzFzcs+bkO
        FVVSlZum+iwNpzo8rdRnGd1mrBG/F0f60HS9+AlVmQnqqKwHjdLoiq+iwvfNBzTuyFDS9CGgzU7fY
        isuP7yOQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58090)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pZJdV-00071Q-I2; Mon, 06 Mar 2023 22:48:53 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pZJdQ-0000tT-Em; Mon, 06 Mar 2023 22:48:49 +0000
Date:   Mon, 6 Mar 2023 22:48:48 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: mdio: Add netlink interface
Message-ID: <ZAZt0D+CQBnYIogp@shell.armlinux.org.uk>
References: <20230306204517.1953122-1-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306204517.1953122-1-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 03:45:16PM -0500, Sean Anderson wrote:
> +static int mdio_nl_eval(struct mdio_nl_xfer *xfer)
> +{
> +	struct mdio_nl_insn *insn;
> +	unsigned long timeout;
> +	u16 regs[8] = { 0 };
> +	int pc, ret = 0;

So "pc" is signed.

> +	int phy_id, reg, prtad, devad, val;
> +
> +	timeout = jiffies + msecs_to_jiffies(xfer->timeout_ms);
> +
> +	mutex_lock(&xfer->mdio->mdio_lock);
> +
> +	for (insn = xfer->prog, pc = 0;
> +	     pc < xfer->prog_len;

xfer->prog_len is signed, so this is a signed comparison.

> +		case MDIO_NL_OP_JEQ:
> +			if (__arg_ri(insn->arg0, regs) ==
> +			    __arg_ri(insn->arg1, regs))
> +				pc += (s16)__arg_i(insn->arg2);

This adds a signed 16-bit integer to pc, which can make pc negative.

And so the question becomes... what prevents pc becoming negative
and then trying to use a negative number as an index?

I think prog_len and pc should both be unsigned, then the test you
have will be unsigned, and thus wrapping "pc" around zero makes it
a very large integer which fails the test - preventing at least
access outside of the array. Better still would be a validator
that checks that the program is in fact safe to execute.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
