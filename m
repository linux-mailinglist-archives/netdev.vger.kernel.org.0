Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF611690E95
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 17:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjBIQql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 11:46:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBIQqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 11:46:40 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2090.outbound.protection.outlook.com [40.107.243.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2612A5D1FE
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 08:46:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bDJXU8t8e7zdq/BvpYzIg4/r6dBqyrkd0n/360n8/T/FDT9Yqi8bvgHBZhAqLlag+9eeuxENmksxqfcM+fcbgDdw3lguBL1c8XQYU7ECx9oiovbGJgUDFMx//LolrTxYyCQnuFO6NzPD2NB+oEIIiNHO8MVHr06embgqa1lmx3ph24SIfSTGieSpuPuViD2nOOYVAPv5QVrjwxFk/5HDHXlBRcQwyaNWjnfxowIbWesh7/BPLghBwoJRpBU6QYCN3DiSoF9m2etOftWMBuPYo3hMGK7UKBQyXT7Gx3sOxLaoC7qcsDTQFLznmPohg8xUhWWjvBWzvq2XBP/tFOQdaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IyR1m5o5XTjLddk7Qrme1dpVanIiT+dkWJ0lkHA8Yxo=;
 b=SxppwZRlwhZ4+mWdhOxOULJDQRWAffyRIMzEuRBvqqsvQQ8RRxPj2rw78v11d9q4f1XX0zajc6M0ZhKU+uZQIKHWrkKQhn4OwvaBbLMsW1qjLOlnFiihEOQCMHnJXlkuoooVzp76fIKeUOXEblHxTwdRzuaRK0Tz/752pQWLVbmn67HzaIdp78WOvka8o9oYroUNF7k9K7InnzmOc9iPOXG/t8Ix1cds8SEKYoSMFuMKS4eSayRA0Bz7I/Atiny/fvbftjwMdE2eAv26BxmC2nECescgzu32oG1mQpKTPOwISFmW9fqnU7cwIE3KynnRutzLdcIf1R522y2OdfGQyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IyR1m5o5XTjLddk7Qrme1dpVanIiT+dkWJ0lkHA8Yxo=;
 b=C5hhJdZTLxRPU6sm9KP/B+M1JaQF+PYjtgESep56xi2iRyt1HeAtnF4zbDoAfGMqI08F90Fu28KJDqtLImtNsq/hUjnxkP6xH6qZq+JvYfsvR4qLfvYNJIUr37aNh/LNvBs4kOMRcTEyfrpctGOK1cC8KVFD2T17x3WRMwj9IKU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL0PR13MB4452.namprd13.prod.outlook.com (2603:10b6:208:1c3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Thu, 9 Feb
 2023 16:46:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 16:46:36 +0000
Date:   Thu, 9 Feb 2023 17:46:29 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, tariqt@nvidia.com,
        saeedm@nvidia.com, jacob.e.keller@intel.com, gal@nvidia.com,
        kim.phillips@amd.com, moshe@nvidia.com
Subject: Re: [patch net-next 6/7] devlink: allow to call
 devl_param_driverinit_value_get() without holding instance lock
Message-ID: <Y+UjZVPU87ISpRbn@corigine.com>
References: <20230209154308.2984602-1-jiri@resnulli.us>
 <20230209154308.2984602-7-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209154308.2984602-7-jiri@resnulli.us>
X-ClientProxiedBy: AM9P195CA0019.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL0PR13MB4452:EE_
X-MS-Office365-Filtering-Correlation-Id: 0aa2866d-920b-482b-d9ae-08db0abd3505
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2WR69J1aZrlwd6DlUaFnV//uehwepvzVBFmAo72UsPweqfsQ0E3jl3U+tfphPtqaMRMxTcjK45hqfMioaThfsbLKNXm//gpNInL24FCjK83zFZxiVrJqcDmzNz0KZ+IH4SVZHyRj2Na0jJhWG62TL5fQO5FpX71h9YVF+3urimuOOOnaZc9hqmo5qslkOICnIi1WA+N89/IO28bh8B1BlxEa47HLFz358JzupK4kQm58sfmuKH5Ox4m8lEnxobrHchlmj/2S4+nFQghZd+M57WtUPIb6dRygAR3Yt5Ynz4SGFD8MCzYM++op/xWqsu9hO0UwHcnsrZ2QVQWRm+daMWE2g0q2N1E0Odk5FYmCXFvZ5TtYm/qqdnATNqeQ6hIzc4t7j9DxzTwhKny6LQ4xDBSwTckRYQJjJuwlPOFf1K30qxuX0k7vVVl4cy6HjsbWvj654+DaepBvMbqZxbk9lfD+CRX1ZFOuuNfR3xJNvmewFr6YzDgd+s4hMF6X0ow855iwjt8RXxJ/VVXrMyuFL67QLJ7EAZ15+ZWrOtILcrLZIZAwewssACQL4LLjjPiS6l3y7dD+fRb8UFDCm1nYfkYRcT19MZN6sUfIQcsgjbTeZDGfY9SAB/EibdcPJMRRlWlEw5+qUE+Xi9J0U37Tote1P5APXd9sbXu2nPZ3txbZ6z2EZex0Sri5LCV4z59VbLNhrm3cyiQm69G7IInAAYzde0kJADo/ieQFoVTV12A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(366004)(136003)(346002)(39830400003)(451199018)(36756003)(2906002)(38100700002)(66476007)(8676002)(66556008)(41300700001)(66946007)(4326008)(6916009)(44832011)(316002)(83380400001)(8936002)(7416002)(5660300002)(478600001)(6486002)(966005)(6506007)(2616005)(86362001)(186003)(6666004)(6512007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Wqm4SxIUyPucuBfigGIXho0TbTsClsPeejyhlyFj++qdVRkWIZ0BmpI8W3sq?=
 =?us-ascii?Q?QyC6fkJ40HPNAlYHE8dW24aH2UVZMS27MQH/uDgp9kJIf9+4YQDO4sdsCmkQ?=
 =?us-ascii?Q?1Wj4l3PmaCkGqSFg5TQulUq8v+OdzprpGxwXcJRaf3BmHjlaDnb3jH6RZfY8?=
 =?us-ascii?Q?RZMJ5iXrBZr7ugRjeEOVJsT4Ifhswq+LtiGRycoT7gQkXjNYrABA5gYNEPrE?=
 =?us-ascii?Q?FxXfmyLYtKflNVD7zcJXX5q5npS+NmXZnci9HWsv0x1TV6nCVBndskUsJxO5?=
 =?us-ascii?Q?+U43eV08ED6ZsnRwm2a/sVW9T5KY0WzAnogIOLRUZSHbkeclAlWE8J2tWH/c?=
 =?us-ascii?Q?FvKbEqIl0YFr49ScVIxNBpqpon3rRjPfDoJr9b9UYFPavrxR9faMt4mxXDsD?=
 =?us-ascii?Q?hqUu7Rco287v7pI86qqwa9r2tlUJelFJn/594HSWilmxGU0yRObnnjZj5XHr?=
 =?us-ascii?Q?iy3V0PFxmnYyQ5MQsA7q/jIM7ZvQNUTIXUpZWl/5xHhx1JngNgThhPE+0+J+?=
 =?us-ascii?Q?dN339Oeif8JpJvZpDGckJreEeP8edPm8wAwH51XrCkTg6NPnQPgFWDAXMwS3?=
 =?us-ascii?Q?ORTer52uvrMIUdrFB8DgS02x8huMu1lI7BFfRudKNB4wckoQqYCWeDPeuTtC?=
 =?us-ascii?Q?WnmvOLEPlRcBMAiqwnL2NFDX3x6M3wDqVba+vIB/apedeYp5dlpk/iyQHNjt?=
 =?us-ascii?Q?KNxS/pe6jsfmMHRwnX04e1iQyF/haIkO8SIk1V2X6pZ0koWTbHeOMRldRJ2B?=
 =?us-ascii?Q?g2LqCRsaaF17nbgv5PX1KRynSVadVkeRZdPxmPIz3/0iC5eC7A1+RLygaJO2?=
 =?us-ascii?Q?yNdPJlOS/kwlfXt/HMLfiqLf/vSlJwZvEyS0zAGSTryuoGFKcF3JbtP/zxUK?=
 =?us-ascii?Q?gwAh/wzLbnWqtMrG67zs1g9u+rQmTIYxX+uBEjk5roQjcnHNJYJzQi/Ac/hQ?=
 =?us-ascii?Q?XVKKKCIL69FDx+59BEZJy05HnG6ZIirYrQq4x2FFM5P9JztGAaTd3IB75m7n?=
 =?us-ascii?Q?Pqv0eNu9DLlYEEvmM6n21ZyGtApZmjSQTb9yRHUZSgQcXKGrgKLEwp/DSfhv?=
 =?us-ascii?Q?XHctQcv4mmW6SVf/9BsecbrpbDltLJWxh/MFX2oGcddYcqhIoaU9GzPBWGH8?=
 =?us-ascii?Q?jcZJUpVpPtRbMvKbgdBRM29jrwzM4k2mLZg80SUKKajzqz2Gtpqxc+QxD2Yu?=
 =?us-ascii?Q?UNhAFUHj1+sNTJiKOTyvO5H3z85kMHluCiLyI7lU1zanYybemnKTTe/GdwXt?=
 =?us-ascii?Q?C6M281FHRHtY57gigLDghJFwoGyJ3hyI6OOJ4HeGN5ynUHuuvqXoSxOl75dx?=
 =?us-ascii?Q?LkSO6O4uj4UwUJ6glJrMDYaOAr/yn9sRrXfKlVstcp5KCyAfLbqaYBJWY+N2?=
 =?us-ascii?Q?1q1C1FY986xKWNEja6v9cQq7J7dkgzem/j/vcOJtiZhIHIYtmmnCCOhcQ+Lj?=
 =?us-ascii?Q?F6V8NW1Eukdgh7FNdMPzuFg2XZlv35WKZXUdguswvkY9Ua1hfvFf88yj6/Y0?=
 =?us-ascii?Q?+lvpUZBmiSwNLEO9Zzb1qvbg0QCPv+K3vuNJ0Z1m5tsk7Qd3S+KZ2FyemsuS?=
 =?us-ascii?Q?UjynB4QXV7XPUjeW4JYncSjZn0oOdZGxCOzblCeQG1scN2dewBWQHpR1kEUR?=
 =?us-ascii?Q?s5AD1bm3wNuoS6sot62+efqlOiAGBIBcambuut8GQVSYgwTcCc0V4AqeCZ8X?=
 =?us-ascii?Q?xsVYMA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0aa2866d-920b-482b-d9ae-08db0abd3505
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 16:46:36.0229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KRQm0hluFIfDdADrdwhVF8U1XA6B/HWi/rwxCx0G+PFT1AgbXAYBkNLfcTSQIFqYs+RPAAL0K1mfYg3fSfjhODaL6hrR3pTWJlTsQj/F4QM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4452
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 09, 2023 at 04:43:07PM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> If the driver maintains following basic sane behavior, the
> devl_param_driverinit_value_get() function could be called without
> holding instance lock:
> 
> 1) Driver ensures a call to devl_param_driverinit_value_get() cannot
>    race with registering/unregistering the parameter with
>    the same parameter ID.
> 2) Driver ensures a call to devl_param_driverinit_value_get() cannot
>    race with devl_param_driverinit_value_set() call with
>    the same parameter ID.
> 3) Driver ensures a call to devl_param_driverinit_value_get() cannot
>    race with reload operation.
> 
> By the nature of params usage, these requirements should be
> trivially achievable. If the driver for some off reason
> is not able to comply, it has to take the devlink->lock while
> calling devl_param_driverinit_value_get().
> 
> Remove the lock assertion and add comment describing
> the locking requirements.
> 
> This fixes a splat in mlx5 driver introduced by the commit
> referenced in the "Fixes" tag.
> 
> Lore: https://lore.kernel.org/netdev/719de4f0-76ac-e8b9-38a9-167ae239efc7@amd.com/
> Reported-by: Kim Phillips <kim.phillips@amd.com>
> Fixes: 075935f0ae0f ("devlink: protect devlink param list by instance lock")
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

