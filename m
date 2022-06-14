Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDFE54A3C5
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 03:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344816AbiFNBrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 21:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241423AbiFNBre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 21:47:34 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4232DF66
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 18:47:28 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-30c1d90587dso13202517b3.14
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 18:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=l4PjIvONm1IQKFepEMuDqPyve0EvuaStAKHleWOI5U4=;
        b=keMrD0lK99MmEmZqNHED9SqQIvx29ap+MgANfW658dwlfZvJrsoNWlI9FXDBxqa+za
         VARGdXXoJmn5KryQWZj+8ScXKK6VXqNwAmxBq3WrvJtTYqyF49pPQeabsvoQ33dd7Zm9
         GUdC5cio7eBOfzPKl6VgquXY1jLeMHFBa0mblXnksXxjh9ZBheHBbS2YBLkmyB2cnv0z
         RODtwrbl065MJcM4aR2i0vB2oIgwB4RMKqps974SsAItXpR+hUM9whwp/5wZxzkdRDOz
         ZEJKu26kcTh5Mj7t2oGlCPJPuLSeewLtsuZoU0kfm6Fy8cQ92KsRwUtE31ZwuEw4o661
         pfTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=l4PjIvONm1IQKFepEMuDqPyve0EvuaStAKHleWOI5U4=;
        b=Zx+1irRuOULinK3TaBC7hWEw+QnJ0ixCtXrWeRoLpc+9XKFv3POX75ZO6WlF8BqArq
         wDypwvIbv+lz4x6cFHS+x/5DvsYT4RminESzIdD3nBGxdg22G5sx5j02YgkmttKiGQY9
         2mF6QqcXrasQCpdKeGnDZM4Q+sCQAjFb8Ppllx6gNezOvH4nUtEuWWUN9UOk3LP+77Yc
         D0W4cNLLzBtO3pzcJ6Ev/CrE0QR6JKQAh/0hk/L4r8XEbMSPmrpWHxgteRz/PibQmBbT
         +VrPuktke69ThcrVJchaFNbqKkw9jZMM/D4KgBme5hs0pB803eRiD1BbuFPHgooqtcbl
         +mtg==
X-Gm-Message-State: AJIora//hBc6xEQxRkyUWmw0PKtDR/dd1BHM2vGByeM+AXmZkMaI8KMM
        0wekqrs9JodQA7TGMu7YHxKWqMUaHgbK
X-Google-Smtp-Source: AGRyM1subzJdwRtf+vAOstyD6tqNevSviIR17aL9d/daU5mnA6A1DY7dA9Gj0iqv9t7BAYwDQeVntF57tsLy
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:e4b4:1d0c:1c56:a7ed])
 (user=irogers job=sendgmr) by 2002:a25:3c45:0:b0:664:cf75:c2d6 with SMTP id
 j66-20020a253c45000000b00664cf75c2d6mr2520288yba.446.1655171248020; Mon, 13
 Jun 2022 18:47:28 -0700 (PDT)
Date:   Mon, 13 Jun 2022 18:47:14 -0700
Message-Id: <20220614014714.1407239-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH] perf bpf: 8 byte align bpil data
From:   Ian Rogers <irogers@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Quentin Monnet <quentin@isovalent.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpil data is accessed assuming 64-bit alignment resulting in undefined
behavior as the data is just byte aligned. With an -fsanitize=undefined
build the following errors are observed:

$ sudo perf record -a sleep 1
util/bpf-event.c:310:22: runtime error: load of misaligned address 0x55f61084520f for type '__u64', which requires 8 byte alignment
0x55f61084520f: note: pointer points here
 a8 fe ff ff 3c  51 d3 c0 ff ff ff ff 04  84 d3 c0 ff ff ff ff d8  aa d3 c0 ff ff ff ff a4  c0 d3 c0
             ^
util/bpf-event.c:311:20: runtime error: load of misaligned address 0x55f61084522f for type '__u32', which requires 4 byte alignment
0x55f61084522f: note: pointer points here
 ff ff ff ff c7  17 00 00 f1 02 00 00 1f  04 00 00 58 04 00 00 00  00 00 00 0f 00 00 00 63  02 00 00
             ^
util/bpf-event.c:198:33: runtime error: member access within misaligned address 0x55f61084523f for type 'const struct bpf_func_info', which requires 4 byte alignment
0x55f61084523f: note: pointer points here
 58 04 00 00 00  00 00 00 0f 00 00 00 63  02 00 00 3b 00 00 00 ab  02 00 00 44 00 00 00 14  03 00 00

Correct this by rouding up the data sizes and aligning the pointers.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/bpf-utils.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/bpf-utils.c b/tools/perf/util/bpf-utils.c
index e271e05e51bc..80b1d2b3729b 100644
--- a/tools/perf/util/bpf-utils.c
+++ b/tools/perf/util/bpf-utils.c
@@ -149,11 +149,10 @@ get_bpf_prog_info_linear(int fd, __u64 arrays)
 		count = bpf_prog_info_read_offset_u32(&info, desc->count_offset);
 		size  = bpf_prog_info_read_offset_u32(&info, desc->size_offset);
 
-		data_len += count * size;
+		data_len += roundup(count * size, sizeof(__u64));
 	}
 
 	/* step 3: allocate continuous memory */
-	data_len = roundup(data_len, sizeof(__u64));
 	info_linear = malloc(sizeof(struct perf_bpil) + data_len);
 	if (!info_linear)
 		return ERR_PTR(-ENOMEM);
@@ -180,7 +179,7 @@ get_bpf_prog_info_linear(int fd, __u64 arrays)
 		bpf_prog_info_set_offset_u64(&info_linear->info,
 					     desc->array_offset,
 					     ptr_to_u64(ptr));
-		ptr += count * size;
+		ptr += roundup(count * size, sizeof(__u64));
 	}
 
 	/* step 5: call syscall again to get required arrays */
-- 
2.36.1.476.g0c4daa206d-goog

