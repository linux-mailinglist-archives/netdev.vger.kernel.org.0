Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4562C2B6EB6
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 20:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728328AbgKQTdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 14:33:33 -0500
Received: from mailout06.rmx.de ([94.199.90.92]:33061 "EHLO mailout06.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725613AbgKQTdd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 14:33:33 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout06.rmx.de (Postfix) with ESMTPS id 4CbGMD3YZBz9tP3;
        Tue, 17 Nov 2020 20:33:28 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CbGLH5BJpz2xGF;
        Tue, 17 Nov 2020 20:32:39 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.38) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 17 Nov
 2020 20:32:33 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Christian Eggers <ceggers@arri.de>,
        "Richard Cochran" <richard.cochran@omicron.at>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next 2/4] net: phy: dp83640: use enum ptp_msg_type
Date:   Tue, 17 Nov 2020 20:31:22 +0100
Message-ID: <20201117193124.9789-2-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201117193124.9789-1-ceggers@arri.de>
References: <20201117193124.9789-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.38]
X-RMX-ID: 20201117-203247-4CbGLH5BJpz2xGF-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new return type of ptp_get_msgtype(). Remove usage of magic number.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Cc: Richard Cochran <richard.cochran@omicron.at>
Cc: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/phy/dp83640.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index f2caccaf4408..bb68db3518bc 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -88,7 +88,7 @@ struct rxts {
 	unsigned long tmo;
 	u64 ns;
 	u16 seqid;
-	u8  msgtype;
+	enum ptp_msg_type msgtype;
 	u16 hash;
 };
 
@@ -803,7 +803,7 @@ static int decode_evnt(struct dp83640_private *dp83640,
 static int match(struct sk_buff *skb, unsigned int type, struct rxts *rxts)
 {
 	struct ptp_header *hdr;
-	u8 msgtype;
+	enum ptp_msg_type msgtype;
 	u16 seqid;
 	u16 hash;
 
@@ -815,7 +815,7 @@ static int match(struct sk_buff *skb, unsigned int type, struct rxts *rxts)
 
 	msgtype = ptp_get_msgtype(hdr, type);
 
-	if (rxts->msgtype != (msgtype & 0xf))
+	if (rxts->msgtype != msgtype)
 		return 0;
 
 	seqid = be16_to_cpu(hdr->sequence_id);
@@ -964,7 +964,7 @@ static void decode_status_frame(struct dp83640_private *dp83640,
 static int is_sync(struct sk_buff *skb, int type)
 {
 	struct ptp_header *hdr;
-	u8 msgtype;
+	enum ptp_msg_type msgtype;
 
 	hdr = ptp_parse_header(skb, type);
 	if (!hdr)
@@ -972,7 +972,7 @@ static int is_sync(struct sk_buff *skb, int type)
 
 	msgtype = ptp_get_msgtype(hdr, type);
 
-	return (msgtype & 0xf) == 0;
+	return msgtype == PTP_MSGTYPE_SYNC;
 }
 
 static void dp83640_free_clocks(void)
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

