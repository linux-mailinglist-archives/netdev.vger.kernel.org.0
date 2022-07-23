Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD1B57EC58
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 08:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234201AbiGWGj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 02:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiGWGj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 02:39:26 -0400
Received: from mail-m971.mail.163.com (mail-m971.mail.163.com [123.126.97.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 570BD140CE;
        Fri, 22 Jul 2022 23:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=ghGvY
        r984FDqS6i/4Wzdk3AISc6OUN356jDYgZPRZuk=; b=l1Gg+HJ/yum4s9wrE9HmW
        Tl+AJXwAWHhqwSP2CNeWXSVHy7hyatvaru8/VHCxmIT3O4PuE5uTcL268kLx8tqY
        UT+cqGVcRcCM3T8M/u15bwv3EpKoqrFoMbui+gYPXDLGYlZXRBZN21C8WjTd3QNf
        Ko6nxhycL1nyI5dSE/t2Kw=
Received: from localhost.localdomain (unknown [123.58.221.99])
        by smtp1 (Coremail) with SMTP id GdxpCgAXKHNGl9tiDqPaPw--.18361S2;
        Sat, 23 Jul 2022 14:38:00 +0800 (CST)
From:   williamsukatube@163.com
To:     tony0620emma@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     William Dean <williamsukatube@gmail.com>,
        Hacash Robot <hacashRobot@santino.com>
Subject: [PATCH] rtw88: check the return value of alloc_workqueue()
Date:   Sat, 23 Jul 2022 14:37:56 +0800
Message-Id: <20220723063756.2956189-1-williamsukatube@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GdxpCgAXKHNGl9tiDqPaPw--.18361S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tryUAFyxJw18Xr4kGryDWrg_yoW8JFWfpa
        98WwnrCasxKw1UAa1jq3WYyFn8X3W8KF9rZr9avw4rZ3y8ZFyrAa4YqF9FvrZ0krWjgF43
        ArsYgr9xG3Z0vFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07bw89NUUUUU=
X-Originating-IP: [123.58.221.99]
X-CM-SenderInfo: xzlozx5dpv3yxdwxuvi6rwjhhfrp/1tbiUQhHg2DEOrzTiQAAsl
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: William Dean <williamsukatube@gmail.com>

The function alloc_workqueue() in rtw_core_init() can fail, but
there is no check of its return value. To fix this bug, its return value
should be checked with new error handling code.

Fixes: fe101716c7c9d ("rtw88: replace tx tasklet with work queue")
Reported-by: Hacash Robot <hacashRobot@santino.com>
Signed-off-by: William Dean <williamsukatube@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index efabd5b1bf5b..645ef1d01895 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1984,6 +1984,10 @@ int rtw_core_init(struct rtw_dev *rtwdev)
 	timer_setup(&rtwdev->tx_report.purge_timer,
 		    rtw_tx_report_purge_timer, 0);
 	rtwdev->tx_wq = alloc_workqueue("rtw_tx_wq", WQ_UNBOUND | WQ_HIGHPRI, 0);
+	if (!rtwdev->tx_wq) {
+		rtw_warn(rtwdev, "alloc_workqueue rtw_tx_wq failed\n");
+		return -ENOMEM;
+	}
 
 	INIT_DELAYED_WORK(&rtwdev->watch_dog_work, rtw_watch_dog_work);
 	INIT_DELAYED_WORK(&coex->bt_relink_work, rtw_coex_bt_relink_work);
-- 
2.25.1

