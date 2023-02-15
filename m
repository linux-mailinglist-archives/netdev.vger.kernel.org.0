Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5C3697BE5
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 13:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbjBOMfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 07:35:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234048AbjBOMe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 07:34:56 -0500
Received: from smtp.smtpout.orange.fr (smtp-29.smtpout.orange.fr [80.12.242.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7725A28841
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 04:34:42 -0800 (PST)
Received: from pop-os.home ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id SGzfp3ZUhl3gSSGzfpDd5X; Wed, 15 Feb 2023 13:34:41 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 15 Feb 2023 13:34:41 +0100
X-ME-IP: 86.243.2.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] wifi: wfx: Remove some dead code
Date:   Wed, 15 Feb 2023 13:34:37 +0100
Message-Id: <809c4a645c8d1306c0d256345515865c40ec731c.1676464422.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wait_for_completion_timeout() can not return a <0 value.
So simplify the logic and remove dead code.

-ERESTARTSYS can not be returned by do_wait_for_common() for tasks with
TASK_UNINTERRUPTIBLE, which is the case for wait_for_completion_timeout()

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/wireless/silabs/wfx/main.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/silabs/wfx/main.c b/drivers/net/wireless/silabs/wfx/main.c
index 6b9864e478ac..0b50f7058bbb 100644
--- a/drivers/net/wireless/silabs/wfx/main.c
+++ b/drivers/net/wireless/silabs/wfx/main.c
@@ -358,13 +358,9 @@ int wfx_probe(struct wfx_dev *wdev)
 
 	wfx_bh_poll_irq(wdev);
 	err = wait_for_completion_timeout(&wdev->firmware_ready, 1 * HZ);
-	if (err <= 0) {
-		if (err == 0) {
-			dev_err(wdev->dev, "timeout while waiting for startup indication\n");
-			err = -ETIMEDOUT;
-		} else if (err == -ERESTARTSYS) {
-			dev_info(wdev->dev, "probe interrupted by user\n");
-		}
+	if (err == 0) {
+		dev_err(wdev->dev, "timeout while waiting for startup indication\n");
+		err = -ETIMEDOUT;
 		goto bh_unregister;
 	}
 
-- 
2.34.1

