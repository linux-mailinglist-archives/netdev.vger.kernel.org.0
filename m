Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D0E3A96CC
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 12:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbhFPKFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 06:05:07 -0400
Received: from mail-mw2nam10on2094.outbound.protection.outlook.com ([40.107.94.94]:30432
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232333AbhFPKEy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 06:04:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dsMuHPNctGo9gxW2ImZTOeV7CyvxpTtv3PaQFzkKlJ/yV2GGnXOpYKlI7nEdQlOJ/Cm3GjG1A5ytJ0yww1W0j3SPjLTAaxeFMOwb0bqujGuJFC2X7UkckaRMrNOyFCxdldfgJxe/sfIhAd6qjPeSCvtFsTh0vk6JKX4c6Sw6QDRmBV21sBTA4S+B3KaMGWc0tcQtMCkr5RuWrGhrMVlF1Hah1cvV3GT0lprmJCWgsmptadZojr/wk1jLCj+qje2DkGztcOgTfiSkZRZoap8BMD20YE0pc32JQKAsP6o28sC9SVCVOvzMOxyQoDCPU1oZ6pYUOZnsuHmFoedjD1dtHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Di2/dmf2vRq6E99DTr8edjSLMNOD9qjiMejaEF4u68E=;
 b=SYp8HfAvmlPESe34vxeYFsSRbYQH9Ef+eUKKxN4NOTvK9vx0F3L9JpbQhRzMe+ltRMplWUQAgghmX0HOhaO2MUQl5Dm8JFRVoCDJ7ajXpAoZCDsJ57OJFcZOZmEA2BvRxoqnchM0rSpQeQ2BcRLFBMP/qrqkQ+NVKFXAKphb6dTUXJpqFfdKrkOrmacxxUL9lRcjdj5nRMhM8E/msVRiXNtnkVGCJj3+JV6dVa5WrrfdTIpfwr1TaIJuBpO1TU3JlZxAKI6lWvuuyns24N3PGS8C1xXq8PY/4cNE8/Ax8l8jlAT/Egnjq4mv2kiAXM1cp4Sadhu6xKbdYQcK31JSMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Di2/dmf2vRq6E99DTr8edjSLMNOD9qjiMejaEF4u68E=;
 b=QQjgmeTQcAB5VAtdIEaNeRePEjeToNuJNhT5svsnUTNDi+OMkfoyOYz5iBHDzNzit6XZ5tS2qdhKheUGHtywVQBRsRs4pK46KCK1Sa8rnx0RQchq50sINILTo1fJA34UUPIaudtD22/JFZo8DCVrSKeY8vyPFOWe8mWfTTeYYGM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4971.namprd13.prod.outlook.com (2603:10b6:510:98::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.7; Wed, 16 Jun
 2021 10:02:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 10:02:37 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 7/9] nfp: flower-ct: fill in ct merge check function
Date:   Wed, 16 Jun 2021 12:02:05 +0200
Message-Id: <20210616100207.14415-8-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210616100207.14415-1-simon.horman@corigine.com>
References: <20210616100207.14415-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:982:756:703:d63d:7eff:fe99:ac9d]
X-ClientProxiedBy: AM0PR10CA0022.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM0PR10CA0022.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend Transport; Wed, 16 Jun 2021 10:02:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69f852e1-cea6-4dcd-6475-08d930adde5b
X-MS-TrafficTypeDiagnostic: PH0PR13MB4971:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4971C522B4F2C77E4100099AE80F9@PH0PR13MB4971.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PsIbdUjnDu9u0mghlEpcerADi3d2zOLzCQKDEMGcrvTFH5Qz2bloPOEwqqWVxCspaAr1ebzHRfICWmHtClaGT0zMo272YhVKWQMtoBfyG9ZYgReheEv72Wigxhhdfv7RQOYK5j4J7Sqwox3EmXsyp7D6/Qy0rK5VRv+Av037nyI7pdfv9GdAEEl9LkBoKOaATkhgStspBdrdkH1nvsZ61im3J4zWak8HYxSSDNzjnNWaiybSHpSK58u79rJ21MT+68Kljh7qGCxSiAY8p0Wo0IA81WdXJIwrhp5zrcQSqOMpOJG7W+/RtyTf6Wc+zGYNE7qnYK7QV3NwMEjuhR7W6jqSY4mUPpS0l0bvu2XSd6UGwWzQ37rYwvI/xuJnMClptU4iF9cJOPSLkRW7Bc7QVsC+jtsFN75wgVrjRzXp5bAf2O6yG3nIhKozbx2/NSvENeR31c9rTrEl5vC/oI0lBvV1Ij2Ybkn6eecQAIL0EpGhb9kXKBVjaj9NsHW8jDAUu9kjtZ5XqnpmFYE3aNezFXJGv/TnbKKHAJ8JxPAYO6M+mMBxm5mB/3xP1lXUC33SqRenM1f4DDryUGPvHRZ5XpVRG6Ny5tzTPrsXd2YF7gRLZXr3AMsz+y5bSVVq9LZhtk5ZG3SKjVjvOyhg14izpQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(366004)(346002)(39830400003)(66476007)(6512007)(8936002)(66556008)(66946007)(38100700002)(4326008)(86362001)(2616005)(6666004)(6506007)(5660300002)(8676002)(478600001)(1076003)(110136005)(2906002)(316002)(54906003)(16526019)(186003)(107886003)(52116002)(6486002)(36756003)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KkpsApasKktg4rTWAQR1vg4EDC2pa7mpJCi7951vtQpiid7MpV65hhenvPU1?=
 =?us-ascii?Q?VgWm/MwytrhQqTRWztwf4+gDUzx9nDUUsakGWDGktQSg2xoI//3NjQKrdFaF?=
 =?us-ascii?Q?V+L2fkP60bS0sYqIfF83dYbl+JbYX4aOfYYK1N2AgjBFrwk2uZNZErPz7m37?=
 =?us-ascii?Q?7MMooEdn3+GfKpAJQXEyNbGMM5z/ZMb1fiuQi3ttCdWaof2NV7IK/LnePxfy?=
 =?us-ascii?Q?QXk6blGFbwE5v/fgNgx64Dz91OtX3G8vSn8ePaTVwj9Ms8nkqROXYdWZzxoF?=
 =?us-ascii?Q?3TXC4IIv2gSbwOqumtQ/oS++3nm9KuSmUAkVXr6ahExsWo+YWOwh+p7Z7uqI?=
 =?us-ascii?Q?aQoOg3Hwtx3Irz6r7ZjWagUBNvIGQq7MQntMlUnu7d8i/5z8XZ16VNAeYnp1?=
 =?us-ascii?Q?DdWCb8Ir0YpjwevojO3eVxc5BCa9MwJQr8kEDIzSQ58FO8IW5qK6VaJu+mg+?=
 =?us-ascii?Q?L5/F0K+lFr3RJvBjhL86Wp1b4WKKQF7nt6GrF2W1HdznGH2QyNVJodMeJZmX?=
 =?us-ascii?Q?2D3XIIMNb7SGKXWO1b/8w+WqAye9H5MbdJm4Bu+VeWjL9VUZpUZplu5H6p4X?=
 =?us-ascii?Q?R97wl2Vtca8OR3TGk1p+8HIi+BJxG3RfNx8hLdPx9ibTEG+o54D7W1lcKCBb?=
 =?us-ascii?Q?ApSBazrtqL23OnzcCBaqiyBbhhXi4DDOo8Ci8HOgOoC2pUWYnE6HLeDzNwVR?=
 =?us-ascii?Q?v3E7XthkW9pbIiTi21cfYQbwJwiieZhrvxtCeXwthh6w8pnFa0y22uT/6ina?=
 =?us-ascii?Q?5zrue0gMGZ4LIxugE1OmYCerF0KAd8xLBY2mdoXfLIFPwujtjeovmL1mS8Hc?=
 =?us-ascii?Q?SyooOUm2KloUm5TlKg+qACPzyZTGdnXkZ3tWHiBQMu0ICS0/krUHn08WvjAE?=
 =?us-ascii?Q?4HFIEzL0q6CeRHOjIq/ptzbPOlCP2vj8xPqmMWiT9W5a2V+S5EcW8lA+3cj1?=
 =?us-ascii?Q?YIruOC9keSWaBqamEZmtugykIAsRhC2jIiymlLdAilr2dt0B6Ku+s9BjyeD5?=
 =?us-ascii?Q?ziumvEB9xClV8dSLGWJ3xJMPgWx/3w6vZymLPH06qT7tCe3sKALkpVEgT1Ci?=
 =?us-ascii?Q?lf0bkRe3wJO4RXWQVCin0Ktq1S6htF/3Add5M+gm5QzzgHM2fSIJI93+x+Nd?=
 =?us-ascii?Q?kYeMAXzK8roT9XRYDgMMOdJ3KdIt3O+8ky4fajl//I9Hu7/zfoBK0AF4Za4D?=
 =?us-ascii?Q?gf+YrxStSOxzIhtkxWoC1C2ewh+ghF63e2jiXGue0FShy5IG/ZGcWLufpLH+?=
 =?us-ascii?Q?itnxWqu22bUol0SeUSzJuvKiRWQ53r0Nb4/tmDhC6CCISTMVUAMm8x0l44T6?=
 =?us-ascii?Q?GW/LdJB0jrLlXlTMt7YetHRziGNzy9DQxu/cm0QccVPNyyrjRWlCTfpYzWth?=
 =?us-ascii?Q?Oezkkq9vfN76rOgloL/e9fqa9fvr?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69f852e1-cea6-4dcd-6475-08d930adde5b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 10:02:36.8877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F+dCXC41GFIx7Z/eLeehm5Ry/PjrvWBsDjk8bxnFbK4uxahvugIvpMMJp7eoxZPiLmqW2yj/RA9PTusrk06zjQIxRRJB/9AD8OQ58QgPyWo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4971
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

Replace merge check stub code with the actual implementation. This
checks that the match parts of two tc flows does not conflict.
Only overlapping keys needs to be checked, and only the narrowest
masked parts needs to be checked, so each key is masked with the
AND'd result of both masks before comparing.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/conntrack.c | 170 ++++++++++++++++++
 .../ethernet/netronome/nfp/flower/conntrack.h |  20 +++
 2 files changed, 190 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index e5d5ce7f0ead..8bab890390cf 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -75,7 +75,177 @@ bool is_post_ct_flow(struct flow_cls_offload *flow)
 static int nfp_ct_merge_check(struct nfp_fl_ct_flow_entry *entry1,
 			      struct nfp_fl_ct_flow_entry *entry2)
 {
+	unsigned int ovlp_keys = entry1->rule->match.dissector->used_keys &
+				 entry2->rule->match.dissector->used_keys;
+	bool out;
+
+	/* check the overlapped fields one by one, the unmasked part
+	 * should not conflict with each other.
+	 */
+	if (ovlp_keys & BIT(FLOW_DISSECTOR_KEY_CONTROL)) {
+		struct flow_match_control match1, match2;
+
+		flow_rule_match_control(entry1->rule, &match1);
+		flow_rule_match_control(entry2->rule, &match2);
+		COMPARE_UNMASKED_FIELDS(match1, match2, &out);
+		if (out)
+			goto check_failed;
+	}
+
+	if (ovlp_keys & BIT(FLOW_DISSECTOR_KEY_BASIC)) {
+		struct flow_match_basic match1, match2;
+
+		flow_rule_match_basic(entry1->rule, &match1);
+		flow_rule_match_basic(entry2->rule, &match2);
+		COMPARE_UNMASKED_FIELDS(match1, match2, &out);
+		if (out)
+			goto check_failed;
+	}
+
+	if (ovlp_keys & BIT(FLOW_DISSECTOR_KEY_IPV4_ADDRS)) {
+		struct flow_match_ipv4_addrs match1, match2;
+
+		flow_rule_match_ipv4_addrs(entry1->rule, &match1);
+		flow_rule_match_ipv4_addrs(entry2->rule, &match2);
+		COMPARE_UNMASKED_FIELDS(match1, match2, &out);
+		if (out)
+			goto check_failed;
+	}
+
+	if (ovlp_keys & BIT(FLOW_DISSECTOR_KEY_IPV6_ADDRS)) {
+		struct flow_match_ipv6_addrs match1, match2;
+
+		flow_rule_match_ipv6_addrs(entry1->rule, &match1);
+		flow_rule_match_ipv6_addrs(entry2->rule, &match2);
+		COMPARE_UNMASKED_FIELDS(match1, match2, &out);
+		if (out)
+			goto check_failed;
+	}
+
+	if (ovlp_keys & BIT(FLOW_DISSECTOR_KEY_PORTS)) {
+		struct flow_match_ports match1, match2;
+
+		flow_rule_match_ports(entry1->rule, &match1);
+		flow_rule_match_ports(entry2->rule, &match2);
+		COMPARE_UNMASKED_FIELDS(match1, match2, &out);
+		if (out)
+			goto check_failed;
+	}
+
+	if (ovlp_keys & BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
+		struct flow_match_eth_addrs match1, match2;
+
+		flow_rule_match_eth_addrs(entry1->rule, &match1);
+		flow_rule_match_eth_addrs(entry2->rule, &match2);
+		COMPARE_UNMASKED_FIELDS(match1, match2, &out);
+		if (out)
+			goto check_failed;
+	}
+
+	if (ovlp_keys & BIT(FLOW_DISSECTOR_KEY_VLAN)) {
+		struct flow_match_vlan match1, match2;
+
+		flow_rule_match_vlan(entry1->rule, &match1);
+		flow_rule_match_vlan(entry2->rule, &match2);
+		COMPARE_UNMASKED_FIELDS(match1, match2, &out);
+		if (out)
+			goto check_failed;
+	}
+
+	if (ovlp_keys & BIT(FLOW_DISSECTOR_KEY_MPLS)) {
+		struct flow_match_mpls match1, match2;
+
+		flow_rule_match_mpls(entry1->rule, &match1);
+		flow_rule_match_mpls(entry2->rule, &match2);
+		COMPARE_UNMASKED_FIELDS(match1, match2, &out);
+		if (out)
+			goto check_failed;
+	}
+
+	if (ovlp_keys & BIT(FLOW_DISSECTOR_KEY_TCP)) {
+		struct flow_match_tcp match1, match2;
+
+		flow_rule_match_tcp(entry1->rule, &match1);
+		flow_rule_match_tcp(entry2->rule, &match2);
+		COMPARE_UNMASKED_FIELDS(match1, match2, &out);
+		if (out)
+			goto check_failed;
+	}
+
+	if (ovlp_keys & BIT(FLOW_DISSECTOR_KEY_IP)) {
+		struct flow_match_ip match1, match2;
+
+		flow_rule_match_ip(entry1->rule, &match1);
+		flow_rule_match_ip(entry2->rule, &match2);
+		COMPARE_UNMASKED_FIELDS(match1, match2, &out);
+		if (out)
+			goto check_failed;
+	}
+
+	if (ovlp_keys & BIT(FLOW_DISSECTOR_KEY_ENC_KEYID)) {
+		struct flow_match_enc_keyid match1, match2;
+
+		flow_rule_match_enc_keyid(entry1->rule, &match1);
+		flow_rule_match_enc_keyid(entry2->rule, &match2);
+		COMPARE_UNMASKED_FIELDS(match1, match2, &out);
+		if (out)
+			goto check_failed;
+	}
+
+	if (ovlp_keys & BIT(FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS)) {
+		struct flow_match_ipv4_addrs match1, match2;
+
+		flow_rule_match_enc_ipv4_addrs(entry1->rule, &match1);
+		flow_rule_match_enc_ipv4_addrs(entry2->rule, &match2);
+		COMPARE_UNMASKED_FIELDS(match1, match2, &out);
+		if (out)
+			goto check_failed;
+	}
+
+	if (ovlp_keys & BIT(FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS)) {
+		struct flow_match_ipv6_addrs match1, match2;
+
+		flow_rule_match_enc_ipv6_addrs(entry1->rule, &match1);
+		flow_rule_match_enc_ipv6_addrs(entry2->rule, &match2);
+		COMPARE_UNMASKED_FIELDS(match1, match2, &out);
+		if (out)
+			goto check_failed;
+	}
+
+	if (ovlp_keys & BIT(FLOW_DISSECTOR_KEY_ENC_CONTROL)) {
+		struct flow_match_control match1, match2;
+
+		flow_rule_match_enc_control(entry1->rule, &match1);
+		flow_rule_match_enc_control(entry2->rule, &match2);
+		COMPARE_UNMASKED_FIELDS(match1, match2, &out);
+		if (out)
+			goto check_failed;
+	}
+
+	if (ovlp_keys & BIT(FLOW_DISSECTOR_KEY_ENC_IP)) {
+		struct flow_match_ip match1, match2;
+
+		flow_rule_match_enc_ip(entry1->rule, &match1);
+		flow_rule_match_enc_ip(entry2->rule, &match2);
+		COMPARE_UNMASKED_FIELDS(match1, match2, &out);
+		if (out)
+			goto check_failed;
+	}
+
+	if (ovlp_keys & BIT(FLOW_DISSECTOR_KEY_ENC_OPTS)) {
+		struct flow_match_enc_opts match1, match2;
+
+		flow_rule_match_enc_opts(entry1->rule, &match1);
+		flow_rule_match_enc_opts(entry2->rule, &match2);
+		COMPARE_UNMASKED_FIELDS(match1, match2, &out);
+		if (out)
+			goto check_failed;
+	}
+
 	return 0;
+
+check_failed:
+	return -EINVAL;
 }
 
 static int nfp_ct_merge_act_check(struct nfp_fl_ct_flow_entry *pre_ct_entry,
diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.h b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
index 753a9eea5952..170b6cdb8cd0 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
@@ -9,6 +9,26 @@
 
 #define NFP_FL_CT_NO_TUN	0xff
 
+#define COMPARE_UNMASKED_FIELDS(__match1, __match2, __out)	\
+	do {							\
+		typeof(__match1) _match1 = (__match1);		\
+		typeof(__match2) _match2 = (__match2);		\
+		bool *_out = (__out);		\
+		int i, size = sizeof(*(_match1).key);		\
+		char *k1, *m1, *k2, *m2;			\
+		*_out = false;					\
+		k1 = (char *)_match1.key;			\
+		m1 = (char *)_match1.mask;			\
+		k2 = (char *)_match2.key;			\
+		m2 = (char *)_match2.mask;			\
+		for (i = 0; i < size; i++)			\
+			if ((k1[i] & m1[i] & m2[i]) ^		\
+			    (k2[i] & m1[i] & m2[i])) {		\
+				*_out = true;			\
+				break;				\
+			}					\
+	} while (0)						\
+
 extern const struct rhashtable_params nfp_zone_table_params;
 extern const struct rhashtable_params nfp_ct_map_params;
 extern const struct rhashtable_params nfp_tc_ct_merge_params;
-- 
2.20.1

