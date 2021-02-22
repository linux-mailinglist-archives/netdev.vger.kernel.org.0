Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933593211BA
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 09:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbhBVIDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 03:03:11 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:59455 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230390AbhBVIDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 03:03:07 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UPCfV1._1613980943;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UPCfV1._1613980943)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 22 Feb 2021 16:02:23 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     mpe@ellerman.id.au
Cc:     benh@kernel.crashing.org, paulus@samba.org, cforno12@linux.ibm.com,
        davem@davemloft.net, kuba@kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] ibmveth: Switch to using the new API kobj_to_dev()
Date:   Mon, 22 Feb 2021 16:02:21 +0800
Message-Id: <1613980941-45992-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fixed the following coccicheck:
./drivers/net/ethernet/ibm/ibmveth.c:1805:51-52: WARNING opportunity for
kobj_to_dev()

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/ethernet/ibm/ibmveth.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index c3ec9ce..6e9572c 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1801,8 +1801,7 @@ static ssize_t veth_pool_store(struct kobject *kobj, struct attribute *attr,
 	struct ibmveth_buff_pool *pool = container_of(kobj,
 						      struct ibmveth_buff_pool,
 						      kobj);
-	struct net_device *netdev = dev_get_drvdata(
-	    container_of(kobj->parent, struct device, kobj));
+	struct net_device *netdev = dev_get_drvdata(kobj_to_dev(kobj->parent));
 	struct ibmveth_adapter *adapter = netdev_priv(netdev);
 	long value = simple_strtol(buf, NULL, 10);
 	long rc;
-- 
1.8.3.1

