Return-Path: <netdev+bounces-7615-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AE5A720DED
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 07:26:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA776281B88
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 05:26:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7F911FD5;
	Sat,  3 Jun 2023 05:25:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDA43D8B
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 05:25:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2B4C433A4;
	Sat,  3 Jun 2023 05:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685769952;
	bh=N+h0kGExwC3nFQWXRkj+tvBQOwPjOQOkuoOsWwo6r68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pqxZQdQ65lbBx4hEg5s/l4yrc5hp63TxkUuG40KvAa5kCcgqR0vKUyRG6n6zp872c
	 pM2v/n9CiutvjYjBjiSIJCI/9Viv8L7uqtSQhri8nrhMqlY0fQL37qosChwgqmqbRG
	 zpVPmfDZMfAsFE7SmqdnatCMPEOnMDsIFEH182grTYaqlaQHGUwWgvOFYfi+UB381k
	 gZEdNlib7LjU7KcOsuXx67nnsZGic8RdOqF76oGh+lWiaA2k+cMg7NpKlN7bb7yEEG
	 puIg9T/UsX3E1eHoRWbSDTjcTWzOrD1BBHbZ8/NQ4HhVUu1Vj+qmhdlFfw2xKpii6k
	 C2/YX4m9SH4uA==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 4/4] tools: ynl: add sample for netdev
Date: Fri,  2 Jun 2023 22:25:47 -0700
Message-Id: <20230603052547.631384-5-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230603052547.631384-1-kuba@kernel.org>
References: <20230603052547.631384-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a sample application using the C library.
My main goal is to make writing selftests easier but until
I have some of those ready I think it's useful to show off
the functionality and let people poke and tinker.

Sample outputs - dump:

$ ./netdev
Select ifc ($ifindex; or 0 = dump; or -2 ntf check): 0
      lo[1]	0:
  enp1s0[2]	23: basic redirect rx-sg

Notifications (watching veth pair getting added and deleted):

$ ./netdev
Select ifc ($ifindex; or 0 = dump; or -2 ntf check): -2
[53]	0: (ntf: dev-add-ntf)
[54]	0: (ntf: dev-add-ntf)
[54]	23: basic redirect rx-sg (ntf: dev-change-ntf)
[53]	23: basic redirect rx-sg (ntf: dev-change-ntf)
[53]	23: basic redirect rx-sg (ntf: dev-del-ntf)
[54]	23: basic redirect rx-sg (ntf: dev-del-ntf)

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/samples/.gitignore |   1 +
 tools/net/ynl/samples/Makefile   |  28 ++++++++
 tools/net/ynl/samples/netdev.c   | 108 +++++++++++++++++++++++++++++++
 3 files changed, 137 insertions(+)
 create mode 100644 tools/net/ynl/samples/.gitignore
 create mode 100644 tools/net/ynl/samples/Makefile
 create mode 100644 tools/net/ynl/samples/netdev.c

diff --git a/tools/net/ynl/samples/.gitignore b/tools/net/ynl/samples/.gitignore
new file mode 100644
index 000000000000..7b1f5179cb54
--- /dev/null
+++ b/tools/net/ynl/samples/.gitignore
@@ -0,0 +1 @@
+netdev
diff --git a/tools/net/ynl/samples/Makefile b/tools/net/ynl/samples/Makefile
new file mode 100644
index 000000000000..54eb5e3b9ab4
--- /dev/null
+++ b/tools/net/ynl/samples/Makefile
@@ -0,0 +1,28 @@
+# SPDX-License-Identifier: GPL-2.0
+
+CC=gcc
+CFLAGS=-std=gnu99 -O2 -W -Wall -Wextra -Wno-unused-parameter -Wshadow \
+	-I../lib/ -I../generated/
+ifeq ("$(DEBUG)","1")
+  CFLAGS += -g -fsanitize=address -fsanitize=leak -static-libasan
+endif
+
+LDLIBS=-lmnl ../lib/ynl.a ../generated/protos.a
+
+SRCS=$(wildcard *.c)
+BINS=$(patsubst %.c,%,${SRCS})
+
+include $(wildcard *.d)
+
+all: $(BINS)
+
+$(BINS): ../lib/ynl.a ../generated/protos.a
+
+clean:
+	rm -f *.o *.d *~
+
+hardclean: clean
+	rm -f $(BINS)
+
+.PHONY: all clean
+.DEFAULT_GOAL=all
diff --git a/tools/net/ynl/samples/netdev.c b/tools/net/ynl/samples/netdev.c
new file mode 100644
index 000000000000..d31268aa47c5
--- /dev/null
+++ b/tools/net/ynl/samples/netdev.c
@@ -0,0 +1,108 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <stdio.h>
+#include <string.h>
+
+#include <ynl.h>
+
+#include <net/if.h>
+
+#include "netdev-user.h"
+
+/* netdev genetlink family code sample
+ * This sample shows off basics of the netdev family but also notification
+ * handling, hence the somewhat odd UI. We subscribe to notifications first
+ * then wait for ifc selection, so the socket may already accumulate
+ * notifications as we wait. This allows us to test that YNL can handle
+ * requests and notifications getting interleaved.
+ */
+
+static void netdev_print_device(struct netdev_dev_get_rsp *d, unsigned int op)
+{
+	char ifname[IF_NAMESIZE];
+	const char *name;
+
+	if (!d->_present.ifindex)
+		return;
+
+	name = if_indextoname(d->ifindex, ifname);
+	if (name)
+		printf("%8s", name);
+	printf("[%d]\t", d->ifindex);
+
+	if (!d->_present.xdp_features)
+		return;
+
+	printf("%llx:", d->xdp_features);
+	for (int i = 0; d->xdp_features > 1U << i; i++) {
+		if (d->xdp_features & (1U << i))
+			printf(" %s", netdev_xdp_act_str(1 << i));
+	}
+
+	name = netdev_op_str(op);
+	if (name)
+		printf(" (ntf: %s)", name);
+	printf("\n");
+}
+
+int main(int argc, char **argv)
+{
+	struct netdev_dev_get_list *devs;
+	struct ynl_ntf_base_type *ntf;
+	struct ynl_error yerr;
+	struct ynl_sock *ys;
+	int ifindex = 0;
+
+	if (argc > 1)
+		ifindex = strtol(argv[1], NULL, 0);
+
+	ys = ynl_sock_create(&ynl_netdev_family, &yerr);
+	if (!ys) {
+		fprintf(stderr, "YNL: %s\n", yerr.msg);
+		return 1;
+	}
+
+	if (ynl_subscribe(ys, "mgmt"))
+		goto err_close;
+
+	printf("Select ifc ($ifindex; or 0 = dump; or -2 ntf check): ");
+	scanf("%d", &ifindex);
+
+	if (ifindex > 0) {
+		struct netdev_dev_get_req *req;
+		struct netdev_dev_get_rsp *d;
+
+		req = netdev_dev_get_req_alloc();
+		netdev_dev_get_req_set_ifindex(req, ifindex);
+
+		d = netdev_dev_get(ys, req);
+		netdev_dev_get_req_free(req);
+		if (!d)
+			goto err_close;
+
+		netdev_print_device(d, 0);
+		netdev_dev_get_rsp_free(d);
+	} else if (!ifindex) {
+		devs = netdev_dev_get_dump(ys);
+		if (!devs)
+			goto err_close;
+
+		ynl_dump_foreach(devs, d)
+			netdev_print_device(d, 0);
+		netdev_dev_get_list_free(devs);
+	} else if (ifindex == -2) {
+		ynl_ntf_check(ys);
+	}
+	while ((ntf = ynl_ntf_dequeue(ys))) {
+		netdev_print_device((struct netdev_dev_get_rsp *)&ntf->data,
+				    ntf->cmd);
+		ynl_ntf_free(ntf);
+	}
+
+	ynl_sock_destroy(ys);
+	return 0;
+
+err_close:
+	fprintf(stderr, "YNL: %s\n", ys->err.msg);
+	ynl_sock_destroy(ys);
+	return 2;
+}
-- 
2.40.1


