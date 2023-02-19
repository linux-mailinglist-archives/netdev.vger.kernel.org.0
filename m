Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5944569C1CA
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 19:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbjBSSQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 13:16:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbjBSSQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 13:16:25 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2124.outbound.protection.outlook.com [40.107.244.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E30E13DE7;
        Sun, 19 Feb 2023 10:16:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lu7HqoCZiMF/xf6w+tg4jQzO0XCGvNcTvMHmg70b1MtFX3RBGaRVBXAkmwHgSrzVbSjBgp/zeysVL99pfOVhDLs25m6YDq9mdCrKMnwVNIiZqvVx+gzGDyo09K8AyxBHGMunTkqwE/OFHAOzpzDFxz5hcXpVxLqXCscrb6pGrA84ujAd+fqGtVkR//1DZ4AWsGMbYlF6os+/OvJv4vzfKI5DnYkuRtDcAaWLkd0zBDzI7VpRig8Oxvo1OFte56RZza1WqGSyXDlquM3uKDP25VpZl2a/GsN37oJx2S/Xj2IdMo7OqH6SOhdJP+TGu1/vIXmumdMYT5JPGvZFrD6+Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8eRlxBRFuk5woskR1AlVJUpBWdH7k1KqwsJVtOGIKf4=;
 b=SbP0COS7ohbCp3n98yiNcaMEdD62xl261hpIk1b+CUWfFoCHEwQJczgQrjaWVmQw9aZkydW/XjIjM4N9qa61Lz7J2obztKUJvyRJSWzNX5OzMOFa7iFp6CAg52CtR0Ww2AM0g8nBjAyYw1NcfjFx4ly26hrMVTBRV7wqe8Mm+uYavmh/op/fGXQJvd29camkmozpvSIJ0xJwlg29ofZ+O52CX0tQ3CVraNRDsye234BFPi8xQa9N+ZMuO/6B+9poW93BUIjXCch9fZvt6CskRXMckno5fCSAbXhO/dh1ybMOKZBdyQqwsKWCvSYk+hR4r3bPGZNlk0OC95BIAV6how==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8eRlxBRFuk5woskR1AlVJUpBWdH7k1KqwsJVtOGIKf4=;
 b=eauzDEr/jqHiynouEWpx7Z3RbX3AAyuM/NZRB2aKVTzmXhV1fN//momC66EpkA8/Sy0yBXwuJo6GHoFuqTFSuVfjDf5/0egCdtIFfd/NeHsUlo4fq5fO9vy+tDDwX3C+zdVERE/fTJFnAwrdhRgboeaG53YOqvq7HcNqWiKMszg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5951.namprd13.prod.outlook.com (2603:10b6:510:16a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18; Sun, 19 Feb
 2023 18:16:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6111.019; Sun, 19 Feb 2023
 18:16:21 +0000
Date:   Sun, 19 Feb 2023 19:16:07 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Tom Rix <trix@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steen.hegelund@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: lan743x: LAN743X selects FIXED_PHY to resolve a
 link error
Message-ID: <Y/JnZwUEXycgp8QJ@corigine.com>
References: <20230219150321.2683358-1-trix@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230219150321.2683358-1-trix@redhat.com>
X-ClientProxiedBy: AS4P190CA0027.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5951:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d91b7cd-b60f-401c-ad79-08db12a566e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sTAebQD9AKQ6GquPArNa11JtwjY2wLrVpVNXSbeussk7B0Fr4WwUc7Mn2NVJB73IhJuluxbC/s586MxY087Whi7B4mu6n8tNxFCXqrhTMFaQvhG64I/iImD1B8Wpvr/m5XWQw1SpWEICIBZp/5XjesmYk1LWns/ymd59dHZ7AslgoRi6TWK66ZbL24mXPY9cic0JstHLqwvCKHy7AwcSgq0G1Ehron8n2QATfbskX6tXIy7NtGuDQNCoupsjxQoNujtEMKQXNDbW2rC/DNFRUDbjcksUlA5AxzjwfjJaPcMiM+DpwyyegA06F9lF+NiR0YDzscTp7GE4wrezHOQxPyweD1jo8BcZO3wNcVZAb5mGQCvSGBU+6/+1eqKzX50a4cBPm9eUhrHurxH3Ynx59D4EtORWxbqobGU7iARq1FwC1hC8YMVggxvkgz1KystodljiE/81UZY+vVmhcjW5aEdGoipDlNJJX6aws00MjBnocbekdS2V3U0K6KBzkvDi0LzGbKBCTltHGAgxxZ8A34Bl+4SE1mEiUnjrYKwwdg1d+xveL6kBG9lEYeUJ0W4XBQPrCxnmD5jt81695A5pRkVLbdiNRWv9O3zs67cmJLfNPEaxkHwLQs7n7krRcqpTNUWvCGtxRuho+E6EPbYCTsTmef8OQ9LysV4yt3p8rvrGhQKGau4dLl6GSJxaP0i0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(376002)(366004)(136003)(39830400003)(451199018)(38100700002)(6666004)(2616005)(86362001)(966005)(6486002)(36756003)(316002)(478600001)(8676002)(83380400001)(6512007)(186003)(6506007)(44832011)(2906002)(5660300002)(4326008)(6916009)(8936002)(41300700001)(66946007)(66556008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nhzqCltk2Cufsw4KXq7vHys+PwtChi5agjDq6ObRppny20UEZU+i6ysgUcVw?=
 =?us-ascii?Q?lzzg62/IUJBoyRq/x9ko9D4uRR8a7vD5JIcx94s7nluCXf0kYe7IApLRha1p?=
 =?us-ascii?Q?6Pn/ui1wqJGu604yF8fv3dM7BjAiF/GgIHSlBj4Ddc+tyho2BL5igXACVnGC?=
 =?us-ascii?Q?emH++NEsZgeliCPcOT6FxIEMKLEwrmuOSxy8xJ0yidOQAKBcXUSeA/0Z5XHi?=
 =?us-ascii?Q?QQ47CoJur3dgfSjeuY14dorHB39HF1TqJfx0xrzQvVKd52mQg4s+1ryh4hNR?=
 =?us-ascii?Q?mzbggP2mwveu3QFu9FCEuZ8TrTpQ920Wo08ENX1P6tkkCMj0r9Pe2i9ze0gO?=
 =?us-ascii?Q?QMUL+q2/9pnWqtmeS+FwIuqJOam4YIIXIeVN48q7ARZBQGmg7H8qG8mX+Y/G?=
 =?us-ascii?Q?Ql5YOTr0BG/d/AvKW1s/N7Ll77ASn74aJoh1ru8Sqx9F0tD/AIsKDxU40yb2?=
 =?us-ascii?Q?6TkX7WiltmETcvp44zj4dpKZCXUsV9/IEebdmWlIVVxAJ6CAErW6L+H/dwl6?=
 =?us-ascii?Q?KuijyFAaQdQGt+MsglSMVDwLwKjt3MRDnIJE+2tZhj67o+PAnxRHUSgOpy/d?=
 =?us-ascii?Q?p2JcHGQ1zHOmaJ4o6aRXCx7Z6U7f66ld4w5lqcaxmNHpTDwkWjWjaPirDcrH?=
 =?us-ascii?Q?wZ8lhf4YIilQzWeEMEsWHjOz3i4yHYx9BeZ3kI8nEOo9t+brF/q23G/ihHAC?=
 =?us-ascii?Q?Ttmefk1lY9yfxSqVdgKUsD+0UY3LD3fNW3LpAzg2kPkQqqXo9b8GJmI6GpoF?=
 =?us-ascii?Q?PmIRg/Z1llPjAmKPWPwJnv+Sjbz8slSV2vRTLG8bbha4Qenz/0Gm1MabH1GH?=
 =?us-ascii?Q?Ahf7oDQAMrg+nFNM3hv5B6F//4pVeLkD/fhDtont6VxbX5P9Krv89GlL3phT?=
 =?us-ascii?Q?ub912Rf+7IaMYCf5hDp/7RzY2QfhCpidQZoA0iOpYRG67qWp4vGgXx0UHVce?=
 =?us-ascii?Q?cZTTC7gFuQWniqIC/geuE9EfsWEA6bQSFvVuaBU7QlQQ7MPE7/+YAJgf/Jq+?=
 =?us-ascii?Q?/kDhglPvijMYni5ySR6/Ia7x/1lDgxL20TrCh0y4sHAfqAyIFL+CKCcXRSVU?=
 =?us-ascii?Q?/KvZJD6KqO7AQnUJmc4RySccIJH1JhoUZ8cMd9TvEDmgXB2OzDocLrQUafWS?=
 =?us-ascii?Q?QedLnbVqmkw9Ty9vT9z60fKvl2NYYaW9dAPXtBA2JYPlFve9NBhTqPcMCurE?=
 =?us-ascii?Q?e3HcdXjQd+LxSW+miSOtxr/PppevDQDUMmRkZzPRrYeFc+hW22STY4REd0dF?=
 =?us-ascii?Q?9Bz9XyReu86HzBp1kc4Pl+ugypK44D+9HgBQk5K8JEpLeNpap+cLw0ZVOEjE?=
 =?us-ascii?Q?xVSUQzXy4rL0cHIh8d2N1hZ5ALSiWACXe6oAyVsj1O6lXTA8QrnAh4NBKvsU?=
 =?us-ascii?Q?yPlcNFumqo6ixHIIdR6lJhBbc5U/oIDdxYb99WGgojwqoeo0K7LV2iBADE+l?=
 =?us-ascii?Q?ICt+cIHphWL2QIwf/ClzDw4NeLOs8ISN3DuiYT8DtiATePGx4VmdVrmrYrak?=
 =?us-ascii?Q?9ckNFNKQMSQFXoZ1cxYcY/G0TVPDGNROati/Pw3lgdOh5Nbmu6bpOVnPXj6Z?=
 =?us-ascii?Q?EAQSaUUSAoBnEWfjy9V3UFeF1kGTcQ9xYS+nvcy0piKJ09E3G+occa7Zk7II?=
 =?us-ascii?Q?9rY0LSBK2uJwpFacBfuGSkj4yxq8sW+5V8YzkWC/cbei2txvsBOD8EydZlqC?=
 =?us-ascii?Q?xaVYnQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d91b7cd-b60f-401c-ad79-08db12a566e3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 18:16:21.1438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rpGod8OItbP7KgDcBPfnyEckjYkjhGIRiY5S1vFKDDtUAlpeENjOWyHv1Tdzyla3PaGn9NYiG5n60o36JPurKWVEUvlCnvEGUiOGaH1lVCw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5951
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 19, 2023 at 10:03:21AM -0500, Tom Rix wrote:
> A rand config causes this link error
> drivers/net/ethernet/microchip/lan743x_main.o: In function `lan743x_netdev_open':
> drivers/net/ethernet/microchip/lan743x_main.c:1512: undefined reference to `fixed_phy_register'
> 
> lan743x_netdev_open is controlled by LAN743X
> fixed_phy_register is controlled by FIXED_PHY
> 
> So LAN743X should also select FIXED_PHY
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Hi Tom,

I am a little confused by this.

I did manage to cook up a config with LAN743X=m and FIXED_PHY not set.
But I do not see a build failure, and I believe that is because
when FIXED_PHY is not set then a stub version of fixed_phy_register(),
defined as static inline in include/linux/phy_fixed.h, is used.

Ref: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/include/linux/phy_fixed.h?h=main&id=675f176b4dcc2b75adbcea7ba0e9a649527f53bd#n42

> ---
>  drivers/net/ethernet/microchip/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/microchip/Kconfig b/drivers/net/ethernet/microchip/Kconfig
> index 24c994baad13..43ba71e82260 100644
> --- a/drivers/net/ethernet/microchip/Kconfig
> +++ b/drivers/net/ethernet/microchip/Kconfig
> @@ -47,6 +47,7 @@ config LAN743X
>  	depends on PCI
>  	depends on PTP_1588_CLOCK_OPTIONAL
>  	select PHYLIB
> +	select FIXED_PHY
>  	select CRC16
>  	select CRC32
>  	help
> -- 
> 2.27.0
> 
