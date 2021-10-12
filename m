Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F9642A695
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237008AbhJLOBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 10:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236917AbhJLOBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 10:01:45 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0664EC061570
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 06:59:44 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id y3so34216199wrl.1
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 06:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J+GuIj3aWc+P2iq5KRg3Ocnb9emA6/eo+vt5L54uAB8=;
        b=taW16PAyESJ5O3dRnEWjPJa2DMMYr4oAUH/8HAG7iqZRv+eV4Cjf1Vja1t2FiBAFev
         flYbmHkQH1G19nooWHG3uyVLv/fvw2QSE/dasax6pbqw2Y2DrrlvlCgZqEXoogfR+xqS
         EWYIHrd/cnopoVB+lFVq+N1XNgCBrAfkX76OA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J+GuIj3aWc+P2iq5KRg3Ocnb9emA6/eo+vt5L54uAB8=;
        b=ZCSAYsR2xkrlXnqEmm9Xw4qZ81nJwZhjaIIiTzRshN1hV+qypW2maa0zhVP6ta68k0
         qITsHmh6kI3NZI1lwLFH2vWoz1dSZ8PfAK6PrWVFLYDtRMGkhbz4Fp5FUFUR3ZdJOPHW
         FmF/zq5OmI2CMn04rZbUJ7xjmb3Beh8u5fuA4ict1J7MMj3rFdqVgYuRg0gqMevR/Cev
         0oJI9daYS84p/FpFZUEOz9Y4rVD4bB9XXeGZ7eSwA+wFKWhCs/iKlTLMIRR8H6L3aWZs
         8a7HmmVeUjO6soePhGCCMfcpRVaN3cDQhEElEciwlyF6QFV4zMXRN8wOC/RlJoU3cf5s
         PMUQ==
X-Gm-Message-State: AOAM533JHq78JAhJMch6LhQTYoy+YQc6GIN+pHJ6N1es7HoyhX87/2sp
        /TVnyAMyx+byTPeaB0JwR08vNg==
X-Google-Smtp-Source: ABdhPJzEvONrPWYpm0JwryJr3pc0eUlNhggqvqv4BA1FliYf1tYhBkyS6nLO5ZstlXnqog5GloEXcg==
X-Received: by 2002:adf:aa04:: with SMTP id p4mr32712587wrd.67.1634047182565;
        Tue, 12 Oct 2021 06:59:42 -0700 (PDT)
Received: from antares.. (d.5.b.3.f.b.d.4.c.0.9.7.6.8.3.1.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:1386:790c:4dbf:3b5d])
        by smtp.gmail.com with ESMTPSA id o6sm14875894wri.49.2021.10.12.06.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 06:59:42 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     nicolas.dichtel@6wind.com, luke.r.nels@gmail.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH v2 0/4] Fix up bpf_jit_limit some more
Date:   Tue, 12 Oct 2021 14:59:31 +0100
Message-Id: <20211012135935.37054-1-lmb@cloudflare.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some more cleanups around bpf_jit_limit to make it readable via sysctl.

Jakub raised the point that a sysctl toggle is UAPI and therefore
can't be easily changed later on. I tried to find another place to stick
the info, but couldn't find a good one. All the current BPF knobs are in
sysctl.

There are examples of read only sysctls:
$ sudo find /proc/sys -perm 0444 | wc -l
90

There are no examples of sysctls with mode 0400 however:
$ sudo find /proc/sys -perm 0400 | wc -l
0

Thoughts?

Changes in v2:
* riscv not sparcv (Luke)
* Expose bpf_jit_current in bytes, not pages (Nicholas)

Lorenz Bauer (4):
  bpf: define bpf_jit_alloc_exec_limit for riscv JIT
  bpf: define bpf_jit_alloc_exec_limit for arm64 JIT
  bpf: prevent increasing bpf_jit_limit above max
  bpf: export bpf_jit_current

 Documentation/admin-guide/sysctl/net.rst |  6 ++++++
 arch/arm64/net/bpf_jit_comp.c            |  5 +++++
 arch/riscv/net/bpf_jit_core.c            |  5 +++++
 include/linux/filter.h                   |  2 ++
 kernel/bpf/core.c                        |  7 ++++---
 net/core/sysctl_net_core.c               | 26 +++++++++++++++++++++++-
 6 files changed, 47 insertions(+), 4 deletions(-)

-- 
2.30.2

