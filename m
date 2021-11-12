Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61C344EB77
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 17:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235209AbhKLQgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 11:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235496AbhKLQgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 11:36:08 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E11C061766
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 08:33:17 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id u18so16505041wrg.5
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 08:33:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=29aEpYq5trH4dOPg9jb/UUPE1JLQg8xtBdREC7Lqi2Q=;
        b=VN6Me0XULGd/e9ffggWa6m4My3NjArjVfQagBJs/rlpPGsb1/OI31jC/yDuTfGZR68
         R8KVdsk7HJpYcj8rHbJpBgS1PwWw0NvC0u3mdY7cFWd0iVgpjC4vAF5cbw0D6pPsuSlB
         nqwAxrx2EX0tZxnBiea6xzl1VbU4ckZppx0mHgLmRLEz/G5j32xu3Vu4HNvbhJWe0l/s
         PGpy5hy9Na0LRr83Ilw3pbgoWafudSPmZGRBZy1dB/A0PdotD20ktbcIGMKZ0hjow04j
         NZM97UwG6Q1w42Ly0Bu4zIxBeJSg27fW33TfeoDVSkout0maVw97DQO8VKDCgfdms6cw
         3r+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=29aEpYq5trH4dOPg9jb/UUPE1JLQg8xtBdREC7Lqi2Q=;
        b=hbXpCQnEfWH169HQaSnrit02/pbM82lAO+OIY7AcDMi4m8T7MJmIrDSmz+6ynT2I19
         k+8thJim8jxuvKJXkchB2ugVvLWJW0WlKIdFYtLuJbH62SAZusHwBcISAvNp782Ev0GA
         QqSYPUAWZolgjQt8mcjj8lEeGXRhLSgb+yjJHHD6G7u6e1Zg1k5FVkryskAI7IDtjVNB
         6gL6z0p9JRYRzyjR3GpTUHIjgvSC1pLZpLzYeAjHB9G3N+Y6xdW4WIr11u+C06+IxbAI
         wHO5iOFH/EYPsV5geDLetOpKKmZaVAp3FxQXFt6hWGskDd0AH8zEM7WUcRXcQ6uoi2UO
         NxcQ==
X-Gm-Message-State: AOAM532qCqgnpnkfcnNawvLgLrQksZzr0SMR0aDA3xVIOc4q/FbL/qbN
        FH4SH/uadsKiT5rNEbMD5XDM2QyRXPDp9w==
X-Google-Smtp-Source: ABdhPJwf20H2qVmc4pa6mw4IRPMCCyw4CdbXX0JXP6QGOSzufiGVN6EFbhX+IQjqTMI8nblPVVY0nQ==
X-Received: by 2002:adf:dd0d:: with SMTP id a13mr18998491wrm.259.1636734795541;
        Fri, 12 Nov 2021 08:33:15 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id c11sm8631595wmq.27.2021.11.12.08.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 08:33:15 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net 0/2] net: fix the mirred packet drop due to the incorrect dst
Date:   Fri, 12 Nov 2021 11:33:10 -0500
Message-Id: <cover.1636734751.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This issue was found when using OVS HWOL on OVN-k8s. These packets
dropped on rx path were seen with output dst, which should've been
dropped from the skbs when redirecting them.

The 1st patch is to the fix and the 2nd is a selftest to reproduce
and verify it.

Davide Caratti (1):
  selftests: add a test case for mirred egress to ingress

Xin Long (1):
  net: sched: act_mirred: drop dst for the direction from egress to
    ingress

 net/sched/act_mirred.c                        | 11 +++--
 tools/testing/selftests/net/forwarding/config |  1 +
 .../selftests/net/forwarding/tc_actions.sh    | 47 ++++++++++++++++++-
 3 files changed, 55 insertions(+), 4 deletions(-)

-- 
2.27.0

