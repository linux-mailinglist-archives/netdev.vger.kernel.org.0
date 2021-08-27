Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2A73F91B8
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 03:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244193AbhH0A7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 20:59:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243992AbhH0A71 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 20:59:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D05B6102A;
        Fri, 27 Aug 2021 00:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630025899;
        bh=f5WwyApS2Mj25Yni4WGYEHqfpybXnPNhN739z6qxO6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LPVnpKFWCJbq8GOo+Iz16A7ACET/WGDFXIUrSB3JyxLPc6KzNbCvdaiYaTmcUZ/R+
         Lg2Rd+GqgaMxbHszorduSafbclpuA+qngW4uBwO94/jStZi8Zdw5yLlGR1FjzJVtbF
         11+xep7qd3bKngPZil/23sBXLnnyJelCYSyyRlOrYOPQf0BfoCgqWlfH3ljIwnNOS8
         J6kKUrorQZ1juCGrEDvdQQOuVLRUKuQ2FZNJ6pZtU6XW+gduI11/5F6IxibJ0OEMEZ
         5oPvvB5g7nR3zIKPfCyGllAk4P3jKRrMYW6oojZhcvIrGfahdKHrN4NSY2b3pLHVRZ
         BybVX87wOHZSw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/17] net/mlx5: DR, Support IPv6 matching on flow label for STEv0
Date:   Thu, 26 Aug 2021 17:57:53 -0700
Message-Id: <20210827005802.236119-9-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210827005802.236119-1-saeed@kernel.org>
References: <20210827005802.236119-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Add missing support for matching on IPv6 flow label for STEv0.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c    | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
index e4dd4eed5aee..22902c32002c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
@@ -1157,6 +1157,7 @@ dr_ste_v0_build_eth_ipv6_l3_l4_tag(struct mlx5dr_match_param *value,
 				   u8 *tag)
 {
 	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
+	struct mlx5dr_match_misc *misc = &value->misc;
 
 	DR_STE_SET_TAG(eth_l4, tag, dst_port, spec, tcp_dport);
 	DR_STE_SET_TAG(eth_l4, tag, src_port, spec, tcp_sport);
@@ -1168,6 +1169,11 @@ dr_ste_v0_build_eth_ipv6_l3_l4_tag(struct mlx5dr_match_param *value,
 	DR_STE_SET_TAG(eth_l4, tag, ecn, spec, ip_ecn);
 	DR_STE_SET_TAG(eth_l4, tag, ipv6_hop_limit, spec, ttl_hoplimit);
 
+	if (sb->inner)
+		DR_STE_SET_TAG(eth_l4, tag, flow_label, misc, inner_ipv6_flow_label);
+	else
+		DR_STE_SET_TAG(eth_l4, tag, flow_label, misc, outer_ipv6_flow_label);
+
 	if (spec->tcp_flags) {
 		DR_STE_SET_TCP_FLAGS(eth_l4, tag, spec);
 		spec->tcp_flags = 0;
-- 
2.31.1

