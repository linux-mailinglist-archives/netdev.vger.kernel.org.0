Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 288C73BF223
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 00:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhGGWlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 18:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbhGGWlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 18:41:44 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C607FC061574;
        Wed,  7 Jul 2021 15:39:02 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id k6so4611350ilo.3;
        Wed, 07 Jul 2021 15:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=jefEaA935I7Ewqg9v7icuCVxckQtn6iREE1XC6EXneM=;
        b=WfEkgtVJ5WdHMd2Uauyp+6no/T533qvFg023aVbQ09HjKspKFclCw5df2K8nL7UW4V
         WR8sZ/4edZ5XKnNs/Fb0jwA59g8OC2Q4v3F6O33mDCUxeNOiyfxTjFzTAWUoDx8E9FUM
         DxLDEF59167EySUlCx0dcTHoLqhQ4OBNt19uXMV73peMslVAcrz+1RZ6fGxRXloxojLQ
         StA9KfxI8ad4KAGmkXDKkx+seoiiPlZqtCuhrko5myab0jw5dQ1EDJ3SyWbMdLMYNgOv
         HgL6BMF5v3BD7uRZbpGZMtYH2O68MRoq3kSAqvsdAKW4tzVtonD7zpEMq4KjlwQc/HL/
         LDfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jefEaA935I7Ewqg9v7icuCVxckQtn6iREE1XC6EXneM=;
        b=Dx54txc+LPPVMN57acdYu+wnYN2d22J8ApapLvNoWkIm9JrAPyzvZc5TgSRP6CH8Aa
         9S9gTCtlGZQRRRmAN+EhlOsUZ7mgAXmZDxqfHclcUadjEWzCSmej2s/mwG/jRpcvixXV
         xPPFvYPCM7PeNsWIPYJFLB7TSzJ8a0KsZwdr6yTEpt4n9/05tRs4mYbtIi/oK8z0T1zr
         afSTb/UdeuicYyM7zcGIhuPTEbOEYMp13YIYGi1XB1JuWxruB9N1vDXBWemf8+DzJ388
         +HNifcMj+NW24TEqYaRtfpZj046YSDDV24xB498CrxGIGyTkncMweIIRUs85yqCkx+1g
         r7RQ==
X-Gm-Message-State: AOAM532Qw0Hszt/fBx60Rxmifx9mX8zQg4NyfhsuXODSmhSixxJRKv31
        reSVuS5o9/8CYQ0+77wjYeenl8N6UBRr+A==
X-Google-Smtp-Source: ABdhPJxzShA6QPq9FK6cD/m2zDnpgLFZxVGMPC5bQVCghRfEKT77P3x5Igq03VA45qTQSGuOdL1IYw==
X-Received: by 2002:a92:ce12:: with SMTP id b18mr19505597ilo.96.1625697542252;
        Wed, 07 Jul 2021 15:39:02 -0700 (PDT)
Received: from john-Precision-5820-Tower.lan ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id f4sm253455ile.8.2021.07.07.15.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 15:39:01 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf v2 0/2] bpf, fix for subprogs with tailcalls
Date:   Wed,  7 Jul 2021 15:38:46 -0700
Message-Id: <20210707223848.14580-1-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes a use-after-free when using subprogs and tailcalls and adds
a test case to trigger the use-after-free.

v2: original patch missed fixups needed in out label as Daniel caught 

John Fastabend (2):
  bpf: track subprog poke correctly, fix use-after-free
  bpf: selftest to verify mixing bpf2bpf calls and tailcalls with insn
    patch

 arch/x86/net/bpf_jit_comp.c                   |  4 ++
 include/linux/bpf.h                           |  1 +
 kernel/bpf/core.c                             |  7 ++-
 kernel/bpf/verifier.c                         | 45 ++++---------------
 .../selftests/bpf/prog_tests/tailcalls.c      | 36 ++++++++++-----
 .../selftests/bpf/progs/tailcall_bpf2bpf4.c   | 21 ++++++++-
 6 files changed, 65 insertions(+), 49 deletions(-)

-- 
2.17.1

