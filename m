Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 299324DD5E0
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 09:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbiCRIOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 04:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbiCRIOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 04:14:04 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2127.outbound.protection.outlook.com [40.107.223.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C931E261DD8
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 01:12:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dCh/79p/DV/vjn48jAI2XAEZo77hhJBhfVjq+3K2PTpZj9ErPQ50nB38gUz+2eqqb6LbVDVHuowkgCLD4VQfDe0s2Wnn6Q02WHyX91lT6BqDhWJrIZ4Dhtcoe9u8QTa+YUcAg+zZCtpgclOKg78mjEY2BTXilZln9X20rghtywG+/GmMQyo6DFF94i5N8lBqOgYMhMwUyQJ7R5oZr28ezmj5P2/86jNJNZJ75rFdarXY1ZO3G3spA7gr5QJ0hU6nlj4U2Cwho5Vwil5DxYaF20/lGTjjDdHePnIkRVL8KGsLTQX0qx3OYMfqbWPQitZT9LxNZctD5dKBWkaiVNfchA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wzegdf8oK/Hlfhsn2YXghcSLRsyJFvWFDkC2UovI0CE=;
 b=cCS29y2kWZdr19aDFyVVjyUraFa5Z4YMSH27nUWxjTPWdJJqukxKlWrAwYy4rxcL8c9nXXpv4THstH76wBtZpXxiNNjd4Ds13nS4yFs9OqmTX2ZKqdhSXuxcoURMadSDCIJXyPZUGv7v+IC1NzSdK21o/sR5K9cYjCwAmmFVHw9VSaOj+9Gxr8bRG5NDDorLRaiPL+lle4Ho4ivqMgT2ZxzOCe7GK4Shp11tjtg8zGY9P0Neo+TqV5PXTKvXXOcA9baV+5zfHYk//3x44mEh4io4mP7QMw/EIN6k8zuST9FGFZ08V0G4TqGbDgHV0RK70Va29b7MjiGtNWDx/fw0cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wzegdf8oK/Hlfhsn2YXghcSLRsyJFvWFDkC2UovI0CE=;
 b=GYPGaVNwPRHKSP7bLVOINKS6ARUd+zIRH/6L4pgjOXOmZmKgocyRauZRhjC1OmAYJSb4nR7iulaILjf20CINXiUmlFHRdwld62sdKCmHoQ1R/6xS3JIOSIk5EVXdQ9Y41GBMHtapr/FI3w2N+koCDFxtwa6oEUqOWCPnfRMI41U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3310.namprd13.prod.outlook.com (2603:10b6:208:159::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.7; Fri, 18 Mar
 2022 08:12:43 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5081.015; Fri, 18 Mar 2022
 08:12:43 +0000
Date:   Fri, 18 Mar 2022 09:12:37 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@resnulli.us,
        leonro@nvidia.com, saeedm@nvidia.com, idosch@idosch.org,
        michael.chan@broadcom.com
Subject: Re: [PATCH net-next 0/5] devlink: hold the instance lock in eswitch
 callbacks
Message-ID: <YjQ+9XuTGwf1EVT1@corigine.com>
References: <20220317042023.1470039-1-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317042023.1470039-1-kuba@kernel.org>
X-ClientProxiedBy: AM0PR10CA0034.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3444dc54-4fb6-46eb-028a-08da08b713d0
X-MS-TrafficTypeDiagnostic: MN2PR13MB3310:EE_
X-Microsoft-Antispam-PRVS: <MN2PR13MB33103578D0A6210A6782738DE8139@MN2PR13MB3310.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7aoNU4BM3OAjSzF+LuSJCcGD6pwSja6OBoROwjPboKPL0hh2TpbDdSnJUFlIKcroAAlIELIFre41yxjhpDB/24rWobTs4DtUyl7Z/1UgUYl2+s8ARxMF+9es69tBtMT+pChRn46Nh5pxnOjmYmDPuOrpApPC/h/2aOIi6k9muSPUCHL8xjX4PjUzLFDGtZi8Pq5KWmRHKS0Pyqkuk0BbPW8J8kIazS96nozFsDpUk9u2vGMyDAidBgbsXseyD0A6Ta8u1y48hOmMkaGaE/ZV5ZUp/sv80NDvgEf4JSJSP0ejcvKPcY14FrpS1EP8lXWQFlGcHLqbKkGBZLVQXwyCnNeIqKa4VTodf9nHVWFB0+dmz8CtscmYIvsERsosMOt30nqTP6qSEXtH2Zc4dWZnBOwdZHwIGWrJ1kDWllRXpmTijrrBoDMiwiUWET25fr6MeTpJYuqOBk9+9nhXP8VCUkT7esP/qVshQ1s+n5vIMBZqF/TQjpHiO/X6usKNwako2ssb8dVooByE23uTT9VrJLXmox3kFIC09PMs3T/xzbWTwoJ/DeO/eg4EMw/6bermroq8njir3dUCvlt7xZvNCzHBv1ETXx/PRCM2Wm6M5XpNzZ3S6L+NWwBIBcfKdIP83X91Nmm/cm9Kok9472AQARoKcaJAfnpOFvhHkqaaG1W6ApYGpnSc7yQJfwOcXThNsacW4XfhU4ise9TWLl6iNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(366004)(396003)(39830400003)(346002)(376002)(8936002)(44832011)(5660300002)(6506007)(186003)(52116002)(6512007)(316002)(83380400001)(6666004)(36756003)(66476007)(66556008)(8676002)(2906002)(66946007)(4326008)(86362001)(2616005)(6916009)(508600001)(6486002)(38100700002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cLX2T74zhCFhwsHXBlPHBsGSn0bizR0Z97mc7sK5Ji6A6wwBBFzyS7UWprth?=
 =?us-ascii?Q?uY6a3QEhsZf/ITczfqwEZSJ8gSCW4jbw35RyFoVH6zCktF8vdEUwRh0r8ioG?=
 =?us-ascii?Q?wRhMsGqz4w7SZ1D6v9JRrfI0LwMExwPgpJk5X8KKyRWs1ANNO+1E30aT4HFq?=
 =?us-ascii?Q?JHYl62Gdu1TtPdAgnUMwdPljugiJQnIkIeJ9VsAGiqN4ruKEQPZXDcZKrJWR?=
 =?us-ascii?Q?rBlZ9V7+C586q8+kTY9y5BWmPta1AuuZ8weDwfCB2lYUiKdnqLFdN8dL8GD7?=
 =?us-ascii?Q?ezN/GFdUNnkdylnyRjr1BpfdDmFwf4U4UKq/VIweIOGaXWVNnD6viDAfWG3V?=
 =?us-ascii?Q?pvtvfxeRvMg8eHGITWBza8mJUTZzZlizsYq6s6lYMKxhnv94VVaKOYLcuDfI?=
 =?us-ascii?Q?wo3RlaAzjfrIcJ4ZwQH0im5SgjgHM+0lo0PR7c3jbXjfrHa1hc7pY4coIj7a?=
 =?us-ascii?Q?daP33ZwYWdJQFl89PCZiMXcxDc5+rbj8+Ef50HtZTOYwwiHikYIms6H5ODZx?=
 =?us-ascii?Q?BHP0InZQc1cOtVQG0gYq2lOI8D5764XNyJgDU5b7U4cC/zG0mLA+jQUHDVCe?=
 =?us-ascii?Q?kGSPUet1xkYAJ4vzrHC0icTiBBu/dQESYE8pxi+hHUMk0kV495YijlUDZcwD?=
 =?us-ascii?Q?Una6gHihCmLAmIgD56SNllxu29xcacWPPgeKHx6akE8+e82ajQu4MoJ4XkuN?=
 =?us-ascii?Q?1sLngJ9Bh1Eko9jOnXKjEVJ9JbU3Ak6luQ/PqhfCwS4JODUYzZS8U253CU4S?=
 =?us-ascii?Q?fHFNBCDQyM3dc1LPNqu4cwrNHlrv+JhZYs3xWNNCK72la1/E5zPZv0oWFa7C?=
 =?us-ascii?Q?DBcXLqKHIqnJQMN9NDsSBOUKmAkmUEhcSTSnErE8qpmMBJRLFMwe/cqF1p7F?=
 =?us-ascii?Q?2Uy/oXHhnOaqVylBIIYMs2ttOtBD4m5JnMEfJ7SZ77DFVktEaaIVdloInH6j?=
 =?us-ascii?Q?dB8FUkCmauiYm3IvtGqDbZ/pnSLYAVxFlAH6SCffnasdl0e895t0nbOCwwNR?=
 =?us-ascii?Q?RGceViD7ScVCFVK6joJ37yJOA8OsYthG1fizHq8fbjEdH/m//uHOJ84RPHtg?=
 =?us-ascii?Q?efgBcjl7JB3eb+DAUAM4K92bzScnoH+1YuRMC+fBMz8lg+P86nk/x2QvvFRP?=
 =?us-ascii?Q?oj7j9wkugH3LpoHI2IGq+cI0JvaRpoY5W+bWV3CnyNIoaQyfBY9KU505bsJM?=
 =?us-ascii?Q?iQmPlGcSTwyr3wViQMOVUsPpDaGNA48fszTBZ+24907yvaMsQxziuTlaegnr?=
 =?us-ascii?Q?yL5Qiz96dVlaRgZ0P0v5vjPsBiv9ZoI5VDvnKQWk5RxPgjodzq2i73TuTi4Z?=
 =?us-ascii?Q?G1S/bbbrC/0mtnALBpvSXTF6HyTMMcUQObbRZX1h8AZQCpOEJkMwcpSrgbRd?=
 =?us-ascii?Q?bY9+/xomHQwLiBmK1RsmJ634ZidVKvSXjw9LGGzoW1DRZjCwUE4+Yqx4BMuY?=
 =?us-ascii?Q?kv2iTsg+CMHlT5WFLxPbja1vmz75VKl7xbwrg43xj+DOrNFKqDO8I4pJJdEn?=
 =?us-ascii?Q?crrroON7IJY2D8Rg/hPWvGC9RfmhFh+Sc48yGCVutQVOhoRfoSU6gpfWwQ?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3444dc54-4fb6-46eb-028a-08da08b713d0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 08:12:43.2032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0AB1OV27dBpKUVaxd9mT5gxYj2J1giwhT8ZprH/NiuaBCLK8PYY9eIIe3bUZ43/vSNI4qxLuh5B+F9YQzJ0UnQBYQxE/WMcno3wiqpqi6Gw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3310
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 16, 2022 at 09:20:18PM -0700, Jakub Kicinski wrote:
> Series number 2 in the effort to hold the devlink instance lock
> in call driver callbacks. We have the following drivers using
> this API:
> 
>  - bnxt, nfp, netdevsim - their own locking is removed / simplified
>    by this series; all of them needed a lock to protect from changes
>    to the number of VFs while switching modes, now the VF config bus
>    callback takes the devlink instance lock via devl_lock();
>  - ice - appears not to allow changing modes while SR-IOV enabled,
>    so nothing to do there;
>  - liquidio - does not contain any locking;
>  - octeontx2/af - is very special but at least doesn't have locking
>    so doesn't get in the way either;
>  - mlx5 has a wealth of locks - I chickened out and dropped the lock
>    in the callbacks so that I can leave the driver be, for now.
> 
> The last one is obviously not ideal, but I would prefer to transition
> the API already as it make take longer.
> 
> LMK if it's an abuse of power / I'm not thinking straight.

Thanks Jakub,

we have reviewed this from an NFP driver perspective and are happy
with this change - it looks quite straightforward from that perspective.
