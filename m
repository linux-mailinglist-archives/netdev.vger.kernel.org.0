Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE0E2327BE2
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 11:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233969AbhCAKVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 05:21:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232671AbhCAKUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 05:20:22 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACEEC06174A
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 02:19:26 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id i9so12677090wml.0
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 02:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=huw0E5JgfJJ5Mr24mx+mu5o+pU+1rG0sWMzXMDebmr8=;
        b=TYElbNBuCbPG1SWGVRM5PERfDcisbcAF3dnhNm9hRzk8LPNthZ/sALbCLOdoe0Mrai
         BuBGR4GskhW4yPRtwz/+ymE1rnIpHS7R/lSnXTaIwPZCViBQfx7FDqPG8SrAqOGin7fN
         eyscB1Ev6N62AUbbkzSa+AHLjao0kH0lEEF3A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=huw0E5JgfJJ5Mr24mx+mu5o+pU+1rG0sWMzXMDebmr8=;
        b=aPBwz+fQGH4kZSUxBpqVSOQpOKE1GUk6gOeFC9JL+YE0EH/CvoGtootxWMD9RuDOUn
         Bq4wTnlrYVnqMzMPv/+3cDhe/lO+rAvYZ2ivyiLEkhwofXfhxhcbx9F/cSrl48cQtn7M
         HrpzjmtJ2byTF8vVuHdfoIx+BC3ddqhLWozCcS7kRAg25rz3ZJMj6jktXXSvElG1+VFB
         uYR0iAd45MR68jL+mx+lvEgCHyQUN6fIoY5/AxL3XmZdOXdAGOWP0OBRGquLUBVfGZEh
         XWsQWfIhQGFqb/THGFlNAdtsxyPwi8hanHkNcDI22oM/hSF5JMxbocxu9ER8MukYXQcs
         5URw==
X-Gm-Message-State: AOAM533hByFuYDBIJCRDuTrCs8Q6AFNnRmgD1Vkp17yiqjHstafv6pJE
        yBaOdNv+K/35opoANa5agkm5ow==
X-Google-Smtp-Source: ABdhPJzAZ31GRbwyNt3T+djmZx2Ldu7tSKt2CNzVymzPhy2n2PfJdtBoDDPNKOw4OIvCcVn9hekX5g==
X-Received: by 2002:a1c:7905:: with SMTP id l5mr3555456wme.181.1614593965369;
        Mon, 01 Mar 2021 02:19:25 -0800 (PST)
Received: from localhost.localdomain (2.b.a.d.8.4.b.a.9.e.4.2.1.8.0.5.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:5081:24e9:ab48:dab2])
        by smtp.gmail.com with ESMTPSA id a198sm14134600wmd.11.2021.03.01.02.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 02:19:24 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next v3 0/5] PROG_TEST_RUN support for sk_lookup programs
Date:   Mon,  1 Mar 2021 10:18:54 +0000
Message-Id: <20210301101859.46045-1-lmb@cloudflare.com>
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

