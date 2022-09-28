Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 363295EDB97
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 13:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbiI1LTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 07:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbiI1LTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 07:19:31 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8D3A8964
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 04:19:30 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Mcv6S35Bfz1P6fy;
        Wed, 28 Sep 2022 19:15:12 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 19:19:28 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <j.vosburgh@gmail.com>, <vfalico@gmail.com>, <andy@greyhouse.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>
Subject: [net-next] net: bonding: Convert to use sysfs_emit() APIs
Date:   Wed, 28 Sep 2022 19:40:22 +0800
Message-ID: <1664365222-30004-1-git-send-email-wangyufen@huawei.com>
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
 drivers/net/bonding/bond_sysfs_slave.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/bonding/bond_sysfs_slave.c b/drivers/net/bonding/bond_sysfs_slave.c
index 69b0a37..6cc53d2 100644
--- a/drivers/net/bonding/bond_sysfs_slave.c
+++ b/drivers/net/bonding/bond_sysfs_slave.c
@@ -22,30 +22,30 @@ static ssize_t state_show(struct slave *slave, char *buf)
 {
 	switch (bond_slave_state(slave)) {
 	case BOND_STATE_ACTIVE:
-		return sprintf(buf, "active\n");
+		return sysfs_emit(buf, "active\n");
 	case BOND_STATE_BACKUP:
-		return sprintf(buf, "backup\n");
+		return sysfs_emit(buf, "backup\n");
 	default:
-		return sprintf(buf, "UNKNOWN\n");
+		return sysfs_emit(buf, "UNKNOWN\n");
 	}
 }
 static SLAVE_ATTR_RO(state);
 
 static ssize_t mii_status_show(struct slave *slave, char *buf)
 {
-	return sprintf(buf, "%s\n", bond_slave_link_status(slave->link));
+	return sysfs_emit(buf, "%s\n", bond_slave_link_status(slave->link));
 }
 static SLAVE_ATTR_RO(mii_status);
 
 static ssize_t link_failure_count_show(struct slave *slave, char *buf)
 {
-	return sprintf(buf, "%d\n", slave->link_failure_count);
+	return sysfs_emit(buf, "%d\n", slave->link_failure_count);
 }
 static SLAVE_ATTR_RO(link_failure_count);
 
 static ssize_t perm_hwaddr_show(struct slave *slave, char *buf)
 {
-	return sprintf(buf, "%*phC\n",
+	return sysfs_emit(buf, "%*phC\n",
 		       slave->dev->addr_len,
 		       slave->perm_hwaddr);
 }
@@ -53,7 +53,7 @@ static ssize_t perm_hwaddr_show(struct slave *slave, char *buf)
 
 static ssize_t queue_id_show(struct slave *slave, char *buf)
 {
-	return sprintf(buf, "%d\n", slave->queue_id);
+	return sysfs_emit(buf, "%d\n", slave->queue_id);
 }
 static SLAVE_ATTR_RO(queue_id);
 
@@ -68,7 +68,7 @@ static ssize_t ad_aggregator_id_show(struct slave *slave, char *buf)
 				       agg->aggregator_identifier);
 	}
 
-	return sprintf(buf, "N/A\n");
+	return sysfs_emit(buf, "N/A\n");
 }
 static SLAVE_ATTR_RO(ad_aggregator_id);
 
@@ -79,11 +79,11 @@ static ssize_t ad_actor_oper_port_state_show(struct slave *slave, char *buf)
 	if (BOND_MODE(slave->bond) == BOND_MODE_8023AD) {
 		ad_port = &SLAVE_AD_INFO(slave)->port;
 		if (ad_port->aggregator)
-			return sprintf(buf, "%u\n",
+			return sysfs_emit(buf, "%u\n",
 				       ad_port->actor_oper_port_state);
 	}
 
-	return sprintf(buf, "N/A\n");
+	return sysfs_emit(buf, "N/A\n");
 }
 static SLAVE_ATTR_RO(ad_actor_oper_port_state);
 
@@ -94,11 +94,11 @@ static ssize_t ad_partner_oper_port_state_show(struct slave *slave, char *buf)
 	if (BOND_MODE(slave->bond) == BOND_MODE_8023AD) {
 		ad_port = &SLAVE_AD_INFO(slave)->port;
 		if (ad_port->aggregator)
-			return sprintf(buf, "%u\n",
+			return sysfs_emit(buf, "%u\n",
 				       ad_port->partner_oper.port_state);
 	}
 
-	return sprintf(buf, "N/A\n");
+	return sysfs_emit(buf, "N/A\n");
 }
 static SLAVE_ATTR_RO(ad_partner_oper_port_state);
 
-- 
1.8.3.1

