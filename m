Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3309454EAF2
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 22:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378284AbiFPUWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 16:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbiFPUWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 16:22:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51CD65B3C6;
        Thu, 16 Jun 2022 13:22:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2D57B82604;
        Thu, 16 Jun 2022 20:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CAD2C34114;
        Thu, 16 Jun 2022 20:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655410940;
        bh=9RllCRm9hOwGB74wm9vFOEE5iJuWq+u1U1gnB/VeY64=;
        h=From:To:Cc:Subject:Date:From;
        b=LKZLJuBU0gF3dWB1qVxeS15RamUa5kVQiFdJkjvlDgaYQnv5L3aB6FLtDIsDIfGne
         +gqjH/NhjqVMsUA1Cj0SDk0xzuCM3LDABl89WTC/vTuT2wd1gf3KDEiYsCoU3Z3o45
         YMEq/6ho1vOs2S2RfakUR5dgbUyrjRm4sg4o7Tn1KeaaYbn6HDzT+F91OgnWpDMZRV
         HR2EAmQuIme0d0m4iR/j511rRgi0Ry1Mm+jzXHZVRQ/IFwqA3Kz3/YqkcLA3ODnVWm
         wziUO/p9dLksm+PAqhi3aPji3ZiNdTtjhbk7aH1h4aJDIgeKTab1OdLsrnKAD6FOX5
         phXJo+m+He0oQ==
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
Subject: [PATCHv5 bpf-next 0/1] perf tools: Fix prologue generation
Date:   Thu, 16 Jun 2022 22:22:13 +0200
Message-Id: <20220616202214.70359-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
sending change we discussed some time ago [1] to get rid of
some deprecated functions we use in perf prologue code.

Despite the gloomy discussion I think the final code does
not look that bad ;-)

This patchset removes following libbpf functions from perf:
  bpf_program__set_prep
  bpf_program__nth_fd
  struct bpf_prog_prep_result

v5 changes:
  - squashed patches together so we don't break bisection [Arnaldo]

v4 changes:
  - fix typo [Andrii]

v3 changes:
  - removed R0/R1 zero init in libbpf_prog_prepare_load_fn,
    because it's not needed [Andrii]
  - rebased/post on top of bpf-next/master which now has
    all the needed perf/core changes

v2 changes:
  - use fallback section prog handler, so we don't need to
    use section prefix [Andrii]
  - realloc prog->insns array in bpf_program__set_insns [Andrii]
  - squash patch 1 from previous version with
    bpf_program__set_insns change [Daniel]
  - patch 3 already merged [Arnaldo]
  - added more comments

thanks,
jirka


[1] https://lore.kernel.org/bpf/CAEf4BzaiBO3_617kkXZdYJ8hS8YF--ZLgapNbgeeEJ-pY0H88g@mail.gmail.com/
---
Jiri Olsa (1):
      perf tools: Rework prologue generation code

 tools/perf/util/bpf-loader.c | 204 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 175 insertions(+), 29 deletions(-)
