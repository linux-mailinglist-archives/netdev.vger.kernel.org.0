Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03D0524360
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 05:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344185AbiELDYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 23:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238977AbiELDYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 23:24:53 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945BF5D67C;
        Wed, 11 May 2022 20:24:51 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R431e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VCykjJ9_1652325870;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VCykjJ9_1652325870)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 12 May 2022 11:24:49 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     wellslutw@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, p.zabel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] net: ethernet: Use swap() instead of open coding it
Date:   Thu, 12 May 2022 11:24:29 +0800
Message-Id: <20220512032429.94306-1-jiapeng.chong@linux.alibaba.com>
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
 drivers/net/ethernet/sunplus/spl2sw_driver.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/sunplus/spl2sw_driver.c b/drivers/net/ethernet/sunplus/spl2sw_driver.c
index 8320fa833d3e..cccf14325ba8 100644
--- a/drivers/net/ethernet/sunplus/spl2sw_driver.c
+++ b/drivers/net/ethernet/sunplus/spl2sw_driver.c
@@ -204,8 +204,6 @@ static const struct net_device_ops netdev_ops = {
 
 static void spl2sw_check_mac_vendor_id_and_convert(u8 *mac_addr)
 {
-	u8 tmp;
-
 	/* Byte order of MAC address of some samples are reversed.
 	 * Check vendor id and convert byte order if it is wrong.
 	 * OUI of Sunplus: fc:4b:bc
@@ -213,19 +211,13 @@ static void spl2sw_check_mac_vendor_id_and_convert(u8 *mac_addr)
 	if (mac_addr[5] == 0xfc && mac_addr[4] == 0x4b && mac_addr[3] == 0xbc &&
 	    (mac_addr[0] != 0xfc || mac_addr[1] != 0x4b || mac_addr[2] != 0xbc)) {
 		/* Swap mac_addr[0] and mac_addr[5] */
-		tmp = mac_addr[0];
-		mac_addr[0] = mac_addr[5];
-		mac_addr[5] = tmp;
+		swap(mac_addr[0], mac_addr[5]);
 
 		/* Swap mac_addr[1] and mac_addr[4] */
-		tmp = mac_addr[1];
-		mac_addr[1] = mac_addr[4];
-		mac_addr[4] = tmp;
+		swap(mac_addr[1], mac_addr[4]);
 
 		/* Swap mac_addr[2] and mac_addr[3] */
-		tmp = mac_addr[2];
-		mac_addr[2] = mac_addr[3];
-		mac_addr[3] = tmp;
+		swap(mac_addr[2], mac_addr[3]);
 	}
 }
 
-- 
2.20.1.7.g153144c

