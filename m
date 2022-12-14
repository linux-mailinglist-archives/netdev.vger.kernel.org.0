Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695C364C8D6
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 13:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238400AbiLNMUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 07:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238401AbiLNMU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 07:20:28 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2072.outbound.protection.outlook.com [40.107.247.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FA728E30;
        Wed, 14 Dec 2022 04:17:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RyziyK8imaTz1DU0QDyFPpRIVOuQj2Ckfv3WcFkGXI4DiZlUQixGqEmE7XRtOJHKIN1rC0BGahdB6xAnBDuydYXR+THl0FtLt4gjAbHpdI9s5BPIHp8S+OBqI/Mbo+EjUZOZHvYqlPUdvoNCOc3k2JgrzStGWi07YmdZ8F1XJUdz4X8P85AXWPaIuhSLtiTMxJtWAC6kKKta76FCg2/CyId37cM2Jp1sQy8yec6tUrBaFXtQLaUhTLe2pltLwWkKnki4iWGveuAmaZ/Nj4yuTyxadNEf+jPf+R4d51/zA4PI0WIntVKE/yWLKHOr3gfJ/LLLbX25x0XyHxWirIpuWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E/XR3Tg2GZGgZxf1ZewJg1epjCclLeTmNBreMjSYfYM=;
 b=fkGf4JKf++2rveTcTfWRJbAEM3qdBE0uyJqY4iMU9/SxtmKPFdU+bJUX0atz9c3QLDb7wEDnrNDsf2ik8YGyAV2hV4ZpnIGj2nm0QRxPTX9Jr19aiQWU7e7jKRW3xsqPphIPfQ1+c9BsSFLbyf4D+d+B67+vvHp3YiKHhtE0mjho5UdOvRkZQkvQuxlYGYL5ujq8mghM3L7hRcjfKX2wDkztHF5rHUfkYR26M92AzJb9QU4YebEb80LgFqln/LR1v0o71yQnR563qIFX4p70mwSITVyhbPebSFeoLSraD4l4Qf8xFvFanTspJBMwBH8d/pIUKhCzO03mCLKf6e6hOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E/XR3Tg2GZGgZxf1ZewJg1epjCclLeTmNBreMjSYfYM=;
 b=JE1tLsC+WaP9PXg4wQe7F3mhOYu4EWFyrZuVPbe7zs8qU2Lt6EwPCTxzEp5KUkzFm2g3BN2iKaGWXEwncSE6BHu4ObPUAeB1ylzSfiMhNJWGgFE0Vr2+NSRaJ+poOqoxiTwpwwP6EzHNoOVbx3iGKe+ntudIhHWMSqqJgDOVyzM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU0PR04MB9346.eurprd04.prod.outlook.com (2603:10a6:10:356::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 12:17:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5880.019; Wed, 14 Dec 2022
 12:17:29 +0000
Date:   Wed, 14 Dec 2022 14:17:25 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        linux-kernel@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCH net] net: enetc: avoid buffer leaks on xdp_do_redirect()
 failure
Message-ID: <20221214121725.g4ox7it4aeumde6x@skbuf>
References: <20221213001908.2347046-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213001908.2347046-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: VI1PR02CA0062.eurprd02.prod.outlook.com
 (2603:10a6:802:14::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU0PR04MB9346:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e14e914-f0b2-4dcb-1699-08daddcd2acb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a34jSDAQPZbIBif1xgF+mskPh7vhjJdoay2ApJm8Dt6g3WyaJ9cHg6ZGv9+0VPXua6hk2a9s4Zw12tZpmSlixG1E6xBuqhEtYPqN2V6CS0sOPTGhb3fWaD+Fa/evZH7PXiMzsDxyVi5e/XlsYEy2+CA0JQcHy+m/ozWQhW+In76fLKdeECg7IJ+KRTrPZn//1ubDK8TNsVD8TUI7WLTRn//RxAlHVzgjOR5ZYNqOHWMSXneEa5CR5Wthgpbs3zWdDSqaIS/3gZ3eoVHt5cDL35fDOqKvgG+2Ol4xo3mmPX1PpwKMwym8dPbQ0/xX8naMtgGc3IEd4d0UAcouv0XdhhZRjYe7FIBBwH8/pZ9uABdkNuvlZ4SVRrVQFUFDNtOErciGY3nEYhNAGWKauNCLqfajoRAZtL4ISklCjp1K5/ZIbFR6pKPH1O/lK6SwwiCuBjqme/4drY/IcpAtctNHgnwMF7pPFUUG88Tm1aA9e5jtCKqd0uAJXS3DQTH2QZDf2axA9u9N6rI+TJt7PuZlSgAy9HVhZ/RZaTNXgOHcXLKv6JXxyGRj/fGF/yTZ8MeGX7Qf28X5z2r1SwEP8z72c/KJc+GViSCOt71w+3TtgV123LCgEdvx5qpsDEjps04T1UaY8Ie4t/uf80rDg6Z9uw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(346002)(366004)(376002)(136003)(39860400002)(451199015)(6506007)(8936002)(5660300002)(4744005)(2906002)(44832011)(6512007)(6916009)(316002)(41300700001)(9686003)(478600001)(26005)(33716001)(86362001)(6666004)(54906003)(6486002)(1076003)(38100700002)(186003)(66946007)(83380400001)(8676002)(66556008)(4326008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4lLeGsoqwx/r04Mv21dqai9IvGchn3Gs40+Y420UZchvlQrRsVADeenTKY0Q?=
 =?us-ascii?Q?Pq392DCpH4lhpuGM1JvSYCLMj8sRPJvqC1qazv8sNkDHpy4w9PbNnEN2htz9?=
 =?us-ascii?Q?59MjtBjfpsWV/P0Q4N0rRB3GWQeNbOHyTAe2OEX1OvaiLezqSitazVAlwC9O?=
 =?us-ascii?Q?9bYw+wYkn55EyA7JmjpRs30SUj4mHzMzwurRJcEHrMePV+0tg+O2XRS3DRtk?=
 =?us-ascii?Q?TXMg25VHVolABuscxycmf6hd2krupi9+MmkMPKkSeboBVRbHmKmvYOkM3K4w?=
 =?us-ascii?Q?8KjcZ5LT+flb5tDQ+mZwxSL1/16HR7SGJYMeqfUs8SdlF3TEOC9/KN8D6Zzq?=
 =?us-ascii?Q?4qwHhFIK1ei9ji4cuHk/AswYnNm5NdlM4APF1neNFzSe8eskvaWhwyMhRLEO?=
 =?us-ascii?Q?f14l8L/m6MfM8v1nuCNHaHhkkTxHJ4HObiKl0zuKc64lqEV2EWlAnC5EXffp?=
 =?us-ascii?Q?5+M9+2ojUi4WH6w8NCzO3o0HSa/91CsyHPwS8ABmGBmNtPEpt8+EgQt6jXfb?=
 =?us-ascii?Q?pTxR+zcmm15XPnZbTsnNAkJH4FMcnvwAmfNX1CeUKjyHMPDsUgujCm/UcokK?=
 =?us-ascii?Q?5m/bLqoDg3UJFAMmPclHP49p5AJ3+bW2aIU0YOQYJVre38/HzZa/CquhYaFp?=
 =?us-ascii?Q?R34BIlcV3Laxa599nputSIB4QY4TRG2nXUD7VNx6zD41r6OjBAekxp7Od4l7?=
 =?us-ascii?Q?iHz6GBSpj9Y2titBYgsdztLh4a+OjZ+DC4sOU2ShNA88Is3AFGFxz3rJImJt?=
 =?us-ascii?Q?jaP+pzGLhpNQH35FxL4h2z5MT0fj6HqDNIEY1LuMG2a2LGvdJHlywYHk0nDw?=
 =?us-ascii?Q?MWiJBVhnesshjR1/dVm61hV4Ucc9vvTUsYQ4bbG6nE9d1zotczFyy9eedvXa?=
 =?us-ascii?Q?zKGzyGGGkWGUc2SNOYeLWj/3veXY4LDGb3DFCtGh/2rPFqGsUwnfxEdc0bIJ?=
 =?us-ascii?Q?s57uVScxgMn6vqP9b3tSJV8JePYVj3GbSelTJTqiKxkyQCe8koXVTL0n3ZmT?=
 =?us-ascii?Q?vKh6R9mt41jNMZidZSWeiIfexJ6XQVVxjNFBZYyPel5Bvv3tcSVlDCHzE87Y?=
 =?us-ascii?Q?w0RQe4kNw4mul/527L83OPvTv4D+6rvg5MqXw0Dth3PpFbrlJoEnPDd5tODv?=
 =?us-ascii?Q?sEnTFN1qYjEnC1rkzgO18dJ+1wsDFsrNkbeARg9+Oci6lhCROnq3MLWwrFOy?=
 =?us-ascii?Q?y/9airxSPSEZew2PAcUNyy49m7vamE8MY33TTXkxVFE3UpQAebcklODrilVB?=
 =?us-ascii?Q?WJIUQiy+4zqrA4ZTX2l5FvJtgr2YOgPnNzosmrbdTo3n1cbsorvfVyJpgDru?=
 =?us-ascii?Q?YnUIE8ICl6srnu/FfRueNOC76aLWSI3bHAkj5gOIN+JMkDseVEdqUNFLHrLL?=
 =?us-ascii?Q?QviemkkkjPIl9OhLZ8P/c0WmDNQl9GepITftRxfJHE6OdZWNjV8y6e+2zbmJ?=
 =?us-ascii?Q?5/jE8PnjpckhxTzx7CjnwdjLUq7McMMk7qP6u83QuxfXuzowWPoZht9EXaYg?=
 =?us-ascii?Q?IGjY/Gbl+hOmwtp017DTiLP3N/afUCAh7yDiE9w1/xqbBsh0xrD8pG2LsXnQ?=
 =?us-ascii?Q?kwjuEE3KqcQve42ttDKeiqTJeMcA2Ax0X87LmouCGf5nnIhxJ/9Nod1hMy2u?=
 =?us-ascii?Q?yQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e14e914-f0b2-4dcb-1699-08daddcd2acb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 12:17:28.9989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TlM/XyeoW+DS4qsp4lWbjbwn3X2TCmmKjquLtp1qkNlq5rzl24XBOd2kcs8j3ObProqpU3oep2QUatSxsuJ7bA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9346
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 13, 2022 at 02:19:08AM +0200, Vladimir Oltean wrote:
> The problem, summarized, is that we zeroize rx_swbd->page before we're
> completely done with it, and this makes it impossible for the error path
> to do something with it.
> ---

I was pretty tired when I wrote this commit message, please let me know
if it rambles too much or it misses the point, I can rewrite it and
shorten it if needed.
