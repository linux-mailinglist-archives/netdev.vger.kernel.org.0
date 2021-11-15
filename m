Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A28C045148F
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 21:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242809AbhKOUK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 15:10:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:44634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244890AbhKOTSL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 14:18:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CE786332C;
        Mon, 15 Nov 2021 18:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000697;
        bh=GWtHFQckl+yFlyGQ1kdPONnP5sWG9iA+kUgmhWRoimc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V29K0XlvuaU2agk4ECI3IDbTR4ImyahnXpE46sUfEags2d4kea2x67hFb+HKTQHmF
         YmaZqmKCsH6tcAvf6BQu986wednUbZ5hEF3k2h1r7TBCskh2JxXykW6QPeSs4DAWm3
         VAHcGLKpLiLdZ+dxYWtyVavQGOo+RwW60Ka2Wlpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Rogers <irogers@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Stephane Eranian <eranian@google.com>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 758/849] perf bpf: Add missing free to bpf_event__print_bpf_prog_info()
Date:   Mon, 15 Nov 2021 18:04:01 +0100
Message-Id: <20211115165445.893796427@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ian Rogers <irogers@google.com>

[ Upstream commit 88c42f4d6cb249eb68524282f8d4cc32f9059984 ]

If btf__new() is called then there needs to be a corresponding btf__free().

Fixes: f8dfeae009effc0b ("perf bpf: Show more BPF program info in print_bpf_prog_info()")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Yonghong Song <yhs@fb.com>
Cc: bpf@vger.kernel.org
Cc: netdev@vger.kernel.org
Link: http://lore.kernel.org/lkml/20211106053733.3580931-2-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/bpf-event.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
index 17a9844e4fbf8..53d6c6f449c9c 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -564,7 +564,7 @@ void bpf_event__print_bpf_prog_info(struct bpf_prog_info *info,
 		synthesize_bpf_prog_name(name, KSYM_NAME_LEN, info, btf, 0);
 		fprintf(fp, "# bpf_prog_info %u: %s addr 0x%llx size %u\n",
 			info->id, name, prog_addrs[0], prog_lens[0]);
-		return;
+		goto out;
 	}
 
 	fprintf(fp, "# bpf_prog_info %u:\n", info->id);
@@ -574,4 +574,6 @@ void bpf_event__print_bpf_prog_info(struct bpf_prog_info *info,
 		fprintf(fp, "# \tsub_prog %u: %s addr 0x%llx size %u\n",
 			i, name, prog_addrs[i], prog_lens[i]);
 	}
+out:
+	btf__free(btf);
 }
-- 
2.33.0



