Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7CB34E6B5
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 13:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232122AbhC3LrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 07:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbhC3Lqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 07:46:38 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC251C0613D8
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 04:46:37 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lRCpQ-0006GC-G8
        for netdev@vger.kernel.org; Tue, 30 Mar 2021 13:46:36 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id E7274603E85
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 11:46:20 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 10BCC603E12;
        Tue, 30 Mar 2021 11:46:09 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id a153314c;
        Tue, 30 Mar 2021 11:46:01 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Torin Cooper-Bennun <torin@maxiluxsystems.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 18/39] can: m_can: add infrastructure for internal timestamps
Date:   Tue, 30 Mar 2021 13:45:38 +0200
Message-Id: <20210330114559.1114855-19-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330114559.1114855-1-mkl@pengutronix.de>
References: <20210330114559.1114855-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Torin Cooper-Bennun <torin@maxiluxsystems.com>

Add infrastucture to allow internal timestamps from the M_CAN to be
configured and retrieved.

Link: https://lore.kernel.org/r/20210308102427.63916-2-torin@maxiluxsystems.com
Signed-off-by: Torin Cooper-Bennun <torin@maxiluxsystems.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 12a75ebe9ce1..9f7cfe91f7ff 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -8,6 +8,7 @@
  * https://github.com/linux-can/can-doc/tree/master/m_can
  */
 
+#include <linux/bitfield.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
@@ -148,6 +149,16 @@ enum m_can_reg {
 #define NBTP_NTSEG2_SHIFT	0
 #define NBTP_NTSEG2_MASK	(0x7f << NBTP_NTSEG2_SHIFT)
 
+/* Timestamp Counter Configuration Register (TSCC) */
+#define TSCC_TCP_MASK		GENMASK(19, 16)
+#define TSCC_TSS_MASK		GENMASK(1, 0)
+#define TSCC_TSS_DISABLE	0x0
+#define TSCC_TSS_INTERNAL	0x1
+#define TSCC_TSS_EXTERNAL	0x2
+
+/* Timestamp Counter Value Register (TSCV) */
+#define TSCV_TSC_MASK		GENMASK(15, 0)
+
 /* Error Counter Register(ECR) */
 #define ECR_RP			BIT(15)
 #define ECR_REC_SHIFT		8
@@ -302,6 +313,7 @@ enum m_can_reg {
 #define RX_BUF_ANMF		BIT(31)
 #define RX_BUF_FDF		BIT(21)
 #define RX_BUF_BRS		BIT(20)
+#define RX_BUF_RXTS_MASK	GENMASK(15, 0)
 
 /* Tx Buffer Element */
 /* T0 */
@@ -319,6 +331,7 @@ enum m_can_reg {
 /* E1 */
 #define TX_EVENT_MM_SHIFT	TX_BUF_MM_SHIFT
 #define TX_EVENT_MM_MASK	(0xff << TX_EVENT_MM_SHIFT)
+#define TX_EVENT_TXTS_MASK	GENMASK(15, 0)
 
 static inline u32 m_can_read(struct m_can_classdev *cdev, enum m_can_reg reg)
 {
@@ -413,6 +426,20 @@ static inline void m_can_disable_all_interrupts(struct m_can_classdev *cdev)
 	m_can_write(cdev, M_CAN_ILE, 0x0);
 }
 
+/* Retrieve internal timestamp counter from TSCV.TSC, and shift it to 32-bit
+ * width.
+ */
+static u32 m_can_get_timestamp(struct m_can_classdev *cdev)
+{
+	u32 tscv;
+	u32 tsc;
+
+	tscv = m_can_read(cdev, M_CAN_TSCV);
+	tsc = FIELD_GET(TSCV_TSC_MASK, tscv);
+
+	return (tsc << 16);
+}
+
 static void m_can_clean(struct net_device *net)
 {
 	struct m_can_classdev *cdev = netdev_priv(net);
-- 
2.30.2


