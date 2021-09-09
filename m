Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344CF4043E1
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 05:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349727AbhIIDOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 23:14:37 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:56809 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349225AbhIIDOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 23:14:33 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0UnkWDai_1631157201;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0UnkWDai_1631157201)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 09 Sep 2021 11:13:22 +0800
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:PERFORMANCE EVENTS SUBSYSTEM" 
        <linux-perf-users@vger.kernel.org>,
        "open list:PERFORMANCE EVENTS SUBSYSTEM" 
        <linux-kernel@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Subject: [RFC PATCH] perf: fix panic by mark recursion inside
 perf_log_throttle
Message-ID: <ff979a43-045a-dc56-64d1-2c31dd4db381@linux.alibaba.com>
Date:   Thu, 9 Sep 2021 11:13:21 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When running with ftrace function enabled, we observed panic
as below:

  traps: PANIC: double fault, error_code: 0x0
  [snip]
  RIP: 0010:perf_swevent_get_recursion_context+0x0/0x70
  [snip]
  Call Trace:
   <NMI>
   perf_trace_buf_alloc+0x26/0xd0
   perf_ftrace_function_call+0x18f/0x2e0
   kernelmode_fixup_or_oops+0x5/0x120
   __bad_area_nosemaphore+0x1b8/0x280
   do_user_addr_fault+0x410/0x920
   exc_page_fault+0x92/0x300
   asm_exc_page_fault+0x1e/0x30
  RIP: 0010:__get_user_nocheck_8+0x6/0x13
   perf_callchain_user+0x266/0x2f0
   get_perf_callchain+0x194/0x210
   perf_callchain+0xa3/0xc0
   perf_prepare_sample+0xa5/0xa60
   perf_event_output_forward+0x7b/0x1b0
   __perf_event_overflow+0x67/0x120
   perf_swevent_overflow+0xcb/0x110
   perf_swevent_event+0xb0/0xf0
   perf_tp_event+0x292/0x410
   perf_trace_run_bpf_submit+0x87/0xc0
   perf_trace_lock_acquire+0x12b/0x170
   lock_acquire+0x1bf/0x2e0
   perf_output_begin+0x70/0x4b0
   perf_log_throttle+0xe2/0x1a0
   perf_event_nmi_handler+0x30/0x50
   nmi_handle+0xba/0x2a0
   default_do_nmi+0x45/0xf0
   exc_nmi+0x155/0x170
   end_repeat_nmi+0x16/0x55

According to the trace we know the story is like this, the NMI
triggered perf IRQ throttling and call perf_log_throttle(),
which triggered the swevent overflow, and the overflow process
do perf_callchain_user() which triggered a user PF, and the PF
process triggered perf ftrace which finally lead into a suspected
stack overflow.

This patch marking the context as recursion during perf_log_throttle()
, so no more swevent during the process and no more panic.

Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
---
 kernel/events/core.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 744e872..6063443 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8716,6 +8716,7 @@ static void perf_log_throttle(struct perf_event *event, int enable)
 	struct perf_output_handle handle;
 	struct perf_sample_data sample;
 	int ret;
+	int rctx;

 	struct {
 		struct perf_event_header	header;
@@ -8738,14 +8739,17 @@ static void perf_log_throttle(struct perf_event *event, int enable)

 	perf_event_header__init_id(&throttle_event.header, &sample, event);

+	rctx = perf_swevent_get_recursion_context();
 	ret = perf_output_begin(&handle, &sample, event,
 				throttle_event.header.size);
-	if (ret)
-		return;
+	if (!ret) {
+		perf_output_put(&handle, throttle_event);
+		perf_event__output_id_sample(event, &handle, &sample);
+		perf_output_end(&handle);
+	}

-	perf_output_put(&handle, throttle_event);
-	perf_event__output_id_sample(event, &handle, &sample);
-	perf_output_end(&handle);
+	if (rctx >= 0)
+		perf_swevent_put_recursion_context(rctx);
 }

 /*
-- 
1.8.3.1

