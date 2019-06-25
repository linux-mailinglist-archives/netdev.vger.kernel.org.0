Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 371F355C44
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 01:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfFYX03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 19:26:29 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56526 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726369AbfFYX03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 19:26:29 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5PNNhae021514
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 16:26:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=n0cLbckLnuL9BrZ7N5JtzR/HNfjgiILuQ9zQxZoL+6Y=;
 b=Gtp2ImmzVbXOh8UP6IdQQktOEEhTCIB0IuAm3F/lDyuRJXY+6yktvqRR8KVz5qJl+Fgn
 X2/TGSW1HMPTXHp3qM2iOfFZZU2VOun2grTb1uc63Rpt8Mld6gIdOwis06WemEtJDpmN
 T7YDn37/RhbC12t+fgNMA7LcBZuK2LPRyGI= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tbv1f09cg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 16:26:27 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 25 Jun 2019 16:26:25 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id B7788861829; Tue, 25 Jun 2019 16:26:24 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 1/2] libbpf: add perf buffer reading API
Date:   Tue, 25 Jun 2019 16:26:00 -0700
Message-ID: <20190625232601.3227055-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190625232601.3227055-1-andriin@fb.com>
References: <20190625232601.3227055-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-25_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906250191
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

perf_buffer__poll() is used to fetch ring buffer data across all CPUs,
utilizing epoll instance.

perf_buffer__free() does corresponding clean up and unsets FDs from BPF map.

All APIs are not thread-safe. User should ensure proper locking/coordination if
used in multi-threaded set up.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c   | 282 +++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h   |  12 ++
 tools/lib/bpf/libbpf.map |   5 +-
 3 files changed, 298 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 9a4199b51300..c74cc535902a 100644
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
@@ -4322,6 +4324,286 @@ bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
 	return ret;
 }
 
+struct perf_cpu_buf {
+	int fd;
+	void *base; /* mmap()'ed memory */
+	void *buf; /* for reconstructing segmented data */
+	size_t buf_size;
+};
+
+struct perf_buffer {
+	perf_buffer_sample_fn sample_cb;
+	perf_buffer_lost_fn lost_cb;
+	void *ctx; /* passed into callbacks */
+
+	size_t page_size;
+	size_t mmap_size;
+	struct perf_cpu_buf **cpu_bufs;
+	struct epoll_event *events;
+	int cpu_cnt;
+	int epfd; /* perf event FD */
+	int mapfd; /* BPF_MAP_TYPE_PERF_EVENT_ARRAY BPF map FD */
+};
+
+static void perf_buffer__free_cpu_buf(struct perf_buffer *pb,
+				      struct perf_cpu_buf *cpu_buf, int cpu)
+{
+	if (!cpu_buf)
+		return;
+	if (cpu_buf->base &&
+	    munmap(cpu_buf->base, pb->mmap_size + pb->page_size))
+		pr_warning("failed to munmap cpu_buf #%d\n", cpu);
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
+			bpf_map_delete_elem(pb->mapfd, &i);
+			perf_buffer__free_cpu_buf(pb, cpu_buf, i);
+		}
+		free(pb->cpu_bufs);
+	}
+	if (pb->epfd >= 0)
+		close(pb->epfd);
+	free(pb->events);
+	free(pb);
+}
+
+static struct perf_cpu_buf *perf_buffer__open_cpu_buf(struct perf_buffer *pb,
+						      int cpu)
+{
+	struct perf_event_attr attr = {};
+	struct perf_cpu_buf *cpu_buf;
+	char msg[STRERR_BUFSIZE];
+	int err;
+
+	cpu_buf = calloc(1, sizeof(*cpu_buf));
+	if (!cpu_buf)
+		return ERR_PTR(-ENOMEM);
+
+	attr.config = PERF_COUNT_SW_BPF_OUTPUT;
+	attr.type = PERF_TYPE_SOFTWARE;
+	attr.sample_type = PERF_SAMPLE_RAW;
+	attr.sample_period = 1;
+	attr.wakeup_events = 1;
+	cpu_buf->fd = syscall(__NR_perf_event_open, &attr, -1 /* pid */, cpu,
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
+	perf_buffer__free_cpu_buf(pb, cpu_buf, cpu);
+	return (struct perf_cpu_buf *)ERR_PTR(err);
+}
+
+struct perf_buffer *perf_buffer__new(struct bpf_map *map, size_t page_cnt,
+				     perf_buffer_sample_fn sample_cb,
+				     perf_buffer_lost_fn lost_cb, void *ctx)
+{
+	char msg[STRERR_BUFSIZE];
+	struct perf_buffer *pb;
+	int err, cpu;
+
+	if (bpf_map__def(map)->type != BPF_MAP_TYPE_PERF_EVENT_ARRAY) {
+		pr_warning("map '%s' should be BPF_MAP_TYPE_PERF_EVENT_ARRAY\n",
+			   bpf_map__name(map));
+		return ERR_PTR(-EINVAL);
+	}
+	if (bpf_map__fd(map) < 0) {
+		pr_warning("map '%s' doesn't have associated FD\n",
+			   bpf_map__name(map));
+		return ERR_PTR(-EINVAL);
+	}
+	if (page_cnt & (page_cnt - 1)) {
+		pr_warning("page count should be power of two, but is %zu\n",
+			   page_cnt);
+		return ERR_PTR(-EINVAL);
+	}
+
+	pb = calloc(1, sizeof(*pb));
+	if (!pb)
+		return ERR_PTR(-ENOMEM);
+
+	pb->sample_cb = sample_cb;
+	pb->lost_cb = lost_cb;
+	pb->ctx = ctx;
+	pb->page_size = getpagesize();
+	pb->mmap_size = pb->page_size * page_cnt;
+	pb->mapfd = bpf_map__fd(map);
+
+	pb->epfd = epoll_create1(EPOLL_CLOEXEC);
+	if (pb->epfd < 0) {
+		err = -errno;
+		pr_warning("failed to create epoll instance: %s\n",
+			   libbpf_strerror_r(err, msg, sizeof(msg)));
+		goto error;
+	}
+
+	pb->cpu_cnt = libbpf_num_possible_cpus();
+	if (pb->cpu_cnt < 0) {
+		err = pb->cpu_cnt;
+		goto error;
+	}
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
+	for (cpu = 0; cpu < pb->cpu_cnt; cpu++) {
+		struct perf_cpu_buf *cpu_buf;
+
+		cpu_buf = perf_buffer__open_cpu_buf(pb, cpu);
+		if (IS_ERR(cpu_buf)) {
+			err = PTR_ERR(cpu_buf);
+			goto error;
+		}
+
+		pb->cpu_bufs[cpu] = cpu_buf;
+
+		err = bpf_map_update_elem(pb->mapfd, &cpu, &cpu_buf->fd, 0);
+		if (err) {
+			pr_warning("failed to set cpu #%d perf FD %d: %s\n",
+				   cpu, cpu_buf->fd,
+				   libbpf_strerror_r(err, msg, sizeof(msg)));
+			goto error;
+		}
+
+		pb->events[cpu].events = EPOLLIN;
+		pb->events[cpu].data.ptr = cpu_buf;
+		if (epoll_ctl(pb->epfd, EPOLL_CTL_ADD, cpu_buf->fd,
+			      &pb->events[cpu]) < 0) {
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
+	struct perf_buffer *pb = ctx;
+	void *data = e;
+
+	switch (e->type) {
+	case PERF_RECORD_SAMPLE: {
+		struct perf_sample_raw *s = data;
+
+		pb->sample_cb(pb->ctx, s->data, s->size);
+		break;
+	}
+	case PERF_RECORD_LOST: {
+		struct perf_sample_lost *s = data;
+
+		if (pb->lost_cb)
+			pb->lost_cb(pb->ctx, s->lost);
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
+					 perf_buffer__process_record, pb);
+	if (ret != LIBBPF_PERF_EVENT_CONT)
+		return ret;
+	return 0;
+}
+
+int perf_buffer__poll(struct perf_buffer *pb, int timeout_ms)
+{
+	int cnt, err;
+
+	cnt = epoll_wait(pb->epfd, pb->events, pb->cpu_cnt, timeout_ms);
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
index bf7020a565c6..3bfde1a475ce 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -354,6 +354,18 @@ LIBBPF_API int bpf_prog_load(const char *file, enum bpf_prog_type type,
 LIBBPF_API int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags);
 LIBBPF_API int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags);
 
+struct perf_buffer;
+typedef void (*perf_buffer_sample_fn)(void *ctx, void *data, __u32 size);
+typedef void (*perf_buffer_lost_fn)(void *ctx, __u64 cnt);
+
+LIBBPF_API struct perf_buffer *perf_buffer__new(struct bpf_map *map,
+						size_t page_cnt,
+						perf_buffer_sample_fn sample_cb,
+						perf_buffer_lost_fn lost_cb,
+						void *ctx);
+LIBBPF_API void perf_buffer__free(struct perf_buffer *pb);
+LIBBPF_API int perf_buffer__poll(struct perf_buffer *pb, int timeout_ms);
+
 enum bpf_perf_event_ret {
 	LIBBPF_PERF_EVENT_DONE	= 0,
 	LIBBPF_PERF_EVENT_ERROR	= -1,
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 2382fbda4cbb..10f48103110a 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -170,13 +170,16 @@ LIBBPF_0.0.4 {
 		btf_dump__dump_type;
 		btf_dump__free;
 		btf_dump__new;
-		btf__parse_elf;
 		bpf_object__load_xattr;
 		bpf_program__attach_kprobe;
 		bpf_program__attach_perf_event;
 		bpf_program__attach_raw_tracepoint;
 		bpf_program__attach_tracepoint;
 		bpf_program__attach_uprobe;
+		btf__parse_elf;
 		libbpf_num_possible_cpus;
 		libbpf_perf_event_disable_and_close;
+		perf_buffer__free;
+		perf_buffer__new;
+		perf_buffer__poll;
 } LIBBPF_0.0.3;
-- 
2.17.1

