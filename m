Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBD32315C5
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 00:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729846AbgG1WxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 18:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729380AbgG1WxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 18:53:24 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98380C061794;
        Tue, 28 Jul 2020 15:53:24 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id u10so1349232plr.7;
        Tue, 28 Jul 2020 15:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BlZIU6sjaRo9S5cuZoZyjFXtIY4Td8Q+hgRdHNZUwiA=;
        b=tSeXE9lBdH7l8tQlUVu+gQ4au0SZR19moYuxefv7OjoxeasBMywWxehwj8CXSR1XkE
         JLAxj3iUe/oVc7NFUkKwNKsp7Y+FyF+FaUCt8pr1xFoUGTkBW6eyM/gmw6kUFlKf3FNR
         AfCw2rHvBeYPH99anZUuAj0jmnvrZFsOcsBZfbvjEtqXe9OLFwq1LY3UCX0GeEd+398W
         SvBXWUsFe0CGPUTdz+q7/6VcazQY+EA/R0Cc6HoOG4iLrN79XmoDXjiHqD4xRW6zHFn9
         oNgGZmDwbqDWa0QWuJKGUpIdOEzYx1L22/QKYe/lQhvXiOSxHZIL2IFz5mPP/dNB9UVN
         J76A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BlZIU6sjaRo9S5cuZoZyjFXtIY4Td8Q+hgRdHNZUwiA=;
        b=q9rlkoXmJQKtZVo7DP7NSE1D2L3bsGQKcNpoN9hVxpUb9ev25QBiBbo5eES0cBGDwi
         U+lVfc5PhhR4iV3glyRvWriHB3knzP7Prcnf/ER7M7ChdktzXcWfu+HTCLOYxcE6itY8
         iRtmkf7jLImplswm99xPYu3J3dXSqZiDQrHdyH8klVJiQ2QnoxVnKxQ8cuoS95+/THGZ
         o3eRFgLUrdRJWn/b3guSB5vQufhiFrIC6bq1lCOS21VR8VTOCnwYQydPDv7BkjsFQb06
         x9mTnnCiUF7Xd3a0krtAhmBjM4uYItlmrLh3GkmAJQ18n3LlMV0DjrTSG1XZeP5IyAQC
         1IGQ==
X-Gm-Message-State: AOAM5325FmoocdykalkI3XDc1tok5MSd/2rYqIi3vaSP3oGznSzxgUz3
        XUxPOr9MDXlkvFHz0IBK3Pc=
X-Google-Smtp-Source: ABdhPJxBOvWtfrDBMLmIdPLuGoa0i5DvwVqKVTO6M9Kjlts1vt9j9WhD75F8H+U1O4jQHbCAkXG2cA==
X-Received: by 2002:a17:902:8a85:: with SMTP id p5mr24984280plo.89.1595976804118;
        Tue, 28 Jul 2020 15:53:24 -0700 (PDT)
Received: from localhost.localdomain ([131.107.147.194])
        by smtp.gmail.com with ESMTPSA id y198sm101689pfg.116.2020.07.28.15.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2020 15:53:23 -0700 (PDT)
From:   Andres Beltran <lkmlabelt@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org
Cc:     linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikelley@microsoft.com, parri.andrea@gmail.com,
        skarade@microsoft.com, Andres Beltran <lkmlabelt@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH] hv_netvsc: Add validation for untrusted Hyper-V values
Date:   Tue, 28 Jul 2020 18:53:21 -0400
Message-Id: <20200728225321.26570-1-lkmlabelt@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For additional robustness in the face of Hyper-V errors or malicious
behavior, validate all values that originate from packets that Hyper-V
has sent to the guest in the host-to-guest ring buffer. Ensure that
invalid values cannot cause indexing off the end of an array, or
subvert an existing validation via integer overflow. Ensure that
outgoing packets do not have any leftover guest memory that has not
been zeroed out.

Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Andres Beltran <lkmlabelt@gmail.com>
---
 drivers/net/hyperv/hyperv_net.h   |  4 ++
 drivers/net/hyperv/netvsc.c       | 99 +++++++++++++++++++++++++++----
 drivers/net/hyperv/netvsc_drv.c   |  7 +++
 drivers/net/hyperv/rndis_filter.c | 73 ++++++++++++++++++++---
 4 files changed, 163 insertions(+), 20 deletions(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index f43b614f2345..7df5943fa46f 100644
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
index 79b907a29433..7aa5276a1f36 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -398,6 +398,15 @@ static int netvsc_init_buf(struct hv_device *device,
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
@@ -479,6 +488,12 @@ static int netvsc_init_buf(struct hv_device *device,
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
@@ -770,12 +785,24 @@ static void netvsc_send_completion(struct net_device *ndev,
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
 	case NVSP_MSG1_TYPE_SEND_RECV_BUF_COMPLETE:
 	case NVSP_MSG1_TYPE_SEND_SEND_BUF_COMPLETE:
 	case NVSP_MSG5_TYPE_SUBCHANNEL:
+		if (msglen < sizeof(struct nvsp_message)) {
+			netdev_err(ndev, "nvsp_msg5 length too small: %u\n",
+				   msglen);
+			return;
+		}
 		/* Copy the response back */
 		memcpy(&net_device->channel_init_pkt, nvsp_packet,
 		       sizeof(struct nvsp_message));
@@ -1167,19 +1194,28 @@ static void enq_receive_complete(struct net_device *ndev,
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
@@ -1188,6 +1224,14 @@ static int netvsc_receive(struct net_device *ndev,
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
@@ -1198,6 +1242,14 @@ static int netvsc_receive(struct net_device *ndev,
 
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
@@ -1205,7 +1257,8 @@ static int netvsc_receive(struct net_device *ndev,
 		void *data;
 		int ret;
 
-		if (unlikely(offset + buflen > net_device->recv_buf_size)) {
+		if (unlikely(offset > net_device->recv_buf_size ||
+			     buflen > net_device->recv_buf_size - offset)) {
 			nvchan->rsc.cnt = 0;
 			status = NVSP_STAT_FAIL;
 			netif_err(net_device_ctx, rx_err, ndev,
@@ -1244,6 +1297,13 @@ static void netvsc_send_table(struct net_device *ndev,
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
 
@@ -1275,10 +1335,18 @@ static void netvsc_send_table(struct net_device *ndev,
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
@@ -1288,16 +1356,24 @@ static void netvsc_send_vf(struct net_device *ndev,
 
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
@@ -1311,23 +1387,20 @@ static int netvsc_process_raw_pkt(struct hv_device *device,
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
index 6267f706e8ee..aa0268495229 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -724,6 +724,13 @@ void netvsc_linkstatus_callback(struct net_device *net,
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
index 10489ba44a09..fc78eac9aade 100644
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

