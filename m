Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0C3660181
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 14:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbjAFNqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 08:46:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbjAFNqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 08:46:33 -0500
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7282631C;
        Fri,  6 Jan 2023 05:46:31 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B2E21E000F;
        Fri,  6 Jan 2023 13:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1673012790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=uu7OlXq7ioXd41G8rKLySQ2P+vBgHgZaa7tQBl0hBPY=;
        b=Jaw9EnR0ocZijcz73Weg51q15VpvtxO+e+sXj6TECPVfvS4t3CG5IsZSMicIGkphQrAJSR
        RMrI3V7yfPAys2mACw6z6a+ushF4tqEH4dunx7gWqcVg/uT6M8iAg0KNEc6J3jbaD59sTa
        3Yx2v1Ii98pZFw1Wxislma4WLuAutaL7UBtIKJj2UCAf0wFbKJa8uJjzVNaK5RwMp3hAAu
        OshQODbT3gloiCkutv+o/Oq8gMcApGoz3lwMZubM3NJ/jBLTNHFbA0cKRbXnHGof6X41OP
        iwmWHJH+Ch9+0dR4fj652hMw24AqzL3JkUDNbUic+BdzyLmMApom/hc824K54A==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: lan966x: check for ptp to be enabled in lan966x_ptp_deinit()
Date:   Fri,  6 Jan 2023 14:48:30 +0100
Message-Id: <20230106134830.333494-1-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If ptp was not enabled due to missing IRQ for instance,
lan966x_ptp_deinit() will dereference NULL pointers.

Fixes: d096459494a8 ("net: lan966x: Add support for ptp clocks")
Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
index f9ebfaafbebc..a8348437dd87 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
@@ -1073,6 +1073,9 @@ void lan966x_ptp_deinit(struct lan966x *lan966x)
 	struct lan966x_port *port;
 	int i;
 
+	if (!lan966x->ptp)
+		return;
+
 	for (i = 0; i < lan966x->num_phys_ports; i++) {
 		port = lan966x->ports[i];
 		if (!port)
-- 
2.38.1

