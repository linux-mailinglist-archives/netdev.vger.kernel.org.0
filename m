Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8280D68C22A
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 16:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbjBFPtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 10:49:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbjBFPtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 10:49:10 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2128.outbound.protection.outlook.com [40.107.94.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671327EE9
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 07:48:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hGq3gMkG7UKNONyke16eYHC6sg1RfsOEw4XUHIZBnoNeesAt54O8FoZ+nWE1Pb/uU7GRXvryH+ygKGusjNUXwkp2URuR99rhZaUlL+BUoTfV8U2zyclEnmY/sVE1PkoaHg3HnYsCE6pCh6QJC2QFv2KZPRbjasbJvfYOR5aSPoA/Q/WlM0zgCiWY3/6gUvSdEJ9OePTmAAhEDvtdKKtUshd2DBHNRG1KO0pdKFHEpp2uLItiDmjKdr1B+iZ7kQBWMnfLlHhklyhOj26hNfZFXzLWGDYVX010YhQPS6EpaIxFX4JkqNMvfh7bQdfe1iFLrEv/iF4ZewuLX8cM9Rn2Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sayhz05HCueU1JTdDI7m9P8J3Zi5jDktDK5SEsMH18Q=;
 b=nAGTFNfrw6yKSg8xPXDOXyPVDVrxR2HLqqpGMzKRFL0NhaMuOnXSx7D3JsKcbbnsIeZW7mqgTTveY5aoB7mYTW0FXkXQA5BrTQwwr9UuDMp5t7tv9O+ylBzxtPALxMLu+j/j+Y8CdL8PpJg2fXOkBp+emRl6C3JZYjwyUn/NKDY/Aa5w5muh5ZwLu55JQuxfyXB3b4KVeiUDqus4ovNASwQLcPQcimYmRcGflpQHwSdS7cUwHUZtcgg2PSdhuvi+gL1HpopcewHPXby26K/0mxBlq5Thd4tU1QpmNd4uLl3Dr8HToxfV31lBObsKa2SSUDdINZrRV6k8DDtjJ6L0aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sayhz05HCueU1JTdDI7m9P8J3Zi5jDktDK5SEsMH18Q=;
 b=YiaBhhjCIpx4jyUCbMuVE3H5a7oIbwW2Z56zMSj9t9465fOnhaBui9WdANGjJ1KlyK2Lgpg+77errh0P5R1U/wBrbelBtypI+4TGeSNygrcCfLjPuVrKcBg8XYZwPxhKbn/pezuq3raAZRoK3z2m2tDreWQmSEj3MnuFGmRiGbs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5240.namprd13.prod.outlook.com (2603:10b6:8:7::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.32; Mon, 6 Feb 2023 15:48:53 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 15:48:53 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        James Hershaw <james.hershaw@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next] nfp: flower: add check for flower VF netdevs for get/set_eeprom
Date:   Mon,  6 Feb 2023 16:48:36 +0100
Message-Id: <20230206154836.2803995-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P190CA0009.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5240:EE_
X-MS-Office365-Filtering-Correlation-Id: 29ebe829-0c96-4546-c160-08db0859a603
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FZZL8umlDE+wjoHO5axZZypHmkH/bkmwHgM8257Ttx6OZA+mizt1Cup9oW3XwpZoElHMfx2ntLGnCGNKLrUd0QUb9c8rE5wgoegTj/N3cvuADgnmOEtfwBg4rdzujfLg4jJDHnbXgPVAsnNv5bycx3p+ZzO6lFc5k2Y0wZi1Zugj8UTOy+XUMr2ebfai3MV0ZN6hEUsXzHiezrAQfNUl/z2pFDCSGwUPi4d9fJa/9Sa+YNgJv2QKelbP8B/qasgRgD29N1BvF1Xg+nGwYmZBUzj6ps1dHdkoW6j2tFFOOWwu/E1sr/Sm5AG6JJTcKBvgPBVnfCMKYrzkTuW4sLl+QzsDpDj8+qcbMugDgzYMMGywCNQZClrXWNCu0HDo9nDBWfTMhqThVKcw7drUOjJsvFh354xoOmH1lBUQfAH16Y+scejguSExqC0HH780n5cvaogdJOwGtTZTNipxUN6ZHygpOFZD4smKjag5m49iFgzKvAYS4vZOikW1qfFf3KTswi9m8mQFjHb2ivdUQxtgAtfTJdRaaoKBHYNj+JVJWPir2gPve3GCZjmLcwOjsc+PSOQCrD907A+eW6iapgqoaBxUIqZvthBnFmnhB0VZWs5SEwZl8eXOjoYDji9070II7FeIyn7NDgydvM4g0k8wccCek4y+pggsTSku7p+VMlVJX+AaXtLhdrQgdmZj2Rgj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(39840400004)(396003)(366004)(346002)(451199018)(54906003)(52116002)(110136005)(4326008)(66476007)(316002)(66556008)(66946007)(36756003)(38100700002)(86362001)(6512007)(186003)(2616005)(8676002)(478600001)(44832011)(2906002)(83380400001)(41300700001)(5660300002)(8936002)(1076003)(6506007)(107886003)(6666004)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7xWU0xBAs1QOSmHDwYp+YtSF3wh95Uh69e9i5WvP2v6qFPBkcyGRNNfAGY6A?=
 =?us-ascii?Q?S/nWheYS9IZDJjKn21pMTq19UJ/3GI7xKGnyDZ1SM4o/zH5Vb/TqbmY0MJ0D?=
 =?us-ascii?Q?VvjnkPkpTikqUavQYrf8LSpMCdtsXJ4vidzDjqY+b2a0OvH2chDMT0pJRCLc?=
 =?us-ascii?Q?UInmXUDk7o9DSQ1vm+xfiIx8FbflGGm1QEGj9i4mVRWv2rI9OLePpySS+t7l?=
 =?us-ascii?Q?gdX6QBS7TAWr84TLAn+/3d0f1cgkel+R0t+cMNkdA06jn4VBpua6U0KHhm/P?=
 =?us-ascii?Q?JfF8sDDIMDcjT4yYcW7AffaI4D+AsCe3AzEUIOZE/2WalBUxXtUzbWOFpPXb?=
 =?us-ascii?Q?y8IPeGUx405SuPxLmV66pzl1i7yckK95pVJKID1bPJWl84qQB+F1M9sOc4AL?=
 =?us-ascii?Q?YvS2KA7BTnDqAURa0nwjxZWQ8BwSYRSZJMtNT2xNEyImP8IC5mrU4D32eEiW?=
 =?us-ascii?Q?ZRqu0YnRK1aQ004qymEt5u5wR7afffDDJNdhuU89Uq6sitn6mT5XPxdrkkU7?=
 =?us-ascii?Q?O9bOrgQgeD1SOc2qdRk09ElqvAfWb1A4M4S1ELgdOfZQ3oCaMqchplCaf9NE?=
 =?us-ascii?Q?dlv8yMHjvf047vMLY/rmiBjLabqEipX6vU0Z/dZ6eVSNo/vuxuCA45U3d6+J?=
 =?us-ascii?Q?4tk90q3Zb+YuCGqn2vYYTFoOOkzYrBgXcZK61plUF0GD3d3HyhG/27duuA7L?=
 =?us-ascii?Q?Cxag5Cbom0afajZajy6sOYBRWkR6Fqgw3zwJq/VuwWkAxOuLs7XxEfrBTM88?=
 =?us-ascii?Q?mSMTBfbAtCPvXiQ3fHHvmOh09fykfbtikb9TKb0ZMjlWKyCMonxzfMk1rpK9?=
 =?us-ascii?Q?b/cT9Ch6hANftb+s9/evVlnSCIYACBacLZb9PYvXya1aFz8i+eDnZ5BPB1DV?=
 =?us-ascii?Q?hUbxzHOhIJT+mFfBnDelVs3mraK97dPJReBedDn7WCoOG66wbD+zhJ3Lviqo?=
 =?us-ascii?Q?F1qSd9oyPnnliB/Kia6R3VdZ+f5a8tbWsJcyxkPyGVRWeP2PJQXl1OmirSvt?=
 =?us-ascii?Q?7ynG0Ic2LJEktcaKni4MUf0lHkEnrloi+l2OOjxYIf0GIJHaoZ+zIhJ4O33v?=
 =?us-ascii?Q?23diuypTX0/eDny66CT56gthLw0I59VgPxQ8Qqq1k5W8bSmDAFzmXPCdT6wn?=
 =?us-ascii?Q?z5y8dklrZHyDQ/1mcB6gJdGwe0YPp/cMhzEID38SMWGW+U7idfmmwIOzUruX?=
 =?us-ascii?Q?5G6zR1OM0hBaj6ZAyumDsw8cr2dBAgrz8gwlm9Oa/Fr8Vhb3kvYkoDyj2yqi?=
 =?us-ascii?Q?+BOD+1Xq+RRGGamaS+RvoLP3FTa+Whbpne6Q/hkQcTfGhYbu/N4fPfG0f8CI?=
 =?us-ascii?Q?il/qaEqxu/UtRer4bb08qrnlSy9E3xWnTai7QFDrc1d+ruMIXZPCsgz8xSkV?=
 =?us-ascii?Q?Ku9LlqjoeytyTZOUCL8dyYQgPpYNgXj0CnXtBE2BHDdyrtJqwjI+8gr8eCxd?=
 =?us-ascii?Q?9O5g9/bMpM3GRsgUMLCrTgXT8AwjIj3f2YSbe+2ci/lMTW9MAgdYzz7OioHD?=
 =?us-ascii?Q?+2qIHz3m+/cW1a1H55cQWPA9STFr81FMFH6sk1HP8o70Sxk+YSnlMGEtVLe1?=
 =?us-ascii?Q?qrFctGJoccPsMB3UbyuzpMczdBsvi+77KIq7SbSb/xLWeOHLf+RgPz3c1sVt?=
 =?us-ascii?Q?R2UD4lbmeXpoOKJC0yg7yduaQHyq9vsoNYzVQDLvafXKPH5lnVTBxYzffhj7?=
 =?us-ascii?Q?LDlvsQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29ebe829-0c96-4546-c160-08db0859a603
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 15:48:53.5944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dnZ8GK3A6KiQGLyCTnY7Av4YSMD8jYRib8Vs+KFIDCVM7tyP3IvkwYFwskPFawEDZlHFGvig1rqbzo+iO07NH7Ia7etp4dMVy7/1522/hLE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5240
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: James Hershaw <james.hershaw@corigine.com>

Move the nfp_net_get_port_mac_by_hwinfo() check to ahead in the
get/set_eeprom() functions to in order to check for a VF netdev, which
this function does not support.

It is debatable if this is a fix or an enhancement, and we have chosen
to go for the latter. It does address a problem introduced by
commit 74b4f1739d4e ("nfp: flower: change get/set_eeprom logic and enable for flower reps").
However, the ethtool->len == 0 check avoids the problem manifesting as a
run-time bug (NULL pointer dereference of app).

Signed-off-by: James Hershaw <james.hershaw@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index e9d228d7a95d..807b86667bca 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1908,12 +1908,12 @@ nfp_net_get_eeprom(struct net_device *netdev,
 	struct nfp_app *app = nfp_app_from_netdev(netdev);
 	u8 buf[NFP_EEPROM_LEN] = {};
 
-	if (eeprom->len == 0)
-		return -EINVAL;
-
 	if (nfp_net_get_port_mac_by_hwinfo(netdev, buf))
 		return -EOPNOTSUPP;
 
+	if (eeprom->len == 0)
+		return -EINVAL;
+
 	eeprom->magic = app->pdev->vendor | (app->pdev->device << 16);
 	memcpy(bytes, buf + eeprom->offset, eeprom->len);
 
@@ -1927,15 +1927,15 @@ nfp_net_set_eeprom(struct net_device *netdev,
 	struct nfp_app *app = nfp_app_from_netdev(netdev);
 	u8 buf[NFP_EEPROM_LEN] = {};
 
+	if (nfp_net_get_port_mac_by_hwinfo(netdev, buf))
+		return -EOPNOTSUPP;
+
 	if (eeprom->len == 0)
 		return -EINVAL;
 
 	if (eeprom->magic != (app->pdev->vendor | app->pdev->device << 16))
 		return -EINVAL;
 
-	if (nfp_net_get_port_mac_by_hwinfo(netdev, buf))
-		return -EOPNOTSUPP;
-
 	memcpy(buf + eeprom->offset, bytes, eeprom->len);
 	if (nfp_net_set_port_mac_by_hwinfo(netdev, buf))
 		return -EOPNOTSUPP;
-- 
2.30.2

