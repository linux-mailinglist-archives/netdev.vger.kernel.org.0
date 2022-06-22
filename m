Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB3A554131
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 06:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354017AbiFVEH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 00:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbiFVEH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 00:07:56 -0400
Received: from mail-m963.mail.126.com (mail-m963.mail.126.com [123.126.96.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C9E8FF38
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 21:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=4ZcUI
        pWUGV5xCWa5nF+nGF6SZjkQr/+L5/KOM/xlrG4=; b=JrBstc8aIxWuV5F25fzdk
        BCGpVWY9cyoSRKGex3PwQmeURjNqeUPpTcsV3vGT3LyIkJjECVNMQ8LpU3/gEBCc
        qSfSeJvT/BEq3tEJnP9ConMSeFHtFrVMj+KECeUaf8pqCE1I2rcpOBDi9wJTJjK1
        4yoYXMrJWx+2ewNWlh3rWo=
Received: from localhost.localdomain (unknown [124.16.139.61])
        by smtp8 (Coremail) with SMTP id NORpCgB3f3M+lbJi3zOYGA--.54289S2;
        Wed, 22 Jun 2022 12:06:23 +0800 (CST)
From:   Liang He <windhl@126.com>
To:     andrew@lunn.ch, kurt@linutronix.de, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, windhl@126.com
Subject: [PATCH] net/dsa/hirschmann: Add missing of_node_get() in hellcreek_led_setup()
Date:   Wed, 22 Jun 2022 12:06:21 +0800
Message-Id: <20220622040621.4094304-1-windhl@126.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: NORpCgB3f3M+lbJi3zOYGA--.54289S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Xr1fKF48GFWDtw1ftF47Jwb_yoWfXrg_Wr
        12gFyayas8Wr1DtrsF9r4Sqr90yr1DCrs7uFyIv343Ja4aqayag34rXF18Jrn7Ww42yFy3
        XrnIg3W5W3y3tjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRiYhFDUUUUU==
X-Originating-IP: [124.16.139.61]
X-CM-SenderInfo: hzlqvxbo6rjloofrz/1tbi7QEoF1pEAQKbBgABsS
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

of_find_node_by_name() will decrease the refcount of its first arg and
we need a of_node_get() to keep refcount balance.

Signed-off-by: Liang He <windhl@126.com>
---
 drivers/net/dsa/hirschmann/hellcreek_ptp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/hirschmann/hellcreek_ptp.c b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
index 2572c6087bb5..b28baab6d56a 100644
--- a/drivers/net/dsa/hirschmann/hellcreek_ptp.c
+++ b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
@@ -300,6 +300,7 @@ static int hellcreek_led_setup(struct hellcreek *hellcreek)
 	const char *label, *state;
 	int ret = -EINVAL;
 
+	of_node_get(hellcreek->dev->of_node);
 	leds = of_find_node_by_name(hellcreek->dev->of_node, "leds");
 	if (!leds) {
 		dev_err(hellcreek->dev, "No LEDs specified in device tree!\n");
-- 
2.25.1

