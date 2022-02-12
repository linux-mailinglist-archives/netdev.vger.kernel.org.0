Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D159F4B353B
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 14:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbiBLNIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 08:08:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235865AbiBLNII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 08:08:08 -0500
Received: from smtp.smtpout.orange.fr (smtp01.smtpout.orange.fr [80.12.242.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7E92983A
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 05:08:04 -0800 (PST)
Received: from localhost.localdomain ([124.33.176.97])
        by smtp.orange.fr with ESMTPA
        id Is7sniOlvu3WEIs80n92xc; Sat, 12 Feb 2022 14:07:55 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Sat, 12 Feb 2022 14:07:55 +0100
X-ME-IP: 124.33.176.97
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     netdev@vger.kernel.org, linux-can@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH] can: etas_es58x: use BITS_PER_TYPE() instead of manual calculation
Date:   Sat, 12 Feb 2022 22:07:37 +0900
Message-Id: <20220212130737.3008-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The input to the GENMASK() macro was calculated by hand. Replaced it
with a dedicated macro: BITS_PER_TYPE() which does the exact same job.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/usb/etas_es58x/es58x_fd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_fd.c b/drivers/net/can/usb/etas_es58x/es58x_fd.c
index ec87126e1a7d..88d2540abbbe 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_fd.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_fd.c
@@ -69,7 +69,8 @@ static int es58x_fd_echo_msg(struct net_device *netdev,
 	int i, num_element;
 	u32 rcv_packet_idx;
 
-	const u32 mask = GENMASK(31, sizeof(echo_msg->packet_idx) * 8);
+	const u32 mask = GENMASK(BITS_PER_TYPE(mask) - 1,
+				 BITS_PER_TYPE(echo_msg->packet_idx));
 
 	num_element = es58x_msg_num_element(es58x_dev->dev,
 					    es58x_fd_urb_cmd->echo_msg,
-- 
2.34.1

