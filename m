Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02A026BEDE3
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbjCQQSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjCQQSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:18:43 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2119.outbound.protection.outlook.com [40.107.243.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A4E19F34;
        Fri, 17 Mar 2023 09:18:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cQ/uzLiaYYt2Bb763yuxoKZeZusUT9UnYjFgJNFNVcj6blectSDVm1BPue80DIPmLX+ACYJoBpDLwyNKNvSSuerpsnkTHhepGWTujCYQZ20eBaj/vl7Cl0Lknk6skw7M5pndbtp9CpJIwd09mcJ2LNQpDdwF1IFCDqnNIn27jQAq9SSQU2+ewdTIe1NY1LQCth9CygOGwNtt6LGbG3PbUXdxIqbkDUwmEzp58mtMkpKLkxX9jIkA84qNU0M7mDUUPcvArlHCZuMe7/Pk54TtpMxq/anNRn4+JxcGZOyDCq9YXJ64jkFPPFIF4zwm5nmgKp1EMBxH0n6O1pDdIf6Osg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cYCqcdFiYbjGffWTvyikDydmd02htosW+Wh65b/aSIw=;
 b=inEu+LigcWt4s2C9qiv0AD27xHzCVAsummF7JtQzm2w2up2/v69wIkbi+N8cr0xdPurY/jZG9ldxYrcDiPuCot6L4mnxO8/5XgAC+sc9EJ9nAE7QoO/buFszHmPzz2o7FGxirLBG0dfQg2Iv5E9kaxnOCFI1pks6f2ht6rZbhskItudqf/fvW6ssTAFXDq1ATTMrzCeb8cILKqKrKYYbp1rznsEO+raG0t3HsCmSy8rn6ZD7G41LgcqYlM2yZkkBqBPwU580jgS/uO2OOwDfVtk9963A9t2+yadpT95yJnXfLgsr1p5+EBaYPzwscQ9gviP9CMCTRERs3pRcLJceeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cYCqcdFiYbjGffWTvyikDydmd02htosW+Wh65b/aSIw=;
 b=iP69bFUzsVVUWAueNANaLsGPZRkinCpwGeuofhJmASHKPR+vS0HM5Ma8HyI02oEdkroDm61NxlFfN1YFAdDf8EXHXXdwpMhjrG0IIB8K5stk21veWBgdVFy47UHNzpWpkL28o3o1d0dAdTGP7qDdEcQZHmmbKxAHmBvtbJzojqc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM4PR13MB5884.namprd13.prod.outlook.com (2603:10b6:8:4f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Fri, 17 Mar
 2023 16:18:38 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 16:18:38 +0000
Date:   Fri, 17 Mar 2023 17:18:30 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 12/16] can: m_can: Use the workqueue as queue
Message-ID: <ZBSS1tqgHzYp3pBH@corigine.com>
References: <20230315110546.2518305-1-msp@baylibre.com>
 <20230315110546.2518305-13-msp@baylibre.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315110546.2518305-13-msp@baylibre.com>
X-ClientProxiedBy: AM0PR02CA0098.eurprd02.prod.outlook.com
 (2603:10a6:208:154::39) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM4PR13MB5884:EE_
X-MS-Office365-Filtering-Correlation-Id: 0982e470-4b16-425b-ef0c-08db270343dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ef7PaAW/ddBZtwB9A3bMkNJVHl/gTrVGePvEDJVl+Wz7+cbFtNadtlr3sr9KTAwqP4KyQrV/45vvINUxJ0NYMqy9UqVUGlwP1oLwWeTOKvl7naaSYPzi2wZCcgfJTIyEzHA6399y69soo0kXZ9eZRdL5WmebswIdjB25X7HMOSIU6erH/EfR89gUyExNiMNM/Ksc/QHcZ577UgCkiUuVznSzCj/4WoolkKRf9v7FVM124JP+la7+OWliZJBx8xWuqmy/yNECfD1B5iwlSDfBZZLGp8YGnFesjXITdYIp+NBP+115jcqHWza2e1ZBV6ON7kQepKk4i9/8M5dpPQ5/i6b0542bu/sNvG6VB/c8yi8qa5vSpf9w4oqzefON8eRCbfJmXISpBssn5/fGckpSluoVwx8DXaHZ3sHuIDSRDGfBdXDjcpRoAJW5pxzzLmaQwEUCobtcl1a0Yf4IhQ3qdrkxsSU+aw3NiLhtbZWxZzFdJ9xilObelLGDP98bGuTtADyCNFBhWhcqAz+sIYVAAguPNiwkd8zA5ml6wS5LRcJVJdB4Ox8KarWoIrh8uFRU74j8JgrPjUgwP95Qt1DNI17s1dMbKohjLaI3bokF4Eu6B0gIzx1K8y5itrh6XrP+gGZuWCyBUHMeYnHOcCxVfFOyhA7wY2nD3gLdvw/dmZS3zcntMW7iDbFp/i3y1Zgv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(366004)(396003)(346002)(39840400004)(451199018)(66899018)(54906003)(8936002)(478600001)(41300700001)(4326008)(6916009)(66556008)(66476007)(8676002)(66946007)(36756003)(86362001)(38100700002)(6666004)(186003)(5660300002)(6506007)(6512007)(2906002)(316002)(83380400001)(2616005)(44832011)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4D8S5eSOovsJZQUUyPPrvw4anAd0/orUsNVCfzagXPQLVnS0Tl3Z8AWygQRf?=
 =?us-ascii?Q?hGSkcKKZarfCS8el/28vj270KSVLyciywu1ObBJYwOTyfSngGl9ZFFZwS9k+?=
 =?us-ascii?Q?bBfJ6zHbIFopFZ7fyM10Q9V7QSl3DqrFoDan6hoaql0CpBB8B6kZsPpd86HF?=
 =?us-ascii?Q?/w0Woiv/lL1izxe0+7qeJDUSsHkQw3dwJFisnhJYzTSbpLUUBksKn23vIHpZ?=
 =?us-ascii?Q?ojP+JU+rP57uhK+Rwu/YVua8HZHtU1vcSbOrBp5UUO/asO/6v0jhuDwsMij7?=
 =?us-ascii?Q?GnKXFKmAAhEMa7upsrMc6vF+m3PtmeVuOEUxn9yCEWYQ7GMjvjvl53CmkdqM?=
 =?us-ascii?Q?/KWFFjVBwf494wofJFEGv3ATLk432oQ1sNV/wzR2MTOloDCLv+9y0HiZk1J+?=
 =?us-ascii?Q?XY00K0lbzdziUxD8kCYFaf32S/YK0DADECZSrYJIKA9Mo6AylTHGg/5FOSh4?=
 =?us-ascii?Q?uhFm3mRoU6z1Xz27Emk47JkjxGbv5vcGet7+rinAVy1gZ5dXsYAQfX96rIxO?=
 =?us-ascii?Q?49xZAQPRz/80V+lh2b11CTGBvgd9EWhfWNqgZ4vDFIwo4iNPyvL3qqsbSL8N?=
 =?us-ascii?Q?j2X/hNYEqrWxvKwdG4suIYRbW5mAONCsf9AhEpYQCfdKqwE/VaUBO9yggj+l?=
 =?us-ascii?Q?Rkdiyiv3N2luZw0ueA7LBzfvfkujmXnvFHz7OO1TLeU0yYC2P8Tt9f85LDG8?=
 =?us-ascii?Q?WPirQkU4jpWWlyX8Snbd8WMqwLl6T/uFll1rx8386IDRQkJPme7Ctz3UX0zX?=
 =?us-ascii?Q?bfwMYv3+bLIOGSY3d4OMpCycetGxx5l2IHMzOndDDTxftt845PXF6pEjwMB+?=
 =?us-ascii?Q?nhvpS3aG6UTFrJC81ELL24olju/h1Gr3pkR6ZSzySk6SOH/JtTwuur/styZy?=
 =?us-ascii?Q?FY/ir5aOfY2T1VQ9b5wtGV7P5IrA6u9h1SWWhEMMoW4OaesZtoyqdjGJ2tVh?=
 =?us-ascii?Q?EmHhLuwSvjReBOAlk8YSOkeMVjZ8FNoZFno6PLUxyiOwL5uTm8PJ2lN8f3Su?=
 =?us-ascii?Q?3rvQcC262OkkwZ7c2DQoDFYdy/bzP4mBNtBXTPptifMdTIyyg4D65k4Rhj3Y?=
 =?us-ascii?Q?maGTKc+Ra74vsIab8b5CIl3N6bvtzttMJ2OCEWFypKbuFoubt4e0WhLp3zoB?=
 =?us-ascii?Q?/1T9Nu61nE2Vp9A7M9NGrQaumsGvfYSfRpk5z6kYnAPJghvYiAqNs3xpJabc?=
 =?us-ascii?Q?9jkJrKrrSn+r1gtCeodFTmDg/64+ltU83e7lN7/1ZB3rVjXBGrrokvEZ02Ph?=
 =?us-ascii?Q?6FiD8n5LljQYZ6qxYiMqZ+MadO7wbHscZmiyBYn/dE2jtvnoVb8j8h02FSms?=
 =?us-ascii?Q?oaK7M3wZUkIHZVG2T4RarFwCtOYznAqWXCBDWkeR6tUhf2vo+tP0g3XZqkk8?=
 =?us-ascii?Q?qRGVuKrjzyRn0DEpddZMc12Lw+94hrAXiyY5Hts9G7+Pzgn/8rDFSqBm/oYR?=
 =?us-ascii?Q?EiT+peFU2yHMmcqX1cc1NggBI6PxIlEVvjtnhy9vIhY00HtxvLwo59VG0wR/?=
 =?us-ascii?Q?5J/58ictLEk/6rtfv6lvJL12VaIz2TAlsusMW6l0J55KdZlDQCjlWsxZzUoi?=
 =?us-ascii?Q?hz6fNPGMNwBdZNODghUsTrtZQFqbf5zbyTYAhqMuKyOnaJr/kZ70PLeECcfg?=
 =?us-ascii?Q?iPuo/XDFb52byZCE+/angyq1m9LWvqYUKmF3OJMoux+aUdOlFuG19wWvtYFA?=
 =?us-ascii?Q?S/PvJw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0982e470-4b16-425b-ef0c-08db270343dd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 16:18:38.1622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ot6oMyxD7enTMTPES2YAg6ZF5rvsYqT0SOf5qtXa4Z1b61o27bDeFVY85TmV6xUzJX5DgVtxQ4OU6ElxDjzxGm3+P6sfPmsp537Sr4n+7/U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR13MB5884
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 12:05:42PM +0100, Markus Schneider-Pargmann wrote:
> The current implementation uses the workqueue for peripheral chips to
> submit work. Only a single work item is queued and used at any time.
> 
> To be able to keep more than one transmit in flight at a time, prepare
> the workqueue to support multiple transmits at the same time.
> 
> Each work item now has a separate storage for a skb and a pointer to
> cdev. This assures that each workitem can be processed individually.
> 
> The workqueue is replaced by an ordered workqueue which makes sure that
> only a single worker processes the items queued on the workqueue. Also
> items are ordered by the order they were enqueued. This removes most of
> the concurrency the workqueue normally offers. It is not necessary for
> this driver.
> 
> The cleanup functions have to be adopted a bit to handle this new
> mechanism.
> 
> Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

