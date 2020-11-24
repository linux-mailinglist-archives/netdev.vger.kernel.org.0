Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80BD82C1F1F
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 08:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730286AbgKXHr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 02:47:29 -0500
Received: from mailout10.rmx.de ([94.199.88.75]:36712 "EHLO mailout10.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730164AbgKXHr2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 02:47:28 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout10.rmx.de (Postfix) with ESMTPS id 4CgGMH6L6Dz34wv;
        Tue, 24 Nov 2020 08:47:23 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CgGLT0lcLz2xZP;
        Tue, 24 Nov 2020 08:46:41 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.100) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 24 Nov
 2020 08:46:02 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Christian Eggers <ceggers@arri.de>,
        "Antoine Tenart" <atenart@kernel.org>
Subject: [PATCH net-next v2 3/3] net: phy: mscc: use new PTP_MSGTYPE_* defines
Date:   Tue, 24 Nov 2020 08:44:18 +0100
Message-ID: <20201124074418.2609-4-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201124074418.2609-1-ceggers@arri.de>
References: <20201124074418.2609-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.100]
X-RMX-ID: 20201124-084643-4CgGLT0lcLz2xZP-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use recently introduced PTP_MSGTYPE_SYNC and PTP_MSGTYPE_DELAY_REQ
defines instead of a driver internal enumeration.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Cc: Antoine Tenart <atenart@kernel.org>
---
 drivers/net/phy/mscc/mscc_ptp.c | 14 +++++++-------
 drivers/net/phy/mscc/mscc_ptp.h |  5 -----
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_ptp.c b/drivers/net/phy/mscc/mscc_ptp.c
index d8a61456d1ce..924ed5b034a4 100644
--- a/drivers/net/phy/mscc/mscc_ptp.c
+++ b/drivers/net/phy/mscc/mscc_ptp.c
@@ -506,9 +506,9 @@ static int vsc85xx_ptp_cmp_init(struct phy_device *phydev, enum ts_blk blk)
 {
 	struct vsc8531_private *vsc8531 = phydev->priv;
 	bool base = phydev->mdio.addr == vsc8531->ts_base_addr;
-	enum vsc85xx_ptp_msg_type msgs[] = {
-		PTP_MSG_TYPE_SYNC,
-		PTP_MSG_TYPE_DELAY_REQ
+	u8 msgs[] = {
+		PTP_MSGTYPE_SYNC,
+		PTP_MSGTYPE_DELAY_REQ
 	};
 	u32 val;
 	u8 i;
@@ -847,9 +847,9 @@ static int vsc85xx_ts_ptp_action_flow(struct phy_device *phydev, enum ts_blk blk
 static int vsc85xx_ptp_conf(struct phy_device *phydev, enum ts_blk blk,
 			    bool one_step, bool enable)
 {
-	enum vsc85xx_ptp_msg_type msgs[] = {
-		PTP_MSG_TYPE_SYNC,
-		PTP_MSG_TYPE_DELAY_REQ
+	u8 msgs[] = {
+		PTP_MSGTYPE_SYNC,
+		PTP_MSGTYPE_DELAY_REQ
 	};
 	u32 val;
 	u8 i;
@@ -858,7 +858,7 @@ static int vsc85xx_ptp_conf(struct phy_device *phydev, enum ts_blk blk,
 		if (blk == INGRESS)
 			vsc85xx_ts_ptp_action_flow(phydev, blk, msgs[i],
 						   PTP_WRITE_NS);
-		else if (msgs[i] == PTP_MSG_TYPE_SYNC && one_step)
+		else if (msgs[i] == PTP_MSGTYPE_SYNC && one_step)
 			/* no need to know Sync t when sending in one_step */
 			vsc85xx_ts_ptp_action_flow(phydev, blk, msgs[i],
 						   PTP_WRITE_1588);
diff --git a/drivers/net/phy/mscc/mscc_ptp.h b/drivers/net/phy/mscc/mscc_ptp.h
index 3ea163af0f4f..da3465360e90 100644
--- a/drivers/net/phy/mscc/mscc_ptp.h
+++ b/drivers/net/phy/mscc/mscc_ptp.h
@@ -436,11 +436,6 @@ enum ptp_cmd {
 	PTP_SAVE_IN_TS_FIFO = 11, /* invalid when writing in reg */
 };
 
-enum vsc85xx_ptp_msg_type {
-	PTP_MSG_TYPE_SYNC,
-	PTP_MSG_TYPE_DELAY_REQ,
-};
-
 struct vsc85xx_ptphdr {
 	u8 tsmt; /* transportSpecific | messageType */
 	u8 ver;  /* reserved0 | versionPTP */
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

