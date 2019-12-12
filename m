Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B34B311C249
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 02:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727564AbfLLBgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 20:36:14 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62972 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727469AbfLLBgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 20:36:13 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xBC1Yh47022335
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 17:36:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=q2yXvwQlWtQh556GVbO35lfheFRkkaZdBIVAVVg+UUo=;
 b=rDGznlTqjXyuoNKEWCivpeYWUsVRl7o1i4p+xhL0a8TMC+X4NyAhllHzxBGZ4hENddqe
 2nde3sQHYRulHulKblBa7VC5E5HXDnwh8/ycUTVIIcJDFenTD+jxAEGBEDiLOQmW0hE2
 SDeAh1AcSijvQNoMqUgR3eiDmQJvam4mleE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2wtpnencsx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 17:36:12 -0800
Received: from intmgw005.05.ash5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 11 Dec 2019 17:36:11 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id D46A12EC1A0E; Wed, 11 Dec 2019 17:36:10 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 3/4] libbpf: don't attach perf_buffer to offline/missing CPUs
Date:   Wed, 11 Dec 2019 17:36:09 -0800
Message-ID: <20191212013609.1691168-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-11_07:2019-12-11,2019-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 clxscore=1015 suspectscore=25 phishscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912120004
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's quite common on some systems to have more CPUs enlisted as "possible",
than there are (and could ever be) present/online CPUs. In such cases,
perf_buffer creationg will fail due to inability to create perf event on
missing CPU with error like this:

libbpf: failed to open perf buffer event on cpu #16: No such device

This patch fixes the logic of perf_buffer__new() to ignore CPUs that are
missing or currently offline. In rare cases where user explicitly listed
specific CPUs to connect to, behavior is unchanged: libbpf will try to open
perf event buffer on specified CPU(s) anyways.

Fixes: fb84b8224655 ("libbpf: add perf buffer API")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index b761d8636026..1bb63961d2ce 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5944,7 +5944,7 @@ struct perf_buffer {
 	size_t mmap_size;
 	struct perf_cpu_buf **cpu_bufs;
 	struct epoll_event *events;
-	int cpu_cnt;
+	int cpu_cnt; /* number of allocated CPU buffers */
 	int epoll_fd; /* perf event FD */
 	int map_fd; /* BPF_MAP_TYPE_PERF_EVENT_ARRAY BPF map FD */
 };
@@ -6078,11 +6078,13 @@ perf_buffer__new_raw(int map_fd, size_t page_cnt,
 static struct perf_buffer *__perf_buffer__new(int map_fd, size_t page_cnt,
 					      struct perf_buffer_params *p)
 {
+	const char *online_cpus_file = "/sys/devices/system/cpu/online";
 	struct bpf_map_info map = {};
 	char msg[STRERR_BUFSIZE];
 	struct perf_buffer *pb;
+	bool *online = NULL;
 	__u32 map_info_len;
-	int err, i;
+	int err, i, j, n;
 
 	if (page_cnt & (page_cnt - 1)) {
 		pr_warn("page count should be power of two, but is %zu\n",
@@ -6151,20 +6153,32 @@ static struct perf_buffer *__perf_buffer__new(int map_fd, size_t page_cnt,
 		goto error;
 	}
 
-	for (i = 0; i < pb->cpu_cnt; i++) {
+	err = parse_cpu_mask_file(online_cpus_file, &online, &n);
+	if (err) {
+		pr_warn("failed to get online CPU mask: %d\n", err);
+		goto error;
+	}
+
+	for (i = 0, j = 0; i < pb->cpu_cnt; i++) {
 		struct perf_cpu_buf *cpu_buf;
 		int cpu, map_key;
 
 		cpu = p->cpu_cnt > 0 ? p->cpus[i] : i;
 		map_key = p->cpu_cnt > 0 ? p->map_keys[i] : i;
 
+		/* in case user didn't explicitly requested particular CPUs to
+		 * be attached to, skip offline/not present CPUs
+		 */
+		if (p->cpu_cnt <= 0 && (cpu >= n || !online[cpu]))
+			continue;
+
 		cpu_buf = perf_buffer__open_cpu_buf(pb, p->attr, cpu, map_key);
 		if (IS_ERR(cpu_buf)) {
 			err = PTR_ERR(cpu_buf);
 			goto error;
 		}
 
-		pb->cpu_bufs[i] = cpu_buf;
+		pb->cpu_bufs[j] = cpu_buf;
 
 		err = bpf_map_update_elem(pb->map_fd, &map_key,
 					  &cpu_buf->fd, 0);
@@ -6176,21 +6190,25 @@ static struct perf_buffer *__perf_buffer__new(int map_fd, size_t page_cnt,
 			goto error;
 		}
 
-		pb->events[i].events = EPOLLIN;
-		pb->events[i].data.ptr = cpu_buf;
+		pb->events[j].events = EPOLLIN;
+		pb->events[j].data.ptr = cpu_buf;
 		if (epoll_ctl(pb->epoll_fd, EPOLL_CTL_ADD, cpu_buf->fd,
-			      &pb->events[i]) < 0) {
+			      &pb->events[j]) < 0) {
 			err = -errno;
 			pr_warn("failed to epoll_ctl cpu #%d perf FD %d: %s\n",
 				cpu, cpu_buf->fd,
 				libbpf_strerror_r(err, msg, sizeof(msg)));
 			goto error;
 		}
+		j++;
 	}
+	pb->cpu_cnt = j;
+	free(online);
 
 	return pb;
 
 error:
+	free(online);
 	if (pb)
 		perf_buffer__free(pb);
 	return ERR_PTR(err);
-- 
2.17.1

