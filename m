Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7DF633C25
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 13:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbiKVMLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 07:11:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233633AbiKVML3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 07:11:29 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2066.outbound.protection.outlook.com [40.107.21.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316D849B6F
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 04:11:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RMP5hSa8LcCZGfaLtuO9SBoNG5XaDzmFrKIGN3I6HBVAIrcgv5ueM4wWKINFa4GaFRM46ucrf0HozV7fDXQ7/Nmti0TLECGQ3Sh70ocQsqQDxSgUNKyPDJcnrPbEbtNYAcvrIqCLvHLzrkVb+JOws0ccZqeyK0xbvXecrMwsc+gYyn+1sycAFSpD8BFnpJrMLjN6Kxm/7MvJt3/Syqz79EHB4qngUE8UYH2WEdm/GhKVZlNFodShPF5/F/HZbjPdKdf+9m9DbM1gKl6v7JqEfFOZRq9DKSFlsCXyK2HQMGx24uKdCeNYz7uW3ELV8SlcvL/iQAQfAmt3wKXY5JzOEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fkhO/3Fw6reWcddCBCpAKumhRKY/GTGMx824mHgMt8Q=;
 b=SxX5qeRqtgpdYx0nzO3ykkIWVMc6iijB/chkKsZoSeyRLfnuWm3d+cbWDCEIDcELjIAa3K4j9pVAKgHF/0FfSIoegHzlzqBZuVThU1Jf5cJo4kfyODNeF7FLL+UsSq0DlHTpM7JercA+u9s+SdLmkgJaL/wpsp3nPUPwG9qQmXK9BlTpXbChA57Zrk++HC47yCmYdsdKzYbNK9lVE5ABadSzDELygRPXjcgv9PH7geCxphImHOZ2L2//VWUCGnNE2omu6mITpX+K1puZJZKoS/snJahM5/vcXwd/yrpXka8kTX1mfdU8+zUBbsQxqcr3wmUPaggN/wInaRklvBtgZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fkhO/3Fw6reWcddCBCpAKumhRKY/GTGMx824mHgMt8Q=;
 b=UeyjLXrSZGieV3WWemT509y1/ogK+Dn/ZefTXOI+SRRqlcq27yOMonsNnBhEZ/qJo3vV7id8nCrA2JYvjstNE550V+rbTze1iVvy4bt/uldWDPdw3owfHG57LpnktdgNL28QFy0vkt9eTL3iBA5L0BK9PxV9Jo8vH/or0fySnRg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7512.eurprd04.prod.outlook.com (2603:10a6:20b:29e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Tue, 22 Nov
 2022 12:11:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 12:11:25 +0000
Date:   Tue, 22 Nov 2022 14:11:22 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Sean Anderson <sean.anderson@seco.com>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
Subject: Re: [PATCH v4 net-next 3/8] net: phy: bcm84881: move the in-band
 capability check where it belongs
Message-ID: <20221122121122.klqkw4onjxabyi22@skbuf>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
 <20221118000124.2754581-4-vladimir.oltean@nxp.com>
 <Y3yYo63kj+ACdkW1@shell.armlinux.org.uk>
 <Y3yvd0uyG2tNeED3@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3yvd0uyG2tNeED3@shell.armlinux.org.uk>
X-ClientProxiedBy: VI1PR04CA0056.eurprd04.prod.outlook.com
 (2603:10a6:802:2::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7512:EE_
X-MS-Office365-Filtering-Correlation-Id: b23b3888-6736-468d-7aa4-08dacc82ad4b
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qm2A1qXAltDwx77yRd3A7tw52hbryzQhLBa+ABZmIhcTJDRvKm576R7GTgxV0ij3ZHpwpmk/37zeSHpA+RZB9BDzkoJ0lg9V/c4sL1zitpZu+X3ZX+rf9QebzJZGw9t2nS7qBn1OUG4xWh4vHvwHdmjqyxVhE0ZpE64OKZF58IE/x/zS0VLHTLUm762tM7A39Fi4ArLzFz5dyltTy14LpmcsOtyburO40P/VSCIjO20QMycJUjYvSNWtuiArXC14b/sKaPvzbSC6zZI+XdnUGIuQAUWrcyTGn6twFhG4HmxQteHR4w/5qyGRco+oc1qdijIDTNyKKcD0AacNKzj4Qb4csXlQcPH6ROL+p9MKwpQ3LwVjg3fw1Rs8xSkrIEjzKTX09RRCK+TRk9DZTw+McPjKie5xoKAS37fJCpC2LCyiulo6mNMDMVkkOnblTEoCzDFguPOcCWVdXMM+EMLWVj/UGsJSqonk8/JSpjjuPNPuGy7ndLqEL2ybB5hlP+9cM7lIFOqPiRC97ai8SvEnf/v0uxuPbiNrMCcwx0WPoKxBRKvFM7f2ziZIZptAsBYs9tHUZc+x00mUhc5f2ojn/rarmVKauab793h00o7kz60wcUDM3cCg5mtrvGx3dczAxmvv5EGtzqB3I8V3cpvL3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(366004)(136003)(39860400002)(346002)(376002)(451199015)(38100700002)(26005)(33716001)(86362001)(66556008)(6486002)(478600001)(6506007)(7416002)(6666004)(66946007)(4326008)(8676002)(41300700001)(66476007)(316002)(83380400001)(1076003)(5660300002)(186003)(6512007)(2906002)(8936002)(54906003)(6916009)(9686003)(44832011)(66899015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zSg9RHcfMDgFFBDkr+2x+5zbrptJWTiFXWRK0XiBgp7ak0LJvTw5g8pJHBW1?=
 =?us-ascii?Q?kyq0WHR9xS1ku+d5xu+DYjaDCGoYu65z+AfeS2GrW0xPxiyCxFd0qBPHO5sb?=
 =?us-ascii?Q?S9Ef3QTwnnAWCmosiRwwHl1SQRupHE8twNraODewp5lbk9ehMZCBSxUESrrw?=
 =?us-ascii?Q?y5BLlUwA2baVsmOo7jRv2/kgauniOOcXSOswjfpAG/zRWXuSVAZ1V91xLfYp?=
 =?us-ascii?Q?1+y1SLYzwaFcR+AO3YBaDDGoEF1tDg98Gfw5lO5d8SBo64zRwJuZVDQwneIv?=
 =?us-ascii?Q?aoq9HlhmxZttN1ZpLc0OxcBEtuiV+ed3qoCp70Zq8GRcKpzVGku5/oEwnSwF?=
 =?us-ascii?Q?A4PiR2BvmPUyBXIOpvE1+shSHUaO4JpXjZQUYj6hsZNOt+990U7Fb19FUl7M?=
 =?us-ascii?Q?WgkB04sy16RBbl1kPVdTOmKmmuXzZisxOYBnuN0RSg7ERU/E0EvGBIoXPTCr?=
 =?us-ascii?Q?linNK8EekLkIm1khXrtxICHeiTKEOF0395Fv05RTUreukVMQPUGbk5k/PWN0?=
 =?us-ascii?Q?qzsuTAmLVH6NvVYG6XToiwY0oPye2GQqzIWRuyhbGzPd8XEEZ7birzvKhWrj?=
 =?us-ascii?Q?7GhNGbN4AjXYO9NtL/7K1DdqppOlQOludbMi1eFhc6jYTvKlo1QbChXch9Re?=
 =?us-ascii?Q?rzb7CJajW6cDlPkyvImm6l2rX8NuP4NUcTFy0r9/Shj3vxu3kruCGt7aoD5w?=
 =?us-ascii?Q?xFZ3G/xKDsidW3wdWpCrpS0+8NtgrzYXcdsj6GaEIp7wvRBjSyMAmqpjDzt/?=
 =?us-ascii?Q?nTcy4DqgZ3aTnQwE4MpUzZm8JyXTD8764P8tj1oExDp5u3RuGrkaOM5vPexi?=
 =?us-ascii?Q?Tna/OVTchdPauN1QuOEgX2cDANr5v0kRc3GOhwV7XmC7q57vm3+8EiJ8fWKO?=
 =?us-ascii?Q?T1vsT/cNUg0UzriP3YB3sLwlQa1+skBOrSelNW3RSNN5wrPsbXvYUSTbaq0Q?=
 =?us-ascii?Q?zHNOfCu65UdKMYWRs2LZucxcuII0bdxJYcCLcWFbcBRNtxG7pZhUws1b7IC8?=
 =?us-ascii?Q?u4fOURQl1AI2jtlCudyIRr4Ev1yLEgZZVJX2ZjvIkmONPAqEqFiJmf7c5q3p?=
 =?us-ascii?Q?a+jf4ujz0JexhN1T6Qqi0BWfULvw+ALpSDD4he43c8tcJHwsNwvzFkeIHqSx?=
 =?us-ascii?Q?yVvl+kaoCIsmLwe/XvTG/J6Q2zLweKdlPqA42561DO+j1g4Z8xhYqy2qnnaV?=
 =?us-ascii?Q?m4qdYhYefOoVlN7I8M3z8ITUm1pdWqH1EQp612q66+EzaaCNT8yf8hyrg5YO?=
 =?us-ascii?Q?GDw1S9F8sRcgPa/FEMxDEHlPjIw5H0Tp+E26/rblSM8/d2AxT33OlwWnb6Sr?=
 =?us-ascii?Q?CqFPlR+e6YgDiEXejv3b6bgf5oDkw9xsgP4GT/9KlpitzF3E5exM1L+PhpxC?=
 =?us-ascii?Q?LrAWWqiRv4EKHxHXsyPvRac8FwFxTLJ22CE1FGgQHy+hjP1FhXItHsp723Pl?=
 =?us-ascii?Q?cq5xysFhd1YN0BEAxXyfoGRVu0aD1QIHGxoTepRMYXICcTcese5vQQ/JWzmC?=
 =?us-ascii?Q?INfwdbIbwXntLotdE7GxvQVzhXPWmyEj5IEut16a0GNNUu5/7bos1PKtAMFX?=
 =?us-ascii?Q?1JA6ygAYvTG+l+lgZd6xOM7tKu+fFMaIDoO0XbfsMnN+J8WcT5dwlyQ8DBE/?=
 =?us-ascii?Q?FA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b23b3888-6736-468d-7aa4-08dacc82ad4b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 12:11:25.3753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5gzhjFZdXQc4nhQQOGqs+LKO801YJJl/SBnaRatKyUKXsrNdXM+RSWVVMuvAxF1ObCh/OOoDzM4LwKzsj8Dvkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7512
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 11:16:07AM +0000, Russell King (Oracle) wrote:
> On Tue, Nov 22, 2022 at 09:38:43AM +0000, Russell King (Oracle) wrote:
> > Also, if we get the Marvell driver implementing validate_an_inband()
> > then I believe we can get rid of other parts of this patch - 88E1111 is
> > the commonly used accessible PHY on gigabit SFPs, as this PHY implements
> > I2C access natively. As I mentioned, Marvell PHYs can be set to no
> > inband, requiring inband, or inband with bypass mode enabled. So we
> > need to decide how we deal with that - especially if we're going to be
> > changing the mode from 1000base-X to SGMII (which we do on some SFP
> > modules so they work at 10/100/1000.)
> 
> For the Marvell 88E1111:
> 
> - If switching into 1000base-X mode, then bypass mode is enabled by
> m88e1111_config_init_1000basex(). However, if AN is disabled in the
> fibre page BMCR (e.g. by firmware), then AN won't be used.
> 
> - If switching into SGMII mode, then bypass mode is left however it was
> originally set by m88e1111_config_init_sgmii() - so it may be allowed
> or it may be disallowed, which means it's whatever the hardware
> defaulted to or firmware set it as.
> 
> For the 88e151x (x=0,2,8) it looks like bypass mode defaults to being
> allowed on hardware reset, but firmware may change that.
> 
> I don't think we make much of an effort to configure other Marvell
> PHYs, relying on their hardware reset defaults or firmware to set
> them appropriately.
> 
> So, I think for 88e151x, we should implement something like:
> 
> 	int mode, bmcr, fscr2;
> 
> 	/* RGMII too? I believe RGMII can signal inband as well, so we
> 	 * may need to handle that as well.
> 	 */
> 	if (interface != PHY_INTERFACE_MODE_SGMII &&
> 	    interface != PHY_INTERFACE_MODE_1000BASE_X)
> 		return PHY_AN_INBAND_UNKNOWN;
> 
> 	bmcr = phy_read_paged(phydev, MII_MARVELL_FIBER_PAGE, MII_BMCR);
> 	if (bmcr < 0)
> 		return SOME_ERROR?

There's a limitation in the API presented here, you can't return
SOME_ERROR, you have to return PHY_AN_INBAND_UNKNOWN and maybe log the
error to the console. If the error persists, other PHY methods will
eventually catch it.

> 
> 	mode = PHY_AN_INBAND_OFF;
> 
> 	if (bmcr & BMCR_ANENABLE) {
> 		mode = PHY_AN_INBAND_ON;
> 
> 		fscr2 = phy_read_paged(phydev, MII_MARVELL_FIBER_PAGE,
> 				       0x1a);
> 		if (fscr2 & BIT(6))
> 			mode |= PHY_AN_INBAND_TIMEOUT;
> 	}
> 
> 	return mode;
> 
> Obviously adding register definitions for BIT(6) and 01a.
> 
> For the 88E1111:
> 
> 	int mode, hwcfg;
> 
> 	/* If operating in 1000base-X mode, we always turn on inband
> 	 * and allow bypass.
> 	 */
> 	if (interface == PHY_INTERFACE_MODE_1000BASEX)
> 		return PHY_AN_INBAND_ON | PHY_AN_INBAND_TIMEOUT;
> 
> 	if (interface == PHY_INTERFACE_MODE_SGMII) {
> 		hwcfg = phy_read(phydev, MII_M1111_PHY_EXT_SR);
> 		if (hwcfg < 0)
> 			return SOME_ERROR?
> 
> 		mode = PHY_AN_INBAND_ON;
> 		if (hwcfg & MII_M1111_HWCFG_SERIAL_AN_BYPASS)
> 			mode |= PHY_AN_INBAND_TIMEOUT;
> 
> 		return mode;
> 	}
> 
> 	return PHY_AN_INBAND_UNKNOWN;
> 
> Maybe?

Hmm, not quite (neither for 88E151x not 88E1111). The intention with the
validate()/config() split is that you either implement just validate(),
or both. If you implement just validate(), you should report just one
bit, corresponding to what the hardware is configured for (so either
PHY_AN_INBAND_ON, *or* PHY_AN_INBAND_TIMEOUT). This is because you'd
otherwise tell phylink that 2 modes are supported, but provide no way to
choose between them, and you don't make it clear which one is in use
either. This will force phylink to adapt to MLO_AN_PHY or MLO_AN_INBAND,
depending on what has a chance of working.

If you implement config_an_inband() too, then the validate procedure
becomes a simple report of what can be configured for that PHY
(OFF | ON | ON_TIMEOUT for 88E151x, and ON | ON_TIMEOUT for 88E1111).
It's then the config_an_inband() procedure that applies to hardware the
mode that is selected by phylink. From config_an_inband() you can return
a negative error code on PHY I/O failure.

If you can prepare some more formal patches for these PHYs for which I
don't have documentation, I think I have a copper SFP module which uses
SGMII and 88E1111, and I can plug it into the Honeycomb and see what
happens.
