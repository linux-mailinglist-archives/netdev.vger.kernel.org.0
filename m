Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0ADE6C9A24
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 05:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbjC0D2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 23:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231891AbjC0D2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 23:28:36 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405FB5244;
        Sun, 26 Mar 2023 20:28:33 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0Veevipl_1679887708;
Received: from localhost(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0Veevipl_1679887708)
          by smtp.aliyun-inc.com;
          Mon, 27 Mar 2023 11:28:29 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        wintera@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v4 4/9] net/smc: Introduce SMC-D loopback device
Date:   Mon, 27 Mar 2023 11:28:14 +0800
Message-Id: <1679887699-54797-5-git-send-email-guwen@linux.alibaba.com>
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

This patch introduces a kind of loopback device for SMC-D, thus
enabling the SMC communication between two local sockets within
one OS instance.

The loopback device supports basic capabilities defined by SMC-D
options, and exposed as an SMC-D v2 device.

The GID of loopback device is random generated, CHID is 0xFFFF
and SEID is SMCD_DEFAULT_V2_SEID.

TODO:
- The hierarchy preference of coexistent SMC-D devices.

Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 include/net/smc.h      |   6 +
 net/smc/Makefile       |   2 +-
 net/smc/af_smc.c       |  12 +-
 net/smc/smc_cdc.c      |   9 +-
 net/smc/smc_cdc.h      |   1 +
 net/smc/smc_ism.c      |  20 +++
 net/smc/smc_ism.h      |   1 +
 net/smc/smc_loopback.c | 360 +++++++++++++++++++++++++++++++++++++++++++++++++
 net/smc/smc_loopback.h |  51 +++++++
 9 files changed, 459 insertions(+), 3 deletions(-)
 create mode 100644 net/smc/smc_loopback.c
 create mode 100644 net/smc/smc_loopback.h

diff --git a/include/net/smc.h b/include/net/smc.h
index 26206d2..021ca42 100644
--- a/include/net/smc.h
+++ b/include/net/smc.h
@@ -41,6 +41,12 @@ struct smcd_dmb {
 	dma_addr_t dma_addr;
 };
 
+struct smcd_seid {
+	u8 seid_string[24];
+	u8 serial_number[4];
+	u8 type[4];
+};
+
 #define ISM_EVENT_DMB	0
 #define ISM_EVENT_GID	1
 #define ISM_EVENT_SWR	2
diff --git a/net/smc/Makefile b/net/smc/Makefile
index 875efcd..a8c3711 100644
--- a/net/smc/Makefile
+++ b/net/smc/Makefile
@@ -4,5 +4,5 @@ obj-$(CONFIG_SMC)	+= smc.o
 obj-$(CONFIG_SMC_DIAG)	+= smc_diag.o
 smc-y := af_smc.o smc_pnet.o smc_ib.o smc_clc.o smc_core.o smc_wr.o smc_llc.o
 smc-y += smc_cdc.o smc_tx.o smc_rx.o smc_close.o smc_ism.o smc_netlink.o smc_stats.o
-smc-y += smc_tracepoint.o
+smc-y += smc_tracepoint.o smc_loopback.o
 smc-$(CONFIG_SYSCTL) += smc_sysctl.o
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index c6b4a62..c91600a 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -53,6 +53,7 @@
 #include "smc_stats.h"
 #include "smc_tracepoint.h"
 #include "smc_sysctl.h"
+#include "smc_loopback.h"
 
 static DEFINE_MUTEX(smc_server_lgr_pending);	/* serialize link group
 						 * creation on server
@@ -3471,15 +3472,23 @@ static int __init smc_init(void)
 		goto out_sock;
 	}
 
+	rc = smc_loopback_init();
+	if (rc) {
+		pr_err("%s: smc_loopback_init fails with %d\n", __func__, rc);
+		goto out_ib;
+	}
+
 	rc = tcp_register_ulp(&smc_ulp_ops);
 	if (rc) {
 		pr_err("%s: tcp_ulp_register fails with %d\n", __func__, rc);
-		goto out_ib;
+		goto out_lo;
 	}
 
 	static_branch_enable(&tcp_have_smc);
 	return 0;
 
+out_lo:
+	smc_loopback_exit();
 out_ib:
 	smc_ib_unregister_client();
 out_sock:
@@ -3517,6 +3526,7 @@ static void __exit smc_exit(void)
 	tcp_unregister_ulp(&smc_ulp_ops);
 	sock_unregister(PF_SMC);
 	smc_core_exit();
+	smc_loopback_exit();
 	smc_ib_unregister_client();
 	smc_ism_exit();
 	destroy_workqueue(smc_close_wq);
diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index 89105e9..2f79bac 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -410,7 +410,14 @@ static void smc_cdc_msg_recv(struct smc_sock *smc, struct smc_cdc_msg *cdc)
  */
 static void smcd_cdc_rx_tsklet(struct tasklet_struct *t)
 {
-	struct smc_connection *conn = from_tasklet(conn, t, rx_tsklet);
+	struct smc_connection *conn =
+		from_tasklet(conn, t, rx_tsklet);
+
+	smcd_cdc_rx_handler(conn);
+}
+
+void smcd_cdc_rx_handler(struct smc_connection *conn)
+{
 	struct smcd_cdc_msg *data_cdc;
 	struct smcd_cdc_msg cdc;
 	struct smc_sock *smc;
diff --git a/net/smc/smc_cdc.h b/net/smc/smc_cdc.h
index 696cc11..11559d4 100644
--- a/net/smc/smc_cdc.h
+++ b/net/smc/smc_cdc.h
@@ -301,5 +301,6 @@ int smcr_cdc_msg_send_validation(struct smc_connection *conn,
 				 struct smc_wr_buf *wr_buf);
 int smc_cdc_init(void) __init;
 void smcd_cdc_rx_init(struct smc_connection *conn);
+void smcd_cdc_rx_handler(struct smc_connection *conn);
 
 #endif /* SMC_CDC_H */
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index 8ad4c71..f638999 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -24,6 +24,19 @@ struct smcd_dev_list smcd_dev_list = {
 	.mutex = __MUTEX_INITIALIZER(smcd_dev_list.mutex)
 };
 
+/* s390 ISMv2 device creates seid by s390 cpu_id,
+ * but extension SMCv2 device, like loopback, uses
+ * SMCD_DEFAULT_V2_SEID as seid.
+ *
+ * If ISMv2 device and extension SMCv2 device coexist,
+ * ISMv2's seid will overwrite SMCD_DEFAULT_V2_SEID.
+ */
+struct smcd_seid SMCD_DEFAULT_V2_SEID = {
+	.seid_string = "IBM-DEF-ISMSEID000000000",
+	.serial_number = "1000",
+	.type = "1000",
+};
+
 static bool smc_ism_v2_capable;
 static u8 smc_ism_v2_system_eid[SMC_MAX_EID_LEN];
 
@@ -79,6 +92,13 @@ void smc_ism_check_v2_capable(struct smcd_dev *smcd)
 
 	system_eid = smcd->ops->get_system_eid();
 	if (smcd->ops->supports_v2()) {
+		if (smc_ism_v2_capable &&
+		    memcmp(smc_ism_v2_system_eid, &SMCD_DEFAULT_V2_SEID,
+			   SMC_MAX_EID_LEN))
+			/* ISMv2 device already set the seid */
+			return;
+
+		/* set the initial seid or overwrite the default seid */
 		smc_ism_v2_capable = true;
 		memcpy(smc_ism_v2_system_eid, system_eid,
 		       SMC_MAX_EID_LEN);
diff --git a/net/smc/smc_ism.h b/net/smc/smc_ism.h
index 14d2e77..870ff7b 100644
--- a/net/smc/smc_ism.h
+++ b/net/smc/smc_ism.h
@@ -21,6 +21,7 @@ struct smcd_dev_list {	/* List of SMCD devices */
 };
 
 extern struct smcd_dev_list	smcd_dev_list;	/* list of smcd devices */
+extern struct smcd_seid		SMCD_DEFAULT_V2_SEID; /* default v2 SEID */
 
 struct smc_ism_vlanid {			/* VLAN id set on ISM device */
 	struct list_head list;
diff --git a/net/smc/smc_loopback.c b/net/smc/smc_loopback.c
new file mode 100644
index 0000000..6ac5727
--- /dev/null
+++ b/net/smc/smc_loopback.c
@@ -0,0 +1,360 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *  Shared Memory Communications Direct over loopback device.
+ *
+ *  Provide a SMC-D loopback dummy device.
+ *
+ *  Copyright (c) 2022, Alibaba Inc.
+ *
+ *  Author: Wen Gu <guwen@linux.alibaba.com>
+ *          Tony Lu <tonylu@linux.alibaba.com>
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/types.h>
+#include <net/smc.h>
+
+#include "smc_cdc.h"
+#include "smc_ism.h"
+#include "smc_loopback.h"
+
+#define SMC_LO_SUPPORTS_V2 0x1 /* SMC-D loopback supports SMC-Dv2 */
+
+static struct smc_lo_dev *lo_dev;
+static const char smc_lo_dev_name[] = "smcd_loopback_dev";
+
+static inline void smc_lo_gen_id(struct smc_lo_dev *ldev)
+{
+	/* TODO: ensure local_gid is unique.
+	 */
+	get_random_bytes(&ldev->local_gid, sizeof(ldev->local_gid));
+	ldev->chid = SMC_LO_CHID;
+}
+
+static int smc_lo_query_rgid(struct smcd_dev *smcd, u64 rgid,
+			     u32 vid_valid, u32 vid)
+{
+	struct smc_lo_dev *ldev = smcd->priv;
+
+	/* rgid should equal to lgid in loopback */
+	if (!ldev || rgid != ldev->local_gid)
+		return -ENETUNREACH;
+	return 0;
+}
+
+static int smc_lo_register_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb,
+			       void *client_priv)
+{
+	struct smc_lo_dev *ldev = smcd->priv;
+	struct smc_lo_dmb_node *dmb_node;
+	int sba_idx, rc;
+
+	/* check space for new dmb */
+	for_each_clear_bit(sba_idx, ldev->sba_idx_mask, SMC_LODEV_MAX_DMBS) {
+		if (!test_and_set_bit(sba_idx, ldev->sba_idx_mask))
+			break;
+	}
+	if (sba_idx == SMC_LODEV_MAX_DMBS)
+		return -ENOSPC;
+
+	dmb_node = kzalloc(sizeof(*dmb_node), GFP_KERNEL);
+	if (!dmb_node) {
+		rc = -ENOMEM;
+		goto err_bit;
+	}
+
+	dmb_node->sba_idx = sba_idx;
+	dmb_node->cpu_addr = kzalloc(dmb->dmb_len, GFP_KERNEL |
+			     __GFP_NOWARN | __GFP_NORETRY |
+			     __GFP_NOMEMALLOC);
+	if (!dmb_node->cpu_addr) {
+		rc = -ENOMEM;
+		goto err_node;
+	}
+	dmb_node->len = dmb->dmb_len;
+	dmb_node->dma_addr = (dma_addr_t)dmb_node->cpu_addr;
+
+	/* TODO: token is random but not exclusive !
+	 * suppose to find token in dmb hask table, if has this token
+	 * already, then generate another one.
+	 */
+	/* add new dmb into hash table */
+	get_random_bytes(&dmb_node->token, sizeof(dmb_node->token));
+	write_lock(&ldev->dmb_ht_lock);
+	hash_add(ldev->dmb_ht, &dmb_node->list, dmb_node->token);
+	write_unlock(&ldev->dmb_ht_lock);
+
+	dmb->sba_idx = dmb_node->sba_idx;
+	dmb->dmb_tok = dmb_node->token;
+	dmb->cpu_addr = dmb_node->cpu_addr;
+	dmb->dma_addr = dmb_node->dma_addr;
+	dmb->dmb_len = dmb_node->len;
+
+	return 0;
+
+err_node:
+	kfree(dmb_node);
+err_bit:
+	clear_bit(sba_idx, ldev->sba_idx_mask);
+	return rc;
+}
+
+static int smc_lo_unregister_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
+{
+	struct smc_lo_dmb_node *dmb_node = NULL, *tmp_node;
+	struct smc_lo_dev *ldev = smcd->priv;
+
+	/* remove dmb from hash table */
+	write_lock(&ldev->dmb_ht_lock);
+	hash_for_each_possible(ldev->dmb_ht, tmp_node, list, dmb->dmb_tok) {
+		if (tmp_node->token == dmb->dmb_tok) {
+			dmb_node = tmp_node;
+			break;
+		}
+	}
+	if (!dmb_node) {
+		write_unlock(&ldev->dmb_ht_lock);
+		return -EINVAL;
+	}
+	hash_del(&dmb_node->list);
+	write_unlock(&ldev->dmb_ht_lock);
+
+	clear_bit(dmb_node->sba_idx, ldev->sba_idx_mask);
+	kfree(dmb_node->cpu_addr);
+	kfree(dmb_node);
+
+	return 0;
+}
+
+static int smc_lo_add_vlan_id(struct smcd_dev *smcd, u64 vlan_id)
+{
+	return -EOPNOTSUPP;
+}
+
+static int smc_lo_del_vlan_id(struct smcd_dev *smcd, u64 vlan_id)
+{
+	return -EOPNOTSUPP;
+}
+
+static int smc_lo_set_vlan_required(struct smcd_dev *smcd)
+{
+	return -EOPNOTSUPP;
+}
+
+static int smc_lo_reset_vlan_required(struct smcd_dev *smcd)
+{
+	return -EOPNOTSUPP;
+}
+
+static int smc_lo_move_data(struct smcd_dev *smcd, u64 dmb_tok, unsigned int idx,
+			    bool sf, unsigned int offset, void *data,
+			    unsigned int size)
+{
+	struct smc_lo_dmb_node *rmb_node = NULL, *tmp_node;
+	struct smc_lo_dev *ldev = smcd->priv;
+
+	read_lock(&ldev->dmb_ht_lock);
+	hash_for_each_possible(ldev->dmb_ht, tmp_node, list, dmb_tok) {
+		if (tmp_node->token == dmb_tok) {
+			rmb_node = tmp_node;
+			break;
+		}
+	}
+	if (!rmb_node) {
+		read_unlock(&ldev->dmb_ht_lock);
+		return -EINVAL;
+	}
+	read_unlock(&ldev->dmb_ht_lock);
+
+	memcpy((char *)rmb_node->cpu_addr + offset, data, size);
+
+	if (sf) {
+		struct smc_connection *conn =
+			smcd->conn[rmb_node->sba_idx];
+
+		if (conn && !conn->killed)
+			smcd_cdc_rx_handler(conn);
+	}
+	return 0;
+}
+
+static int smc_lo_supports_v2(void)
+{
+	return SMC_LO_SUPPORTS_V2;
+}
+
+static u8 *smc_lo_get_system_eid(void)
+{
+	return SMCD_DEFAULT_V2_SEID.seid_string;
+}
+
+static u64 smc_lo_get_local_gid(struct smcd_dev *smcd)
+{
+	return ((struct smc_lo_dev *)smcd->priv)->local_gid;
+}
+
+static u16 smc_lo_get_chid(struct smcd_dev *smcd)
+{
+	return ((struct smc_lo_dev *)smcd->priv)->chid;
+}
+
+static struct device *smc_lo_get_dev(struct smcd_dev *smcd)
+{
+	return &((struct smc_lo_dev *)smcd->priv)->dev;
+}
+
+static const struct smcd_ops lo_ops = {
+	.query_remote_gid = smc_lo_query_rgid,
+	.register_dmb = smc_lo_register_dmb,
+	.unregister_dmb = smc_lo_unregister_dmb,
+	.add_vlan_id = smc_lo_add_vlan_id,
+	.del_vlan_id = smc_lo_del_vlan_id,
+	.set_vlan_required = smc_lo_set_vlan_required,
+	.reset_vlan_required = smc_lo_reset_vlan_required,
+	.signal_event = NULL,
+	.move_data = smc_lo_move_data,
+	.supports_v2 = smc_lo_supports_v2,
+	.get_system_eid = smc_lo_get_system_eid,
+	.get_local_gid = smc_lo_get_local_gid,
+	.get_chid = smc_lo_get_chid,
+	.get_dev = smc_lo_get_dev,
+};
+
+static struct smcd_dev *smcd_lo_alloc_dev(const struct smcd_ops *ops,
+					  int max_dmbs)
+{
+	struct smcd_dev *smcd;
+
+	smcd = kzalloc(sizeof(*smcd), GFP_KERNEL);
+	if (!smcd)
+		return NULL;
+
+	smcd->conn = kcalloc(max_dmbs, sizeof(struct smc_connection *),
+			     GFP_KERNEL);
+	if (!smcd->conn)
+		goto out_smcd;
+
+	smcd->ops = ops;
+
+	spin_lock_init(&smcd->lock);
+	spin_lock_init(&smcd->lgr_lock);
+	INIT_LIST_HEAD(&smcd->vlan);
+	INIT_LIST_HEAD(&smcd->lgr_list);
+	init_waitqueue_head(&smcd->lgrs_deleted);
+	return smcd;
+
+out_smcd:
+	kfree(smcd);
+	return NULL;
+}
+
+static int smcd_lo_register_dev(struct smc_lo_dev *ldev)
+{
+	struct smcd_dev *smcd;
+
+	smcd = smcd_lo_alloc_dev(&lo_ops, SMC_LODEV_MAX_DMBS);
+	if (!smcd)
+		return -ENOMEM;
+
+	ldev->smcd = smcd;
+	smcd->priv = ldev;
+	smcd->parent_pci_dev = NULL;
+	mutex_lock(&smcd_dev_list.mutex);
+	smc_ism_check_v2_capable(smcd);
+	list_add(&smcd->list, &smcd_dev_list.list);
+	mutex_unlock(&smcd_dev_list.mutex);
+	pr_warn_ratelimited("smc: adding smcd device %s with pnetid %.16s%s\n",
+			    smc_lo_dev_name, smcd->pnetid,
+			    smcd->pnetid_by_user ? " (user defined)" : "");
+	return 0;
+}
+
+static void smcd_lo_unregister_dev(struct smc_lo_dev *ldev)
+{
+	struct smcd_dev *smcd = ldev->smcd;
+
+	pr_warn_ratelimited("smc: removing smcd device %s\n",
+			    smc_lo_dev_name);
+	smcd->going_away = 1;
+	smc_smcd_terminate_all(smcd);
+	mutex_lock(&smcd_dev_list.mutex);
+	list_del_init(&smcd->list);
+	mutex_unlock(&smcd_dev_list.mutex);
+}
+
+static void smc_lo_dev_release(struct device *dev)
+{
+	struct smc_lo_dev *ldev =
+		container_of(dev, struct smc_lo_dev, dev);
+	struct smcd_dev *smcd = ldev->smcd;
+
+	kfree(smcd->conn);
+	kfree(smcd);
+	kfree(ldev);
+}
+
+static int smc_lo_dev_init(struct smc_lo_dev *ldev)
+{
+	smc_lo_gen_id(ldev);
+	rwlock_init(&ldev->dmb_ht_lock);
+	hash_init(ldev->dmb_ht);
+
+	return smcd_lo_register_dev(ldev);
+}
+
+static int smc_lo_dev_probe(void)
+{
+	struct smc_lo_dev *ldev;
+	int ret;
+
+	ldev = kzalloc(sizeof(*ldev), GFP_KERNEL);
+	if (!ldev)
+		return -ENOMEM;
+
+	ldev->dev.parent = NULL;
+	ldev->dev.release = smc_lo_dev_release;
+	device_initialize(&ldev->dev);
+	dev_set_name(&ldev->dev, smc_lo_dev_name);
+	ret = device_add(&ldev->dev);
+	if (ret)
+		goto free_dev;
+
+	ret = smc_lo_dev_init(ldev);
+	if (ret)
+		goto put_dev;
+
+	lo_dev = ldev; /* global loopback device */
+	return 0;
+
+put_dev:
+	device_del(&ldev->dev);
+free_dev:
+	kfree(ldev);
+	return ret;
+}
+
+static void smc_lo_dev_exit(struct smc_lo_dev *ldev)
+{
+	smcd_lo_unregister_dev(ldev);
+}
+
+static void smc_lo_dev_remove(void)
+{
+	if (!lo_dev)
+		return;
+
+	smc_lo_dev_exit(lo_dev);
+	device_del(&lo_dev->dev); /* device_add in smc_lo_dev_probe */
+	put_device(&lo_dev->dev); /* device_initialize in smc_lo_dev_probe */
+}
+
+int smc_loopback_init(void)
+{
+	return smc_lo_dev_probe();
+}
+
+void smc_loopback_exit(void)
+{
+	smc_lo_dev_remove();
+}
diff --git a/net/smc/smc_loopback.h b/net/smc/smc_loopback.h
new file mode 100644
index 0000000..9d34aba
--- /dev/null
+++ b/net/smc/smc_loopback.h
@@ -0,0 +1,51 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ *  Shared Memory Communications Direct over loopback device.
+ *
+ *  Provide a SMC-D loopback dummy device.
+ *
+ *  Copyright (c) 2022, Alibaba Inc.
+ *
+ *  Author: Wen Gu <guwen@linux.alibaba.com>
+ *          Tony Lu <tonylu@linux.alibaba.com>
+ *
+ */
+
+#ifndef _SMC_LOOPBACK_H
+#define _SMC_LOOPBACK_H
+
+#include <linux/types.h>
+#include <linux/interrupt.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <net/smc.h>
+
+#include "smc_core.h"
+
+#define SMC_LO_CHID 0xFFFF
+#define SMC_LODEV_MAX_DMBS 5000
+#define SMC_LODEV_MAX_DMBS_BUCKETS 16
+
+struct smc_lo_dmb_node {
+	struct hlist_node list;
+	u64 token;
+	u32 len;
+	u32 sba_idx;
+	void *cpu_addr;
+	dma_addr_t dma_addr;
+};
+
+struct smc_lo_dev {
+	struct smcd_dev *smcd;
+	struct device dev;
+	u16 chid;
+	u64 local_gid;
+	DECLARE_BITMAP(sba_idx_mask, SMC_LODEV_MAX_DMBS);
+	rwlock_t dmb_ht_lock;
+	DECLARE_HASHTABLE(dmb_ht, SMC_LODEV_MAX_DMBS_BUCKETS);
+};
+
+int smc_loopback_init(void);
+void smc_loopback_exit(void);
+
+#endif /* _SMC_LOOPBACK_H */
-- 
1.8.3.1

