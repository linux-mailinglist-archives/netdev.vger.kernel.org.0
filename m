Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFAF126CAE5
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 22:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbgIPUR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 16:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728185AbgIPUQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 16:16:46 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26412C06121C
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 13:16:21 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id t4so5400872qvr.21
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 13:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=JEGDhDy0i0NXGVogNpEKp6N3BhWlDVgJ1Ss+eXstDS8=;
        b=Cr0pbVi/P8EJnHlXGCs6MoDzp6ikdg7g9weO0ajM9wg7h12zQtMVqRq8k4pOdQKwTb
         7ftjslmmczWg8PBJagPtJ9YFKljqpRsM/Tq1mE0S7ct3bVlz2yJFplk3yr1yt2MbLFFh
         48LtzIoHhTwfi9ZiDpbVked8e3L3fgkLP16LEULNLeCWqntrU0QbcLmJ/8a2u80xwM7j
         6Dl/BYP5x0SzYNssjpzXI2IYFxcpiU/0FpYQ2LpioIDHCS+c+uLkt/PduxRB6VWXF3so
         tpgSjCtFtmdz6ASPmJDX7nJNQGHGMqzE8n1J4lx33fvDS14475vkP83oGOYh/th9RkjT
         03MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JEGDhDy0i0NXGVogNpEKp6N3BhWlDVgJ1Ss+eXstDS8=;
        b=lptvsl18Rn3G1woMbzyIh8eDdHIdpe90WUlsf4xU5lkGdD6rBYGG4za5k9QX0gWeiw
         yEJWPWdBZENMcNldWBHXm/GJsZY1U/yZkekzQolC738osECHmaHuIAfI7v/KKspfnjdK
         qrnP+fw/Om+EvfcnBFqX+GESF31G2g0aaVTatbzx+csYAvqgOCUIzFRS6jC/BOgxg4n0
         FqsTtB6exS5VCpC0qWmb81OrNUfRme07ubX9wTYamicmj0p+xJFTBcKd8qCHr69AS6V9
         XZXK+AffU6AD07ot34dOFi9wMZy4rooBKuQ+OmyW1uAXM1joTlWz2bBHCGqj7iFWYtSq
         Hazg==
X-Gm-Message-State: AOAM532BWhD/Y2Mk80m5h7jtBNNdL4VUiuZYDHUEEnzF2hmN5O+Gh3DQ
        wiTy3YAH8p6oJiROcPKcCBy04heL8s1sAqnvjvRP
X-Google-Smtp-Source: ABdhPJwRasF3+ybFhcwR2eBIZaGWRgKaYBBuDmJGK4uF+WJlagHiIvooM9IhAqq257N5hWKnFmDtqegPm4TTFBubAGKI
X-Received: from danielwinkler-linux.mtv.corp.google.com ([2620:15c:202:201:f693:9fff:fef4:4e59])
 (user=danielwinkler job=sendgmr) by 2002:ad4:58aa:: with SMTP id
 ea10mr8827403qvb.58.1600287380260; Wed, 16 Sep 2020 13:16:20 -0700 (PDT)
Date:   Wed, 16 Sep 2020 13:16:01 -0700
In-Reply-To: <20200916201602.1223002-1-danielwinkler@google.com>
Message-Id: <20200916131430.5.Ibedcb7af24f1c01a680de4cc8cc5a98951588393@changeid>
Mime-Version: 1.0
References: <20200916201602.1223002-1-danielwinkler@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH 5/6] Bluetooth: Query LE tx power on startup
From:   Daniel Winkler <danielwinkler@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Daniel Winkler <danielwinkler@google.com>,
        Sonny Sasaka <sonnysasaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Queries tx power via HCI_LE_Read_Transmit_Power command when the hci
device is initialized, and stores resulting min/max LE power in hdev
struct. If command isn't available (< BT5 support), min/max values
both default to HCI_TX_POWER_INVALID.

This patch is manually verified by ensuring BT5 devices correctly query
and receive controller tx power range.

Reviewed-by: Sonny Sasaka <sonnysasaka@chromium.org>
Signed-off-by: Daniel Winkler <danielwinkler@google.com>
---

 include/net/bluetooth/hci.h      |  7 +++++++
 include/net/bluetooth/hci_core.h |  2 ++
 net/bluetooth/hci_core.c         |  8 ++++++++
 net/bluetooth/hci_event.c        | 18 ++++++++++++++++++
 4 files changed, 35 insertions(+)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index c8e67042a3b14c..c1504aa3d9cfd5 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -1797,6 +1797,13 @@ struct hci_cp_le_set_adv_set_rand_addr {
 	bdaddr_t  bdaddr;
 } __packed;
 
+#define HCI_OP_LE_READ_TRANSMIT_POWER	0x204b
+struct hci_rp_le_read_transmit_power {
+	__u8  status;
+	__s8  min_le_tx_power;
+	__s8  max_le_tx_power;
+} __packed;
+
 #define HCI_OP_LE_READ_BUFFER_SIZE_V2	0x2060
 struct hci_rp_le_read_buffer_size_v2 {
 	__u8    status;
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 667b9d37099dec..c1f5b5c4109215 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -381,6 +381,8 @@ struct hci_dev {
 	__u16		def_page_timeout;
 	__u16		def_multi_adv_rotation_duration;
 	__u16		def_le_autoconnect_timeout;
+	__s8		min_le_tx_power;
+	__s8		max_le_tx_power;
 
 	__u16		pkt_type;
 	__u16		esco_type;
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 3a2332f4a9bba2..6bff1c09be3b42 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -741,6 +741,12 @@ static int hci_init3_req(struct hci_request *req, unsigned long opt)
 			hci_req_add(req, HCI_OP_LE_READ_ADV_TX_POWER, 0, NULL);
 		}
 
+		if (hdev->commands[38] & 0x80) {
+			/* Read LE Min/Max Tx Power*/
+			hci_req_add(req, HCI_OP_LE_READ_TRANSMIT_POWER,
+				    0, NULL);
+		}
+
 		if (hdev->commands[26] & 0x40) {
 			/* Read LE White List Size */
 			hci_req_add(req, HCI_OP_LE_READ_WHITE_LIST_SIZE,
@@ -3654,6 +3660,8 @@ struct hci_dev *hci_alloc_dev(void)
 	hdev->le_num_of_adv_sets = HCI_MAX_ADV_INSTANCES;
 	hdev->def_multi_adv_rotation_duration = HCI_DEFAULT_ADV_DURATION;
 	hdev->def_le_autoconnect_timeout = HCI_LE_AUTOCONN_TIMEOUT;
+	hdev->min_le_tx_power = HCI_TX_POWER_INVALID;
+	hdev->max_le_tx_power = HCI_TX_POWER_INVALID;
 
 	hdev->rpa_timeout = HCI_DEFAULT_RPA_TIMEOUT;
 	hdev->discov_interleaved_timeout = DISCOV_INTERLEAVED_TIMEOUT;
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 9a24fd99d9e08e..beb35680f3a83a 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1202,6 +1202,20 @@ static void hci_cc_le_set_adv_set_random_addr(struct hci_dev *hdev,
 	hci_dev_unlock(hdev);
 }
 
+static void hci_cc_le_read_transmit_power(struct hci_dev *hdev,
+					  struct sk_buff *skb)
+{
+	struct hci_rp_le_read_transmit_power *rp = (void *)skb->data;
+
+	BT_DBG("%s status 0x%2.2x", hdev->name, rp->status);
+
+	if (rp->status)
+		return;
+
+	hdev->min_le_tx_power = rp->min_le_tx_power;
+	hdev->max_le_tx_power = rp->max_le_tx_power;
+}
+
 static void hci_cc_le_set_adv_enable(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	__u8 *sent, status = *((__u8 *) skb->data);
@@ -3577,6 +3591,10 @@ static void hci_cmd_complete_evt(struct hci_dev *hdev, struct sk_buff *skb,
 		hci_cc_le_set_adv_set_random_addr(hdev, skb);
 		break;
 
+	case HCI_OP_LE_READ_TRANSMIT_POWER:
+		hci_cc_le_read_transmit_power(hdev, skb);
+		break;
+
 	default:
 		BT_DBG("%s opcode 0x%4.4x", hdev->name, *opcode);
 		break;
-- 
2.28.0.618.gf4bc123cb7-goog

