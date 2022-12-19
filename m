Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590DF6510EE
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 18:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbiLSRIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 12:08:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbiLSRIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 12:08:17 -0500
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D712DDEAD;
        Mon, 19 Dec 2022 09:08:15 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VXiFqJC_1671469691;
Received: from localhost(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VXiFqJC_1671469691)
          by smtp.aliyun-inc.com;
          Tue, 20 Dec 2022 01:08:13 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next 1/5] net/smc: introduce SMC-D loopback device
Date:   Tue, 20 Dec 2022 01:07:44 +0800
Message-Id: <1671469668-82691-2-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1671469668-82691-1-git-send-email-guwen@linux.alibaba.com>
References: <1671469668-82691-1-git-send-email-guwen@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces a kind of loopback device for SMC-D, thus
enabling the SMC communication between two local sockets in one
kernel.

The loopback device supports basic capabilities defined by SMC-D,
including registering DMB, unregistering DMB and moving data.

Considering that there is no ism device on other servers expect
IBM z13, the loopback device can be used as a dummy device to
test SMC-D logic for the broad community.

Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 include/net/smc.h      |   1 +
 net/smc/Makefile       |   2 +-
 net/smc/af_smc.c       |  12 +-
 net/smc/smc_cdc.c      |   6 +
 net/smc/smc_cdc.h      |   1 +
 net/smc/smc_loopback.c | 289 +++++++++++++++++++++++++++++++++++++++++++++++++
 net/smc/smc_loopback.h |  59 ++++++++++
 7 files changed, 368 insertions(+), 2 deletions(-)
 create mode 100644 net/smc/smc_loopback.c
 create mode 100644 net/smc/smc_loopback.h

diff --git a/include/net/smc.h b/include/net/smc.h
index c926d33..7699f97 100644
--- a/include/net/smc.h
+++ b/include/net/smc.h
@@ -93,6 +93,7 @@ struct smcd_dev {
 	atomic_t lgr_cnt;
 	wait_queue_head_t lgrs_deleted;
 	u8 going_away : 1;
+	u8 is_loopback : 1;
 };
 
 struct smcd_dev *smcd_alloc_dev(struct device *parent, const char *name,
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
index e12d4fa..9546c02 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -52,6 +52,7 @@
 #include "smc_stats.h"
 #include "smc_tracepoint.h"
 #include "smc_sysctl.h"
+#include "smc_loopback.h"
 
 static DEFINE_MUTEX(smc_server_lgr_pending);	/* serialize link group
 						 * creation on server
@@ -3451,15 +3452,23 @@ static int __init smc_init(void)
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
@@ -3494,6 +3503,7 @@ static void __exit smc_exit(void)
 	tcp_unregister_ulp(&smc_ulp_ops);
 	sock_unregister(PF_SMC);
 	smc_core_exit();
+	smc_loopback_exit();
 	smc_ib_unregister_client();
 	destroy_workqueue(smc_close_wq);
 	destroy_workqueue(smc_tcp_ls_wq);
diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index 53f63bf..61f5ff7 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -408,6 +408,12 @@ static void smc_cdc_msg_recv(struct smc_sock *smc, struct smc_cdc_msg *cdc)
 static void smcd_cdc_rx_tsklet(struct tasklet_struct *t)
 {
 	struct smc_connection *conn = from_tasklet(conn, t, rx_tsklet);
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
diff --git a/net/smc/smc_loopback.c b/net/smc/smc_loopback.c
new file mode 100644
index 0000000..803156e
--- /dev/null
+++ b/net/smc/smc_loopback.c
@@ -0,0 +1,289 @@
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
+#include "smc_loopback.h"
+
+#define DRV_NAME "smc_lodev"
+
+struct lo_dev *lo_dev;
+
+static const struct pci_device_id lo_dev_table[] = {
+	{ PCI_VDEVICE(IBM, PCI_ANY_ID), 0 },
+	{ 0, }
+};
+MODULE_DEVICE_TABLE(pci, lo_dev_table);
+
+static struct lo_systemeid LO_SYSTEM_EID = {
+	.seid_string = "SMC-SYSZ-LOSEID000000000",
+	.serial_number = "0000",
+	.type = "0000",
+};
+
+int lo_query_rgid(struct smcd_dev *smcd, u64 rgid, u32 vid_valid,
+		  u32 vid)
+{
+	struct lo_dev *ldev = smcd->priv;
+
+	/* return local gid */
+	if (!ldev || rgid != ldev->lgid)
+		return -ENETUNREACH;
+	return 0;
+}
+
+int lo_register_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
+{
+	struct lo_dev *ldev = smcd->priv;
+	struct lo_dmb_node *dmb_node;
+	int sba_idx, rc;
+
+	/* check space for new dmb */
+	for_each_clear_bit(sba_idx, ldev->sba_idx_mask, LODEV_MAX_DMBS) {
+		if (!test_and_set_bit(sba_idx, ldev->sba_idx_mask))
+			break;
+	}
+	if (sba_idx == LODEV_MAX_DMBS)
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
+int lo_unregister_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
+{
+	struct lo_dmb_node *dmb_node = NULL, *tmp_node;
+	struct lo_dev *ldev = smcd->priv;
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
+int lo_add_vlan_id(struct smcd_dev *smcd, u64 vlan_id)
+{
+	return 0;
+}
+
+int lo_del_vlan_id(struct smcd_dev *smcd, u64 vlan_id)
+{
+	return 0;
+}
+
+int lo_set_vlan_required(struct smcd_dev *smcd)
+{
+	return 0;
+}
+
+int lo_reset_vlan_required(struct smcd_dev *smcd)
+{
+	return 0;
+}
+
+int lo_signal_ieq(struct smcd_dev *smcd, u64 rgid, u32 trigger_irq,
+		  u32 event_code, u64 info)
+{
+	return 0;
+}
+
+int lo_move_data(struct smcd_dev *smcd, u64 dmb_tok, unsigned int idx,
+		 bool sf, unsigned int offset, void *data,
+		  unsigned int size)
+{
+	struct lo_dmb_node *rmb_node = NULL, *tmp_node;
+	struct lo_dev *ldev = smcd->priv;
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
+u8 *lo_get_system_eid(void)
+{
+	return &LO_SYSTEM_EID.seid_string[0];
+}
+
+u16 lo_get_chid(struct smcd_dev *smcd)
+{
+	return 0;
+}
+
+static const struct smcd_ops lo_ops = {
+	.query_remote_gid = lo_query_rgid,
+	.register_dmb = lo_register_dmb,
+	.unregister_dmb = lo_unregister_dmb,
+	.add_vlan_id = lo_add_vlan_id,
+	.del_vlan_id = lo_del_vlan_id,
+	.set_vlan_required = lo_set_vlan_required,
+	.reset_vlan_required = lo_reset_vlan_required,
+	.signal_event = lo_signal_ieq,
+	.move_data = lo_move_data,
+	.get_system_eid = lo_get_system_eid,
+	.get_chid = lo_get_chid,
+};
+
+static int lo_dev_init(struct lo_dev *ldev)
+{
+	struct smcd_dev *smcd = ldev->smcd;
+
+	/* smcd related */
+	smcd->is_loopback = 1;
+	smcd->priv = ldev;
+	get_random_bytes(&smcd->local_gid, sizeof(smcd->local_gid));
+
+	/* ldev related */
+	/* TODO: lgid is random but not exclusive !
+	 */
+	ldev->lgid = smcd->local_gid;
+	rwlock_init(&ldev->dmb_ht_lock);
+	hash_init(ldev->dmb_ht);
+
+	return smcd_register_dev(smcd);
+}
+
+static int lo_dev_probe(void)
+{
+	struct lo_dev *ldev;
+	int ret;
+
+	ldev = kzalloc(sizeof(*ldev), GFP_KERNEL);
+	if (!ldev)
+		return -ENOMEM;
+
+	ldev->smcd = smcd_alloc_dev(NULL, "smcd-loopback-dev",
+				    &lo_ops, LODEV_MAX_DMBS);
+	if (!ldev->smcd) {
+		ret = -ENOMEM;
+		goto err_ldev;
+	}
+
+	ret = lo_dev_init(ldev);
+	if (ret)
+		goto err_smcd;
+
+	lo_dev = ldev;
+	return 0;
+
+err_smcd:
+	smcd_free_dev(ldev->smcd);
+err_ldev:
+	kfree(ldev);
+	return ret;
+}
+
+static void lo_dev_exit(struct lo_dev *ldev)
+{
+	smcd_unregister_dev(ldev->smcd);
+}
+
+static void lo_dev_remove(void)
+{
+	if (!lo_dev)
+		return;
+
+	lo_dev_exit(lo_dev);
+	smcd_free_dev(lo_dev->smcd);
+	kfree(lo_dev);
+}
+
+int smc_loopback_init(void)
+{
+	/* TODO: now lo_dev is a global device shared by
+	 * the whole kernel, and can't be referred to by
+	 * smc-tools command 'smcd dev'. Need to be improved.
+	 */
+	return lo_dev_probe();
+}
+
+void smc_loopback_exit(void)
+{
+	lo_dev_remove();
+}
diff --git a/net/smc/smc_loopback.h b/net/smc/smc_loopback.h
new file mode 100644
index 0000000..d7f7815
--- /dev/null
+++ b/net/smc/smc_loopback.h
@@ -0,0 +1,59 @@
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
+#define LODEV_MAX_DMBS 5000
+#define LODEV_MAX_DMBS_BUCKETS 16
+
+struct lo_dmb_node {
+	struct hlist_node list;
+	u64 token;
+	u32 len;
+	u32 sba_idx;
+	void *cpu_addr;
+	dma_addr_t dma_addr;
+};
+
+struct lo_dev {
+	struct smcd_dev *smcd;
+	/* priv data */
+	u64 lgid;
+	DECLARE_BITMAP(sba_idx_mask, LODEV_MAX_DMBS);
+	rwlock_t dmb_ht_lock;
+	DECLARE_HASHTABLE(dmb_ht, LODEV_MAX_DMBS_BUCKETS);
+};
+
+struct lo_systemeid {
+	u8 seid_string[24];
+	u8 serial_number[4];
+	u8 type[4];
+};
+
+/* smcd loopback dev*/
+extern struct lo_dev *lo_dev;
+
+int smc_loopback_init(void);
+void smc_loopback_exit(void);
+
+#endif /* _SMC_LOOPBACK_H */
+
-- 
1.8.3.1

