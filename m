Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F19F6C4784
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 11:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjCVKXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 06:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjCVKXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 06:23:31 -0400
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6623B44B7
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 03:23:27 -0700 (PDT)
X-QQ-mid: bizesmtp86t1679480598toh98512
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 22 Mar 2023 18:23:10 +0800 (CST)
X-QQ-SSF: 01400000000000H0Z000B00A0000000
X-QQ-FEAT: G46xFj+wOV9NyWbjMjq0ndrwk71yly9NQ849SREccsue4G1Kb8NUO+3rx1Rj5
        OcQL8QrF0aTi7jjLk8mU+/0jWgM2Eb7C+LV0MRMvT4XCMttv6vYL08dXfNMZ5npa3UhnkF6
        e2bCry6PKHnWP2OrtWUUHAlnF56CQdwCYpWN42rB7nalIG0rlQlXj4T4HFpFXPMjVOIwS87
        sl2AevGO8VX3I/1OnOCG8BXskGg6wwZB+uEILNjzUvKKlgOhacWVQqZcedeBBeQeDEFQWDc
        u555cTax2+86JE8Epzog1X2m/aqpShVE2WVa/44oAar/tJheZSx2yJaJCnLdedVA0pGuUsT
        pBK2qE5h0iHAp6JufGeUM16DMp4t+dbAi8SecIIWqKPjL9XHVQ0qm6Tlm0IZcSO6a/gJ6b5
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net] net: wangxun: Fix vector length of interrupt cause
Date:   Wed, 22 Mar 2023 18:36:32 +0800
Message-Id: <20230322103632.132011-1-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-0.0 required=5.0 tests=RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is 64-bit interrupt cause register for txgbe. Fix to clear upper
32 bits.

Fixes: 3f703186113f ("net: libwx: Add irq flow functions")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_type.h    | 2 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c   | 2 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c | 3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index 77d8d7f1707e..97e2c1e13b80 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -222,7 +222,7 @@
 #define WX_PX_INTA                   0x110
 #define WX_PX_GPIE                   0x118
 #define WX_PX_GPIE_MODEL             BIT(0)
-#define WX_PX_IC                     0x120
+#define WX_PX_IC(_i)                 (0x120 + (_i) * 4)
 #define WX_PX_IMS(_i)                (0x140 + (_i) * 4)
 #define WX_PX_IMC(_i)                (0x150 + (_i) * 4)
 #define WX_PX_ISB_ADDR_L             0x160
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index 5b564d348c09..17412e5282de 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -352,7 +352,7 @@ static void ngbe_up(struct wx *wx)
 	netif_tx_start_all_queues(wx->netdev);
 
 	/* clear any pending interrupts, may auto mask */
-	rd32(wx, WX_PX_IC);
+	rd32(wx, WX_PX_IC(0));
 	rd32(wx, WX_PX_MISC_IC);
 	ngbe_irq_enable(wx, true);
 	if (wx->gpio_ctrl)
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 6c0a98230557..a58ce5463686 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -229,7 +229,8 @@ static void txgbe_up_complete(struct wx *wx)
 	wx_napi_enable_all(wx);
 
 	/* clear any pending interrupts, may auto mask */
-	rd32(wx, WX_PX_IC);
+	rd32(wx, WX_PX_IC(0));
+	rd32(wx, WX_PX_IC(1));
 	rd32(wx, WX_PX_MISC_IC);
 	txgbe_irq_enable(wx, true);
 
-- 
2.27.0

