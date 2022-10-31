Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF53E613A88
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 16:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbiJaPoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 11:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231995AbiJaPoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 11:44:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B534B11C21
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 08:44:17 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1opWxU-0002ve-3S
        for netdev@vger.kernel.org; Mon, 31 Oct 2022 16:44:16 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 1981910F489
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 15:44:12 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 7F8B010F418;
        Mon, 31 Oct 2022 15:44:08 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 84dbf477;
        Mon, 31 Oct 2022 15:44:08 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Jimmy Assarsson <extja@kvaser.com>,
        Anssi Hannula <anssi.hannula@bitwise.fi>
Subject: [PATCH net-next 08/14] can: kvaser_usb: kvaser_usb_set_bittiming(): fix redundant initialization warning for err
Date:   Mon, 31 Oct 2022 16:44:00 +0100
Message-Id: <20221031154406.259857-9-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221031154406.259857-1-mkl@pengutronix.de>
References: <20221031154406.259857-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variable err is initialized, but the initialized value is
Overwritten before it is read. Fix the warning by not initializing the
variable err at all.

Fixes: 39d3df6b0ea8 ("can: kvaser_usb: Compare requested bittiming parameters with actual parameters in do_set_{,data}_bittiming")
Cc: Jimmy Assarsson <extja@kvaser.com>
Cc: Anssi Hannula <anssi.hannula@bitwise.fi>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index 989e75351062..810dfe4053ca 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -541,7 +541,7 @@ static int kvaser_usb_set_bittiming(struct net_device *netdev)
 	int tseg1 = bt->prop_seg + bt->phase_seg1;
 	int tseg2 = bt->phase_seg2;
 	int sjw = bt->sjw;
-	int err = -EOPNOTSUPP;
+	int err;
 
 	busparams.bitrate = cpu_to_le32(bt->bitrate);
 	busparams.sjw = (u8)sjw;
-- 
2.35.1


