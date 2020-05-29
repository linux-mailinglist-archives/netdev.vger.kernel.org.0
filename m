Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793D41E777B
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 09:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725355AbgE2Hyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 03:54:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35562 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725795AbgE2Hys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 03:54:48 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04T7pomF006037
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 00:54:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=JhL4E5L6lTzWtd1ubpOI+g08Du7A2fV9/crUJe5s1QQ=;
 b=AdyBaEmG3MrJKVhrY7D0viMX6MJmYhXU7nKz98mTG04quXMmKb3rV4/e62k4QawfzrXw
 UVHORYavBLgGWoIyGTZU/iEVgAuTgmnbQPDDOY8P+sdIBEA3nlqV56ue/gX4ZCFP4rG7
 5VmzuiOfEzpcABpNbopB0ILdFdxGQ1XQlHQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 319yh609d2-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 00:54:47 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 29 May 2020 00:54:46 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 1B74B2EC3747; Fri, 29 May 2020 00:54:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 2/5] libbpf: add BPF ring buffer support
Date:   Fri, 29 May 2020 00:54:21 -0700
Message-ID: <20200529075424.3139988-3-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200529075424.3139988-1-andriin@fb.com>
References: <20200529075424.3139988-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-29_02:2020-05-28,2020-05-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 bulkscore=0
 mlxlogscore=928 impostorscore=0 spamscore=0 phishscore=0 mlxscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 suspectscore=25
 lowpriorityscore=0 cotscore=-2147483648 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005290062
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Declaring and instantiating BPF ring buffer doesn't require any changes t=
o
libbpf, as it's just another type of maps. So using existing BTF-defined =
maps
syntax with __uint(type, BPF_MAP_TYPE_RINGBUF) and __uint(max_elements,
<size-of-ring-buf>) is all that's necessary to create and use BPF ring bu=
ffer.

This patch adds BPF ring buffer consumer to libbpf. It is very similar to
perf_buffer implementation in terms of API, but also attempts to fix some
minor problems and inconveniences with existing perf_buffer API.

ring_buffer support both single ring buffer use case (with just using
ring_buffer__new()), as well as allows to add more ring buffers, each wit=
h its
own callback and context. This allows to efficiently poll and consume
multiple, potentially completely independent, ring buffers, using single
epoll instance.

The latter is actually a problem in practice for applications
that are using multiple sets of perf buffers. They have to create multipl=
e
instances for struct perf_buffer and poll them independently or in a loop=
,
each approach having its own problems (e.g., inability to use a common po=
ll
timeout). struct ring_buffer eliminates this problem by aggregating many
independent ring buffer instances under the single "ring buffer manager".

Second, perf_buffer's callback can't return error, so applications that n=
eed
to stop polling due to error in data or data signalling the end, have to =
use
extra mechanisms to signal that polling has to stop. ring_buffer's callba=
ck
can return error, which will be passed through back to user code and can =
be
acted upon appropariately.

Two APIs allow to consume ring buffer data:
  - ring_buffer__poll(), which will wait for data availability notificati=
on
    and will consume data only from reported ring buffer(s); this API all=
ows
    to efficiently use resources by reading data only when it becomes
    available;
  - ring_buffer__consume(), will attempt to read new records regardless o=
f
    data availablity notification sub-system. This API is useful for case=
s
    when lowest latency is required, in expense of burning CPU resources.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/Build           |   2 +-
 tools/lib/bpf/libbpf.h        |  21 +++
 tools/lib/bpf/libbpf.map      |   5 +
 tools/lib/bpf/libbpf_probes.c |   5 +
 tools/lib/bpf/ringbuf.c       | 285 ++++++++++++++++++++++++++++++++++
 5 files changed, 317 insertions(+), 1 deletion(-)
 create mode 100644 tools/lib/bpf/ringbuf.c

diff --git a/tools/lib/bpf/Build b/tools/lib/bpf/Build
index e3962cfbc9a6..190366d05588 100644
--- a/tools/lib/bpf/Build
+++ b/tools/lib/bpf/Build
@@ -1,3 +1,3 @@
 libbpf-y :=3D libbpf.o bpf.o nlattr.o btf.o libbpf_errno.o str_error.o \
 	    netlink.o bpf_prog_linfo.o libbpf_probes.o xsk.o hashmap.o \
-	    btf_dump.o
+	    btf_dump.o ringbuf.o
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 1e2e399a5f2c..8528a02d5af8 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -478,6 +478,27 @@ LIBBPF_API int bpf_get_link_xdp_id(int ifindex, __u3=
2 *prog_id, __u32 flags);
 LIBBPF_API int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *=
info,
 				     size_t info_size, __u32 flags);
=20
+/* Ring buffer APIs */
+struct ring_buffer;
+
+typedef int (*ring_buffer_sample_fn)(void *ctx, void *data, size_t size)=
;
+
+struct ring_buffer_opts {
+	size_t sz; /* size of this struct, for forward/backward compatiblity */
+};
+
+#define ring_buffer_opts__last_field sz
+
+LIBBPF_API struct ring_buffer *
+ring_buffer__new(int map_fd, ring_buffer_sample_fn sample_cb, void *ctx,
+		 const struct ring_buffer_opts *opts);
+LIBBPF_API void ring_buffer__free(struct ring_buffer *rb);
+LIBBPF_API int ring_buffer__add(struct ring_buffer *rb, int map_fd,
+				ring_buffer_sample_fn sample_cb, void *ctx);
+LIBBPF_API int ring_buffer__poll(struct ring_buffer *rb, int timeout_ms)=
;
+LIBBPF_API int ring_buffer__consume(struct ring_buffer *rb);
+
+/* Perf buffer APIs */
 struct perf_buffer;
=20
 typedef void (*perf_buffer_sample_fn)(void *ctx, int cpu,
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 381a7342ecfc..c18860200abb 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -263,4 +263,9 @@ LIBBPF_0.0.9 {
 		bpf_link_get_next_id;
 		bpf_program__attach_iter;
 		perf_buffer__consume;
+		ring_buffer__add;
+		ring_buffer__consume;
+		ring_buffer__free;
+		ring_buffer__new;
+		ring_buffer__poll;
 } LIBBPF_0.0.8;
diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.=
c
index 2c92059c0c90..10cd8d1891f5 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -238,6 +238,11 @@ bool bpf_probe_map_type(enum bpf_map_type map_type, =
__u32 ifindex)
 		if (btf_fd < 0)
 			return false;
 		break;
+	case BPF_MAP_TYPE_RINGBUF:
+		key_size =3D 0;
+		value_size =3D 0;
+		max_entries =3D 4096;
+		break;
 	case BPF_MAP_TYPE_UNSPEC:
 	case BPF_MAP_TYPE_HASH:
 	case BPF_MAP_TYPE_ARRAY:
diff --git a/tools/lib/bpf/ringbuf.c b/tools/lib/bpf/ringbuf.c
new file mode 100644
index 000000000000..bc10fa1d43c7
--- /dev/null
+++ b/tools/lib/bpf/ringbuf.c
@@ -0,0 +1,285 @@
+// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+/*
+ * Ring buffer operations.
+ *
+ * Copyright (C) 2020 Facebook, Inc.
+ */
+#include <stdlib.h>
+#include <stdio.h>
+#include <errno.h>
+#include <unistd.h>
+#include <linux/err.h>
+#include <linux/bpf.h>
+#include <asm/barrier.h>
+#include <sys/mman.h>
+#include <sys/epoll.h>
+#include <tools/libc_compat.h>
+
+#include "libbpf.h"
+#include "libbpf_internal.h"
+#include "bpf.h"
+
+/* make sure libbpf doesn't use kernel-only integer typedefs */
+#pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
+
+struct ring {
+	ring_buffer_sample_fn sample_cb;
+	void *ctx;
+	void *data;
+	unsigned long *consumer_pos;
+	unsigned long *producer_pos;
+	unsigned long mask;
+	int map_fd;
+};
+
+struct ring_buffer {
+	struct epoll_event *events;
+	struct ring *rings;
+	size_t page_size;
+	int epoll_fd;
+	int ring_cnt;
+};
+
+static void ringbuf_unmap_ring(struct ring_buffer *rb, struct ring *r)
+{
+	if (r->consumer_pos) {
+		munmap(r->consumer_pos, rb->page_size);
+		r->consumer_pos =3D NULL;
+	}
+	if (r->producer_pos) {
+		munmap(r->producer_pos, rb->page_size + 2 * (r->mask + 1));
+		r->producer_pos =3D NULL;
+	}
+}
+
+/* Add extra RINGBUF maps to this ring buffer manager */
+int ring_buffer__add(struct ring_buffer *rb, int map_fd,
+		     ring_buffer_sample_fn sample_cb, void *ctx)
+{
+	struct bpf_map_info info;
+	__u32 len =3D sizeof(info);
+	struct epoll_event *e;
+	struct ring *r;
+	void *tmp;
+	int err;
+
+	memset(&info, 0, sizeof(info));
+
+	err =3D bpf_obj_get_info_by_fd(map_fd, &info, &len);
+	if (err) {
+		err =3D -errno;
+		pr_warn("ringbuf: failed to get map info for fd=3D%d: %d\n",
+			map_fd, err);
+		return err;
+	}
+
+	if (info.type !=3D BPF_MAP_TYPE_RINGBUF) {
+		pr_warn("ringbuf: map fd=3D%d is not BPF_MAP_TYPE_RINGBUF\n",
+			map_fd);
+		return -EINVAL;
+	}
+
+	tmp =3D reallocarray(rb->rings, rb->ring_cnt + 1, sizeof(*rb->rings));
+	if (!tmp)
+		return -ENOMEM;
+	rb->rings =3D tmp;
+
+	tmp =3D reallocarray(rb->events, rb->ring_cnt + 1, sizeof(*rb->events))=
;
+	if (!tmp)
+		return -ENOMEM;
+	rb->events =3D tmp;
+
+	r =3D &rb->rings[rb->ring_cnt];
+	memset(r, 0, sizeof(*r));
+
+	r->map_fd =3D map_fd;
+	r->sample_cb =3D sample_cb;
+	r->ctx =3D ctx;
+	r->mask =3D info.max_entries - 1;
+
+	/* Map writable consumer page */
+	tmp =3D mmap(NULL, rb->page_size, PROT_READ | PROT_WRITE, MAP_SHARED,
+		   map_fd, 0);
+	if (tmp =3D=3D MAP_FAILED) {
+		err =3D -errno;
+		pr_warn("ringbuf: failed to mmap consumer page for map fd=3D%d: %d\n",
+			map_fd, err);
+		return err;
+	}
+	r->consumer_pos =3D tmp;
+
+	/* Map read-only producer page and data pages. We map twice as big
+	 * data size to allow simple reading of samples that wrap around the
+	 * end of a ring buffer. See kernel implementation for details.
+	 * */
+	tmp =3D mmap(NULL, rb->page_size + 2 * info.max_entries, PROT_READ,
+		   MAP_SHARED, map_fd, rb->page_size);
+	if (tmp =3D=3D MAP_FAILED) {
+		err =3D -errno;
+		ringbuf_unmap_ring(rb, r);
+		pr_warn("ringbuf: failed to mmap data pages for map fd=3D%d: %d\n",
+			map_fd, err);
+		return err;
+	}
+	r->producer_pos =3D tmp;
+	r->data =3D tmp + rb->page_size;
+
+	e =3D &rb->events[rb->ring_cnt];
+	memset(e, 0, sizeof(*e));
+
+	e->events =3D EPOLLIN;
+	e->data.fd =3D rb->ring_cnt;
+	if (epoll_ctl(rb->epoll_fd, EPOLL_CTL_ADD, map_fd, e) < 0) {
+		err =3D -errno;
+		ringbuf_unmap_ring(rb, r);
+		pr_warn("ringbuf: failed to epoll add map fd=3D%d: %d\n",
+			map_fd, err);
+		return err;
+	}
+
+	rb->ring_cnt++;
+	return 0;
+}
+
+void ring_buffer__free(struct ring_buffer *rb)
+{
+	int i;
+
+	if (!rb)
+		return;
+
+	for (i =3D 0; i < rb->ring_cnt; ++i)
+		ringbuf_unmap_ring(rb, &rb->rings[i]);
+	if (rb->epoll_fd >=3D 0)
+		close(rb->epoll_fd);
+
+	free(rb->events);
+	free(rb->rings);
+	free(rb);
+}
+
+struct ring_buffer *
+ring_buffer__new(int map_fd, ring_buffer_sample_fn sample_cb, void *ctx,
+		 const struct ring_buffer_opts *opts)
+{
+	struct ring_buffer *rb;
+	int err;
+
+	if (!OPTS_VALID(opts, ring_buffer_opts))
+		return NULL;
+
+	rb =3D calloc(1, sizeof(*rb));
+	if (!rb)
+		return NULL;
+
+	rb->page_size =3D getpagesize();
+
+	rb->epoll_fd =3D epoll_create1(EPOLL_CLOEXEC);
+	if (rb->epoll_fd < 0) {
+		err =3D -errno;
+		pr_warn("ringbuf: failed to create epoll instance: %d\n", err);
+		goto err_out;
+	}
+
+	err =3D ring_buffer__add(rb, map_fd, sample_cb, ctx);
+	if (err)
+		goto err_out;
+
+	return rb;
+
+err_out:
+	ring_buffer__free(rb);
+	return NULL;
+}
+
+static inline int roundup_len(__u32 len)
+{
+	/* clear out top 2 bits (discard and busy, if set) */
+	len <<=3D 2;
+	len >>=3D 2;
+	/* add length prefix */
+	len +=3D BPF_RINGBUF_HDR_SZ;
+	/* round up to 8 byte alignment */
+	return (len + 7) / 8 * 8;
+}
+
+static int ringbuf_process_ring(struct ring* r)
+{
+	int *len_ptr, len, err, cnt =3D 0;
+	unsigned long cons_pos, prod_pos;
+	bool got_new_data;
+	void *sample;
+
+	cons_pos =3D smp_load_acquire(r->consumer_pos);
+	do {
+		got_new_data =3D false;
+		prod_pos =3D smp_load_acquire(r->producer_pos);
+		while (cons_pos < prod_pos) {
+			len_ptr =3D r->data + (cons_pos & r->mask);
+			len =3D smp_load_acquire(len_ptr);
+
+			/* sample not committed yet, bail out for now */
+			if (len & BPF_RINGBUF_BUSY_BIT)
+				goto done;
+
+			got_new_data =3D true;
+			cons_pos +=3D roundup_len(len);
+
+			if ((len & BPF_RINGBUF_DISCARD_BIT) =3D=3D 0) {
+				sample =3D (void *)len_ptr + BPF_RINGBUF_HDR_SZ;
+				err =3D r->sample_cb(r->ctx, sample, len);
+				if (err) {
+					/* update consumer pos and bail out */
+					smp_store_release(r->consumer_pos,
+							  cons_pos);
+					return err;
+				}
+				cnt++;
+			}
+
+			smp_store_release(r->consumer_pos, cons_pos);
+		}
+	} while (got_new_data);
+done:
+	return cnt;
+}
+
+/* Consume available ring buffer(s) data without event polling.
+ * Returns number of records consumed across all registered ring buffers=
, or
+ * negative number if any of the callbacks return error.
+ */
+int ring_buffer__consume(struct ring_buffer *rb)
+{
+	int i, err, res =3D 0;
+
+	for (i =3D 0; i < rb->ring_cnt; i++) {
+		struct ring *ring =3D &rb->rings[i];
+
+		err =3D ringbuf_process_ring(ring);
+		if (err < 0)
+			return err;
+		res +=3D err;
+	}
+	return res;
+}
+
+/* Poll for available data and consume records, if any are available.
+ * Returns number of records consumed, or negative number, if any of the
+ * registered callbacks returned error.
+ */
+int ring_buffer__poll(struct ring_buffer *rb, int timeout_ms)
+{
+	int i, cnt, err, res =3D 0;
+
+	cnt =3D epoll_wait(rb->epoll_fd, rb->events, rb->ring_cnt, timeout_ms);
+	for (i =3D 0; i < cnt; i++) {
+		__u32 ring_id =3D rb->events[i].data.fd;
+		struct ring *ring =3D &rb->rings[ring_id];
+
+		err =3D ringbuf_process_ring(ring);
+		if (err < 0)
+			return err;
+		res +=3D cnt;
+	}
+	return cnt < 0 ? -errno : res;
+}
--=20
2.24.1

