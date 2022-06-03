Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2DD153D2E6
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 22:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243793AbiFCUpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 16:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiFCUpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 16:45:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FB45B894;
        Fri,  3 Jun 2022 13:45:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F40A7B82481;
        Fri,  3 Jun 2022 20:45:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6160DC385B8;
        Fri,  3 Jun 2022 20:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654289116;
        bh=yuxPSID2uVVHczjuT1HyaKHQ8maLcXOqcB+pYQKeeso=;
        h=From:To:Cc:Subject:Date:From;
        b=X9lExf1k6GSKV/H65HL5CWEgXd6lm689I67jY7lnsp86ZUIphnoa2ZoXObIyKxcFp
         29SNC9Sodk7HdeX72fFywKRgaE4tnTh1DJxXU/PSeut63WR7jTKbd3aIZScYq9knYI
         2qyLsnDD5VclQ1HJmgRMPTCi+rybrE40L1Izg+rHDG8ISzh6bavE7dJj3OZzFN3tXA
         HKqBTWwRuClg/ha6XX7kJfD0LbqLilqhVvw+DgtdF1FU0XL83i/p7YYWqite6zyOTm
         5GswFzU+CYHZA7EwvcC6EKZ357Z09n8ttxsUFCvh0HxgbiqrdHzkpzawEGurxKVwyA
         JxFzzyCSpCZ9w==
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
Subject: [PATCHv4 bpf-next 0/2] perf tools: Fix prologue generation
Date:   Fri,  3 Jun 2022 22:45:07 +0200
Message-Id: <20220603204509.15044-1-jolsa@kernel.org>
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
Jiri Olsa (2):
      perf tools: Register fallback libbpf section handler
      perf tools: Rework prologue generation code

 tools/perf/util/bpf-loader.c | 173 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 155 insertions(+), 18 deletions(-)
