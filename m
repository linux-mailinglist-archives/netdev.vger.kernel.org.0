Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A647D6AF6C7
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 21:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjCGUgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 15:36:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjCGUgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 15:36:31 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0356A7AA2;
        Tue,  7 Mar 2023 12:36:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=BVb4tiMdT2faXd9FacvIsPER+ODtFm7SXnJKt/bIKr0=; b=XGkkYfMl0eR2Y5wzxKDMDPNrn6
        +rpYYkyAcD+KC/5LdUYdjbbzDP670KJnpZC8xkvFvh47FJPVoC7PHNTwgCmmKukCe5q8dYb6edElx
        CRu9TxI/bt8+LUNptGEYi6cAxXM526j2XXdeBPT/O7+jny9MlxoCJ7uNlgqOzjpnyjs0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pZe2A-006haZ-W3; Tue, 07 Mar 2023 21:35:42 +0100
Date:   Tue, 7 Mar 2023 21:35:42 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Klaus Kudielka <klaus.kudielka@gmail.com>
Cc:     Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-aspeed@lists.ozlabs.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH net-next v2 4/6] net: mdio: scan bus based on bus
 capabilities for C22 and C45
Message-ID: <72530e86-9ba9-4a01-9cd2-68835ecae7a0@lunn.ch>
References: <20230116-net-next-remove-probe-capabilities-v2-0-15513b05e1f4@walle.cc>
 <20230116-net-next-remove-probe-capabilities-v2-4-15513b05e1f4@walle.cc>
 <449bde236c08d5ab5e54abd73b645d8b29955894.camel@gmail.com>
 <100c439a-2a4d-4cb2-96f2-5bf273e2121a@lunn.ch>
 <712bc92ca6d576f33f63f1e9c2edf0030b10d3ae.camel@gmail.com>
 <db6b8a09-b680-4baa-8963-d355ad29eb09@lunn.ch>
 <0e10aa8492eadb587949d8744b56fccaabbd183b.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e10aa8492eadb587949d8744b56fccaabbd183b.camel@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Summary: Still 4 calls to mdio_bus_scan_c22, but also *2* calls to mdio_bus_scan_c45, approx. 190*100 reads by the switch driver

Those calls to mdio_bus_scan_c45 are caused by 743a19e38d02 net: dsa:
mv88e6xxx: Separate C22 and C45 transactions.

Some families of the mv88e6xxx do support C45 bus transactions. That
includes the 6171 you have. Before, we never scanned the C45 bus, but
now we do.

But something does not add up. Doing an additional c45 scan should
only double the number of reads by the switch driver.

The only part of a c45 scan which is not linear is
mv88e6xxx_g2_smi_phy_wait() which is implemented by
mv88e6xxx_wait_mask(). That loops reading a register waiting for a bit
to change. Maybe print out the value of i, and see if it is looping
more times for C45 than C22?

     Andrew
