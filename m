Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBBF1DD56B
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729377AbgEUR7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:59:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:59410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727883AbgEUR7b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 13:59:31 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94A3120759;
        Thu, 21 May 2020 17:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590083971;
        bh=ppWRC1MoP9Ysl2ET1eT42HKlmv/NF5x/YfKiCPwpBsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tU0fa9I1naMMgPclZH8owCKrQ+uNo4WrJoPPzddMylD+R3/sRcPa9TtuaDSLBFjCM
         j8rN9W0699Ku15jLomzHuBG497g926v5pfcS7D/1jkSpT5FROaoZg6WzOJzJJBGG86
         uK0S6aKJ3PBfGYHNJQvAPghNNWHArEjYBVlSOLDM=
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>,
        netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 3/4] rdma: Add support to get CQ in raw format
Date:   Wed, 20 May 2020 13:25:38 +0300
Message-Id: <20200520102539.458983-4-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200520102539.458983-1-leon@kernel.org>
References: <20200520102539.458983-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

Add the required support to print CQ data in raw format.
Example:

$rdma res show cq dev mlx5_2 cqn 1 -r -j
[{"ifindex":8,"ifname":"mlx5_2","cqn":1,"cqe":1023,"users":4,
"poll-ctx":"UNBOUND_WORKQUEUE","adaptive-moderation":"on",
"comm":"ib_core", "data":[0,4,255,254,0,0,0,0,0,0,0,0,16,28,...]}]

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/res-cq.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/rdma/res-cq.c b/rdma/res-cq.c
index e1efe3ba..d34b5245 100644
--- a/rdma/res-cq.c
+++ b/rdma/res-cq.c
@@ -39,9 +39,21 @@ static void print_cq_dim_setting(struct rd *rd, struct nlattr *attr)
 	print_on_off(rd, "adaptive-moderation", dim_setting);
 }

+static bool resp_is_valid(struct nlattr **nla_line, bool raw)
+{
+	if (raw)
+		return nla_line[RDMA_NLDEV_ATTR_RES_RAW] ? true : false;
+
+	if (!nla_line[RDMA_NLDEV_ATTR_RES_CQE] ||
+	    !nla_line[RDMA_NLDEV_ATTR_RES_USECNT])
+		return false;
+	return true;
+}
+
 static int res_cq_line(struct rd *rd, const char *name, int idx,
 		       struct nlattr **nla_line)
 {
+	bool raw = rd->show_raw;
 	char *comm = NULL;
 	uint32_t pid = 0;
 	uint8_t poll_ctx = 0;
@@ -50,8 +62,7 @@ static int res_cq_line(struct rd *rd, const char *name, int idx,
 	uint64_t users;
 	uint32_t cqe;

-	if (!nla_line[RDMA_NLDEV_ATTR_RES_CQE] ||
-	    !nla_line[RDMA_NLDEV_ATTR_RES_USECNT])
+	if (!resp_is_valid(nla_line, raw))
 		return MNL_CB_ERROR;

 	cqe = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_CQE]);
@@ -107,6 +118,7 @@ static int res_cq_line(struct rd *rd, const char *name, int idx,
 	print_comm(rd, comm, nla_line);

 	print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
+	print_raw_data(rd, nla_line);
 	newline(rd);

 out:	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
--
2.26.2

