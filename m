Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A377C4346EE
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 10:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhJTIcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 04:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhJTIcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 04:32:20 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26386C06161C
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 01:30:06 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id y74-20020a1c7d4d000000b00322f53b9bbfso9240287wmc.3
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 01:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=36K3eo2kvYLnIh7MhO6B56uMEJ0wK8B7qHZgdAK1xZM=;
        b=EKW7Gw+rFN0RDhEHdg2dCdCR2u4ot0V5t8Gf97hnoGypa0zIbUSVi/LrNTgx8FkIgR
         26ti5ULugpFdi6U/1Y+T6CArPklIAtZCdedtAeCOqaDFUPZO6hKEckVyLjIj6WwmtLxZ
         gQDFAKJetsCFDmCbt9xt72FI9Sl0wxeXDaLQ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=36K3eo2kvYLnIh7MhO6B56uMEJ0wK8B7qHZgdAK1xZM=;
        b=EVBJzQEZCJJSiwGNXR6nWbEsNoC4kty0KrLbQGScs7zha1WcR31PrkV4rE87gfc3Wv
         4eFJVAZPV8ivhsdA3zeZUEWGWu5TZdQjFqxDK/WFGoy0zFEG2XLcew4Dp/nGQtC8TLN3
         fbxIya0T3UJu6sOcaT5m9MGl0NA5sl+iQ+X1W7HrHmXaL5wPLhMXLpA04Jn2x9VT+n6C
         ySwUduJGxOuDVtViuGEICZXV2790ekqAEXFZnkZcQ5pW8oRQ6dyaV+oimNAwq+ExBs9z
         B/U7EP0OU6xYhaYlWxCh0PKLORBmrv4jl+yGJ3b0konJPYQmus6Uo90Y9SkAyzp8l/ij
         xDNw==
X-Gm-Message-State: AOAM530QHxiJJkFSwsEYvg+3hAs6gage/iEZ/2HNN5luw6N7WSOcmucd
        5gFKVfY4uyT1Nz0AY7bArWud2g==
X-Google-Smtp-Source: ABdhPJyVYtM/WKGa3w08DC0RC6YUzXqtv+7iro0D/nQ+V0iQQBARwtqXKCnOrURvQFQ2p4TQl+daZw==
X-Received: by 2002:a1c:f002:: with SMTP id a2mr11871816wmb.79.1634718604721;
        Wed, 20 Oct 2021 01:30:04 -0700 (PDT)
Received: from antares.. (d.5.c.c.6.2.1.6.f.5.3.5.c.9.c.f.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:fc9c:535f:6126:cc5d])
        by smtp.gmail.com with ESMTPSA id s13sm4473133wmc.47.2021.10.20.01.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 01:30:04 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next 0/2] Support RENAME_EXCHANGE on bpffs
Date:   Wed, 20 Oct 2021 09:29:54 +0100
Message-Id: <20211020082956.8359-1-lmb@cloudflare.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for renameat2(RENAME_EXCHANGE) on bpffs. This is useful
for atomic upgrades of our sk_lookup control plane.

* Create a temporary directory on bpffs
* Migrate maps and pin them into temporary directory
* Load new sk_lookup BPF, attach it and pin the link into temp dir
* renameat2(temp dir, state dir, RENAME_EXCHANGE)
* rmdir temp dir

Due to the sk_lookup semantics this means we can never end up in a
situation where an upgrade breaks the existing control plane.

Lorenz Bauer (2):
  libfs: support RENAME_EXCHANGE in simple_rename()
  selftests: bpf: test RENAME_EXCHANGE and RENAME_NOREPLACE on bpffs

 fs/libfs.c                                    |  6 ++-
 .../selftests/bpf/prog_tests/test_bpffs.c     | 39 +++++++++++++++++++
 2 files changed, 44 insertions(+), 1 deletion(-)

-- 
2.30.2

