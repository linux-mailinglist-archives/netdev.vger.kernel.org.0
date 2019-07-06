Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4280861244
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 18:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfGFQwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 12:52:07 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52674 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbfGFQwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 12:52:07 -0400
Received: by mail-wm1-f68.google.com with SMTP id s3so11913307wms.2
        for <netdev@vger.kernel.org>; Sat, 06 Jul 2019 09:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=FygySr8XbWbcTUQL4Crt79hGB3bXqN6kmV0yD7rjlFI=;
        b=suKaUvvze9rGS+n5HCbJ3SglDJWIauw6KqSYDnkXI7JTCsIokI55Y1b3fO7nr3XpSE
         q1sV/zgQ8djFXu1oDyO5sFjq/lGdIUeY9eNUhdbTONO5edj1Tmff+lZxJNtxQmC13tsI
         1wliQnQS/TiTk3uBCriEQ0q4tdYRkH3I9cpfiDmMNzo2RKdanQ3uooxYIcZPH7IoTuyJ
         zUGUt8OFDYG03kbCQ9HJhuFz/U7tE1fQNPaJRiJFplvqHHrTBXXF2aCjEf0yoeWefrM7
         pEEzeX0Np3DHNxQh4ZhHLgn2a4mvH0nBpICwMzcspSn+/Ie5oIByikeGT3nLj+siTccF
         Ywzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=FygySr8XbWbcTUQL4Crt79hGB3bXqN6kmV0yD7rjlFI=;
        b=AeWlbqvEwrOw2ears1dipEePto3g6A+usJ0002tfbF8yfC4himAAyGuZ1JZpnN5pE3
         cjfMvSkhkl7n1xFAvYDLHZ5hRGoyDJ0JQLTIp+l5diVKUtaNOOn2Aeqivdi6hW5ikr7Z
         VdOyN8i58bmus4CFCRCjk11dvSz3zS2I50No3tvsaeACu0hzN51vAXF3AC5Q+PXactQb
         iCpQSWq5HLftHCowmalCQ/udtw3jc08zKhL3jr4qRqc38SyQjVgmDWIdSo4DrvoSKU7W
         YsHBamA2exOjW2w6yjQHkMluVHAAGrikW2A/gcCIPAYAMnT1b17OpXKjPBmb9YX568YY
         MSxg==
X-Gm-Message-State: APjAAAWzCbIN+2L3AKrbifm9XXtGb9nEberKPln2UWV/BXNEUew/5Aej
        JHIkeF2EgorJSk0ChChT5UpiHG8=
X-Google-Smtp-Source: APXvYqxUfbdCMXAZDvyTLQwmfBGbQuuhuUTVNRpUsO9Kg2/1P+MJjtmp5/Y2DqFQ74jz1SFqwJk6dg==
X-Received: by 2002:a1c:b189:: with SMTP id a131mr8842622wmf.7.1562431924325;
        Sat, 06 Jul 2019 09:52:04 -0700 (PDT)
Received: from avx2 ([46.53.252.147])
        by smtp.gmail.com with ESMTPSA id g11sm9537291wru.24.2019.07.06.09.52.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 06 Jul 2019 09:52:03 -0700 (PDT)
Date:   Sat, 6 Jul 2019 19:52:02 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Per.Hallsmark@windriver.com
Subject: [PATCH 1/2] proc: revalidate directories created with
 proc_net_mkdir()
Message-ID: <20190706165201.GA10550@avx2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

/proc/net directories may contain content which depends on net namespace.
Such dentries should be revalidated after setns(CLONE_NEWNET).

See
	commit 1fde6f21d90f8ba5da3cb9c54ca991ed72696c43
	proc: fix /proc/net/* after setns(2)

The patch is all about "pde_force_lookup()" line.

	[redid original patch --adobriyan]

Reported-by: "Hallsmark, Per" <Per.Hallsmark@windriver.com>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/generic.c       |   25 ++++++++++++++++++-------
 fs/proc/internal.h      |    3 +++
 fs/proc/proc_net.c      |   17 +++++++++++++++++
 include/linux/proc_fs.h |   16 ++++++++--------
 4 files changed, 46 insertions(+), 15 deletions(-)

--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -459,26 +459,37 @@ struct proc_dir_entry *proc_symlink(const char *name,
 }
 EXPORT_SYMBOL(proc_symlink);
 
-struct proc_dir_entry *proc_mkdir_data(const char *name, umode_t mode,
-		struct proc_dir_entry *parent, void *data)
+struct proc_dir_entry *_proc_mkdir(const char *name, umode_t mode,
+				   struct proc_dir_entry **parent, void *data)
 {
 	struct proc_dir_entry *ent;
 
 	if (mode == 0)
 		mode = S_IRUGO | S_IXUGO;
 
-	ent = __proc_create(&parent, name, S_IFDIR | mode, 2);
+	ent = __proc_create(parent, name, S_IFDIR | mode, 2);
 	if (ent) {
 		ent->data = data;
 		ent->proc_fops = &proc_dir_operations;
 		ent->proc_iops = &proc_dir_inode_operations;
-		parent->nlink++;
-		ent = proc_register(parent, ent);
-		if (!ent)
-			parent->nlink--;
 	}
 	return ent;
 }
+
+struct proc_dir_entry *proc_mkdir_data(const char *name, umode_t mode,
+		struct proc_dir_entry *parent, void *data)
+{
+	struct proc_dir_entry *pde;
+
+	pde = _proc_mkdir(name, mode, &parent, data);
+	if (!pde)
+		return NULL;
+	parent->nlink++;
+	pde = proc_register(parent, pde);
+	if (!pde)
+		parent->nlink--;
+	return pde;
+}
 EXPORT_SYMBOL_GPL(proc_mkdir_data);
 
 struct proc_dir_entry *proc_mkdir_mode(const char *name, umode_t mode,
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -299,3 +299,6 @@ extern unsigned long task_statm(struct mm_struct *,
 				unsigned long *, unsigned long *,
 				unsigned long *, unsigned long *);
 extern void task_mem(struct seq_file *, struct mm_struct *);
+
+struct proc_dir_entry *_proc_mkdir(const char *name, umode_t mode,
+				   struct proc_dir_entry **parent, void *data);
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -251,6 +251,23 @@ struct proc_dir_entry *proc_create_net_single_write(const char *name, umode_t mo
 }
 EXPORT_SYMBOL_GPL(proc_create_net_single_write);
 
+struct proc_dir_entry *proc_net_mkdir(struct net *net, const char *name,
+				      struct proc_dir_entry *parent)
+{
+	struct proc_dir_entry *pde;
+
+	pde = _proc_mkdir(name, 0, &parent, net);
+	if (!pde)
+		return NULL;
+	pde_force_lookup(pde);
+	parent->nlink++;
+	pde = proc_register(parent, pde);
+	if (!pde)
+		parent->nlink++;
+	return pde;
+}
+EXPORT_SYMBOL_GPL(proc_net_mkdir);
+
 static struct net *get_proc_task_net(struct inode *dir)
 {
 	struct task_struct *task;
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -8,6 +8,7 @@
 #include <linux/types.h>
 #include <linux/fs.h>
 
+struct net;
 struct proc_dir_entry;
 struct seq_file;
 struct seq_operations;
@@ -73,6 +74,8 @@ struct proc_dir_entry *proc_create_net_single_write(const char *name, umode_t mo
 						    int (*show)(struct seq_file *, void *),
 						    proc_write_t write,
 						    void *data);
+struct proc_dir_entry *proc_net_mkdir(struct net *net, const char *name, struct proc_dir_entry *parent);
+
 extern struct pid *tgid_pidfd_to_pid(const struct file *file);
 
 #else /* CONFIG_PROC_FS */
@@ -115,6 +118,11 @@ static inline int remove_proc_subtree(const char *name, struct proc_dir_entry *p
 #define proc_create_net(name, mode, parent, state_size, ops) ({NULL;})
 #define proc_create_net_single(name, mode, parent, show, data) ({NULL;})
 
+static inline struct proc_dir_entry *proc_net_mkdir(struct net *net, const char *name, struct proc_dir_entry *parent)
+{
+	return NULL;
+}
+
 static inline struct pid *tgid_pidfd_to_pid(const struct file *file)
 {
 	return ERR_PTR(-EBADF);
@@ -122,14 +130,6 @@ static inline struct pid *tgid_pidfd_to_pid(const struct file *file)
 
 #endif /* CONFIG_PROC_FS */
 
-struct net;
-
-static inline struct proc_dir_entry *proc_net_mkdir(
-	struct net *net, const char *name, struct proc_dir_entry *parent)
-{
-	return proc_mkdir_data(name, 0, parent, net);
-}
-
 struct ns_common;
 int open_related_ns(struct ns_common *ns,
 		   struct ns_common *(*get_ns)(struct ns_common *ns));
