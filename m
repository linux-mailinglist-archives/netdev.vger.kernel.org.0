Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5C526C0FC
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 11:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgIPJrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 05:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbgIPJrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 05:47:47 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205D1C06174A;
        Wed, 16 Sep 2020 02:47:47 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id l17so5591814edq.12;
        Wed, 16 Sep 2020 02:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yeJbBw2eHDwnQ559iCHev+7zqC69NXbokFEtWduqgfs=;
        b=N4h27BnNo54E9VJd/Qst4lxFVO7y05/Td5jucvasW7gDZR2NuqqvlCAtMWBOY9ybUV
         JoJ4vm8zjOy1wMYubrAw04x4UrDnjYquYTrTnjTXqd6Xr8rqOJwI5anrJkp2wYCxQtsM
         4sJ03s5Sywl9c97mKWYIa4zVAqwQtnT+1J6PVRjcxEjm/Bm5jlJrVD3PG+Fq6eO3dzZS
         zhQYzZILvcHr4LTX72EjU02d4SAfo9Y78Oz0VkGBbh1JVoALundDKc1qBLxV3GNh1n46
         R08ojTWbug+ybo74dogPklbX+LVPrNNqWMwbwaeAfnvvU8FsrHOpq94G9pZJqnnTmlv0
         gRUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yeJbBw2eHDwnQ559iCHev+7zqC69NXbokFEtWduqgfs=;
        b=Dl8KtKN1vgLBT3NAlXYfho4Q/2WVsIzBu09B4MxQW2r5wvf/ZJPgi1ZgfDIeXdnfkc
         cSK2IE6OfPVWy/tvVcfhvVBsh+jIR5Y6cCPrdcyo6hvfZ1FAYngA1LioOUQHSU0b21as
         nWZaymhSCxlKm7aP8Qym70lMnExrkQl4Ig5/1S9F9bqzKYcMrSSbz95bdirTH0xsQPLa
         QoKswVrWEqnI2jLpsFut/cPLJ9vkfHVjzODpCNPHaGb3xTpXwoXDvjvzbcODVEphZdnx
         XVV7WURq7TcqxMqO/P6flhLx/ChuZtUAF0UvcEWFUeuIhyvLS4WCMujaC6LSCdODBdBN
         rl/A==
X-Gm-Message-State: AOAM532xTjeJlphgysL/N4I63Vn7oinIfMYw0TiKOBV+XzrOXVUarWM6
        Qw5Hfalc0G4PbbT/DMCHbiPvEn3Vo+dhQIbmEKQ=
X-Google-Smtp-Source: ABdhPJzvC6rGuUR3GP9uCqBuk0kI6rpSrg4lCb+bHAn4QoDWndVwJf1v1oFGufFOK0AxQIKHVUDSUQ==
X-Received: by 2002:aa7:dcd2:: with SMTP id w18mr27173350edu.288.1600249665222;
        Wed, 16 Sep 2020 02:47:45 -0700 (PDT)
Received: from localhost.localdomain (ip-213-220-210-175.net.upcbroadband.cz. [213.220.210.175])
        by smtp.gmail.com with ESMTPSA id i14sm5975913ejp.2.2020.09.16.02.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 02:47:44 -0700 (PDT)
From:   "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, linux-hyperv@vger.kernel.org,
        Andres Beltran <lkmlabelt@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        Andrea Parri <parri.andrea@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH v3] hv_netvsc: Add validation for untrusted Hyper-V values
Date:   Wed, 16 Sep 2020 11:47:27 +0200
Message-Id: <20200916094727.46615-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andres Beltran <lkmlabelt@gmail.com>

For additional robustness in the face of Hyper-V errors or malicious
behavior, validate all values that originate from packets that Hyper-V
has sent to the guest in the host-to-guest ring buffer. Ensure that
invalid values cannot cause indexing off the end of an array, or
subvert an existing validation via integer overflow. Ensure that
outgoing packets do not have any leftover guest memory that has not
been zeroed out.

Signed-off-by: Andres Beltran <lkmlabelt@gmail.com>
Co-developed-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
Changes in v3:
  - Include header size in the estimate for hv_pkt_datalen (Haiyang)
Changes in v2:
  - Replace size check on struct nvsp_message with sub-checks (Haiyang)

 drivers/net/hyperv/hyperv_net.h   |   4 +
 drivers/net/hyperv/netvsc.c       | 124 ++++++++++++++++++++++++++----
 drivers/net/hyperv/netvsc_drv.c   |   7 ++
 drivers/net/hyperv/rndis_filter.c |  73 ++++++++++++++++--
 4 files changed, 188 insertions(+), 20 deletions(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index 4d2b2d48ff2a1..da78bd0fb2aa2 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -860,6 +860,10 @@ static inline u32 netvsc_rqstor_size(unsigned long ringbytes)
 	       ringbytes / NETVSC_MIN_IN_MSG_SIZE;
 }
 
+#define NETVSC_XFER_HEADER_SIZE(rng_cnt) \
+		(offsetof(struct vmtransfer_page_packet_header, ranges) + \
+		(rng_cnt) * sizeof(struct vmtransfer_page_range))
+
 struct multi_send_data {
 	struct sk_buff *skb; /* skb containing the pkt */
 	struct hv_netvsc_packet *pkt; /* netvsc pkt pending */
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 03e93e3ddbad8..db4d5b0a15105 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -388,6 +388,15 @@ static int netvsc_init_buf(struct hv_device *device,
 	net_device->recv_section_size = resp->sections[0].sub_alloc_size;
 	net_device->recv_section_cnt = resp->sections[0].num_sub_allocs;
 
+	/* Ensure buffer will not overflow */
+	if (net_device->recv_section_size < NETVSC_MTU_MIN || (u64)net_device->recv_section_size *
+	    (u64)net_device->recv_section_cnt > (u64)buf_size) {
+		netdev_err(ndev, "invalid recv_section_size %u\n",
+			   net_device->recv_section_size);
+		ret = -EINVAL;
+		goto cleanup;
+	}
+
 	/* Setup receive completion ring.
 	 * Add 1 to the recv_section_cnt because at least one entry in a
 	 * ring buffer has to be empty.
@@ -460,6 +469,12 @@ static int netvsc_init_buf(struct hv_device *device,
 	/* Parse the response */
 	net_device->send_section_size = init_packet->msg.
 				v1_msg.send_send_buf_complete.section_size;
+	if (net_device->send_section_size < NETVSC_MTU_MIN) {
+		netdev_err(ndev, "invalid send_section_size %u\n",
+			   net_device->send_section_size);
+		ret = -EINVAL;
+		goto cleanup;
+	}
 
 	/* Section count is simply the size divided by the section size. */
 	net_device->send_section_cnt = buf_size / net_device->send_section_size;
@@ -740,12 +755,49 @@ static void netvsc_send_completion(struct net_device *ndev,
 				   int budget)
 {
 	const struct nvsp_message *nvsp_packet = hv_pkt_data(desc);
+	u32 msglen = hv_pkt_datalen(desc);
+
+	/* Ensure packet is big enough to read header fields */
+	if (msglen < sizeof(struct nvsp_message_header)) {
+		netdev_err(ndev, "nvsp_message length too small: %u\n", msglen);
+		return;
+	}
 
 	switch (nvsp_packet->hdr.msg_type) {
 	case NVSP_MSG_TYPE_INIT_COMPLETE:
+		if (msglen < sizeof(struct nvsp_message_header) +
+				sizeof(struct nvsp_message_init_complete)) {
+			netdev_err(ndev, "nvsp_msg length too small: %u\n",
+				   msglen);
+			return;
+		}
+		fallthrough;
+
 	case NVSP_MSG1_TYPE_SEND_RECV_BUF_COMPLETE:
+		if (msglen < sizeof(struct nvsp_message_header) +
+				sizeof(struct nvsp_1_message_send_receive_buffer_complete)) {
+			netdev_err(ndev, "nvsp_msg1 length too small: %u\n",
+				   msglen);
+			return;
+		}
+		fallthrough;
+
 	case NVSP_MSG1_TYPE_SEND_SEND_BUF_COMPLETE:
+		if (msglen < sizeof(struct nvsp_message_header) +
+				sizeof(struct nvsp_1_message_send_send_buffer_complete)) {
+			netdev_err(ndev, "nvsp_msg1 length too small: %u\n",
+				   msglen);
+			return;
+		}
+		fallthrough;
+
 	case NVSP_MSG5_TYPE_SUBCHANNEL:
+		if (msglen < sizeof(struct nvsp_message_header) +
+				sizeof(struct nvsp_5_subchannel_complete)) {
+			netdev_err(ndev, "nvsp_msg5 length too small: %u\n",
+				   msglen);
+			return;
+		}
 		/* Copy the response back */
 		memcpy(&net_device->channel_init_pkt, nvsp_packet,
 		       sizeof(struct nvsp_message));
@@ -1126,19 +1178,28 @@ static void enq_receive_complete(struct net_device *ndev,
 static int netvsc_receive(struct net_device *ndev,
 			  struct netvsc_device *net_device,
 			  struct netvsc_channel *nvchan,
-			  const struct vmpacket_descriptor *desc,
-			  const struct nvsp_message *nvsp)
+			  const struct vmpacket_descriptor *desc)
 {
 	struct net_device_context *net_device_ctx = netdev_priv(ndev);
 	struct vmbus_channel *channel = nvchan->channel;
 	const struct vmtransfer_page_packet_header *vmxferpage_packet
 		= container_of(desc, const struct vmtransfer_page_packet_header, d);
+	const struct nvsp_message *nvsp = hv_pkt_data(desc);
+	u32 msglen = hv_pkt_datalen(desc);
 	u16 q_idx = channel->offermsg.offer.sub_channel_index;
 	char *recv_buf = net_device->recv_buf;
 	u32 status = NVSP_STAT_SUCCESS;
 	int i;
 	int count = 0;
 
+	/* Ensure packet is big enough to read header fields */
+	if (msglen < sizeof(struct nvsp_message_header)) {
+		netif_err(net_device_ctx, rx_err, ndev,
+			  "invalid nvsp header, length too small: %u\n",
+			  msglen);
+		return 0;
+	}
+
 	/* Make sure this is a valid nvsp packet */
 	if (unlikely(nvsp->hdr.msg_type != NVSP_MSG1_TYPE_SEND_RNDIS_PKT)) {
 		netif_err(net_device_ctx, rx_err, ndev,
@@ -1147,6 +1208,14 @@ static int netvsc_receive(struct net_device *ndev,
 		return 0;
 	}
 
+	/* Validate xfer page pkt header */
+	if ((desc->offset8 << 3) < sizeof(struct vmtransfer_page_packet_header)) {
+		netif_err(net_device_ctx, rx_err, ndev,
+			  "Invalid xfer page pkt, offset too small: %u\n",
+			  desc->offset8 << 3);
+		return 0;
+	}
+
 	if (unlikely(vmxferpage_packet->xfer_pageset_id != NETVSC_RECEIVE_BUFFER_ID)) {
 		netif_err(net_device_ctx, rx_err, ndev,
 			  "Invalid xfer page set id - expecting %x got %x\n",
@@ -1157,6 +1226,14 @@ static int netvsc_receive(struct net_device *ndev,
 
 	count = vmxferpage_packet->range_cnt;
 
+	/* Check count for a valid value */
+	if (NETVSC_XFER_HEADER_SIZE(count) > desc->offset8 << 3) {
+		netif_err(net_device_ctx, rx_err, ndev,
+			  "Range count is not valid: %d\n",
+			  count);
+		return 0;
+	}
+
 	/* Each range represents 1 RNDIS pkt that contains 1 ethernet frame */
 	for (i = 0; i < count; i++) {
 		u32 offset = vmxferpage_packet->ranges[i].byte_offset;
@@ -1164,7 +1241,8 @@ static int netvsc_receive(struct net_device *ndev,
 		void *data;
 		int ret;
 
-		if (unlikely(offset + buflen > net_device->recv_buf_size)) {
+		if (unlikely(offset > net_device->recv_buf_size ||
+			     buflen > net_device->recv_buf_size - offset)) {
 			nvchan->rsc.cnt = 0;
 			status = NVSP_STAT_FAIL;
 			netif_err(net_device_ctx, rx_err, ndev,
@@ -1203,6 +1281,13 @@ static void netvsc_send_table(struct net_device *ndev,
 	u32 count, offset, *tab;
 	int i;
 
+	/* Ensure packet is big enough to read send_table fields */
+	if (msglen < sizeof(struct nvsp_message_header) +
+		     sizeof(struct nvsp_5_send_indirect_table)) {
+		netdev_err(ndev, "nvsp_v5_msg length too small: %u\n", msglen);
+		return;
+	}
+
 	count = nvmsg->msg.v5_msg.send_table.count;
 	offset = nvmsg->msg.v5_msg.send_table.offset;
 
@@ -1234,10 +1319,18 @@ static void netvsc_send_table(struct net_device *ndev,
 }
 
 static void netvsc_send_vf(struct net_device *ndev,
-			   const struct nvsp_message *nvmsg)
+			   const struct nvsp_message *nvmsg,
+			   u32 msglen)
 {
 	struct net_device_context *net_device_ctx = netdev_priv(ndev);
 
+	/* Ensure packet is big enough to read its fields */
+	if (msglen < sizeof(struct nvsp_message_header) +
+		     sizeof(struct nvsp_4_send_vf_association)) {
+		netdev_err(ndev, "nvsp_v4_msg length too small: %u\n", msglen);
+		return;
+	}
+
 	net_device_ctx->vf_alloc = nvmsg->msg.v4_msg.vf_assoc.allocated;
 	net_device_ctx->vf_serial = nvmsg->msg.v4_msg.vf_assoc.serial;
 	netdev_info(ndev, "VF slot %u %s\n",
@@ -1247,16 +1340,24 @@ static void netvsc_send_vf(struct net_device *ndev,
 
 static void netvsc_receive_inband(struct net_device *ndev,
 				  struct netvsc_device *nvscdev,
-				  const struct nvsp_message *nvmsg,
-				  u32 msglen)
+				  const struct vmpacket_descriptor *desc)
 {
+	const struct nvsp_message *nvmsg = hv_pkt_data(desc);
+	u32 msglen = hv_pkt_datalen(desc);
+
+	/* Ensure packet is big enough to read header fields */
+	if (msglen < sizeof(struct nvsp_message_header)) {
+		netdev_err(ndev, "inband nvsp_message length too small: %u\n", msglen);
+		return;
+	}
+
 	switch (nvmsg->hdr.msg_type) {
 	case NVSP_MSG5_TYPE_SEND_INDIRECTION_TABLE:
 		netvsc_send_table(ndev, nvscdev, nvmsg, msglen);
 		break;
 
 	case NVSP_MSG4_TYPE_SEND_VF_ASSOCIATION:
-		netvsc_send_vf(ndev, nvmsg);
+		netvsc_send_vf(ndev, nvmsg, msglen);
 		break;
 	}
 }
@@ -1270,23 +1371,20 @@ static int netvsc_process_raw_pkt(struct hv_device *device,
 {
 	struct vmbus_channel *channel = nvchan->channel;
 	const struct nvsp_message *nvmsg = hv_pkt_data(desc);
-	u32 msglen = hv_pkt_datalen(desc);
 
 	trace_nvsp_recv(ndev, channel, nvmsg);
 
 	switch (desc->type) {
 	case VM_PKT_COMP:
-		netvsc_send_completion(ndev, net_device, channel,
-				       desc, budget);
+		netvsc_send_completion(ndev, net_device, channel, desc, budget);
 		break;
 
 	case VM_PKT_DATA_USING_XFER_PAGES:
-		return netvsc_receive(ndev, net_device, nvchan,
-				      desc, nvmsg);
+		return netvsc_receive(ndev, net_device, nvchan, desc);
 		break;
 
 	case VM_PKT_DATA_INBAND:
-		netvsc_receive_inband(ndev, net_device, nvmsg, msglen);
+		netvsc_receive_inband(ndev, net_device, desc);
 		break;
 
 	default:
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 787f17e2a9716..720a381c951f2 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -748,6 +748,13 @@ void netvsc_linkstatus_callback(struct net_device *net,
 	struct netvsc_reconfig *event;
 	unsigned long flags;
 
+	/* Ensure the packet is big enough to access its fields */
+	if (resp->msg_len - RNDIS_HEADER_SIZE < sizeof(struct rndis_indicate_status)) {
+		netdev_err(net, "invalid rndis_indicate_status packet, len: %u\n",
+			   resp->msg_len);
+		return;
+	}
+
 	/* Update the physical link speed when changing to another vSwitch */
 	if (indicate->status == RNDIS_STATUS_LINK_SPEED_CHANGE) {
 		u32 speed;
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 10489ba44a090..fc78eac9aadec 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -275,6 +275,16 @@ static void rndis_filter_receive_response(struct net_device *ndev,
 		return;
 	}
 
+	/* Ensure the packet is big enough to read req_id. Req_id is the 1st
+	 * field in any request/response message, so the payload should have at
+	 * least sizeof(u32) bytes
+	 */
+	if (resp->msg_len - RNDIS_HEADER_SIZE < sizeof(u32)) {
+		netdev_err(ndev, "rndis msg_len too small: %u\n",
+			   resp->msg_len);
+		return;
+	}
+
 	spin_lock_irqsave(&dev->request_lock, flags);
 	list_for_each_entry(request, &dev->req_list, list_ent) {
 		/*
@@ -331,8 +341,9 @@ static void rndis_filter_receive_response(struct net_device *ndev,
  * Get the Per-Packet-Info with the specified type
  * return NULL if not found.
  */
-static inline void *rndis_get_ppi(struct rndis_packet *rpkt,
-				  u32 type, u8 internal)
+static inline void *rndis_get_ppi(struct net_device *ndev,
+				  struct rndis_packet *rpkt,
+				  u32 rpkt_len, u32 type, u8 internal)
 {
 	struct rndis_per_packet_info *ppi;
 	int len;
@@ -340,11 +351,36 @@ static inline void *rndis_get_ppi(struct rndis_packet *rpkt,
 	if (rpkt->per_pkt_info_offset == 0)
 		return NULL;
 
+	/* Validate info_offset and info_len */
+	if (rpkt->per_pkt_info_offset < sizeof(struct rndis_packet) ||
+	    rpkt->per_pkt_info_offset > rpkt_len) {
+		netdev_err(ndev, "Invalid per_pkt_info_offset: %u\n",
+			   rpkt->per_pkt_info_offset);
+		return NULL;
+	}
+
+	if (rpkt->per_pkt_info_len > rpkt_len - rpkt->per_pkt_info_offset) {
+		netdev_err(ndev, "Invalid per_pkt_info_len: %u\n",
+			   rpkt->per_pkt_info_len);
+		return NULL;
+	}
+
 	ppi = (struct rndis_per_packet_info *)((ulong)rpkt +
 		rpkt->per_pkt_info_offset);
 	len = rpkt->per_pkt_info_len;
 
 	while (len > 0) {
+		/* Validate ppi_offset and ppi_size */
+		if (ppi->size > len) {
+			netdev_err(ndev, "Invalid ppi size: %u\n", ppi->size);
+			continue;
+		}
+
+		if (ppi->ppi_offset >= ppi->size) {
+			netdev_err(ndev, "Invalid ppi_offset: %u\n", ppi->ppi_offset);
+			continue;
+		}
+
 		if (ppi->type == type && ppi->internal == internal)
 			return (void *)((ulong)ppi + ppi->ppi_offset);
 		len -= ppi->size;
@@ -388,14 +424,29 @@ static int rndis_filter_receive_data(struct net_device *ndev,
 	const struct ndis_pkt_8021q_info *vlan;
 	const struct rndis_pktinfo_id *pktinfo_id;
 	const u32 *hash_info;
-	u32 data_offset;
+	u32 data_offset, rpkt_len;
 	void *data;
 	bool rsc_more = false;
 	int ret;
 
+	/* Ensure data_buflen is big enough to read header fields */
+	if (data_buflen < RNDIS_HEADER_SIZE + sizeof(struct rndis_packet)) {
+		netdev_err(ndev, "invalid rndis pkt, data_buflen too small: %u\n",
+			   data_buflen);
+		return NVSP_STAT_FAIL;
+	}
+
+	/* Validate rndis_pkt offset */
+	if (rndis_pkt->data_offset >= data_buflen - RNDIS_HEADER_SIZE) {
+		netdev_err(ndev, "invalid rndis packet offset: %u\n",
+			   rndis_pkt->data_offset);
+		return NVSP_STAT_FAIL;
+	}
+
 	/* Remove the rndis header and pass it back up the stack */
 	data_offset = RNDIS_HEADER_SIZE + rndis_pkt->data_offset;
 
+	rpkt_len = data_buflen - RNDIS_HEADER_SIZE;
 	data_buflen -= data_offset;
 
 	/*
@@ -410,13 +461,13 @@ static int rndis_filter_receive_data(struct net_device *ndev,
 		return NVSP_STAT_FAIL;
 	}
 
-	vlan = rndis_get_ppi(rndis_pkt, IEEE_8021Q_INFO, 0);
+	vlan = rndis_get_ppi(ndev, rndis_pkt, rpkt_len, IEEE_8021Q_INFO, 0);
 
-	csum_info = rndis_get_ppi(rndis_pkt, TCPIP_CHKSUM_PKTINFO, 0);
+	csum_info = rndis_get_ppi(ndev, rndis_pkt, rpkt_len, TCPIP_CHKSUM_PKTINFO, 0);
 
-	hash_info = rndis_get_ppi(rndis_pkt, NBL_HASH_VALUE, 0);
+	hash_info = rndis_get_ppi(ndev, rndis_pkt, rpkt_len, NBL_HASH_VALUE, 0);
 
-	pktinfo_id = rndis_get_ppi(rndis_pkt, RNDIS_PKTINFO_ID, 1);
+	pktinfo_id = rndis_get_ppi(ndev, rndis_pkt, rpkt_len, RNDIS_PKTINFO_ID, 1);
 
 	data = (void *)msg + data_offset;
 
@@ -474,6 +525,14 @@ int rndis_filter_receive(struct net_device *ndev,
 	if (netif_msg_rx_status(net_device_ctx))
 		dump_rndis_message(ndev, rndis_msg);
 
+	/* Validate incoming rndis_message packet */
+	if (buflen < RNDIS_HEADER_SIZE || rndis_msg->msg_len < RNDIS_HEADER_SIZE ||
+	    buflen < rndis_msg->msg_len) {
+		netdev_err(ndev, "Invalid rndis_msg (buflen: %u, msg_len: %u)\n",
+			   buflen, rndis_msg->msg_len);
+		return NVSP_STAT_FAIL;
+	}
+
 	switch (rndis_msg->ndis_msg_type) {
 	case RNDIS_MSG_PACKET:
 		return rndis_filter_receive_data(ndev, net_dev, nvchan,
-- 
2.25.1

