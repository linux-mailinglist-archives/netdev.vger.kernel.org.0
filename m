Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3122F2B1167
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 23:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgKLW0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 17:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgKLW0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 17:26:07 -0500
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5166DC0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 14:26:07 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4CXGQj5YKqzQkKW;
        Thu, 12 Nov 2020 23:26:05 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1605219957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I7QPqgldd5bRpbnFKP5pPO4Fyu4g+hlUXzRjdqHYhf4=;
        b=LOFhqeVDcjlFS0EHuH3DHpm5CUkAeB7o/AwVuC8hSak5+RMVlCzm1Hlt7uxTqaecLzAmIl
        HeZ9CEcdQtM0fotxSMAAKwTl2TH/310IQFMoxW6onmwL5kpqayuUzK2Ui5OhvGtSY3XiTr
        op03uzpGtldlRF4w1arTNimDrbObA1M/O4P0g2kC86qdSE1yYL7es+sKB0dCsyiLFUSY/v
        W/Kt8KNeo3w6HcXoYbPXRyhy+Q0600neDQFl4ndKF+pCxHsQVrN0dA4O5/mnIWw51sV80b
        MlNFmQWe2xrGfpx90XlOUrblIb89osOWDgQ6zFYuAu++hRK/lfdZ4PVHKowRWw==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter06.heinlein-hosting.de (spamfilter06.heinlein-hosting.de [80.241.56.125]) (amavisd-new, port 10030)
        with ESMTP id rl4WDhU0o__H; Thu, 12 Nov 2020 23:25:56 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>,
        Leon Romanovsky <leon@kernel.org>,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next v5 01/11] Unify batch processing across tools
Date:   Thu, 12 Nov 2020 23:24:38 +0100
Message-Id: <a7380e781b75ce787510b5775ba15061ced7f666.1605218735.git.me@pmachata.org>
In-Reply-To: <cover.1605218735.git.me@pmachata.org>
References: <cover.1605218735.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 1.12 / 15.00 / 15.00
X-Rspamd-Queue-Id: 8251E170D
X-Rspamd-UID: a08df5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code for handling batches is largely the same across iproute2 tools.
Extract a helper to handle the batch, and adjust the tools to dispatch to
this helper. Sandwitch the invocation between prologue / epilogue code
specific for each tool.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 bridge/bridge.c   | 38 +++++++-------------------------------
 devlink/devlink.c | 41 +++++++----------------------------------
 include/utils.h   |  3 +++
 ip/ip.c           | 46 ++++++++++------------------------------------
 lib/utils.c       | 40 ++++++++++++++++++++++++++++++++++++++++
 rdma/rdma.c       | 38 +++++++-------------------------------
 tc/tc.c           | 38 +++++++-------------------------------
 7 files changed, 81 insertions(+), 163 deletions(-)

diff --git a/bridge/bridge.c b/bridge/bridge.c
index 453d689732bd..8f691cfdd466 100644
--- a/bridge/bridge.c
+++ b/bridge/bridge.c
@@ -77,20 +77,14 @@ static int do_cmd(const char *argv0, int argc, char **argv)
 	return -1;
 }
 
-static int batch(const char *name)
+static int br_batch_cmd(int argc, char *argv[], void *data)
 {
-	char *line = NULL;
-	size_t len = 0;
-	int ret = EXIT_SUCCESS;
+	return do_cmd(argv[0], argc, argv);
+}
 
-	if (name && strcmp(name, "-") != 0) {
-		if (freopen(name, "r", stdin) == NULL) {
-			fprintf(stderr,
-				"Cannot open file \"%s\" for reading: %s\n",
-				name, strerror(errno));
-			return EXIT_FAILURE;
-		}
-	}
+static int batch(const char *name)
+{
+	int ret;
 
 	if (rtnl_open(&rth, 0) < 0) {
 		fprintf(stderr, "Cannot open rtnetlink\n");
@@ -99,25 +93,7 @@ static int batch(const char *name)
 
 	rtnl_set_strict_dump(&rth);
 
-	cmdlineno = 0;
-	while (getcmdline(&line, &len, stdin) != -1) {
-		char *largv[100];
-		int largc;
-
-		largc = makeargs(line, largv, 100);
-		if (largc == 0)
-			continue;       /* blank line */
-
-		if (do_cmd(largv[0], largc, largv)) {
-			fprintf(stderr, "Command failed %s:%d\n",
-				name, cmdlineno);
-			ret = EXIT_FAILURE;
-			if (!force)
-				break;
-		}
-	}
-	if (line)
-		free(line);
+	ret = do_batch(name, force, br_batch_cmd, NULL);
 
 	rtnl_close(&rth);
 	return ret;
diff --git a/devlink/devlink.c b/devlink/devlink.c
index 1ff865bc5c22..5bb00b3a5b8c 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -7912,43 +7912,16 @@ static void dl_free(struct dl *dl)
 	free(dl);
 }
 
-static int dl_batch(struct dl *dl, const char *name, bool force)
+static int dl_batch_cmd(int argc, char *argv[], void *data)
 {
-	char *line = NULL;
-	size_t len = 0;
-	int ret = EXIT_SUCCESS;
-
-	if (name && strcmp(name, "-") != 0) {
-		if (freopen(name, "r", stdin) == NULL) {
-			fprintf(stderr,
-				"Cannot open file \"%s\" for reading: %s\n",
-				name, strerror(errno));
-			return EXIT_FAILURE;
-		}
-	}
-
-	cmdlineno = 0;
-	while (getcmdline(&line, &len, stdin) != -1) {
-		char *largv[100];
-		int largc;
-
-		largc = makeargs(line, largv, 100);
-		if (!largc)
-			continue;	/* blank line */
-
-		if (dl_cmd(dl, largc, largv)) {
-			fprintf(stderr, "Command failed %s:%d\n",
-				name, cmdlineno);
-			ret = EXIT_FAILURE;
-			if (!force)
-				break;
-		}
-	}
+	struct dl *dl = data;
 
-	if (line)
-		free(line);
+	return dl_cmd(dl, argc, argv);
+}
 
-	return ret;
+static int dl_batch(struct dl *dl, const char *name, bool force)
+{
+	return do_batch(name, force, dl_batch_cmd, dl);
 }
 
 int main(int argc, char **argv)
diff --git a/include/utils.h b/include/utils.h
index 7041c4612e46..085b17b1f6e3 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -322,4 +322,7 @@ int get_time64(__s64 *time, const char *str);
 char *sprint_time(__u32 time, char *buf);
 char *sprint_time64(__s64 time, char *buf);
 
+int do_batch(const char *name, bool force,
+	     int (*cmd)(int argc, char *argv[], void *user), void *user);
+
 #endif /* __UTILS_H__ */
diff --git a/ip/ip.c b/ip/ip.c
index ac4450235370..5e31957f2420 100644
--- a/ip/ip.c
+++ b/ip/ip.c
@@ -121,56 +121,30 @@ static int do_cmd(const char *argv0, int argc, char **argv)
 	return EXIT_FAILURE;
 }
 
-static int batch(const char *name)
+static int ip_batch_cmd(int argc, char *argv[], void *data)
 {
-	char *line = NULL;
-	size_t len = 0;
-	int ret = EXIT_SUCCESS;
-	int orig_family = preferred_family;
+	const int *orig_family = data;
 
-	batch_mode = 1;
+	preferred_family = *orig_family;
+	return do_cmd(argv[0], argc, argv);
+}
 
-	if (name && strcmp(name, "-") != 0) {
-		if (freopen(name, "r", stdin) == NULL) {
-			fprintf(stderr,
-				"Cannot open file \"%s\" for reading: %s\n",
-				name, strerror(errno));
-			return EXIT_FAILURE;
-		}
-	}
+static int batch(const char *name)
+{
+	int orig_family = preferred_family;
+	int ret;
 
 	if (rtnl_open(&rth, 0) < 0) {
 		fprintf(stderr, "Cannot open rtnetlink\n");
 		return EXIT_FAILURE;
 	}
 
-	cmdlineno = 0;
-	while (getcmdline(&line, &len, stdin) != -1) {
-		char *largv[100];
-		int largc;
-
-		preferred_family = orig_family;
-
-		largc = makeargs(line, largv, 100);
-		if (largc == 0)
-			continue;	/* blank line */
-
-		if (do_cmd(largv[0], largc, largv)) {
-			fprintf(stderr, "Command failed %s:%d\n",
-				name, cmdlineno);
-			ret = EXIT_FAILURE;
-			if (!force)
-				break;
-		}
-	}
-	if (line)
-		free(line);
+	ret = do_batch(name, force, ip_batch_cmd, &orig_family);
 
 	rtnl_close(&rth);
 	return ret;
 }
 
-
 int main(int argc, char **argv)
 {
 	char *basename;
diff --git a/lib/utils.c b/lib/utils.c
index c98021d6ecad..9815e328c9e0 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -1695,3 +1695,43 @@ char *sprint_time64(__s64 time, char *buf)
 	print_time64(buf, SPRINT_BSIZE-1, time);
 	return buf;
 }
+
+int do_batch(const char *name, bool force,
+	     int (*cmd)(int argc, char *argv[], void *data), void *data)
+{
+	char *line = NULL;
+	size_t len = 0;
+	int ret = EXIT_SUCCESS;
+
+	if (name && strcmp(name, "-") != 0) {
+		if (freopen(name, "r", stdin) == NULL) {
+			fprintf(stderr,
+				"Cannot open file \"%s\" for reading: %s\n",
+				name, strerror(errno));
+			return EXIT_FAILURE;
+		}
+	}
+
+	cmdlineno = 0;
+	while (getcmdline(&line, &len, stdin) != -1) {
+		char *largv[100];
+		int largc;
+
+		largc = makeargs(line, largv, 100);
+		if (!largc)
+			continue;	/* blank line */
+
+		if (cmd(largc, largv, data)) {
+			fprintf(stderr, "Command failed %s:%d\n",
+				name, cmdlineno);
+			ret = EXIT_FAILURE;
+			if (!force)
+				break;
+		}
+	}
+
+	if (line)
+		free(line);
+
+	return ret;
+}
diff --git a/rdma/rdma.c b/rdma/rdma.c
index 9ea2d17ffe9e..8dc2d3e344be 100644
--- a/rdma/rdma.c
+++ b/rdma/rdma.c
@@ -41,40 +41,16 @@ static int rd_cmd(struct rd *rd, int argc, char **argv)
 	return rd_exec_cmd(rd, cmds, "object");
 }
 
-static int rd_batch(struct rd *rd, const char *name, bool force)
+static int rd_batch_cmd(int argc, char *argv[], void *data)
 {
-	char *line = NULL;
-	size_t len = 0;
-	int ret = 0;
-
-	if (name && strcmp(name, "-") != 0) {
-		if (!freopen(name, "r", stdin)) {
-			pr_err("Cannot open file \"%s\" for reading: %s\n",
-			       name, strerror(errno));
-			return errno;
-		}
-	}
+	struct rd *rd = data;
 
-	cmdlineno = 0;
-	while (getcmdline(&line, &len, stdin) != -1) {
-		char *largv[512];
-		int largc;
-
-		largc = makeargs(line, largv, ARRAY_SIZE(largv));
-		if (!largc)
-			continue;	/* blank line */
-
-		ret = rd_cmd(rd, largc, largv);
-		if (ret) {
-			pr_err("Command failed %s:%d\n", name, cmdlineno);
-			if (!force)
-				break;
-		}
-	}
-
-	free(line);
+	return rd_cmd(rd, argc, argv);
+}
 
-	return ret;
+static int rd_batch(struct rd *rd, const char *name, bool force)
+{
+	return do_batch(name, force, rd_batch_cmd, rd);
 }
 
 static int rd_init(struct rd *rd, char *filename)
diff --git a/tc/tc.c b/tc/tc.c
index 5d57054b45fb..01fe58d06202 100644
--- a/tc/tc.c
+++ b/tc/tc.c
@@ -231,22 +231,16 @@ static int do_cmd(int argc, char **argv)
 	return -1;
 }
 
+static int tc_batch_cmd(int argc, char *argv[], void *data)
+{
+	return do_cmd(argc, argv);
+}
+
 static int batch(const char *name)
 {
-	char *line = NULL;
-	size_t len = 0;
-	int ret = 0;
+	int ret;
 
 	batch_mode = 1;
-	if (name && strcmp(name, "-") != 0) {
-		if (freopen(name, "r", stdin) == NULL) {
-			fprintf(stderr,
-				"Cannot open file \"%s\" for reading: %s\n",
-				name, strerror(errno));
-			return -1;
-		}
-	}
-
 	tc_core_init();
 
 	if (rtnl_open(&rth, 0) < 0) {
@@ -254,26 +248,8 @@ static int batch(const char *name)
 		return -1;
 	}
 
-	cmdlineno = 0;
-	while (getcmdline(&line, &len, stdin) != -1) {
-		char *largv[100];
-		int largc;
-
-		largc = makeargs(line, largv, 100);
-		if (largc == 0)
-			continue;	/* blank line */
-
-		if (do_cmd(largc, largv)) {
-			fprintf(stderr, "Command failed %s:%d\n",
-				name, cmdlineno);
-			ret = 1;
-			if (!force)
-				break;
-		}
-		fflush(stdout);
-	}
+	ret = do_batch(name, force, tc_batch_cmd, NULL);
 
-	free(line);
 	rtnl_close(&rth);
 	return ret;
 }
-- 
2.25.1

