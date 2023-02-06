Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3381568BC6C
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 13:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjBFMI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 07:08:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjBFMIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 07:08:42 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2092.outbound.protection.outlook.com [40.107.223.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F2B1716F
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 04:08:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jihtwFRviOBGoOqTx0JL20Y7kW7llt8S57gqWGKhNiZc+bYhndKUPbSxvT5L7yZ1POn8ftV/eIZIk3U0xU1/tcmeznSbOM2aavr6CM13ilQqKHTW7HXqyU66bPi63RdqKvIvlvpXsQZTa+SBoFm8plbbPZqMNgUMnh8+xzknG5iqEKvkqZ2G0frE8Z1NgEBrwxNk/OE3T7UsxYLgdvB1kV5/aDNooCSO4xaw1YRw41Iaez7u+1BnHS7+uxZeXtGjnmvaMNtvbfZG1G5b4tavfsi0ouJ/fg4Vae5AuWPwWHPmXcjA7+HIqWZuaitNJL2KK92S5wjxk658tanChNmZLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SjkpE28pxSGtnM5Pi76m8K+TEdbd58l2uT1b8ZGg+nQ=;
 b=AgmnyhHHfNU8EqZrtOcr5XbwX+XjvFI9VbyzIzyCKyU+J4ju53tos5rV21rKNgbHFkbhVQtCOifXCBbh4ajfTtil2jGA7n83fyxAbjURjgjXiTjVH1YlHAqBUvYZHlXMG+F2IMR29PunxQtslObj9mJGnv5KiCRHYN29VnOxqTxI+MhsbSUXtkz0mI4s0QEAtmrEQIgZaymq/2yrhr0FP34xrYf/22p24rrLDmJ23ndF51sJIb6CJ2JHzVP0EmrGXlctx9ndM9899NsjwVpF5ADBaqLHkqk1APNpOCAtKnTrJ6wzIY9lPP7wsmPzagVe9i3emoGTdsjp7SyO+2J+Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SjkpE28pxSGtnM5Pi76m8K+TEdbd58l2uT1b8ZGg+nQ=;
 b=meS3CMWVgUHvQYvsaBAxO660wbQ1SuUqwt+8kkReR38NS/yds1MeqJLaRPG+tDVlFYoNCv6m8wAkjtFHs5r727IA8RTykHlF5ySzpG5cP+gCYXcNrGMzH1u376WFGdjPrurWwKSI1isGZMaXxW5P3ZKIrWRYwBALK4Zd/c5pn7E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB6056.namprd13.prod.outlook.com (2603:10b6:806:330::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Mon, 6 Feb
 2023 12:08:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 12:08:24 +0000
Date:   Mon, 6 Feb 2023 13:08:18 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next] ethtool: mm: fix get_mm() return code not
 propagating to user space
Message-ID: <Y+Dtsn1bXTlu8cYR@corigine.com>
References: <20230206094932.446379-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206094932.446379-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM0PR02CA0009.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB6056:EE_
X-MS-Office365-Filtering-Correlation-Id: 811f790c-59ac-4b1b-15fc-08db083ad918
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uWgqbXHJGzz2fo/fU+HDobtvhnHNyx95qFqo6EikgGOTylMiHadmebMM8kKLVFDV0m8+XzDubWpHHTfdaxQt3pMEjF0wVj76mV5wp/5T/54MG13WvsDWYrOMhsthnAiutwUOHA450L1q+0kXfVu4V/CjMgopUG6vXVJF640pZTWYYRdj1EEzdJArh9cbnTucUbIutYjFAf6opOYAfYLzoBveHAcr7+/Wr8NEc+PR23vD9StDamhxZvy6cRIR1LFVQdHixImJ34TQ418CXAEg8G+W92lze3h0aDfRtPGVid4aQZzPp0eouCIF1MJVwvTaLPujvKrTg46m0DzAmTQglT+rlVkxYp/rHJC4CwEihQh1sGvVKb7gf3BrxBB+O0wZVrYUxw96n1FuZbtYVtvY9AgGdnj1bXcaGpqDVlymFgvf/Ih2ShKQoXEOyhtBWVWkmDcrlp06ghDgdoGIWfoIFa4+xlVCRVgGqAonf7dcL0Qsym/GhJawhmbvhrweoMuSJhiYJK2oCZ90gBYh36gA9iiXwsNoWq5sHqPth/8zYtDzL7enCbdWaq7fIxGPfSwlE00mn2j2rYMlDFDCUnS/Ij/U/bzC2uv8VGEsYEqGbxMsZbQKN6mnrnQeZNrcRjYf3cl2AwFB+ZQQQjsxkkpPLZvipD+FPygxSXkdI8Zmf0KgyiTPjIFU/hAHxid+44fy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(39840400004)(376002)(396003)(136003)(451199018)(4744005)(8936002)(36756003)(5660300002)(44832011)(54906003)(6506007)(6666004)(316002)(478600001)(6486002)(38100700002)(2616005)(6916009)(66476007)(8676002)(4326008)(66556008)(86362001)(41300700001)(66946007)(186003)(2906002)(6512007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a5GYYQXpCEKxiAyVLdfG5dO7rHxxZ8q+aDTTW6RQxi3hCGYSA1Yg6+btXeuP?=
 =?us-ascii?Q?0mE3F/lCWPEU/rkGcltuSluFhPqqttFyUzPtimg+D9W4Lu6VhfytOq7UmIRa?=
 =?us-ascii?Q?qcF+zEfYMltljYfqR20OBUwsKTbFnOf9JhcneuvhtUUaSkjwGzI0BJuky+cV?=
 =?us-ascii?Q?wWnijLfQ/YE4D7o+p6uOWiInreMO90aEm0z8uuKhIT7s8UmZBoVas81TczYu?=
 =?us-ascii?Q?Tkahdqgl564Lg/Rve9RAhXJl7lyXV2fiVCEkl6+q9PKYW59ejyRw+iTMz3iK?=
 =?us-ascii?Q?t15o1NhXAu386t7UFshHGXCctffGvGsHFssvBLPAVMVHMoC/8VttE51DfPhe?=
 =?us-ascii?Q?QRDsaZcyQt3ZxZ7uhplFjqASVkXEECrmXEJmpQWPgGh31V16fa+u4mN32xTE?=
 =?us-ascii?Q?0gBRkCV5EkGhih/Rtu8UNbg7pU7GW6xvWe76HalJCl6cIUqRO/+BNCVu8lr7?=
 =?us-ascii?Q?D1jfSg79JWaF8l2W8ZNZ5Xy8JB4WfhfoBDYy/3xGVHfhhl18BoFwfGlFOdfZ?=
 =?us-ascii?Q?WVUq+5guIab5AJxhoTaoaWHDZ3bdz+kdyrFD5W17GQwdZbq643WROv8UcKdJ?=
 =?us-ascii?Q?a5Y7vIQITh0J4EJIaznpQ5kqa4fOfvz9wTvdvAGPK1t6ka9RTNyeR8ARE4rX?=
 =?us-ascii?Q?NoWZYYRV6m+oMw3ySVwE+HIq51T42oc7Xz0fCRDeJtYX6VlyvWHRvrBsX6Vw?=
 =?us-ascii?Q?bIIz9Bi7rykIrHFISKIBox5SA9UfHlRom8Wey7xEH9jpQotNKroSnsYvD/Ia?=
 =?us-ascii?Q?3Tfdm2DtB+rtOrRNxgrIYoQ5e8HZ3SWg1RNiYLvjmOfGDajHGpbYaEMBhvmV?=
 =?us-ascii?Q?ECpNvXmRI4sEvHPUkPTp6FiY0fQAY7hiiH0WMAXtNnzNRfNBZTPxiVtQ1A/N?=
 =?us-ascii?Q?T1AdbHSHbJyX14nliBFQP32j27m4mppSy2ZL1H5EEvndmjz+vV3JZbgAuOz8?=
 =?us-ascii?Q?Y0n9lULmexoeH5UzvorAeMRp2NdLR4iakZEsxlvQTQzYvaFocg8hy+6bUmMV?=
 =?us-ascii?Q?rmrfk6k2595Yduri6gza0sRZyEjbfwio3S+T4JbAx2vjp6zGcVsxU1usjoCG?=
 =?us-ascii?Q?y452RI5zBq+O2gQ/GLQMgbwMSM4y4YXjPAKpsLYAfDo++l81aF5XZ+sjoFkc?=
 =?us-ascii?Q?s1BQRdNbr256urkwjvv0ixMNeemNK+vPBZZecXLuRpgM92kjGZVLWq0GnMhQ?=
 =?us-ascii?Q?miMQnsnXWQmRNu6qgnh50hKM72lXQTGQ/10MgpKOObq3VYyamDvk9HT9dUjz?=
 =?us-ascii?Q?bf5vlP3y31APRXhX21xx20yTvtMUEd/bTpv4j8VuyCkQ+rVi/y5WX50Pr0co?=
 =?us-ascii?Q?ltuMll179olbhvS/6itScmxLjSs+GTbcAv8woV+o9adiwSWdHodrNc/zY4tp?=
 =?us-ascii?Q?W+jvMFz9Xr+R6mET3eOlzYJNGKOZVx5gnsOp0j6CiO55643OmVCofZSAxj3A?=
 =?us-ascii?Q?zsuxl1aeyUZcY2YPNxMzNTq2bgTwJFhrbjvieFnvoCzPGpdRZyd9m38J90pp?=
 =?us-ascii?Q?YUaNB3qyjaCJTBaNCl5yiWuYTrspDPWm01VtOLafZHgRuvXj+g/Z/vvCHSkR?=
 =?us-ascii?Q?AbrG1S2KEQhxKYtA4DpADZARZ3dPEomXwl+ZT2Qab78EulZ3K+8asW7VRiwP?=
 =?us-ascii?Q?Hs0qKy31TFe2H1yuxp+sQUzmvrcr7BEAC0EjyPGX7/+f28AIqQmmu0aSaoWw?=
 =?us-ascii?Q?E3xP6Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 811f790c-59ac-4b1b-15fc-08db083ad918
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 12:08:24.8291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SCNazDqMXYiI3FAW0a/U1yGFexkiiF2AHVUJHPGBWOelym83DkdMhgrrzsKfqxkbfqXlofG6uP/p+9A1juTwze6PY+LdPEICNqXsK5Hq2Ow=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB6056
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 11:49:32AM +0200, Vladimir Oltean wrote:
> If ops->get_mm() returns a non-zero error code, we goto out_complete,
> but there, we return 0. Fix that to propagate the "ret" variable to the
> caller. If ops->get_mm() succeeds, it will always return 0.
> 
> Fixes: 2b30f8291a30 ("net: ethtool: add support for MAC Merge layer")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

