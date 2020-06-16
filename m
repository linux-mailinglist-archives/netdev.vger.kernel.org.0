Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 668761FA6DF
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 05:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbgFPD0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 23:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726928AbgFPDZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 23:25:38 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0A3C0A88B4
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 20:25:36 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id m2so893260pjv.2
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 20:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rE3Y2iFwUUd87kC4LPkJ/n5Ro7lODcTLpnlUXVeVqP4=;
        b=V3XA0nHMmtCHiAAjYJ+ZyCD0LYHJYFVci/dawxxSgdePAiA4xV8RysbhxpPr+L3zVP
         34KqKhpQ2oyvvwl6p1Hw7IgxnST9JWeyZLSe5rxdOOI4bbcYAgkCRIRj4tk0JM60C9JZ
         M+G42YS35Vm30gy42rDJy0fo0E5XO0KuRrgn0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rE3Y2iFwUUd87kC4LPkJ/n5Ro7lODcTLpnlUXVeVqP4=;
        b=Tr+GtQZveZXWi1w9ae/8JdNYUloA3USmKGYrj5Kz50z/fRf4EJvQF+7oF48NFN5WYH
         IV0kWhztnbhB6HRFyC7XyCjWvtCCDIiXIl/Vtlzczdg1O63A9tZbYqAfuwJQDBd3FTHD
         PPvR3sQzYTLkmVklyWhXIvWN8NFh7KvpOWa0/r7yNG5ouhrooSCZV4CTBLunigfJo7XP
         j9di+1QXmWKtNeLzfNT7YPTY5vXc3X8MxUlDo4ZAsd+lW2aULkWxG83ALivKdi1lJnNY
         oKC6gNOhTIKKu+zVoqJgpuqDghIaEJNevMEGu9wo6MQB3GhFH1sW0XW7AZhA2W1tFQyc
         J26g==
X-Gm-Message-State: AOAM531mlA6Qvr8SxA1VM4DcKpVaUEdi9eYfvSxkgktnYrz9UKeMIQQE
        4Cqh6Qx1xhGcRZ+RIlOzoIgKpJGf/+kNBA==
X-Google-Smtp-Source: ABdhPJxCZqVuV3kzeXed/HFT/JXAbaWaHZ3nnHfrJBQ1uX2cvtIopqK121014OWTVMCuzhtnGpPz3A==
X-Received: by 2002:a17:90b:234c:: with SMTP id ms12mr836787pjb.164.1592277935719;
        Mon, 15 Jun 2020 20:25:35 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id ds11sm785227pjb.0.2020.06.15.20.25.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 20:25:32 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Sargun Dhillon <sargun@sargun.me>,
        Christian Brauner <christian@brauner.io>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>,
        Tycho Andersen <tycho@tycho.ws>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Matt Denton <mpdenton@google.com>,
        Jann Horn <jannh@google.com>, Chris Palmer <palmer@google.com>,
        Robert Sesek <rsesek@google.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH v4 09/11] selftests/seccomp: Rename user_trap_syscall() to user_notif_syscall()
Date:   Mon, 15 Jun 2020 20:25:22 -0700
Message-Id: <20200616032524.460144-10-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200616032524.460144-1-keescook@chromium.org>
References: <20200616032524.460144-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The user_trap_syscall() helper creates a filter with
SECCOMP_RET_USER_NOTIF. To avoid confusion with SECCOMP_RET_TRAP, rename
the helper to user_notif_syscall().

Additionally fix a redundant "return" after XFAIL.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 60 +++++++++----------
 1 file changed, 29 insertions(+), 31 deletions(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 40ed846744e4..95b134933831 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -3110,10 +3110,8 @@ TEST(get_metadata)
 	long ret;
 
 	/* Only real root can get metadata. */
-	if (geteuid()) {
-		XFAIL(return, "get_metadata requires real root");
-		return;
-	}
+	if (geteuid())
+		XFAIL(return, "get_metadata test requires real root");
 
 	ASSERT_EQ(0, pipe(pipefd));
 
@@ -3170,7 +3168,7 @@ TEST(get_metadata)
 	ASSERT_EQ(0, kill(pid, SIGKILL));
 }
 
-static int user_trap_syscall(int nr, unsigned int flags)
+static int user_notif_syscall(int nr, unsigned int flags)
 {
 	struct sock_filter filter[] = {
 		BPF_STMT(BPF_LD+BPF_W+BPF_ABS,
@@ -3216,7 +3214,7 @@ TEST(user_notification_basic)
 
 	/* Check that we get -ENOSYS with no listener attached */
 	if (pid == 0) {
-		if (user_trap_syscall(__NR_getppid, 0) < 0)
+		if (user_notif_syscall(__NR_getppid, 0) < 0)
 			exit(1);
 		ret = syscall(__NR_getppid);
 		exit(ret >= 0 || errno != ENOSYS);
@@ -3233,13 +3231,13 @@ TEST(user_notification_basic)
 	EXPECT_EQ(seccomp(SECCOMP_SET_MODE_FILTER, 0, &prog), 0);
 
 	/* Check that the basic notification machinery works */
-	listener = user_trap_syscall(__NR_getppid,
-				     SECCOMP_FILTER_FLAG_NEW_LISTENER);
+	listener = user_notif_syscall(__NR_getppid,
+				      SECCOMP_FILTER_FLAG_NEW_LISTENER);
 	ASSERT_GE(listener, 0);
 
 	/* Installing a second listener in the chain should EBUSY */
-	EXPECT_EQ(user_trap_syscall(__NR_getppid,
-				    SECCOMP_FILTER_FLAG_NEW_LISTENER),
+	EXPECT_EQ(user_notif_syscall(__NR_getppid,
+				     SECCOMP_FILTER_FLAG_NEW_LISTENER),
 		  -1);
 	EXPECT_EQ(errno, EBUSY);
 
@@ -3303,12 +3301,12 @@ TEST(user_notification_with_tsync)
 	/* these were exclusive */
 	flags = SECCOMP_FILTER_FLAG_NEW_LISTENER |
 		SECCOMP_FILTER_FLAG_TSYNC;
-	ASSERT_EQ(-1, user_trap_syscall(__NR_getppid, flags));
+	ASSERT_EQ(-1, user_notif_syscall(__NR_getppid, flags));
 	ASSERT_EQ(EINVAL, errno);
 
 	/* but now they're not */
 	flags |= SECCOMP_FILTER_FLAG_TSYNC_ESRCH;
-	ret = user_trap_syscall(__NR_getppid, flags);
+	ret = user_notif_syscall(__NR_getppid, flags);
 	close(ret);
 	ASSERT_LE(0, ret);
 }
@@ -3326,8 +3324,8 @@ TEST(user_notification_kill_in_middle)
 		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
 	}
 
-	listener = user_trap_syscall(__NR_getppid,
-				     SECCOMP_FILTER_FLAG_NEW_LISTENER);
+	listener = user_notif_syscall(__NR_getppid,
+				      SECCOMP_FILTER_FLAG_NEW_LISTENER);
 	ASSERT_GE(listener, 0);
 
 	/*
@@ -3380,8 +3378,8 @@ TEST(user_notification_signal)
 
 	ASSERT_EQ(socketpair(PF_LOCAL, SOCK_SEQPACKET, 0, sk_pair), 0);
 
-	listener = user_trap_syscall(__NR_gettid,
-				     SECCOMP_FILTER_FLAG_NEW_LISTENER);
+	listener = user_notif_syscall(__NR_gettid,
+				      SECCOMP_FILTER_FLAG_NEW_LISTENER);
 	ASSERT_GE(listener, 0);
 
 	pid = fork();
@@ -3450,8 +3448,8 @@ TEST(user_notification_closed_listener)
 		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
 	}
 
-	listener = user_trap_syscall(__NR_getppid,
-				     SECCOMP_FILTER_FLAG_NEW_LISTENER);
+	listener = user_notif_syscall(__NR_getppid,
+				      SECCOMP_FILTER_FLAG_NEW_LISTENER);
 	ASSERT_GE(listener, 0);
 
 	/*
@@ -3484,8 +3482,8 @@ TEST(user_notification_child_pid_ns)
 
 	ASSERT_EQ(unshare(CLONE_NEWUSER | CLONE_NEWPID), 0);
 
-	listener = user_trap_syscall(__NR_getppid,
-				     SECCOMP_FILTER_FLAG_NEW_LISTENER);
+	listener = user_notif_syscall(__NR_getppid,
+				      SECCOMP_FILTER_FLAG_NEW_LISTENER);
 	ASSERT_GE(listener, 0);
 
 	pid = fork();
@@ -3524,8 +3522,8 @@ TEST(user_notification_sibling_pid_ns)
 		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
 	}
 
-	listener = user_trap_syscall(__NR_getppid,
-				     SECCOMP_FILTER_FLAG_NEW_LISTENER);
+	listener = user_notif_syscall(__NR_getppid,
+				      SECCOMP_FILTER_FLAG_NEW_LISTENER);
 	ASSERT_GE(listener, 0);
 
 	pid = fork();
@@ -3589,8 +3587,8 @@ TEST(user_notification_fault_recv)
 
 	ASSERT_EQ(unshare(CLONE_NEWUSER), 0);
 
-	listener = user_trap_syscall(__NR_getppid,
-				     SECCOMP_FILTER_FLAG_NEW_LISTENER);
+	listener = user_notif_syscall(__NR_getppid,
+				      SECCOMP_FILTER_FLAG_NEW_LISTENER);
 	ASSERT_GE(listener, 0);
 
 	pid = fork();
@@ -3641,7 +3639,7 @@ TEST(user_notification_continue)
 		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
 	}
 
-	listener = user_trap_syscall(__NR_dup, SECCOMP_FILTER_FLAG_NEW_LISTENER);
+	listener = user_notif_syscall(__NR_dup, SECCOMP_FILTER_FLAG_NEW_LISTENER);
 	ASSERT_GE(listener, 0);
 
 	pid = fork();
@@ -3736,7 +3734,7 @@ TEST(user_notification_filter_empty)
 	if (pid == 0) {
 		int listener;
 
-		listener = user_trap_syscall(__NR_mknod, SECCOMP_FILTER_FLAG_NEW_LISTENER);
+		listener = user_notif_syscall(__NR_mknod, SECCOMP_FILTER_FLAG_NEW_LISTENER);
 		if (listener < 0)
 			_exit(EXIT_FAILURE);
 
@@ -3792,7 +3790,7 @@ TEST(user_notification_filter_empty_threaded)
 		int listener, status;
 		pthread_t thread;
 
-		listener = user_trap_syscall(__NR_dup, SECCOMP_FILTER_FLAG_NEW_LISTENER);
+		listener = user_notif_syscall(__NR_dup, SECCOMP_FILTER_FLAG_NEW_LISTENER);
 		if (listener < 0)
 			_exit(EXIT_FAILURE);
 
@@ -3869,8 +3867,8 @@ TEST(user_notification_sendfd)
 	}
 
 	/* Check that the basic notification machinery works */
-	listener = user_trap_syscall(__NR_getppid,
-				     SECCOMP_FILTER_FLAG_NEW_LISTENER);
+	listener = user_notif_syscall(__NR_getppid,
+				      SECCOMP_FILTER_FLAG_NEW_LISTENER);
 	ASSERT_GE(listener, 0);
 
 	pid = fork();
@@ -3993,8 +3991,8 @@ TEST(user_notification_sendfd_rlimit)
 	}
 
 	/* Check that the basic notification machinery works */
-	listener = user_trap_syscall(__NR_getppid,
-				     SECCOMP_FILTER_FLAG_NEW_LISTENER);
+	listener = user_notif_syscall(__NR_getppid,
+				      SECCOMP_FILTER_FLAG_NEW_LISTENER);
 	ASSERT_GE(listener, 0);
 
 	pid = fork();
-- 
2.25.1

