Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4DDF3272C8
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 16:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhB1PGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 10:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbhB1PFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 10:05:39 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C23AC0617A9;
        Sun, 28 Feb 2021 07:04:21 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id e9so6562920pjs.2;
        Sun, 28 Feb 2021 07:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8/x+hLQ6Qn9/Q906STHQruoSKlP5avG/u3tHWEaX0FM=;
        b=RFTVUV6tYZAmjZRY2rFgfYLVtz+E6R/jpo4P9wrRSQYVmXuv7bbdHXX5gx2WsW9dCt
         hU9zrzrjUJkTCHaZaLY6NdGgKn4H5bp3brYUZ8IpTCeq8OHgmlR1H4p6Wju0agRExtWi
         Jsrnya/FeeMuYtZb0HatALdChEwn0iI4COH5jPphCkLDVrzvezOmcWaioLxJABLFh7pM
         oR3EN8i+n3+ZBfcJSg6yrMQ5BqXZEsMnCfb4+CnQJbdpg2GLwTlzU0hdWW2TAUkjYnkO
         FP8tKNwEnpXtp33dHfGrEtVta0uLj4cmnRWEJz5VrVi83fV9XRWMapxEg45JQ7/wdI78
         g+lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8/x+hLQ6Qn9/Q906STHQruoSKlP5avG/u3tHWEaX0FM=;
        b=DUEPynholg2Le82zEsGJcrCO9XwgWyZ2kuqqy5MuFtj83mFkvkRFcvashmDU3Welol
         6b6Xl8pLGA/mop3VIQh+QyBc7352LHmkeE8bbPvM+T1UEIjKgFESjKrLaeqBVtZ5fOK7
         JtW7LYTAZ2Gu1TMsTkSuZ41wp6Lmwseo1sbzcw6qiN8XPFa8IdY9Up9VGEZMkcsA01l5
         db4nOepBOwwMQ0PMLYUL1TXZ2m28goluDHY/qSAw4ORHTN2jTd2lbVMrrVyI1hBdw0ij
         XivJ7/Sx8Bm4Tz+JJNcWaE95G0h4HweUqC+yBmTJzd2v6GfBr8RYLImp0kz1CE+H5vzi
         6CYA==
X-Gm-Message-State: AOAM532NM9oP5AKb2mRXlTRvOStmJWLv0XlPStENDcUP8IvBdyaUccIz
        zTW3tk8n79Lk9txxdOfO1Ds=
X-Google-Smtp-Source: ABdhPJwbnd69QV1i2bRwIq+NDb286ER4bmQYpVSIiuHfVU93sV0hMKrG7MiVfJKJF0263tFDFALA7Q==
X-Received: by 2002:a17:903:22d2:b029:e3:f6cf:9408 with SMTP id y18-20020a17090322d2b02900e3f6cf9408mr11576503plg.8.1614524660652;
        Sun, 28 Feb 2021 07:04:20 -0800 (PST)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:0:561f:afde:af07:8820])
        by smtp.gmail.com with ESMTPSA id 142sm8391331pfz.196.2021.02.28.07.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 07:04:20 -0800 (PST)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        sunilmut@microsoft.com
Subject: [RFC PATCH 11/12] HV/Netvsc: Add Isolation VM support for netvsc driver
Date:   Sun, 28 Feb 2021 10:03:14 -0500
Message-Id: <20210228150315.2552437-12-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210228150315.2552437-1-ltykernel@gmail.com>
References: <20210228150315.2552437-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Add Isolation VM support for netvsc driver. Map send/receive
ring buffer in extra address space in SNP isolation VM, reserve
bounce buffer for packets sent via vmbus_sendpacket_pagebuffer()
and release bounce buffer via hv_pkt_bounce() when get send
complete response from host.

Signed-off-by: Sunil Muthuswamy <sunilmut@microsoft.com>
Co-Developed-by: Sunil Muthuswamy <sunilmut@microsoft.com>
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 drivers/net/hyperv/hyperv_net.h |  3 +
 drivers/net/hyperv/netvsc.c     | 97 ++++++++++++++++++++++++++++++---
 2 files changed, 92 insertions(+), 8 deletions(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index 11266b92bcf0..45d5838ff128 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -1027,14 +1027,17 @@ struct netvsc_device {
 
 	/* Receive buffer allocated by us but manages by NetVSP */
 	void *recv_buf;
+	void *recv_original_buf;
 	u32 recv_buf_size; /* allocated bytes */
 	u32 recv_buf_gpadl_handle;
 	u32 recv_section_cnt;
 	u32 recv_section_size;
 	u32 recv_completion_cnt;
 
+
 	/* Send buffer allocated by us */
 	void *send_buf;
+	void *send_original_buf;
 	u32 send_buf_size;
 	u32 send_buf_gpadl_handle;
 	u32 send_section_cnt;
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 77657c5acc65..171af85e055d 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -26,7 +26,7 @@
 
 #include "hyperv_net.h"
 #include "netvsc_trace.h"
-
+#include "../../hv/hyperv_vmbus.h"
 /*
  * Switch the data path from the synthetic interface to the VF
  * interface.
@@ -119,8 +119,21 @@ static void free_netvsc_device(struct rcu_head *head)
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
@@ -241,13 +254,18 @@ static void netvsc_teardown_recv_gpadl(struct hv_device *device,
 				       struct netvsc_device *net_device,
 				       struct net_device *ndev)
 {
+	void *recv_buf;
 	int ret;
 
 	if (net_device->recv_buf_gpadl_handle) {
+		if (net_device->recv_original_buf)
+			recv_buf = net_device->recv_original_buf;
+		else
+			recv_buf = net_device->recv_buf;
+
 		ret = vmbus_teardown_gpadl(device->channel,
 					   net_device->recv_buf_gpadl_handle,
-					   net_device->recv_buf,
-					   net_device->recv_buf_size);
+					   recv_buf, net_device->recv_buf_size);
 
 		/* If we failed here, we might as well return and have a leak
 		 * rather than continue and a bugchk
@@ -265,13 +283,18 @@ static void netvsc_teardown_send_gpadl(struct hv_device *device,
 				       struct netvsc_device *net_device,
 				       struct net_device *ndev)
 {
+	void *send_buf;
 	int ret;
 
 	if (net_device->send_buf_gpadl_handle) {
+		if (net_device->send_original_buf)
+			send_buf = net_device->send_original_buf;
+		else
+			send_buf = net_device->send_buf;
+
 		ret = vmbus_teardown_gpadl(device->channel,
 					   net_device->send_buf_gpadl_handle,
-					   net_device->send_buf,
-					   net_device->send_buf_size);
+					   send_buf, net_device->send_buf_size);
 
 		/* If we failed here, we might as well return and have a leak
 		 * rather than continue and a bugchk
@@ -306,9 +329,19 @@ static int netvsc_init_buf(struct hv_device *device,
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
+
+	ret = hv_bounce_resources_reserve(device->channel,
+			PAGE_SIZE * 1024);
+	if (ret) {
+		pr_warn("Fail to reserve bounce buffer.\n");
+		return -ENOMEM;
+	}
 
 	/* Get receive buffer area. */
 	buf_size = device_info->recv_sections * device_info->recv_section_size;
@@ -345,6 +378,28 @@ static int netvsc_init_buf(struct hv_device *device,
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
+		net_device->recv_buf = (void*)vaddr;
+	}
+
+
 	/* Notify the NetVsp of the gpadl handle */
 	init_packet = &net_device->channel_init_pkt;
 	memset(init_packet, 0, sizeof(struct nvsp_message));
@@ -435,12 +490,36 @@ static int netvsc_init_buf(struct hv_device *device,
 				    buf_size,
 				    &net_device->send_buf_gpadl_handle,
 				    VMBUS_PAGE_VISIBLE_READ_WRITE);
+	
 	if (ret != 0) {
 		netdev_err(ndev,
 			   "unable to establish send buffer's gpadl\n");
 		goto cleanup;
 	}
 
+	if (hv_isolation_type_snp()) {
+		area = get_vm_area(buf_size , VM_IOREMAP);
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
+		net_device->send_buf = (void*)vaddr;	
+	}
+
+	
 	/* Notify the NetVsp of the gpadl handle */
 	init_packet = &net_device->channel_init_pkt;
 	memset(init_packet, 0, sizeof(struct nvsp_message));
@@ -747,6 +826,8 @@ static void netvsc_send_tx_complete(struct net_device *ndev,
 		tx_stats->bytes += packet->total_bytes;
 		u64_stats_update_end(&tx_stats->syncp);
 
+		if (desc->type == VM_PKT_COMP && packet->bounce_pkt)
+			hv_pkt_bounce(channel, packet->bounce_pkt);
 		napi_consume_skb(skb, budget);
 	}
 
-- 
2.25.1

