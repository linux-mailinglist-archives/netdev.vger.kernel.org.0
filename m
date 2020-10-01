Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0003F28081E
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 21:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733099AbgJATxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 15:53:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:40424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733017AbgJATxQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 15:53:16 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BFDD21D24;
        Thu,  1 Oct 2020 19:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601581995;
        bh=NL/1RvC+vQMmDlSKfQA4oeem/JPFBYJYA0yCnZeBZ7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ynwbuywbr4oS9khJFoTa7eBtZiuB2nCtGHGudwBSLYgpWRt/Z9QwKaeIa6w2UCfSw
         Yv9Dh8AAHjdk7h2jnqX3ql3g5bCmsSaOKB06CGFoPS5jMsYzzaLN2Q+uT2cFqsm12B
         SMQSNTIvXa4Vj2x++fkmEDxI4hkKDb69KWfZ41Mg=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net V2 10/15] net/mlx5e: CT, Fix coverity issue
Date:   Thu,  1 Oct 2020 12:52:42 -0700
Message-Id: <20201001195247.66636-11-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001195247.66636-1-saeed@kernel.org>
References: <20201001195247.66636-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

The cited commit introduced the following coverity issue at function
mlx5_tc_ct_rule_to_tuple_nat:
- Memory - corruptions (OVERRUN)
  Overrunning array "tuple->ip.src_v6.in6_u.u6_addr32" of 4 4-byte
  elements at element index 7 (byte offset 31) using index
  "ip6_offset" (which evaluates to 7).

In case of IPv6 destination address rewrite, ip6_offset values are
between 4 to 7, which will cause memory overrun of array
"tuple->ip.src_v6.in6_u.u6_addr32" to array
"tuple->ip.dst_v6.in6_u.u6_addr32".

Fixed by writing the value directly to array
"tuple->ip.dst_v6.in6_u.u6_addr32" in case ip6_offset values are
between 4 to 7.

Fixes: bc562be9674b ("net/mlx5e: CT: Save ct entries tuples in hashtables")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index bc5f72ec3623..a8be40cbe325 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -246,8 +246,10 @@ mlx5_tc_ct_rule_to_tuple_nat(struct mlx5_ct_tuple *tuple,
 		case FLOW_ACT_MANGLE_HDR_TYPE_IP6:
 			ip6_offset = (offset - offsetof(struct ipv6hdr, saddr));
 			ip6_offset /= 4;
-			if (ip6_offset < 8)
+			if (ip6_offset < 4)
 				tuple->ip.src_v6.s6_addr32[ip6_offset] = cpu_to_be32(val);
+			else if (ip6_offset < 8)
+				tuple->ip.dst_v6.s6_addr32[ip6_offset - 4] = cpu_to_be32(val);
 			else
 				return -EOPNOTSUPP;
 			break;
-- 
2.26.2

