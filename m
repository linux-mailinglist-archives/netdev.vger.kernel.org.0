Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63A42E03E0
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 02:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725826AbgLVBeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 20:34:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgLVBeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 20:34:36 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98521C0613D6
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 17:33:56 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id p126so13230901oif.7
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 17:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ck7csi3zKqXrT/VMla0nlJF6LqwPlBE9JwVQNoLM/+g=;
        b=oLmqupE69GBHksHwg5GdwgtV7AY5BiPRej6SZHCS+Y90sEIIM9hjR3Lkon2oqC8xF5
         qBo4TDIEuBggeDSuPOP6c3eyklyHrKiAJfC0yPgDBi7AfVmI4ZXZ/e/sdjexkkRE/I80
         A/3LREIaBNlLsBn2ZfMuNxAO6nJybysmTLYGEe6gxePXfOCfYNwlIOW1r7ofhfuS4sZ6
         RMxxfps6iR2rrHIfOhm3FzJbcw3wPIaxTbhDwZZ5g+i4JpMdboGOoOpQHujXPWvCzfb9
         2ggX8YTN9kTSFj91lBFpLZv5gx9pFyNYsVAthZBv7fpTdmzz5AycdWlL9PV3RARZBXXk
         f2yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ck7csi3zKqXrT/VMla0nlJF6LqwPlBE9JwVQNoLM/+g=;
        b=MgR+wJb4s+jsD7GvSHz1Ha7EiJeNjdz+CqlRter3jAPcK/dVP9QcHJkqJnrKlbPEs6
         cxo9YLe5zEc80gRvSBdXkyDOiLBX3/kle+zhDs5Lx6LmXrm2/F9UJ05BALgKzNmZayhN
         uWVdNqlR6CrO9/MIhc9u5VeqHNYgmn4h8aTWSPn2hQA5Lau6n3Wm5Jzg71QKt0KTpD6c
         8lse6xenNUOfpc8scJI2xbD9rv3ecpZjfrtsDliGAS9AGWk1UKSLRQjyu2VjvQnSZaiF
         K2L/p8RPYxp4mKBPH+eaIQT3hMVKCSvWFQExNlsJ89C1aAkxQcjuYEchSVCRqGz6eg0l
         dVDA==
X-Gm-Message-State: AOAM533Gbf3otlb7mZU5f/u3t4YhinVYDK72ScYUVqK7ltbVIvaSd24I
        VQvwj6R75Ciwra1o+O6u7TRfMf8BVlQmSw==
X-Google-Smtp-Source: ABdhPJz72hRPPSiqr5cApHXavv7f1T8U/P3q27OHaSC/pm2/9xFU6pHhcd9aLangABJAirLqdXzOFA==
X-Received: by 2002:aca:c3c3:: with SMTP id t186mr12986148oif.53.1608600835277;
        Mon, 21 Dec 2020 17:33:55 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:3825:1c64:a3d3:108])
        by smtp.gmail.com with ESMTPSA id z14sm4089607oot.5.2020.12.21.17.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 17:33:54 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf-next v3 0/3] bpf: introduce timeout map
Date:   Mon, 21 Dec 2020 17:33:41 -0800
Message-Id: <20201222013344.795259-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This patchset introduces a new bpf hash map which has timeout.
Patch 1 is the implementation of timeout map, patch 2 adds some test
cases for timeout map in test_maps, and patch 3 adds a test case in
map ptr test.

Please check each patch description for more details.

---
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
  bpf: introduce timeout map
  selftests/bpf: add test cases for bpf timeout map
  selftests/bpf: add timeout map check in map_ptr tests

 include/linux/bpf_types.h                     |   1 +
 include/uapi/linux/bpf.h                      |   5 +-
 kernel/bpf/hashtab.c                          | 252 +++++++++++++++++-
 kernel/bpf/syscall.c                          |   3 +-
 tools/include/uapi/linux/bpf.h                |   1 +
 .../selftests/bpf/progs/map_ptr_kern.c        |  20 ++
 tools/testing/selftests/bpf/test_maps.c       |  46 ++++
 7 files changed, 319 insertions(+), 9 deletions(-)

-- 
2.25.1

