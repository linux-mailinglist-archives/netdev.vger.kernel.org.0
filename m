Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A35F4E4C75
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 07:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241919AbiCWGFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 02:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232574AbiCWGFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 02:05:13 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54026E8D9
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 23:03:41 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nWu5k-0000A0-QL; Wed, 23 Mar 2022 07:03:32 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nWu5j-0000FY-28; Wed, 23 Mar 2022 07:03:31 +0100
Date:   Wed, 23 Mar 2022 07:03:31 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yangbo Lu <yangbo.lu@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: sja1105q: proper way to solve PHY clk dependecy
Message-ID: <20220323060331.GA4519@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 06:43:19 up 102 days, 14:28, 61 users,  load average: 0.21, 0.09,
 0.09
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

I have SJA1105Q based switch with 3 T1L PHYs connected over RMII
interface. The clk input "XI" of PHYs is connected to "MII0_TX_CLK/REF_CLK/TXC"
pins of the switch. Since this PHYs can't be configured reliably over MDIO
interface without running clk on XI input, i have a dependency dilemma:
i can't probe MDIO bus, without enabling DSA ports.

If I see it correctly, following steps should be done:
- register MDIO bus without scanning for PHYs
- define SJA1105Q switch as clock provider and PHYs as clk consumer
- detect and attach PHYs on port enable if clks can't be controlled
  without enabling the port.
- HW reset line of the PHYs should be asserted if we disable port and
  deasserted with proper reinit after port is enabled.

Other way would be to init and enable switch ports and PHYs by a bootloader and
keep it enabled.

What is the proper way to go?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
