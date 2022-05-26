Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDD95353D2
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 21:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244967AbiEZTQ2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 26 May 2022 15:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344417AbiEZTQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 15:16:27 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B4219035
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 12:16:27 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24QJ6mQs022919
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 12:16:26 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3gac8asjge-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 12:16:26 -0700
Received: from twshared10560.18.frc3.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 26 May 2022 12:16:24 -0700
Received: by devbig932.frc1.facebook.com (Postfix, from userid 4523)
        id 185AE821AA87; Thu, 26 May 2022 12:16:18 -0700 (PDT)
From:   Song Liu <song@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, Song Liu <song@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>
Subject: [PATCH bpf] selftests/bpf: fix stacktrace_build_id with missing kprobe/urandom_read
Date:   Thu, 26 May 2022 12:16:08 -0700
Message-ID: <20220526191608.2364049-1-song@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: t84T7GnDkerz3o-rvhGJqCtx_ZJJ-Km5
X-Proofpoint-GUID: t84T7GnDkerz3o-rvhGJqCtx_ZJJ-Km5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-26_10,2022-05-25_02,2022-02-23_01
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kernel function urandom_read is replaced with urandom_read_iter.
Therefore, kprobe on urandom_read is not working any more:

[root@eth50-1 bpf]# ./test_progs -n 161
test_stacktrace_build_id:PASS:skel_open_and_load 0 nsec
libbpf: kprobe perf_event_open() failed: No such file or directory
libbpf: prog 'oncpu': failed to create kprobe 'urandom_read+0x0' \
        perf event: No such file or directory
libbpf: prog 'oncpu': failed to auto-attach: -2
test_stacktrace_build_id:FAIL:attach_tp err -2
161     stacktrace_build_id:FAIL

Fix this by replacing urandom_read with urandom_read_iter in the test.

Fixes: 1b388e7765f2 ("random: convert to using fops->read_iter()")
Reported-by: Mykola Lysenko <mykolal@fb.com>
Signed-off-by: Song Liu <song@kernel.org>
---
 tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c b/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c
index 6c62bfb8bb6f..0c4426592a26 100644
--- a/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c
+++ b/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c
@@ -39,7 +39,7 @@ struct {
 	__type(value, stack_trace_t);
 } stack_amap SEC(".maps");
 
-SEC("kprobe/urandom_read")
+SEC("kprobe/urandom_read_iter")
 int oncpu(struct pt_regs *args)
 {
 	__u32 max_len = sizeof(struct bpf_stack_build_id)
-- 
2.30.2

