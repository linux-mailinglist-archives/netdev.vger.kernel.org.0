Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23EB05E7A57
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 14:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbiIWMSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 08:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbiIWMQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 08:16:18 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCAC912F762
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 05:09:07 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1obhUQ-0007G8-6Z
        for netdev@vger.kernel.org; Fri, 23 Sep 2022 14:09:06 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 963E6EB124
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 12:09:04 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 4692EEB105;
        Fri, 23 Sep 2022 12:09:02 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id c64d6b52;
        Fri, 23 Sep 2022 12:09:00 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Ziyang Xuan <william.xuanziyang@huawei.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 01/11] can: bcm: registration process optimization in bcm_module_init()
Date:   Fri, 23 Sep 2022 14:08:49 +0200
Message-Id: <20220923120859.740577-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220923120859.740577-1-mkl@pengutronix.de>
References: <20220923120859.740577-1-mkl@pengutronix.de>
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

From: Ziyang Xuan <william.xuanziyang@huawei.com>

Now, register_netdevice_notifier() and register_pernet_subsys() are both
after can_proto_register(). It can create CAN_BCM socket and process socket
once can_proto_register() successfully, so it is possible missing notifier
event or proc node creation because notifier or bcm proc directory is not
registered or created yet. Although this is a low probability scenario, it
is not impossible.

Move register_pernet_subsys() and register_netdevice_notifier() to the
front of can_proto_register(). In addition, register_pernet_subsys() and
register_netdevice_notifier() may fail, check their results are necessary.

Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Link: https://lore.kernel.org/all/823cff0ebec33fa9389eeaf8b8ded3217c32cb38.1663206163.git.william.xuanziyang@huawei.com
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/bcm.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index e5d179ba6f7d..0a2adb844280 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -1749,15 +1749,27 @@ static int __init bcm_module_init(void)
 
 	pr_info("can: broadcast manager protocol\n");
 
+	err = register_pernet_subsys(&canbcm_pernet_ops);
+	if (err)
+		return err;
+
+	err = register_netdevice_notifier(&canbcm_notifier);
+	if (err)
+		goto register_notifier_failed;
+
 	err = can_proto_register(&bcm_can_proto);
 	if (err < 0) {
 		printk(KERN_ERR "can: registration of bcm protocol failed\n");
-		return err;
+		goto register_proto_failed;
 	}
 
-	register_pernet_subsys(&canbcm_pernet_ops);
-	register_netdevice_notifier(&canbcm_notifier);
 	return 0;
+
+register_proto_failed:
+	unregister_netdevice_notifier(&canbcm_notifier);
+register_notifier_failed:
+	unregister_pernet_subsys(&canbcm_pernet_ops);
+	return err;
 }
 
 static void __exit bcm_module_exit(void)

base-commit: d05d9eb79d0cd0f7a978621b4a56a1f2db444f86
-- 
2.35.1


