Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA5C6A325F
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 16:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbjBZPfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 10:35:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbjBZPfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 10:35:00 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on20722.outbound.protection.outlook.com [IPv6:2a01:111:f400:7ea9::722])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2F07DAB;
        Sun, 26 Feb 2023 07:34:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FChEeT6rl6n6GYhfIhdzKdITee0YsfBTPtpHvI95hPyVHK2eBg4cDAsheuLfh/VP+Wm41qp+vNi0uECBFO/cOCNeDdoLv4L1atBmbUOdmSg3b6GF6TGMlWJDZkTUD8TXWz9SiIiLrx5kuGIvcVV1BC9HNQoxRON68iltEgs2/N4yEAqMcRxgUGTNs2GLorWHAFbm3DtatPPYs1pIds3RFkck1Miccic245OF+CNVgDo7iuXnZN7ntwQfEXIvci5uA3iXvrL+InfCPSHxfJr2MAs4PJsKlR/SyFVCRiTZfXFdsauxNd0MbChZj0+P18qka8HoZpi3DILONp/KavqSCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3/doHwLvY68yEd3hKA2nppMoLMapHuz+pcOycyFQ7nA=;
 b=hbu5W7AQlotzP348pBJZEMbs0QtceVl6cH6NHkKgaCUjRXqx9gkkwiQCAibvI60AtiiB/Vylsz5dnked+FcpRobVNPfK6nHtcMciOOAHwTMgTgJa7vWftPIcdEIvcUvJq2NTKHxcXR2UTSVcBuWlJSx+Ifxe2b/9iIe6UN1BAQAnFA1JIEYprwAxMsXcd7aE+1Wb19ASPL3BeKlOGwbVEUbAPYG3+0RwP1+XSWHnWeJXOpCp4Z3JjYBka9fFm5qOpi77eWR1oT9fG2oJGAhp+GL3B9rSklS6rVqEvXDLFNF2ZU9fsZKBXgwtRVAyuMVR94M0lgkL9/TKFO/NFzPnyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3/doHwLvY68yEd3hKA2nppMoLMapHuz+pcOycyFQ7nA=;
 b=c7b0rPGYa1tKfwBft65Ic4X6t0mst7u13aLSdR9Cvjc/ek0fP4YGzY97aIr+NHV188LK0eef72p4vL0zqTFVDd6vuFtJWyc2A7ARcCRn4IjR3iwxDpd61TUmCEqD5WkMklvHHljRGYEfQVfiyGobCO9wY7c5hauYvs5QIsXwLpc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO3PR13MB5768.namprd13.prod.outlook.com (2603:10b6:303:167::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.27; Sun, 26 Feb
 2023 15:33:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6134.027; Sun, 26 Feb 2023
 15:33:53 +0000
Date:   Sun, 26 Feb 2023 16:33:47 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Kang Chen <void0red@gmail.com>
Cc:     krzysztof.kozlowski@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfc: fdp: add null check of devm_kmalloc_array in
 fdp_nci_i2c_read_device_properties
Message-ID: <Y/t729AIYjxuP6X6@corigine.com>
References: <20230226095933.3286710-1-void0red@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230226095933.3286710-1-void0red@gmail.com>
X-ClientProxiedBy: AM0PR06CA0114.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO3PR13MB5768:EE_
X-MS-Office365-Filtering-Correlation-Id: e642ee17-0110-4687-dbe0-08db180edd6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VcWaPKhJxBWujTD/i+CKbIa1z78mJu7vct4DnyEhaG5ZwsZGdG4IFusxvo7PRy803IzDWodMRWKkPg6LJPLQD9NeV05ENQDvKxz5OQenYCRFOe0CabDL5zsPVwZVAhIsqR6NP+utfycXLfbPtKlQrrbGXCQYlbNkHc88tFN6+0Eu5aDctBaMol63pKsMbzQIBh4VV5ZiMCCRcykXDMHO10H+ykKqvRVg4uSYTYoNgNwdP+dKvHDtqdjQEw3V9IHnJJsn14p+2yW+fjqcgU7+jeccgJZ+YmpHCbUAg0k2u8K4aO9z/fklS8wltKhjDL7/2LtUR7Jre3PEJzabCXQpovPHM+X8xfRf8/0mw6+NBVx8dOIjcktY26jUJLp/ujE9CXWMGwNUq4OdeNKJOtlF6JxD1qHxB0Z/kUM8QtbsYxMEtrZRbe/w91siu/c1dh3AFKCsKKKyRS9syLm8COmvWPJ55Ow/+8jsi4nfm+iammwozyBckgPHQlyITpxQKeZKPJIIXS2LHc5vtKl6/4MIFOXfGOPiVA9+nPmKAE0twD5BxjpwvlotaTkVkSOyniW+XTvR3Kue8TR1QhnsqLHLsgwQrV5itFew6yzhO1YCp5kXGBr7DekNClvGOTFGM2C1H3D3sAPiw/LCBFGvZiClMRfr19+gMKTjsoVHehPIcENVO766GPV/Gaevg17B09l6XUmyY8syGNj3MAJI0lWt6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39830400003)(346002)(376002)(396003)(136003)(366004)(451199018)(86362001)(36756003)(38100700002)(8936002)(2906002)(5660300002)(44832011)(66946007)(4326008)(6916009)(66556008)(66476007)(8676002)(41300700001)(316002)(186003)(6512007)(2616005)(478600001)(6486002)(6506007)(6666004)(70780200001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QAVCO1jc1C8ge0q34cuJUQu8gPFMFmvaUdrSaMs11pKKwzEbR+nIygr34Vn7?=
 =?us-ascii?Q?2TwkjAsXJVeyVsu6qmR+gU5c/mqdXs6MgPsF2ya03lEPRhPUroWEVeFaEnJx?=
 =?us-ascii?Q?GRQKYrKokIHuaBRC9Tl4/yXlp863kRqLF/mxfUuZ0IR5mTWaSq6koT3gBv0V?=
 =?us-ascii?Q?9e4pvlzqMhgKfFM13ohenkr470E0wDMv/qrLr83oB/kIZArLaP4zWR9XS2Tz?=
 =?us-ascii?Q?MOhBlUWJTUN1fgHJixaUvlEZ53GOkBw+5W+apE8iWPMCxjCk8LGmxRKls+vf?=
 =?us-ascii?Q?SHZp3wZ8JDYJkzPZ+BiF/C6+SIPEnLxQJuwGsrRQbJ+GQ4xlfBDKVmhCl0Pn?=
 =?us-ascii?Q?HS0J8NhnCEZNW54/zIKBTO1gFbAi0VFtcjKMievcc5E1N+1oVl8D1YTk1Vso?=
 =?us-ascii?Q?YJ0lvKm7C30QR+GiNfc/EjCu3+4oyDLFtitP5iRPSEFLrklzKPldFJnR/uMQ?=
 =?us-ascii?Q?fwxP2PIN3IMzF0EgI+AZRpB7vqjzZXOQ1J/1LoBaoWKVp8EqXFYgZMZfMzZo?=
 =?us-ascii?Q?JWxtnN9S0v7T6rHZxz/9LGDsMqNAggLy8Cr4NUG0yGPmrAUp59Y16FDbQEX3?=
 =?us-ascii?Q?9pvHwqvSezomYOyeDBsFHO+daGR9uQgDpYvZGb0UaolNRSWA3DR5NCx+raa/?=
 =?us-ascii?Q?Jv6xm04C1fpyAKexRZi5Y5wdBcIS7iEXh8+jcwDGMn08TAmJH4xSY1sxLu1L?=
 =?us-ascii?Q?t8Buxcs/4h17DhC/jqsYr5JHx5gJCsf7EvTgNwjKwsCKY7r7p04NCCq1IBPy?=
 =?us-ascii?Q?LG44FHFeKhPrPR/9uuHdniPIWH5BMPwtYN2E7sZihXGjhe5N31aQyTUbs1K0?=
 =?us-ascii?Q?k+xG2Oo0ul7oULdl2qCNlgZLzxepavR0G47ma1pUZdxyl1Ph5DYJlhdQsuwe?=
 =?us-ascii?Q?O4LeUhVDCKeVq5VdCBJxb4yA1NBcG74cljnyaR+0c5aCZWtxCdAozcErwH+s?=
 =?us-ascii?Q?C1PVlE+tql18yaTxRo9t5r7G6b13EbOwjjqsCb/UlmhdFcu4awOjztX9bTMM?=
 =?us-ascii?Q?+GhuCu00gzlxXfWKGvj1P/ZrGNC3dqdLO/SzUfbpkuOzcdzlaAEpeToBzz24?=
 =?us-ascii?Q?VpM9WIeLivLI5iX8fo1hKXFIgoEN12vBoV1jHmpsNmmKbesk0dcj7RQH06IQ?=
 =?us-ascii?Q?zq6LYLwT3DFpU7AwhsPImhjAePUuExK5ghEcXYpURYcKWPaK87pUx6HdQ44X?=
 =?us-ascii?Q?5onJYFXAc3sQVHok5qGtsOa5Ztw5qsEWb15WreBhHaofjrkg9m2pLC7/8WcJ?=
 =?us-ascii?Q?lTlsyw92klHYKgUYfeXyFJyg/9i3rT8rRy9hwcP9/8UpKIoaGnPa7uw8D8my?=
 =?us-ascii?Q?fBpfcWB/FKaHo57SOL23dvWSOdI2tCDz6rwXH2PLjwQJJHkPLgjKlt6+o8K3?=
 =?us-ascii?Q?RulWz9ueWUkt7SV/HhrhIxT9ufFx7eCZfQD2emgafgS6mtQHBLuDSvoEZ/uO?=
 =?us-ascii?Q?Co8CxhP86kfR55/8sJDXfsX5rCLjd6ZyJPVsg0AV2lggiqnQFoaCijUiUNyO?=
 =?us-ascii?Q?ufKg2LSA22MmO5OQXF93+bm/+88+La+KcD8AIdBkVwoVLVgBuT3wbkIEoxEZ?=
 =?us-ascii?Q?26FqPQXbYMBZE/MjBYfXFK8THW7aVE9PIwB9PsxF5NHtp+P1NfC69xcd4Wpc?=
 =?us-ascii?Q?UFfTggKCvn2xwDwoIOew7XzzldNwH2uiW/tfZeDGbxl8uIvmw7qggNVR4JuJ?=
 =?us-ascii?Q?Gztp2Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e642ee17-0110-4687-dbe0-08db180edd6e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2023 15:33:53.4496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OGz6+axOiDWQ4WOt7RIr+oRT5dfrVndldrnpYTPJe09j3a7PTJO0c1rfadIBX8Hy3ljpg1+FKH1nIBR9kmekeQi2KKe8xYq5fZMXqUrSVDs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO3PR13MB5768
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 26, 2023 at 05:59:33PM +0800, Kang Chen wrote:
> devm_kmalloc_array may fails, *fw_vsc_cfg might be null and cause
> out-of-bounds write in device_property_read_u8_array later.
> 
> Signed-off-by: Kang Chen <void0red@gmail.com>

I'm not sure if this is a bug-fix (for stable).
But if so, I think the following is the appropriate fixes tag.

Fixes: a06347c04c13 ("NFC: Add Intel Fields Peak NFC solution driver")

> ---
>  drivers/nfc/fdp/i2c.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
> index 2d53e0f88..d95d20efa 100644
> --- a/drivers/nfc/fdp/i2c.c
> +++ b/drivers/nfc/fdp/i2c.c
> @@ -247,6 +247,9 @@ static void fdp_nci_i2c_read_device_properties(struct device *dev,
>  					   len, sizeof(**fw_vsc_cfg),
>  					   GFP_KERNEL);
>  
> +		if (!*fw_vsc_cfg)
> +			goto vsc_read_err;

This leads to:

	dev_dbg(dev, "FW vendor specific commands not present\n");

Which seems a little misleading for this error condition.

> +
>  		r = device_property_read_u8_array(dev, FDP_DP_FW_VSC_CFG_NAME,
>  						  *fw_vsc_cfg, len);
>  
> -- 
> 2.34.1
> 
