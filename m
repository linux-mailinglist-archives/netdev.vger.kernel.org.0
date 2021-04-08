Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF33358968
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 18:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbhDHQNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 12:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231655AbhDHQNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 12:13:54 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF31C061760;
        Thu,  8 Apr 2021 09:13:42 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id hq27so3983189ejc.9;
        Thu, 08 Apr 2021 09:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dLmbBYo1yGsc211Y5IH11JuH7LuOWCp+Fdd9cX545w4=;
        b=ELUeQB40c9dkBlbawHGz0KdR+6wijinrVj41xLJ3gj1Hl1B32cUiC5gzps/j+/bDL/
         S0/sDRfT5d1uVs5oBbR9rfa+UGoyU692k1ooCQ4PD9HTPnJTIAUFskVhjzFzyvhknSDs
         zhuPn+HNFEuJEKCRRSy7MJwN2SSqLHYCXu04CuWH91xXk6D4uEVngHFDarn8rKbWlw2/
         YVaEYZrW8rd6ygla4vYTR4v3mH+XVoTuGaZMDbtcLNY9kPxG0xtYvXlcyqcwXqDEb14G
         rLKRLnTMooo5IOPsngnhc098KXaOCYvKotJzgMBXK4j3v/UgFl5/cLvabzu8kAcbdmaO
         /OPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dLmbBYo1yGsc211Y5IH11JuH7LuOWCp+Fdd9cX545w4=;
        b=rXbNlF32LXBOR41ui5q3IELLpeX4OfXUPo0CML/DKjKYHhnvdpYJPuYsN4mlFA7A0W
         lFDgvaYuno4SwvH12gCZCKKxhryjdRqmjUc2ySnrSKGhEoY1RYYCUOTRQKZ0bZS/Y/Cg
         Ow01e6k/XycwVCsuOAXkDWd/0LZd7K0DFLZr/GriypqEoAbSaZJ9BuJBA6PVSAdcouMB
         SkPIR5ymQ+A1o6axy8zHOLLDNuCWuVM0cOsizFJc+Aa3QHuC+9h5OcqPb2vdaKOuXOoS
         8r0SnCobsSfDI+Ilaonr90oNcmtaq+oYSYdX9BGZmkxHmmTuUmQkVgXoTv+CXIL88dcF
         3wew==
X-Gm-Message-State: AOAM532qGVGOKwRcwdmq34RTytacNZqVkHhSskHM7CMhw8pna/aXqUF9
        hNHPr8A/GW3/9si5sq++4mk8cyS9Dd6AKJXy
X-Google-Smtp-Source: ABdhPJxrTMR6uP/M4BYRU+oCXzTkRViwn7yg8Ko5bHgv5zJn5J6Hpf3lQnbhX1yaCftimI3NDnujeg==
X-Received: by 2002:a17:907:689:: with SMTP id wn9mr11256445ejb.485.1617898421048;
        Thu, 08 Apr 2021 09:13:41 -0700 (PDT)
Received: from anparri.mshome.net ([151.76.116.20])
        by smtp.gmail.com with ESMTPSA id p22sm6782970eju.85.2021.04.08.09.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 09:13:40 -0700 (PDT)
From:   "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, mikelley@microsoft.com,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
Subject: [RFC PATCH hyperv-next] scsi: storvsc: Use blk_mq_unique_tag() to generate requestIDs
Date:   Thu,  8 Apr 2021 18:13:15 +0200
Message-Id: <20210408161315.341888-1-parri.andrea@gmail.com>
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
 drivers/hv/channel.c              | 14 +++---
 drivers/hv/ring_buffer.c          | 12 ++---
 drivers/net/hyperv/netvsc.c       |  8 ++--
 drivers/net/hyperv/rndis_filter.c |  2 +
 drivers/scsi/storvsc_drv.c        | 73 ++++++++++++++++++++++++++-----
 include/linux/hyperv.h            | 13 +++++-
 6 files changed, 92 insertions(+), 30 deletions(-)

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
index ecd82ebfd5bc4..46d8e038e4ee1 100644
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
@@ -341,7 +343,7 @@ int hv_ringbuffer_write(struct vmbus_channel *channel,
 	if (channel->rescind) {
 		if (rqst_id != VMBUS_NO_RQSTOR) {
 			/* Reclaim request ID to avoid leak of IDs */
-			vmbus_request_addr(&channel->requestor, rqst_id);
+			channel->request_addr_callback(channel, rqst_id);
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
index 6bc5453cea8a7..1c05fabc06b04 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -684,6 +684,62 @@ static void storvsc_change_target_cpu(struct vmbus_channel *channel, u32 old,
 	spin_unlock_irqrestore(&stor_device->lock, flags);
 }
 
+u64 storvsc_next_request_id(struct vmbus_channel *channel, u64 rqst_addr)
+{
+	struct storvsc_cmd_request *request =
+		(struct storvsc_cmd_request *)(unsigned long)rqst_addr;
+	struct storvsc_device *stor_device;
+	struct hv_device *device;
+
+	device = (channel->primary_channel != NULL) ?
+		channel->primary_channel->device_obj : channel->device_obj;
+	if (device == NULL)
+		return VMBUS_RQST_ERROR;
+
+	stor_device = get_out_stor_device(device);
+	if (stor_device == NULL)
+		return VMBUS_RQST_ERROR;
+
+	if (request == &stor_device->init_request)
+		return VMBUS_RQST_INIT;
+	if (request == &stor_device->reset_request)
+		return VMBUS_RQST_RESET;
+
+	return blk_mq_unique_tag(request->cmd->request);
+}
+
+u64 storvsc_request_addr(struct vmbus_channel *channel, u64 rqst_id)
+{
+	struct storvsc_cmd_request *request;
+	struct storvsc_device *stor_device;
+	struct hv_device *device;
+	struct Scsi_Host *shost;
+	struct scsi_cmnd *scmnd;
+
+	device = (channel->primary_channel != NULL) ?
+		channel->primary_channel->device_obj : channel->device_obj;
+	if (device == NULL)
+		return VMBUS_RQST_ERROR;
+
+	stor_device = get_out_stor_device(device);
+	if (stor_device == NULL)
+		return VMBUS_RQST_ERROR;
+
+	if (rqst_id == VMBUS_RQST_INIT)
+		return (unsigned long)&stor_device->init_request;
+	if (rqst_id == VMBUS_RQST_RESET)
+		return (unsigned long)&stor_device->reset_request;
+
+	shost = stor_device->host;
+
+	scmnd = scsi_host_find_tag(shost, rqst_id);
+	if (scmnd == NULL)
+		return VMBUS_RQST_ERROR;
+
+	request = (struct storvsc_cmd_request *)(unsigned long)scsi_cmd_priv(scmnd);
+	return (unsigned long)request;
+}
+
 static void handle_sc_creation(struct vmbus_channel *new_sc)
 {
 	struct hv_device *device = new_sc->primary_channel->device_obj;
@@ -698,11 +754,8 @@ static void handle_sc_creation(struct vmbus_channel *new_sc)
 
 	memset(&props, 0, sizeof(struct vmstorage_channel_properties));
 
-	/*
-	 * The size of vmbus_requestor is an upper bound on the number of requests
-	 * that can be in-progress at any one time across all channels.
-	 */
-	new_sc->rqstor_size = scsi_driver.can_queue;
+	new_sc->next_request_id_callback = storvsc_next_request_id;
+	new_sc->request_addr_callback = storvsc_request_addr;
 
 	ret = vmbus_open(new_sc,
 			 storvsc_ringbuffer_size,
@@ -1255,8 +1308,7 @@ static void storvsc_on_channel_callback(void *context)
 		struct storvsc_cmd_request *request;
 		u64 cmd_rqst;
 
-		cmd_rqst = vmbus_request_addr(&channel->requestor,
-					      desc->trans_id);
+		cmd_rqst = channel->request_addr_callback(channel, desc->trans_id);
 		if (cmd_rqst == VMBUS_RQST_ERROR) {
 			dev_err(&device->device,
 				"Incorrect transaction id\n");
@@ -1290,11 +1342,8 @@ static int storvsc_connect_to_vsp(struct hv_device *device, u32 ring_size,
 
 	memset(&props, 0, sizeof(struct vmstorage_channel_properties));
 
-	/*
-	 * The size of vmbus_requestor is an upper bound on the number of requests
-	 * that can be in-progress at any one time across all channels.
-	 */
-	device->channel->rqstor_size = scsi_driver.can_queue;
+	device->channel->next_request_id_callback = storvsc_next_request_id;
+	device->channel->request_addr_callback = storvsc_request_addr;
 
 	ret = vmbus_open(device->channel,
 			 ring_size,
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

