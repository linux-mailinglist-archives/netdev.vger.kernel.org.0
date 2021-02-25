Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605C2325914
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 22:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbhBYVzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 16:55:02 -0500
Received: from smtp-17-i2.italiaonline.it ([213.209.12.17]:57611 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234708AbhBYVyD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 16:54:03 -0500
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([87.20.116.197])
        by smtp-17.iol.local with ESMTPA
        id FOYQlNUJ2lChfFOYZlkbhQ; Thu, 25 Feb 2021 22:52:24 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614289944; bh=zrB7Sex8qAljdk/P0favelF3Z2QW1uq0XCEp2nBu39I=;
        h=From;
        b=zFg22pCfjHhJMdOR+sy+LuWnSD883ppuuy4r1j+OLUD8OZi3/Z/eN8lArW956o2gI
         DimTwLEky5X1nlxEt24Maz7Ezy/036wTmws5DOvwSJ7Py8zcud+Y3dKlmOEgX3ChQh
         +E/lQmFQsJjUxL7XC+mXNAv4g/0cXkN3fWDtkY0kC/aLBrVp8LinGOs5gEwZUP0w6U
         +HrLuPMHCiE8mzT7CWE05uPl9v37Km5XMJ7PDYSk8X7l/NPc2C+FQG3DSiy7SzFciA
         XuO5fYSUwIU9GBMhzY8eEMpXL31pfeFbpgX/I1ElMaXkH9/COu64puz1MOAffti213
         KP+fWD1xOzg5w==
X-CNFS-Analysis: v=2.4 cv=S6McfKgP c=1 sm=1 tr=0 ts=60381c18 cx=a_exe
 a=AVqmXbCQpuNSdJmApS5GbQ==:117 a=AVqmXbCQpuNSdJmApS5GbQ==:17
 a=FEz_7PL0ERQs5GQP_jQA:9 a=EQGfsiorO9qKaa_4:21 a=GjewnYaElfTv6_oh:21
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@systec-electronic.com>,
        Federico Vaga <federico.vaga@gmail.com>,
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
Subject: [PATCH v2 6/6] can: c_can: add support to 64 message objects
Date:   Thu, 25 Feb 2021 22:51:55 +0100
Message-Id: <20210225215155.30509-7-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210225215155.30509-1-dariobin@libero.it>
References: <20210225215155.30509-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfFMAPA/Fi5dwIs8cvMTO93k73YNNOSJ+XOPpg8LGQMt4XZ8QrrHJje7xLkIJVXnqIzLOFqRhRo336KskWqnxd9eZ4HmEdqxckfyhh2LHUDKSRJA1YYKp
 5rzpZ4H+dF+i8UencNPBJ3GT/TN/1eoX1tWFu+CQTSlWphgy6gNBrv0jsQBVHTFQUr9XMAh1SS75jvPOurnRnoxzkl4aEkRypio2syCkNSjWMumFa0faRO4p
 MCxNyyu0nCAS0ih4+n0uJReoAzMlycJUlAWL7CRgCYK09+Ehdmo1XdnrE5XBFT2A3s6HVpenAc0qyydAMrn9b+/TwKLINrtQ/GSgamKvdK4Fy77wV6SdHZfA
 v3JldOAneHbJojF7nRKmk9WfOGKqQ2AMTtcQJ0vbuVvPmX3VEhO85KejNSFvBPJiFmn6leH7GThW/PhHVQEk/X+JlVDfbbxvbzIS37dx2gfvyyY3Wcw9oB7Q
 34hsBQuuZvuCTRMrFiytK5B58NVBGHqeM0B+D5yZM5YAvut7SZ8mpVPkiCAoLGW508lLLmhrnd2zUYwK2vQ351kTo+kG+TiEWmVmge9qGVc2smKDerLrNz2E
 qZYdx6Q0g3szkI6cKP+a7a/vuSTd1NiI+mK8SlxFgUh3LaEn4arURPAdamOv+IFr0fSmyUN6er8WX5qs2zmRCoofSk48sAiQjmlv39JDSSbKxQ==
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

Changes in v2:
- Add message objects number to PCI driver data.

 drivers/net/can/c_can/c_can.c          | 19 +++++++++++--------
 drivers/net/can/c_can/c_can.h          |  5 +++--
 drivers/net/can/c_can/c_can_pci.c      |  6 +++++-
 drivers/net/can/c_can/c_can_platform.c |  6 +++++-
 4 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index df1ad6b3fd3b..b049e94543cb 100644
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
index 22ae6077b489..cff24597be3c 100644
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
+	int msg_obj_num;
 
 	/* RAMINIT register description. Optional. */
 	const struct raminit_bits *raminit_bits; /* Array of START/DONE bit positions */
diff --git a/drivers/net/can/c_can/c_can_pci.c b/drivers/net/can/c_can/c_can_pci.c
index 3752f68d095e..2cb98ccd04d7 100644
--- a/drivers/net/can/c_can/c_can_pci.c
+++ b/drivers/net/can/c_can/c_can_pci.c
@@ -31,6 +31,8 @@ enum c_can_pci_reg_align {
 struct c_can_pci_data {
 	/* Specify if is C_CAN or D_CAN */
 	enum c_can_dev_id type;
+	/* Number of message objects */
+	int msg_obj_num;
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

