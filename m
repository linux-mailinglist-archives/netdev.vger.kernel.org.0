Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2DC27FF5A
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 19:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391641AbfHBRRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 13:17:13 -0400
Received: from mail-yb1-f201.google.com ([209.85.219.201]:50292 "EHLO
        mail-yb1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391600AbfHBRRN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 13:17:13 -0400
Received: by mail-yb1-f201.google.com with SMTP id p20so56904482yba.17
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 10:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=J7AQaFXwu5WiKwAQvAEm/CM8Y6RcUQxdCxDS3Eq2sUw=;
        b=v/q12+Le9fyg0uq6BK05Y39eA0dWg1KO/5dRPk6UfAV7wqGJiyCZ9MWPelH9blhgch
         QDtblH9daSOxT5jO+rpP7GVcVFoegsWnx2LcW0E7YjA7ecw6z/svZ63XuROEXVFr1ZXm
         eTXBTzzaHH0PLqVsHjBeEebfyi5LW6Reg1zG7xAkCmOIssEmkVE7/JPUrsqxfXYWCG6H
         18ghk/hWSNm1ZtproyxszTn4bCjfks+dTVoF7gUNoB5Jnzemja4bwmWdX75V7LOuY/7f
         WnYbTEjVYHaohk6xL+li5tCfCv/cLMc1QIJFVsxI359+rPbKDOPboJ2rp4idrzmdATNj
         gRSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=J7AQaFXwu5WiKwAQvAEm/CM8Y6RcUQxdCxDS3Eq2sUw=;
        b=ZGfTJCi9xSkI2CdAbc1ZPlC9PSN0xVg3qdiI0H5JeLyVlzSDxSAPozaQ8nGBYAMCgm
         qnbHeOXL6Ebfhgjfc5X15eWmcPYT5SZGsuA+jZCQZSyxtDMdKwHnbCf+y0IOGUFpwV8W
         MQzLkP2CnwmvssAU8ImNcrRXc9AbNZiplIjAjuzY3q0XliOgWxOTENFcePiyPt4s+MzS
         yT3NTXYfJX6bD52OGL3hamrgxpuLJTAtDeJMPbtLs3E1CEpSg3MJIG90pQJ1VZwjwZrJ
         gxZQGrze19jMyU/UZPXmneEqBXnR3qhjn+RMLJgeHp8UnSyp3ECEgKQsXnxagPQDDf9j
         h0dw==
X-Gm-Message-State: APjAAAW8iYiOvSMN4O9rxvYaBU/lRjPpSizSH7wMBrLqqEmH2VxVZDDx
        tIh+afnvAOBbDsJS0V8PASiHpjWvGngazou+iFJjemRnnNSswf/3AgY1mXVKwYsVYliaHfjM1Um
        9nXSvbY7/DEWlu9YjOgDYYVmcQHj2n2RYtnK4UJuipQFBSV4GrDSrmQ==
X-Google-Smtp-Source: APXvYqwlIvMtaIvnsp9MX7ClvMzS6jG9pV6QwcoPrxTdIr75wIzUgTmlA5jE8buoKuUaYKoy4mMKAgE=
X-Received: by 2002:a25:56c6:: with SMTP id k189mr88721912ybb.41.1564766232294;
 Fri, 02 Aug 2019 10:17:12 -0700 (PDT)
Date:   Fri,  2 Aug 2019 10:17:07 -0700
Message-Id: <20190802171710.11456-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
Subject: [PATCH bpf-next 0/3] selftests/bpf: switch test_progs back to stdio
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I was looking into converting test_sockops* to test_progs framework
and that requires using cgroup_helpers.c which rely on stdio/stderr.
Let's use open_memstream to override stdout into buffer during
subtests instead of custom test_{v,}printf wrappers. That lets
us continue to use stdio in the subtests and dump it on failure
if required.

That would also fix bpf_find_map which currently uses printf to
signal failure (missed during test_printf conversion).

Cc: Andrii Nakryiko <andriin@fb.com>

Stanislav Fomichev (3):
  selftests/bpf: test_progs: switch to open_memstream
  selftests/bpf: test_progs: test__printf -> printf
  selftests/bpf: test_progs: drop extra trailing tab

 .../bpf/prog_tests/bpf_verif_scale.c          |   4 +-
 .../selftests/bpf/prog_tests/l4lb_all.c       |   2 +-
 .../selftests/bpf/prog_tests/map_lock.c       |  10 +-
 .../selftests/bpf/prog_tests/send_signal.c    |   4 +-
 .../selftests/bpf/prog_tests/spinlock.c       |   2 +-
 .../bpf/prog_tests/stacktrace_build_id.c      |   4 +-
 .../bpf/prog_tests/stacktrace_build_id_nmi.c  |   4 +-
 .../selftests/bpf/prog_tests/xdp_noinline.c   |   4 +-
 tools/testing/selftests/bpf/test_progs.c      | 116 +++++++-----------
 tools/testing/selftests/bpf/test_progs.h      |  12 +-
 10 files changed, 68 insertions(+), 94 deletions(-)

-- 
2.22.0.770.g0f2c4a37fd-goog
