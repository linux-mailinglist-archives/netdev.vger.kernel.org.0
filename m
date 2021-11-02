Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 843B044257D
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 03:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbhKBCRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 22:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhKBCRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 22:17:23 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E95CC061714;
        Mon,  1 Nov 2021 19:14:49 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id p18so10309811plf.13;
        Mon, 01 Nov 2021 19:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R3O/qNibn89mV+i+4+qws+meH7SW/EJqH11QrNvHTNk=;
        b=K3HqagTdVMw7o0QkGDd3Dz5q2KMqJzIs/7eIZ9S883nnkU+ldHxnMiprSXTnPCAZ6p
         wrC8UZVVnaOY724do02l7Ds2ulR9Jjb7uapa4lqTZ3x2QYCi2CmFXEuITyBLzhkt0h6P
         J93LVLzHUA/pDslLYylb29riisY2Q1Eb+0g+plwzLr/SpE956ZzPCEdvf3KZ+EGiQ7ra
         LFReIujObJyKNnBwDz3IMei6iX9bpygvlIfm1B8l5ByXkiakYZMdroiwMuzgLu93+t/m
         f8IGmBI/ojqiAokFWqoXh9S/wdsz1IcYIz1xpD/zlvfS5M8UC4uECMD53zTc83zZoolR
         JxCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R3O/qNibn89mV+i+4+qws+meH7SW/EJqH11QrNvHTNk=;
        b=szNoetLN8WD0Zk02VR+uj5WuSzHzBuoN/2kBNUXWxhotNO+mlmuSzwri+MJbpu42rq
         rLYaEAzwWLZmNFOnRPK59Ut7B/LI+FmwFtEnkqDTKDF4H/5Ci+e3bL8aOTU+T0UMOdlm
         a49rqL1vVDPRH+WDI+0hc56E+FBjtBUR8FeIlpRJhILJZBMMZ65Zac7tFVLvl1memXIt
         6EIshz763/R0AfEAGa4FByfbjq/Lw+JSwstcgTMYXRSzW6GAIQPdDS6I/kLzu6MniGkA
         WginNqBQgszoZWWuOZT/Cgi+HsFxpOA4L2vmSctfydrx1OqPwP2tDoP+Vc3CugqbWPQj
         En6w==
X-Gm-Message-State: AOAM530YeE9UnnpQhqem0TWotViziNi0HHMaCCCgGO1pACvnU/u7upVC
        W8vVuOGHSLU7xAObaMMnP1g9q8HJkg==
X-Google-Smtp-Source: ABdhPJxJS1peSO92+vEaq6U1Cy1kpts3+6noQFak6z8gPmuBVpae/2vfma5Y7F1kR0k7umSkINB/iQ==
X-Received: by 2002:a17:90a:7e90:: with SMTP id j16mr3192744pjl.105.1635819288644;
        Mon, 01 Nov 2021 19:14:48 -0700 (PDT)
Received: from jevburton2.c.googlers.com.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j6sm14051446pgf.60.2021.11.01.19.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 19:14:48 -0700 (PDT)
From:   Joe Burton <jevburton.kernel@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Joe Burton <jevburton@google.com>
Subject: [RFC PATCH v3 0/3] Introduce BPF map tracing capability
Date:   Tue,  2 Nov 2021 02:14:29 +0000
Message-Id: <20211102021432.2807760-1-jevburton.kernel@gmail.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Burton <jevburton@google.com>

This is the third version of a patch series implementing map tracing.

Map tracing enables executing BPF programs upon BPF map updates. This
might be useful to perform upgrades of stateful programs; e.g., tracing
programs can propagate changes to maps that occur during an upgrade
operation.

This version uses trampoline hooks to provide the capability.
fentry/fexit/fmod_ret programs can attach to two new functions:
        int bpf_map_trace_update_elem(struct bpf_map* map, void* key,
                void* val, u32 flags);
        int bpf_map_trace_delete_elem(struct bpf_map* map, void* key);

These hooks work as intended for the following map types:
        BPF_MAP_TYPE_ARRAY
        BPF_MAP_TYPE_PERCPU_ARRAY
        BPF_MAP_TYPE_HASH
        BPF_MAP_TYPE_PERCPU_HASH
        BPF_MAP_TYPE_LRU_HASH
        BPF_MAP_TYPE_LRU_PERCPU_HASH

The only guarantee about the semantics of these hooks is that they execute
before the operation takes place. We cannot call them with locks held
because the hooked program might try to acquire the same locks. Thus they
may be invoked in situations where the traced map is not ultimately
updated.

The original proposal suggested exposing a function for each
(map type) x (access type). The problem I encountered is that e.g.
percpu hashtables use a custom function for some access types
(htab_percpu_map_update_elem) but a common function for others
(htab_map_delete_elem). Thus a userspace application would have to
maintain a unique list of functions to attach to for each map type;
moreover, this list could change across kernel versions. Map tracing is
easier to use with fewer functions, at the cost of tracing programs
being triggered more times.

To prevent the compiler from optimizing out the calls to my tracing
functions, I use the asm("") trick described in gcc's
__attribute__((noinline)) documentation. Experimentally, this trick
works with clang as well.

Joe Burton (3):
  bpf: Add map tracing functions and call sites
  bpf: Add selftests
  bpf: Add real world example for map tracing

 kernel/bpf/Makefile                           |   2 +-
 kernel/bpf/arraymap.c                         |   6 +
 kernel/bpf/hashtab.c                          |  25 ++
 kernel/bpf/map_trace.c                        |  25 ++
 kernel/bpf/map_trace.h                        |  18 +
 .../selftests/bpf/prog_tests/map_trace.c      | 422 ++++++++++++++++++
 .../selftests/bpf/progs/bpf_map_trace.c       |  95 ++++
 .../bpf/progs/bpf_map_trace_common.h          |  12 +
 .../progs/bpf_map_trace_real_world_common.h   | 125 ++++++
 .../bpf_map_trace_real_world_migration.c      | 102 +++++
 .../bpf/progs/bpf_map_trace_real_world_new.c  |   4 +
 .../bpf/progs/bpf_map_trace_real_world_old.c  |   5 +
 12 files changed, 840 insertions(+), 1 deletion(-)
 create mode 100644 kernel/bpf/map_trace.c
 create mode 100644 kernel/bpf/map_trace.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/map_trace.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace_common.h
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace_real_world_common.h
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace_real_world_migration.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace_real_world_new.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace_real_world_old.c

-- 
2.33.1.1089.g2158813163f-goog

