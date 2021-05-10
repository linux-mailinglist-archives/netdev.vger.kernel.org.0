Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30413798C7
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 23:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbhEJVKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 17:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhEJVKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 17:10:04 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A4CC061574;
        Mon, 10 May 2021 14:08:58 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id s6so20334362edu.10;
        Mon, 10 May 2021 14:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=es/vwfAMVB7AivnWOtsM8HnUGDRwewCv6Q9SMlwNd6E=;
        b=PkTKAktDlrtVJgPcOdmr8BqHxRCaqpExgf60grTNBM0sZplwbmOuq65DqcrvvxrY0Z
         V+VcVktED7MKipI+sdaonG2xaOyIEGJNxeONM6qYf/cgBx19CKAjeYAFCqIqJw4OOuzh
         yjMC/me8fFqgisFyLR3V3eaCaMIr0JEJwd7FI4+45p168qV4K4wED9fgn2aV67LVxGBM
         7RyNOiyhvyqYW0mTCFl/APvl4OLwg31fV7PvIvMpN9iUHn0QOtqxjQvvD3uZ2NJPHR66
         rA0HqQPyEEu4T2MFi41hcKGiTO2k0GOauq5fujclnZdhd/8dos8i53fgnffX7iaGyF/l
         yEPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=es/vwfAMVB7AivnWOtsM8HnUGDRwewCv6Q9SMlwNd6E=;
        b=BbqmPzymWXJyUcBPvdNDgm2bbF02EGJFFutOWlatO9SJOnep9JJ5R2k7hrW9UjpeYa
         ITsRAxZxVcNUqis3ECDoj4qaxpcscWOEJA7fJkdR4TTviV8zzeT0MAU/30tuq6v4UVLG
         QIaWzSEPsIdLx57c6YusNdUjFx6fTQkyKUL9cKrwz9CO/1Tla4wEJYTttPTInh+UWgKP
         G0X4sDqYhI2tTo8kpXHXO6PLOlbAM0LMzXj9lKpv3TTriBAT+MjDK/VV09F+2uuy9USu
         gD1/Xd3Z5oLfkoVxFwiADgMXr3xHSzGgguSV8t02rUgsJpQlPPzD0mCI5Yts6yam4VEm
         zDNg==
X-Gm-Message-State: AOAM531WKHt0iJcPA2Is9BGG500QWy+GA41W6xVB59fL/SXS5GnLGaYP
        IAkaQBYwShEH50pgFj0VKr3cKpX2KKOcEzMd
X-Google-Smtp-Source: ABdhPJziV/TE+08UYwuFHWlVP6m5z7z+wZLVn5NCmcVcns1RLgE1LYH2xHxTMiL2b7a+TobI1aKCfQ==
X-Received: by 2002:a05:6402:3587:: with SMTP id y7mr32248641edc.197.1620680937336;
        Mon, 10 May 2021 14:08:57 -0700 (PDT)
Received: from anparri.mshome.net ([151.76.108.233])
        by smtp.gmail.com with ESMTPSA id c25sm12471239edt.43.2021.05.10.14.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 14:08:56 -0700 (PDT)
From:   "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, mikelley@microsoft.com,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
Subject: [PATCH v2] scsi: storvsc: Use blk_mq_unique_tag() to generate requestIDs
Date:   Mon, 10 May 2021 23:08:41 +0200
Message-Id: <20210510210841.370472-1-parri.andrea@gmail.com>
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
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
---
Changes since v1[1]:
  - add Reviewed-by: tags
  - rebase on hyperv-next

[1] https://lkml.kernel.org/r/20210415105926.3688-1-parri.andrea@gmail.com

 drivers/hv/channel.c              | 14 ++---
 drivers/hv/ring_buffer.c          | 14 +++--
 drivers/net/hyperv/netvsc.c       |  8 ++-
 drivers/net/hyperv/rndis_filter.c |  2 +
 drivers/scsi/storvsc_drv.c        | 94 +++++++++++++++++++++----------
 include/linux/hyperv.h            | 13 ++++-
 6 files changed, 95 insertions(+), 50 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 9aa789e5f22bb..2058fe969b04b 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -1124,15 +1124,14 @@ EXPORT_SYMBOL_GPL(vmbus_recvpacket_raw);
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
@@ -1166,16 +1165,15 @@ EXPORT_SYMBOL_GPL(vmbus_next_request_id);
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
index 29e90477363a8..7a10048c63548 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -321,11 +321,12 @@ int hv_ringbuffer_write(struct vmbus_channel *channel,
 	 */
 
 	if (desc->flags == VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED) {
-		rqst_id = vmbus_next_request_id(&channel->requestor, requestid);
-		if (rqst_id == VMBUS_RQST_ERROR) {
-			spin_unlock_irqrestore(&outring_info->ring_lock, flags);
-			pr_err("No request id available\n");
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
@@ -353,7 +354,8 @@ int hv_ringbuffer_write(struct vmbus_channel *channel,
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
index d17ff04986f52..553ec12cac875 100644
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
 	device->channel->max_pkt_size = NETVSC_MAX_PKT_SIZE;
 
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index d7ff9ddcbae28..983bf362466ad 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1259,6 +1259,8 @@ static void netvsc_sc_open(struct vmbus_channel *new_sc)
 	/* Set the channel before opening.*/
 	nvchan->channel = new_sc;
 
+	new_sc->next_request_id_callback = vmbus_next_request_id;
+	new_sc->request_addr_callback = vmbus_request_addr;
 	new_sc->rqstor_size = netvsc_rqstor_size(netvsc_ring_bytes);
 	new_sc->max_pkt_size = NETVSC_MAX_PKT_SIZE;
 
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index bfbaebded8025..439bb294e7eb0 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -692,6 +692,23 @@ static void storvsc_change_target_cpu(struct vmbus_channel *channel, u32 old,
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
@@ -707,11 +724,7 @@ static void handle_sc_creation(struct vmbus_channel *new_sc)
 	memset(&props, 0, sizeof(struct vmstorage_channel_properties));
 	new_sc->max_pkt_size = STORVSC_MAX_PKT_SIZE;
 
-	/*
-	 * The size of vmbus_requestor is an upper bound on the number of requests
-	 * that can be in-progress at any one time across all channels.
-	 */
-	new_sc->rqstor_size = scsi_driver.can_queue;
+	new_sc->next_request_id_callback = storvsc_next_request_id;
 
 	ret = vmbus_open(new_sc,
 			 storvsc_ringbuffer_size,
@@ -778,7 +791,7 @@ static void  handle_multichannel_storage(struct hv_device *device, int max_chns)
 	ret = vmbus_sendpacket(device->channel, vstor_packet,
 			       (sizeof(struct vstor_packet) -
 			       stor_device->vmscsi_size_delta),
-			       (unsigned long)request,
+			       VMBUS_RQST_INIT,
 			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 
@@ -847,7 +860,7 @@ static int storvsc_execute_vstor_op(struct hv_device *device,
 	ret = vmbus_sendpacket(device->channel, vstor_packet,
 			       (sizeof(struct vstor_packet) -
 			       stor_device->vmscsi_size_delta),
-			       (unsigned long)request,
+			       VMBUS_RQST_INIT,
 			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	if (ret != 0)
@@ -1249,6 +1262,7 @@ static void storvsc_on_channel_callback(void *context)
 	const struct vmpacket_descriptor *desc;
 	struct hv_device *device;
 	struct storvsc_device *stor_device;
+	struct Scsi_Host *shost;
 
 	if (channel->primary_channel != NULL)
 		device = channel->primary_channel->device_obj;
@@ -1259,20 +1273,12 @@ static void storvsc_on_channel_callback(void *context)
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
@@ -1280,14 +1286,44 @@ static void storvsc_on_channel_callback(void *context)
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
 
@@ -1300,11 +1336,7 @@ static int storvsc_connect_to_vsp(struct hv_device *device, u32 ring_size,
 	memset(&props, 0, sizeof(struct vmstorage_channel_properties));
 
 	device->channel->max_pkt_size = STORVSC_MAX_PKT_SIZE;
-	/*
-	 * The size of vmbus_requestor is an upper bound on the number of requests
-	 * that can be in-progress at any one time across all channels.
-	 */
-	device->channel->rqstor_size = scsi_driver.can_queue;
+	device->channel->next_request_id_callback = storvsc_next_request_id;
 
 	ret = vmbus_open(device->channel,
 			 ring_size,
@@ -1630,7 +1662,7 @@ static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
 	ret = vmbus_sendpacket(device->channel, vstor_packet,
 			       (sizeof(struct vstor_packet) -
 				stor_device->vmscsi_size_delta),
-			       (unsigned long)&stor_device->reset_request,
+			       VMBUS_RQST_RESET,
 			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	if (ret != 0)
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 9dd22af1b7f61..6c77b4c782851 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -783,7 +783,11 @@ struct vmbus_requestor {
 
 #define VMBUS_NO_RQSTOR U64_MAX
 #define VMBUS_RQST_ERROR (U64_MAX - 1)
+/* NetVSC-specific */
 #define VMBUS_RQST_ID_NO_RESPONSE (U64_MAX - 2)
+/* StorVSC-specific */
+#define VMBUS_RQST_INIT (U64_MAX - 2)
+#define VMBUS_RQST_RESET (U64_MAX - 3)
 
 struct vmbus_device {
 	u16  dev_type;
@@ -1013,6 +1017,11 @@ struct vmbus_channel {
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
@@ -1021,8 +1030,8 @@ struct vmbus_channel {
 	u32 max_pkt_size;
 };
 
-u64 vmbus_next_request_id(struct vmbus_requestor *rqstor, u64 rqst_addr);
-u64 vmbus_request_addr(struct vmbus_requestor *rqstor, u64 trans_id);
+u64 vmbus_next_request_id(struct vmbus_channel *channel, u64 rqst_addr);
+u64 vmbus_request_addr(struct vmbus_channel *channel, u64 trans_id);
 
 static inline bool is_hvsock_channel(const struct vmbus_channel *c)
 {
-- 
2.25.1

