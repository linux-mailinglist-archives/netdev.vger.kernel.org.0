Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E30F6B7B4B
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 15:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbjCMO6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 10:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbjCMO6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 10:58:22 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A77B746D3
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 07:57:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T57vpgG95IVcoMfkXNJQ1+5adIGP9P+Cr0QhT7/21Ayi55iHj5IuIMLYGMk4HNwYBZCX2FHwyzrttS+LSsYJy1YX7JDEFzcwEgm69jgLTvXNfXLyQqWIOfdLuLfe94NqOBBPRi4PRlfVXCiTmeyTBauMDXH1n5yMwMGQfWo/ro4qffeELVfDallcbfpGCTOBIux6eRh8C0vjnxywM+sfM+DSbi3rXSXeVFNwPUoBM8hpMaGlCl3PyotiP8miT+aYY/+RrsLHQoeniSHw6B1HKK7ETciSY/Atu66Tq3yBsyaP7iYvQZ7Qwl8G9C57MYNhAnpHCrqqvitcu2I0fIky+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DWAS9sy8p3oKjwtrl1G1L1zE48uknaQb+yom1/wew44=;
 b=CJyQ+WLAxo9EaHqvG1s8ZyQw5m4ga+XsVIjtw4V9SkwkRjSgQNPObvU8q4c9mCAMIgY0wHOs8ArDJxvTBSTvyr2Jy0jXTLUSCTed5R0sdY2LpC6YYfOGky6Y/CO4tKJYn9z/5H2QzMSrCY+nJSMWBe6gCZ/p46qfO/H89PI41f284efgm65lxO5/ZMVvHT47vi+kfUqZMq9HF2i1l7fhuyLDn4DA4ToAXmz2iDeWiuzY/snjmawr7uFYsBXt6wzh16mmMx89HvH76r4Exjy+5Yn703TJhclENX4OFuM4iHh0FnknerHBnHj17RfEVcO/Tjti78jTuT3zsThvky/16g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DWAS9sy8p3oKjwtrl1G1L1zE48uknaQb+yom1/wew44=;
 b=tESM1fl40aWYg5lW21Yxu4pAqGKKvoFsxVLmx4J2wzkvDNek2E8uY29L98HHTEAiYpg4lbiQ4TXk9fLPasOTcy38Kx5enWk9i98KgoKjnAE+GlVPyNDYWSxrShdqShYde+UA9vCxsiPkd5h4WyQm1DuTSGUhpILLhEJG5eKRtd6cJmJKLnO1SE9c1Z2KJ5LzV10tvI5FfFk+yEH1pMV52xt3mjz7xZ/id3ZRN6fBuYqQBOnzku0R+BH0NRxScEtjSWR3MpD7Ow/VIacbAv+euuH9dUmsAx5Sa2pFwOSd/Xjcwfd+NQpGbCwZdgNCUXWsQEMmzD8QW+kvHEJNhaqShA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by IA1PR12MB7493.namprd12.prod.outlook.com (2603:10b6:208:41b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 14:56:17 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%6]) with mapi id 15.20.6178.022; Mon, 13 Mar 2023
 14:56:17 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 10/11] vxlan: Enable MDB support
Date:   Mon, 13 Mar 2023 16:53:48 +0200
Message-Id: <20230313145349.3557231-11-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230313145349.3557231-1-idosch@nvidia.com>
References: <20230313145349.3557231-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0041.eurprd03.prod.outlook.com
 (2603:10a6:803:118::30) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|IA1PR12MB7493:EE_
X-MS-Office365-Filtering-Correlation-Id: be41d2e1-7949-4a34-777c-08db23d3197d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uFdp6L22enTruKLYYwB5mQ+HI1Au/EPkGrrHABi9CbOl36fxSqKSjb/5qmDH23RCArv5nwlbUOh1NM7+TBWOdgBlXHdNk8z08f9sTfOA2CyBwNwsOh+aerHD5OjXvX5v6AyNeAvGOpGTs5eWNsAJmk2Lp8hEYu2t1jlyOoBuVpUMo2GVoMXTPZKgyTC/IUSF80w6OFIAS8GqoaC4Vh/tnFb/zgFwWhFcr3iO+WRekBnfDFJFg324BRdpZfrGjq4o/HrwAM3ITmUBx4y4DXzk2Ey+nQOXU1o8xg1nJgya9UndITnDoCc8SXw2/gTsd3CwdnYDCqvlWGAXl2cKMzaWIEjerqF9BjdK6BkcVI0ozbmM3DyW9Q50b3yvUTCCEUroKrK+Xjgsu6vA4A29FW84zkupZ7V+2+yNPocWRRZxlsrGO+ZXn4S4VJVXSJblBfR2dz7pnHvFxQbwBtLOpKdRruXs6wvgk8CCLap/Etv9BvZAxLjDiycwvvgK86ErUuZFCLop0bRSRj25Y5bW0ZS5Sver6VYrMNteiT1fLYb8Q3GM8ZVbP1TFVCcFGc5eO+4I2pd1eruG9U8+uzxlHui0trDt3M0rt3D8HMKtoQ8nM6Lwkn+uOY5KrJyE4CgZSDWzDCydA6UjWvleR7Mp0054/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(396003)(39860400002)(346002)(136003)(451199018)(2906002)(41300700001)(83380400001)(36756003)(4744005)(5660300002)(66946007)(8676002)(8936002)(66556008)(4326008)(66476007)(38100700002)(316002)(86362001)(478600001)(186003)(2616005)(26005)(6506007)(6666004)(107886003)(6512007)(1076003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D3+jV3HetRYQr3XKclzsgcji4BGJ4/yAlEAdl9iD2zIf2JBMmqH5yudZoh9u?=
 =?us-ascii?Q?1tKzM3cfvN2C8kT2mtql/gboWniWhAur1Z8co08WBWa4Ww9/KpGEvScpvO0M?=
 =?us-ascii?Q?QRfyjL4KjbCp8z+raJr1Jxx6PLPlfBu8ws41vLExFgfp/kO5HMLEqO0TyD1e?=
 =?us-ascii?Q?yci9QKy3BRMUdMUH0mGti3hJRwIRkphvTW9rKlP82shNt9ygruXTibd8VUE4?=
 =?us-ascii?Q?fIjYK5HXbtYzUpFOcV2IOXTYdT77O1fN4YW5QjWzim8rPUSdGGeaqV5BBknV?=
 =?us-ascii?Q?S/J4ASei2Bu7qKGz+NPCKdJm5DsbLJJELMuVbz/IEe0jwZE6MgP16CbaBmhY?=
 =?us-ascii?Q?ONu1ePp3I1uQNcrZFmdYvssuzccxxs2FN5n0I3Tt1gZq88YQvqx2/he3V8+5?=
 =?us-ascii?Q?BwnuRpH+BJ1BMyEPbUwgvnmVp7kaGJfW/zlhT+A5wMKl3N7zaLxXkAIZ+6HD?=
 =?us-ascii?Q?W7NSXT2s/3QY13GjS29R3UBGi7+pN1szs62SSeayZOLBtLR3Tlw3pGiZy28W?=
 =?us-ascii?Q?OcfzoenyMfqCNVDLyQp34u1k1/EEoKDyMmssVEtfs+9RaUUQxGu9aQ6ZL48L?=
 =?us-ascii?Q?PaW+lpWE+b2Ck/skrj3n2Zl+KxIIhMrkp0520plWmRS9mrFXh7J6nRck7d9O?=
 =?us-ascii?Q?IM5qUyUjt21Nuz394AdMwpc5jPwqT6zo9jOY9lEVpOnbkV+y+vR/tLtg8+mN?=
 =?us-ascii?Q?8TJ+5KXIMK+XlLoKRMY8qcAd2vHFIfZ1IdduRtGff/Kr/kzQ7Ta6FJddcJo3?=
 =?us-ascii?Q?pKPuo6qjyFKOP//syz7X/U5PVynh6SyuTkLYiQc1zHwN9oGPi9bBxaFAGqqU?=
 =?us-ascii?Q?aU/Xkaon7j1LiENx5QIXtDl01EBnMcSrEXk++SlogPY3OWN8rvOvzJNkgoCo?=
 =?us-ascii?Q?P0gfqLllNpwAWCDbBnxIrk2+uSHvH3eWCB3iFHR3mLIkknC7ApyHw9AEHgp4?=
 =?us-ascii?Q?daqCvKGc+doxpl/lCZcUpcAqMFtQSNGf7wKJdcJXM7Cz1LuKFsQUsY7mLIkB?=
 =?us-ascii?Q?k5wUL7yDXU9MFvhHF8tIq189bLX/l615CcBrDXeTGlbMK9lT+3LO/dQmFsaU?=
 =?us-ascii?Q?6E1GaKf2rvlz6XEIwE8B16V31U/dnITwj2dWZKQtpstRMZshEz0QYvbvfkfa?=
 =?us-ascii?Q?89FMZJNCNopQZVboUAkOiwZy0eb6uIZaZdgQ80dTEtfp7umu/Hz8PZrpSNab?=
 =?us-ascii?Q?TsRZysK2QwWaGfSAvg1b7eP6nCQx2G9jLAwD2qvW8JVoOB18y/RUV50HqVfE?=
 =?us-ascii?Q?sej1pcTJLsp9J7C9xW9+20i0XjjneLnIeT2rj8E8POIkwao9YzY+nFRS845y?=
 =?us-ascii?Q?zfE7xnzv5sxzfpeiw9Ky2frEAXAOq1ifhiR8Rd5Oz4erTbNcSiohj7DRzoVz?=
 =?us-ascii?Q?3OueJqF7xbomcjCDVxRIbUAHa3nDMDWnsYlMCNK2U+s2K/xTSYtIvMf9vFa6?=
 =?us-ascii?Q?zFlDD1C3WMELRBHHP/OyuWuMP31Ose+0Ki8IFuYOvgQ7rud+RVe2lSsmAZUu?=
 =?us-ascii?Q?5k7c8hMkcOXLf56E9+z3kWI/I4vCOlnhAULIr/e/RzAtwaqV4aLAhv106+8y?=
 =?us-ascii?Q?UZvVopvGva6a/4rWSa2sMqQz95OfWBizhKcJnd+q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be41d2e1-7949-4a34-777c-08db23d3197d
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 14:56:17.7357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: viCM9hzRRTIHO8R62xXP+cdj8Hdr/8GQ6FECqIkhAnKXvzGUSbmrYfKBUszKSEwy9HejV2P/bPD8WWLmahybaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7493
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the VXLAN MDB control and data paths are in place we can expose
the VXLAN MDB functionality to user space.

Set the VXLAN MDB net device operations to the appropriate functions,
thereby allowing the rtnetlink code to reach the VXLAN driver.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/vxlan/vxlan_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 1e55c5582e67..e473200b731f 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -3083,6 +3083,9 @@ static const struct net_device_ops vxlan_netdev_ether_ops = {
 	.ndo_fdb_del		= vxlan_fdb_delete,
 	.ndo_fdb_dump		= vxlan_fdb_dump,
 	.ndo_fdb_get		= vxlan_fdb_get,
+	.ndo_mdb_add		= vxlan_mdb_add,
+	.ndo_mdb_del		= vxlan_mdb_del,
+	.ndo_mdb_dump		= vxlan_mdb_dump,
 	.ndo_fill_metadata_dst	= vxlan_fill_metadata_dst,
 };
 
-- 
2.37.3

