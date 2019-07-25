Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B91A5744C1
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 07:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390456AbfGYFL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 01:11:57 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33823 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390362AbfGYFL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 01:11:56 -0400
Received: by mail-qk1-f194.google.com with SMTP id t8so35544521qkt.1;
        Wed, 24 Jul 2019 22:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=qXMolS9bi6Wza6wvHtLWXxXOh2ThsYL/tKKpIPkYlnY=;
        b=j77QlnQBhDzQa7ggtdsAkn6iRGcUqjJ+yVNMwrZNTJVQO43sCpBSeHKw2e3FO3AGU8
         oNX7Vm11+oypNa2jjstEX22YWbEfaLsAopIyb/BrhPxVqbCajikwGRcn9qupyj+K4L28
         9UuNLJMBlXYS9x2LIYO2cL1kNCBjPBM02U1DtPBhOitKuoy3OMHVawth0XlfyrJW5O5Y
         SmkdwmWuXcLgngy9OTd+cNjIV3KV9OFrcvdUWuaPbV+22jj771SdSpNqGR5GdQcM6bJu
         1o9MUdYtHN0FI9M2qP8e5kdPudjkbyTobxm4H0l7NXD22fqWqPskAhqF6jT8bmhBmfHc
         e3Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qXMolS9bi6Wza6wvHtLWXxXOh2ThsYL/tKKpIPkYlnY=;
        b=FKbnrYaPISYm6G6aD+NMlqb7iDUH9skZ914txmp9T2OtamZc4sIbswKYonfrOVr9vK
         fOX5ogEk+Y5e7gq3XG8l2eRIVPvsSJoDCn3tvw33cFGH/YeTDqJ/2Qos7Fs9/I1LeR/p
         CphHA1KFqxFS2HWxzbECCveuAwl6uWS/cl73c/cAh1LbU6mRf/Mw2HZP7b4MPHrWhrBz
         lCC8q6cTZykk2q3BN9a9wSmGwq1xKrf867ZOOli3c50IJTiSOs7fN31jc4iueFpoHY4Y
         YLIxZkAdJGTQSiIDmf2qHgBI9+19SmSsk5w5YDpIWQSawHwv2mIu7Rq0pbc0wnWwD/aY
         HxLg==
X-Gm-Message-State: APjAAAXtNXukucogOfZBNCMq8Q82IyGE0y8P0hUhVPB3LmCeH+mcPV4z
        HJ1d2jGoXyKsrff4DT7Ti3s=
X-Google-Smtp-Source: APXvYqxuEiqi2anKU0KbYoV5cw1U3bHSXHVGdLI0p26Ch6MD+vpL9CtLOI0QeYdINaqTZrs7Fdprtg==
X-Received: by 2002:a37:ef03:: with SMTP id j3mr10232314qkk.233.1564031515675;
        Wed, 24 Jul 2019 22:11:55 -0700 (PDT)
Received: from AzureHyper-V.3xjlci4r0w3u5g13o212qxlisd.bx.internal.cloudapp.net ([13.68.195.119])
        by smtp.gmail.com with ESMTPSA id j61sm21664353qte.47.2019.07.24.22.11.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 22:11:54 -0700 (PDT)
From:   Himadri Pandya <himadrispandya@gmail.com>
X-Google-Original-From: Himadri Pandya <himadri18.07@gmail.com>
To:     mikelley@microsoft.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, davem@davemloft.net
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Himadri Pandya <himadri18.07@gmail.com>
Subject: [PATCH] hv_sock: use HV_HYP_PAGE_SIZE instead of PAGE_SIZE_4K
Date:   Thu, 25 Jul 2019 05:11:25 +0000
Message-Id: <20190725051125.10605-1-himadri18.07@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Older windows hosts require the hv_sock ring buffer to be defined
using 4K pages. This was achieved by using the symbol PAGE_SIZE_4K
defined specifically for this purpose. But now we have a new symbol
HV_HYP_PAGE_SIZE defined in hyperv-tlfs which can be used for this.

This patch removes the definition of symbol PAGE_SIZE_4K and replaces
its usage with the symbol HV_HYP_PAGE_SIZE. This patch also aligns
sndbuf and rcvbuf to hyper-v specific page size using HV_HYP_PAGE_SIZE
instead of the guest page size(PAGE_SIZE) as hyper-v expects the page
size to be 4K and it might not be the case on ARM64 architecture.

Signed-off-by: Himadri Pandya <himadri18.07@gmail.com>
---
 net/vmw_vsock/hyperv_transport.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index f2084e3f7aa4..ecb5d72d8010 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -13,15 +13,16 @@
 #include <linux/hyperv.h>
 #include <net/sock.h>
 #include <net/af_vsock.h>
+#include <asm/hyperv-tlfs.h>
 
 /* Older (VMBUS version 'VERSION_WIN10' or before) Windows hosts have some
- * stricter requirements on the hv_sock ring buffer size of six 4K pages. Newer
- * hosts don't have this limitation; but, keep the defaults the same for compat.
+ * stricter requirements on the hv_sock ring buffer size of six 4K pages.
+ * hyperv-tlfs defines HV_HYP_PAGE_SIZE as 4K. Newer hosts don't have this
+ * limitation; but, keep the defaults the same for compat.
  */
-#define PAGE_SIZE_4K		4096
-#define RINGBUFFER_HVS_RCV_SIZE (PAGE_SIZE_4K * 6)
-#define RINGBUFFER_HVS_SND_SIZE (PAGE_SIZE_4K * 6)
-#define RINGBUFFER_HVS_MAX_SIZE (PAGE_SIZE_4K * 64)
+#define RINGBUFFER_HVS_RCV_SIZE (HV_HYP_PAGE_SIZE * 6)
+#define RINGBUFFER_HVS_SND_SIZE (HV_HYP_PAGE_SIZE * 6)
+#define RINGBUFFER_HVS_MAX_SIZE (HV_HYP_PAGE_SIZE * 64)
 
 /* The MTU is 16KB per the host side's design */
 #define HVS_MTU_SIZE		(1024 * 16)
@@ -54,7 +55,7 @@ struct hvs_recv_buf {
  * ringbuffer APIs that allow us to directly copy data from userspace buffer
  * to VMBus ringbuffer.
  */
-#define HVS_SEND_BUF_SIZE (PAGE_SIZE_4K - sizeof(struct vmpipe_proto_header))
+#define HVS_SEND_BUF_SIZE (HV_HYP_PAGE_SIZE - sizeof(struct vmpipe_proto_header))
 
 struct hvs_send_buf {
 	/* The header before the payload data */
@@ -388,10 +389,10 @@ static void hvs_open_connection(struct vmbus_channel *chan)
 	} else {
 		sndbuf = max_t(int, sk->sk_sndbuf, RINGBUFFER_HVS_SND_SIZE);
 		sndbuf = min_t(int, sndbuf, RINGBUFFER_HVS_MAX_SIZE);
-		sndbuf = ALIGN(sndbuf, PAGE_SIZE);
+		sndbuf = ALIGN(sndbuf, HV_HYP_PAGE_SIZE);
 		rcvbuf = max_t(int, sk->sk_rcvbuf, RINGBUFFER_HVS_RCV_SIZE);
 		rcvbuf = min_t(int, rcvbuf, RINGBUFFER_HVS_MAX_SIZE);
-		rcvbuf = ALIGN(rcvbuf, PAGE_SIZE);
+		rcvbuf = ALIGN(rcvbuf, HV_HYP_PAGE_SIZE);
 	}
 
 	ret = vmbus_open(chan, sndbuf, rcvbuf, NULL, 0, hvs_channel_cb,
@@ -662,7 +663,7 @@ static ssize_t hvs_stream_enqueue(struct vsock_sock *vsk, struct msghdr *msg,
 	ssize_t ret = 0;
 	ssize_t bytes_written = 0;
 
-	BUILD_BUG_ON(sizeof(*send_buf) != PAGE_SIZE_4K);
+	BUILD_BUG_ON(sizeof(*send_buf) != HV_HYP_PAGE_SIZE);
 
 	send_buf = kmalloc(sizeof(*send_buf), GFP_KERNEL);
 	if (!send_buf)
-- 
2.17.1

