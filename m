Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCDCB3272CD
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 16:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhB1PG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 10:06:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbhB1PFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 10:05:37 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624DBC061797;
        Sun, 28 Feb 2021 07:04:19 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id x29so1484754pgk.6;
        Sun, 28 Feb 2021 07:04:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IlP+UqaTTH6S778JlrTl0GossJzFFQBlG/jMumY6xKg=;
        b=J0QoRw2N/2yfzZ3toJcfKV7iDJelt9eUQKb6RRq4Kd6ay2raOQT9S/TwUdFfypau8h
         vjkHtPR1oSYaI4rJmrZaf6IUip0nmHA0rrHfe6CTGDCPXaLBZnsZ3grf0BrWLWMPbiCj
         JHcYaTcEbMGmgQ17OPUu1z7YG4Gcz6hldTjKLlsW5QNTFZH0sNSUy1pqnR6uNsMhnChq
         wRSgVqWI3aKKA1T4jXyBX0kT+HZfQVX+oeIXWwMhyAs3/jIXBA0rRl5df/erDwToudUm
         zPi8NTk6eCUd+2cxVKP6i/4Mjr6QA85zeSp4eqkLMry2KrwuQTFlYt0s5cOBCq8Aw3Eg
         6ikA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IlP+UqaTTH6S778JlrTl0GossJzFFQBlG/jMumY6xKg=;
        b=PGzPaAfZFlOeQHX/NC0tGUeTwcyO7RGi99yTYRb1eNP4AWgqu63Vhm+GuQv3lbLkph
         Z2gpn6yZR1sAhWp/GlTzeynuI2Bknpev5kDPXwkK4k8nfaLtCL8su43ncSR5956bBKjv
         TdXVFkTvzoDf+Qmdsb946MKWVNzabgN9aKdaL+Zx1/JaiOODu8kzONUyp/ddHkHDKpT4
         VegeK3dM5yVxRCLWHLWo4gZ18enRq/Tp90B+2+48DbHhK1NtMm/uVDEP3WP0T/aIEuIf
         vaRGMEJrR6mmimLwM+kD2EtsgRIHm+iKPze+viO1WnJANmQyrJRLFUm6ZVkK3e7Z2bl4
         28yw==
X-Gm-Message-State: AOAM531sGMfxMJcggRiXDlKsMqzxxuzmqWjUSk2AXt132OCR4KKqpu0N
        XDtsUyKZenocVdm4UkENJovcO9NeO05jIQ==
X-Google-Smtp-Source: ABdhPJzt3j/jSpIF5FDNrIEGk8aix6RpyugpCS9ngRugRC+2zmIkhMDolzJWu2IRrQWYFPZmlfzD9g==
X-Received: by 2002:a65:6107:: with SMTP id z7mr10290870pgu.435.1614524658971;
        Sun, 28 Feb 2021 07:04:18 -0800 (PST)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:0:561f:afde:af07:8820])
        by smtp.gmail.com with ESMTPSA id 142sm8391331pfz.196.2021.02.28.07.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 07:04:18 -0800 (PST)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
        vkuznets@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, sunilmut@microsoft.com
Subject: [RFC PATCH 9/12] x86/Hyper-V: Add new parameter for vmbus_sendpacket_pagebuffer()/mpb_desc()
Date:   Sun, 28 Feb 2021 10:03:12 -0500
Message-Id: <20210228150315.2552437-10-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210228150315.2552437-1-ltykernel@gmail.com>
References: <20210228150315.2552437-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Add new parameter io_type and struct bounce_pkt for vmbus_sendpacket_pagebuffer()
and vmbus_sendpacket_mpb_desc() in order to add bounce buffer support
later.

Signed-off-by: Sunil Muthuswamy <sunilmut@microsoft.com>
Co-Developed-by: Sunil Muthuswamy <sunilmut@microsoft.com>
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 drivers/hv/channel.c            |  7 +++++--
 drivers/hv/hyperv_vmbus.h       | 12 ++++++++++++
 drivers/net/hyperv/hyperv_net.h |  1 +
 drivers/net/hyperv/netvsc.c     |  5 ++++-
 drivers/scsi/storvsc_drv.c      | 23 +++++++++++++++++------
 include/linux/hyperv.h          | 16 ++++++++++++++--
 6 files changed, 53 insertions(+), 11 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 4c05b1488649..976ef99dda28 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -1044,7 +1044,8 @@ EXPORT_SYMBOL(vmbus_sendpacket);
 int vmbus_sendpacket_pagebuffer(struct vmbus_channel *channel,
 				struct hv_page_buffer pagebuffers[],
 				u32 pagecount, void *buffer, u32 bufferlen,
-				u64 requestid)
+				u64 requestid, u8 io_type,
+				struct hv_bounce_pkt **bounce_pkt)
 {
 	int i;
 	struct vmbus_channel_packet_page_buffer desc;
@@ -1101,7 +1102,9 @@ EXPORT_SYMBOL_GPL(vmbus_sendpacket_pagebuffer);
 int vmbus_sendpacket_mpb_desc(struct vmbus_channel *channel,
 			      struct vmbus_packet_mpb_array *desc,
 			      u32 desc_size,
-			      void *buffer, u32 bufferlen, u64 requestid)
+			      void *buffer, u32 bufferlen, u64 requestid,
+			      u32 pfn_count, u8 io_type,
+			      struct hv_bounce_pkt **bounce_pkt)
 {
 	u32 packetlen;
 	u32 packetlen_aligned;
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 7edf2be60d2c..7677f083d33a 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -57,6 +57,18 @@ union hv_monitor_trigger_state {
 	};
 };
 
+/*
+ * Hyper-V bounce packet. Each in-use bounce packet is mapped to a vmbus
+ * transaction and contains a list of bounce pages for that transaction.
+ */
+struct hv_bounce_pkt {
+	/* Link to the next bounce packet, when it is in the free list */
+	struct list_head link;
+	struct list_head bounce_page_head;
+	u32 flags;
+};
+
+
 /*
  * All vmbus channels initially start with zero bounce pages and are required
  * to set any non-zero size, if needed.
diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index b3a43c4ec8ab..11266b92bcf0 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -130,6 +130,7 @@ struct hv_netvsc_packet {
 	u32 total_bytes;
 	u32 send_buf_index;
 	u32 total_data_buflen;
+	struct hv_bounce_pkt *bounce_pkt;
 };
 
 #define NETVSC_HASH_KEYLEN 40
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 08d73401bb28..77657c5acc65 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -926,14 +926,17 @@ static inline int netvsc_send_pkt(
 
 	trace_nvsp_send_pkt(ndev, out_channel, rpkt);
 
+	packet->bounce_pkt = NULL;
 	if (packet->page_buf_cnt) {
 		if (packet->cp_partial)
 			pb += packet->rmsg_pgcnt;
 
+		/* The I/O type is always 'write' for netvsc */
 		ret = vmbus_sendpacket_pagebuffer(out_channel,
 						  pb, packet->page_buf_cnt,
 						  &nvmsg, sizeof(nvmsg),
-						  req_id);
+						  req_id, IO_TYPE_WRITE,
+						  &packet->bounce_pkt);
 	} else {
 		ret = vmbus_sendpacket(out_channel,
 				       &nvmsg, sizeof(nvmsg),
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 2e4fa77445fd..c5b4974eb41f 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -31,6 +31,7 @@
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_transport_fc.h>
 #include <scsi/scsi_transport.h>
+#include <asm/mshyperv.h>
 
 /*
  * All wire protocol details (storage protocol between the guest and the host)
@@ -427,6 +428,7 @@ struct storvsc_cmd_request {
 	u32 payload_sz;
 
 	struct vstor_packet vstor_packet;
+	struct hv_bounce_pkt *bounce_pkt;
 };
 
 
@@ -1390,7 +1392,8 @@ static struct vmbus_channel *get_og_chn(struct storvsc_device *stor_device,
 
 
 static int storvsc_do_io(struct hv_device *device,
-			 struct storvsc_cmd_request *request, u16 q_num)
+			 struct storvsc_cmd_request *request, u16 q_num,
+			 u32 pfn_count)
 {
 	struct storvsc_device *stor_device;
 	struct vstor_packet *vstor_packet;
@@ -1493,14 +1496,18 @@ static int storvsc_do_io(struct hv_device *device,
 
 	vstor_packet->operation = VSTOR_OPERATION_EXECUTE_SRB;
 
+	request->bounce_pkt = NULL;
 	if (request->payload->range.len) {
+		struct vmscsi_request *vm_srb = &request->vstor_packet.vm_srb;
 
 		ret = vmbus_sendpacket_mpb_desc(outgoing_channel,
 				request->payload, request->payload_sz,
 				vstor_packet,
 				(sizeof(struct vstor_packet) -
 				vmscsi_size_delta),
-				(unsigned long)request);
+				(unsigned long)request,
+				pfn_count,
+				vm_srb->data_in, &request->bounce_pkt);
 	} else {
 		ret = vmbus_sendpacket(outgoing_channel, vstor_packet,
 			       (sizeof(struct vstor_packet) -
@@ -1510,8 +1517,10 @@ static int storvsc_do_io(struct hv_device *device,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	}
 
-	if (ret != 0)
+	if (ret != 0) {
+		request->bounce_pkt = NULL;
 		return ret;
+	}
 
 	atomic_inc(&stor_device->num_outstanding_req);
 
@@ -1825,14 +1834,16 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	cmd_request->payload_sz = payload_sz;
 
 	/* Invokes the vsc to start an IO */
-	ret = storvsc_do_io(dev, cmd_request, get_cpu());
+	ret = storvsc_do_io(dev, cmd_request, get_cpu(), sg_count);
 	put_cpu();
 
-	if (ret == -EAGAIN) {
+	if (ret) {
 		if (payload_sz > sizeof(cmd_request->mpb))
 			kfree(payload);
 		/* no more space */
-		return SCSI_MLQUEUE_DEVICE_BUSY;
+		if (ret == -EAGAIN || ret == -ENOSPC)
+			return SCSI_MLQUEUE_DEVICE_BUSY;
+		return ret;
 	}
 
 	return 0;
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index d518aba17565..d1a936091665 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1184,19 +1184,31 @@ extern int vmbus_sendpacket(struct vmbus_channel *channel,
 				  enum vmbus_packet_type type,
 				  u32 flags);
 
+#define IO_TYPE_WRITE	0
+#define IO_TYPE_READ	1
+#define IO_TYPE_UNKNOWN 2
+
+struct hv_bounce_pkt;
+
 extern int vmbus_sendpacket_pagebuffer(struct vmbus_channel *channel,
 					    struct hv_page_buffer pagebuffers[],
 					    u32 pagecount,
 					    void *buffer,
 					    u32 bufferlen,
-					    u64 requestid);
+					    u64 requestid,
+					    u8 io_type,
+					    struct hv_bounce_pkt **bounce_pkt);
 
 extern int vmbus_sendpacket_mpb_desc(struct vmbus_channel *channel,
 				     struct vmbus_packet_mpb_array *mpb,
 				     u32 desc_size,
 				     void *buffer,
 				     u32 bufferlen,
-				     u64 requestid);
+				     u64 requestid,
+				     u32 pfn_count,
+				     u8 io_type,
+				     struct hv_bounce_pkt **bounce_pkt);
+
 
 extern int vmbus_establish_gpadl(struct vmbus_channel *channel,
 				      void *kbuffer,
-- 
2.25.1

