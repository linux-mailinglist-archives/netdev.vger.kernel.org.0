Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7E4624CB0B
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 04:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgHUCy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 22:54:56 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37310 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726702AbgHUCyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 22:54:54 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07L2sBHq003787
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 19:54:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=ujLsei6d9MTTvzOY59QeLLIkNuFkTD09Qg7i7E++HUs=;
 b=HlFtQDwVELFt/hkCB9es/4Uf/H6TMjUfmIQnootMg6ULFTOQ0+IywMHL3S74lZuPqnzR
 bfDQwxX1vMjKCSKrGF+/a4V6V+5aTKkJ+CSx33xiOimNtjMcb+0+3aIDJ0T0z5MisvKu
 FuJtOfPjs392aYb9VSg03iqjN578LNFW2A8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304m3a8us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 19:54:53 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 19:54:52 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 7C3192EC5F52; Thu, 20 Aug 2020 19:54:49 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] libbpf: add perf_buffer APIs for better integration with outside epoll loop
Date:   Thu, 20 Aug 2020 19:54:48 -0700
Message-ID: <20200821025448.2087055-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_03:2020-08-19,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 bulkscore=0 suspectscore=25 spamscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008210026
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

These APIs allow for great flexiblity, but do not sacrifice general usabi=
lity
of perf_buffer.

Also exercise and check new APIs in perf_buffer selftest.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c                        | 51 ++++++++++++++-
 tools/lib/bpf/libbpf.h                        |  3 +
 tools/lib/bpf/libbpf.map                      |  7 +++
 .../selftests/bpf/prog_tests/perf_buffer.c    | 62 +++++++++++++++----
 4 files changed, 111 insertions(+), 12 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 0bc1fd813408..a6359d49aa9d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -9390,6 +9390,55 @@ int perf_buffer__poll(struct perf_buffer *pb, int =
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
@@ -9402,7 +9451,7 @@ int perf_buffer__consume(struct perf_buffer *pb)
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
index 5ecb4069a9f0..15e02dcda2c7 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -590,6 +590,9 @@ perf_buffer__new_raw(int map_fd, size_t page_cnt,
 LIBBPF_API void perf_buffer__free(struct perf_buffer *pb);
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
index e35bd6cdbdbf..77466958310a 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -299,3 +299,10 @@ LIBBPF_0.1.0 {
 		btf__set_fd;
 		btf__set_pointer_size;
 } LIBBPF_0.0.9;
+
+LIBBPF_0.2.0 {
+	global:
+		perf_buffer__buffer_cnt;
+		perf_buffer__buffer_fd;
+		perf_buffer__consume_buffer;
+} LIBBPF_0.1.0;
diff --git a/tools/testing/selftests/bpf/prog_tests/perf_buffer.c b/tools=
/testing/selftests/bpf/prog_tests/perf_buffer.c
index c33ec180b3f2..add224ce17af 100644
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
@@ -71,16 +91,8 @@ void test_perf_buffer(void)
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
@@ -92,6 +104,34 @@ void test_perf_buffer(void)
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
+		CHECK(last_fd =3D=3D fd, "fd_check", "last fd %d =3D=3D fd %d\n", last=
_fd, fd);
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

