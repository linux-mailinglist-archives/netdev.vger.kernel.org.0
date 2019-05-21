Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42A73251D6
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 16:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbfEUOXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 10:23:00 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:57782 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728309AbfEUOW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 10:22:57 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 21 May 2019 17:22:54 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x4LEMlHu023035;
        Tue, 21 May 2019 17:22:52 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     dsahern@gmail.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        stephen@networkplumber.org, leonro@mellanox.com, parav@mellanox.com
Subject: [PATCH iproute2-next 3/4] rdma: Add an option to set net namespace of rdma device
Date:   Tue, 21 May 2019 09:22:43 -0500
Message-Id: <20190521142244.8452-4-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190521142244.8452-1-parav@mellanox.com>
References: <20190521142244.8452-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enrich rdma tool with an option to set network namespace of RDMA
device. After successful execution of it, rdma device will
be accessible only in assigned network namespace.

rdma tool command examples and output.

First set netns mode to exclusive.

$ rdma system set netns exclusive

Now create network namespace and assign RDMA device to this
network namespace.

$ ip netns add foo
$ rdma dev set mlx5_1 netns foo

Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 rdma/dev.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/rdma/dev.c b/rdma/dev.c
index 90483622..d28bf6b3 100644
--- a/rdma/dev.c
+++ b/rdma/dev.c
@@ -4,12 +4,14 @@
  * Authors:     Leon Romanovsky <leonro@mellanox.com>
  */
 
+#include <fcntl.h>
 #include "rdma.h"
 
 static int dev_help(struct rd *rd)
 {
 	pr_out("Usage: %s dev show [DEV]\n", rd->filename);
 	pr_out("       %s dev set [DEV] name DEVNAME\n", rd->filename);
+	pr_out("       %s dev set [DEV] netns NSNAME\n", rd->filename);
 	return 0;
 }
 
@@ -272,11 +274,46 @@ static int dev_set_name(struct rd *rd)
 	return rd_sendrecv_msg(rd, seq);
 }
 
+static int dev_set_netns(struct rd *rd)
+{
+	char *netns_path;
+	uint32_t seq;
+	int netns;
+	int ret;
+
+	if (rd_no_arg(rd)) {
+		pr_err("Please provide device name.\n");
+		return -EINVAL;
+	}
+
+	if (asprintf(&netns_path, "%s/%s", NETNS_RUN_DIR, rd_argv(rd)) < 0)
+		return -ENOMEM;
+
+	netns = open(netns_path, O_RDONLY | O_CLOEXEC);
+	if (netns < 0) {
+		fprintf(stderr, "Cannot open network namespace \"%s\": %s\n",
+			rd_argv(rd), strerror(errno));
+		ret = -EINVAL;
+		goto done;
+	}
+
+	rd_prepare_msg(rd, RDMA_NLDEV_CMD_SET,
+		       &seq, (NLM_F_REQUEST | NLM_F_ACK));
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_DEV_INDEX, rd->dev_idx);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_NET_NS_FD, netns);
+	ret = rd_sendrecv_msg(rd, seq);
+	close(netns);
+done:
+	free(netns_path);
+	return ret;
+}
+
 static int dev_one_set(struct rd *rd)
 {
 	const struct rd_cmd cmds[] = {
 		{ NULL,		dev_help},
 		{ "name",	dev_set_name},
+		{ "netns",	dev_set_netns},
 		{ 0 }
 	};
 
-- 
2.19.2

