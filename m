Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E9F3271F2
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 11:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbhB1Ku2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 05:50:28 -0500
Received: from smtp-17-i2.italiaonline.it ([213.209.12.17]:51385 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230494AbhB1Kj6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Feb 2021 05:39:58 -0500
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([87.20.116.197])
        by smtp-17.iol.local with ESMTPA
        id GJTalhz13lChfGJTllvZV4; Sun, 28 Feb 2021 11:39:13 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614508753; bh=DAcsIcI1qqpEQyjajSihDV+gP9Q8Oe+cpX5SqQxGkZI=;
        h=From;
        b=Qe00kSCrmEyC7cQBaoubWCHyqqCEKq5KVHyx/HpoMyfs4gQKKnS/Nph72fE1P21yu
         +X513RVVQlTQbtVSuWn2xOWZpdJ3gCVnqjPfCC2E539q2CCbotZg2XMHm5xmmZlH4Q
         KCvDpbu1XC28TYDbhQ05kHPfnvIzTQq4U/e0mhmaD3hRmMr6OoqWxYHPgN1f4KxqRr
         aUo3nkIvUixy5NdPxHZ7XfWt4xYzy7kx22FwQqjhnQnM7OmSXY9TACbHcXhkzXJoQd
         CeLRy08YZr4FsfbJ1EkyJBDrNyKBX69/FfYqwlWQ2IykwXaD4vsrtIuQadj/ezgXRa
         bgtwnkZDK7Z8A==
X-CNFS-Analysis: v=2.4 cv=S6McfKgP c=1 sm=1 tr=0 ts=603b72d1 cx=a_exe
 a=AVqmXbCQpuNSdJmApS5GbQ==:117 a=AVqmXbCQpuNSdJmApS5GbQ==:17
 a=FEz_7PL0ERQs5GQP_jQA:9 a=oxaoH9BcOFauOGrG:21 a=Asb3xwQKlx4a7rY6:21
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Federico Vaga <federico.vaga@gmail.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v3 6/6] can: c_can: add support to 64 message objects
Date:   Sun, 28 Feb 2021 11:38:55 +0100
Message-Id: <20210228103856.4089-7-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210228103856.4089-1-dariobin@libero.it>
References: <20210228103856.4089-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfMtgfoD11GRmxmTwHk6CA4xJ2FIHUYbkitTuHRUiwJbQyZapeubBQKOEzBse9y8YAOvKlzS1nBNfmFJBK/VWJ7r/vNFegrFoARRvSos6N85xiRieDZIK
 wiPhUoqpGnlPATmGP6SI5dIhidQM0g5BMvgqJiGU6nJbzEMywIyzVlAywQ5DeL/7BrLJHgZeJQ8wajk6P4nIw89anL3Gn3coiB1O47kzlKShbVpKdN7j6niU
 AkZdxqSEAcL/U6itSQuB9QvO+2i62hNsXwKS0QtrTcOAni4yt5atoZrz0+Ut3DLmO0eHcXGiabDHbyC2w+Wfhd0aOwz7xmKEbpCQUY1qf5UcFZqNY5dwQbdt
 Zzn7c2gxv7H+MTXIzC9tZZBg0jrPKJZ6rqpXfwWCjrwXTRqwIBGhWtfMYpeUs0FLdcZbPXSvALtbPWvdbPIrutugMjuAPJ4LIIsLEglL+7Yma5loM3TaKeOY
 8ZQY5v8rUJZJQeOUEEHfeD6qePCgperhHWgZWOpRp0o5tiLMknQ2OtTBEllaOsITXQ50fGNrMaWsx926pJXUKkgcj/TDuDxZNDvP6VTKSvrXI9vDK5a31EuN
 Nwudre3C/Tjgi5dHSaVtZ5zz0YqX6JTFTaDMmDgDg4NFptBkgXMOCEbE1DZAId+CixAPyMbva+WliSMg0ISdg+06iCmx/tFDtSuLbuvhlcur6Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

D_CAN controller supports 16, 32, 64 or 128 message objects, comparing
to 32 on C_CAN.
AM335x/AM437x Sitara processors and DRA7 SOC all instantiate a D_CAN
controller with 64 message objects, as described in the "DCAN features"
subsection of the CAN chapter of their technical reference manuals.

The driver policy has been kept unchanged, and as in the previous
version, the first half of the message objects is used for reception and
the second for transmission.

The I/O load is increased only in the case of 64 message objects,
keeping it unchanged in the case of 32. Two 32-bit read accesses are in
fact required, which however remained at 16-bit for configurations with
32 message objects.

Signed-off-by: Dario Binacchi <dariobin@libero.it>

---

Changes in v3:
- Use unsigned int instead of int as type of the msg_obj_num field
  in c_can_driver_data and c_can_pci_data structures.

Changes in v2:
- Add message objects number to PCI driver data.

 drivers/net/can/c_can/c_can.c          | 19 +++++++++++--------
 drivers/net/can/c_can/c_can.h          |  5 +++--
 drivers/net/can/c_can/c_can_pci.c      |  6 +++++-
 drivers/net/can/c_can/c_can_platform.c |  6 +++++-
 4 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index ede6f4d62095..bb766904636b 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -723,8 +723,12 @@ static void c_can_do_tx(struct net_device *dev)
 	struct net_device_stats *stats = &dev->stats;
 	u32 idx, obj, pkts = 0, bytes = 0, pend, clr;
 
-	clr = pend = priv->read_reg(priv, C_CAN_INTPND2_REG);
+	if (priv->msg_obj_tx_last > 32)
+		pend = priv->read_reg32(priv, C_CAN_INTPND3_REG);
+	else
+		pend = priv->read_reg(priv, C_CAN_INTPND2_REG);
 
+	clr = pend;
 	while ((idx = ffs(pend))) {
 		idx--;
 		pend &= ~(1 << idx);
@@ -834,7 +838,12 @@ static int c_can_read_objects(struct net_device *dev, struct c_can_priv *priv,
 
 static inline u32 c_can_get_pending(struct c_can_priv *priv)
 {
-	u32 pend = priv->read_reg(priv, C_CAN_NEWDAT1_REG);
+	u32 pend;
+
+	if (priv->msg_obj_rx_last > 16)
+		pend = priv->read_reg32(priv, C_CAN_NEWDAT1_REG);
+	else
+		pend = priv->read_reg(priv, C_CAN_NEWDAT1_REG);
 
 	return pend;
 }
@@ -856,12 +865,6 @@ static int c_can_do_rx_poll(struct net_device *dev, int quota)
 	struct c_can_priv *priv = netdev_priv(dev);
 	u32 pkts = 0, pend = 0, toread, n;
 
-	/*
-	 * It is faster to read only one 16bit register. This is only possible
-	 * for a maximum number of 16 objects.
-	 */
-	WARN_ON(priv->msg_obj_rx_last > 16);
-
 	while (quota > 0) {
 		if (!pend) {
 			pend = c_can_get_pending(priv);
diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
index 68295fab83d9..bd291e998a51 100644
--- a/drivers/net/can/c_can/c_can.h
+++ b/drivers/net/can/c_can/c_can.h
@@ -22,8 +22,6 @@
 #ifndef C_CAN_H
 #define C_CAN_H
 
-#define C_CAN_NO_OF_OBJECTS	32
-
 enum reg {
 	C_CAN_CTRL_REG = 0,
 	C_CAN_CTRL_EX_REG,
@@ -61,6 +59,7 @@ enum reg {
 	C_CAN_NEWDAT2_REG,
 	C_CAN_INTPND1_REG,
 	C_CAN_INTPND2_REG,
+	C_CAN_INTPND3_REG,
 	C_CAN_MSGVAL1_REG,
 	C_CAN_MSGVAL2_REG,
 	C_CAN_FUNCTION_REG,
@@ -122,6 +121,7 @@ static const u16 __maybe_unused reg_map_d_can[] = {
 	[C_CAN_NEWDAT2_REG]	= 0x9E,
 	[C_CAN_INTPND1_REG]	= 0xB0,
 	[C_CAN_INTPND2_REG]	= 0xB2,
+	[C_CAN_INTPND3_REG]	= 0xB4,
 	[C_CAN_MSGVAL1_REG]	= 0xC4,
 	[C_CAN_MSGVAL2_REG]	= 0xC6,
 	[C_CAN_IF1_COMREQ_REG]	= 0x100,
@@ -161,6 +161,7 @@ struct raminit_bits {
 
 struct c_can_driver_data {
 	enum c_can_dev_id id;
+	unsigned int msg_obj_num;
 
 	/* RAMINIT register description. Optional. */
 	const struct raminit_bits *raminit_bits; /* Array of START/DONE bit positions */
diff --git a/drivers/net/can/c_can/c_can_pci.c b/drivers/net/can/c_can/c_can_pci.c
index 3752f68d095e..9415b12d26c8 100644
--- a/drivers/net/can/c_can/c_can_pci.c
+++ b/drivers/net/can/c_can/c_can_pci.c
@@ -31,6 +31,8 @@ enum c_can_pci_reg_align {
 struct c_can_pci_data {
 	/* Specify if is C_CAN or D_CAN */
 	enum c_can_dev_id type;
+	/* Number of message objects */
+	unsigned int msg_obj_num;
 	/* Set the register alignment in the memory */
 	enum c_can_pci_reg_align reg_align;
 	/* Set the frequency */
@@ -149,7 +151,7 @@ static int c_can_pci_probe(struct pci_dev *pdev,
 	}
 
 	/* allocate the c_can device */
-	dev = alloc_c_can_dev(C_CAN_NO_OF_OBJECTS);
+	dev = alloc_c_can_dev(c_can_pci_data->msg_obj_num);
 	if (!dev) {
 		ret = -ENOMEM;
 		goto out_iounmap;
@@ -253,6 +255,7 @@ static void c_can_pci_remove(struct pci_dev *pdev)
 
 static const struct c_can_pci_data c_can_sta2x11= {
 	.type = BOSCH_C_CAN,
+	.msg_obj_num = 32,
 	.reg_align = C_CAN_REG_ALIGN_32,
 	.freq = 52000000, /* 52 Mhz */
 	.bar = 0,
@@ -260,6 +263,7 @@ static const struct c_can_pci_data c_can_sta2x11= {
 
 static const struct c_can_pci_data c_can_pch = {
 	.type = BOSCH_C_CAN,
+	.msg_obj_num = 32,
 	.reg_align = C_CAN_REG_32,
 	.freq = 50000000, /* 50 MHz */
 	.init = c_can_pci_reset_pch,
diff --git a/drivers/net/can/c_can/c_can_platform.c b/drivers/net/can/c_can/c_can_platform.c
index a5b9b1a93702..87a145b67a2f 100644
--- a/drivers/net/can/c_can/c_can_platform.c
+++ b/drivers/net/can/c_can/c_can_platform.c
@@ -192,10 +192,12 @@ static void c_can_hw_raminit(const struct c_can_priv *priv, bool enable)
 
 static const struct c_can_driver_data c_can_drvdata = {
 	.id = BOSCH_C_CAN,
+	.msg_obj_num = 32,
 };
 
 static const struct c_can_driver_data d_can_drvdata = {
 	.id = BOSCH_D_CAN,
+	.msg_obj_num = 32,
 };
 
 static const struct raminit_bits dra7_raminit_bits[] = {
@@ -205,6 +207,7 @@ static const struct raminit_bits dra7_raminit_bits[] = {
 
 static const struct c_can_driver_data dra7_dcan_drvdata = {
 	.id = BOSCH_D_CAN,
+	.msg_obj_num = 64,
 	.raminit_num = ARRAY_SIZE(dra7_raminit_bits),
 	.raminit_bits = dra7_raminit_bits,
 	.raminit_pulse = true,
@@ -217,6 +220,7 @@ static const struct raminit_bits am3352_raminit_bits[] = {
 
 static const struct c_can_driver_data am3352_dcan_drvdata = {
 	.id = BOSCH_D_CAN,
+	.msg_obj_num = 64,
 	.raminit_num = ARRAY_SIZE(am3352_raminit_bits),
 	.raminit_bits = am3352_raminit_bits,
 };
@@ -293,7 +297,7 @@ static int c_can_plat_probe(struct platform_device *pdev)
 	}
 
 	/* allocate the c_can device */
-	dev = alloc_c_can_dev(C_CAN_NO_OF_OBJECTS);
+	dev = alloc_c_can_dev(drvdata->msg_obj_num);
 	if (!dev) {
 		ret = -ENOMEM;
 		goto exit;
-- 
2.17.1

