Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3B0306727
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 23:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237137AbhA0WUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 17:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236441AbhA0WTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 17:19:44 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7BDC06174A
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 14:19:04 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id f127so3708132ybf.12
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 14:19:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=n659vTkbVZagxuC1KCd65CsCxB1C/4ji4FFXQhlT6SM=;
        b=Ee/E+KLVmMv42Eck8UyUBf3Cal3qGAoGtLEzzIia+55jGeCLo4X6MVPS1sYmXLt0m/
         DUepJxRm1Fw+0ace8HUNMrdb5UF8p4Lvgy4D02gN3X1w8gfka2xDuJvWXKuX6Dt3i/IG
         spyAuYNpS+kx2w18LBa0YGfT/Hb5fF4sABb6n4Lr9TtkLb5hKeNSCg4COZfaZrNDoj3x
         BxGBGnv13HwjtPs3mudItZGszjNYMfrTi1nczPJKbyjlSXfawlUWsEtjjfm2x7RG/+Kg
         xWGi3u2dJ5Pge2uZWvCThjKDXU3bwBR6+CWX2z90USCSrrFOj2/qN1HbhfoeRG+78GGG
         OQdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=n659vTkbVZagxuC1KCd65CsCxB1C/4ji4FFXQhlT6SM=;
        b=VolG/Su7abj7vrWaQxVdE2ySq1USpA1Zhzw8/ljdbbNJT15ZXLQTBhFqOoe5rROYla
         gWo6sO7Md03xErqv16edEaPWxyCecoyNNaZoU4yAeoGeGQiQNEvmxadMHO6vS0XUxqGd
         uHd5vKFl2NzJhQkrW3882X/Aj9Mm7w3Sm6jRCYj8ykG7waZumvCFM94r/RAkKnz/cZ7L
         nd3AwV2VJ9G4Aag9nbx5c9NMm60gxl0bwDjZ+U0KDuoOnCVPHT5mIWb74UlDaKdNLODq
         NwH4QBjEfOcEh/1AgHEZu7F4orNTXQ2Wf1vug4Tye2vsOW2N8mcCrcCJMSp5mXoaqO6U
         nLXw==
X-Gm-Message-State: AOAM532W2kqaBzwRyheIYtzqz1TU0flRfJTEw30pHTdGDTcbLYE4VR1v
        aosanphwm/FBOLVSBRiowPwzLK4WJT4y
X-Google-Smtp-Source: ABdhPJwbc2mNRHnTGIC2C/qfPGnRVPnVIfldELiXxeQJQ0EGLrHwn0IsWcwcfUl6QC22s6NXREoWPpXh/JgB
Sender: "yudiliu via sendgmr" <yudiliu@yudiliu.mtv.corp.google.com>
X-Received: from yudiliu.mtv.corp.google.com ([2620:15c:202:201:8edc:d4ff:fe53:2823])
 (user=yudiliu job=sendgmr) by 2002:a25:a527:: with SMTP id
 h36mr19236482ybi.400.1611785943188; Wed, 27 Jan 2021 14:19:03 -0800 (PST)
Date:   Wed, 27 Jan 2021 14:18:59 -0800
Message-Id: <20210127141821.v2.1.I7d3819e3c406b20307a56fe96159e8f842f72d89@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH v2] Bluetooth: Skip eSCO 2M params when not supported
From:   Yu Liu <yudiliu@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        chromeos-bluetooth-upstreaming@chromium.org
Cc:     Yu Liu <yudiliu@google.com>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a peer device doesn't support eSCO 2M we should skip the params that
use it when setting up sync connection since they will always fail.

Signed-off-by: Yu Liu <yudiliu@google.com>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
---

Changes in v2:
- Fix title

Changes in v1:
- Initial change

 include/net/bluetooth/hci_core.h |  1 +
 net/bluetooth/hci_conn.c         | 39 +++++++++++++++++++++++---------
 2 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 239ab72f16c6e..71468a9ea798a 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1237,6 +1237,7 @@ void hci_conn_del_sysfs(struct hci_conn *conn);
 #define lmp_le_capable(dev)        ((dev)->features[0][4] & LMP_LE)
 #define lmp_sniffsubr_capable(dev) ((dev)->features[0][5] & LMP_SNIFF_SUBR)
 #define lmp_pause_enc_capable(dev) ((dev)->features[0][5] & LMP_PAUSE_ENC)
+#define lmp_esco_2m_capable(dev)   ((dev)->features[0][5] & LMP_EDR_ESCO_2M)
 #define lmp_ext_inq_capable(dev)   ((dev)->features[0][6] & LMP_EXT_INQ)
 #define lmp_le_br_capable(dev)     (!!((dev)->features[0][6] & LMP_SIMUL_LE_BR))
 #define lmp_ssp_capable(dev)       ((dev)->features[0][6] & LMP_SIMPLE_PAIR)
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 07c34c55fc508..18740af603963 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -39,24 +39,25 @@ struct sco_param {
 	u16 pkt_type;
 	u16 max_latency;
 	u8  retrans_effort;
+	bool cap_2m_reqd;
 };
 
 static const struct sco_param esco_param_cvsd[] = {
-	{ EDR_ESCO_MASK & ~ESCO_2EV3, 0x000a,	0x01 }, /* S3 */
-	{ EDR_ESCO_MASK & ~ESCO_2EV3, 0x0007,	0x01 }, /* S2 */
-	{ EDR_ESCO_MASK | ESCO_EV3,   0x0007,	0x01 }, /* S1 */
-	{ EDR_ESCO_MASK | ESCO_HV3,   0xffff,	0x01 }, /* D1 */
-	{ EDR_ESCO_MASK | ESCO_HV1,   0xffff,	0x01 }, /* D0 */
+	{ EDR_ESCO_MASK & ~ESCO_2EV3, 0x000a,	0x01,   true  }, /* S3 */
+	{ EDR_ESCO_MASK & ~ESCO_2EV3, 0x0007,	0x01,   true  }, /* S2 */
+	{ EDR_ESCO_MASK | ESCO_EV3,   0x0007,	0x01,   false }, /* S1 */
+	{ EDR_ESCO_MASK | ESCO_HV3,   0xffff,	0x01,   false }, /* D1 */
+	{ EDR_ESCO_MASK | ESCO_HV1,   0xffff,	0x01,   false }, /* D0 */
 };
 
 static const struct sco_param sco_param_cvsd[] = {
-	{ EDR_ESCO_MASK | ESCO_HV3,   0xffff,	0xff }, /* D1 */
-	{ EDR_ESCO_MASK | ESCO_HV1,   0xffff,	0xff }, /* D0 */
+	{ EDR_ESCO_MASK | ESCO_HV3,   0xffff,	0xff,   false }, /* D1 */
+	{ EDR_ESCO_MASK | ESCO_HV1,   0xffff,	0xff,   false }, /* D0 */
 };
 
 static const struct sco_param esco_param_msbc[] = {
-	{ EDR_ESCO_MASK & ~ESCO_2EV3, 0x000d,	0x02 }, /* T2 */
-	{ EDR_ESCO_MASK | ESCO_EV3,   0x0008,	0x02 }, /* T1 */
+	{ EDR_ESCO_MASK & ~ESCO_2EV3, 0x000d,	0x02,   true  }, /* T2 */
+	{ EDR_ESCO_MASK | ESCO_EV3,   0x0008,	0x02,   false }, /* T1 */
 };
 
 /* This function requires the caller holds hdev->lock */
@@ -278,6 +279,20 @@ static void hci_add_sco(struct hci_conn *conn, __u16 handle)
 	hci_send_cmd(hdev, HCI_OP_ADD_SCO, sizeof(cp), &cp);
 }
 
+static bool find_next_esco_param(struct hci_conn *conn,
+				 const struct sco_param *esco_param, int size)
+{
+	for (; conn->attempt <= size; conn->attempt++) {
+		if (lmp_esco_2m_capable(conn->link) ||
+		    !esco_param[conn->attempt - 1].cap_2m_reqd)
+			break;
+		BT_DBG("hcon %p skipped attempt %d, eSCO 2M not supported",
+		       conn, conn->attempt);
+	}
+
+	return conn->attempt <= size;
+}
+
 bool hci_setup_sync(struct hci_conn *conn, __u16 handle)
 {
 	struct hci_dev *hdev = conn->hdev;
@@ -299,13 +314,15 @@ bool hci_setup_sync(struct hci_conn *conn, __u16 handle)
 
 	switch (conn->setting & SCO_AIRMODE_MASK) {
 	case SCO_AIRMODE_TRANSP:
-		if (conn->attempt > ARRAY_SIZE(esco_param_msbc))
+		if (!find_next_esco_param(conn, esco_param_msbc,
+					  ARRAY_SIZE(esco_param_msbc)))
 			return false;
 		param = &esco_param_msbc[conn->attempt - 1];
 		break;
 	case SCO_AIRMODE_CVSD:
 		if (lmp_esco_capable(conn->link)) {
-			if (conn->attempt > ARRAY_SIZE(esco_param_cvsd))
+			if (!find_next_esco_param(conn, esco_param_cvsd,
+						  ARRAY_SIZE(esco_param_cvsd)))
 				return false;
 			param = &esco_param_cvsd[conn->attempt - 1];
 		} else {
-- 
2.30.0.280.ga3ce27912f-goog

