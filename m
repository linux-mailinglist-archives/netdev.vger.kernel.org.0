Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26DA544138E
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 07:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbhKAGIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 02:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbhKAGHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 02:07:43 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3B8C06122C;
        Sun, 31 Oct 2021 23:04:55 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id l13so5851568pls.3;
        Sun, 31 Oct 2021 23:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QKwddORb13OigBCy9mDZcUnsG5h+t9yQLv8LVp5siCU=;
        b=j5LFKzVUzTdpQtOquEYQiQ93/QxNXDe/080ZPzqen1nnJEcnWv0Arg1m3H5YGUWw8M
         stUDWkjS1zFBojQqjlqwmgBfiFDvw/FY5w1DdoEUTOEo04//87rHjl76eKfDkRV6JYaD
         wHniweh+Bt9WBNr9zbaJOafXiibJeSYbktM2cOjCLSm/QMXoinVi4CBxQO0XAGBypciT
         vft62rQAmLIxRWsns2FxpBvhq592YznXCJfnsuQVHL7l548rjILVi1WcAe1E24RkOJBv
         6xba3tgT8iJOTopxgjfSx7YFqWx5gxJbgzz6VMxiVUScwsGxaEWyzxex2OUaialtPu/r
         8Emw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QKwddORb13OigBCy9mDZcUnsG5h+t9yQLv8LVp5siCU=;
        b=ejNQ3ZWHYJ19MF44lpdAswwzMjH2DL96bejXoDBGJAc0yB6p4zPTy9VxORoYptl/eq
         /9vgSu2bQPmJid/zehsBnikd2cp2bT23NCEQdWNwdRjjYOKp/Qinu5nlmoTIE8I+yv0e
         SqeZ34xks1kPdOcxHMPmSKeh1c0ccqEmY7MzcexY4yjw28vkYUcChIepqZ48NPmavZbj
         3H2PAQbaeqACGG+kANVuRKRu/KQESYdVYfbI5dj1mPck5c/toMUY3itLBn9HQNPCkL91
         U0guMUc42RUlVvy5PzTDkCaMz9mS8uB4dEiGatyk5IEkgBMnfKrN8QDCMuts4vW9LZ5o
         wLoQ==
X-Gm-Message-State: AOAM532L6cDo/KB5/i9IBKqGbrfkTDURPrr5iLGtUPKy58Ek0xVOsbo6
        0zbbSb4qccEH7vl3mgus5ck=
X-Google-Smtp-Source: ABdhPJyrJq+mOKZ0lf2kZ6Y6bPXWfxcFbUFKsxFZDJ2CDMm20OFCcbYj+83X+q3vioiE0f2mNOqwFQ==
X-Received: by 2002:a17:90a:930c:: with SMTP id p12mr36038293pjo.176.1635746695055;
        Sun, 31 Oct 2021 23:04:55 -0700 (PDT)
Received: from localhost.localdomain ([144.202.123.152])
        by smtp.gmail.com with ESMTPSA id g8sm3277586pfc.65.2021.10.31.23.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Oct 2021 23:04:54 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     akpm@linux-foundation.org, keescook@chromium.org,
        rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
        arnaldo.melo@gmail.com, pmladek@suse.com, peterz@infradead.org,
        viro@zeniv.linux.org.uk, valentin.schneider@arm.com,
        qiang.zhang@windriver.com, robdclark@chromium.org,
        christian@brauner.io, dietmar.eggemann@arm.com, mingo@redhat.com,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, dennis.dalessandro@cornelisnetworks.com,
        mike.marciniszyn@cornelisnetworks.com, dledford@redhat.com,
        jgg@ziepe.ca
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, oliver.sang@intel.com, lkp@intel.com,
        Yafang Shao <laoar.shao@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: [PATCH v7 11/11] kernel/kthread: show a warning if kthread's comm is truncated
Date:   Mon,  1 Nov 2021 06:04:19 +0000
Message-Id: <20211101060419.4682-12-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211101060419.4682-1-laoar.shao@gmail.com>
References: <20211101060419.4682-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Show a warning if task comm is truncated. Below is the result
of my test case:

truncated kthread comm:I-am-a-kthread-with-a-l (pid:178) by 8 characters

As we have extended task comm to 24, all the existing in-tree
kthreads/workqueues are not truncated anymore. So this warning will only
be printed for the newly introduced one if it has a long name.

Suggested-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Petr Mladek <pmladek@suse.com>
---
 kernel/kthread.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 5b37a8567168..63f38d3a4f62 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -399,12 +399,17 @@ struct task_struct *__kthread_create_on_node(int (*threadfn)(void *data),
 	if (!IS_ERR(task)) {
 		static const struct sched_param param = { .sched_priority = 0 };
 		char name[TASK_COMM_LEN];
+		int len;
 
 		/*
 		 * task is already visible to other tasks, so updating
 		 * COMM must be protected.
 		 */
-		vsnprintf(name, sizeof(name), namefmt, args);
+		len = vsnprintf(name, sizeof(name), namefmt, args);
+		if (len >= TASK_COMM_LEN) {
+			pr_warn("truncated kthread comm:%s (pid:%d) by %d characters\n",
+				name, task->pid, len - TASK_COMM_LEN + 1);
+		}
 		set_task_comm(task, name);
 		/*
 		 * root may have changed our (kthreadd's) priority or CPU mask.
-- 
2.17.1

