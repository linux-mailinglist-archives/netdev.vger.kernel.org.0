Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107C624EC41
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 10:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbgHWIxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 04:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbgHWIxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 04:53:44 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE68C061573;
        Sun, 23 Aug 2020 01:53:44 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id bh1so2784693plb.12;
        Sun, 23 Aug 2020 01:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=94G6VmuueR2zsOOi3oE6PvzdBkde1/pE7oee6OMzwvA=;
        b=T7mk3mu6oaP5Dcr9hCsIsECBhBi1vQo0G77W1aSpL3Q78nhtTRfNkeUK9jTZMTsodL
         J54IYwHg8ksjblzsTkwnwdQxdT0MGGXaiMVMqwWGQR2fsgQqyu9uK2+P18GPv01yENTE
         ykI0dEEzeK0xF/2Q5oOzXDqqZ9Kr9u01WSwqttwrJAgp5sLEG1GnrqNUdLG+92rRaI9s
         n7Qi45aoLcYcUuUSfUp68elIJPeRDcCtKXHzrIUHT35AcFF2za1OSfcLRaHiwvbDbL4H
         xAwVJKcy/dfhqR/+Vbz6uOpyZxlvcKkE4CpFK5O2pEP/2vTwGKz3s/z3O5RDP2axoTsY
         +92A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=94G6VmuueR2zsOOi3oE6PvzdBkde1/pE7oee6OMzwvA=;
        b=hfrDAA3nljsv2MhQyk6/jjOABPUC56yGFV3GWoDLtKJdQEJXUsXnjs/Ska8JzFvgGp
         BkVM6n9c848rN/IBqw0TZOMCiYfdypqeye3N6mguQ0tH/fhJcFQhjxQn28060hXNVXEs
         JAK1CpqBtBvHYTjQIAERPNRopaM7G8VNzOk/0p/RT1CEPhrBzQqNFoF9yK7oqV95j7LL
         ZPsFyKn3xMFaqB9n7GciiP5rbV50O1d8IRiKmawUvl0hBnsVhHbP9pMcKyyS9RsHjKub
         IjJkdvKmTQpIyyZn+W7p1jv8tKmtITrOPgvvsIOJoKOJ4EPjbfwM/JSHSkvjkvHHF7Z6
         iFng==
X-Gm-Message-State: AOAM533vZ1FtWlgcX9l4zkha67klp+GFFYtz00dE32OOXnNFpmtmvb/h
        PsenzokdVZfDXMpLSVa9rjNaNXggUA==
X-Google-Smtp-Source: ABdhPJyriwyVXYWlYgoSnl0ACk8f+SIQWWxEENTngYD+RTJ3itY8GA4Q24ppHF36iQmhGVN1IKzo4Q==
X-Received: by 2002:a17:90a:2bc8:: with SMTP id n8mr466863pje.189.1598172823900;
        Sun, 23 Aug 2020 01:53:43 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id b15sm6128446pgk.14.2020.08.23.01.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2020 01:53:43 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next 0/3] samples: bpf: Refactor tracing programs with libbpf
Date:   Sun, 23 Aug 2020 17:53:31 +0900
Message-Id: <20200823085334.9413-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the problem of increasing fragmentation of the bpf loader programs,
instead of using bpf_loader.o, which is used in samples/bpf, this
patch refactors the existing kprobe, tracepoint tracing programs with 
libbbpf bpf loader.

    - For kprobe events pointing to system calls, the SYSCALL() macro in
    trace_common.h was used.
    - Adding a kprobe/tracepoint event and attaching a bpf program to it
    was done through bpf_program_attach().
    - Instead of using the existing BPF MAP definition, MAP definition
    has been refactored with the new BTF-defined MAP format.

Daniel T. Lee (3):
  samples: bpf: cleanup bpf_load.o from Makefile
  samples: bpf: Refactor kprobe tracing programs with libbpf
  samples: bpf: Refactor tracepoint tracing programs with libbpf

 samples/bpf/Makefile                          | 18 ++---
 samples/bpf/cpustat_kern.c                    | 36 +++++-----
 samples/bpf/cpustat_user.c                    | 47 +++++++++++--
 samples/bpf/lathist_kern.c                    | 24 +++----
 samples/bpf/lathist_user.c                    | 42 ++++++++++--
 samples/bpf/offwaketime_kern.c                | 52 +++++++-------
 samples/bpf/offwaketime_user.c                | 66 ++++++++++++++----
 samples/bpf/spintest_kern.c                   | 36 +++++-----
 samples/bpf/spintest_user.c                   | 68 +++++++++++++++----
 samples/bpf/syscall_tp_kern.c                 | 24 +++----
 samples/bpf/syscall_tp_user.c                 | 54 +++++++++++----
 .../bpf/test_current_task_under_cgroup_kern.c | 27 ++++----
 .../bpf/test_current_task_under_cgroup_user.c | 52 +++++++++++---
 samples/bpf/test_probe_write_user_kern.c      | 12 ++--
 samples/bpf/test_probe_write_user_user.c      | 49 ++++++++++---
 samples/bpf/trace_output_kern.c               | 15 ++--
 samples/bpf/trace_output_user.c               | 55 ++++++++++-----
 17 files changed, 465 insertions(+), 212 deletions(-)

-- 
2.25.1

