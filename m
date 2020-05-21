Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F701DCD16
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 14:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729351AbgEUMi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 08:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729204AbgEUMi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 08:38:58 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B5BC05BD43
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 05:38:58 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id e11so2292888pfn.3
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 05:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qrPX9G3+4aBI10o4oEHyWzWzharRDL5aHtWT6C1hV1M=;
        b=eyKMrOdNlKxE4hK1V2DTniBs10Fv951OeqXz10XdX18R8Rfd3190Or/83oF/SH95bY
         uvnoW91oDo+l1trvF6bBOB35j8/L8HZZmvjmG1NlbB7/RfHjC6Qww+CTnf65DOzg3gBM
         HvL2UmtJKcRKuvQQcowlTcflRqqMNLvyknjmz06+5/TuFOyzPVS+J2J4s/NUfI7GyClY
         2tuimsIj3m0Gka/Vcc7ZhL+KpuB/95rD27Z9FDuCuP0i01ZBVcDWacPM1vImhji8nu+B
         21Ydvn693kQ1m8d0AN4yRG+H/hJ1YTf7jl1qRgSnMAdAn/XNUWoU3hjjPFQjz00HF60A
         S11w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qrPX9G3+4aBI10o4oEHyWzWzharRDL5aHtWT6C1hV1M=;
        b=Zaxgrggqylje+2ZCTnY7HfC9mUDvU1r069dkwA0WENxBicJL6scMKPs8et4jmNL+0k
         BfWAnFKwyAOoBnT4idJw0qDsn+4cF14qYjA+vdYhvgXORPwhi4y5woU0RiYBGQoJ/x1b
         sZyw3+pKeFd+iSXRLOJfxn7uGQEKVMumh4AJNyDnGrzghsQoJUgt7/GOSrXp5Rgac1d5
         lFz4nOUkGO2wuAwbdBANuJ37NVR3uCk3SFsX0J0lW2eiafLdn+hqk/aEbr58wtPfOgXx
         ue+a58nWJ3jD98/o8oSI72xfsIB1IMtakclclPsEuRi+6XeJIzLq0sQmSEHBTAFJVyIj
         asXw==
X-Gm-Message-State: AOAM530BSSVh0fY3BSoCGKUmMVNik9tYCGsgq286cwzHd4mCNPau56Ia
        0ZQeAu8PjHfNm7uCNN2+P9fs6w==
X-Google-Smtp-Source: ABdhPJy9gosZTjDkb+FQ3lX5TtFuOdxNa9fPv/j1JyHKILIqEs4RR3/DsnPRh7l5AqHBoL4DlK9LOQ==
X-Received: by 2002:a62:8241:: with SMTP id w62mr9613358pfd.187.1590064737961;
        Thu, 21 May 2020 05:38:57 -0700 (PDT)
Received: from Smcdef-MBP.lan ([103.136.220.73])
        by smtp.gmail.com with ESMTPSA id w14sm4152316pgi.12.2020.05.21.05.38.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 May 2020 05:38:57 -0700 (PDT)
From:   Muchun Song <songmuchun@bytedance.com>
To:     adobriyan@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org
Cc:     ebiederm@xmission.com, bernd.edlinger@hotmail.de,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH] files: Use rcu lock to get the file structures for better performance
Date:   Thu, 21 May 2020 20:38:35 +0800
Message-Id: <20200521123835.70069-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is another safe way to get the file structure without
holding the files->file_lock. That is rcu lock, and this way
has better performance. So use the rcu lock instead of the
files->file_lock.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 fs/proc/fd.c         | 31 ++++++++++++++++++++++++-------
 kernel/bpf/syscall.c | 17 +++++++++++------
 kernel/kcmp.c        | 15 ++++++++++-----
 3 files changed, 45 insertions(+), 18 deletions(-)

diff --git a/fs/proc/fd.c b/fs/proc/fd.c
index 81882a13212d3..5d5b0f091d32a 100644
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -34,19 +34,27 @@ static int seq_show(struct seq_file *m, void *v)
 	if (files) {
 		unsigned int fd = proc_fd(m->private);
 
-		spin_lock(&files->file_lock);
+		rcu_read_lock();
+again:
 		file = fcheck_files(files, fd);
 		if (file) {
-			struct fdtable *fdt = files_fdtable(files);
+			struct fdtable *fdt;
+
+			if (!get_file_rcu(file)) {
+				/*
+				 * we loop to catch the new file (or NULL
+				 * pointer).
+				 */
+				goto again;
+			}
 
+			fdt = files_fdtable(files);
 			f_flags = file->f_flags;
 			if (close_on_exec(fd, fdt))
 				f_flags |= O_CLOEXEC;
-
-			get_file(file);
 			ret = 0;
 		}
-		spin_unlock(&files->file_lock);
+		rcu_read_unlock();
 		put_files_struct(files);
 	}
 
@@ -160,14 +168,23 @@ static int proc_fd_link(struct dentry *dentry, struct path *path)
 		unsigned int fd = proc_fd(d_inode(dentry));
 		struct file *fd_file;
 
-		spin_lock(&files->file_lock);
+		rcu_read_lock();
+again:
 		fd_file = fcheck_files(files, fd);
 		if (fd_file) {
+			if (!get_file_rcu(fd_file)) {
+				/*
+				 * we loop to catch the new file
+				 * (or NULL pointer).
+				 */
+				goto again;
+			}
 			*path = fd_file->f_path;
 			path_get(&fd_file->f_path);
+			fput(fd_file);
 			ret = 0;
 		}
-		spin_unlock(&files->file_lock);
+		rcu_read_unlock();
 		put_files_struct(files);
 	}
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 8608d6e1b0e0e..441c91378a1fc 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3451,14 +3451,19 @@ static int bpf_task_fd_query(const union bpf_attr *attr,
 	if (!files)
 		return -ENOENT;
 
-	err = 0;
-	spin_lock(&files->file_lock);
+	rcu_read_lock();
+again:
 	file = fcheck_files(files, fd);
-	if (!file)
+	if (file) {
+		if (!get_file_rcu(file)) {
+			/* we loop to catch the new file (or NULL pointer) */
+			goto again;
+		}
+		err = 0;
+	} else {
 		err = -EBADF;
-	else
-		get_file(file);
-	spin_unlock(&files->file_lock);
+	}
+	rcu_read_unlock();
 	put_files_struct(files);
 
 	if (err)
diff --git a/kernel/kcmp.c b/kernel/kcmp.c
index b3ff9288c6cc9..3b4f2a54186f2 100644
--- a/kernel/kcmp.c
+++ b/kernel/kcmp.c
@@ -120,13 +120,18 @@ static int kcmp_epoll_target(struct task_struct *task1,
 	if (!files)
 		return -EBADF;
 
-	spin_lock(&files->file_lock);
+	rcu_read_lock();
+again:
 	filp_epoll = fcheck_files(files, slot.efd);
-	if (filp_epoll)
-		get_file(filp_epoll);
-	else
+	if (filp_epoll) {
+		if (!get_file_rcu(filp_epoll)) {
+			/* we loop to catch the new file (or NULL pointer) */
+			goto again;
+		}
+	} else {
 		filp_tgt = ERR_PTR(-EBADF);
-	spin_unlock(&files->file_lock);
+	}
+	rcu_read_unlock();
 	put_files_struct(files);
 
 	if (filp_epoll) {
-- 
2.11.0

