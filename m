Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59757721A7
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 23:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403952AbfGWVfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 17:35:17 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33008 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2403946AbfGWVfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 17:35:17 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x6NLW8S6028909
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 14:35:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=aYTQ+zUgQJAdgomjovg3XpG481pbk+qgmf0N4tXpo40=;
 b=NI8y3rsD26SwEKlLfyHOFIuINK+/g47Q45EKncnO4uWdv6XrtXRZCGMIXcrMyhai9RkL
 pI/L11NBeCY55q2PfcYjqIXziQYlTyIXRNggHmhoKiqIBfA4xJo6Jwg1GTi1mgjEo1ef
 Zyt+KU1328gQ8vkbyEMN/wUUygK56imX0wc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2tx613h33g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 14:35:15 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 23 Jul 2019 14:35:08 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 5E0248615A2; Tue, 23 Jul 2019 14:35:06 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <songliubraving@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 5/5] selftests/bpf: remove perf buffer helpers
Date:   Tue, 23 Jul 2019 14:34:45 -0700
Message-ID: <20190723213445.1732339-6-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190723213445.1732339-1-andriin@fb.com>
References: <20190723213445.1732339-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-23_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=25 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=986 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907230217
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

libbpf's perf_buffer API supersedes trace_helper.h's helpers.
Remove those helpers after all existing users were already moved to
perf_buffer API.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 tools/testing/selftests/bpf/trace_helpers.c | 125 --------------------
 tools/testing/selftests/bpf/trace_helpers.h |   9 --
 2 files changed, 134 deletions(-)

diff --git a/tools/testing/selftests/bpf/trace_helpers.c b/tools/testing/selftests/bpf/trace_helpers.c
index b47f205f0310..7f989b3e4e22 100644
--- a/tools/testing/selftests/bpf/trace_helpers.c
+++ b/tools/testing/selftests/bpf/trace_helpers.c
@@ -86,128 +86,3 @@ long ksym_get_addr(const char *name)
 
 	return 0;
 }
-
-static int page_size;
-static int page_cnt = 8;
-static struct perf_event_mmap_page *header;
-
-int perf_event_mmap_header(int fd, struct perf_event_mmap_page **header)
-{
-	void *base;
-	int mmap_size;
-
-	page_size = getpagesize();
-	mmap_size = page_size * (page_cnt + 1);
-
-	base = mmap(NULL, mmap_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
-	if (base == MAP_FAILED) {
-		printf("mmap err\n");
-		return -1;
-	}
-
-	*header = base;
-	return 0;
-}
-
-int perf_event_mmap(int fd)
-{
-	return perf_event_mmap_header(fd, &header);
-}
-
-static int perf_event_poll(int fd)
-{
-	struct pollfd pfd = { .fd = fd, .events = POLLIN };
-
-	return poll(&pfd, 1, 1000);
-}
-
-struct perf_event_sample {
-	struct perf_event_header header;
-	__u32 size;
-	char data[];
-};
-
-static enum bpf_perf_event_ret
-bpf_perf_event_print(struct perf_event_header *hdr, void *private_data)
-{
-	struct perf_event_sample *e = (struct perf_event_sample *)hdr;
-	perf_event_print_fn fn = private_data;
-	int ret;
-
-	if (e->header.type == PERF_RECORD_SAMPLE) {
-		ret = fn(e->data, e->size);
-		if (ret != LIBBPF_PERF_EVENT_CONT)
-			return ret;
-	} else if (e->header.type == PERF_RECORD_LOST) {
-		struct {
-			struct perf_event_header header;
-			__u64 id;
-			__u64 lost;
-		} *lost = (void *) e;
-		printf("lost %lld events\n", lost->lost);
-	} else {
-		printf("unknown event type=%d size=%d\n",
-		       e->header.type, e->header.size);
-	}
-
-	return LIBBPF_PERF_EVENT_CONT;
-}
-
-int perf_event_poller(int fd, perf_event_print_fn output_fn)
-{
-	enum bpf_perf_event_ret ret;
-	void *buf = NULL;
-	size_t len = 0;
-
-	for (;;) {
-		perf_event_poll(fd);
-		ret = bpf_perf_event_read_simple(header, page_cnt * page_size,
-						 page_size, &buf, &len,
-						 bpf_perf_event_print,
-						 output_fn);
-		if (ret != LIBBPF_PERF_EVENT_CONT)
-			break;
-	}
-	free(buf);
-
-	return ret;
-}
-
-int perf_event_poller_multi(int *fds, struct perf_event_mmap_page **headers,
-			    int num_fds, perf_event_print_fn output_fn)
-{
-	enum bpf_perf_event_ret ret;
-	struct pollfd *pfds;
-	void *buf = NULL;
-	size_t len = 0;
-	int i;
-
-	pfds = calloc(num_fds, sizeof(*pfds));
-	if (!pfds)
-		return LIBBPF_PERF_EVENT_ERROR;
-
-	for (i = 0; i < num_fds; i++) {
-		pfds[i].fd = fds[i];
-		pfds[i].events = POLLIN;
-	}
-
-	for (;;) {
-		poll(pfds, num_fds, 1000);
-		for (i = 0; i < num_fds; i++) {
-			if (!pfds[i].revents)
-				continue;
-
-			ret = bpf_perf_event_read_simple(headers[i],
-							 page_cnt * page_size,
-							 page_size, &buf, &len,
-							 bpf_perf_event_print,
-							 output_fn);
-			if (ret != LIBBPF_PERF_EVENT_CONT)
-				break;
-		}
-	}
-	free(buf);
-	free(pfds);
-
-	return ret;
-}
diff --git a/tools/testing/selftests/bpf/trace_helpers.h b/tools/testing/selftests/bpf/trace_helpers.h
index 18924f23db1b..aa4dcfe18050 100644
--- a/tools/testing/selftests/bpf/trace_helpers.h
+++ b/tools/testing/selftests/bpf/trace_helpers.h
@@ -3,7 +3,6 @@
 #define __TRACE_HELPER_H
 
 #include <libbpf.h>
-#include <linux/perf_event.h>
 
 struct ksym {
 	long addr;
@@ -14,12 +13,4 @@ int load_kallsyms(void);
 struct ksym *ksym_search(long key);
 long ksym_get_addr(const char *name);
 
-typedef enum bpf_perf_event_ret (*perf_event_print_fn)(void *data, int size);
-
-int perf_event_mmap(int fd);
-int perf_event_mmap_header(int fd, struct perf_event_mmap_page **header);
-/* return LIBBPF_PERF_EVENT_DONE or LIBBPF_PERF_EVENT_ERROR */
-int perf_event_poller(int fd, perf_event_print_fn output_fn);
-int perf_event_poller_multi(int *fds, struct perf_event_mmap_page **headers,
-			    int num_fds, perf_event_print_fn output_fn);
 #endif
-- 
2.17.1

