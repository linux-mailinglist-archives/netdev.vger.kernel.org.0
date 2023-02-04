Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C14768AB71
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 18:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbjBDRGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 12:06:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjBDRGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 12:06:15 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2074.outbound.protection.outlook.com [40.107.8.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9C8305D4
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 09:06:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SEPAKLq5YZwtQ6RSbKk+LUmjWd+02NJ8Zw5AuqIRpqqvlvYPmi3DQ8FLu1hReID5orGGL7sYOV3j6xfa2sh7C0oPChhjbjkbtNrjYGbqLdEtpYyRE0RX5drUSI+X74fW2HDf2lOoWQHZPniC6gGPY5jCTBsaAeR2S6moMzmzq7YjzDqHYNspx4pgaNmu93Iu8j9CkfX7c5rLMyp7o9C8ROC0ZGYczxfY6oznaJye1mNYF3NQ+t7GB4jPQLLfbBUJoM3rx6g4NgWbLto/WQ9ewDKcbxzwvAASr9Phd9OjfHNXUTybqs4+zGhpJfiAAO19aULATx/8tr2DsW5/oybbEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ALggdWLCKVgWjSLdZ6lki1Vda1+i4grrsKFEAr3qe6k=;
 b=lTFPUkgZqgC2rMscQISj5+APXvw619jPzotP+0MhaMrWnzTpP0t52XDQALwWuUFYJpKXosAgknBAJsYaEPrRhDom97cBmve+ifn6wOGkoqLFOVysznyXrOAp4/Uruz6IaT50Hlmo2hrX3PcATRAY3PHtUB3+OGs2w0kdKXeiRN37dc2eZIo73v9xlMuxp4D+lXNLkAug0JDKozyjJ5TaStdxaiC/sUe+VVR5FLcHD/55b/NEPXhXi0d5YyioPkHXiGGwsC98z794gjEHzx+uTipr9z40Vy2ZSxG5M7pir4DK0tVHyPJagL6uxHaA5rtOow9Or+pXkdb7ikwfY81u1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ALggdWLCKVgWjSLdZ6lki1Vda1+i4grrsKFEAr3qe6k=;
 b=JCuRLaVZFep+tR3Fbc1xtkFOq7occVjeza/rg/QkCJOgDyqgaUn83vucDr4Iy7kArVtnQhmjZrz2a9BW71wpcLyGM2ZEn2s7K7So9AAA1Hh5JueLfCY9GlEOIY2kaUG69/RxyuZcEc5dAfYEj0VpBfGkYzRRWUBrIMYoxDT9Amk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8211.eurprd04.prod.outlook.com (2603:10a6:20b:3ea::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sat, 4 Feb
 2023 17:06:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 17:06:11 +0000
Date:   Sat, 4 Feb 2023 19:06:07 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: Re: [PATCH net-next 2/2] net: enetc: add support for MAC Merge
 statistics counters
Message-ID: <20230204170607.ldh7l5pnntz3cxc3@skbuf>
References: <20230204145350.1186825-1-vladimir.oltean@nxp.com>
 <20230204145350.1186825-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230204145350.1186825-2-vladimir.oltean@nxp.com>
X-ClientProxiedBy: BE1P281CA0130.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8211:EE_
X-MS-Office365-Filtering-Correlation-Id: 8275e29e-9cf3-4156-97d9-08db06d21d55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4dtGfaTvoPaLZ70PVoheBUHVTrlFkf/hzHCwPAoSHmppJ5OIUtOTIEcZ1+6uvw0Ev/7gJK2QdU7beU0rhzo2w1BoL9mklmeiNRNFvC+E/ptRf9w/k79S9lnCCSd1fkSIP0zmBzopJe6rjru8U5D4TTBIwRt6PCeq45u8+jZ6Xlp0T7N1V+fRfzLpEBCyO2eunUC1EgubTlb2Cm3eGfVWESzpSUjaUhik6HNDHl7vZ0K/pgUnQrCTClmNYnVn0NlwJiPXBrKB5U2vPWPzbT9ZWfT15BdBsjZUdlzhjIPZcKKmDHGk39B/NKCWs6ITomTog1De6rrT/gLmfaT2hx3kXY6ZLVNCNEd3W93BAcLr0gR58rk+Mkjxld2fDjh/FgmYYLfuXiehE93r5NzXMc3Q1lAqrRv0FNP9JlWb/qNDcg0HYNEn7R5ZLeweHQ1dsYsbk2vA/LaFXNj3fC/1YDnPDuXvw+sGWQFAnSByzLlXgYY0Uo6aS7nV2zuwscbCRrMyTKIVW2n6DP9o3m5sqfO3fZpp43lulgD465Tu8O5+XCrU7iY8rEp/0LauHRTO46GUGm367lfyA8OA/Du9qgIjLRHnOGPQu53UdV6FOVcgMN45YJ77MdbT8VlL85bg3V0eWXvlKfysIxPSGO8xias/Rw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(396003)(366004)(346002)(39860400002)(136003)(376002)(451199018)(478600001)(6486002)(8936002)(38100700002)(26005)(1076003)(6506007)(41300700001)(186003)(9686003)(33716001)(6512007)(54906003)(66476007)(316002)(8676002)(66946007)(66556008)(4326008)(6916009)(86362001)(44832011)(6666004)(2906002)(5660300002)(66899018)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nQDXl2UpO3ut0O1+cwB+mX6QQsSJGsTUKbCkuwVt8zX6jPKXHYfufJ8Do78/?=
 =?us-ascii?Q?icCYrQ3TxPd1xwhslZP0moJFbnqWd3pfhU8EGFSTeICTxK9kJOgs7MN96daD?=
 =?us-ascii?Q?0LzGdLwJ+/WibWzQKQxF3Xv87rvJVw0+gsmSLX8Z5+sPFq3C4TtN+FoFWoUS?=
 =?us-ascii?Q?r/iL65xioAsVn/ssTODPgUvYCpAgN9zLRUvI7AFSd2WT1XYGi+aPVFWLtkbx?=
 =?us-ascii?Q?CUSLTXmsJTZnVa1GUkZCktufVBab5WjeUB/21kgNnXA00Et8d9s3KMbQgqU6?=
 =?us-ascii?Q?xx+D/LeZifKRrX7RZeDIufJly6wLR8QCtDDbxlWXItUqiuqLs9nvUsV10v8H?=
 =?us-ascii?Q?Yw6KhzNEcAI56v1Cd0N7zWrADPg8EDZUv8bmV42e5oyCcyR6bxC97sthwmCr?=
 =?us-ascii?Q?TY/rnDIf5NnDsPzCcW+TWPq9XMT7YR3ytHyrpm0BMUDY+4w+/m35/aKBQYwh?=
 =?us-ascii?Q?4dNs9oxr1EJKYQCQ/hJy3lQw9ip69mrOatPYZUcoqn9scE/4DQL8BqAgoMqk?=
 =?us-ascii?Q?6Bboukx1uUtNoFNqIAy6LcmT+4RdZ89NHTnQf4DKo0qYbXXNK8e26sU7So83?=
 =?us-ascii?Q?cYCGiyXrp8mCRYG+2QPebaGsxfnvbnDKoVMU0AIL9nUTImixU8TCaDHkpoev?=
 =?us-ascii?Q?gIzlKtcI6dmPFbMbyR1QO5pRs/50DH2cGPc1hQiuYlydztDpmhaeY0rR5U9K?=
 =?us-ascii?Q?WyD3919IgquJCOglDP6qKOCmPinTuOLXNKfzK0K/XRjNcsObgoMJa6e9oKMQ?=
 =?us-ascii?Q?hOXHPDqumS9HW60RrWCuySB8YLS7TrUVZcbXSKy4/dfVEC1TaX4nVE8/QJvJ?=
 =?us-ascii?Q?L5BHeQXPi7dA7bWExkJbDILiHDVAE1Pq2LMLh2RT8gGOnwpLTAEiJEop63cf?=
 =?us-ascii?Q?otd0sbl3EzzDp75kRyxBhBTxdKwDTTH/LqOuSKL+d+OvEdRcMXZBlK0gDFMX?=
 =?us-ascii?Q?PwYs4v0a4YAQx/yXPqsSnQ1Qxk5NRW6Z/opIDKcryQaHVuVamJDpQDWJDI/k?=
 =?us-ascii?Q?lDDIJuC4C6W4yTcoOnaLd75OomE2MT7aJby2KoSclk9DZnUBOFLsdDXnNRUT?=
 =?us-ascii?Q?J96WYMrkM1PYRzgIlDzToF0J/dJVr4KtR04X0EGGs0q3N0/Kn1dgTTIVFyHy?=
 =?us-ascii?Q?QdCiYDIzBi5QCXsydvBPZqvNg8MAuakeeaGcxU1TNP6UmRS6AIz4CVERAO9S?=
 =?us-ascii?Q?Iyi0v0UadwZUFXQE85qykMKEEWF6amY8gAkMyV1TM/Ay9AwZH6CPV4RMEDGY?=
 =?us-ascii?Q?G2I5UeWOsLJF/NWEDZoL3rUdB+xWay9x+qFxjd88oYTb3Z4U6U1oxDsKevRl?=
 =?us-ascii?Q?wRtsuNkdNtJpJykk8XSJrHtofiPeSyCB+4w0/mV395NvyWZJFyVvPlmkEwYL?=
 =?us-ascii?Q?yL+3Gju6ijR/MblEyjzWkC4CPfF1Kw8u6kry9px60hxUbUqNkmE/4ASayGpH?=
 =?us-ascii?Q?1o7xnY2upz93fPNrnMHsf/oL3ZkCocn+6NQIQpBft/t2kJp059kIJi4KbtHz?=
 =?us-ascii?Q?V34ru0xBLqVygmPADu3r4PojMoxjjPkOuzDpK6i9TJYa83fQUGXSRtgg1qge?=
 =?us-ascii?Q?0Nr7vigDAgJncA07PCevxY2ihntvKvixiynKYP3UOpvf0hV5+qa28qYclNM+?=
 =?us-ascii?Q?iA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8275e29e-9cf3-4156-97d9-08db06d21d55
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 17:06:10.9823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kCf2TTsJkBxLopNd6k9r7xMF5uogPK+3i/4xPlm3PvtRxB/3UcHsVZtv/K7zozoJCZ52sXw+h0kZZL2qmWkCxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8211
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 04, 2023 at 04:53:50PM +0200, Vladimir Oltean wrote:
> Add PF driver support for the following:
> 
> - Viewing the standardized MAC Merge layer counters.
> 
> - Viewing the standardized Ethernet MAC and RMON counters associated
>   with the pMAC.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

I'm an absolute dumbass, I ran git format-patch without including this
uncommitted bit into the patch.

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 631451d8f47c..4eb029364509 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
 /* Copyright 2017-2019 NXP */

+#include <linux/ethtool_netlink.h>
 #include <linux/net_tstamp.h>
 #include <linux/module.h>
 #include "enetc.h"

I'll resend on Monday. Other comments still welcome by then, of course.
