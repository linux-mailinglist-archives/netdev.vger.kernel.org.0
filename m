Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3167109D
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 06:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731953AbfGWEbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 00:31:32 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9034 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731738AbfGWEb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 00:31:29 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6N4RMCE024499
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 21:31:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=8vj66Wz8kgcLrZwsVt5kr7RmD0+Uo9WYRoNH7EAXwQE=;
 b=XUrWuTBIZh9sdIqMPt5bVWhHfZVnEvF3CWn8WayCBzBxzMYKllk4lHJzsF9MTNvgBBAR
 Egw/OOKaU8JpnDd9Qe/SirBVjp1bcG5O6+W8Ru/OsetK4L4qV8aB0HoKXQTaoslL+mMG
 /9BTbsE1buke/ymWwPojmGrG/gKDObEoirw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2twg5ytbj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 21:31:28 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 22 Jul 2019 21:31:27 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id C92B08614ED; Mon, 22 Jul 2019 21:31:26 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 5/5] selftests/bpf: remove perf buffer helpers
Date:   Mon, 22 Jul 2019 21:31:12 -0700
Message-ID: <20190723043112.3145810-6-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190723043112.3145810-1-andriin@fb.com>
References: <20190723043112.3145810-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-23_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=25 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=948 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907230039
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

libbpf's perf_buffer API supersedes trace_helper.h's helpers.
Remove those helpers after all existing users were already moved to
perf_buffer API.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
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

