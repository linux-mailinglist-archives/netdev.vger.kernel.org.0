Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88D2768BDDA
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 14:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbjBFNTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 08:19:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbjBFNS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 08:18:29 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B52A02449B
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 05:17:37 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pP1NH-0008Ca-PL
        for netdev@vger.kernel.org; Mon, 06 Feb 2023 14:17:35 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 9614E171540
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:16:29 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 0DA6C17133E;
        Mon,  6 Feb 2023 13:16:25 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 825cb9ad;
        Mon, 6 Feb 2023 13:16:24 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent Mailhol <vincent.mailhol@gmail.com>
Subject: [PATCH net-next 43/47] can: bittiming: can_sjw_check(): check that SJW is not longer than either Phase Buffer Segment
Date:   Mon,  6 Feb 2023 14:16:16 +0100
Message-Id: <20230206131620.2758724-44-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230206131620.2758724-1-mkl@pengutronix.de>
References: <20230206131620.2758724-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to "The Configuration of the CAN Bit Timing" [1] the SJW
"may not be longer than either Phase Buffer Segment".

Check SJW against length of both Phase buffers. In case the SJW is
greater, report an error via netlink to user space and bail out.

[1] http://web.archive.org/http://www.oertel-halle.de/files/cia99paper.pdf

Link: https://lore.kernel.org/all/20230202110854.2318594-14-mkl@pengutronix.de
Suggested-by: Vincent Mailhol <vincent.mailhol@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/bittiming.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/can/dev/bittiming.c b/drivers/net/can/dev/bittiming.c
index 0a2a9b12565f..68287b79afe8 100644
--- a/drivers/net/can/dev/bittiming.c
+++ b/drivers/net/can/dev/bittiming.c
@@ -24,6 +24,20 @@ int can_sjw_check(const struct net_device *dev, const struct can_bittiming *bt,
 		return -EINVAL;
 	}
 
+	if (bt->sjw > bt->phase_seg1) {
+		NL_SET_ERR_MSG_FMT(extack,
+				   "sjw: %u greater than phase-seg1: %u",
+				   bt->sjw, bt->phase_seg1);
+		return -EINVAL;
+	}
+
+	if (bt->sjw > bt->phase_seg2) {
+		NL_SET_ERR_MSG_FMT(extack,
+				   "sjw: %u greater than phase-seg2: %u",
+				   bt->sjw, bt->phase_seg2);
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
-- 
2.39.1


