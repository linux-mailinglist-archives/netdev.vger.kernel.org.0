Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6AA52195A7
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 03:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgGIBam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 21:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgGIBal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 21:30:41 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65ADBC061A0B;
        Wed,  8 Jul 2020 18:30:41 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id p3so228109pgh.3;
        Wed, 08 Jul 2020 18:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QxuCgGeAL1bNkTY0VEO/qfZ//Aqs3V69dcrU/BuTnbI=;
        b=hsa2lRCbc7Uf4QTFUxtTVE3idc/OCWp5hvMflhoD2vnvM8ThC68V7hgf1a91EkX46I
         mQ12YZyZQpuX0bNUh6AUZEimBDu6g+iJT8e0BENR+L3sOQd/ERwLTNu4we4rZG/yxBIm
         FktSjHgcKvYdHT4JWHtu+zrtuSNQOvKDDQzQYlIdN5hKrZ7GqM9rf8knDCzP4yPh2OP3
         oK4PZfdz9y5fdbJ7V5mX22weIQCty/JU7yhgNlsHLSWepqVaDcb0I14n51hPnlz3KYwu
         jE0LcQhqnoS/uHAwSB6buRKeLB8oDbpyu/ZLBHkhTKRlT+NfFkE+DzozEW9j2KHaHo2K
         7ITQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QxuCgGeAL1bNkTY0VEO/qfZ//Aqs3V69dcrU/BuTnbI=;
        b=SLo6nkI9WPeUZ8PaTQ/pZGO7JAqUtwpTIAvndWMC+fyBB6RSIQQhFb2+44TIDafcXB
         He3O6BJ9U35YTKd6VuOVu4xRHKRbhLxkT/2ndyPDksFTFrx6151eJ5gBMDEIwhybaJZ4
         s8FJUK9UnPAKPwZFESa2uh+DJPzQZ0w/hkFVlKqkmsLWmGPuRxZuDEiLAuELS/n5ldQc
         m2t+8AKpAW3qXGl3iSwXaq36uds06tQ6RgSSB9QzvUSH8MJs45OCma5UsyfykSlCel/w
         BhzzZdbnBFGG1aKrtHNlpsk5+rwJ4pvnRgfJOMEz/zcvyrM9Y4/IRyaKKHtJSPf9yeN/
         q/xA==
X-Gm-Message-State: AOAM530RrOjlF8X6lH69BQsFHEgdAl3RrU51LQkq48abeK7fjuIQhJyZ
        FMkv8hAI0/R0UeRy+L5p0H71BbrKuHLDEA==
X-Google-Smtp-Source: ABdhPJy8o+BwhD8H+FwfIP8zerHcTmBN3QcTKZcRWgXbEX93tgI3TAL4gKF/uK6JZY0K38PEjzBxqA==
X-Received: by 2002:a63:8c4a:: with SMTP id q10mr52529336pgn.431.1594258240212;
        Wed, 08 Jul 2020 18:30:40 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q14sm847157pgk.86.2020.07.08.18.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 18:30:39 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv6 bpf-next 2/3] sample/bpf: add xdp_redirect_map_multicast test
Date:   Thu,  9 Jul 2020 09:30:07 +0800
Message-Id: <20200709013008.3900892-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200709013008.3900892-1-liuhangbin@gmail.com>
References: <20200701041938.862200-1-liuhangbin@gmail.com>
 <20200709013008.3900892-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a sample for xdp multicast. In the sample we could forward all
packets between given interfaces.

v5: add a null_map as we have strict the arg2 to ARG_CONST_MAP_PTR.
    Move the testing part to bpf selftest in next patch.
v4: no update.
v3: add rxcnt map to show the packet transmit speed.
v2: no update.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 samples/bpf/Makefile                      |   3 +
 samples/bpf/xdp_redirect_map_multi_kern.c |  57 ++++++++
 samples/bpf/xdp_redirect_map_multi_user.c | 166 ++++++++++++++++++++++
 3 files changed, 226 insertions(+)
 create mode 100644 samples/bpf/xdp_redirect_map_multi_kern.c
 create mode 100644 samples/bpf/xdp_redirect_map_multi_user.c

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index f87ee02073ba..fddca6cb76b8 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -41,6 +41,7 @@ tprogs-y += test_map_in_map
 tprogs-y += per_socket_stats_example
 tprogs-y += xdp_redirect
 tprogs-y += xdp_redirect_map
+tprogs-y += xdp_redirect_map_multi
 tprogs-y += xdp_redirect_cpu
 tprogs-y += xdp_monitor
 tprogs-y += xdp_rxq_info
@@ -97,6 +98,7 @@ test_map_in_map-objs := test_map_in_map_user.o
 per_socket_stats_example-objs := cookie_uid_helper_example.o
 xdp_redirect-objs := xdp_redirect_user.o
 xdp_redirect_map-objs := xdp_redirect_map_user.o
+xdp_redirect_map_multi-objs := xdp_redirect_map_multi_user.o
 xdp_redirect_cpu-objs := bpf_load.o xdp_redirect_cpu_user.o
 xdp_monitor-objs := bpf_load.o xdp_monitor_user.o
 xdp_rxq_info-objs := xdp_rxq_info_user.o
@@ -156,6 +158,7 @@ always-y += tcp_tos_reflect_kern.o
 always-y += tcp_dumpstats_kern.o
 always-y += xdp_redirect_kern.o
 always-y += xdp_redirect_map_kern.o
+always-y += xdp_redirect_map_multi_kern.o
 always-y += xdp_redirect_cpu_kern.o
 always-y += xdp_monitor_kern.o
 always-y += xdp_rxq_info_kern.o
diff --git a/samples/bpf/xdp_redirect_map_multi_kern.c b/samples/bpf/xdp_redirect_map_multi_kern.c
new file mode 100644
index 000000000000..cc7ebaedf55a
--- /dev/null
+++ b/samples/bpf/xdp_redirect_map_multi_kern.c
@@ -0,0 +1,57 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ */
+#define KBUILD_MODNAME "foo"
+#include <uapi/linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+struct bpf_map_def SEC("maps") forward_map = {
+	.type = BPF_MAP_TYPE_DEVMAP_HASH,
+	.key_size = sizeof(u32),
+	.value_size = sizeof(int),
+	.max_entries = 256,
+};
+
+struct bpf_map_def SEC("maps") null_map = {
+	.type = BPF_MAP_TYPE_DEVMAP_HASH,
+	.key_size = sizeof(u32),
+	.value_size = sizeof(int),
+	.max_entries = 1,
+};
+
+struct bpf_map_def SEC("maps") rxcnt = {
+	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
+	.key_size = sizeof(u32),
+	.value_size = sizeof(long),
+	.max_entries = 1,
+};
+
+SEC("xdp_redirect_map_multi")
+int xdp_redirect_map_multi_prog(struct xdp_md *ctx)
+{
+	long *value;
+	u32 key = 0;
+
+	/* count packet in global counter */
+	value = bpf_map_lookup_elem(&rxcnt, &key);
+	if (value)
+		*value += 1;
+
+	return bpf_redirect_map_multi(&forward_map, &null_map,
+				      BPF_F_EXCLUDE_INGRESS);
+}
+
+SEC("xdp_dummy")
+int xdp_pass(struct xdp_md *ctx)
+{
+	return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/samples/bpf/xdp_redirect_map_multi_user.c b/samples/bpf/xdp_redirect_map_multi_user.c
new file mode 100644
index 000000000000..49f44c91b672
--- /dev/null
+++ b/samples/bpf/xdp_redirect_map_multi_user.c
@@ -0,0 +1,166 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <linux/if_link.h>
+#include <assert.h>
+#include <errno.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <net/if.h>
+#include <unistd.h>
+#include <libgen.h>
+
+#include "bpf_util.h"
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#define MAX_IFACE_NUM 32
+
+static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
+static int ifaces[MAX_IFACE_NUM] = {};
+static int rxcnt;
+
+static void int_exit(int sig)
+{
+	__u32 prog_id = 0;
+	int i;
+
+	for (i = 0; ifaces[i] > 0; i++) {
+		if (bpf_get_link_xdp_id(ifaces[i], &prog_id, xdp_flags)) {
+			printf("bpf_get_link_xdp_id failed\n");
+			exit(1);
+		}
+		if (prog_id)
+			bpf_set_link_xdp_fd(ifaces[i], -1, xdp_flags);
+	}
+
+	exit(0);
+}
+
+static void poll_stats(int interval)
+{
+	unsigned int nr_cpus = bpf_num_possible_cpus();
+	__u64 values[nr_cpus], prev[nr_cpus];
+
+	memset(prev, 0, sizeof(prev));
+
+	while (1) {
+		__u64 sum = 0;
+		__u32 key = 0;
+		int i;
+
+		sleep(interval);
+		assert(bpf_map_lookup_elem(rxcnt, &key, values) == 0);
+		for (i = 0; i < nr_cpus; i++)
+			sum += (values[i] - prev[i]);
+		if (sum)
+			printf("Forwarding %10llu pkt/s\n", sum / interval);
+		memcpy(prev, values, sizeof(values));
+	}
+}
+
+static void usage(const char *prog)
+{
+	fprintf(stderr,
+		"usage: %s [OPTS] <IFNAME|IFINDEX> <IFNAME|IFINDEX> ...\n"
+		"OPTS:\n"
+		"    -S    use skb-mode\n"
+		"    -N    enforce native mode\n"
+		"    -F    force loading prog\n",
+		prog);
+}
+
+int main(int argc, char **argv)
+{
+	struct bpf_prog_load_attr prog_load_attr = {
+		.prog_type      = BPF_PROG_TYPE_XDP,
+	};
+	int prog_fd, forward_map;
+	int i, ret, opt, ifindex;
+	char ifname[IF_NAMESIZE];
+	struct bpf_object *obj;
+	char filename[256];
+
+	while ((opt = getopt(argc, argv, "SNF")) != -1) {
+		switch (opt) {
+		case 'S':
+			xdp_flags |= XDP_FLAGS_SKB_MODE;
+			break;
+		case 'N':
+			/* default, set below */
+			break;
+		case 'F':
+			xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;
+			break;
+		default:
+			usage(basename(argv[0]));
+			return 1;
+		}
+	}
+
+	if (!(xdp_flags & XDP_FLAGS_SKB_MODE))
+		xdp_flags |= XDP_FLAGS_DRV_MODE;
+
+	if (optind == argc) {
+		printf("usage: %s <IFNAME|IFINDEX> <IFNAME|IFINDEX> ...\n", argv[0]);
+		return 1;
+	}
+
+	printf("Get interfaces");
+	for (i = 0; i < MAX_IFACE_NUM && argv[optind + i]; i++) {
+		ifaces[i] = if_nametoindex(argv[optind + i]);
+		if (!ifaces[i])
+			ifaces[i] = strtoul(argv[optind + i], NULL, 0);
+		if (!if_indextoname(ifaces[i], ifname)) {
+			perror("Invalid interface name or i");
+			return 1;
+		}
+		printf(" %d", ifaces[i]);
+	}
+	printf("\n");
+
+	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	prog_load_attr.file = filename;
+
+	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
+		return 1;
+
+	forward_map = bpf_object__find_map_fd_by_name(obj, "forward_map");
+	rxcnt = bpf_object__find_map_fd_by_name(obj, "rxcnt");
+
+	if (forward_map < 0 || rxcnt < 0) {
+		printf("bpf_object__find_map_fd_by_name failed\n");
+		return 1;
+	}
+
+	signal(SIGINT, int_exit);
+	signal(SIGTERM, int_exit);
+
+	/* Init forward multicast groups and exclude group */
+	for (i = 0; ifaces[i] > 0; i++) {
+		ifindex = ifaces[i];
+
+		/* Add all the interfaces to group all */
+		ret = bpf_map_update_elem(forward_map, &ifindex, &ifindex, 0);
+		if (ret) {
+			perror("bpf_map_update_elem");
+			goto err_out;
+		}
+
+		/* bind prog_fd to each interface */
+		ret = bpf_set_link_xdp_fd(ifindex, prog_fd, xdp_flags);
+		if (ret) {
+			printf("Set xdp fd failed on %d\n", ifindex);
+			goto err_out;
+		}
+
+	}
+
+	poll_stats(2);
+
+	return 0;
+
+err_out:
+	return 1;
+}
-- 
2.25.4

