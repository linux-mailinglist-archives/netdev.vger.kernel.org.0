Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A647C6EBF54
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 14:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjDWMSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 08:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjDWMSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 08:18:02 -0400
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D171723;
        Sun, 23 Apr 2023 05:18:00 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VgjtUoW_1682252276;
Received: from localhost(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VgjtUoW_1682252276)
          by smtp.aliyun-inc.com;
          Sun, 23 Apr 2023 20:17:58 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v5 2/9] net/smc: Decouple ism_dev from SMC-D DMB registration
Date:   Sun, 23 Apr 2023 20:17:44 +0800
Message-Id: <1682252271-2544-3-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1682252271-2544-1-git-send-email-guwen@linux.alibaba.com>
References: <1682252271-2544-1-git-send-email-guwen@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch tries to decouple ISM device from SMC-D DMB registration,
So that the register_dmb option is not restricted to be used by ISM
device.

Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 drivers/s390/net/ism_drv.c | 5 +++--
 include/net/smc.h          | 4 ++--
 net/smc/smc_ism.c          | 7 ++-----
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index 8acb9eb..5eeb54d 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -796,9 +796,10 @@ static int smcd_query_rgid(struct smcd_dev *smcd, u64 rgid, u32 vid_valid,
 }
 
 static int smcd_register_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb,
-			     struct ism_client *client)
+			     void *client_priv)
 {
-	return ism_register_dmb(smcd->priv, (struct ism_dmb *)dmb, client);
+	return ism_register_dmb(smcd->priv, (struct ism_dmb *)dmb,
+				(struct ism_client *)client_priv);
 }
 
 static int smcd_unregister_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
diff --git a/include/net/smc.h b/include/net/smc.h
index 963ce9c..26206d2 100644
--- a/include/net/smc.h
+++ b/include/net/smc.h
@@ -50,13 +50,12 @@ struct smcd_dmb {
 #define ISM_ERROR	0xFFFF
 
 struct smcd_dev;
-struct ism_client;
 
 struct smcd_ops {
 	int (*query_remote_gid)(struct smcd_dev *dev, u64 rgid, u32 vid_valid,
 				u32 vid);
 	int (*register_dmb)(struct smcd_dev *dev, struct smcd_dmb *dmb,
-			    struct ism_client *client);
+			    void *client_priv);
 	int (*unregister_dmb)(struct smcd_dev *dev, struct smcd_dmb *dmb);
 	int (*add_vlan_id)(struct smcd_dev *dev, u64 vlan_id);
 	int (*del_vlan_id)(struct smcd_dev *dev, u64 vlan_id);
@@ -77,6 +76,7 @@ struct smcd_ops {
 struct smcd_dev {
 	const struct smcd_ops *ops;
 	void *priv;
+	void *client_priv;
 	struct device *parent_pci_dev;
 	struct list_head list;
 	spinlock_t lock;
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index 4249fb9..d4709ca 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -200,7 +200,6 @@ int smc_ism_unregister_dmb(struct smcd_dev *smcd, struct smc_buf_desc *dmb_desc)
 int smc_ism_register_dmb(struct smc_link_group *lgr, int dmb_len,
 			 struct smc_buf_desc *dmb_desc)
 {
-#if IS_ENABLED(CONFIG_ISM)
 	struct smcd_dmb dmb;
 	int rc;
 
@@ -209,7 +208,7 @@ int smc_ism_register_dmb(struct smc_link_group *lgr, int dmb_len,
 	dmb.sba_idx = dmb_desc->sba_idx;
 	dmb.vlan_id = lgr->vlan_id;
 	dmb.rgid = lgr->peer_gid;
-	rc = lgr->smcd->ops->register_dmb(lgr->smcd, &dmb, &smc_ism_client);
+	rc = lgr->smcd->ops->register_dmb(lgr->smcd, &dmb, lgr->smcd->client_priv);
 	if (!rc) {
 		dmb_desc->sba_idx = dmb.sba_idx;
 		dmb_desc->token = dmb.dmb_tok;
@@ -218,9 +217,6 @@ int smc_ism_register_dmb(struct smc_link_group *lgr, int dmb_len,
 		dmb_desc->len = dmb.dmb_len;
 	}
 	return rc;
-#else
-	return 0;
-#endif
 }
 
 static int smc_nl_handle_smcd_dev(struct smcd_dev *smcd,
@@ -419,6 +415,7 @@ static void smcd_register_dev(struct ism_dev *ism)
 	if (!smcd)
 		return;
 	smcd->priv = ism;
+	smcd->client_priv = &smc_ism_client;
 	smcd->parent_pci_dev = ism->dev.parent;
 	ism_set_priv(ism, &smc_ism_client, smcd);
 	if (smc_pnetid_by_dev_port(&ism->pdev->dev, 0, smcd->pnetid))
-- 
1.8.3.1

