Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A31365EDBBF
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 13:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbiI1L2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 07:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiI1L2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 07:28:54 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D815BA3D20
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 04:28:52 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4McvKG49PBzlVk5;
        Wed, 28 Sep 2022 19:24:34 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 19:28:50 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>
Subject: [net-next 1/2] net: tun: Convert to use sysfs_emit() APIs
Date:   Wed, 28 Sep 2022 19:49:43 +0800
Message-ID: <1664365784-31179-1-git-send-email-wangyufen@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follow the advice of the Documentation/filesystems/sysfs.rst and show()
should only use sysfs_emit() or sysfs_emit_at() when formatting the value
to be returned to user space.

Signed-off-by: Wang Yufen <wangyufen@huawei.com>
---
 drivers/net/tun.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 3732e51..4b31da6 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2664,7 +2664,7 @@ static ssize_t tun_flags_show(struct device *dev, struct device_attribute *attr,
 			      char *buf)
 {
 	struct tun_struct *tun = netdev_priv(to_net_dev(dev));
-	return sprintf(buf, "0x%x\n", tun_flags(tun));
+	return sysfs_emit(buf, "0x%x\n", tun_flags(tun));
 }
 
 static ssize_t owner_show(struct device *dev, struct device_attribute *attr,
@@ -2672,9 +2672,9 @@ static ssize_t owner_show(struct device *dev, struct device_attribute *attr,
 {
 	struct tun_struct *tun = netdev_priv(to_net_dev(dev));
 	return uid_valid(tun->owner)?
-		sprintf(buf, "%u\n",
-			from_kuid_munged(current_user_ns(), tun->owner)):
-		sprintf(buf, "-1\n");
+		sysfs_emit(buf, "%u\n",
+			   from_kuid_munged(current_user_ns(), tun->owner)) :
+		sysfs_emit(buf, "-1\n");
 }
 
 static ssize_t group_show(struct device *dev, struct device_attribute *attr,
@@ -2682,9 +2682,9 @@ static ssize_t group_show(struct device *dev, struct device_attribute *attr,
 {
 	struct tun_struct *tun = netdev_priv(to_net_dev(dev));
 	return gid_valid(tun->group) ?
-		sprintf(buf, "%u\n",
-			from_kgid_munged(current_user_ns(), tun->group)):
-		sprintf(buf, "-1\n");
+		sysfs_emit(buf, "%u\n",
+			   from_kgid_munged(current_user_ns(), tun->group)) :
+		sysfs_emit(buf, "-1\n");
 }
 
 static DEVICE_ATTR_RO(tun_flags);
-- 
1.8.3.1

