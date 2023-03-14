Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 012386B8B4E
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 07:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjCNGhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 02:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjCNGhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 02:37:10 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2099.outbound.protection.outlook.com [40.107.95.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D114B96636
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 23:37:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hv+ogvkK85kqS3F7vCuBjCXdnrCpSTxnObNK+1jhK3DW25/ia614GnShrFO+o6rfX2A+4igzQRpayjtRmY9vFFkhiDhbgD8The9n94h4S/g9A6jPN1JR8xBlFpAF1uzs6V+M9f2zAyT+vLCjf4YB9uZSMa6C3DhKsdZgmunU/Fr9qxP3ycc+30unGx4VPMRf7eRkRGAZNN246HyaT0jmASX6chaq5mjz6rlepTguZvhW2fdcGX3OXQk1/dPuUkyP3dFlhsnXR+pe/lR/bm4ycKM97+yCsY90D534CJMvyoAvTIKQ6PaYa/8LCG88cCy9Yq7vHxzE5yu8AZOpZGJ4iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EWlTZ+Sa+njU1uAfjrZltTAqeGxDlznY5Drnynx0Mvo=;
 b=Wppi8BFtFg3o39xC0C/GBMQNm3EDGt3oMB81IpzdhOLoCyp0L7xxhjhq0kFDACQkxApWTIlcx/oQWqHonVsEkCH3Iris5Qk6LULOZv2ieCaabArOP4UtxEJzROEI5fvHRVsmI7ObOCZwrcx5vL8PfKkPUJewwioROrR5kv6vZX1On95RqM6LTavKFml5NLIx6TpCIXYxr2smuhkJLz0EdvlVRNEqD03hFWMctzRBxW19hQW4YYxTh87y0Xms/gYUMeVmPRSdhlmNSJuMVS8Y9vtJ3SnKkWVnyAYVRkqvVDLtuLLrFxDQfYgWXGd9WVoHBz/mvmCk88Uhr2VQHafMQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EWlTZ+Sa+njU1uAfjrZltTAqeGxDlznY5Drnynx0Mvo=;
 b=cRX7EeNp9BnJBo2Vlup0ETf/51YwQazmuh8Hkz3P0Ophr4YtwCWE8bJx2bbFSkq9Xxc9O/iXr6nCVFIpOHH87lkqGCNv7KaFF7QbFiNy07+fq7fulGgzNtWls9eBcJvVmqxREqSn1mPPYgCHg8fArxuWicYhpqcDeRh1q6xPCao=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 SA0PR13MB4110.namprd13.prod.outlook.com (2603:10b6:806:99::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.26; Tue, 14 Mar 2023 06:37:06 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::c281:6de1:2a5c:40b8]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::c281:6de1:2a5c:40b8%3]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 06:37:06 +0000
From:   Louis Peens <louis.peens@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: [PATCH net-next 2/6] nfp: flower: refactor function "is_pre_ct_flow"
Date:   Tue, 14 Mar 2023 08:36:06 +0200
Message-Id: <20230314063610.10544-3-louis.peens@corigine.com>
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
X-MS-Office365-Filtering-Correlation-Id: 25acccbb-40bb-4b7d-1f6f-08db24568769
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QFIq7nXBYBZiSv/kAAK7SMDL73BSAze+RozMGuC1jId2v5w2RvqeeIQKfsrcerkV9Y5stMof8n7fE/a1GKwwT4KXP2A/Yz9ma6AP1wczIR1LUS6teG4iSFj7X+EOMGIzL1IQ1BtmKMc0LA25PKSpFfg/UwWLD+mV4RXXU9QalVAXntCHKyoGAN2HiH9thzP+eotHgG6ueCZFfBi0pJPhJ58TAKHnDYeuXVluK4a2WiDJy0CDvGAZZtDgHonttICPeF944i67ZrUJTKsleqBc8A6k3YjOQaOeE8MXW2DuCYdRVBOZht8/FeHcf+6pBPGrYaJH3/6sHr7VIJvBPSAJmyW6/b8h3YvpNPxLGKHMyp9ky1M2KvLMjXQ1pat3HGPKDuGCiitEBHb2pVZLbb9Dpwf8AKgC60XA/4mgGTJPAEcy4+XJysMTiSCpnwycCEISegh4LTjROHfxyOpppCY64osxevtTe2wOPkvp83D3D/YJmrL54aO4NNfU8mm0+DWY6yNzVspxSDQNSdSKg2qRAMRtzqSXlZGspe9VhPwK+YBSKsH9rFQoFQQXlAsqXt0K/7bvaQfrkXlo3ynOoLjz7meCOlpqdYnKKBD8u5wQ8KugoPFMZ9q780f6dYd+qptmTszqVioRBuhAdMtfg2erk5vpsrX8gkIgeeNG54qkVtJknaPtDij4j7vEKQpPrAUtWMjG65UuV1PenyywCnJCSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39840400004)(376002)(396003)(366004)(451199018)(41300700001)(5660300002)(44832011)(2906002)(86362001)(38350700002)(36756003)(38100700002)(8936002)(52116002)(478600001)(66946007)(66556008)(66476007)(8676002)(6486002)(107886003)(4326008)(110136005)(316002)(1076003)(186003)(6506007)(6512007)(2616005)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4iiaPsCi8Ikw9QnYCNUZS/RENIvG2bALTWZ/LjBCbFY5Vji9IUsnWiOYzG0v?=
 =?us-ascii?Q?u1gHLT0c6/uPYA+ggatGpe97com8B/d2P+yMRVtBD1nuq1etFbcWbHmRXnhF?=
 =?us-ascii?Q?dNWy6b7FMGhZ+CM2qdT6ZuI97QCK5FhK7XroArk9hrPqEMMti98im7iZFmiw?=
 =?us-ascii?Q?dK1tJKSNRvI01Vbq5mGVPHna1tZo3Jgqr6XOkO9ySCTSD3y9DwXGvXx7DaJT?=
 =?us-ascii?Q?W+R2oDTnjeFpwIrna7VE+SGLGfrY1Fh/6WGNeFJRn0xhFXn22MV0pV4vfM+/?=
 =?us-ascii?Q?eX1w3eaBu4HU30DDhCthzx/d72rgUrTbs3/a8lRpCRhAee6+ioOorgRvZIFN?=
 =?us-ascii?Q?q4InT7I+O2pIrS8Kt6ToQ8CXhX4spMrPUbhSxfVFOFxzTYRoVqASGD3ghW+O?=
 =?us-ascii?Q?KuyUm+/uSR6lzW0QZHiiRReZWq3L9TH5puZq/8ZdhlVSzPYuZvqwgq4qils/?=
 =?us-ascii?Q?zk7vgMeTBi4YZ5x5jKX685nHMyA6KHj4U4NrwY1x1F83ouNr095bTLjfkL2A?=
 =?us-ascii?Q?Et0FbpKYUldSMVyevArCLr6dJvgzwJ4DZynvT0puHTjHAOsQS4ggBUZcq+IL?=
 =?us-ascii?Q?mjLhRBBLvp/R+/kPMJwtTDS4J5omiqyDIHGhNFDq1qF1EqUtmlfPNPzZwPBp?=
 =?us-ascii?Q?T1ZD1fjvjOtekfYSbCA1ND5RUvXcnZ24LyhEtxtEssN2DvYQc8quBAImLnKU?=
 =?us-ascii?Q?JwDNoMgEyR2y0AJjRfsnXdVhPY2o7ryhSDLyv95O9MlsGOTKC4LTUj6ejRU2?=
 =?us-ascii?Q?M5osC/Sqv8LDxbXVHcJKRwqHr6Cqwr+pWXLE4SfxE0KqvktjvuvrV3IkygpK?=
 =?us-ascii?Q?HLvxSHaoqzCBEuw9/577QIAo5Sdc94VjaewWgWRtL0nd6h64rDMenXhk6SmU?=
 =?us-ascii?Q?Gq+uA3CzZoIJiRiOeerxn2jMQBiZpNMXoEkXOPDmf5iIpkNQ5nnv8mS6zYyV?=
 =?us-ascii?Q?aXZjOxC14VQr6yWMGhMuzftoS91koyRvS502TEy4JkM/f1DrVcRa6bkND3AK?=
 =?us-ascii?Q?Hylo5KuO6Fzdk6Mo8bNLZSU1n3M+23HNCvHXDRYvD6P/wXR1XvGmQoTwjjsd?=
 =?us-ascii?Q?NHApBPMSV1XpcPXReeWbZTWHPtReNsXd3EycncbArEr0XF4xHZpoZqocRKpr?=
 =?us-ascii?Q?SRUW6VK8vKUMWOH00Ax50xndMRZiGynz24g+yjjXhPsSAi6jPWt1lSMQFCG6?=
 =?us-ascii?Q?By2uPoHET+fk/9SrUChU7AGtj2jujl5aSW1YX8Oy32Jq1rPXMDMhtlJ9JHZh?=
 =?us-ascii?Q?hvHMHng+bqZoKxg00GrD4/qTuUQp6TO0iHAS9eXBIFC0zswGOmNhPYtnHMYZ?=
 =?us-ascii?Q?GC1PepF77qJ5V5cPX4gnvaxDNXw/99Q3RR5BBnT8ZKUFNgshs63SMmTP8vZZ?=
 =?us-ascii?Q?QN57VPOsPD/A0OoGX/wdlFc+glk06y7ggS5yxOGh5btmy6uMRCZ9POtqpFvH?=
 =?us-ascii?Q?k2W/hmd3TVUBh+eWcsRBGVSs4UmdEVNAh6G6yWu/JboDA0QABEDRqlWAtoXS?=
 =?us-ascii?Q?Q9LnUtalK8u0ArR3rns4PF8ZSO4gJuZI8+Tv2H3ep8VMX4MILTflWnmt/LAt?=
 =?us-ascii?Q?l/iNE5fdBkM684mEekTZthXwoA7kCi844drD9EozOTwoOB2sWdSL0jL/aW+n?=
 =?us-ascii?Q?yQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25acccbb-40bb-4b7d-1f6f-08db24568769
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 06:37:06.1595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r8yCejsVamZqUDBvwUluMqW8cadeBtsXB2DHWjTIPtUaDuEDTb4rBD4jip4DfG5TU+o7QREx+jxVD2zGl/IJy0fHliZOckFxWQwpCCi8sGc=
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

In the scenario of multiple ct zones, ct state key match and ct action
is present in one flow rule, the flow rule is classified to post_ct_flow
in design.

There is no ct state key match for pre ct flow, the judging condition
is added to function "is_pre_ct_flow".

Chain_index is another field for judging which flows are pre ct flow
If chain_index not 0, the flow is not pre ct flow.

Signed-off-by: Wentao Jia <wentao.jia@corigine.com>
Acked-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
---
 .../net/ethernet/netronome/nfp/flower/conntrack.c    | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index a54d374788e1..e0d6c8754272 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -55,9 +55,21 @@ static void *get_hashentry(struct rhashtable *ht, void *key,
 
 bool is_pre_ct_flow(struct flow_cls_offload *flow)
 {
+	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
+	struct flow_dissector *dissector = rule->match.dissector;
 	struct flow_action_entry *act;
+	struct flow_match_ct ct;
 	int i;
 
+	if (dissector->used_keys & BIT(FLOW_DISSECTOR_KEY_CT)) {
+		flow_rule_match_ct(rule, &ct);
+		if (ct.key->ct_state)
+			return false;
+	}
+
+	if (flow->common.chain_index)
+		return false;
+
 	flow_action_for_each(i, act, &flow->rule->action) {
 		if (act->id == FLOW_ACTION_CT) {
 			/* The pre_ct rule only have the ct or ct nat action, cannot
-- 
2.34.1

