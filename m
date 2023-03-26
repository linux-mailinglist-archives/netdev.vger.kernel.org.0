Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2420C6C9303
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 09:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbjCZHyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 03:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCZHx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 03:53:59 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2123.outbound.protection.outlook.com [40.107.237.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5074E83FE;
        Sun, 26 Mar 2023 00:53:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LYxfToC+d9bJ1VonQqNePVaXJ0WkeXg5nqnOFP54IGL8hbXjOm+ENsLSmrZxEZzX45kSLSGKRR1IHLu8y4bebdPy0YTimP7XImxvSbLD5F4ME56bAoFoXQ+rwsQykcn16xcxaEUvMb346rjJo1xN6XANyOTjOn2yQHab61jYh2sx7qRR+7wWBTZwE2+Kzph6CHRuA5SzDZZDlkX452mEs+/nfY8j9RR3QtASOUgK4VpmWis0Uz1BD7uT73lAPCrkYdj6X5EqSTpv5H0a0mF6S/of7ZZRarfZNxOloMwJNLjxsjtmJf+x9kM8fZ7x7PlW51Zxiv1kSU0fZa3WTEIQJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ya1QWLihPYgGqivUFaUE5RbQxsob5P+OvpU0jbmrRMM=;
 b=L6kv2ccVG5Xc8S9SnlsWHmDCkIh9VltSbbHUOlUJrwSxsJxsBkKaF2e+D3ZO2wvvvmUlo1az/Bew7tVGrfTvWF0RlnnV2ia6zLUNzZeA9E4tBwZ8RWdbXZXIzTh0BTkdG2FNZNM2py45aJZygzsDfqeC+ktNsADqQ7zcl6jS/QcztHJe9Ku9p1R6zCjHsrBF4H7PZA1bljy83baTmN1F4SEyhYBTVxEgChXqWs9/uOGa1eqcrJljTUt2HiFAVLnTdOeNBMrzBf+rk9c8mSoRJVF5/XrVYocCFShxY3oZ2KfImEXeXbnQDXqjwV0dlvj0DlzGdF4RecSpkLVyGnkPhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ya1QWLihPYgGqivUFaUE5RbQxsob5P+OvpU0jbmrRMM=;
 b=HW7SbBu78rmT4WPJjL0FMhfx9W/FNj8DJ6E/A8sIxxThqIXjpXkHwOJ1mufs+l48CrVAjnT/+Q31qLAIknOZbcj69PMPeJfl08beQ8dOz/Vo0ncWSLxXDzJfCVVraSsMzUAasCcAIeCJXnATDZsieAbZPuuvWjqg2Of11Ge3bKI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB4471.namprd13.prod.outlook.com (2603:10b6:a03:1db::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sun, 26 Mar
 2023 07:53:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Sun, 26 Mar 2023
 07:53:54 +0000
Date:   Sun, 26 Mar 2023 09:53:47 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Tom Rix <trix@redhat.com>
Cc:     aelior@marvell.com, manishc@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        nathan@kernel.org, ndesaulniers@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] qed: remove unused num_ooo_add_to_peninsula variable
Message-ID: <ZB/6C7xCSqTEYvry@corigine.com>
References: <20230326001733.1343274-1-trix@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230326001733.1343274-1-trix@redhat.com>
X-ClientProxiedBy: AS4P251CA0014.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB4471:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bf78a01-6a68-4e7d-377d-08db2dcf3f04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qG0e+ylMnC0OTJ25D2fXVZ+ZDYuFypHXEH9azXA3EoVarrcAZDv4JfcT8qRrb2aUuafiqytYvFOdxXsS7/kSYT4uPix8tlR8JXGzXJGE3StfOKuEcDlz3I0mWvJhWLcEK2LJzpjFoZmEgi3lyLVFGXEgfCSRzi5MvSzNPjJwv+uCB01TsGwlbs0YUnHqwYgonmoi1XBOSDhlDUyyEsE4pSzphP1Yf81z9lfUS4bTXa7vu8lKrqLkfUJkQonYpHlHm9Qkqn8/zYqRnDURgMGvFnqNToMDgZgiLbMbT5QGzNc2W48NMpdC3HjNLhJDLaRxpKhBG7oq+O8TIYCWcF9hTW9feBPk82QIJx7M8mcVxvDR5epZWRds2gMCakJJnH/FqGnDjitRfeK6jfSy+iwjR5bKwW58Ls6fWltc8SY7k9fodyIJ2paeIiyJpWypidLYqmLUhBT75y5RnBbGfFl1YXMgQzpnZKX+zcBZQOVze2JoB7OIJmTYgC7iNEYgFuyLa2F664eVuoGt1pXDxCo8Lz0OWwx2ORHbWKciqZyH9VWTtQGr7fxi9c036JTcn72EGfa/YnLBmjzi+HmBmV0p3nhP1HvzE0CigwoayTT/Kw8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(396003)(346002)(39830400003)(376002)(451199021)(36756003)(4326008)(41300700001)(8676002)(186003)(316002)(478600001)(6916009)(8936002)(5660300002)(7416002)(2906002)(38100700002)(4744005)(44832011)(2616005)(6512007)(6506007)(6486002)(66946007)(66556008)(66476007)(6666004)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4MQH97kGB7/WAqo3eekpNAEjz3rbiUFxniDlDBEwmQmjbn++zuxP/Cdp6Y0w?=
 =?us-ascii?Q?OncKYISerzic3tx26rbMqglUKKgTm7Fm7J5nk0K/6O/7L5kyUEDAcSKdzjBV?=
 =?us-ascii?Q?LRF8nnnr6epjTu1TDzS4AGgQz+u4/fefFbv7zIXY0q4uBuX93X8O6db3y3xr?=
 =?us-ascii?Q?YKAojT/E3IGE2GC47aPIvVG+uikOXAvBtunxmH+nJM966+lyDNmwi1EOVV7q?=
 =?us-ascii?Q?WLgnqSdvKCEHPoOl51nvw96uL/EUZIc/42L+6JDp0vjQCYukhfdPEmnY7l95?=
 =?us-ascii?Q?h+5Nw8MjAo1ujP8FEMdLfe8/UPDOx3oBsqbIEMaMvTz7qs5IuARI/LoSRWQO?=
 =?us-ascii?Q?OhlrhiokeNwH8oQ2WCtqboVvfll3IBWSAJrtk/XBGapPZG9CQDkYTRLTWJY6?=
 =?us-ascii?Q?VobT9DBrPdQDI1l/xMxFW7vriV9u6kDzMiml1STlp093JXE9i71VCRof1vr+?=
 =?us-ascii?Q?PyH8+SmPTPq+PdTDxhhOrfaCn4zFEjA15+jUOo35ZXTDeIfxtMBLz1AeoT+u?=
 =?us-ascii?Q?ScBjyotSkQMear559J+FUtmJrQ8v47Ui9r8hhyB2v7tLaEGp7p1dzbXh6ESU?=
 =?us-ascii?Q?efTufbAhMQC6hTSPhF/3h99HUkncY7g6j6SVvstYkGvG14f/HaLgrlKtWtCo?=
 =?us-ascii?Q?Qbkkh9T9kwjV8C9addtXZ5ks5F3vauAgUYfVTVBvFaBSc4EbxmIgWTR7IKmP?=
 =?us-ascii?Q?z3CLhgALax3c6fRXdzx//RYqqc99PflogL77UVU8fYu8Mcf9n1QwuMkekSJz?=
 =?us-ascii?Q?wt6AHQyE2IIOVl9sp/JOlScCr56929ZJPjXy0vAy3F56S0ecPe2IRsHrdMb3?=
 =?us-ascii?Q?cKUVWDmak3c9JdBywzphYSHGMD/nw2MueUiaUneeqY42TGNl1om5CAzXKQ3b?=
 =?us-ascii?Q?8erKZelaOHarnpqTM3MTZa0LEONxoLI1fep7or5Zbo5qyp/Oa752siss0Fec?=
 =?us-ascii?Q?7zrzXekaJj+gqTq3z6QNDPsaMR+/UXZY5DDtgP04ne78j5+FoAm4QJg9Dkuf?=
 =?us-ascii?Q?A7GOIhh/R4XJKgXr40B/8m3TlcSUlnPAHnGox6md2TF3L6S0tEY8zrrGohhu?=
 =?us-ascii?Q?qhVekx0psQWSXr3tulqyXwUzRd96l1VaUK23tBjrqERp32lbQM9+DmwO7zCW?=
 =?us-ascii?Q?gTcwWq3YcBo3KddhEoJiGw1DMO3VyjFwXr0pkHO2XnQOUJ0Eje0FVdISXPJK?=
 =?us-ascii?Q?m0dYB44tNs9skLvPdZF+e5XYysPktH5pE3QOVyGPtNbymTAuQi+JIiI2LC5F?=
 =?us-ascii?Q?F/E53M7wKKTsAKnSkhIi3LyesvW0Lza5BvbHxEFPRolUkOjP/oIkw45Mxcst?=
 =?us-ascii?Q?TDZazx1XvbU6zK1EhHB2KN9oOR+3CEMd+Bzo9ajUBowAHsogJy9dPo5rOkXW?=
 =?us-ascii?Q?heAnADB2lTcI9iGj3x68fwu0RacI6PyaW+a8Dpb+8j36SWKiSpxMs/5t6wPL?=
 =?us-ascii?Q?AyPe5BKrwS4ZMf8e6Zd9WaacsYRVFGEhpU7F1cYPCyM7GMbYghgAslGICRvR?=
 =?us-ascii?Q?rk9vH5/8F9L/UJU85dHMrTT/dh4De/nZY3kOToDjJnws2glbDPmf3OYQqpuE?=
 =?us-ascii?Q?nv07tAMwMW0Kn3XaNTH4Ktjc9g1EuYtXk/pb8uvsxdhCnPk3hSwutk+vD3GN?=
 =?us-ascii?Q?4zfI44c5Yvh4livR8sNs9JRQksv4svkz6v52BGIgwBhj+7iRI9YL1p+CMKeh?=
 =?us-ascii?Q?/Tyuwg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bf78a01-6a68-4e7d-377d-08db2dcf3f04
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 07:53:54.4009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cv3xhGRF4LjwZ21Z3qrYPTDbA+xOT1pHp7sN1uOHKexgHC/Ig6OzKloxhW3T2rWgQSlqefpXKjt+l8Eaf3M7FhkJzM8HOUv5ELBnBA3EIvQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB4471
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 25, 2023 at 08:17:33PM -0400, Tom Rix wrote:
> clang with W=1 reports
> drivers/net/ethernet/qlogic/qed/qed_ll2.c:649:6: error: variable
>   'num_ooo_add_to_peninsula' set but not used [-Werror,-Wunused-but-set-variable]
>         u32 num_ooo_add_to_peninsula = 0, cid;
>             ^
> This variable is not used so remove it.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

