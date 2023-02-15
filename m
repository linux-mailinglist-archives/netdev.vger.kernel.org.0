Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5E36980D9
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 17:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjBOQ3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 11:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjBOQ3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 11:29:10 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2117.outbound.protection.outlook.com [40.107.212.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5F73A87E;
        Wed, 15 Feb 2023 08:29:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=amBl8Jl59R3bYRAwa3X+yeukzc6Swwnq55AE3NY+iwA8qpPcY9ExAQ9lcsHR6J3lhJucOO63/pX1ukPoXw2tbJ5Yql4wq8yoT4s/vPGU/q18Sb8RUDv1HIEo97Z8zVaGFHYS1fiRLkmKJy32TSF61BIxglErRRui9AxYbbG7N08RKJOfgBQSw3zGxJl8CVbBc+N9GHGnB/W88Efq86tWN4b5TSSNE5mNIoj0hMI4u/qPbc86ocWbMRFc5im7rKp5xHH+411wHJ6OaiW7Eo1wjZQ6c/BVzphG/Xl+iO40P9644/6aoTSyJeIzmSbXwDHfQonBdJrfQYqC5OU9SrTIwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7YnfpIje7GUKnPvACkIQSK2pcsLn2buXtDaFx5HybIw=;
 b=jZH4MrlvkHxFQLtJQTuIiYISlKbtqpAMMMMj7ElfCSHWyxMqvuBYQIyvGpwKehiGYGpwQVZFqz7bOt5jsnxCBe4HX2SO4PK4nFsLLVuXYlLnNrXzup9uEqsaCNiCOoKX7wZnH8/noIpamRpykNC2t4B/Zt1JEZYapjRwXk4YKkLUFrUmxKCd8aPN7JxGOc7kQ5hEOxda0ePAcRYiFsTMQWUgTsd2babogn1nxHDYt7tPn4vEpqA/LFl+oIeJvvNzQK8ohjiD1UYkSAIESnhJJvUbTeqKQIpMVvueAEBQ6ud4sCmqkKBYqYd66fQ4UbSdHxBHChoA+YrdfnBvbWuj7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7YnfpIje7GUKnPvACkIQSK2pcsLn2buXtDaFx5HybIw=;
 b=MWNJA96q3gOPpuyXUzdM0Y6IwPQRbMS1xMHHP5sw5pzoHWHQLDtsV+8jystkj7F5rLv/v4fPgGlhpIDSD9KCgDz/pPRf5OcSs00gKQk52oRAlpGypOZ8IK/tKgJpFlui55UWRsNDHHPQPosWWV3HXY6zW/6ztnncewUloYvJPcA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BLAPR10MB5315.namprd10.prod.outlook.com
 (2603:10b6:208:324::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Wed, 15 Feb
 2023 16:29:06 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa%4]) with mapi id 15.20.6111.010; Wed, 15 Feb 2023
 16:29:06 +0000
Date:   Wed, 15 Feb 2023 08:29:03 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: ocelot: fix selecting MFD_OCELOT
Message-ID: <Y+0IT/bV7snqCmnF@COLIN-DESKTOP1.localdomain>
References: <20230215104631.31568-1-lukas.bulwahn@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215104631.31568-1-lukas.bulwahn@gmail.com>
X-ClientProxiedBy: BYAPR04CA0016.namprd04.prod.outlook.com
 (2603:10b6:a03:40::29) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|BLAPR10MB5315:EE_
X-MS-Office365-Filtering-Correlation-Id: fe2c9531-9398-4d5a-dca6-08db0f71c198
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QYBubiLRXbccHt16MMXcvat8m5hnTvT6bJi55+DrLcRV2m1G0nADwPIFXWwpPBm5L++o1NxCGguAoBOLm0bNhlJOEpQ4KIMs1/49nZIh1AvzZrx4hEJSBryG7C+e940WyObXI18Ov2WlMheTaCXITfIEqQPPYg/URnZsBbBGdIzD3m1hTOycC/92aOPqB6WuJFgs7ZjhAgR+gyImjPl1F3KXJJUGBQpCurxh9SB1GJwJtezUg+wMxGrxh61WU6bbZ4l2gEaLhzi2VUGbODXfqKjQTQz+DEUj3APCkyp3R47XlmdDCr1iCBh0v9dte/WWyPc9vL48znvWSXL7hhkeebFdcfjgWs0vt+VX1Lp4R+o0EpWO2Tc5hjhsxEcnMiT9fFhlpNBiq62pEJwwWXmjrPofOzn1pkl1Xie4UDBOvsKxcQfqQAYOvf41N9VG0A25W/Vpqzb2uF8Vphvn+YkvWmWaPmcv7BL0hn8EHI35mpFUmx8UkdGsyeSxScaKejY5yKaO3coYUczl9xSCEQeK1KKn8bC9OuAsT4BTkvDffadtrZdNehyVq11S/KomcSffSOhBl9Sutx5BlRDBOWXkrtC9qjvpBety3TQlv9To0kQ09vvkIYRhynhjN0HXtz/KbRYAFGJ7szob89/Vw18iKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(396003)(366004)(39830400003)(136003)(451199018)(66556008)(2906002)(6916009)(66946007)(8676002)(66476007)(8936002)(7416002)(5660300002)(4326008)(54906003)(44832011)(41300700001)(316002)(9686003)(6486002)(6512007)(478600001)(6506007)(6666004)(186003)(26005)(38100700002)(86362001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7DZgUzEJXa07p1S3vs5HsYV7DjnvpolsPS+1LiWxVzhdLC/IrjihANf5KjQt?=
 =?us-ascii?Q?6845hijJkPfs91Iw7ZOoyPb1+G+m/7pj7CdhOIrsNGeMXdF4l/gR18+xVu+4?=
 =?us-ascii?Q?ozvPQnURyUVd3mBDjG/hWpRUE2S4eTngSqK+nNuY/nIWCgvQfUg5H4iVJjCS?=
 =?us-ascii?Q?hwkxKMGgZMQdFshoxw4fvnSF/JG5XgINo7q3Ie7wAbzKuEMZUNyt4fDYp15q?=
 =?us-ascii?Q?rg7tzSmEpxgLKPenFRtlrCJY89t7LT3gdWoITJvJC0NeUg2cZzBuTxXbe0NX?=
 =?us-ascii?Q?4Up203EcC/R5a//55i1rgWDc+f2QMU3fnxWO9LPhUQ0EeEDN6AKllKH/RCkS?=
 =?us-ascii?Q?ynjdIMD9pf8QwL6nLPzi/z9yTr4+SFy1nQ2d2M8L0s+Vf8CT5NmWsJ4T64OR?=
 =?us-ascii?Q?is4pUcp56zv7vb9W7lGPw2NkdQ2wiuSfIGnXYA+TiRqLo6KPzIlnJDG0fwe9?=
 =?us-ascii?Q?0Zd4HZ2hv5iOBDkn5jwvl2mzppFwlQeuGuGfFC23SwoFRrq2G3oNkp6Tq0Gt?=
 =?us-ascii?Q?M85ufgIZPKSou4IgTGVSKaCTdBcIaOLBz+CSZYWzGiidiEEkmSVdtHm67YLq?=
 =?us-ascii?Q?Jb/H2lgZE7S1fPBffS+KRjxQOi/c1DbXmnkj44iBzmi7zDI10OfKvL3Yrp/y?=
 =?us-ascii?Q?sirTFW2HcRzTVw1rNiWWcQugdmSP4aJAzE72ibcvpQ7wOS8f9K+yq8+h5h3I?=
 =?us-ascii?Q?tgpPa/mVss0foEbPZWyCaTw/CB8fmu2SJB+KG+ILdJH4M9NJFAWHMGPm/iMh?=
 =?us-ascii?Q?238Su7+3gQR6IHpR3OJNHFPfYSCO/ur/VxdxoYyeKLAJR4oksvdWo8KccIml?=
 =?us-ascii?Q?9YjqtlHdhhrX2Q2JvFTXtsJ2VrqnOyvjkuXd9zcIt1NXI2KKReTYlb76TODC?=
 =?us-ascii?Q?qNtr7aLd45oDa0RFj0hbjP4+5HLhqiBOmoM65kC5roJTzqeaa2q45riwOBmY?=
 =?us-ascii?Q?D2Yr32c4s6Jj4voUH/VKH7OGD4/69zIdrbvMwQozetmC1vMXp7xdBP1Md4dW?=
 =?us-ascii?Q?91Kuy/hspq/3ZB2ISBHVDEbaJpWK5LXBPsnBjGbZS2i4/3gT92ofAzN8mDz9?=
 =?us-ascii?Q?2bCZZipzf2QhkpSG6T7HsKXjK8m5vZGMi2uUA1LwaO3RCFRD4E4D2y282+hZ?=
 =?us-ascii?Q?8xWBnPv2JrkQrco5zTMGxzo4wt9JEWf1YnxZq7q8CQ2WM4jGrfEh/B3HIxu0?=
 =?us-ascii?Q?dRC8T3h76TRLWZwOCZckcTgEQ10Iw9QFEEb7BN3XNe6nRDlwtRbYzadiyLFE?=
 =?us-ascii?Q?BnO94dWAaClb/GwJUX7dKD2QcuQVz9NaPoGdsndJ62Sbb3KR6QvUUIa7jP3Q?=
 =?us-ascii?Q?noWebBSfPi7boIhWVTWpvvJB5voJqW0q5KV0yAF8uC6xb4qgNHFrcpFMMw5r?=
 =?us-ascii?Q?1GnhbqW8VqolMnZoVDVehEmDPauleE5YHqrY+3aklzs7K7Uh+ZU+PMX1HrFt?=
 =?us-ascii?Q?QNUDvzXLNh+lMTSaVriSOtPOuoyi62VWvDhXlns8oeMB4l0wKtx03rrZaU9i?=
 =?us-ascii?Q?G/YUOvWH+ozbU0debmM8hee+QOPm3MwA4z2ZQBC3wzR7yCWrAr7hLEYXcba2?=
 =?us-ascii?Q?2zeQPNfwZ7mSSEYbqAVVEAztcX5UjJA/EcG/rWSWTXHN7y8FgtNz5xK6me2X?=
 =?us-ascii?Q?qIaRp+8Rx40hmte5QfJvPAo=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe2c9531-9398-4d5a-dca6-08db0f71c198
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 16:29:06.0861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GrU8/TiluaMSui2CblA88Dj4NSOSAPcUCPI7yx8mUA9t3esER4HbaKV+VgLJ/HbZv2y80QHhkzN3AZyjboE1SgLyGSKe/63btrx65CRdzg0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5315
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lukas,

On Wed, Feb 15, 2023 at 11:46:31AM +0100, Lukas Bulwahn wrote:
> Commit 3d7316ac81ac ("net: dsa: ocelot: add external ocelot switch
> control") adds config NET_DSA_MSCC_OCELOT_EXT, which selects the
> non-existing config MFD_OCELOT_CORE.
> 
> Replace this select with the intended and existing MFD_OCELOT.

Thanks for this. We pivoted away from *_CORE a while back and I clearly
missed this. It can go through net-next this week.

Acked-by: Colin Foster <colin.foster@in-advantage.com>

> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
>  drivers/net/dsa/ocelot/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
> index eff0a7dfcd21..081e7a88ea02 100644
> --- a/drivers/net/dsa/ocelot/Kconfig
> +++ b/drivers/net/dsa/ocelot/Kconfig
> @@ -14,7 +14,7 @@ config NET_DSA_MSCC_OCELOT_EXT
>  	depends on NET_VENDOR_MICROSEMI
>  	depends on PTP_1588_CLOCK_OPTIONAL
>  	select MDIO_MSCC_MIIM
> -	select MFD_OCELOT_CORE
> +	select MFD_OCELOT
>  	select MSCC_OCELOT_SWITCH_LIB
>  	select NET_DSA_MSCC_FELIX_DSA_LIB
>  	select NET_DSA_TAG_OCELOT_8021Q
> -- 
> 2.17.1
> 
