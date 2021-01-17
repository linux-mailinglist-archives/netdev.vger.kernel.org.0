Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908442F9066
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 05:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbhAQEXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 23:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727087AbhAQEXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 23:23:19 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B31C061573;
        Sat, 16 Jan 2021 20:22:38 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id r9so12901056otk.11;
        Sat, 16 Jan 2021 20:22:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V3cvkEML2uZN+iWOL+N3h9Jk8evv0icASfLNeb9Rsio=;
        b=tshboUXexD3ZfqDbrRTlb9Ox69LPBt1Yb64PXKG7xzwmZXQCZq3ravafbGLPJZLcKp
         leBlVKifxPEO+1S1EfuA489sis9uzOIkZIzqqgbtrOndbJdUzicA3lM8N5fvUmYtPbec
         7zsCB2BrIdaypEnX1uR+N/T9nCOiYFTxTQ3v0PfUger6+1FTxjdUbbSwxMGUwLGah6eV
         h71zMONOs+ILS40b732ZGk8exKxVAkdJLpJn/wfhieZNAdLxxCw/Sf1Zu823eRKRjvT/
         GUruLfTnul4w3nDOGhyr5uzwAoZTIv+tBwb00IC8MvsETJ1Y/s2Cs252s0LtB7on2LO3
         X7Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V3cvkEML2uZN+iWOL+N3h9Jk8evv0icASfLNeb9Rsio=;
        b=jpfYRHsJ/TkZsSsefH43kDEzU4m9pDL3H+DMlsaPnmmXHvCyH2GHQCvHTAFp4YRe07
         NKt2bthIq08rLTK/qQsbANHhKeK3PGUSEXIl0Ikw5aLjdbTkKvXvCO17H3oq+wY7oRYn
         qNkUYI2E9imzyeQP5xprKw5K007JcrTboGMb/+Fotd3MuQjRVrM8n0gqqdoorc5oWyPy
         xVqywWPtLgOEX0tSQC3VXN8+zGgAIQjBrev2hFlpIA/DY7plGEABMOhhjzRy2YyavjyU
         YvObR8PGFvuped0DOfAkJBjxfqnDkacnDXJ16kN5vCVfH53RWsrQHe3ZzidcZ/YDrnEY
         ulwA==
X-Gm-Message-State: AOAM531cn+eQkkUgTLLf2HXreRt/LsoQApWEs4oyCGJLFL8ortLb+3lv
        2WZiGUUTik0lKR65GScI8ietkcExuIQauw==
X-Google-Smtp-Source: ABdhPJwGZxzUk87rS3TKKlgXqkNMKurtJWRuEyT8zHd6gDBwYsiHAh7aqDUBoNlh5dxVpILt1UO1NQ==
X-Received: by 2002:a9d:6e98:: with SMTP id a24mr2791459otr.351.1610857357843;
        Sat, 16 Jan 2021 20:22:37 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1c14:d05:b7d:917b])
        by smtp.gmail.com with ESMTPSA id l8sm537444ota.9.2021.01.16.20.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jan 2021 20:22:37 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf-next v4 0/3] bpf: introduce timeout hash map
Date:   Sat, 16 Jan 2021 20:22:21 -0800
Message-Id: <20210117042224.17839-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This patchset introduces a new eBPF hash map whose elements have
timeouts. Patch 1 is the implementation of timeout map, patch 2 adds
some test cases for timeout map in test_maps, and patch 3 adds a test
case in map ptr test.

Please check each patch description for more details.

---
v4: merge gc_work into gc_idle_work to avoid a nasty race condition
    fix a potential use-after-free
    add one more test case
    improve comments and update changelog

v3: move gc list from bucket to elem
    reuse lru_node in struct htab_elem
    drop patches which are no longer necessary
    fix delete path
    add a test case for delete path
    add parallel test cases
    change timeout to ms
    drop batch ops

v2: fix hashmap ptr test
    add a test case in map ptr test
    factor out htab_timeout_map_alloc()

Cong Wang (3):
  bpf: introduce timeout hash map
  selftests/bpf: add test cases for bpf timeout map
  selftests/bpf: add timeout map check in map_ptr tests

 include/linux/bpf_types.h                     |   1 +
 include/uapi/linux/bpf.h                      |   5 +-
 kernel/bpf/hashtab.c                          | 239 +++++++++++++++++-
 kernel/bpf/syscall.c                          |   3 +-
 tools/include/uapi/linux/bpf.h                |   1 +
 .../selftests/bpf/progs/map_ptr_kern.c        |  20 ++
 tools/testing/selftests/bpf/test_maps.c       |  47 ++++
 7 files changed, 307 insertions(+), 9 deletions(-)

-- 
2.25.1

