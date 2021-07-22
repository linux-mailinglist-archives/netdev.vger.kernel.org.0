Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB253D1F81
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 09:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhGVHSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 03:18:00 -0400
Received: from mail-bn8nam11on2102.outbound.protection.outlook.com ([40.107.236.102]:43163
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231187AbhGVHR4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 03:17:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UugwKY5u7K2tNwKYGnIzxryNfmwaGPbucAFrQAeqwVIyNZewLK7ASpZ46yCqH2GXcC2y1DSMu139Ch1g8ZkLh7NOIpIcW6AuR+qhdLJxQNpTBzvgB451vbdKXPVDriWgVLw3cchiOkw3YZPms5OH392fTEdlfPMxVSvacfTdszZLK2BFcCNKWTBn5ZRnGyyUPmFGHJxN/Dm7AJ7wa/lGOE55bnyzoyiY6kz+CDX0UDjMDsXs38Rqx7jZioCx5xcxjg5XcWXIu960RtdM9UNEzSBCmKPi0/daogGw/Z/x61i6imjKPwDuadGxmoFCkt5a41wDbsDGSDlq1q9j7VOGTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1F09HQD/uo9guJONJpyHbOLwoPF0MMqoKnTh+EW2lSU=;
 b=h9huoPx2NEtMHMj9ylQHwgFSqcYp2jdU5Culo633exM4uWlXXVV+I71nUKQkJRtFV94SlrRPou2jRSijFcslBWgEfD202odPSL/wSuvpeXbilVQ3Lm4xG/LwNlzqQHikruBcScG3uOusGnJzo6xFllx/x3axkysfLDPJ332sLxG5Y22v9tNzvRlWJCx7YUvThc/uZh7RsGarDh4xhVVpCMSt8oOjM5/IMxrWdky1C0qtyYk7080w67yWhgvDq98aq0/HuURPXAxU2Idu4GQFlSoAc7N71DxrhhQ1WbzH4/ORncwhaQl8rDAFc5sMnw4H6dWbj1780UYeIhKHLrJQ4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1F09HQD/uo9guJONJpyHbOLwoPF0MMqoKnTh+EW2lSU=;
 b=gvpb6ASKoET2ai4Veg7cgw+jH30iDGvggmW2JeFIRhmuhgoch/T9ku9QBMer3G+rQ+V4+NN732DpfMJHN0YjF+cigM4ZDNu5GD2F/jITnF76iR6I2amqLIZCFVya/AgRT5rtfa9ATN62yTLkkBFWr6WzxH7UxBBeiah208N0j48=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4892.namprd13.prod.outlook.com (2603:10b6:510:74::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.11; Thu, 22 Jul
 2021 07:58:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%7]) with mapi id 15.20.4352.024; Thu, 22 Jul 2021
 07:58:30 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 1/9] nfp: flower: make the match compilation functions reusable
Date:   Thu, 22 Jul 2021 09:58:00 +0200
Message-Id: <20210722075808.10095-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210722075808.10095-1-simon.horman@corigine.com>
References: <20210722075808.10095-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0136.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::41) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM0PR06CA0136.eurprd06.prod.outlook.com (2603:10a6:208:ab::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 07:58:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1c8f88e-ec3c-489f-aa61-08d94ce67e6d
X-MS-TrafficTypeDiagnostic: PH0PR13MB4892:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB48923715251995E4434C7403E8E49@PH0PR13MB4892.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7vyNnAvbTmczPqTToNOWZTvp1DQiJTGmPeoPGObV2TNUwv3HG7ZPucyErQvjTsg55NUrIvYjmCszdoGFIz4OYEtfw/06XRHKWwppUtayOcSCMccFxPa2ys4Relfy6n3ZSfXh67J20KvMz5QGtbZGdwWbn7e8ySfAYr5khL7Z4F47D0+Dti/PsHOtnJsdsoBAJ2YghzKCFrhddFvIPzjRNlwJtH8Jv2xQ6mcp/4HcpeVqDcHJLTYbJ4rDJlMo0lEmmmiYUzhw2K0jui5iwPmuG8B/pP+DYajOFhPHeVqFwDzU/r/9xyZSOTEAbemRrAeZCNVxRCOOtqL/gr62HVOeNU/i4YapvqP5zKbqB0ol4bS/obL2hbibr42aRUFE2QENWvnFtPewR2xwDfdIbw7sJqkCvqmjEwneqLduMxyw1PrDG2oRqyuSg8olaG5+0lS9N/pmkXhuv2+alGkGzU+CVoLvjdTudvm3Upw4MDkmrdIF4RnRQzk4jAAKdXal9MmRlEvwe4C+z6oWLPskDOv7BmQktC0Y1Y4rWBTGy+tpzRHbgPm3/SeKeacx8soCULqJKqErWJTU7pa9RoNQGeqgOqq0v7bD9LZnK++dEep4YUFEIQMdXO2YeALvOm1GrWu+bgk/yTezBl62v3i7jkNxJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39830400003)(396003)(136003)(346002)(52116002)(4326008)(6666004)(316002)(6506007)(1076003)(8936002)(5660300002)(30864003)(8676002)(6486002)(186003)(107886003)(6512007)(110136005)(478600001)(2906002)(54906003)(36756003)(86362001)(44832011)(83380400001)(38100700002)(2616005)(66946007)(66556008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cQAUxl+KjtKmY6PPl6kuanGPu7f2ej5hnrlBWBw6APQlKdira6h2d4/IhKd7?=
 =?us-ascii?Q?e3c5F+WJYij1+uutdlCzWFiE8SxmZK1eis8zshQVshq8iie1UPbnzVozi8co?=
 =?us-ascii?Q?lkTupdDgELwalmB51R7wydWSfiIRU9Ke+2YUmT/ascEFX9pTdIoVW4urrWV2?=
 =?us-ascii?Q?ffk3ijYysmoMwQsFWsDuyBlDjzu/otDi6z1cflNhw7S1Jlei/pz8AD8deNDo?=
 =?us-ascii?Q?6XT6me+iFkD3hQ99O8YWdWV1QAON5A0d+RCf3bgv5Q+CkrMw2YxepuykvkZH?=
 =?us-ascii?Q?EjcIppVXLRlLEAWC2cuPjoHMJ0Gc9c9ePg6/YrmVH1VRBf88tC9QUBgI55T3?=
 =?us-ascii?Q?rh0bBlpLnvcU6ecpsY3UOT9na7zIwHcvBDKbRM7tmWvmb0AjdbcNpjBrwJNY?=
 =?us-ascii?Q?5BCVXrijvOD/KGsjK1MJyT+CNwVWZaT/AQyHumx1/JSIWoLVbmNGWUFfLcIa?=
 =?us-ascii?Q?5pBsSY9mqEVUpxGAJG/V3GhMk+5eeYisycWRFtJh91ZF7oLSWTHeCPGdJ/tb?=
 =?us-ascii?Q?TMKTM7ava4j0dptI6Cbtfy2lnRgc3M7gZR8Izr/3sMT8v9o0YYusCaBTAfET?=
 =?us-ascii?Q?eiOzVJT8YiXEnli8njFpxkkp1D+pJWIFm+1uT/pfeGQKZ592nfNXMB/rVtL1?=
 =?us-ascii?Q?Dx9w87UnkCRnL/PK9Xyu3t8u4+KLKJQKzFudAfaN7gcKCeFVhN0RuYhfAclG?=
 =?us-ascii?Q?2XnIvYK6sAZ72poXfjmen8OwdwVAeBsE0y9Fv7ipTwMvjW9tEJ/m1xvu5wP8?=
 =?us-ascii?Q?QD6eGKT3Lc7TwaUuXtsWVOGmAbcbe0Agoxp1ZoR0YgBvkfezdOxNqHyvT4eZ?=
 =?us-ascii?Q?gAMEACG2ImI+tVnGvHWAsf0mM3uvhWQ6XzIvs6XaSdx5Aqovz2MzfsU/h0pP?=
 =?us-ascii?Q?TU1TV1DRC6KRl7Y5Y8BfpTQtKNAOfj4Kq4BsEgj/rXvMH7h7C2UJgg2KVZ58?=
 =?us-ascii?Q?DYlKfa7w1V+X1sePpPCkefxT1MkRszY8g/qSkoc1495FjgUgKtBA9cekv7Up?=
 =?us-ascii?Q?w5UlJG2XPqlcaUG6VCL7C+i3OEipl1gpaPrLjFX1fuYnGogbRBadoA+JJyFy?=
 =?us-ascii?Q?mVh6KZSLCllhg5vwXkKPZca8M+7iBplG/tW9Mby64wd3J+ngK4MZ4c4htL1B?=
 =?us-ascii?Q?Np0fy+Xx/EIfhYtdc289vRg4tOAdmXWu0RlorB0eSI3Npf+4IsMdQuke2+0B?=
 =?us-ascii?Q?TakvhgMDT/Y+PRSnqHG5raj6UPRFcAUwTZo3T+EhOlW3KY0LblF/qqLox5yL?=
 =?us-ascii?Q?3K/cAdmf6CAGcaWTSBQaCJrPzrHsHyUgJ8Mr5OFGPYgLFV1svt1ESrfxMI2O?=
 =?us-ascii?Q?TfKNvMNAMHx0gryinV0MfMXW/8UJeCnpD+xJgX01jE9C4aXV9y8uZZ05F2Yc?=
 =?us-ascii?Q?LDL4AquKhL3D1U8BqumKcyVvOecS?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1c8f88e-ec3c-489f-aa61-08d94ce67e6d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 07:58:29.9181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8nwLqgBjfzOSxfFX5oZiu9Tjf4MPK5LnP+Cz87dcVXT4bThaL7f66bpdZuZNqzL/WhqL0LFbuzRJK6/T0uGPQnleO3BaXhCaWcQLmt1u7ZA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4892
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

Expose and refactor the match compilation functions so that they
can be invoked externally. Also update the functions so they can
be called multiple times with the results OR'd together. This is
applicable for the flows-merging scenario, in which there could be
overlapped and non-conflicting match fields. This will be used
in upcoming conntrack patches. This is safe to do in the in the
single call case as well since both unmasked_data and mask_data
gets initialised to 0.

Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../net/ethernet/netronome/nfp/flower/main.h  |  54 +++
 .../net/ethernet/netronome/nfp/flower/match.c | 330 ++++++++++--------
 2 files changed, 239 insertions(+), 145 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 0fbd682ccf72..beb19deaeb56 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -413,6 +413,60 @@ int nfp_flower_setup_tc(struct nfp_app *app, struct net_device *netdev,
 int nfp_flower_merge_offloaded_flows(struct nfp_app *app,
 				     struct nfp_fl_payload *sub_flow1,
 				     struct nfp_fl_payload *sub_flow2);
+void
+nfp_flower_compile_meta(struct nfp_flower_meta_tci *ext,
+			struct nfp_flower_meta_tci *msk, u8 key_type);
+void
+nfp_flower_compile_tci(struct nfp_flower_meta_tci *ext,
+		       struct nfp_flower_meta_tci *msk,
+		       struct flow_rule *rule);
+void
+nfp_flower_compile_ext_meta(struct nfp_flower_ext_meta *frame, u32 key_ext);
+int
+nfp_flower_compile_port(struct nfp_flower_in_port *frame, u32 cmsg_port,
+			bool mask_version, enum nfp_flower_tun_type tun_type,
+			struct netlink_ext_ack *extack);
+void
+nfp_flower_compile_mac(struct nfp_flower_mac_mpls *ext,
+		       struct nfp_flower_mac_mpls *msk,
+		       struct flow_rule *rule);
+int
+nfp_flower_compile_mpls(struct nfp_flower_mac_mpls *ext,
+			struct nfp_flower_mac_mpls *msk,
+			struct flow_rule *rule,
+			struct netlink_ext_ack *extack);
+void
+nfp_flower_compile_tport(struct nfp_flower_tp_ports *ext,
+			 struct nfp_flower_tp_ports *msk,
+			 struct flow_rule *rule);
+void
+nfp_flower_compile_vlan(struct nfp_flower_vlan *ext,
+			struct nfp_flower_vlan *msk,
+			struct flow_rule *rule);
+void
+nfp_flower_compile_ipv4(struct nfp_flower_ipv4 *ext,
+			struct nfp_flower_ipv4 *msk, struct flow_rule *rule);
+void
+nfp_flower_compile_ipv6(struct nfp_flower_ipv6 *ext,
+			struct nfp_flower_ipv6 *msk, struct flow_rule *rule);
+void
+nfp_flower_compile_geneve_opt(u8 *ext, u8 *msk, struct flow_rule *rule);
+void
+nfp_flower_compile_ipv4_gre_tun(struct nfp_flower_ipv4_gre_tun *ext,
+				struct nfp_flower_ipv4_gre_tun *msk,
+				struct flow_rule *rule);
+void
+nfp_flower_compile_ipv4_udp_tun(struct nfp_flower_ipv4_udp_tun *ext,
+				struct nfp_flower_ipv4_udp_tun *msk,
+				struct flow_rule *rule);
+void
+nfp_flower_compile_ipv6_udp_tun(struct nfp_flower_ipv6_udp_tun *ext,
+				struct nfp_flower_ipv6_udp_tun *msk,
+				struct flow_rule *rule);
+void
+nfp_flower_compile_ipv6_gre_tun(struct nfp_flower_ipv6_gre_tun *ext,
+				struct nfp_flower_ipv6_gre_tun *msk,
+				struct flow_rule *rule);
 int nfp_flower_compile_flow_match(struct nfp_app *app,
 				  struct flow_cls_offload *flow,
 				  struct nfp_fl_key_ls *key_ls,
diff --git a/drivers/net/ethernet/netronome/nfp/flower/match.c b/drivers/net/ethernet/netronome/nfp/flower/match.c
index 255a4dff6288..9af1bd90d6c4 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/match.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/match.c
@@ -7,51 +7,68 @@
 #include "cmsg.h"
 #include "main.h"
 
-static void
-nfp_flower_compile_meta_tci(struct nfp_flower_meta_tci *ext,
-			    struct nfp_flower_meta_tci *msk,
-			    struct flow_rule *rule, u8 key_type, bool qinq_sup)
+void
+nfp_flower_compile_meta(struct nfp_flower_meta_tci *ext,
+			struct nfp_flower_meta_tci *msk, u8 key_type)
 {
-	u16 tmp_tci;
-
-	memset(ext, 0, sizeof(struct nfp_flower_meta_tci));
-	memset(msk, 0, sizeof(struct nfp_flower_meta_tci));
-
 	/* Populate the metadata frame. */
 	ext->nfp_flow_key_layer = key_type;
 	ext->mask_id = ~0;
 
 	msk->nfp_flow_key_layer = key_type;
 	msk->mask_id = ~0;
+}
 
-	if (!qinq_sup && flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
+void
+nfp_flower_compile_tci(struct nfp_flower_meta_tci *ext,
+		       struct nfp_flower_meta_tci *msk,
+		       struct flow_rule *rule)
+{
+	u16 msk_tci, key_tci;
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
 		struct flow_match_vlan match;
 
 		flow_rule_match_vlan(rule, &match);
 		/* Populate the tci field. */
-		tmp_tci = NFP_FLOWER_MASK_VLAN_PRESENT;
-		tmp_tci |= FIELD_PREP(NFP_FLOWER_MASK_VLAN_PRIO,
+		key_tci = NFP_FLOWER_MASK_VLAN_PRESENT;
+		key_tci |= FIELD_PREP(NFP_FLOWER_MASK_VLAN_PRIO,
 				      match.key->vlan_priority) |
 			   FIELD_PREP(NFP_FLOWER_MASK_VLAN_VID,
 				      match.key->vlan_id);
-		ext->tci = cpu_to_be16(tmp_tci);
 
-		tmp_tci = NFP_FLOWER_MASK_VLAN_PRESENT;
-		tmp_tci |= FIELD_PREP(NFP_FLOWER_MASK_VLAN_PRIO,
+		msk_tci = NFP_FLOWER_MASK_VLAN_PRESENT;
+		msk_tci |= FIELD_PREP(NFP_FLOWER_MASK_VLAN_PRIO,
 				      match.mask->vlan_priority) |
 			   FIELD_PREP(NFP_FLOWER_MASK_VLAN_VID,
 				      match.mask->vlan_id);
-		msk->tci = cpu_to_be16(tmp_tci);
+
+		ext->tci |= cpu_to_be16((key_tci & msk_tci));
+		msk->tci |= cpu_to_be16(msk_tci);
 	}
 }
 
 static void
+nfp_flower_compile_meta_tci(struct nfp_flower_meta_tci *ext,
+			    struct nfp_flower_meta_tci *msk,
+			    struct flow_rule *rule, u8 key_type, bool qinq_sup)
+{
+	memset(ext, 0, sizeof(struct nfp_flower_meta_tci));
+	memset(msk, 0, sizeof(struct nfp_flower_meta_tci));
+
+	nfp_flower_compile_meta(ext, msk, key_type);
+
+	if (!qinq_sup)
+		nfp_flower_compile_tci(ext, msk, rule);
+}
+
+void
 nfp_flower_compile_ext_meta(struct nfp_flower_ext_meta *frame, u32 key_ext)
 {
 	frame->nfp_flow_key_layer2 = cpu_to_be32(key_ext);
 }
 
-static int
+int
 nfp_flower_compile_port(struct nfp_flower_in_port *frame, u32 cmsg_port,
 			bool mask_version, enum nfp_flower_tun_type tun_type,
 			struct netlink_ext_ack *extack)
@@ -74,28 +91,37 @@ nfp_flower_compile_port(struct nfp_flower_in_port *frame, u32 cmsg_port,
 	return 0;
 }
 
-static int
+void
 nfp_flower_compile_mac(struct nfp_flower_mac_mpls *ext,
-		       struct nfp_flower_mac_mpls *msk, struct flow_rule *rule,
-		       struct netlink_ext_ack *extack)
+		       struct nfp_flower_mac_mpls *msk,
+		       struct flow_rule *rule)
 {
-	memset(ext, 0, sizeof(struct nfp_flower_mac_mpls));
-	memset(msk, 0, sizeof(struct nfp_flower_mac_mpls));
-
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
 		struct flow_match_eth_addrs match;
+		int i;
 
 		flow_rule_match_eth_addrs(rule, &match);
 		/* Populate mac frame. */
-		ether_addr_copy(ext->mac_dst, &match.key->dst[0]);
-		ether_addr_copy(ext->mac_src, &match.key->src[0]);
-		ether_addr_copy(msk->mac_dst, &match.mask->dst[0]);
-		ether_addr_copy(msk->mac_src, &match.mask->src[0]);
+		for (i = 0; i < ETH_ALEN; i++) {
+			ext->mac_dst[i] |= match.key->dst[i] &
+					   match.mask->dst[i];
+			msk->mac_dst[i] |= match.mask->dst[i];
+			ext->mac_src[i] |= match.key->src[i] &
+					   match.mask->src[i];
+			msk->mac_src[i] |= match.mask->src[i];
+		}
 	}
+}
 
+int
+nfp_flower_compile_mpls(struct nfp_flower_mac_mpls *ext,
+			struct nfp_flower_mac_mpls *msk,
+			struct flow_rule *rule,
+			struct netlink_ext_ack *extack)
+{
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_MPLS)) {
 		struct flow_match_mpls match;
-		u32 t_mpls;
+		u32 key_mpls, msk_mpls;
 
 		flow_rule_match_mpls(rule, &match);
 
@@ -106,22 +132,24 @@ nfp_flower_compile_mac(struct nfp_flower_mac_mpls *ext,
 			return -EOPNOTSUPP;
 		}
 
-		t_mpls = FIELD_PREP(NFP_FLOWER_MASK_MPLS_LB,
-				    match.key->ls[0].mpls_label) |
-			 FIELD_PREP(NFP_FLOWER_MASK_MPLS_TC,
-				    match.key->ls[0].mpls_tc) |
-			 FIELD_PREP(NFP_FLOWER_MASK_MPLS_BOS,
-				    match.key->ls[0].mpls_bos) |
-			 NFP_FLOWER_MASK_MPLS_Q;
-		ext->mpls_lse = cpu_to_be32(t_mpls);
-		t_mpls = FIELD_PREP(NFP_FLOWER_MASK_MPLS_LB,
-				    match.mask->ls[0].mpls_label) |
-			 FIELD_PREP(NFP_FLOWER_MASK_MPLS_TC,
-				    match.mask->ls[0].mpls_tc) |
-			 FIELD_PREP(NFP_FLOWER_MASK_MPLS_BOS,
-				    match.mask->ls[0].mpls_bos) |
-			 NFP_FLOWER_MASK_MPLS_Q;
-		msk->mpls_lse = cpu_to_be32(t_mpls);
+		key_mpls = FIELD_PREP(NFP_FLOWER_MASK_MPLS_LB,
+				      match.key->ls[0].mpls_label) |
+			   FIELD_PREP(NFP_FLOWER_MASK_MPLS_TC,
+				      match.key->ls[0].mpls_tc) |
+			   FIELD_PREP(NFP_FLOWER_MASK_MPLS_BOS,
+				      match.key->ls[0].mpls_bos) |
+			   NFP_FLOWER_MASK_MPLS_Q;
+
+		msk_mpls = FIELD_PREP(NFP_FLOWER_MASK_MPLS_LB,
+				      match.mask->ls[0].mpls_label) |
+			   FIELD_PREP(NFP_FLOWER_MASK_MPLS_TC,
+				      match.mask->ls[0].mpls_tc) |
+			   FIELD_PREP(NFP_FLOWER_MASK_MPLS_BOS,
+				      match.mask->ls[0].mpls_bos) |
+			   NFP_FLOWER_MASK_MPLS_Q;
+
+		ext->mpls_lse |= cpu_to_be32((key_mpls & msk_mpls));
+		msk->mpls_lse |= cpu_to_be32(msk_mpls);
 	} else if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
 		/* Check for mpls ether type and set NFP_FLOWER_MASK_MPLS_Q
 		 * bit, which indicates an mpls ether type but without any
@@ -132,30 +160,41 @@ nfp_flower_compile_mac(struct nfp_flower_mac_mpls *ext,
 		flow_rule_match_basic(rule, &match);
 		if (match.key->n_proto == cpu_to_be16(ETH_P_MPLS_UC) ||
 		    match.key->n_proto == cpu_to_be16(ETH_P_MPLS_MC)) {
-			ext->mpls_lse = cpu_to_be32(NFP_FLOWER_MASK_MPLS_Q);
-			msk->mpls_lse = cpu_to_be32(NFP_FLOWER_MASK_MPLS_Q);
+			ext->mpls_lse |= cpu_to_be32(NFP_FLOWER_MASK_MPLS_Q);
+			msk->mpls_lse |= cpu_to_be32(NFP_FLOWER_MASK_MPLS_Q);
 		}
 	}
 
 	return 0;
 }
 
-static void
+static int
+nfp_flower_compile_mac_mpls(struct nfp_flower_mac_mpls *ext,
+			    struct nfp_flower_mac_mpls *msk,
+			    struct flow_rule *rule,
+			    struct netlink_ext_ack *extack)
+{
+	memset(ext, 0, sizeof(struct nfp_flower_mac_mpls));
+	memset(msk, 0, sizeof(struct nfp_flower_mac_mpls));
+
+	nfp_flower_compile_mac(ext, msk, rule);
+
+	return nfp_flower_compile_mpls(ext, msk, rule, extack);
+}
+
+void
 nfp_flower_compile_tport(struct nfp_flower_tp_ports *ext,
 			 struct nfp_flower_tp_ports *msk,
 			 struct flow_rule *rule)
 {
-	memset(ext, 0, sizeof(struct nfp_flower_tp_ports));
-	memset(msk, 0, sizeof(struct nfp_flower_tp_ports));
-
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PORTS)) {
 		struct flow_match_ports match;
 
 		flow_rule_match_ports(rule, &match);
-		ext->port_src = match.key->src;
-		ext->port_dst = match.key->dst;
-		msk->port_src = match.mask->src;
-		msk->port_dst = match.mask->dst;
+		ext->port_src |= match.key->src & match.mask->src;
+		ext->port_dst |= match.key->dst & match.mask->dst;
+		msk->port_src |= match.mask->src;
+		msk->port_dst |= match.mask->dst;
 	}
 }
 
@@ -167,18 +206,18 @@ nfp_flower_compile_ip_ext(struct nfp_flower_ip_ext *ext,
 		struct flow_match_basic match;
 
 		flow_rule_match_basic(rule, &match);
-		ext->proto = match.key->ip_proto;
-		msk->proto = match.mask->ip_proto;
+		ext->proto |= match.key->ip_proto & match.mask->ip_proto;
+		msk->proto |= match.mask->ip_proto;
 	}
 
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IP)) {
 		struct flow_match_ip match;
 
 		flow_rule_match_ip(rule, &match);
-		ext->tos = match.key->tos;
-		ext->ttl = match.key->ttl;
-		msk->tos = match.mask->tos;
-		msk->ttl = match.mask->ttl;
+		ext->tos |= match.key->tos & match.mask->tos;
+		ext->ttl |= match.key->ttl & match.mask->ttl;
+		msk->tos |= match.mask->tos;
+		msk->ttl |= match.mask->ttl;
 	}
 
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_TCP)) {
@@ -231,99 +270,108 @@ nfp_flower_compile_ip_ext(struct nfp_flower_ip_ext *ext,
 }
 
 static void
-nfp_flower_fill_vlan(struct flow_dissector_key_vlan *key,
-		     struct nfp_flower_vlan *frame,
-		     bool outer_vlan)
+nfp_flower_fill_vlan(struct flow_match_vlan *match,
+		     struct nfp_flower_vlan *ext,
+		     struct nfp_flower_vlan *msk, bool outer_vlan)
 {
-	u16 tci;
-
-	tci = NFP_FLOWER_MASK_VLAN_PRESENT;
-	tci |= FIELD_PREP(NFP_FLOWER_MASK_VLAN_PRIO,
-			  key->vlan_priority) |
-	       FIELD_PREP(NFP_FLOWER_MASK_VLAN_VID,
-			  key->vlan_id);
+	struct flow_dissector_key_vlan *mask = match->mask;
+	struct flow_dissector_key_vlan *key = match->key;
+	u16 msk_tci, key_tci;
+
+	key_tci = NFP_FLOWER_MASK_VLAN_PRESENT;
+	key_tci |= FIELD_PREP(NFP_FLOWER_MASK_VLAN_PRIO,
+			      key->vlan_priority) |
+		   FIELD_PREP(NFP_FLOWER_MASK_VLAN_VID,
+			      key->vlan_id);
+	msk_tci = NFP_FLOWER_MASK_VLAN_PRESENT;
+	msk_tci |= FIELD_PREP(NFP_FLOWER_MASK_VLAN_PRIO,
+			      mask->vlan_priority) |
+		   FIELD_PREP(NFP_FLOWER_MASK_VLAN_VID,
+			      mask->vlan_id);
 
 	if (outer_vlan) {
-		frame->outer_tci = cpu_to_be16(tci);
-		frame->outer_tpid = key->vlan_tpid;
+		ext->outer_tci |= cpu_to_be16((key_tci & msk_tci));
+		ext->outer_tpid |= key->vlan_tpid & mask->vlan_tpid;
+		msk->outer_tci |= cpu_to_be16(msk_tci);
+		msk->outer_tpid |= mask->vlan_tpid;
 	} else {
-		frame->inner_tci = cpu_to_be16(tci);
-		frame->inner_tpid = key->vlan_tpid;
+		ext->inner_tci |= cpu_to_be16((key_tci & msk_tci));
+		ext->inner_tpid |= key->vlan_tpid & mask->vlan_tpid;
+		msk->inner_tci |= cpu_to_be16(msk_tci);
+		msk->inner_tpid |= mask->vlan_tpid;
 	}
 }
 
-static void
+void
 nfp_flower_compile_vlan(struct nfp_flower_vlan *ext,
 			struct nfp_flower_vlan *msk,
 			struct flow_rule *rule)
 {
 	struct flow_match_vlan match;
 
-	memset(ext, 0, sizeof(struct nfp_flower_vlan));
-	memset(msk, 0, sizeof(struct nfp_flower_vlan));
-
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
 		flow_rule_match_vlan(rule, &match);
-		nfp_flower_fill_vlan(match.key, ext, true);
-		nfp_flower_fill_vlan(match.mask, msk, true);
+		nfp_flower_fill_vlan(&match, ext, msk, true);
 	}
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CVLAN)) {
 		flow_rule_match_cvlan(rule, &match);
-		nfp_flower_fill_vlan(match.key, ext, false);
-		nfp_flower_fill_vlan(match.mask, msk, false);
+		nfp_flower_fill_vlan(&match, ext, msk, false);
 	}
 }
 
-static void
+void
 nfp_flower_compile_ipv4(struct nfp_flower_ipv4 *ext,
 			struct nfp_flower_ipv4 *msk, struct flow_rule *rule)
 {
-	struct flow_match_ipv4_addrs match;
-
-	memset(ext, 0, sizeof(struct nfp_flower_ipv4));
-	memset(msk, 0, sizeof(struct nfp_flower_ipv4));
-
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV4_ADDRS)) {
+		struct flow_match_ipv4_addrs match;
+
 		flow_rule_match_ipv4_addrs(rule, &match);
-		ext->ipv4_src = match.key->src;
-		ext->ipv4_dst = match.key->dst;
-		msk->ipv4_src = match.mask->src;
-		msk->ipv4_dst = match.mask->dst;
+		ext->ipv4_src |= match.key->src & match.mask->src;
+		ext->ipv4_dst |= match.key->dst & match.mask->dst;
+		msk->ipv4_src |= match.mask->src;
+		msk->ipv4_dst |= match.mask->dst;
 	}
 
 	nfp_flower_compile_ip_ext(&ext->ip_ext, &msk->ip_ext, rule);
 }
 
-static void
+void
 nfp_flower_compile_ipv6(struct nfp_flower_ipv6 *ext,
 			struct nfp_flower_ipv6 *msk, struct flow_rule *rule)
 {
-	memset(ext, 0, sizeof(struct nfp_flower_ipv6));
-	memset(msk, 0, sizeof(struct nfp_flower_ipv6));
-
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV6_ADDRS)) {
 		struct flow_match_ipv6_addrs match;
+		int i;
 
 		flow_rule_match_ipv6_addrs(rule, &match);
-		ext->ipv6_src = match.key->src;
-		ext->ipv6_dst = match.key->dst;
-		msk->ipv6_src = match.mask->src;
-		msk->ipv6_dst = match.mask->dst;
+		for (i = 0; i < sizeof(ext->ipv6_src); i++) {
+			ext->ipv6_src.s6_addr[i] |= match.key->src.s6_addr[i] &
+						    match.mask->src.s6_addr[i];
+			ext->ipv6_dst.s6_addr[i] |= match.key->dst.s6_addr[i] &
+						    match.mask->dst.s6_addr[i];
+			msk->ipv6_src.s6_addr[i] |= match.mask->src.s6_addr[i];
+			msk->ipv6_dst.s6_addr[i] |= match.mask->dst.s6_addr[i];
+		}
 	}
 
 	nfp_flower_compile_ip_ext(&ext->ip_ext, &msk->ip_ext, rule);
 }
 
-static int
-nfp_flower_compile_geneve_opt(void *ext, void *msk, struct flow_rule *rule)
+void
+nfp_flower_compile_geneve_opt(u8 *ext, u8 *msk, struct flow_rule *rule)
 {
 	struct flow_match_enc_opts match;
+	int i;
 
-	flow_rule_match_enc_opts(rule, &match);
-	memcpy(ext, match.key->data, match.key->len);
-	memcpy(msk, match.mask->data, match.mask->len);
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_OPTS)) {
+		flow_rule_match_enc_opts(rule, &match);
 
-	return 0;
+		for (i = 0; i < match.mask->len; i++) {
+			ext[i] |= match.key->data[i] & match.mask->data[i];
+			msk[i] |= match.mask->data[i];
+		}
+	}
 }
 
 static void
@@ -335,10 +383,10 @@ nfp_flower_compile_tun_ipv4_addrs(struct nfp_flower_tun_ipv4 *ext,
 		struct flow_match_ipv4_addrs match;
 
 		flow_rule_match_enc_ipv4_addrs(rule, &match);
-		ext->src = match.key->src;
-		ext->dst = match.key->dst;
-		msk->src = match.mask->src;
-		msk->dst = match.mask->dst;
+		ext->src |= match.key->src & match.mask->src;
+		ext->dst |= match.key->dst & match.mask->dst;
+		msk->src |= match.mask->src;
+		msk->dst |= match.mask->dst;
 	}
 }
 
@@ -349,12 +397,17 @@ nfp_flower_compile_tun_ipv6_addrs(struct nfp_flower_tun_ipv6 *ext,
 {
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS)) {
 		struct flow_match_ipv6_addrs match;
+		int i;
 
 		flow_rule_match_enc_ipv6_addrs(rule, &match);
-		ext->src = match.key->src;
-		ext->dst = match.key->dst;
-		msk->src = match.mask->src;
-		msk->dst = match.mask->dst;
+		for (i = 0; i < sizeof(ext->src); i++) {
+			ext->src.s6_addr[i] |= match.key->src.s6_addr[i] &
+					       match.mask->src.s6_addr[i];
+			ext->dst.s6_addr[i] |= match.key->dst.s6_addr[i] &
+					       match.mask->dst.s6_addr[i];
+			msk->src.s6_addr[i] |= match.mask->src.s6_addr[i];
+			msk->dst.s6_addr[i] |= match.mask->dst.s6_addr[i];
+		}
 	}
 }
 
@@ -367,10 +420,10 @@ nfp_flower_compile_tun_ip_ext(struct nfp_flower_tun_ip_ext *ext,
 		struct flow_match_ip match;
 
 		flow_rule_match_enc_ip(rule, &match);
-		ext->tos = match.key->tos;
-		ext->ttl = match.key->ttl;
-		msk->tos = match.mask->tos;
-		msk->ttl = match.mask->ttl;
+		ext->tos |= match.key->tos & match.mask->tos;
+		ext->ttl |= match.key->ttl & match.mask->ttl;
+		msk->tos |= match.mask->tos;
+		msk->ttl |= match.mask->ttl;
 	}
 }
 
@@ -383,10 +436,11 @@ nfp_flower_compile_tun_udp_key(__be32 *key, __be32 *key_msk,
 		u32 vni;
 
 		flow_rule_match_enc_keyid(rule, &match);
-		vni = be32_to_cpu(match.key->keyid) << NFP_FL_TUN_VNI_OFFSET;
-		*key = cpu_to_be32(vni);
+		vni = be32_to_cpu((match.key->keyid & match.mask->keyid)) <<
+		      NFP_FL_TUN_VNI_OFFSET;
+		*key |= cpu_to_be32(vni);
 		vni = be32_to_cpu(match.mask->keyid) << NFP_FL_TUN_VNI_OFFSET;
-		*key_msk = cpu_to_be32(vni);
+		*key_msk |= cpu_to_be32(vni);
 	}
 }
 
@@ -398,22 +452,19 @@ nfp_flower_compile_tun_gre_key(__be32 *key, __be32 *key_msk, __be16 *flags,
 		struct flow_match_enc_keyid match;
 
 		flow_rule_match_enc_keyid(rule, &match);
-		*key = match.key->keyid;
-		*key_msk = match.mask->keyid;
+		*key |= match.key->keyid & match.mask->keyid;
+		*key_msk |= match.mask->keyid;
 
 		*flags = cpu_to_be16(NFP_FL_GRE_FLAG_KEY);
 		*flags_msk = cpu_to_be16(NFP_FL_GRE_FLAG_KEY);
 	}
 }
 
-static void
+void
 nfp_flower_compile_ipv4_gre_tun(struct nfp_flower_ipv4_gre_tun *ext,
 				struct nfp_flower_ipv4_gre_tun *msk,
 				struct flow_rule *rule)
 {
-	memset(ext, 0, sizeof(struct nfp_flower_ipv4_gre_tun));
-	memset(msk, 0, sizeof(struct nfp_flower_ipv4_gre_tun));
-
 	/* NVGRE is the only supported GRE tunnel type */
 	ext->ethertype = cpu_to_be16(ETH_P_TEB);
 	msk->ethertype = cpu_to_be16(~0);
@@ -424,40 +475,31 @@ nfp_flower_compile_ipv4_gre_tun(struct nfp_flower_ipv4_gre_tun *ext,
 				       &ext->tun_flags, &msk->tun_flags, rule);
 }
 
-static void
+void
 nfp_flower_compile_ipv4_udp_tun(struct nfp_flower_ipv4_udp_tun *ext,
 				struct nfp_flower_ipv4_udp_tun *msk,
 				struct flow_rule *rule)
 {
-	memset(ext, 0, sizeof(struct nfp_flower_ipv4_udp_tun));
-	memset(msk, 0, sizeof(struct nfp_flower_ipv4_udp_tun));
-
 	nfp_flower_compile_tun_ipv4_addrs(&ext->ipv4, &msk->ipv4, rule);
 	nfp_flower_compile_tun_ip_ext(&ext->ip_ext, &msk->ip_ext, rule);
 	nfp_flower_compile_tun_udp_key(&ext->tun_id, &msk->tun_id, rule);
 }
 
-static void
+void
 nfp_flower_compile_ipv6_udp_tun(struct nfp_flower_ipv6_udp_tun *ext,
 				struct nfp_flower_ipv6_udp_tun *msk,
 				struct flow_rule *rule)
 {
-	memset(ext, 0, sizeof(struct nfp_flower_ipv6_udp_tun));
-	memset(msk, 0, sizeof(struct nfp_flower_ipv6_udp_tun));
-
 	nfp_flower_compile_tun_ipv6_addrs(&ext->ipv6, &msk->ipv6, rule);
 	nfp_flower_compile_tun_ip_ext(&ext->ip_ext, &msk->ip_ext, rule);
 	nfp_flower_compile_tun_udp_key(&ext->tun_id, &msk->tun_id, rule);
 }
 
-static void
+void
 nfp_flower_compile_ipv6_gre_tun(struct nfp_flower_ipv6_gre_tun *ext,
 				struct nfp_flower_ipv6_gre_tun *msk,
 				struct flow_rule *rule)
 {
-	memset(ext, 0, sizeof(struct nfp_flower_ipv6_gre_tun));
-	memset(msk, 0, sizeof(struct nfp_flower_ipv6_gre_tun));
-
 	/* NVGRE is the only supported GRE tunnel type */
 	ext->ethertype = cpu_to_be16(ETH_P_TEB);
 	msk->ethertype = cpu_to_be16(~0);
@@ -527,9 +569,9 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 	msk += sizeof(struct nfp_flower_in_port);
 
 	if (NFP_FLOWER_LAYER_MAC & key_ls->key_layer) {
-		err = nfp_flower_compile_mac((struct nfp_flower_mac_mpls *)ext,
-					     (struct nfp_flower_mac_mpls *)msk,
-					     rule, extack);
+		err = nfp_flower_compile_mac_mpls((struct nfp_flower_mac_mpls *)ext,
+						  (struct nfp_flower_mac_mpls *)msk,
+						  rule, extack);
 		if (err)
 			return err;
 
@@ -640,9 +682,7 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 		}
 
 		if (key_ls->key_layer_two & NFP_FLOWER_LAYER2_GENEVE_OP) {
-			err = nfp_flower_compile_geneve_opt(ext, msk, rule);
-			if (err)
-				return err;
+			nfp_flower_compile_geneve_opt(ext, msk, rule);
 		}
 	}
 
-- 
2.20.1

