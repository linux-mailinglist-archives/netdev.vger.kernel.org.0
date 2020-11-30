Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F8E2C9131
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 23:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730763AbgK3We1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 30 Nov 2020 17:34:27 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18244 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730753AbgK3We1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 17:34:27 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AUMUKj7001025
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 14:33:46 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3547g8fser-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 14:33:46 -0800
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 30 Nov 2020 14:33:44 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 262082ECA5EA; Mon, 30 Nov 2020 14:33:40 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf 2/2] selftests/bpf: drain ringbuf samples at the end of test
Date:   Mon, 30 Nov 2020 14:33:36 -0800
Message-ID: <20201130223336.904192-2-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201130223336.904192-1-andrii@kernel.org>
References: <20201130223336.904192-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_12:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 clxscore=1034
 spamscore=0 suspectscore=8 phishscore=0 mlxscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=977 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300140
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid occasional test failures due to the last sample being delayed to
another ring_buffer__poll() call. Instead, drain samples completely with
ring_buffer__consume(). This is supposed to fix a rare and non-deterministic
test failure in libbpf CI.

Fixes: cb1c9ddd5525 ("selftests/bpf: Add BPF ringbuf selftests")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/ringbuf.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/ringbuf.c b/tools/testing/selftests/bpf/prog_tests/ringbuf.c
index 1a48c6f7f54e..fddbc5db5d6a 100644
--- a/tools/testing/selftests/bpf/prog_tests/ringbuf.c
+++ b/tools/testing/selftests/bpf/prog_tests/ringbuf.c
@@ -220,6 +220,12 @@ void test_ringbuf(void)
 	if (CHECK(bg_ret <= 0, "bg_ret", "epoll_wait result: %ld", bg_ret))
 		goto cleanup;
 
+	/* due to timing variations, there could still be non-notified
+	 * samples, so consume them here to collect all the samples
+	 */
+	err = ring_buffer__consume(ringbuf);
+	CHECK(err < 0, "rb_consume", "failed: %d\b", err);
+
 	/* 3 rounds, 2 samples each */
 	cnt = atomic_xchg(&sample_cnt, 0);
 	CHECK(cnt != 6, "cnt", "exp %d samples, got %d\n", 6, cnt);
-- 
2.24.1

