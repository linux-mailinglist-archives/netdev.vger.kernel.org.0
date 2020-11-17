Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956442B6EC8
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 20:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730332AbgKQTfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 14:35:06 -0500
Received: from mailout08.rmx.de ([94.199.90.85]:37941 "EHLO mailout08.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728666AbgKQTfF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 14:35:05 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout08.rmx.de (Postfix) with ESMTPS id 4CbGP00LtzzMm7K;
        Tue, 17 Nov 2020 20:35:00 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CbGN71y83z2xDp;
        Tue, 17 Nov 2020 20:34:15 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.38) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 17 Nov
 2020 20:33:48 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Christian Eggers <ceggers@arri.de>,
        "Kurt Kanzenbach" <kurt@linutronix.de>
Subject: [PATCH net-next 4/4] ptp: ptp_ines: use enum ptp_msg_type
Date:   Tue, 17 Nov 2020 20:31:24 +0100
Message-ID: <20201117193124.9789-4-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201117193124.9789-1-ceggers@arri.de>
References: <20201117193124.9789-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.38]
X-RMX-ID: 20201117-203419-4CbGN71y83z2xDp-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new return type of ptp_get_msgtype(). Remove driver internal defines
for this.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/ptp/ptp_ines.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/ptp/ptp_ines.c b/drivers/ptp/ptp_ines.c
index 4700ffbdfced..4836c9c35604 100644
--- a/drivers/ptp/ptp_ines.c
+++ b/drivers/ptp/ptp_ines.c
@@ -108,11 +108,6 @@ MODULE_LICENSE("GPL");
 #define MESSAGE_TYPE_P_DELAY_RESP	3
 #define MESSAGE_TYPE_DELAY_REQ		4
 
-#define SYNC				0x0
-#define DELAY_REQ			0x1
-#define PDELAY_REQ			0x2
-#define PDELAY_RESP			0x3
-
 static LIST_HEAD(ines_clocks);
 static DEFINE_MUTEX(ines_clocks_lock);
 
@@ -442,7 +437,7 @@ static bool ines_match(struct sk_buff *skb, unsigned int ptp_class,
 {
 	struct ptp_header *hdr;
 	u16 portn, seqid;
-	u8 msgtype;
+	enum ptp_msg_type msgtype;
 	u64 clkid;
 
 	if (unlikely(ptp_class & PTP_CLASS_V1))
@@ -675,7 +670,7 @@ static void ines_txtstamp_work(struct work_struct *work)
 static bool is_sync_pdelay_resp(struct sk_buff *skb, int type)
 {
 	struct ptp_header *hdr;
-	u8 msgtype;
+	enum ptp_msg_type msgtype;
 
 	hdr = ptp_parse_header(skb, type);
 	if (!hdr)
@@ -683,26 +678,26 @@ static bool is_sync_pdelay_resp(struct sk_buff *skb, int type)
 
 	msgtype = ptp_get_msgtype(hdr, type);
 
-	switch ((msgtype & 0xf)) {
-	case SYNC:
-	case PDELAY_RESP:
+	switch (msgtype) {
+	case PTP_MSGTYPE_SYNC:
+	case PTP_MSGTYPE_PDELAY_RESP:
 		return true;
 	default:
 		return false;
 	}
 }
 
-static u8 tag_to_msgtype(u8 tag)
+static enum ptp_msg_type tag_to_msgtype(u8 tag)
 {
 	switch (tag) {
 	case MESSAGE_TYPE_SYNC:
-		return SYNC;
+		return PTP_MSGTYPE_SYNC;
 	case MESSAGE_TYPE_P_DELAY_REQ:
-		return PDELAY_REQ;
+		return PTP_MSGTYPE_PDELAY_REQ;
 	case MESSAGE_TYPE_P_DELAY_RESP:
-		return PDELAY_RESP;
+		return PTP_MSGTYPE_PDELAY_RESP;
 	case MESSAGE_TYPE_DELAY_REQ:
-		return DELAY_REQ;
+		return PTP_MSGTYPE_DELAY_REQ;
 	}
 	return 0xf;
 }
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

