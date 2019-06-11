Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71BE13D1E7
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 18:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405215AbfFKQLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 12:11:30 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44698 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388744AbfFKQLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 12:11:30 -0400
Received: by mail-wr1-f65.google.com with SMTP id b17so13688360wrq.11
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 09:11:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cn/GGlHPHDdnf++kK93tVK4UsMV2NprdUCGNa+HjZPA=;
        b=Tb9+xJy1UeaFXlX3unrx1cQGqOzvCShYdj1wxmEmZYoS5c6yTfa8IbN6gOYYIZqwtC
         7QZJBDrsJcDscNS6TXzuNNJvnGHvEANVwQg4tsuW6zjprBdlh4yslNpHE5VNyWroZ+8X
         sm7HPxB0DJ5+2xbUsOVIxk69lxxAW3mxKzkNU4U6fgIMouP+br+52vTnWpN4iK6NwkmE
         1RzUvn85ECUSg2Cz77PrX8X1qEIOnrnlYqkU1svBsm81+ca3SnrbsizzWFgfHaVr03RF
         jNPDfeDo4BxFMSFSnuJ1wd9E8YSs+wgmtMp3lZajTHVGBwMBUI8R/qqO3jYFOnDYuQqy
         I+Ug==
X-Gm-Message-State: APjAAAVe+/BZJYFJ0tYWjybOq3/VVQB1pvS9iz71NF3pG6ydgeIxPaye
        h9fyNuPcReRV+WshoJE5aPnNuHK+hy8=
X-Google-Smtp-Source: APXvYqzOo6IEicMWki20V6eOu80YIOlJG9VJ0OtSy2PoXlF2PZH1QYfqqXtfiMPFOBfjrm4ntFTptQ==
X-Received: by 2002:a5d:49c3:: with SMTP id t3mr2370780wrs.147.1560269487605;
        Tue, 11 Jun 2019 09:11:27 -0700 (PDT)
Received: from mcroce-redhat.mxp.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id y18sm4286981wmd.29.2019.06.11.09.11.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 09:11:26 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2 v2 1/3] netns: switch netns in the child when executing commands
Date:   Tue, 11 Jun 2019 18:10:29 +0200
Message-Id: <20190611161031.12898-2-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190611161031.12898-1-mcroce@redhat.com>
References: <20190611161031.12898-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'ip netns exec' changes the current netns just before executing a child
process, and restores it after forking. This is needed if we're running
in batch or do_all mode.
Some cleanups must be done both in the parent and in the child: the
parent must restore the previous netns, while the child must reset any
VRF association.
Unfortunately, if do_all is set, the VRF are not reset in the child, and
the spawned processes are started with the wrong VRF context. This can
be triggered with this script:

	# ip -b - <<-'EOF'
		link add type vrf table 100
		link set vrf0 up
		link add type dummy
		link set dummy0 vrf vrf0 up
		netns add ns1
	EOF
	# ip -all -b - <<-'EOF'
		vrf exec vrf0 true
		netns exec setsid -f sleep 1h
	EOF
	# ip vrf pids vrf0
	  314  sleep
	# ps 314
	  PID TTY      STAT   TIME COMMAND
	  314 ?        Ss     0:00 sleep 1h

Refactor cmd_exec() and pass to it a function pointer which is called in
the child before the final exec. In the netns exec case the function just
resets the VRF and switches netns.

Doing it in the child is less error prone and safer, because the parent
environment is always kept unaltered.

After this refactor some utility functions became unused, so remove them.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 include/utils.h |  6 ++----
 ip/ipnetns.c    | 30 ++++++++++++++++--------------
 ip/ipvrf.c      |  2 +-
 lib/exec.c      |  7 ++++++-
 lib/utils.c     | 27 ---------------------------
 5 files changed, 25 insertions(+), 47 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 8a9c3020..927fdc17 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -294,14 +294,12 @@ extern int cmdlineno;
 ssize_t getcmdline(char **line, size_t *len, FILE *in);
 int makeargs(char *line, char *argv[], int maxargs);
 
-int do_each_netns(int (*func)(char *nsname, void *arg), void *arg,
-		bool show_label);
-
 char *int_to_str(int val, char *buf);
 int get_guid(__u64 *guid, const char *arg);
 int get_real_family(int rtm_type, int rtm_family);
 
-int cmd_exec(const char *cmd, char **argv, bool do_fork);
+int cmd_exec(const char *cmd, char **argv, bool do_fork,
+	     int (*setup)(void *), void *arg);
 int make_path(const char *path, mode_t mode);
 char *find_cgroup2_mount(void);
 int get_command_name(const char *pid, char *comm, size_t len);
diff --git a/ip/ipnetns.c b/ip/ipnetns.c
index 8ead0c4c..58655676 100644
--- a/ip/ipnetns.c
+++ b/ip/ipnetns.c
@@ -396,11 +396,24 @@ static int netns_list(int argc, char **argv)
 	return 0;
 }
 
+static int do_switch(void *arg)
+{
+	char *netns = arg;
+
+	/* we just changed namespaces. clear any vrf association
+	 * with prior namespace before exec'ing command
+	 */
+	vrf_reset();
+
+	return netns_switch(netns);
+}
+
 static int on_netns_exec(char *nsname, void *arg)
 {
 	char **argv = arg;
 
-	cmd_exec(argv[1], argv + 1, true);
+	printf("\nnetns: %s\n", nsname);
+	cmd_exec(argv[0], argv, true, do_switch, nsname);
 	return 0;
 }
 
@@ -409,8 +422,6 @@ static int netns_exec(int argc, char **argv)
 	/* Setup the proper environment for apps that are not netns
 	 * aware, and execute a program in that environment.
 	 */
-	const char *cmd;
-
 	if (argc < 1 && !do_all) {
 		fprintf(stderr, "No netns name specified\n");
 		return -1;
@@ -421,22 +432,13 @@ static int netns_exec(int argc, char **argv)
 	}
 
 	if (do_all)
-		return do_each_netns(on_netns_exec, --argv, 1);
-
-	if (netns_switch(argv[0]))
-		return -1;
-
-	/* we just changed namespaces. clear any vrf association
-	 * with prior namespace before exec'ing command
-	 */
-	vrf_reset();
+		return netns_foreach(on_netns_exec, argv);
 
 	/* ip must return the status of the child,
 	 * but do_cmd() will add a minus to this,
 	 * so let's add another one here to cancel it.
 	 */
-	cmd = argv[1];
-	return -cmd_exec(cmd, argv + 1, !!batch_mode);
+	return -cmd_exec(argv[1], argv + 1, !!batch_mode, do_switch, argv[0]);
 }
 
 static int is_pid(const char *str)
diff --git a/ip/ipvrf.c b/ip/ipvrf.c
index a13cf653..2b019c6c 100644
--- a/ip/ipvrf.c
+++ b/ip/ipvrf.c
@@ -456,7 +456,7 @@ static int ipvrf_exec(int argc, char **argv)
 	if (vrf_switch(argv[0]))
 		return -1;
 
-	return -cmd_exec(argv[1], argv + 1, !!batch_mode);
+	return -cmd_exec(argv[1], argv + 1, !!batch_mode, NULL, NULL);
 }
 
 /* reset VRF association of current process to default VRF;
diff --git a/lib/exec.c b/lib/exec.c
index eb36b59d..9b1c8f4a 100644
--- a/lib/exec.c
+++ b/lib/exec.c
@@ -5,8 +5,10 @@
 #include <unistd.h>
 
 #include "utils.h"
+#include "namespace.h"
 
-int cmd_exec(const char *cmd, char **argv, bool do_fork)
+int cmd_exec(const char *cmd, char **argv, bool do_fork,
+	     int (*setup)(void *), void *arg)
 {
 	fflush(stdout);
 	if (do_fork) {
@@ -34,6 +36,9 @@ int cmd_exec(const char *cmd, char **argv, bool do_fork)
 		}
 	}
 
+	if (setup && setup(arg))
+		return -1;
+
 	if (execvp(cmd, argv)  < 0)
 		fprintf(stderr, "exec of \"%s\" failed: %s\n",
 				cmd, strerror(errno));
diff --git a/lib/utils.c b/lib/utils.c
index a81c0700..be0f11b0 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -1418,33 +1418,6 @@ void print_nlmsg_timestamp(FILE *fp, const struct nlmsghdr *n)
 	fprintf(fp, "Timestamp: %s %lu us\n", tstr, usecs);
 }
 
-static int on_netns(char *nsname, void *arg)
-{
-	struct netns_func *f = arg;
-
-	if (netns_switch(nsname))
-		return -1;
-
-	return f->func(nsname, f->arg);
-}
-
-static int on_netns_label(char *nsname, void *arg)
-{
-	printf("\nnetns: %s\n", nsname);
-	return on_netns(nsname, arg);
-}
-
-int do_each_netns(int (*func)(char *nsname, void *arg), void *arg,
-		bool show_label)
-{
-	struct netns_func nsf = { .func = func, .arg = arg };
-
-	if (show_label)
-		return netns_foreach(on_netns_label, &nsf);
-
-	return netns_foreach(on_netns, &nsf);
-}
-
 char *int_to_str(int val, char *buf)
 {
 	sprintf(buf, "%d", val);
-- 
2.21.0

