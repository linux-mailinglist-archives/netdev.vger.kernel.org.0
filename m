Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91232610B5B
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 09:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbiJ1HgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 03:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiJ1HgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 03:36:02 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D50FA2A97
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 00:36:01 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MzDmQ22FQzJnK9;
        Fri, 28 Oct 2022 15:33:10 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 28 Oct 2022 15:35:58 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 28 Oct
 2022 15:35:58 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <davem@davemloft.net>, <leon@kernel.org>, <kuba@kernel.org>
Subject: [PATCH net-next] net: hns: hnae: remove unnecessary __module_get() and module_put()
Date:   Fri, 28 Oct 2022 15:34:57 +0800
Message-ID: <20221028073457.3492371-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hnae_ae_register() is called from hns_dsaf_probe(), the refcount of
module hnae has already be got in resolve_symbol() while calling the
function, so the __module_get()/module_put() can be removed.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns/hnae.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hnae.c b/drivers/net/ethernet/hisilicon/hns/hnae.c
index 430eccea8e5e..9b26f0f2c748 100644
--- a/drivers/net/ethernet/hisilicon/hns/hnae.c
+++ b/drivers/net/ethernet/hisilicon/hns/hnae.c
@@ -424,8 +424,6 @@ int hnae_ae_register(struct hnae_ae_dev *hdev, struct module *owner)
 		return ret;
 	}
 
-	__module_get(THIS_MODULE);
-
 	INIT_LIST_HEAD(&hdev->handle_list);
 	spin_lock_init(&hdev->lock);
 
@@ -445,7 +443,6 @@ EXPORT_SYMBOL(hnae_ae_register);
 void hnae_ae_unregister(struct hnae_ae_dev *hdev)
 {
 	device_unregister(&hdev->cls_dev);
-	module_put(THIS_MODULE);
 }
 EXPORT_SYMBOL(hnae_ae_unregister);
 
-- 
2.25.1

