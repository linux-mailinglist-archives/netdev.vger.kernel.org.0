Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 737214CA4CF
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 13:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241767AbiCBMaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 07:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241763AbiCBMaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 07:30:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5FD3F6007B
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 04:29:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646224178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=COepOcpxDS3o2xiTxzCatt0VV4c2oydjW2H5jz6pKfQ=;
        b=LLSLkigaNI66YmeKoYGb2uPGdWYD9OzfMj0yxpbSW1eW3ERAQ38BAjOUc/hGkTG8WgjeaW
        XOhr4FeB8+8/heBmW67GGeVFoCKj+d7VYUO8KAgw0S4+8NDA8e8lRvK7XE3LQl7F7ZCiMi
        xo2aMT6owlTwI4WJGYPbY3ctqPL+hzs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-kyL5sIb6NHKgc5Tee2EYYQ-1; Wed, 02 Mar 2022 07:29:35 -0500
X-MC-Unique: kyL5sIb6NHKgc5Tee2EYYQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4873D520F;
        Wed,  2 Mar 2022 12:29:34 +0000 (UTC)
Received: from tc2.redhat.com (unknown [10.39.192.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BD6678344;
        Wed,  2 Mar 2022 12:29:32 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com,
        markzhang@nvidia.com, leonro@nvidia.com
Subject: [PATCH iproute2 v2 2/2] rdma: make RES_PID and RES_KERN_NAME alternative to each other
Date:   Wed,  2 Mar 2022 13:28:48 +0100
Message-Id: <d7e811bf3ed10d970608356643b0c6dd1a5ec91b.1646223467.git.aclaudi@redhat.com>
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
index 3475349d..3abc5b42 100644
--- a/rdma/res-cmid.c
+++ b/rdma/res-cmid.c
@@ -164,6 +164,10 @@ static int res_cm_id_line(struct rd *rd, const char *name, int idx,
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 		if (!get_task_name(pid, b))
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
 	res_print_uint(rd, "cm-idn", cm_idn,
diff --git a/rdma/res-cq.c b/rdma/res-cq.c
index 5ed455ea..e691f21f 100644
--- a/rdma/res-cq.c
+++ b/rdma/res-cq.c
@@ -89,6 +89,10 @@ static int res_cq_line(struct rd *rd, const char *name, int idx,
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 		if (!get_task_name(pid, b))
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
 	res_print_uint(rd, "cqn", cqn, nla_line[RDMA_NLDEV_ATTR_RES_CQN]);
diff --git a/rdma/res-ctx.c b/rdma/res-ctx.c
index fbd52dd5..e300f605 100644
--- a/rdma/res-ctx.c
+++ b/rdma/res-ctx.c
@@ -23,6 +23,10 @@ static int res_ctx_line(struct rd *rd, const char *name, int idx,
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 		if (!get_task_name(pid, b))
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
 	res_print_uint(rd, "ctxn", ctxn, nla_line[RDMA_NLDEV_ATTR_RES_CTXN]);
diff --git a/rdma/res-mr.c b/rdma/res-mr.c
index 6a59d9e4..f3a86cac 100644
--- a/rdma/res-mr.c
+++ b/rdma/res-mr.c
@@ -52,6 +52,10 @@ static int res_mr_line(struct rd *rd, const char *name, int idx,
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 		if (!get_task_name(pid, b))
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
 	res_print_uint(rd, "mrn", mrn, nla_line[RDMA_NLDEV_ATTR_RES_MRN]);
diff --git a/rdma/res-pd.c b/rdma/res-pd.c
index a51bb634..7ab3ac6b 100644
--- a/rdma/res-pd.c
+++ b/rdma/res-pd.c
@@ -39,6 +39,10 @@ static int res_pd_line(struct rd *rd, const char *name, int idx,
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 		if (!get_task_name(pid, b))
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
 	res_print_uint(rd, "pdn", pdn, nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
diff --git a/rdma/res-qp.c b/rdma/res-qp.c
index 575e0529..d15522e8 100644
--- a/rdma/res-qp.c
+++ b/rdma/res-qp.c
@@ -151,17 +151,16 @@ static int res_qp_line(struct rd *rd, const char *name, int idx,
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 		if (!get_task_name(pid, b))
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
 	res_print_uint(rd, "lqpn", lqpn, nla_line[RDMA_NLDEV_ATTR_RES_LQPN]);
diff --git a/rdma/res-srq.c b/rdma/res-srq.c
index 945109fc..2944ee4a 100644
--- a/rdma/res-srq.c
+++ b/rdma/res-srq.c
@@ -179,7 +179,12 @@ static int res_srq_line(struct rd *rd, const char *name, int idx,
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 		if (!get_task_name(pid, b))
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
 	res_print_uint(rd, "srqn", srqn, nla_line[RDMA_NLDEV_ATTR_RES_SRQN]);
diff --git a/rdma/stat.c b/rdma/stat.c
index a63b70a4..fe66f4d0 100644
--- a/rdma/stat.c
+++ b/rdma/stat.c
@@ -253,15 +253,16 @@ static int res_counter_line(struct rd *rd, const char *name, int index,
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 		if (!get_task_name(pid, b))
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

