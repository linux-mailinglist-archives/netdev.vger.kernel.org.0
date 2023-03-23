Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 507586C6D98
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbjCWQcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232076AbjCWQbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:31:47 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2099.outbound.protection.outlook.com [40.107.220.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16782B2A3
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 09:31:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YncAp5pxqh38aqFzNnBKt94jXf6xsoMjuMQbTZLp6mIfEYbdfOPpoDLmxY7FuF6W7252v1YHn0RDQg/huVnICBagcLhKU08RAZA26obb4Du+w/2hf070F0E/fFliKfrx0+EY7D4X+Mur0W1mSLCdBcfFHP9jbGk9N0lGM+62Q4TrwBX6WWneubVuVOP8NbdsizujGbGhAGe8ZVH6GlNP6P8P3CjAcdd+RDy5wN2B98pG8SNhLEXdzq+BU+6kpdcDhEtXlaplO1c0Zztbqpo3b0nV8mAXe6DL417Mi/xBQeyBRTXhYUils2yBfEPJRYxNYeyH2enQa6iFnEV8YSeEHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fldUWIuDT08sJrvqGdAeWKSkjO4kNcvmigqqtizdZYQ=;
 b=hYt8kohZd3aTXmkuVNCYfHrUibwSjc7ueBS9vRSXHmvC3P/wvopQA6jpZb6J+JigH8nXOKR1QzTs4eL82IuITtAI9rBmxiNxfLQACZr5xLgHi0fwC15uR2CjUf39tnYtPSgOjYX1hO4ZtQcS5NlP4ZSXXlNzEnoLxAWQ3AovtT0t6ebPOlhs9M0fvAxFt6HTLxwAACwIVwP+6MYN2kflYW3Lzm7RvRMRqcpzqEBtRyrbIcICViVSckN4IIKHPg4JV98fIWw+jkXyrX2ky/nVns44WP6igSUOPVVfIjurVui0E0F3g5vxMbnYQADmdKCxFhRq/YWxxK96XwnOmnufhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fldUWIuDT08sJrvqGdAeWKSkjO4kNcvmigqqtizdZYQ=;
 b=s3hbR4BuaTG2YrNGZHABVl8BZGejOB+Vkxv9bXqed8vRhioAH2AMozSu4Tv8YyLL98s1G4S74sWjG9darDKDNcXtWH3V3YifgBmPhTwCHDYCQJBVNBWQX8d32W0OZY7OIhET8bBHv0oDA+t8oi6XpdFjf5ezNciTBT0k2gz9Qug=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3618.namprd13.prod.outlook.com (2603:10b6:a03:222::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 16:31:06 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 16:31:06 +0000
Date:   Thu, 23 Mar 2023 17:30:53 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Josua Mayer <josua@solid-run.com>
Cc:     netdev@vger.kernel.org, Yazan Shhady <yazan.shhady@solid-run.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] net: phy: dp83869: fix default value for
 tx-/rx-internal-delay
Message-ID: <ZBx+vdcrRgRwGdnC@corigine.com>
References: <20230323102536.31988-1-josua@solid-run.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323102536.31988-1-josua@solid-run.com>
X-ClientProxiedBy: AM3PR04CA0139.eurprd04.prod.outlook.com (2603:10a6:207::23)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3618:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e7fc339-273f-4ce0-99fc-08db2bbc008d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HAaumN04LvLDOdc7DOsTROXjgPHi5YIru1EN7EGENrud8IGLxOPadOPvZtsrrTcIT6u+l9xCzAePPEPlzRtO4yTkzBlOh1dN70YS/iYYVdax/DQmaYeRJTZpMrPN04DWE/uZmn13u1Q0VCLIIQ+ViOlB0azmHwmdhtulX5cdwHxT/anDDqxYF8CbIS5mKecpqF5Q9nxJUGI1JsvxDBCgyeUHsYsMokF3tS8WUT+3HcAVuXvEFhpZpTL9P0dTvdRK0SDUyi3mmBl8MA1YUAPOPI1fMry0F7mUBYszqxqRFoiJjMow2taVcrIvi6LLX/qSJHx4YxCbaAWgqKls//nAKsnub/0Di2dQq+2fQaLuiIHKOerZEyO+pcwnE9PuOQL/Th3IZ8BSlbBvkjb0U8S9ihv+7Bj3rTC5Zu8Z4hUvtHVpBB8h/rkt3at94VQHwoPYnrvCmvBjPuZMADJO4Umg1P2H+2ybo8xE0whTQo1/cPVCA9j5MYBhQrLSKKrohbxa4TReMbZY0rUN8QPKa4G+C9CIQDZp9EvAnp3rNCWBrLqhJ1kxEFvKhC2Bo+GfZlQ2Ooakyur1tGc04Cs8Y5ndh/W8aQaqXHo2S2FVhA90vozPJ1gTGP7DdO++xWwYPX1QR0mfzybYacqE4t2CCsuSXWXk+flmSfLjh7eJrE1lauKKpFm9EYdSGW1qrFmpsB65
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(366004)(396003)(136003)(39830400003)(451199018)(38100700002)(2906002)(478600001)(6486002)(83380400001)(2616005)(186003)(86362001)(36756003)(316002)(66946007)(54906003)(6916009)(66476007)(8676002)(66556008)(4326008)(8936002)(6666004)(6512007)(6506007)(5660300002)(44832011)(7416002)(41300700001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AbasifDIfOJxun0XPqOj+LP/usJtsums7J9cIcTSB0W1oYpBzHEeXUnKXq1v?=
 =?us-ascii?Q?49+2D24LQo5Vep4WJVVHtINpXGzP0ZMPNU022RYX5Z1130f31Y/FMF7Drx1g?=
 =?us-ascii?Q?Hlf63J1cHHY/1HLTLCbMHBPptLJ2yVPz2/AckADoh4IRsBkM7Q8PueDT+8Qa?=
 =?us-ascii?Q?fGr0l92huojNhDKtlHObrfW5/bDF4DE/u5Io1GKN1GtXbjffhgRXwln0iJT7?=
 =?us-ascii?Q?3QYWq9uGiFF3k5xfeMpYPoWqOf/pdgoOLdmdOMuox2si+R3k8Fo8EH5rc+YN?=
 =?us-ascii?Q?5PMzJFs3x395oF7Mm0yiLwFeve+ytujGXGESVtmJX5/whtODR2anfZlPE/L0?=
 =?us-ascii?Q?sYR9CHNA7yDYx+pZMIBwSNCxNOn8laizgO83RVbwrywqG0K2tc3moNtw7ant?=
 =?us-ascii?Q?ZARRqsaiU1m6fiqYeyqcCJlT0hUHJuFHnIWABnm4Lp34NUjjRd9HkrD+KXpP?=
 =?us-ascii?Q?TKev9ZrLJ6aqX2CACdlbfHZeH+WWLTgXSabBcKitzUxIPPeVL2fOViQbLhh+?=
 =?us-ascii?Q?xFFrYQYTqoTDvztcJOItE+nt4zOmTm+mkpIqd49aSz5fXWoe7N1dUbjRP0nv?=
 =?us-ascii?Q?UVGe+cqLjgXFi9+qLoXqsceq0MzSjM7Dn2b8srH7RQv+xH8OrdpU4oLtDis7?=
 =?us-ascii?Q?aypYuSYedX58272J41/osMjPGXAtDSdXlFnylCy9FPz1r0bcLEagZ/060z/1?=
 =?us-ascii?Q?0TchC8JVHAzFFwuIr9N/m6aI3Ds3hUWfCZW3uCx0OC7H3sjFfEfhZYpJWLtK?=
 =?us-ascii?Q?BQmo4qbF5D3Vp9pOLap0Jkv615Du2DKvjbeRUnmm5KzNjh2Q+Ssat4lRlx+Y?=
 =?us-ascii?Q?I5ZTbIUNpQo76T6aixfCXAgKYIoxwyYw6FVSxFxIcwarK+kxRS9YUMXgddcW?=
 =?us-ascii?Q?HNnuZWBDDVTdI4xymoSe3Q/7LnfCHdXfv7blS7jkZ+iFBVNMuFST6JNInjau?=
 =?us-ascii?Q?A0I+fULA3nbbR8ewuext1JHQAlbKgPJ+CIyNo/D6AjwkVa6Zr7Zj1ORXlplp?=
 =?us-ascii?Q?wKhm4UFjjuSvs2RuJRxMCNwCsm1GVjZAdPTYN4dfcldEXCvF8ktPQNqr+Wfx?=
 =?us-ascii?Q?/mVeHIV/yrQym4l9Kj2ctuNOun6uR1pldGcHXwYFZHIA/6BLHptMAuaqRAI6?=
 =?us-ascii?Q?Bse7PE783fND2fcAhf6Xm2HzNbaZciVC07UbfJFQ9/mpkLlLhqWOK0rYvXws?=
 =?us-ascii?Q?foAT2y10jBZHYxxuB8tYeuHRmDPKXmFaTy/NpHt66qkzk0Nym9dPRjmK+d+K?=
 =?us-ascii?Q?3k0NQH4rVLrDtSpqxEAzB194AvsAQwmfXmBGml2HjHLcQQD4yszIcrssldUe?=
 =?us-ascii?Q?WujfWJ5YCi+RoG7u9m1NsnrM2BEZNWrPKcqyZj+QySk5VBn0aSphoh875VGp?=
 =?us-ascii?Q?Isy1mNlktUNlzjqJFQ1PrPUDW5/gD6SsqUtjsgTejzjbySCdRU0y9uk53zxU?=
 =?us-ascii?Q?vSorfB0zwYGbn0CKpjQYezKnRi31dhJU2Prpj+JNkqgN01H9KK+SAtmv8lSE?=
 =?us-ascii?Q?BFCbxl1rgPWFbl9lD0jVSJN3g3oUVjvcGt5lbWB2iiMiouDwLaNuWDgXC807?=
 =?us-ascii?Q?Id+b6hd5dAf7lDF57wQh6KvnQt5EsL2Z9OioD6sY/tl0Q/R2w71CIl6XCKS/?=
 =?us-ascii?Q?94ZdzNqFTObAQiJATbKY0Ts5zV9SOT6WW94BhAAKeJt3/+dx02YAAXOszvr6?=
 =?us-ascii?Q?Db5/wQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e7fc339-273f-4ce0-99fc-08db2bbc008d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 16:31:06.7446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Uj/TwNgeub0K4LfuFCKm0lR8vPbu8L9Vqjn1JFRSziEytrV920ud05YyUV8SxFDy8U/CUXKpt64SbPS+80bikClxdwiY6Yoa3FZzpy1mDo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3618
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 12:25:36PM +0200, Josua Mayer wrote:
> dp83869 internally uses a look-up table for mapping supported delays in
> nanoseconds to register values.
> When specific delays are defined in device-tree, phy_get_internal_delay
> does the lookup automatically returning an index.
> 
> The default case wrongly assigns the nanoseconds value from the lookup
> table, resulting in numeric value 2000 applied to delay configuration
> register, rather than the expected index values 0-7 (7 for 2000).
> Ultimately this issue broke RX for 1Gbps links.
> 
> Fix default delay configuration by assigning the intended index value
> directly.
> 
> Co-developed-by: Yazan Shhady <yazan.shhady@solid-run.com>
> Signed-off-by: Yazan Shhady <yazan.shhady@solid-run.com>
> Signed-off-by: Josua Mayer <josua@solid-run.com>

I wonder if this warrants:

Cc: stable@vger.kernel.org
736b25afe284 ("net: dp83869: Add RGMII internal delay configuration")

And being targeted at 'net' ([PATCH net] in subject).

In any case, the fix seems correct to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  drivers/net/phy/dp83869.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
> index b4ff9c5073a3c..9ab5eff502b71 100644
> --- a/drivers/net/phy/dp83869.c
> +++ b/drivers/net/phy/dp83869.c
> @@ -588,15 +588,13 @@ static int dp83869_of_init(struct phy_device *phydev)
>  						       &dp83869_internal_delay[0],
>  						       delay_size, true);
>  	if (dp83869->rx_int_delay < 0)
> -		dp83869->rx_int_delay =
> -				dp83869_internal_delay[DP83869_CLK_DELAY_DEF];
> +		dp83869->rx_int_delay = DP83869_CLK_DELAY_DEF;
>  
>  	dp83869->tx_int_delay = phy_get_internal_delay(phydev, dev,
>  						       &dp83869_internal_delay[0],
>  						       delay_size, false);
>  	if (dp83869->tx_int_delay < 0)
> -		dp83869->tx_int_delay =
> -				dp83869_internal_delay[DP83869_CLK_DELAY_DEF];
> +		dp83869->tx_int_delay = DP83869_CLK_DELAY_DEF;
>  
>  	return ret;
>  }
> -- 
> 2.35.3
> 
