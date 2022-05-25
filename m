Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7341C533583
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 04:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242767AbiEYCx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 22:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242338AbiEYCx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 22:53:56 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01FE7090F
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 19:53:54 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id m13so10135468qtx.0
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 19:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QL4XbVs19Flmpd07pTiThIq7YuypQ+9+bnrvDH5lVcQ=;
        b=dBYx3PW+9BIaKrlEbcZYpchEksmEFHj+PWu0M97nflGKcM94N8m50AOlIOh3z07QY8
         DCiU7IzpSYoZcwyDuHs818cvE1cKdmXgQxuchHjWGD8wrZZHu80bjx0vEjcRST1dSSiI
         EveZS7U/UTkhGm4TNlbmvQGkefP0qkJCJfPnW2dOsmiAmls8oBnQHvPwyKaeStd7x9Dg
         K+sjUDWIuIqsSgAmD2T7k8UASmZgfVdW+O7GmErRDCmktH7HjgUgT/9Npp3mYYt4EtoE
         LIyN9TYsu6SKAE5xXtf6Bq7mqt9+u1z8Zax4vdoYDYoA7jXBEYC+IvRxhP5OoryFIIEi
         dF0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QL4XbVs19Flmpd07pTiThIq7YuypQ+9+bnrvDH5lVcQ=;
        b=CRKFdYY/yk5GfeXFYEppNlc1UQzPjgfYDowB53rXrMhad6prbGEhoOZkoXhKD6xPbo
         7uiTRTywJQNW7PfWMsJNY6IiPnSjtbw5fCpCkouj2vnifzc4KS5/IcMPKRjoM9cuTym2
         PZz2Szx6rCEEJ6TMzuPmCKxj3yoiq8twXIxPgrnsVNjb13HIflqRhNAEMAw6UwbZkxPf
         K8isvmORwoDTgVc0ANcHUvnfI8v0hRDi4D160zHWWN+eojZ+trxjl3DM4cDaGIkTT3+9
         EzcwsKAcNWlZC29uHV5Gw69Eil7T7nCOmz9jEWpc+OCYcMxol3H659elTeP4XNQlYPM5
         X7Ew==
X-Gm-Message-State: AOAM533gJwGqHLjmIK0Ax7wPGzvvLtr+hj02tcKvWW+mcSlXbCwCDwgd
        62vqkohCpTuLRq9vrj8o7g==
X-Google-Smtp-Source: ABdhPJwQhk7FW6IO3C09jgy2EVyM/GRSmuQmEoAv59AUHZL4FL81muqBvEyJxsJ81Zp7lcEUIYtKqA==
X-Received: by 2002:ac8:5a46:0:b0:2f3:eb45:e465 with SMTP id o6-20020ac85a46000000b002f3eb45e465mr23146098qta.126.1653447233810;
        Tue, 24 May 2022 19:53:53 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-3-231-65-244.compute-1.amazonaws.com. [3.231.65.244])
        by smtp.gmail.com with ESMTPSA id o9-20020a05622a044900b002f39b99f697sm734387qtx.49.2022.05.24.19.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 19:53:53 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH iproute2-next 7/7] ss: Introduce -T, --threads option
Date:   Tue, 24 May 2022 19:53:41 -0700
Message-Id: <d331efd6c19dd77e3bd682bef20daf1c9ec173b8.1653446538.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1653446538.git.peilin.ye@bytedance.com>
References: <cover.1653446538.git.peilin.ye@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

The -p, -Z and -z options only show process (thread group leader)
information.  For example, if the thread group leader has exited, but
another thread in the group is still using a socket, ss -[pZz] does not
show it.

Add a new option, -T (--threads), to show thread information.  It implies
the -p option.  For example, imagine process A and thread B (in the same
group) using the same socket.  ss -p only shows A:

  $ ss -ltp "sport = 1234"
  State   Recv-Q  Send-Q  Local Address:Port      Peer Address:Port       Process
  LISTEN  0       100           0.0.0.0:1234           0.0.0.0:*           users:(("test",pid=2932547,fd=3))

ss -T shows A and B:

  $ ss -ltT "sport = 1234"
  State   Recv-Q  Send-Q  Local Address:Port      Peer Address:Port       Process
  LISTEN  0       100           0.0.0.0:1234           0.0.0.0:*           users:(("test",pid=2932547,tid=2932548,fd=3),("test",pid=2932547,tid=2932547,fd=3))

If -T is used, -Z and -z also show SELinux contexts for threads.

Rename some variables (from "process" to "task", for example) since we
use them for both processes and threads.

Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 man/man8/ss.8 |  8 ++++-
 misc/ss.c     | 94 +++++++++++++++++++++++++++++++++++----------------
 2 files changed, 72 insertions(+), 30 deletions(-)

diff --git a/man/man8/ss.8 b/man/man8/ss.8
index 68f0a699e61b..026530ed77bd 100644
--- a/man/man8/ss.8
+++ b/man/man8/ss.8
@@ -155,6 +155,10 @@ the number of packets dropped before they are de-multiplexed into the socket
 .B \-p, \-\-processes
 Show process using socket.
 .TP
+.B \-T, \-\-threads
+Show thread using socket. Implies \-p.
+.BR \-p .
+.TP
 .B \-i, \-\-info
 Show internal TCP information. Below fields may appear:
 .RS
@@ -311,7 +315,9 @@ Continually display sockets as they are destroyed
 .B \-Z, \-\-context
 As the
 .B \-p
-option but also shows process security context.
+option but also shows process security context. If the
+.B \-T
+option is used, also shows thread security context.
 .sp
 For
 .BR netlink (7)
diff --git a/misc/ss.c b/misc/ss.c
index 07d0057b22cc..344bb0f055d6 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -112,7 +112,8 @@ static void freecon(char *context)
 int preferred_family = AF_UNSPEC;
 static int show_options;
 int show_details;
-static int show_users;
+static int show_processes;
+static int show_threads;
 static int show_mem;
 static int show_tcpinfo;
 static int show_bpf;
@@ -526,9 +527,10 @@ struct user_ent {
 	struct user_ent	*next;
 	unsigned int	ino;
 	int		pid;
+	int		tid;
 	int		fd;
-	char		*process;
-	char		*process_ctx;
+	char		*task;
+	char		*task_ctx;
 	char		*socket_ctx;
 };
 
@@ -542,9 +544,9 @@ static int user_ent_hashfn(unsigned int ino)
 	return val & (USER_ENT_HASH_SIZE - 1);
 }
 
-static void user_ent_add(unsigned int ino, char *process,
-					int pid, int fd,
-					char *proc_ctx,
+static void user_ent_add(unsigned int ino, char *task,
+					int pid, int tid, int fd,
+					char *task_ctx,
 					char *sock_ctx)
 {
 	struct user_ent *p, **pp;
@@ -557,9 +559,10 @@ static void user_ent_add(unsigned int ino, char *process,
 	p->next = NULL;
 	p->ino = ino;
 	p->pid = pid;
+	p->tid = tid;
 	p->fd = fd;
-	p->process = strdup(process);
-	p->process_ctx = strdup(proc_ctx);
+	p->task = strdup(task);
+	p->task_ctx = strdup(task_ctx);
 	p->socket_ctx = strdup(sock_ctx);
 
 	pp = &user_ent_hash[user_ent_hashfn(ino)];
@@ -569,7 +572,7 @@ static void user_ent_add(unsigned int ino, char *process,
 
 #define MAX_PATH_LEN	1024
 
-static void user_ent_hash_build_task(char *path, int pid)
+static void user_ent_hash_build_task(char *path, int pid, int tid)
 {
 	const char *no_ctx = "unavailable";
 	char task[16] = {'\0', };
@@ -579,7 +582,7 @@ static void user_ent_hash_build_task(char *path, int pid)
 	struct dirent *d;
 	DIR *dir;
 
-	if (getpidcon(pid, &task_context) != 0)
+	if (getpidcon(tid, &task_context) != 0)
 		task_context = strdup(no_ctx);
 
 	pos_id = strlen(path);	/* $PROC_ROOT/$ID/ */
@@ -634,7 +637,7 @@ static void user_ent_hash_build_task(char *path, int pid)
 			}
 		}
 
-		user_ent_add(ino, task, pid, fd, task_context, sock_context);
+		user_ent_add(ino, task, pid, tid, fd, task_context, sock_context);
 		freecon(sock_context);
 	}
 
@@ -650,8 +653,8 @@ static void user_ent_destroy(void)
 	while (cnt != USER_ENT_HASH_SIZE) {
 		p = user_ent_hash[cnt];
 		while (p) {
-			free(p->process);
-			free(p->process_ctx);
+			free(p->task);
+			free(p->task_ctx);
 			free(p->socket_ctx);
 			p_next = p->next;
 			free(p);
@@ -687,7 +690,30 @@ static void user_ent_hash_build(void)
 			continue;
 
 		snprintf(name + nameoff, sizeof(name) - nameoff, "%d/", pid);
-		user_ent_hash_build_task(name, pid);
+		user_ent_hash_build_task(name, pid, pid);
+
+		if (show_threads) {
+			struct dirent *task_d;
+			DIR *task_dir;
+
+			snprintf(name + nameoff, sizeof(name) - nameoff, "%d/task/", pid);
+
+			task_dir = opendir(name);
+			if (!task_dir)
+				continue;
+
+			while ((task_d = readdir(task_dir)) != NULL) {
+				int tid;
+
+				if (sscanf(task_d->d_name, "%d%*c", &tid) != 1)
+					continue;
+				if (tid == pid)
+					continue;
+
+				snprintf(name + nameoff, sizeof(name) - nameoff, "%d/", tid);
+				user_ent_hash_build_task(name, pid, tid);
+			}
+		}
 	}
 	closedir(dir);
 }
@@ -704,6 +730,7 @@ static int find_entry(unsigned int ino, char **buf, int type)
 	struct user_ent *p;
 	int cnt = 0;
 	char *ptr;
+	char thread_info[16] = {'\0', };
 	char *new_buf;
 	int len, new_buf_len;
 	int buf_used = 0;
@@ -720,23 +747,27 @@ static int find_entry(unsigned int ino, char **buf, int type)
 
 		while (1) {
 			ptr = *buf + buf_used;
+
+			if (show_threads)
+				snprintf(thread_info, sizeof(thread_info), "tid=%d,", p->tid);
+
 			switch (type) {
 			case USERS:
 				len = snprintf(ptr, buf_len - buf_used,
-					"(\"%s\",pid=%d,fd=%d),",
-					p->process, p->pid, p->fd);
+					"(\"%s\",pid=%d,%sfd=%d),",
+					p->task, p->pid, thread_info, p->fd);
 				break;
 			case PROC_CTX:
 				len = snprintf(ptr, buf_len - buf_used,
-					"(\"%s\",pid=%d,proc_ctx=%s,fd=%d),",
-					p->process, p->pid,
-					p->process_ctx, p->fd);
+					"(\"%s\",pid=%d,%sproc_ctx=%s,fd=%d),",
+					p->task, p->pid, thread_info,
+					p->task_ctx, p->fd);
 				break;
 			case PROC_SOCK_CTX:
 				len = snprintf(ptr, buf_len - buf_used,
-					"(\"%s\",pid=%d,proc_ctx=%s,fd=%d,sock_ctx=%s),",
-					p->process, p->pid,
-					p->process_ctx, p->fd,
+					"(\"%s\",pid=%d,%sproc_ctx=%s,fd=%d,sock_ctx=%s),",
+					p->task, p->pid, thread_info,
+					p->task_ctx, p->fd,
 					p->socket_ctx);
 				break;
 			default:
@@ -2417,7 +2448,7 @@ static void proc_ctx_print(struct sockstat *s)
 			out(" users:(%s)", buf);
 			free(buf);
 		}
-	} else if (show_users) {
+	} else if (show_processes || show_threads) {
 		if (find_entry(s->ino, &buf, USERS) > 0) {
 			out(" users:(%s)", buf);
 			free(buf);
@@ -5312,6 +5343,7 @@ static void _usage(FILE *dest)
 "   -e, --extended      show detailed socket information\n"
 "   -m, --memory        show socket memory usage\n"
 "   -p, --processes     show process using socket\n"
+"   -T, --threads       show thread using socket\n"
 "   -i, --info          show internal TCP information\n"
 "       --tipcinfo      show internal tipc socket information\n"
 "   -s, --summary       show socket usage summary\n"
@@ -5319,8 +5351,8 @@ static void _usage(FILE *dest)
 "       --cgroup        show cgroup information\n"
 "   -b, --bpf           show bpf filter socket information\n"
 "   -E, --events        continually display sockets as they are destroyed\n"
-"   -Z, --context       display process SELinux security contexts\n"
-"   -z, --contexts      display process and socket SELinux security contexts\n"
+"   -Z, --context       display task SELinux security contexts\n"
+"   -z, --contexts      display task and socket SELinux security contexts\n"
 "   -N, --net           switch to the specified network namespace name\n"
 "\n"
 "   -4, --ipv4          display only IP version 4 sockets\n"
@@ -5441,6 +5473,7 @@ static const struct option long_opts[] = {
 	{ "memory", 0, 0, 'm' },
 	{ "info", 0, 0, 'i' },
 	{ "processes", 0, 0, 'p' },
+	{ "threads", 0, 0, 'T' },
 	{ "bpf", 0, 0, 'b' },
 	{ "events", 0, 0, 'E' },
 	{ "dccp", 0, 0, 'd' },
@@ -5491,7 +5524,7 @@ int main(int argc, char *argv[])
 	int state_filter = 0;
 
 	while ((ch = getopt_long(argc, argv,
-				 "dhaletuwxnro460spbEf:mMiA:D:F:vVzZN:KHSO",
+				 "dhaletuwxnro460spTbEf:mMiA:D:F:vVzZN:KHSO",
 				 long_opts, NULL)) != EOF) {
 		switch (ch) {
 		case 'n':
@@ -5514,7 +5547,10 @@ int main(int argc, char *argv[])
 			show_tcpinfo = 1;
 			break;
 		case 'p':
-			show_users++;
+			show_processes++;
+			break;
+		case 'T':
+			show_threads++;
 			break;
 		case 'b':
 			show_options = 1;
@@ -5683,7 +5719,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	if (show_users || show_proc_ctx || show_sock_ctx)
+	if (show_processes || show_threads || show_proc_ctx || show_sock_ctx)
 		user_ent_hash_build();
 
 	argc -= optind;
@@ -5803,7 +5839,7 @@ int main(int argc, char *argv[])
 	if (current_filter.dbs & (1<<MPTCP_DB))
 		mptcp_show(&current_filter);
 
-	if (show_users || show_proc_ctx || show_sock_ctx)
+	if (show_processes || show_threads || show_proc_ctx || show_sock_ctx)
 		user_ent_destroy();
 
 	render();
-- 
2.20.1

