Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B1D3067ED
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 00:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbhA0Xay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 18:30:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231296AbhA0X3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 18:29:36 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDA0C0613ED
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 15:28:55 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id 22so2254383qty.14
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 15:28:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=aV8qow/FlZNu0c81xilee4C+KbHK/rtvK4HJqpkcS4A=;
        b=VCZP39zYXsZwenkBzMAEwnx+ULlIDbDyV9VqrO2RXlCODqfqoM8m+f2LuS8tbf7V6o
         XPmuce1SrV+D3Wuk3eV00rY3bi4ISIRmkUmjfButeyBCR1l+GToQDJyaUr/cpR2D04C4
         L5g5rv7IkxLVU5ZYR765RhqG6v7UPkX5aSZVOctk3vbfmFglMURMkeRyGdw2IgSHQN+r
         jEIAojqQd7q79xL/M65GyGVJePQSGJTo39wiviUkAm48pPI7PUjuxcFVqHCt8xnGSC3h
         t3guGwx4K0tnxlMREJAPaYgzpB3hitQxgrhCDkKtHbSuHYt5lhi/IQhgcXZUbzFZtSwl
         0KRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=aV8qow/FlZNu0c81xilee4C+KbHK/rtvK4HJqpkcS4A=;
        b=K+9MxL1XOZzzdFgWJVrK5c/9L+B8FSEWAPt2c+XGbGAygfKX5yD+3YIZUh8rHaPHq6
         xADbrCADEj/fanPP6UxCyORX1xmoZhri8fvEGbknRRvC1atZu4qA2AzvtBnW+00yAj+E
         T/dbPbpvW9WDMn6ULo3p7rZZ5jLdmFCMwPJPe37Y0VHwLybhem02yhhkpEZaCc4S3HJc
         tT8EpbAvlquSi4YG5yuQVC0KVl38OhOqS2amT4G1Rovb8JXK5eTUYTJv5z5QvflP4FOp
         L+vyNfUv8Gd021KJZGnyWy6prgtdaQxvQSITWUjMhyYsuqsu9x1yKGsala4m08KIgFAV
         pQ+A==
X-Gm-Message-State: AOAM530ggpVlxoMkap/RoOdkJ+Y97AH91obKRfMFaNSKFNtz9jghabxP
        9bkIC18F5ttba1npHyougIXsuLki5b451RddTEAcnlg72Q7EUfpfhc0II9C0IFQGommm5lpocHE
        WwPmtHVD/C4esttYFodgvaaMs9Ffwh/mRw7XBa1XpvCl3BiZysgH85A==
X-Google-Smtp-Source: ABdhPJz6V+ya64pFDx3wSNHefGAy0VN+OCOjr0JVgJ7jbCXMNtCj/yuI+U4WnwEEisUsYWxjq1gQmBU=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:ad4:53ab:: with SMTP id j11mr6120275qvv.1.1611790134978;
 Wed, 27 Jan 2021 15:28:54 -0800 (PST)
Date:   Wed, 27 Jan 2021 15:28:49 -0800
Message-Id: <20210127232853.3753823-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH bpf-next v2 0/4] bpf: expose bpf_{g,s}etsockopt to more
 bpf_sock_addr hooks
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We'd like to use the SENDMSG ones, Daniel suggested to
expose to more hooks while are here.

Stanislav Fomichev (4):
  bpf: enable bpf_{g,s}etsockopt in BPF_CGROUP_UDP{4,6}_SENDMSG
  bpf: enable bpf_{g,s}etsockopt in
    BPF_CGROUP_INET{4,6}_GET{PEER,SOCK}NAME
  selftests/bpf: rewrite readmsg{4,6} asm progs to c in test_sock_addr
  bpf: enable bpf_{g,s}etsockopt in BPF_CGROUP_UDP{4,6}_RECVMSG

 net/core/filter.c                             | 16 ++++
 .../selftests/bpf/bpf_sockopt_helpers.h       | 21 +++++
 .../selftests/bpf/progs/connect_force_port4.c |  8 ++
 .../selftests/bpf/progs/connect_force_port6.c |  8 ++
 .../selftests/bpf/progs/recvmsg4_prog.c       | 42 +++++++++
 .../selftests/bpf/progs/recvmsg6_prog.c       | 48 +++++++++++
 .../selftests/bpf/progs/sendmsg4_prog.c       |  7 ++
 .../selftests/bpf/progs/sendmsg6_prog.c       |  5 ++
 tools/testing/selftests/bpf/test_sock_addr.c  | 86 +++----------------
 9 files changed, 167 insertions(+), 74 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/bpf_sockopt_helpers.h
 create mode 100644 tools/testing/selftests/bpf/progs/recvmsg4_prog.c
 create mode 100644 tools/testing/selftests/bpf/progs/recvmsg6_prog.c

-- 
2.30.0.280.ga3ce27912f-goog

