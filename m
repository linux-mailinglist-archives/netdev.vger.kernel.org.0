Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE3426E8B60
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 09:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbjDTH1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 03:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233857AbjDTH1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 03:27:13 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5041B273C
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 00:27:11 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1a68d61579bso6657355ad.1
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 00:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1681975631; x=1684567631;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hg5G5o39i/mOMMBB9sZHDlNqgHJXvtHyvxUr2dJ6THE=;
        b=kH4OTVJnseH6q7Pe1OOos6zPSHDAj2tZ3qazT0bYMqWKsaGrGzoVXAs3l/JAw+j1uX
         BXCMEQb6ZcsuZ3SVhgAScqbhp0DJlBdJO8HBkB0E+llRcaSBO0Os/+DSrtH3J0oUSNcY
         hae3WB91GwxFXIIvhDunREC36+rEKUAaCp36mnpohuHY1u+KW2U9FzpIXSs5wXp39BQ1
         6TA0plyxWwwY0ADUdpTefB6sKA2APq+b1MZxAwbklNl2gWCQUlOtlgz3V7B0Yx4iJNGl
         pjWTq1UvjsNAsXD66F9eEMQPuhP7xgOsZ6wiF+iSqJrg+wxvZ6hvVOPvUMqmc8gdoqZl
         ++cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681975631; x=1684567631;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hg5G5o39i/mOMMBB9sZHDlNqgHJXvtHyvxUr2dJ6THE=;
        b=WTEcfXCCRrfxbnxCMn3BHqFbwPolMiYVYfjHQtYE8x5iSfU60xYWdciBucs/ry9nql
         oA88PpsV3OoSTdF6eUERN/kg4AfiXQDqbERLEUGugUI4gKudsbQWiv2jbz8OBavzayeh
         r3oO2N6v7tMDXchETpkR0TseOJkMABWaabus98ZivepEL7a3TLvuwImUvGdbQGsrNETf
         CkF0IVRvj94GupsG+eDmKFRIpsojY1O9hfxkaWA2/67h4/Bu7rGQXNuGY+dqK8JTPqP6
         R2TJjvAtt31w+6Cc811idcYaVwWiKuhc0vR53Ii6xw4eoWpjUr0KxYpxFp70ZvZFpeBi
         u4Yg==
X-Gm-Message-State: AAQBX9d3EDF357nXUTukvKmdfSPbh4jS9dfDWt/rduUoXzZWIKmV1xwy
        kR0U6uYmwfiYQgkzQ4Hm2rvFWw==
X-Google-Smtp-Source: AKy350ZJIw4S2jRf7AWkGYprd3RLjOgFmimEdu2sssZcSsBy7YV14EYvdTzo91BU7GQ4xQK0LTxMDg==
X-Received: by 2002:a17:903:2444:b0:19e:6cb9:4c8f with SMTP id l4-20020a170903244400b0019e6cb94c8fmr814495pls.41.1681975630719;
        Thu, 20 Apr 2023 00:27:10 -0700 (PDT)
Received: from C02F52LSML85.bytedance.net ([139.177.225.238])
        by smtp.gmail.com with ESMTPSA id y18-20020a17090ad71200b0023440af7aafsm612160pju.9.2023.04.20.00.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 00:27:10 -0700 (PDT)
From:   Feng zhou <zhoufeng.zf@bytedance.com>
To:     martin.lau@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mykolal@fb.com, shuah@kernel.org
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        yangzhenze@bytedance.com, wangdongdong.6@bytedance.com,
        zhoufeng.zf@bytedance.com
Subject: [PATCH bpf-next 0/2] Introduce a new bpf helper of bpf_task_under_cgroup
Date:   Thu, 20 Apr 2023 15:26:55 +0800
Message-Id: <20230420072657.80324-1-zhoufeng.zf@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Feng Zhou <zhoufeng.zf@bytedance.com>

Trace sched related functions, such as enqueue_task_fair, it is necessary to
specify a task instead of the current task which within a given cgroup to a map.

Feng Zhou (2):
  bpf: Add bpf_task_under_cgroup helper
  selftests/bpf: Add testcase for bpf_task_under_cgroup

 include/uapi/linux/bpf.h                      | 13 +++++
 kernel/bpf/verifier.c                         |  4 +-
 kernel/trace/bpf_trace.c                      | 31 ++++++++++++
 tools/include/uapi/linux/bpf.h                | 13 +++++
 .../bpf/prog_tests/task_under_cgroup.c        | 49 +++++++++++++++++++
 .../bpf/progs/test_task_under_cgroup.c        | 31 ++++++++++++
 6 files changed, 140 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/task_under_cgroup.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_task_under_cgroup.c

-- 
2.20.1

