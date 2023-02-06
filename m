Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65C6F68BDC0
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 14:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbjBFNSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 08:18:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbjBFNRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 08:17:53 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C448234F8
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 05:17:27 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pP1N7-0007eP-3w
        for netdev@vger.kernel.org; Mon, 06 Feb 2023 14:17:25 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 6D11F171308
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:16:24 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 5E888171297;
        Mon,  6 Feb 2023 13:16:22 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id c028949a;
        Mon, 6 Feb 2023 13:16:21 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Jannik Hartung <jannik.hartung@tu-bs.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 01/47] can: gw: give feedback on missing CGW_FLAGS_CAN_IIF_TX_OK flag
Date:   Mon,  6 Feb 2023 14:15:34 +0100
Message-Id: <20230206131620.2758724-2-mkl@pengutronix.de>
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

From: Oliver Hartkopp <socketcan@hartkopp.net>

To send CAN traffic back to the incoming interface a special flag has to
be set. When creating a routing job for identical interfaces without this
flag the rule is created but has no effect.

This patch adds an error return value in the case that the CAN interfaces
are identical but the CGW_FLAGS_CAN_IIF_TX_OK flag was not set.

Reported-by: Jannik Hartung <jannik.hartung@tu-bs.de>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/all/20230125055407.2053-1-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/gw.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/can/gw.c b/net/can/gw.c
index 23a3d89cad81..37528826935e 100644
--- a/net/can/gw.c
+++ b/net/can/gw.c
@@ -1139,6 +1139,13 @@ static int cgw_create_job(struct sk_buff *skb,  struct nlmsghdr *nlh,
 	if (gwj->dst.dev->type != ARPHRD_CAN)
 		goto out;
 
+	/* is sending the skb back to the incoming interface intended? */
+	if (gwj->src.dev == gwj->dst.dev &&
+	    !(gwj->flags & CGW_FLAGS_CAN_IIF_TX_OK)) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	ASSERT_RTNL();
 
 	err = cgw_register_filter(net, gwj);

base-commit: 609aa68d60965f70485655def733d533f99b341b
-- 
2.39.1


