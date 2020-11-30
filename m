Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF282C9130
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 23:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730757AbgK3WeX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 30 Nov 2020 17:34:23 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57796 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730753AbgK3WeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 17:34:22 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0AUMTMbv008214
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 14:33:41 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 3542bngfmm-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 14:33:41 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 30 Nov 2020 14:33:40 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 099C42ECA5EA; Mon, 30 Nov 2020 14:33:37 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf 1/2] libbpf: fix ring_buffer__poll() to return number of consumed samples
Date:   Mon, 30 Nov 2020 14:33:35 -0800
Message-ID: <20201130223336.904192-1-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_12:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 mlxscore=0 spamscore=0 mlxlogscore=860 malwarescore=0 suspectscore=8
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300140
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix ring_buffer__poll() to return the number of non-discarded records
consumed, just like its documentation states. It's also consistent with
ring_buffer__consume() return. Fix up selftests with wrong expected results.

Fixes: bf99c936f947 ("libbpf: Add BPF ring buffer support")
Fixes: cb1c9ddd5525 ("selftests/bpf: Add BPF ringbuf selftests")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/ringbuf.c                                | 2 +-
 tools/testing/selftests/bpf/prog_tests/ringbuf.c       | 2 +-
 tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/ringbuf.c b/tools/lib/bpf/ringbuf.c
index 5c6522c89af1..98537ff2679e 100644
--- a/tools/lib/bpf/ringbuf.c
+++ b/tools/lib/bpf/ringbuf.c
@@ -278,7 +278,7 @@ int ring_buffer__poll(struct ring_buffer *rb, int timeout_ms)
 		err = ringbuf_process_ring(ring);
 		if (err < 0)
 			return err;
-		res += cnt;
+		res += err;
 	}
 	return cnt < 0 ? -errno : res;
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/ringbuf.c b/tools/testing/selftests/bpf/prog_tests/ringbuf.c
index c1650548433c..1a48c6f7f54e 100644
--- a/tools/testing/selftests/bpf/prog_tests/ringbuf.c
+++ b/tools/testing/selftests/bpf/prog_tests/ringbuf.c
@@ -217,7 +217,7 @@ void test_ringbuf(void)
 	if (CHECK(err, "join_bg", "err %d\n", err))
 		goto cleanup;
 
-	if (CHECK(bg_ret != 1, "bg_ret", "epoll_wait result: %ld", bg_ret))
+	if (CHECK(bg_ret <= 0, "bg_ret", "epoll_wait result: %ld", bg_ret))
 		goto cleanup;
 
 	/* 3 rounds, 2 samples each */
diff --git a/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c b/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c
index 78e450609803..d37161e59bb2 100644
--- a/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c
+++ b/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c
@@ -81,7 +81,7 @@ void test_ringbuf_multi(void)
 
 	/* poll for samples, should get 2 ringbufs back */
 	err = ring_buffer__poll(ringbuf, -1);
-	if (CHECK(err != 4, "poll_res", "expected 4 records, got %d\n", err))
+	if (CHECK(err != 2, "poll_res", "expected 2 records, got %d\n", err))
 		goto cleanup;
 
 	/* expect extra polling to return nothing */
-- 
2.24.1

