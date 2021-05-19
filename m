Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D766388D97
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 14:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353359AbhESMK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 08:10:57 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49339 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353351AbhESMK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 08:10:56 -0400
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 2CF865C017C;
        Wed, 19 May 2021 08:09:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute7.internal (MEProxy); Wed, 19 May 2021 08:09:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=JvOVkaDqp6X7crh8If4TxPDDfRd2bbz/EjPG/AbLvPg=; b=HOYh4dUK
        dV5iiBG2brL0gGkNaOu+73y1Ylr5fe1AQDumeXeuxbveDrsRb69dtqaVj8migSZf
        VMBAn816f95sqMRUfagQbApVqqyQO2QtpTS47iy8cnq5+ZnMYr7r8t5PMo5a5/Ct
        K87g5C5fG+6ORfHOT51MEQXWyJE5gT8OMhk6GI455X4//mKmQ8F/kuM2s2bw74Yn
        VaRPtilEsT7kJSsfH7WymA4CbXty3k42RRtKe3fFyoQ3JpGBc2mCp1ETU3en3xVJ
        JDwhDtuM4MOARiAQQHk+OOMwoYg4d+tn31tinyddX2jxPyzQhc3mCghMHNLT5PvW
        4YEH3iGPJ/tqKw==
X-ME-Sender: <xms:AAClYIeJ66Btk0FtFzv4nblVYlI0fb3bx7l1kLZ91xFjpaPV09wC_Q>
    <xme:AAClYKP0QkRi-fpGz6rGSS1gJeLlbbgnehRW9pC64lUZuC7DPGf1QZgFlAiroDQiW
    xEI69GvSlBIk54>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeiledggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrudek
    jeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:AAClYJjz8A9LVdNRN5afqaCoMAxr3Hb9FzYwcWUsfLdXFDrpFFNu5w>
    <xmx:AAClYN-zden97IbTrdEJCYdh6kP2dVSqbMMp22x8J9QNdpPs9ih0FQ>
    <xmx:AAClYEu0j5apgZ8wj-7-jrsHUCB8L16kNjCFSFiaz71dVFCfK1XujQ>
    <xmx:AAClYGKPTDS_vmSbu_yc25iYopCgsOrFdDk5uEvqq8A045yolac6XQ>
Received: from shredder.mellanox.com (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 19 May 2021 08:09:34 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/7] mlxsw: spectrum_router: Move multipath hash configuration to a bitmap
Date:   Wed, 19 May 2021 15:08:20 +0300
Message-Id: <20210519120824.302191-4-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519120824.302191-1-idosch@idosch.org>
References: <20210519120824.302191-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Currently, the multipath hash configuration is written directly to the
register payload. While this is OK for the two currently supported
policies, it is going to be hard to follow when more policies and more
packet fields are added.

Instead, set the required headers and fields in a bitmap and then dump
it to the register payload.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 46 +--------
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 98 ++++++++++++-------
 2 files changed, 64 insertions(+), 80 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 900b4bf5bb5b..4039c9d21824 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -8305,6 +8305,8 @@ enum {
 	MLXSW_REG_RECR2_TCP_UDP_EN_IPV4		= 7,
 	/* Enable TCP/UDP header fields if packet is IPv6 */
 	MLXSW_REG_RECR2_TCP_UDP_EN_IPV6		= 8,
+
+	__MLXSW_REG_RECR2_HEADER_CNT,
 };
 
 /* reg_recr2_outer_header_enables
@@ -8339,6 +8341,8 @@ enum {
 	MLXSW_REG_RECR2_TCP_UDP_SPORT			= 74,
 	/* TCP/UDP Destination Port */
 	MLXSW_REG_RECR2_TCP_UDP_DPORT			= 75,
+
+	__MLXSW_REG_RECR2_FIELD_CNT,
 };
 
 /* reg_recr2_outer_header_fields_enable
@@ -8347,48 +8351,6 @@ enum {
  */
 MLXSW_ITEM_BIT_ARRAY(reg, recr2, outer_header_fields_enable, 0x14, 0x14, 1);
 
-static inline void mlxsw_reg_recr2_ipv4_sip_enable(char *payload)
-{
-	int i;
-
-	for (i = MLXSW_REG_RECR2_IPV4_SIP0; i <= MLXSW_REG_RECR2_IPV4_SIP3; i++)
-		mlxsw_reg_recr2_outer_header_fields_enable_set(payload, i,
-							       true);
-}
-
-static inline void mlxsw_reg_recr2_ipv4_dip_enable(char *payload)
-{
-	int i;
-
-	for (i = MLXSW_REG_RECR2_IPV4_DIP0; i <= MLXSW_REG_RECR2_IPV4_DIP3; i++)
-		mlxsw_reg_recr2_outer_header_fields_enable_set(payload, i,
-							       true);
-}
-
-static inline void mlxsw_reg_recr2_ipv6_sip_enable(char *payload)
-{
-	int i = MLXSW_REG_RECR2_IPV6_SIP0_7;
-
-	mlxsw_reg_recr2_outer_header_fields_enable_set(payload, i, true);
-
-	i = MLXSW_REG_RECR2_IPV6_SIP8;
-	for (; i <= MLXSW_REG_RECR2_IPV6_SIP15; i++)
-		mlxsw_reg_recr2_outer_header_fields_enable_set(payload, i,
-							       true);
-}
-
-static inline void mlxsw_reg_recr2_ipv6_dip_enable(char *payload)
-{
-	int i = MLXSW_REG_RECR2_IPV6_DIP0_7;
-
-	mlxsw_reg_recr2_outer_header_fields_enable_set(payload, i, true);
-
-	i = MLXSW_REG_RECR2_IPV6_DIP8;
-	for (; i <= MLXSW_REG_RECR2_IPV6_DIP15; i++)
-		mlxsw_reg_recr2_outer_header_fields_enable_set(payload, i,
-							       true);
-}
-
 static inline void mlxsw_reg_recr2_pack(char *payload, u32 seed)
 {
 	MLXSW_REG_ZERO(recr2, payload);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 1762a790dd34..3f896c5e50c7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -9599,73 +9599,95 @@ static void mlxsw_sp_router_fib_dump_flush(struct notifier_block *nb)
 }
 
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
-static void mlxsw_sp_mp_hash_header_set(char *recr2_pl, int header)
-{
-	mlxsw_reg_recr2_outer_header_enables_set(recr2_pl, header, true);
-}
+struct mlxsw_sp_mp_hash_config {
+	DECLARE_BITMAP(headers, __MLXSW_REG_RECR2_HEADER_CNT);
+	DECLARE_BITMAP(fields, __MLXSW_REG_RECR2_FIELD_CNT);
+};
 
-static void mlxsw_sp_mp_hash_field_set(char *recr2_pl, int field)
-{
-	mlxsw_reg_recr2_outer_header_fields_enable_set(recr2_pl, field, true);
-}
+#define MLXSW_SP_MP_HASH_HEADER_SET(_headers, _header) \
+	bitmap_set(_headers, MLXSW_REG_RECR2_##_header, 1)
 
-static void mlxsw_sp_mp4_hash_init(struct mlxsw_sp *mlxsw_sp, char *recr2_pl)
+#define MLXSW_SP_MP_HASH_FIELD_SET(_fields, _field) \
+	bitmap_set(_fields, MLXSW_REG_RECR2_##_field, 1)
+
+#define MLXSW_SP_MP_HASH_FIELD_RANGE_SET(_fields, _field, _nr) \
+	bitmap_set(_fields, MLXSW_REG_RECR2_##_field, _nr)
+
+static void mlxsw_sp_mp4_hash_init(struct mlxsw_sp *mlxsw_sp,
+				   struct mlxsw_sp_mp_hash_config *config)
 {
 	struct net *net = mlxsw_sp_net(mlxsw_sp);
+	unsigned long *headers = config->headers;
+	unsigned long *fields = config->fields;
 
 	switch (net->ipv4.sysctl_fib_multipath_hash_policy) {
 	case 0:
-		mlxsw_sp_mp_hash_header_set(recr2_pl, MLXSW_REG_RECR2_IPV4_EN_NOT_TCP_NOT_UDP);
-		mlxsw_sp_mp_hash_header_set(recr2_pl, MLXSW_REG_RECR2_IPV4_EN_TCP_UDP);
-		mlxsw_reg_recr2_ipv4_sip_enable(recr2_pl);
-		mlxsw_reg_recr2_ipv4_dip_enable(recr2_pl);
+		MLXSW_SP_MP_HASH_HEADER_SET(headers, IPV4_EN_NOT_TCP_NOT_UDP);
+		MLXSW_SP_MP_HASH_HEADER_SET(headers, IPV4_EN_TCP_UDP);
+		MLXSW_SP_MP_HASH_FIELD_RANGE_SET(fields, IPV4_SIP0, 4);
+		MLXSW_SP_MP_HASH_FIELD_RANGE_SET(fields, IPV4_DIP0, 4);
 		break;
 	case 1:
-		mlxsw_sp_mp_hash_header_set(recr2_pl, MLXSW_REG_RECR2_IPV4_EN_NOT_TCP_NOT_UDP);
-		mlxsw_sp_mp_hash_header_set(recr2_pl, MLXSW_REG_RECR2_IPV4_EN_TCP_UDP);
-		mlxsw_sp_mp_hash_header_set(recr2_pl, MLXSW_REG_RECR2_TCP_UDP_EN_IPV4);
-		mlxsw_reg_recr2_ipv4_sip_enable(recr2_pl);
-		mlxsw_reg_recr2_ipv4_dip_enable(recr2_pl);
-		mlxsw_sp_mp_hash_field_set(recr2_pl, MLXSW_REG_RECR2_IPV4_PROTOCOL);
-		mlxsw_sp_mp_hash_field_set(recr2_pl, MLXSW_REG_RECR2_TCP_UDP_SPORT);
-		mlxsw_sp_mp_hash_field_set(recr2_pl, MLXSW_REG_RECR2_TCP_UDP_DPORT);
+		MLXSW_SP_MP_HASH_HEADER_SET(headers, IPV4_EN_NOT_TCP_NOT_UDP);
+		MLXSW_SP_MP_HASH_HEADER_SET(headers, IPV4_EN_TCP_UDP);
+		MLXSW_SP_MP_HASH_HEADER_SET(headers, TCP_UDP_EN_IPV4);
+		MLXSW_SP_MP_HASH_FIELD_RANGE_SET(fields, IPV4_SIP0, 4);
+		MLXSW_SP_MP_HASH_FIELD_RANGE_SET(fields, IPV4_DIP0, 4);
+		MLXSW_SP_MP_HASH_FIELD_SET(fields, IPV4_PROTOCOL);
+		MLXSW_SP_MP_HASH_FIELD_SET(fields, TCP_UDP_SPORT);
+		MLXSW_SP_MP_HASH_FIELD_SET(fields, TCP_UDP_DPORT);
 		break;
 	}
 }
 
-static void mlxsw_sp_mp6_hash_init(struct mlxsw_sp *mlxsw_sp, char *recr2_pl)
+static void mlxsw_sp_mp6_hash_init(struct mlxsw_sp *mlxsw_sp,
+				   struct mlxsw_sp_mp_hash_config *config)
 {
+	unsigned long *headers = config->headers;
+	unsigned long *fields = config->fields;
+
 	switch (ip6_multipath_hash_policy(mlxsw_sp_net(mlxsw_sp))) {
 	case 0:
-		mlxsw_sp_mp_hash_header_set(recr2_pl, MLXSW_REG_RECR2_IPV6_EN_NOT_TCP_NOT_UDP);
-		mlxsw_sp_mp_hash_header_set(recr2_pl, MLXSW_REG_RECR2_IPV6_EN_TCP_UDP);
-		mlxsw_reg_recr2_ipv6_sip_enable(recr2_pl);
-		mlxsw_reg_recr2_ipv6_dip_enable(recr2_pl);
-		mlxsw_sp_mp_hash_field_set(recr2_pl, MLXSW_REG_RECR2_IPV6_NEXT_HEADER);
-		mlxsw_sp_mp_hash_field_set(recr2_pl, MLXSW_REG_RECR2_IPV6_FLOW_LABEL);
+		MLXSW_SP_MP_HASH_HEADER_SET(headers, IPV6_EN_NOT_TCP_NOT_UDP);
+		MLXSW_SP_MP_HASH_HEADER_SET(headers, IPV6_EN_TCP_UDP);
+		MLXSW_SP_MP_HASH_FIELD_SET(fields, IPV6_SIP0_7);
+		MLXSW_SP_MP_HASH_FIELD_RANGE_SET(fields, IPV6_SIP8, 8);
+		MLXSW_SP_MP_HASH_FIELD_SET(fields, IPV6_DIP0_7);
+		MLXSW_SP_MP_HASH_FIELD_RANGE_SET(fields, IPV6_DIP8, 8);
+		MLXSW_SP_MP_HASH_FIELD_SET(fields, IPV6_NEXT_HEADER);
+		MLXSW_SP_MP_HASH_FIELD_SET(fields, IPV6_FLOW_LABEL);
 		break;
 	case 1:
-		mlxsw_sp_mp_hash_header_set(recr2_pl, MLXSW_REG_RECR2_IPV6_EN_NOT_TCP_NOT_UDP);
-		mlxsw_sp_mp_hash_header_set(recr2_pl, MLXSW_REG_RECR2_IPV6_EN_TCP_UDP);
-		mlxsw_sp_mp_hash_header_set(recr2_pl, MLXSW_REG_RECR2_TCP_UDP_EN_IPV6);
-		mlxsw_reg_recr2_ipv6_sip_enable(recr2_pl);
-		mlxsw_reg_recr2_ipv6_dip_enable(recr2_pl);
-		mlxsw_sp_mp_hash_field_set(recr2_pl, MLXSW_REG_RECR2_IPV6_NEXT_HEADER);
-		mlxsw_sp_mp_hash_field_set(recr2_pl, MLXSW_REG_RECR2_TCP_UDP_SPORT);
-		mlxsw_sp_mp_hash_field_set(recr2_pl, MLXSW_REG_RECR2_TCP_UDP_DPORT);
+		MLXSW_SP_MP_HASH_HEADER_SET(headers, IPV6_EN_NOT_TCP_NOT_UDP);
+		MLXSW_SP_MP_HASH_HEADER_SET(headers, IPV6_EN_TCP_UDP);
+		MLXSW_SP_MP_HASH_HEADER_SET(headers, TCP_UDP_EN_IPV6);
+		MLXSW_SP_MP_HASH_FIELD_SET(fields, IPV6_SIP0_7);
+		MLXSW_SP_MP_HASH_FIELD_RANGE_SET(fields, IPV6_SIP8, 8);
+		MLXSW_SP_MP_HASH_FIELD_SET(fields, IPV6_DIP0_7);
+		MLXSW_SP_MP_HASH_FIELD_RANGE_SET(fields, IPV6_DIP8, 8);
+		MLXSW_SP_MP_HASH_FIELD_SET(fields, IPV6_NEXT_HEADER);
+		MLXSW_SP_MP_HASH_FIELD_SET(fields, TCP_UDP_SPORT);
+		MLXSW_SP_MP_HASH_FIELD_SET(fields, TCP_UDP_DPORT);
 		break;
 	}
 }
 
 static int mlxsw_sp_mp_hash_init(struct mlxsw_sp *mlxsw_sp)
 {
+	struct mlxsw_sp_mp_hash_config config = {};
 	char recr2_pl[MLXSW_REG_RECR2_LEN];
+	unsigned long bit;
 	u32 seed;
 
 	seed = jhash(mlxsw_sp->base_mac, sizeof(mlxsw_sp->base_mac), 0);
 	mlxsw_reg_recr2_pack(recr2_pl, seed);
-	mlxsw_sp_mp4_hash_init(mlxsw_sp, recr2_pl);
-	mlxsw_sp_mp6_hash_init(mlxsw_sp, recr2_pl);
+	mlxsw_sp_mp4_hash_init(mlxsw_sp, &config);
+	mlxsw_sp_mp6_hash_init(mlxsw_sp, &config);
+
+	for_each_set_bit(bit, config.headers, __MLXSW_REG_RECR2_HEADER_CNT)
+		mlxsw_reg_recr2_outer_header_enables_set(recr2_pl, bit, 1);
+	for_each_set_bit(bit, config.fields, __MLXSW_REG_RECR2_FIELD_CNT)
+		mlxsw_reg_recr2_outer_header_fields_enable_set(recr2_pl, bit, 1);
 
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(recr2), recr2_pl);
 }
-- 
2.31.1

