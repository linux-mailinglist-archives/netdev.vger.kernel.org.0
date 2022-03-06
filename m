Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0CFA4CEB7B
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 13:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbiCFMQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 07:16:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiCFMQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 07:16:36 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3AE15C649;
        Sun,  6 Mar 2022 04:15:44 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id z16so11476958pfh.3;
        Sun, 06 Mar 2022 04:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4bHhpltx5t5BGct675dtWCaSJ7bKFWsocHgCtE6eVVc=;
        b=bzJD080S+XDAsKEY1Tr7d58HsT3skQFMC81wCT3/qmQ5zO6HxEX7M9FgRMbI9kgC+R
         WC83rFFuxsgaLokbgjnHTjxHD4T1GZEShuQKBF1eM3VksSygT57ZEYXbS40qcpGI+FWN
         8OIO8kx9/lpSQbcQ3hAzqNrolTD1gDdMMphGIcqyYAl5KgdxWekcv65x1gcq1cHZkRpI
         3iTxLizN8EPTFcwca8Vo3hz5bpR/VWPz+P3LSOH242Z7AuaE2phWnRKGRusidEgHQthi
         GfPmySoiT71SybnHtyIc/vWUS2kTK5svvBrEIVp9htwhAxi3VLhpBB5GnbNDDUPlGpPS
         lzug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4bHhpltx5t5BGct675dtWCaSJ7bKFWsocHgCtE6eVVc=;
        b=QxRvPcErG3N35rSQ7Y1nY3cXFT6fD/Qc8Jaul5l/PgZxRTGsU1F/BWMOBpNXWps3t/
         qg+1Du870kZWQlvksiDf0K2AOqDiqXQdwIknrs5J4PYl05ZAznPnaDkm/3qUtwVsESMQ
         nz5vd5cETSfIyztQG4VIu1pua17K/Gq3BjZc4fVXr+aVfVJFJhlM2em30mJKqcMEkg04
         C4LYfuEkZhwk0O4XR6TXdEZe8FfmYHybTWBRH5BwSPawPOVDIWopjdESNo/try9Fy1b8
         w6nHeI/kcM3U78uWMS/pyMQ328/ATBvDwG1911nBBiyhCAipb9fhdYtPUPCrCRtqWm10
         APdQ==
X-Gm-Message-State: AOAM532OukwLLL1rxa6FD6dFhiGpjdl/ljcORJhUcGZN5MqHFsdejwrr
        AP83h8CWjWtSw/LI1PhLDYs=
X-Google-Smtp-Source: ABdhPJwMwgpJ3FZFGDEqfbPHz4WIisFZDDFIZnebzD81Yp1JdcrYZMuCkinh87h1xKDlnFDYIK2Aig==
X-Received: by 2002:a63:5214:0:b0:373:8aca:7453 with SMTP id g20-20020a635214000000b003738aca7453mr5826444pgb.574.1646568944065;
        Sun, 06 Mar 2022 04:15:44 -0800 (PST)
Received: from baaz.falakreyaz.gmail.com.beta.tailscale.net ([49.36.203.74])
        by smtp.gmail.com with ESMTPSA id me8-20020a17090b17c800b001bce9d8e61fsm16481253pjb.50.2022.03.06.04.15.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 04:15:43 -0800 (PST)
From:   Muhammad Falak R Wani <falakreyaz@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Muhammad Falak R Wani <falakreyaz@gmail.com>
Subject: [PATCH bpf-next] samples/bpf: fix broken bpf programs due to function inlining
Date:   Sun,  6 Mar 2022 17:45:35 +0530
Message-Id: <20220306121535.156276-1-falakreyaz@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit: "be6bfe36db17 block: inline hot paths of blk_account_io_*()"
inlines the function `blk_account_io_done`. As a result we can't attach a
kprobe to the function anymore. Use `__blk_account_io_done` instead.

Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
---
 samples/bpf/task_fd_query_kern.c | 2 +-
 samples/bpf/tracex3_kern.c       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/task_fd_query_kern.c b/samples/bpf/task_fd_query_kern.c
index c821294e1774..186ac0a79c0a 100644
--- a/samples/bpf/task_fd_query_kern.c
+++ b/samples/bpf/task_fd_query_kern.c
@@ -10,7 +10,7 @@ int bpf_prog1(struct pt_regs *ctx)
 	return 0;
 }
 
-SEC("kretprobe/blk_account_io_done")
+SEC("kretprobe/__blk_account_io_done")
 int bpf_prog2(struct pt_regs *ctx)
 {
 	return 0;
diff --git a/samples/bpf/tracex3_kern.c b/samples/bpf/tracex3_kern.c
index 710a4410b2fb..bde6591cb20c 100644
--- a/samples/bpf/tracex3_kern.c
+++ b/samples/bpf/tracex3_kern.c
@@ -49,7 +49,7 @@ struct {
 	__uint(max_entries, SLOTS);
 } lat_map SEC(".maps");
 
-SEC("kprobe/blk_account_io_done")
+SEC("kprobe/__blk_account_io_done")
 int bpf_prog2(struct pt_regs *ctx)
 {
 	long rq = PT_REGS_PARM1(ctx);
-- 
2.35.1

