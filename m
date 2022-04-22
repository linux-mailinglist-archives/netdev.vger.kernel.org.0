Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB7D50B48C
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 12:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446347AbiDVKDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 06:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348202AbiDVKDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 06:03:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15223CFFD;
        Fri, 22 Apr 2022 03:00:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E6AB61E0D;
        Fri, 22 Apr 2022 10:00:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97CBC385A4;
        Fri, 22 Apr 2022 10:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650621654;
        bh=l3QQdpXdux2M4AyDc26VJwNvtk8Vaco1LZHB5M52YYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ru6TTEKUp6T28F5HUuIo6smBeiiu1WspTfaSHfTaXJAF6wExVAde87EJH58jNlOvl
         o95d1M/wY0AbXrumgzvmzSgFT9MHtqbHMMY6yT+syjMBAauz5NIk/eEyQI4GhsldAs
         //PZRcbLM4LpZh+KKpT7uLlbI9fOkO9Ti+fjgTDaXUw3qlxJJJJqSxasiO8wiwynUN
         sJtc4SHugo+KicvHM1IqWfDprNK7pC0JNK+lKM/n48WbPugDmQtBe1jz5H6LMXoteI
         qrMu32Mg5DgEcnLlAvd7evPh0nWIgeMFAFLDLVwJKOp1CC09PDqUM62E31NWcSNLg9
         55UpmRflEDj2g==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     linux-perf-users@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Ian Rogers <irogers@google.com>
Subject: [PATCH perf/core 2/5] libbpf: Load prog's instructions after prog_prepare_load_fn callback
Date:   Fri, 22 Apr 2022 12:00:22 +0200
Message-Id: <20220422100025.1469207-3-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220422100025.1469207-1-jolsa@kernel.org>
References: <20220422100025.1469207-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can have changed instructions after calling
prog_prepare_load_fn callback, reload them.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/bpf/libbpf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 284790d81c1b..c8df74e5f658 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6695,6 +6695,8 @@ static int bpf_object_load_prog_instance(struct bpf_object *obj, struct bpf_prog
 				prog->name, err);
 			return err;
 		}
+		insns = prog->insns;
+		insns_cnt = prog->insns_cnt;
 	}
 
 	if (obj->gen_loader) {
-- 
2.35.1

