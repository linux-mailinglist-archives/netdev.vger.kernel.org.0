Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3305C435958
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 05:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbhJUDsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 23:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbhJUDrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 23:47:51 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8922BC061755;
        Wed, 20 Oct 2021 20:45:32 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id s136so21131316pgs.4;
        Wed, 20 Oct 2021 20:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IFlJQvgcVFayHxxxZOKIVduulLCEIS8IL4o5ynS1C+Y=;
        b=UV8lW+/u1hTpRZJeCHc5TAt9vjBVIKt3Djp229X12qYrvSLGxWW1bKeiw+35AbdgHZ
         WTHz3f4L3AEy4IcO4pxMCxOofNj3ssteEGzxBpB+qYEtsB6hOybtEFf3eU573jsSgpUE
         Nwjn4G9sdOwsZs39sVNKcDy01eHIktFDOO2ioKO9LlyLYiqocG7RJgjuC/LM5CjJE42j
         ySBHVs2Rqa6BOsWToOPQoyUJ3vEmMgzACPy6muR0ZkQcLZDG2ThP3p2GVvto9g+wsEWM
         g0Jiw1B4Ew61OZS3bljvYjzsQ9AL94rVWrEN6LADvLRsKcdK8mu4n5ijbRADRGbgAiVE
         b4Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IFlJQvgcVFayHxxxZOKIVduulLCEIS8IL4o5ynS1C+Y=;
        b=uTA8Q/0hWLp40hntGN7fIhWK/m/3q739EKf4os7NSUxUR7myuPPbwXVpReVtnUKB3i
         1ROLVgMYMgjaMloLqGHKFwc7lL9DPd6kpjn2cqcCge7Ll0ZoUzD9We77VqW33cTmfeAt
         Pl6c3vcfVOEgtPq/wL279RNAA4OZh1yb2294ACWCs9mgklICLbdmLvdKtEBE9+SKsP5+
         4lVWXUVcl/cjMFG2+N/jPUSXeWVkrFbDkeznXq4Q1v1B0TVnptY33dwZNeDY+PIQvBB1
         XkKEjFUIaoLZpnz3zDFEprt2pv2tFbKMyDEoNoYb3w2JyKxm3w+meOy8GnlYz5e87LfR
         j95w==
X-Gm-Message-State: AOAM533B9KBctyylL9ei5cJuYTz6ncheGbkqmdaqnY+H638t9vreSsWj
        nkd1EotKCwCUr70/TfpdWQE=
X-Google-Smtp-Source: ABdhPJw3tJ4+yRDaDe8c44srjX2Pyw7/4ELqqc0tR6rMgxRse+mdX70FULOBuOH5G3XvimxzcYd6cw==
X-Received: by 2002:a63:d80c:: with SMTP id b12mr2541097pgh.331.1634787932148;
        Wed, 20 Oct 2021 20:45:32 -0700 (PDT)
Received: from localhost.localdomain ([140.82.17.67])
        by smtp.gmail.com with ESMTPSA id bp19sm3651077pjb.46.2021.10.20.20.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 20:45:31 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     keescook@chromium.org, rostedt@goodmis.org,
        mathieu.desnoyers@efficios.com, arnaldo.melo@gmail.com,
        pmladek@suse.com, peterz@infradead.org, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, valentin.schneider@arm.com,
        qiang.zhang@windriver.com, robdclark@chromium.org,
        christian@brauner.io, dietmar.eggemann@arm.com, mingo@redhat.com,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, oliver.sang@intel.com, lkp@intel.com,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v5 06/15] elfcore: make prpsinfo always get a nul terminated task comm
Date:   Thu, 21 Oct 2021 03:45:13 +0000
Message-Id: <20211021034516.4400-7-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211021034516.4400-1-laoar.shao@gmail.com>
References: <20211021034516.4400-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kernel test robot reported a -Wstringop-truncation warning after I
extend task comm from 16 to 24. Below is the detailed warning:

   fs/binfmt_elf.c: In function 'fill_psinfo.isra':
>> fs/binfmt_elf.c:1575:9: warning: 'strncpy' output may be truncated copying 16 bytes from a string of length 23 [-Wstringop-truncation]
    1575 |         strncpy(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This patch can fix this warning.

struct elf_prpsinfo is used to dump the task information in userspace
coredump or kernel vmcore. Use TASK_COMM_LEN_16 instead of hard-coded 16
to make it more grepable, and use strscpy_pad() instead of strncpy() to
make it always get a nul terminated task comm.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Petr Mladek <pmladek@suse.com>
---
 fs/binfmt_elf.c                | 2 +-
 include/linux/elfcore-compat.h | 3 ++-
 include/linux/elfcore.h        | 4 ++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index a813b70f594e..a4ba79fce2a9 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1572,7 +1572,7 @@ static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
 	SET_UID(psinfo->pr_uid, from_kuid_munged(cred->user_ns, cred->uid));
 	SET_GID(psinfo->pr_gid, from_kgid_munged(cred->user_ns, cred->gid));
 	rcu_read_unlock();
-	strncpy(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
+	strscpy_pad(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
 
 	return 0;
 }
diff --git a/include/linux/elfcore-compat.h b/include/linux/elfcore-compat.h
index e272c3d452ce..69fa1a728964 100644
--- a/include/linux/elfcore-compat.h
+++ b/include/linux/elfcore-compat.h
@@ -5,6 +5,7 @@
 #include <linux/elf.h>
 #include <linux/elfcore.h>
 #include <linux/compat.h>
+#include <linux/sched.h>
 
 /*
  * Make sure these layouts match the linux/elfcore.h native definitions.
@@ -43,7 +44,7 @@ struct compat_elf_prpsinfo
 	__compat_uid_t			pr_uid;
 	__compat_gid_t			pr_gid;
 	compat_pid_t			pr_pid, pr_ppid, pr_pgrp, pr_sid;
-	char				pr_fname[16];
+	char				pr_fname[TASK_COMM_LEN_16];
 	char				pr_psargs[ELF_PRARGSZ];
 };
 
diff --git a/include/linux/elfcore.h b/include/linux/elfcore.h
index 2aaa15779d50..ee7ac09734ba 100644
--- a/include/linux/elfcore.h
+++ b/include/linux/elfcore.h
@@ -65,8 +65,8 @@ struct elf_prpsinfo
 	__kernel_gid_t	pr_gid;
 	pid_t	pr_pid, pr_ppid, pr_pgrp, pr_sid;
 	/* Lots missing */
-	char	pr_fname[16];	/* filename of executable */
-	char	pr_psargs[ELF_PRARGSZ];	/* initial part of arg list */
+	char	pr_fname[TASK_COMM_LEN_16];	/* filename of executable */
+	char	pr_psargs[ELF_PRARGSZ];		/* initial part of arg list */
 };
 
 static inline void elf_core_copy_regs(elf_gregset_t *elfregs, struct pt_regs *regs)
-- 
2.17.1

