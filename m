Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9104E69809B
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 17:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjBOQS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 11:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjBOQSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 11:18:48 -0500
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4059B2FCC7;
        Wed, 15 Feb 2023 08:18:41 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R941e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0Vbl3Oxi_1676477916;
Received: from localhost(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0Vbl3Oxi_1676477916)
          by smtp.aliyun-inc.com;
          Thu, 16 Feb 2023 00:18:37 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v3 1/9] net/smc: Decouple ism_dev from SMC-D device dump
Date:   Thu, 16 Feb 2023 00:18:17 +0800
Message-Id: <1676477905-88043-2-git-send-email-guwen@linux.alibaba.com>
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

This patch helps to decouple SMC-D device and ISM device, allowing
different underlying device forms, such as non-PCI devices.

Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 include/net/smc.h | 1 +
 net/smc/smc_ism.c | 6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/net/smc.h b/include/net/smc.h
index 597cb93..debf126 100644
--- a/include/net/smc.h
+++ b/include/net/smc.h
@@ -76,6 +76,7 @@ struct smcd_ops {
 struct smcd_dev {
 	const struct smcd_ops *ops;
 	void *priv;
+	struct device *parent_pci_dev;
 	struct list_head list;
 	spinlock_t lock;
 	struct smc_connection **conn;
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index 3b0b771..8023bb0 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -231,11 +231,9 @@ static int smc_nl_handle_smcd_dev(struct smcd_dev *smcd,
 	struct smc_pci_dev smc_pci_dev;
 	struct nlattr *port_attrs;
 	struct nlattr *attrs;
-	struct ism_dev *ism;
 	int use_cnt = 0;
 	void *nlh;
 
-	ism = smcd->priv;
 	nlh = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
 			  &smc_gen_nl_family, NLM_F_MULTI,
 			  SMC_NETLINK_GET_DEV_SMCD);
@@ -250,7 +248,8 @@ static int smc_nl_handle_smcd_dev(struct smcd_dev *smcd,
 	if (nla_put_u8(skb, SMC_NLA_DEV_IS_CRIT, use_cnt > 0))
 		goto errattr;
 	memset(&smc_pci_dev, 0, sizeof(smc_pci_dev));
-	smc_set_pci_values(to_pci_dev(ism->dev.parent), &smc_pci_dev);
+	if (smcd->parent_pci_dev)
+		smc_set_pci_values(to_pci_dev(smcd->parent_pci_dev), &smc_pci_dev);
 	if (nla_put_u32(skb, SMC_NLA_DEV_PCI_FID, smc_pci_dev.pci_fid))
 		goto errattr;
 	if (nla_put_u16(skb, SMC_NLA_DEV_PCI_CHID, smc_pci_dev.pci_pchid))
@@ -420,6 +419,7 @@ static void smcd_register_dev(struct ism_dev *ism)
 	if (!smcd)
 		return;
 	smcd->priv = ism;
+	smcd->parent_pci_dev = ism->dev.parent;
 	ism_set_priv(ism, &smc_ism_client, smcd);
 	if (smc_pnetid_by_dev_port(&ism->pdev->dev, 0, smcd->pnetid))
 		smc_pnetid_by_table_smcd(smcd);
-- 
1.8.3.1

