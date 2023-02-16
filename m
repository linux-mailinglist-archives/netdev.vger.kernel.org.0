Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDB3699971
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 17:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjBPQF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 11:05:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjBPQFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 11:05:55 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B094B1BDE
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 08:05:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oKoHKLFcGdYkPEvg5hsRqsr9b1muSm9uPE9ZPe8kEjNnxlSMhrrwmWrN/bJ0y09lvCl2JMn2tZ5r3+nLU2EI39WVoQZd/zT4VdnB1KWTYeETN3X1Azm1nhOp/yORTMyXnmakI0onJUfZqyb5lZiAlULklH8VAA/AzVYN5FwZuXRQxkfIJDnhFQGLYNGRTZ0Qrnldh5e5bYBC8zphUONPnNj0ogLlIZMWfDmtwTmckYk7uQvy8sS4WTpJOr8MPwF3QfvojL0/eJmN4i9L0S5h6k/OauzlP5hraLuexTGSC1KDXFsz46xC+RXTMXgxM0fpjaTs9u88ftzyeq4jlxYdag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Fd9SSm83bqgmES0p8y83rZNfdhz7PdZV4TAXpvX0b4=;
 b=b7u7MOijClGlF2pWm9yfaLBjWWzZKyYmUVyVQoFLpXybS5Kj8jrlV1Rj3yGRt2DRhm6nv/s47qgSK7Bzf9Wzcavr7WZ7LAxU0xp1vJkX6qNqYKXXB23MrGd8gEeGFZPjxCtCijmu4Exmu1ve8jjtQ0w9UhV6TAuUVfvJkHchKw5YE1hhP5gxkq8r2Qvcsov6gqNsqe3RkHpwtSSPLiqHnBlpzioKt1zTHoB6lH1drwzo3rIPN0Yi/LSgVcQWAN6VGHp5DkQVR8+a/JUGIudsTOmeLOMt5etBruQIBkRRswYFDtZRAV1DqqDtbAH9WuymEqmiLKG7p/agR5uKD3mwqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Fd9SSm83bqgmES0p8y83rZNfdhz7PdZV4TAXpvX0b4=;
 b=zduJF7Hrj6LyXFh+iAynIezAT5Nkoi+eHECmCaqZfEFniYCeQDYKUHggU6WeuGwhw0WX32qdGMPZLfxdTjd2qjHiJc4N+xl6ms0A2fbt8PEQZ7+HwKqtz5bj+CzOB8wTH0aBlM9AidB117B6CNrkSYehqopt841xie8YUvEzyhI=
Received: from DM6PR06CA0049.namprd06.prod.outlook.com (2603:10b6:5:54::26) by
 CY8PR12MB7243.namprd12.prod.outlook.com (2603:10b6:930:58::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.13; Thu, 16 Feb 2023 16:05:51 +0000
Received: from DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:54:cafe::b5) by DM6PR06CA0049.outlook.office365.com
 (2603:10b6:5:54::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13 via Frontend
 Transport; Thu, 16 Feb 2023 16:05:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT023.mail.protection.outlook.com (10.13.173.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.13 via Frontend Transport; Thu, 16 Feb 2023 16:05:50 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 16 Feb
 2023 10:05:48 -0600
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Thu, 16 Feb 2023 10:05:47 -0600
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>
Subject: [PATCH net-next] sfc: support offloading TC VLAN push/pop actions to the MAE
Date:   Thu, 16 Feb 2023 16:04:42 +0000
Message-ID: <20230216160442.48394-1-edward.cree@amd.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT023:EE_|CY8PR12MB7243:EE_
X-MS-Office365-Filtering-Correlation-Id: 95835269-2a9f-4657-48ca-08db1037ac8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lYILS9n2XltjdRIAjUYJ2fhghxI8kfKIPDmhQqdBpNvAOMUGWjO/AXgzse8sK2CW+/oyqHmeDZij+tX3hUYaPYZ2+ofDvLPtHlAYof8UxBsUS5hMwSFN/msYM5V2zfkR8xCY8qPvU+76wPu/kH9LlrPmcXjv4LZxSab4EcN2yZbOb3uvLSKa9Er0ZK8Ng3YzqEMup7k+/7eI/cza7ZpgJz01gRhATKAJRdCbNN657QVH6mLZYtFy6JliPe+J6owzLnjjwouLHL8yrPS7g+yQJfmH0CwEDvDtcDWM4IHDBvb9oTU44EG/ayoWcZdGJDZ3urBNmQgA1fszj2FoE5HbMsDgf7bm1XnWBy5SDFRp91D8WWu2PJFlwoEeuQZZ0KGu2o/vqcoSQnjMto4kPBbYKZyWYjMPVIT7n3cElVwwFyH9BzM1sOigfL1JOIIsRrPUUkvhSq+Z3DBMn7KjxCp2KIJGCy31FVVudolJFlfQfr7+QPAw/CttsyCiPY+UeoMFup4duz+GjSzRtzB/2dLAArwxZl2uFS5PYyuL5k3rN8wi2zIfNMuayww4NBI8xOySUnPU+yP0Nc7VcxC6U8TwXRI6gC6p45YbmF7zUcU1Tc6ifZH3sCZWSCcEAiFKx+cf+6zTc/Xsx5NkiuOOHZ+CbjhgFWUorF5EidRYYl5CtnXRdbejMUhZUMEeLiOjbtBfjuvTM8Ny4A6k8CynYexW8F/Zj/Vz9RU1gTkoNTUcNKw=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(376002)(136003)(451199018)(40470700004)(36840700001)(46966006)(2906002)(36756003)(2876002)(82310400005)(83380400001)(86362001)(40480700001)(336012)(2616005)(426003)(47076005)(81166007)(82740400003)(356005)(36860700001)(40460700003)(70586007)(8676002)(70206006)(110136005)(54906003)(316002)(5660300002)(8936002)(4326008)(41300700001)(1076003)(6666004)(26005)(186003)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 16:05:50.6371
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95835269-2a9f-4657-48ca-08db1037ac8e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7243
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

EF100 can pop and/or push up to two VLAN tags.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/mae.c  | 43 ++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/mcdi.h |  5 ++++
 drivers/net/ethernet/sfc/tc.c   | 53 +++++++++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/tc.h   |  4 +++
 4 files changed, 105 insertions(+)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 6321fd393fc3..7ae5b22af624 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -679,9 +679,40 @@ int efx_mae_alloc_action_set(struct efx_nic *efx, struct efx_tc_action_set *act)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_ACTION_SET_ALLOC_OUT_LEN);
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_ACTION_SET_ALLOC_IN_LEN);
+	unsigned char vlan_push, vlan_pop;
 	size_t outlen;
 	int rc;
 
+	/* Translate vlan actions from bitmask to count */
+	switch (act->vlan_push) {
+	case 0:
+	case 1:
+		vlan_push = act->vlan_push;
+		break;
+	case 2: /* can't happen */
+	default:
+		return -EINVAL;
+	case 3:
+		vlan_push = 2;
+		break;
+	}
+	switch (act->vlan_pop) {
+	case 0:
+	case 1:
+		vlan_pop = act->vlan_pop;
+		break;
+	case 2: /* can't happen */
+	default:
+		return -EINVAL;
+	case 3:
+		vlan_pop = 2;
+		break;
+	}
+
+	MCDI_POPULATE_DWORD_2(inbuf, MAE_ACTION_SET_ALLOC_IN_FLAGS,
+			      MAE_ACTION_SET_ALLOC_IN_VLAN_PUSH, vlan_push,
+			      MAE_ACTION_SET_ALLOC_IN_VLAN_POP, vlan_pop);
+
 	MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_SRC_MAC_ID,
 		       MC_CMD_MAE_MAC_ADDR_ALLOC_OUT_MAC_ID_NULL);
 	MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_DST_MAC_ID,
@@ -694,6 +725,18 @@ int efx_mae_alloc_action_set(struct efx_nic *efx, struct efx_tc_action_set *act)
 			       MC_CMD_MAE_COUNTER_ALLOC_OUT_COUNTER_ID_NULL);
 	MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_COUNTER_LIST_ID,
 		       MC_CMD_MAE_COUNTER_LIST_ALLOC_OUT_COUNTER_LIST_ID_NULL);
+	if (act->vlan_push & 1) {
+		MCDI_SET_WORD_BE(inbuf, MAE_ACTION_SET_ALLOC_IN_VLAN0_TCI_BE,
+				 act->vlan_tci[0]);
+		MCDI_SET_WORD_BE(inbuf, MAE_ACTION_SET_ALLOC_IN_VLAN0_PROTO_BE,
+				 act->vlan_proto[0]);
+	}
+	if (act->vlan_push & 2) {
+		MCDI_SET_WORD_BE(inbuf, MAE_ACTION_SET_ALLOC_IN_VLAN1_TCI_BE,
+				 act->vlan_tci[1]);
+		MCDI_SET_WORD_BE(inbuf, MAE_ACTION_SET_ALLOC_IN_VLAN1_PROTO_BE,
+				 act->vlan_proto[1]);
+	}
 	MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_ENCAP_HEADER_ID,
 		       MC_CMD_MAE_ENCAP_HEADER_ALLOC_OUT_ENCAP_HEADER_ID_NULL);
 	if (act->deliver)
diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
index b139b76febff..454e9d51a4c2 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -233,6 +233,11 @@ void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev);
 	((void)BUILD_BUG_ON_ZERO(_field ## _LEN != 2),  \
 	le16_to_cpu(*(__force const __le16 *)MCDI_STRUCT_PTR(_buf, _field)))
 /* Write a 16-bit field defined in the protocol as being big-endian. */
+#define MCDI_SET_WORD_BE(_buf, _field, _value) do {			\
+	BUILD_BUG_ON(MC_CMD_ ## _field ## _LEN != 2);			\
+	BUILD_BUG_ON(MC_CMD_ ## _field ## _OFST & 1);			\
+	*(__force __be16 *)MCDI_PTR(_buf, _field) = (_value);		\
+	} while (0)
 #define MCDI_STRUCT_SET_WORD_BE(_buf, _field, _value) do {		\
 	BUILD_BUG_ON(_field ## _LEN != 2);				\
 	BUILD_BUG_ON(_field ## _OFST & 1);				\
diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index deeaab9ee761..195c288736be 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -286,6 +286,10 @@ static int efx_tc_flower_parse_match(struct efx_nic *efx,
 
 /* For details of action order constraints refer to SF-123102-TC-1§12.6.1 */
 enum efx_tc_action_order {
+	EFX_TC_AO_VLAN1_POP,
+	EFX_TC_AO_VLAN0_POP,
+	EFX_TC_AO_VLAN0_PUSH,
+	EFX_TC_AO_VLAN1_PUSH,
 	EFX_TC_AO_COUNT,
 	EFX_TC_AO_DELIVER
 };
@@ -294,6 +298,22 @@ static bool efx_tc_flower_action_order_ok(const struct efx_tc_action_set *act,
 					  enum efx_tc_action_order new)
 {
 	switch (new) {
+	case EFX_TC_AO_VLAN0_POP:
+		if (act->vlan_pop & 1)
+			return false;
+		fallthrough;
+	case EFX_TC_AO_VLAN1_POP:
+		if (act->vlan_pop & 2)
+			return false;
+		fallthrough;
+	case EFX_TC_AO_VLAN0_PUSH:
+		if (act->vlan_push & 1)
+			return false;
+		fallthrough;
+	case EFX_TC_AO_VLAN1_PUSH:
+		if (act->vlan_push & 2)
+			return false;
+		fallthrough;
 	case EFX_TC_AO_COUNT:
 		if (act->count)
 			return false;
@@ -393,6 +413,8 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 
 	flow_action_for_each(i, fa, &fr->action) {
 		struct efx_tc_action_set save;
+		int depth;
+		u16 tci;
 
 		if (!act) {
 			/* more actions after a non-pipe action */
@@ -494,6 +516,37 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 			}
 			*act = save;
 			break;
+		case FLOW_ACTION_VLAN_POP:
+			if (act->vlan_push & 2) {
+				act->vlan_push &= ~2;
+			} else if (act->vlan_push & 1) {
+				act->vlan_push &= ~1;
+			} else if (efx_tc_flower_action_order_ok(act, EFX_TC_AO_VLAN0_POP)) {
+				act->vlan_pop |= 1;
+			} else if (efx_tc_flower_action_order_ok(act, EFX_TC_AO_VLAN1_POP)) {
+				act->vlan_pop |= 2;
+			} else {
+				NL_SET_ERR_MSG_MOD(extack, "More than two VLAN pops, or action order violated");
+				rc = -EINVAL;
+				goto release;
+			}
+			break;
+		case FLOW_ACTION_VLAN_PUSH:
+			if (efx_tc_flower_action_order_ok(act, EFX_TC_AO_VLAN0_PUSH)) {
+				depth = 0;
+			} else if (efx_tc_flower_action_order_ok(act, EFX_TC_AO_VLAN1_PUSH)) {
+				depth = 1;
+			} else {
+				rc = -EINVAL;
+				NL_SET_ERR_MSG_MOD(extack, "More than two VLAN pushes, or action order violated");
+				goto release;
+			}
+			tci = fa->vlan.vid & 0x0fff;
+			tci |= fa->vlan.prio << 13;
+			act->vlan_push |= (1 << depth);
+			act->vlan_tci[depth] = cpu_to_be16(tci);
+			act->vlan_proto[depth] = fa->vlan.proto;
+			break;
 		default:
 			NL_SET_ERR_MSG_FMT_MOD(extack, "Unhandled action %u",
 					       fa->id);
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
index 418ce8c13a06..542853f60c2a 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -19,7 +19,11 @@
 #define IS_ALL_ONES(v)	(!(typeof (v))~(v))
 
 struct efx_tc_action_set {
+	u16 vlan_push:2;
+	u16 vlan_pop:2;
 	u16 deliver:1;
+	__be16 vlan_tci[2]; /* TCIs for vlan_push */
+	__be16 vlan_proto[2]; /* Ethertypes for vlan_push */
 	struct efx_tc_counter_index *count;
 	u32 dest_mport;
 	u32 fw_id; /* index of this entry in firmware actions table */
