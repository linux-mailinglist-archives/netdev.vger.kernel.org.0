Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E20ED643FA1
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234752AbiLFJRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:17:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235014AbiLFJRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:17:10 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B876205CB;
        Tue,  6 Dec 2022 01:16:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670318193; x=1701854193;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8zmuvJbN+CIFS6o0aluGJxj9TsaZ0LRNLARkVM7mehc=;
  b=M4FgzYh3WjPhGRYku6Ffc8mlDrjCiQVKAyotcT1Mj18sE4XXHxH1Z8E1
   fRdJgIwQ4UZpqdrIuVgX816/Czec1c4creUfDY4ksNetIF2dPb1j5Bfmr
   fQQmpBpxS5OXLonXrdkzYvS4/i711Xr+7QDOJnjlRnzJlSc4Cz3yTyTl8
   OkOIDkPSiZkBpvZyNjA5O1lddHDQObyvK/z/ep7fsQN5gTUJznGAqtEi1
   aqKkPSDcDQiw8aiAkSiSEmzzwSteiaJs78k9stKS2wWj8kMHW35XlcNaf
   D8yRUA170P94xw9dd/F1QK/kW2nUXPqTe0R0VF5g9a3zCzQUG/xRE+rDk
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="186737403"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Dec 2022 02:16:29 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 6 Dec 2022 02:16:27 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 6 Dec 2022 02:16:21 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>, <ceggers@arri.de>
Subject: [Patch net-next v2 09/13] net: dsa: microchip: ptp: move pdelay_rsp correction field to tail tag
Date:   Tue, 6 Dec 2022 14:44:24 +0530
Message-ID: <20221206091428.28285-10-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221206091428.28285-1-arun.ramadoss@microchip.com>
References: <20221206091428.28285-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
---
v1 -> v2
- added fallthrough keyword in switch case to suppress checkpatch
warning

RFC v3 -> Patch v1
- Patch is separated from transmission logic patch
---
 drivers/net/dsa/microchip/ksz_ptp.c |  4 +++
 include/linux/dsa/ksz_common.h      |  2 ++
 net/dsa/tag_ksz.c                   | 42 ++++++++++++++++++++++++++++-
 3 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
index dcecc08a8d42..512fa4098261 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -202,6 +202,8 @@ void ksz_port_txtstamp(struct dsa_switch *ds, int port,
 
 	switch (ptp_msg_type) {
 	case PTP_MSGTYPE_PDELAY_REQ:
+		 fallthrough;
+	case PTP_MSGTYPE_PDELAY_RESP:
 		break;
 
 	default:
@@ -214,6 +216,8 @@ void ksz_port_txtstamp(struct dsa_switch *ds, int port,
 
 	/* caching the value to be used in later */
 	KSZ_SKB_CB(skb)->clone = clone;
+	KSZ_SKB_CB(clone)->ptp_type = type;
+	KSZ_SKB_CB(clone)->ptp_msg_type = ptp_msg_type;
 }
 
 static int _ksz_ptp_gettime(struct ksz_device *dev, struct timespec64 *ts)
diff --git a/include/linux/dsa/ksz_common.h b/include/linux/dsa/ksz_common.h
index 55ee714a9a13..b180eb3429bd 100644
--- a/include/linux/dsa/ksz_common.h
+++ b/include/linux/dsa/ksz_common.h
@@ -37,6 +37,8 @@ struct ksz_tagger_data {
 
 struct ksz_skb_cb {
 	struct sk_buff *clone;
+	unsigned int ptp_type;
+	u8 ptp_msg_type;
 };
 
 #define KSZ_SKB_CB(skb) \
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index cdca1f15fc6f..e57066f3947e 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -236,14 +236,54 @@ static void ksz_rcv_timestamp(struct sk_buff *skb, u8 *tag,
  */
 static void ksz_xmit_timestamp(struct dsa_port *dp, struct sk_buff *skb)
 {
+	struct sk_buff *clone = KSZ_SKB_CB(skb)->clone;
 	struct ksz_tagger_private *priv;
+	struct ptp_header *ptp_hdr;
+	unsigned int ptp_type;
+	u32 tstamp_raw = 0;
+	u8 ptp_msg_type;
+	s64 correction;
 
 	priv = ksz_tagger_private(dp->ds);
 
 	if (!test_bit(KSZ_HWTS_EN, &priv->state))
 		return;
 
-	put_unaligned_be32(0, skb_put(skb, KSZ_PTP_TAG_LEN));
+	if (!clone)
+		goto output_tag;
+
+	ptp_type = KSZ_SKB_CB(clone)->ptp_type;
+	if (ptp_type == PTP_CLASS_NONE)
+		goto output_tag;
+
+	ptp_hdr = ptp_parse_header(skb, ptp_type);
+	if (!ptp_hdr)
+		goto output_tag;
+
+	ptp_msg_type = KSZ_SKB_CB(clone)->ptp_msg_type;
+	if (ptp_msg_type != PTP_MSGTYPE_PDELAY_RESP)
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

