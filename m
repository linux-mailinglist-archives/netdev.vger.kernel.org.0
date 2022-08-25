Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D29045A0B17
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 10:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235902AbiHYIJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 04:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239475AbiHYIJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 04:09:18 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2125.outbound.protection.outlook.com [40.107.92.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40373A4B22
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 01:09:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iunl0pp8m+ZfohiWjVlQEetfDRJ5fVloBOnvAtIzInH2IeqoAtetv3Em8Qypo/2HVTIT/t38E4xqPvi0q3fZrFzXRoJAW5GUWYNG5+J7/Y86PKD26OTG2gX7hWMNA+zt30xfhHyJH4DQitoEa4vQML+Yj0d/zWI14QQYXs0Oz3N9RB5LRsUUGxNZycNf72DEHdL47GFTAl/RsWNVh6HoqRhjGcbzbpzM0oyB0eHF25QHhW4bCRIMIruIoX6VmrOpn+gbze5iBcn/E3vNExSnupLyD4EToYjuOCFCUpyPFE9yupdCxb2c39zE1iWso/DUuwzBBpJvOzoV0MUrd5dl0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vgm/zFi2DQXqwT1A3rqk2NotxjgH33ux6MQxfZDRYds=;
 b=hAuxnUhQxMj0wtl0KmdP5n3rwyqLswSJnTFBsaSNtktfMXk1CrQqSYUTbPGhu56wfqQQK6NkWsTb1xsTXWl//Vgq5V3OD9k4HgPB9EQMd5qtuUgOP9RQPy4NOU93oJmvTZZdqldWUZ6ZzKC1qxhtVNJGKG4X7iIUHv6DS3tIlBXot2ph1bJyfSwmQV+qxX3xXLjZF0645709GchLgWPPnmSA06ZKGSpoQVrmCJ7UNR4dEWaAMhn10gCX/Hb0g7Ofr5AytEZm1DuCeePFKwwwXn3GRufwIpun4D62d98IALcmHKNrENCIXxGVRdHnneiqMb6BhZyNknrKn92lzTwHAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vgm/zFi2DQXqwT1A3rqk2NotxjgH33ux6MQxfZDRYds=;
 b=jevkypdHB3p6Y8r4P/bScQF7Swn5IM0JK7rAN8HpkCNbnSgj7/i2C4x69SzfDNf5pP1Fv90dkNShk4SbZs0/zPX8RIUpgZ1xzykf+MnMzhTrHD02EEPfvxMt2h4PDbJB4p6euN6C01vJPDdmxa0t7WJU+iSttHQ8mZDLszkNlkM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN6PR13MB3122.namprd13.prod.outlook.com (2603:10b6:405:7c::38) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Thu, 25 Aug
 2022 08:09:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576%8]) with mapi id 15.20.5566.014; Thu, 25 Aug 2022
 08:09:12 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Tianyu Yuan <tianyu.yuan@corigine.com>
Subject: [PATCH net] nfp: flower: fix ingress police using matchall filter
Date:   Thu, 25 Aug 2022 10:08:45 +0200
Message-Id: <20220825080845.507534-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P195CA0019.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ebc10c1b-308b-49ed-3e9d-08da86711814
X-MS-TrafficTypeDiagnostic: BN6PR13MB3122:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m/d/oLN1uBckQgZVvWmlvIkNyQkksZPenEW1fR+e0s98rAGx4GtdEX0Fm+oNT778TlXw+ZQaLUBFCMr/6WM2ULbD/WFZc68VNCfZ0jg3FSwg+pywW14KHYm/b1/5aHWfNZIIF16XfAESp7dUwNN0AfmtDfjvi16n9WHVxdm7TUpfWdWVHywjru5r2rtR4rPlaaihV7IpimYjGBqaoCMIfy8INJ9QmEc06H0UhpUBX7P4mGI7giqgAwml2fB6PmNem1vomVjsari36otGLw5cKcJeG19RXUyIIz5x9bxw++hCnWwLe4apOCpU+zOoFN5E6V/5pnQjT3bqNTkORpAvGZQ/aZC7djwe35M8MgqyaDUM4whtnllwnGgw7Dqq1dKyiCUmcm8l2ibzoLR9yjsnoEpxtMU8Hddb65oFiazdAG58oSqXhDq3SK8D/eLYj2bjWOHVNQFDLesaKFE4M+SDS5YMMHBnQcYnEmkW0axrG5jVB5niRCe1Ngl5+GYln2Wo8SmIT2udwMITsl2rAfvMiRjcqmgVbpT6Mise+REggUNmY0bpGCqwH3pxi+XdkYRj/m0gNpQwx3OsFj6BDHgkxgaUURkj/LvimhnACrbKNvNer+b7bYE0M91C69HVebO1smjSLATyuBO274AdlLWRzwd84kvTXXDFwVlLi3JauMqoufsBaJvbJgKa7oeakLFTkyw1IKcEs6ZHKDYU+2Ftfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39840400004)(396003)(376002)(366004)(136003)(346002)(83380400001)(5660300002)(4326008)(36756003)(8676002)(66946007)(66476007)(6486002)(66556008)(316002)(2906002)(86362001)(44832011)(38100700002)(8936002)(41300700001)(52116002)(6666004)(6506007)(186003)(6512007)(110136005)(1076003)(2616005)(478600001)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bxpEcP99JwX0ImhPE1B1YmSxzqyp2fvqHrw/1gOD0ysPP6QBnndqrONA4pwU?=
 =?us-ascii?Q?6ARiZKM7EEE270qHTsuIV/QsXS5dzN+pjvgci0IjjNN5IE0HB6sKS3aYaVvf?=
 =?us-ascii?Q?9mF+BT6w2ssRD+OTRYmKmdIZRNNrkG9XkWy9LN7c08AJRO6xJQZfMopbnEGL?=
 =?us-ascii?Q?2sZilB2Q3qSV1JAzmT7+Z7vebW7w80FA8BysWO3fR1c0Tg4JcoaRcE2Kab0X?=
 =?us-ascii?Q?uy2laKD3FAOKi915zCGD0/if9vIbCaR9fi44YZMdcx9g8q23M+JGSDDumduB?=
 =?us-ascii?Q?9QfephwZ5cAvayWhBXhAKkAAGhZwhACKFXmeGkNL6soW7S1TBIHtuBw6TsNz?=
 =?us-ascii?Q?ZIdJWAMDzp+S+fXMYQjSBQFu5hQHkUrgu624pO+3x2Jk1vTVq7AQH5S91cr9?=
 =?us-ascii?Q?hTpn0UuLNCNa8p6hMTXNP3cv0Z2QRS56JO9acQipujt4H0xbUfuiQI936HJG?=
 =?us-ascii?Q?n7q1YSAr2/5rEiI+VanbUVIs48nKWh2aMqsZjvnyg80uSK29cAA9KWcY4VNg?=
 =?us-ascii?Q?KHzBXKbEA1fQhqzHLVUOBBbe5pH0mldTuSb0oLnjzccS1mnkg+vjByHCNox8?=
 =?us-ascii?Q?MoOx2nDZTzm5dM1h1vr4wCp6ftBYhocvgmQw04egNRj3oMnt5I5GE10xqW11?=
 =?us-ascii?Q?vUVFy/v8AtpWkhpc6oazFSVn7wqmVeku1f8lLLPV4W2m29ruEnU6p6qujvFT?=
 =?us-ascii?Q?qa1nS9og6BPBxSLeZEe0lQc/SG8oRjirMD/7nT1gHjwDI+8gCrQ+LifM3gB3?=
 =?us-ascii?Q?WVw7ARUw5tOft/kpAOvOGpgRwHjeVAe1OWU7k7juTIVbvj4KLlUUxnyDKEIA?=
 =?us-ascii?Q?Lzqk08sniKZGXiqalQs4gUWKstKxKZICM1ol6cXQ1j7KLXsGj2BO6uJWHorw?=
 =?us-ascii?Q?XWC8jFr3lEafIJ5GIbXKnnxS+e5lbu6fvvo7FatejC5M2mheYrp8COwJRsS2?=
 =?us-ascii?Q?k/OQP7OGNoCCAMTfXZ6+9VqIPUQ+D8dhDx/WAyKAWVRrXNv1zsYxRPNtk+Pa?=
 =?us-ascii?Q?YKbdFH7tX6NaYwARfcdQhvmOS/wlD7vaxzS7/oqNGFBRMwmk1BHFd3MbFejj?=
 =?us-ascii?Q?JEL1GIgzbKOMFMf6zO+9DDxXjs6BMvJkSbVGA46NPOor2dx/2X0xqh3c5TQe?=
 =?us-ascii?Q?7EC4sPxC18OyZ8arfj3xb91iUbVmIfQDydMRNKbTV858T8ZBXZ9RbotQviiz?=
 =?us-ascii?Q?7uVSE4yZ3JI6xt977hYLnze17bm3Btf2I0bTRvmBltpvE1KWMGgi/nIKASeq?=
 =?us-ascii?Q?8jy3GQDN1hhr3jvNU6Ax38WP3zDgUDZO/0hkCnQkhhLoq7XNDqG+YfTkdyyP?=
 =?us-ascii?Q?7ClIx0YnY4N1SWpnxNqkW549lip6S4nO0OctGVJLMgoVLwk0fSmt8W5cHtJA?=
 =?us-ascii?Q?wmFFPuG5QeflEkH58mqK2L8Zq6YikotNd5mG6Z9KVj+P8l66a1INvB6OxmrV?=
 =?us-ascii?Q?lM4/nzTFpcuiSV2bQq/sAQOsGIEdeoVxzSK//P4enGb/TvnkyxnbeZfAZgnR?=
 =?us-ascii?Q?wX+k5jMSXYQ3zT+C163XYK5nB8wuYv1uQ34HdxxARxhiiNL/McidWoPzL046?=
 =?us-ascii?Q?pdYxNEC2iNUv0zSFovbSosrfARGAf0d2UxbmEenBmrufhN+x5PPxqPYaHVkR?=
 =?us-ascii?Q?jq49JVYIn0/v5uSqzFjzYhILTN7ux3LppOdLN6qvc1bQ3x5BD+06ZVPH9MCV?=
 =?us-ascii?Q?ioofIw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebc10c1b-308b-49ed-3e9d-08da86711814
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 08:09:12.2252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w7fdnaUVrSWUZ0vsP9pjQUr4QwQnz1aOgJ0UlgrkbG79Xgch/36/BH7pRpDXkqpKxYzFTRvCsZ18EhclLgoKeRkbmOMQuqk5/MwtwjauVVI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR13MB3122
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Yuan <tianyu.yuan@corigine.com>

Referenced commit introduced nfp_policer_validate in the progress
installing rate limiter. This validate check the action id and will
reject police with CONTINUE, which is required to support ingress
police offload.

Fix this issue by allowing FLOW_ACTION_CONTINUE as notexceed action
id in nfp_policer_validate

Fixes: d97b4b105ce7 ("flow_offload: reject offload for all drivers with invalid police parameters")
Signed-off-by: Tianyu Yuan <tianyu.yuan@corigine.com>
Reviewed-by: Baowen Zheng <baowen.zheng@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/flower/qos_conf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
index 4e5df9f2c372..7b92026e1a6f 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
@@ -127,10 +127,11 @@ static int nfp_policer_validate(const struct flow_action *action,
 		return -EOPNOTSUPP;
 	}
 
-	if (act->police.notexceed.act_id != FLOW_ACTION_PIPE &&
+	if (act->police.notexceed.act_id != FLOW_ACTION_CONTINUE &&
+	    act->police.notexceed.act_id != FLOW_ACTION_PIPE &&
 	    act->police.notexceed.act_id != FLOW_ACTION_ACCEPT) {
 		NL_SET_ERR_MSG_MOD(extack,
-				   "Offload not supported when conform action is not pipe or ok");
+				   "Offload not supported when conform action is not continue, pipe or ok");
 		return -EOPNOTSUPP;
 	}
 
-- 
2.30.2

