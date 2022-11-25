Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2C1638D88
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 16:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiKYPgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 10:36:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiKYPgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 10:36:05 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2052.outbound.protection.outlook.com [40.107.22.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC2D2C117
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 07:36:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U0lYWmzVvOmuiaTB/jvBDUvZPk7WE+B+d9HKphoR6o8DskuNc68t8yEPw6tpz/mxW13Idq0YyqYUH/PnpV2YQLa9c0hqy6OfdqkANoOGytde54Q2VRUJCg4RWvaVaWZVshIgzSEGceN4BgyPTXvpDGYj1sa4EybyY8jcfpv4/UG96+HJr/ysoi7gNWMwZwXLKwmbHM5izrpmfSSYtWThTruWwQ8LQ0YnF8ck7/ku+Y8TiHUqMlgJwcX2q5zucOcdyIFhGiAfusbI5B6FtbcbXlEyhc0iNTVwvnieqtvZ7lQUQBG1ZZysLZgXBlIfLc6jnU0lzIHsfiEEposwsPrtdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yqYgxuLkzHUQC5qm72d4XiLsKbBgaoDeEBrEfRa6ikQ=;
 b=bgUNWopc9eKWauHfv172iU9vFMU7OAyYGPMXlgDBhwh/rtYQXqZorxqxddC9dEq8moTmGspbG+evoW+8Y0fCOb6FvdoSjSolhTd4kg8/2Hdh8v4TaGQPFiKumzZBRa7xicTr2axSyR+/ILAG4Oilt/47moTR6kEg90llzgG00IZWb4pn5tCembPAidBmLh/FTOSL2qX/nJ+m6A/egX7CdC7afgS2y8yBiGl4bHa4eJuwwyv5XXxByqDeyYjrymFI5NFI2G33b5kih9oXLNWcR56SMGmZxBDXACZLe77/bgVAogM02KzqOwBN0KgTME2dX3qK2tj13W3cTrGQe5kVPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yqYgxuLkzHUQC5qm72d4XiLsKbBgaoDeEBrEfRa6ikQ=;
 b=q1Pu0e+z9jQ5eCZxGUyqrndkfeSMcSFjrOlaVeLw06RzRKt36dr3udEuyn3kf2v9XRDQhpJGSYHI6Bc1qbixvmt5lsmcVgGj85wlFKW4FxlOartMU3cjXjr8sMw4frHJkSha/fhWV5oCYggCuIafgRS8e8qY9oAbPCSxu1T/cu8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8433.eurprd04.prod.outlook.com (2603:10a6:20b:344::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.17; Fri, 25 Nov
 2022 15:35:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Fri, 25 Nov 2022
 15:35:59 +0000
Date:   Fri, 25 Nov 2022 17:35:55 +0200
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
Message-ID: <20221125153555.uzrl7j2me3lh2aeg@skbuf>
References: <Y3yvd0uyG2tNeED3@shell.armlinux.org.uk>
 <20221122121122.klqkw4onjxabyi22@skbuf>
 <Y3z/xcbYMQFM5SN4@shell.armlinux.org.uk>
 <20221122175603.soux2q2cxs2wfsun@skbuf>
 <Y30U1tHqLw0SWwo1@shell.armlinux.org.uk>
 <20221122193618.p57qrvhymeegu7cs@skbuf>
 <Y34NK9h86cgYmcoM@shell.armlinux.org.uk>
 <Y34b+7IOaCX401vR@shell.armlinux.org.uk>
 <20221125123022.cnqobhnuzyqb5ukw@skbuf>
 <Y4DGhv/6BHNaMEYQ@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4DGhv/6BHNaMEYQ@shell.armlinux.org.uk>
X-ClientProxiedBy: AM4PR07CA0013.eurprd07.prod.outlook.com
 (2603:10a6:205:1::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8433:EE_
X-MS-Office365-Filtering-Correlation-Id: fdd232af-70f5-45fd-1fb6-08dacefac074
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N4PdLUYyFXYlHWHtKY4gpjDGeaCDkaV89Bip25IhgmdhI5TiDrDMCzouLZUJq/vj0xt0un0vEdvY94KQFsBZDk70hLR8ZEQFRmxFjHXO7xxO0vUkg45TtR4kJh/aHtRF1Zc4JtA/K65EloMDz91srSQOQwxF69zHpcRJu1SOTIk3dFbMAhom8u7IG2SnpUf3KozjPtkD7hiY1pJ4dHOCIDBldAmjYHahdxWx9jDIDKET5fg+kv3wpJsMKUZfIhZYmYXXKqRFi63O2dyBT1ExWoNODh7ehB3+HFuf5pjToimPy4zb2Wkt+EiA94P3rBzRJAjzmfRpbLoXcrg0oeQIq0Qkj5DBKRf5gGgGOBwzmUxNTW9vCWttHxlYxRbiknNL8AK8a2C6MvoVVDwMbsQTvtulpED2xrpNrMvOAq++AEbC55hdfX0uKoHbI2y45qUDAb5WDLQ7in2R3co94zWRHvkzk4VpiPG9DvtI8jSUkqYo/sd6Sr9vO+s812DP6OgZs6/RcDRZKlEmRQrLJ4B+LciVYfo1Z0KPkdq1BID+cXLryfIi959XgcTyAbeUNecJ+Uax35YrgtyNJVn6fqPRAvf45tBwhfcq8LvyD+hh1vVj3i1MoxbVEZ4Kn2P6JP0LgBoZJ7PmuAZBqtdD7oRT3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(366004)(396003)(346002)(376002)(136003)(39860400002)(451199015)(86362001)(6916009)(54906003)(6486002)(186003)(1076003)(6506007)(6666004)(26005)(5660300002)(66946007)(478600001)(30864003)(8936002)(7416002)(44832011)(41300700001)(316002)(2906002)(4326008)(8676002)(66556008)(66476007)(9686003)(38100700002)(6512007)(83380400001)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZoftRr5lx77tiD9pILxCzn2l/V2xpOwnH4P6NAh9q0cAy4VMFry9yCflmZIV?=
 =?us-ascii?Q?lyK0UtWuct4kC7OmuHtm/cF+2gwXNw8gz0C2ny3gzqZ7NPRk+7xKXwXllnyR?=
 =?us-ascii?Q?aYDAaY9Gx8HELYZyvbMI6U5mKs24YPQkc91NjnT+0SmDoooUIrOwI0CsReiD?=
 =?us-ascii?Q?sSCHiRbQN7VHLvHSQDFEr2EgGDaceozVTJJXJNSfszE+aEwi3eSoXjUUetH4?=
 =?us-ascii?Q?RkLqsz5tld+TX4o8f9Q17NgPy37JtlvvjHaiIki/GqlFPariVbGmurM2HxXD?=
 =?us-ascii?Q?fr1tIXUSmJAi9Gz6FOiHDRXv8DkYComqWgxdF51ZaK53LQOaIlGmlmfXsRRW?=
 =?us-ascii?Q?uwawv3qCjz6aWSTstEKEHfHq28VMtBf/H7R+/pzvcfyhGz1ZeTh8qrd6O/cO?=
 =?us-ascii?Q?Wd+c0ym7g+6aMVsrQDK+7AI50GikpF90hh20w5X1Ucvfup0LGecvKq76ezBP?=
 =?us-ascii?Q?LW+2l19KZ9yc8t6UljYHD2K2pBM3fHR2oCo9+Ru6+WJpSV4zzjw6oiEpktC8?=
 =?us-ascii?Q?uyrcWTNYhcdMVJBBg1jxgUDWbSTMpf/oVKbBzv2Z0wew7olP6yIlTyJzLgoS?=
 =?us-ascii?Q?mjzNJkFpyhA0erVN5IHFhU0mzuDinRrcKRNhrQ6HHlMzOHOf8IFQ2FguCBxU?=
 =?us-ascii?Q?bkDjqfemUpi6GaM7TYXLQPGjCq5ALEYWOg7PwyQrY+rcCVs1SpYEb8JR6r4X?=
 =?us-ascii?Q?k0/Nn13ITBY26r+Z1DiUseDEFARrj3NzntqZJ0kzbCaQFViRgdjNA9TMg21w?=
 =?us-ascii?Q?qS+6I7Z7Fqet/VdPHjXYeYA2gvmmBRs6/m2y/b8H9M2fwyo8tax2295ULkHg?=
 =?us-ascii?Q?pkL85UGwreoj1zfGA6k42bumBJ+NQTJhqDuLMfL96K7GVbPiy4tQJv9bIub0?=
 =?us-ascii?Q?seEp47MXEoTUe5xvDI2G8RHWNkc5Gjs+VZppZRx4gXrVYGjnWummybzF7Wl2?=
 =?us-ascii?Q?PFj1oAadHTjwFTUOpBVKCYm1O1QMFaiSOf8h2FASnvh6OjPhLH2GopElZD65?=
 =?us-ascii?Q?7v04y5XhSloK41JBAKNpLbwJZepzyW9ZspIvw3NtVPoEsEV9JmX+FmySSHs0?=
 =?us-ascii?Q?WeMEgv7E0I4ghC0Kvakg1jDVWITeRjrEWtaJtDtEiS9DizK0FEvUBrD8mm7V?=
 =?us-ascii?Q?1CKYzZCRL/vbAeNUxixxoJVlrmgvUVLIA2vudH4A33vleCN4wr7jBzTsJFqM?=
 =?us-ascii?Q?3Gg3g1SvlYcZ3x86eU3PElkQLmfp3SApQ+DIJAeECrBv4nO3rNjtG0RGgpau?=
 =?us-ascii?Q?63pDOZmasFisIl5XL/7FPQqQY/LFjb8KbW3R2yfK01EWVCh6dWzpxYYO6MN3?=
 =?us-ascii?Q?yMOXXMwPAnEsGzVhvdvb1k3pbs56hoG8Hde6AijNzyf6ryz8Hdx0RykJsAe0?=
 =?us-ascii?Q?YoklT8MHch0XzmI407ALiaqLSGa8Ge2T4d3GLcvFeWYaDHMfi2jpT93dMWOL?=
 =?us-ascii?Q?RbCiq/5GM0ogjRzXzykSCsv8mElHgd84DC4pdIJHMzMAYQh/jQMW/Qw5fTcb?=
 =?us-ascii?Q?aQgSYmTq1V31Ur1up0DfPOb3XKnEsH2zPCY70vaUf5AjLr95RqAtxzQrBH9B?=
 =?us-ascii?Q?eGf6w+hzPUy9LrNgeaUqUm2XFsmekeAj6IBZAQwLt5ld5MLU0d7Eu/W6vQqp?=
 =?us-ascii?Q?vg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdd232af-70f5-45fd-1fb6-08dacefac074
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 15:35:59.4515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s6K4hcncXsuQNP09FFEWCsbUY9YmienSKCG4BBaiIQjJgvx7XunDtBRQTJNiCMlhF1zj+9YKhjXca68O3AZXSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8433
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 25, 2022 at 01:43:34PM +0000, Russell King (Oracle) wrote:
> Hi Vladimir,
> 
> On Fri, Nov 25, 2022 at 02:30:42PM +0200, Vladimir Oltean wrote:
> > Hi Russell,
> > 
> > Sorry for the delay. Had to do something else yesterday and the day before.
> 
> I think there was some kind of celebration going on in the US for at
> least one of those days...

Yeah, but I don't celebrate that. I had to write some documentation.

> > So the default EXT_SR is being changed by the PHY driver from 0x9088 to
> > 0x9084 (MII_M1111_HWCFG_MODE_COPPER_1000X_AN -> MII_M1111_HWCFG_MODE_SGMII_NO_CLK).
> > 
> > I don't know if it's possible to force these modules to operate in
> > 1000BASE-X mode. If you're interested in the results there, please give
> > me some guidance.
> 
> The value of "EXT_SR before" is 1000base-X, so if you change sfp-bus.c::
> sfp_select_interface() to use 1000BASEX instead of SGMII then you'll be
> using 1000BASEX instead (and it should work, although at fixed 1G
> speeds). The only reason the module is working in SGMII mode is because,
> as you've noticed above, we switch it to SGMII mode in
> m88e1111_config_init_sgmii().
> 

Which is an interesting thing, because m88e1111_config_init_1000basex()
does not change the HWCFG_MODE_MASK to something with 1000X in it.

Anyway, with sfp_select_interface() hacked, I can confirm it works in
1000BASE-X with AN enabled too.

[   69.746643] fsl_dpaa2_eth dpni.1 dpmac7: configuring for inband/sgmii link mode
[   69.845784] fsl_dpaa2_eth dpni.1 dpmac7: PHY driver reported AN inband 0x4 // PHY_AN_INBAND_ON_TIMEOUT
[   69.852764] fsl_dpaa2_eth dpni.1 dpmac7: switched to inband/1000base-x link mode // MLO_AN_INBAND
[   69.934191] Marvell 88E1111 i2c:sfp-0:16: m88e1111_config_init_1000basex: EXT_SR before 0x9088 after 0x9088, fiber page BMCR before 0x1140 after 0x1140
[   70.015735] fsl_dpaa2_eth dpni.1 dpmac7: PHY [i2c:sfp-0:16] driver [Marvell 88E1111] (irq=POLL)

ping 192.168.100.2
PING 192.168.100.2 (192.168.100.2) 56(84) bytes of data.
64 bytes from 192.168.100.2: icmp_seq=1 ttl=64 time=0.874 ms
64 bytes from 192.168.100.2: icmp_seq=2 ttl=64 time=0.225 ms
64 bytes from 192.168.100.2: icmp_seq=3 ttl=64 time=0.216 ms
^C
--- 192.168.100.2 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2019ms
rtt min/avg/max/mdev = 0.216/0.438/0.874/0.308 ms

printed with code:

static int m88e1111_config_init_1000basex(struct phy_device *phydev)
{
	int extsr = phy_read(phydev, MII_M1111_PHY_EXT_SR);
	int fiber_bmcr_before, fiber_bmcr_after;
	int ext_sr_after;
	int err, mode;

	if (extsr < 0)
		return extsr;

	fiber_bmcr_before = phy_read_paged(phydev, MII_MARVELL_FIBER_PAGE, MII_BMCR);
	if (fiber_bmcr_before < 0)
		return fiber_bmcr_before;

	/* If using copper mode, ensure 1000BaseX auto-negotiation is enabled.
	 * FIXME: does this actually enable 1000BaseX auto-negotiation if it
	 * was previously disabled in the Fiber BMCR? 2.3.1.6 suggests not!
	 */
	mode = extsr & MII_M1111_HWCFG_MODE_MASK;
	if (mode == MII_M1111_HWCFG_MODE_COPPER_1000X_NOAN) {
		err = phy_modify(phydev, MII_M1111_PHY_EXT_SR,
				 MII_M1111_HWCFG_MODE_MASK |
				 MII_M1111_HWCFG_SERIAL_AN_BYPASS,
				 MII_M1111_HWCFG_MODE_COPPER_1000X_AN |
				 MII_M1111_HWCFG_SERIAL_AN_BYPASS);
		if (err < 0)
			return err;
	}

	ext_sr_after = phy_read(phydev, MII_M1111_PHY_EXT_SR);
	if (ext_sr_after < 0)
		return ext_sr_after;

	fiber_bmcr_after = phy_read_paged(phydev, MII_MARVELL_FIBER_PAGE, MII_BMCR);
	if (fiber_bmcr_after < 0)
		return fiber_bmcr_after;

	phydev_err(phydev, "%s: EXT_SR before 0x%x after 0x%x, fiber page BMCR before 0x%x after 0x%x\n",
		   __func__, extsr, ext_sr_after,
		   fiber_bmcr_before, fiber_bmcr_after);
	return 0;
}

Furthermore, I can confirm that if the fiber page BMCR has BMCR_ANENABLE
disabled, the link with my Lynx PCS in MLO_AN_INBAND is broken (and that
the write to EXT_SR doesn't change the value of the BMCR).



But there's actually a problem (or maybe two problems).

First is that if I make phylink treat the ON_TIMEOUT capability by using
MLO_AN_PHY (basically like this):

phylink_sfp_config_phy():

	/* Select whether to operate in in-band mode or not, based on the
	 * capability of the PHY in the current link mode.
	 */
	ret = phy_validate_an_inband(phy, iface);
	phylink_err(pl, "PHY driver reported AN inband 0x%x\n", ret);
	if (ret == PHY_AN_INBAND_UNKNOWN) {
		mode = MLO_AN_INBAND;

		phylink_dbg(pl,
			    "PHY driver does not report in-band autoneg capability, assuming true\n");
//	} else if (ret & (PHY_AN_INBAND_ON | PHY_AN_INBAND_ON_TIMEOUT)) {
	} else if (ret & PHY_AN_INBAND_ON) {
		mode = MLO_AN_INBAND;
	} else {
		mode = MLO_AN_PHY;
	}

[   30.059923] fsl_dpaa2_eth dpni.1 dpmac7: PHY driver reported AN inband 0x4 // PHY_AN_INBAND_ON_TIMEOUT
[   30.066867] fsl_dpaa2_eth dpni.1 dpmac7: switched to phy/1000base-x link mode // MLO_AN_PHY
[   30.153350] Marvell 88E1111 i2c:sfp-0:16: m88e1111_config_init_1000basex: EXT_SR before 0x9088 after 0x9088, fiber page BMCR before 0x1140 after 0x1140
[   30.238970] fsl_dpaa2_eth dpni.1 dpmac7: PHY [i2c:sfp-0:16] driver [Marvell 88E1111] (irq=POLL)

then pinging is broken with mismatched in-band AN settings ("TIMEOUT" in
PHY, "OFF" in PCS). I triple-checked this.

ping 192.168.100.2
PING 192.168.100.2 (192.168.100.2) 56(84) bytes of data.
From 192.168.100.1 icmp_seq=1 Destination Host Unreachable
From 192.168.100.1 icmp_seq=2 Destination Host Unreachable
From 192.168.100.1 icmp_seq=3 Destination Host Unreachable
From 192.168.100.1 icmp_seq=4 Destination Host Unreachable
From 192.168.100.1 icmp_seq=5 Destination Host Unreachable
From 192.168.100.1 icmp_seq=6 Destination Host Unreachable
^C
--- 192.168.100.2 ping statistics ---
9 packets transmitted, 0 received, +6 errors, 100% packet loss, time 8170ms


However, if using the same phylink code (to force a mismatch), I unhack
sfp_select_interface() and use SGMII mode, the timeout feature does
actually work:

[   30.262979] fsl_dpaa2_eth dpni.1 dpmac7: PHY driver reported AN inband 0x4 // PHY_AN_INBAND_ON_TIMEOUT
[   30.270349] fsl_dpaa2_eth dpni.1 dpmac7: switched to phy/sgmii link mode // MLO_AN_PHY
[   30.351066] Marvell 88E1111 i2c:sfp-0:16: m88e1111_config_init_sgmii: EXT_SR before 0x9088 after 0x9084, fiber page BMCR before 0x1140 after 0x1140
[   30.433236] fsl_dpaa2_eth dpni.1 dpmac7: PHY [i2c:sfp-0:16] driver [Marvell 88E1111] (irq=POLL)

this is a functional link despite the mismatched settings.

ping 192.168.100.2
PING 192.168.100.2 (192.168.100.2) 56(84) bytes of data.
64 bytes from 192.168.100.2: icmp_seq=1 ttl=64 time=0.885 ms
64 bytes from 192.168.100.2: icmp_seq=2 ttl=64 time=0.221 ms
64 bytes from 192.168.100.2: icmp_seq=3 ttl=64 time=0.216 ms
64 bytes from 192.168.100.2: icmp_seq=4 ttl=64 time=0.217 ms
64 bytes from 192.168.100.2: icmp_seq=5 ttl=64 time=0.238 ms
^C
--- 192.168.100.2 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4062ms
rtt min/avg/max/mdev = 0.216/0.355/0.885/0.264 ms


The second problem is that not even *matched* settings work if I turn
off BMCR_ANENABLE in the PHY fiber page.

[   30.809869] fsl_dpaa2_eth dpni.1 dpmac7: configuring for inband/sgmii link mode
[   30.817936] mdio_bus 0x0000000008c1f000:00: MII_BMCR 0x1140 MII_BMSR 0x9 MII_ADVERTISE 0x1 MII_LPA 0x0 IF_MODE 0x3 // PCS registers at the end of lynx_pcs_config_giga()
[   30.917651] fsl_dpaa2_eth dpni.1 dpmac7: PHY driver reported AN inband 0x4 // ignore; m88e1111_validate_an_inband() is hardcoded for this and does not detect BMCR for BASE-X
[   30.924571] fsl_dpaa2_eth dpni.1 dpmac7: switched to phy/1000base-x link mode
[   30.932441] mdio_bus 0x0000000008c1f000:00: MII_BMCR 0x140 MII_BMSR 0xd MII_ADVERTISE 0x1 MII_LPA 0x0 IF_MODE 0x1
[   31.032547] Marvell 88E1111 i2c:sfp-0:16: m88e1111_config_init_1000basex: EXT_SR before 0x9088 after 0x9088, fiber page BMCR before 0x140 after 0x140
[   31.117668] fsl_dpaa2_eth dpni.1 dpmac7: PHY [i2c:sfp-0:16] driver [Marvell 88E1111] (irq=POLL)

ping 192.168.100.2
PING 192.168.100.2 (192.168.100.2) 56(84) bytes of data.
^C
--- 192.168.100.2 ping statistics ---
4 packets transmitted, 0 received, 100% packet loss, time 3058ms

What's common is that if in-band autoneg is turned off (either forced
off or via timeout), 1000BASE-X between the Lynx PCS and the 88E1111
simply doesn't work.

> > I was curious if the fiber page BMCR has an effect for in-band autoneg,
> > and at least for SGMII it surely does. If I add this to
> > m88e1111_config_init_sgmii():
> > 
> > 	phy_modify_paged(phydev, MII_MARVELL_FIBER_PAGE, MII_BMCR,
> > 			 BMCR_ANENABLE, 0);
> > 
> > (and force an intentional mismatch) then I am able to break the link
> > with my Lynx PCS.
> 
> Yes, the fiber page is re-used for the host side of the link when
> operating in SGMII and 1000baseX modes, so changes there have the
> expected effect.
> 
> > If my hunch is correct that this also holds true for 1000BASE-X, then
> > you are also correct that m88e1111_config_init_1000basex() only allows
> > AN bypass but does not seem to enable in-band AN in itself, if it wasn't
> > enabled.
> > 
> > The implication here is that maybe we should test for the fiber page
> > BMCR in both SGMII and 1000BASE-X modes?
> 
> I think a more comprehensive test would be to write the fiber page
> BMCR with 0x140 before changing the mode from 1000baseX to SGMII and
> see whether the BMCR changes value. My suspicion is it won't, and
> the hwcfg_mode only has an effect on the settings in the fiber page
> under hardware reset conditions, and mode changes have no effect on
> the fiber page.

Confirmed that changes to the EXT_SR register don't cause changes to the
MII_BMCR register:

[   28.587838] Marvell 88E1111 i2c:sfp-0:16: m88e1111_config_init_sgmii: EXT_SR before 0x9088 after 0x9084, fiber page BMCR before 0x140 after 0x140

generated by:

static int m88e1111_config_init_sgmii(struct phy_device *phydev)
{
	int fiber_bmcr_before, fiber_bmcr_after;
	int ext_sr_before, ext_sr_after;
	int err;

	ext_sr_before = phy_read(phydev, MII_M1111_PHY_EXT_SR);
	if (ext_sr_before < 0)
		return ext_sr_before;

	err = phy_modify_paged(phydev, MII_MARVELL_FIBER_PAGE, MII_BMCR,
			       BMCR_ANENABLE, 0);
	if (err < 0)
		return err;

	fiber_bmcr_before = phy_read_paged(phydev, MII_MARVELL_FIBER_PAGE, MII_BMCR);
	if (fiber_bmcr_before < 0)
		return fiber_bmcr_before;

	err = m88e1111_config_init_hwcfg_mode(
		phydev,
		MII_M1111_HWCFG_MODE_SGMII_NO_CLK,
		MII_M1111_HWCFG_FIBER_COPPER_AUTO);
	if (err < 0)
		return err;

	ext_sr_after = phy_read(phydev, MII_M1111_PHY_EXT_SR);
	if (ext_sr_after < 0)
		return ext_sr_after;

	fiber_bmcr_after = phy_read_paged(phydev, MII_MARVELL_FIBER_PAGE, MII_BMCR);
	if (fiber_bmcr_after < 0)
		return fiber_bmcr_after;

	phydev_err(phydev, "%s: EXT_SR before 0x%x after 0x%x, fiber page BMCR before 0x%x after 0x%x\n",
		   __func__, ext_sr_before, ext_sr_after,
		   fiber_bmcr_before, fiber_bmcr_after);

	/* make sure copper is selected */
	return marvell_set_page(phydev, MII_MARVELL_COPPER_PAGE);
}
