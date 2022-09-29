Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2285E5EF115
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 10:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235108AbiI2I7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 04:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234841AbiI2I7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 04:59:07 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2117.outbound.protection.outlook.com [40.107.223.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E62D13EEBA
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 01:59:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jn6yxUlpRvX5bBjMTvJkTY5Bo4BKW8syVvD6vsBtRwarNTLBqr5aidcU+6OX/0Rafsemh1WL1RPRGezFsB2NuvJX6IV5E3a6+Np8Sk2WNKWCRN6eo0mUD7MUrSLhnssVtp5SBwNMxk3lDOLLz1eiuUsIBnqaIs6gpq2NLqaIbw67FdzAnNDTyvQtbBJbZ2XGI8aapq/EiPwoRAEw4Da0zIkgPI5Wr11h7rTL8rGZyL/djlQWvB6K2JJWP6jGIL7nIw9Vgnq1p85eR8FL3a/DRenCUXeVXtlIayOnvZygAtaILOKEArN4yR5737CK55uYii+A52mH3NcoUIxVpOJ0zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=URgznGOsKOJaeYxYk6t+Yda+OB/psrONMj5do3nuO3o=;
 b=oUWopARpV79WnuWVWlmhj+0/kcZLqmPhNnFRS4RzHPJB1B3ttlNn853wRa0LR5AhBcYGUsHctag2nYcof5Z5w6sQjaGiWBw+MC01+NwrF2+iBS7ag4HBJ9PrqUrrvNutH1jZ6lmz016bwbnTIZILhgjmGD8xqYEX+A+FFbQ7pas4zhhHEr3U68/05rFLsYBM74thYKVLQyN1vAnhnG1bywIn/4xT/yWnhHB4M3RUHgRSoSQBj66iUbxZg+s0YVdLHnvRpT9CwCJizkk5UmQQvdkmqrjuCbTK8F7XvZy37JrFZGpd5D7chnQkH+i5oeGy1TRsB4N6HAgGGRnqr/BTvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=URgznGOsKOJaeYxYk6t+Yda+OB/psrONMj5do3nuO3o=;
 b=uFgB5tW+0ItxJIhVXFEXREJ5xxcZK8/CDVAEckKsNHoGX0E1/3wwENIaW+1jDodV36F2bmwmUrkKwtwaB5ao4ACctdMXSiefOpmdPA6FJpSvHhwCspiIjaZkCmRE4wa+qqKgpxQ/lII6J+M20SlMMou1ln6Ew7TDaYRlToQXskg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3854.namprd13.prod.outlook.com (2603:10b6:208:19e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Thu, 29 Sep
 2022 08:59:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54%5]) with mapi id 15.20.5676.011; Thu, 29 Sep 2022
 08:59:01 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Fei Qin <fei.qin@corigine.com>
Subject: [PATCH net-next v2 5/5] nfp: add support restart of link auto-negotiation
Date:   Thu, 29 Sep 2022 10:58:32 +0200
Message-Id: <20220929085832.622510-6-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220929085832.622510-1-simon.horman@corigine.com>
References: <20220929085832.622510-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P190CA0036.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3854:EE_
X-MS-Office365-Filtering-Correlation-Id: 2135f95f-1263-42b0-eb57-08daa1f8da18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bFlZiiXee17H1bKMj229nMSQcWL4Vw8uMdN4EniXV3tV1OeGhCjvfQ2CXhPD3BKqTCG2CB6q0iaky8yy+csJvetH60lxm43YPVQ1xJQpJaqh/uieirdIKMUUIYhMvEdgouVYJchJYpxd0hlCv1cNjZduldKm2o1CG5ErfL+mX7SC3OS10eSmVIPQ+qjExtguNKbWFobiMCjLngsuYWoZ+8ntU3V0dCyLVm0TSdcc3SALZV4yiYJgOEX/n5r1nvDMuq80mUDzgoHT+uDOcnFIpoNBijfL6k/CxBUtOf7hwpeMHIn2ctoUHgTOFspPwqF0Z9TYpUPiaoDDf7UVNqIMHIdy4V1Vy4WYUQ3PhD3rmXIqQM3XhERw6FCWBh8plyZpCqnRqVn/eCuIhuFpiCZcN5h987+3OmyHs73g9Lk5K0eTMuL80Ys4O1G8bLiJe+krZBD66M/EcwS5WRo0itjrHG3RxMbYj9gDZZpcEnqUlkQUwWi0IHxcfCHWM6CQuy6Aq2xejokcwXm9w6xZxQeARi+i3wcz8RsN+xAHE+Q6qGXZXBIDYPbJkwUQaWCUueDEBtAQJdTlDg11YV9MYG3c4moQhp+0AYWxRg4d36y7dAqDrDinyn3e9riXCDdewilmjwCDIFH4DLmh+idodp8386VTAce/lxVqN6d1031qMUptqixFHZ6FIb1PceOlAv2yAGxNGW9pWza8f6p8Q0X2iFyOENv8ctdHsZ6PJO9DKM1gfJBMa8Mk8bXseqTS+Gk0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(366004)(39840400004)(136003)(451199015)(8676002)(2616005)(1076003)(186003)(6512007)(86362001)(66946007)(4326008)(54906003)(5660300002)(66476007)(6666004)(107886003)(2906002)(36756003)(6506007)(38100700002)(66556008)(6486002)(44832011)(52116002)(41300700001)(478600001)(8936002)(316002)(110136005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YocRzB0IkP2IKsQDKJ+H1QpQzaqnGHJc+aDKTyHrNwLPkBL2Eu23DHHv0mX0?=
 =?us-ascii?Q?vs1OBHNy6655EaxPk7iJNFIFo/ZLf4/BHwleRqX9V7Yew27BbxgcOrQBVXGD?=
 =?us-ascii?Q?WVbkyGcYd8uhMms9PQm2MYuuo2aSU0OGIhX/jwBZ5zhlv6P941QgExgvEH8x?=
 =?us-ascii?Q?SmqHMr/UXZEgLQeSeUUyGLdiLwKS97lZ6WuKC3OjgKZKl5dMmtBlb0ETTRZv?=
 =?us-ascii?Q?7upVbWFyRvnf743DEQHJaS0t5T+xXBPrUmBF1XerN+xPZ742bo7O3TEGBP3K?=
 =?us-ascii?Q?9SRqAZzoSdgyPPFBaSjhKs6Vo6Xp4g8e2rNgo0OTTnAmYsKZVLjceN4zXl3+?=
 =?us-ascii?Q?V0Oe9drY/zz1ww/NO1FVdWu+THozO/dikh1buHeJa4rH/gmA5H9jBssAileE?=
 =?us-ascii?Q?95YlgIrwJnvNUyv3BxU+x4myrRfPyGrSNjFNT3nqrhF2bnnoOkyePc4bx3Ev?=
 =?us-ascii?Q?Ywf8a61O6FXM3htY3veqUZQsi/DjmJEf2n+dEV22ZYf4Q/O2zjLr5r0MtDLY?=
 =?us-ascii?Q?uZ7gM1G1xP+VVBVhjYsPoDRQdN14RVBiVs5qUpKw5rPEuUm3uAkhPOVCw2KT?=
 =?us-ascii?Q?VGqk1hpC4c5yMdpd3U9ens3gUZCWbns9Y/66x08cP3Mxlc1CTgP3IWVvjEhx?=
 =?us-ascii?Q?muWhlMijmD/SRYd70dbPEQrl+LP4Gr5SV8cRov4m4+39k//TA763hHjvz2Bv?=
 =?us-ascii?Q?dcOeqPUHOK0G52TX7RibNOHaxqx0O+fJV8u6/1MYqVvYerYxlc1ISLO59aS3?=
 =?us-ascii?Q?eh0K+JYikG3f/OTMmMa+claOLFQGax7ydQuOQfe7S8yTjPyEn6NjgoX1knKP?=
 =?us-ascii?Q?DA44wUKEx1EjumXzal2eTyaXOrYg7EZB3YDZkHVZu0vWXEBZLZ+sF5K6w5jz?=
 =?us-ascii?Q?/ypZR3n+5CyWXXDxD8PYRRuXzAsS4ArAja+OucoyhhD5xkfHoDMW1fi+QVwi?=
 =?us-ascii?Q?9jOvbX4FKQAx4877UMQPTb0WsIykCd3UO4UVfK0MaA3LeblyDXVROOAtNAV9?=
 =?us-ascii?Q?hpB8P1+ZvGK7+dgUHlY62NW22Xy+qX4KEUJnNyj7QSoiTjpkJVQCydTscW3o?=
 =?us-ascii?Q?tBTedgkJHQHxZW+RWqaqslDk2r+BA3o0MjMdhqg6b5miRioE9kU+x4UkLnnP?=
 =?us-ascii?Q?e/1/nx8sP0MXGdUNUNJVWqbhu9H3jdWDdDyFHJpk7TtYfvvzwuLXmcnFDd5I?=
 =?us-ascii?Q?OUToI3xGuJF2ekrHpJt8Sms0UAwCUH+7m1nAFGKtEauDpOWnDrZpeozXtMlC?=
 =?us-ascii?Q?qwVs3V4whY2TiaCi+OYXvDgpNgcOaN2SSSl3+8pftA32sDBZ1OMUObd/aXfz?=
 =?us-ascii?Q?8RZn2F+tWhdnwQNIOdUqa84WEfpngqkNWy7PU5PuamdsCn7FRFmUirR2VjHW?=
 =?us-ascii?Q?3cS8Dk3Ucka5wAk4xYsjJaoPQGox9t5qzYx//Xi7V6B4nEuYJLo0cPsXEGhh?=
 =?us-ascii?Q?KXL8YkIi0T8yCuht0nT9tc9OFXLtqVIR24fvXT5Dx/9/SHwGwUlZNULcnP5k?=
 =?us-ascii?Q?Ba17Uybcs3+L2KX5JWvfOphivWRE6Rb9XHi6CVkSFArWpHXHysFCElJfiY1M?=
 =?us-ascii?Q?BQ9IetGGK474nxrjy1JFIIFW3Dqo3iFRpMa9/n82FS6nkEy52ZuvSU6VgAjW?=
 =?us-ascii?Q?wk6Kr1/n1uL11Z4w/1dz96O5lhXM3s3DwnKxDVpwB6porjlVPRfSOsCa5369?=
 =?us-ascii?Q?sXw4yw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2135f95f-1263-42b0-eb57-08daa1f8da18
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 08:59:01.0780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3FgQ8WJRDRYRuZ/cSvFLXjEZsl4Y3QkRYnz4ceT/ZE3YwJkUktkgeWSy+gmRjhqSA/SlceSiJbDETqRAklUFQKWpTNLQ7QUlWw/9WjWX2F0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3854
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fei Qin <fei.qin@corigine.com>

Add support restart of link auto-negotiation.
This may be initiated using:

  # ethtool -r <intf>

Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  | 33 +++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 678cea0fd274..22a5d2419084 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -228,6 +228,37 @@ nfp_net_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 	nfp_get_drvinfo(nn->app, nn->pdev, vnic_version, drvinfo);
 }
 
+static int
+nfp_net_nway_reset(struct net_device *netdev)
+{
+	struct nfp_eth_table_port *eth_port;
+	struct nfp_port *port;
+	int err;
+
+	port = nfp_port_from_netdev(netdev);
+	eth_port = nfp_port_get_eth_port(port);
+	if (!eth_port)
+		return -EOPNOTSUPP;
+
+	if (!netif_running(netdev))
+		return 0;
+
+	err = nfp_eth_set_configured(port->app->cpp, eth_port->index, false);
+	if (err) {
+		netdev_info(netdev, "Link down failed: %d\n", err);
+		return err;
+	}
+
+	err = nfp_eth_set_configured(port->app->cpp, eth_port->index, true);
+	if (err) {
+		netdev_info(netdev, "Link up failed: %d\n", err);
+		return err;
+	}
+
+	netdev_info(netdev, "Link reset succeeded\n");
+	return 0;
+}
+
 static void
 nfp_app_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 {
@@ -1841,6 +1872,7 @@ static const struct ethtool_ops nfp_net_ethtool_ops = {
 				     ETHTOOL_COALESCE_MAX_FRAMES |
 				     ETHTOOL_COALESCE_USE_ADAPTIVE,
 	.get_drvinfo		= nfp_net_get_drvinfo,
+	.nway_reset             = nfp_net_nway_reset,
 	.get_link		= ethtool_op_get_link,
 	.get_ringparam		= nfp_net_get_ringparam,
 	.set_ringparam		= nfp_net_set_ringparam,
@@ -1878,6 +1910,7 @@ static const struct ethtool_ops nfp_net_ethtool_ops = {
 
 const struct ethtool_ops nfp_port_ethtool_ops = {
 	.get_drvinfo		= nfp_app_get_drvinfo,
+	.nway_reset             = nfp_net_nway_reset,
 	.get_link		= ethtool_op_get_link,
 	.get_strings		= nfp_port_get_strings,
 	.get_ethtool_stats	= nfp_port_get_stats,
-- 
2.30.2

