Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3AAC2B6EB3
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 20:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729522AbgKQTco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 14:32:44 -0500
Received: from mailout11.rmx.de ([94.199.88.76]:43794 "EHLO mailout11.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727019AbgKQTco (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 14:32:44 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout11.rmx.de (Postfix) with ESMTPS id 4CbGLH5FB1z3yV3;
        Tue, 17 Nov 2020 20:32:39 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CbGKV6zcVz2xZR;
        Tue, 17 Nov 2020 20:31:58 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.38) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 17 Nov
 2020 20:31:58 +0100
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
Subject: [PATCH net-next 1/4] net: ptp: introduce enum ptp_msg_type
Date:   Tue, 17 Nov 2020 20:31:21 +0100
Message-ID: <20201117193124.9789-1-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.38]
X-RMX-ID: 20201117-203158-4CbGKV6zcVz2xZR-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using a PTP wide enum will obsolete different driver internal defines
and uses of magic numbers.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Cc: Kurt Kanzenbach <kurt@linutronix.de>
---
 include/linux/ptp_classify.h | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/linux/ptp_classify.h b/include/linux/ptp_classify.h
index 56b2d7d66177..83024220cb42 100644
--- a/include/linux/ptp_classify.h
+++ b/include/linux/ptp_classify.h
@@ -93,6 +93,13 @@ unsigned int ptp_classify_raw(const struct sk_buff *skb);
  */
 struct ptp_header *ptp_parse_header(struct sk_buff *skb, unsigned int type);
 
+enum ptp_msg_type {
+	PTP_MSGTYPE_SYNC        = 0x0,
+	PTP_MSGTYPE_DELAY_REQ   = 0x1,
+	PTP_MSGTYPE_PDELAY_REQ  = 0x2,
+	PTP_MSGTYPE_PDELAY_RESP = 0x3,
+};
+
 /**
  * ptp_get_msgtype - Extract ptp message type from given header
  * @hdr: ptp header
@@ -103,10 +110,10 @@ struct ptp_header *ptp_parse_header(struct sk_buff *skb, unsigned int type);
  *
  * Return: The message type
  */
-static inline u8 ptp_get_msgtype(const struct ptp_header *hdr,
+static inline enum ptp_msg_type ptp_get_msgtype(const struct ptp_header *hdr,
 				 unsigned int type)
 {
-	u8 msgtype;
+	enum ptp_msg_type msgtype;
 
 	if (unlikely(type & PTP_CLASS_V1)) {
 		/* msg type is located at the control field for ptp v1 */
@@ -132,13 +139,13 @@ static inline struct ptp_header *ptp_parse_header(struct sk_buff *skb,
 {
 	return NULL;
 }
-static inline u8 ptp_get_msgtype(const struct ptp_header *hdr,
+static inline enum ptp_msg_type ptp_get_msgtype(const struct ptp_header *hdr,
 				 unsigned int type)
 {
 	/* The return is meaningless. The stub function would not be
 	 * executed since no available header from ptp_parse_header.
 	 */
-	return 0;
+	return PTP_MSGTYPE_SYNC;
 }
 #endif
 #endif /* _PTP_CLASSIFY_H_ */
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

