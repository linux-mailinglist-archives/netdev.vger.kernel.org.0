Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2A9380F6B
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 20:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbhENSIw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 14 May 2021 14:08:52 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5548 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231394AbhENSIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 14:08:52 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14EI41Xd015816
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 11:07:40 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 38gpr1kxdv-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 11:07:40 -0700
Received: from intmgw001.06.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 14 May 2021 11:07:39 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 95AF82ED8EB5; Fri, 14 May 2021 11:07:36 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH bpf] selftests/bpf: test ringbuf mmap read-only and read-write restrictions
Date:   Fri, 14 May 2021 11:07:26 -0700
Message-ID: <20210514180726.843157-1-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: WauRRt8rduFUnDLPEOI-A2vVEH5NQYU5
X-Proofpoint-GUID: WauRRt8rduFUnDLPEOI-A2vVEH5NQYU5
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-14_08:2021-05-12,2021-05-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 spamscore=0 priorityscore=1501 adultscore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105140142
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend ringbuf selftest to validate read/write and read-only restrictions on
memory mapping consumer/producer/data pages. Ensure no "escalations" from
PROT_READ to PROT_WRITE/PROT_EXEC is allowed. And test that mremap() fails to
expand mmap()'ed area.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 .../selftests/bpf/prog_tests/ringbuf.c        | 49 ++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/ringbuf.c b/tools/testing/selftests/bpf/prog_tests/ringbuf.c
index de78617f6550..f9a8ae331963 100644
--- a/tools/testing/selftests/bpf/prog_tests/ringbuf.c
+++ b/tools/testing/selftests/bpf/prog_tests/ringbuf.c
@@ -86,8 +86,9 @@ void test_ringbuf(void)
 	const size_t rec_sz = BPF_RINGBUF_HDR_SZ + sizeof(struct sample);
 	pthread_t thread;
 	long bg_ret = -1;
-	int err, cnt;
+	int err, cnt, rb_fd;
 	int page_size = getpagesize();
+	void *mmap_ptr, *tmp_ptr;
 
 	skel = test_ringbuf__open();
 	if (CHECK(!skel, "skel_open", "skeleton open failed\n"))
@@ -101,6 +102,52 @@ void test_ringbuf(void)
 	if (CHECK(err != 0, "skel_load", "skeleton load failed\n"))
 		goto cleanup;
 
+	rb_fd = bpf_map__fd(skel->maps.ringbuf);
+	/* good read/write cons_pos */
+	mmap_ptr = mmap(NULL, page_size, PROT_READ | PROT_WRITE, MAP_SHARED, rb_fd, 0);
+	ASSERT_OK_PTR(mmap_ptr, "rw_cons_pos");
+	tmp_ptr = mremap(mmap_ptr, page_size, 2 * page_size, MREMAP_MAYMOVE);
+	if (!ASSERT_ERR_PTR(tmp_ptr, "rw_extend"))
+		goto cleanup;
+	ASSERT_ERR(mprotect(mmap_ptr, page_size, PROT_EXEC), "exec_cons_pos_protect");
+	ASSERT_OK(munmap(mmap_ptr, page_size), "unmap_rw");
+
+	/* bad writeable prod_pos */
+	mmap_ptr = mmap(NULL, page_size, PROT_WRITE, MAP_SHARED, rb_fd, page_size);
+	err = -errno;
+	ASSERT_ERR_PTR(mmap_ptr, "wr_prod_pos");
+	ASSERT_EQ(err, -EPERM, "wr_prod_pos_err");
+
+	/* bad writeable data pages */
+	mmap_ptr = mmap(NULL, page_size, PROT_WRITE, MAP_SHARED, rb_fd, 2 * page_size);
+	err = -errno;
+	ASSERT_ERR_PTR(mmap_ptr, "wr_data_page_one");
+	ASSERT_EQ(err, -EPERM, "wr_data_page_one_err");
+	mmap_ptr = mmap(NULL, page_size, PROT_WRITE, MAP_SHARED, rb_fd, 3 * page_size);
+	ASSERT_ERR_PTR(mmap_ptr, "wr_data_page_two");
+	mmap_ptr = mmap(NULL, 2 * page_size, PROT_WRITE, MAP_SHARED, rb_fd, 2 * page_size);
+	ASSERT_ERR_PTR(mmap_ptr, "wr_data_page_all");
+
+	/* good read-only pages */
+	mmap_ptr = mmap(NULL, 4 * page_size, PROT_READ, MAP_SHARED, rb_fd, 0);
+	if (!ASSERT_OK_PTR(mmap_ptr, "ro_prod_pos"))
+		goto cleanup;
+
+	ASSERT_ERR(mprotect(mmap_ptr, 4 * page_size, PROT_WRITE), "write_protect");
+	ASSERT_ERR(mprotect(mmap_ptr, 4 * page_size, PROT_EXEC), "exec_protect");
+	ASSERT_ERR_PTR(mremap(mmap_ptr, 0, 4 * page_size, MREMAP_MAYMOVE), "ro_remap");
+	ASSERT_OK(munmap(mmap_ptr, 4 * page_size), "unmap_ro");
+
+	/* good read-only pages with initial offset */
+	mmap_ptr = mmap(NULL, page_size, PROT_READ, MAP_SHARED, rb_fd, page_size);
+	if (!ASSERT_OK_PTR(mmap_ptr, "ro_prod_pos"))
+		goto cleanup;
+
+	ASSERT_ERR(mprotect(mmap_ptr, page_size, PROT_WRITE), "write_protect");
+	ASSERT_ERR(mprotect(mmap_ptr, page_size, PROT_EXEC), "exec_protect");
+	ASSERT_ERR_PTR(mremap(mmap_ptr, 0, 3 * page_size, MREMAP_MAYMOVE), "ro_remap");
+	ASSERT_OK(munmap(mmap_ptr, page_size), "unmap_ro");
+
 	/* only trigger BPF program for current process */
 	skel->bss->pid = getpid();
 
-- 
2.30.2

