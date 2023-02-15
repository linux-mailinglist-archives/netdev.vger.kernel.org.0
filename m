Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE556980AC
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 17:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbjBOQTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 11:19:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjBOQSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 11:18:53 -0500
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B643B0E8;
        Wed, 15 Feb 2023 08:18:50 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R931e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0Vbl3P-7_1676477924;
Received: from localhost(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0Vbl3P-7_1676477924)
          by smtp.aliyun-inc.com;
          Thu, 16 Feb 2023 00:18:45 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v3 6/9] net/smc: Introudce interfaces for DMB attach and detach
Date:   Thu, 16 Feb 2023 00:18:22 +0800
Message-Id: <1676477905-88043-7-git-send-email-guwen@linux.alibaba.com>
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

This patch extends smcd_ops, adding two more semantic for SMC-D DMB:

- attach_dmb:
  Attach an already registered DMB to a specific buf_desc, so that we
  can refer to the DMB through this buf_desc.

- detach_dmb:
  Reverse operation of attach_dmb. detach the DMB from the buf_desc.

This interface extension is to prepare for the avoidance of memory
copy from sndbuf to DMB with SMC-D device whose DMBs has ISM_DMB_MAPPABLE
attribute.

Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 include/net/smc.h |  2 ++
 net/smc/smc_ism.c | 31 +++++++++++++++++++++++++++++++
 net/smc/smc_ism.h |  2 ++
 3 files changed, 35 insertions(+)

diff --git a/include/net/smc.h b/include/net/smc.h
index 256d600..0790e64 100644
--- a/include/net/smc.h
+++ b/include/net/smc.h
@@ -67,6 +67,8 @@ struct smcd_ops {
 	int (*register_dmb)(struct smcd_dev *dev, struct smcd_dmb *dmb,
 			    void *client_priv);
 	int (*unregister_dmb)(struct smcd_dev *dev, struct smcd_dmb *dmb);
+	int (*attach_dmb)(struct smcd_dev *dev, struct smcd_dmb *dmb);
+	int (*detach_dmb)(struct smcd_dev *dev, u64 token);
 	int (*add_vlan_id)(struct smcd_dev *dev, u64 vlan_id);
 	int (*del_vlan_id)(struct smcd_dev *dev, u64 vlan_id);
 	int (*set_vlan_required)(struct smcd_dev *dev);
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index e085c48..e2670e3 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -243,6 +243,37 @@ int smc_ism_register_dmb(struct smc_link_group *lgr, int dmb_len,
 	return rc;
 }
 
+int smc_ism_attach_dmb(struct smcd_dev *dev, u64 token,
+		       struct smc_buf_desc *dmb_desc)
+{
+	struct smcd_dmb dmb;
+	int rc = 0;
+
+	memset(&dmb, 0, sizeof(dmb));
+	dmb.dmb_tok = token;
+
+	if (!dev->ops->attach_dmb)
+		return -EINVAL;
+
+	rc = dev->ops->attach_dmb(dev, &dmb);
+	if (!rc) {
+		dmb_desc->sba_idx = dmb.sba_idx;
+		dmb_desc->token = dmb.dmb_tok;
+		dmb_desc->cpu_addr = dmb.cpu_addr;
+		dmb_desc->dma_addr = dmb.dma_addr;
+		dmb_desc->len = dmb.dmb_len;
+	}
+	return rc;
+}
+
+int smc_ism_detach_dmb(struct smcd_dev *dev, u64 token)
+{
+	if (!dev->ops->detach_dmb)
+		return -EINVAL;
+
+	return dev->ops->detach_dmb(dev, token);
+}
+
 static int smc_nl_handle_smcd_dev(struct smcd_dev *smcd,
 				  struct sk_buff *skb,
 				  struct netlink_callback *cb)
diff --git a/net/smc/smc_ism.h b/net/smc/smc_ism.h
index aabea35..fc16dc2 100644
--- a/net/smc/smc_ism.h
+++ b/net/smc/smc_ism.h
@@ -39,6 +39,8 @@ int smc_ism_register_dmb(struct smc_link_group *lgr, int buf_size,
 			 struct smc_buf_desc *dmb_desc);
 int smc_ism_unregister_dmb(struct smcd_dev *dev, struct smc_buf_desc *dmb_desc);
 bool smc_ism_dmb_mappable(struct smcd_dev *smcd);
+int smc_ism_attach_dmb(struct smcd_dev *dev, u64 token, struct smc_buf_desc *dmb_desc);
+int smc_ism_detach_dmb(struct smcd_dev *dev, u64 token);
 int smc_ism_signal_shutdown(struct smc_link_group *lgr);
 void smc_ism_get_system_eid(u8 **eid);
 u16 smc_ism_get_chid(struct smcd_dev *dev);
-- 
1.8.3.1

