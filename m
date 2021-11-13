Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3702D44F3A4
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 15:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235884AbhKMOZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Nov 2021 09:25:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231672AbhKMOZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Nov 2021 09:25:35 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7EEC061766
        for <netdev@vger.kernel.org>; Sat, 13 Nov 2021 06:22:42 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id r4so2301230edy.12
        for <netdev@vger.kernel.org>; Sat, 13 Nov 2021 06:22:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MRN60IWLDnv5Ty38gBT5/CzrewJ5PhcZHXfvFeewv6o=;
        b=DkEoloGHAD5a8Tj9gnzTpAR0XtBtw0V2P5ZakYG8pPYmmxWNxbV1oWT3lsO89HDYS5
         sQYoNls2ETdL4K+ut+RNEQArNZyz/GVAcU5aUEaVXr0gXR4xTzCD3Qy53YaxeGgm/nk3
         tjb5YEXJiR31eM4lRH14ddXl4xTdu2zWD71dv4HpqVPdJwGkFITX15ks4ljtPycknmNS
         OpJsWGjGgIybl1FIfz+fveX5rQ8lRqP9GVZ0+vl09AuPaZn8OaZEmeSzyuxqJwfg1yKQ
         YDxUtrFB8Z/llvMIlU1PVPDrpZ9TVXuWa3Pq6UTt+IkHHV6Y/6cHT3YlJlr4SVvovHBS
         TcLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MRN60IWLDnv5Ty38gBT5/CzrewJ5PhcZHXfvFeewv6o=;
        b=4FwC3O51hMrd/d8eDtyt4wFZZu3/c55KtDmiyGad1ZHUvcENp8VjvpF8b4+93Zq83n
         eBhgwdn3+1v3hYYFfcmmBHG1zOyDjO0pCAifiKZE4fp7Ls4Yn+4k1ZrK7qRjNfX//qIv
         sMAAI2Xp4MJ8/7R0ZNnGo2aKNHha1pkKLD5Xfw0ImDAe33w/EGBlxkVzbWngkEV1vDv0
         iIYHYNjfbQUqcNnb5DHxFD2OYsfSvrLQpph7YrOo/hXMgok73nwvPPfmQJ0PWFrYMir+
         e+lPi4EKOoYE5EKmxGiB4yjvAOQsCUaorNpbC8W1DpUxBvIg2lGdi9D5UzetecMCo/3L
         /Mww==
X-Gm-Message-State: AOAM531RB9gFpT78+TOzHEExh2BOjUXXE05oM+2vfIfTZATwMAjG7zCa
        oeWlSev0WGXLSLEfDu7KKzisEg==
X-Google-Smtp-Source: ABdhPJzPX3P/PUcI/TgZYja+jpJuHrjZX/SZS0+hhN0cttf5b+dHVLuHI1xWyTmpMoC1G43RIcIdMw==
X-Received: by 2002:a17:906:f0d4:: with SMTP id dk20mr30379627ejb.257.1636813360831;
        Sat, 13 Nov 2021 06:22:40 -0800 (PST)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id oz13sm3894007ejc.65.2021.11.13.06.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Nov 2021 06:22:40 -0800 (PST)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, tglx@linutronix.de,
        rdna@fb.com
Subject: [PATCH bpf v2 0/2] Forbid bpf_ktime_get_coarse_ns and bpf_timer_* in tracing progs
Date:   Sat, 13 Nov 2021 18:22:25 +0400
Message-Id: <20211113142227.566439-1-me@ubique.spb.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Various locking issues are possible with bpf_ktime_get_coarse_ns() and
bpf_timer_* set of helpers.

syzbot found a locking issue with bpf_ktime_get_coarse_ns() helper executed in
BPF_PROG_TYPE_PERF_EVENT prog type - [1]. The issue is possible because the
helper uses non fast version of time accessor that isn't safe for any context.
The helper was added because it provided performance benefits in comparison to
bpf_ktime_get_ns() helper.

A similar locking issue is possible with bpf_timer_* set of helpers when used
in tracing progs.

The solution is to restrict use of the helpers in tracing progs.

In the [1] discussion it was stated that bpf_spin_lock related helpers shall
also be excluded for tracing progs. The verifier has a compatibility check
between a map and a program. If a tracing program tries to use a map which
value has struct bpf_spin_lock the verifier fails that is why bpf_spin_lock is
already restricted.

Patch 1 restricts helpers
Patch 2 adds tests

v1 -> v2:
 * Limit the helpers via func proto getters instead of allowed callback
 * Add note about helpers' restrictions to linux/bpf.h
 * Add Fixes tag
 * Remove extra \0 from btf_str_sec
 * Beside asm tests add prog tests
 * Trim CC

1. https://lore.kernel.org/all/00000000000013aebd05cff8e064@google.com/

Dmitrii Banshchikov (2):
  bpf: Forbid bpf_ktime_get_coarse_ns and bpf_timer_* in tracing progs
  selftests/bpf: Add tests for restricted helpers

 include/uapi/linux/bpf.h                      |   6 +
 kernel/bpf/cgroup.c                           |   2 +
 kernel/bpf/helpers.c                          |   2 -
 kernel/bpf/verifier.c                         |   7 +
 kernel/trace/bpf_trace.c                      |   2 -
 net/core/filter.c                             |   6 +
 net/ipv4/bpf_tcp_ca.c                         |   2 +
 tools/include/uapi/linux/bpf.h                |   6 +
 .../bpf/prog_tests/helper_restricted.c        |  33 +++
 .../bpf/progs/test_helper_restricted.c        | 123 +++++++++++
 tools/testing/selftests/bpf/test_verifier.c   |  46 +++-
 .../bpf/verifier/helper_restricted.c          | 196 ++++++++++++++++++
 12 files changed, 426 insertions(+), 5 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/helper_restricted.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_helper_restricted.c
 create mode 100644 tools/testing/selftests/bpf/verifier/helper_restricted.c

-- 
2.25.1

