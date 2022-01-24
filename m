Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60FA498779
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244804AbiAXSAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244818AbiAXSAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 13:00:03 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40148C061756
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:00:02 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nC3dI-0005BU-LA
        for netdev@vger.kernel.org; Mon, 24 Jan 2022 19:00:00 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id C9153210B1
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 17:59:56 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 6E2B221090;
        Mon, 24 Jan 2022 17:59:56 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 2c334826;
        Mon, 24 Jan 2022 17:59:56 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Angelo Dureghello <angelo@kernel-space.org>
Subject: [PATCH net 5/5] can: flexcan: mark RX via mailboxes as supported on MCF5441X
Date:   Mon, 24 Jan 2022 18:59:55 +0100
Message-Id: <20220124175955.3464134-6-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124175955.3464134-1-mkl@pengutronix.de>
References: <20220124175955.3464134-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most flexcan IP cores support 2 RX modes:
- FIFO
- mailbox

The flexcan IP core on the MCF5441X cannot receive CAN RTR messages
via mailboxes. However the mailbox mode is more performant. The commit

| 1c45f5778a3b ("can: flexcan: add ethtool support to change rx-rtr setting during runtime")

added support to switch from FIFO to mailbox mode on these cores.

After testing the mailbox mode on the MCF5441X by Angelo Dureghello,
this patch marks it (without RTR capability) as supported. Further the
IP core overview table is updated, that RTR reception via mailboxes is
not supported.

Link: https://lore.kernel.org/all/20220121084425.3141218-1-mkl@pengutronix.de
Tested-by: Angelo Dureghello <angelo@kernel-space.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan/flexcan-core.c | 1 +
 drivers/net/can/flexcan/flexcan.h      | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/flexcan/flexcan-core.c b/drivers/net/can/flexcan/flexcan-core.c
index 0bff1884d5cc..74d7fcbfd065 100644
--- a/drivers/net/can/flexcan/flexcan-core.c
+++ b/drivers/net/can/flexcan/flexcan-core.c
@@ -296,6 +296,7 @@ static_assert(sizeof(struct flexcan_regs) ==  0x4 * 18 + 0xfb8);
 static const struct flexcan_devtype_data fsl_mcf5441x_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_BROKEN_PERR_STATE |
 		FLEXCAN_QUIRK_NR_IRQ_3 | FLEXCAN_QUIRK_NR_MB_16 |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX |
 		FLEXCAN_QUIRK_SUPPPORT_RX_FIFO,
 };
 
diff --git a/drivers/net/can/flexcan/flexcan.h b/drivers/net/can/flexcan/flexcan.h
index fccdff8b1f0f..23fc09a7e10f 100644
--- a/drivers/net/can/flexcan/flexcan.h
+++ b/drivers/net/can/flexcan/flexcan.h
@@ -21,7 +21,7 @@
  * Below is some version info we got:
  *    SOC   Version   IP-Version  Glitch- [TR]WRN_INT IRQ Err Memory err RTR rece-   FD Mode     MB
  *                                Filter? connected?  Passive detection  ption in MB Supported?
- * MCF5441X FlexCAN2  ?               no       yes        no       no       yes           no     16
+ * MCF5441X FlexCAN2  ?               no       yes        no       no        no           no     16
  *    MX25  FlexCAN2  03.00.00.00     no        no        no       no        no           no     64
  *    MX28  FlexCAN2  03.00.04.00    yes       yes        no       no        no           no     64
  *    MX35  FlexCAN2  03.00.00.00     no        no        no       no        no           no     64
-- 
2.34.1


