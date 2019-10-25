Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 388DBE4EFC
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 16:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407605AbfJYO0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 10:26:15 -0400
Received: from smtp3-1.goneo.de ([85.220.129.38]:38497 "EHLO smtp3-1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406662AbfJYO0O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 10:26:14 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp3.goneo.de (Postfix) with ESMTP id 89E0B23EFDE;
        Fri, 25 Oct 2019 16:26:10 +0200 (CEST)
X-Virus-Scanned: by goneo
X-Spam-Flag: NO
X-Spam-Score: -3.006
X-Spam-Level: 
X-Spam-Status: No, score=-3.006 tagged_above=-999 tests=[ALL_TRUSTED=-1,
        AWL=-0.106, BAYES_00=-1.9] autolearn=ham
Received: from smtp3.goneo.de ([127.0.0.1])
        by localhost (smtp3.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 142ff0j-5fBw; Fri, 25 Oct 2019 16:26:08 +0200 (CEST)
Received: from lem-wkst-02.lemonage.de. (hq.lemonage.de [87.138.178.34])
        by smtp3.goneo.de (Postfix) with ESMTPA id 68B00240028;
        Fri, 25 Oct 2019 16:26:08 +0200 (CEST)
From:   Lars Poeschel <poeschel@lemonage.de>
To:     Lars Poeschel <poeschel@lemonage.de>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        netdev@vger.kernel.org (open list:NFC SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Cc:     Johan Hovold <johan@kernel.org>, David Miller <davem@davemloft.net>
Subject: [PATCH v10 6/7] nfc: pn533: Add autopoll capability
Date:   Fri, 25 Oct 2019 16:25:20 +0200
Message-Id: <20191025142521.22695-7-poeschel@lemonage.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191025142521.22695-1-poeschel@lemonage.de>
References: <20191025142521.22695-1-poeschel@lemonage.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pn532 devices support an autopoll command, that lets the chip
automatically poll for selected nfc technologies instead of manually
looping through every single nfc technology the user is interested in.
This is faster and less cpu and bus intensive than manually polling.
This adds this autopoll capability to the pn533 driver.

Cc: Johan Hovold <johan@kernel.org>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
Changes in v10:
- Rebased the patch series on net-next 'Commit 503a64635d5e ("Merge
  branch 'DPAA-Ethernet-changes'")'

Changes in v9:
- Rebased the patch series on v5.4-rc2

Changes in v8:
- Reverse christmas tree order for local variables in
  pn533_autopoll_complete and pn533_start_poll

Changes in v7:
- Remove __packed attribute at struct pn532_autopoll_resp
- Add missing '\n' at the end of dev_dbg and nfc_err strings

Changes in v6:
- Rebased the patch series on v5.3-rc5

 drivers/nfc/pn533/pn533.c | 193 +++++++++++++++++++++++++++++++++++++-
 drivers/nfc/pn533/pn533.h |  10 +-
 2 files changed, 197 insertions(+), 6 deletions(-)

diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index e185dc5f12b9..aa766e7ece70 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -185,6 +185,32 @@ struct pn533_cmd_jump_dep_response {
 	u8 gt[];
 } __packed;
 
+struct pn532_autopoll_resp {
+	u8 type;
+	u8 ln;
+	u8 tg;
+	u8 tgdata[];
+};
+
+/* PN532_CMD_IN_AUTOPOLL */
+#define PN532_AUTOPOLL_POLLNR_INFINITE	0xff
+#define PN532_AUTOPOLL_PERIOD		0x03 /* in units of 150 ms */
+
+#define PN532_AUTOPOLL_TYPE_GENERIC_106		0x00
+#define PN532_AUTOPOLL_TYPE_GENERIC_212		0x01
+#define PN532_AUTOPOLL_TYPE_GENERIC_424		0x02
+#define PN532_AUTOPOLL_TYPE_JEWEL		0x04
+#define PN532_AUTOPOLL_TYPE_MIFARE		0x10
+#define PN532_AUTOPOLL_TYPE_FELICA212		0x11
+#define PN532_AUTOPOLL_TYPE_FELICA424		0x12
+#define PN532_AUTOPOLL_TYPE_ISOA		0x20
+#define PN532_AUTOPOLL_TYPE_ISOB		0x23
+#define PN532_AUTOPOLL_TYPE_DEP_PASSIVE_106	0x40
+#define PN532_AUTOPOLL_TYPE_DEP_PASSIVE_212	0x41
+#define PN532_AUTOPOLL_TYPE_DEP_PASSIVE_424	0x42
+#define PN532_AUTOPOLL_TYPE_DEP_ACTIVE_106	0x80
+#define PN532_AUTOPOLL_TYPE_DEP_ACTIVE_212	0x81
+#define PN532_AUTOPOLL_TYPE_DEP_ACTIVE_424	0x82
 
 /* PN533_TG_INIT_AS_TARGET */
 #define PN533_INIT_TARGET_PASSIVE 0x1
@@ -1389,6 +1415,101 @@ static int pn533_poll_dep(struct nfc_dev *nfc_dev)
 	return rc;
 }
 
+static int pn533_autopoll_complete(struct pn533 *dev, void *arg,
+			       struct sk_buff *resp)
+{
+	struct pn532_autopoll_resp *apr;
+	struct nfc_target nfc_tgt;
+	u8 nbtg;
+	int rc;
+
+	if (IS_ERR(resp)) {
+		rc = PTR_ERR(resp);
+
+		nfc_err(dev->dev, "%s  autopoll complete error %d\n",
+			__func__, rc);
+
+		if (rc == -ENOENT) {
+			if (dev->poll_mod_count != 0)
+				return rc;
+			goto stop_poll;
+		} else if (rc < 0) {
+			nfc_err(dev->dev,
+				"Error %d when running autopoll\n", rc);
+			goto stop_poll;
+		}
+	}
+
+	nbtg = resp->data[0];
+	if ((nbtg > 2) || (nbtg <= 0))
+		return -EAGAIN;
+
+	apr = (struct pn532_autopoll_resp *)&resp->data[1];
+	while (nbtg--) {
+		memset(&nfc_tgt, 0, sizeof(struct nfc_target));
+		switch (apr->type) {
+		case PN532_AUTOPOLL_TYPE_ISOA:
+			dev_dbg(dev->dev, "ISOA\n");
+			rc = pn533_target_found_type_a(&nfc_tgt, apr->tgdata,
+						       apr->ln - 1);
+			break;
+		case PN532_AUTOPOLL_TYPE_FELICA212:
+		case PN532_AUTOPOLL_TYPE_FELICA424:
+			dev_dbg(dev->dev, "FELICA\n");
+			rc = pn533_target_found_felica(&nfc_tgt, apr->tgdata,
+						       apr->ln - 1);
+			break;
+		case PN532_AUTOPOLL_TYPE_JEWEL:
+			dev_dbg(dev->dev, "JEWEL\n");
+			rc = pn533_target_found_jewel(&nfc_tgt, apr->tgdata,
+						      apr->ln - 1);
+			break;
+		case PN532_AUTOPOLL_TYPE_ISOB:
+			dev_dbg(dev->dev, "ISOB\n");
+			rc = pn533_target_found_type_b(&nfc_tgt, apr->tgdata,
+						       apr->ln - 1);
+			break;
+		case PN532_AUTOPOLL_TYPE_MIFARE:
+			dev_dbg(dev->dev, "Mifare\n");
+			rc = pn533_target_found_type_a(&nfc_tgt, apr->tgdata,
+						       apr->ln - 1);
+			break;
+		default:
+			nfc_err(dev->dev,
+				    "Unknown current poll modulation\n");
+			rc = -EPROTO;
+		}
+
+		if (rc)
+			goto done;
+
+		if (!(nfc_tgt.supported_protocols & dev->poll_protocols)) {
+			nfc_err(dev->dev,
+				    "The Tg found doesn't have the desired protocol\n");
+			rc = -EAGAIN;
+			goto done;
+		}
+
+		dev->tgt_available_prots = nfc_tgt.supported_protocols;
+		apr = (struct pn532_autopoll_resp *)
+			(apr->tgdata + (apr->ln - 1));
+	}
+
+	pn533_poll_reset_mod_list(dev);
+	nfc_targets_found(dev->nfc_dev, &nfc_tgt, 1);
+
+done:
+	dev_kfree_skb(resp);
+	return rc;
+
+stop_poll:
+	nfc_err(dev->dev, "autopoll operation has been stopped\n");
+
+	pn533_poll_reset_mod_list(dev);
+	dev->poll_protocols = 0;
+	return rc;
+}
+
 static int pn533_poll_complete(struct pn533 *dev, void *arg,
 			       struct sk_buff *resp)
 {
@@ -1532,6 +1653,7 @@ static int pn533_start_poll(struct nfc_dev *nfc_dev,
 {
 	struct pn533 *dev = nfc_get_drvdata(nfc_dev);
 	struct pn533_poll_modulations *cur_mod;
+	struct sk_buff *skb;
 	u8 rand_mod;
 	int rc;
 
@@ -1557,9 +1679,73 @@ static int pn533_start_poll(struct nfc_dev *nfc_dev,
 			tm_protocols = 0;
 	}
 
-	pn533_poll_create_mod_list(dev, im_protocols, tm_protocols);
 	dev->poll_protocols = im_protocols;
 	dev->listen_protocols = tm_protocols;
+	if (dev->device_type == PN533_DEVICE_PN532_AUTOPOLL) {
+		skb = pn533_alloc_skb(dev, 4 + 6);
+		if (!skb)
+			return -ENOMEM;
+
+		*((u8 *)skb_put(skb, sizeof(u8))) =
+			PN532_AUTOPOLL_POLLNR_INFINITE;
+		*((u8 *)skb_put(skb, sizeof(u8))) = PN532_AUTOPOLL_PERIOD;
+
+		if ((im_protocols & NFC_PROTO_MIFARE_MASK) &&
+				(im_protocols & NFC_PROTO_ISO14443_MASK) &&
+				(im_protocols & NFC_PROTO_NFC_DEP_MASK))
+			*((u8 *)skb_put(skb, sizeof(u8))) =
+				PN532_AUTOPOLL_TYPE_GENERIC_106;
+		else {
+			if (im_protocols & NFC_PROTO_MIFARE_MASK)
+				*((u8 *)skb_put(skb, sizeof(u8))) =
+					PN532_AUTOPOLL_TYPE_MIFARE;
+
+			if (im_protocols & NFC_PROTO_ISO14443_MASK)
+				*((u8 *)skb_put(skb, sizeof(u8))) =
+					PN532_AUTOPOLL_TYPE_ISOA;
+
+			if (im_protocols & NFC_PROTO_NFC_DEP_MASK) {
+				*((u8 *)skb_put(skb, sizeof(u8))) =
+					PN532_AUTOPOLL_TYPE_DEP_PASSIVE_106;
+				*((u8 *)skb_put(skb, sizeof(u8))) =
+					PN532_AUTOPOLL_TYPE_DEP_PASSIVE_212;
+				*((u8 *)skb_put(skb, sizeof(u8))) =
+					PN532_AUTOPOLL_TYPE_DEP_PASSIVE_424;
+			}
+		}
+
+		if (im_protocols & NFC_PROTO_FELICA_MASK ||
+				im_protocols & NFC_PROTO_NFC_DEP_MASK) {
+			*((u8 *)skb_put(skb, sizeof(u8))) =
+				PN532_AUTOPOLL_TYPE_FELICA212;
+			*((u8 *)skb_put(skb, sizeof(u8))) =
+				PN532_AUTOPOLL_TYPE_FELICA424;
+		}
+
+		if (im_protocols & NFC_PROTO_JEWEL_MASK)
+			*((u8 *)skb_put(skb, sizeof(u8))) =
+				PN532_AUTOPOLL_TYPE_JEWEL;
+
+		if (im_protocols & NFC_PROTO_ISO14443_B_MASK)
+			*((u8 *)skb_put(skb, sizeof(u8))) =
+				PN532_AUTOPOLL_TYPE_ISOB;
+
+		if (tm_protocols)
+			*((u8 *)skb_put(skb, sizeof(u8))) =
+				PN532_AUTOPOLL_TYPE_DEP_ACTIVE_106;
+
+		rc = pn533_send_cmd_async(dev, PN533_CMD_IN_AUTOPOLL, skb,
+				pn533_autopoll_complete, NULL);
+
+		if (rc < 0)
+			dev_kfree_skb(skb);
+		else
+			dev->poll_mod_count++;
+
+		return rc;
+	}
+
+	pn533_poll_create_mod_list(dev, im_protocols, tm_protocols);
 
 	/* Do not always start polling from the same modulation */
 	get_random_bytes(&rand_mod, sizeof(rand_mod));
@@ -2461,7 +2647,8 @@ static int pn533_dev_up(struct nfc_dev *nfc_dev)
 	if (dev->phy_ops->dev_up)
 		dev->phy_ops->dev_up(dev);
 
-	if (dev->device_type == PN533_DEVICE_PN532) {
+	if ((dev->device_type == PN533_DEVICE_PN532) ||
+		(dev->device_type == PN533_DEVICE_PN532_AUTOPOLL)) {
 		int rc = pn532_sam_configuration(nfc_dev);
 
 		if (rc)
@@ -2508,6 +2695,7 @@ static int pn533_setup(struct pn533 *dev)
 	case PN533_DEVICE_PASORI:
 	case PN533_DEVICE_ACR122U:
 	case PN533_DEVICE_PN532:
+	case PN533_DEVICE_PN532_AUTOPOLL:
 		max_retries.mx_rty_atr = 0x2;
 		max_retries.mx_rty_psl = 0x1;
 		max_retries.mx_rty_passive_act =
@@ -2544,6 +2732,7 @@ static int pn533_setup(struct pn533 *dev)
 	switch (dev->device_type) {
 	case PN533_DEVICE_STD:
 	case PN533_DEVICE_PN532:
+	case PN533_DEVICE_PN532_AUTOPOLL:
 		break;
 
 	case PN533_DEVICE_PASORI:
diff --git a/drivers/nfc/pn533/pn533.h b/drivers/nfc/pn533/pn533.h
index 47d4a6bf9420..b66f02a53167 100644
--- a/drivers/nfc/pn533/pn533.h
+++ b/drivers/nfc/pn533/pn533.h
@@ -6,10 +6,11 @@
  * Copyright (C) 2012-2013 Tieto Poland
  */
 
-#define PN533_DEVICE_STD     0x1
-#define PN533_DEVICE_PASORI  0x2
-#define PN533_DEVICE_ACR122U 0x3
-#define PN533_DEVICE_PN532   0x4
+#define PN533_DEVICE_STD		0x1
+#define PN533_DEVICE_PASORI		0x2
+#define PN533_DEVICE_ACR122U		0x3
+#define PN533_DEVICE_PN532		0x4
+#define PN533_DEVICE_PN532_AUTOPOLL	0x5
 
 #define PN533_ALL_PROTOCOLS (NFC_PROTO_JEWEL_MASK | NFC_PROTO_MIFARE_MASK |\
 			     NFC_PROTO_FELICA_MASK | NFC_PROTO_ISO14443_MASK |\
@@ -75,6 +76,7 @@
 #define PN533_CMD_IN_ATR 0x50
 #define PN533_CMD_IN_RELEASE 0x52
 #define PN533_CMD_IN_JUMP_FOR_DEP 0x56
+#define PN533_CMD_IN_AUTOPOLL 0x60
 
 #define PN533_CMD_TG_INIT_AS_TARGET 0x8c
 #define PN533_CMD_TG_GET_DATA 0x86
-- 
2.23.0

