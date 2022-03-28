Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0944E9EC7
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 20:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245139AbiC1SS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 14:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245136AbiC1SS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 14:18:28 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C462045AD2
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 11:16:47 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2e6aaf57a0eso118249287b3.11
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 11:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Ks5inujeHMEVxUB7zAVWQxnHOqdx1mqab5HUZltc7vU=;
        b=J6u58MRMuLgKkN16tqDK8PNzqa87b4p96x0rqR++F8OKJiVqcIKgMDr7gwanIYANyi
         moIgDDt6nII49PSEg7lqS9u2+9Cw50bUoUAt4Zus4l6BW7Mnb9xnYhJSGKX/O56KZ6XA
         Tr5v6uFb42Pc/5C168XSU+HerlZJFmPcKXk6EXMDsHhj7XEd7YZSu/M7MJOBF5GOVZcU
         IUVxJe2zCGe6ft1UbMeIG3UyVa3MGwO/SYu2u4yjy6qsiFT54b4NVFxA6NsnLlMeisxp
         IfHXCfHS0ijUr8cTyBL8Cq5+t6C8akBAk98LzBTNpWr2ugnMZ6hQkR+9XbP+wEwNao3a
         8KTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Ks5inujeHMEVxUB7zAVWQxnHOqdx1mqab5HUZltc7vU=;
        b=VYM7/C43aI8rCY2OFIVyeFhECqWMt7Unio82gY48zrKuwXn7zgU7EOawLMfwJmpx/A
         do2Wjq28rJayAUgdIg9N+sHG3FAmasquAqLuEsqwFrmJ51Yx81Cjkct3CVpUK9lYawAK
         LKt65Gol4wUi9ST04gnoKwk9lmN5h9w/z3NEXlW9ErOCL7TkPyzOu8eL1Q9zU+AFYpFx
         b+mxYTM505v+R3Uq6FkMeBDXEFSJemxhdFskneX2xuvZan2Xf2B1cAzSCck2l9nqWKBm
         MzDb5wtVfGDwEXNsXg+xhWtveudmG+/alneGBBtiiezz+J1YqYhU+J1CGS3R4XpbJMdS
         ll0Q==
X-Gm-Message-State: AOAM530bR2bPIXhD8Hv277Zw/NipuI6q1cU4RVzptbFOJUWAxy6CyP1B
        pI+5v0uBTY3n9B18c7qSfxzyfYHyI7aG4pGFi1z8uo0yc8mBiHuC+QjMrRR7S97NR56dgKLYX3J
        p3nd8fKgT0wg+jOtRE2OqfttO5Tyfk09YkNxXk9gKBSPie7MABXkXiw==
X-Google-Smtp-Source: ABdhPJyiUre3if+KZ6bOtuzRKbFV/CUrxNUqw8n01nz4/VaZSJ046RPKFMkzTHFaytf7wBoFfeAXjz0=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:a900:e0f6:cf98:d8c8])
 (user=sdf job=sendgmr) by 2002:a0d:c906:0:b0:2e7:f90b:5a4e with SMTP id
 l6-20020a0dc906000000b002e7f90b5a4emr20096282ywd.51.1648491406922; Mon, 28
 Mar 2022 11:16:46 -0700 (PDT)
Date:   Mon, 28 Mar 2022 11:16:37 -0700
Message-Id: <20220328181644.1748789-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH bpf-next 0/7] bpf: cgroup_sock lsm flavor
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>, kafai@fb.com,
        kpsingh@kernel.org
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

This series implements new lsm flavor for attaching per-cgroup programs to
existing lsm hooks. The cgroup is taken out of 'current', unless
the first argument of the hook is 'struct socket'. In this case,
the cgroup association is taken out of socket. The attachment
looks like a regular per-cgroup attachment: we add new BPF_LSM_CGROUP
attach type which, together with attach_btf_id, signals per-cgroup lsm.
Behind the scenes, we allocate trampoline shim program and
attach to lsm. This program looks up cgroup from current/socket
and runs cgroup's effective prog array. The rest of the per-cgroup BPF
stays the same: hierarchy, local storage, retval conventions
(return 1 == success).

Current limitations:
* haven't considered sleepable bpf; can be extended later on
* not sure the verifier does the right thing with null checks;
  see latest selftest for details
* total of 10 (global) per-cgroup LSM attach points; this bloats
  bpf_cgroup a bit

Cc: ast@kernel.org
Cc: daniel@iogearbox.net
Cc: kafai@fb.com
Cc: kpsingh@kernel.org

Stanislav Fomichev (7):
  bpf: add bpf_func_t and trampoline helpers
  bpf: per-cgroup lsm flavor
  bpf: minimize number of allocated lsm slots per program
  bpf: allow writing to a subset of sock fields from lsm progtype
  libbpf: add lsm_cgoup_sock type
  selftests/bpf: lsm_cgroup functional test
  selftests/bpf: verify lsm_cgroup struct sock access

 include/linux/bpf-cgroup-defs.h               |   8 +
 include/linux/bpf.h                           |  25 ++-
 include/linux/bpf_lsm.h                       |   8 +
 include/uapi/linux/bpf.h                      |   1 +
 kernel/bpf/bpf_lsm.c                          | 147 +++++++++++++
 kernel/bpf/btf.c                              |  11 +
 kernel/bpf/cgroup.c                           | 198 +++++++++++++++--
 kernel/bpf/syscall.c                          |  10 +
 kernel/bpf/trampoline.c                       | 205 +++++++++++++++---
 kernel/bpf/verifier.c                         |   4 +-
 tools/include/uapi/linux/bpf.h                |   1 +
 tools/lib/bpf/libbpf.c                        |   2 +
 .../selftests/bpf/prog_tests/lsm_cgroup.c     | 158 ++++++++++++++
 .../testing/selftests/bpf/progs/lsm_cgroup.c  |  94 ++++++++
 tools/testing/selftests/bpf/test_verifier.c   |  54 ++++-
 .../selftests/bpf/verifier/lsm_cgroup.c       |  34 +++
 16 files changed, 902 insertions(+), 58 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c
 create mode 100644 tools/testing/selftests/bpf/progs/lsm_cgroup.c
 create mode 100644 tools/testing/selftests/bpf/verifier/lsm_cgroup.c

-- 
2.35.1.1021.g381101b075-goog

