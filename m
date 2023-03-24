Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75D646C7DF6
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 13:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbjCXMXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 08:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbjCXMXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 08:23:30 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2101.outbound.protection.outlook.com [40.107.223.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987B513509;
        Fri, 24 Mar 2023 05:23:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dsYfbezXhMgb5ULnWEzSMtbkTXBBHwCyQZbPLk4yjqzyD6UPAewG8m59N4J2MZt7ZT1mpSRC+x/kgi1VWvUsJe/rgh6DFMNTHSDRYVP6jzt0FkTWumP4Q7Vnbgd0JpWeDqZrx2G6BF78RCjJRKgJL3DweAHFsk5Gw8KOhcA+CcZTfiu6xQ9YfSArOADDUDKt3TDnloK29VRCJoQi50o+UY9L0t5s/RM1bMos7fW9YaE2bLYlQWC2tUS+FFHLi9yTxeQnjqOErgXYulesxyr+tRHgKVFrdcoqdv32zRtCPDtskksDXwU61gzvSzcD9jLCIkAPAoEMpBcgwBHRE1lIug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sq6iBJaoufPXQAFwrfq3oz70LIXWhasabMvg/cxxpsM=;
 b=ikeavmivlu+cpKc/uv7K2F7g08JyCzIYeb68d+BSIuw5cantYVfSoWo8LxzVjgFtiQud9W9PZK6NDfp3A98M+CDIDP4PxczzEoxkDuXJgOLqur10uHD+m1/v36YggRvInaapsOZxxZRdkHdvoSMroWZrw/pAk0YTgsWDElHpUmbYaSjVnC3G6b0x3SJmgPeWquqMRygYGLZHhH6DQ6T+E8OjrJ1tTAKsnVv4akqTm2tGyWmlmRSY9IlmLMHiyx7Ub9iMiAlLI0pQROcTSCvE09GoZRsMRytlkD/q48llNs10+GGOjt50aiGS0TuUFxfedc1UOYltOf7NS6tEwXrUOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sq6iBJaoufPXQAFwrfq3oz70LIXWhasabMvg/cxxpsM=;
 b=BKmwhTP5CSPZqz5kWo3J0KruTzOQ0QUceiAXi3d2SH7EQkzvJ1z0wdmhx/RKZ1rMmdR5uE1bGviH/rbmzhfkQObNr4Sg0clR16MM+584SgGFTnu4z/Qne85Gq/DYKMNlgK0kbFRVptUXt3Yw8aREKVYlumH1SVaKyZcQyCN2qqg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4638.namprd13.prod.outlook.com (2603:10b6:5:3a1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Fri, 24 Mar
 2023 12:23:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.040; Fri, 24 Mar 2023
 12:23:26 +0000
Date:   Fri, 24 Mar 2023 13:23:19 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fman: Add myself as a reviewer
Message-ID: <ZB2WN97GGAa4zNjc@corigine.com>
References: <20230323145957.2999211-1-sean.anderson@seco.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323145957.2999211-1-sean.anderson@seco.com>
X-ClientProxiedBy: AM0PR03CA0096.eurprd03.prod.outlook.com
 (2603:10a6:208:69::37) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4638:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c404051-7c13-4ae7-97b2-08db2c629144
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PJqRVvdn6SlljSwgjAvDlmn8CKH+FX0it89mFirtAh7spBu1LqOW0ssGGegfiuNtGBfFvR6idgrrwX+R+DDzn0oD750srfTb8tn1PvH3NwT1EVhCohr90GrTnCB20L0VRCrH/SXIvDR4I2Yp2FsLu9/RtHX6jrj4VGwOA2Q2KBWqZOMcFcO8OTuj/tB6xI8O1Y6EFyEJ3A4W1bZTy8L6l0YLj/TTUz/nG7TTGhJpyYHw3GTKWUHyEizYFlFL88n1TeMkOerirZeKPxeYx3MhYuMey3HZeWqktcRnfboH8OTWa9QRDDufHkjC/8plEY12TN8BzISwWZeCWrVdgExvhZXnRVb7Q91GKRJazy7vpDidtMvq9Vwh5TElws/kXHhS05GpHUS38pBbnNKhAJIlPr/bVYLSEzaWfsEX/F6tu4WtCXusjyYzqTn65jF48Em6dsE7KKaGhan6cdgTOfYngytReIblfJT7y/yAyIke/h+MqPScHz2IE5MoPe6mpZD4d5s4gkQAgPUJve+pfG+VSeTEgi3v5gzQ+vsFIksjbmQ6es/OdetkYk9n/STOYB9sOCeVZIWaYbY46r2MnRgrA/TotV7UMlR/nAcx/d2HLmVX4FIh30BTXuTz1b4YK5mvuA5BEIynmOsCnglZsDR5tQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(396003)(376002)(136003)(366004)(346002)(451199018)(8676002)(6916009)(4326008)(66946007)(66556008)(5660300002)(44832011)(41300700001)(8936002)(54906003)(6512007)(316002)(6506007)(6666004)(186003)(66476007)(478600001)(6486002)(2616005)(558084003)(36756003)(86362001)(38100700002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QC1clmVja6NCGc9AWGPla/LpptehmWKQZoOwcZDCIuO5FtVcs3jXcjuwpSoF?=
 =?us-ascii?Q?U6ScG9Vn76NrSnl+cwwkZqMnTFt95K0h2BsseB4ymYUXx/T4pPBZBj0w2ISQ?=
 =?us-ascii?Q?vVQ8TCBpdqBbFtWF5cj9JZMEmKpO/hjL/VC8fFwNgPY38yXQetiiK+RpuBjw?=
 =?us-ascii?Q?SPIK7LXhDT2ve1ypd8n2Hr8YWytBfwRQZW8oXuxN02PFznJlZDAk7+oIrcJu?=
 =?us-ascii?Q?nW8zffnv7/+0ZG3+rTaYxm9i488hdEQs1yuMeaUxmDiwbZMkDpnWbRoeqAAu?=
 =?us-ascii?Q?DF876HFeHxpm7QL/MATL5iiFF/ioXLJ2w7frWmjomfK0L35uupeEALrRvigs?=
 =?us-ascii?Q?pHZp6UfhvIuY9x9hh0PjimTCWTwKJWAWxEhRdwyloolfPnqXaBFqlC2tQQrU?=
 =?us-ascii?Q?cjFEr5cGSuChm1aOJCE/oMHg7Og7/jvbF+pHVWcgMkR5fXaqI8uVkM/M91bL?=
 =?us-ascii?Q?DBxj3ps93+COkZSO9oPRWwY5OVXiom5QCOy8ARq+Cyd1fDeS5Rk8egY7qFjB?=
 =?us-ascii?Q?N9MaQz1aXbsFOf86L4CCTXAo094u7uFHh1eT7VQoa8cEFQuiB3wyu1pmYeQC?=
 =?us-ascii?Q?buAWmilmFnU1sBtRfGFw0Y+KM7mg+CNDJ5WIWI/I4y+SePlKdscOI3tIwEgM?=
 =?us-ascii?Q?AjZ0i7z0AUeJL+hqIOL2PiDkdf3sHYNpWY2Dc4I4QuU13ERuVZCoD5oeqNUm?=
 =?us-ascii?Q?eSDNTnWRYoM0FEa6Qix/Z2qWGxPG4E68L2K/fnfO/ZGAFknnwPwrby6zlNUC?=
 =?us-ascii?Q?a8nQg3ARPMEloSdJhNbOW/ds/LkbqQ+WHyoSIYNWa2kLRp7PW4olhUSPv4P3?=
 =?us-ascii?Q?SKgpXm1sKs/ekYf7ClPPCNgla92y74AIpcJGRGdpfxUhkwjQ0k2rKAWM6dnV?=
 =?us-ascii?Q?woasryXt0lTHCOBuJUxTVKXDkpLPSB8Vp4P05YkUIW3mnYfOSdBO3ut6xAji?=
 =?us-ascii?Q?NB6in4hkk+1+L/noerXDort7vS5+jfIXF5GNjQUswbnPieF3j1EL2vtjjq7D?=
 =?us-ascii?Q?zXPf0Hsup5bjvmdbEmRP2UKJhFaCsmKzFfQZyZdQDufQ5xTL4mH1FLZsm2uR?=
 =?us-ascii?Q?aURcgcrLz9V6UeaLVgKokG0V3qGA7hkhpsEPK335H4WYBOy1KgvFQlvwJR6b?=
 =?us-ascii?Q?ilcYIirfP5VjrPSSlnuu2vLLAXwWbluX6AyLm7Nb0Az8iQN4E/8Z+86HNaAH?=
 =?us-ascii?Q?sDQIqMeKRbRvXZ3Y2qnYTnQNYfSIryusru2hSG/bBajQfXOaMH0ST60hnjVv?=
 =?us-ascii?Q?mxSRMfqAQU2xNK99EzAlw8BFCgzQSoCYEURhkHwsPlty/gkgw/i7VfdmP3IX?=
 =?us-ascii?Q?zNrbwA27FKfy14DJTptKeHnDk5ovkfTLWSJK+qLp7QKjcifOHl4fxD1hYGg8?=
 =?us-ascii?Q?u6byv+8lFa6kBrdPgijibUGrzB0/80HFsxxGc7YGlLwy8PBVuIevP/mMpFlv?=
 =?us-ascii?Q?DjBwBjA8SntBpaQI3HATX2BdLXTht00CLn3XK33eiCKuhERVnlp3SzIqRmzs?=
 =?us-ascii?Q?MABxD4yxcHvpxlA70ufKrHtAAz6gtNvbMgENvT69pxOzcn2+s1d1+NKni4f0?=
 =?us-ascii?Q?92D/W2Dpu5jAMvVL+HQTvMDkAS5O7lkoV9ByW2KWd8GNPjGHGK76HwMjKizB?=
 =?us-ascii?Q?tMJ7L6fPJqf408IRvMRwLxiVopSNBY8iXORXH8Y1dLf1yPOqFCBm4Cqlqr57?=
 =?us-ascii?Q?lgLwOQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c404051-7c13-4ae7-97b2-08db2c629144
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 12:23:26.0228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /9ua6nvM1rFaYs43SErwLfxOurNJ2ly3QmFAmeyIjQiOxP+0zqgZpcLelwpEE/x2h062dSMBEl0kMfnC7CULb+33cpnEK2gf9TG2ZIe7nBE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4638
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 10:59:57AM -0400, Sean Anderson wrote:
> I've read through or reworked a good portion of this driver. Add myself
> as a reviewer.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
