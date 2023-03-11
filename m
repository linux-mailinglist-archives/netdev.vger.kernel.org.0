Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A16DB6B5D62
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 16:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjCKPkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 10:40:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCKPkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 10:40:16 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C7E584A4;
        Sat, 11 Mar 2023 07:40:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=L1cjWa/ZkeQ8ynLS3HKj8W+1nV4bPBS6kn+zz6pEL5o=; b=lDIfeYMpfdi1Shz/zgmeAVzusF
        x0OEDGQ7Z6xWJV0WYKAedb45mhigl1d3v7Rp4+oxS6/c7dG4Gtq5h8DXWBlX2hNo1fHCotl1eOB/J
        GWSyM2lJOXImtgRMI7Ct7afh4KEiz7rG2+6+STKjo44VLsu9aDw855+FMSxYMvtefYn8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pb1Jo-0074HD-9X; Sat, 11 Mar 2023 16:39:36 +0100
Date:   Sat, 11 Mar 2023 16:39:36 +0100
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
Message-ID: <a57a216d-ff5a-46e6-9780-e53772dcefc8@lunn.ch>
References: <100c439a-2a4d-4cb2-96f2-5bf273e2121a@lunn.ch>
 <712bc92ca6d576f33f63f1e9c2edf0030b10d3ae.camel@gmail.com>
 <db6b8a09-b680-4baa-8963-d355ad29eb09@lunn.ch>
 <0e10aa8492eadb587949d8744b56fccaabbd183b.camel@gmail.com>
 <72530e86-9ba9-4a01-9cd2-68835ecae7a0@lunn.ch>
 <09d65e1ee0679e1e74b4f3a5a4c55bd48332f043.camel@gmail.com>
 <70f5bca0-322c-4bae-b880-742e56365abe@lunn.ch>
 <10da10caea22a8f5da8f1779df3e13b948e8a363.camel@gmail.com>
 <4abd56aa-5b9f-4e16-b0ca-11989bb8c764@lunn.ch>
 <bff0e542b8c04980e9e3af1d3e6bf739c87eb514.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bff0e542b8c04980e9e3af1d3e6bf739c87eb514.camel@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 11, 2023 at 07:49:23AM +0100, Klaus Kudielka wrote:
> On Sat, 2023-03-11 at 00:49 +0100, Andrew Lunn wrote:
> > > Yes, that helps. Primarily, because mdiobus_scan_bus_c45 now is called only once,
> > > and at least some things are done in parallel.
> > 
> > Great. Could you cook up a proper patch and submit it?
> 
> I can give it a try. The commit message will be from my perspective,
> and the change Suggested-By you.

The commit message is fine.

I have one more idea which can speed things up. The scanning of the
MDIO bus works in two different ways depending on if there is a DT
node, describing what should be found on the bus. For mv88e6xxx, using
DT is optional. Some boards do, some don't.

If there is a DT node, only the addresses listed in DT are scanned.

If there is no DT node, by default, all 32 addresses on the bus are
scanned. However, DSA makes another assumption. There is a one to one
mapping between port number and PHY address on the MDIO bus. Port 0
uses MDIO address 0. Port 7 uses MDIO address 7 etc. If you have an 8
port switch, there is no point scanning addresses 8 to 31, they will
never be used.

The mdio bus structure has a member phy_mask. This is a bitmap. If bit
N is set, address N is not scanned. So i suggest you extend
mv88e6xxx_mdio_register() to set phy_mask based on
mv88e6xxx_num_ports(chip).

	Andrew
