Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B055D52F4E7
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 23:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238777AbiETVSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 17:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232505AbiETVSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 17:18:33 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A02A19C758
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 14:18:31 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2ff40ee8109so79984047b3.14
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 14:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=18bwlj3FX7yKV9w1kkR962CK79p7S27hQhP4LX/pIKQ=;
        b=mGLUmGi7jHY+PecyF64Hh2M2xvayEJfgYAn0zfQ9IgXvts4wFfUo/cOK2a3daAlpgg
         Z/x0HHvPMLlPCHc9MstENKUlKWNXgfRsbiUOAaaTTp4LGCLLob8PqJE00c56hO8yBeA5
         UYaUuo/kE5Q5H3FnALF4QALDGnNih0qa6kUuob34d/lJi+Ur/6bZI614pp9by3LrWZvR
         H1iqBas8ASIS/p9lPF1kbYol7QbDHQx11F8zRDfz8JOi/CTwHzmBV3jsYPFlrgD5u/QU
         z+QN4QXG7G/hJ3pPyosd8UGGfLmcfl1mee3LPkMxTAK8Ly0VQ1hBj69p/QL19CckSzlb
         paoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=18bwlj3FX7yKV9w1kkR962CK79p7S27hQhP4LX/pIKQ=;
        b=AhCCwq7fYOVCETfLUHqqO59meHxUOlwCLgNnAeUw3KvCcZ4MgKXvSnLExdgkIn5Qtt
         atft2tpUCyiWixa7F6pXCunm0yET+8ZQw5HOKFZvhJqvRNF1317MAOQNmwBetBc/rIou
         /bwRbJEqJ9lcWiIQRG2Gc7Dsk5h9zTUHoer8pb+HpNFyAlSx4L4Na2IY634Ofru2yZVp
         6Kiiu05p0IZ8HGJsHJXtJ/I3CY3yjxc7N67wpiEW+6cZuIga6s0JX+Nt1UxmTRgfSzSg
         iIgjlhREfuvyBQVRm8vZj4qgD5nIPQ2DGiiv7GGtWMGYimmn2CkvUUfE83Upf25daEGK
         MFOQ==
X-Gm-Message-State: AOAM532Irrh97O2dVQlfby9J8VsziYKP84HmaKNVRcK6KhZjbF2Dh1aO
        WWGexFtncwliGGC3tIVAneboId4qJfhb
X-Google-Smtp-Source: ABdhPJyWt6SQJDsVNaO60kNg1MhSmmRPKx9jLE6nMqMy595GulDCVDpGbFVt14AFkHVJWwUIZVUuND4YgxJd
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:64b0:e751:72e8:e4a7])
 (user=irogers job=sendgmr) by 2002:a25:496:0:b0:64f:59d4:dea2 with SMTP id
 144-20020a250496000000b0064f59d4dea2mr5340798ybe.493.1653081510737; Fri, 20
 May 2022 14:18:30 -0700 (PDT)
Date:   Fri, 20 May 2022 14:18:26 -0700
Message-Id: <20220520211826.1828180-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH] perf build: Error for BPF skeletons without LIBBPF
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
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Ian Rogers <irogers@google.com>
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

LIBBPF requires LIBELF so doing "make BUILD_BPF_SKEL=1 NO_LIBELF=1"
fails with compiler errors about missing declarations. Similar could
happen if libbpf feature detection fails. Prefer to error when
BUILD_BPF_SKEL is enabled but LIBBPF isn't.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/Makefile.config | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index d9b699ad402c..bedb734bd6f2 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -664,6 +664,9 @@ ifdef BUILD_BPF_SKEL
   ifeq ($(feature-clang-bpf-co-re), 0)
     dummy := $(error Error: clang too old/not installed. Please install recent clang to build with BUILD_BPF_SKEL)
   endif
+  ifeq ($(filter -DHAVE_LIBBPF_SUPPORT, $(CFLAGS)),)
+    dummy := $(error Error: BPF skeleton support requires libbpf)
+  endif
   $(call detected,CONFIG_PERF_BPF_SKEL)
   CFLAGS += -DHAVE_BPF_SKEL
 endif
-- 
2.36.1.124.g0e6072fb45-goog

