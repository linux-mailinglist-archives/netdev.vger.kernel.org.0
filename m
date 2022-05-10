Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5DA2520EFE
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 09:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbiEJHvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 03:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiEJHvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 03:51:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B200189E6C;
        Tue, 10 May 2022 00:47:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22D5960C11;
        Tue, 10 May 2022 07:47:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B127DC385C8;
        Tue, 10 May 2022 07:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652168826;
        bh=k1qHqMw8XlQub7Epu9Rj6/6HIjdS2deXd99AuNOhZWk=;
        h=From:To:Cc:Subject:Date:From;
        b=XSNGQz8vUy49BegzIrwUEtrjqi/8AWrG2IhO6CZGpu5Q74BpsRqoOZ1dutd9QQReJ
         NRJXMAlqe7jjf1vYZemzVtZUTbHsIvX/5CIlBL/jv32AatzR+qQzqc916q4bF5OYXw
         vDlQPN3YzW42LapeOLSzF8pjgmrRiPY9cOxcMIRykk3PwLHCmIDCxiWVFFWQRZtV2m
         lwoL4uUPvSYXwh+31dqulIpIoOIF7qUuedS6jiAvFmNd0Ad0fWiIxQXHL5wV4fPjem
         TDACK+8WulJg0SALGSUnwoJY6WQ+Mt0fCaTSg1nzReugs/FCdEVbJat0wGcKn4jMDs
         y4jE3d18xEUgg==
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
Subject: [PATCHv2 0/3] perf tools: Fix prologue generation
Date:   Tue, 10 May 2022 09:46:56 +0200
Message-Id: <20220510074659.2557731-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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

v2 changes:
  - use fallback section prog handler, so we don't need to
    use section prefix [Andrii]
  - realloc prog->insns array in bpf_program__set_insns [Andrii]
  - squash patch 1 from previous version with
    bpf_program__set_insns change [Daniel]
  - patch 3 already merged [Arnaldo]
  - added more comments

  meanwhile.. perf/core and bpf-next diverged, so:
    - libbpf bpf_program__set_insns change is based on bpf-next/master
    - perf changes do not apply on bpf-next/master so they are based on
      perf/core ... however they can be merged only after we release
      libbpf 0.8.0 with bpf_program__set_insns change, so we don't break
      the dynamic linking
      I'm sending perf changes now just for review, I'll resend them
      once libbpf 0.8.0 is released

thanks,
jirka


[1] https://lore.kernel.org/bpf/CAEf4BzaiBO3_617kkXZdYJ8hS8YF--ZLgapNbgeeEJ-pY0H88g@mail.gmail.com/
---
Jiri Olsa (1):
      libbpf: Add bpf_program__set_insns function

 tools/lib/bpf/libbpf.c   | 22 ++++++++++++++++++++++
 tools/lib/bpf/libbpf.h   | 18 ++++++++++++++++++
 tools/lib/bpf/libbpf.map |  1 +
 3 files changed, 41 insertions(+)

Jiri Olsa (2):
      perf tools: Register fallback libbpf section handler
      perf tools: Rework prologue generation code

 tools/perf/util/bpf-loader.c | 175 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 157 insertions(+), 18 deletions(-)
