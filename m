Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF181D2E1E
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 17:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbfJJPq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 11:46:29 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38172 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbfJJPq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 11:46:28 -0400
Received: by mail-wm1-f67.google.com with SMTP id 3so7319777wmi.3;
        Thu, 10 Oct 2019 08:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=17J60DRPCCD/mscGumczbqePJySiGDleLy32mtKTZS0=;
        b=OM1x4l2UapbgXwCF8NSwkz0gf73MQGHv1t0KJ0bM3iud43s95AA5O6B0Dic9/IkYp8
         +gb4lB8K36sLt/+7dCtvJahP+KGT/jdldnJY7lZbvp7IkKVR04a7kmQP9YK5rxnmq6A5
         FwzMSULZWP+YgGqMt+2KNGN50UVjrAgKz2iJHaPzEMe1uylZ8/ikc2fvNo5IAFOSBtRo
         aLuAFhud1oMHX+oYpnSqosYbLzmLcaMX8359ZAYjT0QmwYl5EdHqQJ1tsXLajJ9S8GDX
         5L/Wb+KEn0maHenk7mFsqfbTFMcQi0ZcioY1n5ITRtYH80Xid8LXLb92i7M/gW2RoK1s
         lehw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=17J60DRPCCD/mscGumczbqePJySiGDleLy32mtKTZS0=;
        b=DX3W9pW1jgg5sqNwnBiThYzI7oVsRuf+6RkoaVlZXk0bXYYu7Oi/kby0O2fI5TpPFB
         Ad4I2voqYoMtwoiOc6c2TYHnbDelt8Fj5ky1LIkRd9D3EI+2LRxouko6HyKsE/NpcPBZ
         47nrQ2F+cwx7e/fd/kxRQydYoANh0gzaOtycCjzxkg8e6WlWp+YhMR0W3JVirW8XFo1+
         3TN8YdnA+xsbV7gkOzqS/BZLBCYxNdI4J9cnusNxIGAPlotDuR0R0F2MW+nBJrQz/imF
         dIMmlvSSwyV2SHp23yhVsWVHBlwbcq8F67mMaK+FOGqerul+UorYHNkgm3IefD51fPCh
         NeDw==
X-Gm-Message-State: APjAAAXm5pYnuBDwftH6APwUY+812j/RrGy+I1VSUwHtW0q8ko4EsUR6
        j17eWLcpNhWZTpPkn+7UkhTRlueg0VtGag==
X-Google-Smtp-Source: APXvYqys2H39JcVqx5mSZEGe323hH5d2rRgfm28DVW2g4OLJlcze1O/IiwXVyS72a8t0UC4KDGg2yQ==
X-Received: by 2002:a1c:39d7:: with SMTP id g206mr8406283wma.7.1570722384365;
        Thu, 10 Oct 2019 08:46:24 -0700 (PDT)
Received: from andrea.corp.microsoft.com ([2a01:110:8012:1010:e9a3:da77:7120:dee0])
        by smtp.gmail.com with ESMTPSA id u25sm6719807wml.4.2019.10.10.08.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 08:46:23 -0700 (PDT)
From:   Andrea Parri <parri.andrea@gmail.com>
To:     linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Michael Kelley <mikelley@microsoft.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Dexuan Cui <decui@microsoft.com>,
        Andrea Parri <parri.andrea@gmail.com>
Subject: [PATCH v2 2/3] Drivers: hv: vmbus: Enable VMBus protocol versions 4.1, 5.1 and 5.2
Date:   Thu, 10 Oct 2019 17:45:59 +0200
Message-Id: <20191010154600.23875-3-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010154600.23875-1-parri.andrea@gmail.com>
References: <20191010154600.23875-1-parri.andrea@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hyper-V has added VMBus protocol versions 5.1 and 5.2 in recent release
versions.  Allow Linux guests to negotiate these new protocol versions
on versions of Hyper-V that support them.  While on this, also allow
guests to negotiate the VMBus protocol version 4.1 (which was missing).

Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
---
 drivers/hv/connection.c          | 15 +++++++++------
 drivers/net/hyperv/netvsc.c      |  6 +++---
 include/linux/hyperv.h           |  8 +++++++-
 net/vmw_vsock/hyperv_transport.c |  4 ++--
 4 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index b1f805426e6b4..2f6961ac8c996 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -44,8 +44,11 @@ EXPORT_SYMBOL_GPL(vmbus_proto_version);
  * Table of VMBus versions listed from newest to oldest.
  */
 static __u32 vmbus_versions[] = {
+	VERSION_WIN10_V5_2,
+	VERSION_WIN10_V5_1,
 	VERSION_WIN10_V5,
-	VERSION_WIN10,
+	VERSION_WIN10_V4_1,
+	VERSION_WIN10_V4,
 	VERSION_WIN8_1,
 	VERSION_WIN8,
 	VERSION_WIN7,
@@ -68,12 +71,12 @@ int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo, u32 version)
 	msg->vmbus_version_requested = version;
 
 	/*
-	 * VMBus protocol 5.0 (VERSION_WIN10_V5) requires that we must use
-	 * VMBUS_MESSAGE_CONNECTION_ID_4 for the Initiate Contact Message,
+	 * VMBus protocol 5.0 (VERSION_WIN10_V5) and higher require that we must
+	 * use VMBUS_MESSAGE_CONNECTION_ID_4 for the Initiate Contact Message,
 	 * and for subsequent messages, we must use the Message Connection ID
 	 * field in the host-returned Version Response Message. And, with
-	 * VERSION_WIN10_V5, we don't use msg->interrupt_page, but we tell
-	 * the host explicitly that we still use VMBUS_MESSAGE_SINT(2) for
+	 * VERSION_WIN10_V5 and higher, we don't use msg->interrupt_page, but we
+	 * tell the host explicitly that we still use VMBUS_MESSAGE_SINT(2) for
 	 * compatibility.
 	 *
 	 * On old hosts, we should always use VMBUS_MESSAGE_CONNECTION_ID (1).
@@ -399,7 +402,7 @@ int vmbus_post_msg(void *buffer, size_t buflen, bool can_sleep)
 		case HV_STATUS_INVALID_CONNECTION_ID:
 			/*
 			 * See vmbus_negotiate_version(): VMBus protocol 5.0
-			 * requires that we must use
+			 * and higher require that we must use
 			 * VMBUS_MESSAGE_CONNECTION_ID_4 for the Initiate
 			 * Contact message, but on old hosts that only
 			 * support VMBus protocol 4.0 or lower, here we get
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index d22a36fc7a7c6..d4c1a776b314a 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -624,11 +624,11 @@ void netvsc_device_remove(struct hv_device *device)
 	 * receive buffer GPADL. Do the same for send buffer.
 	 */
 	netvsc_revoke_recv_buf(device, net_device, ndev);
-	if (vmbus_proto_version < VERSION_WIN10)
+	if (vmbus_proto_version < VERSION_WIN10_V4)
 		netvsc_teardown_recv_gpadl(device, net_device, ndev);
 
 	netvsc_revoke_send_buf(device, net_device, ndev);
-	if (vmbus_proto_version < VERSION_WIN10)
+	if (vmbus_proto_version < VERSION_WIN10_V4)
 		netvsc_teardown_send_gpadl(device, net_device, ndev);
 
 	RCU_INIT_POINTER(net_device_ctx->nvdev, NULL);
@@ -650,7 +650,7 @@ void netvsc_device_remove(struct hv_device *device)
 	 * If host is Win2016 or higher then we do the GPADL tear down
 	 * here after VMBus is closed.
 	*/
-	if (vmbus_proto_version >= VERSION_WIN10) {
+	if (vmbus_proto_version >= VERSION_WIN10_V4) {
 		netvsc_teardown_recv_gpadl(device, net_device, ndev);
 		netvsc_teardown_send_gpadl(device, net_device, ndev);
 	}
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index c08b62dbd151f..a4f80e30b0207 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -182,15 +182,21 @@ static inline u32 hv_get_avail_to_write_percent(
  * 2 . 4  (Windows 8)
  * 3 . 0  (Windows 8 R2)
  * 4 . 0  (Windows 10)
+ * 4 . 1  (Windows 10 RS3)
  * 5 . 0  (Newer Windows 10)
+ * 5 . 1  (Windows 10 RS4)
+ * 5 . 2  (Windows Server 2019, RS5)
  */
 
 #define VERSION_WS2008  ((0 << 16) | (13))
 #define VERSION_WIN7    ((1 << 16) | (1))
 #define VERSION_WIN8    ((2 << 16) | (4))
 #define VERSION_WIN8_1    ((3 << 16) | (0))
-#define VERSION_WIN10	((4 << 16) | (0))
+#define VERSION_WIN10_V4 ((4 << 16) | (0))
+#define VERSION_WIN10_V4_1 ((4 << 16) | (1))
 #define VERSION_WIN10_V5 ((5 << 16) | (0))
+#define VERSION_WIN10_V5_1 ((5 << 16) | (1))
+#define VERSION_WIN10_V5_2 ((5 << 16) | (2))
 
 /* Make maximum size of pipe payload of 16K */
 #define MAX_PIPE_DATA_PAYLOAD		(sizeof(u8) * 16384)
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index c443db7af8d4a..cb0dbae4de14a 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -14,7 +14,7 @@
 #include <net/sock.h>
 #include <net/af_vsock.h>
 
-/* Older (VMBUS version 'VERSION_WIN10' or before) Windows hosts have some
+/* Older (VMBUS version 'VERSION_WIN10_V4' or before) Windows hosts have some
  * stricter requirements on the hv_sock ring buffer size of six 4K pages. Newer
  * hosts don't have this limitation; but, keep the defaults the same for compat.
  */
@@ -955,7 +955,7 @@ static int __init hvs_init(void)
 {
 	int ret;
 
-	if (vmbus_proto_version < VERSION_WIN10)
+	if (vmbus_proto_version < VERSION_WIN10_V4)
 		return -ENODEV;
 
 	ret = vmbus_driver_register(&hvs_drv);
-- 
2.23.0

