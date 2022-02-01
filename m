Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 295314A62AE
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 18:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241586AbiBARkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 12:40:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23378 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233255AbiBARkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 12:40:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643737216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qnU4vUxo8x+y3ebRuIiqy3FjsThYYN89Ijsumv5mldg=;
        b=i41bZJZBKbPGq5OA8X8DyO/ewaGUehd7SYpK3BPis9otDhiNXmBKmPN1y6lxcsINErHq5E
        yJ2OtT5EiI4UTBneIAWuyzhEiC51AG9CtkMd+tAxJXjIpi/wrOGpLDp58ATTdNiMkboERi
        QAp3o6zaRBUrg7KXku06WlFLWQOLSKk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-NYnMn5wuPpGJJHedICm3xw-1; Tue, 01 Feb 2022 12:40:13 -0500
X-MC-Unique: NYnMn5wuPpGJJHedICm3xw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A876793934;
        Tue,  1 Feb 2022 17:39:56 +0000 (UTC)
Received: from tc2.redhat.com (unknown [10.39.195.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 80B14D1907;
        Tue,  1 Feb 2022 17:39:55 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com,
        markzhang@nvidia.com, leonro@nvidia.com
Subject: [PATCH iproute2 3/3] rdma: RES_PID and RES_KERN_NAME are alternatives to each other
Date:   Tue,  1 Feb 2022 18:39:26 +0100
Message-Id: <d603407d01a58b23a4cf69b14ca4e9668145ac68.1643736038.git.aclaudi@redhat.com>
In-Reply-To: <cover.1643736038.git.aclaudi@redhat.com>
References: <cover.1643736038.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RDMA_NLDEV_ATTR_RES_PID and RDMA_NLDEV_ATTR_RES_KERN_NAME cannot be set
together, as evident from the fill_res_name_pid() function in the kernel
infiniband driver. This commit makes this clear at first glance, using
an else branch for RDMA_NLDEV_ATTR_RES_KERN_NAME.

This also helps coverity to better understand this code and avoid
producing a bogus warning complaining about mnl_attr_get_str overwriting
comm, and thus leaking the storage that comm points to.

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 rdma/res-cmid.c | 10 ++++------
 rdma/res-cq.c   |  9 ++++-----
 rdma/res-ctx.c  |  9 ++++-----
 rdma/res-mr.c   |  8 ++++----
 rdma/res-pd.c   |  9 ++++-----
 rdma/res-qp.c   |  9 ++++-----
 rdma/res-srq.c  | 10 +++++-----
 rdma/stat.c     | 11 +++++------
 8 files changed, 34 insertions(+), 41 deletions(-)

diff --git a/rdma/res-cmid.c b/rdma/res-cmid.c
index bfaa47b5..21bdabca 100644
--- a/rdma/res-cmid.c
+++ b/rdma/res-cmid.c
@@ -161,6 +161,10 @@ static int res_cm_id_line(struct rd *rd, const char *name, int idx,
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 		comm = get_task_name(pid);
+	} else if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]) {
+		/* discard const from mnl_attr_get_str */
+		comm = (char *)mnl_attr_get_str(
+			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
 	}
 
 	if (rd_is_filtered_attr(rd, "pid", pid,
@@ -173,12 +177,6 @@ static int res_cm_id_line(struct rd *rd, const char *name, int idx,
 				nla_line[RDMA_NLDEV_ATTR_RES_CM_IDN]))
 		goto out;
 
-	if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]) {
-		/* discard const from mnl_attr_get_str */
-		comm = (char *)mnl_attr_get_str(
-			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
-	}
-
 	open_json_object(NULL);
 	print_link(rd, idx, name, port, nla_line);
 	res_print_uint(rd, "cm-idn", cm_idn,
diff --git a/rdma/res-cq.c b/rdma/res-cq.c
index 9e7c4f51..0ba19447 100644
--- a/rdma/res-cq.c
+++ b/rdma/res-cq.c
@@ -86,6 +86,10 @@ static int res_cq_line(struct rd *rd, const char *name, int idx,
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 		comm = get_task_name(pid);
+	} else if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]) {
+		/* discard const from mnl_attr_get_str */
+		comm = (char *)mnl_attr_get_str(
+			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
 	}
 
 	if (rd_is_filtered_attr(rd, "pid", pid,
@@ -103,11 +107,6 @@ static int res_cq_line(struct rd *rd, const char *name, int idx,
 				nla_line[RDMA_NLDEV_ATTR_RES_CTXN]))
 		goto out;
 
-	if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
-		/* discard const from mnl_attr_get_str */
-		comm = (char *)mnl_attr_get_str(
-			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
-
 	open_json_object(NULL);
 	print_dev(rd, idx, name);
 	res_print_uint(rd, "cqn", cqn, nla_line[RDMA_NLDEV_ATTR_RES_CQN]);
diff --git a/rdma/res-ctx.c b/rdma/res-ctx.c
index 30afe97a..895598d8 100644
--- a/rdma/res-ctx.c
+++ b/rdma/res-ctx.c
@@ -20,6 +20,10 @@ static int res_ctx_line(struct rd *rd, const char *name, int idx,
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 		comm = get_task_name(pid);
+	} else if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]) {
+		/* discard const from mnl_attr_get_str */
+		comm = (char *)mnl_attr_get_str(
+			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
 	}
 
 	if (rd_is_filtered_attr(rd, "pid", pid,
@@ -33,11 +37,6 @@ static int res_ctx_line(struct rd *rd, const char *name, int idx,
 				nla_line[RDMA_NLDEV_ATTR_RES_CTXN]))
 		goto out;
 
-	if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
-		/* discard const from mnl_attr_get_str */
-		comm = (char *)mnl_attr_get_str(
-			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
-
 	open_json_object(NULL);
 	print_dev(rd, idx, name);
 	res_print_uint(rd, "ctxn", ctxn, nla_line[RDMA_NLDEV_ATTR_RES_CTXN]);
diff --git a/rdma/res-mr.c b/rdma/res-mr.c
index 1bf73f3a..9ae6c777 100644
--- a/rdma/res-mr.c
+++ b/rdma/res-mr.c
@@ -49,6 +49,10 @@ static int res_mr_line(struct rd *rd, const char *name, int idx,
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 		comm = get_task_name(pid);
+	} else if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]) {
+		/* discard const from mnl_attr_get_str */
+		comm = (char *)mnl_attr_get_str(
+			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
 	}
 
 	if (rd_is_filtered_attr(rd, "pid", pid,
@@ -67,10 +71,6 @@ static int res_mr_line(struct rd *rd, const char *name, int idx,
 				nla_line[RDMA_NLDEV_ATTR_RES_PDN]))
 		goto out;
 
-	if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
-		/* discard const from mnl_attr_get_str */
-		comm = (char *)mnl_attr_get_str(
-			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
 	open_json_object(NULL);
 	print_dev(rd, idx, name);
 	res_print_uint(rd, "mrn", mrn, nla_line[RDMA_NLDEV_ATTR_RES_MRN]);
diff --git a/rdma/res-pd.c b/rdma/res-pd.c
index df538010..aca2b0cc 100644
--- a/rdma/res-pd.c
+++ b/rdma/res-pd.c
@@ -36,6 +36,10 @@ static int res_pd_line(struct rd *rd, const char *name, int idx,
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 		comm = get_task_name(pid);
+	} else if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]) {
+		/* discard const from mnl_attr_get_str */
+		comm = (char *)mnl_attr_get_str(
+			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
 	}
 
 	if (rd_is_filtered_attr(rd, "pid", pid,
@@ -55,11 +59,6 @@ static int res_pd_line(struct rd *rd, const char *name, int idx,
 				nla_line[RDMA_NLDEV_ATTR_RES_PDN]))
 		goto out;
 
-	if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
-		/* discard const from mnl_attr_get_str */
-		comm = (char *)mnl_attr_get_str(
-			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
-
 	open_json_object(NULL);
 	print_dev(rd, idx, name);
 	res_print_uint(rd, "pdn", pdn, nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
diff --git a/rdma/res-qp.c b/rdma/res-qp.c
index a38be399..76a5334f 100644
--- a/rdma/res-qp.c
+++ b/rdma/res-qp.c
@@ -148,17 +148,16 @@ static int res_qp_line(struct rd *rd, const char *name, int idx,
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 		comm = get_task_name(pid);
+	} else if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]) {
+		/* discard const from mnl_attr_get_str */
+		comm = (char *)mnl_attr_get_str(
+			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
 	}
 
 	if (rd_is_filtered_attr(rd, "pid", pid,
 				nla_line[RDMA_NLDEV_ATTR_RES_PID]))
 		goto out;
 
-	if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
-		/* discard const from mnl_attr_get_str */
-		comm = (char *)mnl_attr_get_str(
-			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
-
 	open_json_object(NULL);
 	print_link(rd, idx, name, port, nla_line);
 	res_print_uint(rd, "lqpn", lqpn, nla_line[RDMA_NLDEV_ATTR_RES_LQPN]);
diff --git a/rdma/res-srq.c b/rdma/res-srq.c
index 3038c352..982e3fe9 100644
--- a/rdma/res-srq.c
+++ b/rdma/res-srq.c
@@ -176,7 +176,12 @@ static int res_srq_line(struct rd *rd, const char *name, int idx,
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 		comm = get_task_name(pid);
+	} else if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]) {
+		/* discard const from mnl_attr_get_str */
+		comm = (char *)mnl_attr_get_str(
+			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
 	}
+
 	if (rd_is_filtered_attr(rd, "pid", pid,
 				nla_line[RDMA_NLDEV_ATTR_RES_PID]))
 		goto out;
@@ -209,11 +214,6 @@ static int res_srq_line(struct rd *rd, const char *name, int idx,
 			MNL_CB_OK)
 		goto out;
 
-	if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
-		/* discard const from mnl_attr_get_str */
-		comm = (char *)mnl_attr_get_str(
-			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
-
 	open_json_object(NULL);
 	print_dev(rd, idx, name);
 	res_print_uint(rd, "srqn", srqn, nla_line[RDMA_NLDEV_ATTR_RES_SRQN]);
diff --git a/rdma/stat.c b/rdma/stat.c
index 66121b12..cf2c705b 100644
--- a/rdma/stat.c
+++ b/rdma/stat.c
@@ -256,19 +256,18 @@ static int res_counter_line(struct rd *rd, const char *name, int index,
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 		comm = get_task_name(pid);
+	} else if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]) {
+		/* discard const from mnl_attr_get_str */
+		comm = (char *)mnl_attr_get_str(
+			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
 	}
+
 	if (rd_is_filtered_attr(rd, "pid", pid,
 				nla_line[RDMA_NLDEV_ATTR_RES_PID])) {
 		ret = MNL_CB_OK;
 		goto out;
 	}
 
-	if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]) {
-		/* discard const from mnl_attr_get_str */
-		comm = (char *)mnl_attr_get_str(
-			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
-	}
-
 	mnl_attr_for_each_nested(nla_entry, qp_table) {
 		struct nlattr *qp_line[RDMA_NLDEV_ATTR_MAX] = {};
 
-- 
2.34.1

