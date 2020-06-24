Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C72920715D
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 12:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390524AbgFXKkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 06:40:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390513AbgFXKkd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 06:40:33 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7A8120E65;
        Wed, 24 Jun 2020 10:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592995232;
        bh=gprIv+6BzfrUJZaab7DxJNetQeQITYafD527sYDNwRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gRRi+zq/B13eF1wGg5Vcout6E9Zegm7tL3Id/7rvw5bAc6CK7Ak6n/pqHrlyTEhAx
         M6WA0vBwhrYItNAyzCp28LyEmjhb0T/O4Ot+dEMSo9btO+CRTlV80IGN0eIbBPeJvF
         0IRC9VGkkadtqG354LBG9ipF7Mlz9JOK5ddVDFnY=
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH iproute2-next v1 4/4] rdma: Add support to get MR in raw format
Date:   Wed, 24 Jun 2020 13:40:12 +0300
Message-Id: <20200624104012.1450880-5-leon@kernel.org>
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

Add the required support to print MR data in raw format.
Example:

$rdma res show mr dev mlx5_1 mrn 2 -r -j
[{"ifindex":7,"ifname":"mlx5_1",
"data":[0,4,255,254,0,0,0,0,0,0,0,0,16,28,0,216,...]}]

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/res-mr.c | 21 +++++++++++++++++++--
 rdma/res.h    |  2 ++
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/rdma/res-mr.c b/rdma/res-mr.c
index c1366035..1bf73f3a 100644
--- a/rdma/res-mr.c
+++ b/rdma/res-mr.c
@@ -7,6 +7,20 @@
 #include "res.h"
 #include <inttypes.h>
 
+static int res_mr_line_raw(struct rd *rd, const char *name, int idx,
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
 static int res_mr_line(struct rd *rd, const char *name, int idx,
 		       struct nlattr **nla_line)
 {
@@ -69,6 +83,7 @@ static int res_mr_line(struct rd *rd, const char *name, int idx,
 	print_comm(rd, comm, nla_line);
 
 	print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
+	print_raw_data(rd, nla_line);
 	newline(rd);
 
 out:
@@ -91,7 +106,8 @@ int res_mr_idx_parse_cb(const struct nlmsghdr *nlh, void *data)
 	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
 	idx = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
 
-	return res_mr_line(rd, name, idx, tb);
+	return (rd->show_raw) ? res_mr_line_raw(rd, name, idx, tb) :
+		res_mr_line(rd, name, idx, tb);
 }
 
 int res_mr_parse_cb(const struct nlmsghdr *nlh, void *data)
@@ -119,7 +135,8 @@ int res_mr_parse_cb(const struct nlmsghdr *nlh, void *data)
 		if (ret != MNL_CB_OK)
 			break;
 
-		ret = res_mr_line(rd, name, idx, nla_line);
+		ret = (rd->show_raw) ? res_mr_line_raw(rd, name, idx, nla_line) :
+			res_mr_line(rd, name, idx, nla_line);
 		if (ret != MNL_CB_OK)
 			break;
 	}
diff --git a/rdma/res.h b/rdma/res.h
index bb0f19e0..70ce5758 100644
--- a/rdma/res.h
+++ b/rdma/res.h
@@ -33,6 +33,8 @@ static inline uint32_t res_get_command(uint32_t command, struct rd *rd)
 		return RDMA_NLDEV_CMD_RES_QP_GET_RAW;
 	case RDMA_NLDEV_CMD_RES_CQ_GET:
 		return RDMA_NLDEV_CMD_RES_CQ_GET_RAW;
+	case RDMA_NLDEV_CMD_RES_MR_GET:
+		return RDMA_NLDEV_CMD_RES_MR_GET_RAW;
 	default:
 		return command;
 	}
-- 
2.26.2

