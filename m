Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4AC56BB919
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 17:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbjCOQH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 12:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbjCOQHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 12:07:45 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2103.outbound.protection.outlook.com [40.107.244.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F8FF7B12E;
        Wed, 15 Mar 2023 09:07:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bGqfPzbHrjAbz0hmh29x6tRe1DJtqSXEPkZvEJPADJLyM90L+z4xOk0MF5IrjgXZZ5ZJLV7vooGXUa+BSgoTejv7YYxN0Q8XZwnm2FkHbohAIjJjA74yxZP8wKDt0sefxF5VWamG6SzG0qCdrdDkdxQSNloqbGctfIY3KUcKtDy/S6nvmN9HauyOJjEJctSPvo7mE8v5qkiGVsepfAtu57D4hEKV6rGKOCpGWqCdysBEObNzBGKadzlzXAvMhaCYDQ8ZcQuUwAJXgLnjtFzV5+wURcsbmeMuaVus6N2UVMHV2Rp0+Ax89GzN7CbCYKd4ZXOjoef/J2w1trXhetl4Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HWLTNF8dSE5PxKvSsfOvbN0kuisFw/R365WaL+CutCo=;
 b=XxITDzNrnJRtwLYa0+Tc26Q2QCqa7afgB3d4AW3ouBvvUtRzpG2mvbybG5nSi+AaHKbpaKB8uzVlW0exx5f0SgjxJrv0/8Y35G/XCJG9b2+w86ictyusn1YubkVvZl1vm5DQkyxE1Ld3xFz6dv5LzlhsitB+Dz3j4tifBh5qvJNfpv3oD+XhPuAFOhGlYogMgvR/IL/KHIT2/DxWET1l+8xSfHluTI2h/Y6Hnl7LAa5hCbQ/fdGubsLI3P1yfiuxANC9rIqJ2U1SB29FhGwoLEdbQq0eXQiW9reCEQAznZ1dYT49iYVzwoenSY5YlX6HcDLzP585Xs4ngRT4hFFAug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HWLTNF8dSE5PxKvSsfOvbN0kuisFw/R365WaL+CutCo=;
 b=ELYCM1S5pWN/DxxYf06E3IynquKR69NXHVt/hIhc5ECQZp9F72URsOEfoFw09eDy/drRUeM84a9rd3j1+VKO+IbXKEjENPzchysnnphT6zXjKN2I5AhD1s29hpbSoYVn1hcE28YNwbyOglopKfMGZiZH/wyn0uURCK4ydn6nlMc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO3PR13MB5814.namprd13.prod.outlook.com (2603:10b6:303:172::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Wed, 15 Mar
 2023 16:07:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.030; Wed, 15 Mar 2023
 16:07:01 +0000
Date:   Wed, 15 Mar 2023 17:06:52 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com
Subject: Re: [PATCH v12 1/4] serdev: Replace all instances of ENOTSUPP with
 EOPNOTSUPP
Message-ID: <ZBHtHDZQmP8f8aio@corigine.com>
References: <20230315120327.958413-1-neeraj.sanjaykale@nxp.com>
 <20230315120327.958413-2-neeraj.sanjaykale@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315120327.958413-2-neeraj.sanjaykale@nxp.com>
X-ClientProxiedBy: AM0PR03CA0084.eurprd03.prod.outlook.com
 (2603:10a6:208:69::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO3PR13MB5814:EE_
X-MS-Office365-Filtering-Correlation-Id: 29aa0ee5-7e2d-4be8-084d-08db256f4f5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O/D+LBxcUyMwly4GZxVRGcGU/2S9sIe+/6KKlhRQhHIWdiqAcuP7ANbvyw18mbV1vZMhFl32PNMFCx0C/yNgpDKaHUhQ6w5ZcqY91UAvyLCkI0lzub53adfTNXn/1+eWCNXlmiszq5744o/IpfU0Y3+rYcinCui9pI8F/VW4OFf8YamxHu7sF075spX91BKX8NRmmTYMxZE8z3ZIFFIX7CkEC7TcOSNji8MbGR/H4P3n1UPRubWXj8C2NPX0vtvwiOZ9bQMPFSblrFVpvldhdb+yofdyQ6lMy8Wj4CeDWVPONZzGz9dk8iC0B5z0pjDtlsnMw1m4LZNU5couKEA/ZrnKY3YmqMUYS1C29yn2X20Hyaj/k8oHWpSAImBQhJo9nhrYfiiXn383vsYbrS/d3CezxacnLxlevsBxivSzxWbm0S0huHzvPJwcLRoLucnUPBqd3vRQZezFYGaQNPJ/MSvHdEF+I+MqXY6jrncqAdreOiKA+eH2yOtN1e+WKSAi93uUrkHiHtJczkKdJpgZgW4rWo0OewHN01aOojp9fP5NRRgaBDl2r4QTzPSzlFTagAcXEHglo5s0rYWZOFNYYm8cLxPSVGji0wuf6A0yfzWGW10y8GIYWZB/67Ix63kucqAcR+TrvgWsbDphxNciFcoK+noVHjlR6zIPhs/4aQSJaByq9M3aOowpMwd18k7D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(346002)(396003)(366004)(376002)(136003)(451199018)(2616005)(7416002)(186003)(44832011)(6512007)(6506007)(8936002)(6666004)(2906002)(38100700002)(4744005)(6486002)(5660300002)(66556008)(316002)(41300700001)(8676002)(66476007)(478600001)(66946007)(86362001)(4326008)(36756003)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SVrHup/86o9avuqD8tZp7NtiDwVgHKBB6LYW2Qyh2P30aXr1ywzWxUivdud+?=
 =?us-ascii?Q?6+LLBYbotvluOSKbEKKygH5IDeO8P5Mxm+6GFms7O2apkcXwq1/DWpY8hNCO?=
 =?us-ascii?Q?+b/jRSON9SMvPKTxD2yiDiGBAZCQI/P0KgPFWAathvXlgdCbrC43todqnlHX?=
 =?us-ascii?Q?xdcg8tQrJ844GK/mJpZhNy9hwpFeT6eZPx9BIuNFIOvsynmas9wvSND0yINO?=
 =?us-ascii?Q?ZPmO9mLToZxIAQSmgdp9u3QnD6nfapT2CZuNORuB7qmPi1PZLxTv/+VhVB+N?=
 =?us-ascii?Q?0+KqO9Wnsnyw8Cp0tQWiavqD+pS2No4mdDeMA65b3aCDpdm4aFLnhPrRQc25?=
 =?us-ascii?Q?HcD4Mpi7VdGOSG3mLZlcryvB5nYk1cvmmD0lQj1pCxU7QUEipjFDAU0uxywE?=
 =?us-ascii?Q?wxsAWn++qOsoJgw2p2QbNjvLoOkls3gprgoMnfwTiPD4JrSJ9qS6gxcLO83A?=
 =?us-ascii?Q?f/KicuKnSrACPNrywLW7N0BIW3KT59YfthS4kygiTs7PAAGjBVjLeCX4zyVK?=
 =?us-ascii?Q?z3nWd5LY4/Gp2up+2G6t/Zd9SzfwkIhCi4qgo/ljkzYAaOvjJLktIp3JwwS2?=
 =?us-ascii?Q?gL+QMomu3hWlxvdouShEdiKS/Cu/ZGNS3T5Ph5aRm3BEQFW2GVz9btSxzyMK?=
 =?us-ascii?Q?phB2we/xzDzT5paZizyRWOTFvMx09UGpd+/WnS8lyXXOUsYvYiLLfGSNXm1g?=
 =?us-ascii?Q?CwLiAnil6w4s69I3Z5RsDN5D/ADHBZS33lXnrbFdNVSkZnVv853zyRtANueF?=
 =?us-ascii?Q?JN40MwtbMzdXfaKE0sHb8NGHDcIPDL8WArDVy995rZHDPApUHoIWNTXCVDlW?=
 =?us-ascii?Q?/9DE3zZ+XW2zNmNtDRl3pwxEbNFHdyMY1EfvXdAsZWd4A0wZJ37fhx01AIhm?=
 =?us-ascii?Q?0V5T1T6B6JGa8qBwRqDIg8r1x9PWLJQu81MfGnAS4/laBU7q9gjDqIU3TVVT?=
 =?us-ascii?Q?OLEcN3zvpEe+t2cZK2Tc2jbIAXq4KgQvo9IsGx/nKwt5teePdwj/qLL/KeuX?=
 =?us-ascii?Q?EUaLTLTnGumKyWpRL6XT0b/6GfMZV1INbdG2xRwl3kdEn+MML4AYCrJI4Xzv?=
 =?us-ascii?Q?QGMrf6mgppnyDVjCyLJ/8OfLDc74Pg1ISP0q27z2R/izfWK/a/MP1Qe3uqm0?=
 =?us-ascii?Q?QSQhWIMyQeC3VVdWs+G+Z6oGewUcAZjn4xQere9vM+cTULN0+y4nurcbigaJ?=
 =?us-ascii?Q?VK3cbmiPStdkr2jcMfw9u0lZRBMMFk3rgyubS3jMsQOWiwrBpFd9/Cbm80DY?=
 =?us-ascii?Q?PWpGYk+SOGcYVLjHQl8rklROClK91m27XBGbzZFguQyS4FVuza6H37ipiBJb?=
 =?us-ascii?Q?4/+AY/KP+IZgL4mT2l1/5iY29nORubST7KYUQKeTehkImQTzTvJ7WPJm8qZo?=
 =?us-ascii?Q?G11QlT8WjpC6f2DgVTy+3Uw02dY5my2kXSzKPXRk8qMxC/SGWiDqPCRzHvM+?=
 =?us-ascii?Q?rYDwXIsiSKN0hnT3968Qsf+iIdqD/S/moG639bumCf66sTXUwRZABZjBxaGY?=
 =?us-ascii?Q?BH/wrpyan44yoiE+ztff/YPRTjQ1I9/oP+odFO8SfZ6LuGag5Ejvb1tGns4r?=
 =?us-ascii?Q?WqBRlbV+6ryQuyevNo6cRtjcrfiyUskZ9M004xytH0mXWI+S0n5IOcwKAMnV?=
 =?us-ascii?Q?Zf6iRDiMkqMp3MaZFlAgzz/TV/mYXQaVZgQ5nPS4Xm5EHFlIiDr70KhdAgo9?=
 =?us-ascii?Q?u2gNhA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29aa0ee5-7e2d-4be8-084d-08db256f4f5a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 16:07:00.7986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lh+rcsTdN7Y3jkOOEBgpGoObAKVPtGu0zqA553jx4O+JyaxUHgcj37/dX6uegrGQeBdoyUMh7VZYw0CnTRTn2kohzUKdcVGZ6/wCBB9aiC4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO3PR13MB5814
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 05:33:23PM +0530, Neeraj Sanjay Kale wrote:
> This replaces all instances of ENOTSUPP with EOPNOTSUPP since ENOTSUPP
> is not a standard error code. This will help maintain consistency in
> error codes when new serdev API's are added.
> 
> Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> ---
> v11: Replace all instances of ENOTSUPP with EOPNOTSUPP. (Simon Horman)

There may be a policy or issue here, I defer to the maintainer on that.
But from my PoV this looks good.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

BTW, please consider waiting 24h between patch postings to
allow review to take place.
