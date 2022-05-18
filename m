Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6F152B42C
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 10:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbiERHvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 03:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232638AbiERHvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 03:51:16 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2134.outbound.protection.outlook.com [40.107.220.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA211C915
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 00:51:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rccuy1KKq/NjwPJIxOC3+2uX+1NsytIooSNwSjuyXpkeEpbKWv0Q8PTczCvO7AoQGh5RBb7uODL8fxz7h01R71J5SK6byoRd//h/T/tUSK73JgOFX8mu/dhx/tiTSeZqWRCdUSNuG9Rk7Cj+g4UR3NoQIRCJsiilOAjP5f75HVVsGPxV5NHiYIVQzyZcrjpZbycaTx3k0ACwT23/io7kIUH/IO+3d7rvgQC69S28CDqEHQdf6HFvQfpuTT5BPSYr3XMxjZ53Tw6Oew0mfSoc+4NG13P0eDffsfPcyulF1VoRsjoYeUzW8SrjEfSIHzNqvvzc8gWeCr32MSNk2L83UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SlvSqQ82f9Om4ECq4IRyIqfC1Leyu9k5qQIxyyYPYoY=;
 b=jIGsqEfxi4MkdGGLii2cbzD1uVt5WWP7V6UDs2Md0IoXD5vHfBFsAwqJxEOvlNjbEL8D2FOx7GwzxrZi5YaGt3NKHi6Yi/y+oXAP+G81vEOo0KKqd4skECy4oofGFWt2x1JBMgMlNL2RiwKeaIdQfp3QByeOOzO35U8xHG5H2Wn0U1/lTYvI/eOcfauzlX7qBLyKxrKN56xdwf0/WVgkGnZSI2ZcwKYcM/mZ8AAk9c/aAyr4XNsWBhsw2y3gigKwIYlJ4VQKHsiSuOpm24cg/D4+4l0Rg7qJgH14N9sjpkmg6nqmYAorOAslbHyJK3Jw3bBg4t9bOsg683k4fO/0PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SlvSqQ82f9Om4ECq4IRyIqfC1Leyu9k5qQIxyyYPYoY=;
 b=ZtttbjxCnG85vL0S7PXihRxIXy12IUG2SWljzVNRBlWgrrF4Y9/CS/Jnng6AK1+ulol/wR1wiGsEHTvkSb6202W70C81d/L+FCRxPWceBpJBmfvvqfyIFAO9BXq8dbP3p6JSclM2mfRrjT16SYFUVDRqlsxwzF0vMDUN2bBDP1Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MWHPR13MB1088.namprd13.prod.outlook.com (2603:10b6:300:11::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Wed, 18 May
 2022 07:51:11 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa%6]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 07:51:11 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next] nfp: flower: support ct merging when mangle action exists
Date:   Wed, 18 May 2022 09:50:55 +0200
Message-Id: <20220518075055.130649-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR07CA0022.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::35) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6e4b3d5-3259-4837-5ecd-08da38a32cd4
X-MS-TrafficTypeDiagnostic: MWHPR13MB1088:EE_
X-Microsoft-Antispam-PRVS: <MWHPR13MB10882D179B34876935FBA135E8D19@MWHPR13MB1088.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nzcUiGwGglx5FrneIpgM8xwOk1aAR+UYwjSk6YawTnhss+N1O/jDErfrcYQ3SV6LAKccGqMdmif9BezuKeeoT6kpGPgjyoGxslBDImfKZ+Q/E7gnNU4bhMnYc2YU98ipISoS+N2qkwLgn1lzEgispvVKKCSNT7eOGOMj5W7KrbXZ7AcXqi3tMuF3eqhZWeIrn4NyfQwFZq5eQ2EmYwBBZUX7o3fnUHkdBR3mFd3rCj6GXKNUuXB/om61UsIEy1u+DxDyLWvBOzHHvQztwmL8SCzJpptCmJfetUf4WUlbvucEnd7AWzA/ALfQdKoTjrkXXg7vAjl1gODaPgopX4KmBCyUIMryqkXlOFy3MFVO1TKx3dG2VI0xyoCbyZw+u4UjDBCd44yOSJsQW1umk0EM4e/BLqto7IRobVI7IPMHDOb4oNX3HSufaL4wa1LvQouBXpcdb67r7ezBUeYpTOUmC2j0e9lzldpFI4Q5ClDR6vJSAEySFSx1GtnPPZo0yItYH83ijfaZdlii6yzDnG86wDNEGRuM5oFCln0VnJI/K0Z58CNIMLoy7t8CoN8nWs4LjtHHIqHyLVia2bYZs+Qqc+ZagPIkSFX11xTFlNZXsfjVgX2cpwG50tWcCpIWtppqi3X6XkIX9/jy2vHY5u9q7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(39840400004)(396003)(366004)(136003)(346002)(376002)(38100700002)(316002)(8936002)(107886003)(30864003)(2906002)(41300700001)(66946007)(44832011)(1076003)(2616005)(508600001)(110136005)(36756003)(83380400001)(8676002)(5660300002)(66476007)(6486002)(66556008)(6506007)(6666004)(52116002)(186003)(4326008)(86362001)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e65an3WmLFFEdLFx8WF9V5W6Ntz8fhmUCfb0e8kW7qQGr9YKHB8CQcCIKFxC?=
 =?us-ascii?Q?TDcgvmSVENXM06uM0yue/AW5iNe/O0Pq1u6FEdQ6GzGxPoGL4dYGGwI86HoF?=
 =?us-ascii?Q?qWZEmA/++1psXpOBiszubBFrCnzRHnvWVCPL7dgEhwjv5535JmERXSYMH9M4?=
 =?us-ascii?Q?vF59cvLN4HLG4zcfOB/f8aFr4p1yC9qc3lP2TX7Di5jbKbrKwB9qDdwY1e5v?=
 =?us-ascii?Q?DEURrB2gfM6cApbROxfTQoeS4OP69Kroh+swiY75kpxuwbXjUUDCLjySfHB6?=
 =?us-ascii?Q?vJ5Qe86Iiw3/QSBPuOk7XtzkX4vBTLoqnLN/18TbSFPuWAAzoA3MYJSWlYCx?=
 =?us-ascii?Q?/kmuwVLr3UervfThrinwahhIdawovpwPcOb6JDeEiihGgCpFVRWDJWSHMgq9?=
 =?us-ascii?Q?Y8srwHnoSW14BIFj+LUfkYrmp0KbYgcXhpFsCN2jsiGzCm/t/XunXsZe8Q0H?=
 =?us-ascii?Q?ynVBNamTJ6B1omXuR9CCHpdBkUy9eERwW+B/xAjiHrMnsSonsaUOH+qlavHd?=
 =?us-ascii?Q?zGL91ZJnTMJbmr99azHrkRwhMVe4E3EYfc+DiNJMa675EjqMIUJlIJFtbJnD?=
 =?us-ascii?Q?RLvZnn/8IyLOPvaozkFGB5+Bujw4YIrw/yY6hY/ADXCmGxpnFNAvS4SKehf7?=
 =?us-ascii?Q?ZxtArKxbIRqeZt/+n0LE+VJ2NSEkU5+gBAmFV9BwiLRIGhvdua+z1N291Q++?=
 =?us-ascii?Q?X9oHoaEhBmrNw1aKAinpyUUC8ojwOHg2Pet1BKJDTj6Lig58Zy5acIvmWqE7?=
 =?us-ascii?Q?ejmNKmt1lVP+CdrcIPH3jU3sqe3kH078YjUmJ4bIvM5u1lu20PVRhQyyDq+A?=
 =?us-ascii?Q?+xwrINiiW/Q3i58ZcxU5zLEdbRrTcGWS76Tfcw2VorgxWaGiutfxOGnF7tHs?=
 =?us-ascii?Q?c884BSwnFDsjgUex89aMjzKV00dQp05AkK5GfYEEQVpYu6L9nMskmb7cEOrJ?=
 =?us-ascii?Q?w/o1DRrb4lgegihVSsGUBBNBPYX4U2AODXJnrUE5BEAER54czZ4Lc3dy5RPS?=
 =?us-ascii?Q?OCHG6+45pyye9q+HdDkHJF0dXz3zS9alrBtgvrBmv48hTnPOd7fN5qZ8bw0v?=
 =?us-ascii?Q?Jq1Goe66UZ0ZiDIsEJI1N2ERLgVx2OUoThzwum6NZ5Ny37u7iP14d62PFgla?=
 =?us-ascii?Q?QZtIO/AYfFqvarI5zgz0OL5hN5QEx1KcwB6308BBZzDnnx0CHtu5VZVqODV5?=
 =?us-ascii?Q?MICtPBpvFJCFlj0Pk+Kt5R3DBV1t8msBf6B1lv1/sE0Y+pIoj3cBG1ZoBJSy?=
 =?us-ascii?Q?GwR+jQM6qfyYuBnMlkKvqMswa1bzX4mBDmBJDOXKQFwRbxWoU28+hCMGeb5R?=
 =?us-ascii?Q?jM5NhN6eI/oMk0uUzktGyXHsLmd3lZ7/NEB1kUY/P6j+R7vSjJMXqhK4ly+8?=
 =?us-ascii?Q?LqHQ8FGCXlbPIWPOUyzXwd38I/22N8W9inGVW+hrqzIC+9z2YiOVWz7EFpBz?=
 =?us-ascii?Q?7j/91Pj8VSWVvWMLNPYo58xtOv1ZbA8wYhEBQ1NkT1TnaK+KDa2secfh6Wob?=
 =?us-ascii?Q?m+ugQ9VKrdwjUYKbRWZtOzOAVExd2bF8zzNC9pagDhK2eixzROQ5hQtl7tKz?=
 =?us-ascii?Q?SzN9+kbClwlwmF97a+5kZjExus9nE5oneox2EpieysgD5zl/rvZ/iULqHZtz?=
 =?us-ascii?Q?nkt0I8T9jFBEx44rLkkKm1Z+B24fUBZsBdI4SgP6ZFqSpSjBHMJZ2m+am+af?=
 =?us-ascii?Q?FSM6hgZpbQZPz+V4ZJTLRG7l/ekNoWdGJfweWV/ggUIxxK+0lRBs7u5sCOAa?=
 =?us-ascii?Q?rbeRyhGi0qzAlv0qb0YGNxIZtud79WS5GyOB2T4LcmdOhrbOJIfD3fmuIoo4?=
X-MS-Exchange-AntiSpam-MessageData-1: 3wy8MobY7dVHXMXQ5NNJlz4ombaR7lVcGhM=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6e4b3d5-3259-4837-5ecd-08da38a32cd4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 07:51:11.1786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0OA7CgRbjw2MgEwJglf8+uDapiPrix5l3l9LAAKR/KoImfTHl9UhkSNoOn9WC5n07Mg0QP4CJQGCB4+EuBO27k4S2lBxSvh8cLKc5c0u8N0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR13MB1088
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

Current implementation of ct merging doesn't support the case
that the fields mangling in pre_ct rules are matched in post_ct
rules.

This change is to support merging when mangling mac address,
ip address, tos, ttl and l4 port. VLAN and MPLS mangling is
not involved yet.

Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/conntrack.c | 243 +++++++++++-------
 .../net/ethernet/netronome/nfp/flower/match.c |  51 +++-
 2 files changed, 189 insertions(+), 105 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index 1edcd9f86c9c..443a5d6eb57b 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -76,12 +76,119 @@ bool is_post_ct_flow(struct flow_cls_offload *flow)
 	return false;
 }
 
+/**
+ * get_mangled_key() - Mangle the key if mangle act exists
+ * @rule:	rule that carries the actions
+ * @buf:	pointer to key to be mangled
+ * @offset:	used to adjust mangled offset in L2/L3/L4 header
+ * @key_sz:	key size
+ * @htype:	mangling type
+ *
+ * Returns buf where the mangled key stores.
+ */
+static void *get_mangled_key(struct flow_rule *rule, void *buf,
+			     u32 offset, size_t key_sz,
+			     enum flow_action_mangle_base htype)
+{
+	struct flow_action_entry *act;
+	u32 *val = (u32 *)buf;
+	u32 off, msk, key;
+	int i;
+
+	flow_action_for_each(i, act, &rule->action) {
+		if (act->id == FLOW_ACTION_MANGLE &&
+		    act->mangle.htype == htype) {
+			off = act->mangle.offset - offset;
+			msk = act->mangle.mask;
+			key = act->mangle.val;
+
+			/* Mangling is supposed to be u32 aligned */
+			if (off % 4 || off >= key_sz)
+				continue;
+
+			val[off >> 2] &= msk;
+			val[off >> 2] |= key;
+		}
+	}
+
+	return buf;
+}
+
+/* Only tos and ttl are involved in flow_match_ip structure, which
+ * doesn't conform to the layout of ip/ipv6 header definition. So
+ * they need particular process here: fill them into the ip/ipv6
+ * header, so that mangling actions can work directly.
+ */
+#define NFP_IPV4_TOS_MASK	GENMASK(23, 16)
+#define NFP_IPV4_TTL_MASK	GENMASK(31, 24)
+#define NFP_IPV6_TCLASS_MASK	GENMASK(27, 20)
+#define NFP_IPV6_HLIMIT_MASK	GENMASK(7, 0)
+static void *get_mangled_tos_ttl(struct flow_rule *rule, void *buf,
+				 bool is_v6)
+{
+	struct flow_match_ip match;
+	/* IPv4's ttl field is in third dword. */
+	__be32 ip_hdr[3];
+	u32 tmp, hdr_len;
+
+	flow_rule_match_ip(rule, &match);
+
+	if (is_v6) {
+		tmp = FIELD_PREP(NFP_IPV6_TCLASS_MASK, match.key->tos);
+		ip_hdr[0] = cpu_to_be32(tmp);
+		tmp = FIELD_PREP(NFP_IPV6_HLIMIT_MASK, match.key->ttl);
+		ip_hdr[1] = cpu_to_be32(tmp);
+		hdr_len = 2 * sizeof(__be32);
+	} else {
+		tmp = FIELD_PREP(NFP_IPV4_TOS_MASK, match.key->tos);
+		ip_hdr[0] = cpu_to_be32(tmp);
+		tmp = FIELD_PREP(NFP_IPV4_TTL_MASK, match.key->ttl);
+		ip_hdr[2] = cpu_to_be32(tmp);
+		hdr_len = 3 * sizeof(__be32);
+	}
+
+	get_mangled_key(rule, ip_hdr, 0, hdr_len,
+			is_v6 ? FLOW_ACT_MANGLE_HDR_TYPE_IP6 :
+				FLOW_ACT_MANGLE_HDR_TYPE_IP4);
+
+	match.key = buf;
+
+	if (is_v6) {
+		tmp = be32_to_cpu(ip_hdr[0]);
+		match.key->tos = FIELD_GET(NFP_IPV6_TCLASS_MASK, tmp);
+		tmp = be32_to_cpu(ip_hdr[1]);
+		match.key->ttl = FIELD_GET(NFP_IPV6_HLIMIT_MASK, tmp);
+	} else {
+		tmp = be32_to_cpu(ip_hdr[0]);
+		match.key->tos = FIELD_GET(NFP_IPV4_TOS_MASK, tmp);
+		tmp = be32_to_cpu(ip_hdr[2]);
+		match.key->ttl = FIELD_GET(NFP_IPV4_TTL_MASK, tmp);
+	}
+
+	return buf;
+}
+
+/* Note entry1 and entry2 are not swappable, entry1 should be
+ * the former flow whose mangle action need be taken into account
+ * if existed, and entry2 should be the latter flow whose action
+ * we don't care.
+ */
 static int nfp_ct_merge_check(struct nfp_fl_ct_flow_entry *entry1,
 			      struct nfp_fl_ct_flow_entry *entry2)
 {
 	unsigned int ovlp_keys = entry1->rule->match.dissector->used_keys &
 				 entry2->rule->match.dissector->used_keys;
-	bool out;
+	bool out, is_v6 = false;
+	u8 ip_proto = 0;
+	/* Temporary buffer for mangling keys, 64 is enough to cover max
+	 * struct size of key in various fields that may be mangled.
+	 * Supported fileds to mangle:
+	 * mac_src/mac_dst(struct flow_match_eth_addrs, 12B)
+	 * nw_tos/nw_ttl(struct flow_match_ip, 2B)
+	 * nw_src/nw_dst(struct flow_match_ipv4/6_addrs, 32B)
+	 * tp_src/tp_dst(struct flow_match_ports, 4B)
+	 */
+	char buf[64];
 
 	if (entry1->netdev && entry2->netdev &&
 	    entry1->netdev != entry2->netdev)
@@ -105,6 +212,14 @@ static int nfp_ct_merge_check(struct nfp_fl_ct_flow_entry *entry1,
 
 		flow_rule_match_basic(entry1->rule, &match1);
 		flow_rule_match_basic(entry2->rule, &match2);
+
+		/* n_proto field is a must in ct-related flows,
+		 * it should be either ipv4 or ipv6.
+		 */
+		is_v6 = match1.key->n_proto == htons(ETH_P_IPV6);
+		/* ip_proto field is a must when port field is cared */
+		ip_proto = match1.key->ip_proto;
+
 		COMPARE_UNMASKED_FIELDS(match1, match2, &out);
 		if (out)
 			goto check_failed;
@@ -115,6 +230,13 @@ static int nfp_ct_merge_check(struct nfp_fl_ct_flow_entry *entry1,
 
 		flow_rule_match_ipv4_addrs(entry1->rule, &match1);
 		flow_rule_match_ipv4_addrs(entry2->rule, &match2);
+
+		memcpy(buf, match1.key, sizeof(*match1.key));
+		match1.key = get_mangled_key(entry1->rule, buf,
+					     offsetof(struct iphdr, saddr),
+					     sizeof(*match1.key),
+					     FLOW_ACT_MANGLE_HDR_TYPE_IP4);
+
 		COMPARE_UNMASKED_FIELDS(match1, match2, &out);
 		if (out)
 			goto check_failed;
@@ -125,16 +247,34 @@ static int nfp_ct_merge_check(struct nfp_fl_ct_flow_entry *entry1,
 
 		flow_rule_match_ipv6_addrs(entry1->rule, &match1);
 		flow_rule_match_ipv6_addrs(entry2->rule, &match2);
+
+		memcpy(buf, match1.key, sizeof(*match1.key));
+		match1.key = get_mangled_key(entry1->rule, buf,
+					     offsetof(struct ipv6hdr, saddr),
+					     sizeof(*match1.key),
+					     FLOW_ACT_MANGLE_HDR_TYPE_IP6);
+
 		COMPARE_UNMASKED_FIELDS(match1, match2, &out);
 		if (out)
 			goto check_failed;
 	}
 
 	if (ovlp_keys & BIT(FLOW_DISSECTOR_KEY_PORTS)) {
+		enum flow_action_mangle_base htype = FLOW_ACT_MANGLE_UNSPEC;
 		struct flow_match_ports match1, match2;
 
 		flow_rule_match_ports(entry1->rule, &match1);
 		flow_rule_match_ports(entry2->rule, &match2);
+
+		if (ip_proto == IPPROTO_UDP)
+			htype = FLOW_ACT_MANGLE_HDR_TYPE_UDP;
+		else if (ip_proto == IPPROTO_TCP)
+			htype = FLOW_ACT_MANGLE_HDR_TYPE_TCP;
+
+		memcpy(buf, match1.key, sizeof(*match1.key));
+		match1.key = get_mangled_key(entry1->rule, buf, 0,
+					     sizeof(*match1.key), htype);
+
 		COMPARE_UNMASKED_FIELDS(match1, match2, &out);
 		if (out)
 			goto check_failed;
@@ -145,6 +285,12 @@ static int nfp_ct_merge_check(struct nfp_fl_ct_flow_entry *entry1,
 
 		flow_rule_match_eth_addrs(entry1->rule, &match1);
 		flow_rule_match_eth_addrs(entry2->rule, &match2);
+
+		memcpy(buf, match1.key, sizeof(*match1.key));
+		match1.key = get_mangled_key(entry1->rule, buf, 0,
+					     sizeof(*match1.key),
+					     FLOW_ACT_MANGLE_HDR_TYPE_ETH);
+
 		COMPARE_UNMASKED_FIELDS(match1, match2, &out);
 		if (out)
 			goto check_failed;
@@ -185,6 +331,8 @@ static int nfp_ct_merge_check(struct nfp_fl_ct_flow_entry *entry1,
 
 		flow_rule_match_ip(entry1->rule, &match1);
 		flow_rule_match_ip(entry2->rule, &match2);
+
+		match1.key = get_mangled_tos_ttl(entry1->rule, buf, is_v6);
 		COMPARE_UNMASKED_FIELDS(match1, match2, &out);
 		if (out)
 			goto check_failed;
@@ -256,98 +404,16 @@ static int nfp_ct_merge_check(struct nfp_fl_ct_flow_entry *entry1,
 	return -EINVAL;
 }
 
-static int nfp_ct_check_mangle_merge(struct flow_action_entry *a_in,
-				     struct flow_rule *rule)
-{
-	enum flow_action_mangle_base htype = a_in->mangle.htype;
-	u32 offset = a_in->mangle.offset;
-
-	switch (htype) {
-	case FLOW_ACT_MANGLE_HDR_TYPE_ETH:
-		if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS))
-			return -EOPNOTSUPP;
-		break;
-	case FLOW_ACT_MANGLE_HDR_TYPE_IP4:
-		if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IP)) {
-			struct flow_match_ip match;
-
-			flow_rule_match_ip(rule, &match);
-			if (offset == offsetof(struct iphdr, ttl) &&
-			    match.mask->ttl)
-				return -EOPNOTSUPP;
-			if (offset == round_down(offsetof(struct iphdr, tos), 4) &&
-			    match.mask->tos)
-				return -EOPNOTSUPP;
-		}
-		if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV4_ADDRS)) {
-			struct flow_match_ipv4_addrs match;
-
-			flow_rule_match_ipv4_addrs(rule, &match);
-			if (offset == offsetof(struct iphdr, saddr) &&
-			    match.mask->src)
-				return -EOPNOTSUPP;
-			if (offset == offsetof(struct iphdr, daddr) &&
-			    match.mask->dst)
-				return -EOPNOTSUPP;
-		}
-		break;
-	case FLOW_ACT_MANGLE_HDR_TYPE_IP6:
-		if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IP)) {
-			struct flow_match_ip match;
-
-			flow_rule_match_ip(rule, &match);
-			if (offset == round_down(offsetof(struct ipv6hdr, hop_limit), 4) &&
-			    match.mask->ttl)
-				return -EOPNOTSUPP;
-			/* for ipv6, tos and flow_lbl are in the same word */
-			if (offset == round_down(offsetof(struct ipv6hdr, flow_lbl), 4) &&
-			    match.mask->tos)
-				return -EOPNOTSUPP;
-		}
-		if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV6_ADDRS)) {
-			struct flow_match_ipv6_addrs match;
-
-			flow_rule_match_ipv6_addrs(rule, &match);
-			if (offset >= offsetof(struct ipv6hdr, saddr) &&
-			    offset < offsetof(struct ipv6hdr, daddr) &&
-			    memchr_inv(&match.mask->src, 0, sizeof(match.mask->src)))
-				return -EOPNOTSUPP;
-			if (offset >= offsetof(struct ipv6hdr, daddr) &&
-			    offset < sizeof(struct ipv6hdr) &&
-			    memchr_inv(&match.mask->dst, 0, sizeof(match.mask->dst)))
-				return -EOPNOTSUPP;
-		}
-		break;
-	case FLOW_ACT_MANGLE_HDR_TYPE_TCP:
-	case FLOW_ACT_MANGLE_HDR_TYPE_UDP:
-		/* currently only can modify ports */
-		if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PORTS))
-			return -EOPNOTSUPP;
-		break;
-	default:
-		break;
-	}
-	return 0;
-}
-
 static int nfp_ct_merge_act_check(struct nfp_fl_ct_flow_entry *pre_ct_entry,
 				  struct nfp_fl_ct_flow_entry *post_ct_entry,
 				  struct nfp_fl_ct_flow_entry *nft_entry)
 {
 	struct flow_action_entry *act;
-	int err, i;
+	int i;
 
 	/* Check for pre_ct->action conflicts */
 	flow_action_for_each(i, act, &pre_ct_entry->rule->action) {
 		switch (act->id) {
-		case FLOW_ACTION_MANGLE:
-			err = nfp_ct_check_mangle_merge(act, nft_entry->rule);
-			if (err)
-				return err;
-			err = nfp_ct_check_mangle_merge(act, post_ct_entry->rule);
-			if (err)
-				return err;
-			break;
 		case FLOW_ACTION_VLAN_PUSH:
 		case FLOW_ACTION_VLAN_POP:
 		case FLOW_ACTION_VLAN_MANGLE:
@@ -363,11 +429,6 @@ static int nfp_ct_merge_act_check(struct nfp_fl_ct_flow_entry *pre_ct_entry,
 	/* Check for nft->action conflicts */
 	flow_action_for_each(i, act, &nft_entry->rule->action) {
 		switch (act->id) {
-		case FLOW_ACTION_MANGLE:
-			err = nfp_ct_check_mangle_merge(act, post_ct_entry->rule);
-			if (err)
-				return err;
-			break;
 		case FLOW_ACTION_VLAN_PUSH:
 		case FLOW_ACTION_VLAN_POP:
 		case FLOW_ACTION_VLAN_MANGLE:
@@ -924,7 +985,7 @@ static int nfp_ct_do_nft_merge(struct nfp_fl_ct_zone_entry *zt,
 	err = nfp_ct_merge_check(pre_ct_entry, nft_entry);
 	if (err)
 		return err;
-	err = nfp_ct_merge_check(post_ct_entry, nft_entry);
+	err = nfp_ct_merge_check(nft_entry, post_ct_entry);
 	if (err)
 		return err;
 	err = nfp_ct_check_meta(post_ct_entry, nft_entry);
@@ -1009,7 +1070,7 @@ static int nfp_ct_do_tc_merge(struct nfp_fl_ct_zone_entry *zt,
 	if (post_ct_entry->chain_index != pre_ct_entry->chain_index)
 		return -EINVAL;
 
-	err = nfp_ct_merge_check(post_ct_entry, pre_ct_entry);
+	err = nfp_ct_merge_check(pre_ct_entry, post_ct_entry);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/netronome/nfp/flower/match.c b/drivers/net/ethernet/netronome/nfp/flower/match.c
index 9d86eea4dc16..193a167a6762 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/match.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/match.c
@@ -98,16 +98,18 @@ nfp_flower_compile_mac(struct nfp_flower_mac_mpls *ext,
 {
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
 		struct flow_match_eth_addrs match;
+		u8 tmp;
 		int i;
 
 		flow_rule_match_eth_addrs(rule, &match);
 		/* Populate mac frame. */
 		for (i = 0; i < ETH_ALEN; i++) {
-			ext->mac_dst[i] |= match.key->dst[i] &
-					   match.mask->dst[i];
+			tmp = match.key->dst[i] & match.mask->dst[i];
+			ext->mac_dst[i] |= tmp & (~msk->mac_dst[i]);
 			msk->mac_dst[i] |= match.mask->dst[i];
-			ext->mac_src[i] |= match.key->src[i] &
-					   match.mask->src[i];
+
+			tmp = match.key->src[i] & match.mask->src[i];
+			ext->mac_src[i] |= tmp & (~msk->mac_src[i]);
 			msk->mac_src[i] |= match.mask->src[i];
 		}
 	}
@@ -189,11 +191,16 @@ nfp_flower_compile_tport(struct nfp_flower_tp_ports *ext,
 {
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PORTS)) {
 		struct flow_match_ports match;
+		__be16 tmp;
 
 		flow_rule_match_ports(rule, &match);
-		ext->port_src |= match.key->src & match.mask->src;
-		ext->port_dst |= match.key->dst & match.mask->dst;
+
+		tmp = match.key->src & match.mask->src;
+		ext->port_src |= tmp & (~msk->port_src);
 		msk->port_src |= match.mask->src;
+
+		tmp = match.key->dst & match.mask->dst;
+		ext->port_dst |= tmp & (~msk->port_dst);
 		msk->port_dst |= match.mask->dst;
 	}
 }
@@ -212,11 +219,16 @@ nfp_flower_compile_ip_ext(struct nfp_flower_ip_ext *ext,
 
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IP)) {
 		struct flow_match_ip match;
+		u8 tmp;
 
 		flow_rule_match_ip(rule, &match);
-		ext->tos |= match.key->tos & match.mask->tos;
-		ext->ttl |= match.key->ttl & match.mask->ttl;
+
+		tmp = match.key->tos & match.mask->tos;
+		ext->tos |= tmp & (~msk->tos);
 		msk->tos |= match.mask->tos;
+
+		tmp = match.key->ttl & match.mask->ttl;
+		ext->ttl |= tmp & (~msk->ttl);
 		msk->ttl |= match.mask->ttl;
 	}
 
@@ -325,11 +337,16 @@ nfp_flower_compile_ipv4(struct nfp_flower_ipv4 *ext,
 {
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV4_ADDRS)) {
 		struct flow_match_ipv4_addrs match;
+		__be32 tmp;
 
 		flow_rule_match_ipv4_addrs(rule, &match);
-		ext->ipv4_src |= match.key->src & match.mask->src;
-		ext->ipv4_dst |= match.key->dst & match.mask->dst;
+
+		tmp = match.key->src & match.mask->src;
+		ext->ipv4_src |= tmp & (~msk->ipv4_src);
 		msk->ipv4_src |= match.mask->src;
+
+		tmp = match.key->dst & match.mask->dst;
+		ext->ipv4_dst |= tmp & (~msk->ipv4_dst);
 		msk->ipv4_dst |= match.mask->dst;
 	}
 
@@ -342,15 +359,21 @@ nfp_flower_compile_ipv6(struct nfp_flower_ipv6 *ext,
 {
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV6_ADDRS)) {
 		struct flow_match_ipv6_addrs match;
+		u8 tmp;
 		int i;
 
 		flow_rule_match_ipv6_addrs(rule, &match);
 		for (i = 0; i < sizeof(ext->ipv6_src); i++) {
-			ext->ipv6_src.s6_addr[i] |= match.key->src.s6_addr[i] &
-						    match.mask->src.s6_addr[i];
-			ext->ipv6_dst.s6_addr[i] |= match.key->dst.s6_addr[i] &
-						    match.mask->dst.s6_addr[i];
+			tmp = match.key->src.s6_addr[i] &
+			      match.mask->src.s6_addr[i];
+			ext->ipv6_src.s6_addr[i] |= tmp &
+						    (~msk->ipv6_src.s6_addr[i]);
 			msk->ipv6_src.s6_addr[i] |= match.mask->src.s6_addr[i];
+
+			tmp = match.key->dst.s6_addr[i] &
+			      match.mask->dst.s6_addr[i];
+			ext->ipv6_dst.s6_addr[i] |= tmp &
+						    (~msk->ipv6_dst.s6_addr[i]);
 			msk->ipv6_dst.s6_addr[i] |= match.mask->dst.s6_addr[i];
 		}
 	}
-- 
2.30.2

