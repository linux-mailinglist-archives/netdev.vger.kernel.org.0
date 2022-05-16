Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60624527D93
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 08:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234525AbiEPG1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 02:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235673AbiEPG12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 02:27:28 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE27E2611C;
        Sun, 15 May 2022 23:27:25 -0700 (PDT)
Received: from kwepemi500015.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4L1q614v33zgY7h;
        Mon, 16 May 2022 14:26:49 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemi500015.china.huawei.com
 (7.221.188.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 16 May
 2022 14:27:22 +0800
From:   Lu Wei <luwei32@huawei.com>
To:     <jreuter@yaina.de>, <ralf@linux-mips.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-hams@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] ax25: merge repeat codes in ax25_dev_device_down()
Date:   Mon, 16 May 2022 14:28:04 +0800
Message-ID: <20220516062804.254742-1-luwei32@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500015.china.huawei.com (7.221.188.92)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Merge repeat codes to reduce the duplication.

Signed-off-by: Lu Wei <luwei32@huawei.com>
---
 net/ax25/ax25_dev.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
index d2a244e1c260..b80fccbac62a 100644
--- a/net/ax25/ax25_dev.c
+++ b/net/ax25/ax25_dev.c
@@ -115,23 +115,13 @@ void ax25_dev_device_down(struct net_device *dev)
 
 	if ((s = ax25_dev_list) == ax25_dev) {
 		ax25_dev_list = s->next;
-		spin_unlock_bh(&ax25_dev_lock);
-		ax25_dev_put(ax25_dev);
-		dev->ax25_ptr = NULL;
-		dev_put_track(dev, &ax25_dev->dev_tracker);
-		ax25_dev_put(ax25_dev);
-		return;
+		goto unlock_put;
 	}
 
 	while (s != NULL && s->next != NULL) {
 		if (s->next == ax25_dev) {
 			s->next = ax25_dev->next;
-			spin_unlock_bh(&ax25_dev_lock);
-			ax25_dev_put(ax25_dev);
-			dev->ax25_ptr = NULL;
-			dev_put_track(dev, &ax25_dev->dev_tracker);
-			ax25_dev_put(ax25_dev);
-			return;
+			goto unlock_put;
 		}
 
 		s = s->next;
@@ -139,6 +129,14 @@ void ax25_dev_device_down(struct net_device *dev)
 	spin_unlock_bh(&ax25_dev_lock);
 	dev->ax25_ptr = NULL;
 	ax25_dev_put(ax25_dev);
+	return;
+
+unlock_put:
+	spin_unlock_bh(&ax25_dev_lock);
+	ax25_dev_put(ax25_dev);
+	dev->ax25_ptr = NULL;
+	dev_put_track(dev, &ax25_dev->dev_tracker);
+	ax25_dev_put(ax25_dev);
 }
 
 int ax25_fwd_ioctl(unsigned int cmd, struct ax25_fwd_struct *fwd)
-- 
2.17.1

