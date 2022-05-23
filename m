Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96285531A7B
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbiEWUIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 16:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbiEWUIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 16:08:18 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917DD97282
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 13:08:17 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ntELg-0002ez-0K
        for netdev@vger.kernel.org; Mon, 23 May 2022 22:08:16 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 221F5848A8
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 20:08:14 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id A75DD8489E;
        Mon, 23 May 2022 20:08:13 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 51a8fe0b;
        Mon, 23 May 2022 20:08:12 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 2/3] can: kvaser_usb: silence a GCC 12 -Warray-bounds warning
Date:   Mon, 23 May 2022 22:08:08 +0200
Message-Id: <20220523200809.1708614-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220523200809.1708614-1-mkl@pengutronix.de>
References: <20220523200809.1708614-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

This driver does a lot of casting of smaller buffers to
struct kvaser_cmd_ext, GCC 12 does not like that:

| drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c:489:65: warning: array subscript ‘struct kvaser_cmd_ext[0]’ is partly outside array bounds of ‘unsigned char[32]’ [-Warray-bounds]
| drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c:489:23: note: in expansion of macro ‘le16_to_cpu’
|   489 |                 ret = le16_to_cpu(((struct kvaser_cmd_ext *)cmd)->len);
|       |                       ^~~~~~~~~~~

Temporarily silence this warning (move it to W=1 builds).

Link: https://lore.kernel.org/all/20220520194659.2356903-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Tested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/kvaser_usb/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/can/usb/kvaser_usb/Makefile b/drivers/net/can/usb/kvaser_usb/Makefile
index cf260044f0b9..b20d951a0790 100644
--- a/drivers/net/can/usb/kvaser_usb/Makefile
+++ b/drivers/net/can/usb/kvaser_usb/Makefile
@@ -1,3 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_CAN_KVASER_USB) += kvaser_usb.o
 kvaser_usb-y = kvaser_usb_core.o kvaser_usb_leaf.o kvaser_usb_hydra.o
+
+# FIXME: temporarily silence -Warray-bounds on non W=1+ builds
+ifndef KBUILD_EXTRA_WARN
+CFLAGS_kvaser_usb_hydra.o += -Wno-array-bounds
+endif
-- 
2.35.1


