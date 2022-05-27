Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 878FB535939
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 08:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244633AbiE0GVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 02:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233671AbiE0GU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 02:20:59 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07EF674C2;
        Thu, 26 May 2022 23:20:58 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4L8ZQM3dNPzbbt7;
        Fri, 27 May 2022 14:19:23 +0800 (CST)
Received: from dggpemm500018.china.huawei.com (7.185.36.111) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 27 May 2022 14:20:56 +0800
Received: from localhost.localdomain (10.175.112.125) by
 dggpemm500018.china.huawei.com (7.185.36.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 27 May 2022 14:20:56 +0800
From:   keliu <liuke94@huawei.com>
To:     <krzysztof.kozlowski@linaro.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     keliu <liuke94@huawei.com>
Subject: [PATCH] net: nfc: Directly use ida_alloc()/free()
Date:   Fri, 27 May 2022 06:42:25 +0000
Message-ID: <20220527064225.2358248-1-liuke94@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500018.china.huawei.com (7.185.36.111)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use ida_alloc()/ida_free() instead of deprecated
ida_simple_get()/ida_simple_remove() .

Signed-off-by: keliu <liuke94@huawei.com>
---
 net/nfc/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/nfc/core.c b/net/nfc/core.c
index 5b286e1e0a6f..9a1d61ac40b8 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -975,7 +975,7 @@ static void nfc_release(struct device *d)
 			kfree(se);
 	}
 
-	ida_simple_remove(&nfc_index_ida, dev->idx);
+	ida_free(&nfc_index_ida, dev->idx);
 
 	kfree(dev);
 }
@@ -1066,7 +1066,7 @@ struct nfc_dev *nfc_allocate_device(const struct nfc_ops *ops,
 	if (!dev)
 		return NULL;
 
-	rc = ida_simple_get(&nfc_index_ida, 0, 0, GFP_KERNEL);
+	rc = ida_alloc(&nfc_index_ida, GFP_KERNEL);
 	if (rc < 0)
 		goto err_free_dev;
 	dev->idx = rc;
-- 
2.25.1

