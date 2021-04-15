Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E8A3607DA
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 12:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbhDOLAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 07:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbhDOLAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 07:00:15 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E8EC061574;
        Thu, 15 Apr 2021 03:59:52 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id x4so27535579edd.2;
        Thu, 15 Apr 2021 03:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=quNwjHGSQJJ75cXijPAjnj98Z1ZEv2xM4ocogoagxfc=;
        b=YszXNWSXT6BvSB8w8jaXejj+Hxdt6AN4McB3j50NCGpI5bAbFQgy0zF1CJB3U9W+9J
         zvUuxR15Rbv0u7jjQ7JDpJc6pQ60onHBjidCsXQQQptwvkOw171Kc/BQ4ZD32KnYC4ay
         RCPtXyt15ZmOif7s/t7EwH0QnXYRnl8/ujT7TdNkclNMvOaJ+17HjBEniSj6DfZm//pr
         EKe0sjaYqI/FR9PQ3TVg0OLapa/tVPPJVmnfR7+ysWx3IBeXlboB9fQxPW5M7Of2m9F2
         jxzI/6890Ex3GAN1koE7zuQP+g/f+enthh21DxDVzx4filDHYn+uzy8aTHUF0wPjUbkx
         n9jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=quNwjHGSQJJ75cXijPAjnj98Z1ZEv2xM4ocogoagxfc=;
        b=q/hffiDsJEhQ6gtK/XNHqiJDRg5IZGbaLI0lgvLvUsxTYMTEYvp+hC9LmCLoYu4iMB
         2PYQ/gt9Uw4WabE8SJsPN7op1mXMewc63D5ur1zn1snktOJ992LpejJqKJnl17P4qAoI
         e35LkCEf5x3o9DQfG5NWDxP1FbHGQIDzqiJ1JIXZY1Z3+Xwbl6wNngvgLGDVhPvEID1Q
         iC2gm3BKERjrJE5Vlrv9q3EOK7ZKKEjnGE3aCNImjkSnbtoPjwBtDeZqfQYZR5Kr4wdj
         fYRvm2xUsMBhcDp6xaQO3kwfgg05PiFPh796nL2Ftx3ya0dGoqWkHg9y15jzK0W8BoMX
         eCWA==
X-Gm-Message-State: AOAM531BC266D1+hmmWz74x/hUQdm7Ir6XxHZH1x+N1iiPv6359Un+ig
        TzPBSbNRhYlgVuoIhoMmu8edSgfKOjfWdAQT
X-Google-Smtp-Source: ABdhPJwA2Vjd4DWSWStiST0wCGIYV6RuGMZ9FWPTiw3P5v5+nGDIQ3u5onMUkkNOGv2NFDbx8QpNnQ==
X-Received: by 2002:aa7:da15:: with SMTP id r21mr3353043eds.253.1618484390412;
        Thu, 15 Apr 2021 03:59:50 -0700 (PDT)
Received: from anparri.mshome.net (mob-176-243-198-62.net.vodafone.it. [176.243.198.62])
        by smtp.gmail.com with ESMTPSA id z6sm1625651ejp.86.2021.04.15.03.59.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 03:59:50 -0700 (PDT)
From:   "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, mikelley@microsoft.com,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
Subject: [PATCH hyperv-next] scsi: storvsc: Use blk_mq_unique_tag() to generate requestIDs
Date:   Thu, 15 Apr 2021 12:59:26 +0200
Message-Id: <20210415105926.3688-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use blk_mq_unique_tag() to generate requestIDs for StorVSC, avoiding
all issues with allocating enough entries in the VMbus requestor.

Suggested-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
---
Changes since RFC:
  - pass sentinel values for {init,reset}_request in vmbus_sendpacket()
  - remove/inline the storvsc_request_addr() callback
  - make storvsc_next_request_id() 'static'
  - add code to handle the case of an unsolicited message from Hyper-V
  - other minor/style changes

[1] https://lkml.kernel.org/r/20210408161315.341888-1-parri.andrea@gmail.com

 drivers/hv/channel.c              | 14 ++---
 drivers/hv/ring_buffer.c          | 13 +++--
 drivers/net/hyperv/netvsc.c       |  8 ++-
 drivers/net/hyperv/rndis_filter.c |  2 +
 drivers/scsi/storvsc_drv.c        | 94 +++++++++++++++++++++----------
 include/linux/hyperv.h            | 13 ++++-
 6 files changed, 95 insertions(+), 49 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index db30be8f9ccea..f78e02ace51e8 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -1121,15 +1121,14 @@ EXPORT_SYMBOL_GPL(vmbus_recvpacket_raw);
  * vmbus_next_request_id - Returns a new request id. It is also
  * the index at which the guest memory address is stored.
  * Uses a spin lock to avoid race conditions.
- * @rqstor: Pointer to the requestor struct
+ * @channel: Pointer to the VMbus channel struct
  * @rqst_add: Guest memory address to be stored in the array
  */
-u64 vmbus_next_request_id(struct vmbus_requestor *rqstor, u64 rqst_addr)
+u64 vmbus_next_request_id(struct vmbus_channel *channel, u64 rqst_addr)
 {
+	struct vmbus_requestor *rqstor = &channel->requestor;
 	unsigned long flags;
 	u64 current_id;
-	const struct vmbus_channel *channel =
-		container_of(rqstor, const struct vmbus_channel, requestor);
 
 	/* Check rqstor has been initialized */
 	if (!channel->rqstor_size)
@@ -1163,16 +1162,15 @@ EXPORT_SYMBOL_GPL(vmbus_next_request_id);
 /*
  * vmbus_request_addr - Returns the memory address stored at @trans_id
  * in @rqstor. Uses a spin lock to avoid race conditions.
- * @rqstor: Pointer to the requestor struct
+ * @channel: Pointer to the VMbus channel struct
  * @trans_id: Request id sent back from Hyper-V. Becomes the requestor's
  * next request id.
  */
-u64 vmbus_request_addr(struct vmbus_requestor *rqstor, u64 trans_id)
+u64 vmbus_request_addr(struct vmbus_channel *channel, u64 trans_id)
 {
+	struct vmbus_requestor *rqstor = &channel->requestor;
 	unsigned long flags;
 	u64 req_addr;
-	const struct vmbus_channel *channel =
-		container_of(rqstor, const struct vmbus_channel, requestor);
 
 	/* Check rqstor has been initialized */
 	if (!channel->rqstor_size)
diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index ecd82ebfd5bc4..2bf57677272b5 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -310,10 +310,12 @@ int hv_ringbuffer_write(struct vmbus_channel *channel,
 	 */
 
 	if (desc->flags == VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED) {
-		rqst_id = vmbus_next_request_id(&channel->requestor, requestid);
-		if (rqst_id == VMBUS_RQST_ERROR) {
-			spin_unlock_irqrestore(&outring_info->ring_lock, flags);
-			return -EAGAIN;
+		if (channel->next_request_id_callback != NULL) {
+			rqst_id = channel->next_request_id_callback(channel, requestid);
+			if (rqst_id == VMBUS_RQST_ERROR) {
+				spin_unlock_irqrestore(&outring_info->ring_lock, flags);
+				return -EAGAIN;
+			}
 		}
 	}
 	desc = hv_get_ring_buffer(outring_info) + old_write;
@@ -341,7 +343,8 @@ int hv_ringbuffer_write(struct vmbus_channel *channel,
 	if (channel->rescind) {
 		if (rqst_id != VMBUS_NO_RQSTOR) {
 			/* Reclaim request ID to avoid leak of IDs */
-			vmbus_request_addr(&channel->requestor, rqst_id);
+			if (channel->request_addr_callback != NULL)
+				channel->request_addr_callback(channel, rqst_id);
 		}
 		return -ENODEV;
 	}
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index c64cc7639c39c..1a221ce2d6fdc 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -730,7 +730,7 @@ static void netvsc_send_tx_complete(struct net_device *ndev,
 	int queue_sends;
 	u64 cmd_rqst;
 
-	cmd_rqst = vmbus_request_addr(&channel->requestor, (u64)desc->trans_id);
+	cmd_rqst = channel->request_addr_callback(channel, (u64)desc->trans_id);
 	if (cmd_rqst == VMBUS_RQST_ERROR) {
 		netdev_err(ndev, "Incorrect transaction id\n");
 		return;
@@ -790,8 +790,8 @@ static void netvsc_send_completion(struct net_device *ndev,
 
 	/* First check if this is a VMBUS completion without data payload */
 	if (!msglen) {
-		cmd_rqst = vmbus_request_addr(&incoming_channel->requestor,
-					      (u64)desc->trans_id);
+		cmd_rqst = incoming_channel->request_addr_callback(incoming_channel,
+								   (u64)desc->trans_id);
 		if (cmd_rqst == VMBUS_RQST_ERROR) {
 			netdev_err(ndev, "Invalid transaction id\n");
 			return;
@@ -1602,6 +1602,8 @@ struct netvsc_device *netvsc_device_add(struct hv_device *device,
 		       netvsc_poll, NAPI_POLL_WEIGHT);
 
 	/* Open the channel */
+	device->channel->next_request_id_callback = vmbus_next_request_id;
+	device->channel->request_addr_callback = vmbus_request_addr;
 	device->channel->rqstor_size = netvsc_rqstor_size(netvsc_ring_bytes);
 	ret = vmbus_open(device->channel, netvsc_ring_bytes,
 			 netvsc_ring_bytes,  NULL, 0,
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 123cc9d25f5ed..ebf34bf3f9075 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1259,6 +1259,8 @@ static void netvsc_sc_open(struct vmbus_channel *new_sc)
 	/* Set the channel before opening.*/
 	nvchan->channel = new_sc;
 
+	new_sc->next_request_id_callback = vmbus_next_request_id;
+	new_sc->request_addr_callback = vmbus_request_addr;
 	new_sc->rqstor_size = netvsc_rqstor_size(netvsc_ring_bytes);
 	ret = vmbus_open(new_sc, netvsc_ring_bytes,
 			 netvsc_ring_bytes, NULL, 0,
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 6bc5453cea8a7..b219a266cca80 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -684,6 +684,23 @@ static void storvsc_change_target_cpu(struct vmbus_channel *channel, u32 old,
 	spin_unlock_irqrestore(&stor_device->lock, flags);
 }
 
+static u64 storvsc_next_request_id(struct vmbus_channel *channel, u64 rqst_addr)
+{
+	struct storvsc_cmd_request *request =
+		(struct storvsc_cmd_request *)(unsigned long)rqst_addr;
+
+	if (rqst_addr == VMBUS_RQST_INIT)
+		return VMBUS_RQST_INIT;
+	if (rqst_addr == VMBUS_RQST_RESET)
+		return VMBUS_RQST_RESET;
+
+	/*
+	 * Cannot return an ID of 0, which is reserved for an unsolicited
+	 * message from Hyper-V.
+	 */
+	return (u64)blk_mq_unique_tag(request->cmd->request) + 1;
+}
+
 static void handle_sc_creation(struct vmbus_channel *new_sc)
 {
 	struct hv_device *device = new_sc->primary_channel->device_obj;
@@ -698,11 +715,7 @@ static void handle_sc_creation(struct vmbus_channel *new_sc)
 
 	memset(&props, 0, sizeof(struct vmstorage_channel_properties));
 
-	/*
-	 * The size of vmbus_requestor is an upper bound on the number of requests
-	 * that can be in-progress at any one time across all channels.
-	 */
-	new_sc->rqstor_size = scsi_driver.can_queue;
+	new_sc->next_request_id_callback = storvsc_next_request_id;
 
 	ret = vmbus_open(new_sc,
 			 storvsc_ringbuffer_size,
@@ -769,7 +782,7 @@ static void  handle_multichannel_storage(struct hv_device *device, int max_chns)
 	ret = vmbus_sendpacket(device->channel, vstor_packet,
 			       (sizeof(struct vstor_packet) -
 			       stor_device->vmscsi_size_delta),
-			       (unsigned long)request,
+			       VMBUS_RQST_INIT,
 			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 
@@ -838,7 +851,7 @@ static int storvsc_execute_vstor_op(struct hv_device *device,
 	ret = vmbus_sendpacket(device->channel, vstor_packet,
 			       (sizeof(struct vstor_packet) -
 			       stor_device->vmscsi_size_delta),
-			       (unsigned long)request,
+			       VMBUS_RQST_INIT,
 			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	if (ret != 0)
@@ -1240,6 +1253,7 @@ static void storvsc_on_channel_callback(void *context)
 	const struct vmpacket_descriptor *desc;
 	struct hv_device *device;
 	struct storvsc_device *stor_device;
+	struct Scsi_Host *shost;
 
 	if (channel->primary_channel != NULL)
 		device = channel->primary_channel->device_obj;
@@ -1250,20 +1264,12 @@ static void storvsc_on_channel_callback(void *context)
 	if (!stor_device)
 		return;
 
-	foreach_vmbus_pkt(desc, channel) {
-		void *packet = hv_pkt_data(desc);
-		struct storvsc_cmd_request *request;
-		u64 cmd_rqst;
-
-		cmd_rqst = vmbus_request_addr(&channel->requestor,
-					      desc->trans_id);
-		if (cmd_rqst == VMBUS_RQST_ERROR) {
-			dev_err(&device->device,
-				"Incorrect transaction id\n");
-			continue;
-		}
+	shost = stor_device->host;
 
-		request = (struct storvsc_cmd_request *)(unsigned long)cmd_rqst;
+	foreach_vmbus_pkt(desc, channel) {
+		struct vstor_packet *packet = hv_pkt_data(desc);
+		struct storvsc_cmd_request *request = NULL;
+		u64 rqst_id = desc->trans_id;
 
 		if (hv_pkt_datalen(desc) < sizeof(struct vstor_packet) -
 				stor_device->vmscsi_size_delta) {
@@ -1271,14 +1277,44 @@ static void storvsc_on_channel_callback(void *context)
 			continue;
 		}
 
-		if (request == &stor_device->init_request ||
-		    request == &stor_device->reset_request) {
-			memcpy(&request->vstor_packet, packet,
-			       (sizeof(struct vstor_packet) - stor_device->vmscsi_size_delta));
-			complete(&request->wait_event);
+		if (rqst_id == VMBUS_RQST_INIT) {
+			request = &stor_device->init_request;
+		} else if (rqst_id == VMBUS_RQST_RESET) {
+			request = &stor_device->reset_request;
 		} else {
+			/* Hyper-V can send an unsolicited message with ID of 0 */
+			if (rqst_id == 0) {
+				/*
+				 * storvsc_on_receive() looks at the vstor_packet in the message
+				 * from the ring buffer.  If the operation in the vstor_packet is
+				 * COMPLETE_IO, then we call storvsc_on_io_completion(), and
+				 * dereference the guest memory address.  Make sure we don't call
+				 * storvsc_on_io_completion() with a guest memory address that is
+				 * zero if Hyper-V were to construct and send such a bogus packet.
+				 */
+				if (packet->operation == VSTOR_OPERATION_COMPLETE_IO) {
+					dev_err(&device->device, "Invalid packet with ID of 0\n");
+					continue;
+				}
+			} else {
+				struct scsi_cmnd *scmnd;
+
+				/* Transaction 'rqst_id' corresponds to tag 'rqst_id - 1' */
+				scmnd = scsi_host_find_tag(shost, rqst_id - 1);
+				if (scmnd == NULL) {
+					dev_err(&device->device, "Incorrect transaction ID\n");
+					continue;
+				}
+				request = (struct storvsc_cmd_request *)scsi_cmd_priv(scmnd);
+			}
+
 			storvsc_on_receive(stor_device, packet, request);
+			continue;
 		}
+
+		memcpy(&request->vstor_packet, packet,
+		       (sizeof(struct vstor_packet) - stor_device->vmscsi_size_delta));
+		complete(&request->wait_event);
 	}
 }
 
@@ -1290,11 +1326,7 @@ static int storvsc_connect_to_vsp(struct hv_device *device, u32 ring_size,
 
 	memset(&props, 0, sizeof(struct vmstorage_channel_properties));
 
-	/*
-	 * The size of vmbus_requestor is an upper bound on the number of requests
-	 * that can be in-progress at any one time across all channels.
-	 */
-	device->channel->rqstor_size = scsi_driver.can_queue;
+	device->channel->next_request_id_callback = storvsc_next_request_id;
 
 	ret = vmbus_open(device->channel,
 			 ring_size,
@@ -1620,7 +1652,7 @@ static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
 	ret = vmbus_sendpacket(device->channel, vstor_packet,
 			       (sizeof(struct vstor_packet) -
 				stor_device->vmscsi_size_delta),
-			       (unsigned long)&stor_device->reset_request,
+			       VMBUS_RQST_RESET,
 			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	if (ret != 0)
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 2c18c8e768efe..5692ffa60e022 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -779,7 +779,11 @@ struct vmbus_requestor {
 
 #define VMBUS_NO_RQSTOR U64_MAX
 #define VMBUS_RQST_ERROR (U64_MAX - 1)
+/* NetVSC-specific */
 #define VMBUS_RQST_ID_NO_RESPONSE (U64_MAX - 2)
+/* StorVSC-specific */
+#define VMBUS_RQST_INIT (U64_MAX - 2)
+#define VMBUS_RQST_RESET (U64_MAX - 3)
 
 struct vmbus_device {
 	u16  dev_type;
@@ -1007,13 +1011,18 @@ struct vmbus_channel {
 	u32 fuzz_testing_interrupt_delay;
 	u32 fuzz_testing_message_delay;
 
+	/* callback to generate a request ID from a request address */
+	u64 (*next_request_id_callback)(struct vmbus_channel *channel, u64 rqst_addr);
+	/* callback to retrieve a request address from a request ID */
+	u64 (*request_addr_callback)(struct vmbus_channel *channel, u64 rqst_id);
+
 	/* request/transaction ids for VMBus */
 	struct vmbus_requestor requestor;
 	u32 rqstor_size;
 };
 
-u64 vmbus_next_request_id(struct vmbus_requestor *rqstor, u64 rqst_addr);
-u64 vmbus_request_addr(struct vmbus_requestor *rqstor, u64 trans_id);
+u64 vmbus_next_request_id(struct vmbus_channel *channel, u64 rqst_addr);
+u64 vmbus_request_addr(struct vmbus_channel *channel, u64 trans_id);
 
 static inline bool is_hvsock_channel(const struct vmbus_channel *c)
 {
-- 
2.25.1

