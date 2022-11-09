Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45324622637
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 10:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbiKIJF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 04:05:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiKIJFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 04:05:55 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25901E3D8;
        Wed,  9 Nov 2022 01:05:53 -0800 (PST)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N6fFb6fzvz15MTS;
        Wed,  9 Nov 2022 17:05:39 +0800 (CST)
Received: from dggpemm500013.china.huawei.com (7.185.36.172) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 17:05:52 +0800
Received: from ubuntu1804.huawei.com (10.67.175.36) by
 dggpemm500013.china.huawei.com (7.185.36.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 17:05:51 +0800
From:   Chen Zhongjin <chenzhongjin@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <chenzhongjin@huawei.com>
Subject: [PATCH] wifi: cfg80211: Fix not unregister reg_pdev when load_builtin_regdb_keys() fails
Date:   Wed, 9 Nov 2022 17:02:37 +0800
Message-ID: <20221109090237.214127-1-chenzhongjin@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.36]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500013.china.huawei.com (7.185.36.172)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In regulatory_init_db(), when it's going to return a error, reg_pdev
should be unregistered. When load_builtin_regdb_keys() fails it doesn't
do it and makes cfg80211 can't be reload with report:

sysfs: cannot create duplicate filename '/devices/platform/regulatory.0'
 ...
 <TASK>
 dump_stack_lvl+0x79/0x9b
 sysfs_warn_dup.cold+0x1c/0x29
 sysfs_create_dir_ns+0x22d/0x290
 kobject_add_internal+0x247/0x800
 kobject_add+0x135/0x1b0
 device_add+0x389/0x1be0
 platform_device_add+0x28f/0x790
 platform_device_register_full+0x376/0x4b0
 regulatory_init+0x9a/0x4b2 [cfg80211]
 cfg80211_init+0x84/0x113 [cfg80211]
 ...

Fixes: 90a53e4432b1 ("cfg80211: implement regdb signature checking")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
---
 net/wireless/reg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index d5c7a5aa6853..da0cb5abc20f 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -4305,8 +4305,10 @@ static int __init regulatory_init_db(void)
 		return -EINVAL;
 
 	err = load_builtin_regdb_keys();
-	if (err)
+	if (err) {
+		platform_device_unregister(reg_pdev);
 		return err;
+	}
 
 	/* We always try to get an update for the static regdomain */
 	err = regulatory_hint_core(cfg80211_world_regdom->alpha2);
-- 
2.17.1

