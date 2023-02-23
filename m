Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 841556A0169
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 04:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233977AbjBWDHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 22:07:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233980AbjBWDHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 22:07:37 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70202474E1;
        Wed, 22 Feb 2023 19:07:22 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id c23so6451443pjo.4;
        Wed, 22 Feb 2023 19:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=U6wLMALzHzJ/ey42lUD1+2CstzLDwzhK2uzp7X/sAT0=;
        b=NTZ+0euWEhou1Xfc7GELfDQjxjkHJH0JmfWQpUNcJtdti1txH7JpRPc0ILBI7vc9sC
         7/ScTcbRe9B0DS2dYkej6/9ltm42qpnVW0ie+2j9BmGapMiAwcWT9bSE0X5ui7GUQsB3
         GDMufj6Zw1+GGThIg3rWYykotqDxj0iUJ9NydZoGKBgO/Sn2jQF1KX9J/eP0eVNBJEtC
         xqMSnqBYXRUImd7avM9AwP6d3pYjqUlVwOivE8CCMVml+Ey9mIN52nsfBNgr38jQq5n0
         EkgASMYZtz7BXI6rFz+/t013C2QMuEeNd4X83uv+xFynFD2hF6CYPguJB8mAdJ/eVDJw
         5nAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U6wLMALzHzJ/ey42lUD1+2CstzLDwzhK2uzp7X/sAT0=;
        b=i5aejMR2FUnMR/DPM75U26j+FSMva2HwsImEKxge70OholDrTt5ug88npybYmZFKTD
         Ovc98e1mL2q0BhaZcv3EmoeKVPyUf7JpuPwJlry5hspWreeEmx4Rba/0ChwA11pQ+zhC
         wfDHirltr5/oPN32HKQTPBaKGCCb8doN2ziNNM+Wnufu5gByB2xYEETRCT38BYSt6cPY
         s1uiXI3yCKEd4BPfjkwSwR2khA0FCTavIH6zSZKRX5WhPcgfy9TpxliiVIEfxhnTB60/
         ettKzptBfTv/Y943i8SNOd9fK+Yd9EFs12eTww0+jlNw87FcMU2aZ1vgntlYVBSJVWhf
         GQPA==
X-Gm-Message-State: AO0yUKWqVF3Ezd56NZXG+PUzQb0H3d43ugcIsIw2tyJz+Vd7YSNBa4BI
        /Z86AxU70afmyZthH3iEcdE=
X-Google-Smtp-Source: AK7set9UUujFGmUMF9WbB85Onnb1d2G0sDSPxn7zlIBICOfzkesrCxHdYL+HrQdhbMJ4JRXut9YgIQ==
X-Received: by 2002:a17:902:e80c:b0:19a:df6a:726f with SMTP id u12-20020a170902e80c00b0019adf6a726fmr12292797plg.61.1677121641737;
        Wed, 22 Feb 2023 19:07:21 -0800 (PST)
Received: from localhost.localdomain ([2620:10d:c090:400::5:9cb3])
        by smtp.gmail.com with ESMTPSA id t18-20020a170902d21200b0019337bf957dsm6879912ply.296.2023.02.22.19.07.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 22 Feb 2023 19:07:21 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v2 bpf-next 0/4] bpf: Introduce kptr_rcu.
Date:   Wed, 22 Feb 2023 19:07:13 -0800
Message-Id: <20230223030717.58668-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

v1->v2:
Instead of agressively allow dereferenced kptr_rcu pointers into KF_TRUSTED_ARGS
kfuncs only allow them into KF_RCU funcs.
The KF_RCU flag is a weaker version of KF_TRUSTED_ARGS. The kfuncs marked with
KF_RCU expect either PTR_TRUSTED or MEM_RCU arguments. The verifier guarantees
that the objects are valid and there is no use-after-free, but the pointers
maybe NULL and pointee object's reference count could have reached zero, hence
kfuncs must do != NULL check and consider refcnt==0 case when accessing such
arguments.
No changes in patch 1.
Patches 2,3,4 adjusted with above behavior.

v1:
The __kptr_ref turned out to be too limited, since any "trusted" pointer access
requires bpf_kptr_xchg() which is impractical when the same pointer needs
to be dereferenced by multiple cpus.
The __kptr "untrusted" only access isn't very useful in practice.
Rename __kptr to __kptr_untrusted with eventual goal to deprecate it,
and rename __kptr_ref to __kptr, since that looks to be more common use of kptrs.
Introduce __kptr_rcu that can be directly dereferenced and used similar
to native kernel C code.
Once bpf_cpumask and task_struct kfuncs are converted to observe RCU GP
when refcnt goes to zero, both __kptr and __kptr_untrusted can be deprecated
and __kptr_rcu can become the only __kptr tag.

Alexei Starovoitov (4):
  bpf: Rename __kptr_ref -> __kptr and __kptr -> __kptr_untrusted.
  bpf: Introduce kptr_rcu.
  selftests/bpf: Add a test case for kptr_rcu.
  selftests/bpf: Tweak cgroup kfunc test.

 Documentation/bpf/bpf_design_QA.rst           |  4 +--
 Documentation/bpf/cpumasks.rst                |  4 +--
 Documentation/bpf/kfuncs.rst                  | 13 ++++----
 include/linux/bpf.h                           | 15 ++++++---
 include/linux/btf.h                           |  2 +-
 kernel/bpf/btf.c                              | 26 +++++++++++++--
 kernel/bpf/helpers.c                          |  7 ++--
 kernel/bpf/syscall.c                          |  4 +++
 kernel/bpf/verifier.c                         | 33 ++++++++++++-------
 net/bpf/test_run.c                            |  3 +-
 tools/lib/bpf/bpf_helpers.h                   |  3 +-
 tools/testing/selftests/bpf/progs/cb_refs.c   |  2 +-
 .../selftests/bpf/progs/cgrp_kfunc_common.h   |  2 +-
 .../selftests/bpf/progs/cgrp_kfunc_failure.c  |  2 +-
 .../selftests/bpf/progs/cgrp_kfunc_success.c  |  7 +++-
 .../selftests/bpf/progs/cpumask_common.h      |  2 +-
 .../selftests/bpf/progs/jit_probe_mem.c       |  2 +-
 tools/testing/selftests/bpf/progs/lru_bug.c   |  2 +-
 tools/testing/selftests/bpf/progs/map_kptr.c  | 18 ++++++++--
 .../selftests/bpf/progs/map_kptr_fail.c       |  6 ++--
 .../selftests/bpf/progs/task_kfunc_common.h   |  2 +-
 tools/testing/selftests/bpf/test_verifier.c   | 22 ++++++-------
 tools/testing/selftests/bpf/verifier/calls.c  |  2 +-
 23 files changed, 123 insertions(+), 60 deletions(-)

-- 
2.30.2

