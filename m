Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077D12AABBC
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 16:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbgKHPIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 10:08:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728500AbgKHPIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 10:08:34 -0500
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA92FC0613CF
        for <netdev@vger.kernel.org>; Sun,  8 Nov 2020 07:08:33 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4CTcvg62BVzQlPr;
        Sun,  8 Nov 2020 16:08:31 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1604848110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yk9vsKqU6CoSoOgqvkxP3qcJS25ZON71cxiU9k5XwyU=;
        b=lI8icE5bng3TkP3bMga8GHyyvDUn19WpCe3ADrAKBBxGbbhV4d/xAmWGyJqxOg1+u9CUPa
        LbzvNtVMFtm8CQ5vAXJ5WkfhWTlczIK98JuPK8ZD/bi9CFAy4QVbdCd5JjnkelQSyxEmat
        z4pig0YbtvM75gc62g1B3+Myq/FdIYp7bq1LTm9DQCapvxengIJBcxqH/xv3Rm/xhl8LdJ
        Q14Tki508OEFV1+TbOstAG+totTq4w+Uq15mYbESm0BdfaKDFzgWFSuuZ+1ff6AhAd4aWv
        Z1di3QBQaGwMBybkpF1+TLgy9/uf3wGHEwmw5tSiuGX1/kvKf71Zv12KIWKBoQ==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id 7JgYolDbWxzF; Sun,  8 Nov 2020 16:08:28 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>,
        Leon Romanovsky <leon@kernel.org>,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next v3 04/11] lib: Extract from devlink/mnlg a helper, mnlu_socket_open()
Date:   Sun,  8 Nov 2020 16:07:25 +0100
Message-Id: <c828f857b470770c44575b5ced4569126f801ba2.1604847919.git.me@pmachata.org>
In-Reply-To: <cover.1604847919.git.me@pmachata.org>
References: <cover.1604847919.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 1.14 / 15.00 / 15.00
X-Rspamd-Queue-Id: BDDF21725
X-Rspamd-UID: f94e75
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This little dance of mnl_socket_open(), option setting, and bind, is the
same regardless of tool. Extract into a new module that should hold helpers
for working with libmnl, mnl_util.c.

Signed-off-by: Petr Machata <me@pmachata.org>
---

Notes:
    v2:
    - Add SPDX-License-Identifier

 devlink/Makefile    |  2 +-
 devlink/mnlg.c      | 19 ++++---------------
 include/mnl_utils.h |  7 +++++++
 lib/Makefile        |  2 +-
 lib/mnl_utils.c     | 30 ++++++++++++++++++++++++++++++
 5 files changed, 43 insertions(+), 17 deletions(-)
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
index 000000000000..2426912aa511
--- /dev/null
+++ b/lib/mnl_utils.c
@@ -0,0 +1,30 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * mnl_utils.c	Helpers for working with libmnl.
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

