Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D83256EF33D
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 13:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240443AbjDZLSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 07:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbjDZLST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 07:18:19 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2043.outbound.protection.outlook.com [40.107.20.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 109FB3C29;
        Wed, 26 Apr 2023 04:18:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BzHzday95Z9dFdv28oy5LheGJHAD60dokt5BvoIwa7/+sqqNVdtOCWj7GEcmEvsiI23h+MCN7d9vjdY36ZeKl4e7dmxCMqq/utYrTszbhhY5PffXvRhqH+B4jiff15hDMnzqziWE0V3yUaGxnZEaUsHByQ39+TVPDOC62RGeJ5XYPBnSGCHk7D4rQAZjhpNj8v2AaJ9A4Kt3Lg9e3zpmrm+PYyENtmHsyYISP77zD74Nft52rh/MtqDRRmW+LHCXPA/4W/CrSWQOasx50LALaOkzCHobFcse6DaobaIY6lI8UzrZ8cRY3X40ghz/Fdn5st55BmfjaEzjw+9WDGLxVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mfFyYYs2XcUPEHSQb7j4e0SaNBZKkPCcvo1UgQeclT8=;
 b=c1aP+xFi1yNcsIF35EkpOrUQXEyNRBf5lRT+xRzk6dkFKYJDwVTiEuDjFfkzWSiocAxGYZ5x1+EmWpzkLs2XT4gabHXMl6YnTVwnaewjjBi1iPwJwWEDaKQA9usxT3BFOMhgWyn9aRKMmz8Mz0zLWz+1L5ISbd831TxdZUezAaDjLLFIzAbPMZujPPXy9yDGQXFYUKhnQ2voKfAdquGs3/TVJFUS+NZaJKKO8awvDgvgcWd1iPgc8Oc0k0+nmA9HfiOIh4JtRd0e6EijBB0jqmObupzDpx8k6bCU3cWeqXxxwSVn12QBYsM/T/zdsd6uW1QUrVPLKIqOUpr4UDoHAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mfFyYYs2XcUPEHSQb7j4e0SaNBZKkPCcvo1UgQeclT8=;
 b=UO526r8EomOPoiZjGbXS6BAJVSsckDK/pUsnv3FIQNVlfz4BFIsmP+oT1cJq0M5E8Rd5rk3ePQVbi+wCQC5Bp1L3tNIJ/mDPlWsaRI3cHtMoTSbhlAr1dXN+5W4+dCvt06Njuilzgp+9RfPnCaECfWYan/Sx44zYEiXmtgMqNhE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DBBPR04MB7962.eurprd04.prod.outlook.com (2603:10a6:10:1e7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Wed, 26 Apr
 2023 11:18:13 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6340.021; Wed, 26 Apr 2023
 11:18:13 +0000
Date:   Wed, 26 Apr 2023 14:18:09 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Harini Katakam <harini.katakam@amd.com>
Cc:     robh+dt@kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com,
        wsa+renesas@sang-engineering.com,
        krzysztof.kozlowski+dt@linaro.org, simon.horman@corigine.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, harinikatakamlinux@gmail.com,
        michal.simek@amd.com, radhey.shyam.pandey@amd.com
Subject: Re: [PATCH net-next v2 3/3] phy: mscc: Add support for VSC8531_02
 with RGMII tuning
Message-ID: <20230426111809.s647kol4dmas46io@skbuf>
References: <20230426104313.28950-1-harini.katakam@amd.com>
 <20230426104313.28950-1-harini.katakam@amd.com>
 <20230426104313.28950-4-harini.katakam@amd.com>
 <20230426104313.28950-4-harini.katakam@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230426104313.28950-4-harini.katakam@amd.com>
 <20230426104313.28950-4-harini.katakam@amd.com>
X-ClientProxiedBy: FR3P281CA0125.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::7) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DBBPR04MB7962:EE_
X-MS-Office365-Filtering-Correlation-Id: cdebc09e-1f70-47dd-9d9a-08db4647ecb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jUk665oYcIvRO81sX9Ogj0H4QaXej1PDigm0hr7m5OhEVx7oanv0NGxois+p5w9VDESs84Gpa+xpdqpuaJMd5UFGaUrl2WbQmV1MSeGSG+1vS6PD5eK8JPW8ixQMjnfF+hxWzKPlvo9U6LOzF6WWqc/vv6/tH5NET5zRlBaaj8bcfhbFCVxl3KmvQitZairsCFiBsXRwCDE66sH1FGifmt0KRpdPbtF0lXaeWkvpuiY0A02In/jk2xT+0Yp9cqka3uTIePhfdAvBXGmaI1jm0oL507zmu0fsOPfZiFxft2zbslV1Sc8ZexLHHxmvprzYGpN5bfXk4zhokSSMjRS2qXKjJtpyxKC+0tBiHxRxubLq6ROaRGIikoyq+s1YvEsv/lXzkz2PxEAwTb5x6DF1Puno38mpq7kiHQ/UCHAD583mFh3RE2guH+8TKKC0izNj6Eu24Y31mPdn79EMLTjE0nY2mg+plW7rF7hSG3omoMdThBsQ6XYbGNUTVcY2W7Yclq6LLvTOx4QUa6Rejpl/FAIr+K1SLTSPNJS8UmDn6N0YQhXQ4jxsXvD7SXiNeXc3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(376002)(39860400002)(396003)(136003)(346002)(366004)(451199021)(83380400001)(316002)(86362001)(33716001)(9686003)(41300700001)(186003)(66946007)(6512007)(8676002)(8936002)(66476007)(66556008)(6506007)(1076003)(26005)(5660300002)(7416002)(6916009)(4326008)(44832011)(38100700002)(6486002)(478600001)(6666004)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nEzUuZBz/0srgVwNJ/Dismw66K3EF+b0AqmgQzJXG3xG1+1CXxX8E31+qpey?=
 =?us-ascii?Q?DyYsfbx0QtA18ojOfCQ5QKuMm9QcdTgEUJhrDDQ8GNqHZe8PfwWxQKjYD8gk?=
 =?us-ascii?Q?mI3PGYfBl3KAYkU3vuA0eHedHOw9kE8FatVz3lDt42N8oieNY5L6TX5vXXEg?=
 =?us-ascii?Q?YwCVaHVs7Ll9ffFyuArLsp7C8FWshYJofUQ6pUsQ2ugqnNiv8FER840N2hL8?=
 =?us-ascii?Q?CJ/tEU/vjmqU9N2IHoqXN+Of0sjWXrP+Yd0lbyT/q1sDbLDPWIkuUeSE1jCX?=
 =?us-ascii?Q?d7wUPekyAJebOM8ZoT76o+dmvNhrBVvj6zdAk4DWvhfRTQObmlPrOe+Vr88F?=
 =?us-ascii?Q?3FO9ewxJdv9wLdDQAhM1F7raPBh8sPrxyV41SIM42AclVG4TYE/FukXPRDXb?=
 =?us-ascii?Q?jtRsaKxw3IzaksSEzho80zj46K+3/gH25drkViIUSenb/M6qL22oPI/8xCPy?=
 =?us-ascii?Q?Oocakip3MgGOqWh+u2XCN3r/T4VJMrgvevK4mTE50f3LSxdmDcfEOTjQ10JL?=
 =?us-ascii?Q?dQN5Tba5p0dXuYq2GhVvAPVRa03REP8z+QkQ9V2NJGb5xUEesHO4k6Fpel/O?=
 =?us-ascii?Q?roerTFaGbMF1SMdDdhtXxTu6VuIhKwdYELnHjgGVhnNhohTfYspvBYERo3f9?=
 =?us-ascii?Q?LGhpg/5xYgXhFYyUONcN7AWNjvA4YfIWL3GQdTuFkVPYYKZyWkQ0aPJ9VQuc?=
 =?us-ascii?Q?Bi55IEXSe5vAzhBfit3wdx6liaC6D7zP1R0n/hf3d6QHihxuV7jMx7FD13H4?=
 =?us-ascii?Q?ayRYnDbfT86guT4CG9lb1DzWKKtCutn33NdFc5ytb0e7llTKIR6DfcwvzZ+y?=
 =?us-ascii?Q?4PO4MfXqLftZQVlaO3bS1fEr2yEsjbl8+Zs90ZXBzAjgNRJotQjFcgIL+Oac?=
 =?us-ascii?Q?67wBwGOVSrblwxqU2IAkafPU1UshD5nG7nhvtS4/Wc5kYdrO5C8BIfI8JdAL?=
 =?us-ascii?Q?k1OAzpqFH1RKTXgaB3P1ZEz4sVff5TspCHQTQQVSFHN3UhE7Au4+QWlo0suW?=
 =?us-ascii?Q?j9Ji9QWVYmPjG8yGY4Re9G7Bbznb/nexHe6KvTPOXUvIJiT3O+DRmY/7//NX?=
 =?us-ascii?Q?aXSQC4PS3ToTvY+C6GnNuTA+UL7/MIX4YPndzf12ixxNZoAuXXZhhM6DdBPd?=
 =?us-ascii?Q?o2Jl8eGfottGpHOMjTONdafnLEDhQ5iIXvA+U9Rq/U9upOGKWk+qdJGfvtLi?=
 =?us-ascii?Q?TsMB6CRLrz1T2X31wxz5D9DdZNc/PPRtxLKkpmkU9/HDQ6bWZvwjkfNItz9q?=
 =?us-ascii?Q?vcskFzTfivA96szbFMqoajdQMY5OzGBTuJIj186pz1EZiBdz0GJT25kO1S6F?=
 =?us-ascii?Q?g756WW7ILj3wr4e8UZc5qG6en7+iiVIOROafLwYnzhrPAYjqNErObVRxVYkB?=
 =?us-ascii?Q?/34y+74chVecrFkzTbHv/xRhabKyZEic68Tvc4cWuM1cFUWA6WwA7nEnu3Is?=
 =?us-ascii?Q?zdkzbltxp7B6vcRNP+jE0aCvRjSp/Jjt0U4B2P8Br62GMMMhfP+NHVq0pB4/?=
 =?us-ascii?Q?yUb35NkYGisT5GLpTIh66tGgUOCxW3pTCixNFHmS1G/WTnI3MtaKx6BhE4Cw?=
 =?us-ascii?Q?CCve2WMYlilrgAoxTC9zsE04x0rPYQc/PRoydtFbCdjd9ulQSG5fSUCtu2Ax?=
 =?us-ascii?Q?lA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdebc09e-1f70-47dd-9d9a-08db4647ecb4
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 11:18:13.2284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7P1idmuseVo8qH0hLVdScm/Mtj/AbpPcpaaJzoFErZnBZGfmgM2V1FVhRuVSegaDUGXeCbZ0uWmUoXbukdpILA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7962
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 04:13:13PM +0530, Harini Katakam wrote:
> From: Harini Katakam <harini.katakam@xilinx.com>
> 
> Add support for VSC8531_02 (Rev 2) device.
> Add support for optional RGMII RX and TX delay tuning via devicetree.
> The hierarchy is:
> - Retain the defaul 0.2ns delay when RGMII tuning is not set.
> - Retain the default 2ns delay when RGMII tuning is set and DT delay
> property is NOT specified.
> - Use the DT delay value when RGMII tuning is set and a DT delay
> property is specified.
> 
> Signed-off-by: Harini Katakam <harini.katakam@amd.com>
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> v2:
> - Switch both VSC8531 and VSC8531-02 to use exact phy id match as they
> share the same model number
> - Ensure RCT
> - Improve optional property read
> 
>  drivers/net/phy/mscc/mscc.h      |  3 +++
>  drivers/net/phy/mscc/mscc_main.c | 40 ++++++++++++++++++++++++++++----
>  2 files changed, 39 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
> index a50235fdf7d9..5a26eba0ace0 100644
> --- a/drivers/net/phy/mscc/mscc.h
> +++ b/drivers/net/phy/mscc/mscc.h
> @@ -281,6 +281,7 @@ enum rgmii_clock_delay {
>  #define PHY_ID_VSC8514			  0x00070670
>  #define PHY_ID_VSC8530			  0x00070560
>  #define PHY_ID_VSC8531			  0x00070570
> +#define PHY_ID_VSC8531_02		  0x00070572
>  #define PHY_ID_VSC8540			  0x00070760
>  #define PHY_ID_VSC8541			  0x00070770
>  #define PHY_ID_VSC8552			  0x000704e0
> @@ -373,6 +374,8 @@ struct vsc8531_private {
>  	 * package.
>  	 */
>  	unsigned int base_addr;
> +	u32 rx_delay;
> +	u32 tx_delay;
>  
>  #if IS_ENABLED(CONFIG_MACSEC)
>  	/* MACsec fields:
> diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
> index 75d9582e5784..80cc90a23d57 100644
> --- a/drivers/net/phy/mscc/mscc_main.c
> +++ b/drivers/net/phy/mscc/mscc_main.c
> @@ -525,6 +525,7 @@ static int vsc85xx_rgmii_set_skews(struct phy_device *phydev, u32 rgmii_cntl,
>  {
>  	u16 rgmii_rx_delay_pos = ffs(rgmii_rx_delay_mask) - 1;
>  	u16 rgmii_tx_delay_pos = ffs(rgmii_tx_delay_mask) - 1;
> +	struct vsc8531_private *vsc8531 = phydev->priv;
>  	u16 reg_val = 0;
>  	int rc;
>  
> @@ -532,10 +533,10 @@ static int vsc85xx_rgmii_set_skews(struct phy_device *phydev, u32 rgmii_cntl,
>  
>  	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID ||
>  	    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
> -		reg_val |= RGMII_CLK_DELAY_2_0_NS << rgmii_rx_delay_pos;
> +		reg_val |= vsc8531->rx_delay << rgmii_rx_delay_pos;
>  	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID ||
>  	    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
> -		reg_val |= RGMII_CLK_DELAY_2_0_NS << rgmii_tx_delay_pos;
> +		reg_val |= vsc8531->tx_delay << rgmii_tx_delay_pos;
>  
>  	rc = phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_2,
>  			      rgmii_cntl,
> @@ -1812,6 +1813,15 @@ static int vsc85xx_config_init(struct phy_device *phydev)
>  {
>  	int rc, i, phy_id;
>  	struct vsc8531_private *vsc8531 = phydev->priv;
> +	struct device_node *of_node = phydev->mdio.dev.of_node;
> +
> +	vsc8531->rx_delay = RGMII_CLK_DELAY_2_0_NS;
> +	rc = of_property_read_u32(of_node, "mscc,rx-delay",
> +				  &vsc8531->rx_delay);
> +
> +	vsc8531->tx_delay = RGMII_CLK_DELAY_2_0_NS;
> +	rc = of_property_read_u32(of_node, "mscc,tx-delay",
> +				  &vsc8531->tx_delay);

Since the dt-bindings document says "If this property is present then
the PHY applies the RX|TX delay", then I guess the precedence as applied
by vsc85xx_rgmii_set_skews() should be different. The RX delays should
be applied based on rx-internal-delay-ps (if present) regardless of
phy-mode, or set to RGMII_CLK_DELAY_2_0_NS if we are in the rgmii-rxid
or rgmii-id modes. Similar for tx.

Also, please split the VSC8531-02 addition into a separate patch, since
the configurable RGMII delays also affect existing PHYs (like VSC8502).
