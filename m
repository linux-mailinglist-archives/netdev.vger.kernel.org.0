Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8623552CF2
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348197AbiFUIZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348191AbiFUIYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:24:41 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6EF5237C9;
        Tue, 21 Jun 2022 01:23:44 -0700 (PDT)
Received: from fraeml745-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LRzy40VZHz6897v;
        Tue, 21 Jun 2022 16:21:48 +0800 (CST)
Received: from lhreml745-chm.china.huawei.com (10.201.108.195) by
 fraeml745-chm.china.huawei.com (10.206.15.226) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 21 Jun 2022 10:23:42 +0200
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhreml745-chm.china.huawei.com (10.201.108.195) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 21 Jun 2022 09:23:41 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <anton.sirazetdinov@huawei.com>
Subject: [PATCH v6 17/17] samples/landlock: adds network demo
Date:   Tue, 21 Jun 2022 16:23:13 +0800
Message-ID: <20220621082313.3330667-18-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220621082313.3330667-1-konstantin.meskhidze@huawei.com>
References: <20220621082313.3330667-1-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.123.66.134]
X-ClientProxiedBy: mscpeml500001.china.huawei.com (7.188.26.142) To
 lhreml745-chm.china.huawei.com (10.201.108.195)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds network demo. It's possible to
allow a sandoxer to bind/connect to a list of
particular ports restricting networks actions to
the rest of ports.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v5:
* Makes network ports sandboxing optional.
* Fixes some logic errors.
* Formats code with clang-format-14.

Changes since v4:
* Adds ENV_TCP_BIND_NAME "LL_TCP_BIND" and
ENV_TCP_CONNECT_NAME "LL_TCP_CONNECT" variables
to insert TCP ports.
* Renames populate_ruleset() to populate_ruleset_fs().
* Adds populate_ruleset_net() and parse_port_num() helpers.
* Refactors main() to support network sandboxing.

---
 samples/landlock/sandboxer.c | 118 +++++++++++++++++++++++++++++++----
 1 file changed, 107 insertions(+), 11 deletions(-)

diff --git a/samples/landlock/sandboxer.c b/samples/landlock/sandboxer.c
index 3e404e51ec64..0606c676fded 100644
--- a/samples/landlock/sandboxer.c
+++ b/samples/landlock/sandboxer.c
@@ -51,6 +51,8 @@ static inline int landlock_restrict_self(const int ruleset_fd,

 #define ENV_FS_RO_NAME "LL_FS_RO"
 #define ENV_FS_RW_NAME "LL_FS_RW"
+#define ENV_TCP_BIND_NAME "LL_TCP_BIND"
+#define ENV_TCP_CONNECT_NAME "LL_TCP_CONNECT"
 #define ENV_PATH_TOKEN ":"

 static int parse_path(char *env_path, const char ***const path_list)
@@ -71,6 +73,20 @@ static int parse_path(char *env_path, const char ***const path_list)
 	return num_paths;
 }

+static int parse_port_num(char *env_port)
+{
+	int i, num_ports = 0;
+
+	if (env_port) {
+		num_ports++;
+		for (i = 0; env_port[i]; i++) {
+			if (env_port[i] == ENV_PATH_TOKEN[0])
+				num_ports++;
+		}
+	}
+	return num_ports;
+}
+
 /* clang-format off */

 #define ACCESS_FILE ( \
@@ -80,8 +96,8 @@ static int parse_path(char *env_path, const char ***const path_list)

 /* clang-format on */

-static int populate_ruleset(const char *const env_var, const int ruleset_fd,
-			    const __u64 allowed_access)
+static int populate_ruleset_fs(const char *const env_var, const int ruleset_fd,
+			       const __u64 allowed_access)
 {
 	int num_paths, i, ret = 1;
 	char *env_path_name;
@@ -142,6 +158,48 @@ static int populate_ruleset(const char *const env_var, const int ruleset_fd,
 	return ret;
 }

+static int populate_ruleset_net(const char *const env_var, const int ruleset_fd,
+				const __u64 allowed_access)
+{
+	int num_ports, i, ret = 1;
+	char *env_port_name;
+	struct landlock_net_service_attr net_service = {
+		.allowed_access = 0,
+		.port = 0,
+	};
+
+	env_port_name = getenv(env_var);
+	if (!env_port_name) {
+		ret = 0;
+		goto out_free_name;
+	}
+	env_port_name = strdup(env_port_name);
+	unsetenv(env_var);
+	num_ports = parse_port_num(env_port_name);
+
+	if (num_ports == 1 && (strtok(env_port_name, ENV_PATH_TOKEN) == NULL)) {
+		ret = 0;
+		goto out_free_name;
+	}
+
+	for (i = 0; i < num_ports; i++) {
+		net_service.allowed_access = allowed_access;
+		net_service.port = atoi(strsep(&env_port_name, ENV_PATH_TOKEN));
+		if (landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
+				      &net_service, 0)) {
+			fprintf(stderr,
+				"Failed to update the ruleset with port \"%d\": %s\n",
+				net_service.port, strerror(errno));
+			goto out_free_name;
+		}
+	}
+	ret = 0;
+
+out_free_name:
+	free(env_port_name);
+	return ret;
+}
+
 /* clang-format off */

 #define ACCESS_FS_ROUGHLY_READ ( \
@@ -172,32 +230,50 @@ int main(const int argc, char *const argv[], char *const *const envp)
 	const char *cmd_path;
 	char *const *cmd_argv;
 	int ruleset_fd, abi;
+	char *env_port_name;
 	__u64 access_fs_ro = ACCESS_FS_ROUGHLY_READ,
-	      access_fs_rw = ACCESS_FS_ROUGHLY_READ | ACCESS_FS_ROUGHLY_WRITE;
+	      access_fs_rw = ACCESS_FS_ROUGHLY_READ | ACCESS_FS_ROUGHLY_WRITE,
+	      access_net_tcp = 0;
 	struct landlock_ruleset_attr ruleset_attr = {
 		.handled_access_fs = access_fs_rw,
+		.handled_access_net = access_net_tcp,
 	};

 	if (argc < 2) {
 		fprintf(stderr,
-			"usage: %s=\"...\" %s=\"...\" %s <cmd> [args]...\n\n",
-			ENV_FS_RO_NAME, ENV_FS_RW_NAME, argv[0]);
+			"usage: %s=\"...\" %s=\"...\" %s=\"...\" %s=\"...\"%s "
+			"<cmd> [args]...\n\n",
+			ENV_FS_RO_NAME, ENV_FS_RW_NAME, ENV_TCP_BIND_NAME,
+			ENV_TCP_CONNECT_NAME, argv[0]);
 		fprintf(stderr,
 			"Launch a command in a restricted environment.\n\n");
-		fprintf(stderr, "Environment variables containing paths, "
-				"each separated by a colon:\n");
+		fprintf(stderr,
+			"Environment variables containing paths and ports "
+			"each separated by a colon:\n");
 		fprintf(stderr,
 			"* %s: list of paths allowed to be used in a read-only way.\n",
 			ENV_FS_RO_NAME);
 		fprintf(stderr,
-			"* %s: list of paths allowed to be used in a read-write way.\n",
+			"* %s: list of paths allowed to be used in a read-write way.\n\n",
 			ENV_FS_RW_NAME);
+		fprintf(stderr,
+			"Environment variables containing ports are optional "
+			"and could be skipped.\n");
+		fprintf(stderr,
+			"* %s: list of ports allowed to bind (server).\n",
+			ENV_TCP_BIND_NAME);
+		fprintf(stderr,
+			"* %s: list of ports allowed to connect (client).\n",
+			ENV_TCP_CONNECT_NAME);
 		fprintf(stderr,
 			"\nexample:\n"
 			"%s=\"/bin:/lib:/usr:/proc:/etc:/dev/urandom\" "
 			"%s=\"/dev/null:/dev/full:/dev/zero:/dev/pts:/tmp\" "
+			"%s=\"9418\" "
+			"%s=\"80:443\" "
 			"%s bash -i\n",
-			ENV_FS_RO_NAME, ENV_FS_RW_NAME, argv[0]);
+			ENV_FS_RO_NAME, ENV_FS_RW_NAME, ENV_TCP_BIND_NAME,
+			ENV_TCP_CONNECT_NAME, argv[0]);
 		return 1;
 	}

@@ -232,16 +308,36 @@ int main(const int argc, char *const argv[], char *const *const envp)
 		access_fs_rw &= ~ACCESS_ABI_2;
 	}

+	/* Adds optionally network bind() support. */
+	env_port_name = getenv(ENV_TCP_BIND_NAME);
+	if (env_port_name) {
+		access_net_tcp |= LANDLOCK_ACCESS_NET_BIND_TCP;
+	}
+	/* Adds optionally network connect() support. */
+	env_port_name = getenv(ENV_TCP_CONNECT_NAME);
+	if (env_port_name) {
+		access_net_tcp |= LANDLOCK_ACCESS_NET_CONNECT_TCP;
+	}
+	ruleset_attr.handled_access_net = access_net_tcp;
+
 	ruleset_fd =
 		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
 	if (ruleset_fd < 0) {
 		perror("Failed to create a ruleset");
 		return 1;
 	}
-	if (populate_ruleset(ENV_FS_RO_NAME, ruleset_fd, access_fs_ro)) {
+	if (populate_ruleset_fs(ENV_FS_RO_NAME, ruleset_fd, access_fs_ro)) {
+		goto err_close_ruleset;
+	}
+	if (populate_ruleset_fs(ENV_FS_RW_NAME, ruleset_fd, access_fs_rw)) {
+		goto err_close_ruleset;
+	}
+	if (populate_ruleset_net(ENV_TCP_BIND_NAME, ruleset_fd,
+				 LANDLOCK_ACCESS_NET_BIND_TCP)) {
 		goto err_close_ruleset;
 	}
-	if (populate_ruleset(ENV_FS_RW_NAME, ruleset_fd, access_fs_rw)) {
+	if (populate_ruleset_net(ENV_TCP_CONNECT_NAME, ruleset_fd,
+				 LANDLOCK_ACCESS_NET_CONNECT_TCP)) {
 		goto err_close_ruleset;
 	}
 	if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
--
2.25.1

