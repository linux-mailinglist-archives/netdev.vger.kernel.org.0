Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C047207A17
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 19:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405444AbgFXRTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 13:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405414AbgFXRTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 13:19:04 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710ECC061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 10:19:04 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d10so1305254pls.5
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 10:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ol9t0bjdsAj0UzWNXZ3UJ+4bKWVFzJMdubkoVZLa8xA=;
        b=EiK+iXWLGGkn4hpVC0KxeD/SKkLR03cRAQ/XwlOw9T1/k3oaxAopAhREqjpJ4kAiR/
         smVPciiVnd9/FD9DAJJ6l9avVnir/JTl1pL+FsBhT3MSN2aCeEFl4W2Zv8OEstazuqmb
         hBOGPZ1dJzHIzTkG92yh4gcrGIFB/P3ys8aEqA0iaMXj38l//uFHWsMF9EhYrDj/gKht
         8c3vt69qRhjeM0uH1A0VEE8Fgniu+qmV0mjRHrEbeCJsTNafJqKu5TatTpWGiAuBLHm6
         r1UKqzqNQ3bGEx2eDiJndF0nj1yiJe5fzjnxN4hjetuMtiJGv/HVnJHXwY4W9U+VX0Kn
         cHaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ol9t0bjdsAj0UzWNXZ3UJ+4bKWVFzJMdubkoVZLa8xA=;
        b=cxvr6Qwz9emMDqysBEIvZXoyyVMM5fu0dd5Be3EBoGRJ+u73ZFNADk8il09L15nSHN
         /H0SqJJBmWArtJnfN2W7Se0P3ty/pmGqxKXKpeu33V1kCiJNbEPlOKcWf/F3e8mOJGJP
         sjweX/DgHvNn/Ue9zp5Ej8QSLh4X+aCFjLwYJ6Bw9CWEUz8aFUESt8qF0QcJKRqCd4+c
         2IH/8OfwX6mGfMRbq37kmS3a2FdCC9EUS72W99xDuucwbJMbmXYwNwi8RRLbYL7GHSxx
         lroe/9xMIXKZpzlPubeQBSp4hkdJnWhLgUGUWhJCdHSf2Cuj6XcwI53roFrcA9d3Ur5U
         eTtw==
X-Gm-Message-State: AOAM533kWdFqxxBAPNTydAXbeEcKd2SGvBp2MWbRzzCbo/6q0ABHmHZc
        bC1IqGT69mWaO0q/EP6/xB4EddzdKsE=
X-Google-Smtp-Source: ABdhPJxUdPE/TcbmEDgp+ec+yReJTK3z9xFkM8syVGkc37ghhdKA6MDwSHb+qj8wkEY7SXzDUb9Krg==
X-Received: by 2002:a17:902:8b82:: with SMTP id ay2mr18039670plb.185.1593019143557;
        Wed, 24 Jun 2020 10:19:03 -0700 (PDT)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id w18sm17490241pgj.31.2020.06.24.10.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 10:19:02 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
To:     netdev@vger.kernel.org
Cc:     Tom Herbert <tom@herbertland.com>
Subject: [RFC PATCH 01/11] cgroup: Export cgroup_{procs,threads}_start and cgroup_procs_next
Date:   Wed, 24 Jun 2020 10:17:40 -0700
Message-Id: <20200624171749.11927-2-tom@herbertland.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200624171749.11927-1-tom@herbertland.com>
References: <20200624171749.11927-1-tom@herbertland.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export the functions and put prototypes in linux/cgroup.h. This allows
creating cgroup entries that provide per task information.
---
 include/linux/cgroup.h | 3 +++
 kernel/cgroup/cgroup.c | 9 ++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 4598e4da6b1b..59837f6f4e54 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -119,6 +119,9 @@ int task_cgroup_path(struct task_struct *task, char *buf, size_t buflen);
 int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry);
 int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 		     struct pid *pid, struct task_struct *tsk);
+void *cgroup_procs_start(struct seq_file *s, loff_t *pos);
+void *cgroup_threads_start(struct seq_file *s, loff_t *pos);
+void *cgroup_procs_next(struct seq_file *s, void *v, loff_t *pos);
 
 void cgroup_fork(struct task_struct *p);
 extern int cgroup_can_fork(struct task_struct *p,
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 1ea181a58465..69cd14201cf0 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4597,7 +4597,7 @@ static void cgroup_procs_release(struct kernfs_open_file *of)
 	}
 }
 
-static void *cgroup_procs_next(struct seq_file *s, void *v, loff_t *pos)
+void *cgroup_procs_next(struct seq_file *s, void *v, loff_t *pos)
 {
 	struct kernfs_open_file *of = s->private;
 	struct css_task_iter *it = of->priv;
@@ -4607,6 +4607,7 @@ static void *cgroup_procs_next(struct seq_file *s, void *v, loff_t *pos)
 
 	return css_task_iter_next(it);
 }
+EXPORT_SYMBOL_GPL(cgroup_procs_next);
 
 static void *__cgroup_procs_start(struct seq_file *s, loff_t *pos,
 				  unsigned int iter_flags)
@@ -4637,7 +4638,7 @@ static void *__cgroup_procs_start(struct seq_file *s, loff_t *pos,
 	return cgroup_procs_next(s, NULL, NULL);
 }
 
-static void *cgroup_procs_start(struct seq_file *s, loff_t *pos)
+void *cgroup_procs_start(struct seq_file *s, loff_t *pos)
 {
 	struct cgroup *cgrp = seq_css(s)->cgroup;
 
@@ -4653,6 +4654,7 @@ static void *cgroup_procs_start(struct seq_file *s, loff_t *pos)
 	return __cgroup_procs_start(s, pos, CSS_TASK_ITER_PROCS |
 					    CSS_TASK_ITER_THREADED);
 }
+EXPORT_SYMBOL_GPL(cgroup_procs_start);
 
 static int cgroup_procs_show(struct seq_file *s, void *v)
 {
@@ -4764,10 +4766,11 @@ static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
 	return ret ?: nbytes;
 }
 
-static void *cgroup_threads_start(struct seq_file *s, loff_t *pos)
+void *cgroup_threads_start(struct seq_file *s, loff_t *pos)
 {
 	return __cgroup_procs_start(s, pos, 0);
 }
+EXPORT_SYMBOL_GPL(cgroup_threads_start);
 
 static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
 				    char *buf, size_t nbytes, loff_t off)
-- 
2.25.1

