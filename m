Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C61915061BD
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 03:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245556AbiDSBkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 21:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245585AbiDSBkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 21:40:22 -0400
Received: from mail.meizu.com (edge05.meizu.com [157.122.146.251])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999D123145;
        Mon, 18 Apr 2022 18:37:39 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail12.meizu.com
 (172.16.1.108) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 19 Apr
 2022 09:37:39 +0800
Received: from meizu.meizu.com (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Tue, 19 Apr
 2022 09:37:37 +0800
From:   Haowen Bai <baihaowen@meizu.com>
To:     Pontus Fuchs <pontus.fuchs@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Haowen Bai <baihaowen@meizu.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ar5523: Use kzalloc instead of kmalloc/memset
Date:   Tue, 19 Apr 2022 09:37:31 +0800
Message-ID: <1650332252-4994-1-git-send-email-baihaowen@meizu.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.137.70]
X-ClientProxiedBy: IT-EXMB-1-126.meizu.com (172.16.1.126) To
 IT-EXMB-1-125.meizu.com (172.16.1.125)
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use kzalloc rather than duplicating its implementation, which
makes code simple and easy to understand.

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
---
 drivers/net/wireless/ath/ar5523/ar5523.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index 00ddeee123c2..9f84a6fde0c2 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -1500,7 +1500,7 @@ static int ar5523_load_firmware(struct usb_device *dev)
 		return -ENOENT;
 	}
 
-	txblock = kmalloc(sizeof(*txblock), GFP_KERNEL);
+	txblock = kzalloc(sizeof(*txblock), GFP_KERNEL);
 	if (!txblock)
 		goto out;
 
@@ -1512,7 +1512,6 @@ static int ar5523_load_firmware(struct usb_device *dev)
 	if (!fwbuf)
 		goto out_free_rxblock;
 
-	memset(txblock, 0, sizeof(struct ar5523_fwblock));
 	txblock->flags = cpu_to_be32(AR5523_WRITE_BLOCK);
 	txblock->total = cpu_to_be32(fw->size);
 
-- 
2.7.4

