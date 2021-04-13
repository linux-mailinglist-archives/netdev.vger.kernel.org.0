Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7EF35E2B2
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 17:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346652AbhDMPXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 11:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346640AbhDMPXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 11:23:02 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BADC061756;
        Tue, 13 Apr 2021 08:22:42 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id y2so8405888plg.5;
        Tue, 13 Apr 2021 08:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rEnojfxzKMIKinSbA6nTujnDRb/izr87Op+NW+5m2CE=;
        b=XFpasjOZk+H4LLKL4mlCbTAycGSs2LUXz/hrOiohXGQIgf6xFZlBX3DMBRZsKCKkKP
         aoyLkIPqYPyQhBVALx5HVVmuovtpoetQxBM7Jc9tfVAoCnDQ9vaNMm/CTJlG5Pw1AIRf
         eH8/SvcpUbjvfgmYgDZps5of0O1vfQzg3qqA8nOilJHUx7WcL6YArmMG1H3mrBwgDfQm
         jUwDREIue/hbNmFGIrNcFRkCYM9vLmgfJDv9AgEWQ8bY118oc/APupS4BRsceon0QG1A
         EYImIlHMWJZPtiksudaB9+f5/hRDGYoqyLXhdLlQeCkldn6m/joV9mDcuplWZVicrJlp
         5X0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rEnojfxzKMIKinSbA6nTujnDRb/izr87Op+NW+5m2CE=;
        b=YyTTJv32FRNKwEmPbAHqtK43TcOB4OwM8EpEZB9+PU5l+IbeN5eHKPJJA/wE3WykwH
         rZfW0MeVCTJnyrJ44u3rhMR5MgQd87Q9sT9NCdRBr6DkFhGJZbJWqdB4YXBIVGfQ7PFE
         ZXso7U0gqQW1N7+oqGBU/tj7AYbdsv6nmcvQQnpBQuijtLrxeGIHHL1FPCdC0IH6lk6Y
         PNhhTe09HXuYN4gd/n97ISAEGRCiBAIArbCzGkyUOromDa+F+VV8o/0WorF1QQydKcHP
         DMwiW1K7AvSsOoYlKgyous5b2AJUdBnl+z/5HUypljzwkJ7wmlf/u0mRJro1Ee6nYpxe
         Uj2g==
X-Gm-Message-State: AOAM533GQ86aTEQ1WmC4wSs41kIvUm0zeJVlQgFAPhQ1kx7TkQy6QCA0
        Ufgcs7zwRf+jOJCLjbz82FI=
X-Google-Smtp-Source: ABdhPJwe99OU9JAMHjujM5wbIkHXoLVzuJVclSN7ThfPg6rD4edQB9JEbxmZS+evcRtOb0i5b1J3Cw==
X-Received: by 2002:a17:90b:400a:: with SMTP id ie10mr562730pjb.210.1618327362565;
        Tue, 13 Apr 2021 08:22:42 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:36:5b29:fe1a:45c9:c61c])
        by smtp.gmail.com with ESMTPSA id y3sm12882026pfg.145.2021.04.13.08.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 08:22:42 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        sunilmut@microsoft.com
Subject: [RFC V2 PATCH 11/12] HV/Netvsc: Add Isolation VM support for netvsc driver
Date:   Tue, 13 Apr 2021 11:22:16 -0400
Message-Id: <20210413152217.3386288-12-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210413152217.3386288-1-ltykernel@gmail.com>
References: <20210413152217.3386288-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

In Isolation VM, all shared memory with host needs to mark visible
to host via hvcall. vmbus_establish_gpadl() has already done it for
netvsc rx/tx ring buffer. The page buffer used by vmbus_sendpacket_
pagebuffer() still need to handle. Use DMA API to map/umap these
memory during sending/receiving packet and Hyper-V DMA ops callback
will use swiotlb fucntion to allocate bounce buffer and copy data
from/to bounce buffer.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 drivers/net/hyperv/hyperv_net.h   |  11 +++
 drivers/net/hyperv/netvsc.c       | 137 ++++++++++++++++++++++++++++--
 drivers/net/hyperv/rndis_filter.c |   3 +
 3 files changed, 144 insertions(+), 7 deletions(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index 2a87cfa27ac0..d85f811238c7 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -130,6 +130,7 @@ struct hv_netvsc_packet {
 	u32 total_bytes;
 	u32 send_buf_index;
 	u32 total_data_buflen;
+	struct dma_range *dma_range;
 };
 
 #define NETVSC_HASH_KEYLEN 40
@@ -1026,6 +1027,7 @@ struct netvsc_device {
 
 	/* Receive buffer allocated by us but manages by NetVSP */
 	void *recv_buf;
+	void *recv_original_buf;
 	u32 recv_buf_size; /* allocated bytes */
 	u32 recv_buf_gpadl_handle;
 	u32 recv_section_cnt;
@@ -1034,6 +1036,8 @@ struct netvsc_device {
 
 	/* Send buffer allocated by us */
 	void *send_buf;
+	void *send_original_buf;
+	u32 send_buf_size;
 	u32 send_buf_gpadl_handle;
 	u32 send_section_cnt;
 	u32 send_section_size;
@@ -1715,4 +1719,11 @@ struct rndis_message {
 #define TRANSPORT_INFO_IPV6_TCP 0x10
 #define TRANSPORT_INFO_IPV6_UDP 0x20
 
+struct dma_range {
+	dma_addr_t dma;
+	u32 mapping_size;
+};
+
+void netvsc_dma_unmap(struct hv_device *hv_dev,
+		      struct hv_netvsc_packet *packet);
 #endif /* _HYPERV_NET_H */
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 2353623259f3..1a5f5be4eeea 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -26,6 +26,7 @@
 
 #include "hyperv_net.h"
 #include "netvsc_trace.h"
+#include "../../hv/hyperv_vmbus.h"
 
 /*
  * Switch the data path from the synthetic interface to the VF
@@ -119,8 +120,21 @@ static void free_netvsc_device(struct rcu_head *head)
 	int i;
 
 	kfree(nvdev->extension);
-	vfree(nvdev->recv_buf);
-	vfree(nvdev->send_buf);
+
+	if (nvdev->recv_original_buf) {
+		iounmap(nvdev->recv_buf);
+		vfree(nvdev->recv_original_buf);
+	} else {
+		vfree(nvdev->recv_buf);
+	}
+
+	if (nvdev->send_original_buf) {
+		iounmap(nvdev->send_buf);
+		vfree(nvdev->send_original_buf);
+	} else {
+		vfree(nvdev->send_buf);
+	}
+
 	kfree(nvdev->send_section_map);
 
 	for (i = 0; i < VRSS_CHANNEL_MAX; i++) {
@@ -302,9 +316,12 @@ static int netvsc_init_buf(struct hv_device *device,
 	struct nvsp_1_message_send_receive_buffer_complete *resp;
 	struct net_device *ndev = hv_get_drvdata(device);
 	struct nvsp_message *init_packet;
+	struct vm_struct *area;
+	u64 extra_phys;
 	unsigned int buf_size;
+	unsigned long vaddr;
 	size_t map_words;
-	int ret = 0;
+	int ret = 0, i;
 
 	/* Get receive buffer area. */
 	buf_size = device_info->recv_sections * device_info->recv_section_size;
@@ -340,6 +357,27 @@ static int netvsc_init_buf(struct hv_device *device,
 		goto cleanup;
 	}
 
+	if (hv_isolation_type_snp()) {
+		area = get_vm_area(buf_size, VM_IOREMAP);
+		if (!area)
+			goto cleanup;
+
+		vaddr = (unsigned long)area->addr;
+		for (i = 0; i < buf_size / HV_HYP_PAGE_SIZE; i++) {
+			extra_phys = (virt_to_hvpfn(net_device->recv_buf + i * HV_HYP_PAGE_SIZE)
+				<< HV_HYP_PAGE_SHIFT) + ms_hyperv.shared_gpa_boundary;
+			ret |= ioremap_page_range(vaddr + i * HV_HYP_PAGE_SIZE,
+					   vaddr + (i + 1) * HV_HYP_PAGE_SIZE,
+					   extra_phys, PAGE_KERNEL_IO);
+		}
+
+		if (ret)
+			goto cleanup;
+
+		net_device->recv_original_buf = net_device->recv_buf;
+		net_device->recv_buf = (void *)vaddr;
+	}
+
 	/* Notify the NetVsp of the gpadl handle */
 	init_packet = &net_device->channel_init_pkt;
 	memset(init_packet, 0, sizeof(struct nvsp_message));
@@ -432,6 +470,28 @@ static int netvsc_init_buf(struct hv_device *device,
 		goto cleanup;
 	}
 
+	if (hv_isolation_type_snp()) {
+		area = get_vm_area(buf_size, VM_IOREMAP);
+		if (!area)
+			goto cleanup;
+
+		vaddr = (unsigned long)area->addr;
+
+		for (i = 0; i < buf_size / HV_HYP_PAGE_SIZE; i++) {
+			extra_phys = (virt_to_hvpfn(net_device->send_buf + i * HV_HYP_PAGE_SIZE)
+				<< HV_HYP_PAGE_SHIFT) + ms_hyperv.shared_gpa_boundary;
+			ret |= ioremap_page_range(vaddr + i * HV_HYP_PAGE_SIZE,
+					   vaddr + (i + 1) * HV_HYP_PAGE_SIZE,
+					   extra_phys, PAGE_KERNEL_IO);
+		}
+
+		if (ret)
+			goto cleanup;
+
+		net_device->send_original_buf = net_device->send_buf;
+		net_device->send_buf = (void *)vaddr;
+	}
+
 	/* Notify the NetVsp of the gpadl handle */
 	init_packet = &net_device->channel_init_pkt;
 	memset(init_packet, 0, sizeof(struct nvsp_message));
@@ -722,7 +782,7 @@ static void netvsc_send_tx_complete(struct net_device *ndev,
 
 	/* Notify the layer above us */
 	if (likely(skb)) {
-		const struct hv_netvsc_packet *packet
+		struct hv_netvsc_packet *packet
 			= (struct hv_netvsc_packet *)skb->cb;
 		u32 send_index = packet->send_buf_index;
 		struct netvsc_stats *tx_stats;
@@ -738,6 +798,7 @@ static void netvsc_send_tx_complete(struct net_device *ndev,
 		tx_stats->bytes += packet->total_bytes;
 		u64_stats_update_end(&tx_stats->syncp);
 
+		netvsc_dma_unmap(ndev_ctx->device_ctx, packet);
 		napi_consume_skb(skb, budget);
 	}
 
@@ -878,6 +939,60 @@ static void netvsc_copy_to_send_buf(struct netvsc_device *net_device,
 		memset(dest, 0, padding);
 }
 
+void netvsc_dma_unmap(struct hv_device *hv_dev,
+		      struct hv_netvsc_packet *packet)
+{
+	u32 page_count = packet->cp_partial ?
+		packet->page_buf_cnt - packet->rmsg_pgcnt :
+		packet->page_buf_cnt;
+	int i;
+
+	if (!packet->dma_range)
+		return;
+
+	for (i = 0; i < page_count; i++)
+		dma_unmap_single(&hv_dev->device, packet->dma_range[i].dma,
+				 packet->dma_range[i].mapping_size,
+				 DMA_TO_DEVICE);
+
+	kfree(packet->dma_range);
+}
+
+int netvsc_dma_map(struct hv_device *hv_dev,
+		   struct hv_netvsc_packet *packet,
+		   struct hv_page_buffer *pb)
+{
+	u32 page_count =  packet->cp_partial ?
+		packet->page_buf_cnt - packet->rmsg_pgcnt :
+		packet->page_buf_cnt;
+	dma_addr_t dma;
+	int i;
+
+	packet->dma_range = kzalloc(sizeof(struct dma_range) * page_count,
+			      GFP_KERNEL);
+	if (!packet->dma_range)
+		return -ENOMEM;
+
+	for (i = 0; i < page_count; i++) {
+		char *src = phys_to_virt((pb[i].pfn << HV_HYP_PAGE_SHIFT)
+					 + pb[i].offset);
+		u32 len = pb[i].len;
+
+		dma = dma_map_single(&hv_dev->device, src, len,
+				     DMA_TO_DEVICE);
+		if (dma_mapping_error(&hv_dev->device, dma))
+			return -ENOMEM;
+
+		packet->dma_range[i].dma = dma;
+		packet->dma_range[i].mapping_size = len;
+		pb[i].pfn = dma >> HV_HYP_PAGE_SHIFT;
+		pb[i].offset = offset_in_hvpage(dma);
+		pb[i].len = len;
+	}
+
+	return 0;
+}
+
 static inline int netvsc_send_pkt(
 	struct hv_device *device,
 	struct hv_netvsc_packet *packet,
@@ -917,14 +1032,22 @@ static inline int netvsc_send_pkt(
 
 	trace_nvsp_send_pkt(ndev, out_channel, rpkt);
 
+	packet->dma_range = NULL;
 	if (packet->page_buf_cnt) {
 		if (packet->cp_partial)
 			pb += packet->rmsg_pgcnt;
 
+		ret = netvsc_dma_map(ndev_ctx->device_ctx, packet, pb);
+		if (ret)
+			return ret;
+
 		ret = vmbus_sendpacket_pagebuffer(out_channel,
-						  pb, packet->page_buf_cnt,
-						  &nvmsg, sizeof(nvmsg),
-						  req_id);
+					  pb, packet->page_buf_cnt,
+					  &nvmsg, sizeof(nvmsg),
+					  req_id);
+
+		if (ret)
+			netvsc_dma_unmap(ndev_ctx->device_ctx, packet);
 	} else {
 		ret = vmbus_sendpacket(out_channel,
 				       &nvmsg, sizeof(nvmsg),
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 598713c0d5a8..b19243f5874c 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -263,6 +263,8 @@ static void rndis_filter_receive_response(struct net_device *ndev,
 {
 	struct rndis_device *dev = nvdev->extension;
 	struct rndis_request *request = NULL;
+	struct hv_device *hv_dev = ((struct net_device_context *)
+			netdev_priv(ndev))->device_ctx;
 	bool found = false;
 	unsigned long flags;
 
@@ -327,6 +329,7 @@ static void rndis_filter_receive_response(struct net_device *ndev,
 			}
 		}
 
+		netvsc_dma_unmap(hv_dev, &request->pkt);
 		complete(&request->wait_event);
 	} else {
 		netdev_err(ndev,
-- 
2.25.1

