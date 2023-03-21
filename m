Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280526C2BD4
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 09:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjCUIAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 04:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjCUIAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 04:00:24 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2114.outbound.protection.outlook.com [40.107.244.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18EB3B86A;
        Tue, 21 Mar 2023 01:00:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QbcDL/DOGu88vbtqBPUEYPIf1Uid4Mjpen560FWh8N1Dp6LHRCx+q2txob2TYCkxDbJDqgf21vRIypPloTsLkE/ZG0Xj6WHHDf8QPS1rmz8niEus6k4fpzQPD7KbZ58W563bLLRGmq1LH2VmiEPDggeesBYb3PJWiDTzAW/u2ubc9h3BrFyEXjMQfi3AWsJv6a7h4SCqrnvo3hPrzcVfoq2gA7VQwNMMuS0GgYh1SjAWJn3NSd3Krs7JS49pJA9Dav9dp+A2HS13gZGDu4w4Ym05QOM2J30ZRvyx1UClO+fEgoN6z9c1P2xcJD0o5bLkZ9XXOeFq5NRtnVb8ZyDkQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ifBVyCtNaQhuc26oPQZFe+6e0AFkXYG/SqZ55PYvsA=;
 b=GuFE/8gM9kPNPANn3osXb4IGeervYhY1gMVG5ruCfOJD31f9PNg762wp5G5ltoYcFKbaBhmc02qFD/wAOUu3TOSl7I37JOVd9IoaeWJwoxnp6I8RpsxfsJS0rr+oeeP8ghDwYj5hNgMxsU1eBwHmVh2CU3/DS//kjzw7IZxs1tTjkYMpWuYWQd2q4enJJuojbpwibNc469VnJl1UVx5nI7wn0ENbhBMVHl1zW+UiIF5GCOTDJFS5UsJ0h3E1b4CjKRLdnalhz5DDp1QMzsiaxXy1ZhiOgsgOc+g+ePkTJnGWMe5iSb3OEdD+IGqxOWiXXNjyZj1MPfw/VOFy9bQkJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ifBVyCtNaQhuc26oPQZFe+6e0AFkXYG/SqZ55PYvsA=;
 b=Dh0635LQKhM6/7sqZWpbj5vdtIXx2QXI3bb5UpFN6Dg7uvm0oC7X4j8XeaCZ/np6jJKoB8sEdjLQ8Ft3jK3sB9OWziWu5MQbqhbpUm7RGqC2rr+zGPxdmuith4iHG4qgCjIBFYKfXmD939ZtHzzq3QppsBkJcs63i7imWjYUd/c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5407.namprd13.prod.outlook.com (2603:10b6:510:139::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 08:00:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 08:00:17 +0000
Date:   Tue, 21 Mar 2023 09:00:10 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 9/9] net: sunhme: Consolidate common probe
 tasks
Message-ID: <ZBlkCqW2RbX+MMHE@corigine.com>
References: <20230314003613.3874089-1-seanga2@gmail.com>
 <20230314003613.3874089-10-seanga2@gmail.com>
 <ZBXCWUm/1ffaD1B+@corigine.com>
 <7bf5761c-abdd-a3cb-267c-5e61641b15f8@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bf5761c-abdd-a3cb-267c-5e61641b15f8@gmail.com>
X-ClientProxiedBy: AS4P192CA0020.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5407:EE_
X-MS-Office365-Filtering-Correlation-Id: 032c28d5-3617-48b5-e59c-08db29e24f58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IB17IidBYwynPP72DwHlXoaw+lRfciIIQoqX/XQSO3zSTwnM/mnY8EJFsXbb+DVWrn7jVHtC+KJzzEcANAiOgTKtkfj06qEZqhwR9BeZWS00CkKRUCXDiukwUkW/RIndw37nAV2xfnQKgxlyzDoIbA3xVv9FOwqlb/1EyT46w+0UnDOUaHRQhyTQU3uEKgMrgbmRInAtjTTrVN7a/qAvudEi2GCHT5ThVDSWecSzypqzwLJ3nwNHlSAKyZOyVySN4pObqW46Njvxjy37YOlGcZhu9Y1HaaGUyzWTSOCR/CynYG+O8/WaUWWqJSfVe53HAVq8L3+lkOYNoL1yNJJIhy2CgaOGBJ4TJnIWchTiyjx+4W8ogXVvXZO1BOXt50BkEi165AbkHH7RaGzR3VzdUxSJCNIng5FL0xCTHN5ppCtbhqzvJU7hGEwoTJ5eiRP9aqVfnt94/AceAJM29teXEU6GeQVfX6AjlMk5aHk9xknluXVpqarSPKj89rkCs3W40dzM2CBrq6/NzDyRB2ksRMh5RYLhxgD+v8V//Dg+Fqka3bERCZwTVBiYFYs00pllO4ourdZf3tv5RAPh7CvD/M/eBnYBfhbiIUeCWQzjLsiwkArSsOB42ZFlbVnqLjA2SK5vfdJxIc5bQdLRGtq9ybRTNAvF3GSKrIcItU0U6g9b+Epq6YBFlZHBEeh8rm+g6Lpj/o9tMKcZntCTSnTfO2A14iCYpQxcAjmE48gA8aaFHM84PLkW2dflt2z7DMIz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(396003)(136003)(39840400004)(366004)(451199018)(66476007)(54906003)(66556008)(66946007)(478600001)(44832011)(41300700001)(8936002)(5660300002)(8676002)(6916009)(4326008)(86362001)(36756003)(53546011)(6506007)(186003)(6486002)(316002)(38100700002)(2616005)(6512007)(6666004)(2906002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hPLU4TtSysTRHUrE6zyrx83VbDAemLx3SkEVjb572waNuGFsSUJfcWk8XGye?=
 =?us-ascii?Q?/5RICShX3cKk6vQT4oC9siw0/WOXWaphGYHNX6TE7VM26MxwRNUxbV/c14up?=
 =?us-ascii?Q?xCyvBNS2g+4+ZorCmmbMpD2u9MsTg8nyLTgE6jJrZQHt/1rLlpwvsheKrmbm?=
 =?us-ascii?Q?jejYKRGpEo4N+CHJM/D3S9is4TcAOgVq4KTXfrVaFFhXaFm35bdHPXNW99/Y?=
 =?us-ascii?Q?uTW6PI9OOFeZj24IL26VO2LLeL2leX1II3zerKokcT7vOI5Gv/89pvdyMg4s?=
 =?us-ascii?Q?vjpaNfFrjj6eB+8Vl3dlRasS+kR3IZ05u2p7obxyQpwVjLhrGJ/vjmLhynVe?=
 =?us-ascii?Q?9M7yCqVHlwmtKemGBWPQHeSYexAdHLwduvA+rI1SueQgxRrc7C3w5PZC6aBx?=
 =?us-ascii?Q?UoUNMg4XW6XndFvRAi/dUuM+pVNq7ALXHx6mYaH8G5Qbl4Rk5OFIoQupnzpz?=
 =?us-ascii?Q?WvrZYBjrb/O3k+LBILl9ZDqEQ9anoP7/0eHIOU4w7Mrr16C9RXpA6xhSu6RK?=
 =?us-ascii?Q?6mZb5+Yu4AbFt6V777uFj840LlAOjhlRGUdUSyKO3FXL1DbF+iCQBuYcCGTt?=
 =?us-ascii?Q?hBJ1Df2ikzMnVBhgSQPhIN1Iyj/4TJoL/OihGmyoVqlb7b6FP9dNZgXmlyog?=
 =?us-ascii?Q?7tFfu5MN98JbxxtdbSZVncRS/eNA1Zh2S/REE9gQqqDc/5638QIav5+n5wtK?=
 =?us-ascii?Q?8qJOBqyKWE3Gdm4sD2jt0go9vHTHvFW00wHfDlFl/zTCeEvirdI02ifs/xCo?=
 =?us-ascii?Q?gXXaTCW0ImAtA/j64+hI5hoUDReU9/dVQMFWQkIpeb8VdjPQ6aOa6estvwr0?=
 =?us-ascii?Q?zWMXa4xXbBNB+/40zPqW8Xj4YCTTKBuDE9bq7wsapDLNyru4vgGLREYqD4zK?=
 =?us-ascii?Q?x5AAeqqbe6j5bjGqGbSKiyMXJCAaPoD6gP9Hbqa7z00Hz/2S63NKtyc07R4K?=
 =?us-ascii?Q?CZhZDijSjSQH1ynR95p4fCi32O/dEKE4mi4jU41MhINz+4Kyhnxrn6wR0Fxj?=
 =?us-ascii?Q?BEiI+JZNrDlZpooJceNjD2Liqj+C+5gs8ZWJgsgXJbePKAh2NPB96q46QyuI?=
 =?us-ascii?Q?XVWsSG+NuPmnkfGbVnGjS0hvvd/5BmhDiPWdtuh6aSttdLMKBH0FQSc4TT1Y?=
 =?us-ascii?Q?tPBt4RnJ3Po+cXA856HlzdUywr4A126yGe59yIe2Ji50BdhYZOnMCWmQlOs5?=
 =?us-ascii?Q?xcjdWMkU5fCm5X/LKwxyW2bx1f4KFPjdjTH7J7PgOMEHPOlr4tyfNI0wb2nU?=
 =?us-ascii?Q?A50e5dhivS3LJN9IMZUGO/oa8r/mqFDjQQM0JGngVtkXywYmxw/P9h5RI4X8?=
 =?us-ascii?Q?NAdQgVszXNk6G+hWkDx8j9yqUd05lOfQOMPBX/iqGZnD+9Xbik4qaK9jyFL4?=
 =?us-ascii?Q?vgJ4lqRKJtgogc4SEf4IO1HTdWw0vYECkhPPvrjSuMBwVBMnryRXYyka1+ng?=
 =?us-ascii?Q?ATyLuYC/RdOcs6j3+VDtipRKbQcUYTTNMCdWLdcyudCYeclnz8iqAyk2K+ra?=
 =?us-ascii?Q?NIm+nc5IIZw46G8/CdZgQgDFUwuve0ylWmOP0qVaRsmmpIYAs9SSaq92nY+2?=
 =?us-ascii?Q?mYom6pNVMmwWAbVDf0QCSPYlicEWr6Iw8zCUdLIJ1o09wMT5ViFXhd0oTE2T?=
 =?us-ascii?Q?kxMaK9ypIeOsgLyOjJKYiKNENig1nHdBUi2qUHha6ZGCFF4egx/dh0/vEJHY?=
 =?us-ascii?Q?u2ZaDQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 032c28d5-3617-48b5-e59c-08db29e24f58
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 08:00:17.5673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iKg1mUtNK2wyuF7b9ubQYFejJoPI5RUx0g35o99cjmCCPEeMB0Q9VphKesEFqoHyX8BfDsl3CeGaxjTU3IfU1pMEpEK26kOxEVWx6TJrFuw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5407
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 18, 2023 at 10:40:46AM -0400, Sean Anderson wrote:
> On 3/18/23 09:53, Simon Horman wrote:
> > On Mon, Mar 13, 2023 at 08:36:13PM -0400, Sean Anderson wrote:
> > > Most of the second half of the PCI/SBUS probe functions are the same.
> > > Consolidate them into a common function.
> > > 
> > > Signed-off-by: Sean Anderson <seanga2@gmail.com>

...

> > > @@ -2511,70 +2576,18 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
> > >   		goto err_out_clear_quattro;
> > >   	}
> > > -	hp->hm_revision = of_getintprop_default(dp, "hm-rev", 0xff);
> > > -	if (hp->hm_revision == 0xff)
> > > -		hp->hm_revision = 0xa0;
> > 
> > It's not clear to me that the same value will be set by the call to
> > happy_meal_common_probe(hp, dp, 0); where the logic is:
> > 
> > #ifdef CONFIG_SPARC
> > 	hp->hm_revision = of_getintprop_default(dp, "hm-rev", 0xff);
> > 	if (hp->hm_revision == 0xff)
> > 		hp->hm_revision = 0xc0 | minor_rev;
> 
> OK, so maybe this should be xor, with sbus passing in 0x30.

Maybe moving the math to the caller makes things easier.
I'm unsure.

> > #else
> > 	/* works with this on non-sparc hosts */
> > 	hp->hm_revision = 0x20;
> > #endif
> > 
> > I am assuming that the SPARC logic is run.
> > But another question: is it strictly true that SBUS means SPARC?
> 
> Yes.

Thanks, got it.
