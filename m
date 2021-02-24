Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E761C324754
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 00:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236279AbhBXXDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 18:03:54 -0500
Received: from smtp-17-i2.italiaonline.it ([213.209.12.17]:45600 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236272AbhBXXDw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 18:03:52 -0500
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([87.20.116.197])
        by smtp-17.iol.local with ESMTPA
        id F32VlxCf1lChfF32clf7Xj; Wed, 24 Feb 2021 23:53:59 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614207239; bh=du/r059EGbu4TPhvkxNS/d6olzOblvZ4VEQuwxQdY+Y=;
        h=From;
        b=RbOBMX4JZ2BfUT6o3fOBK3A5/5xjwSTKHnVUGx+Da7w4DfgB3L9xQcJBmfIoVG0Ko
         pa6jhOyxtkFeeZ48grdqXWUNMpX211R2nvRDfT0NB+A6lEiSLc/ZAugfMchFeqtdb8
         xhPJYwbixx1uK7AR2l5sS2yJpXIB/5qU8ksMBtYoIXz0ZqGXTlyIaSrcvtj75QyzPn
         7jlv/Ber75iVjr3212iKXmXMdaN4oz8ijQ1+ziGz2MkR/sgi3K2EokJ3rLdpGyWZQb
         1FatfF+LvdTV8DNpO2bQcK0ifMAELGVZwzzcOLJoU06rDIQ+XjwplN6Zi/ArXLcmrW
         OnHpYppy2dZjQ==
X-CNFS-Analysis: v=2.4 cv=S6McfKgP c=1 sm=1 tr=0 ts=6036d907 cx=a_exe
 a=AVqmXbCQpuNSdJmApS5GbQ==:117 a=AVqmXbCQpuNSdJmApS5GbQ==:17
 a=Et75ynYvZpBubEpffocA:9 a=guPwXWNZSXGlnza0:21 a=TNOWAEZzmosXMk2n:21
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 6/6] can: c_can: add support to 64 messages objects
Date:   Wed, 24 Feb 2021 23:52:46 +0100
Message-Id: <20210224225246.11346-7-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210224225246.11346-1-dariobin@libero.it>
References: <20210224225246.11346-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfLvwxBQLCQPQhDNkT/ybW8k2/InpKU2rjXB1xggz9UHl+xJ4nzvqUNdWRbHwVJGqXr1oeh2iddosJSnI7A2RlEJwSIMvyBw7qLfCIgnlzsjMUHn0sSyu
 di9n1EoQdiMe0E1ByYKafEuus0383cJ1eWhSzHlpkOWMJXA71Mq3gOwOSyDy/29MUfHcYL1Fd+mG+iZ5PmCKtjtK6p1pNpgXLINEXeDjo4d+YbzeEUyOfv4B
 MpFqkOSaroL7ajDgG/XzwTn3E+7FihmzrklNrMvbgdaYMp/ZYKzJx5MER9AFw6l8GJm1s44ISPfQAKA19uc52NvhJg1E85EdeF8fBRgdfV7S4++q7/g3NiAq
 qIldyhtLoyWvQNdOZPIQdY/MZQzkOJQYPQGw+Tkab1HMdLDiieCM89sYzwJtFpnDYqk4qtEohhsizQMPTh4kLOqnzzKhlC4I7ptxq3UxUuwqNG4hkhjacdYC
 YQ4IhEvB+LJPFSFx6N2OqQz/etU8MHxYygZQ8nipTmQgE4zWTifoZSoNv22I8QjXiktV4V33ztx3BJFVI00YfE7anWbPow8v4QE0/dq5sbihe6mlneZLnvIQ
 +ioTR/+hJQmSnSYKhjI+NipO
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

D_CAN controller supports 16, 32, 64 or 128 messages objects, comparing
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

 drivers/net/can/c_can/c_can.c          | 19 +++++++++++--------
 drivers/net/can/c_can/c_can.h          |  5 +++--
 drivers/net/can/c_can/c_can_platform.c |  6 +++++-
 3 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 772b26685fea..3429eab5ac7d 100644
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
index 1dbe777320f5..7cf92a576d4a 100644
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

