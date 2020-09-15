Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A7326AF2E
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 23:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbgIOU3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 16:29:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727964AbgIOU1m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 16:27:42 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81750221E5;
        Tue, 15 Sep 2020 20:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600201561;
        bh=w2b/mGwOanH31s7Lrui5TD2QMtu7FRYiq0hQME9X02Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xckbTlaiMxyAj5jDmI8Rnlh7VmIpLNCgrReJv6L/J2rjngtXeXoBuEGTeEngp/YI8
         dZFC1akIWjgedpkfWiNjDhTAqWQMxW2TGtY9BJOp9pptN/4Rub4ZOU3xPTQ0HH2sti
         M8bXD4pALtIcM2n+gmxrFiGKm1YJAxdUBLhIEK5I=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 15/16] net/mlx5e: Add IPv6 traffic class (DSCP) header rewrite support
Date:   Tue, 15 Sep 2020 13:25:32 -0700
Message-Id: <20200915202533.64389-16-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915202533.64389-1-saeed@kernel.org>
References: <20200915202533.64389-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

Add support for rewriting of IPV6 DSCP part of traffic class field.
Next commands, for example, can be used to offload rewrite action:

OVS:
 $ ovs-ofctl add-flow ovs-sriov "tcpv6, in_port=REP, \
       actions=mod_nw_tos:68, output:NIC"

iproute2:
 $ tc filter add dev REP ingress protocol ipv6 prio 1 flower skip_sw \
       ip_proto tcp \
       action pedit ex munge ip6 traffic_class set 68 retain 0xfc pipe \
       action mirred egress redirect dev NIC

Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 2dded22a64a3..817c503693fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2615,6 +2615,7 @@ static struct mlx5_fields fields[] = {
 	OFFLOAD(DIPV6_31_0,   32, U32_MAX, ip6.daddr.s6_addr32[3], 0,
 		dst_ipv4_dst_ipv6.ipv6_layout.ipv6[12]),
 	OFFLOAD(IPV6_HOPLIMIT, 8,  U8_MAX, ip6.hop_limit, 0, ttl_hoplimit),
+	OFFLOAD(IP_DSCP, 16,  0xc00f, ip6, 0, ip_dscp),
 
 	OFFLOAD(TCP_SPORT, 16, U16_MAX, tcp.source,  0, tcp_sport),
 	OFFLOAD(TCP_DPORT, 16, U16_MAX, tcp.dest,    0, tcp_dport),
-- 
2.26.2

