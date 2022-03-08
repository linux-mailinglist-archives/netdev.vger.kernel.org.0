Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C475D4D1E19
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 18:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245427AbiCHRGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 12:06:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbiCHRGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 12:06:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2946D51E6C
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 09:05:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646759126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Eb537rFmNRoZp5/QSBrSHOZog53+5ygqrbOGl/RqEN8=;
        b=crgS3N3eHi+2y1hGegqDy0B0ol4yhq/u2Opv9YSL6GX7YttMYvd4ZyNVOr06j6uFn5BuRR
        zgbjr8g5KlgWj8tZPp8RG+dTTW1+bvhPUZZE7SY0Zgs6BwT1smFxq3y7210AbxJbhlfdmK
        bhxu7ZRs3vdpRRcjQ45EXybE+Dzz/m4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-303-L5w3OTaUPj26_nv2TXXXIw-1; Tue, 08 Mar 2022 12:05:23 -0500
X-MC-Unique: L5w3OTaUPj26_nv2TXXXIw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3558501E0;
        Tue,  8 Mar 2022 17:05:21 +0000 (UTC)
Received: from tc2.redhat.com (unknown [10.39.195.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC019106F774;
        Tue,  8 Mar 2022 17:05:20 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com,
        markzhang@nvidia.com, leonro@nvidia.com
Subject: [PATCH iproute2 v3 2/2] rdma: make RES_PID and RES_KERN_NAME alternative to each other
Date:   Tue,  8 Mar 2022 18:04:57 +0100
Message-Id: <848836737af45858e3d4d3f48fb47e84e79cc105.1646750928.git.aclaudi@redhat.com>
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

RDMA_NLDEV_ATTR_RES_PID and RDMA_NLDEV_ATTR_RES_KERN_NAME cannot be set
together, as evident for the fill_res_name_pid() function in the kernel
infiniband driver. This commit makes this clear at first glance, using
an else branch for the RDMA_NLDEV_ATTR_RES_KERN_NAME case.

This also helps coverity to better understand this code and avoid
producing a bogus warning complaining about mnl_attr_get_str overwriting
comme, and thus leaking the storage that comm points to.

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 rdma/res-cmid.c | 10 ++++------
 rdma/res-cq.c   |  9 ++++-----
 rdma/res-ctx.c  |  9 ++++-----
 rdma/res-mr.c   |  8 ++++----
 rdma/res-pd.c   |  9 ++++-----
 rdma/res-qp.c   |  9 ++++-----
 rdma/res-srq.c  | 10 +++++-----
 rdma/stat.c     |  9 +++++----
 8 files changed, 34 insertions(+), 39 deletions(-)

diff --git a/rdma/res-cmid.c b/rdma/res-cmid.c
index b532d7f4..7371c3a6 100644
--- a/rdma/res-cmid.c
+++ b/rdma/res-cmid.c
@@ -164,6 +164,10 @@ static int res_cm_id_line(struct rd *rd, const char *name, int idx,
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 		if (!get_task_name(pid, b, sizeof(b)))
 			comm = b;
+	} else if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]) {
+		/* discard const from mnl_attr_get_str */
+		comm = (char *)mnl_attr_get_str(
+			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
 	}
 
 	if (rd_is_filtered_attr(rd, "pid", pid,
@@ -176,12 +180,6 @@ static int res_cm_id_line(struct rd *rd, const char *name, int idx,
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
 	res_print_u32(rd, "cm-idn", cm_idn,
diff --git a/rdma/res-cq.c b/rdma/res-cq.c
index a4625afc..2cfa4994 100644
--- a/rdma/res-cq.c
+++ b/rdma/res-cq.c
@@ -89,6 +89,10 @@ static int res_cq_line(struct rd *rd, const char *name, int idx,
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 		if (!get_task_name(pid, b, sizeof(b)))
 			comm = b;
+	} else if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]) {
+		/* discard const from mnl_attr_get_str */
+		comm = (char *)mnl_attr_get_str(
+			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
 	}
 
 	if (rd_is_filtered_attr(rd, "pid", pid,
@@ -106,11 +110,6 @@ static int res_cq_line(struct rd *rd, const char *name, int idx,
 				nla_line[RDMA_NLDEV_ATTR_RES_CTXN]))
 		goto out;
 
-	if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
-		/* discard const from mnl_attr_get_str */
-		comm = (char *)mnl_attr_get_str(
-			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
-
 	open_json_object(NULL);
 	print_dev(rd, idx, name);
 	res_print_u32(rd, "cqn", cqn, nla_line[RDMA_NLDEV_ATTR_RES_CQN]);
diff --git a/rdma/res-ctx.c b/rdma/res-ctx.c
index 79ecbf67..500186d9 100644
--- a/rdma/res-ctx.c
+++ b/rdma/res-ctx.c
@@ -23,6 +23,10 @@ static int res_ctx_line(struct rd *rd, const char *name, int idx,
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 		if (!get_task_name(pid, b, sizeof(b)))
 			comm = b;
+	} else if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]) {
+		/* discard const from mnl_attr_get_str */
+		comm = (char *)mnl_attr_get_str(
+			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
 	}
 
 	if (rd_is_filtered_attr(rd, "pid", pid,
@@ -36,11 +40,6 @@ static int res_ctx_line(struct rd *rd, const char *name, int idx,
 				nla_line[RDMA_NLDEV_ATTR_RES_CTXN]))
 		goto out;
 
-	if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
-		/* discard const from mnl_attr_get_str */
-		comm = (char *)mnl_attr_get_str(
-			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
-
 	open_json_object(NULL);
 	print_dev(rd, idx, name);
 	res_print_u32(rd, "ctxn", ctxn, nla_line[RDMA_NLDEV_ATTR_RES_CTXN]);
diff --git a/rdma/res-mr.c b/rdma/res-mr.c
index 7153a6fe..fb48d5df 100644
--- a/rdma/res-mr.c
+++ b/rdma/res-mr.c
@@ -52,6 +52,10 @@ static int res_mr_line(struct rd *rd, const char *name, int idx,
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 		if (!get_task_name(pid, b, sizeof(b)))
 			comm = b;
+	} else if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]) {
+		/* discard const from mnl_attr_get_str */
+		comm = (char *)mnl_attr_get_str(
+			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
 	}
 
 	if (rd_is_filtered_attr(rd, "pid", pid,
@@ -70,10 +74,6 @@ static int res_mr_line(struct rd *rd, const char *name, int idx,
 				nla_line[RDMA_NLDEV_ATTR_RES_PDN]))
 		goto out;
 
-	if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
-		/* discard const from mnl_attr_get_str */
-		comm = (char *)mnl_attr_get_str(
-			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
 	open_json_object(NULL);
 	print_dev(rd, idx, name);
 	res_print_u32(rd, "mrn", mrn, nla_line[RDMA_NLDEV_ATTR_RES_MRN]);
diff --git a/rdma/res-pd.c b/rdma/res-pd.c
index 09c1040c..66f91f42 100644
--- a/rdma/res-pd.c
+++ b/rdma/res-pd.c
@@ -39,6 +39,10 @@ static int res_pd_line(struct rd *rd, const char *name, int idx,
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 		if (!get_task_name(pid, b, sizeof(b)))
 			comm = b;
+	} else if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]) {
+		/* discard const from mnl_attr_get_str */
+		comm = (char *)mnl_attr_get_str(
+			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
 	}
 
 	if (rd_is_filtered_attr(rd, "pid", pid,
@@ -58,11 +62,6 @@ static int res_pd_line(struct rd *rd, const char *name, int idx,
 				nla_line[RDMA_NLDEV_ATTR_RES_PDN]))
 		goto out;
 
-	if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
-		/* discard const from mnl_attr_get_str */
-		comm = (char *)mnl_attr_get_str(
-			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
-
 	open_json_object(NULL);
 	print_dev(rd, idx, name);
 	res_print_u32(rd, "pdn", pdn, nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
diff --git a/rdma/res-qp.c b/rdma/res-qp.c
index 151accb9..c180a97e 100644
--- a/rdma/res-qp.c
+++ b/rdma/res-qp.c
@@ -151,17 +151,16 @@ static int res_qp_line(struct rd *rd, const char *name, int idx,
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 		if (!get_task_name(pid, b, sizeof(b)))
 			comm = b;
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
 	res_print_u32(rd, "lqpn", lqpn, nla_line[RDMA_NLDEV_ATTR_RES_LQPN]);
diff --git a/rdma/res-srq.c b/rdma/res-srq.c
index f3a652d8..186ae281 100644
--- a/rdma/res-srq.c
+++ b/rdma/res-srq.c
@@ -179,7 +179,12 @@ static int res_srq_line(struct rd *rd, const char *name, int idx,
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 		if (!get_task_name(pid, b, sizeof(b)))
 			comm = b;
+	} else if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]) {
+		/* discard const from mnl_attr_get_str */
+		comm = (char *)mnl_attr_get_str(
+			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
 	}
+
 	if (rd_is_filtered_attr(rd, "pid", pid,
 				nla_line[RDMA_NLDEV_ATTR_RES_PID]))
 		goto out;
@@ -212,11 +217,6 @@ static int res_srq_line(struct rd *rd, const char *name, int idx,
 			MNL_CB_OK)
 		goto out;
 
-	if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
-		/* discard const from mnl_attr_get_str */
-		comm = (char *)mnl_attr_get_str(
-			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
-
 	open_json_object(NULL);
 	print_dev(rd, idx, name);
 	res_print_u32(rd, "srqn", srqn, nla_line[RDMA_NLDEV_ATTR_RES_SRQN]);
diff --git a/rdma/stat.c b/rdma/stat.c
index ab062915..aad8815c 100644
--- a/rdma/stat.c
+++ b/rdma/stat.c
@@ -253,15 +253,16 @@ static int res_counter_line(struct rd *rd, const char *name, int index,
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 		if (!get_task_name(pid, b, sizeof(b)))
 			comm = b;
+	} else if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]) {
+		/* discard const from mnl_attr_get_str */
+		comm = (char *)mnl_attr_get_str(
+			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
 	}
+
 	if (rd_is_filtered_attr(rd, "pid", pid,
 				nla_line[RDMA_NLDEV_ATTR_RES_PID]))
 		return MNL_CB_OK;
 
-	if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
-		comm = (char *)mnl_attr_get_str(
-			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
-
 	mnl_attr_for_each_nested(nla_entry, qp_table) {
 		struct nlattr *qp_line[RDMA_NLDEV_ATTR_MAX] = {};
 
-- 
2.35.1

