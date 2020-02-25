Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4256B16F2F0
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 00:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729297AbgBYXIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 18:08:55 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:37647 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbgBYXIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 18:08:55 -0500
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id DF04622FE5;
        Wed, 26 Feb 2020 00:08:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1582672132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bBQCpWzOT+jCTvKUq+eGkBcAmAFVVUcn5WV8ncy2QlE=;
        b=N61VRDYWpZK8b1WQH8wA+EgWLWO1wXOY4MuiaNGsbVV116f2DKquii8QhBLwp6aYf7p99e
        ucO88t0RlEaMdXUjS5jH0rmt5fyjU9tpMUKoi/3O8iGjFe+i5g7G9rTZMKEoKlGK85J5Q+
        LKwpq2j3oefL/en6JlLT0V1KRCXC6Us=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Michael Walle <michael@walle.cc>
Subject: [RFC PATCH 0/2] AT8031 PHY timestamping support
Date:   Wed, 26 Feb 2020 00:08:17 +0100
Message-Id: <20200225230819.7325-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
X-Spam-Level: ******
X-Rspamd-Server: web
X-Spam-Status: Yes, score=6.40
X-Spam-Score: 6.40
X-Rspamd-Queue-Id: DF04622FE5
X-Spamd-Result: default: False [6.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         BROKEN_CONTENT_TYPE(1.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         NEURAL_SPAM(0.00)[1.036];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[9];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:31334, ipnet:2a02:810c::/31, country:DE];
         FREEMAIL_CC(0.00)[lunn.ch,gmail.com,armlinux.org.uk,davemloft.net,walle.cc];
         SUSPICIOUS_RECIPS(1.50)[]
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is the current state of my work for adding PHY timestamping
support. I just wanted to post this to the mailinglist before I never do
it. Maybe its a starting point for other people. That being said, I
wouldn't mind comments ;) The code basically works but there are three
major caveats:

 (1) The reading of timestamps via MDIO sometimes return wrong values. What
     I see is that a part of the timestamp corresponds to the new timestamp
	 while another part still contains old values. Thus at the moment, I'm
	 reading the registers twice. I don't know if the reading actually
	 affects the update of the timestamp or the different timing (my MDIO
	 bus is rather slow, so reading the timestamp a second time take some
	 amount of time; but I've also tested with some delays and it didn't
	 had any effects). There is also no possibility to read the timestamp
	 atomically :(
 (2) It seems to be the case that the PHY generates an interrupt on every
     PTP message, eg. even if it is not an event message meaning that a new
	 timestamp is ready. Thus we might read the timestamp too often.
 (3) Sometimes the TX timestamp is missing. It seems that in this case the
     PHY doesn't generate an interrupt. If you check for any RX_PTP/TX_PTP
	 interrupt pending and then read both timestamps (remember that
	 get_rxts/get_txts checks that the timestamp has actually changed)
	 it seems to work though.

	   if (mask & (AT8031_INTR_RX_PTP | AT8031_INTR_TX_PTP)) {
			   at8031_get_rxts(phydev);
			   at8031_get_txts(phydev);
	   }

Please note that the patch doesn't contain the code above. Replacing the
IRQ handling with the code make PTP actually work, but I'm not satisfied
with that solution, esp. reading the timestamps multiple times over MDIO.
So currently I'm stuck and unfortunately, I'm not able to get support from
Atheros/our FAE.

The PHY also supports appending the timestamp to the actual ethernet frame,
but this seems to only work when the PHY is connected via RGMII. I've never
get it to work with a SGMII connection.

The first patch might actually be useful outside of this series. See also
  https://lore.kernel.org/netdev/bd47f8e1ebc04fa98856ed8d89b91419@walle.cc/

-michael

Michael Walle (2):
  net: phy: let the driver register its own IRQ handler
  net: phy: at803x: add PTP support for AR8031

 drivers/net/phy/Kconfig      |  17 +
 drivers/net/phy/at803x.c     | 879 ++++++++++++++++++++++++++++++++++-
 drivers/net/phy/phy.c        |  15 +
 drivers/net/phy/phy_device.c |   6 +-
 include/linux/phy.h          |   2 +
 5 files changed, 892 insertions(+), 27 deletions(-)

-- 
2.20.1

