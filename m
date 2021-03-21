Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C1E343579
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 23:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbhCUWqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 18:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbhCUWqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 18:46:04 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F20CC061574;
        Sun, 21 Mar 2021 15:46:04 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id z10so8808820qkz.13;
        Sun, 21 Mar 2021 15:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TnK9eBWXjTWfsPpcQTj1SqdSGJq3Agw5XvYKtzKhjFo=;
        b=WTBtFMBcRsSZyVEgxETBKX7rrVNLpWMG9dsEHTNwJ/7EpU1VHS0r5oD9+RIyXGkKPp
         3m72I3/TnPj8FEJob+9NsOFcyKGTFEm90TqM9XyzWyxBPkWxZ62jOJBqDRH3zxaGS7lM
         1Ubcwrr0SGucTtPxKnc7x9TScTg8vNPc0IvPoHczwxbMosUC1Ugrh3zbRYaCACpGpuQI
         h+f0Q2eWcm5xt8/Wl/kKQZwIqiZ7sq/e1oEwcZlp0plRK1lorGwpFXSOvaMdkgrEiW68
         6JiefSK0aJZtHwPah/xy8ZK8CdX3LMfWlmYffK2ApwU4OGU2ysEDjkr9L4oyfjHMtN0q
         n8Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TnK9eBWXjTWfsPpcQTj1SqdSGJq3Agw5XvYKtzKhjFo=;
        b=nBVI69C+faeRPCv3Q7SkJROiXL8sm8207CghaHzZ0Ki51UztXDPDVC53QT569etX2h
         DBDW/iDHYrT3B5rSWULFC/+DGxHAYgHOqnbzVae7JYACnt/zhpYyEteVfwUtnI8m8M4j
         CvbXFmo89HEBrlO3hYthlyU6tHRL9w4uyMrFkJQz+5jAHvimD290qs1y10BxHHOI/RVr
         CE7ZQBBnKWdFJXBAD9+5eMMxHX1GfkFqCbQcH9jVOAwt2WrMYcxq4+pLF9WG1rlVnvCh
         Kx9LlfYXmqAiQKa4UYR0wfTwLqqtRt1mnaO0UzVs6pS2vYK0gVhCxoyBcTopOS9+3WUT
         /F6w==
X-Gm-Message-State: AOAM532gx5LqO9X6u2xGCPRYbaHk4BQfXonkyK8mGsUImj/qC4CwNTYW
        4wSLTcSMjrjkphxsE1nTUtI=
X-Google-Smtp-Source: ABdhPJww5+r5XApDkYylNmptdQHDWtgqTaUK9ZzteYsAHOlIxYUjqTvJ24aAN22RxV8YlBuTDIU/Pw==
X-Received: by 2002:a05:620a:2994:: with SMTP id r20mr2627407qkp.88.1616366763603;
        Sun, 21 Mar 2021 15:46:03 -0700 (PDT)
Received: from localhost.localdomain ([179.218.4.27])
        by smtp.gmail.com with ESMTPSA id k16sm6556825qkj.55.2021.03.21.15.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 15:46:03 -0700 (PDT)
From:   Pedro Tammela <pctammela@gmail.com>
Cc:     jhs@mojatatu.com, Pedro Tammela <pctammela@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Pedro Tammela <pctammela@mojatatu.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next 0/2] add support for batched ops in LPM trie
Date:   Sun, 21 Mar 2021 19:45:19 -0300
Message-Id: <20210321224525.223432-1-pctammela@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch itself is straightforward thanks to the infrastructure that is
already in-place.

The tests follows the other '*_map_batch_ops' tests with minor tweaks.

Pedro Tammela (2):
  bpf: add support for batched operations in LPM trie maps
  bpf: selftests: add tests for batched ops in LPM trie maps

 kernel/bpf/lpm_trie.c                         |   3 +
 .../map_tests/lpm_trie_map_batch_ops.c (new)  | 158 ++++++++++++++++++
 2 files changed, 161 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/map_tests/lpm_trie_map_batch_ops.c

-- 
2.25.1

