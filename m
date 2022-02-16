Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8DDF4B7CD2
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 02:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245565AbiBPBpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 20:45:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244340AbiBPBpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 20:45:23 -0500
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E6DF9FB4;
        Tue, 15 Feb 2022 17:45:11 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R421e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V4akc2F_1644975908;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0V4akc2F_1644975908)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 16 Feb 2022 09:45:09 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, josright123@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] net: Fix an ignored error return from dm9051_get_regs()
Date:   Wed, 16 Feb 2022 09:45:07 +0800
Message-Id: <20220216014507.109117-1-yang.lee@linux.alibaba.com>
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

The return from the call to dm9051_get_regs() is int, it can be
a negative error code, however this is being assigned to an unsigned
int variable 'ret', so making 'ret' an int.

Eliminate the following coccicheck warning:
./drivers/net/ethernet/davicom/dm9051.c:527:5-8: WARNING: Unsigned
expression compared with zero: ret < 0

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/ethernet/davicom/dm9051.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/davicom/dm9051.c b/drivers/net/ethernet/davicom/dm9051.c
index d2513c97f83e..8984363624eb 100644
--- a/drivers/net/ethernet/davicom/dm9051.c
+++ b/drivers/net/ethernet/davicom/dm9051.c
@@ -519,7 +519,7 @@ static int dm9051_map_init(struct spi_device *spi, struct board_info *db)
 static int dm9051_map_chipid(struct board_info *db)
 {
 	struct device *dev = &db->spidev->dev;
-	unsigned int ret;
+	int ret;
 	unsigned short wid;
 	u8 buff[6];
 
-- 
2.20.1.7.g153144c

