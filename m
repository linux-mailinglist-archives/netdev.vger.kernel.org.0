Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC60669809E
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 17:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbjBOQTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 11:19:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjBOQSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 11:18:48 -0500
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1619539CC3;
        Wed, 15 Feb 2023 08:18:43 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0Vbl3meW_1676477919;
Received: from localhost(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0Vbl3meW_1676477919)
          by smtp.aliyun-inc.com;
          Thu, 16 Feb 2023 00:18:40 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v3 3/9] net/smc: Extract v2 check helper from SMC-D device registration
Date:   Thu, 16 Feb 2023 00:18:19 +0800
Message-Id: <1676477905-88043-4-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1676477905-88043-1-git-send-email-guwen@linux.alibaba.com>
References: <1676477905-88043-1-git-send-email-guwen@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extracts v2-capable logic from the process of registering the
ISM device as an SMC-D device, so that the registration process of other
underlying devices can also use it.

Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/smc_ism.c | 27 +++++++++++++++++----------
 net/smc/smc_ism.h |  1 +
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index 93c7415..9504273 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -69,6 +69,22 @@ bool smc_ism_is_v2_capable(void)
 	return smc_ism_v2_capable;
 }
 
+/* must be called under smcd_dev_list.mutex lock */
+void smc_ism_check_v2_capable(struct smcd_dev *smcd)
+{
+	u8 *system_eid = NULL;
+
+	if (!list_empty(&smcd_dev_list.list))
+		return;
+
+	system_eid = smcd->ops->get_system_eid();
+	if (system_eid[24] != '0' || system_eid[28] != '0') {
+		smc_ism_v2_capable = true;
+		memcpy(smc_ism_v2_system_eid, system_eid,
+		       SMC_MAX_EID_LEN);
+	}
+}
+
 /* Set a connection using this DMBE. */
 void smc_ism_set_conn(struct smc_connection *conn)
 {
@@ -422,16 +438,7 @@ static void smcd_register_dev(struct ism_dev *ism)
 		smc_pnetid_by_table_smcd(smcd);
 
 	mutex_lock(&smcd_dev_list.mutex);
-	if (list_empty(&smcd_dev_list.list)) {
-		u8 *system_eid = NULL;
-
-		system_eid = smcd->ops->get_system_eid();
-		if (system_eid[24] != '0' || system_eid[28] != '0') {
-			smc_ism_v2_capable = true;
-			memcpy(smc_ism_v2_system_eid, system_eid,
-			       SMC_MAX_EID_LEN);
-		}
-	}
+	smc_ism_check_v2_capable(smcd);
 	/* sort list: devices without pnetid before devices with pnetid */
 	if (smcd->pnetid[0])
 		list_add_tail(&smcd->list, &smcd_dev_list.list);
diff --git a/net/smc/smc_ism.h b/net/smc/smc_ism.h
index 832b2f4..14d2e77 100644
--- a/net/smc/smc_ism.h
+++ b/net/smc/smc_ism.h
@@ -42,6 +42,7 @@ int smc_ism_register_dmb(struct smc_link_group *lgr, int buf_size,
 void smc_ism_get_system_eid(u8 **eid);
 u16 smc_ism_get_chid(struct smcd_dev *dev);
 bool smc_ism_is_v2_capable(void);
+void smc_ism_check_v2_capable(struct smcd_dev *dev);
 int smc_ism_init(void);
 void smc_ism_exit(void);
 int smcd_nl_get_device(struct sk_buff *skb, struct netlink_callback *cb);
-- 
1.8.3.1

