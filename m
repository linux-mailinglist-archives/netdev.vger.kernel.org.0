Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9272F5A46F9
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 12:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbiH2KR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 06:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiH2KRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 06:17:16 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2122.outbound.protection.outlook.com [40.107.95.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6CE18E2A
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 03:17:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G7lBnkONwkleO6zMAri8LvZqhFwyPacJCbH0BsuV8XhsAtpi+Moo3snnUPhVaWS8l84cc9jYNKiiyAuvBuXIBlGS2466r0U46f1zokF3AiJB7W3XXYp4Vsyvuk2+a5PsyHgSM+TmnPTBMWna0rVGh5KoRhTsVPC9ghLlfMciR8vxo7pCAbZcVKPwVhWOIefWW8pjabJV4DVGHn2BSerWcIlFng5nXglDvaDvE0JEqteuHpTuJ07rWEFzEJY1o8I6q7vMn+3vgekFVkazBK3PaIYk/6Dxoy+4shMIT5dSW7/SfsZ1i520UrZBnjlOmhZlvIUsCGUGBCrRo3HG4zysbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jfpLlq5o03MaP5ey9kmb0r41JinSzKzn6TFQk/1qh1E=;
 b=jR6lTBTHXxG+oVn7q9+upudqvXjT2eSl9kH2zban1Td9HtfuA1p8Rv943OC6CWMZ5Qt3heXXuJfOCiYAh1bYawvbniHaH+behfjI8lbIVTkoKpgLAoMN9Xod6DFqTJAWaPvRs+6X1DYrOLLUbFPsBU/UcLXAd9k6f/3HdhoB+r4bwn8EkI3yCV64s0Jkdt+7ChMwsGj6kDCN0jgZduUkD4ZwhuyHaeVPa5JIMr6xEC5k8WOOecX8P8t8W3LU6iESPnwR4j/YJktOT6LcoEFnc8PC6OnpxLyw+aIhg3WU61W93Zap9vphQwFFQCOqAMd78Abup0JIG7DZVnFC6UW0WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jfpLlq5o03MaP5ey9kmb0r41JinSzKzn6TFQk/1qh1E=;
 b=jEzBu12huD0Qwy3UnXN0zrs6AkrSZ8NfmSoqbZG+GpUN30BHAhfr8oyf3ZBcENjk0jUZs/goB5q4kjdqm9YUIyZH6gGITWoM0kBY+re9osg3PgeVVx99lV+/06Iub+MiqwGRA1UYCbSF6PXxnRceYoid7J9FvAyEXNfpboS1Y3M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB4471.namprd13.prod.outlook.com (2603:10b6:a03:1db::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Mon, 29 Aug
 2022 10:17:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576%9]) with mapi id 15.20.5588.010; Mon, 29 Aug 2022
 10:17:10 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net] nfp: fix the access to management firmware hanging
Date:   Mon, 29 Aug 2022 12:16:51 +0200
Message-Id: <20220829101651.633840-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P250CA0010.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c6603b9-e4b7-4aa0-6f9b-08da89a7a256
X-MS-TrafficTypeDiagnostic: BY5PR13MB4471:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Un2kBHA0T0IDnVLubehDmBlvMwDQVkP/Ym7F+XCmSqPfXWw3AVTNyALPziO+WJheus853cmR/ODHj0SYjNy8T/ZmDn9Mn4BvHuagNhe+cSQRfSvJXS4JeGnMxVejVcvnudkYTsm6/2C69xsgP55VhBEtgfjOIz/lMkVPksnh+/IUhwOK8cJxiWeSLKw6pdNITbSXfmGgczjt43w+JI4cfunS1mq9cJX/11T9swd6x/OCEj856MLGYC0U5lJGEjvejMRBeTilZK+qq2PW6R+MgPNN0nftPdmicEpxvnssndkipccFrENRevY+Vlw2w4aqsKqIuIH+Keti8Ih2TWEPZa58t0FZ7kXYFy2FqB9/q3ynHss6YR9poWibyQHGMnFnUnnFrLRqXBmMJ5LMz2zzaJ93UVVL14Cbcq6q5PTPwow3ZPS6BiPViqTk3B6532nQ0TnJhwnVBkMtBFkAVi9SS+Nd/w1eyKRX4mZIX23Jn/coW46ovKq+m4/TEN2ujx/RyXs69dIOHPwyGgIPu/RrYVbjGAmO+gSxY2uNqtWIbnQacrp2Zhi+0Bom4Hvw/NkIYZdFgQUlmQMjpCfviyU+J7Pegt5TcSEg6+UVPs6aLaZnK7If0QLSottsGvTQwlu7p9m0364UXbusbsLri5Tv5ZYbyyd9Y8v2UwgijfBV5WrqsZiJpfsURTFalbg6AhRM2ELCiPovGLnHJBLfyUsvnPxr1kNzl5Esgu7hC6isR61C0nztrafzdsBO5pq/Zqs6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39830400003)(396003)(366004)(136003)(5660300002)(8936002)(41300700001)(186003)(2616005)(86362001)(1076003)(6506007)(44832011)(6666004)(6512007)(52116002)(107886003)(83380400001)(2906002)(36756003)(316002)(110136005)(478600001)(38100700002)(6486002)(4326008)(66556008)(8676002)(66946007)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3b1xTsNj7Z80kZQ0hdYaXgrrE5zoBr0n6mjeeDp+Ruk/gWD+0nfNclp5W+Iv?=
 =?us-ascii?Q?1f/4pcaWFsdgJ1rCxe/2EwYh6LDtKq+RiqwDmo3OIh2ae0MYZPOXxgD7FSTf?=
 =?us-ascii?Q?kh3qbB/GYYXdWg6y/IznA5wPT78sUr+vVhv+oB2UaLI3cVBKbWGg67uN+wYL?=
 =?us-ascii?Q?wnjqMsMsaMcwwGHcvujUwNYDZLn1Lvb1Hpca27C9JNn73Jo1IDGSEuAP8Rfr?=
 =?us-ascii?Q?14mhpGAEOb3MMgzdjT1XnvardVbr8BDpG07wuy+RvaSiWg71k6lccMw2T6G0?=
 =?us-ascii?Q?7xaClAsrm9irQsHRPMyZB36MNxqcjcPp1LFSYxNFx73G9O3au+diMaQAnuKx?=
 =?us-ascii?Q?QLMIBP77kC5jBjTJ0LMy2UJo2JW2wS7pu9FLJnT7v/oWyehcwRTWOeYN53a5?=
 =?us-ascii?Q?BizqlAOwN4frR5IVrCTLhKNe8MATetAV942M4JlaFC8RfhdCm+2QpZoUJjO7?=
 =?us-ascii?Q?tlbQnZ6g5pIxcwy6IEFUIfvylB5LoOx/Pzbs2QgmGnpBQ3IgNgS1EjSiMGI7?=
 =?us-ascii?Q?KGp3GtX9BJPdx7XAh/HjykTQ2zt/3uBrw/fR+t0L/d7ijQYz228KwG6R3u3v?=
 =?us-ascii?Q?eYRnz+Q3kLMz4W1fSINmky7J9d3SKyzCpAEBDBJVyDSi3jvyiscNQC5gyKBF?=
 =?us-ascii?Q?1i7srCej0xWpcrwAjZ77PHmVuiNciKMgTm5m3m132ENiCzZ3a5mPz+T5Bgr0?=
 =?us-ascii?Q?yd+evDMsSsy+mttKRAVxOnBnY4zeJ03Ophapd7Rmf2rpC/luRqVQHvc4E1sq?=
 =?us-ascii?Q?lPjfpIsuEfZJpsWG8z+EdS3HkkxWjsW6GE0/1cnO5nDQlQMJ2K69iprCuK8J?=
 =?us-ascii?Q?qlWF2OAqpPVMngKymwgmbffaGeDskJ5aQ+VV3KthE1qp58VLJH7Y02znPmjB?=
 =?us-ascii?Q?u1FZLaXbcTNnkaP7FNw+Wotjh6t5NkdqihJs2M4hKW5XG8iZiCK6tOHEmq5b?=
 =?us-ascii?Q?ZzkYwe65XWxa3pfCWdnpPrHAZgV30VHmMdGnUbjigiE8VV35TE5jJ0uxLsDW?=
 =?us-ascii?Q?BrvHPhVsf0R+KJhV40F6KDvsjMniAkEhd2ojbgKBwgxYUVELGyvncu5ghv+M?=
 =?us-ascii?Q?+SCnxhGP0ZoCY6IL8meCC8y+7oT62UukLdhCVn2a71RzQOueuJYAK0zL6WrU?=
 =?us-ascii?Q?u+LFGhJWi0B0CagU6Y0YJjpUwvpdjjo5+wXApBBBOcws2LX1Q1e48AfbrmR6?=
 =?us-ascii?Q?NC6leZGIShPtJnkj4lNynU7svSZWpcrXdNr38tHrUV95fU8/xBLJDl+CqUMD?=
 =?us-ascii?Q?HsZrl3zPKiUL6PickZxgMV5qhJlq8QCkpj33+pnrC33Nd4/zq9MC/cSgP8wK?=
 =?us-ascii?Q?3HqbRpfEuqRg9thhquCOnFgx+57yY47iTZQq0nNf0RFtAsTIvPChdlfxpM0E?=
 =?us-ascii?Q?v9jcEfOFGaGJ9OW3aMjSVOmfcrdOET5GBgF0Bg5HnevSbXcvynUDcCgRNWbj?=
 =?us-ascii?Q?7O59OULeC6/Ey381a+aHfVpdWF3jjvDPLpFaV4dguPwkv4yh2OdYMEcyzKg7?=
 =?us-ascii?Q?uQMokXkvPfkltcsHRV6RXfC4IbyfN6twvLiQEJktPrGaqchSL8e4RzABbT42?=
 =?us-ascii?Q?fm4zyZWcc4pw/jFnRacWkOsV2Jj+MUbOk97U7+/OkBHUKJKWS4vd1FZY8bIk?=
 =?us-ascii?Q?kWil7lsP3pT7crQmNxMqM5Y+LaDxPZEvsdtlFob5edkHJg4hxoucoG97XpWB?=
 =?us-ascii?Q?rt+RDA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c6603b9-e4b7-4aa0-6f9b-08da89a7a256
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 10:17:10.5275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AzMcibh4DeYsAkgld7KoPIFa/3FYSsObi9KMneHwZk3KI6I+3iQALHE+qJnlDWcx5yx3zHCfedw1/xQ63E+GrD0C9HXd1rtbb/19TcOsTP4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB4471
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gao Xiao <gao.xiao@corigine.com>

When running `ethtool -p` with the old management firmware,
the management firmware resource is not correctly released,
which causes firmware related malfunction: all the access
to management firmware hangs.

It releases the management firmware resource when set id
mode operation is not supported.

Fixes: ccb9bc1dfa44 ("nfp: add 'ethtool --identify' support")
Signed-off-by: Gao Xiao <gao.xiao@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
index edd300033735..4cc38799eabc 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
@@ -507,6 +507,7 @@ int nfp_eth_set_idmode(struct nfp_cpp *cpp, unsigned int idx, bool state)
 	if (nfp_nsp_get_abi_ver_minor(nsp) < 32) {
 		nfp_err(nfp_nsp_cpp(nsp),
 			"set id mode operation not supported, please update flash\n");
+		nfp_eth_config_cleanup_end(nsp);
 		return -EOPNOTSUPP;
 	}
 
-- 
2.30.2

