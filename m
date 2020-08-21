Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6313624DC8B
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 19:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbgHUREX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 13:04:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41912 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728086AbgHURAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 13:00:08 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07LH03JW029283
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 10:00:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=G5Fkq7EiMfy5fUe1Mrwvp1yz3IX7aI3/tzTCH9ax9fQ=;
 b=IT1V582t9sRQTgiOwayis3biDWNxA267Ofmd4wUcgVuQDDVXK86laqdTHNXfgzXqI1bW
 HJOXfazIMXJ/z4CxvRo3uqtaniHbWdRHXbo0jgD29kxMzfnKz7Sx47wilqE9ebGiuHKv
 ADawoJdjZHQePuE9Yx2CIYheslGpvpRUWvw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 332gp80k3t-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 10:00:03 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 21 Aug 2020 09:59:30 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 8CE712EC5FE8; Fri, 21 Aug 2020 09:59:29 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alan Maguire <alan.maguire@oracle.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next] libbpf: add perf_buffer APIs for better integration with outside epoll loop
Date:   Fri, 21 Aug 2020 09:59:27 -0700
Message-ID: <20200821165927.849538-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_08:2020-08-21,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=25 spamscore=0
 clxscore=1015 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008210160
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a set of APIs to perf_buffer manage to allow applications to integrat=
e
perf buffer polling into existing epoll-based infrastructure. One example=
 is
applications using libevent already and wanting to plug perf_buffer polli=
ng,
instead of relying on perf_buffer__poll() and waste an extra thread to do=
 it.
But perf_buffer is still extremely useful to set up and consume perf buff=
er
rings even for such use cases.

So to accomodate such new use cases, add three new APIs:
  - perf_buffer__buffer_cnt() returns number of per-CPU buffers maintaine=
d by
    given instance of perf_buffer manager;
  - perf_buffer__buffer_fd() returns FD of perf_event corresponding to
    a specified per-CPU buffer; this FD is then polled independently;
  - perf_buffer__consume_buffer() consumes data from single per-CPU buffe=
r,
    identified by its slot index.

To support a simpler, but less efficient, way to integrate perf_buffer in=
to
external polling logic, also expose underlying epoll FD through
perf_buffer__epoll_fd() API. It will need to be followed by
perf_buffer__poll(), wasting extra syscall, or perf_buffer__consume(), wa=
sting
CPU to iterate buffers with no data. But could be simpler and more conven=
ient
for some cases.

These APIs allow for great flexiblity, but do not sacrifice general usabi=
lity
of perf_buffer.

Also exercise and check new APIs in perf_buffer selftest.

Reviewed-by: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c                        | 56 +++++++++++++++-
 tools/lib/bpf/libbpf.h                        |  4 ++
 tools/lib/bpf/libbpf.map                      |  8 +++
 .../selftests/bpf/prog_tests/perf_buffer.c    | 65 +++++++++++++++----
 4 files changed, 121 insertions(+), 12 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 0bc1fd813408..210429c5b772 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -9373,6 +9373,11 @@ static int perf_buffer__process_records(struct per=
f_buffer *pb,
 	return 0;
 }
=20
+int perf_buffer__epoll_fd(const struct perf_buffer *pb)
+{
+	return pb->epoll_fd;
+}
+
 int perf_buffer__poll(struct perf_buffer *pb, int timeout_ms)
 {
 	int i, cnt, err;
@@ -9390,6 +9395,55 @@ int perf_buffer__poll(struct perf_buffer *pb, int =
timeout_ms)
 	return cnt < 0 ? -errno : cnt;
 }
=20
+/* Return number of PERF_EVENT_ARRAY map slots set up by this perf_buffe=
r
+ * manager.
+ */
+size_t perf_buffer__buffer_cnt(const struct perf_buffer *pb)
+{
+	return pb->cpu_cnt;
+}
+
+/*
+ * Return perf_event FD of a ring buffer in *buf_idx* slot of
+ * PERF_EVENT_ARRAY BPF map. This FD can be polled for new data using
+ * select()/poll()/epoll() Linux syscalls.
+ */
+int perf_buffer__buffer_fd(const struct perf_buffer *pb, size_t buf_idx)
+{
+	struct perf_cpu_buf *cpu_buf;
+
+	if (buf_idx >=3D pb->cpu_cnt)
+		return -EINVAL;
+
+	cpu_buf =3D pb->cpu_bufs[buf_idx];
+	if (!cpu_buf)
+		return -ENOENT;
+
+	return cpu_buf->fd;
+}
+
+/*
+ * Consume data from perf ring buffer corresponding to slot *buf_idx* in
+ * PERF_EVENT_ARRAY BPF map without waiting/polling. If there is no data=
 to
+ * consume, do nothing and return success.
+ * Returns:
+ *   - 0 on success;
+ *   - <0 on failure.
+ */
+int perf_buffer__consume_buffer(struct perf_buffer *pb, size_t buf_idx)
+{
+	struct perf_cpu_buf *cpu_buf;
+
+	if (buf_idx >=3D pb->cpu_cnt)
+		return -EINVAL;
+
+	cpu_buf =3D pb->cpu_bufs[buf_idx];
+	if (!cpu_buf)
+		return -ENOENT;
+
+	return perf_buffer__process_records(pb, cpu_buf);
+}
+
 int perf_buffer__consume(struct perf_buffer *pb)
 {
 	int i, err;
@@ -9402,7 +9456,7 @@ int perf_buffer__consume(struct perf_buffer *pb)
=20
 		err =3D perf_buffer__process_records(pb, cpu_buf);
 		if (err) {
-			pr_warn("error while processing records: %d\n", err);
+			pr_warn("perf_buffer: failed to process records in buffer #%d: %d\n",=
 i, err);
 			return err;
 		}
 	}
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 5ecb4069a9f0..308e0ded8f14 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -588,8 +588,12 @@ perf_buffer__new_raw(int map_fd, size_t page_cnt,
 		     const struct perf_buffer_raw_opts *opts);
=20
 LIBBPF_API void perf_buffer__free(struct perf_buffer *pb);
+LIBBPF_API int perf_buffer__epoll_fd(const struct perf_buffer *pb);
 LIBBPF_API int perf_buffer__poll(struct perf_buffer *pb, int timeout_ms)=
;
 LIBBPF_API int perf_buffer__consume(struct perf_buffer *pb);
+LIBBPF_API int perf_buffer__consume_buffer(struct perf_buffer *pb, size_=
t buf_idx);
+LIBBPF_API size_t perf_buffer__buffer_cnt(const struct perf_buffer *pb);
+LIBBPF_API int perf_buffer__buffer_fd(const struct perf_buffer *pb, size=
_t buf_idx);
=20
 typedef enum bpf_perf_event_ret
 	(*bpf_perf_event_print_t)(struct perf_event_header *hdr,
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index e35bd6cdbdbf..66a6286d0716 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -299,3 +299,11 @@ LIBBPF_0.1.0 {
 		btf__set_fd;
 		btf__set_pointer_size;
 } LIBBPF_0.0.9;
+
+LIBBPF_0.2.0 {
+	global:
+		perf_buffer__buffer_cnt;
+		perf_buffer__buffer_fd;
+		perf_buffer__epoll_fd;
+		perf_buffer__consume_buffer;
+} LIBBPF_0.1.0;
diff --git a/tools/testing/selftests/bpf/prog_tests/perf_buffer.c b/tools=
/testing/selftests/bpf/prog_tests/perf_buffer.c
index c33ec180b3f2..ca9f0895ec84 100644
--- a/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
+++ b/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
@@ -7,6 +7,8 @@
 #include "test_perf_buffer.skel.h"
 #include "bpf/libbpf_internal.h"
=20
+static int duration;
+
 /* AddressSanitizer sometimes crashes due to data dereference below, due=
 to
  * this being mmap()'ed memory. Disable instrumentation with
  * no_sanitize_address attribute
@@ -24,13 +26,31 @@ static void on_sample(void *ctx, int cpu, void *data,=
 __u32 size)
 	CPU_SET(cpu, cpu_seen);
 }
=20
+int trigger_on_cpu(int cpu)
+{
+	cpu_set_t cpu_set;
+	int err;
+
+	CPU_ZERO(&cpu_set);
+	CPU_SET(cpu, &cpu_set);
+
+	err =3D pthread_setaffinity_np(pthread_self(), sizeof(cpu_set), &cpu_se=
t);
+	if (err && CHECK(err, "set_affinity", "cpu #%d, err %d\n", cpu, err))
+		return err;
+
+	usleep(1);
+
+	return 0;
+}
+
 void test_perf_buffer(void)
 {
-	int err, on_len, nr_on_cpus =3D 0,  nr_cpus, i, duration =3D 0;
+	int err, on_len, nr_on_cpus =3D 0, nr_cpus, i;
 	struct perf_buffer_opts pb_opts =3D {};
 	struct test_perf_buffer *skel;
-	cpu_set_t cpu_set, cpu_seen;
+	cpu_set_t cpu_seen;
 	struct perf_buffer *pb;
+	int last_fd =3D -1, fd;
 	bool *online;
=20
 	nr_cpus =3D libbpf_num_possible_cpus();
@@ -63,6 +83,9 @@ void test_perf_buffer(void)
 	if (CHECK(IS_ERR(pb), "perf_buf__new", "err %ld\n", PTR_ERR(pb)))
 		goto out_close;
=20
+	CHECK(perf_buffer__epoll_fd(pb) < 0, "epoll_fd",
+	      "bad fd: %d\n", perf_buffer__epoll_fd(pb));
+
 	/* trigger kprobe on every CPU */
 	CPU_ZERO(&cpu_seen);
 	for (i =3D 0; i < nr_cpus; i++) {
@@ -71,16 +94,8 @@ void test_perf_buffer(void)
 			continue;
 		}
=20
-		CPU_ZERO(&cpu_set);
-		CPU_SET(i, &cpu_set);
-
-		err =3D pthread_setaffinity_np(pthread_self(), sizeof(cpu_set),
-					     &cpu_set);
-		if (err && CHECK(err, "set_affinity", "cpu #%d, err %d\n",
-				 i, err))
+		if (trigger_on_cpu(i))
 			goto out_close;
-
-		usleep(1);
 	}
=20
 	/* read perf buffer */
@@ -92,6 +107,34 @@ void test_perf_buffer(void)
 		  "expect %d, seen %d\n", nr_on_cpus, CPU_COUNT(&cpu_seen)))
 		goto out_free_pb;
=20
+	if (CHECK(perf_buffer__buffer_cnt(pb) !=3D nr_cpus, "buf_cnt",
+		  "got %zu, expected %d\n", perf_buffer__buffer_cnt(pb), nr_cpus))
+		goto out_close;
+
+	for (i =3D 0; i < nr_cpus; i++) {
+		if (i >=3D on_len || !online[i])
+			continue;
+
+		fd =3D perf_buffer__buffer_fd(pb, i);
+		CHECK(fd < 0 || last_fd =3D=3D fd, "fd_check", "last fd %d =3D=3D fd %=
d\n", last_fd, fd);
+		last_fd =3D fd;
+
+		err =3D perf_buffer__consume_buffer(pb, i);
+		if (CHECK(err, "drain_buf", "cpu %d, err %d\n", i, err))
+			goto out_close;
+
+		CPU_CLR(i, &cpu_seen);
+		if (trigger_on_cpu(i))
+			goto out_close;
+
+		err =3D perf_buffer__consume_buffer(pb, i);
+		if (CHECK(err, "consume_buf", "cpu %d, err %d\n", i, err))
+			goto out_close;
+
+		if (CHECK(!CPU_ISSET(i, &cpu_seen), "cpu_seen", "cpu %d not seen\n", i=
))
+			goto out_close;
+	}
+
 out_free_pb:
 	perf_buffer__free(pb);
 out_close:
--=20
2.24.1

