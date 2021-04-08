Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB9B35896F
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 18:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbhDHQPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 12:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231655AbhDHQPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 12:15:21 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D173C061760;
        Thu,  8 Apr 2021 09:15:10 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id w18so3169036edc.0;
        Thu, 08 Apr 2021 09:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q4COyLAPvypgmtF3K9YRMwxE37mb3+X0oyB6wXzw7G0=;
        b=hfuOm4km2gml1KEbAwr87lvHx6DPSQmJsZvtYFLlox4xM8SXAqgSpW+D8R4ohJdCcN
         Mk8lfiD6+Mp4sfH2tbqqRdx5T7ZlPhn9Ly+Osx6j8okCKfqsUifxYg21pF1oghA0ig79
         jYBz8HA3mmMwK5LRy3wBu+y2/cIIF8apT9jSTO+XO3Mbafmk7hqLu0c9ecNPaHoxvwxl
         va0LZj9nf4Qm1kNCoP02yqFnG5bftUNFC/f22TJkAPGiW7MfYDLgnRlQCCdZYrYRSn7D
         9z6rIugRRAhLlbsOBJWxic+JX7qB8cZgqtsMlN5/TFvTvRziAl370NW77Kxg07XXAthg
         sGUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q4COyLAPvypgmtF3K9YRMwxE37mb3+X0oyB6wXzw7G0=;
        b=adwax0KbAkFQYpkxCdOnVkPseuMGc6OslcZyGhpjJqjfhMY3MM3HFq9oGHgCQ5a7FT
         pVuitmMyKv1wsvZewt6d04QKSgYcmkLqiRzz35GX02JbYEh++9tjZ8qQicZyxa2FmNHU
         xs6KNbV47UrpqlkeQ1XrGcQHLN6msk7Ml1wB24Q9Xdi2piuW0OrQubr+VRVXkxjtUNlo
         0eedfpapaPIsDfK2/UVj2TI8bnjF2S6k+YdUPDjOiRH6vuTroztBt9bPEcltuJLsDKRo
         C77KXr9lq/LF+l3E8qDFdcl2DUsF/4sIDKU1Qalt6bnYdmv0t6ZfeQB45Ct+NeLeaZZH
         VezQ==
X-Gm-Message-State: AOAM532Tlb5KWHWGU/YR0lREFvOmLX3XPzTBnAq6Y3H+QZxeJJsHtkYo
        E+aLx6Ivu86zfoKCFaGKR1wSVfp7OBw1c52A
X-Google-Smtp-Source: ABdhPJy7GIgG0cwbV43JAXXtePZT68GDe3o0v1OlQBboYucEVeDdV9unTADtA0jcmE8e5e06fS3++g==
X-Received: by 2002:a05:6402:1393:: with SMTP id b19mr12347442edv.333.1617898506993;
        Thu, 08 Apr 2021 09:15:06 -0700 (PDT)
Received: from anparri.mshome.net ([151.76.116.20])
        by smtp.gmail.com with ESMTPSA id y21sm1499627edr.38.2021.04.08.09.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 09:15:06 -0700 (PDT)
From:   "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, mikelley@microsoft.com,
        Andres Beltran <lkmlabelt@gmail.com>,
        Andrea Parri <parri.andrea@gmail.com>
Subject: [PATCH hyperv-next] Drivers: hv: vmbus: Copy packets sent by Hyper-V out of the ring buffer
Date:   Thu,  8 Apr 2021 18:14:39 +0200
Message-Id: <20210408161439.341988-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andres Beltran <lkmlabelt@gmail.com>

Pointers to ring-buffer packets sent by Hyper-V are used within the
guest VM. Hyper-V can send packets with erroneous values or modify
packet fields after they are processed by the guest. To defend
against these scenarios, return a copy of the incoming VMBus packet
after validating its length and offset fields in hv_pkt_iter_first().
In this way, the packet can no longer be modified by the host.

Signed-off-by: Andres Beltran <lkmlabelt@gmail.com>
Co-developed-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
---
 drivers/hv/channel.c              |  9 ++--
 drivers/hv/hv_fcopy.c             |  1 +
 drivers/hv/hv_kvp.c               |  1 +
 drivers/hv/hyperv_vmbus.h         |  2 +-
 drivers/hv/ring_buffer.c          | 82 ++++++++++++++++++++++++++-----
 drivers/net/hyperv/hyperv_net.h   |  7 +++
 drivers/net/hyperv/netvsc.c       |  2 +
 drivers/net/hyperv/rndis_filter.c |  2 +
 drivers/scsi/storvsc_drv.c        | 10 ++++
 include/linux/hyperv.h            | 48 +++++++++++++++---
 net/vmw_vsock/hyperv_transport.c  |  4 +-
 11 files changed, 143 insertions(+), 25 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index db30be8f9ccea..b665db21e120d 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -597,12 +597,15 @@ static int __vmbus_open(struct vmbus_channel *newchannel,
 	newchannel->onchannel_callback = onchannelcallback;
 	newchannel->channel_callback_context = context;
 
-	err = hv_ringbuffer_init(&newchannel->outbound, page, send_pages);
+	if (!newchannel->max_pkt_size)
+		newchannel->max_pkt_size = VMBUS_DEFAULT_MAX_PKT_SIZE;
+
+	err = hv_ringbuffer_init(&newchannel->outbound, page, send_pages, 0);
 	if (err)
 		goto error_clean_ring;
 
-	err = hv_ringbuffer_init(&newchannel->inbound,
-				 &page[send_pages], recv_pages);
+	err = hv_ringbuffer_init(&newchannel->inbound, &page[send_pages],
+				 recv_pages, newchannel->max_pkt_size);
 	if (err)
 		goto error_clean_ring;
 
diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c
index 59ce85e00a028..660036da74495 100644
--- a/drivers/hv/hv_fcopy.c
+++ b/drivers/hv/hv_fcopy.c
@@ -349,6 +349,7 @@ int hv_fcopy_init(struct hv_util_service *srv)
 {
 	recv_buffer = srv->recv_buffer;
 	fcopy_transaction.recv_channel = srv->channel;
+	fcopy_transaction.recv_channel->max_pkt_size = HV_HYP_PAGE_SIZE * 2;
 
 	/*
 	 * When this driver loads, the user level daemon that
diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
index b49962d312cef..c698592b83e42 100644
--- a/drivers/hv/hv_kvp.c
+++ b/drivers/hv/hv_kvp.c
@@ -757,6 +757,7 @@ hv_kvp_init(struct hv_util_service *srv)
 {
 	recv_buffer = srv->recv_buffer;
 	kvp_transaction.recv_channel = srv->channel;
+	kvp_transaction.recv_channel->max_pkt_size = HV_HYP_PAGE_SIZE * 4;
 
 	/*
 	 * When this driver loads, the user level daemon that
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 9416e09ebd58c..42f3d9d123a12 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -174,7 +174,7 @@ extern int hv_synic_cleanup(unsigned int cpu);
 void hv_ringbuffer_pre_init(struct vmbus_channel *channel);
 
 int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
-		       struct page *pages, u32 pagecnt);
+		       struct page *pages, u32 pagecnt, u32 max_pkt_size);
 
 void hv_ringbuffer_cleanup(struct hv_ring_buffer_info *ring_info);
 
diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index ecd82ebfd5bc4..848f3bba83f8b 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -190,7 +190,7 @@ void hv_ringbuffer_pre_init(struct vmbus_channel *channel)
 
 /* Initialize the ring buffer. */
 int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
-		       struct page *pages, u32 page_cnt)
+		       struct page *pages, u32 page_cnt, u32 max_pkt_size)
 {
 	int i;
 	struct page **pages_wraparound;
@@ -232,6 +232,14 @@ int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
 		sizeof(struct hv_ring_buffer);
 	ring_info->priv_read_index = 0;
 
+	/* Initialize buffer that holds copies of incoming packets */
+	if (max_pkt_size) {
+		ring_info->pkt_buffer = kzalloc(max_pkt_size, GFP_KERNEL);
+		if (!ring_info->pkt_buffer)
+			return -ENOMEM;
+		ring_info->pkt_buffer_size = max_pkt_size;
+	}
+
 	spin_lock_init(&ring_info->ring_lock);
 
 	return 0;
@@ -244,6 +252,9 @@ void hv_ringbuffer_cleanup(struct hv_ring_buffer_info *ring_info)
 	vunmap(ring_info->ring_buffer);
 	ring_info->ring_buffer = NULL;
 	mutex_unlock(&ring_info->ring_buffer_mutex);
+
+	kfree(ring_info->pkt_buffer);
+	ring_info->pkt_buffer_size = 0;
 }
 
 /* Write to the ring buffer. */
@@ -384,7 +395,7 @@ int hv_ringbuffer_read(struct vmbus_channel *channel,
 	memcpy(buffer, (const char *)desc + offset, packetlen);
 
 	/* Advance ring index to next packet descriptor */
-	__hv_pkt_iter_next(channel, desc);
+	__hv_pkt_iter_next(channel, desc, true);
 
 	/* Notify host of update */
 	hv_pkt_iter_close(channel);
@@ -410,6 +421,22 @@ static u32 hv_pkt_iter_avail(const struct hv_ring_buffer_info *rbi)
 		return (rbi->ring_datasize - priv_read_loc) + write_loc;
 }
 
+/*
+ * Get first vmbus packet without copying it out of the ring buffer
+ */
+struct vmpacket_descriptor *hv_pkt_iter_first_raw(struct vmbus_channel *channel)
+{
+	struct hv_ring_buffer_info *rbi = &channel->inbound;
+
+	hv_debug_delay_test(channel, MESSAGE_DELAY);
+
+	if (hv_pkt_iter_avail(rbi) < sizeof(struct vmpacket_descriptor))
+		return NULL;
+
+	return (struct vmpacket_descriptor *)(hv_get_ring_buffer(rbi) + rbi->priv_read_index);
+}
+EXPORT_SYMBOL_GPL(hv_pkt_iter_first_raw);
+
 /*
  * Get first vmbus packet from ring buffer after read_index
  *
@@ -418,17 +445,49 @@ static u32 hv_pkt_iter_avail(const struct hv_ring_buffer_info *rbi)
 struct vmpacket_descriptor *hv_pkt_iter_first(struct vmbus_channel *channel)
 {
 	struct hv_ring_buffer_info *rbi = &channel->inbound;
-	struct vmpacket_descriptor *desc;
+	struct vmpacket_descriptor *desc, *desc_copy;
+	u32 bytes_avail, pkt_len, pkt_offset;
 
-	hv_debug_delay_test(channel, MESSAGE_DELAY);
-	if (hv_pkt_iter_avail(rbi) < sizeof(struct vmpacket_descriptor))
+	desc = hv_pkt_iter_first_raw(channel);
+	if (!desc)
 		return NULL;
 
-	desc = hv_get_ring_buffer(rbi) + rbi->priv_read_index;
-	if (desc)
-		prefetch((char *)desc + (desc->len8 << 3));
+	bytes_avail = min(rbi->pkt_buffer_size, hv_pkt_iter_avail(rbi));
+
+	/*
+	 * Ensure the compiler does not use references to incoming Hyper-V values (which
+	 * could change at any moment) when reading local variables later in the code
+	 */
+	pkt_len = READ_ONCE(desc->len8) << 3;
+	pkt_offset = READ_ONCE(desc->offset8) << 3;
+
+	/*
+	 * If pkt_len is invalid, set it to the smaller of hv_pkt_iter_avail() and
+	 * rbi->pkt_buffer_size
+	 */
+	if (pkt_len < sizeof(struct vmpacket_descriptor) || pkt_len > bytes_avail)
+		pkt_len = bytes_avail;
+
+	/*
+	 * If pkt_offset is invalid, arbitrarily set it to
+	 * the size of vmpacket_descriptor
+	 */
+	if (pkt_offset < sizeof(struct vmpacket_descriptor) || pkt_offset > pkt_len)
+		pkt_offset = sizeof(struct vmpacket_descriptor);
+
+	/* Copy the Hyper-V packet out of the ring buffer */
+	desc_copy = (struct vmpacket_descriptor *)rbi->pkt_buffer;
+	memcpy(desc_copy, desc, pkt_len);
+
+	/*
+	 * Hyper-V could still change len8 and offset8 after the earlier read.
+	 * Ensure that desc_copy has legal values for len8 and offset8 that
+	 * are consistent with the copy we just made
+	 */
+	desc_copy->len8 = pkt_len >> 3;
+	desc_copy->offset8 = pkt_offset >> 3;
 
-	return desc;
+	return desc_copy;
 }
 EXPORT_SYMBOL_GPL(hv_pkt_iter_first);
 
@@ -440,7 +499,8 @@ EXPORT_SYMBOL_GPL(hv_pkt_iter_first);
  */
 struct vmpacket_descriptor *
 __hv_pkt_iter_next(struct vmbus_channel *channel,
-		   const struct vmpacket_descriptor *desc)
+		   const struct vmpacket_descriptor *desc,
+		   bool copy)
 {
 	struct hv_ring_buffer_info *rbi = &channel->inbound;
 	u32 packetlen = desc->len8 << 3;
@@ -453,7 +513,7 @@ __hv_pkt_iter_next(struct vmbus_channel *channel,
 		rbi->priv_read_index -= dsize;
 
 	/* more data? */
-	return hv_pkt_iter_first(channel);
+	return copy ? hv_pkt_iter_first(channel) : hv_pkt_iter_first_raw(channel);
 }
 EXPORT_SYMBOL_GPL(__hv_pkt_iter_next);
 
diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index e1a497d3c9ba4..154539b2f75ba 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -895,9 +895,16 @@ static inline u32 netvsc_rqstor_size(unsigned long ringbytes)
 		ringbytes / NETVSC_MIN_IN_MSG_SIZE;
 }
 
+/* XFER PAGE packets can specify a maximum of 375 ranges for NDIS >= 6.0
+ * and a maximum of 64 ranges for NDIS < 6.0 with no RSC; with RSC, this
+ * limit is raised to 562 (= NVSP_RSC_MAX).
+ */
+#define NETVSC_MAX_XFER_PAGE_RANGES NVSP_RSC_MAX
 #define NETVSC_XFER_HEADER_SIZE(rng_cnt) \
 		(offsetof(struct vmtransfer_page_packet_header, ranges) + \
 		(rng_cnt) * sizeof(struct vmtransfer_page_range))
+#define NETVSC_MAX_PKT_SIZE (NETVSC_XFER_HEADER_SIZE(NETVSC_MAX_XFER_PAGE_RANGES) + \
+		sizeof(struct nvsp_message) + (sizeof(u32) * VRSS_SEND_TAB_SIZE))
 
 struct multi_send_data {
 	struct sk_buff *skb; /* skb containing the pkt */
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index c64cc7639c39c..d17ff04986f52 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -1603,6 +1603,8 @@ struct netvsc_device *netvsc_device_add(struct hv_device *device,
 
 	/* Open the channel */
 	device->channel->rqstor_size = netvsc_rqstor_size(netvsc_ring_bytes);
+	device->channel->max_pkt_size = NETVSC_MAX_PKT_SIZE;
+
 	ret = vmbus_open(device->channel, netvsc_ring_bytes,
 			 netvsc_ring_bytes,  NULL, 0,
 			 netvsc_channel_cb, net_device->chan_table);
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 123cc9d25f5ed..6508c4724c224 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1260,6 +1260,8 @@ static void netvsc_sc_open(struct vmbus_channel *new_sc)
 	nvchan->channel = new_sc;
 
 	new_sc->rqstor_size = netvsc_rqstor_size(netvsc_ring_bytes);
+	new_sc->max_pkt_size = NETVSC_MAX_PKT_SIZE;
+
 	ret = vmbus_open(new_sc, netvsc_ring_bytes,
 			 netvsc_ring_bytes, NULL, 0,
 			 netvsc_channel_cb, nvchan);
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 6bc5453cea8a7..bfbaebded8025 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -402,6 +402,14 @@ static void storvsc_on_channel_callback(void *context);
 #define STORVSC_IDE_MAX_TARGETS				1
 #define STORVSC_IDE_MAX_CHANNELS			1
 
+/*
+ * Upper bound on the size of a storvsc packet. vmscsi_size_delta is not
+ * included in the calculation because it is set after STORVSC_MAX_PKT_SIZE
+ * is used in storvsc_connect_to_vsp
+ */
+#define STORVSC_MAX_PKT_SIZE (sizeof(struct vmpacket_descriptor) +\
+			      sizeof(struct vstor_packet))
+
 struct storvsc_cmd_request {
 	struct scsi_cmnd *cmd;
 
@@ -697,6 +705,7 @@ static void handle_sc_creation(struct vmbus_channel *new_sc)
 		return;
 
 	memset(&props, 0, sizeof(struct vmstorage_channel_properties));
+	new_sc->max_pkt_size = STORVSC_MAX_PKT_SIZE;
 
 	/*
 	 * The size of vmbus_requestor is an upper bound on the number of requests
@@ -1290,6 +1299,7 @@ static int storvsc_connect_to_vsp(struct hv_device *device, u32 ring_size,
 
 	memset(&props, 0, sizeof(struct vmstorage_channel_properties));
 
+	device->channel->max_pkt_size = STORVSC_MAX_PKT_SIZE;
 	/*
 	 * The size of vmbus_requestor is an upper bound on the number of requests
 	 * that can be in-progress at any one time across all channels.
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 2c18c8e768efe..7387bb41f6a37 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -181,6 +181,10 @@ struct hv_ring_buffer_info {
 	 * being freed while the ring buffer is being accessed.
 	 */
 	struct mutex ring_buffer_mutex;
+
+	/* Buffer that holds a copy of an incoming host packet */
+	void *pkt_buffer;
+	u32 pkt_buffer_size;
 };
 
 
@@ -788,6 +792,8 @@ struct vmbus_device {
 	bool allowed_in_isolated;
 };
 
+#define VMBUS_DEFAULT_MAX_PKT_SIZE 4096
+
 struct vmbus_channel {
 	struct list_head listentry;
 
@@ -1010,6 +1016,9 @@ struct vmbus_channel {
 	/* request/transaction ids for VMBus */
 	struct vmbus_requestor requestor;
 	u32 rqstor_size;
+
+	/* The max size of a packet on this channel */
+	u32 max_pkt_size;
 };
 
 u64 vmbus_next_request_id(struct vmbus_requestor *rqstor, u64 rqst_addr);
@@ -1651,32 +1660,55 @@ static inline u32 hv_pkt_datalen(const struct vmpacket_descriptor *desc)
 }
 
 
+struct vmpacket_descriptor *
+hv_pkt_iter_first_raw(struct vmbus_channel *channel);
+
 struct vmpacket_descriptor *
 hv_pkt_iter_first(struct vmbus_channel *channel);
 
 struct vmpacket_descriptor *
 __hv_pkt_iter_next(struct vmbus_channel *channel,
-		   const struct vmpacket_descriptor *pkt);
+		   const struct vmpacket_descriptor *pkt,
+		   bool copy);
 
 void hv_pkt_iter_close(struct vmbus_channel *channel);
 
-/*
- * Get next packet descriptor from iterator
- * If at end of list, return NULL and update host.
- */
 static inline struct vmpacket_descriptor *
-hv_pkt_iter_next(struct vmbus_channel *channel,
-		 const struct vmpacket_descriptor *pkt)
+hv_pkt_iter_next_pkt(struct vmbus_channel *channel,
+		     const struct vmpacket_descriptor *pkt,
+		     bool copy)
 {
 	struct vmpacket_descriptor *nxt;
 
-	nxt = __hv_pkt_iter_next(channel, pkt);
+	nxt = __hv_pkt_iter_next(channel, pkt, copy);
 	if (!nxt)
 		hv_pkt_iter_close(channel);
 
 	return nxt;
 }
 
+/*
+ * Get next packet descriptor without copying it out of the ring buffer
+ * If at end of list, return NULL and update host.
+ */
+static inline struct vmpacket_descriptor *
+hv_pkt_iter_next_raw(struct vmbus_channel *channel,
+		     const struct vmpacket_descriptor *pkt)
+{
+	return hv_pkt_iter_next_pkt(channel, pkt, false);
+}
+
+/*
+ * Get next packet descriptor from iterator
+ * If at end of list, return NULL and update host.
+ */
+static inline struct vmpacket_descriptor *
+hv_pkt_iter_next(struct vmbus_channel *channel,
+		 const struct vmpacket_descriptor *pkt)
+{
+	return hv_pkt_iter_next_pkt(channel, pkt, true);
+}
+
 #define foreach_vmbus_pkt(pkt, channel) \
 	for (pkt = hv_pkt_iter_first(channel); pkt; \
 	    pkt = hv_pkt_iter_next(channel, pkt))
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index cc3bae2659e79..19189cf30a72f 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -596,7 +596,7 @@ static ssize_t hvs_stream_dequeue(struct vsock_sock *vsk, struct msghdr *msg,
 		return -EOPNOTSUPP;
 
 	if (need_refill) {
-		hvs->recv_desc = hv_pkt_iter_first(hvs->chan);
+		hvs->recv_desc = hv_pkt_iter_first_raw(hvs->chan);
 		ret = hvs_update_recv_data(hvs);
 		if (ret)
 			return ret;
@@ -610,7 +610,7 @@ static ssize_t hvs_stream_dequeue(struct vsock_sock *vsk, struct msghdr *msg,
 
 	hvs->recv_data_len -= to_read;
 	if (hvs->recv_data_len == 0) {
-		hvs->recv_desc = hv_pkt_iter_next(hvs->chan, hvs->recv_desc);
+		hvs->recv_desc = hv_pkt_iter_next_raw(hvs->chan, hvs->recv_desc);
 		if (hvs->recv_desc) {
 			ret = hvs_update_recv_data(hvs);
 			if (ret)
-- 
2.25.1

