Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83302652EE7
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 10:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234653AbiLUJuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 04:50:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234619AbiLUJtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 04:49:04 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB05E22B27;
        Wed, 21 Dec 2022 01:47:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1671616069; x=1703152069;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UW9weyQb1i5iAnjitm37ivyAzEtGjXAcDn9E3AWAHPs=;
  b=TFnMKntueme5liyxinfy7w2jkT1188YlpvF5wCDFk0ycpaZ6Y0DcdCqN
   fJrPAKUwGY0xBqVeW1sS4sZKoQfdG0sys5HCKqB5DWmuMOz8R7M+pQjxa
   7G1c+TKJf+SpS5msoX5POHUvJQvZvFWekQ7rp2aIUDhPrSfpPu1a/JgET
   vBWtw3p9QT4N4VR2YNjr0vz6f0vh7UJpunvVyeorVXWmNoeBwXWV00KTM
   1zv2qlHpshrMAHewUhDdeSIPdCPD2+ipLUJMgmpOKB9aQ/SBNJqYY+WMV
   1+qTwR8LRGRhY4uW3CDjIjtt6PF3NYPFFP/MHEuJqozv9Mw5bsjYrCOpH
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="193886750"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Dec 2022 02:47:48 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 21 Dec 2022 02:47:48 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Wed, 21 Dec 2022 02:47:41 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>, <ceggers@arri.de>,
        <jacob.e.keller@intel.com>
Subject: [RFC Patch net-next v5 09/13] net: dsa: microchip: ptp: move pdelay_rsp correction field to tail tag
Date:   Wed, 21 Dec 2022 15:16:08 +0530
Message-ID: <20221221094612.22372-10-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221221094612.22372-1-arun.ramadoss@microchip.com>
References: <20221221094612.22372-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christian Eggers <ceggers@arri.de>

For PDelay_Resp messages we will likely have a negative value in the
correction field. The switch hardware cannot correctly update such
values (produces an off by one error in the UDP checksum), so it must be
moved to the time stamp field in the tail tag. Format of the correction
field is 48 bit ns + 16 bit fractional ns.  After updating the
correction field, clone is no longer required hence it is freed.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Co-developed-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
v2 -> v3
- used update_correction variable in skb->cb instead of ptp_msg_type

v1 -> v2
- added fallthrough keyword in switch case to suppress checkpatch
warning

RFC v3 -> Patch v1
- Patch is separated from transmission logic patch
---
 drivers/net/dsa/microchip/ksz_ptp.c |  5 ++++
 include/linux/dsa/ksz_common.h      |  2 ++
 net/dsa/tag_ksz.c                   | 41 ++++++++++++++++++++++++++++-
 3 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
index 8f5e099b1b99..5d5b8d4ed17b 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -267,6 +267,8 @@ void ksz_port_txtstamp(struct dsa_switch *ds, int port,
 
 	switch (ptp_msg_type) {
 	case PTP_MSGTYPE_PDELAY_REQ:
+		 fallthrough;
+	case PTP_MSGTYPE_PDELAY_RESP:
 		break;
 
 	default:
@@ -279,6 +281,9 @@ void ksz_port_txtstamp(struct dsa_switch *ds, int port,
 
 	/* caching the value to be used in tag_ksz.c */
 	KSZ_SKB_CB(skb)->clone = clone;
+	KSZ_SKB_CB(clone)->ptp_type = type;
+	if (ptp_msg_type == PTP_MSGTYPE_PDELAY_RESP)
+		KSZ_SKB_CB(clone)->update_correction = true;
 }
 
 static void ksz_ptp_txtstamp_skb(struct ksz_device *dev,
diff --git a/include/linux/dsa/ksz_common.h b/include/linux/dsa/ksz_common.h
index b91beab5e138..576a99ca698d 100644
--- a/include/linux/dsa/ksz_common.h
+++ b/include/linux/dsa/ksz_common.h
@@ -36,6 +36,8 @@ struct ksz_tagger_data {
 
 struct ksz_skb_cb {
 	struct sk_buff *clone;
+	unsigned int ptp_type;
+	bool update_correction;
 	u32 tstamp;
 };
 
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index e14ee26bf6a0..7dd2133b0820 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -7,6 +7,7 @@
 #include <linux/dsa/ksz_common.h>
 #include <linux/etherdevice.h>
 #include <linux/list.h>
+#include <linux/ptp_classify.h>
 #include <net/dsa.h>
 
 #include "tag.h"
@@ -194,14 +195,52 @@ static void ksz_rcv_timestamp(struct sk_buff *skb, u8 *tag)
  */
 static void ksz_xmit_timestamp(struct dsa_port *dp, struct sk_buff *skb)
 {
+	struct sk_buff *clone = KSZ_SKB_CB(skb)->clone;
 	struct ksz_tagger_private *priv;
+	struct ptp_header *ptp_hdr;
+	bool update_correction;
+	unsigned int ptp_type;
+	u32 tstamp_raw = 0;
+	s64 correction;
 
 	priv = ksz_tagger_private(dp->ds);
 
 	if (!test_bit(KSZ_HWTS_EN, &priv->state))
 		return;
 
-	put_unaligned_be32(0, skb_put(skb, KSZ_PTP_TAG_LEN));
+	if (!clone)
+		goto output_tag;
+
+	update_correction = KSZ_SKB_CB(clone)->update_correction;
+	if (!update_correction)
+		goto output_tag;
+
+	ptp_type = KSZ_SKB_CB(clone)->ptp_type;
+
+	ptp_hdr = ptp_parse_header(skb, ptp_type);
+	if (!ptp_hdr)
+		goto output_tag;
+
+	correction = (s64)get_unaligned_be64(&ptp_hdr->correction);
+
+	if (correction < 0) {
+		struct timespec64 ts;
+
+		ts = ns_to_timespec64(-correction >> 16);
+		tstamp_raw = ((ts.tv_sec & 3) << 30) | ts.tv_nsec;
+
+		/* Set correction field to 0 and update UDP checksum.  */
+		ptp_header_update_correction(skb, ptp_type, ptp_hdr, 0);
+	}
+
+	/* For PDelay_Resp messages, the clone is not required in
+	 * skb_complete_tx_timestamp() and should be freed here.
+	 */
+	kfree_skb(clone);
+	KSZ_SKB_CB(skb)->clone = NULL;
+
+output_tag:
+	put_unaligned_be32(tstamp_raw, skb_put(skb, KSZ_PTP_TAG_LEN));
 }
 
 /* Defer transmit if waiting for egress time stamp is required.  */
-- 
2.36.1

