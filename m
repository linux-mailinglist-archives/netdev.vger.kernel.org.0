Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B28457D4E
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 12:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237477AbhKTLbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 06:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237404AbhKTLbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Nov 2021 06:31:08 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38420C06173E;
        Sat, 20 Nov 2021 03:28:05 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id n8so10137649plf.4;
        Sat, 20 Nov 2021 03:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Lt7iv6uOXlDKXawjf9ET+/GYW6XX3mUcHJCliRc171M=;
        b=kLCK+zjYkFrsRjI3TaLGvzv3dnaA97yKMIg42nSBAyE1CrZ1nNquqZklW0bBKpTZq7
         pNmcot6EjZ9TWOZAABMubJPR5Kyan1K7kPxVdoomExOt05GYyGlv7AFj4Fr55pVPzg+o
         +XV8stHIt7WeJLXpo2UTuUMPz9ODHe6+c6eW5reRPjwArvPFK2a80PqrcNaeOD67hog4
         NnqvdZZ/XZQpUoCXrgoZP4o2TVm+LoC3v/isOJg7qXtWFBbY6sFwjA9wPRRkXB/dcBFr
         +c0dso/sFQeMrtKScg4mVtk1QmQlKD1r3mxPSbfYJUngA0ElfoaTlYERHu6+ygIQpnyk
         kWmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lt7iv6uOXlDKXawjf9ET+/GYW6XX3mUcHJCliRc171M=;
        b=jE32akL7HTvIiDsYdgZ7Ar0TkuuOWs/Q36BV0Y3c3r9MzPUZ2XQsafkERF2zUrV47u
         Irfi2cpfM80R65dlFY/n3NgOGb2gaSwobsyuAOckXqhR0YWA/TVPpyn9hEyTCN4r2+cP
         xCDoxRua+I8pqM/6I0EA/URyAQDAzKALAfVhP4VEvNDGZF+5gB3PEo3aV/1MN5Ym16oo
         zfoHW6AGQbtSSLUXwBTB3dbS7xKviuySEKf4G6i54awGDHkwk/dKvR6vrMXXi/0AX3L1
         dky0ZfQLtCp5d603jR+ox4Rh4IKZmu6/4tF8Qjio4QwvThO/X55rU5IJcHldYSHHGM7n
         49RA==
X-Gm-Message-State: AOAM531PFYOEPts2U/eacKXSd0MgYmQChEjZdE1XazyeIGifJaRt2a3d
        s3dd8FDSfIjeLUH+3lAhtg8=
X-Google-Smtp-Source: ABdhPJz9GZRYzuPNdb4pW+nAfRhUojoMVAgV/BEbkEffPAsNBPEqLyyAkiUpEHZPYz68GAmQ/wSOOg==
X-Received: by 2002:a17:90b:3b8c:: with SMTP id pc12mr9369718pjb.9.1637407684839;
        Sat, 20 Nov 2021 03:28:04 -0800 (PST)
Received: from vultr.guest ([66.42.104.82])
        by smtp.gmail.com with ESMTPSA id q17sm2835490pfu.117.2021.11.20.03.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Nov 2021 03:28:04 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        oliver.sang@intel.com, lkp@intel.com,
        Yafang Shao <laoar.shao@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        David Hildenbrand <david@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 4/7] fs/binfmt_elf: replace open-coded string copy with get_task_comm
Date:   Sat, 20 Nov 2021 11:27:35 +0000
Message-Id: <20211120112738.45980-5-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211120112738.45980-1-laoar.shao@gmail.com>
References: <20211120112738.45980-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is better to use get_task_comm() instead of the open coded string
copy as we do in other places.

struct elf_prpsinfo is used to dump the task information in userspace
coredump or kernel vmcore. Below is the verification of vmcore,

crash> ps
   PID    PPID  CPU       TASK        ST  %MEM     VSZ    RSS  COMM
      0      0   0  ffffffff9d21a940  RU   0.0       0      0  [swapper/0]
>     0      0   1  ffffa09e40f85e80  RU   0.0       0      0  [swapper/1]
>     0      0   2  ffffa09e40f81f80  RU   0.0       0      0  [swapper/2]
>     0      0   3  ffffa09e40f83f00  RU   0.0       0      0  [swapper/3]
>     0      0   4  ffffa09e40f80000  RU   0.0       0      0  [swapper/4]
>     0      0   5  ffffa09e40f89f80  RU   0.0       0      0  [swapper/5]
      0      0   6  ffffa09e40f8bf00  RU   0.0       0      0  [swapper/6]
>     0      0   7  ffffa09e40f88000  RU   0.0       0      0  [swapper/7]
>     0      0   8  ffffa09e40f8de80  RU   0.0       0      0  [swapper/8]
>     0      0   9  ffffa09e40f95e80  RU   0.0       0      0  [swapper/9]
>     0      0  10  ffffa09e40f91f80  RU   0.0       0      0  [swapper/10]
>     0      0  11  ffffa09e40f93f00  RU   0.0       0      0  [swapper/11]
>     0      0  12  ffffa09e40f90000  RU   0.0       0      0  [swapper/12]
>     0      0  13  ffffa09e40f9bf00  RU   0.0       0      0  [swapper/13]
>     0      0  14  ffffa09e40f98000  RU   0.0       0      0  [swapper/14]
>     0      0  15  ffffa09e40f9de80  RU   0.0       0      0  [swapper/15]

It works well as expected.

Some comments are added to explain why we use the hard-coded 16.

Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Petr Mladek <pmladek@suse.com>
---
 fs/binfmt_elf.c                | 2 +-
 include/linux/elfcore-compat.h | 5 +++++
 include/linux/elfcore.h        | 5 +++++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index f8c7f26f1fbb..b9a33cc34d6b 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1585,7 +1585,7 @@ static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
 	SET_UID(psinfo->pr_uid, from_kuid_munged(cred->user_ns, cred->uid));
 	SET_GID(psinfo->pr_gid, from_kgid_munged(cred->user_ns, cred->gid));
 	rcu_read_unlock();
-	strncpy(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
+	get_task_comm(psinfo->pr_fname, p);
 
 	return 0;
 }
diff --git a/include/linux/elfcore-compat.h b/include/linux/elfcore-compat.h
index e272c3d452ce..54feb64e9b5d 100644
--- a/include/linux/elfcore-compat.h
+++ b/include/linux/elfcore-compat.h
@@ -43,6 +43,11 @@ struct compat_elf_prpsinfo
 	__compat_uid_t			pr_uid;
 	__compat_gid_t			pr_gid;
 	compat_pid_t			pr_pid, pr_ppid, pr_pgrp, pr_sid;
+	/*
+	 * The hard-coded 16 is derived from TASK_COMM_LEN, but it can't be
+	 * changed as it is exposed to userspace. We'd better make it hard-coded
+	 * here.
+	 */
 	char				pr_fname[16];
 	char				pr_psargs[ELF_PRARGSZ];
 };
diff --git a/include/linux/elfcore.h b/include/linux/elfcore.h
index 957ebec35aad..746e081879a5 100644
--- a/include/linux/elfcore.h
+++ b/include/linux/elfcore.h
@@ -65,6 +65,11 @@ struct elf_prpsinfo
 	__kernel_gid_t	pr_gid;
 	pid_t	pr_pid, pr_ppid, pr_pgrp, pr_sid;
 	/* Lots missing */
+	/*
+	 * The hard-coded 16 is derived from TASK_COMM_LEN, but it can't be
+	 * changed as it is exposed to userspace. We'd better make it hard-coded
+	 * here.
+	 */
 	char	pr_fname[16];	/* filename of executable */
 	char	pr_psargs[ELF_PRARGSZ];	/* initial part of arg list */
 };
-- 
2.17.1

