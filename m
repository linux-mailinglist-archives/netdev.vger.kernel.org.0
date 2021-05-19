Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7160E388D9B
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 14:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353372AbhESMLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 08:11:05 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:40041 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353375AbhESMLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 08:11:01 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 124205C016C;
        Wed, 19 May 2021 08:09:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 19 May 2021 08:09:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=ICq6MNTObUs74KJw33jXtcN1XgIc+IelzlHPqIXMNSc=; b=kYisMSyl
        e+GttZcsRkDm4sI82B5flhyIDBlkWqKitpY5VVFppt014iDOzLX6weMluqZ340ry
        nrl0VRsVl6b47+1NFgdtnOqzmBxdvjtOEusKKxr81jXm1JhRMdTb6ANOtKENGdLA
        1+xaaK9vO2MxKEJguAAHY7WXRMVK85yhr26sICh6f69oOkAZs0tvedL/WZeuZ56Z
        D3AlWBy3fwWMLgCNoAGgip2uoyoOQicTwmfa0t1uAm4p02PYq4D1BtNKvUgM+F29
        WvcOOnk7naRKOhqhW077Dl6ltno1TGeqcha8J+ldlbys6CncIxcTIrZABJ03SQUG
        +MeKPZXi9G34gw==
X-ME-Sender: <xms:BQClYFYALCrntzKOWTXay3I6hdkafL37Jb8ZMHa0mcWXsQHJ093NUA>
    <xme:BQClYMaER6gQyR8S3vqVBkjFGhAm_TuZ90MXlm8NPPN8myTbY8dg-msyATZQogoYW
    P_KAe9WtT1rT58>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeiledggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrudek
    jeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:BQClYH_Epfnqclj-aLb5mBip1_zEQ6i-a82NxYFrHhas1-uDNZGxsw>
    <xmx:BQClYDowFsZzotQciOHODNQFwRB5tfKB-06_WQcjMwcGbwkX-vkuIg>
    <xmx:BQClYAppgkQAa1muANohYNkSqBAJwyW1PQ4f2N4CRUr7vpn2U-JTGQ>
    <xmx:BgClYJk7LBQX5lTvP_6WbhzgfY_C3-Kx_oUFgFaQgZ20nrceK2ZbgA>
Received: from shredder.mellanox.com (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 19 May 2021 08:09:40 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 6/7] mlxsw: spectrum_router: Add support for inner layer 3 multipath hash policy
Date:   Wed, 19 May 2021 15:08:23 +0300
Message-Id: <20210519120824.302191-7-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519120824.302191-1-idosch@idosch.org>
References: <20210519120824.302191-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

When this policy is set, the kernel uses the inner layer 3 fields for
multipath hash computation and falls back to the outer fields if no
encapsulation was encountered. This behavior is most likely influenced
by the behavior of the flow dissector, which is used for the packet
dissection.

The Spectrum ASIC, however, cannot fallback to outer fields if inner
fields are not available. This should not result in a discrepancy from
the software data path because if several flows have matching inner
fields, they will tend to have matching outer fields as well.

Therefore, implement this policy by enabling both outer and inner layer
3 fields for the multipath hash computation.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 41 +++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 605515137636..bacac94398dd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -9602,6 +9602,8 @@ static void mlxsw_sp_router_fib_dump_flush(struct notifier_block *nb)
 struct mlxsw_sp_mp_hash_config {
 	DECLARE_BITMAP(headers, __MLXSW_REG_RECR2_HEADER_CNT);
 	DECLARE_BITMAP(fields, __MLXSW_REG_RECR2_FIELD_CNT);
+	DECLARE_BITMAP(inner_headers, __MLXSW_REG_RECR2_HEADER_CNT);
+	DECLARE_BITMAP(inner_fields, __MLXSW_REG_RECR2_INNER_FIELD_CNT);
 };
 
 #define MLXSW_SP_MP_HASH_HEADER_SET(_headers, _header) \
@@ -9613,6 +9615,27 @@ struct mlxsw_sp_mp_hash_config {
 #define MLXSW_SP_MP_HASH_FIELD_RANGE_SET(_fields, _field, _nr) \
 	bitmap_set(_fields, MLXSW_REG_RECR2_##_field, _nr)
 
+static void mlxsw_sp_mp_hash_inner_l3(struct mlxsw_sp_mp_hash_config *config)
+{
+	unsigned long *inner_headers = config->inner_headers;
+	unsigned long *inner_fields = config->inner_fields;
+
+	/* IPv4 inner */
+	MLXSW_SP_MP_HASH_HEADER_SET(inner_headers, IPV4_EN_NOT_TCP_NOT_UDP);
+	MLXSW_SP_MP_HASH_HEADER_SET(inner_headers, IPV4_EN_TCP_UDP);
+	MLXSW_SP_MP_HASH_FIELD_RANGE_SET(inner_fields, INNER_IPV4_SIP0, 4);
+	MLXSW_SP_MP_HASH_FIELD_RANGE_SET(inner_fields, INNER_IPV4_DIP0, 4);
+	/* IPv6 inner */
+	MLXSW_SP_MP_HASH_HEADER_SET(inner_headers, IPV6_EN_NOT_TCP_NOT_UDP);
+	MLXSW_SP_MP_HASH_HEADER_SET(inner_headers, IPV6_EN_TCP_UDP);
+	MLXSW_SP_MP_HASH_FIELD_SET(inner_fields, INNER_IPV6_SIP0_7);
+	MLXSW_SP_MP_HASH_FIELD_RANGE_SET(inner_fields, INNER_IPV6_SIP8, 8);
+	MLXSW_SP_MP_HASH_FIELD_SET(inner_fields, INNER_IPV6_DIP0_7);
+	MLXSW_SP_MP_HASH_FIELD_RANGE_SET(inner_fields, INNER_IPV6_DIP8, 8);
+	MLXSW_SP_MP_HASH_FIELD_SET(inner_fields, INNER_IPV6_NEXT_HEADER);
+	MLXSW_SP_MP_HASH_FIELD_SET(inner_fields, INNER_IPV6_FLOW_LABEL);
+}
+
 static void mlxsw_sp_mp4_hash_outer_addr(struct mlxsw_sp_mp_hash_config *config)
 {
 	unsigned long *headers = config->headers;
@@ -9642,6 +9665,12 @@ static void mlxsw_sp_mp4_hash_init(struct mlxsw_sp *mlxsw_sp,
 		MLXSW_SP_MP_HASH_FIELD_SET(fields, TCP_UDP_SPORT);
 		MLXSW_SP_MP_HASH_FIELD_SET(fields, TCP_UDP_DPORT);
 		break;
+	case 2:
+		/* Outer */
+		mlxsw_sp_mp4_hash_outer_addr(config);
+		/* Inner */
+		mlxsw_sp_mp_hash_inner_l3(config);
+		break;
 	}
 }
 
@@ -9677,6 +9706,14 @@ static void mlxsw_sp_mp6_hash_init(struct mlxsw_sp *mlxsw_sp,
 		MLXSW_SP_MP_HASH_FIELD_SET(fields, TCP_UDP_SPORT);
 		MLXSW_SP_MP_HASH_FIELD_SET(fields, TCP_UDP_DPORT);
 		break;
+	case 2:
+		/* Outer */
+		mlxsw_sp_mp6_hash_outer_addr(config);
+		MLXSW_SP_MP_HASH_FIELD_SET(fields, IPV6_NEXT_HEADER);
+		MLXSW_SP_MP_HASH_FIELD_SET(fields, IPV6_FLOW_LABEL);
+		/* Inner */
+		mlxsw_sp_mp_hash_inner_l3(config);
+		break;
 	}
 }
 
@@ -9696,6 +9733,10 @@ static int mlxsw_sp_mp_hash_init(struct mlxsw_sp *mlxsw_sp)
 		mlxsw_reg_recr2_outer_header_enables_set(recr2_pl, bit, 1);
 	for_each_set_bit(bit, config.fields, __MLXSW_REG_RECR2_FIELD_CNT)
 		mlxsw_reg_recr2_outer_header_fields_enable_set(recr2_pl, bit, 1);
+	for_each_set_bit(bit, config.inner_headers, __MLXSW_REG_RECR2_HEADER_CNT)
+		mlxsw_reg_recr2_inner_header_enables_set(recr2_pl, bit, 1);
+	for_each_set_bit(bit, config.inner_fields, __MLXSW_REG_RECR2_INNER_FIELD_CNT)
+		mlxsw_reg_recr2_inner_header_fields_enable_set(recr2_pl, bit, 1);
 
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(recr2), recr2_pl);
 }
-- 
2.31.1

