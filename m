Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE596C3BEF
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 21:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjCUUjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 16:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjCUUi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 16:38:59 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21D93A864;
        Tue, 21 Mar 2023 13:38:57 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id z10so9355050pgr.8;
        Tue, 21 Mar 2023 13:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679431137;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SiZ2q8feRrZogsSXuy10V1SXAnZtQZnnaFP+X15KKCg=;
        b=VenZd4XDd7XaidXlU5XdG8CN+9fkYShGFFfYqxWY/XwfAAkHOzoyxEc3MQhsHodAHG
         LSKKMcF8wX4hi5mNIbQ5tRK+E9QLn3oXlzjB48VQvgs+m3SPpxNmySANo0UNltCbl03D
         kTqa/VrYKcSfjgfcyqCdyG6Kx5kKhNGWuM0AluHahQ6H3MLOcbn5QUf+MMI7pHPvFkBi
         gL2qnnHUmUgkl7GSguHOFO/kTXCp2w/KRiSvBKBHNu+4XY7TOqjLxawW4YijxVH/0aL4
         ikOAKIhgjBnooptAO4hDocDQwWU/efRcdJNH1NwzZkBFd6ZF3DFxPdosLs3mLSVuyOCa
         38EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679431137;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SiZ2q8feRrZogsSXuy10V1SXAnZtQZnnaFP+X15KKCg=;
        b=HvK6GOlxJGDOvJvsMavYNfHlzO8dbMQlvrZ5xCPFFJfJ3XN/4ZCMqYLuw1obqNkRzQ
         /dreYM5qXYxSQO5NJH6BY9URtsZLkOV0Ew+ZwSsA1viZ4iA5Xr5lMruVuo8iOxpj2mfL
         ShgPEcqwXBDFgS4FyDanfoN6Y1UIlZUTrMxVZ1Y3ausuY6TUqNGjMpZKWr8U1KniROzq
         7gN8JIX5m5kQNSbWKA6zsiMv1xdOIJ9+QbfGg6zfRrWuujqIzgYMANRRM26pSZ+GWbwo
         Uvv8KdPMeyFA2TYVms1b+XRBtBy3l5B0rVm4vNKfQPXiqhxIJhOlZKPq2HZSWxMm9XRb
         coOw==
X-Gm-Message-State: AO0yUKWnM7tqW1yNWC1G465kwG4afmFJyl0Fux/lEFLv+CYIbhSSCFOl
        hz4HXs3gLslQn3LZQxRZrs8=
X-Google-Smtp-Source: AK7set+R/RyV9D6h+vuc87KbbjrulqiSyxgfa7EmcXfXGmlTw9GRpreCNlNoCp/Hk15ZmeB7uBo0bQ==
X-Received: by 2002:a62:1955:0:b0:623:77f5:eeed with SMTP id 82-20020a621955000000b0062377f5eeedmr971045pfz.25.1679431137337;
        Tue, 21 Mar 2023 13:38:57 -0700 (PDT)
Received: from macbook-pro-6.dhcp.thefacebook.com ([2620:10d:c090:500::5:34cf])
        by smtp.gmail.com with ESMTPSA id a21-20020a62bd15000000b005895f9657ebsm8628819pff.70.2023.03.21.13.38.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 21 Mar 2023 13:38:56 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v2 bpf-next 0/4] bpf: Support ksym detection in light skeleton.
Date:   Tue, 21 Mar 2023 13:38:50 -0700
Message-Id: <20230321203854.3035-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

v1->v2: update denylist on s390

Patch 1: Cleanup internal libbpf names.
Patch 2: Teach the verifier that rdonly_mem != NULL.
Patch 3: Fix gen_loader to support ksym detection.
Patch 4: Selftest and update denylist.

Alexei Starovoitov (4):
  libbpf: Rename RELO_EXTERN_VAR/FUNC.
  bpf: Teach the verifier to recognize rdonly_mem as not null.
  libbpf: Support kfunc detection in light skeleton.
  selftests/bpf: Add light skeleton test for kfunc detection.

 kernel/bpf/verifier.c                         | 14 ++++---
 tools/lib/bpf/bpf_gen_internal.h              |  4 +-
 tools/lib/bpf/gen_loader.c                    | 38 +++++++++----------
 tools/lib/bpf/libbpf.c                        | 25 ++++++------
 tools/testing/selftests/bpf/DENYLIST.s390x    |  1 +
 .../selftests/bpf/progs/test_ksyms_weak.c     | 15 ++++++++
 6 files changed, 61 insertions(+), 36 deletions(-)

-- 
2.34.1

