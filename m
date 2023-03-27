Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C55356C9A28
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 05:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbjC0D2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 23:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbjC0D2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 23:28:40 -0400
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1855255;
        Sun, 26 Mar 2023 20:28:34 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R541e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VeeviqL_1679887710;
Received: from localhost(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VeeviqL_1679887710)
          by smtp.aliyun-inc.com;
          Mon, 27 Mar 2023 11:28:31 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        wintera@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v4 5/9] net/smc: Introduce an interface for getting DMB attribute
Date:   Mon, 27 Mar 2023 11:28:15 +0800
Message-Id: <1679887699-54797-6-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1679887699-54797-1-git-send-email-guwen@linux.alibaba.com>
References: <1679887699-54797-1-git-send-email-guwen@linux.alibaba.com>
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On s390, since all OSs run on a kind of machine level hypervisor which
is a partitioning hypervisor without paging, the sndbufs and DMBs in
such case are unable to be mapped to the same physical memory.

However, in other scene, such as communication within the same OS instance
(loopback) or between guests of a paging hypervisor (see [1]), eg. KVM,
the sndbufs and DMBs can be mapped to the same physical memory to avoid
memory copy from sndbufs to DMBs.

So this patch introduces an interface to smcd_ops for users to judge
whether DMB-map is available. And for reuse, the interface is designed
to return DMB attribute, not only mappability.

[1] https://lists.oasis-open.org/archives/virtio-comment/202302/msg00148.html

Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 include/net/smc.h | 5 +++++
 net/smc/smc_ism.c | 8 ++++++++
 net/smc/smc_ism.h | 1 +
 3 files changed, 14 insertions(+)

diff --git a/include/net/smc.h b/include/net/smc.h
index 021ca42..e39ac41 100644
--- a/include/net/smc.h
+++ b/include/net/smc.h
@@ -55,6 +55,10 @@ struct smcd_seid {
 
 #define ISM_ERROR	0xFFFF
 
+enum {
+	ISM_DMB_MAPPABLE = 0,
+};
+
 struct smcd_dev;
 
 struct smcd_ops {
@@ -77,6 +81,7 @@ struct smcd_ops {
 	u64 (*get_local_gid)(struct smcd_dev *dev);
 	u16 (*get_chid)(struct smcd_dev *dev);
 	struct device* (*get_dev)(struct smcd_dev *dev);
+	int (*get_dev_dmb_attr)(struct smcd_dev *dev);
 };
 
 struct smcd_dev {
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index f638999..a21c867 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -233,6 +233,14 @@ int smc_ism_unregister_dmb(struct smcd_dev *smcd, struct smc_buf_desc *dmb_desc)
 	return rc;
 }
 
+bool smc_ism_dmb_mappable(struct smcd_dev *smcd)
+{
+	if (smcd->ops->get_dev_dmb_attr &&
+	    (smcd->ops->get_dev_dmb_attr(smcd) & (1 << ISM_DMB_MAPPABLE)))
+		return true;
+	return false;
+}
+
 int smc_ism_register_dmb(struct smc_link_group *lgr, int dmb_len,
 			 struct smc_buf_desc *dmb_desc)
 {
diff --git a/net/smc/smc_ism.h b/net/smc/smc_ism.h
index 870ff7b..0ddaa45 100644
--- a/net/smc/smc_ism.h
+++ b/net/smc/smc_ism.h
@@ -39,6 +39,7 @@ struct smc_ism_vlanid {			/* VLAN id set on ISM device */
 int smc_ism_register_dmb(struct smc_link_group *lgr, int buf_size,
 			 struct smc_buf_desc *dmb_desc);
 int smc_ism_unregister_dmb(struct smcd_dev *dev, struct smc_buf_desc *dmb_desc);
+bool smc_ism_dmb_mappable(struct smcd_dev *smcd);
 int smc_ism_signal_shutdown(struct smc_link_group *lgr);
 void smc_ism_get_system_eid(u8 **eid);
 u16 smc_ism_get_chid(struct smcd_dev *dev);
-- 
1.8.3.1

