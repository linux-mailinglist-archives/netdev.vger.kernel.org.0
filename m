Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C500C8A35
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 15:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbfJBNtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 09:49:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbfJBNtl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 09:49:41 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 798A821783;
        Wed,  2 Oct 2019 13:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570024180;
        bh=H4MJVYsZJO/6VO8DXButzSaRTg+PIdVczRyRW0Kz44s=;
        h=From:To:Cc:Subject:Date:From;
        b=zx0ObmtNO0OIiDZM7ZoFvl4nP91oCLt63Od0FQRGCsZ2sg2E8dqScO5GN0KIZlza6
         zS6/Ih+YgFQX4UOS0NdVRUzi76Kd6ibI1pS94iv6oy4xRG9Zjp3tVC8wBW8SiXK2/j
         T1upSM7vFqiVChdwHy6LqQdibEo0oWUqKNwfYiW8=
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next] rdma: Relax requirement to have PID for HW objects
Date:   Wed,  2 Oct 2019 16:49:34 +0300
Message-Id: <20191002134934.19226-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

RDMA has weak connection between PIDs and HW objects, because
the latter tied to file descriptors for their lifetime management.

The outcome of such connection is that for the following scenario,
the returned PID will be 0 (not-valid):
 1. Create FD and context
 2. Share it with ephemeral child
 3. Create any object and exit that child

This flow was revealed in testing environment and of course real users
are not running such scenario, because it makes no sense at all in RDMA
world.

Let's do two changes in the code to support such workflow anyway:
 1. Remove need to provide PID/kernel name. Code already supports it,
    just need to remove extra validation.
 2. Ball-out in case PID is 0.

Link: https://lore.kernel.org/linux-rdma/20191002123245.18153-2-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/res-cmid.c | 5 +----
 rdma/res-cq.c   | 5 +----
 rdma/res-mr.c   | 5 +----
 rdma/res-pd.c   | 5 +----
 rdma/res-qp.c   | 5 +----
 rdma/res.c      | 3 +++
 6 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/rdma/res-cmid.c b/rdma/res-cmid.c
index 0b830088..0ee9c3d4 100644
--- a/rdma/res-cmid.c
+++ b/rdma/res-cmid.c
@@ -120,11 +120,8 @@ static int res_cm_id_line(struct rd *rd, const char *name, int idx,
 	char *comm = NULL;
 
 	if (!nla_line[RDMA_NLDEV_ATTR_RES_STATE] ||
-	    !nla_line[RDMA_NLDEV_ATTR_RES_PS] ||
-	    (!nla_line[RDMA_NLDEV_ATTR_RES_PID] &&
-	     !nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])) {
+	    !nla_line[RDMA_NLDEV_ATTR_RES_PS])
 		return MNL_CB_ERROR;
-	}
 
 	if (nla_line[RDMA_NLDEV_ATTR_PORT_INDEX])
 		port = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_PORT_INDEX]);
diff --git a/rdma/res-cq.c b/rdma/res-cq.c
index d2591fbe..6855e798 100644
--- a/rdma/res-cq.c
+++ b/rdma/res-cq.c
@@ -56,11 +56,8 @@ static int res_cq_line(struct rd *rd, const char *name, int idx,
 	uint32_t cqe;
 
 	if (!nla_line[RDMA_NLDEV_ATTR_RES_CQE] ||
-	    !nla_line[RDMA_NLDEV_ATTR_RES_USECNT] ||
-	    (!nla_line[RDMA_NLDEV_ATTR_RES_PID] &&
-	     !nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])) {
+	    !nla_line[RDMA_NLDEV_ATTR_RES_USECNT])
 		return MNL_CB_ERROR;
-	}
 
 	cqe = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_CQE]);
 
diff --git a/rdma/res-mr.c b/rdma/res-mr.c
index f4a24dc1..c1b8069a 100644
--- a/rdma/res-mr.c
+++ b/rdma/res-mr.c
@@ -17,11 +17,8 @@ static int res_mr_line(struct rd *rd, const char *name, int idx,
 	uint32_t mrn = 0;
 	uint32_t pid = 0;
 
-	if (!nla_line[RDMA_NLDEV_ATTR_RES_MRLEN] ||
-	    (!nla_line[RDMA_NLDEV_ATTR_RES_PID] &&
-	     !nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])) {
+	if (!nla_line[RDMA_NLDEV_ATTR_RES_MRLEN])
 		return MNL_CB_ERROR;
-	}
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_RKEY])
 		rkey = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_RKEY]);
diff --git a/rdma/res-pd.c b/rdma/res-pd.c
index 07c836e8..6e5e4e6b 100644
--- a/rdma/res-pd.c
+++ b/rdma/res-pd.c
@@ -17,11 +17,8 @@ static int res_pd_line(struct rd *rd, const char *name, int idx,
 	uint32_t pdn = 0;
 	uint64_t users;
 
-	if (!nla_line[RDMA_NLDEV_ATTR_RES_USECNT] ||
-	    (!nla_line[RDMA_NLDEV_ATTR_RES_PID] &&
-	     !nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])) {
+	if (!nla_line[RDMA_NLDEV_ATTR_RES_USECNT])
 		return MNL_CB_ERROR;
-	}
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY])
 		local_dma_lkey = mnl_attr_get_u32(
diff --git a/rdma/res-qp.c b/rdma/res-qp.c
index 954e465d..e30d68ed 100644
--- a/rdma/res-qp.c
+++ b/rdma/res-qp.c
@@ -90,11 +90,8 @@ static int res_qp_line(struct rd *rd, const char *name, int idx,
 	if (!nla_line[RDMA_NLDEV_ATTR_RES_LQPN] ||
 	    !nla_line[RDMA_NLDEV_ATTR_RES_SQ_PSN] ||
 	    !nla_line[RDMA_NLDEV_ATTR_RES_TYPE] ||
-	    !nla_line[RDMA_NLDEV_ATTR_RES_STATE] ||
-	    (!nla_line[RDMA_NLDEV_ATTR_RES_PID] &&
-	     !nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])) {
+	    !nla_line[RDMA_NLDEV_ATTR_RES_STATE])
 		return MNL_CB_ERROR;
-	}
 
 	if (nla_line[RDMA_NLDEV_ATTR_PORT_INDEX])
 		port = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_PORT_INDEX]);
diff --git a/rdma/res.c b/rdma/res.c
index 6003006e..e8607808 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -211,6 +211,9 @@ char *get_task_name(uint32_t pid)
 	char *comm;
 	FILE *f;
 
+	if (!pid)
+		return NULL;
+
 	if (asprintf(&comm, "/proc/%d/comm", pid) < 0)
 		return NULL;
 
-- 
2.20.1

