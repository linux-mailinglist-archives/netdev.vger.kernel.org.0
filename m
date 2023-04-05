Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 855F56D87B3
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbjDEUHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233411AbjDEUHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:07:13 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2045.outbound.protection.outlook.com [40.107.20.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E1C4ECD
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 13:07:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BWKVZtgR46T23Jyfpgd2YBGgCmekp/av8Zw0RnNlHfqt5UgBoHYb1N/TLkBxIPwZaESm9dy8u4LU/eNTg7Pm0yem+KVMtSnRXj9hsf9k1RN69c1QHTWkYn2b5+6Q5zgYS8vbaMgQknLvuCJxachl3vdVzed7DtBAz3UlNLzaRzVQMlHHz84n0MRM/sjdX1nzgQpNuB9LfNlQbyFABUUIfCO709byqNuKJf8i4FSyd6VwTLCuxx9r+dUyt3b9yJbt7wueWpmL3/Pu05xpAWAROT7wmFsXv5y8M2vH3dd8cgH2xUJkVGb3jkC3JknIMHM00dNu/Km+wTMYTdpgZJaw+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yxzp/yQ5C7Y/sgJnKi0dIsQXJc1tvIsIl4O0uywER0o=;
 b=ZIhFQvrcoW07WiqWzdymKwIXwjQTZV1Z2myTGIif+SJdBvLVYjHjiQP+QAKZYk4w8SQwasONlFRP3YIZb42FHfuJ3Op4k8s8yztmQ66qG0XptGiNTSwm49P/nVJvyskRmDn7C5DHs8rKZXIp8ku2n1WGsR0iFufiSzjmH3WP7zTOFiDJDRjykssSnepwDDxIo14bTqfLfa1IBxxkYJ92Ni7ZBMhi9PPXkzIcs410pWtCCsVkjes//f/QllP8AGJ8IhZaaOnaJJ8wxd9PEtvSRfZVYzMTLL7BuZfOiga/GpoCmEnmrsT51t++d0XAYepU5zHFGsGVzLk0k60dvxl29w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yxzp/yQ5C7Y/sgJnKi0dIsQXJc1tvIsIl4O0uywER0o=;
 b=e45S5v/PmahbgGjJJ7WEgY2QaC4kGAChARq0Fg2t9SiIeLq2u1PT+cIoymm3cnKO6HVNfF5jDBtlUsNHA5LWOJRB/h1KY7i3fsZ/Be2chVxHlMHglLzd7fCt1nfSdKK9dUIf6FNOdmlaWANut+SWFPNjyfqq5yj6JyB07gIuHh0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM9PR04MB8097.eurprd04.prod.outlook.com (2603:10a6:20b:3e9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.29; Wed, 5 Apr
 2023 20:07:08 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Wed, 5 Apr 2023
 20:07:08 +0000
Date:   Wed, 5 Apr 2023 23:07:05 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH net-next] net: dsa: replace
 NETDEV_PRE_CHANGE_HWTSTAMP notifier with a stub
Message-ID: <20230405200705.565jqcen5wd3zo4a@skbuf>
References: <20230405165115.3744445-1-vladimir.oltean@nxp.com>
 <ZC3Ue5i/zjZkvMGy@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZC3Ue5i/zjZkvMGy@corigine.com>
X-ClientProxiedBy: VI1PR0101CA0080.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::48) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM9PR04MB8097:EE_
X-MS-Office365-Filtering-Correlation-Id: c68dff8e-4373-48d9-c24c-08db361155b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NFXTTIIhp8G07fifiAcrCyYSroPeget9qeI8Ia6T45acTgw+DmjTFNJuJ4RCN4axnHCEM+aK6krlO/UAZHzMMGiWAgBOXRzkDUxfwp9PH/P7+iC0kQb9MFrzp1C1hZCEGkGOM69nEFkX/jIJO/BJkgPReEo5nd3ZiVU2JqcesTg8OKPLN5x8Zo2LJhlTBwzTySPk10Vyj99t/zLJn3iLueqwYnFKxwJC35zc+HYu1qqer8kVRm0BsW6poR2BdqWRzMIZbnfm7ky/C46Z4rOffNHJO90gUbd7vPHaJm/XjgK5HXcUnImCgZLcx0urJ2lopuK9+CwtqQVeSClp0R77jaSYrLmbgyrDrint92l0jNwFzG6LaD6ElEvy1q4aN3ye4J7LO578woS6ZniH+QwU9Aa+Un5yOIKBRLzuerIPMGIVj4fcpagrfYifnOA2UVPrtcB6j+dlkVT2GujpgshEKp8PKCfKAR/NePqCyylIw8VGCpbEI8V2E864Ffjm5va4LyTwtUFsGc31Fz5sN2GycQve5bzdii9CmzFXWr1Wft5j4niJJixuFffTwDBjoxsm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(346002)(396003)(376002)(366004)(136003)(39860400002)(451199021)(6666004)(41300700001)(86362001)(54906003)(186003)(6486002)(4326008)(8676002)(6916009)(478600001)(38100700002)(2906002)(66946007)(66556008)(66476007)(316002)(8936002)(26005)(5660300002)(6512007)(6506007)(9686003)(1076003)(33716001)(558084003)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R011gHbMSqnEGmuMgzKcp6IM/n5qm7uI47VpuDeK+Xt7pzqKsUP0dvlXRs36?=
 =?us-ascii?Q?2hNvy79o1HIFDP6ikrbcjc5Jkeym8p6UiV/3d6UD9ArebJu21JNZ7iaZEjA4?=
 =?us-ascii?Q?fSCbZnGaQqYffRsogCGVAM0cpqDKFPTbAxDJX+PcErLsX/O7aBVKxV4XlEkn?=
 =?us-ascii?Q?cYXuHZNnL0moeZssEILKmQhsmOD5j+RpWirWHxKw11kv796zpAs9LVHSKgY+?=
 =?us-ascii?Q?CbD51ipWT1my7mzFvioFEOFJeLwncNbcxvznXF0Rx5IAqOk72Y0Ph2XZ514y?=
 =?us-ascii?Q?qcJI+mClgD2A+SP0XYJswQo4VlSfF401SLlCrU54WFg1YFz00z6W7LaU/a4m?=
 =?us-ascii?Q?sQRPxH/MRRioRr9ryVRvMKJ2owNiddwfMxnLFhQB6ejcBAgWNW+ULdzoGn0g?=
 =?us-ascii?Q?Jkx5Vq/ztOujrZc1TL+/YDlOlXMOPheXu3r6961mscXniqAPvD6jT4WmzXvY?=
 =?us-ascii?Q?4NPC3wRnZmVUAjhlFjOAJfkGlgB7YGONFpR/HCAP3YKv+zp3alQs4yxHSsui?=
 =?us-ascii?Q?Ax4na5xbOnI3X4RawNeqinwc/PbKYwQUbYLaebKRvOcUrcshhiFZ34wJh+AB?=
 =?us-ascii?Q?/AGR4NALLoEb19CXI8sN6O3RKCGQaTxOWbLU4FmN5PUXjIsYWNCsXVj2pNNk?=
 =?us-ascii?Q?gUAGDkeeRyktNgWPZHJHDh4TdKobd8lyWbTpikRIHWDtiWF6Yn7ptQJr/Qfm?=
 =?us-ascii?Q?gwoDrdSzdskHa0R33WUEfOhUH1hvoA5efzfy9LNkRrsG0zyhIaWY4T699GbL?=
 =?us-ascii?Q?mzGaskwzTAn7dbCX2rpZ/LIRvaux3DfnQUjMjBVzd389ss3KwbbDuVQVNGXx?=
 =?us-ascii?Q?dyWmDAsq6fEalRi8141o5GHGaFTDOIBlr/8NLmNalGIzIxlk8N32C3i9VvnD?=
 =?us-ascii?Q?ylDRQSlHja/YOmP8eAh06JLrJjqg7JSYuqsZyq1VqxvmYGjyA6IZg8d9q4z3?=
 =?us-ascii?Q?Pq4CedC7Uey/fjsTgzKKoRsTxoB+HbIZ3uBdYKehJMjc9JMZoWIiP9uacMOH?=
 =?us-ascii?Q?ppLv0YsKzs6fBWDRKu5MXriOzt7caeYqlN55Sba5Q49v0igzt5AbxGBeA40z?=
 =?us-ascii?Q?J8O6vLCl05ib1MHBasAuf+FkwRShtG7L+TqwzgN0NHflGLon55btKLNZ/5Gu?=
 =?us-ascii?Q?mPDxqmVGhWynk9gpIXW9od23PIlkGV38Ze2iA0Wxip+mDJ0YYcEC7beMkzKp?=
 =?us-ascii?Q?hoTt84uSfC+2fjM+8UWZ/87iDq7sEWdaxurzuUXvQ+8cw5N4qojGLqbrCRob?=
 =?us-ascii?Q?w1ks2MVQbMiHunQalP2+dlSdQzt7M7VbwjO4dckQZGMkzvBNrHsUyA1QByzz?=
 =?us-ascii?Q?xenFyUd2VB6+UryNmYzFx168b4RRcv8RPv/5iIyo6ple54HWG54fepATbWUE?=
 =?us-ascii?Q?CYSw/ftHrE05RGERvpp9X7PpRHEZ9C5OQU4v/Go7sAFTHB6ILs16ZnNEJEpX?=
 =?us-ascii?Q?FC+T88NYjr9U7XOeS/rq4jPGqDqMyPVNNy3tFmhYhngLYVe705lxzXaFxD8G?=
 =?us-ascii?Q?sANiE93OfrWcO9mnkB//08f7w/YWUlfXZz9kHkeYsA+QLMXJ+t7wyc1/IBkg?=
 =?us-ascii?Q?tCTOnzvRa+cHf/X8rsSvUGXB65zbEsSWKt2roxMuYy23x107y5qf9mrx9pWn?=
 =?us-ascii?Q?aw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c68dff8e-4373-48d9-c24c-08db361155b2
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 20:07:08.4790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z2Q3GxUqprjcNCgn1rB/2aJwnYrogQQSNyZMiLzNwGG1rNCs/RM15Tshfh4GVMQqCMhvSpRJF6AdB9h/WYJ27w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8097
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 10:05:15PM +0200, Simon Horman wrote:
> nit: clang-16 tells me that err is uninitialised here if dsa_stubs is false.
> nit: clang-16 tell me that extack is now unused in this function.

Thanks, all good points. Thank clang-16 on my behalf!
