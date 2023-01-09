Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96E9E6629F0
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 16:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237095AbjAIPbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 10:31:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237226AbjAIPbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 10:31:05 -0500
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B69395FB;
        Mon,  9 Jan 2023 07:30:37 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id CC5B84000A;
        Mon,  9 Jan 2023 15:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1673278235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=JeLio8yD9weT4NXy3rfTtYARl8N0adDQIDkmNvJp3nU=;
        b=mIyU7ZXDjmnd8giwcY7EM1bkXO01Tc0pmsrh62pwu6zKiJA2BV238+2nuey7QHPIuPEBYO
        eFwcnnqAihoAMQFIQTzAgXo56OSd1PofvhYKx2l/p1vLJy3c7LZwFQm9ZinXHz0E8dmRyW
        m0YAJGfDd1tAWfKP36jt7yYfCwU5rddXa3EfRhQnSrkjPtA+uepw8DcNmldlLyMd0khZ8e
        BkVxG9tU7yO1/i9cRdbA2NE8PvI8IWTXVHM56iIoNd69jTnDhTtvsLX3uPo5Q2LrOgP0n2
        u9HrT1kssWqEFRb4JOJY7PecH+cxAV13YzV1DFwtC5gkSVWO4fqtOXLJwsR8Ig==
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
Subject: [PATCH net v2] net: lan966x: check for ptp to be enabled in lan966x_ptp_deinit()
Date:   Mon,  9 Jan 2023 16:32:23 +0100
Message-Id: <20230109153223.390015-1-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If ptp was not enabled due to missing IRQ for instance,
lan966x_ptp_deinit() will dereference NULL pointers.

Fixes: d096459494a8 ("net: lan966x: Add support for ptp clocks")
Signed-off-by: Clément Léger <clement.leger@bootlin.com>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
Changes in v2:
 - Added Reviewed-by: Horatiu Vultur
 - Added net in patch subject to target net tree

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

