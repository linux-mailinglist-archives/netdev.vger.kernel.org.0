Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 274D6251D1
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 16:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbfEUOWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 10:22:54 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:57748 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726900AbfEUOWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 10:22:54 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 21 May 2019 17:22:51 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x4LEMlHs023035;
        Tue, 21 May 2019 17:22:49 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     dsahern@gmail.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        stephen@networkplumber.org, leonro@mellanox.com, parav@mellanox.com
Subject: [PATCH iproute2-next 1/4] rdma: Add an option to query,set net namespace sharing sys parameter
Date:   Tue, 21 May 2019 09:22:41 -0500
Message-Id: <20190521142244.8452-2-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190521142244.8452-1-parav@mellanox.com>
References: <20190521142244.8452-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enrich rdma tool with an option to query rdma subsystem parameter
whether rdma devices are shared among multiple network namespaces
or exclusive to single network namespace.

rdma tool command examples and output.

$ rdma system show
netns shared

$ rdma system set netns exclusive

$ rdma system show
netns exclusive

Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 rdma/Makefile |   2 +-
 rdma/rdma.c   |   3 +-
 rdma/rdma.h   |   1 +
 rdma/sys.c    | 143 ++++++++++++++++++++++++++++++++++++++++++++++++++
 rdma/utils.c  |   1 +
 5 files changed, 148 insertions(+), 2 deletions(-)
 create mode 100644 rdma/sys.c

diff --git a/rdma/Makefile b/rdma/Makefile
index 6a424234..4847f27e 100644
--- a/rdma/Makefile
+++ b/rdma/Makefile
@@ -7,7 +7,7 @@ ifeq ($(HAVE_MNL),y)
 CFLAGS += -I./include/uapi/
 
 RDMA_OBJ = rdma.o utils.o dev.o link.o res.o res-pd.o res-mr.o res-cq.o \
-	   res-cmid.o res-qp.o
+	   res-cmid.o res-qp.o sys.o
 
 TARGETS += rdma
 endif
diff --git a/rdma/rdma.c b/rdma/rdma.c
index 676e03c2..e9f1b4bb 100644
--- a/rdma/rdma.c
+++ b/rdma/rdma.c
@@ -11,7 +11,7 @@ static void help(char *name)
 {
 	pr_out("Usage: %s [ OPTIONS ] OBJECT { COMMAND | help }\n"
 	       "       %s [ -f[orce] ] -b[atch] filename\n"
-	       "where  OBJECT := { dev | link | resource | help }\n"
+	       "where  OBJECT := { dev | link | resource | system | help }\n"
 	       "       OPTIONS := { -V[ersion] | -d[etails] | -j[son] | -p[retty]}\n", name, name);
 }
 
@@ -29,6 +29,7 @@ static int rd_cmd(struct rd *rd, int argc, char **argv)
 		{ "dev",	cmd_dev },
 		{ "link",	cmd_link },
 		{ "resource",	cmd_res },
+		{ "system",	cmd_sys },
 		{ 0 }
 	};
 
diff --git a/rdma/rdma.h b/rdma/rdma.h
index 9ed9e045..885a751e 100644
--- a/rdma/rdma.h
+++ b/rdma/rdma.h
@@ -93,6 +93,7 @@ char *rd_argv(struct rd *rd);
 int cmd_dev(struct rd *rd);
 int cmd_link(struct rd *rd);
 int cmd_res(struct rd *rd);
+int cmd_sys(struct rd *rd);
 int rd_exec_cmd(struct rd *rd, const struct rd_cmd *c, const char *str);
 int rd_exec_dev(struct rd *rd, int (*cb)(struct rd *rd));
 int rd_exec_require_dev(struct rd *rd, int (*cb)(struct rd *rd));
diff --git a/rdma/sys.c b/rdma/sys.c
new file mode 100644
index 00000000..78e5198f
--- /dev/null
+++ b/rdma/sys.c
@@ -0,0 +1,143 @@
+/*
+ * sys.c	RDMA tool
+ *
+ *              This program is free software; you can redistribute it and/or
+ *              modify it under the terms of the GNU General Public License
+ *              as published by the Free Software Foundation; either version
+ *              2 of the License, or (at your option) any later version.
+ */
+
+#include "rdma.h"
+
+static int sys_help(struct rd *rd)
+{
+	pr_out("Usage: %s system show [ netns ]\n", rd->filename);
+	pr_out("       %s system set netns { shared | exclusive }\n", rd->filename);
+	return 0;
+}
+
+static const char *netns_modes_str[] = {
+	"exclusive",
+	"shared",
+};
+
+static int sys_show_parse_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
+	struct rd *rd = data;
+
+	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
+
+	if (tb[RDMA_NLDEV_SYS_ATTR_NETNS_MODE]) {
+		const char *mode_str;
+		uint8_t netns_mode;
+
+		netns_mode =
+			mnl_attr_get_u8(tb[RDMA_NLDEV_SYS_ATTR_NETNS_MODE]);
+
+		if (netns_mode <= ARRAY_SIZE(netns_modes_str))
+			mode_str = netns_modes_str[netns_mode];
+		else
+			mode_str = "unknown";
+
+		if (rd->json_output)
+			jsonw_string_field(rd->jw, "netns", mode_str);
+		else
+			pr_out("netns %s\n", mode_str);
+	}
+	return MNL_CB_OK;
+}
+
+static int sys_show_no_args(struct rd *rd)
+{
+	uint32_t seq;
+	int ret;
+
+	rd_prepare_msg(rd, RDMA_NLDEV_CMD_SYS_GET,
+		       &seq, (NLM_F_REQUEST | NLM_F_ACK));
+	ret = rd_send_msg(rd);
+	if (ret)
+		return ret;
+
+	ret = rd_recv_msg(rd, sys_show_parse_cb, rd, seq);
+	return ret;
+}
+
+static int sys_show(struct rd *rd)
+{
+	const struct rd_cmd cmds[] = {
+		{ NULL,		sys_show_no_args},
+		{ "netns",	sys_show_no_args},
+		{ 0 }
+	};
+
+	return rd_exec_cmd(rd, cmds, "parameter");
+}
+
+static int sys_set_netns_cmd(struct rd *rd, bool enable)
+{
+	uint32_t seq;
+
+	rd_prepare_msg(rd, RDMA_NLDEV_CMD_SYS_SET,
+		       &seq, (NLM_F_REQUEST | NLM_F_ACK));
+	mnl_attr_put_u8(rd->nlh, RDMA_NLDEV_SYS_ATTR_NETNS_MODE, enable);
+
+	return rd_sendrecv_msg(rd, seq);
+}
+
+static bool sys_valid_netns_cmd(const char *cmd)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(netns_modes_str); i++) {
+		if (!strcmp(cmd, netns_modes_str[i]))
+			return true;
+	}
+	return false;
+}
+
+static int sys_set_netns_args(struct rd *rd)
+{
+	bool cmd;
+
+	if (rd_no_arg(rd) || !sys_valid_netns_cmd(rd_argv(rd))) {
+		pr_err("valid options are: { shared | exclusive }\n");
+		return -EINVAL;
+	}
+
+	cmd = (strcmp(rd_argv(rd), "shared") == 0) ? true : false;
+
+	return sys_set_netns_cmd(rd, cmd);
+}
+
+static int sys_set_help(struct rd *rd)
+{
+	pr_out("Usage: %s system set [PARAM] value\n", rd->filename);
+	pr_out("            system set netns { shared | exclusive }\n");
+	return 0;
+}
+
+static int sys_set(struct rd *rd)
+{
+	const struct rd_cmd cmds[] = {
+		{ NULL,			sys_set_help },
+		{ "help",		sys_set_help },
+		{ "netns",		sys_set_netns_args},
+		{ 0 }
+	};
+
+	return rd_exec_cmd(rd, cmds, "parameter");
+}
+
+int cmd_sys(struct rd *rd)
+{
+	const struct rd_cmd cmds[] = {
+		{ NULL,		sys_show },
+		{ "show",	sys_show },
+		{ "set",	sys_set },
+		{ "help",	sys_help },
+		{ 0 }
+	};
+
+	return rd_exec_cmd(rd, cmds, "system command");
+}
diff --git a/rdma/utils.c b/rdma/utils.c
index 11ed8a73..558d1c29 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -435,6 +435,7 @@ static const enum mnl_attr_data_type nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_DRIVER_U32] = MNL_TYPE_U32,
 	[RDMA_NLDEV_ATTR_DRIVER_S64] = MNL_TYPE_U64,
 	[RDMA_NLDEV_ATTR_DRIVER_U64] = MNL_TYPE_U64,
+	[RDMA_NLDEV_SYS_ATTR_NETNS_MODE] = MNL_TYPE_U8,
 };
 
 int rd_attr_check(const struct nlattr *attr, int *typep)
-- 
2.19.2

