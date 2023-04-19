Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7676E7808
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 13:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbjDSLFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 07:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232659AbjDSLFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 07:05:49 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2100.outbound.protection.outlook.com [40.107.95.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65121B5;
        Wed, 19 Apr 2023 04:05:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A4hUSFTg/A88HYwh8NZ3jHvwUi7eu40v2LebQ9XkUvVJ8T6XrYbecEo7Ea9sI8jLw/9AD9R5LAG8OHpx7JldxH6EZXT9j2KrUPtvEPkQihxypRbFKAn7yz2KIue3zHrfxLgyScQfMkx59+7DYKOHL04FdeXsVYptP/9DgAGyBaG1b9hKwyGQ5xjLUxagfEDzu32OcASD/4hBZA4KirIVzU8LtleSTOIWDjk2meOpRN8vCHnWTlJmHPzxTkUgZwyBecd9WGUoI2rsckdPirfS3bDxnWxxrHFfgelo1XKU+g7PWRylxMcRrXaAVmn+ahsI2gZVpsOEUOh6nVUbrq//pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mjUfhg8fCBBu1UAIChHOXwa+4sVEDZmwKj6oHAbaOLA=;
 b=ArqwBA0hYO0kKgMYkvkvzsO//2tf2VoybFlnWcQ0CmoapN8DuDVYrmNvcYAUuaJRLqdZK+4EomosiR8f52a1/pMSHcQaNHqbp+3uwGuEjqY9xGNQyL+3dUj5ggicXKPGwxuefvnxhhJSToEGI24tfOuGBrPs2bUyXTq77kRNsObr+bUp9WE4t9bw3CG0XJeAOk2w+73r3o97n/qWkY0I1oQHLKnwBrgDyC0kRstLKhj/XfvGeXKrjO1HVgu0xc4BKI9RmLY1ZDXd2RS15ChiSkgleJ4xv1Oa+AMSj/ea1vSynmdS47Dn6mQbwVJf9Af5P6psU1KDS5xiqOS0lu1rjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mjUfhg8fCBBu1UAIChHOXwa+4sVEDZmwKj6oHAbaOLA=;
 b=N57uDZEZS2WYd0UkMWC8P8ResPQEUo9u3DHf7Xmj/+ZWOXTzYlwQ8vku8V5auqi4TycgtYAvOaveuwa148h6P7ZkGVJHewgC3czpC7tONPJTTFHoSYXROc/ptj7P2ogst9Mk6f9aEcJCnDNZxpfTb0ht2Y4awySWe6C44trjhsI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5491.namprd13.prod.outlook.com (2603:10b6:806:232::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 11:05:45 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 11:05:44 +0000
Date:   Wed, 19 Apr 2023 13:05:38 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Sai Krishna <saikrishnag@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, leon@kernel.org,
        sgoutham@marvell.com, gakula@marvell.com, lcherian@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        Ratheesh Kannoth <rkannoth@marvell.com>
Subject: Re: [net PATCH v3 07/10] octeontx2-af: Update/Fix NPC field hash
 extract feature
Message-ID: <ZD/LAqE1eIxxoCya@corigine.com>
References: <20230419062018.286136-1-saikrishnag@marvell.com>
 <20230419062018.286136-8-saikrishnag@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419062018.286136-8-saikrishnag@marvell.com>
X-ClientProxiedBy: AM0PR02CA0074.eurprd02.prod.outlook.com
 (2603:10a6:208:154::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5491:EE_
X-MS-Office365-Filtering-Correlation-Id: 152f2954-c413-46bb-1668-08db40c605ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f2PdHZi1p3tFXsAt00S0QfRSkhtEjJfFd+v/EFrZxctzTwprPXQddDYlFtGP59wlkXxCoKrLLr7m2GkXK4aZj/LHEL4+J8eqC5dgtEyEe7KBexzg8lTW2jdcKqt0l/YTov1iKwiOeb1YYMXomMJv650G05baASBhkj5Rk5GJHGR6FQXoLccIQkFRGWK8/0EgsVL0W0Fza4ZOiY02NoI1XeJrOWpAlRSGwIJf8/MUjEdCBRHkDS82qec2AyOQe1u8AwlNslCZRm+c9OVZ4Ln1j4VW7ueF5Lsddiog6q89ArtaDfWtwpxG2AMiNButEqF2oxQkDKWJcIZ65+WoagCdG6fAJ++JpVQ1v/MpBl1yZU5GGgFYKjwAyKT3Qm5yhBpHlNmSQpXCWzgwXhjg/OqlhzZWx+jDL3KoJ7lqc0emPnG2sABYYY/G9U1l9nejMW3BJWAE9Sg+Toji79AKB3YWv/sLBm4Lj23mAKy44fwFJYEa+UxNmZTaVi/dwYuU5yVMoFyO0cniVYj2rYfV+LVRSk+TwOfoL9OYwxfzNe17zvEXSglV/f93zCf2fSZdh8be
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(39840400004)(136003)(346002)(366004)(451199021)(36756003)(4326008)(316002)(6916009)(66946007)(66556008)(66476007)(6486002)(41300700001)(478600001)(6666004)(15650500001)(5660300002)(8936002)(8676002)(2906002)(7416002)(44832011)(4744005)(86362001)(38100700002)(2616005)(6506007)(83380400001)(186003)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UOxwHVIHPd+RdBToaDVzAA1ktemCLF+iQadR2+v4xxYV/jgEELTJBAo2/Mde?=
 =?us-ascii?Q?DPGO5oJddZMyhZgs/pf5Cg39G07UBRSr0rRxlTPf8z2bn17hG2pnfmWJeepR?=
 =?us-ascii?Q?tEBQoGZLQtqw/cfgeTeh3xl1ZxRpEBpbDIsRAxjEhLOWvCVdba45uz9oILnl?=
 =?us-ascii?Q?T1sAqVJaKJH/r1XtPyujqPv/AoGDF0xbCgQIxKt5/EVmXNqbC93H8IrCGRNl?=
 =?us-ascii?Q?dQ7zMMn8/0QeT73BJYCSJwrFSHikNim8UOs55f/sFrWyqpCKi51VbwoTbu2W?=
 =?us-ascii?Q?tStkEExdGmfAZUgrwJRs2l1p0QwC+BotYMlwHwoxArYNhnBDRyFdfK9pL3bm?=
 =?us-ascii?Q?czXlfWUY8UiiOlPYwLT0+ea9bRQMzlSF2MjRjdVODDe94bZBWMLougvf20YL?=
 =?us-ascii?Q?xXsyHYdiRRCNG+35FFkU3Yq32soiGqmT4DcCHG8DYJJIn1b1+1FsJbazDicI?=
 =?us-ascii?Q?a/G1B+8sNdeAB9N+B2Z14aFJkxMZf0RMqsdrHrmhrGFSlzz2GeRrHHW9fDvh?=
 =?us-ascii?Q?hV/OsGIDIMeczrKb25c2sjDPxc9a4A9Zk3fWFvhZ1zRZLKA2okvLF4nBG+cp?=
 =?us-ascii?Q?Cc5Tfh+RkGgACsk7Qv/ZXf8ORCkAqRwSyJjw/E8kgWCD8n04Ao2YVSsAZTT6?=
 =?us-ascii?Q?5VWtBy5zeKH75Mdj89Sq2Sd9mw/oZb1BIuCqIDABkvY+hnDl4mlsw8x4nbqc?=
 =?us-ascii?Q?nM+GxKFTya+b4pXDOZklUG40cmvLJnfrt1FH8ZZY931ECVBl7yUtmz5ACExE?=
 =?us-ascii?Q?+jUdt6rmr2y8zqtV5YCPCyln+uvtWKUsP+Av17MMo59pyutzrviB/0okmNdy?=
 =?us-ascii?Q?8DrEv/ljqTQ0dF+MS8WB1iTt2kfDVqwYI8bL8eQ4SDhedc11jWmiKnOHsHV0?=
 =?us-ascii?Q?8QaoWUpPzgnW/tm/QgbSAAKieZtDWshAQ4A2f/owgg/WI8ilZoq87PXVS9hq?=
 =?us-ascii?Q?D0yLimtegy1E3RoBPLoQZvnArrhTyrZb9PKul1I7jo3QQVTvou7iZrbx4ii+?=
 =?us-ascii?Q?quTKogWKGlxzRLypBchjdLiiCXIL/NEPhZX5o0z5oKu/EzRxt7JQyh/g5FU+?=
 =?us-ascii?Q?hV//1649jmG3XKUo7RCp7ynljpNPqhZ0x1ZMMf0GEZtLJGaqZ3FoSwJhh2KW?=
 =?us-ascii?Q?Fa66B9T71rxXWSMI02xjNuPSK13AYDoflSxW41GlVt4B5jEBqDlKQvAp2MJL?=
 =?us-ascii?Q?y5IzRJViUXqZ3L/+Ik6fmmfrm+Ard7YYBYDqy5IY2xWl+wbG7A9OXgljEIFc?=
 =?us-ascii?Q?B8tGqwyHVJDQQ4OnVrUog4pxrGioQQlQTqAjGWbT8cXpfifDlrU9BlS58kt4?=
 =?us-ascii?Q?xjUyGLEYqmWHlAIm1Rern6Dv/ZAFRxtrSUmypo/Pede0nYbjPL3bj/NZOG43?=
 =?us-ascii?Q?vpFQpFXnNheBTNlT9D5c/NXU/dckYBOM91L73fA7lGqFs+Bm9qF4i4soY9q6?=
 =?us-ascii?Q?fFntALhq4guAAp5dehKr4mUyffe3xxw6l8+6ynvJjMvX9sHBRZHyvvABhO69?=
 =?us-ascii?Q?f50m1VMz7a9eRD+hn0P2ZA5C1T5AifZBeqW5iY0DwbO6nM/V9GdD6Rzl64kg?=
 =?us-ascii?Q?byoT2Dpu85Vqb9q9QogQ/W0Y5phKX+obcsdWWQF2mIla6FnkntB01ZEE4a5b?=
 =?us-ascii?Q?pqf98gyVwsqH63n7/BCgxT16es7HtvHNzJVmAHXn25oROh3z07QvPjYQ2ama?=
 =?us-ascii?Q?v/SXjQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 152f2954-c413-46bb-1668-08db40c605ab
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 11:05:44.7587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VSttZOTfu/NGhCtA2gMyQD9gvbMpKEQvx0bbiadKBCfFlpfm4dB4UsuX5YRTHXDx6ALwrqaOl/JsRGwRJMimO4kS1XsE+9risro5GgpPzBM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5491
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 11:50:15AM +0530, Sai Krishna wrote:
> From: Ratheesh Kannoth <rkannoth@marvell.com>
> 
> 1. As per previous implementation, mask and control parameter to
> generate the field hash value was not passed to the caller program.
> Updated the secret key mbox to share that information as well,
> as a part of the fix.
> 2. Earlier implementation did not consider hash reduction of both
> source and destination IPv6 addresses. Only source IPv6 address
> was considered. This fix solves that and provides option to hash
> 
> Fixes: 56d9f5fd2246 ("octeontx2-af: Use hashed field in MCAM key")
> Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Sai Krishna <saikrishnag@marvell.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

As an aside. The indentation of some of this code is quite deep.
You may want to consider cleaning that up at some point.
