Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85C0465C49
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 03:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348543AbhLBCuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 21:50:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbhLBCux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 21:50:53 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056D1C061574
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 18:47:31 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id b13so19206571plg.2
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 18:47:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zHaY/u+VXW2CsMUSynMMz/TLLwWJkeEeKBLeRVbqzXw=;
        b=PCOrE/Hsx5cfYETnaRINphxXFTZo/emIo4K2hxObLIeQslGBdBI1GDuMVsidxqcuwJ
         sXo7/cuohG/CcSLQGRWnDxTAy14IHdxJc2IdFfXjrWVH6gThQIfWBgmQW1f1zpsErntq
         gpettylIQ6MwBlsjaZ0mcqyaT3Rt6lpMhxRbTbh0vWixpJIvE2e3PqxdmC9Btin174jq
         aa3qmowTMijeK7aRvbLVV4P4CCCg9/TC8dBkopZ8rQGGUeLrYbveBoASeLdKZYicHznA
         fLSP3L3NJfgp71Wp6bmaluhWX5TmzCnt3I/bwoqDPr1XEsdtCO37EtWFfQ6kJB0mknKQ
         zOsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zHaY/u+VXW2CsMUSynMMz/TLLwWJkeEeKBLeRVbqzXw=;
        b=vsTPZER6r7B0fziATt81/yzilHrAEwN5vDrwoZje11Gf6AvO42rI2FKZ/9FWNvUNqM
         tyJ0j6NhzyNjPB1BGhhcYAeXzx6kGSexSbMfibO0DQGioRXgz/T7xEfB3zA3wh1ckG29
         RcYV7wSfY5AA4mcKmULyN6CFXAFvoKp2Godf4DZl+uTdktFESNYQrxvS1PPClurz0kBT
         Dx5Tx8RhrJjWMvcG+qorOzOjduQtmsXwJImAMrByIBWZy/mDfDjafyo02OLgIZ0gTuvw
         sExK2qIfbqXsY0P1KuWLcreN5rkPCFL64IoaaJDxLpdpRnG535bLf4+gLitPP8Ubc7Rx
         RgfQ==
X-Gm-Message-State: AOAM533KaTGnD1kGOF606jtpc10R2TimFwiG+56IrtOk3KsBbTI1weGD
        Yz3T4YAj97mrxxBTMTBr90bCArQyi/Q=
X-Google-Smtp-Source: ABdhPJyAnybTrZbB/62hBdLoto0D1QS6NB+w0PleHqmfjVbS/9M1080YS6Sf/nGg7NaWcduM7pi4nQ==
X-Received: by 2002:a17:90b:3b4c:: with SMTP id ot12mr2753472pjb.196.1638413251116;
        Wed, 01 Dec 2021 18:47:31 -0800 (PST)
Received: from localhost.localdomain ([111.204.182.106])
        by smtp.gmail.com with ESMTPSA id z10sm1183180pfh.188.2021.12.01.18.47.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Dec 2021 18:47:30 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, edumazet@google.com, atenart@kernel.org,
        alexandr.lobakin@intel.com, weiwan@google.com, arnd@arndb.de,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [net v4 0/3] Fix bpf_redirect to ifb netdev
Date:   Thu,  2 Dec 2021 10:47:20 +0800
Message-Id: <20211202024723.76257-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

This patchset try to fix bpf_redirect to ifb netdev.
Prevent packets loopback and perfromance drop, add check
in sch egress.

Tonghao Zhang (3):
  net: core: set skb useful vars in __bpf_tx_skb
  net: sched: add check tc_skip_classify in sch egress
  selftests: bpf: add bpf_redirect to ifb

 net/core/dev.c                                |  3 +
 net/core/filter.c                             | 12 ++-
 tools/testing/selftests/bpf/Makefile          |  1 +
 .../bpf/progs/test_bpf_redirect_ifb.c         | 13 ++++
 .../selftests/bpf/test_bpf_redirect_ifb.sh    | 73 +++++++++++++++++++
 5 files changed, 101 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_bpf_redirect_ifb.c
 create mode 100755 tools/testing/selftests/bpf/test_bpf_redirect_ifb.sh

-- 
2.27.0

