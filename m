Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED126DE11F
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 18:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjDKQkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 12:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjDKQkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 12:40:22 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2124.outbound.protection.outlook.com [40.107.237.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3640C49E8
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 09:40:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CKRDw9r0P6Fdw8mMkO7yQijQkupVHh18AZnmKQFs5BVzCLLD5zs9fYbIgwwJ0ePAevmSzPEXvI2Jcx/FJ7If9JBoYxyXSD2eG0aLwmcnHHH/MObKxRkOytOSR+1xmz2uifiYRbJWpeUnwAnLy/ebGnr0lv02F8NoROkVn0jo0ErYng1BjUj+WCGSaHmtHQQdKPcxKJ9W0oJUJ5rOApUF9wwM+roLAYpFE3LScU+NxboRuE2NbJYJGX+GVcPXEx0L/CY5C8fD9dwaOKW5eWpjFXx8DGS+KlJP0m7/EsdDZIuCoKrXAqfywlEX/eID+0u7yRiZU9WPw0vmzV6i3I3Wgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gtNqAT8beADYjbyfN9Q7gsUf6cAlJehv5+T5oPnRU7c=;
 b=nYnp94rVwQnctLPROEqhQg/WzDtErXJTxGhQqBbACZFQ2vb76g6xSMLiGLphsS6sYNxihRjErMBzd2Z6q5IRufqDO18TjKCgCpsavI6Jb9hLSwBEtMvQp9tyLcldcypFXXUCIsxE9egj9eXCbJboNCmWQzfe7M1h1n8+uu0hzCixPaYyX+OfprRvg43Co99R9OI9keK3Rm0xJ7sTcd2qQ8/MKAmJxRg2q23TwweP0bOkkjjgX+J8zOF5s3T7J89edoGjodOlQNoKY96/OcU9BnVRMZfj1nbkxQDIcIQK77iex4zSdfpswHVneqE9v/IHv+aSmNj3bDCpzyv59ttcxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gtNqAT8beADYjbyfN9Q7gsUf6cAlJehv5+T5oPnRU7c=;
 b=frU+k15ksjKTiXBlypSdUXVQLArZP9Xu2v+4A9WxbCsbIIVRRX+YIvgQyRgjeQ+LJNVXOJ7JyacQq1AAQkJb7T8HqnYSx0Qb5Tfaja+aCM2lTP1DYTtdlmObPHjDR4UW+OIKd2+npxgvozjBXqAbxoQP5zKbKubg34W7NhtUQNI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6169.namprd13.prod.outlook.com (2603:10b6:510:240::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Tue, 11 Apr
 2023 16:40:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 16:40:18 +0000
Date:   Tue, 11 Apr 2023 18:40:11 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
Subject: Re: [PATCH net-next 03/10] net/mlx5e: Configure IPsec SA tables to
 support tunnel mode
Message-ID: <ZDWNaxiakeiT9usn@corigine.com>
References: <cover.1681106636.git.leonro@nvidia.com>
 <6dd712b0868728fe08c3bce30d82f4dbb12638d5.1681106636.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6dd712b0868728fe08c3bce30d82f4dbb12638d5.1681106636.git.leonro@nvidia.com>
X-ClientProxiedBy: AM3PR07CA0126.eurprd07.prod.outlook.com
 (2603:10a6:207:8::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6169:EE_
X-MS-Office365-Filtering-Correlation-Id: bfb7ef5d-1b13-4508-dcff-08db3aab6f3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kWV2AHb4hEvX0rChtJdWSB8JBnByWcg+ksoeNV0x8Z2XID8vLWXxnUuWFwOyMXUrDXarDvL6Czk4oIpWIE3hn1C9PqImsUCO75N4h7Paa0Vc1coJjDgacqM//zE0yocZkofptp83TjaZkqak7RzcwUgMVhdXCvhKflfvEtismgCJstMdqzDUjAaWeAzKOeyyvxAOZjOeZRQ5w/OvuqHyk3tF+M2oVWF8lAUPvmTk4VkVdfGpwyM6eXZvCi5QL4tdqofN44h3stACGKQYGhQ9m4eXtH2bMrjo0QNbPZDrx5FvHjG0SAl0wpYbFuWbkn9kGwgsMvs4/hPOXZkqTWqAu+wTdFMvUZfjrXw+gO8FhnVmfwnnf6M2zHWCasVRQ2BCU6Xqt6h5MxZpuBB9Zsegvb9acgn/pjgzatCaSeal/avaI6Tpw4f5cB+Frj16GMG2B8SI/fHCcF+C3uxrtD+QzKEM4rPsDxHTnolpXPuhamUjAuoGea+/3yV5MHThLbWluT+5GUUuU2jHW49t53PhFaMOhFOBqIPQvgCNtBLxUQpOIe8F+HSUFE2Q3NHaat1B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39850400004)(366004)(136003)(396003)(451199021)(7416002)(6512007)(6506007)(6666004)(4744005)(44832011)(186003)(5660300002)(2906002)(8936002)(2616005)(54906003)(316002)(36756003)(41300700001)(83380400001)(4326008)(8676002)(66556008)(66946007)(86362001)(6916009)(66476007)(6486002)(478600001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bcuya+IBPgll7YkAqJ62HlmziFXh6dMn43zcYZIB/HeCVJAnu4AtD74CDibl?=
 =?us-ascii?Q?yB4LOCnz/6utbpJoIC4bqAmQSuECwj4ykmXSI7NExWdpySXAQTr8927TF7BH?=
 =?us-ascii?Q?//LJj3AXiEoyGDobXu6o5RWIUIdY/yUUzQsO2khCWzjVt34PPdaaYg++v9gU?=
 =?us-ascii?Q?okhep4bxXKPSwAL1eV1kDFv0gapr8zit/ca+/d6bHiPNZ+mgAg7M17QIu9Ei?=
 =?us-ascii?Q?7za1THvP0yteT4s8pfyd5L5/eWl4cck2Sa91ba44OQHiAER+vefh+slAH920?=
 =?us-ascii?Q?eXAhkmJYZxNVrmmK3yrwsuYzjxXjNwuAs+/KIZ2ZbZjClDh6NTtXQJln2HaR?=
 =?us-ascii?Q?yXey4cxRbIIs7rohmHMx5cUdLY6cjezNmm43/kTns6dKSYobQUGyuMpP/3Sc?=
 =?us-ascii?Q?gqzjDwUuYxTuBSvBc9X0NXiRQf2CizRejZQI8PHS0V1tvfJcFD2UrOof/qfV?=
 =?us-ascii?Q?znnVxch/w3jau8vGs8xSXTIoryINg4C61Q7wMAWaPftJNENDErHmQ6zzX7oM?=
 =?us-ascii?Q?YerpvJqmjD/636MituxSnTW8ZXxyxhufjZFGeHKxdoO0TAWK0HAcwLVhbjXy?=
 =?us-ascii?Q?AGAKaH3vsENkBpXEZYIIXOwD0Ns+NY+P0sOHmOHy07xlnCetTHaBMnFAmNw8?=
 =?us-ascii?Q?oikedw6WwO2NkbOkYSNFpSZ2zalZ14eQeEqGulTj3cemPsQhIWMH/IxYt63/?=
 =?us-ascii?Q?yyvnEmX3rAHhqA5ziOilYZ6lc5rKdfx3fEyTlXVO83YpkySX+DHV+Nt6fbtB?=
 =?us-ascii?Q?py0DEIAGFLd0xlnP61g3Ik8vJpVjF7HXZtM687yG/3RJfGi1lptbudYDEpo+?=
 =?us-ascii?Q?XBqOpALVZaJ1E3O4CxLFpMKSsWlYlR40j2svcd33HE0VIBLoDBZJ+kVve7LV?=
 =?us-ascii?Q?nnaa8FOGtivo/kf3A9Ngm4KJpmRd+lO2PuUM5gTuuwFCio+cZFHSJTICJz4z?=
 =?us-ascii?Q?/GLf9WtfyE24pM/xUQSrjCsoHCWZC1kLKYJ4x5VBIl8w8IGFHEkEIYpS2JKB?=
 =?us-ascii?Q?zn6TN3TY09nZNTvDV2y8TCKl36Gf/Ic2HHGaZPB9YXAuL75z7ooeeXY43D9S?=
 =?us-ascii?Q?mK1vMKgBdqmYn9oA8aM8d+WXNJeaMcMHAs1UxHTzjUM3WplIwKv5cGFCh7ja?=
 =?us-ascii?Q?DqapIP/fiNKbih1Js1TJ9A+URrXpHm9iuLPkcE2yirOXgGjvjXhv7tKuj8Ll?=
 =?us-ascii?Q?D+5Fk+dM0+Pa3PCrAKqo6lWway0oTeXrtG+ZwFSK6eoPHMa4I5zDc6OcAyk2?=
 =?us-ascii?Q?+1hT/OC68CpHbC//ZCF71P1JboHY45TJKumxDWtB2gkxeMYRdhF+HersyUbb?=
 =?us-ascii?Q?2I7LUnHdcGyVPQhSCcC6S6OpnQK0L6gU2Wh4DnbFup+kEj48YFWakn4mpKFy?=
 =?us-ascii?Q?fcu6ApdykzsLhJaqzp1nPvRA/fKWPZzx78C11+sMEVDPQxa1hgdYqiBmHotk?=
 =?us-ascii?Q?AxEklpi96Beu/VNo7hXprhNw0GdKnZ1M7ufNRw0CU8icIH4Eq4ICCvFhnVjC?=
 =?us-ascii?Q?DidpTwAmvw9KDZ9jcauTo/Af/WKONyxY2YRnT3klQzlhQh0MBWP+rJaRcF98?=
 =?us-ascii?Q?OLt9vDgSxG0Qt9/Ken3yE6sEtgcEbuQ1ugczdletqTEA7vntMjMkfkUeZH7i?=
 =?us-ascii?Q?iGbQyDut71B1QQONGe/aAjN5vwu6RbZ+5zjw4ktg2K7MYtc8GKfGODJErq6x?=
 =?us-ascii?Q?ZZZtsg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfb7ef5d-1b13-4508-dcff-08db3aab6f3e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 16:40:18.5226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MpKhm19DOVooJLKHadsIs/P8kelDGAPL9jtLrPAMjOATD30TS4VKVBnNWphOsLaXrLG1RG8ODaDs+EEbl9ea9Z7VlkxtND29z5qYN743Fsc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6169
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 09:19:05AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Create SA flow steering tables both for RX and TX with tunnel reformat
> property. This allows to add and delete extra headers needed for tunnel
> mode.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

