Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2FC29327A
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 02:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389659AbgJTA65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 20:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389646AbgJTA64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 20:58:56 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9194EC0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 17:58:56 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4CFZy70MjQzQkLJ;
        Tue, 20 Oct 2020 02:58:55 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1603155532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FNnn/KZ7OI3tK2XOX5doCKW3VvKCqGiTdDq7Hh5NN+4=;
        b=ZEYzGe0no66LDzgtvMpBDzu9plvq7QzwHHzQKcCNgXrKwCXc4NiUho5EC74yKu13m9fBKM
        6/i67fQwexqh3kBSYzhgJN8Gg1rO5TUItjnGhx6I5uL26w9Psf7Q62l2lvsko3ZfDG+E1Y
        MduvVj8l+UKyddSwLqgX+e207Ne63xNNbW/iwa0kHF3RIrzANfGsO6BmDQqmLHZW2oGEiR
        Kh4s48WIVVzLzp1OH5k92/sVqCinNnUvLKP0VEFDZ97xw0mdLLPt54GUhSsg4fWCFOP1Pz
        Rc+M7rVblIjtDeC6vh5c11DUPDVwW4j7ispoqE/i9oBXixTIDQWGVg9EWO1ZoQ==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id u25FtTK-Olh4; Tue, 20 Oct 2020 02:58:51 +0200 (CEST)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 08/15] lib: Extract from devlink/mnlg a helper, mnlu_socket_open()
Date:   Tue, 20 Oct 2020 02:58:16 +0200
Message-Id: <210528643b5e88d5e241054e0e652e21c87aceeb.1603154867.git.me@pmachata.org>
In-Reply-To: <cover.1603154867.git.me@pmachata.org>
References: <cover.1603154867.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 1.11 / 15.00 / 15.00
X-Rspamd-Queue-Id: B38BA17DB
X-Rspamd-UID: bd8ea8
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This little dance of mnl_socket_open(), option setting, and bind, is the
same regardless of tool. Extract into a new module that should hold helpers
for working with libmnl, mnl_util.c.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 devlink/Makefile    |  2 +-
 devlink/mnlg.c      | 19 ++++---------------
 include/mnl_utils.h |  7 +++++++
 lib/Makefile        |  2 +-
 lib/mnl_utils.c     | 35 +++++++++++++++++++++++++++++++++++
 5 files changed, 48 insertions(+), 17 deletions(-)
 create mode 100644 include/mnl_utils.h
 create mode 100644 lib/mnl_utils.c

diff --git a/devlink/Makefile b/devlink/Makefile
index 7da7d1fa18d5..d540feb3c012 100644
--- a/devlink/Makefile
+++ b/devlink/Makefile
@@ -12,7 +12,7 @@ endif
 
 all: $(TARGETS) $(LIBS)
 
-devlink: $(DEVLINKOBJ)
+devlink: $(DEVLINKOBJ) $(LIBNETLINK)
 	$(QUIET_LINK)$(CC) $^ $(LDFLAGS) $(LDLIBS) -o $@
 
 install: all
diff --git a/devlink/mnlg.c b/devlink/mnlg.c
index c7d25e8713a1..9817bbad5e7d 100644
--- a/devlink/mnlg.c
+++ b/devlink/mnlg.c
@@ -19,6 +19,7 @@
 #include <linux/genetlink.h>
 
 #include "libnetlink.h"
+#include "mnl_utils.h"
 #include "utils.h"
 #include "mnlg.h"
 
@@ -263,7 +264,6 @@ struct mnlg_socket *mnlg_socket_open(const char *family_name, uint8_t version)
 {
 	struct mnlg_socket *nlg;
 	struct nlmsghdr *nlh;
-	int one = 1;
 	int err;
 
 	nlg = malloc(sizeof(*nlg));
@@ -274,19 +274,9 @@ struct mnlg_socket *mnlg_socket_open(const char *family_name, uint8_t version)
 	if (!nlg->buf)
 		goto err_buf_alloc;
 
-	nlg->nl = mnl_socket_open(NETLINK_GENERIC);
+	nlg->nl = mnlu_socket_open(NETLINK_GENERIC);
 	if (!nlg->nl)
-		goto err_mnl_socket_open;
-
-	/* Older kernels may no support capped/extended ACK reporting */
-	mnl_socket_setsockopt(nlg->nl, NETLINK_CAP_ACK, &one, sizeof(one));
-	mnl_socket_setsockopt(nlg->nl, NETLINK_EXT_ACK, &one, sizeof(one));
-
-	err = mnl_socket_bind(nlg->nl, 0, MNL_SOCKET_AUTOPID);
-	if (err < 0)
-		goto err_mnl_socket_bind;
-
-	nlg->portid = mnl_socket_get_portid(nlg->nl);
+		goto err_socket_open;
 
 	nlh = __mnlg_msg_prepare(nlg, CTRL_CMD_GETFAMILY,
 				 NLM_F_REQUEST | NLM_F_ACK, GENL_ID_CTRL, 1);
@@ -305,9 +295,8 @@ struct mnlg_socket *mnlg_socket_open(const char *family_name, uint8_t version)
 
 err_mnlg_socket_recv_run:
 err_mnlg_socket_send:
-err_mnl_socket_bind:
 	mnl_socket_close(nlg->nl);
-err_mnl_socket_open:
+err_socket_open:
 	free(nlg->buf);
 err_buf_alloc:
 	free(nlg);
diff --git a/include/mnl_utils.h b/include/mnl_utils.h
new file mode 100644
index 000000000000..10a064afdfe8
--- /dev/null
+++ b/include/mnl_utils.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __MNL_UTILS_H__
+#define __MNL_UTILS_H__ 1
+
+struct mnl_socket *mnlu_socket_open(int bus);
+
+#endif /* __MNL_UTILS_H__ */
diff --git a/lib/Makefile b/lib/Makefile
index 7cba1857b7fa..13f4ee15373b 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -7,7 +7,7 @@ UTILOBJ = utils.o rt_names.o ll_map.o ll_types.o ll_proto.o ll_addr.o \
 	inet_proto.o namespace.o json_writer.o json_print.o \
 	names.o color.o bpf.o exec.o fs.o cg_map.o
 
-NLOBJ=libgenl.o libnetlink.o
+NLOBJ=libgenl.o libnetlink.o mnl_utils.o
 
 all: libnetlink.a libutil.a
 
diff --git a/lib/mnl_utils.c b/lib/mnl_utils.c
new file mode 100644
index 000000000000..eecb11341651
--- /dev/null
+++ b/lib/mnl_utils.c
@@ -0,0 +1,35 @@
+/*
+ * mnl_utils.c	Helpers for working with libmnl.
+ *
+ *		This program is free software; you can redistribute it and/or
+ *		modify it under the terms of the GNU General Public License
+ *		as published by the Free Software Foundation; either version
+ *		2 of the License, or (at your option) any later version.
+ *
+ */
+
+#include <libmnl/libmnl.h>
+
+#include "mnl_utils.h"
+
+struct mnl_socket *mnlu_socket_open(int bus)
+{
+	struct mnl_socket *nl;
+	int one = 1;
+
+	nl = mnl_socket_open(bus);
+	if (nl == NULL)
+		return NULL;
+
+	mnl_socket_setsockopt(nl, NETLINK_CAP_ACK, &one, sizeof(one));
+	mnl_socket_setsockopt(nl, NETLINK_EXT_ACK, &one, sizeof(one));
+
+	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0)
+		goto err_bind;
+
+	return nl;
+
+err_bind:
+	mnl_socket_close(nl);
+	return NULL;
+}
-- 
2.25.1

