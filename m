Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3758A4CA4CE
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 13:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241764AbiCBMaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 07:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241763AbiCBMaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 07:30:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 373FA606EA
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 04:29:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646224175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TK/PLp8NRjtHNeiRL8eqfgmqBWGJDzDNksHCR5d0NHo=;
        b=XkiZJIJXPMswhUqHUjRri3+JTItpSQrnVHOedjGBE6ii8aIdULbt3pCDWxYpVm5JEzSYii
        +z/zrKWkI3b6hQx24J6JeuxKI0j5E9JnT+eV29nO3MP7ixSaceJIQkGXv5oRpxPz2iTt2l
        mrJdJPID5hYIrge0zD0GQ30uIZ/YClo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-428-jDrwvckPOoKoLgqxCCl8HQ-1; Wed, 02 Mar 2022 07:29:32 -0500
X-MC-Unique: jDrwvckPOoKoLgqxCCl8HQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E01E520E;
        Wed,  2 Mar 2022 12:29:31 +0000 (UTC)
Received: from tc2.redhat.com (unknown [10.39.192.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8283978344;
        Wed,  2 Mar 2022 12:29:29 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com,
        markzhang@nvidia.com, leonro@nvidia.com
Subject: [PATCH iproute2 v2 1/2] lib/fs: fix memory leak in get_task_name()
Date:   Wed,  2 Mar 2022 13:28:47 +0100
Message-Id: <0731f9e5b5ce95ab2da44ac74aa1f79ead9413bf.1646223467.git.aclaudi@redhat.com>
In-Reply-To: <cover.1646223467.git.aclaudi@redhat.com>
References: <cover.1646223467.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

asprintf() allocates memory which is not freed on the error path of
get_task_name(), thus potentially leading to memory leaks.

Rework get_task_name() and avoid asprintf() usage and memory allocation,
returning the task string to the caller using an additional char*
parameter.

Fixes: 81bfd01a4c9e ("lib: move get_task_name() from rdma")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 include/utils.h |  2 +-
 ip/iptuntap.c   | 17 ++++++++++-------
 lib/fs.c        | 20 ++++++++++----------
 rdma/res-cmid.c |  8 +++++---
 rdma/res-cq.c   |  8 +++++---
 rdma/res-ctx.c  |  7 ++++---
 rdma/res-mr.c   |  7 ++++---
 rdma/res-pd.c   |  8 +++++---
 rdma/res-qp.c   |  7 ++++---
 rdma/res-srq.c  |  7 ++++---
 rdma/stat.c     |  5 ++++-
 11 files changed, 56 insertions(+), 40 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index b6c468e9..81294488 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -307,7 +307,7 @@ char *find_cgroup2_mount(bool do_mount);
 __u64 get_cgroup2_id(const char *path);
 char *get_cgroup2_path(__u64 id, bool full);
 int get_command_name(const char *pid, char *comm, size_t len);
-char *get_task_name(pid_t pid);
+int get_task_name(pid_t pid, char *name);
 
 int get_rtnl_link_stats_rta(struct rtnl_link_stats64 *stats64,
 			    struct rtattr *tb[]);
diff --git a/ip/iptuntap.c b/ip/iptuntap.c
index 385d2bd8..2ae6b1a1 100644
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
+				if (get_task_name(pid, pname)) {
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
index f6f5f8a0..03df0f6a 100644
--- a/lib/fs.c
+++ b/lib/fs.c
@@ -342,25 +342,25 @@ int get_command_name(const char *pid, char *comm, size_t len)
 	return 0;
 }
 
-char *get_task_name(pid_t pid)
+int get_task_name(pid_t pid, char *name)
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
+	if (fscanf(f, "%s\n", name) != 1)
+		return -1;
 
 	fclose(f);
 
-	return comm;
+	return 0;
 }
diff --git a/rdma/res-cmid.c b/rdma/res-cmid.c
index bfaa47b5..3475349d 100644
--- a/rdma/res-cmid.c
+++ b/rdma/res-cmid.c
@@ -159,8 +159,11 @@ static int res_cm_id_line(struct rd *rd, const char *name, int idx,
 		goto out;
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
+		SPRINT_BUF(b);
+
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
-		comm = get_task_name(pid);
+		if (!get_task_name(pid, b))
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
index 9e7c4f51..5ed455ea 100644
--- a/rdma/res-cq.c
+++ b/rdma/res-cq.c
@@ -84,8 +84,11 @@ static int res_cq_line(struct rd *rd, const char *name, int idx,
 		goto out;
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
+		SPRINT_BUF(b);
+
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
-		comm = get_task_name(pid);
+		if (!get_task_name(pid, b))
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
index 30afe97a..fbd52dd5 100644
--- a/rdma/res-ctx.c
+++ b/rdma/res-ctx.c
@@ -18,8 +18,11 @@ static int res_ctx_line(struct rd *rd, const char *name, int idx,
 		return MNL_CB_ERROR;
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
+		SPRINT_BUF(b);
+
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
-		comm = get_task_name(pid);
+		if (!get_task_name(pid, b))
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
index 1bf73f3a..6a59d9e4 100644
--- a/rdma/res-mr.c
+++ b/rdma/res-mr.c
@@ -47,8 +47,11 @@ static int res_mr_line(struct rd *rd, const char *name, int idx,
 		goto out;
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
+		SPRINT_BUF(b);
+
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
-		comm = get_task_name(pid);
+		if (!get_task_name(pid, b))
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
index df538010..a51bb634 100644
--- a/rdma/res-pd.c
+++ b/rdma/res-pd.c
@@ -34,8 +34,11 @@ static int res_pd_line(struct rd *rd, const char *name, int idx,
 			nla_line[RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY]);
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
+		SPRINT_BUF(b);
+
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
-		comm = get_task_name(pid);
+		if (!get_task_name(pid, b))
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
index a38be399..575e0529 100644
--- a/rdma/res-qp.c
+++ b/rdma/res-qp.c
@@ -146,8 +146,11 @@ static int res_qp_line(struct rd *rd, const char *name, int idx,
 		goto out;
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
+		SPRINT_BUF(b);
+
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
-		comm = get_task_name(pid);
+		if (!get_task_name(pid, b))
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
index 3038c352..945109fc 100644
--- a/rdma/res-srq.c
+++ b/rdma/res-srq.c
@@ -174,8 +174,11 @@ static int res_srq_line(struct rd *rd, const char *name, int idx,
 		return MNL_CB_ERROR;
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
+		SPRINT_BUF(b);
+
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
-		comm = get_task_name(pid);
+		if (!get_task_name(pid, b))
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
index adfcd34a..a63b70a4 100644
--- a/rdma/stat.c
+++ b/rdma/stat.c
@@ -248,8 +248,11 @@ static int res_counter_line(struct rd *rd, const char *name, int index,
 		return MNL_CB_OK;
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
+		SPRINT_BUF(b);
+
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
-		comm = get_task_name(pid);
+		if (!get_task_name(pid, b))
+			comm = b;
 	}
 	if (rd_is_filtered_attr(rd, "pid", pid,
 				nla_line[RDMA_NLDEV_ATTR_RES_PID]))
-- 
2.35.1

