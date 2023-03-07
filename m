Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D33786AE9B5
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 18:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbjCGR1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 12:27:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbjCGR0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 12:26:37 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630479AA17;
        Tue,  7 Mar 2023 09:21:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XSqU1Vaxn1A71jmt6ddX6zAGwFHiMcKn20JXj2bElaRSN5ja0a0YUFmPI61ShwMF7ghLGN+pydKcy6INbCmJmTOAe0V4yv1/BkGCbxVTZZuXjW/NDXttMnKrqsOmDGuMgCEKQwuR7XKUHlaCfa6sbMpVstYjxtun+0v4W1em/RUgysQpVgF6fZZnMhg0wL4DWvpswbDZTyHHxWv3dDrnOwZhG3a6FNINlCQLctOsIaasH909KUe1ZczDaofmgOgWePvDiGDjYlkRFzk5nsXMKCD2B/GIsvrlb6+MBRpEYlHtmPcFUVwS+bsKpqwSsKIThSc/lRnHoUHqkZVE59asbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RzNnw1MuTfIMpCnxrHUqkNCjPFtLDt81gzmGxj05USE=;
 b=ImCxoD1mbZliTNdnC2T8pElwJ6xoEijQs1blT6P+EIpMRy449MMTlPEZ7z+ZxvaQaXJN2etpS01xU5j+hGkR23xWsEWoJcr/jbQeJJzWO9QnbO6JN1JDir+CL2P8uuZ7UungyCmSe6dtQTTefWLVS/0dEaRlLF5T931NGkM9H1e86wYZOhPbLInrNVjd0oBf62rO90mufxpbubXX9FoG0HYHvLqRdCgEJeWH9xlsuP/MjzVLZCTEAYdRptjAb7QA/c6GMwU71jN9CAZZXHKdTy4FLSWtBSYZ0Cw/bdBBCL8mdvGXvnHASjV/yUdLKZYIo/cUkyQ2hUVNQsdhWICCvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RzNnw1MuTfIMpCnxrHUqkNCjPFtLDt81gzmGxj05USE=;
 b=Iq3v3c8uH3mdJGImcMYHsrH7ffPZFhNdn2j0tP++wNiFQ123A1QRf8BSIw96cTVy1VK4AYfvBoAEuRRuG6TDFNfnRZdrvkgK0AyivTJc/YMPVuNA7Hur4+082l/V5rJ3OKCFHyQbLE7kBmR95p2xLYLNMnkQXshMHpWE/Kc3Zq4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5683.namprd13.prod.outlook.com (2603:10b6:510:112::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 17:21:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 17:21:27 +0000
Date:   Tue, 7 Mar 2023 18:21:20 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/11] ravb: remove R-Car H3 ES1.* handling
Message-ID: <ZAdykH6hMtAa5QoI@corigine.com>
References: <20230307163041.3815-1-wsa+renesas@sang-engineering.com>
 <20230307163041.3815-8-wsa+renesas@sang-engineering.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307163041.3815-8-wsa+renesas@sang-engineering.com>
X-ClientProxiedBy: AM3PR05CA0140.eurprd05.prod.outlook.com
 (2603:10a6:207:3::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5683:EE_
X-MS-Office365-Filtering-Correlation-Id: e2a465b9-154d-4e4d-3832-08db1f306295
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O7sWGVk/O84tOQmkXy8zomAceqqm4F+KPt6CTRleDMDoLAW2i3shAckD1n5jIYe2fuuZonevBWvXE9I5ylSrPqsqEZ7jwZFryUdUhMA9xoYKtsnx6aj/GRMW+JyaS7cwnuFu0XA7Z4D9YRqeHUZXZQ3f+jgfkL/p/f5tu98qn7+mJTH4AOK8TjjtNEYYUUOip6o5FuwypTD346Z19r2bE1OqlcweQ7ioYCiOAPLLIvgh2kLuA8Sz/akC8gSiky6rwJubQvmeH8Q2eE3GifHGFaHQF96k2E1SN84NdWc36MjpXDC/rNqb57z9nzlq+8CHmox+0U0EUSkEgKbXmbNH66nvGSr7ZnsSgOcSxTNzwg5JFbizpqE5XxoVAtfZKizvBUkMg9yl9pYBuS/kaIEkpqdXwm++ivF0lKs23xCk0+bjDTRyiXGQKH4eFJAMgWXlQqACbD4lFgCNy1zMIRCNOTP6XPbIUD14mgmANBaDNuOlb/xJbH92gv71T53WzBkFY8RhwwrNoRo6Zhq28eye+yz1OWxqViPEYWL2VkRVuo6Y8fOHfdTxE1rGEr0WH58+j/wWCf/wKghQCt7M+HoGyx2ZdYG9JpGZoxg/LE0CqfYUN2APLgK5vuSArtxNGCQEDS7m42eo4COq8oRVBNwkGHZrAuOhjqbOC6amzerp6TD7HaRIyCMWAx8NEDiYm6nw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(39840400004)(346002)(136003)(396003)(451199018)(2906002)(38100700002)(186003)(6506007)(6512007)(2616005)(44832011)(6666004)(4744005)(66946007)(66476007)(8936002)(66556008)(478600001)(5660300002)(6486002)(7416002)(41300700001)(54906003)(36756003)(4326008)(8676002)(316002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zEczywK45NtEX42Vxp3TKOrY2KXrJiBtTXQRcRy3toqow1Qqir4of6CAnA3l?=
 =?us-ascii?Q?WZm5j+RW3hNyjGhTySLB10Xu48POr8LegBcax7n8xdxMP6B8D9MEviSRpEgf?=
 =?us-ascii?Q?CWqd8Q3b4ajJDVvlMfsv868j1aj5Re+dHgHVQyl10jqiUTWmMCiHAazJCoZw?=
 =?us-ascii?Q?LyxadzLYawiIbIQbIGGu3CYAUMfYTjJQ8q5ME13+6u+lKmRtSYzVz0/N6Hp/?=
 =?us-ascii?Q?j4l/8xeTrEvsuvT1b9gWFCLKVmh6WSl4YFjH5Goy7HPjGY5+QiNcqHzlwnca?=
 =?us-ascii?Q?cAX1+o/WFBRITVnWqWy0ncYUX12QMYVzp4FWKiLN0t4d+6fAmdqTus42FfA0?=
 =?us-ascii?Q?991YXNdqEKVBoXRGZq8oBdyj1baaA0ygVKHHWZOSMU/uLTgENhOhE1ggeg/C?=
 =?us-ascii?Q?Z9U8CNGM5Hp9uLLOOmQOaO/mbUEIg186Gd4AMbSPGb+wvtams/qCWvwjbO2e?=
 =?us-ascii?Q?TmOsdWcJ6BEVGsS/rA5FnoCaN14ik6W2QeZ2y3GpyBSxHaehVJ0idLEcePa6?=
 =?us-ascii?Q?b0PmjjqGMszxPoyYuk6GnSZCzfDeR7cKPHx4Ijt8LxTA4q2C8COWMmltS3fc?=
 =?us-ascii?Q?3qjygUFTDSY00NCbzszeaBgS4bEvyDayTy7ttcCeTwg1OojxAmXZc5ilfNpP?=
 =?us-ascii?Q?LMaHPwnf7Y0TY1d4z0AKWjLC5zf9jVAyBKo/ITG22/9rJEgMVm8nRIr6pxPQ?=
 =?us-ascii?Q?KsEPqjcDX7WRKtfTiqPxLlxWVdg8OfIujwHEempIj4orR/9WiU+3Gr2sU2nT?=
 =?us-ascii?Q?i2WIErGYQ9pZWqTbNp5ePHBfBXDxUTxsNBQBoWW6tAPaVZLUs6Ys5ufKl6na?=
 =?us-ascii?Q?Uxa+OO9UgsZrsUeKBdUqZxUzTCjfUbAIOsoACbFXDI/Ezw6Lk3mqwK334s0+?=
 =?us-ascii?Q?9Wa6/8LvsJnlJrzkF9yZ0fHVyWyZjSTfX2EMBeHKxO+ZF9NEZ6GN0PFyrKCc?=
 =?us-ascii?Q?3N6U6gEorsshI43yo0A0ywc/I8YoOo7JoJVOloV9RBqKnC0HKWPV5gfOgaf/?=
 =?us-ascii?Q?pdnwAFTZReJfg8WMcIiuBwByjUwJe0l+9JK0J01+nsXGcUfYy7xStwDJBY/8?=
 =?us-ascii?Q?yDNxR/VDwsFoEQajNzS1SgP+pM4tKVTVFxeQPfg902xOp/BY3eAOF/5dmWep?=
 =?us-ascii?Q?+WK5KvIzHgOIUvzTjvNmx9wnkJ6teTQXLTKmFzsuQWBopMNhjz08GjDxn4+r?=
 =?us-ascii?Q?vIoLDUk959jrarRqUWbJqG4Kyas7B2z9k7zh0Or1+klT70JKBsay92Y6F4Tp?=
 =?us-ascii?Q?Kyikdz/zNIkwK3KW4USbayVqSnxFJjyvLrAVrq1uRa4QbcIMmy1ShcfimILF?=
 =?us-ascii?Q?ym+KGmjmEDrRJKDzv75TsU7N8Knev4HEEb1ZBG0HbAbDnwVgYtZXPFoddynk?=
 =?us-ascii?Q?pOSqVIjuhhh8any9eyaVB1hJNFFv4hfEHiKXiJHHoHHbAZTaHtrnHhogdDFz?=
 =?us-ascii?Q?UF4kpbVWmVgwJAiU719SfyviasW56GJLJJxoL+82DfxiNQRrxeEQa5G8yiFS?=
 =?us-ascii?Q?Brcfaf/W+aVMpoT1Xwbl5hOry7GP+Rarnm1R1KK0wNtE1/1xucFKn5Yf4Jf1?=
 =?us-ascii?Q?sBGlTcT06M+upNbVCC9ARlbDWBZSIItjRsVfxi8dfrAvTpI0Vdm2ADyUtUhW?=
 =?us-ascii?Q?TfYi2nZ8b9f0TJrXM4Ys4DvTqk0eVdsFyTIo5wJkVlMqgko5E6QiaBhMfu44?=
 =?us-ascii?Q?qXdHEg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2a465b9-154d-4e4d-3832-08db1f306295
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 17:21:27.7925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BlucwB8iM5uYqkMEEKYRPNOeKqWN0yvtd23/TCKHmzpDY7qzFv3SnOaXOxH0ADedTI4bM7CPI9lMWmRPXud2ckte9wpz2IH0dg9KpsAbfHU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5683
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 05:30:35PM +0100, Wolfram Sang wrote:
> R-Car H3 ES1.* was only available to an internal development group and
> needed a lot of quirks and workarounds. These become a maintenance
> burden now, so our development group decided to remove upstream support
> and disable booting for this SoC. Public users only have ES2 onwards.
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

This brought back some memories.

Signed-off-by: Simon Horman <simon.horman@corigine.com>
