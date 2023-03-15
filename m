Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 798B46BA8AB
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbjCOHFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbjCOHE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:04:58 -0400
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2B427D79;
        Wed, 15 Mar 2023 00:04:54 -0700 (PDT)
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4Pc1c45ym3z8RV7R;
        Wed, 15 Mar 2023 15:04:52 +0800 (CST)
Received: from szxlzmapp05.zte.com.cn ([10.5.230.85])
        by mse-fl2.zte.com.cn with SMTP id 32F74e3W080872;
        Wed, 15 Mar 2023 15:04:40 +0800 (+08)
        (envelope-from wang.yi59@zte.com.cn)
Received: from fox-cloudhost8.zte.com.cn (unknown [10.234.72.110])
        by smtp (Zmail) with SMTP;
        Wed, 15 Mar 2023 15:04:42 +0800
X-Zmail-TransId: 3e8164116e08000-ffc3a
From:   Yi Wang <wang.yi59@zte.com.cn>
To:     peterz@infradead.org
Cc:     mingo@redhat.com, acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        namhyung@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        xue.zhihong@zte.com.cn, wang.yi59@zte.com.cn,
        wang.liang82@zte.com.cn, "Liu.Xiaoyang" <liu.xiaoyang@zte.com.cn>
Subject: [PATCH] perf: fix segmentation fault in perf_event__synthesize_one_bpf_prog
Date:   Wed, 15 Mar 2023 14:58:18 +0800
Message-Id: <20230315065818.31156-1-wang.yi59@zte.com.cn>
X-Mailer: git-send-email 2.33.0.rc0.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl2.zte.com.cn 32F74e3W080872
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.137.novalocal with ID 64116E14.002 by FangMail milter!
X-FangMail-Envelope: 1678863892/4Pc1c45ym3z8RV7R/64116E14.002/10.5.228.133/[10.5.228.133]/mse-fl2.zte.com.cn/<wang.yi59@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 64116E14.002/4Pc1c45ym3z8RV7R
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Liu.Xiaoyang" <liu.xiaoyang@zte.com.cn>

Description of problem:
when /proc/sys/kernel/kptr_restrict set to 2 and there are bpf progs
loaded on system, ptr prog_lens and prog_addrs maybe Null.
then prog_addrs[i] and prog_lens[i] will case segmentation fault.

call trace：
perf: Segmentation fault
perf(sighandler_dump_stack+0x48)
/lib64/libc.so.6(+0x37400)
perf(perf_event__synthesize_bpf_events+0x23a)
perf(+0x235b73)
perf(cmd_record+0xc0d)
perf(+0x2a8c5d)
perf(main+0x69a)

Signed-off-by: Liu.Xiaoyang <liu.xiaoyang@zte.com.cn>
Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
---
 tools/perf/util/bpf-event.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
index cc7c1f9..7a6ea6d 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -307,6 +307,11 @@ static int perf_event__synthesize_one_bpf_prog(struct perf_session *session,
 		__u64 *prog_addrs = (__u64 *)(uintptr_t)(info->jited_ksyms);
 		int name_len;
 
+		if (!prog_lens || !prog_addrs) {
+			err = -1;
+			goto out;
+		}
+
 		*ksymbol_event = (struct perf_record_ksymbol) {
 			.header = {
 				.type = PERF_RECORD_KSYMBOL,
-- 
1.8.3.1
