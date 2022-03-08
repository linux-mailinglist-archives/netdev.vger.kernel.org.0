Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6D74D1E1A
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 18:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245387AbiCHRGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 12:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbiCHRGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 12:06:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C89E7527C3
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 09:05:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646759124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nOCskAIRbM85KPSREva0eXxkb7vrbbLV9FnuykAxRyM=;
        b=aauo9Pvtzh6tVRRVzntILsBhWDhHAbsxWXsM+3fiSVnXj8g1DJ8p5CICHzpN/QqfgAtbi9
        jifXDYplH1wdAThgejKTvkW3RjratzInyUU+YAfXhWXGLSXsr3tWfBpj0OF1jhkCh/mTbW
        MgWsp7+rqiFKkbBCzlqMl1CHoPYZDao=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-yot6CuslOnuyhXojgKU25w-1; Tue, 08 Mar 2022 12:05:21 -0500
X-MC-Unique: yot6CuslOnuyhXojgKU25w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F861824FA8;
        Tue,  8 Mar 2022 17:05:20 +0000 (UTC)
Received: from tc2.redhat.com (unknown [10.39.195.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D311106D5BD;
        Tue,  8 Mar 2022 17:05:19 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com,
        markzhang@nvidia.com, leonro@nvidia.com
Subject: [PATCH iproute2 v3 1/2] lib/fs: fix memory leak in get_task_name()
Date:   Tue,  8 Mar 2022 18:04:56 +0100
Message-Id: <d35e7d5f30777c59930b95a59217b99ead86a9f2.1646750928.git.aclaudi@redhat.com>
In-Reply-To: <cover.1646750928.git.aclaudi@redhat.com>
References: <cover.1646750928.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

asprintf() allocates memory which is not freed on the error path of
get_task_name(), thus potentially leading to memory leaks.
%m specifier on fscanf allocates memory, too, which needs to be freed by
the caller.

This reworks get_task_name() to avoid memory allocation.
- Pass a buffer and its lenght to the function, similarly to what
  get_command_name() does, thus avoiding to allocate memory for
  the string to be returned;
- Use snprintf() instead of asprintf();
- Use fgets() instead of fscanf() to limit string lenght.

Fixes: 81bfd01a4c9e ("lib: move get_task_name() from rdma")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 include/utils.h |  2 +-
 ip/iptuntap.c   | 17 ++++++++++-------
 lib/fs.c        | 23 +++++++++++++----------
 rdma/res-cmid.c |  8 +++++---
 rdma/res-cq.c   |  8 +++++---
 rdma/res-ctx.c  |  7 ++++---
 rdma/res-mr.c   |  7 ++++---
 rdma/res-pd.c   |  8 +++++---
 rdma/res-qp.c   |  7 ++++---
 rdma/res-srq.c  |  7 ++++---
 rdma/stat.c     |  5 ++++-
 11 files changed, 59 insertions(+), 40 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index b6c468e9..b0e0967c 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -307,7 +307,7 @@ char *find_cgroup2_mount(bool do_mount);
 __u64 get_cgroup2_id(const char *path);
 char *get_cgroup2_path(__u64 id, bool full);
 int get_command_name(const char *pid, char *comm, size_t len);
-char *get_task_name(pid_t pid);
+int get_task_name(pid_t pid, char *name, size_t len);
 
 int get_rtnl_link_stats_rta(struct rtnl_link_stats64 *stats64,
 			    struct rtattr *tb[]);
diff --git a/ip/iptuntap.c b/ip/iptuntap.c
index 385d2bd8..35c9bf5b 100644
--- a/ip/iptuntap.c
+++ b/ip/iptuntap.c
@@ -321,14 +321,17 @@ static void show_processes(const char *name)
 			} else if (err == 2 &&
 				   !strcmp("iff", key) &&
 				   !strcmp(name, value)) {
-				char *pname = get_task_name(pid);
-
-				print_string(PRINT_ANY, "name",
-					     "%s", pname ? : "<NULL>");
+				SPRINT_BUF(pname);
+
+				if (get_task_name(pid, pname, sizeof(pname))) {
+					print_string(PRINT_ANY, "name",
+						     "%s", "<NULL>");
+				} else {
+					print_string(PRINT_ANY, "name",
+						     "%s", pname);
+				}
 
-				print_uint(PRINT_ANY, "pid",
-					   "(%d)", pid);
-				free(pname);
+				print_uint(PRINT_ANY, "pid", "(%d)", pid);
 			}
 
 			free(key);
diff --git a/lib/fs.c b/lib/fs.c
index f6f5f8a0..3752931c 100644
--- a/lib/fs.c
+++ b/lib/fs.c
@@ -342,25 +342,28 @@ int get_command_name(const char *pid, char *comm, size_t len)
 	return 0;
 }
 
-char *get_task_name(pid_t pid)
+int get_task_name(pid_t pid, char *name, size_t len)
 {
-	char *comm;
+	char path[PATH_MAX];
 	FILE *f;
 
 	if (!pid)
-		return NULL;
+		return -1;
 
-	if (asprintf(&comm, "/proc/%d/comm", pid) < 0)
-		return NULL;
+	if (snprintf(path, sizeof(path), "/proc/%d/comm", pid) >= sizeof(path))
+		return -1;
 
-	f = fopen(comm, "r");
+	f = fopen(path, "r");
 	if (!f)
-		return NULL;
+		return -1;
 
-	if (fscanf(f, "%ms\n", &comm) != 1)
-		comm = NULL;
+	if (!fgets(name, len, f))
+		return -1;
+
+	/* comm ends in \n, get rid of it */
+	name[strcspn(name, "\n")] = '\0';
 
 	fclose(f);
 
-	return comm;
+	return 0;
 }
diff --git a/rdma/res-cmid.c b/rdma/res-cmid.c
index fd57dbb7..b532d7f4 100644
--- a/rdma/res-cmid.c
+++ b/rdma/res-cmid.c
@@ -159,8 +159,11 @@ static int res_cm_id_line(struct rd *rd, const char *name, int idx,
 		goto out;
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
+		SPRINT_BUF(b);
+
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
-		comm = get_task_name(pid);
+		if (!get_task_name(pid, b, sizeof(b)))
+			comm = b;
 	}
 
 	if (rd_is_filtered_attr(rd, "pid", pid,
@@ -199,8 +202,7 @@ static int res_cm_id_line(struct rd *rd, const char *name, int idx,
 	print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
 	newline(rd);
 
-out:	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
-		free(comm);
+out:
 	return MNL_CB_OK;
 }
 
diff --git a/rdma/res-cq.c b/rdma/res-cq.c
index 818e1d0c..a4625afc 100644
--- a/rdma/res-cq.c
+++ b/rdma/res-cq.c
@@ -84,8 +84,11 @@ static int res_cq_line(struct rd *rd, const char *name, int idx,
 		goto out;
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
+		SPRINT_BUF(b);
+
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
-		comm = get_task_name(pid);
+		if (!get_task_name(pid, b, sizeof(b)))
+			comm = b;
 	}
 
 	if (rd_is_filtered_attr(rd, "pid", pid,
@@ -123,8 +126,7 @@ static int res_cq_line(struct rd *rd, const char *name, int idx,
 	print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
 	newline(rd);
 
-out:	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
-		free(comm);
+out:
 	return MNL_CB_OK;
 }
 
diff --git a/rdma/res-ctx.c b/rdma/res-ctx.c
index ea5faf18..79ecbf67 100644
--- a/rdma/res-ctx.c
+++ b/rdma/res-ctx.c
@@ -18,8 +18,11 @@ static int res_ctx_line(struct rd *rd, const char *name, int idx,
 		return MNL_CB_ERROR;
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
+		SPRINT_BUF(b);
+
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
-		comm = get_task_name(pid);
+		if (!get_task_name(pid, b, sizeof(b)))
+			comm = b;
 	}
 
 	if (rd_is_filtered_attr(rd, "pid", pid,
@@ -48,8 +51,6 @@ static int res_ctx_line(struct rd *rd, const char *name, int idx,
 	newline(rd);
 
 out:
-	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
-		free(comm);
 	return MNL_CB_OK;
 }
 
diff --git a/rdma/res-mr.c b/rdma/res-mr.c
index 25eaa056..7153a6fe 100644
--- a/rdma/res-mr.c
+++ b/rdma/res-mr.c
@@ -47,8 +47,11 @@ static int res_mr_line(struct rd *rd, const char *name, int idx,
 		goto out;
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
+		SPRINT_BUF(b);
+
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
-		comm = get_task_name(pid);
+		if (!get_task_name(pid, b, sizeof(b)))
+			comm = b;
 	}
 
 	if (rd_is_filtered_attr(rd, "pid", pid,
@@ -87,8 +90,6 @@ static int res_mr_line(struct rd *rd, const char *name, int idx,
 	newline(rd);
 
 out:
-	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
-		free(comm);
 	return MNL_CB_OK;
 }
 
diff --git a/rdma/res-pd.c b/rdma/res-pd.c
index 2932eb98..09c1040c 100644
--- a/rdma/res-pd.c
+++ b/rdma/res-pd.c
@@ -34,8 +34,11 @@ static int res_pd_line(struct rd *rd, const char *name, int idx,
 			nla_line[RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY]);
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
+		SPRINT_BUF(b);
+
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
-		comm = get_task_name(pid);
+		if (!get_task_name(pid, b, sizeof(b)))
+			comm = b;
 	}
 
 	if (rd_is_filtered_attr(rd, "pid", pid,
@@ -76,8 +79,7 @@ static int res_pd_line(struct rd *rd, const char *name, int idx,
 	print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
 	newline(rd);
 
-out:	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
-		free(comm);
+out:
 	return MNL_CB_OK;
 }
 
diff --git a/rdma/res-qp.c b/rdma/res-qp.c
index 9218804a..151accb9 100644
--- a/rdma/res-qp.c
+++ b/rdma/res-qp.c
@@ -146,8 +146,11 @@ static int res_qp_line(struct rd *rd, const char *name, int idx,
 		goto out;
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
+		SPRINT_BUF(b);
+
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
-		comm = get_task_name(pid);
+		if (!get_task_name(pid, b, sizeof(b)))
+			comm = b;
 	}
 
 	if (rd_is_filtered_attr(rd, "pid", pid,
@@ -179,8 +182,6 @@ static int res_qp_line(struct rd *rd, const char *name, int idx,
 	print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
 	newline(rd);
 out:
-	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
-		free(comm);
 	return MNL_CB_OK;
 }
 
diff --git a/rdma/res-srq.c b/rdma/res-srq.c
index c6df454a..f3a652d8 100644
--- a/rdma/res-srq.c
+++ b/rdma/res-srq.c
@@ -174,8 +174,11 @@ static int res_srq_line(struct rd *rd, const char *name, int idx,
 		return MNL_CB_ERROR;
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
+		SPRINT_BUF(b);
+
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
-		comm = get_task_name(pid);
+		if (!get_task_name(pid, b, sizeof(b)))
+			comm = b;
 	}
 	if (rd_is_filtered_attr(rd, "pid", pid,
 				nla_line[RDMA_NLDEV_ATTR_RES_PID]))
@@ -228,8 +231,6 @@ static int res_srq_line(struct rd *rd, const char *name, int idx,
 	newline(rd);
 
 out:
-	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
-		free(comm);
 	return MNL_CB_OK;
 }
 
diff --git a/rdma/stat.c b/rdma/stat.c
index c7da2922..ab062915 100644
--- a/rdma/stat.c
+++ b/rdma/stat.c
@@ -248,8 +248,11 @@ static int res_counter_line(struct rd *rd, const char *name, int index,
 		return MNL_CB_OK;
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
+		SPRINT_BUF(b);
+
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
-		comm = get_task_name(pid);
+		if (!get_task_name(pid, b, sizeof(b)))
+			comm = b;
 	}
 	if (rd_is_filtered_attr(rd, "pid", pid,
 				nla_line[RDMA_NLDEV_ATTR_RES_PID]))
-- 
2.35.1

