Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25695326151
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 11:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbhBZKcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 05:32:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbhBZKcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 05:32:10 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88AFC061756
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 02:31:19 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id r3so8058973wro.9
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 02:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LfT7ay7KwasSV+sFD2ZaC84G9Rrb7GHYn7zU3XdQ/XU=;
        b=ZwKmmSp24fKokSPGlq2bPqs5KXOblmvAuokvjIfEv8tjYpVI3UAW38bbqjjPu95gbp
         8fn8CQoAJDksihVHIPxhmjbAnf2CudyqSee6rbwDY48DC3OclwE7fN6phWXBLVf2QCpG
         wTTI2Yf3ZpD5rVuxE6JnHVn6sIjiwmOI1nk9U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LfT7ay7KwasSV+sFD2ZaC84G9Rrb7GHYn7zU3XdQ/XU=;
        b=P249nNLLcHEbpKXYrn4sfEgL86FhgyALGqe7nUa0tFOvlw+GWEWmhHMSv3aKLVNENo
         KE6M8XBr4eHNEcMYk+fTKpc79rVZvwsfgs0w9MSUJ3NlsP7uuO1UX6YMPWXQDLDHv0jQ
         meeZDE0gi1zNhhvdaWcBTtNPW5CjrtVMD0NPfqUOZdjozCihMpTPj4VGLvhLAknxB3SG
         +A6zy0yz/daLd/p+ibNZH6a9AXT+Jr8am1Nmx4COBcWOaPWtahwncjhuk2l/HLx2v8K4
         tFMitY9og4KmVIe3BY4oDn3UpsLWavGtXKsJwRh/AHcx9+WLBrr3cbGRgHxDpVMUe/lQ
         +g9g==
X-Gm-Message-State: AOAM531KLsM+1KklJO1/xOeZffsghGTaI+/6yqXTB2U7zorys6gIANdf
        0VYWEL7AfdhJclMUaYyBTEnYfQ==
X-Google-Smtp-Source: ABdhPJyn6xEPInc3v+XuCtC0l/86BRgur+A0WxpiVPnmC4pIphB8qK4wWb23cs3tqG/GJlyY7pG7ZA==
X-Received: by 2002:a5d:4d09:: with SMTP id z9mr2417189wrt.426.1614335478555;
        Fri, 26 Feb 2021 02:31:18 -0800 (PST)
Received: from localhost.localdomain (d.4.3.e.3.5.0.6.8.1.5.9.3.d.9.6.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:69d3:9518:6053:e34d])
        by smtp.gmail.com with ESMTPSA id a21sm12448744wmb.5.2021.02.26.02.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 02:31:18 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next v2 0/5] PROG_TEST_RUN support for sk_lookup programs
Date:   Fri, 26 Feb 2021 10:30:59 +0000
Message-Id: <20210226103103.131210-1-lmb@cloudflare.com>
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

Changes since v1:
- Add sparse annotations to the t_* functions
- Add appropriate type casts in bpf_prog_test_run_sk_lookup
- Drop running multiple programs

Lorenz Bauer (5):
  bpf: consolidate shared test timing code
  bpf: add for_each_bpf_prog helper
  bpf: add PROG_TEST_RUN support for sk_lookup programs
  selftests: bpf: convert sk_lookup ctx access tests to PROG_TEST_RUN
  selftests: bpf: check that PROG_TEST_RUN repeats as requested

 include/linux/bpf.h                           |  21 +-
 include/linux/filter.h                        |   4 +-
 include/uapi/linux/bpf.h                      |   5 +-
 net/bpf/test_run.c                            | 245 +++++++++++++-----
 net/core/filter.c                             |   1 +
 tools/include/uapi/linux/bpf.h                |   5 +-
 .../selftests/bpf/prog_tests/prog_run_xattr.c |  51 +++-
 .../selftests/bpf/prog_tests/sk_lookup.c      |  83 ++++--
 .../selftests/bpf/progs/test_sk_lookup.c      |  62 +++--
 9 files changed, 358 insertions(+), 119 deletions(-)

-- 
2.27.0

