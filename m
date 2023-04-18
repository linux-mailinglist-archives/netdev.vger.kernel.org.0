Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1C196E6726
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 16:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbjDRO33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 10:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbjDRO30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 10:29:26 -0400
Received: from exchange.fintech.ru (exchange.fintech.ru [195.54.195.159])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8946DD;
        Tue, 18 Apr 2023 07:29:24 -0700 (PDT)
Received: from Ex16-01.fintech.ru (10.0.10.18) by exchange.fintech.ru
 (195.54.195.159) with Microsoft SMTP Server (TLS) id 14.3.498.0; Tue, 18 Apr
 2023 17:29:23 +0300
Received: from localhost (10.0.253.138) by Ex16-01.fintech.ru (10.0.10.18)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Tue, 18 Apr
 2023 17:29:22 +0300
From:   Nikita Zhandarovich <n.zhandarovich@fintech.ru>
To:     Larry Finger <Larry.Finger@lwfinger.net>
CC:     Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        <linux-wireless@vger.kernel.org>, <b43-dev@lists.infradead.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lvc-project@linuxtesting.org>,
        Natalia Petrova <n.petrova@fintech.ru>
Subject: [PATCH v2] b43legacy: Add checking for null for ssb_get_devtypedata(dev)
Date:   Tue, 18 Apr 2023 07:29:18 -0700
Message-ID: <20230418142918.70510-1-n.zhandarovich@fintech.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.0.253.138]
X-ClientProxiedBy: Ex16-02.fintech.ru (10.0.10.19) To Ex16-01.fintech.ru
 (10.0.10.18)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since second call of ssb_get_devtypedata() may fail as well as the
first one, the NULL return value in 'wl' will be later dereferenced in
calls to b43legacy_one_core_attach() and schedule_work().

Instead of merely warning about this failure with
B43legacy_WARN_ON(), properly return with error to avoid any further
NULL pointer dereferences.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: 75388acd0cd8 ("[B43LEGACY]: add mac80211-based driver for legacy BCM43xx devices")
Co-developed-by: Natalia Petrova <n.petrova@fintech.ru>
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
---
v2: fix issues with overlooked null-ptr-dereferences pointed out by
Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/all/Y+eb9mZntfe6rO3v@corigine.com/ 

 drivers/net/wireless/broadcom/b43legacy/main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43legacy/main.c b/drivers/net/wireless/broadcom/b43legacy/main.c
index 760136638a95..5a706dd0b1a4 100644
--- a/drivers/net/wireless/broadcom/b43legacy/main.c
+++ b/drivers/net/wireless/broadcom/b43legacy/main.c
@@ -3857,7 +3857,11 @@ static int b43legacy_probe(struct ssb_device *dev,
 		if (err)
 			goto out;
 		wl = ssb_get_devtypedata(dev);
-		B43legacy_WARN_ON(!wl);
+		if (!wl) {
+			B43legacy_WARN_ON(!wl);
+			err = -ENODEV;
+			goto out;
+		}
 	}
 	err = b43legacy_one_core_attach(dev, wl);
 	if (err)
-- 
2.25.1

