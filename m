Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901F532C404
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232491AbhCDAKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1843036AbhCCKYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 05:24:41 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25EDC08ED87
        for <netdev@vger.kernel.org>; Wed,  3 Mar 2021 02:18:27 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id d11so23026308wrj.7
        for <netdev@vger.kernel.org>; Wed, 03 Mar 2021 02:18:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MrjISZvwHbhwQBfRB9QHN6sF/EaAM40kAOYVP7EBVPk=;
        b=yAr0OpU+J5TnBd2deL9/KG6DkLgp+D2rcjyU28XXNUmWYTepPnPJW0hmFRrV+ounO8
         K7BNCcSH5Egh4MDcMIQCV+o782+A6OzDYSsgeD8/XjZsoZPeRZx4iHFZfcoDjnfsp/Wz
         eh8DI2EhYpqJOjeOf5YfHkvlHqfcvH41nQJ0s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MrjISZvwHbhwQBfRB9QHN6sF/EaAM40kAOYVP7EBVPk=;
        b=BL7PiclMZQ6NOJTQKw/UF9tiM+CWEVETd1h7MGq+MZfMO9q1loKx7nl6YrCVcMKYg6
         yE4cJZt7F4Yb7IB6n/VKLIeH+b3bj8cNpRysrza/U1e9y9G9mcO4h35O6hPwaYT5mcHQ
         5BvfkTDFayflz6WHzT3KC8C8IIYXjzqlCsTFNk9921v47vpc1dDtvIijl/0ZoxzgDJjI
         gxcBHNjee7sU6A6z4n02GzcO1DcGOo9NkRRxoTyj3tk7/G9yZ/TecNa4NEOUHgzYXjM8
         T9q3vCCBK2AM3qOORa9iz55wZitbD8805qcqNa0tQzcl1lPchuca34u/gJaeg2UFaBJi
         h0BQ==
X-Gm-Message-State: AOAM531CZyCfZxCjM43XYrUVqy8JNgEvlmA6YLPDmjiwSmzJ+P0U0UOu
        Ei0d6zaLUPuSkZLSDOnsOnYzNw==
X-Google-Smtp-Source: ABdhPJwouyFYuLRZj6bEB1+6XmR8zNP/itvznp79frNrqnTcU/VMSyPnF2hyfkLjUF7dp6+rDpI1+Q==
X-Received: by 2002:adf:a2c7:: with SMTP id t7mr26641486wra.42.1614766706440;
        Wed, 03 Mar 2021 02:18:26 -0800 (PST)
Received: from localhost.localdomain (c.a.8.8.c.1.2.8.8.7.0.2.6.c.a.1.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:1ac6:2078:821c:88ac])
        by smtp.gmail.com with ESMTPSA id r26sm1710761wmn.28.2021.03.03.02.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 02:18:25 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next v4 0/5] PROG_TEST_RUN support for sk_lookup programs
Date:   Wed,  3 Mar 2021 10:18:11 +0000
Message-Id: <20210303101816.36774-1-lmb@cloudflare.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't have PROG_TEST_RUN support for sk_lookup programs at the
moment. So far this hasn't been a problem, since we can run our
tests in a separate network namespace. For benchmarking it's nice
to have PROG_TEST_RUN, so I've gone and implemented it.

Based on discussion on the v1 I've dropped support for testing multiple
programs at once.

Changes since v3:
- Use bpf_test_timer prefix (Andrii)

Changes since v2:
- Fix test_verifier failure (Alexei)

Changes since v1:
- Add sparse annotations to the t_* functions
- Add appropriate type casts in bpf_prog_test_run_sk_lookup
- Drop running multiple programs

Lorenz Bauer (5):
  bpf: consolidate shared test timing code
  bpf: add PROG_TEST_RUN support for sk_lookup programs
  selftests: bpf: convert sk_lookup ctx access tests to PROG_TEST_RUN
  selftests: bpf: check that PROG_TEST_RUN repeats as requested
  selftests: bpf: don't run sk_lookup in verifier tests

 include/linux/bpf.h                           |  10 +
 include/uapi/linux/bpf.h                      |   5 +-
 net/bpf/test_run.c                            | 246 +++++++++++++-----
 net/core/filter.c                             |   1 +
 tools/include/uapi/linux/bpf.h                |   5 +-
 .../selftests/bpf/prog_tests/prog_run_xattr.c |  51 +++-
 .../selftests/bpf/prog_tests/sk_lookup.c      |  83 ++++--
 .../selftests/bpf/progs/test_sk_lookup.c      |  62 +++--
 tools/testing/selftests/bpf/test_verifier.c   |   4 +-
 .../selftests/bpf/verifier/ctx_sk_lookup.c    |   1 +
 10 files changed, 356 insertions(+), 112 deletions(-)

-- 
2.27.0

