Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CECB24C032
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 16:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgHTOIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 10:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731156AbgHTN6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 09:58:04 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466CCC061385
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 06:58:04 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id c15so2094037wrs.11
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 06:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kde3u3HFPYfuRfECAfMIiyKrmgr3zdkcjvZMTk3eLDM=;
        b=Qgob22Eti6jORi7jdQCQ7THfTNNOTA2JNT6c1xYrIu9O0VbwEMFKfBo6LJfT2N2YQT
         JrmvKCwF9iGitucFxGWfLkGdtqMU2iPsBxMJp4DvVZq9+ckYokMR8cCEv219EsfsfrTm
         7oVb70aprHUQVBSiiWqGVfLFLu8AZGS2VJyjU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kde3u3HFPYfuRfECAfMIiyKrmgr3zdkcjvZMTk3eLDM=;
        b=Q029uFC82WMSiqK1Vnk60agBILfpy1irlTc0hSJ8s+UC6jVOxfxat4gEWDOHHZWmmP
         Ni6Tvl2jYXhJ0j10E7kJQMsEZu4vUlucc1Dqu6C+/hPgd6Z5OPoFjcad+X1Ewvw93fAM
         eAS6Kt7gCOTozDfTaAY6AT7GEPAm+IDWp4rDTq/c/qzpy1LLtosfvKuQzk9m1yeI62Tq
         WChZ8GNo4nfWp1jfObftLi7txPssSTTBcj8h12sgM56Tw1WLVgt4bNDAAbxcAywV3n2c
         gG7KJhK9uT5LbQUYq1oRyn/8QbqJBmfHWy4/qxexbL5cgF8RQv1hbnE0lZkmig6WenJO
         R4+Q==
X-Gm-Message-State: AOAM530L2hRNyDbinb+xPtHf1UGvxJvK7+o/+GtKA4FfmLldCh1duziO
        lPT2k/P/3Q6vvljavMc3zbRmtSHoE0XrwQ==
X-Google-Smtp-Source: ABdhPJyX2YxrmJ0WJsq2rzq0AmiRTb/+U7SKiSvn21ip7fjjEM9/SN7nPmweGKYWTCWQXIJWKA9OZg==
X-Received: by 2002:a05:6000:c:: with SMTP id h12mr3257295wrx.49.1597931882880;
        Thu, 20 Aug 2020 06:58:02 -0700 (PDT)
Received: from antares.lan (d.0.f.e.b.c.7.2.d.c.3.8.4.8.d.9.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:9d84:83cd:27cb:ef0d])
        by smtp.gmail.com with ESMTPSA id l81sm4494215wmf.4.2020.08.20.06.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 06:58:01 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     jakub@cloudflare.com, john.fastabend@gmail.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 0/6] Allow updating sockmap / sockhash from BPF
Date:   Thu, 20 Aug 2020 14:57:23 +0100
Message-Id: <20200820135729.135783-1-lmb@cloudflare.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We're currently building a control plane for our BPF socket dispatch
work. As part of that, we have a need to create a copy of an existing
sockhash, to allow us to change the keys. I previously proposed allowing
privileged userspace to look up sockets, which doesn't work due to
security concerns (see [1]).

In follow up discussions during BPF office hours we identified bpf_iter
as a possible solution: instead of accessing sockets from user space
we can iterate the source sockhash, and insert the values into a new
map. Enabling this requires two pieces: the ability to iterate
sockmap and sockhash, as well as being able to call map_update_elem
from BPF.

This patch set implements the latter: it's now possible to update
sockmap from BPF context. As a next step, we can implement bpf_iter
for sockmap.

Changes in v2:
- Fix warning in patch #2 (Jakub K)
- Renamed override_map_arg_type (John)
- Only allow updating sockmap from known safe contexts (John)
- Use __s64 for sockmap updates from user space (Yonghong)
- Various small test fixes around test macros and such (Yonghong)

Thank your for your reviews!

1: https://lore.kernel.org/bpf/20200310174711.7490-1-lmb@cloudflare.com/

Lorenz Bauer (6):
  net: sk_msg: simplify sk_psock initialization
  bpf: sockmap: merge sockmap and sockhash update functions
  bpf: sockmap: call sock_map_update_elem directly
  bpf: override the meaning of ARG_PTR_TO_MAP_VALUE for sockmap and
    sockhash
  bpf: sockmap: allow update from BPF
  selftests: bpf: test sockmap update from BPF

 include/linux/bpf.h                           |   7 +
 include/linux/skmsg.h                         |  17 ---
 kernel/bpf/syscall.c                          |   5 +-
 kernel/bpf/verifier.c                         |  78 +++++++++-
 net/core/skmsg.c                              |  34 ++++-
 net/core/sock_map.c                           | 137 ++++++++----------
 net/ipv4/tcp_bpf.c                            |  13 +-
 net/ipv4/udp_bpf.c                            |   9 +-
 .../selftests/bpf/prog_tests/sockmap_basic.c  |  71 +++++++++
 .../selftests/bpf/progs/test_sockmap_copy.c   |  48 ++++++
 10 files changed, 301 insertions(+), 118 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_copy.c

-- 
2.25.1

