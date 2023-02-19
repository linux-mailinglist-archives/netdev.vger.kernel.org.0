Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB86F69C059
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 14:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjBSNbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 08:31:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjBSNbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 08:31:44 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2090.outbound.protection.outlook.com [40.107.94.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38785E38B;
        Sun, 19 Feb 2023 05:31:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ehO8TiDLIbsN2aTDgJ/WJ/SPM2Y8FTomO6Fk3L2LseLNpEqwFhk8rLiNsfJ/choRp84qI2MzW/O+c5P4k4+6yPL4aRETEZmJsom+/jAthrKxH9INQ6/ipKzUeRSyFFTNl11J82S7ZuQMtRUIVtk34rEa/+VETymcJBFLRwptwrGzoKGnz6nM0vVGcHTHbx92cmdPo9PKqigsHlZdwS97HizSezS1H0QXvoPfeeQTnoMxXGhT3qp1/B+nsh28MHe4hcfcR0hspcRAPJ1j69zOY6z485ilWfa2bYr83okWKgdDKZMav0eaSpgIGWF1nJCDS8fBcyeaOFqkIdsgezZvqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L6BdIlNBolGgKL9qvC8Gf9t6JZI+IHI0+SzLLPddW1s=;
 b=g88FcPzB0jhOL4SebyVveD4RIle2FxkNh+BKuhsx7/ewKQxFWRB08yEOoSGt2dkwI1z73XDSg1JwBdjn793Tj8elBukOf5iTVyp09ff+o4WOCdFdTJRNmyLfbh1Xhg/KSrthhd1gFkFnULvHRq02feViraS0fsW5YSsVrNgePMy8Z6Gu2nhDgH4FJ1d8cCrqjVSTMr2P89rK2WjqCNbVoNJy0iuuw/z+WUPZJdsi5vXt6Ea7ORSPbjwFZTqdqidUSuwXZcTp3VnMOuidiTi694RUzXlNfCe7AgSC6wt0RgtxxhJYF2KKGKeKQaDC8y6a7nF2PKTspr+Tc8aNdOg13w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L6BdIlNBolGgKL9qvC8Gf9t6JZI+IHI0+SzLLPddW1s=;
 b=BXL38M2Y1yO52qFte4f+drZsEStJmliwfddBH4DnRo8ILf0tfRs9t9p7tfdwyWiDvaWO7qnSTff1QP9Ggj+nGNT2ELj4KaXxZisI8EhoXHkHsNo9vTpUMK68v1z+9sInJkPNST0aijoZ0eNtJ3P1ndxA9h5z6Rfme+lnmbtKEjI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB4648.namprd13.prod.outlook.com (2603:10b6:408:116::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18; Sun, 19 Feb
 2023 13:31:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6111.018; Sun, 19 Feb 2023
 13:31:40 +0000
Date:   Sun, 19 Feb 2023 14:31:33 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        Arnd Bergmann <arnd@kernel.org>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>,
        Jonathan Cooper <jonathan.s.cooper@amd.com>,
        Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] sfc: use IS_ENABLED() checks for CONFIG_SFC_SRIOV
Message-ID: <Y/IktbtY0rz+SVuX@corigine.com>
References: <20230217095650.2305559-1-arnd@kernel.org>
 <f38d6b22-f846-5637-d58b-2d8862bc6840@gmail.com>
 <9e066063-a2e7-494a-9784-2fc37ef77094@app.fastmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e066063-a2e7-494a-9784-2fc37ef77094@app.fastmail.com>
X-ClientProxiedBy: AM3PR05CA0097.eurprd05.prod.outlook.com
 (2603:10a6:207:1::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB4648:EE_
X-MS-Office365-Filtering-Correlation-Id: a33aa7f0-6f46-450f-f0c8-08db127da1d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 87hZhD9PZFkKbzpUtCCouy7nyEOB3NlwsfW1h7vO5Er7qAp89f6/CVximDu+i5v95hFveFg5ifeLst7COwGSIxILBl0bhEEFMEuhTb22vzZ3gFceNBPPO+O2XDWSavVqAqpg2QLR1y+0C91P7ZjF3VmRu4Xd609Iyr4op7KEtaJls5N5fQBRZ5gw8WHXRbfQesde4s3pEkilUqjhnXwZzD7ceXRK1jyKqK+SJE3DBtH6pnVixvg66nv8Q8HURjbYNNpWP0FWa0Xm+uC37tHK7CsDF1Hw7Zh7mfZxaw/EcIXX9xq/NT0W0/efRULNAjI3RKA/6mEmrGlLnGcDyKY8OjwBXLo/WaGa+YQP9rM5z0Y+Sf9a0ntTMZ8wiuwnAR+jnMbHheWfDQ1m/XmNgKw+xKbeB0QHohAX2iqlf3gT9zNhiiCfIrpdLgbic2GYtUYygJAKWK849K/rNlXQL7+NF76tM/flt6piD7TPIiaa9orgQ5WBH4XHXQaffcbvbQ7+uxK4i4S8Iz6rJrBUPUFGoHxAY1hHgqi0o9hxF9v10/jkGhCI0s6kVT/JOeSMFIGBvsJs/K1xB8GaZjZjPoFPSi44QQz+eBA3bvb1APxCqCR3CdIfucxw8KDwktIYNpThxzepSSt74Dq9AaYw19C4RetWcHmbusrWbXOPYmZXWqnQ9CGklYJ0fwVs13XNgNIh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39830400003)(136003)(346002)(376002)(396003)(451199018)(186003)(53546011)(6666004)(6486002)(2616005)(6512007)(316002)(6506007)(478600001)(38100700002)(66476007)(54906003)(6916009)(4326008)(8676002)(41300700001)(66946007)(66556008)(8936002)(5660300002)(7416002)(2906002)(44832011)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TXWH9Zx/CzNGloByv87YU0QG9tfge8WwIg4ZxXWb6s6HKs0DJ0M28wsVWvF5?=
 =?us-ascii?Q?G7e/6reCmiM7+cIcY1adNqvtPsalnDHq8UrNsiRoVzEh2D6qANkduqlWwkWu?=
 =?us-ascii?Q?g6KXA/sefhGgb2WumwRBxd/cyZnQ3drr8r9wPFarIYGWtQQc8dmKZAVZjLOu?=
 =?us-ascii?Q?mYPQ5Zqky0f2RpPUuzoCMJ29AWCQBeCf+OFk3O3U5kz4W9bXH2C5vMcsG8D7?=
 =?us-ascii?Q?lLGuDpcw3ttnLKgtEqyFG2ge+5uiRErwNch0dtNiL69P8PGr3bcRmlj6x+dp?=
 =?us-ascii?Q?IyxjYCKnO+QzNTP/fb+ePBIMu8RgrFOm3EQcYLTc34m2w0cFRBdWb32GZ/8W?=
 =?us-ascii?Q?YJktz9rmV3GYBzEWwpM1MPhtUvcRtrSCftHZhaKwhE8lZwHJaKs1M1c7F/S5?=
 =?us-ascii?Q?Qw+vtPq7FsaG8/s2VZE2sOLLXtwJZK/sP7ED8KQ7vmj+hMMLBPrLiVJCm57U?=
 =?us-ascii?Q?Y+PHTm4g5T8qdQAybPasqsUBlOoXUB36r5F3RHFs8C+T1VbGBfXWuddxgU3E?=
 =?us-ascii?Q?9L5rT3pa06vR3AbSX1WvCdGp0/b2E6HQ4NVT1FSJAY9sSwOc8aVxjBOwdW68?=
 =?us-ascii?Q?VO37YkT8RANoTwuYtELxNhxsUzgLsP/VK/5mZrzEH76EtdmcfZcdgkmjWSsW?=
 =?us-ascii?Q?dhORlHybuMIqgY/R7ars2kUQUe8yPNIsQbkccLlqGHqI9CoFP49BevahFy4i?=
 =?us-ascii?Q?TT8ArmCRytaoZMSv1PI+fn5mGfe108Yr09lRHUSoEgwA6eD3Oy4gWTy5A3bl?=
 =?us-ascii?Q?qGFEcE/jvKegHHqsXUYmBA33BUyC/dMLDWF1KXRKui2Ka5yoG02wqFTPdRs9?=
 =?us-ascii?Q?zUMrLObygJ0Ls09JNiBbuJPLRiJum5rns0TMuUypN1i+Qw+ZPtfDkIyKXS+3?=
 =?us-ascii?Q?w3PnI6Qe42xATaGnZnQDUgBVsKFB8/pQgSeSK+PaZ9TVRw3VE/NyFEjrSmxJ?=
 =?us-ascii?Q?7fL3wsiMVwW+kBGNV9wwQwLMKMCI0aePZ5CzLP0+0ui3ObmRAg+jkt//nmU5?=
 =?us-ascii?Q?atbw6HS1HCtLbR7iH+UR8HiUo6iIMInfXUjK3iBEjuINiv5f+SHuusT/eDHx?=
 =?us-ascii?Q?CmWHlH51Ids2tsVCX3eY9U1egc0jA41e7aRea1j8zh/MaqC6y1aug0byL0MO?=
 =?us-ascii?Q?kEaG9Na9cqeXXuQKxpH6kQAhORmCEWPEnLU/1n30jKSUAvMQhgRyOV73YxWz?=
 =?us-ascii?Q?ExgRt0VCjfUabY3O2c5IaeSot0rQSzSA66W7zzMNIPMsuLqb9X5ENuBNAlty?=
 =?us-ascii?Q?tx298pLdWn4x8iUzJyyqOfbPjvEoW1WRaKj45/RWSx8s4fZfnAie1JZWgD7W?=
 =?us-ascii?Q?oOBq5SFbKFy/X4EbN3JZ7UXFDru3kNOYtRkSs56FtpmhGc9jvGQ+f0nIV/69?=
 =?us-ascii?Q?euA8l0jpUT2GcSt1ISF6flj0tfjScXO8zuFSyD8QQwavRWBOIHM9l/MNyKJf?=
 =?us-ascii?Q?vOXqp/klseDQ9T+3SpUNw4abEhANlrQZSmmhIE7M6Lv+UKtL9hgZnx87cfGn?=
 =?us-ascii?Q?XjV3NmzuMB1W/aiZaI6qgTxvun8Cl9N334iSSnsP1nkrD4nGEK8xIYlPi1lI?=
 =?us-ascii?Q?bKF3iE6INSvQ84eXtsAXf0CJ4+2cqlgoo09ElpTtzWASH02GL9CX2eeNUAbZ?=
 =?us-ascii?Q?ejF/rDHm8xtuYSqjipGhpp+XPHQpf+Xm0hqDm8bWSH9kG6RqRY9z6xL1Ndry?=
 =?us-ascii?Q?6gR8/Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a33aa7f0-6f46-450f-f0c8-08db127da1d3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 13:31:40.0321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MT8ks2RlINJCgPm10UqFf4QSn1hdKRbKWtfztZUC4kqxTwGyyUZVjQDaGhTWJs0lpdEHsHtshY82KAhMUbV+AKoE0CjEOGoOjKH7KKxdFB8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4648
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 05:19:26PM +0100, Arnd Bergmann wrote:
> On Fri, Feb 17, 2023, at 17:13, Edward Cree wrote:
> > On 17/02/2023 09:56, Arnd Bergmann wrote:
> >> From: Arnd Bergmann <arnd@arndb.de>
> >> 
> >> One local variable has become unused after a recent change:
> >> 
> >> drivers/net/ethernet/sfc/ef100_nic.c: In function 'ef100_probe_netdev_pf':
> >> drivers/net/ethernet/sfc/ef100_nic.c:1155:21: error: unused variable 'net_dev' [-Werror=unused-variable]
> >>   struct net_device *net_dev = efx->net_dev;
> >>                      ^~~~~~~
> >> 
> >> The variable is still used in an #ifdef. Replace the #ifdef with
> >> an if(IS_ENABLED()) check that lets the compiler see where it is
> >> used, rather than adding another #ifdef.
> >
> > So we've had Leon telling us[1] to use __maybe_unused, and you're
> >  saying to use IS_ENABLED() instead.  Which is right?
> > (And does it make any difference to build time?  I'm assuming the
> >  compiler is smart enough that this change doesn't affect text
> >  size...?)
> > -ed
> 
> Both are correct, but I prefer the IS_ENABLED() change because it
> improves build coverage. The resulting object code should be the
> same, as the dead-code-elimination in gcc takes care of removing
> it the same way.
> 
> If you use the __maybe_uninitialized annotation, you still need
> an extra fix to initialize the ef100_probe_netdev_pf() return
> code.

FWIIW, IS_ENABLED() is the approach that is more familiar to me.
Though I have nothing in particular against other approaches.

Questions of consistency aside, this patch does look good to
me and does appear to address the build problem in question - on x86_64.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
