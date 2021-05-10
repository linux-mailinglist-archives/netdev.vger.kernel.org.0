Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C53F3789D9
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 13:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234455AbhEJLdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 07:33:09 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:52703 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236627AbhEJLIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 07:08:22 -0400
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 757B022239;
        Mon, 10 May 2021 13:07:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1620644836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=UvqLle58hbQrYS8D+Qw3M/VyRDyS9/kql1bKzFA9u7k=;
        b=fARMSm9TNGEW00ePDePRuLEWD6meuhM4gNJBexH8X5WahVhkjcmFtIsh/DkiZ1PZadJdlT
        l3/Z/XBwt3yGoJUb3z5w+Uw2QS8BKKV+qPLzxcQb5TNaW/2096auE7k6llCniolwJprYq+
        ygS8YDrQqBviVGNwEKsF4vjWMF4yaD4=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net] net: dsa: felix: re-enable TAS guard band mode
Date:   Mon, 10 May 2021 13:07:08 +0200
Message-Id: <20210510110708.11504-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 316bcffe4479 ("net: dsa: felix: disable always guard band bit for
TAS config") disabled the guard band and broke 802.3Qbv compliance.

There are two issues here:
 (1) Without the guard band the end of the scheduling window could be
     overrun by a frame in transit.
 (2) Frames that don't fit into a configured window will still be sent.

The reason for both issues is that the switch will schedule the _start_
of a frame transmission inside the predefined window without taking the
length of the frame into account. Thus, we'll need the guard band which
will close the gate early, so that a complete frame can still be sent.
Revert the commit and add a note.

For a lengthy discussion see [1].

[1] https://lore.kernel.org/netdev/c7618025da6723418c56a54fe4683bd7@walle.cc/

Fixes: 316bcffe4479 ("net: dsa: felix: disable always guard band bit for TAS config")
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 2473bebe48e6..f966a253d1c7 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1227,12 +1227,17 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 	if (taprio->num_entries > VSC9959_TAS_GCL_ENTRY_MAX)
 		return -ERANGE;
 
-	/* Set port num and disable ALWAYS_GUARD_BAND_SCH_Q, which means set
-	 * guard band to be implemented for nonschedule queues to schedule
-	 * queues transition.
+	/* Enable guard band. The switch will schedule frames without taking
+	 * their length into account. Thus we'll always need to enable the
+	 * guard band which reserves the time of a maximum sized frame at the
+	 * end of the time window.
+	 *
+	 * Although the ALWAYS_GUARD_BAND_SCH_Q bit is global for all ports, we
+	 * need to set PORT_NUM, because subsequent writes to PARAM_CFG_REG_n
+	 * operate on the port number.
 	 */
-	ocelot_rmw(ocelot,
-		   QSYS_TAS_PARAM_CFG_CTRL_PORT_NUM(port),
+	ocelot_rmw(ocelot, QSYS_TAS_PARAM_CFG_CTRL_PORT_NUM(port) |
+		   QSYS_TAS_PARAM_CFG_CTRL_ALWAYS_GUARD_BAND_SCH_Q,
 		   QSYS_TAS_PARAM_CFG_CTRL_PORT_NUM_M |
 		   QSYS_TAS_PARAM_CFG_CTRL_ALWAYS_GUARD_BAND_SCH_Q,
 		   QSYS_TAS_PARAM_CFG_CTRL);
-- 
2.20.1

