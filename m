Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09ABC6B8B4B
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 07:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjCNGhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 02:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjCNGhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 02:37:10 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2099.outbound.protection.outlook.com [40.107.95.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFAE96633
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 23:37:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IdYjJbS8w5Uts1aMYZvI0l/9+4lJoSsQ7SLG4DUOcX02giRgYc0UdSwnRhHJraPTKUVG2GTvrZsShbxi0LAhAVOsNpW+ZgPA+IcJgvN6oizQUb4RLparwp8PR+4p4QMB61Ylx3TFJze991O4Ma2kAWbIMVE9GiEHUA9bTZd9ldwOMk4Z6WAZq2s+2004B6Ux9ihFoYjM5rN4dovSWBNqRA/TzZcfmgnTj8uV+EExaKYJbd5oL1EI0d4r/KeGkyzJSYrFyvCUOaRvqaq5MjYY9cecl1f7LcG7EvbmR5Hmb++e3/etPGxp0ADbpPTnathqQp8OGlzL/yNBM0rk4PjfMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SWTK8hfdOtKZjlTl794Ro3Ker7FSkOR2e6u8X2gKjCE=;
 b=MEaykyZCs/+6esvu4zHdOFXHTfV2iX3QO7ssNJVw2PeP1Vhe9csEGAXTOrQj+c7xGpI7kBwx4ZvkdX991aD3OjH7zOcsnZSUhBojeh3WLZnJQq+5mSXYX/aDZfpgMACvODSegwrFpE2QJCI/G2A158VGX6LRWwiuFnj6aESLiaWKOHIMffRdwCgzkuFmwwiCdkH9GcAdXv1rmCpwlcpfT9dfDddGis23N3cAJfY+ePNoj7kQw0UcVGgT7btELiTtgNYpIKP4j8Y8t61BbpokJnbXt8nvVBaT1VJ8PxZl7DNdBTFsSEs3qonmL5hChqULDP97R2NzQeyMhsgjF708lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SWTK8hfdOtKZjlTl794Ro3Ker7FSkOR2e6u8X2gKjCE=;
 b=mSIfKBPsazRXk4LqL4GsFGrj623GnITWndk9h2LSUEy6K4XQr+sYkqUTJsWH9Dxn0Tz13cXzWh6xO6OfmkSdcWnfy1zNrxxKj7KFfQeTqnSpE+vl9V4Z3xvVKk9oaHcK4D2e7qTGzYcq23nUn1Q9pZxUHwxv2Hezzv8aZSD6avk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 SA0PR13MB4110.namprd13.prod.outlook.com (2603:10b6:806:99::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.26; Tue, 14 Mar 2023 06:37:09 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::c281:6de1:2a5c:40b8]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::c281:6de1:2a5c:40b8%3]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 06:37:09 +0000
From:   Louis Peens <louis.peens@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: [PATCH net-next 3/6] nfp: flower: refactor function "is_post_ct_flow"
Date:   Tue, 14 Mar 2023 08:36:07 +0200
Message-Id: <20230314063610.10544-4-louis.peens@corigine.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230314063610.10544-1-louis.peens@corigine.com>
References: <20230314063610.10544-1-louis.peens@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: JNAP275CA0067.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::13)
 To DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB4249:EE_|SA0PR13MB4110:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f58970f-1cc3-42cb-3f4c-08db24568916
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0SpUrK3p3HFPmm9LNQI/ZDgckxiVo6Vg2mYXidrlWqyNtMsqKWg8aoGZWLlj7V9C/KD7mOAtRhr83mkieUTGz03arI43seDpPEP9EjqNa3hWyzV8X0acA1MXHuoLYexEQwjzik53IoIEy18b09jOIb80IClim3q9kutIvc6eLlcynrpNkaRfYr9o+TD5TMOkTdhWu8M2eJ++fAs59mlkM3d0RDZobn/mOBOYSsHfTdxSKctWk+eQpptJUPNr/s9+QgZaY/Ct/fEvTH/z9ty9kP7MED9omZKB8qnF/aWucAt4/WVPtlmMOssjjcnJrexcdfkm8zK3kLwQSp4SLnaJwfBBMxpeRpiqU73/OWzHZ+Om3k5oev+3ViCNOO3An/xquvT76Jv1m/jGQP6Oh1nOv5bwLjt8h1AouWNvDJJ4H40NFSZW/nPcDMT3PD7LESwkepjbyb+gh7P7hsCUGy2bPbhs3tzGMfeg/+vn6j/Yc2fzfxAPIbk90wKD/U59zlsmn2m9FLg41Q9LXSHZvPDH0W+SVDx+h5dqV0TLV8ssFzeYmdlm/3Jl4StlzZckUTWfZVWaRLXQwh8rwuMgntt5D3TmSbVQfQmkH4cnd6mGk6tz6uGfrCbd6Hd21Ugte0wT6+MULWXqBN7EqJnL3bmGoZ33ATFKeqktBoodbEJmiPrFNqoE3tsYZmkFqxkuurQIDISYQ4qTx6aZccaDm3t+HQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39840400004)(376002)(396003)(366004)(451199018)(41300700001)(5660300002)(44832011)(2906002)(86362001)(38350700002)(36756003)(38100700002)(8936002)(52116002)(478600001)(66946007)(66556008)(66476007)(8676002)(6486002)(107886003)(4326008)(83380400001)(110136005)(316002)(1076003)(186003)(6506007)(6512007)(2616005)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6U9E045unJ+LVO9VthDibFhiGuPOTh4JR5cnM5zW6reZzU+XqSqfyq8FVrWR?=
 =?us-ascii?Q?go/yNshHtHhXbkw8JesEU6+aqOaWqdVoHRPw7rNnsmDO14URE1wVwXtXTKDp?=
 =?us-ascii?Q?ClW1yhbT/DIOUotz24Pf3mV4vzjnPfWF9yfXHTtt2gckQ3OqxX1G+3wvYYx/?=
 =?us-ascii?Q?okXbjE8L7KgRQE8UehgwAgndCoTPA+iJUJ6eNxRdr9Q0/rDfvvzoryn70JN1?=
 =?us-ascii?Q?66FJuWLqpk6Na0etVTeafT8zkBj/47ZyBjLzlXdfyWuV9RK9Is01PMLheS2g?=
 =?us-ascii?Q?Rhbt86TyjqgEm8gUNikJ+TM/sgqMB4gHGVEIURsJp6zdH186NEQoSNR8W0Q2?=
 =?us-ascii?Q?htQFQoutrzWzsGojlBh50yctao5m9L8Shi5wmiFzWhiyERY1DGbfdOEdashm?=
 =?us-ascii?Q?RxnIzVDsDEfjTugSUgas+BUHdsVnDqywoQws5ZbpnBG1yIwZLjT3Nwx5bUVx?=
 =?us-ascii?Q?GZMRkyJK/2JHm1gIRQjMDnjzbUHT/eOR32o/4s04U/7ojx/Fc/oJCTNgdi0U?=
 =?us-ascii?Q?S5Ld1JA+N8o0piKHKmp0VGg0LORfkNn01x9weuFtQFQva9DUDpwIyZyNQm6t?=
 =?us-ascii?Q?yu1A6dXajrVwRPXwQnqTh1axZjlLKVT89sLFnXbPqIFIlcDVBBuuObELqcnD?=
 =?us-ascii?Q?rA5hOLnUpHWtsdi2ZJlzVAZ2dR5f1tSiPtkEt/RP42iAtfJ09KgKZecSQc8k?=
 =?us-ascii?Q?l4hkAgPzbVX8cDBXXAstPF8EO9PYoZwK2Oz7P5EzTj6Um9kI2yNFZ5Hwdvgj?=
 =?us-ascii?Q?XgVxFXlaiTGxJs3NBGahIM0+yny1nbSFF1xVUiijMqLZhRQcKD43LrdOcdGE?=
 =?us-ascii?Q?0SWXni3hUJR9lTda5nj7F/VOKs1xY9Fc086qzrz0QRbEGA0oDIXrNcGqjBQr?=
 =?us-ascii?Q?AIrdZJ+xHL+05A4auXIFTL/cvObjUEzPPjEHFaBj4U2NQZB7DD7AhqEBxxb6?=
 =?us-ascii?Q?uoZFjS8M4k3tWW/FdnwL663abTPnqZcHpWe17M/T+wWRVxM+eX4P3dLAbWe5?=
 =?us-ascii?Q?VXFBvcIn206XNgl/wGHyCYDpiNF5xVp05sIzPcTwk0xXakD/T1UQJvngWPiV?=
 =?us-ascii?Q?QyYHjk0S2CHNug8lZV16LOBqC19g93jxHDKhlg0zZYEsScE/PAboP7Z1wbCG?=
 =?us-ascii?Q?UMJBOLXnYj8mRgzrKkwn1qOmDfeoAvTj8I/g4ZnwzPkMAI1ZkzrtOq9Q3J/B?=
 =?us-ascii?Q?zGiYKbSTHpJmlQr3Jc63Edl4VhZE2pb6SJlPmlsRQLCW/3K3QY5VKbLI1Thm?=
 =?us-ascii?Q?Wd0Zy/u/3PDZz5chFQofnKHWfkBDnykqAHhLKOucoR0Vlbg+57z2QK+yoCI1?=
 =?us-ascii?Q?cKfcRiKtcHAtzCk+sDcjyCj0RipYcW+JvWC4biRVVYaYENwy7LJ8RRxsgFzp?=
 =?us-ascii?Q?tFW0IQfosaBhzWPjC455bdzFo/lPXEKUqwEWA0ba2OtMoC+Li/ktKy1Mfoth?=
 =?us-ascii?Q?HYCL6VLAgOMqTf7PsP+w/4Kxl/y4jYYruVB4RPHvN/KNdyYDzGwNUNe/L9Ek?=
 =?us-ascii?Q?qM7BFvFIJR3R0v80qWAqKO7Z8ZArGFmqblbU5N/q6jEE/hucsEmXfnneFKuQ?=
 =?us-ascii?Q?Yvl7zB75LyCZp7AsGHCAtRlakG3erE4O+05Jgqpug7aV1yotSDhvaeX7qJ72?=
 =?us-ascii?Q?sw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f58970f-1cc3-42cb-3f4c-08db24568916
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 06:37:09.0031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yrY04HV98ys0+8j8rIn9XqOaNUmSZ91ZQ5cRH3x9fEuFbBnaxwgAUqW8RusCcfxaxFKQCmb/4pQhN0rxnLobTNMSpnAZpxvmwb0S+xVyUew=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB4110
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wentao Jia <wentao.jia@corigine.com>

'ct_clear' action only or no ct action is supported for 'post_ct_flow'.
But in scenario of multiple ct zones, one non 'ct_clear' ct action or
more ct actions, including 'ct_clear action', may be present in one flow
rule. If ct state match key is 'ct_established', the flow rule is still
expected to be classified as 'post_ct_flow'. Check ct status first in
function "is_post_ct_flow" to achieve this.

Signed-off-by: Wentao Jia <wentao.jia@corigine.com>
Acked-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
---
 .../ethernet/netronome/nfp/flower/conntrack.c | 25 +++++++++----------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index e0d6c8754272..6b90b922bac0 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -94,24 +94,23 @@ bool is_post_ct_flow(struct flow_cls_offload *flow)
 	struct flow_match_ct ct;
 	int i;
 
-	/* post ct entry cannot contains any ct action except ct_clear. */
-	flow_action_for_each(i, act, &flow->rule->action) {
-		if (act->id == FLOW_ACTION_CT) {
-			/* ignore ct clear action. */
-			if (act->ct.action == TCA_CT_ACT_CLEAR) {
-				exist_ct_clear = true;
-				continue;
-			}
-
-			return false;
-		}
-	}
-
 	if (dissector->used_keys & BIT(FLOW_DISSECTOR_KEY_CT)) {
 		flow_rule_match_ct(rule, &ct);
 		if (ct.key->ct_state & TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED)
 			return true;
 	} else {
+		/* post ct entry cannot contains any ct action except ct_clear. */
+		flow_action_for_each(i, act, &flow->rule->action) {
+			if (act->id == FLOW_ACTION_CT) {
+				/* ignore ct clear action. */
+				if (act->ct.action == TCA_CT_ACT_CLEAR) {
+					exist_ct_clear = true;
+					continue;
+				}
+
+				return false;
+			}
+		}
 		/* when do nat with ct, the post ct entry ignore the ct status,
 		 * will match the nat field(sip/dip) instead. In this situation,
 		 * the flow chain index is not zero and contains ct clear action.
-- 
2.34.1

