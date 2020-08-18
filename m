Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD20247DCE
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 07:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgHRFQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 01:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgHRFQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 01:16:52 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDDA0C061389;
        Mon, 17 Aug 2020 22:16:52 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o13so9226102pgf.0;
        Mon, 17 Aug 2020 22:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y5Zc/ZnBx7HDn0Hn84bmSbv/zgUibMJgEQM0Os56gyQ=;
        b=Y7GzetaXOy95OSWh7uHYzqjFmNWMrZ+s4EUlNHtt1X4jvAdTYHGwYMhQDXi9gDf0T9
         o9je4CfEIeQxQMN2ezGb50a2BqWnnZ7xkAHRl6HWhB6oQb3hoq4p6I3BRLK+VfiptLfj
         r6T/xmH+PBqVrLT+osIh2jzR1QQqwAAA8wufSAMSjsBmP7NLLgKCpC5E/1PN7CwS1Nie
         kqCRQ8BCa4dFuwc4a6/2WwBCEhfc4WqYFHNjlfBze2bo8NVXhVsA94wCmJFjUuSO+TUC
         A9iovk+8zn2Oe34S84pDUJXwaK7uBfkB8oMKmIrlePhA3YFXpr4gWfJxI1TKPsoPTBaf
         xLkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y5Zc/ZnBx7HDn0Hn84bmSbv/zgUibMJgEQM0Os56gyQ=;
        b=sLAIRDrqKXj8shffOJdr02sjpGib5IZofAQ8EWDjMxquNU+eOx6fkrq4J6HdKVY1zY
         w2e+R7MRoKiW6RdUsi5saq9XXw9/q0nzk0B1cT0o7Rwl2m39Pr/b7Bd+4JI84Cysr71M
         yflHlgJ+ePcn0C5DK4Xf1jN2xU/aXPdItBXLkXBa5KWXUvpIYF/doPAdPfSEe1TXzznH
         20jgh9FaWTSIja3D5SuruRdWsebQi6SXCzBAyz5rPVwGGDQ0BJVw5Qldl7W9xGAs240X
         zMIN2ATXLXU7GttF+YhlfGKvlzOz0IIUGI59C0NlevcHn7br1RP4C/hVRT/b90p9TroI
         f5Zw==
X-Gm-Message-State: AOAM532/zn40IRRp3xliMTkUIJ6UfmJJNpQyI6iY9Y/Bhv+vN0X5vW4e
        8Bdaa+y8o4B6NiLMN+DWpXA8rAvGiQ==
X-Google-Smtp-Source: ABdhPJx2R0kkNuYOnh4AdOHNw8z7dggvOGGyldrRicPG1WWjulDVZP0/uvLKxDON9P8UniERXmJ17A==
X-Received: by 2002:aa7:97a3:: with SMTP id d3mr13728169pfq.178.1597727812063;
        Mon, 17 Aug 2020 22:16:52 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id q7sm20159657pfu.133.2020.08.17.22.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 22:16:51 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next] samples: bpf: Fix broken bpf programs due to removed symbol
Date:   Tue, 18 Aug 2020 14:16:41 +0900
Message-Id: <20200818051641.21724-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From commit f1394b798814 ("block: mark blk_account_io_completion
static") symbol blk_account_io_completion() has been marked as static,
which makes it no longer possible to attach kprobe to this event.
Currently, there are broken samples due to this reason.

As a solution to this, attach kprobe events to blk_account_io_done()
to modify them to perform the same behavior as before.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/task_fd_query_kern.c | 2 +-
 samples/bpf/task_fd_query_user.c | 2 +-
 samples/bpf/tracex3_kern.c       | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/samples/bpf/task_fd_query_kern.c b/samples/bpf/task_fd_query_kern.c
index 278ade5427c8..c821294e1774 100644
--- a/samples/bpf/task_fd_query_kern.c
+++ b/samples/bpf/task_fd_query_kern.c
@@ -10,7 +10,7 @@ int bpf_prog1(struct pt_regs *ctx)
 	return 0;
 }
 
-SEC("kretprobe/blk_account_io_completion")
+SEC("kretprobe/blk_account_io_done")
 int bpf_prog2(struct pt_regs *ctx)
 {
 	return 0;
diff --git a/samples/bpf/task_fd_query_user.c b/samples/bpf/task_fd_query_user.c
index ff2e9c1c7266..4a74531dc403 100644
--- a/samples/bpf/task_fd_query_user.c
+++ b/samples/bpf/task_fd_query_user.c
@@ -314,7 +314,7 @@ int main(int argc, char **argv)
 	/* test two functions in the corresponding *_kern.c file */
 	CHECK_AND_RET(test_debug_fs_kprobe(0, "blk_mq_start_request",
 					   BPF_FD_TYPE_KPROBE));
-	CHECK_AND_RET(test_debug_fs_kprobe(1, "blk_account_io_completion",
+	CHECK_AND_RET(test_debug_fs_kprobe(1, "blk_account_io_done",
 					   BPF_FD_TYPE_KRETPROBE));
 
 	/* test nondebug fs kprobe */
diff --git a/samples/bpf/tracex3_kern.c b/samples/bpf/tracex3_kern.c
index 659613c19a82..710a4410b2fb 100644
--- a/samples/bpf/tracex3_kern.c
+++ b/samples/bpf/tracex3_kern.c
@@ -49,7 +49,7 @@ struct {
 	__uint(max_entries, SLOTS);
 } lat_map SEC(".maps");
 
-SEC("kprobe/blk_account_io_completion")
+SEC("kprobe/blk_account_io_done")
 int bpf_prog2(struct pt_regs *ctx)
 {
 	long rq = PT_REGS_PARM1(ctx);
-- 
2.25.1

