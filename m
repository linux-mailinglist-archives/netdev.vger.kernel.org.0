Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8078C505541
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 15:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241291AbiDRNLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 09:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242500AbiDRNJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 09:09:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 523D435AB1;
        Mon, 18 Apr 2022 05:48:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72DBA6124E;
        Mon, 18 Apr 2022 12:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A156C385A8;
        Mon, 18 Apr 2022 12:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650286118;
        bh=KmajxESK8s8AkUiyXrriHM2As/5Rutgyy3pyGp7Dfpw=;
        h=From:To:Cc:Subject:Date:From;
        b=NRsrd2MA/OPrNtCaN+Nj/Bu+3wODoyvLAxJ+zaLF/8NcxUDef7pTSFIgE4be2rXXg
         y4EbE9eyWlpwSQ7sqnxqTZRfGK2eIeu2kVGrvfab5QoTSXbtjBblSv7YAqWz8dMza0
         zWzanoEqFmj3c/OiRfr/7WjPgOiW9yTQRxQ38e/szi+JmLz9DACybkVXnMKc6WK/vR
         fqYNZxJQrm6pVyYlXgtygDJwtJg1IHAMIw+6ul5M8GmhbGKBtT2F6TovMgXzUD/Gsz
         zGFvNOraEsj7x6fkgHP414atkl7797eFH0V4VN6sSB/WG871Ge8D4IdUwKzHFhMG20
         P4nkrT2Uo2tOw==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCHv2 bpf-next 0/4] bpf: Speed up symbol resolving in kprobe multi link
Date:   Mon, 18 Apr 2022 14:48:30 +0200
Message-Id: <20220418124834.829064-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
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
sending additional fix for symbol resolving in kprobe multi link
requested by Alexei and Andrii [1].

This speeds up bpftrace kprobe attachment, when using pure symbols
(3344 symbols) to attach:

Before:

  # perf stat -r 5 -e cycles ./src/bpftrace -e 'kprobe:x* {  } i:ms:1 { exit(); }'
  ...
  6.5681 +- 0.0225 seconds time elapsed  ( +-  0.34% )

After:

  # perf stat -r 5 -e cycles ./src/bpftrace -e 'kprobe:x* {  } i:ms:1 { exit(); }'
  ...
  0.5661 +- 0.0275 seconds time elapsed  ( +-  4.85% )


v2 changes (first version [2]):
  - removed the 2 seconds check [Alexei]
  - moving/forcing symbols sorting out of kallsyms_lookup_names function [Alexei]
  - skipping one array allocation and copy_from_user [Andrii]
  - several small fixes [Masami,Andrii]
  - build fix [kernel test robot]

thanks,
jirka


[1] https://lore.kernel.org/bpf/CAEf4BzZtQaiUxQ-sm_hH2qKPRaqGHyOfEsW96DxtBHRaKLoL3Q@mail.gmail.com/
[2] https://lore.kernel.org/bpf/20220407125224.310255-1-jolsa@kernel.org/
---
Jiri Olsa (4):
      kallsyms: Add kallsyms_lookup_names function
      fprobe: Resolve symbols with kallsyms_lookup_names
      bpf: Resolve symbols with kallsyms_lookup_names for kprobe multi link
      selftests/bpf: Add attach bench test

 include/linux/kallsyms.h                                   |   6 ++++++
 kernel/kallsyms.c                                          |  70 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/trace/bpf_trace.c                                   | 113 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------
 kernel/trace/fprobe.c                                      |  32 ++++++++++++--------------------
 tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c | 136 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/kprobe_multi_empty.c     |  12 ++++++++++++
 6 files changed, 302 insertions(+), 67 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/kprobe_multi_empty.c
