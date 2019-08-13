Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8968B806
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 14:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbfHMMHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 08:07:40 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43373 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbfHMMHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 08:07:40 -0400
Received: by mail-pf1-f194.google.com with SMTP id v12so3713507pfn.10;
        Tue, 13 Aug 2019 05:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JOoTnYKOHFfIesoWtivO+FL06Qxsm3b0tiJNLnOqwik=;
        b=FCkTbebdflPRFQVhc2G2rYaVEHZkCC1Dq/1ERV3+YbY+V6u2+ZURZ6/0gReD1pRIQP
         Fdf6uyBcmxAFJ3E15+lfMqfIRBkUk4eH2otH7B2wQGuFAFPxhvLAuBn4gZEKTdSsmjlM
         KsT6xqMN59C/9Ccp5JdRodF/GYtV3BGba1vDwE0M6DCeWlGYEymRT3zJzVk83SXonnie
         VkoxbM37UR4Qsm7tslKLoXrr4pRyeqp5iDA5mQIRkTjRJYM/2wZSxRmLSfRKouXoRv5S
         xiZANJA4Cf+YlV80X/PmAfKydlFGsOZfnkJUuix2LozSx+OwBhqWSgJl27/9BCfk8ZnA
         h6UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JOoTnYKOHFfIesoWtivO+FL06Qxsm3b0tiJNLnOqwik=;
        b=TezYh5hzYAEh2zDdaaqi3GKMbn5vp5T9T7v+9p9/JIsQ/vZpBD563iw4DiVBLR5/aR
         1Fry9kyHii0lPJ9zvQSQLEgg+9QezUOUd93/lbtcdkzUaEDLBexA4qnHnPS0NbkoXHR5
         y+v9acS+YDTJxc/NgkcI4lVg6tk5RS4rWcyH2KIiI1ZKtuMtZo4DgACNyIZDIa4/nW/M
         +vCSjCmRCDt95kMwt/rjx8JbCm1b/S8Uuxc1y1Q20EC2PuzAufhSJrUWiICJiBu0qNcl
         sOfJGbGAWtwAsS8glT/YXrH2/o/vVrB0ZIbWeVXi5KoeOpa0pE3jco6OadT13cAhgISi
         tutA==
X-Gm-Message-State: APjAAAX48WIupskfOkkTG6DOmGgyzGUJQaklW+T8kYelkTrXqcrU6RAN
        ZMYoI2H7Gz/lEyTrrNrQTHrp/MOo
X-Google-Smtp-Source: APXvYqy1g9RCGvUeGuYeGqHbj6YHzvpgtw7ssOSc7t7j6/rGS2l9tM9DCY3XnrWMzUK11Ivcz/20Vg==
X-Received: by 2002:a17:90a:b104:: with SMTP id z4mr1943940pjq.102.1565698059098;
        Tue, 13 Aug 2019 05:07:39 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id o9sm73251099pgv.19.2019.08.13.05.07.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 05:07:38 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>
Subject: [RFC PATCH bpf-next 05/14] xdp_flow: Prepare flow tables in bpf
Date:   Tue, 13 Aug 2019 21:05:49 +0900
Message-Id: <20190813120558.6151-6-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
References: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add maps for flow tables in bpf. TC flower has hash tables for each flow
mask ordered by priority. To do the same thing, prepare
hashmap-in-arraymap. As bpf does not provide ordered list, we emulate it
by an array. Each array entry has one-byte next index field to implement
a list. Also prepare a one-element array to point to the head index of
the list.

Because of the limitation of bpf maps, the outer array is implemented
using two array maps. "flow_masks" is the array to emulate the list and
its entries have the priority and mask of each flow table. For each
priority/mask, the same index entry of another map "flow_tables", which
is the hashmap-in-arraymap, points to the actual flow table.

The flow insertion logic in UMH and lookup logic in BPF will be
implemented in the following commits.

NOTE: This list emulation by array may be able to be realized by adding
ordered-list type map. In that case we also need map iteration API for
bpf progs.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 net/xdp_flow/umh_bpf.h           | 18 +++++++++++
 net/xdp_flow/xdp_flow_kern_bpf.c | 22 +++++++++++++
 net/xdp_flow/xdp_flow_umh.c      | 70 ++++++++++++++++++++++++++++++++++++++--
 3 files changed, 108 insertions(+), 2 deletions(-)
 create mode 100644 net/xdp_flow/umh_bpf.h

diff --git a/net/xdp_flow/umh_bpf.h b/net/xdp_flow/umh_bpf.h
new file mode 100644
index 0000000..b4fe0c6
--- /dev/null
+++ b/net/xdp_flow/umh_bpf.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _NET_XDP_FLOW_UMH_BPF_H
+#define _NET_XDP_FLOW_UMH_BPF_H
+
+#include "msgfmt.h"
+
+#define MAX_FLOWS 1024
+#define MAX_FLOW_MASKS 255
+#define FLOW_MASKS_TAIL 255
+
+struct xdp_flow_mask_entry {
+	struct xdp_flow_key mask;
+	__u16 priority;
+	short count;
+	int next;
+};
+
+#endif
diff --git a/net/xdp_flow/xdp_flow_kern_bpf.c b/net/xdp_flow/xdp_flow_kern_bpf.c
index 74cdb1d..c101156 100644
--- a/net/xdp_flow/xdp_flow_kern_bpf.c
+++ b/net/xdp_flow/xdp_flow_kern_bpf.c
@@ -2,6 +2,28 @@
 #define KBUILD_MODNAME "foo"
 #include <uapi/linux/bpf.h>
 #include <bpf_helpers.h>
+#include "umh_bpf.h"
+
+struct bpf_map_def SEC("maps") flow_masks_head = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.key_size = sizeof(u32),
+	.value_size = sizeof(int),
+	.max_entries = 1,
+};
+
+struct bpf_map_def SEC("maps") flow_masks = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.key_size = sizeof(u32),
+	.value_size = sizeof(struct xdp_flow_mask_entry),
+	.max_entries = MAX_FLOW_MASKS,
+};
+
+struct bpf_map_def SEC("maps") flow_tables = {
+	.type = BPF_MAP_TYPE_ARRAY_OF_MAPS,
+	.key_size = sizeof(u32),
+	.value_size = sizeof(u32),
+	.max_entries = MAX_FLOW_MASKS,
+};
 
 SEC("xdp_flow")
 int xdp_flow_prog(struct xdp_md *ctx)
diff --git a/net/xdp_flow/xdp_flow_umh.c b/net/xdp_flow/xdp_flow_umh.c
index 734db00..e35666a 100644
--- a/net/xdp_flow/xdp_flow_umh.c
+++ b/net/xdp_flow/xdp_flow_umh.c
@@ -13,7 +13,7 @@
 #include <sys/resource.h>
 #include <linux/hashtable.h>
 #include <linux/err.h>
-#include "msgfmt.h"
+#include "umh_bpf.h"
 
 extern char xdp_flow_bpf_start;
 extern char xdp_flow_bpf_end;
@@ -95,11 +95,13 @@ static int setup(void)
 
 static int load_bpf(int ifindex, struct bpf_object **objp)
 {
+	int prog_fd, flow_tables_fd, flow_meta_fd, flow_masks_head_fd, err;
+	struct bpf_map *flow_tables, *flow_masks_head;
+	int zero = 0, flow_masks_tail = FLOW_MASKS_TAIL;
 	struct bpf_object_open_attr attr = {};
 	char path[256], errbuf[ERRBUF_SIZE];
 	struct bpf_program *prog;
 	struct bpf_object *obj;
-	int prog_fd, err;
 	ssize_t len;
 
 	len = snprintf(path, 256, "/proc/self/fd/%d", progfile_fd);
@@ -127,6 +129,48 @@ static int load_bpf(int ifindex, struct bpf_object **objp)
 	bpf_object__for_each_program(prog, obj)
 		bpf_program__set_type(prog, attr.prog_type);
 
+	flow_meta_fd = bpf_create_map(BPF_MAP_TYPE_HASH,
+				      sizeof(struct xdp_flow_key),
+				      sizeof(struct xdp_flow_actions),
+				      MAX_FLOWS, 0);
+	if (flow_meta_fd < 0) {
+		err = -errno;
+		pr_err("map creation for flow_tables meta failed: %s\n",
+		       strerror(errno));
+		goto err;
+	}
+
+	flow_tables_fd = bpf_create_map_in_map(BPF_MAP_TYPE_ARRAY_OF_MAPS,
+					       "flow_tables", sizeof(__u32),
+					       flow_meta_fd, MAX_FLOW_MASKS, 0);
+	if (flow_tables_fd < 0) {
+		err = -errno;
+		pr_err("map creation for flow_tables failed: %s\n",
+		       strerror(errno));
+		close(flow_meta_fd);
+		goto err;
+	}
+
+	close(flow_meta_fd);
+
+	flow_tables = bpf_object__find_map_by_name(obj, "flow_tables");
+	if (!flow_tables) {
+		pr_err("Cannot find flow_tables\n");
+		err = -ENOENT;
+		close(flow_tables_fd);
+		goto err;
+	}
+
+	err = bpf_map__reuse_fd(flow_tables, flow_tables_fd);
+	if (err) {
+		err = libbpf_err(err, errbuf);
+		pr_err("Failed to reuse flow_tables fd: %s\n", errbuf);
+		close(flow_tables_fd);
+		goto err;
+	}
+
+	close(flow_tables_fd);
+
 	err = bpf_object__load(obj);
 	if (err) {
 		err = libbpf_err(err, errbuf);
@@ -134,6 +178,28 @@ static int load_bpf(int ifindex, struct bpf_object **objp)
 		goto err;
 	}
 
+	flow_masks_head = bpf_object__find_map_by_name(obj, "flow_masks_head");
+	if (!flow_masks_head) {
+		pr_err("Cannot find flow_masks_head map\n");
+		err = -ENOENT;
+		goto err;
+	}
+
+	flow_masks_head_fd = bpf_map__fd(flow_masks_head);
+	if (flow_masks_head_fd < 0) {
+		err = libbpf_err(flow_masks_head_fd, errbuf);
+		pr_err("Invalid flow_masks_head fd: %s\n", errbuf);
+		goto err;
+	}
+
+	if (bpf_map_update_elem(flow_masks_head_fd, &zero, &flow_masks_tail,
+				0)) {
+		err = -errno;
+		pr_err("Failed to initialize flow_masks_head: %s\n",
+		       strerror(errno));
+		goto err;
+	}
+
 	prog = bpf_object__find_program_by_title(obj, "xdp_flow");
 	if (!prog) {
 		pr_err("Cannot find xdp_flow program\n");
-- 
1.8.3.1

