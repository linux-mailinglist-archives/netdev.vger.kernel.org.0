Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA1973272B4
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 16:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhB1PE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 10:04:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbhB1PEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 10:04:53 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168A2C061756;
        Sun, 28 Feb 2021 07:04:13 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id z7so8243847plk.7;
        Sun, 28 Feb 2021 07:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MqxUHxHYo8+c1jYpL0L/dr5SR36XdEsRZ+oLrFj9d94=;
        b=R4eMTeyo0ic2t0JxgzfoCsZippm5DdR632ssqn04mpQStF/jtaI+bYwRaB/nJ33Opj
         mfO3AfHeKLW9UFSGLp33DaHcOjitQHihjKiksFdzmfUk5cvBMPD0zHFCjmeGCb5bsLG1
         siwNNUA3xBXndbWP6Op7A3VEURlHN1s/hbtHXH43is7U7R+lXYcail/S1EiEJ/mjEy6B
         edxFJA5BZIuHfXfiFVchp1fkxd7MMtuHvslPTchKWzauKNBiwWzkorQZXJp4iQoFNcKz
         ceJos9/2tjT1fUvaPXZgjNoxaLCS3l58UjVwRQIT5GhFYitgj7nkliDysqQvP/dse9cY
         fzow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MqxUHxHYo8+c1jYpL0L/dr5SR36XdEsRZ+oLrFj9d94=;
        b=rqnEUDSvScVjtrASxi2wwHcIl8nh0IQVgIyg+n27TmTQ86kvN7HGo81PvDpIUwi93r
         GK68ib8c5VjmRKSwdESLrvQJk27mrBx4g3jeXPM6tROP5aIVZVJ0U3lQIQGh1FXeZbtG
         qhiTr9uZIE14CNtbtBCYV2hpvUz4zqW8VLH9SuMyuzkB1iqEwAkvyzPkSfpXs0lNb+jX
         VCi5NN9TMS/gpDdN43PG/CvBG+2RazT6fIpQ6CQLlrw+BD5QUdRndm5i27vFAWI/zCIH
         oTpC6tlZV+hORFPlwWTbC+/xZKXrvP9cBQhFDPzjLeOOhDd6vyVN9t9SfSNhwYzG8HXh
         wQNA==
X-Gm-Message-State: AOAM530AiLpuXUfn36WROB+kVKswsMWidxpQvyD6VoL334fi2s4SHu/J
        VeYBQ5EJYuUGpkN9sJ3vQ4YiqdEbVQVMXA==
X-Google-Smtp-Source: ABdhPJzCEJC6JXx0EENDqxZeKuB3gtuSR5ouT4RMMypteX5DkJE+5KD/22D5GDlkJ4t3WLz+AoKOaQ==
X-Received: by 2002:a17:90a:ce92:: with SMTP id g18mr6579833pju.52.1614524652573;
        Sun, 28 Feb 2021 07:04:12 -0800 (PST)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:0:561f:afde:af07:8820])
        by smtp.gmail.com with ESMTPSA id 142sm8391331pfz.196.2021.02.28.07.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 07:04:12 -0800 (PST)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, davem@davemloft.net,
        kuba@kernel.org, gregkh@linuxfoundation.org
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        sunilmut@microsoft.com
Subject: [RFC PATCH 1/12] x86/Hyper-V: Add visibility parameter for vmbus_establish_gpadl()
Date:   Sun, 28 Feb 2021 10:03:04 -0500
Message-Id: <20210228150315.2552437-2-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210228150315.2552437-1-ltykernel@gmail.com>
References: <20210228150315.2552437-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Add visibility parameter for vmbus_establish_gpadl() and prepare
to change host visibility when create gpadl for buffer.

Signed-off-by: Sunil Muthuswamy <sunilmut@microsoft.com>
Co-Developed-by: Sunil Muthuswamy <sunilmut@microsoft.com>
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 arch/x86/include/asm/hyperv-tlfs.h |  9 +++++++++
 drivers/hv/channel.c               | 20 +++++++++++---------
 drivers/net/hyperv/netvsc.c        |  8 ++++++--
 drivers/uio/uio_hv_generic.c       |  7 +++++--
 include/linux/hyperv.h             |  3 ++-
 5 files changed, 33 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index e6cd3fee562b..fb1893a4c32b 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -236,6 +236,15 @@ enum hv_isolation_type {
 /* TSC invariant control */
 #define HV_X64_MSR_TSC_INVARIANT_CONTROL	0x40000118
 
+/* Hyper-V GPA map flags */
+#define HV_MAP_GPA_PERMISSIONS_NONE		0x0
+#define HV_MAP_GPA_READABLE			0x1
+#define HV_MAP_GPA_WRITABLE			0x2
+
+#define VMBUS_PAGE_VISIBLE_READ_ONLY HV_MAP_GPA_READABLE
+#define VMBUS_PAGE_VISIBLE_READ_WRITE (HV_MAP_GPA_READABLE|HV_MAP_GPA_WRITABLE)
+#define VMBUS_PAGE_NOT_VISIBLE HV_MAP_GPA_PERMISSIONS_NONE
+
 /*
  * Declare the MSR used to setup pages used to communicate with the hypervisor.
  */
diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 0bd202de7960..daa21cc72beb 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -242,7 +242,7 @@ EXPORT_SYMBOL_GPL(vmbus_send_modifychannel);
  */
 static int create_gpadl_header(enum hv_gpadl_type type, void *kbuffer,
 			       u32 size, u32 send_offset,
-			       struct vmbus_channel_msginfo **msginfo)
+			       struct vmbus_channel_msginfo **msginfo, u32 visibility)
 {
 	int i;
 	int pagecount;
@@ -391,7 +391,7 @@ static int create_gpadl_header(enum hv_gpadl_type type, void *kbuffer,
 static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
 				   enum hv_gpadl_type type, void *kbuffer,
 				   u32 size, u32 send_offset,
-				   u32 *gpadl_handle)
+				   u32 *gpadl_handle, u32 visibility)
 {
 	struct vmbus_channel_gpadl_header *gpadlmsg;
 	struct vmbus_channel_gpadl_body *gpadl_body;
@@ -405,7 +405,8 @@ static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
 	next_gpadl_handle =
 		(atomic_inc_return(&vmbus_connection.next_gpadl_handle) - 1);
 
-	ret = create_gpadl_header(type, kbuffer, size, send_offset, &msginfo);
+	ret = create_gpadl_header(type, kbuffer, size, send_offset,
+				  &msginfo, visibility);
 	if (ret)
 		return ret;
 
@@ -496,10 +497,10 @@ static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
  * @gpadl_handle: some funky thing
  */
 int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
-			  u32 size, u32 *gpadl_handle)
+			  u32 size, u32 *gpadl_handle, u32 visibility)
 {
 	return __vmbus_establish_gpadl(channel, HV_GPADL_BUFFER, kbuffer, size,
-				       0U, gpadl_handle);
+				       0U, gpadl_handle, visibility);
 }
 EXPORT_SYMBOL_GPL(vmbus_establish_gpadl);
 
@@ -610,10 +611,11 @@ static int __vmbus_open(struct vmbus_channel *newchannel,
 	newchannel->ringbuffer_gpadlhandle = 0;
 
 	err = __vmbus_establish_gpadl(newchannel, HV_GPADL_RING,
-				      page_address(newchannel->ringbuffer_page),
-				      (send_pages + recv_pages) << PAGE_SHIFT,
-				      newchannel->ringbuffer_send_offset << PAGE_SHIFT,
-				      &newchannel->ringbuffer_gpadlhandle);
+			page_address(newchannel->ringbuffer_page),
+			(send_pages + recv_pages) << PAGE_SHIFT,
+			newchannel->ringbuffer_send_offset << PAGE_SHIFT,
+			&newchannel->ringbuffer_gpadlhandle,
+			VMBUS_PAGE_VISIBLE_READ_WRITE);
 	if (err)
 		goto error_clean_ring;
 
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 2353623259f3..bb72c7578330 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -333,7 +333,8 @@ static int netvsc_init_buf(struct hv_device *device,
 	 */
 	ret = vmbus_establish_gpadl(device->channel, net_device->recv_buf,
 				    buf_size,
-				    &net_device->recv_buf_gpadl_handle);
+				    &net_device->recv_buf_gpadl_handle,
+				    VMBUS_PAGE_VISIBLE_READ_WRITE);
 	if (ret != 0) {
 		netdev_err(ndev,
 			"unable to establish receive buffer's gpadl\n");
@@ -422,10 +423,13 @@ static int netvsc_init_buf(struct hv_device *device,
 	/* Establish the gpadl handle for this buffer on this
 	 * channel.  Note: This call uses the vmbus connection rather
 	 * than the channel to establish the gpadl handle.
+	 * Send buffer should theoretically be only marked as "read-only", but
+	 * the netvsp for some reason needs write capabilities on it.
 	 */
 	ret = vmbus_establish_gpadl(device->channel, net_device->send_buf,
 				    buf_size,
-				    &net_device->send_buf_gpadl_handle);
+				    &net_device->send_buf_gpadl_handle,
+				    VMBUS_PAGE_VISIBLE_READ_WRITE);
 	if (ret != 0) {
 		netdev_err(ndev,
 			   "unable to establish send buffer's gpadl\n");
diff --git a/drivers/uio/uio_hv_generic.c b/drivers/uio/uio_hv_generic.c
index 0330ba99730e..813a7bee5139 100644
--- a/drivers/uio/uio_hv_generic.c
+++ b/drivers/uio/uio_hv_generic.c
@@ -29,6 +29,7 @@
 #include <linux/hyperv.h>
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
+#include <asm/mshyperv.h>
 
 #include "../hv/hyperv_vmbus.h"
 
@@ -295,7 +296,8 @@ hv_uio_probe(struct hv_device *dev,
 	}
 
 	ret = vmbus_establish_gpadl(channel, pdata->recv_buf,
-				    RECV_BUFFER_SIZE, &pdata->recv_gpadl);
+				    RECV_BUFFER_SIZE, &pdata->recv_gpadl,
+				    VMBUS_PAGE_VISIBLE_READ_WRITE);
 	if (ret)
 		goto fail_close;
 
@@ -315,7 +317,8 @@ hv_uio_probe(struct hv_device *dev,
 	}
 
 	ret = vmbus_establish_gpadl(channel, pdata->send_buf,
-				    SEND_BUFFER_SIZE, &pdata->send_gpadl);
+				    SEND_BUFFER_SIZE, &pdata->send_gpadl,
+				    VMBUS_PAGE_VISIBLE_READ_ONLY);
 	if (ret)
 		goto fail_close;
 
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index f1d74dcf0353..016fdca20d6e 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1179,7 +1179,8 @@ extern int vmbus_sendpacket_mpb_desc(struct vmbus_channel *channel,
 extern int vmbus_establish_gpadl(struct vmbus_channel *channel,
 				      void *kbuffer,
 				      u32 size,
-				      u32 *gpadl_handle);
+				      u32 *gpadl_handle,
+				      u32 visibility);
 
 extern int vmbus_teardown_gpadl(struct vmbus_channel *channel,
 				     u32 gpadl_handle);
-- 
2.25.1

