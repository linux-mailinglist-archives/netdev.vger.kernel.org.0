Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0376C3F530A
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 23:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232993AbhHWVxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 17:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232808AbhHWVxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 17:53:49 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA59AC061575;
        Mon, 23 Aug 2021 14:53:06 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id u21so12166367qtw.8;
        Mon, 23 Aug 2021 14:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:reply-to:mime-version
         :content-transfer-encoding;
        bh=sLxjM71SuGe9hGuMszxC2z30QFVA4P0rmUHgi02d4SY=;
        b=e+ErOFc33bysvfbMCOJrjf9S+MokkR7iuUlFWgn7SSJHZebdotXndGH18psCqdnoPd
         5BH+Cb9t2DFWlsxB+zDaEeV2XpDH+qUm9D6COz39Kiq3KoqCdfTLZ0je+tbb9FBdFSR7
         mLLfHIkBOixaZy3D/ryxZ+zRIHs+0WyCxj8g6qWIVEOlybpMS4d1TN6Bho+n8No6r8NG
         tMDOlG+FwsxF5aDnyUWXd7dmLL7HfGGN8Q16qffK/KAUrgXbEqOE8xKOnVtsvFF5cEcd
         RpT+pVB4XUKgWfGqPaRhmrbpyMRr2vH89SNJhKHghkyDE+WhJI03xzsJ5dPsQl6JEqcx
         YQOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :mime-version:content-transfer-encoding;
        bh=sLxjM71SuGe9hGuMszxC2z30QFVA4P0rmUHgi02d4SY=;
        b=SKA+NNM5lTQwV7Y2RjXWVuxjDyp53YFeDgmzOUb8ZizIiW3hPAs1JCiN/pITiemhG0
         bMvoMN9kn3GxcN5wPBJiEdDZjbjvt3uLXdaMjOtgDmUL+r1Pe237Gq4la2KXoDmYOB54
         dy8i9NhRY3ucGcM3jO2ub5WDwXMI9AApUgfrtGG3vqi4bM5k4dFo0pTF7fI5g1Oj4A90
         o84H5u+BYn+3Ahi/RGsdpj5Gx1WR7FBGXtNYd/6bB7k3VjdFYO2x+eXls63JzY2K0G+G
         Czx/8IAks2HB69cIkVMuI6WAnO5qbYKT8unpypQOJ8Jdp2nzBM/YOJwxR/h9LftX2mgU
         XTcg==
X-Gm-Message-State: AOAM530DFrtYC3HFKQNxzMxEk3j/axfnmrQkYuN4JoTS5KwznIL/wK7B
        MauTxzTx6Gsz0xo69jV6YrW99v/etaiaErc/
X-Google-Smtp-Source: ABdhPJytSrRjL9t0kkC3gX1sulAHct2Oo68Y4XoCZ/EfbjBb3Wj3PDOuHvC2g6wLJpn8HM1y8VQXeg==
X-Received: by 2002:ac8:6bcc:: with SMTP id b12mr8033154qtt.243.1629755585877;
        Mon, 23 Aug 2021 14:53:05 -0700 (PDT)
Received: from localhost.localdomain (cpe-74-65-249-7.nyc.res.rr.com. [74.65.249.7])
        by smtp.gmail.com with ESMTPSA id 18sm7004261qtx.76.2021.08.23.14.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 14:53:05 -0700 (PDT)
From:   Hans Montero <hansmontero99@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     hjm2133@columbia.edu, sdf@google.com, ppenkov@google.com
Subject: [RFC PATCH bpf-next 0/2] bpf: Implement shared persistent fast(er) sk_storoage mode
Date:   Mon, 23 Aug 2021 17:52:50 -0400
Message-Id: <20210823215252.15936-1-hansmontero99@gmail.com>
X-Mailer: git-send-email 2.30.2
Reply-To: hjm2133@columbia.edu
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hans Montero <hjm2133@columbia.edu>

This patch set adds a BPF local storage optimization. The first patch adds the
feature, and the second patch extends the bpf selftests so that the feature is
tested.

We are running BPF programs for each egress packet and noticed that
bpf_sk_storage_get incurs a significant amount of cpu time. By inlining the
storage into struct sock and accessing that instead of performing a map lookup,
we expect to reduce overhead for our specific use-case. This also has a
side-effect of persisting the socket storage, which can be beneficial.

This optimization is disabled by default and can be enabled by setting
CONFIG_BPF_SHARED_LOCAL_STORAGE_SIZE, the byte length of the inline buffer, to
a non-zero number.

Hans Montero (2):
  bpf: Implement shared sk_storage optimization
  selftests/bpf: Extend tests for shared sk_storage

 include/net/sock.h                            |  3 ++
 include/uapi/linux/bpf.h                      |  6 +++
 kernel/bpf/Kconfig                            | 11 +++++
 kernel/bpf/bpf_local_storage.c                |  3 +-
 net/core/bpf_sk_storage.c                     | 47 ++++++++++++++++++-
 tools/testing/selftests/bpf/config            |  1 +
 .../selftests/bpf/prog_tests/bpf_iter.c       | 31 +++++++++++-
 .../bpf/prog_tests/test_local_storage.c       |  3 ++
 .../progs/bpf_iter_bpf_sk_storage_helpers.c   | 27 ++++++++++-
 .../selftests/bpf/progs/local_storage.c       | 30 ++++++++++++
 10 files changed, 156 insertions(+), 6 deletions(-)

-- 
2.30.2

