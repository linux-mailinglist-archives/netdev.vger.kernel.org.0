Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29288388D9A
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 14:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353366AbhESMLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 08:11:04 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:38699 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353367AbhESMLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 08:11:00 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 4BF7A5C018D;
        Wed, 19 May 2021 08:09:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 19 May 2021 08:09:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=C438wb/me4Ff/NzMflplpZyoDZ0T88h4/8CHnFvNWyI=; b=dCwhku1/
        lCGt4da2wv8nYDzra0Z6kYO811JbiiK836q3PFH5ezwu1eXpfeorosrv1trV0MTw
        ICZCg33/bK8qAcWPp5ViHjFoP65OP9mi930ngXUsSJpGOwnzd2U1H9cZTOt+QbA+
        Euif8gbGp5G7A5/u41alm0NXAFWWvUu5HVwXdw72EbiqybIum4NbcHffYKRvx97c
        8hakp4JPAJ6hBlSghBfqiUnXtui/Yi2xkFp9IUnXQo+J3y6viU2gjUrw++yBHObm
        IcguydtPNin+mtxQoMhjBAbV2wEuT0/lBDaEiH4cw1pBqUU/HbZV7vXBXB5B/3LP
        qkr3XrqyJ8JgWw==
X-ME-Sender: <xms:BAClYP3aDaCazRp9jPWGhNSq4MrEyhAN2B189I9v33kvzUGBcItRoA>
    <xme:BAClYOGn1yeeO7vlvTQ0il1r81Udy7zAWSmhx6FqCuFjm3QFZW9M_q1sRNF5KSz9L
    LgXqgoW7n6OKCQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeiledggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrudek
    jeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:BAClYP74cpAJT-EsCyIJOJLFd_P2HT-yQ71EHhg1RtxQxz98xAYfrQ>
    <xmx:BAClYE2ks9-gHEKpBpqzzmPs2jwLYCyXXklW5tz5XdcOu3XJO4afTQ>
    <xmx:BAClYCHnWR4r4H5t6Hmtnzq033QlEbm5uLHc8-GMiDpFcRNA95Kc1Q>
    <xmx:BAClYOh34u-DfuvtRFaScLeEJmgT1h3L0zegZ2AgjVSK3u15fk3tAQ>
Received: from shredder.mellanox.com (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 19 May 2021 08:09:38 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/7] mlxsw: spectrum_outer: Factor out helper for common outer fields
Date:   Wed, 19 May 2021 15:08:22 +0300
Message-Id: <20210519120824.302191-6-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519120824.302191-1-idosch@idosch.org>
References: <20210519120824.302191-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Outer IPv4 and IPv6 addresses are used by multiple multipath hash
policies. Factor out helpers that set these fields to increase code
sharing between different policies.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 48 +++++++++++--------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 3f896c5e50c7..605515137636 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -9613,6 +9613,17 @@ struct mlxsw_sp_mp_hash_config {
 #define MLXSW_SP_MP_HASH_FIELD_RANGE_SET(_fields, _field, _nr) \
 	bitmap_set(_fields, MLXSW_REG_RECR2_##_field, _nr)
 
+static void mlxsw_sp_mp4_hash_outer_addr(struct mlxsw_sp_mp_hash_config *config)
+{
+	unsigned long *headers = config->headers;
+	unsigned long *fields = config->fields;
+
+	MLXSW_SP_MP_HASH_HEADER_SET(headers, IPV4_EN_NOT_TCP_NOT_UDP);
+	MLXSW_SP_MP_HASH_HEADER_SET(headers, IPV4_EN_TCP_UDP);
+	MLXSW_SP_MP_HASH_FIELD_RANGE_SET(fields, IPV4_SIP0, 4);
+	MLXSW_SP_MP_HASH_FIELD_RANGE_SET(fields, IPV4_DIP0, 4);
+}
+
 static void mlxsw_sp_mp4_hash_init(struct mlxsw_sp *mlxsw_sp,
 				   struct mlxsw_sp_mp_hash_config *config)
 {
@@ -9622,17 +9633,11 @@ static void mlxsw_sp_mp4_hash_init(struct mlxsw_sp *mlxsw_sp,
 
 	switch (net->ipv4.sysctl_fib_multipath_hash_policy) {
 	case 0:
-		MLXSW_SP_MP_HASH_HEADER_SET(headers, IPV4_EN_NOT_TCP_NOT_UDP);
-		MLXSW_SP_MP_HASH_HEADER_SET(headers, IPV4_EN_TCP_UDP);
-		MLXSW_SP_MP_HASH_FIELD_RANGE_SET(fields, IPV4_SIP0, 4);
-		MLXSW_SP_MP_HASH_FIELD_RANGE_SET(fields, IPV4_DIP0, 4);
+		mlxsw_sp_mp4_hash_outer_addr(config);
 		break;
 	case 1:
-		MLXSW_SP_MP_HASH_HEADER_SET(headers, IPV4_EN_NOT_TCP_NOT_UDP);
-		MLXSW_SP_MP_HASH_HEADER_SET(headers, IPV4_EN_TCP_UDP);
+		mlxsw_sp_mp4_hash_outer_addr(config);
 		MLXSW_SP_MP_HASH_HEADER_SET(headers, TCP_UDP_EN_IPV4);
-		MLXSW_SP_MP_HASH_FIELD_RANGE_SET(fields, IPV4_SIP0, 4);
-		MLXSW_SP_MP_HASH_FIELD_RANGE_SET(fields, IPV4_DIP0, 4);
 		MLXSW_SP_MP_HASH_FIELD_SET(fields, IPV4_PROTOCOL);
 		MLXSW_SP_MP_HASH_FIELD_SET(fields, TCP_UDP_SPORT);
 		MLXSW_SP_MP_HASH_FIELD_SET(fields, TCP_UDP_DPORT);
@@ -9640,6 +9645,19 @@ static void mlxsw_sp_mp4_hash_init(struct mlxsw_sp *mlxsw_sp,
 	}
 }
 
+static void mlxsw_sp_mp6_hash_outer_addr(struct mlxsw_sp_mp_hash_config *config)
+{
+	unsigned long *headers = config->headers;
+	unsigned long *fields = config->fields;
+
+	MLXSW_SP_MP_HASH_HEADER_SET(headers, IPV6_EN_NOT_TCP_NOT_UDP);
+	MLXSW_SP_MP_HASH_HEADER_SET(headers, IPV6_EN_TCP_UDP);
+	MLXSW_SP_MP_HASH_FIELD_SET(fields, IPV6_SIP0_7);
+	MLXSW_SP_MP_HASH_FIELD_RANGE_SET(fields, IPV6_SIP8, 8);
+	MLXSW_SP_MP_HASH_FIELD_SET(fields, IPV6_DIP0_7);
+	MLXSW_SP_MP_HASH_FIELD_RANGE_SET(fields, IPV6_DIP8, 8);
+}
+
 static void mlxsw_sp_mp6_hash_init(struct mlxsw_sp *mlxsw_sp,
 				   struct mlxsw_sp_mp_hash_config *config)
 {
@@ -9648,23 +9666,13 @@ static void mlxsw_sp_mp6_hash_init(struct mlxsw_sp *mlxsw_sp,
 
 	switch (ip6_multipath_hash_policy(mlxsw_sp_net(mlxsw_sp))) {
 	case 0:
-		MLXSW_SP_MP_HASH_HEADER_SET(headers, IPV6_EN_NOT_TCP_NOT_UDP);
-		MLXSW_SP_MP_HASH_HEADER_SET(headers, IPV6_EN_TCP_UDP);
-		MLXSW_SP_MP_HASH_FIELD_SET(fields, IPV6_SIP0_7);
-		MLXSW_SP_MP_HASH_FIELD_RANGE_SET(fields, IPV6_SIP8, 8);
-		MLXSW_SP_MP_HASH_FIELD_SET(fields, IPV6_DIP0_7);
-		MLXSW_SP_MP_HASH_FIELD_RANGE_SET(fields, IPV6_DIP8, 8);
+		mlxsw_sp_mp6_hash_outer_addr(config);
 		MLXSW_SP_MP_HASH_FIELD_SET(fields, IPV6_NEXT_HEADER);
 		MLXSW_SP_MP_HASH_FIELD_SET(fields, IPV6_FLOW_LABEL);
 		break;
 	case 1:
-		MLXSW_SP_MP_HASH_HEADER_SET(headers, IPV6_EN_NOT_TCP_NOT_UDP);
-		MLXSW_SP_MP_HASH_HEADER_SET(headers, IPV6_EN_TCP_UDP);
+		mlxsw_sp_mp6_hash_outer_addr(config);
 		MLXSW_SP_MP_HASH_HEADER_SET(headers, TCP_UDP_EN_IPV6);
-		MLXSW_SP_MP_HASH_FIELD_SET(fields, IPV6_SIP0_7);
-		MLXSW_SP_MP_HASH_FIELD_RANGE_SET(fields, IPV6_SIP8, 8);
-		MLXSW_SP_MP_HASH_FIELD_SET(fields, IPV6_DIP0_7);
-		MLXSW_SP_MP_HASH_FIELD_RANGE_SET(fields, IPV6_DIP8, 8);
 		MLXSW_SP_MP_HASH_FIELD_SET(fields, IPV6_NEXT_HEADER);
 		MLXSW_SP_MP_HASH_FIELD_SET(fields, TCP_UDP_SPORT);
 		MLXSW_SP_MP_HASH_FIELD_SET(fields, TCP_UDP_DPORT);
-- 
2.31.1

