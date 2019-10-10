Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00F8ED2E1A
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 17:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbfJJPqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 11:46:25 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34267 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbfJJPqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 11:46:24 -0400
Received: by mail-wr1-f67.google.com with SMTP id j11so8533182wrp.1;
        Thu, 10 Oct 2019 08:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xZh1qCpJn2QAbOo99c0vzLdcWFHT9UIhmOuoKjFsElM=;
        b=YtPiXxpNXtM6Q/G5oAVZD14ilY+pO468GIuMqcUJGDkZUXbN4qczNJoSzBPjCTeCaq
         W3cPYbIYyohMC+tDEnU1QgfurNWVczGcPdYz6aPMvdENV/Wb4rh/wAC77SkEICzPTIMs
         3vpsYK0u828hPPJ6bvc0Q7/uIHLXhWX4w+4dk6utUqH4vimJbbjvp9C96TNwcqRktN38
         GeZyoCWkInlhIy1eU8icW0THvOsMv4bb5zLBzD8QRliOKPz+s6nTZDda4e4BpE6QAdN5
         ZfE+q4/LRUK7svPiBy7+8kNkz+kFtOCSazTj/tkIL4ZqF1z49zqrFGfH8DgKH9KUjwNi
         gv+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xZh1qCpJn2QAbOo99c0vzLdcWFHT9UIhmOuoKjFsElM=;
        b=G97mRvg98w5OvIQuia2RsPMlprRqAe5TczGioUHP5BEuvyBZuCWwfv8YhjBjZtClP0
         uo8GHo39yWcW2OfyJLE/ToAgKpiv20flsfqnVfG/VWKzJHfryTLi2ZKV6Jk0cHI7V+zI
         UVjnDJQ+86ry2FP1WuJrUHcndu2W9u1CwJ35CZ/W35MfMKaWsi+roMPmcMDbb1DaEjPX
         FB1dVyTSRGRJnQ/5gfP7JVmxtBhfUIQm7NFQ1x29yToE7Lt1fxozTB25ZlQkbU9TR1Xz
         XQqOCOzKd+9te9FLsZmXGIgETqCqgPk467A/CtBnbU/sUKN3o0Xbs9i/wWSY2kxVUnxn
         PmMg==
X-Gm-Message-State: APjAAAW087QvlajvoAnxWkMxYnpWIsNLADCQnWosNAWYLJ0VPv0Tcff9
        QFhXCV7g5bPiPOIGVweeH2583PjmU47omA==
X-Google-Smtp-Source: APXvYqx9QBPcDSbNhAOHt0gCqtSU8Ggd8rcZejI/j8DJ/I2POaX5N5r+n2V+JYzP+m+qqSv1UpPqhQ==
X-Received: by 2002:a5d:6949:: with SMTP id r9mr5928459wrw.106.1570722382383;
        Thu, 10 Oct 2019 08:46:22 -0700 (PDT)
Received: from andrea.corp.microsoft.com ([2a01:110:8012:1010:e9a3:da77:7120:dee0])
        by smtp.gmail.com with ESMTPSA id u25sm6719807wml.4.2019.10.10.08.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 08:46:21 -0700 (PDT)
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
Subject: [PATCH v2 1/3] Drivers: hv: vmbus: Introduce table of VMBus protocol versions
Date:   Thu, 10 Oct 2019 17:45:58 +0200
Message-Id: <20191010154600.23875-2-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010154600.23875-1-parri.andrea@gmail.com>
References: <20191010154600.23875-1-parri.andrea@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The technique used to get the next VMBus version seems increasisly
clumsy as the number of VMBus versions increases.  Performance is
not a concern since this is only done once during system boot; it's
just that we'll end up with more lines of code than is really needed.

As an alternative, introduce a table with the version numbers listed
in order (from the most recent to the oldest).  vmbus_connect() loops
through the versions listed in the table until it gets an accepted
connection or gets to the end of the table (invalid version).

Suggested-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
---
 drivers/hv/connection.c | 46 ++++++++++++++---------------------------
 drivers/hv/vmbus_drv.c  |  3 +--
 include/linux/hyperv.h  |  4 ----
 3 files changed, 17 insertions(+), 36 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 6e4c015783ffc..b1f805426e6b4 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -40,29 +40,17 @@ EXPORT_SYMBOL_GPL(vmbus_connection);
 __u32 vmbus_proto_version;
 EXPORT_SYMBOL_GPL(vmbus_proto_version);
 
-static __u32 vmbus_get_next_version(__u32 current_version)
-{
-	switch (current_version) {
-	case (VERSION_WIN7):
-		return VERSION_WS2008;
-
-	case (VERSION_WIN8):
-		return VERSION_WIN7;
-
-	case (VERSION_WIN8_1):
-		return VERSION_WIN8;
-
-	case (VERSION_WIN10):
-		return VERSION_WIN8_1;
-
-	case (VERSION_WIN10_V5):
-		return VERSION_WIN10;
-
-	case (VERSION_WS2008):
-	default:
-		return VERSION_INVAL;
-	}
-}
+/*
+ * Table of VMBus versions listed from newest to oldest.
+ */
+static __u32 vmbus_versions[] = {
+	VERSION_WIN10_V5,
+	VERSION_WIN10,
+	VERSION_WIN8_1,
+	VERSION_WIN8,
+	VERSION_WIN7,
+	VERSION_WS2008
+};
 
 int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo, u32 version)
 {
@@ -169,8 +157,8 @@ int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo, u32 version)
  */
 int vmbus_connect(void)
 {
-	int ret = 0;
 	struct vmbus_channel_msginfo *msginfo = NULL;
+	int i, ret = 0;
 	__u32 version;
 
 	/* Initialize the vmbus connection */
@@ -244,20 +232,18 @@ int vmbus_connect(void)
 	 * version.
 	 */
 
-	version = VERSION_CURRENT;
+	for (i = 0; i < ARRAY_SIZE(vmbus_versions); i++) {
+		version = vmbus_versions[i];
 
-	do {
 		ret = vmbus_negotiate_version(msginfo, version);
 		if (ret == -ETIMEDOUT)
 			goto cleanup;
 
 		if (vmbus_connection.conn_state == CONNECTED)
 			break;
+	}
 
-		version = vmbus_get_next_version(version);
-	} while (version != VERSION_INVAL);
-
-	if (version == VERSION_INVAL)
+	if (vmbus_connection.conn_state != CONNECTED)
 		goto cleanup;
 
 	vmbus_proto_version = version;
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 391f0b225c9ae..a0cd65ab9a950 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -2215,8 +2215,7 @@ static int vmbus_bus_resume(struct device *dev)
 	 * We only use the 'vmbus_proto_version', which was in use before
 	 * hibernation, to re-negotiate with the host.
 	 */
-	if (vmbus_proto_version == VERSION_INVAL ||
-	    vmbus_proto_version == 0) {
+	if (!vmbus_proto_version) {
 		pr_err("Invalid proto version = 0x%x\n", vmbus_proto_version);
 		return -EINVAL;
 	}
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index b4a017093b697..c08b62dbd151f 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -192,10 +192,6 @@ static inline u32 hv_get_avail_to_write_percent(
 #define VERSION_WIN10	((4 << 16) | (0))
 #define VERSION_WIN10_V5 ((5 << 16) | (0))
 
-#define VERSION_INVAL -1
-
-#define VERSION_CURRENT VERSION_WIN10_V5
-
 /* Make maximum size of pipe payload of 16K */
 #define MAX_PIPE_DATA_PAYLOAD		(sizeof(u8) * 16384)
 
-- 
2.23.0

