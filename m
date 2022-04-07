Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02A2B4F8AFC
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 02:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbiDGWdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 18:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbiDGWdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 18:33:17 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2B346640
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 15:31:15 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a143-20020a25ca95000000b0063d8415a03dso5235699ybg.23
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 15:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=dqxIaiuwYB3bO0Dv4QbRVtEexvrTpqg03foYHPZyS8U=;
        b=fk7Me382LQwIaP+R5dmK/llWrb7kvT/CdnLDRt7o+SSM0Tvurx8VFRRGyOnJu1nvJZ
         NURDoDsCMqbPmjO5UuL8Dc3SRB0kPcuVu7A8k5i43AH/ERRywxyYVMSvYuz787UvEUPl
         kwEManMb42eKLcLrZY5ME07w4YdL54kKQYYZ6zWROIJOTScbdFSv1u2OQBYL0agaSyDN
         e64K7oOn8WOdwEhYJbrFDwheIl3nKr1FNjuPEMC6LqPHOMFdUE1fFQQqjJdpRTCqZaBE
         pa3vWNCG43BOU/Bhtw+qoR90mSpSbVCrGRMeCkEOQ7WPAEa4LJsNACjkTY/1a9t4m+fh
         roOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=dqxIaiuwYB3bO0Dv4QbRVtEexvrTpqg03foYHPZyS8U=;
        b=rRO3XuFxt2kdTQa0t5eVeuxak4vyNGFsagRCsizbmmr9RZyBTU8PkXoRj8DhRUivT4
         oEMFs0auqXREV5idWCiqMf2unHnAxkEOHqGUktBz3bIgGURWzg1qoDlzKQgV9jdubS/L
         JvdzK+oKdIwqSScNWBk9qRS734zrwTnU41XxwmOlrkBkE1EnEezCowt2Gyl+88YBS+dD
         GPZp8Gn5jEdYFPEptGNYjRvheI4CdVIYPVtzWLE6yL1viFkclP+zM2ST93pRy6UtdTdd
         3QfierWjxaIQ4KQa7K+WJ+51frgGCUYwaFWlJWRGvDdBW6HQLBR4NtOIdLMNKVxYcV2A
         QORw==
X-Gm-Message-State: AOAM532ipz1IGEcgsjcjDq72z7aB1IdmLhaPHMByG9XSB3X30mXG5RHd
        fnt2fw0k50NXYoyzhmENXwrBdRsVHYa4VpLYj/QrQL4GQoUzfYsOO7YXo30PINqPOrLr/229tkt
        ld++/4HwnsDFabg6CY2sY5913hOj78QHcvb9EhnQD4fzJuSfYWosIig==
X-Google-Smtp-Source: ABdhPJzGkuMTQLmGDG3SUnc2GiKndxn1d7tTsJgnSePZLKTRrViJJRUbSfAj3Gv9QWxcWdtI2rw91CU=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:9e25:5910:c207:e29a])
 (user=sdf job=sendgmr) by 2002:a05:6902:30d:b0:63e:c44:6006 with SMTP id
 b13-20020a056902030d00b0063e0c446006mr11565426ybs.367.1649370674525; Thu, 07
 Apr 2022 15:31:14 -0700 (PDT)
Date:   Thu,  7 Apr 2022 15:31:05 -0700
Message-Id: <20220407223112.1204582-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH bpf-next v3 0/7] bpf: cgroup_sock lsm flavor
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

v3:
- add BPF_LSM_CGROUP to bpftool
- use simple int instead of refcnt_t (to avoid use-after-free
  false positive)

v2:
- addressed build bot failures

Stanislav Fomichev (7):
  bpf: add bpf_func_t and trampoline helpers
  bpf: per-cgroup lsm flavor
  bpf: minimize number of allocated lsm slots per program
  bpf: allow writing to a subset of sock fields from lsm progtype
  libbpf: add lsm_cgoup_sock type
  selftests/bpf: lsm_cgroup functional test
  selftests/bpf: verify lsm_cgroup struct sock access

 include/linux/bpf-cgroup-defs.h               |   8 +
 include/linux/bpf.h                           |  24 +-
 include/linux/bpf_lsm.h                       |   8 +
 include/uapi/linux/bpf.h                      |   1 +
 kernel/bpf/bpf_lsm.c                          | 147 ++++++++++++
 kernel/bpf/btf.c                              |  11 +
 kernel/bpf/cgroup.c                           | 210 ++++++++++++++++--
 kernel/bpf/syscall.c                          |  10 +
 kernel/bpf/trampoline.c                       | 205 ++++++++++++++---
 kernel/bpf/verifier.c                         |   4 +-
 tools/bpf/bpftool/common.c                    |   1 +
 tools/include/uapi/linux/bpf.h                |   1 +
 tools/lib/bpf/libbpf.c                        |   2 +
 .../selftests/bpf/prog_tests/lsm_cgroup.c     | 158 +++++++++++++
 .../testing/selftests/bpf/progs/lsm_cgroup.c  |  94 ++++++++
 tools/testing/selftests/bpf/test_verifier.c   |  54 ++++-
 .../selftests/bpf/verifier/lsm_cgroup.c       |  34 +++
 17 files changed, 914 insertions(+), 58 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c
 create mode 100644 tools/testing/selftests/bpf/progs/lsm_cgroup.c
 create mode 100644 tools/testing/selftests/bpf/verifier/lsm_cgroup.c

-- 
2.35.1.1178.g4f1659d476-goog

