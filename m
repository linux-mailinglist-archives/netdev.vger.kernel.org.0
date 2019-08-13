Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E75EF8B802
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 14:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbfHMMHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 08:07:33 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:32918 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbfHMMHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 08:07:32 -0400
Received: by mail-pl1-f194.google.com with SMTP id c14so49113676plo.0;
        Tue, 13 Aug 2019 05:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T6JTpw6JbtT5ka0riUx2a+o3iLlogyZ6wLRPGdIrAk8=;
        b=JEp9uKPG68bZPEquhG4r+x/3OK01A25GSXMkTp+MVGy0eb7UaoIRVFA8+fWQuXIKt/
         Su44/c4yEq61PnJpU1dYOSFkmPRfDzqeT/DPpnq2rOSSGm7c5lZkHI3D89KfvmoODOIS
         Hv62rQ7xQ2rH9kMTYMNdFOBqBECC2g7IvkdvQMWUYaL0Xd9ZEjvu1cICQduJ9C9EfJ4Y
         qu2nXy+R29sWEAu1zuI4IhlwOjzEs2eqXkXq6sBKQ4K2EbQBFnUFQAU3xrJvmQTPhbx5
         X6QNX3eN/K1k30ejXvIhJ5nzxpvCXc9yU2ljnn6gjXBSUCUJESu42GGVDa8yz0CngPm3
         0xWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T6JTpw6JbtT5ka0riUx2a+o3iLlogyZ6wLRPGdIrAk8=;
        b=jkzuUxv6e34e2vrC+u9HT8OFZyAcFHXBtyD55m/e2awfRDoMpzIeILNXaosNPYV573
         IxiPtkE4wvTe0hd1OrcvHNkrGXNikQKX8eJttdPi9UBpN+KHQubeBZ3hgUNL7xLQKxU8
         SVrwIUk9hDAG+fvZ2mNlkSYGdaYcHiRJDyEbslXAhK5IDBitOW9fz4qQ06E+wfL21BLT
         YX3duj7+OZrxwJ+JGm/d4RztJePDzjlC0zT1TekzEuPz4uAsQg7vSc8l9UvP2fmUrWqQ
         42ViMXeqFZqINBDxmi+Dt96f0qwMHdhwraYAZ68++W/2lMbM2IIZaOJLxc4Ni2uz+djb
         yw+g==
X-Gm-Message-State: APjAAAVrk6VhqSLhVsCEiQXD/4qwkSx7RZjc7yC+6E3ma3R9XWpLDCP6
        5fGAz2VoXbmy54CBsmWxcI0=
X-Google-Smtp-Source: APXvYqw0sY2ao0zJXVVZCu0PvRC++TfOyREYh4hDK1JrW8CNOVgTsorT194iqd4VbVGDjKRwmB5ndA==
X-Received: by 2002:a17:902:a70c:: with SMTP id w12mr10106522plq.288.1565698051603;
        Tue, 13 Aug 2019 05:07:31 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id o9sm73251099pgv.19.2019.08.13.05.07.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 05:07:31 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>
Subject: [RFC PATCH bpf-next 03/14] bpf: Add API to get program from id
Date:   Tue, 13 Aug 2019 21:05:47 +0900
Message-Id: <20190813120558.6151-4-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
References: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Factor out the logic in bpf_prog_get_fd_by_id() and add
bpf_prog_get_by_id(). Also export bpf_prog_get_ok().
They are used by the next commit to get bpf prog from its id.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 include/linux/bpf.h  |  6 ++++++
 kernel/bpf/syscall.c | 26 ++++++++++++++++++--------
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f9a5061..d8ad865 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -633,6 +633,7 @@ int bpf_prog_array_copy(struct bpf_prog_array *old_array,
 struct bpf_prog *bpf_prog_get(u32 ufd);
 struct bpf_prog *bpf_prog_get_type_dev(u32 ufd, enum bpf_prog_type type,
 				       bool attach_drv);
+struct bpf_prog *bpf_prog_get_by_id(u32 id);
 struct bpf_prog * __must_check bpf_prog_add(struct bpf_prog *prog, int i);
 void bpf_prog_sub(struct bpf_prog *prog, int i);
 struct bpf_prog * __must_check bpf_prog_inc(struct bpf_prog *prog);
@@ -755,6 +756,11 @@ static inline struct bpf_prog *bpf_prog_get_type_dev(u32 ufd,
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
+static inline struct bpf_prog *bpf_prog_get_by_id(u32 id)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
 static inline struct bpf_prog * __must_check bpf_prog_add(struct bpf_prog *prog,
 							  int i)
 {
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 5d141f1..cb5ecc4 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1495,6 +1495,7 @@ bool bpf_prog_get_ok(struct bpf_prog *prog,
 
 	return true;
 }
+EXPORT_SYMBOL_GPL(bpf_prog_get_ok);
 
 static struct bpf_prog *__bpf_prog_get(u32 ufd, enum bpf_prog_type *attach_type,
 				       bool attach_drv)
@@ -2122,6 +2123,22 @@ static int bpf_obj_get_next_id(const union bpf_attr *attr,
 	return err;
 }
 
+struct bpf_prog *bpf_prog_get_by_id(u32 id)
+{
+	struct bpf_prog *prog;
+
+	spin_lock_bh(&prog_idr_lock);
+	prog = idr_find(&prog_idr, id);
+	if (prog)
+		prog = bpf_prog_inc_not_zero(prog);
+	else
+		prog = ERR_PTR(-ENOENT);
+	spin_unlock_bh(&prog_idr_lock);
+
+	return prog;
+}
+EXPORT_SYMBOL_GPL(bpf_prog_get_by_id);
+
 #define BPF_PROG_GET_FD_BY_ID_LAST_FIELD prog_id
 
 static int bpf_prog_get_fd_by_id(const union bpf_attr *attr)
@@ -2136,14 +2153,7 @@ static int bpf_prog_get_fd_by_id(const union bpf_attr *attr)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	spin_lock_bh(&prog_idr_lock);
-	prog = idr_find(&prog_idr, id);
-	if (prog)
-		prog = bpf_prog_inc_not_zero(prog);
-	else
-		prog = ERR_PTR(-ENOENT);
-	spin_unlock_bh(&prog_idr_lock);
-
+	prog = bpf_prog_get_by_id(id);
 	if (IS_ERR(prog))
 		return PTR_ERR(prog);
 
-- 
1.8.3.1

