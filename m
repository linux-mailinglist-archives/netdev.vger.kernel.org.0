Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBA1A680DA2
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 13:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236777AbjA3MaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 07:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbjA3MaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 07:30:13 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6076B2685F;
        Mon, 30 Jan 2023 04:30:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NDbxNE0I4eTGl2OnpaiwvknY+6bp+dKyyLHTKPO4ipY=; b=h4HEyApeAZR/zhkUNISzjjlrEv
        lv5NBoXjYcrBU9YtPPit6yXBdjiqXepcoLLN51BCbWEo70a5VTHH5cezCos4MOUI/pXtmQZ9w7y1g
        dRbCtT2DRa1AfmG2UjJRwR5K/tydTewxjkaNQ2miKG5zZ73+R63IAO0npFBa8biRVLLWdNWhTeiuF
        2F+vGCcjEXGKft9Oc0l4GW4NAWzAzSAzPVEGJVLyhfVm8KjuGXIwxGKECxiGX/lmU0+uEXjXcMLsd
        Szd07HpQjIt+IwGwRNk9zUg+BN7nvLfjFYgHRXOu0UPUA/lli09jFSvQ0BlyuSMX9Yg/menlIVttl
        U94GODng==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36358)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pMTIV-00037q-Nc; Mon, 30 Jan 2023 12:30:07 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pMTIU-000387-3o; Mon, 30 Jan 2023 12:30:06 +0000
Date:   Mon, 30 Jan 2023 12:30:06 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] dsa: marvell: Provide per device information
 about max frame size
Message-ID: <Y9e4TowGyjOpFt8o@shell.armlinux.org.uk>
References: <20230106101651.1137755-1-lukma@denx.de>
 <Y8Fno+svcnNY4h/8@shell.armlinux.org.uk>
 <20230116105148.230ef4ae@wsk>
 <20230125122412.4eb1746d@wsk>
 <Y9FG5PxOq7qsfvtz@shell.armlinux.org.uk>
 <20230130125731.7dd6dcee@wsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130125731.7dd6dcee@wsk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 12:57:31PM +0100, Lukasz Majewski wrote:
> Hi Russell,
> 
> > What I'm concerned about, and why I replied, is that setting the
> > devices to have a max frame size of 1522 when we program them to use
> > a larger frame size means we break those switches for normal sized
> > packets.
> > 
> > The current logic in mv88e6xxx_get_max_mtu() is:
> > 
> > 	If the chip implements port_set_jumbo_size, then packet sizes
> > of up to 10240 are supported.
> > 	(ops: 6131, 6141, 6171, 6172, 6175, 6176, 6190, 6190x, 6240,
> > 6320, 6321, 6341, 6350, 6351, 6352, 6390, 6390x, 6393x)
> > 	If the chip implements set_max_frame_size, then packet sizes
> > of up to 1632 are supported.
> > 	(ops: 6085, 6095, 6097, 6123, 6161, 6185)
> > 	Otherwise, packets of up to 1522 are supported.
> > 
> > Now, going through the patch, I see:
> > 
> > 	88e6085 has 10240 but currently has 1632
> > 	88e6095 has 1632 (no change)
> > 	88e6097 has 1632 (no change)
> > 	88e6123 has 10240 but currently has 1632
> > 	88e6131 has 10240 (no change)
> > 	88e6141 has 10240 (no change)
> > 	88e6161 has 1632 but currently has 10240
> > 	88e6165 has 1632 but currently has 1522
> > 	88e6171 has 1522 but currently has 10240
> > 	88e6172 has 10240 (no change)
> > 	88e6175 has 1632 but currently has 10240
> > 	88e6176 has 10240 (no change)
> > 	88e6185 has 1632 (no change)
> > 	88e6190 has 10240 (no change)
> > 	88e6190x has 10240 (no change)
> > 	88e6191 has 10240 but currently has 1522
> > 	88e6191x has 1522 but currently has 10240
> > 	88e6193x has 1522 but currently has 10240
> > 	88e6220 has 2048 but currently has 1522
> > 	88e6240 has 10240 (no change)
> > 	88e6250 has 2048 but currently has 1522
> > 	88e6290 has 10240 but currently has 1522
> > 	88e6320 has 10240 (no change)
> > 	88e6321 has 10240 (no change)
> > 	88e6341 has 10240 (no change)
> > 	88e6350 has 10240 (no change)
> > 	88e6351 has 10240 (no change)
> > 	88e6352 has 10240 (no change)
> > 	88e6390 has 1522 but currently has 10240
> > 	88e6390x has 1522 but currently has 10240
> > 	88e6393x has 1522 but currently has 10240
> > 
> > My point is that based on the above, there's an awful lot of changes
> > that this one patch brings, and I'm not sure many of them are
> > intended.
> 
> As I only have access to mv88e60{20|71} SoCs I had to base on the code
> to deduce which max frame is supported.

The above list of differences are also derived from the code, and this
rather proves my point that deriving these from the code is hard, and
we need a way to programmatically verify that we get them correct.

> > So, I think it would be far better to introduce the "max_frame_size"
> > field using the existing values, and then verify that value during
> > initialisation time for every entry in mv88e6xxx_table[] using the
> > rules that mv88e6xxx_get_max_mtu() was using. Boot that kernel, and
> > have it run that verification, and state that's what's happened and
> > was successful in the commit message.
> > 
> > In the next commit, change mv88e6xxx_get_max_mtu() to use those
> > verified values and remove the verification code.
> > 
> > Then in the following commit, update the "max_frame_size" values with
> > the changes you intend to make.
> > 
> > Then, we can (a) have confidence that each of the new members were
> > properly initialised, and (b) we can also see what changes you're
> > intentionally making.
> > 
> 
> If I understood you correctly - the approach would be to "simulate" and
> obtain each max_frame_size assigned in mv88e6xxx_get_max_mtu() to be
> sure that we do preserve current (buggy or not) behaviour.

What I'm suggesting is something like:

static void mv88e6xxx_validate_frame_size(void)
{
	int max;
	int i;

	for (i = 0; i < ARRAY_SIZE(mv88e6xxx_table); i++) {
		/* same logic as in mv88e6xxx_get_max_mtu() */
		if (mv88e6xxx_table[i].ops->port_set_jumbo_size)
			max = 10240;
		else if (mv88e6xxx_table[i].ops->set_max_frame_size)
			max = 1632;
		else
			max = 1522;

		if (mv88e6xxx_table[i].max_frame_size != max)
			pr_err("BUG: %s has differing max_frame_size: %d != %d\n",
			       mv88e6xxx_table[i].name, max,
			       mv88e6xxx_table[i].max_frame_size);
	}
}

called from the mv88e6xxx_probe() function. I don't see any need to
do much more than that to verify the table, and I don't see any need
to make it only execute once - it's not like the code will be around
for very long.

Provided this code gets run, we can then be sure that the
max_frame_size values initially added correspond with the values
the driver currently uses.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
