Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 322D9333C66
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbhCJMQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232587AbhCJMPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:15:39 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A517C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:15:38 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id b13so27755599edx.1
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Bz3m4dei4ogS/bmZsvi9qRAAZzAMXcrNxJX9NUW+DBQ=;
        b=qnmJMZpGoNfcx/p49aMLw0TkrX/9E5EWN1DLElLk5LZKcDQN8UV64q06GQuqWmMBUk
         6aVpPn0tdhmFQgnceCWGQ5Hqelw3XaM8QwYu5XwpG4grP9NTYM3AZvLvRs0iutCHbQqX
         gbHbAMLUsPesBQdQZlrMHZQPD1yQD9Ccdr6qGFWte1Tl9rQjBgbqk1N3qGP6wP7Wn/yR
         fkp8WOfINSLdvHQ5wNqd31ZgMtPLOR1P1SiesMAA8UlfP8ppSEzKXyBG8LLC/tmg6zom
         qRHHtdxR6GtjW3zweAUVzUqADTC2H1sTf07sS2oWd/r1Y+Vx0NTp5VeeBqKLhoX3MgDm
         eB0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bz3m4dei4ogS/bmZsvi9qRAAZzAMXcrNxJX9NUW+DBQ=;
        b=FjoDue/TN4s8WVjWQ+UhKmTD66WSmnCZq0TyGEflUlqDbQkRA94bJzR91me7HkXjH/
         JmVS25qkmXqAd0QFDePBVudTBNHkb7DtxF9sJGHShZeIJcD54j5o96u5nK1i83lcdPjt
         FOCTDtBOQ825+rL1lipTyjOUNU+SQF2xx1vyGPIopYTsQgKboZtvplj9GhjyZ8OhyYuE
         ePjJJ4azOoLpk1ty2olmNxcrwwwhCRDboYQ4OpyxvrSF95qSq0OxcasZxn1VWG/1c/vf
         BjvnGsDnmFuQYNmGhASqC3Stp4U9oQss3TGcluYEa54VcWJKdqZhsy+LqoavDDehOOid
         mT5Q==
X-Gm-Message-State: AOAM532snlwmCJv/4vVfvgA7JecxPR/4WGuixWyoZSEzKL0bbOk4rB4U
        SG8wfUBnNCWaxaGJTy3PwiI=
X-Google-Smtp-Source: ABdhPJxsOBfQ0tJlEriwpQn4qWkVuqLFH34LGu+xBqj4SYuIaf2oMA4t6nGuIPisY8vSjFTUG2fvSw==
X-Received: by 2002:a05:6402:38f:: with SMTP id o15mr2836003edv.361.1615378537132;
        Wed, 10 Mar 2021 04:15:37 -0800 (PST)
Received: from yoga-910.localhost ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id v15sm4865527edw.28.2021.03.10.04.15.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:15:36 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        jiri@resnulli.us, ruxandra.radulescu@nxp.com,
        netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 07/15] staging: dpaa2-switch: handle Rx path on control interface
Date:   Wed, 10 Mar 2021 14:14:44 +0200
Message-Id: <20210310121452.552070-8-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210310121452.552070-1-ciorneiioana@gmail.com>
References: <20210310121452.552070-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

The dpaa2-ethsw supports only one Rx queue that is shared by all switch
ports. This means that information about which port was the ingress port
for a specific frame needs to be passed in metadata. In our case, the
Flow Context (FLC) field from the frame descriptor holds this
information. Besides the interface ID of the ingress port we also
receive the virtual QDID of the port. Below is a visual description of
the 64 bits of FLC.

63           47           31           15           0
+---------------------------------------------------+
|            |            |            |            |
|  RESERVED  |    IF_ID   |  RESERVED  |  IF QDID   |
|            |            |            |            |
+---------------------------------------------------+

Because all switch ports share the same Rx and Tx conf queues, NAPI
management takes into consideration when there is at least one switch
interface open to enable the NAPI instance.

The Rx path is common, for the most part, for both Rx and Tx conf with
the mention that each of them has its own consume function of a frame
descriptor. Dequeueing from a FQ, consuming dequeued store and also the
NAPI poll function is common between both queues.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c | 455 +++++++++++++++++++++++-
 drivers/staging/fsl-dpaa2/ethsw/ethsw.h |  17 +
 2 files changed, 460 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index 5e2d441cbc38..54cf87a66ab0 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -13,6 +13,7 @@
 #include <linux/msi.h>
 #include <linux/kthread.h>
 #include <linux/workqueue.h>
+#include <linux/iommu.h>
 
 #include <linux/fsl/mc.h>
 
@@ -24,6 +25,16 @@
 
 #define DEFAULT_VLAN_ID			1
 
+static void *dpaa2_iova_to_virt(struct iommu_domain *domain,
+				dma_addr_t iova_addr)
+{
+	phys_addr_t phys_addr;
+
+	phys_addr = domain ? iommu_iova_to_phys(domain, iova_addr) : iova_addr;
+
+	return phys_to_virt(phys_addr);
+}
+
 static int dpaa2_switch_add_vlan(struct ethsw_core *ethsw, u16 vid)
 {
 	int err;
@@ -433,9 +444,51 @@ static int dpaa2_switch_port_carrier_state_sync(struct net_device *netdev)
 	return 0;
 }
 
+/* Manage all NAPI instances for the control interface.
+ *
+ * We only have one RX queue and one Tx Conf queue for all
+ * switch ports. Therefore, we only need to enable the NAPI instance once, the
+ * first time one of the switch ports runs .dev_open().
+ */
+
+static void dpaa2_switch_enable_ctrl_if_napi(struct ethsw_core *ethsw)
+{
+	int i;
+
+	/* Access to the ethsw->napi_users relies on the RTNL lock */
+	ASSERT_RTNL();
+
+	/* a new interface is using the NAPI instance */
+	ethsw->napi_users++;
+
+	/* if there is already a user of the instance, return */
+	if (ethsw->napi_users > 1)
+		return;
+
+	for (i = 0; i < DPAA2_SWITCH_RX_NUM_FQS; i++)
+		napi_enable(&ethsw->fq[i].napi);
+}
+
+static void dpaa2_switch_disable_ctrl_if_napi(struct ethsw_core *ethsw)
+{
+	int i;
+
+	/* Access to the ethsw->napi_users relies on the RTNL lock */
+	ASSERT_RTNL();
+
+	/* If we are not the last interface using the NAPI, return */
+	ethsw->napi_users--;
+	if (ethsw->napi_users)
+		return;
+
+	for (i = 0; i < DPAA2_SWITCH_RX_NUM_FQS; i++)
+		napi_disable(&ethsw->fq[i].napi);
+}
+
 static int dpaa2_switch_port_open(struct net_device *netdev)
 {
 	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
+	struct ethsw_core *ethsw = port_priv->ethsw_data;
 	int err;
 
 	/* No need to allow Tx as control interface is disabled */
@@ -464,6 +517,8 @@ static int dpaa2_switch_port_open(struct net_device *netdev)
 		goto err_carrier_sync;
 	}
 
+	dpaa2_switch_enable_ctrl_if_napi(ethsw);
+
 	return 0;
 
 err_carrier_sync:
@@ -476,6 +531,7 @@ static int dpaa2_switch_port_open(struct net_device *netdev)
 static int dpaa2_switch_port_stop(struct net_device *netdev)
 {
 	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
+	struct ethsw_core *ethsw = port_priv->ethsw_data;
 	int err;
 
 	err = dpsw_if_disable(port_priv->ethsw_data->mc_io, 0,
@@ -486,6 +542,8 @@ static int dpaa2_switch_port_stop(struct net_device *netdev)
 		return err;
 	}
 
+	dpaa2_switch_disable_ctrl_if_napi(ethsw);
+
 	return 0;
 }
 
@@ -692,6 +750,28 @@ static int dpaa2_switch_port_set_mac_addr(struct ethsw_port_priv *port_priv)
 	return 0;
 }
 
+static void dpaa2_switch_free_fd(const struct ethsw_core *ethsw,
+				 const struct dpaa2_fd *fd)
+{
+	struct device *dev = ethsw->dev;
+	unsigned char *buffer_start;
+	struct sk_buff **skbh, *skb;
+	dma_addr_t fd_addr;
+
+	fd_addr = dpaa2_fd_get_addr(fd);
+	skbh = dpaa2_iova_to_virt(ethsw->iommu_domain, fd_addr);
+
+	skb = *skbh;
+	buffer_start = (unsigned char *)skbh;
+
+	dma_unmap_single(dev, fd_addr,
+			 skb_tail_pointer(skb) - buffer_start,
+			 DMA_TO_DEVICE);
+
+	/* Move on with skb release */
+	dev_kfree_skb(skb);
+}
+
 static const struct net_device_ops dpaa2_switch_port_ops = {
 	.ndo_open		= dpaa2_switch_port_open,
 	.ndo_stop		= dpaa2_switch_port_stop,
@@ -1326,6 +1406,98 @@ static int dpaa2_switch_register_notifier(struct device *dev)
 	return err;
 }
 
+/* Build a linear skb based on a single-buffer frame descriptor */
+static struct sk_buff *dpaa2_switch_build_linear_skb(struct ethsw_core *ethsw,
+						     const struct dpaa2_fd *fd)
+{
+	u16 fd_offset = dpaa2_fd_get_offset(fd);
+	dma_addr_t addr = dpaa2_fd_get_addr(fd);
+	u32 fd_length = dpaa2_fd_get_len(fd);
+	struct device *dev = ethsw->dev;
+	struct sk_buff *skb = NULL;
+	void *fd_vaddr;
+
+	fd_vaddr = dpaa2_iova_to_virt(ethsw->iommu_domain, addr);
+	dma_unmap_page(dev, addr, DPAA2_SWITCH_RX_BUF_SIZE,
+		       DMA_FROM_DEVICE);
+
+	skb = build_skb(fd_vaddr, DPAA2_SWITCH_RX_BUF_SIZE +
+			SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
+	if (unlikely(!skb)) {
+		dev_err(dev, "build_skb() failed\n");
+		return NULL;
+	}
+
+	skb_reserve(skb, fd_offset);
+	skb_put(skb, fd_length);
+
+	ethsw->buf_count--;
+
+	return skb;
+}
+
+static void dpaa2_switch_rx(struct dpaa2_switch_fq *fq,
+			    const struct dpaa2_fd *fd)
+{
+	struct ethsw_core *ethsw = fq->ethsw;
+	struct ethsw_port_priv *port_priv;
+	struct net_device *netdev;
+	struct vlan_ethhdr *hdr;
+	struct sk_buff *skb;
+	u16 vlan_tci, vid;
+	int if_id, err;
+
+	/* get switch ingress interface ID */
+	if_id = upper_32_bits(dpaa2_fd_get_flc(fd)) & 0x0000FFFF;
+
+	if (if_id >= ethsw->sw_attr.num_ifs) {
+		dev_err(ethsw->dev, "Frame received from unknown interface!\n");
+		goto err_free_fd;
+	}
+	port_priv = ethsw->ports[if_id];
+	netdev = port_priv->netdev;
+
+	/* build the SKB based on the FD received */
+	if (dpaa2_fd_get_format(fd) != dpaa2_fd_single) {
+		if (net_ratelimit()) {
+			netdev_err(netdev, "Received invalid frame format\n");
+			goto err_free_fd;
+		}
+	}
+
+	skb = dpaa2_switch_build_linear_skb(ethsw, fd);
+	if (unlikely(!skb))
+		goto err_free_fd;
+
+	skb_reset_mac_header(skb);
+
+	/* Remove the VLAN header if the packet that we just received has a vid
+	 * equal to the port PVIDs. Since the dpaa2-switch can operate only in
+	 * VLAN-aware mode and no alterations are made on the packet when it's
+	 * redirected/mirrored to the control interface, we are sure that there
+	 * will always be a VLAN header present.
+	 */
+	hdr = vlan_eth_hdr(skb);
+	vid = ntohs(hdr->h_vlan_TCI) & VLAN_VID_MASK;
+	if (vid == port_priv->pvid) {
+		err = __skb_vlan_pop(skb, &vlan_tci);
+		if (err) {
+			dev_info(ethsw->dev, "__skb_vlan_pop() returned %d", err);
+			goto err_free_fd;
+		}
+	}
+
+	skb->dev = netdev;
+	skb->protocol = eth_type_trans(skb, skb->dev);
+
+	netif_receive_skb(skb);
+
+	return;
+
+err_free_fd:
+	dpaa2_switch_free_fd(ethsw, fd);
+}
+
 static void dpaa2_switch_detect_features(struct ethsw_core *ethsw)
 {
 	ethsw->features = 0;
@@ -1359,6 +1531,146 @@ static int dpaa2_switch_setup_fqs(struct ethsw_core *ethsw)
 	return 0;
 }
 
+/* Free buffers acquired from the buffer pool or which were meant to
+ * be released in the pool
+ */
+static void dpaa2_switch_free_bufs(struct ethsw_core *ethsw, u64 *buf_array, int count)
+{
+	struct device *dev = ethsw->dev;
+	void *vaddr;
+	int i;
+
+	for (i = 0; i < count; i++) {
+		vaddr = dpaa2_iova_to_virt(ethsw->iommu_domain, buf_array[i]);
+		dma_unmap_page(dev, buf_array[i], DPAA2_SWITCH_RX_BUF_SIZE,
+			       DMA_FROM_DEVICE);
+		free_pages((unsigned long)vaddr, 0);
+	}
+}
+
+/* Perform a single release command to add buffers
+ * to the specified buffer pool
+ */
+static int dpaa2_switch_add_bufs(struct ethsw_core *ethsw, u16 bpid)
+{
+	struct device *dev = ethsw->dev;
+	u64 buf_array[BUFS_PER_CMD];
+	struct page *page;
+	int retries = 0;
+	dma_addr_t addr;
+	int err;
+	int i;
+
+	for (i = 0; i < BUFS_PER_CMD; i++) {
+		/* Allocate one page for each Rx buffer. WRIOP sees
+		 * the entire page except for a tailroom reserved for
+		 * skb shared info
+		 */
+		page = dev_alloc_pages(0);
+		if (!page) {
+			dev_err(dev, "buffer allocation failed\n");
+			goto err_alloc;
+		}
+
+		addr = dma_map_page(dev, page, 0, DPAA2_SWITCH_RX_BUF_SIZE,
+				    DMA_FROM_DEVICE);
+		if (dma_mapping_error(dev, addr)) {
+			dev_err(dev, "dma_map_single() failed\n");
+			goto err_map;
+		}
+		buf_array[i] = addr;
+	}
+
+release_bufs:
+	/* In case the portal is busy, retry until successful or
+	 * max retries hit.
+	 */
+	while ((err = dpaa2_io_service_release(NULL, bpid,
+					       buf_array, i)) == -EBUSY) {
+		if (retries++ >= DPAA2_SWITCH_SWP_BUSY_RETRIES)
+			break;
+
+		cpu_relax();
+	}
+
+	/* If release command failed, clean up and bail out. */
+	if (err) {
+		dpaa2_switch_free_bufs(ethsw, buf_array, i);
+		return 0;
+	}
+
+	return i;
+
+err_map:
+	__free_pages(page, 0);
+err_alloc:
+	/* If we managed to allocate at least some buffers,
+	 * release them to hardware
+	 */
+	if (i)
+		goto release_bufs;
+
+	return 0;
+}
+
+static int dpaa2_switch_refill_bp(struct ethsw_core *ethsw)
+{
+	int *count = &ethsw->buf_count;
+	int new_count;
+	int err = 0;
+
+	if (unlikely(*count < DPAA2_ETHSW_REFILL_THRESH)) {
+		do {
+			new_count = dpaa2_switch_add_bufs(ethsw, ethsw->bpid);
+			if (unlikely(!new_count)) {
+				/* Out of memory; abort for now, we'll
+				 * try later on
+				 */
+				break;
+			}
+			*count += new_count;
+		} while (*count < DPAA2_ETHSW_NUM_BUFS);
+
+		if (unlikely(*count < DPAA2_ETHSW_NUM_BUFS))
+			err = -ENOMEM;
+	}
+
+	return err;
+}
+
+static int dpaa2_switch_seed_bp(struct ethsw_core *ethsw)
+{
+	int *count, i;
+
+	for (i = 0; i < DPAA2_ETHSW_NUM_BUFS; i += BUFS_PER_CMD) {
+		count = &ethsw->buf_count;
+		*count += dpaa2_switch_add_bufs(ethsw, ethsw->bpid);
+
+		if (unlikely(*count < BUFS_PER_CMD))
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void dpaa2_switch_drain_bp(struct ethsw_core *ethsw)
+{
+	u64 buf_array[BUFS_PER_CMD];
+	int ret;
+
+	do {
+		ret = dpaa2_io_service_acquire(NULL, ethsw->bpid,
+					       buf_array, BUFS_PER_CMD);
+		if (ret < 0) {
+			dev_err(ethsw->dev,
+				"dpaa2_io_service_acquire() = %d\n", ret);
+			return;
+		}
+		dpaa2_switch_free_bufs(ethsw, buf_array, ret);
+
+	} while (ret);
+}
+
 static int dpaa2_switch_setup_dpbp(struct ethsw_core *ethsw)
 {
 	struct dpsw_ctrl_if_pools_cfg dpsw_ctrl_if_pools_cfg = { 0 };
@@ -1463,6 +1775,103 @@ static void dpaa2_switch_destroy_rings(struct ethsw_core *ethsw)
 		dpaa2_io_store_destroy(ethsw->fq[i].store);
 }
 
+static int dpaa2_switch_pull_fq(struct dpaa2_switch_fq *fq)
+{
+	int err, retries = 0;
+
+	/* Try to pull from the FQ while the portal is busy and we didn't hit
+	 * the maximum number fo retries
+	 */
+	do {
+		err = dpaa2_io_service_pull_fq(NULL, fq->fqid, fq->store);
+		cpu_relax();
+	} while (err == -EBUSY && retries++ < DPAA2_SWITCH_SWP_BUSY_RETRIES);
+
+	if (unlikely(err))
+		dev_err(fq->ethsw->dev, "dpaa2_io_service_pull err %d", err);
+
+	return err;
+}
+
+/* Consume all frames pull-dequeued into the store */
+static int dpaa2_switch_store_consume(struct dpaa2_switch_fq *fq)
+{
+	struct ethsw_core *ethsw = fq->ethsw;
+	int cleaned = 0, is_last;
+	struct dpaa2_dq *dq;
+	int retries = 0;
+
+	do {
+		/* Get the next available FD from the store */
+		dq = dpaa2_io_store_next(fq->store, &is_last);
+		if (unlikely(!dq)) {
+			if (retries++ >= DPAA2_SWITCH_SWP_BUSY_RETRIES) {
+				dev_err_once(ethsw->dev,
+					     "No valid dequeue response\n");
+				return -ETIMEDOUT;
+			}
+			continue;
+		}
+
+		dpaa2_switch_rx(fq, dpaa2_dq_fd(dq));
+		cleaned++;
+
+	} while (!is_last);
+
+	return cleaned;
+}
+
+/* NAPI poll routine */
+static int dpaa2_switch_poll(struct napi_struct *napi, int budget)
+{
+	int err, cleaned = 0, store_cleaned, work_done;
+	struct dpaa2_switch_fq *fq;
+	int retries = 0;
+
+	fq = container_of(napi, struct dpaa2_switch_fq, napi);
+
+	do {
+		err = dpaa2_switch_pull_fq(fq);
+		if (unlikely(err))
+			break;
+
+		/* Refill pool if appropriate */
+		dpaa2_switch_refill_bp(fq->ethsw);
+
+		store_cleaned = dpaa2_switch_store_consume(fq);
+		cleaned += store_cleaned;
+
+		if (cleaned >= budget) {
+			work_done = budget;
+			goto out;
+		}
+
+	} while (store_cleaned);
+
+	/* We didn't consume the entire budget, so finish napi and re-enable
+	 * data availability notifications
+	 */
+	napi_complete_done(napi, cleaned);
+	do {
+		err = dpaa2_io_service_rearm(NULL, &fq->nctx);
+		cpu_relax();
+	} while (err == -EBUSY && retries++ < DPAA2_SWITCH_SWP_BUSY_RETRIES);
+
+	work_done = max(cleaned, 1);
+out:
+
+	return work_done;
+}
+
+static void dpaa2_switch_fqdan_cb(struct dpaa2_io_notification_ctx *nctx)
+{
+	struct dpaa2_switch_fq *fq;
+
+	fq = container_of(nctx, struct dpaa2_switch_fq, nctx);
+
+	napi_schedule(&fq->napi);
+}
+
 static int dpaa2_switch_setup_dpio(struct ethsw_core *ethsw)
 {
 	struct dpsw_ctrl_if_queue_cfg queue_cfg;
@@ -1479,6 +1888,7 @@ static int dpaa2_switch_setup_dpio(struct ethsw_core *ethsw)
 		nctx->is_cdan = 0;
 		nctx->id = ethsw->fq[i].fqid;
 		nctx->desired_cpu = DPAA2_IO_ANY_CPU;
+		nctx->cb = dpaa2_switch_fqdan_cb;
 		err = dpaa2_io_service_register(NULL, nctx, ethsw->dev);
 		if (err) {
 			err = -EPROBE_DEFER;
@@ -1535,10 +1945,14 @@ static int dpaa2_switch_ctrl_if_setup(struct ethsw_core *ethsw)
 	if (err)
 		return err;
 
-	err = dpaa2_switch_alloc_rings(ethsw);
+	err = dpaa2_switch_seed_bp(ethsw);
 	if (err)
 		goto err_free_dpbp;
 
+	err = dpaa2_switch_alloc_rings(ethsw);
+	if (err)
+		goto err_drain_dpbp;
+
 	err = dpaa2_switch_setup_dpio(ethsw);
 	if (err)
 		goto err_destroy_rings;
@@ -1547,6 +1961,8 @@ static int dpaa2_switch_ctrl_if_setup(struct ethsw_core *ethsw)
 
 err_destroy_rings:
 	dpaa2_switch_destroy_rings(ethsw);
+err_drain_dpbp:
+	dpaa2_switch_drain_bp(ethsw);
 err_free_dpbp:
 	dpaa2_switch_free_dpbp(ethsw);
 
@@ -1749,6 +2165,7 @@ static void dpaa2_switch_ctrl_if_teardown(struct ethsw_core *ethsw)
 {
 	dpaa2_switch_free_dpio(ethsw);
 	dpaa2_switch_destroy_rings(ethsw);
+	dpaa2_switch_drain_bp(ethsw);
 	dpaa2_switch_free_dpbp(ethsw);
 }
 
@@ -1825,12 +2242,6 @@ static int dpaa2_switch_probe_port(struct ethsw_core *ethsw,
 	if (err)
 		goto err_port_probe;
 
-	err = register_netdev(port_netdev);
-	if (err < 0) {
-		dev_err(dev, "register_netdev error %d\n", err);
-		goto err_port_probe;
-	}
-
 	ethsw->ports[port_idx] = port_priv;
 
 	return 0;
@@ -1854,6 +2265,7 @@ static int dpaa2_switch_probe(struct fsl_mc_device *sw_dev)
 		return -ENOMEM;
 
 	ethsw->dev = dev;
+	ethsw->iommu_domain = iommu_get_domain_for_dev(dev);
 	dev_set_drvdata(dev, ethsw);
 
 	err = fsl_mc_portal_allocate(sw_dev, FSL_MC_IO_ATOMIC_CONTEXT_PORTAL,
@@ -1883,6 +2295,15 @@ static int dpaa2_switch_probe(struct fsl_mc_device *sw_dev)
 			goto err_free_ports;
 	}
 
+	/* Add a NAPI instance for each of the Rx queues. The first port's
+	 * net_device will be associated with the instances since we do not have
+	 * different queues for each switch ports.
+	 */
+	for (i = 0; i < DPAA2_SWITCH_RX_NUM_FQS; i++)
+		netif_napi_add(ethsw->ports[0]->netdev,
+			       &ethsw->fq[i].napi, dpaa2_switch_poll,
+			       NAPI_POLL_WEIGHT);
+
 	err = dpsw_enable(ethsw->mc_io, 0, ethsw->dpsw_handle);
 	if (err) {
 		dev_err(ethsw->dev, "dpsw_enable err %d\n", err);
@@ -1894,18 +2315,28 @@ static int dpaa2_switch_probe(struct fsl_mc_device *sw_dev)
 	if (err)
 		goto err_stop;
 
-	dev_info(dev, "probed %d port switch\n", ethsw->sw_attr.num_ifs);
+	/* Register the netdev only when the entire setup is done and the
+	 * switch port interfaces are ready to receive traffic
+	 */
+	for (i = 0; i < ethsw->sw_attr.num_ifs; i++) {
+		err = register_netdev(ethsw->ports[i]->netdev);
+		if (err < 0) {
+			dev_err(dev, "register_netdev error %d\n", err);
+			goto err_unregister_ports;
+		}
+	}
+
 	return 0;
 
+err_unregister_ports:
+	for (i--; i >= 0; i--)
+		unregister_netdev(ethsw->ports[i]->netdev);
 err_stop:
 	dpsw_disable(ethsw->mc_io, 0, ethsw->dpsw_handle);
 
 err_free_ports:
-	/* Cleanup registered ports only */
-	for (i--; i >= 0; i--) {
-		unregister_netdev(ethsw->ports[i]->netdev);
+	for (i--; i >= 0; i--)
 		free_netdev(ethsw->ports[i]->netdev);
-	}
 	kfree(ethsw->ports);
 
 err_takedown:
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
index 50dd529e2a79..238f16561979 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
@@ -53,6 +53,19 @@
 
 #define DPAA2_SWITCH_STORE_SIZE 16
 
+/* Buffer management */
+#define BUFS_PER_CMD			7
+#define DPAA2_ETHSW_NUM_BUFS		(1024 * BUFS_PER_CMD)
+#define DPAA2_ETHSW_REFILL_THRESH	(DPAA2_ETHSW_NUM_BUFS * 5 / 6)
+
+/* Number of times to retry DPIO portal operations while waiting
+ * for portal to finish executing current command and become
+ * available. We want to avoid being stuck in a while loop in case
+ * hardware becomes unresponsive, but not give up too easily if
+ * the portal really is busy for valid reasons
+ */
+#define DPAA2_SWITCH_SWP_BUSY_RETRIES		1000
+
 extern const struct ethtool_ops dpaa2_switch_port_ethtool_ops;
 
 struct ethsw_core;
@@ -62,6 +75,7 @@ struct dpaa2_switch_fq {
 	enum dpsw_queue_type type;
 	struct dpaa2_io_store *store;
 	struct dpaa2_io_notification_ctx nctx;
+	struct napi_struct napi;
 	u32 fqid;
 };
 
@@ -89,6 +103,7 @@ struct ethsw_core {
 	unsigned long			features;
 	int				dev_id;
 	struct ethsw_port_priv		**ports;
+	struct iommu_domain		*iommu_domain;
 
 	u8				vlans[VLAN_VID_MASK + 1];
 
@@ -99,7 +114,9 @@ struct ethsw_core {
 
 	struct dpaa2_switch_fq		fq[DPAA2_SWITCH_RX_NUM_FQS];
 	struct fsl_mc_device		*dpbp_dev;
+	int				buf_count;
 	u16				bpid;
+	int				napi_users;
 };
 
 static inline bool dpaa2_switch_supports_cpu_traffic(struct ethsw_core *ethsw)
-- 
2.30.0

