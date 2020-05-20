Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2581B1DD56D
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729391AbgEUR7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:59:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:59468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727883AbgEUR7f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 13:59:35 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7964C20759;
        Thu, 21 May 2020 17:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590083975;
        bh=Ch0yiFmzDb9EKSkeM6eI9ZKlxMrabp38Wq/XMA+m5us=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WtHjzCTCi6mOX8dhw1HOqDzPIJmHXvQ5uc6mZRQF+gigisrbcJuPbrGqTtFuaG2lW
         TVFmwrg9tE6d+xkilWMFo0jVDTs2qUbxwq0erDOVFdzrzu4uaSgZzgTLzndCGuMV+2
         yIsf7yO2sIDFYwhsvrqbns9fr7P4EApZBA9MPCzg=
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>,
        netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 4/4] rdma: Add support to get MR in raw format
Date:   Wed, 20 May 2020 13:25:39 +0300
Message-Id: <20200520102539.458983-5-leon@kernel.org>
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

Add the required support to print MR data in raw format.
Example:

$rdma res show mr dev mlx5_1 mrn 2 -r -j
[{"ifindex":7,"ifname":"mlx5_1","mrn":2,"mrlen":4096,"pdn":5, pid":24336,
"comm":"ibv_rc_pingpong","data":[0,4,255,254,0,0,0,0,0,0,0,0,16,28,0,216,...]}]

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/res-mr.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/rdma/res-mr.c b/rdma/res-mr.c
index c1366035..b6e0a6a9 100644
--- a/rdma/res-mr.c
+++ b/rdma/res-mr.c
@@ -7,17 +7,27 @@
 #include "res.h"
 #include <inttypes.h>

+static bool resp_is_valid(struct nlattr **nla_line, bool raw)
+{
+	if (raw)
+		return nla_line[RDMA_NLDEV_ATTR_RES_RAW] ? true : false;
+	if (!nla_line[RDMA_NLDEV_ATTR_RES_MRLEN])
+		return MNL_CB_ERROR;
+	return true;
+}
+
 static int res_mr_line(struct rd *rd, const char *name, int idx,
 		       struct nlattr **nla_line)
 {
 	uint32_t rkey = 0, lkey = 0;
 	uint64_t iova = 0, mrlen;
+	bool raw = rd->show_raw;
 	char *comm = NULL;
 	uint32_t pdn = 0;
 	uint32_t mrn = 0;
 	uint32_t pid = 0;

-	if (!nla_line[RDMA_NLDEV_ATTR_RES_MRLEN])
+	if (!resp_is_valid(nla_line, raw))
 		return MNL_CB_ERROR;

 	if (nla_line[RDMA_NLDEV_ATTR_RES_RKEY])
@@ -69,6 +79,7 @@ static int res_mr_line(struct rd *rd, const char *name, int idx,
 	print_comm(rd, comm, nla_line);

 	print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
+	print_raw_data(rd, nla_line);
 	newline(rd);

 out:
--
2.26.2

