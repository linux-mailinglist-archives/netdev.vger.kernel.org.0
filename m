Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88FFE364509
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 15:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242318AbhDSNib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 09:38:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41399 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241223AbhDSNhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 09:37:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618839410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+SZaind4Xo4ieCY4t6ykQvIHQLnqWhKgHsfrdxtloQI=;
        b=UKP6z8Q0qJuUj/OR2gyJ2Sr3EcHAzrX2VbOrC2Dxp4x8mA6B5IY3L7UWiGOu+MPqs5aaEP
        WcJnpjWhGgIP7r89PtWjgIaJRGmXglhjRoKzwvm3ZYaVA6fIYD84xOgNE6D4QK383VIMDL
        pDlXaFhmevx8JevFV4Wco8I2mzAdrlo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-8azdJAE-Ov-sFNL4eU_M_Q-1; Mon, 19 Apr 2021 09:36:48 -0400
X-MC-Unique: 8azdJAE-Ov-sFNL4eU_M_Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3266D107ACF8;
        Mon, 19 Apr 2021 13:36:47 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-159.ams2.redhat.com [10.36.112.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 43451610F1;
        Mon, 19 Apr 2021 13:36:46 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2] lib: move get_task_name() from rdma
Date:   Mon, 19 Apr 2021 15:34:58 +0200
Message-Id: <a41d23aa24bbe5b4acfc2465feca582c6e355e0d.1618839246.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function get_task_name() is used to get the name of a process from
its pid, and its implementation is similar to ip/iptuntap.c:pid_name().

Move it to lib/fs.c to use a single implementation and make it easily
reusable.

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 include/utils.h |  1 +
 ip/iptuntap.c   | 31 +------------------------------
 lib/fs.c        | 24 ++++++++++++++++++++++++
 rdma/res.c      | 24 ------------------------
 rdma/res.h      |  1 -
 5 files changed, 26 insertions(+), 55 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index b29c3798..187444d5 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -308,6 +308,7 @@ char *find_cgroup2_mount(bool do_mount);
 __u64 get_cgroup2_id(const char *path);
 char *get_cgroup2_path(__u64 id, bool full);
 int get_command_name(const char *pid, char *comm, size_t len);
+char *get_task_name(pid_t pid);
 
 int get_rtnl_link_stats_rta(struct rtnl_link_stats64 *stats64,
 			    struct rtattr *tb[]);
diff --git a/ip/iptuntap.c b/ip/iptuntap.c
index e9cc7c0f..9cdb4a80 100644
--- a/ip/iptuntap.c
+++ b/ip/iptuntap.c
@@ -260,35 +260,6 @@ static void print_flags(long flags)
 	close_json_array(PRINT_JSON, NULL);
 }
 
-static char *pid_name(pid_t pid)
-{
-	char *comm;
-	FILE *f;
-	int err;
-
-	err = asprintf(&comm, "/proc/%d/comm", pid);
-	if (err < 0)
-		return NULL;
-
-	f = fopen(comm, "r");
-	free(comm);
-	if (!f) {
-		perror("fopen");
-		return NULL;
-	}
-
-	if (fscanf(f, "%ms\n", &comm) != 1) {
-		perror("fscanf");
-		comm = NULL;
-	}
-
-
-	if (fclose(f))
-		perror("fclose");
-
-	return comm;
-}
-
 static void show_processes(const char *name)
 {
 	glob_t globbuf = { };
@@ -346,7 +317,7 @@ static void show_processes(const char *name)
 			} else if (err == 2 &&
 				   !strcmp("iff", key) &&
 				   !strcmp(name, value)) {
-				char *pname = pid_name(pid);
+				char *pname = get_task_name(pid);
 
 				print_string(PRINT_ANY, "name",
 					     "%s", pname ? : "<NULL>");
diff --git a/lib/fs.c b/lib/fs.c
index ee0b130b..f161d888 100644
--- a/lib/fs.c
+++ b/lib/fs.c
@@ -316,3 +316,27 @@ int get_command_name(const char *pid, char *comm, size_t len)
 
 	return 0;
 }
+
+char *get_task_name(pid_t pid)
+{
+	char *comm;
+	FILE *f;
+
+	if (!pid)
+		return NULL;
+
+	if (asprintf(&comm, "/proc/%d/comm", pid) < 0)
+		return NULL;
+
+	f = fopen(comm, "r");
+	if (!f)
+		return NULL;
+
+	if (fscanf(f, "%ms\n", &comm) != 1)
+		comm = NULL;
+
+	fclose(f);
+
+	return comm;
+}
+
diff --git a/rdma/res.c b/rdma/res.c
index dc12bbe4..f42ae938 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -195,30 +195,6 @@ void print_qp_type(struct rd *rd, uint32_t val)
 			   qp_types_to_str(val));
 }
 
-char *get_task_name(uint32_t pid)
-{
-	char *comm;
-	FILE *f;
-
-	if (!pid)
-		return NULL;
-
-	if (asprintf(&comm, "/proc/%d/comm", pid) < 0)
-		return NULL;
-
-	f = fopen(comm, "r");
-	free(comm);
-	if (!f)
-		return NULL;
-
-	if (fscanf(f, "%ms\n", &comm) != 1)
-		comm = NULL;
-
-	fclose(f);
-
-	return comm;
-}
-
 void print_key(struct rd *rd, const char *name, uint64_t val,
 	       struct nlattr *nlattr)
 {
diff --git a/rdma/res.h b/rdma/res.h
index 707941da..e8bd02e4 100644
--- a/rdma/res.h
+++ b/rdma/res.h
@@ -155,7 +155,6 @@ filters qp_valid_filters[MAX_NUMBER_OF_FILTERS] = {
 RES_FUNC(res_qp, RDMA_NLDEV_CMD_RES_QP_GET, qp_valid_filters, false,
 	 RDMA_NLDEV_ATTR_RES_LQPN);
 
-char *get_task_name(uint32_t pid);
 void print_dev(struct rd *rd, uint32_t idx, const char *name);
 void print_link(struct rd *rd, uint32_t idx, const char *name, uint32_t port,
 		struct nlattr **nla_line);
-- 
2.30.2

