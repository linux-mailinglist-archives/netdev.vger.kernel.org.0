Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B038D6055B4
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 05:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiJTDCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 23:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiJTDB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 23:01:59 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876B816D89C
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 20:01:57 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MtC700sYQzHtw1;
        Thu, 20 Oct 2022 11:01:48 +0800 (CST)
Received: from kwepemm600008.china.huawei.com (7.193.23.88) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 20 Oct 2022 11:01:20 +0800
Received: from huawei.com (10.175.100.227) by kwepemm600008.china.huawei.com
 (7.193.23.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 20 Oct
 2022 11:01:20 +0800
From:   Shang XiaoJing <shangxiaojing@huawei.com>
To:     <bongsu.jeon@samsung.com>, <krzysztof.kozlowski@linaro.org>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     <shangxiaojing@huawei.com>
Subject: [PATCH] mm/slub: Fix memory leak in sysfs_slab_add()
Date:   Thu, 20 Oct 2022 11:00:35 +0800
Message-ID: <20221020030035.30075-1-shangxiaojing@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.227]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600008.china.huawei.com (7.193.23.88)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Liu Shixin <liushixin2@huawei.com>

temporary scheme

Signed-off-by: Liu Shixin <liushixin2@huawei.com>
---
 mm/slub.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index 4b98dff9be8e..3e19320aa162 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5980,6 +5980,10 @@ static int sysfs_slab_add(struct kmem_cache *s)
 out:
 	if (!unmergeable)
 		kfree(name);
+	if (err && s->kobj.name) {
+		pr_err("need free kobject.name\n");
+		kfree_const(s->kobj.name);
+	}
 	return err;
 out_del_kobj:
 	kobject_del(&s->kobj);
-- 
2.25.1

