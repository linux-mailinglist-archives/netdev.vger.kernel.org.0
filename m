Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE1A64A62AF
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 18:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241587AbiBARkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 12:40:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:35314 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241582AbiBARkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 12:40:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643737216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UYRLncCVsowRyoLBV+GIXTKfbnP0wqJacTT3x+w1BrI=;
        b=FkmpTQLlYWgzBOpbrOAsTm35enDSlpTThS28oxubdX2rQMP0j5LnXWFhr6URMgzq/AwaKb
        F0dArK1oHjsCi/diBliLaXcBjpsgjgdnSrvtIQUkkvwjNDc6UG0PxfNJT4nMLWpBA+Jqxp
        /WaKMBjLAAbnMd3Fzacb2QfxFQpfEGE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-62t8Cv4wNaGieB9wbEv9AQ-1; Tue, 01 Feb 2022 12:40:13 -0500
X-MC-Unique: 62t8Cv4wNaGieB9wbEv9AQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5016C1927836;
        Tue,  1 Feb 2022 17:39:55 +0000 (UTC)
Received: from tc2.redhat.com (unknown [10.39.195.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0BF8BD1903;
        Tue,  1 Feb 2022 17:39:53 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com,
        markzhang@nvidia.com, leonro@nvidia.com
Subject: [PATCH iproute2 2/3] rdma: stat: fix memory leak in res_counter_line()
Date:   Tue,  1 Feb 2022 18:39:25 +0100
Message-Id: <09e775d1152bc4c92722e91098de01b752a4e7cd.1643736038.git.aclaudi@redhat.com>
In-Reply-To: <cover.1643736038.git.aclaudi@redhat.com>
References: <cover.1643736038.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

get_task_name() uses asprintf() to reserve storage for the task name
string. As asprintf() manpage states, a free() should be used to release
the allocated storage when it is no longer needed.

res_counter_line() uses get_task_name() but does not free the allocated
storage on the error paths and after the usage.

This uses a single return point to free the allocated storage, adopting
the same approach of other rdma code using get_task_name().

Fixes: 5937552b42e4 ("rdma: Add "stat qp show" support")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 rdma/stat.c | 74 ++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 50 insertions(+), 24 deletions(-)

diff --git a/rdma/stat.c b/rdma/stat.c
index adfcd34a..66121b12 100644
--- a/rdma/stat.c
+++ b/rdma/stat.c
@@ -222,9 +222,9 @@ static int res_counter_line(struct rd *rd, const char *name, int index,
 	uint32_t cntn, port = 0, pid = 0, qpn, qp_type = 0;
 	struct nlattr *hwc_table, *qp_table;
 	struct nlattr *nla_entry;
-	const char *comm = NULL;
+	char *comm = NULL;
 	bool isfirst;
-	int err;
+	int err, ret;
 
 	if (nla_line[RDMA_NLDEV_ATTR_PORT_INDEX])
 		port = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_PORT_INDEX]);
@@ -232,52 +232,70 @@ static int res_counter_line(struct rd *rd, const char *name, int index,
 	hwc_table = nla_line[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS];
 	qp_table = nla_line[RDMA_NLDEV_ATTR_RES_QP];
 	if (!hwc_table || !qp_table ||
-	    !nla_line[RDMA_NLDEV_ATTR_STAT_COUNTER_ID])
-		return MNL_CB_ERROR;
+	    !nla_line[RDMA_NLDEV_ATTR_STAT_COUNTER_ID]) {
+		ret = MNL_CB_ERROR;
+		goto out;
+	}
 
 	cntn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_STAT_COUNTER_ID]);
 	if (rd_is_filtered_attr(rd, "cntn", cntn,
-				nla_line[RDMA_NLDEV_ATTR_STAT_COUNTER_ID]))
-		return MNL_CB_OK;
+				nla_line[RDMA_NLDEV_ATTR_STAT_COUNTER_ID])) {
+		ret = MNL_CB_OK;
+		goto out;
+	}
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_TYPE])
 		qp_type = mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_TYPE]);
 
 	if (rd_is_string_filtered_attr(rd, "qp-type", qp_types_to_str(qp_type),
-				       nla_line[RDMA_NLDEV_ATTR_RES_TYPE]))
-		return MNL_CB_OK;
+				       nla_line[RDMA_NLDEV_ATTR_RES_TYPE])) {
+		ret = MNL_CB_OK;
+		goto out;
+	}
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 		comm = get_task_name(pid);
 	}
 	if (rd_is_filtered_attr(rd, "pid", pid,
-				nla_line[RDMA_NLDEV_ATTR_RES_PID]))
-		return MNL_CB_OK;
+				nla_line[RDMA_NLDEV_ATTR_RES_PID])) {
+		ret = MNL_CB_OK;
+		goto out;
+	}
 
-	if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
+	if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]) {
+		/* discard const from mnl_attr_get_str */
 		comm = (char *)mnl_attr_get_str(
 			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
+	}
 
 	mnl_attr_for_each_nested(nla_entry, qp_table) {
 		struct nlattr *qp_line[RDMA_NLDEV_ATTR_MAX] = {};
 
 		err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, qp_line);
-		if (err != MNL_CB_OK)
-			return -EINVAL;
+		if (err != MNL_CB_OK) {
+			ret = -EINVAL;
+			goto out;
+		}
 
-		if (!qp_line[RDMA_NLDEV_ATTR_RES_LQPN])
-			return -EINVAL;
+		if (!qp_line[RDMA_NLDEV_ATTR_RES_LQPN]) {
+			ret = -EINVAL;
+			goto out;
+		}
 
 		qpn = mnl_attr_get_u32(qp_line[RDMA_NLDEV_ATTR_RES_LQPN]);
 		if (rd_is_filtered_attr(rd, "lqpn", qpn,
-					qp_line[RDMA_NLDEV_ATTR_RES_LQPN]))
-			return MNL_CB_OK;
+					qp_line[RDMA_NLDEV_ATTR_RES_LQPN])) {
+			ret = MNL_CB_OK;
+			goto out;
+		}
 	}
 
 	err = res_get_hwcounters(rd, hwc_table, false);
-	if (err != MNL_CB_OK)
-		return err;
+	if (err != MNL_CB_OK) {
+		ret = err;
+		goto out;
+	}
 	open_json_object(NULL);
 	print_link(rd, index, name, port, nla_line);
 	print_color_uint(PRINT_ANY, COLOR_NONE, "cntn", "cntn %u ", cntn);
@@ -292,11 +310,15 @@ static int res_counter_line(struct rd *rd, const char *name, int index,
 	mnl_attr_for_each_nested(nla_entry, qp_table) {
 		struct nlattr *qp_line[RDMA_NLDEV_ATTR_MAX] = {};
 		err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, qp_line);
-		if (err != MNL_CB_OK)
-			return -EINVAL;
+		if (err != MNL_CB_OK) {
+			ret = -EINVAL;
+			goto out;
+		}
 
-		if (!qp_line[RDMA_NLDEV_ATTR_RES_LQPN])
-			return -EINVAL;
+		if (!qp_line[RDMA_NLDEV_ATTR_RES_LQPN]) {
+			ret = -EINVAL;
+			goto out;
+		}
 
 		qpn = mnl_attr_get_u32(qp_line[RDMA_NLDEV_ATTR_RES_LQPN]);
 		if (!isfirst)
@@ -307,7 +329,11 @@ static int res_counter_line(struct rd *rd, const char *name, int index,
 	}
 	close_json_array(PRINT_ANY, ">");
 	newline(rd);
-	return MNL_CB_OK;
+	ret = MNL_CB_OK;
+out:
+	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
+		free(comm);
+	return ret;
 }
 
 static int stat_qp_show_parse_cb(const struct nlmsghdr *nlh, void *data)
-- 
2.34.1

