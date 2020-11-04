Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDCBF2A6B34
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 17:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731789AbgKDQ5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 11:57:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731604AbgKDQ5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 11:57:37 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA6AC0613D3;
        Wed,  4 Nov 2020 08:57:36 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id dk16so30143849ejb.12;
        Wed, 04 Nov 2020 08:57:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qhRqvxUZrEd1m4RzHpRk8WdDFyQDvwBIOeoFsilq4Eg=;
        b=LWmZE3IaQ+7eHHX6/NojbP9kjmjYmQp4JUKxOlEAiCmQiIfcTRwAV+zBgOWO10W5AR
         fOLuxjBcG3y62MaQI+jpusUrauHhb9vx+ODU0uC/W6EExRm5KNsBaSZsQrMm0LKTYiEK
         zfCiA360TZQNQReAR6je69NieRDAr+54I7hK9SOVeiw+0JRUl5UsUDabI9OTJw+mNdfn
         HoKDlzI/35tHPhPzyaMu5jC0zRYJy3LVg0jbYfxbnerMzJrQ0HAs/xOpXstIeaMmQvIA
         PdbU0BDZVKft9cW9n/AFH4NwteDLXI8DvAd/oPOt4B0b0w340Y6uYzy1hALMzCNz4R+V
         q8UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qhRqvxUZrEd1m4RzHpRk8WdDFyQDvwBIOeoFsilq4Eg=;
        b=Z3n77IBLpMdfYzlc1vajdPPuVY+MnrQlh/xGKx3Q+Nxr+d3qiP7tl1vA2PSZLgBuZG
         svE6P3MsHFjM5jpNMnYOxg5GDAQm/8ZTlZXWhc7LZ4IH2q1mk3LxT5m/TtO+osL4YZSU
         m9VvMJ6c9wiOIRHru9EAdrop/ZY2kUK+aBqpJ7jB/zGpfbmxiovzjc0jTWgixAf8G5Pz
         AXBl9KjWz7X5Wx5JGua1+yGbdXXBjJR3x6yAmQexA4Eg+7OKFMudYQ/2bBxWtOK76gIQ
         K4FcPM7jKdPG7APGmJ97suGeCx3ZGu221G7xuntPZ4YDSpJ85LvMoMG8+lEC3Rmfrnbr
         YSIQ==
X-Gm-Message-State: AOAM531h/gx53kp6O1BdEhOqM17CQPu+BHPannovs1qjP33zD4DxuXon
        4We27tc81C849M035XdLAgkmyGO0VSTCbA==
X-Google-Smtp-Source: ABdhPJw50agibUEdGFi7t7TCZw6UKF/HMhPWHX3lI2F26KZbXIyljfs3SBIfl3z79XLcfzBirOBkuQ==
X-Received: by 2002:a17:907:20c3:: with SMTP id qq3mr22192568ejb.274.1604509054801;
        Wed, 04 Nov 2020 08:57:34 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id l12sm1354748edt.46.2020.11.04.08.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 08:57:34 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [RFC 5/9] staging: dpaa2-switch: handle Rx path on control interface
Date:   Wed,  4 Nov 2020 18:57:16 +0200
Message-Id: <20201104165720.2566399-6-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201104165720.2566399-1-ciorneiioana@gmail.com>
References: <20201104165720.2566399-1-ciorneiioana@gmail.com>
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
---
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c | 449 +++++++++++++++++++++++-
 drivers/staging/fsl-dpaa2/ethsw/ethsw.h |  18 +
 2 files changed, 463 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index f8f972421fea..d09aa4a5126a 100644
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
@@ -496,9 +507,51 @@ static int dpaa2_switch_port_carrier_state_sync(struct net_device *netdev)
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
+	/* a new interface is using the NAPI instance */
+	ethsw->napi_users++;
+
+	/* if there is already a user of the instance, return */
+	if (ethsw->napi_users > 1)
+		return;
+
+	if (!dpaa2_switch_has_ctrl_if(ethsw))
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
+	/* If we are not the last interface using the NAPI, return */
+	ethsw->napi_users--;
+	if (ethsw->napi_users)
+		return;
+
+	if (!dpaa2_switch_has_ctrl_if(ethsw))
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
@@ -527,6 +580,8 @@ static int dpaa2_switch_port_open(struct net_device *netdev)
 		goto err_carrier_sync;
 	}
 
+	dpaa2_switch_enable_ctrl_if_napi(ethsw);
+
 	return 0;
 
 err_carrier_sync:
@@ -539,6 +594,7 @@ static int dpaa2_switch_port_open(struct net_device *netdev)
 static int dpaa2_switch_port_stop(struct net_device *netdev)
 {
 	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
+	struct ethsw_core *ethsw = port_priv->ethsw_data;
 	int err;
 
 	err = dpsw_if_disable(port_priv->ethsw_data->mc_io, 0,
@@ -549,6 +605,8 @@ static int dpaa2_switch_port_stop(struct net_device *netdev)
 		return err;
 	}
 
+	dpaa2_switch_disable_ctrl_if_napi(ethsw);
+
 	return 0;
 }
 
@@ -755,6 +813,28 @@ static int dpaa2_switch_port_set_mac_addr(struct ethsw_port_priv *port_priv)
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
@@ -1470,6 +1550,104 @@ static int dpaa2_switch_register_notifier(struct device *dev)
 	return err;
 }
 
+/* Build a linear skb based on a single-buffer frame descriptor */
+static struct sk_buff *dpaa2_switch_build_linear_skb(struct ethsw_core *ethsw,
+						     const struct dpaa2_fd *fd)
+{
+	u16 fd_offset = dpaa2_fd_get_offset(fd);
+	u32 fd_length = dpaa2_fd_get_len(fd);
+	struct device *dev = ethsw->dev;
+	struct sk_buff *skb = NULL;
+	dma_addr_t addr;
+	void *fd_vaddr;
+
+	addr = dpaa2_fd_get_addr(fd);
+	dma_unmap_single(dev, addr, DPAA2_SWITCH_RX_BUF_SIZE,
+			 DMA_FROM_DEVICE);
+	fd_vaddr = dpaa2_iova_to_virt(ethsw->iommu_domain, addr);
+	prefetch(fd_vaddr + fd_offset);
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
+static void dpaa2_switch_tx_conf(struct dpaa2_switch_fq *fq,
+				 const struct dpaa2_fd *fd)
+{
+	dpaa2_switch_free_fd(fq->ethsw, fd);
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
+	int if_id = -1;
+	int err;
+
+	/* prefetch the frame descriptor */
+	prefetch(fd);
+
+	/* get switch ingress interface ID */
+	if_id = upper_32_bits(dpaa2_fd_get_flc(fd)) & 0x0000FFFF;
+
+	if (if_id < 0 || if_id >= ethsw->sw_attr.num_ifs) {
+		dev_err(ethsw->dev, "Frame received from unknown interface!\n");
+		goto err_free_fd;
+	}
+	port_priv = ethsw->ports[if_id];
+	netdev = port_priv->netdev;
+
+	/* build the SKB based on the FD received */
+	if (dpaa2_fd_get_format(fd) == dpaa2_fd_single) {
+		skb = dpaa2_switch_build_linear_skb(ethsw, fd);
+	} else {
+		netdev_err(netdev, "Received invalid frame format\n");
+		goto err_free_fd;
+	}
+
+	if (unlikely(!skb))
+		goto err_free_fd;
+
+	skb_reset_mac_header(skb);
+
+	/* Remove PVID from received frame */
+	hdr = vlan_eth_hdr(skb);
+	vid = ntohs(hdr->h_vlan_TCI) & VLAN_VID_MASK;
+	if (vid == port_priv->pvid) {
+		err = __skb_vlan_pop(skb, &vlan_tci);
+		if (err) {
+			dev_info(ethsw->dev, "skb_vlan_pop() failed %d", err);
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
@@ -1486,7 +1664,7 @@ static int dpaa2_switch_setup_fqs(struct ethsw_core *ethsw)
 	int err;
 
 	err = dpsw_ctrl_if_get_attributes(ethsw->mc_io, 0, ethsw->dpsw_handle,
-					  &ctrl_if_attr);
+			&ctrl_if_attr);
 	if (err) {
 		dev_err(dev, "dpsw_ctrl_if_get_attributes() = %d\n", err);
 		return err;
@@ -1494,15 +1672,158 @@ static int dpaa2_switch_setup_fqs(struct ethsw_core *ethsw)
 
 	ethsw->fq[i].fqid = ctrl_if_attr.rx_fqid;
 	ethsw->fq[i].ethsw = ethsw;
-	ethsw->fq[i++].type = DPSW_QUEUE_RX;
+	ethsw->fq[i].type = DPSW_QUEUE_RX;
+	ethsw->fq[i++].consume = dpaa2_switch_rx;
+
 
 	ethsw->fq[i].fqid = ctrl_if_attr.tx_err_conf_fqid;
 	ethsw->fq[i].ethsw = ethsw;
-	ethsw->fq[i++].type = DPSW_QUEUE_TX_ERR_CONF;
+	ethsw->fq[i].type = DPSW_QUEUE_TX_ERR_CONF;
+	ethsw->fq[i++].consume = dpaa2_switch_tx_conf;
 
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
+			       DMA_BIDIRECTIONAL);
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
@@ -1607,6 +1928,106 @@ static void dpaa2_switch_destroy_rings(struct ethsw_core *ethsw)
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
+		err = dpaa2_io_service_pull_fq(NULL,
+					       fq->fqid,
+					       fq->store);
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
+		/* Process the FD */
+		fq->consume(fq, dpaa2_dq_fd(dq));
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
+	/* We didn't consume entire budget, so finish napi and
+	 * re-enable data availability notifications
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
+	napi_schedule_irqoff(&fq->napi);
+}
+
 static int dpaa2_switch_setup_dpio(struct ethsw_core *ethsw)
 {
 	struct dpsw_ctrl_if_queue_cfg queue_cfg;
@@ -1623,6 +2044,7 @@ static int dpaa2_switch_setup_dpio(struct ethsw_core *ethsw)
 		nctx->is_cdan = 0;
 		nctx->id = ethsw->fq[i].fqid;
 		nctx->desired_cpu = DPAA2_IO_ANY_CPU;
+		nctx->cb = dpaa2_switch_fqdan_cb;
 		err = dpaa2_io_service_register(NULL, nctx, ethsw->dev);
 		if (err) {
 			err = -EPROBE_DEFER;
@@ -1679,10 +2101,14 @@ static int dpaa2_switch_ctrl_if_setup(struct ethsw_core *ethsw)
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
@@ -1691,6 +2117,8 @@ static int dpaa2_switch_ctrl_if_setup(struct ethsw_core *ethsw)
 
 err_destroy_rings:
 	dpaa2_switch_destroy_rings(ethsw);
+err_drain_dpbp:
+	dpaa2_switch_drain_bp(ethsw);
 err_free_dpbp:
 	dpaa2_switch_free_dpbp(ethsw);
 
@@ -1879,6 +2307,7 @@ static void dpaa2_switch_ctrl_if_teardown(struct ethsw_core *ethsw)
 {
 	dpaa2_switch_free_dpio(ethsw);
 	dpaa2_switch_destroy_rings(ethsw);
+	dpaa2_switch_drain_bp(ethsw);
 	dpaa2_switch_free_dpbp(ethsw);
 }
 
@@ -1988,6 +2417,7 @@ static int dpaa2_switch_probe(struct fsl_mc_device *sw_dev)
 		return -ENOMEM;
 
 	ethsw->dev = dev;
+	ethsw->iommu_domain = iommu_get_domain_for_dev(dev);
 	dev_set_drvdata(dev, ethsw);
 
 	err = fsl_mc_portal_allocate(sw_dev, FSL_MC_IO_ATOMIC_CONTEXT_PORTAL,
@@ -2023,6 +2453,17 @@ static int dpaa2_switch_probe(struct fsl_mc_device *sw_dev)
 			goto err_free_ports;
 	}
 
+	/* Add a NAPI instance for each of the Rx queues. The first port's
+	 * net_device will be associated with the instances since we do not have
+	 * different queues for each switch ports.
+	 */
+	if (dpaa2_switch_has_ctrl_if(ethsw)) {
+		for (i = 0; i < DPAA2_SWITCH_RX_NUM_FQS; i++)
+			netif_napi_add(ethsw->ports[0]->netdev,
+				       &ethsw->fq[i].napi, dpaa2_switch_poll,
+				       NAPI_POLL_WEIGHT);
+	}
+
 	err = dpsw_enable(ethsw->mc_io, 0, ethsw->dpsw_handle);
 	if (err) {
 		dev_err(ethsw->dev, "dpsw_enable err %d\n", err);
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
index c78ee5409b8a..bd24be2c6308 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
@@ -53,15 +53,30 @@
 
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
 
 struct dpaa2_switch_fq {
+	void (*consume)(struct dpaa2_switch_fq *fq, const struct dpaa2_fd *fd);
 	struct ethsw_core *ethsw;
 	enum dpsw_queue_type type;
 	struct dpaa2_io_store *store;
 	struct dpaa2_io_notification_ctx nctx;
+	struct napi_struct napi;
 	u32 fqid;
 };
 
@@ -89,6 +104,7 @@ struct ethsw_core {
 	unsigned long			features;
 	int				dev_id;
 	struct ethsw_port_priv		**ports;
+	struct iommu_domain		*iommu_domain;
 
 	u8				vlans[VLAN_VID_MASK + 1];
 	bool				learning;
@@ -100,7 +116,9 @@ struct ethsw_core {
 
 	struct dpaa2_switch_fq		fq[DPAA2_SWITCH_RX_NUM_FQS];
 	struct fsl_mc_device		*dpbp_dev;
+	int				buf_count;
 	u16				bpid;
+	int				napi_users;
 };
 
 static inline bool dpaa2_switch_has_ctrl_if(struct ethsw_core *ethsw)
-- 
2.28.0

