Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 217B14BB928
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 13:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235217AbiBRM3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 07:29:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234972AbiBRM3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 07:29:42 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2102.outbound.protection.outlook.com [40.107.22.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936A333A05;
        Fri, 18 Feb 2022 04:29:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oM5ZHXTTTZcfsf/rk2dKR0/HkFNNOz1eEpd1fMwHWi9zJgou4+6tg4/Tvm0muA62lH/i/m1t3NQTmJG5PHcnAWFP7GMfpsPTEG/xhwMPRViisNz+cGaW0UGesPN3qfXcCjNkX2z1OW+nCx6NggkGf0vGimFCufESzDGRcjPYf5bsP7W2VCwGI/jNbmdq1pGTnzoGUc/kx8p7kJ8Hf9R5mUu4rDg/HYXOKIimK04P93RS1jPvl8efogCxmxCRf/FNVP6eNduDJj6Cfw6M0WR7OjRjYnAJ/ojqpXz1qMPTC5UT+jdq2yvXCOx847CuYJxsiqw3wD7Ay3dbjGWMlChApw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LepwFZoXRCbLFvnZzmH1g6+hDMkPW1Fxp+0YPqZ0p7E=;
 b=jl25COQutSdeTOIjgyIPDIMYDPxNQDa8mefqMIYuZZ/BhOUg4OM+ybGPkiijFvgQ5JEwuVYqJdMZzwLaEOtRKHdhcQBtLkuG9MrGuOPVTVMm7IAmvVAfOBhQDfrP9L6UFAwxB0ydGjoTwgWD5kOl4kkABYshqhYxHnMr9p5Wud88SEg7efdtmkdeb14zSJuBAZtEmT1o5UlpnVdv3iL4ln3U1TABMPLbt5F1NQfjZseWxGWxcruPJdnf/nG/Vmsyg6ZWwHK1+s0OowxPOcWtxCbzbA102NE1WhcKVT5oZsMqMmtnrg7n1Y1VO41JYRwIeRpnqmedXmcHSXNeSm/FvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LepwFZoXRCbLFvnZzmH1g6+hDMkPW1Fxp+0YPqZ0p7E=;
 b=I9lRslbyVEHnJsbuPMa3JZoQLeOLjUKjLXjHLYpSq2c20k25JPLCa2vdBR7XHzgSxgMJ+o1NRMX2spsxPJ8jeTlzAK/yeGtJjWtAHlfrIKFrsL1QjAm04DVg8+cF9Vqt+jr0g74Xi1cill0SI7O4D9QaFuIQ/mY5yZo3iek/Ziw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by HE1P190MB0571.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:5e::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.18; Fri, 18 Feb 2022 12:29:20 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::f16c:7fde:c692:f911]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::f16c:7fde:c692:f911%6]) with mapi id 15.20.4995.022; Fri, 18 Feb 2022
 12:29:20 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: prestera: acl: fix 'client_map' buff overflow
Date:   Fri, 18 Feb 2022 14:29:11 +0200
Message-Id: <1645187351-8489-1-git-send-email-volodymyr.mytnyk@plvision.eu>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0080.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::14) To VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:123::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6903b9c-ef44-461e-c5c6-08d9f2da4954
X-MS-TrafficTypeDiagnostic: HE1P190MB0571:EE_
X-Microsoft-Antispam-PRVS: <HE1P190MB057186007BAC76F803DD70048F379@HE1P190MB0571.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:510;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9hzjWk++6lJc1VN7fb2dnt2CSlokEYmShfaueSKy1QwH3BNpWxJxuU70U7CHCQn08v/miFgZg/91ls4lDBOxmP1drMhGzn+9za2/X+Sw79hr7tzUOxTfr6hx9R5ioqDBh1wlcSwVuXZv4fWh6DDVQzy28Sk53pelTONoCyIuLMuwVZXQLGeL3CifIMsH54TLp+DhpmMz7cjoXOKo2/VyXBj596hta2qWs2yryeUjbvXcuFX720JRs0FgIIF+A44lo4yo1JGjF4Yf1eY03JgV8v3/a5RBsIFUZysYKMkmo30cOLgrQ1XXz/bQNTzhksbtvEpA0UDvA0/MOFKn2ARgA0VklabQ3nQchWKwloJMFKcWGSo/Z6LcZd5YN7SrmgX2wfoKFnnJzDYVQXf6hp8FsbKBNU4zqfEjDC+WxeV62Q5GHgf0dn2LnA1XJ0rip9bGjjKKy+FJbK0FYxpcro7omGb7bPzTDR8q7tJMKI+GeuLXcXafLfoO2tpnQWH7PyKAjDhFw2Qegu2wpa6wmO2lMCxVIapQZWCUUwwsf7/lpd3NAXK3oO5u6O0OGdkRkGO2/D0FNFTZniDH6Zm2qijkRfqIdzX+K2aB+9s6vZN19Kw34rQ4wakHAdiWB0dvwq2pmmBAz/ecCItVRZW5/LevECLA9RAVlSJZPmNHL4YixNUEDhYSTkMS0tbD2YoIu4zJgaeDuZ5FXHFzyta89joLCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(346002)(136003)(396003)(366004)(39830400003)(376002)(6512007)(6666004)(6506007)(38100700002)(2616005)(38350700002)(36756003)(44832011)(2906002)(5660300002)(8936002)(316002)(54906003)(6916009)(6486002)(4326008)(508600001)(52116002)(26005)(186003)(83380400001)(8676002)(66556008)(86362001)(66946007)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YgjHRzPXPLsrnHPh9vloNnZrjjeDwLqMQpY6eD4re6ld3nE8nk7rX685dJXS?=
 =?us-ascii?Q?MFEv/1lK5TKKPyi+Hhp27vUvdq0/t9fhXTkT2/EvqVWnjFqNljvmEF9BxXZx?=
 =?us-ascii?Q?6BIGtDC5eBw2VXiPdiMxMcTZEikwlGxHoDLOHAJ+4N7FtCUKIyTFmKRAu+N7?=
 =?us-ascii?Q?cqovTMlrfIDBi1sByOeIVwvnFC/lVIQiCYAT+6WxtggHTV9Hbx0oopJykKMP?=
 =?us-ascii?Q?8uWBvDj6MGYzoc96dP18gJx9Ql7/JEGUe7iA//VTVvR+bA4Qs8V/GPGJviQN?=
 =?us-ascii?Q?JDmttir6KQ7plBHbWT7mFuVcGkOjiI6wdvuu/Db72t/hAizAcXGUvQ964ZZh?=
 =?us-ascii?Q?pDExboxwZrkOXJ5A67bwTamtIsRsb4awuSP793fEVCNaV7UrhojzoowsSyau?=
 =?us-ascii?Q?+txoU8LFiANjoMfCOCtHZp/jJdTwhk2YSJTkiYmWzhIEcrXmasWd7N5zHgqr?=
 =?us-ascii?Q?efXMR5ZXJ02pe1f/h9oRUIt2cm9dr0/n3tdYEsFDhKHo3bGUqI1MxZsvYv7c?=
 =?us-ascii?Q?1iZwd8OKBTShQfKE6GFYdzeQUWJZYX+jN65qUiDoeDBr9u4BhDzvlDhjsH42?=
 =?us-ascii?Q?t97FwFvGw8SGXqFRlul4oUJnEsjE5keVqBSWnawaZBI2yCUeQieMOX2OpaTj?=
 =?us-ascii?Q?qHqX5waJN2haJQHB1ztMJSZ2WH7tKupgJ+32imG3nrEPo0C2G7guekKRZXH6?=
 =?us-ascii?Q?U4Vbs3BFvCyCS7LJsZP0yWxYzbfbflKPdVhhPlSlnNaH5NTxIjwPo7R1fHqF?=
 =?us-ascii?Q?mul7At2jHLpAJnE62ufembx6oGTR3U6r6Sn836fCBaB+9huoJeVV0PWwDdo+?=
 =?us-ascii?Q?DqxScerKZfs+WBW7bp1m9uwvPZqpXUd6G/ekc7Wq/WjhotSCu3aj/yn+AAMB?=
 =?us-ascii?Q?94V5Q6jF4jw131G8ZapazIjaDRFxDLEX3X9/cg/GGXWFoxUxCiFO5Gs5X6Do?=
 =?us-ascii?Q?QctcPp2kYHBpWY8YigVPSnsqWqW1lyZwBUfpnFo+MsjhjrsqRyBC1PtKKWnQ?=
 =?us-ascii?Q?6Yi69ua+vsaXACdZMsucpGd8YQsfDdOuu6epYARJ5VFjyUrI87rz570VP59b?=
 =?us-ascii?Q?bTd5lSt8lIMohZvej5yujFaWM/3IoPc5upvTu9Xx6bFJe6/BSnpU9Ct60K3E?=
 =?us-ascii?Q?I+rn2ky+QwiFFrW3nymIY2rxYPfdI0Y3tZIhbAZEWZAfhJlMUwTlCgtIlGbG?=
 =?us-ascii?Q?kVpPZ/0NpeZ82+9K4zT54foeo2MvnOezFZlzjdVpukGCulUJiYcktEPY90r6?=
 =?us-ascii?Q?NpdRp9iegh15vu33+ikXw8BbU+ekatvZmvB6GtDtD22Y3byLq0R8pEtRYeHs?=
 =?us-ascii?Q?nW/sjgJkokoZjBoenuRJk9X5K2oLrRBwEmo7lCx2txnHSE9STAvJvybdRRyF?=
 =?us-ascii?Q?K91dcd75OiW061PwRLmbm+3r2HytiM4dgazwKY7uDXcBxzuX/cxj2ssjLruN?=
 =?us-ascii?Q?qNxZhqw2aHM/d3UefH0iTqoaI2xv+Tdr4asIOsqyWycEyPQDgyk6+OKPY0/S?=
 =?us-ascii?Q?6wePFrm9HQqu3VDkn7P01YmQruzMEwcntMfb53IQiGbU2k8oWV3FyqWQZJap?=
 =?us-ascii?Q?64HzmOJIVu4A/Xn2nvk6KaQdWtMn1gS49JXzQeRkcTwle4R6OSE18bSJussP?=
 =?us-ascii?Q?mS+Keof8gLIbIIPVnS2mutQRUCreUIJNYz/aK846fCooDDhD5NM7NEpHU7lc?=
 =?us-ascii?Q?6MxBVw=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: f6903b9c-ef44-461e-c5c6-08d9f2da4954
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 12:29:19.9688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WmVEpgCPfF0g2Zckinr4hhREFqwqPJUUXV5y3/HBTROkWlOAvJHryfDCUVK/p5Y0+5ELPz/pOSDMnBcsDQVwirsRE3d7a1cughq/2Z6dbEY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0571
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Volodymyr Mytnyk <vmytnyk@marvell.com>

smatch warnings:
drivers/net/ethernet/marvell/prestera/prestera_acl.c:103
prestera_acl_chain_to_client() error: buffer overflow
'client_map' 3 <= 3

	prestera_acl_chain_to_client(u32 chain_index, ...)
        ...
	u32 client_map[] = {
		PRESTERA_HW_COUNTER_CLIENT_LOOKUP_0,
		PRESTERA_HW_COUNTER_CLIENT_LOOKUP_1,
		PRESTERA_HW_COUNTER_CLIENT_LOOKUP_2
	};
	if (chain_index > ARRAY_SIZE(client_map))
	...

Fixes: fa5d824ce5dd ("net: prestera: acl: add multi-chain support offload")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_acl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.c b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
index 06303e31b32a..e4af8a503277 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_acl.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
@@ -97,7 +97,7 @@ int prestera_acl_chain_to_client(u32 chain_index, u32 *client)
 		PRESTERA_HW_COUNTER_CLIENT_LOOKUP_2
 	};
 
-	if (chain_index > ARRAY_SIZE(client_map))
+	if (chain_index >= ARRAY_SIZE(client_map))
 		return -EINVAL;
 
 	*client = client_map[chain_index];
-- 
2.7.4

