Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB4776D222F
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 16:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbjCaOQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 10:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjCaOQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 10:16:54 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2093.outbound.protection.outlook.com [40.107.96.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83BE59F8;
        Fri, 31 Mar 2023 07:16:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LR/erU0eiZ1lqSbm1jMQ5HiAI9SANxQrq1z91SUobaCBWsyf6yuFKEIThw0yuvn2eQL51kBWe4Ve7szuWLsTC98/P3yHA4pddXMJn0LPl4yrlIQfG3fFgGpq/WgWPl8Tu35nvUdvjeoB3M2rDQcINPHd9oZKjNrZxDOuaysJ4MotczJjt6XKjvPe1jIMRTl9+SKEWtgPFFxyUMBz72yCtTk9I44ZiT5Ixq1MCPLXc4vwMauKzPxHg+PujJpGBzbuS4G/+mOv2eawhtEslFTincOPrYK3b4oH4UXKa6AmlXjSqTp02zbQXYhKSBmsp0x1sP8wVc3Kf8UHKodp3WMxzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7s0upNL+gjXpG7warmQ2FdMXqiicvUizHC7QBPZoDms=;
 b=QJg4a8tuMyFZYm6NyMeIefYv+ECfGF35nEE5uDXL6Cq8JlYYdGNzdKORPwmXwsE6NOhHpyNFynAa10THEBh8tAXTUgIVmqcTq/lUkt3Oo9JVtrKfQ3tZw8jaWXIH0vdMqhc7h6j5UzvGtjM7CA//aWGdqEqjO6Lqm4wiAjdanK3BcQO2y3LXYXzZWrRDRl3LaQfgOgs9LkZQ+KXue5NFww37SSOtnJ35hekm9yEYG0m4BUaU0X5PVOAGWmNSHoHIB+JOEEQd2B18zO7D+l3eNKSG2ExJKLCi1cTBf6Z5oRm7q1NKS5/RXr4pw80vHATzDVnw6fq8x54rO2jLMWmWAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7s0upNL+gjXpG7warmQ2FdMXqiicvUizHC7QBPZoDms=;
 b=Q3ng5vWnpTGHCEaKjSwh90wqLTGze+oX+wHgFqjZZJnwvbntURx6IcCmnT/32EMXK3dsjp2GUuTvax7j351pQqMkDrVHGpP4Eke61kwvy3iYkA41cQNJoUupPoasKdriCKz8cAWWywtZPZTI2+8JK7X6Iuv57qoOuSo/SfTpxHU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5637.namprd13.prod.outlook.com (2603:10b6:510:142::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.24; Fri, 31 Mar
 2023 14:16:47 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Fri, 31 Mar 2023
 14:16:46 +0000
Date:   Fri, 31 Mar 2023 16:16:40 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Kalle Valo <kvalo@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] ath11k: pci: Add more MODULE_FIRMWARE() entries
Message-ID: <ZCbrSLSnqHLIbkhZ@corigine.com>
References: <20230330143718.19511-1-tiwai@suse.de>
 <ZCbj94oDuVYLJtBn@corigine.com>
 <87a5ztja4m.wl-tiwai@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a5ztja4m.wl-tiwai@suse.de>
X-ClientProxiedBy: AM3PR03CA0056.eurprd03.prod.outlook.com
 (2603:10a6:207:5::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5637:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fc6b4bc-f503-426f-6fef-08db31f28f97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ervJwzHfBSL6IvtU8ovyq6j/61RA1M+rMw/xBcp2uXW6m2tTrv7fZsr9XsRJjxtdMqHb5b/y0U6kQDlJ0HcLWlfgR85x3Vax22ozLEpnt8o3CbyGKVf8/ErRncKr1N0Nu2YYcweONURQy4GXrD84Qt77CRr9kumw0yMd9R/PNl2ObEpNivUmGC0ifpqTKfzvLobNTshtT1zmdbvr3MkY/Aj+MwY5KPXSn2NcMeJVZZ+cgo5WSdBVMifHMC/UwcYfrERFR8CgYvHRNVhOpDPMNbcxH8ENEGpDOySuiHRe184tSA0u6YLGGYV3u8YqLuOp9UEPEKtOFfnk320SEfHSqQ6UaqtxOmZoS0jF9p39brKzGmQ+sqJmdGliS23qwkQzITRrcM7AaiHCHmhizrX3An5oiqvVGuYKE6a/glDostCGc3wasT1SpYgr8kfrgoRpgLI8TubvgO5cgLmwAxWQD2PArAPg59Vhy+OM1GSHDjOnWv2pnAxM59qQi05E/DR+wFB0mzX9YRZ3Pn/PQSOOhIowLtFUr+/ss/lUj9uF4TOOIEff3GrWQGLSPDsaZpta
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(376002)(346002)(136003)(39830400003)(451199021)(36756003)(8676002)(4326008)(6916009)(316002)(66946007)(66556008)(66476007)(6486002)(478600001)(8936002)(5660300002)(41300700001)(2906002)(44832011)(86362001)(38100700002)(186003)(2616005)(6666004)(6506007)(6512007)(83380400001)(66899021);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VdZrfL4lNjoB+Nj8y4Uvs2sCPGq8mA72WoSbpE17zeMimeO/czymCfkbuMkt?=
 =?us-ascii?Q?iPdMzah+zbVY6/I0z4Kaga5y6Akw/BJYKkm3PA/2b9at9obt5tRVoyqDWvHh?=
 =?us-ascii?Q?FvuJ2OwDFz8K57KUCEjmn+LUAoNxLsZridVW7Y9tV4497LY1Wbh1lQwCYcgk?=
 =?us-ascii?Q?JbQ6Jz2zhK33JEEK2nsvIyAsgBCr3VpsvmODCCQMYI2JazPPrqrt//VME+Yn?=
 =?us-ascii?Q?RrjO1k8FF3g9ZnoB7wXRPe8/X2RO9FSpDjZKDH+9pb5/H1OVY7Z8aR9Gtfbv?=
 =?us-ascii?Q?qsdHgpuacYThdVSQdJmc9VnoKYYYstkWEXP48/McdHjKhGWmaFUkYvCZ7qqj?=
 =?us-ascii?Q?ZNa6zGUoPw0syf+7EY4m4pGP/RiTeMZL95LF5jkW4SUhtSCbsxTsgD2BVTN3?=
 =?us-ascii?Q?jPgFiRfIL9eUtZJC1LvNOwYBhvBlQ2EsqfOsleEu5hg1fbVlUjs4tt4ATqGT?=
 =?us-ascii?Q?AZzE0NjWdw35QWnkSaFCBeNuihmG8RSsiAb+hkkkHpAnj5tJaRdd0HXEKHjE?=
 =?us-ascii?Q?S9qgl9550gicCKE6G+KQg/0qc52/DOu56mTNAImBeeMcy6SHrLttyyyhI6Ah?=
 =?us-ascii?Q?1vCmLBg28R9IGbbrv6ksemK9CGHM7aPoiPeF99hlj2M46+qPNDwHwQrshtqL?=
 =?us-ascii?Q?DJVXdXcGUiSchbG2uf38Kx2o2oRkMObKSNhienkgPcu9Sh2+qy2780S5/AEZ?=
 =?us-ascii?Q?rdIUum31+bMUF5uKdo44Dw8hlLGQ7gMxeJFly2gSMhpkIiV0IwluHi0hcauD?=
 =?us-ascii?Q?o4ina8Ea6ofJZccyvGB9N02PLXK9QJ//dxYW4nNdwzLVPGqoj+VSTSXLYRzK?=
 =?us-ascii?Q?96UgrdnRAWbRZvRJksUCQ57TyOKBPsMgAGUzSYcATztm/NgAKUmSauzKFNjm?=
 =?us-ascii?Q?R3fvZFQAdNqyuFwwjGHlCwgFHKlxFYK3ep68hiIwQW5o1aRj6NY3VLxj1odn?=
 =?us-ascii?Q?+uSSZtbxd+3SVJ6kS0pXq/klok+E9Jq1uYOwn02/3YcmB96SkjAWHF/5MDbk?=
 =?us-ascii?Q?8J/IViJl3XPPGY36iN8ClFyptgGZ5VDWvijEw97yCf+XDnIcTlVvnjbPPhuY?=
 =?us-ascii?Q?u0buPE0FzgZFWIqPEGIE/z69cR0uoj2LvcCoCMBSX8gQ31xrNv5Pa4QhwBZr?=
 =?us-ascii?Q?RGffsNfcYFMMFSU2buLySyZsbdh6b12KpHuO3TuNc2tkGWRqyALNpmVvMFTf?=
 =?us-ascii?Q?T4xMPiNXwc1JT7rWr+tFbdwTTZRk4Zl0Uu7Gx196s0qj55FbJrHDPFSRLPJC?=
 =?us-ascii?Q?BBUK9vkfgtEWy93EwAvHH8AoJR2bEo73x2zl3e1M3BQJszFWlo7fuxbU+ASc?=
 =?us-ascii?Q?Jn6RRLicTO+3smDq77s4LYbdEs0iYslPs7ddS9Y2T0FvS5c6GFRsBtQZMECa?=
 =?us-ascii?Q?BptLLJPgxUVOUsM2ZmanXapiQAEC3Xgqd6P/etbUPsr+VAhvWNye4krmWneK?=
 =?us-ascii?Q?lu2Of6UBwN9Hi0mEAjNAIlDZTHzzEpCrCimwe+X+EdcyEUpotiqfguW44zmU?=
 =?us-ascii?Q?e5xgRUZnceX+WRriuaoWkp5vGqHn4k/FvzsT4iQY5WjEC9157hB/dGVIYi0J?=
 =?us-ascii?Q?s/ay2w1Jx/r+CxIBFj4So80hRWZ9W5km5AvXyWLvZb90EnVj8Dws369MZX6Z?=
 =?us-ascii?Q?UXx80nSUCdhQ0dU941PbP7HJ7608yUk5Nsw+t9+X+cDRXLK9ssL7FPBkRAWg?=
 =?us-ascii?Q?wFAfdQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fc6b4bc-f503-426f-6fef-08db31f28f97
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 14:16:46.5645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DS2Y/3683iLfYiltws2DcE/66mejU7w6hy4Mut8kkw0MUcv5JtPNA2Dv55MmblgIDM76HCJkdr7Smsa6tgdWVQhLrnKPB275QE7Bx6vm9Jo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5637
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 03:58:17PM +0200, Takashi Iwai wrote:
> On Fri, 31 Mar 2023 15:45:27 +0200,
> Simon Horman wrote:
> > 
> > On Thu, Mar 30, 2023 at 04:37:18PM +0200, Takashi Iwai wrote:
> > > As there are a few more models supported by the driver, let's add the
> > > missing MODULE_FIRMWARE() entries for them.  The lack of them resulted
> > > in the missing device enablement on some systems, such as the
> > > installation image of openSUSE.
> > > 
> > > While we are at it, use the wildcard instead of listing each firmware
> > > files individually for each.
> > > 
> > > Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > > ---
> > > 
> > > I can rewrite without wildcards if it's preferred, too.
> > > But IMO this makes easier to maintain.
> > > 
> > >  drivers/net/wireless/ath/ath11k/pci.c | 9 +++++----
> > >  1 file changed, 5 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
> > > index 0aeef2948ff5..379f7946a29e 100644
> > > --- a/drivers/net/wireless/ath/ath11k/pci.c
> > > +++ b/drivers/net/wireless/ath/ath11k/pci.c
> > > @@ -1039,7 +1039,8 @@ module_exit(ath11k_pci_exit);
> > >  MODULE_DESCRIPTION("Driver support for Qualcomm Technologies 802.11ax WLAN PCIe devices");
> > >  MODULE_LICENSE("Dual BSD/GPL");
> > >  
> > > -/* QCA639x 2.0 firmware files */
> > > -MODULE_FIRMWARE(ATH11K_FW_DIR "/QCA6390/hw2.0/" ATH11K_BOARD_API2_FILE);
> > > -MODULE_FIRMWARE(ATH11K_FW_DIR "/QCA6390/hw2.0/" ATH11K_AMSS_FILE);
> > > -MODULE_FIRMWARE(ATH11K_FW_DIR "/QCA6390/hw2.0/" ATH11K_M3_FILE);
> > > +/* firmware files */
> > > +MODULE_FIRMWARE(ATH11K_FW_DIR "/QCA6390/hw2.0/*");
> > > +MODULE_FIRMWARE(ATH11K_FW_DIR "/QCN9074/hw1.0/*");
> > > +MODULE_FIRMWARE(ATH11K_FW_DIR "/WCN6855/hw2.0/*");
> > > +MODULE_FIRMWARE(ATH11K_FW_DIR "/WCN6855/hw2.1/*");
> > 
> > I don't feel strongly about this.
> > 
> > But unless I'm mistaken the above does seem to pick up a number of files
> > totalling around 25Mbytes. Perhaps that isn't ideal.
> 
> MODULE_FIRMWARE() itself is nothing but a hint for the required
> firmware files.  The driver supports those models, hence it should
> list up the mandatory firmware files that *can* be used with it;
> without the firmware, the driver itself is just useless, as you know.
> 
> The rest -- how to reduce the actual sizes -- is above the kernel
> modinfo covers, and it depends on the system implementation, IMO.
> It can be somehow more selective, it can compress data, or it can load
> the stuff on demands.

Thanks, understood.
If that is the case then I have no objections.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
