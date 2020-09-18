Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF4526FCD4
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 14:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgIRMpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 08:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgIRMpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 08:45:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341F5C06174A;
        Fri, 18 Sep 2020 05:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=9yRRDQwct1JF6ZjH1ZNHGCkZ32QJgvqPcvKB0dar+RA=; b=s9ZOEgeausCRzTAIKECqvkUxtU
        mBy6UNf6RRm6AlyFjmIkQ3cVDdDYzfwSdhLijuDrQUI+A78+ZqGwh62ALTJTxP+Hb8b83fxY6Qyi6
        isvS5QdYE1J4kBdCQWs+MMQ4aSFmky4TbtL3CMmkNu1/mGKdA0TuWf6yx7Uk0Ps1g7r1gKN2xuwhK
        HRHNr25lHpABcK0AvSVrpaODyp1+JRO4exW0ZmPuLFmNoS3AjrOgbDe3M4ZooZEY0dg3iws/po7YP
        mnoC1b0zsP8OSDeJX3yk3JwikUwzt2CQzpFw1N1+BKD+glSDIGYYTqxd9FdthshAjsDRO8EDuc8gB
        68Zuo9Zg==;
Received: from [80.122.85.238] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJFlh-0008Sq-JK; Fri, 18 Sep 2020 12:45:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
Date:   Fri, 18 Sep 2020 14:45:25 +0200
Message-Id: <20200918124533.3487701-2-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200918124533.3487701-1-hch@lst.de>
References: <20200918124533.3487701-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a flag to force processing a syscall as a compat syscall.  This is
required so that in_compat_syscall() works for I/O submitted by io_uring
helper threads on behalf of compat syscalls.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/sparc/include/asm/compat.h | 3 ++-
 arch/x86/include/asm/compat.h   | 2 +-
 fs/io_uring.c                   | 9 +++++++++
 include/linux/compat.h          | 5 ++++-
 include/linux/sched.h           | 1 +
 5 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/include/asm/compat.h b/arch/sparc/include/asm/compat.h
index 40a267b3bd5208..fee6c51d36e869 100644
--- a/arch/sparc/include/asm/compat.h
+++ b/arch/sparc/include/asm/compat.h
@@ -211,7 +211,8 @@ static inline int is_compat_task(void)
 static inline bool in_compat_syscall(void)
 {
 	/* Vector 0x110 is LINUX_32BIT_SYSCALL_TRAP */
-	return pt_regs_trap_type(current_pt_regs()) == 0x110;
+	return pt_regs_trap_type(current_pt_regs()) == 0x110 ||
+		(current->flags & PF_FORCE_COMPAT);
 }
 #define in_compat_syscall in_compat_syscall
 #endif
diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
index d4edf281fff49d..fbab072d4e5b31 100644
--- a/arch/x86/include/asm/compat.h
+++ b/arch/x86/include/asm/compat.h
@@ -208,7 +208,7 @@ static inline bool in_32bit_syscall(void)
 #ifdef CONFIG_COMPAT
 static inline bool in_compat_syscall(void)
 {
-	return in_32bit_syscall();
+	return in_32bit_syscall() || (current->flags & PF_FORCE_COMPAT);
 }
 #define in_compat_syscall in_compat_syscall	/* override the generic impl */
 #endif
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3790c7fe9fee22..5755d557c3f7bc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5449,6 +5449,9 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	if (unlikely(ret))
 		return ret;
 
+	if (req->ctx->compat)
+		current->flags |= PF_FORCE_COMPAT;
+
 	switch (req->opcode) {
 	case IORING_OP_NOP:
 		break;
@@ -5546,6 +5549,7 @@ static int io_req_defer_prep(struct io_kiocb *req,
 		break;
 	}
 
+	current->flags &= ~PF_FORCE_COMPAT;
 	return ret;
 }
 
@@ -5669,6 +5673,9 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
+	if (ctx->compat)
+		current->flags |= PF_FORCE_COMPAT;
+
 	switch (req->opcode) {
 	case IORING_OP_NOP:
 		ret = io_nop(req, cs);
@@ -5898,6 +5905,8 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		break;
 	}
 
+	current->flags &= ~PF_FORCE_COMPAT;
+
 	if (ret)
 		return ret;
 
diff --git a/include/linux/compat.h b/include/linux/compat.h
index b354ce58966e2d..685066f7ad325f 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -891,7 +891,10 @@ asmlinkage long compat_sys_socketcall(int call, u32 __user *args);
  */
 
 #ifndef in_compat_syscall
-static inline bool in_compat_syscall(void) { return is_compat_task(); }
+static inline bool in_compat_syscall(void)
+{
+	return is_compat_task() || (current->flags & PF_FORCE_COMPAT);
+}
 #endif
 
 /**
diff --git a/include/linux/sched.h b/include/linux/sched.h
index afe01e232935fa..c8b183b5655a1e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1491,6 +1491,7 @@ extern struct pid *cad_pid;
  */
 #define PF_IDLE			0x00000002	/* I am an IDLE thread */
 #define PF_EXITING		0x00000004	/* Getting shut down */
+#define PF_FORCE_COMPAT		0x00000008	/* acting as compat task */
 #define PF_VCPU			0x00000010	/* I'm a virtual CPU */
 #define PF_WQ_WORKER		0x00000020	/* I'm a workqueue worker */
 #define PF_FORKNOEXEC		0x00000040	/* Forked but didn't exec */
-- 
2.28.0

