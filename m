Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496B3524561
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 08:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350131AbiELGJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 02:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350110AbiELGJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 02:09:20 -0400
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2EDC104C83;
        Wed, 11 May 2022 23:09:16 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VCzTSH7_1652335746;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VCzTSH7_1652335746)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 12 May 2022 14:09:14 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     wellslutw@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, p.zabel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH v2] net: ethernet: Use swap() instead of open coding it
Date:   Thu, 12 May 2022 14:09:05 +0800
Message-Id: <20220512060905.33744-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean the following coccicheck warning:

./drivers/net/ethernet/sunplus/spl2sw_driver.c:217:27-28: WARNING
opportunity for swap().

./drivers/net/ethernet/sunplus/spl2sw_driver.c:222:27-28: WARNING
opportunity for swap().

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
Changes in v2:
  -Delete useless comments.

 drivers/net/ethernet/sunplus/spl2sw_driver.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/sunplus/spl2sw_driver.c b/drivers/net/ethernet/sunplus/spl2sw_driver.c
index 8320fa833d3e..1cb7076f946d 100644
--- a/drivers/net/ethernet/sunplus/spl2sw_driver.c
+++ b/drivers/net/ethernet/sunplus/spl2sw_driver.c
@@ -204,28 +204,16 @@ static const struct net_device_ops netdev_ops = {
 
 static void spl2sw_check_mac_vendor_id_and_convert(u8 *mac_addr)
 {
-	u8 tmp;
-
 	/* Byte order of MAC address of some samples are reversed.
 	 * Check vendor id and convert byte order if it is wrong.
 	 * OUI of Sunplus: fc:4b:bc
 	 */
 	if (mac_addr[5] == 0xfc && mac_addr[4] == 0x4b && mac_addr[3] == 0xbc &&
 	    (mac_addr[0] != 0xfc || mac_addr[1] != 0x4b || mac_addr[2] != 0xbc)) {
-		/* Swap mac_addr[0] and mac_addr[5] */
-		tmp = mac_addr[0];
-		mac_addr[0] = mac_addr[5];
-		mac_addr[5] = tmp;
-
-		/* Swap mac_addr[1] and mac_addr[4] */
-		tmp = mac_addr[1];
-		mac_addr[1] = mac_addr[4];
-		mac_addr[4] = tmp;
-
-		/* Swap mac_addr[2] and mac_addr[3] */
-		tmp = mac_addr[2];
-		mac_addr[2] = mac_addr[3];
-		mac_addr[3] = tmp;
+
+		swap(mac_addr[0], mac_addr[5]);
+		swap(mac_addr[1], mac_addr[4]);
+		swap(mac_addr[2], mac_addr[3]);
 	}
 }
 
-- 
2.20.1.7.g153144c

