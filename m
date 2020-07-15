Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8372215C5
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 22:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgGOUIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 16:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgGOUIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 16:08:40 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5ACC061755;
        Wed, 15 Jul 2020 13:08:40 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id gc9so3623709pjb.2;
        Wed, 15 Jul 2020 13:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version:reply-to
         :content-transfer-encoding;
        bh=rNCwMVbvGVdw0IWmEG4fZUijootGqpakUyGcM9vQ3Q4=;
        b=LXLE4tvVJS7Uqt4hgWSPMCUIL5IKFTvG24lxP1ncejCeHwt8nlVj26DzItvi+mJlGn
         btPsbfqYA3l6rszO1hicuuKJprDRXSPcWlwuTZZijUj3s+7r0I/zj23PrOxeaxgIWJok
         gxDbTWcrI5km+owxNhSTRnfPO5GV3c7H5BhAgmV2zwus1Tpy14q/6cXjtdeDuh1K7F7d
         SosxUGuqM2N1avliv/d6u53B2Gk20Xy3NsSxPtfZg4EYPEFmsbrs5e4IOowavm014Sss
         CFkcsH2hynt3+tjgqwsjHSSuRr69dZa5BSeiuHRE0Jt82aJJs5jOObXbeFDk+ry4JTgb
         tw8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :reply-to:content-transfer-encoding;
        bh=rNCwMVbvGVdw0IWmEG4fZUijootGqpakUyGcM9vQ3Q4=;
        b=sOHN+mK3dj+lrcEFBOJFYZMJXy6cKFIxu3ULQalGbT7RF7kG4I0ROPC6muZBgkaa0f
         ojNkInIf3qLSvyYU2C5KmyZlHSPgM7yl8mUedz4NJ8prMxZf0HCFVGTcmMs4KFMcMc0m
         eOIBjyrYYkWBZm5CSr2fjgskCiKItiyTQGXx7oMANaxy6Z3+scqwv0o0rLLVCE2h1oGX
         ycQdmWb3zjnQyOP2C/f1B0JdwqESFtzx6PurJtXPBYFzswMkc3n4HEChv9yj1x9u3wRD
         Ux5m4JvCmjCpaXTbB2aekgHGEQrvv/ZSPdPkM5/LDpyOZ2eWRpqdwAreec0LKj1G4xVS
         H4pw==
X-Gm-Message-State: AOAM5334kV9sWLe9SFyXVXyLENz8XgvPKxHleZUh+mrulD9oxzwu6sPT
        SVRdvKE5WSGsgsU/jFbt9GM=
X-Google-Smtp-Source: ABdhPJwpdYXWujjZ7z2jU4tHAvS1ef7+vdvKxrrHCxs5+A322iJuEvzRNqNVor+BafP97ODQ+ClWog==
X-Received: by 2002:a17:90a:668f:: with SMTP id m15mr1400119pjj.32.1594843719958;
        Wed, 15 Jul 2020 13:08:39 -0700 (PDT)
Received: from localhost.localdomain ([131.107.174.194])
        by smtp.gmail.com with ESMTPSA id 207sm2850450pfa.100.2020.07.15.13.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 13:08:39 -0700 (PDT)
From:   Andres Beltran <lkmlabelt@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org
Cc:     linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikelley@microsoft.com, parri.andrea@gmail.com,
        skarade@microsoft.com, Andres Beltran <lkmlabelt@gmail.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2] Drivers: hv: vmbus: Copy packets sent by Hyper-V out of the ring buffer
Date:   Wed, 15 Jul 2020 16:08:33 -0400
Message-Id: <20200715200834.448269-1-lkmlabelt@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Reply-To: t-mabelt@microsoft.com
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pointers to ring-buffer packets sent by Hyper-V are used within the
guest VM. Hyper-V can send packets with erroneous values or modify
packet fields after they are processed by the guest. To defend
against these scenarios, return a copy of the incoming VMBus packet
after validating its length and offset fields in hv_pkt_iter_first().
In this way, the packet can no longer be modified by the host.

Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-scsi@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Andres Beltran <lkmlabelt@gmail.com>
---
Changes in v2:
	- Removed unused variable in storvsc_connect_to_vsp().

 drivers/hv/channel.c              |  9 +++--
 drivers/hv/hyperv_vmbus.h         |  2 +-
 drivers/hv/ring_buffer.c          | 61 ++++++++++++++++++++++++++++---
 drivers/net/hyperv/hyperv_net.h   |  7 ++++
 drivers/net/hyperv/netvsc.c       |  2 +
 drivers/net/hyperv/rndis_filter.c |  2 +
 drivers/scsi/storvsc_drv.c        | 10 +++++
 include/linux/hyperv.h            |  9 +++++
 8 files changed, 93 insertions(+), 9 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index c16ddd3e5ce1..369628fe811d 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -206,12 +206,15 @@ static int __vmbus_open(struct vmbus_channel *newchannel,
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
 
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 40e2b9f91163..ff755e5d65fd 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -174,7 +174,7 @@ extern int hv_synic_cleanup(unsigned int cpu);
 void hv_ringbuffer_pre_init(struct vmbus_channel *channel);
 
 int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
-		       struct page *pages, u32 pagecnt);
+		       struct page *pages, u32 pagecnt, u32 max_pkt_size);
 
 void hv_ringbuffer_cleanup(struct hv_ring_buffer_info *ring_info);
 
diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index 356e22159e83..172d78256445 100644
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
+		ring_info->pkt_buffer = kmalloc(max_pkt_size, GFP_KERNEL);
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
@@ -395,16 +406,56 @@ struct vmpacket_descriptor *hv_pkt_iter_first(struct vmbus_channel *channel)
 {
 	struct hv_ring_buffer_info *rbi = &channel->inbound;
 	struct vmpacket_descriptor *desc;
+	struct vmpacket_descriptor *desc_copy;
+	u32 bytes_avail, pkt_len, pkt_offset;
 
 	hv_debug_delay_test(channel, MESSAGE_DELAY);
-	if (hv_pkt_iter_avail(rbi) < sizeof(struct vmpacket_descriptor))
+
+	bytes_avail = hv_pkt_iter_avail(rbi);
+	if (bytes_avail < sizeof(struct vmpacket_descriptor))
 		return NULL;
 
 	desc = hv_get_ring_buffer(rbi) + rbi->priv_read_index;
-	if (desc)
-		prefetch((char *)desc + (desc->len8 << 3));
+	if (!desc)
+		return desc;
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
+	if (rbi->pkt_buffer_size < bytes_avail)
+		bytes_avail = rbi->pkt_buffer_size;
+
+	if (pkt_len <= sizeof(struct vmpacket_descriptor) || pkt_len > bytes_avail)
+		pkt_len = bytes_avail;
+
+	/*
+	 * If pkt_offset it is invalid, arbitrarily set it to
+	 * the size of vmpacket_descriptor
+	 */
+	if (pkt_offset < sizeof(struct vmpacket_descriptor) || pkt_offset >= pkt_len)
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
 
diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index f43b614f2345..a394f73b9821 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -860,6 +860,13 @@ static inline u32 netvsc_rqstor_size(unsigned long ringbytes)
 	       ringbytes / NETVSC_MIN_IN_MSG_SIZE;
 }
 
+#define NETVSC_MAX_XFER_PAGE_RANGES 375
+#define NETVSC_XFER_HEADER_SIZE(rng_cnt) \
+		(offsetof(struct vmtransfer_page_packet_header, ranges) + \
+		(rng_cnt) * sizeof(struct vmtransfer_page_range))
+#define NETVSC_MAX_PKT_SIZE (NETVSC_XFER_HEADER_SIZE(NETVSC_MAX_XFER_PAGE_RANGES) + \
+		sizeof(struct nvsp_message) + (sizeof(u32) * VRSS_SEND_TAB_SIZE))
+
 struct multi_send_data {
 	struct sk_buff *skb; /* skb containing the pkt */
 	struct hv_netvsc_packet *pkt; /* netvsc pkt pending */
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 79b907a29433..9585df459841 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -1473,6 +1473,8 @@ struct netvsc_device *netvsc_device_add(struct hv_device *device,
 
 	/* Open the channel */
 	device->channel->rqstor_size = netvsc_rqstor_size(netvsc_ring_bytes);
+	device->channel->max_pkt_size = NETVSC_MAX_PKT_SIZE;
+
 	ret = vmbus_open(device->channel, netvsc_ring_bytes,
 			 netvsc_ring_bytes,  NULL, 0,
 			 netvsc_channel_cb, net_device->chan_table);
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 10489ba44a09..6de0f4e0db7b 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1115,6 +1115,8 @@ static void netvsc_sc_open(struct vmbus_channel *new_sc)
 	nvchan->channel = new_sc;
 
 	new_sc->rqstor_size = netvsc_rqstor_size(netvsc_ring_bytes);
+	new_sc->max_pkt_size = NETVSC_MAX_PKT_SIZE;
+
 	ret = vmbus_open(new_sc, netvsc_ring_bytes,
 			 netvsc_ring_bytes, NULL, 0,
 			 netvsc_channel_cb, nvchan);
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 6d2df1f0fe6d..fc259e2517ae 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -414,6 +414,14 @@ static void storvsc_on_channel_callback(void *context);
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
 
@@ -698,6 +706,7 @@ static void handle_sc_creation(struct vmbus_channel *new_sc)
 		return;
 
 	memset(&props, 0, sizeof(struct vmstorage_channel_properties));
+	new_sc->max_pkt_size = STORVSC_MAX_PKT_SIZE;
 
 	/*
 	 * The size of vmbus_requestor is an upper bound on the number of requests
@@ -1292,6 +1301,7 @@ static int storvsc_connect_to_vsp(struct hv_device *device, u32 ring_size,
 
 	memset(&props, 0, sizeof(struct vmstorage_channel_properties));
 
+	device->channel->max_pkt_size = STORVSC_MAX_PKT_SIZE;
 	/*
 	 * The size of vmbus_requestor is an upper bound on the number of requests
 	 * that can be in-progress at any one time across all channels.
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index d8194924983d..3524d9e481c5 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -133,6 +133,10 @@ struct hv_ring_buffer_info {
 	 * being freed while the ring buffer is being accessed.
 	 */
 	struct mutex ring_buffer_mutex;
+
+	/* Buffer that holds a copy of an incoming host packet */
+	void *pkt_buffer;
+	u32 pkt_buffer_size;
 };
 
 
@@ -738,6 +742,8 @@ struct vmbus_device {
 	bool perf_device;
 };
 
+#define VMBUS_DEFAULT_MAX_PKT_SIZE 4096
+
 struct vmbus_channel {
 	struct list_head listentry;
 
@@ -959,6 +965,9 @@ struct vmbus_channel {
 	/* request/transaction ids for VMBus */
 	struct vmbus_requestor requestor;
 	u32 rqstor_size;
+
+	/* The max size of a packet on this channel */
+	u32 max_pkt_size;
 };
 
 u64 vmbus_next_request_id(struct vmbus_requestor *rqstor, u64 rqst_addr);
-- 
2.25.1

