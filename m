Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21BD35AF20
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 08:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfF3GvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 02:51:22 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63524 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726604AbfF3GvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 02:51:21 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5U6nD7V023452
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 23:51:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Z2DxznVsRgimNmcc4o9wSwdYfoY0Oi2Cb+VEz0qBsII=;
 b=O9t2g5KJuqVuKBi6EUyJ8/9mEXC+NvfhoNvBq3iy6mmKT+zSH4vkjiVJuD/bcI4S/KtS
 nfbY15sYuFwevcNhZDP8+3IAx2M6mqro4idQjpwwN5DKer6dv1lXrfZIapkeq++RjCOA
 Lue1mgeIgkp3ph4DOEI/nriHUSzt5yOH+pU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2te5gc25qh-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 23:51:19 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 29 Jun 2019 23:51:17 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id C736E8614EA; Sat, 29 Jun 2019 23:51:12 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <jakub.kicinski@netronome.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v4 bpf-next 1/4] libbpf: add perf buffer API
Date:   Sat, 29 Jun 2019 23:51:06 -0700
Message-ID: <20190630065109.1794420-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190630065109.1794420-1-andriin@fb.com>
References: <20190630065109.1794420-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-30_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906300090
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF_MAP_TYPE_PERF_EVENT_ARRAY map is often used to send data from BPF program
to user space for additional processing. libbpf already has very low-level API
to read single CPU perf buffer, bpf_perf_event_read_simple(), but it's hard to
use and requires a lot of code to set everything up. This patch adds
perf_buffer abstraction on top of it, abstracting setting up and polling
per-CPU logic into simple and convenient API, similar to what BCC provides.

perf_buffer__new() sets up per-CPU ring buffers and updates corresponding BPF
map entries. It accepts two user-provided callbacks: one for handling raw
samples and one for get notifications of lost samples due to buffer overflow.

perf_buffer__new_raw() is similar, but provides more control over how
perf events are set up (by accepting user-provided perf_event_attr), how
they are handled (perf_event_header pointer is passed directly to
user-provided callback), and on which CPUs ring buffers are created
(it's possible to provide a list of CPUs and corresponding map keys to
update). This API allows advanced users fuller control.

perf_buffer__poll() is used to fetch ring buffer data across all CPUs,
utilizing epoll instance.

perf_buffer__free() does corresponding clean up and unsets FDs from BPF map.

All APIs are not thread-safe. User should ensure proper locking/coordination if
used in multi-threaded set up.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c   | 366 +++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h   |  49 ++++++
 tools/lib/bpf/libbpf.map |   4 +
 3 files changed, 419 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index f8c7a7ecb35e..e2bf3eedd0ae 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -32,7 +32,9 @@
 #include <linux/limits.h>
 #include <linux/perf_event.h>
 #include <linux/ring_buffer.h>
+#include <sys/epoll.h>
 #include <sys/ioctl.h>
+#include <sys/mman.h>
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <sys/vfs.h>
@@ -4348,6 +4350,370 @@ bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
 	return ret;
 }
 
+struct perf_buffer;
+
+struct perf_buffer_params {
+	struct perf_event_attr *attr;
+	/* if event_cb is specified, it takes precendence */
+	perf_buffer_event_fn event_cb;
+	/* sample_cb and lost_cb are higher-level common-case callbacks */
+	perf_buffer_sample_fn sample_cb;
+	perf_buffer_lost_fn lost_cb;
+	void *ctx;
+	int cpu_cnt;
+	int *cpus;
+	int *map_keys;
+};
+
+struct perf_cpu_buf {
+	struct perf_buffer *pb;
+	void *base; /* mmap()'ed memory */
+	void *buf; /* for reconstructing segmented data */
+	size_t buf_size;
+	int fd;
+	int cpu;
+	int map_key;
+};
+
+struct perf_buffer {
+	perf_buffer_event_fn event_cb;
+	perf_buffer_sample_fn sample_cb;
+	perf_buffer_lost_fn lost_cb;
+	void *ctx; /* passed into callbacks */
+
+	size_t page_size;
+	size_t mmap_size;
+	struct perf_cpu_buf **cpu_bufs;
+	struct epoll_event *events;
+	int cpu_cnt;
+	int epoll_fd; /* perf event FD */
+	int map_fd; /* BPF_MAP_TYPE_PERF_EVENT_ARRAY BPF map FD */
+};
+
+static void perf_buffer__free_cpu_buf(struct perf_buffer *pb,
+				      struct perf_cpu_buf *cpu_buf)
+{
+	if (!cpu_buf)
+		return;
+	if (cpu_buf->base &&
+	    munmap(cpu_buf->base, pb->mmap_size + pb->page_size))
+		pr_warning("failed to munmap cpu_buf #%d\n", cpu_buf->cpu);
+	if (cpu_buf->fd >= 0) {
+		ioctl(cpu_buf->fd, PERF_EVENT_IOC_DISABLE, 0);
+		close(cpu_buf->fd);
+	}
+	free(cpu_buf->buf);
+	free(cpu_buf);
+}
+
+void perf_buffer__free(struct perf_buffer *pb)
+{
+	int i;
+
+	if (!pb)
+		return;
+	if (pb->cpu_bufs) {
+		for (i = 0; i < pb->cpu_cnt && pb->cpu_bufs[i]; i++) {
+			struct perf_cpu_buf *cpu_buf = pb->cpu_bufs[i];
+
+			bpf_map_delete_elem(pb->map_fd, &cpu_buf->map_key);
+			perf_buffer__free_cpu_buf(pb, cpu_buf);
+		}
+		free(pb->cpu_bufs);
+	}
+	if (pb->epoll_fd >= 0)
+		close(pb->epoll_fd);
+	free(pb->events);
+	free(pb);
+}
+
+static struct perf_cpu_buf *
+perf_buffer__open_cpu_buf(struct perf_buffer *pb, struct perf_event_attr *attr,
+			  int cpu, int map_key)
+{
+	struct perf_cpu_buf *cpu_buf;
+	char msg[STRERR_BUFSIZE];
+	int err;
+
+	cpu_buf = calloc(1, sizeof(*cpu_buf));
+	if (!cpu_buf)
+		return ERR_PTR(-ENOMEM);
+
+	cpu_buf->pb = pb;
+	cpu_buf->cpu = cpu;
+	cpu_buf->map_key = map_key;
+
+	cpu_buf->fd = syscall(__NR_perf_event_open, attr, -1 /* pid */, cpu,
+			      -1, PERF_FLAG_FD_CLOEXEC);
+	if (cpu_buf->fd < 0) {
+		err = -errno;
+		pr_warning("failed to open perf buffer event on cpu #%d: %s\n",
+			   cpu, libbpf_strerror_r(err, msg, sizeof(msg)));
+		goto error;
+	}
+
+	cpu_buf->base = mmap(NULL, pb->mmap_size + pb->page_size,
+			     PROT_READ | PROT_WRITE, MAP_SHARED,
+			     cpu_buf->fd, 0);
+	if (cpu_buf->base == MAP_FAILED) {
+		cpu_buf->base = NULL;
+		err = -errno;
+		pr_warning("failed to mmap perf buffer on cpu #%d: %s\n",
+			   cpu, libbpf_strerror_r(err, msg, sizeof(msg)));
+		goto error;
+	}
+
+	if (ioctl(cpu_buf->fd, PERF_EVENT_IOC_ENABLE, 0) < 0) {
+		err = -errno;
+		pr_warning("failed to enable perf buffer event on cpu #%d: %s\n",
+			   cpu, libbpf_strerror_r(err, msg, sizeof(msg)));
+		goto error;
+	}
+
+	return cpu_buf;
+
+error:
+	perf_buffer__free_cpu_buf(pb, cpu_buf);
+	return (struct perf_cpu_buf *)ERR_PTR(err);
+}
+
+static struct perf_buffer *__perf_buffer__new(int map_fd, size_t page_cnt,
+					      struct perf_buffer_params *p);
+
+struct perf_buffer *perf_buffer__new(int map_fd, size_t page_cnt,
+				     const struct perf_buffer_opts *opts)
+{
+	struct perf_buffer_params p = {};
+	struct perf_event_attr attr = {
+		.config = PERF_COUNT_SW_BPF_OUTPUT,
+		.type = PERF_TYPE_SOFTWARE,
+		.sample_type = PERF_SAMPLE_RAW,
+		.sample_period = 1,
+		.wakeup_events = 1,
+	};
+
+	p.attr = &attr;
+	p.sample_cb = opts ? opts->sample_cb : NULL;
+	p.lost_cb = opts ? opts->lost_cb : NULL;
+	p.ctx = opts ? opts->ctx : NULL;
+
+	return __perf_buffer__new(map_fd, page_cnt, &p);
+}
+
+struct perf_buffer *
+perf_buffer__new_raw(int map_fd, size_t page_cnt,
+		     const struct perf_buffer_raw_opts *opts)
+{
+	struct perf_buffer_params p = {};
+
+	p.attr = opts->attr;
+	p.event_cb = opts->event_cb;
+	p.ctx = opts->ctx;
+	p.cpu_cnt = opts->cpu_cnt;
+	p.cpus = opts->cpus;
+	p.map_keys = opts->map_keys;
+
+	return __perf_buffer__new(map_fd, page_cnt, &p);
+}
+
+static struct perf_buffer *__perf_buffer__new(int map_fd, size_t page_cnt,
+					      struct perf_buffer_params *p)
+{
+	struct bpf_map_info map = {};
+	char msg[STRERR_BUFSIZE];
+	struct perf_buffer *pb;
+	__u32 map_info_len;
+	int err, i;
+
+	if (page_cnt & (page_cnt - 1)) {
+		pr_warning("page count should be power of two, but is %zu\n",
+			   page_cnt);
+		return ERR_PTR(-EINVAL);
+	}
+
+	map_info_len = sizeof(map);
+	err = bpf_obj_get_info_by_fd(map_fd, &map, &map_info_len);
+	if (err) {
+		err = -errno;
+		pr_warning("failed to get map info for map FD %d: %s\n",
+			   map_fd, libbpf_strerror_r(err, msg, sizeof(msg)));
+		return ERR_PTR(err);
+	}
+
+	if (map.type != BPF_MAP_TYPE_PERF_EVENT_ARRAY) {
+		pr_warning("map '%s' should be BPF_MAP_TYPE_PERF_EVENT_ARRAY\n",
+			   map.name);
+		return ERR_PTR(-EINVAL);
+	}
+
+	pb = calloc(1, sizeof(*pb));
+	if (!pb)
+		return ERR_PTR(-ENOMEM);
+
+	pb->event_cb = p->event_cb;
+	pb->sample_cb = p->sample_cb;
+	pb->lost_cb = p->lost_cb;
+	pb->ctx = p->ctx;
+
+	pb->page_size = getpagesize();
+	pb->mmap_size = pb->page_size * page_cnt;
+	pb->map_fd = map_fd;
+
+	pb->epoll_fd = epoll_create1(EPOLL_CLOEXEC);
+	if (pb->epoll_fd < 0) {
+		err = -errno;
+		pr_warning("failed to create epoll instance: %s\n",
+			   libbpf_strerror_r(err, msg, sizeof(msg)));
+		goto error;
+	}
+
+	if (p->cpu_cnt > 0) {
+		pb->cpu_cnt = p->cpu_cnt;
+	} else {
+		pb->cpu_cnt = libbpf_num_possible_cpus();
+		if (pb->cpu_cnt < 0) {
+			err = pb->cpu_cnt;
+			goto error;
+		}
+		if (map.max_entries < pb->cpu_cnt)
+			pb->cpu_cnt = map.max_entries;
+	}
+
+	pb->events = calloc(pb->cpu_cnt, sizeof(*pb->events));
+	if (!pb->events) {
+		err = -ENOMEM;
+		pr_warning("failed to allocate events: out of memory\n");
+		goto error;
+	}
+	pb->cpu_bufs = calloc(pb->cpu_cnt, sizeof(*pb->cpu_bufs));
+	if (!pb->cpu_bufs) {
+		err = -ENOMEM;
+		pr_warning("failed to allocate buffers: out of memory\n");
+		goto error;
+	}
+
+	for (i = 0; i < pb->cpu_cnt; i++) {
+		struct perf_cpu_buf *cpu_buf;
+		int cpu, map_key;
+
+		cpu = p->cpu_cnt > 0 ? p->cpus[i] : i;
+		map_key = p->cpu_cnt > 0 ? p->map_keys[i] : i;
+
+		cpu_buf = perf_buffer__open_cpu_buf(pb, p->attr, cpu, map_key);
+		if (IS_ERR(cpu_buf)) {
+			err = PTR_ERR(cpu_buf);
+			goto error;
+		}
+
+		pb->cpu_bufs[i] = cpu_buf;
+
+		err = bpf_map_update_elem(pb->map_fd, &map_key,
+					  &cpu_buf->fd, 0);
+		if (err) {
+			err = -errno;
+			pr_warning("failed to set cpu #%d, key %d -> perf FD %d: %s\n",
+				   cpu, map_key, cpu_buf->fd,
+				   libbpf_strerror_r(err, msg, sizeof(msg)));
+			goto error;
+		}
+
+		pb->events[i].events = EPOLLIN;
+		pb->events[i].data.ptr = cpu_buf;
+		if (epoll_ctl(pb->epoll_fd, EPOLL_CTL_ADD, cpu_buf->fd,
+			      &pb->events[i]) < 0) {
+			err = -errno;
+			pr_warning("failed to epoll_ctl cpu #%d perf FD %d: %s\n",
+				   cpu, cpu_buf->fd,
+				   libbpf_strerror_r(err, msg, sizeof(msg)));
+			goto error;
+		}
+	}
+
+	return pb;
+
+error:
+	if (pb)
+		perf_buffer__free(pb);
+	return ERR_PTR(err);
+}
+
+struct perf_sample_raw {
+	struct perf_event_header header;
+	uint32_t size;
+	char data[0];
+};
+
+struct perf_sample_lost {
+	struct perf_event_header header;
+	uint64_t id;
+	uint64_t lost;
+	uint64_t sample_id;
+};
+
+static enum bpf_perf_event_ret
+perf_buffer__process_record(struct perf_event_header *e, void *ctx)
+{
+	struct perf_cpu_buf *cpu_buf = ctx;
+	struct perf_buffer *pb = cpu_buf->pb;
+	void *data = e;
+
+	/* user wants full control over parsing perf event */
+	if (pb->event_cb)
+		return pb->event_cb(pb->ctx, cpu_buf->cpu, e);
+
+	switch (e->type) {
+	case PERF_RECORD_SAMPLE: {
+		struct perf_sample_raw *s = data;
+
+		if (pb->sample_cb)
+			pb->sample_cb(pb->ctx, cpu_buf->cpu, s->data, s->size);
+		break;
+	}
+	case PERF_RECORD_LOST: {
+		struct perf_sample_lost *s = data;
+
+		if (pb->lost_cb)
+			pb->lost_cb(pb->ctx, cpu_buf->cpu, s->lost);
+		break;
+	}
+	default:
+		pr_warning("unknown perf sample type %d\n", e->type);
+		return LIBBPF_PERF_EVENT_ERROR;
+	}
+	return LIBBPF_PERF_EVENT_CONT;
+}
+
+static int perf_buffer__process_records(struct perf_buffer *pb,
+					struct perf_cpu_buf *cpu_buf)
+{
+	enum bpf_perf_event_ret ret;
+
+	ret = bpf_perf_event_read_simple(cpu_buf->base, pb->mmap_size,
+					 pb->page_size, &cpu_buf->buf,
+					 &cpu_buf->buf_size,
+					 perf_buffer__process_record, cpu_buf);
+	if (ret != LIBBPF_PERF_EVENT_CONT)
+		return ret;
+	return 0;
+}
+
+int perf_buffer__poll(struct perf_buffer *pb, int timeout_ms)
+{
+	int cnt, err;
+
+	cnt = epoll_wait(pb->epoll_fd, pb->events, pb->cpu_cnt, timeout_ms);
+	for (int i = 0; i < cnt; i++) {
+		struct perf_cpu_buf *cpu_buf = pb->events[i].data.ptr;
+
+		err = perf_buffer__process_records(pb, cpu_buf);
+		if (err) {
+			pr_warning("error while processing records: %d\n", err);
+			return err;
+		}
+	}
+	return cnt < 0 ? -errno : cnt;
+}
+
 struct bpf_prog_info_array_desc {
 	int	array_offset;	/* e.g. offset of jited_prog_insns */
 	int	count_offset;	/* e.g. offset of jited_prog_len */
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index f55933784f95..5cbf459ece0b 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -358,6 +358,26 @@ LIBBPF_API int bpf_prog_load(const char *file, enum bpf_prog_type type,
 LIBBPF_API int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags);
 LIBBPF_API int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags);
 
+struct perf_buffer;
+
+typedef void (*perf_buffer_sample_fn)(void *ctx, int cpu,
+				      void *data, __u32 size);
+typedef void (*perf_buffer_lost_fn)(void *ctx, int cpu, __u64 cnt);
+
+/* common use perf buffer options */
+struct perf_buffer_opts {
+	/* if specified, sample_cb is called for each sample */
+	perf_buffer_sample_fn sample_cb;
+	/* if specified, lost_cb is called for each batch of lost samples */
+	perf_buffer_lost_fn lost_cb;
+	/* ctx is provided to sample_cb and lost_cb */
+	void *ctx;
+};
+
+LIBBPF_API struct perf_buffer *
+perf_buffer__new(int map_fd, size_t page_cnt,
+		 const struct perf_buffer_opts *opts);
+
 enum bpf_perf_event_ret {
 	LIBBPF_PERF_EVENT_DONE	= 0,
 	LIBBPF_PERF_EVENT_ERROR	= -1,
@@ -365,6 +385,35 @@ enum bpf_perf_event_ret {
 };
 
 struct perf_event_header;
+
+typedef enum bpf_perf_event_ret
+(*perf_buffer_event_fn)(void *ctx, int cpu, struct perf_event_header *event);
+
+/* raw perf buffer options, giving most power and control */
+struct perf_buffer_raw_opts {
+	/* perf event attrs passed directly into perf_event_open() */
+	struct perf_event_attr *attr;
+	/* raw event callback */
+	perf_buffer_event_fn event_cb;
+	/* ctx is provided to event_cb */
+	void *ctx;
+	/* if cpu_cnt == 0, open all on all possible CPUs (up to the number of
+	 * max_entries of given PERF_EVENT_ARRAY map)
+	 */
+	int cpu_cnt;
+	/* if cpu_cnt > 0, cpus is an array of CPUs to open ring buffers on */
+	int *cpus;
+	/* if cpu_cnt > 0, map_keys specify map keys to set per-CPU FDs for */
+	int *map_keys;
+};
+
+LIBBPF_API struct perf_buffer *
+perf_buffer__new_raw(int map_fd, size_t page_cnt,
+		     const struct perf_buffer_raw_opts *opts);
+
+LIBBPF_API void perf_buffer__free(struct perf_buffer *pb);
+LIBBPF_API int perf_buffer__poll(struct perf_buffer *pb, int timeout_ms);
+
 typedef enum bpf_perf_event_ret
 	(*bpf_perf_event_print_t)(struct perf_event_header *hdr,
 				  void *private_data);
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index e6b7d4edbc93..f9d316e873d8 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -179,4 +179,8 @@ LIBBPF_0.0.4 {
 		btf_dump__new;
 		btf__parse_elf;
 		libbpf_num_possible_cpus;
+		perf_buffer__free;
+		perf_buffer__new;
+		perf_buffer__new_raw;
+		perf_buffer__poll;
 } LIBBPF_0.0.3;
-- 
2.17.1

