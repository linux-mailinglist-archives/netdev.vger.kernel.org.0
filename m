Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD95300E5D
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 21:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbhAVU4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 15:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730343AbhAVUzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 15:55:11 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53F4C06174A;
        Fri, 22 Jan 2021 12:54:30 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id 36so6454759otp.2;
        Fri, 22 Jan 2021 12:54:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DOVTjNJRZMnM+kceEiLJHqeJw55QWfuw/x9E/sbQ+ws=;
        b=tsowucZcMrElg3LFFkcBe5NB2AVwbMPq8ozIsRn+8iVFSgNMrkLEJOYPLYSwFGLNIG
         wwj5leUpJ8um/r3oTocXEbPNP+JwAIcuOhohmUlN1eTqWf59hgQaPVIR4v/rwZ9JF/9P
         Wtby9GYcEGdDBrZXD6S7THp1Aq4Iu0DXq8KAPaozjrWFxrzU66GoVQFxegcVnCQhc01d
         ljDuw1PbQj/Ntd7xiKDwLd7WZhVeOVyE162UxDNKx9lpPnp+25tqJdRZJb7DAIeTXWKZ
         P6Qkp+XpWkccZdkeHkgRzN28GJ7o/Hb44//gADbEtT1DjAxIihM6AE4xGaL57nWQjjeM
         lT1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DOVTjNJRZMnM+kceEiLJHqeJw55QWfuw/x9E/sbQ+ws=;
        b=kOMUdR4i1qG6GXfDYrsg2bvablgfZ9dz27vvN5dEYOlaHUtU55yw7fGYL2IQl2MbSf
         qaxoeTy3tkxcvgX4oaP9lLnwMDIkbNmNV0ALdK5OZvla+H1ViXa1Ypwd3MmPRELLkL3f
         ntAJgpilyH12tXfxlzeCRz/qjVN8OZfZNxbe4RN46SGMJYcR7ipl9+XGY8QVjU6VChvc
         vSxc8Fg6lUuFfFsepLmkAhUtTO3H0AecVqFslfcjXivPqQsmXP0nVL0dTWOc8J1E6Ku5
         /+Ltqch+h3gDsykFUD7h0+GQghEBwBiMxni78Mywc1OGIQ2uKJrTV79FbAys4LshM7kM
         nTHQ==
X-Gm-Message-State: AOAM533lzWR3j6KepEIjXbsOP73RWLJ6HGPZyJ2VP3xYRgy7lzy4fYCA
        dJek39bMGtxyRsbvbU/cbKYhAP5LINYrcg==
X-Google-Smtp-Source: ABdhPJyUCqTvmyTHgFTrTyMm8d1WftmtHPiqwbInT1YSC4ZjbU8TiM2PZHVVmd5ffREIHYFtOuoNww==
X-Received: by 2002:a9d:4917:: with SMTP id e23mr2343802otf.143.1611348869858;
        Fri, 22 Jan 2021 12:54:29 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1c14:d05:b7d:917b])
        by smtp.gmail.com with ESMTPSA id k18sm1349193otj.36.2021.01.22.12.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 12:54:29 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jhs@mojatatu.com, andrii@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf-next v5 0/3] bpf: introduce timeout hash map
Date:   Fri, 22 Jan 2021 12:54:12 -0800
Message-Id: <20210122205415.113822-1-xiyou.wangcong@gmail.com>
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
case in map ptr test. This patchset has been tested with the provided
test cases for hours.

Please check each patch description for more details.

---
v5: add a lost piece of patch during rebase
    fix the extra_elems corner case
    add a stress test case

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
 kernel/bpf/hashtab.c                          | 274 +++++++++++++++++-
 kernel/bpf/syscall.c                          |   3 +-
 tools/include/uapi/linux/bpf.h                |   1 +
 .../selftests/bpf/progs/map_ptr_kern.c        |  20 ++
 tools/testing/selftests/bpf/test_maps.c       |  68 +++++
 7 files changed, 357 insertions(+), 15 deletions(-)

-- 
2.25.1

