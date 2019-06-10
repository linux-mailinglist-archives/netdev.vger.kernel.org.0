Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 723813BF5A
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 00:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390321AbfFJWQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 18:16:44 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46173 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390254AbfFJWQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 18:16:41 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so10712778wrw.13
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 15:16:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FS/Mx65btZMurmeUtrbnwp9b+58840hrSdtdOIZC7IU=;
        b=XIYNIcgCtD2WJDfhnngpNxoLtmAitNg8rhsnYCiJhI4JSarP7RWp3uHqJgoaDeop5F
         fRr4lnOXD7cGuruW7rTG1caxGXdiKPItP8aBZJKPLFHahrBlM5Xvpk+A0nEEb3aw0xt9
         n9f07sELyhhU20spdB7p5lfUBjBtxlhiR3KdgTrN3kRTdKFwp/ndTRL/G6hGSKxTL6hP
         7upkDmM8WCxMSQxpFQWvErg6yeVc3Q7NzcIYl/C2nxlkXlOx2uKHKhfA4OOla2gJPe9A
         CKbbv5KavM9tBGBAybtKr+PqkTy9RLGOSn7tVy5QpSyuvT4F9+4UX9U+aVRvqwApJgKg
         zoSA==
X-Gm-Message-State: APjAAAUn2sR9ep0zKx8/cAuZzqq4Y4ijEFUTIqGrjaszJeMktGp2T+Vm
        3qs2LZrAitpwCo3DUdvpl7u2P1IPF9w=
X-Google-Smtp-Source: APXvYqyi779c5UzwZ5sil7Izk45fXkph6Euv/pYaYHswkg8XZwQwphcml+C3F7lF82wx13ohmboYEg==
X-Received: by 2002:adf:e843:: with SMTP id d3mr1836498wrn.249.1560204999620;
        Mon, 10 Jun 2019 15:16:39 -0700 (PDT)
Received: from raver.teknoraver.net (net-93-144-152-91.cust.vodafonedsl.it. [93.144.152.91])
        by smtp.gmail.com with ESMTPSA id q21sm713369wmq.13.2019.06.10.15.16.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 15:16:38 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 1/2] netns: switch netns in the child when executing commands
Date:   Tue, 11 Jun 2019 00:16:12 +0200
Message-Id: <20190610221613.7554-2-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190610221613.7554-1-mcroce@redhat.com>
References: <20190610221613.7554-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'ip netns exec' changes the current netns just before executing a child
process, and restores it after forking. This is needed if we're running in batch
or do_all mode, as well as other cleanup things like VRF associations.
Add an argument to cmd_exec() which allows to switch the current netns directly
in the child, so the parent environment is kept unaltered.
By doing so, some utility functions became unused, so remove them.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 include/utils.h |  5 +----
 ip/ip_common.h  |  1 -
 ip/ipnetns.c    | 18 ++++--------------
 ip/ipvrf.c      | 16 +---------------
 lib/exec.c      |  6 +++++-
 lib/utils.c     | 27 ---------------------------
 6 files changed, 11 insertions(+), 62 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 8a9c3020..c58a3886 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -294,14 +294,11 @@ extern int cmdlineno;
 ssize_t getcmdline(char **line, size_t *len, FILE *in);
 int makeargs(char *line, char *argv[], int maxargs);
 
-int do_each_netns(int (*func)(char *nsname, void *arg), void *arg,
-		bool show_label);
-
 char *int_to_str(int val, char *buf);
 int get_guid(__u64 *guid, const char *arg);
 int get_real_family(int rtm_type, int rtm_family);
 
-int cmd_exec(const char *cmd, char **argv, bool do_fork);
+int cmd_exec(const char *cmd, char **argv, bool do_fork, char *netns);
 int make_path(const char *path, mode_t mode);
 char *find_cgroup2_mount(void);
 int get_command_name(const char *pid, char *comm, size_t len);
diff --git a/ip/ip_common.h b/ip/ip_common.h
index b4aa34a7..38203aae 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -77,7 +77,6 @@ int do_tcp_metrics(int argc, char **argv);
 int do_ipnetconf(int argc, char **argv);
 int do_iptoken(int argc, char **argv);
 int do_ipvrf(int argc, char **argv);
-void vrf_reset(void);
 int netns_identify_pid(const char *pidstr, char *name, int len);
 int do_seg6(int argc, char **argv);
 
diff --git a/ip/ipnetns.c b/ip/ipnetns.c
index 8ead0c4c..9e414b55 100644
--- a/ip/ipnetns.c
+++ b/ip/ipnetns.c
@@ -400,7 +400,8 @@ static int on_netns_exec(char *nsname, void *arg)
 {
 	char **argv = arg;
 
-	cmd_exec(argv[1], argv + 1, true);
+	printf("\nnetns: %s\n", nsname);
+	cmd_exec(argv[0], argv, true, nsname);
 	return 0;
 }
 
@@ -409,8 +410,6 @@ static int netns_exec(int argc, char **argv)
 	/* Setup the proper environment for apps that are not netns
 	 * aware, and execute a program in that environment.
 	 */
-	const char *cmd;
-
 	if (argc < 1 && !do_all) {
 		fprintf(stderr, "No netns name specified\n");
 		return -1;
@@ -421,22 +420,13 @@ static int netns_exec(int argc, char **argv)
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
+	return -cmd_exec(argv[1], argv + 1, !!batch_mode, argv[0]);
 }
 
 static int is_pid(const char *str)
diff --git a/ip/ipvrf.c b/ip/ipvrf.c
index a13cf653..894d85fc 100644
--- a/ip/ipvrf.c
+++ b/ip/ipvrf.c
@@ -456,21 +456,7 @@ static int ipvrf_exec(int argc, char **argv)
 	if (vrf_switch(argv[0]))
 		return -1;
 
-	return -cmd_exec(argv[1], argv + 1, !!batch_mode);
-}
-
-/* reset VRF association of current process to default VRF;
- * used by netns_exec
- */
-void vrf_reset(void)
-{
-	char vrf[32];
-
-	if (vrf_identify(getpid(), vrf, sizeof(vrf)) ||
-	    (vrf[0] == '\0'))
-		return;
-
-	vrf_switch("default");
+	return -cmd_exec(argv[1], argv + 1, !!batch_mode, NULL);
 }
 
 static int ipvrf_filter_req(struct nlmsghdr *nlh, int reqlen)
diff --git a/lib/exec.c b/lib/exec.c
index eb36b59d..3b07e908 100644
--- a/lib/exec.c
+++ b/lib/exec.c
@@ -5,8 +5,9 @@
 #include <unistd.h>
 
 #include "utils.h"
+#include "namespace.h"
 
-int cmd_exec(const char *cmd, char **argv, bool do_fork)
+int cmd_exec(const char *cmd, char **argv, bool do_fork, char *netns)
 {
 	fflush(stdout);
 	if (do_fork) {
@@ -34,6 +35,9 @@ int cmd_exec(const char *cmd, char **argv, bool do_fork)
 		}
 	}
 
+	if (netns && netns_switch(netns))
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

