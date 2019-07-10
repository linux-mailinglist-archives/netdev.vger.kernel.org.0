Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35C1B64299
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 09:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbfGJHZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 03:25:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbfGJHZG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 03:25:06 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CAD22064A;
        Wed, 10 Jul 2019 07:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562743506;
        bh=n4BD9+n2zqi7ZZm1PrYktHUNjck3LFK+AH3YqWy67Y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gDOEWGoNLkraHODHRo8XLVMWrm9UjqUgQooSeW27uCoOMt0Dfz0AKbWRUvWCqFw5A
         GQ+yFAJAFKz8lWZvdB/xjGqrYdrW5WgYN+iKv1MaA99P7zVeSZ21SB945DVNEag35K
         71Ri4Jup8E079XWrYUYtlCNk7dM8hD+dk5i+ILQI=
From:   Leon Romanovsky <leon@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Mark Zhang <markz@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH iproute2-rc 1/8] rdma: Update uapi headers to add statistic counter support
Date:   Wed, 10 Jul 2019 10:24:48 +0300
Message-Id: <20190710072455.9125-2-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190710072455.9125-1-leon@kernel.org>
References: <20190710072455.9125-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

Update rdma_netlink.h to kernel commit 6e7be47a5345 ("RDMA/nldev:
Allow get default counter statistics through RDMA netlink").

Signed-off-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/include/uapi/rdma/rdma_netlink.h | 82 +++++++++++++++++++++++++--
 1 file changed, 78 insertions(+), 4 deletions(-)

diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
index 41cfa84c..d42d6fb2 100644
--- a/rdma/include/uapi/rdma/rdma_netlink.h
+++ b/rdma/include/uapi/rdma/rdma_netlink.h
@@ -147,6 +147,18 @@ enum {
 	IWPM_NLA_HELLO_MAX
 };
 
+/* For RDMA_NLDEV_ATTR_DEV_NODE_TYPE */
+enum {
+	/* IB values map to NodeInfo:NodeType. */
+	RDMA_NODE_IB_CA = 1,
+	RDMA_NODE_IB_SWITCH,
+	RDMA_NODE_IB_ROUTER,
+	RDMA_NODE_RNIC,
+	RDMA_NODE_USNIC,
+	RDMA_NODE_USNIC_UDP,
+	RDMA_NODE_UNSPECIFIED,
+};
+
 /*
  * Local service operations:
  *   RESOLVE - The client requests the local service to resolve a path.
@@ -267,11 +279,15 @@ enum rdma_nldev_command {
 
 	RDMA_NLDEV_CMD_RES_PD_GET, /* can dump */
 
-	RDMA_NLDEV_NUM_OPS
-};
+	RDMA_NLDEV_CMD_GET_CHARDEV,
 
-enum {
-	RDMA_NLDEV_ATTR_ENTRY_STRLEN = 16,
+	RDMA_NLDEV_CMD_STAT_SET,
+
+	RDMA_NLDEV_CMD_STAT_GET, /* can dump */
+
+	RDMA_NLDEV_CMD_STAT_DEL,
+
+	RDMA_NLDEV_NUM_OPS
 };
 
 enum rdma_nldev_print_type {
@@ -478,10 +494,68 @@ enum rdma_nldev_attr {
 	 * File descriptor handle of the net namespace object
 	 */
 	RDMA_NLDEV_NET_NS_FD,			/* u32 */
+	/*
+	 * Information about a chardev.
+	 * CHARDEV_TYPE is the name of the chardev ABI (ie uverbs, umad, etc)
+	 * CHARDEV_ABI signals the ABI revision (historical)
+	 * CHARDEV_NAME is the kernel name for the /dev/ file (no directory)
+	 * CHARDEV is the 64 bit dev_t for the inode
+	 */
+	RDMA_NLDEV_ATTR_CHARDEV_TYPE,		/* string */
+	RDMA_NLDEV_ATTR_CHARDEV_NAME,		/* string */
+	RDMA_NLDEV_ATTR_CHARDEV_ABI,		/* u64 */
+	RDMA_NLDEV_ATTR_CHARDEV,		/* u64 */
+	RDMA_NLDEV_ATTR_UVERBS_DRIVER_ID,       /* u64 */
+	/*
+	 * Counter-specific attributes.
+	 */
+	RDMA_NLDEV_ATTR_STAT_MODE,		/* u32 */
+	RDMA_NLDEV_ATTR_STAT_RES,		/* u32 */
+	RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK,	/* u32 */
+	RDMA_NLDEV_ATTR_STAT_COUNTER,		/* nested table */
+	RDMA_NLDEV_ATTR_STAT_COUNTER_ENTRY,	/* nested table */
+	RDMA_NLDEV_ATTR_STAT_COUNTER_ID,	/* u32 */
+	RDMA_NLDEV_ATTR_STAT_HWCOUNTERS,	/* nested table */
+	RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY,	/* nested table */
+	RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_NAME,	/* string */
+	RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_VALUE,	/* u64 */
 
 	/*
 	 * Always the end
 	 */
 	RDMA_NLDEV_ATTR_MAX
 };
+
+/*
+ * Supported counter bind modes. All modes are mutual-exclusive.
+ */
+enum rdma_nl_counter_mode {
+	RDMA_COUNTER_MODE_NONE,
+
+	/*
+	 * A qp is bound with a counter automatically during initialization
+	 * based on the auto mode (e.g., qp type, ...)
+	 */
+	RDMA_COUNTER_MODE_AUTO,
+
+	/*
+	 * Which qp are bound with which counter is explicitly specified
+	 * by the user
+	 */
+	RDMA_COUNTER_MODE_MANUAL,
+
+	/*
+	 * Always the end
+	 */
+	RDMA_COUNTER_MODE_MAX,
+};
+
+/*
+ * Supported criteria in counter auto mode.
+ * Currently only "qp type" is supported
+ */
+enum rdma_nl_counter_mask {
+	RDMA_COUNTER_MASK_QP_TYPE = 1,
+};
+
 #endif /* _RDMA_NETLINK_H */
-- 
2.20.1

