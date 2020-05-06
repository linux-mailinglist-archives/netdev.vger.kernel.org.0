Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C681C64D2
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 02:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729571AbgEFADb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 20:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728642AbgEFADb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 20:03:31 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009DDC061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 17:03:30 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id y6so66390pjc.4
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 17:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.washington.edu; s=goo201206;
        h=from:to:cc:subject:date:message-id;
        bh=JxRTwli/svDqnOaBY0adT76Z0FFG8KkHdubVGApAA6g=;
        b=hBEgU4DYNOg3qWU84rnU6AnFuKR981yS5BSoO3R/amg38P+jgdPsMbTP70YKHF3J76
         ISfsmEBfrEtrkGLH2pkRg7Fe4lYwDNiRfjMrZkkcqUv2DWOZbq2+54F9b9bHiIE2Av7l
         8JnrloZFVv4BenXnGU9ff7pMXJwzMJFAUgcIs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JxRTwli/svDqnOaBY0adT76Z0FFG8KkHdubVGApAA6g=;
        b=SY2GAQqHGkz9RAl9gNIFBRNG11K3sW0oLG5aIAWsf50SK19wzczLHp9oBZw1PtJZ92
         1L8LB4qHin86S4xINEWcAGzhXV94jkReFz/nVhNYRP92dWaSHOuJ8RMop3wEgp7rqRew
         XGCgZz0Q2xcQhQCplFBiD/oQB39RvCXoWfOiDQAZdBuIr3Ufu1wm3LZ3+v1KLoQWjqZn
         E6jD5c7DT8UI0xVWCSqgMwtyE16RtcPGNHoUAPEXFy+hVXPNpGqgVssyUDxUwiWkRl7S
         A+JROzpV0GYLiXY23SDIaWT5hHPN1ZM74NHeOB1rpInx0qTf/JpTT9D6BSuim/1g6Pp0
         nclA==
X-Gm-Message-State: AGi0PuZ2n0/f4ecjl8wEFlHN4uDUgFADNZNJeXxKctp5gCy3QImH6et2
        q5d1V8efAn/KqFlFGPhnRchgOQ==
X-Google-Smtp-Source: APiQypL3GD15VTzPevJlQEL2Gpk1YRyV1HsaesDcgEeoRusw+eAllZFZbBCvSxvf7cmk2/iAjHnNkQ==
X-Received: by 2002:a17:902:a40b:: with SMTP id p11mr5668144plq.304.1588723410355;
        Tue, 05 May 2020 17:03:30 -0700 (PDT)
Received: from localhost.localdomain (c-73-53-94-119.hsd1.wa.comcast.net. [73.53.94.119])
        by smtp.gmail.com with ESMTPSA id u3sm133912pfn.217.2020.05.05.17.03.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 17:03:29 -0700 (PDT)
From:   Luke Nelson <lukenels@cs.washington.edu>
X-Google-Original-From: Luke Nelson <luke.r.nels@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Luke Nelson <luke.r.nels@gmail.com>, Xi Wang <xi.wang@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 0/4] RV64 BPF JIT Optimizations
Date:   Tue,  5 May 2020 17:03:16 -0700
Message-Id: <20200506000320.28965-1-luke.r.nels@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series introduces a set of optimizations to the BPF JIT
on RV64. The optimizations are related to the verifier zero-extension
optimization and BPF_JMP BPF_K.

We tested the optimizations on a QEMU riscv64 virt machine, using
lib/test_bpf and test_verifier, and formally verified their correctness
using Serval.

Luke Nelson (4):
  bpf, riscv: Enable missing verifier_zext optimizations on RV64
  bpf, riscv: Optimize FROM_LE using verifier_zext on RV64
  bpf, riscv: Optimize BPF_JMP BPF_K when imm == 0 on RV64
  bpf, riscv: Optimize BPF_JSET BPF_K using andi on RV64

 arch/riscv/net/bpf_jit_comp64.c | 64 ++++++++++++++++++++++-----------
 1 file changed, 44 insertions(+), 20 deletions(-)

Cc: Xi Wang <xi.wang@gmail.com>

-- 
2.17.1

