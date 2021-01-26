Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4B7303BD9
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 12:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405275AbhAZLlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 06:41:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405054AbhAZLk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 06:40:26 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001FAC061573;
        Tue, 26 Jan 2021 03:39:45 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id o10so1267224wmc.1;
        Tue, 26 Jan 2021 03:39:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d81ctn8FUtxczg/rYVdyLXmwBeEXZkkJTC9v3I2BIF8=;
        b=XEaaPYO33yd3nwc9B+0SkpLnEu0KxcFo6rMduLLbanYLO2dX+DxrCFUnPJzCV/9dGX
         8kjnfiq3uhNzgrxOLiZ6K49aEripyFYO2IbgqlYwZdVcDwmT9EtASY9o4jZb6lXHGGwt
         j7/UWsuTLCerAylNDmMa8BknMuHaZSC6a+MVTeChkHj3PuabdG/n6zqjrPUCEbEV9SMk
         BdqCAbKsi9Nz+81RofJI+p/QRK2QB8/ROIBIUHUw88JzECtckzDbppXjrvUQ7dP6DCxt
         +wARUE9IDB1uLdJy6ll748dSKlmRborwsHDjipP8sf/q5uiDGVF0RlFawll5nW1qofkI
         MCrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d81ctn8FUtxczg/rYVdyLXmwBeEXZkkJTC9v3I2BIF8=;
        b=a1+Jzzcfwm7muRJ2fg0XyQ2tzTbJjPQEQbMvUeobgp9b9Z/jOvI195Sps41FUMoXj9
         fHlvsojHOcp8kqlkItezfEGPzNZPU2Fk5zsCn5D50AxnbewrE+i7sH1nTeohdv9Ta9bU
         eu0vLnVT5sUJmUeZUsruX3UhNqi1az1el1YoQJHuLhwZZyrhJFlzcgWz5YDkq+EQd33O
         kdX98216abD72aSMkRhWvFknoKq3DojPyE0ouDwamt6k+ULTNv0IqRt2B08d2B2hIrJQ
         KXsCAw1qM5kexig1wsIdG4k/hL3wGAVE9V2Y5XK3zjofVraZOpj4z593aQO3V2xr5s55
         i0CA==
X-Gm-Message-State: AOAM533fp6FflXQAn50yXOjNmvhK+YHrxAT24UrmB5mcy8yUhTadtHYZ
        7iw8at0xJPyzw+S8piPYW3lCDnegMXZOQwjo
X-Google-Smtp-Source: ABdhPJzh01HWTL7prm2VbMliifr67wxjtku1ZusozTkLet0rcXwQhKvncFOXdInJzF6hzFMUYaFuqA==
X-Received: by 2002:a7b:c5c7:: with SMTP id n7mr4269966wmk.140.1611661184320;
        Tue, 26 Jan 2021 03:39:44 -0800 (PST)
Received: from anparri.mshome.net (host-95-238-70-33.retail.telecomitalia.it. [95.238.70.33])
        by smtp.gmail.com with ESMTPSA id b7sm26514949wru.33.2021.01.26.03.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 03:39:43 -0800 (PST)
From:   "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next] hv_netvsc: Copy packets sent by Hyper-V out of the receive buffer
Date:   Tue, 26 Jan 2021 12:38:47 +0100
Message-Id: <20210126113847.1676-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pointers to receive-buffer packets sent by Hyper-V are used within the
guest VM.  Hyper-V can send packets with erroneous values or modify
packet fields after they are processed by the guest.  To defend against
these scenarios, copy (sections of) the incoming packet after validating
their length and offset fields in netvsc_filter_receive().  In this way,
the packet can no longer be modified by the host.

Reported-by: Juan Vazquez <juvazq@microsoft.com>
Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
 drivers/net/hyperv/hyperv_net.h   |  4 +-
 drivers/net/hyperv/netvsc.c       | 20 +++++++++
 drivers/net/hyperv/netvsc_drv.c   |  9 ++--
 drivers/net/hyperv/rndis_filter.c | 74 +++++++++++++++++++------------
 4 files changed, 75 insertions(+), 32 deletions(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index 2a87cfa27ac02..2c0ab80d8ae4e 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -194,7 +194,8 @@ int netvsc_send(struct net_device *net,
 		struct sk_buff *skb,
 		bool xdp_tx);
 void netvsc_linkstatus_callback(struct net_device *net,
-				struct rndis_message *resp);
+				struct rndis_message *resp,
+				void *data);
 int netvsc_recv_callback(struct net_device *net,
 			 struct netvsc_device *nvdev,
 			 struct netvsc_channel *nvchan);
@@ -1002,6 +1003,7 @@ struct net_device_context {
 struct netvsc_channel {
 	struct vmbus_channel *channel;
 	struct netvsc_device *net_device;
+	void *recv_buf; /* buffer to copy packets out from the receive buffer */
 	const struct vmpacket_descriptor *desc;
 	struct napi_struct napi;
 	struct multi_send_data msd;
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 6184e99c7f31f..0fba8257fc119 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -131,6 +131,7 @@ static void free_netvsc_device(struct rcu_head *head)
 
 	for (i = 0; i < VRSS_CHANNEL_MAX; i++) {
 		xdp_rxq_info_unreg(&nvdev->chan_table[i].xdp_rxq);
+		kfree(nvdev->chan_table[i].recv_buf);
 		vfree(nvdev->chan_table[i].mrc.slots);
 	}
 
@@ -1284,6 +1285,19 @@ static int netvsc_receive(struct net_device *ndev,
 			continue;
 		}
 
+		/* We're going to copy (sections of) the packet into nvchan->recv_buf;
+		 * make sure that nvchan->recv_buf is large enough to hold the packet.
+		 */
+		if (unlikely(buflen > net_device->recv_section_size)) {
+			nvchan->rsc.cnt = 0;
+			status = NVSP_STAT_FAIL;
+			netif_err(net_device_ctx, rx_err, ndev,
+				  "Packet too big: buflen=%u recv_section_size=%u\n",
+				  buflen, net_device->recv_section_size);
+
+			continue;
+		}
+
 		data = recv_buf + offset;
 
 		nvchan->rsc.is_last = (i == count - 1);
@@ -1535,6 +1549,12 @@ struct netvsc_device *netvsc_device_add(struct hv_device *device,
 	for (i = 0; i < VRSS_CHANNEL_MAX; i++) {
 		struct netvsc_channel *nvchan = &net_device->chan_table[i];
 
+		nvchan->recv_buf = kzalloc(device_info->recv_section_size, GFP_KERNEL);
+		if (nvchan->recv_buf == NULL) {
+			ret = -ENOMEM;
+			goto cleanup2;
+		}
+
 		nvchan->channel = device->channel;
 		nvchan->net_device = net_device;
 		u64_stats_init(&nvchan->tx_stats.syncp);
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index ac20c432d4d8f..1ec27bbe267da 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -743,7 +743,8 @@ static netdev_tx_t netvsc_start_xmit(struct sk_buff *skb,
  * netvsc_linkstatus_callback - Link up/down notification
  */
 void netvsc_linkstatus_callback(struct net_device *net,
-				struct rndis_message *resp)
+				struct rndis_message *resp,
+				void *data)
 {
 	struct rndis_indicate_status *indicate = &resp->msg.indicate_status;
 	struct net_device_context *ndev_ctx = netdev_priv(net);
@@ -757,6 +758,9 @@ void netvsc_linkstatus_callback(struct net_device *net,
 		return;
 	}
 
+	/* Copy the RNDIS indicate status into nvchan->recv_buf */
+	memcpy(indicate, data + RNDIS_HEADER_SIZE, sizeof(*indicate));
+
 	/* Update the physical link speed when changing to another vSwitch */
 	if (indicate->status == RNDIS_STATUS_LINK_SPEED_CHANGE) {
 		u32 speed;
@@ -771,8 +775,7 @@ void netvsc_linkstatus_callback(struct net_device *net,
 			return;
 		}
 
-		speed = *(u32 *)((void *)indicate
-				 + indicate->status_buf_offset) / 10000;
+		speed = *(u32 *)(data + RNDIS_HEADER_SIZE + indicate->status_buf_offset) / 10000;
 		ndev_ctx->speed = speed;
 		return;
 	}
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index c8534b6619b8d..8ad69795c4b08 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -127,12 +127,13 @@ static void put_rndis_request(struct rndis_device *dev,
 }
 
 static void dump_rndis_message(struct net_device *netdev,
-			       const struct rndis_message *rndis_msg)
+			       const struct rndis_message *rndis_msg,
+			       const void *data)
 {
 	switch (rndis_msg->ndis_msg_type) {
 	case RNDIS_MSG_PACKET:
 		if (rndis_msg->msg_len - RNDIS_HEADER_SIZE >= sizeof(struct rndis_packet)) {
-			const struct rndis_packet *pkt = &rndis_msg->msg.pkt;
+			const struct rndis_packet *pkt = data + RNDIS_HEADER_SIZE;
 			netdev_dbg(netdev, "RNDIS_MSG_PACKET (len %u, "
 				   "data offset %u data len %u, # oob %u, "
 				   "oob offset %u, oob len %u, pkt offset %u, "
@@ -152,7 +153,7 @@ static void dump_rndis_message(struct net_device *netdev,
 		if (rndis_msg->msg_len - RNDIS_HEADER_SIZE >=
 				sizeof(struct rndis_initialize_complete)) {
 			const struct rndis_initialize_complete *init_complete =
-				&rndis_msg->msg.init_complete;
+				data + RNDIS_HEADER_SIZE;
 			netdev_dbg(netdev, "RNDIS_MSG_INIT_C "
 				"(len %u, id 0x%x, status 0x%x, major %d, minor %d, "
 				"device flags %d, max xfer size 0x%x, max pkts %u, "
@@ -173,7 +174,7 @@ static void dump_rndis_message(struct net_device *netdev,
 		if (rndis_msg->msg_len - RNDIS_HEADER_SIZE >=
 				sizeof(struct rndis_query_complete)) {
 			const struct rndis_query_complete *query_complete =
-				&rndis_msg->msg.query_complete;
+				data + RNDIS_HEADER_SIZE;
 			netdev_dbg(netdev, "RNDIS_MSG_QUERY_C "
 				"(len %u, id 0x%x, status 0x%x, buf len %u, "
 				"buf offset %u)\n",
@@ -188,7 +189,7 @@ static void dump_rndis_message(struct net_device *netdev,
 	case RNDIS_MSG_SET_C:
 		if (rndis_msg->msg_len - RNDIS_HEADER_SIZE + sizeof(struct rndis_set_complete)) {
 			const struct rndis_set_complete *set_complete =
-				&rndis_msg->msg.set_complete;
+				data + RNDIS_HEADER_SIZE;
 			netdev_dbg(netdev,
 				"RNDIS_MSG_SET_C (len %u, id 0x%x, status 0x%x)\n",
 				rndis_msg->msg_len,
@@ -201,7 +202,7 @@ static void dump_rndis_message(struct net_device *netdev,
 		if (rndis_msg->msg_len - RNDIS_HEADER_SIZE >=
 				sizeof(struct rndis_indicate_status)) {
 			const struct rndis_indicate_status *indicate_status =
-				&rndis_msg->msg.indicate_status;
+				data + RNDIS_HEADER_SIZE;
 			netdev_dbg(netdev, "RNDIS_MSG_INDICATE "
 				"(len %u, status 0x%x, buf len %u, buf offset %u)\n",
 				rndis_msg->msg_len,
@@ -286,8 +287,10 @@ static void rndis_set_link_state(struct rndis_device *rdev,
 
 static void rndis_filter_receive_response(struct net_device *ndev,
 					  struct netvsc_device *nvdev,
-					  const struct rndis_message *resp)
+					  struct rndis_message *resp,
+					  void *data)
 {
+	u32 *req_id = &resp->msg.init_complete.req_id;
 	struct rndis_device *dev = nvdev->extension;
 	struct rndis_request *request = NULL;
 	bool found = false;
@@ -312,14 +315,16 @@ static void rndis_filter_receive_response(struct net_device *ndev,
 		return;
 	}
 
+	/* Copy the request ID into nvchan->recv_buf */
+	*req_id = *(u32 *)(data + RNDIS_HEADER_SIZE);
+
 	spin_lock_irqsave(&dev->request_lock, flags);
 	list_for_each_entry(request, &dev->req_list, list_ent) {
 		/*
 		 * All request/response message contains RequestId as the 1st
 		 * field
 		 */
-		if (request->request_msg.msg.init_req.req_id
-		    == resp->msg.init_complete.req_id) {
+		if (request->request_msg.msg.init_req.req_id == *req_id) {
 			found = true;
 			break;
 		}
@@ -329,8 +334,10 @@ static void rndis_filter_receive_response(struct net_device *ndev,
 	if (found) {
 		if (resp->msg_len <=
 		    sizeof(struct rndis_message) + RNDIS_EXT_LEN) {
-			memcpy(&request->response_msg, resp,
-			       resp->msg_len);
+			memcpy(&request->response_msg, resp, RNDIS_HEADER_SIZE + sizeof(*req_id));
+			memcpy((void *)&request->response_msg + RNDIS_HEADER_SIZE + sizeof(*req_id),
+			       data + RNDIS_HEADER_SIZE + sizeof(*req_id),
+			       resp->msg_len - RNDIS_HEADER_SIZE - sizeof(*req_id));
 			if (request->request_msg.ndis_msg_type ==
 			    RNDIS_MSG_QUERY && request->request_msg.msg.
 			    query_req.oid == RNDIS_OID_GEN_MEDIA_CONNECT_STATUS)
@@ -359,7 +366,7 @@ static void rndis_filter_receive_response(struct net_device *ndev,
 		netdev_err(ndev,
 			"no rndis request found for this response "
 			"(id 0x%x res type 0x%x)\n",
-			resp->msg.init_complete.req_id,
+			*req_id,
 			resp->ndis_msg_type);
 	}
 }
@@ -371,7 +378,7 @@ static void rndis_filter_receive_response(struct net_device *ndev,
 static inline void *rndis_get_ppi(struct net_device *ndev,
 				  struct rndis_packet *rpkt,
 				  u32 rpkt_len, u32 type, u8 internal,
-				  u32 ppi_size)
+				  u32 ppi_size, void *data)
 {
 	struct rndis_per_packet_info *ppi;
 	int len;
@@ -396,6 +403,8 @@ static inline void *rndis_get_ppi(struct net_device *ndev,
 
 	ppi = (struct rndis_per_packet_info *)((ulong)rpkt +
 		rpkt->per_pkt_info_offset);
+	/* Copy the PPIs into nvchan->recv_buf */
+	memcpy(ppi, data + RNDIS_HEADER_SIZE + rpkt->per_pkt_info_offset, rpkt->per_pkt_info_len);
 	len = rpkt->per_pkt_info_len;
 
 	while (len > 0) {
@@ -453,7 +462,7 @@ static int rndis_filter_receive_data(struct net_device *ndev,
 				     struct netvsc_device *nvdev,
 				     struct netvsc_channel *nvchan,
 				     struct rndis_message *msg,
-				     u32 data_buflen)
+				     void *data, u32 data_buflen)
 {
 	struct rndis_packet *rndis_pkt = &msg->msg.pkt;
 	const struct ndis_tcp_ip_checksum_info *csum_info;
@@ -461,7 +470,6 @@ static int rndis_filter_receive_data(struct net_device *ndev,
 	const struct rndis_pktinfo_id *pktinfo_id;
 	const u32 *hash_info;
 	u32 data_offset, rpkt_len;
-	void *data;
 	bool rsc_more = false;
 	int ret;
 
@@ -472,6 +480,9 @@ static int rndis_filter_receive_data(struct net_device *ndev,
 		return NVSP_STAT_FAIL;
 	}
 
+	/* Copy the RNDIS packet into nvchan->recv_buf */
+	memcpy(rndis_pkt, data + RNDIS_HEADER_SIZE, sizeof(*rndis_pkt));
+
 	/* Validate rndis_pkt offset */
 	if (rndis_pkt->data_offset >= data_buflen - RNDIS_HEADER_SIZE) {
 		netdev_err(ndev, "invalid rndis packet offset: %u\n",
@@ -497,18 +508,17 @@ static int rndis_filter_receive_data(struct net_device *ndev,
 		return NVSP_STAT_FAIL;
 	}
 
-	vlan = rndis_get_ppi(ndev, rndis_pkt, rpkt_len, IEEE_8021Q_INFO, 0, sizeof(*vlan));
+	vlan = rndis_get_ppi(ndev, rndis_pkt, rpkt_len, IEEE_8021Q_INFO, 0, sizeof(*vlan),
+			     data);
 
 	csum_info = rndis_get_ppi(ndev, rndis_pkt, rpkt_len, TCPIP_CHKSUM_PKTINFO, 0,
-				  sizeof(*csum_info));
+				  sizeof(*csum_info), data);
 
 	hash_info = rndis_get_ppi(ndev, rndis_pkt, rpkt_len, NBL_HASH_VALUE, 0,
-				  sizeof(*hash_info));
+				  sizeof(*hash_info), data);
 
 	pktinfo_id = rndis_get_ppi(ndev, rndis_pkt, rpkt_len, RNDIS_PKTINFO_ID, 1,
-				   sizeof(*pktinfo_id));
-
-	data = (void *)msg + data_offset;
+				   sizeof(*pktinfo_id), data);
 
 	/* Identify RSC frags, drop erroneous packets */
 	if (pktinfo_id && (pktinfo_id->flag & RNDIS_PKTINFO_SUBALLOC)) {
@@ -537,7 +547,7 @@ static int rndis_filter_receive_data(struct net_device *ndev,
 	 * the data packet to the stack, without the rndis trailer padding
 	 */
 	rsc_add_data(nvchan, vlan, csum_info, hash_info,
-		     data, rndis_pkt->data_len);
+		     data + data_offset, rndis_pkt->data_len);
 
 	if (rsc_more)
 		return NVSP_STAT_SUCCESS;
@@ -559,10 +569,18 @@ int rndis_filter_receive(struct net_device *ndev,
 			 void *data, u32 buflen)
 {
 	struct net_device_context *net_device_ctx = netdev_priv(ndev);
-	struct rndis_message *rndis_msg = data;
+	struct rndis_message *rndis_msg = nvchan->recv_buf;
+
+	if (buflen < RNDIS_HEADER_SIZE) {
+		netdev_err(ndev, "Invalid rndis_msg (buflen: %u)\n", buflen);
+		return NVSP_STAT_FAIL;
+	}
+
+	/* Copy the RNDIS msg header into nvchan->recv_buf */
+	memcpy(rndis_msg, data, RNDIS_HEADER_SIZE);
 
 	/* Validate incoming rndis_message packet */
-	if (buflen < RNDIS_HEADER_SIZE || rndis_msg->msg_len < RNDIS_HEADER_SIZE ||
+	if (rndis_msg->msg_len < RNDIS_HEADER_SIZE ||
 	    buflen < rndis_msg->msg_len) {
 		netdev_err(ndev, "Invalid rndis_msg (buflen: %u, msg_len: %u)\n",
 			   buflen, rndis_msg->msg_len);
@@ -570,22 +588,22 @@ int rndis_filter_receive(struct net_device *ndev,
 	}
 
 	if (netif_msg_rx_status(net_device_ctx))
-		dump_rndis_message(ndev, rndis_msg);
+		dump_rndis_message(ndev, rndis_msg, data);
 
 	switch (rndis_msg->ndis_msg_type) {
 	case RNDIS_MSG_PACKET:
 		return rndis_filter_receive_data(ndev, net_dev, nvchan,
-						 rndis_msg, buflen);
+						 rndis_msg, data, buflen);
 	case RNDIS_MSG_INIT_C:
 	case RNDIS_MSG_QUERY_C:
 	case RNDIS_MSG_SET_C:
 		/* completion msgs */
-		rndis_filter_receive_response(ndev, net_dev, rndis_msg);
+		rndis_filter_receive_response(ndev, net_dev, rndis_msg, data);
 		break;
 
 	case RNDIS_MSG_INDICATE:
 		/* notification msgs */
-		netvsc_linkstatus_callback(ndev, rndis_msg);
+		netvsc_linkstatus_callback(ndev, rndis_msg, data);
 		break;
 	default:
 		netdev_err(ndev,
-- 
2.25.1

