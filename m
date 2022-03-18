Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 258A14DD7C0
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 11:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234871AbiCRKO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 06:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234693AbiCRKO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 06:14:58 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2102.outbound.protection.outlook.com [40.107.220.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ACD3F8441
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 03:13:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dzQAmCKZTnOVkOso/jkqruaSh7G8bA5iAlvu1yiPZMMmsu+xOZObu9lZhFP7Ic/6kckufApOSVq6XRTqLW6PQdUevo36zh8Cr1odDS3soAWQkrfxenIumK23Fvc8QPOK6+BxCwlDsPAbuM0hKclTGIJ84GwG03gDF+vfxYFQzOSGy51XIZF2CzmJlFysPb5BLlJHwaRyBMhJvujdXYGBfUuGpbdsGRvtwRbr2cREZn7o0fpT99Nl/H/1Ej54guEvM/6eOZCSoWDvaP97CPHFCmEJS4txLSGPfhtgi6IEaPeEGXszhuN+laSkfXg/i/A7+z/gaDErEz1WeRhN1IUloQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/bvmNd3fNL0+vkiDsCp3Qxo9gTvFTWibHqUOwX3oEH8=;
 b=ZsnBxIA5oRzw6WAbxp+ZzKHusjHtMEPiBa/PxDfsZVpz2iECCqpykiN5+xCHHhJw5RIoZWt6SHLFUi5vj3WDFHuvc0OJr/q6jc1vo5XQKFq8q6Z/W3DPXtUHP5BlfcKi75qqfGn8t/3THBFZEVcvfPj2OMj8G3/AfrNptj2eYOCe7MqRQjpBhBAQXug+SiIPtedQZq7oLPZB45BXD+FpuUIyqmo6Uak/DsK5JAlnSd77ZOj1TqdYGhvuiggWn8p2IvLjbFQpOdcLxSDyT6ItJYzTbfNsJXW2V6QTieKkkWik3msywpBn5f6HMdTV4mo4ZeMmOfVHWYMxT2IK8T55Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/bvmNd3fNL0+vkiDsCp3Qxo9gTvFTWibHqUOwX3oEH8=;
 b=OZ1kkqOFzQKFxnC7t6vPdzaOtnqft6u4TKCbZjsTYyC05BwZh0EB4d/WcDN5Ax9q6yXsAXQXUyYv+kI2GEg7ditsr2f4cws4bESxF2v4odL2nQ8EnGRMc4ZhiZwtHZvdJVJCFxyLgFMF5E1eY86klZhO/g0V9/Eh/YiozBuxdcg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN6PR13MB3139.namprd13.prod.outlook.com (2603:10b6:405:7f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.8; Fri, 18 Mar
 2022 10:13:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5081.015; Fri, 18 Mar 2022
 10:13:33 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 01/10] nfp: calculate ring masks without conditionals
Date:   Fri, 18 Mar 2022 11:12:53 +0100
Message-Id: <20220318101302.113419-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220318101302.113419-1-simon.horman@corigine.com>
References: <20220318101302.113419-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0114.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 109b6aa7-adc2-479f-a50b-08da08c7f50d
X-MS-TrafficTypeDiagnostic: BN6PR13MB3139:EE_
X-Microsoft-Antispam-PRVS: <BN6PR13MB31399BCC356E31D29EE5EB06E8139@BN6PR13MB3139.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 93xrFaWtR6HLmsQW09Omo9JlrEjuLbI3tY4vZ9/aroIpNqD7ULqJEuD2l5pUWOGUe1bPUpoJzI69uWLFL90ULWx3fiz0x4LCW2230S93hlowmVEmQLTa9u2FAbMRG8RQfOQYXfZs9TfDokeCWyiPdxEz7fEnG9H9184gYcAh/L9RQHbjJoRzHkRiBbUAjvosvOPNXsOcst0GxAT4esPTU61zHQHQTLu49OiYvbmRuFGJ8iJsfoG8xlzQR4uOs8sbeyTIB4RfjVn+yAy6D2Wu3GQ7QN8Y6t35kuiG2NiDPTbSCzHEPY+VQT3+KcXG6LjQDsUsIvOdc6F+O5dDYDiOZ8ufMBIevk0Rx/XG2BIHFU3W2abhwVwc0x9nSWW0bCb7pWBd67S1BmagrpTWUp7d3XUmmnH8ZaOX8uLiDxEUn2cK59HYI6tA8WCvv0WWXfQ1risWD7Fh3JndS0ziwvoV3vIJb7jg98SkrG7r9Hb4FfX7fEWVRBMfKnydieMS6r7C5jsI6NFbiLGXlmsy4A/Q21IJfWeUbO+/KIMez+SHCmw4SlBGGtmJr9V0LaXyhvdKK0WzJqQ/pubL2QNwSVCT+S77yI95uJzSlOw9cqjK/TXelr3N4CdtjK624gUt9iroA4LHJm8W2A3LB+XXZTaURw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(346002)(39830400003)(396003)(366004)(376002)(66946007)(66556008)(36756003)(8676002)(8936002)(66476007)(5660300002)(4326008)(44832011)(6486002)(508600001)(316002)(2906002)(110136005)(38100700002)(2616005)(83380400001)(107886003)(1076003)(186003)(86362001)(6506007)(6512007)(6666004)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y7MQyBVLfME/xozgYXDHe5Yxp5UB+/EuSVXqubPJOOM3EKBvHz6CfUKRyWAd?=
 =?us-ascii?Q?oTMCiCE/4jj/1N9c9omVdf5roSnYL+AcPUxOaaDzsHKbZ49N9shQKb+clv5h?=
 =?us-ascii?Q?dydwbP7C38sv/XSilr3qv4iHmhi6fmFgwLWtqgpDxsTX9FVMhn7PxOFg+MSR?=
 =?us-ascii?Q?v/tpvnEA5EW2kuAC1wCYnkf1NStMtzNMAzGB0cswYWH1naZrxt3WzHoFP2KR?=
 =?us-ascii?Q?lUnqAeJUbQOxQ3Z3v1Q2DtPz8FcB/F00hUj7mOPydAiZhHkqZTMqNaVHR0mc?=
 =?us-ascii?Q?5GR4dKCgZ1V9ahiryUsAW+tk/JL83b0D+5l5Yxz6rO9XkVTFGHtGM3xeuVkz?=
 =?us-ascii?Q?qZFz0781vPVkcM6KB0tJOKbrv6PL+7xOEZq0WUGXpYXC4owzLwWR8V4MFWuJ?=
 =?us-ascii?Q?93bSsjLSgkRiLmusv056qYXsBrwVCI+3/72zro+hYMizrxDHGy+6+tatAA3O?=
 =?us-ascii?Q?o8yPaZIsysmtREhDP6GOAR2hu/Tb1WusJNPsK8pkP7G6wSpLjxfcuA8VZ8Wa?=
 =?us-ascii?Q?JHvDzcqDAKCBfZqoSmnS2iFSokYYxtndHGwupwCFCH9NKvt96u+XW2ylqi69?=
 =?us-ascii?Q?NliQpp2yPDgwOf2+hd/hG4aauK6xlbf4gNAtlkSEaE/eaTshERbEaLl8PSiq?=
 =?us-ascii?Q?1VZMJ7STOg+tZ6NvhHE2dBapJpDiGWTTOzbm+yPzWixHWdUXlI4Jaelz2N8L?=
 =?us-ascii?Q?DvPsFk0AkyBRQB5Ocxn6l4faVT5HFuV5tK8D5nIgVOFrX7WfKGZE++JC4oJP?=
 =?us-ascii?Q?cP4lpkqQ4iiDfi//LI+nlOEu2hNRakMmzLw8z8mErTnkGnDARCW9MV/09g54?=
 =?us-ascii?Q?tNYEDBbaO2dOXZH1xiae1pBUGGRkTTzlPO6q2DT6VLYmcE+C2kVx7ir/wntu?=
 =?us-ascii?Q?CTQU52C6Kz1DWLxDjry488i5p7auRGkjVXsMTz7dQwEQEfucA5xtl1N8XQOx?=
 =?us-ascii?Q?3QOTHpFyhmNlU8geMXnk1CkmtlNufkZFvCvSd7nzQMWFR2zjtcbRh1fgvwSe?=
 =?us-ascii?Q?yYWp7jbMw16eUoDiqR+Tt+XKYYWsn30/pGlGXvlSyRSC3fI1AQgb/hQ3Kbxo?=
 =?us-ascii?Q?gJJDnVhpuYYce1IGqNz2HhJpl3ADnJd4j2I+voRTs3yjBeXALvfvToYuH6Gn?=
 =?us-ascii?Q?2MXC06NKUqpbjdT4z2PPqmgcBSfWGklVmonGGmXb25UZFHqBtQMjoo0lHEfA?=
 =?us-ascii?Q?iAoNTl6+Lw9HPSDVpO4CdAInVlWLsPY9xuACZakhq6q36q0ym4wssSMjAT61?=
 =?us-ascii?Q?tX1pPDQxoW1BIXZ6Or6Jq2RRwBCGQgJh5LZycchK4BfEBIltwdxXrHYVYjoD?=
 =?us-ascii?Q?wK2Iq1q4O0n6fhW9+2uplZMTECG0NFoicl6uNJGEjK7+lbrXIH70BmXrmi7q?=
 =?us-ascii?Q?8Pf1oFMcCHRebvgF4Wsx43K9FY/Vt/iHgW+HqaNJYMG2gATZihoX8Tzdm0ek?=
 =?us-ascii?Q?aebtybvyaDIi1s+icdILg3WGXWyszIvmJKvtTdW8bEhB5utpkNTO8+MEpeQT?=
 =?us-ascii?Q?Anj1lmhgGbe6+UlSMmLJ8HYJxUySUpPlGVrRYJa2QNYSV89tSkUeHRioDQ?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 109b6aa7-adc2-479f-a50b-08da08c7f50d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 10:13:33.0891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tTW/2xLScrdTyHL8HUVccIXOY1yO8rMzOjfjosNs5Xp0rRRCCdsywA8t3PdOMy7Sd3UTc3hspi98B9mIUDAZHXJNOJrq6TZIEuyMfoecTrI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR13MB3139
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

Ring enable masks are 64bit long.  Replace mask calculation from:
  block_cnt == 64 ? 0xffffffffffffffffULL : (1 << block_cnt) - 1
with:
  (U64_MAX >> (64 - block_cnt))
to simplify the code.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index ef8645b77e79..50f7ada0dedd 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2959,11 +2959,11 @@ static int nfp_net_set_config_and_enable(struct nfp_net *nn)
 	for (r = 0; r < nn->dp.num_rx_rings; r++)
 		nfp_net_rx_ring_hw_cfg_write(nn, &nn->dp.rx_rings[r], r);
 
-	nn_writeq(nn, NFP_NET_CFG_TXRS_ENABLE, nn->dp.num_tx_rings == 64 ?
-		  0xffffffffffffffffULL : ((u64)1 << nn->dp.num_tx_rings) - 1);
+	nn_writeq(nn, NFP_NET_CFG_TXRS_ENABLE,
+		  U64_MAX >> (64 - nn->dp.num_tx_rings));
 
-	nn_writeq(nn, NFP_NET_CFG_RXRS_ENABLE, nn->dp.num_rx_rings == 64 ?
-		  0xffffffffffffffffULL : ((u64)1 << nn->dp.num_rx_rings) - 1);
+	nn_writeq(nn, NFP_NET_CFG_RXRS_ENABLE,
+		  U64_MAX >> (64 - nn->dp.num_rx_rings));
 
 	if (nn->dp.netdev)
 		nfp_net_write_mac_addr(nn, nn->dp.netdev->dev_addr);
-- 
2.30.2

