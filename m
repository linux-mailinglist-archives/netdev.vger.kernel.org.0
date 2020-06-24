Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6584420715C
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 12:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390503AbgFXKkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 06:40:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:60148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390493AbgFXKka (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 06:40:30 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82CEA20CC7;
        Wed, 24 Jun 2020 10:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592995229;
        bh=tGK1okVPgt2njxAjuzlmFZ/M+OmmEZMahmYSAsSFUcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YCcTDVAKWNx5JlH3Stk520PRPzIL+tiOgl08FqUoH9ILd4gXhgtheF7xbADGDaV2x
         iWfw3ydM/4myR8sk7emzWlOmX5ihlOX3svmZau0aHIvRWDmVcWsE09rj9h1tyanAMI
         qE/Usamp0EZuJFwe9gS3ru5Qzno7lssLheOrjGFk=
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH iproute2-next v1 3/4] rdma: Add support to get CQ in raw format
Date:   Wed, 24 Jun 2020 13:40:11 +0300
Message-Id: <20200624104012.1450880-4-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624104012.1450880-1-leon@kernel.org>
References: <20200624104012.1450880-1-leon@kernel.org>
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
[{"ifindex":8,"ifname":"mlx5_2",
"data":[0,4,255,254,0,0,0,0,0,0,0,0,16,28,...]}]

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/res-cq.c | 20 ++++++++++++++++++--
 rdma/res.h    |  2 ++
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/rdma/res-cq.c b/rdma/res-cq.c
index e1efe3ba..313f929a 100644
--- a/rdma/res-cq.c
+++ b/rdma/res-cq.c
@@ -39,6 +39,20 @@ static void print_cq_dim_setting(struct rd *rd, struct nlattr *attr)
 	print_on_off(rd, "adaptive-moderation", dim_setting);
 }
 
+static int res_cq_line_raw(struct rd *rd, const char *name, int idx,
+			   struct nlattr **nla_line)
+{
+	if (!nla_line[RDMA_NLDEV_ATTR_RES_RAW])
+		return MNL_CB_ERROR;
+
+	open_json_object(NULL);
+	print_dev(rd, idx, name);
+	print_raw_data(rd, nla_line);
+	newline(rd);
+
+	return MNL_CB_OK;
+}
+
 static int res_cq_line(struct rd *rd, const char *name, int idx,
 		       struct nlattr **nla_line)
 {
@@ -128,7 +142,8 @@ int res_cq_idx_parse_cb(const struct nlmsghdr *nlh, void *data)
 	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
 	idx = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
 
-	return res_cq_line(rd, name, idx, tb);
+	return (rd->show_raw) ? res_cq_line_raw(rd, name, idx, tb) :
+		res_cq_line(rd, name, idx, tb);
 }
 
 int res_cq_parse_cb(const struct nlmsghdr *nlh, void *data)
@@ -156,7 +171,8 @@ int res_cq_parse_cb(const struct nlmsghdr *nlh, void *data)
 		if (ret != MNL_CB_OK)
 			break;
 
-		ret = res_cq_line(rd, name, idx, nla_line);
+		ret = (rd->show_raw) ? res_cq_line_raw(rd, name, idx, nla_line) :
+			res_cq_line(rd, name, idx, nla_line);
 
 		if (ret != MNL_CB_OK)
 			break;
diff --git a/rdma/res.h b/rdma/res.h
index 24eee2a1..bb0f19e0 100644
--- a/rdma/res.h
+++ b/rdma/res.h
@@ -31,6 +31,8 @@ static inline uint32_t res_get_command(uint32_t command, struct rd *rd)
 	switch (command) {
 	case RDMA_NLDEV_CMD_RES_QP_GET:
 		return RDMA_NLDEV_CMD_RES_QP_GET_RAW;
+	case RDMA_NLDEV_CMD_RES_CQ_GET:
+		return RDMA_NLDEV_CMD_RES_CQ_GET_RAW;
 	default:
 		return command;
 	}
-- 
2.26.2

