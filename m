Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A5D1E82B4
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 18:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgE2P7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 11:59:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47311 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727121AbgE2P7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 11:59:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590767992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hyMa/RGolej/k8Ubd6JZ75AI1yc/FHBnlft4jD99tMU=;
        b=CHyNrr2hltYkL4fp4Yz0/8rBh4VLBVWoa9i/1oQJVZCvq9ukVai5YUHK8wMKbLyDuY3DFr
        +TOqtNg5AaU2+2re3oW3Ls8tEYxz6vq1l8hE3frF7QXN9hCGRVIGv9UzMRMHEvLymdtYjT
        WY52pqi7gFjzSd7NKyDADIW8+6Z+Xf0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-pyS1x5LbOLS6T5CkXiV0pg-1; Fri, 29 May 2020 11:59:46 -0400
X-MC-Unique: pyS1x5LbOLS6T5CkXiV0pg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7A888005AA;
        Fri, 29 May 2020 15:59:44 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A27D25C1B5;
        Fri, 29 May 2020 15:59:41 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 9EF20300003E9;
        Fri, 29 May 2020 17:59:40 +0200 (CEST)
Subject: [PATCH bpf-next RFC 1/3] bpf: move struct bpf_devmap_val out of UAPI
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dsahern@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 29 May 2020 17:59:40 +0200
Message-ID: <159076798058.1387573.3077178618799401182.stgit@firesoul>
In-Reply-To: <159076794319.1387573.8722376887638960093.stgit@firesoul>
References: <159076794319.1387573.8722376887638960093.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The struct bpf_devmap_val doesn't belong in uapi/linux/bpf.h, because this
is a struct that BPF-progs can define themselves, and can provide different
sizes to the kernel.

While moving the struct change the union to be a named union, with the name
"bpf_prog". This makes it easier to identify with BTF in next patch.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/uapi/linux/bpf.h                           |    9 -------
 kernel/bpf/devmap.c                                |   25 ++++++++++++++------
 tools/include/uapi/linux/bpf.h                     |    9 -------
 .../selftests/bpf/prog_tests/xdp_devmap_attach.c   |   18 ++++++++++----
 .../bpf/progs/test_xdp_with_devmap_helpers.c       |   10 +++++++-
 5 files changed, 39 insertions(+), 32 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 61ae81bf67de..970c44ecc472 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3628,15 +3628,6 @@ struct xdp_md {
 	__u32 egress_ifindex;  /* txq->dev->ifindex */
 };
 
-/* DEVMAP values */
-struct bpf_devmap_val {
-	__u32 ifindex;   /* device index */
-	union {
-		int   bpf_prog_fd;  /* prog fd on map write */
-		__u32 bpf_prog_id;  /* prog id on map read */
-	};
-};
-
 enum sk_action {
 	SK_DROP = 0,
 	SK_PASS,
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index defdd22caa4b..4ab67b2d8159 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -60,6 +60,15 @@ struct xdp_dev_bulk_queue {
 	unsigned int count;
 };
 
+/* DEVMAP values */
+struct bpf_devmap_val {
+	__u32 ifindex;   /* device index */
+	union {
+		int   fd;  /* prog fd on map write */
+		__u32 id;  /* prog id on map read */
+	} bpf_prog;
+};
+
 struct bpf_dtab_netdev {
 	struct net_device *dev; /* must be first member, due to tracepoint */
 	struct hlist_node index_hlist;
@@ -117,7 +126,7 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
 	 */
 	if (attr->max_entries == 0 || attr->key_size != 4 ||
 	    (valsize != offsetofend(struct bpf_devmap_val, ifindex) &&
-	     valsize != offsetofend(struct bpf_devmap_val, bpf_prog_fd)) ||
+	     valsize != offsetofend(struct bpf_devmap_val, bpf_prog.fd)) ||
 	    attr->map_flags & ~DEV_CREATE_FLAG_MASK)
 		return -EINVAL;
 
@@ -609,8 +618,8 @@ static struct bpf_dtab_netdev *__dev_map_alloc_node(struct net *net,
 	if (!dev->dev)
 		goto err_out;
 
-	if (val->bpf_prog_fd >= 0) {
-		prog = bpf_prog_get_type_dev(val->bpf_prog_fd,
+	if (val->bpf_prog.fd >= 0) {
+		prog = bpf_prog_get_type_dev(val->bpf_prog.fd,
 					     BPF_PROG_TYPE_XDP, false);
 		if (IS_ERR(prog))
 			goto err_put_dev;
@@ -622,10 +631,10 @@ static struct bpf_dtab_netdev *__dev_map_alloc_node(struct net *net,
 	dev->dtab = dtab;
 	if (prog) {
 		dev->xdp_prog = prog;
-		dev->val.bpf_prog_id = prog->aux->id;
+		dev->val.bpf_prog.id = prog->aux->id;
 	} else {
 		dev->xdp_prog = NULL;
-		dev->val.bpf_prog_id = 0;
+		dev->val.bpf_prog.id = 0;
 	}
 	dev->val.ifindex = val->ifindex;
 
@@ -643,7 +652,7 @@ static int __dev_map_update_elem(struct net *net, struct bpf_map *map,
 				 void *key, void *value, u64 map_flags)
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
-	struct bpf_devmap_val val = { .bpf_prog_fd = -1 };
+	struct bpf_devmap_val val = { .bpf_prog.fd = -1 };
 	struct bpf_dtab_netdev *dev, *old_dev;
 	u32 i = *(u32 *)key;
 
@@ -660,7 +669,7 @@ static int __dev_map_update_elem(struct net *net, struct bpf_map *map,
 	if (!val.ifindex) {
 		dev = NULL;
 		/* can not specify fd if ifindex is 0 */
-		if (val.bpf_prog_fd != -1)
+		if (val.bpf_prog.fd != -1)
 			return -EINVAL;
 	} else {
 		dev = __dev_map_alloc_node(net, dtab, &val, i);
@@ -690,7 +699,7 @@ static int __dev_map_hash_update_elem(struct net *net, struct bpf_map *map,
 				     void *key, void *value, u64 map_flags)
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
-	struct bpf_devmap_val val = { .bpf_prog_fd = -1 };
+	struct bpf_devmap_val val = { .bpf_prog.fd = -1 };
 	struct bpf_dtab_netdev *dev, *old_dev;
 	u32 idx = *(u32 *)key;
 	unsigned long flags;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 61ae81bf67de..970c44ecc472 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3628,15 +3628,6 @@ struct xdp_md {
 	__u32 egress_ifindex;  /* txq->dev->ifindex */
 };
 
-/* DEVMAP values */
-struct bpf_devmap_val {
-	__u32 ifindex;   /* device index */
-	union {
-		int   bpf_prog_fd;  /* prog fd on map write */
-		__u32 bpf_prog_id;  /* prog id on map read */
-	};
-};
-
 enum sk_action {
 	SK_DROP = 0,
 	SK_PASS,
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
index caeea19f2772..b72a696fc6a8 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
@@ -8,11 +8,19 @@
 
 #define IFINDEX_LO 1
 
+struct _bpf_devmap_val {
+	__u32 ifindex;   /* device index */
+	union {
+		int   fd;  /* prog fd on map write */
+		__u32 id;  /* prog id on map read */
+	} bpf_prog;
+};
+
 void test_xdp_with_devmap_helpers(void)
 {
 	struct test_xdp_with_devmap_helpers *skel;
 	struct bpf_prog_info info = {};
-	struct bpf_devmap_val val = {
+	struct _bpf_devmap_val val = {
 		.ifindex = IFINDEX_LO,
 	};
 	__u32 id, len = sizeof(info);
@@ -40,15 +48,15 @@ void test_xdp_with_devmap_helpers(void)
 	if (CHECK_FAIL(err))
 		goto out_close;
 
-	val.bpf_prog_fd = dm_fd;
+	val.bpf_prog.fd = dm_fd;
 	err = bpf_map_update_elem(map_fd, &idx, &val, 0);
 	CHECK(err, "Add program to devmap entry",
 	      "err %d errno %d\n", err, errno);
 
 	err = bpf_map_lookup_elem(map_fd, &id, &val);
 	CHECK(err, "Read devmap entry", "err %d errno %d\n", err, errno);
-	CHECK(info.id != val.bpf_prog_id, "Expected program id in devmap entry",
-	      "expected %u read %u\n", info.id, val.bpf_prog_id);
+	CHECK(info.id != val.bpf_prog.id, "Expected program id in devmap entry",
+	      "expected %u read %u\n", info.id, val.bpf_prog.id);
 
 	/* can not attach BPF_XDP_DEVMAP program to a device */
 	err = bpf_set_link_xdp_fd(IFINDEX_LO, dm_fd, XDP_FLAGS_SKB_MODE);
@@ -56,7 +64,7 @@ void test_xdp_with_devmap_helpers(void)
 	      "should have failed\n");
 
 	val.ifindex = 1;
-	val.bpf_prog_fd = bpf_program__fd(skel->progs.xdp_dummy_prog);
+	val.bpf_prog.fd = bpf_program__fd(skel->progs.xdp_dummy_prog);
 	err = bpf_map_update_elem(map_fd, &idx, &val, 0);
 	CHECK(err == 0, "Add non-BPF_XDP_DEVMAP program to devmap entry",
 	      "should have failed\n");
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c b/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c
index 645f7f415857..126f6de514a1 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c
@@ -3,10 +3,18 @@
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 
+struct _bpf_devmap_val {
+	__u32 ifindex;   /* device index */
+	union {
+		int   fd;  /* prog fd on map write */
+		__u32 id;  /* prog id on map read */
+	} bpf_prog;
+};
+
 struct {
 	__uint(type, BPF_MAP_TYPE_DEVMAP);
 	__uint(key_size, sizeof(__u32));
-	__uint(value_size, sizeof(struct bpf_devmap_val));
+	__uint(value_size, sizeof(struct _bpf_devmap_val));
 	__uint(max_entries, 4);
 } dm_ports SEC(".maps");
 


