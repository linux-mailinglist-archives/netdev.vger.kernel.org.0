Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35B696AE11E
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 14:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbjCGNtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 08:49:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbjCGNsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 08:48:45 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A38E98388D;
        Tue,  7 Mar 2023 05:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=gQ+99a99lnf83/yelPjxBU/kH2TZpXh3Q6BntDbpKjc=; b=l/cno+2MrYiXA2G8Ygtwkk/iSn
        d1Ns6NgiLWFp4sDBYffXfwMK/ar6u1HkblvrPPnUYDaIi5yQ0LKWyH3MjhVvLsiYWR8fhRKGo805s
        ORZZAM+FugHsrw9Rnl9GFv9OUdIhgc4rXtf87QWSVHSWXCfRJgEohRhePAqPHr5L3G2A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pZXfI-006fI5-7e; Tue, 07 Mar 2023 14:47:40 +0100
Date:   Tue, 7 Mar 2023 14:47:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: mdio: Add netlink interface
Message-ID: <537d82d4-9893-4329-874a-0a4f24af1a0d@lunn.ch>
References: <20230306204517.1953122-1-sean.anderson@seco.com>
 <ZAZt0D+CQBnYIogp@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAZt0D+CQBnYIogp@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 10:48:48PM +0000, Russell King (Oracle) wrote:
> On Mon, Mar 06, 2023 at 03:45:16PM -0500, Sean Anderson wrote:
> > +static int mdio_nl_eval(struct mdio_nl_xfer *xfer)
> > +{
> > +	struct mdio_nl_insn *insn;
> > +	unsigned long timeout;
> > +	u16 regs[8] = { 0 };
> > +	int pc, ret = 0;
> 
> So "pc" is signed.
> 
> > +	int phy_id, reg, prtad, devad, val;
> > +
> > +	timeout = jiffies + msecs_to_jiffies(xfer->timeout_ms);
> > +
> > +	mutex_lock(&xfer->mdio->mdio_lock);
> > +
> > +	for (insn = xfer->prog, pc = 0;
> > +	     pc < xfer->prog_len;
> 
> xfer->prog_len is signed, so this is a signed comparison.
> 
> > +		case MDIO_NL_OP_JEQ:
> > +			if (__arg_ri(insn->arg0, regs) ==
> > +			    __arg_ri(insn->arg1, regs))
> > +				pc += (s16)__arg_i(insn->arg2);
> 
> This adds a signed 16-bit integer to pc, which can make pc negative.
> 
> And so the question becomes... what prevents pc becoming negative
> and then trying to use a negative number as an index?

I don't know ebpf very well, but would it of caught this?  I know the
aim of this is to be simple, but due to its simplicity, we are loosing
out on all the inherent safety of eBPF. Is a eBPF interface all that
complex? I assume you just need to add some way to identify MDIO
busses and kfunc to perform a read on the bus?

       Andrew
