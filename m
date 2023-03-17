Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4291B6BE5D7
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 10:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjCQJqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 05:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCQJqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 05:46:38 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2057.outbound.protection.outlook.com [40.107.22.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0AA23316;
        Fri, 17 Mar 2023 02:46:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VtWn1V1UdBaDpjgDOV79v4kulqO+mq2JTIwoJWWcdEGvD9cnp7Ac+rxgvfM27eJx6qXEfPA+b/tohIzWsHyIiKpf/Uh57cmsTLQSfd0eMMtZpfdcsC4SDG6cdEp4YVM/bZ2rM+vjuw9K1wdS8Z2cZ5mt3eJqelqSTT7ZLU0peYpnf1A45RVdSpJt83qrNouoUjAMlPtIA9mLZsMy3NVTn+8+bQUCPAO6C83O5DPHd0Oj85FgS6sdHt4fCRImXsOtQBfDRBWxdVfEydF+9ZX+oJQjp79mNx6t03g0A+b6mx6EYDR/kyRv/uSe7B1ynAjUeTFFQYW0St+a7hTdI/b1Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GTpzvUR7j6CVaBrDFnesLmgzAoK76eyDAYPw34z/yus=;
 b=Ay8saWsG/mKLEdqltMDx+8mKrQ2K82LBKkm9tsQEb2okxrBSJ8wp/omsEBv9/w9FWAagv3WPM1oBKK0qI3NgCcHaejNN/8E8YyvBczYZONmDeiDDt6F3HOkxlx9YVKlKRoZRbwI2JDRtWjwdNccApLUklRyJBa0gOlDiI4OppTMg6470BjpJQTBNielGcsTz1uZYbLqaxQexLTiGBxtD0YXyGi4KGIU253MTQKr2IamvBVU+UAvQFZ3u3YnP8/0+lUDm0BIXoyXSgt5j2N6VUvvlr+tbxVmehiroE0riyR8yMdPqmFPGdXHLn/4lsjFSNhU/CggdfHdNJA52IUE+7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GTpzvUR7j6CVaBrDFnesLmgzAoK76eyDAYPw34z/yus=;
 b=qS/dR2VQjLyBwCQlRSzTzeJTg4pCqHUPzIONfqvMt+FBnMxGj5x1kxzrjL9+/DOJU9ks/dSsbZCnDrzxbwO9C9J6CQVwJAV+qgMOPH1dLSyBABrytYutqwttExQ2L44ppUdQWzbV6Zuh20XgnhUb0FDvbZtolEPIMjXKEQ4JtUM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com (2603:10a6:10:103::19)
 by PAWPR04MB9816.eurprd04.prod.outlook.com (2603:10a6:102:390::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Fri, 17 Mar
 2023 09:46:33 +0000
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::e555:cc9e:b278:15d9]) by DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::e555:cc9e:b278:15d9%7]) with mapi id 15.20.6178.031; Fri, 17 Mar 2023
 09:46:33 +0000
Date:   Fri, 17 Mar 2023 11:46:29 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Russell King <linux@armlinux.org.uk>,
        Marek Vasut <marex@denx.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/RFT PATCH net-next 2/4] net: dsa: microchip: partial
 conversion to regfields API for KSZ8795 (WIP)
Message-ID: <20230317094629.nryf6qkuxp4nisul@skbuf>
References: <20230316161250.3286055-1-vladimir.oltean@nxp.com>
 <20230316161250.3286055-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316161250.3286055-3-vladimir.oltean@nxp.com>
X-ClientProxiedBy: VI1PR0902CA0055.eurprd09.prod.outlook.com
 (2603:10a6:802:1::44) To DB8PR04MB6459.eurprd04.prod.outlook.com
 (2603:10a6:10:103::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8PR04MB6459:EE_|PAWPR04MB9816:EE_
X-MS-Office365-Filtering-Correlation-Id: dbbbe443-d792-406a-b1a5-08db26cc7df4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tgEuQmGkWSj3K5o6mseeZhZZ5/Xbjaoxrd+fCuTs9v9xlujNQu3ZE7k44iPnCyz1GiF/wcFdjxuY/VIl0kHDmHkuSbUdOfVt7d0Uxwrqzfc0yNHbm4f4kopkAmVzK78LWkM4QEpIBptHvx+4r4uxDqB4dx4MIsEKdaSqBW8a+gBZkJGW5c6p5J4AYwWqqPapzGga61i058hfIhKVRg8IZS8zX+3AZRhPrDoy+eNdY/ctBIad8HSWZSKOFLWvhSe9A6JpyHS/sc75n5P+kxFEjW8YQpBs0bBae9VhRiNO55jSQpBGtroydLAqwDAwWYVxZbzDKhMQg+Hk9E03OACIkIZ4Nr8MeKO3yKgsRHaQLHOiT3lw+HVhEIaal0KN8WVPLxUPFxBTjv2jz9R0416T5KBTbxmdU0zZ9SnLSTwnttR2Xlwurcy33D5W2c+qTREQRhG9blkAN5YKkg6zJr0+uGlOdaTiCX80IPGg5ifD2ATeiIKESKcNu3QvSUWRN1rBMRMYMTLX/Wf44Eac/+iMaZiLU2wkrqB5Sn4EmzeSsSnY6+paciOWAuTHm451y1I56p/P3FC6xKxYoDJIgCaEVvZRUo7omrZtU2+neVegmKSxa+ERbC2wBXZmmb3JSngOhWaRPuSHafDdasuR49Ah6yJIq/hYafz6e8iHLNBDDo3kLLIAnS1CU1bN06F5S/FeZGlpxZolInqM/SBjqsfViiDH5jz8aMAZf2RnYFrQx2YtaR2IxJsLX4C+zFlWT0o8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6459.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(136003)(366004)(39860400002)(346002)(376002)(396003)(451199018)(41300700001)(1076003)(6512007)(6506007)(26005)(38100700002)(6666004)(66946007)(66476007)(66556008)(4326008)(6916009)(8676002)(7416002)(2906002)(186003)(8936002)(9686003)(44832011)(83380400001)(316002)(478600001)(86362001)(6486002)(5660300002)(33716001)(966005)(54906003)(473944003)(414714003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j5HnXOD+VA6ksI4mWcQy1Ap0fpERM/KmlxhTogk0lFaN4IOZ5a8ffm89aHDg?=
 =?us-ascii?Q?DKUsvVvSBNbeVZkbytbbHRBscw+BFdmCNSsrqNcHwH5zXy9wlNnkMF4+7bs7?=
 =?us-ascii?Q?euyPs5sJl6QOKQ7+M2F9Ou3jNCK4kse6zKPuYVlKIj+LXq/3IQUJHNnPxOIj?=
 =?us-ascii?Q?mYrNuHiMOkAXWShXo6tszS8o8idEoFbtowCiueB5YtfyDPP4LQnKlsRNyHbA?=
 =?us-ascii?Q?noOWi+8zmZAxEwX6gZjue0SxE3XOA755aVhjxNlXX5idTK2NDvcoJ1wXGZRG?=
 =?us-ascii?Q?PsMzKuWpvxw5uwRrfRi9xlkRbBIr6rbep9CGUIMT41ecD/VB5ECM3WcjwSjM?=
 =?us-ascii?Q?Vxo+rlUjLkIcWIxm1ml5jyAZSPDx7CjYEHmHsOOXsNHds4a4m2BHtRpmNY2m?=
 =?us-ascii?Q?K5qXiqHxWazXby8KhV2LoD3EnU9gxhwqNqopn0NCVYjga1cKdXUFzL8x7C4R?=
 =?us-ascii?Q?mSWCSNGTjEtC9PRyji8UzMunyjaUfNf/lhUMJjakU0hdX70l1jtMbypNc52F?=
 =?us-ascii?Q?jsrOJCLp9ebSaCyrHt2QaxA0Vqj8xayk4TfdPfrV1z1gYlOdQ77zJj0+4Esn?=
 =?us-ascii?Q?Vwxh0itOn/9hFJ231Bj3in0SqzJeXjDu9y02WeoFx8HOwJcHwzrATuHmOB7t?=
 =?us-ascii?Q?6S28jsDSpkG19k01Sj68s7tWJlTSKVXs4Y0GYhJxqOgRuTZUCTAxRwIWZb6F?=
 =?us-ascii?Q?uxXsDUQFRofDev/gXGKr4Gf12gsM83X02QfhAIGbK4pR1+Z6CJVA/a2fgDqH?=
 =?us-ascii?Q?1mYnzZsYVMgRYkZDyLYYVL6aIIundH69mw6g5T0IFn1b2U5IxV9kpgg3XDoB?=
 =?us-ascii?Q?oBxABCxMzOnQjcFPWyTW5MdhymcHXpPqidpTHm2kCk6aJ8UVVZLJjm862Gjv?=
 =?us-ascii?Q?HHlvmIrsElWEiVM/gMhSv8/2UcbFNXpln17gkWakdfxIBhFfm2M8t1ZM3AO6?=
 =?us-ascii?Q?vdiBWa4Q31f3rt74UprBUgt67Qn9YH8Z5Kwo4nf90BsezANiko8KraPyJVMx?=
 =?us-ascii?Q?CroNJdGyG8cOywswmQPK3912jbE1q4aTjBfp6wIIL1cSeyQoCCypHfyB6b3I?=
 =?us-ascii?Q?zRwd0vWkt6bICBJ+dfPp+txyttqRTQhBd4fFRk4GgEQ+mchgbQTT0z7LtZ3q?=
 =?us-ascii?Q?hLku+JI+iAeyK0yj+L/dZ7dcFDMFDn4sygNtCBVCcVS9iDALFDBGBdB5iNYw?=
 =?us-ascii?Q?5oJiS39zmqytMHOTIULLDiqbdvNx2KR09GFA4cpve/oJ1lA1to4ana08RZxV?=
 =?us-ascii?Q?p05CV16JwK3aXPonHlegzfGZtcKr+8sxpJ2Fn65ynIEj5XKfdTOwMuedRxij?=
 =?us-ascii?Q?A83GoHevhXaR5QrchToTSyT/xm2yIoHRP71iJNA2DeiaM6Gf+2WoKOvMz3gw?=
 =?us-ascii?Q?+SIQrpSOD/kD3byWrAnIob2ldmvAaN+VkRe5FZXF9T+oK7uT2xtpHoHioeJo?=
 =?us-ascii?Q?jw30SuYHRpFqDxWyZxNSHdBPNcEB33CPHqr/tbxJYlvI13LqRqpzh/PCjPOV?=
 =?us-ascii?Q?KQjEO1sSvbZ3Ho5V0hH9p97F40AugvDsL9jaRLm8Sj1TVnVVqBOvArkIB+et?=
 =?us-ascii?Q?WmTIkAaTKvriU+eepcObZZYVJzORsNmXxb+8tJj4DdoQGLgNWpj1Upvl+Uzw?=
 =?us-ascii?Q?zg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbbbe443-d792-406a-b1a5-08db26cc7df4
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6459.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 09:46:33.3772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eWQvw8GcXL1yCHNLt3y4e1PNLWgQ5ed/hMfLSa7WHk+Tm1HTzb8RqCM7xgDFE2ocHO6y10zsY4M/v0eJ5jihTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR04MB9816
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 06:12:48PM +0200, Vladimir Oltean wrote:
> During review, Russell King has pointed out that the current way in
> which the KSZ common driver performs register access is error-prone.
> 
> Based on the KSZ9477 software model where we have the XMII Port Control
> 0 Register (at offset 0xN300) and XMII Port Control 1 Register
> (at offset 0xN301), this driver also holds P_XMII_CTRL_0 and P_XMII_CTRL_1.
> 
> However, on some switches, fields accessed through P_XMII_CTRL_0 (for
> example P_MII_100MBIT_M or P_MII_DUPLEX_M) and fields accessed through
> P_XMII_CTRL_1 (for example P_MII_SEL_M) may end up accessing the same
> hardware register. Or at least, that was certainly the impression after
> commit
> https://patchwork.kernel.org/project/netdevbpf/patch/20230315231916.2998480-1-vladimir.oltean@nxp.com/
> (sorry, can't reference the sha1sum of an unmerged commit), because for
> ksz8795_regs[], P_XMII_CTRL_0 and P_XMII_CTRL_1 now have the same value.
> 
> But the reality is far more interesting. Opening a KSZ8795 datasheet, I
> see that out of the register fields accessed via P_XMII_CTRL_0:
> - what the driver names P_MII_SEL_M *is* actually "GMII/MII Mode Select"
>   (bit 2) of the Port 5 Interface Control 6, address 0x56 (all good here)
> - what the driver names P_MII_100MBIT_M is actually "Switch SW5-MII/RMII
>   Speed" (bit 4) of the Global Control 4 register, address 0x06.
> 
> That is a huge problem, because the driver cannot access this register
> for KSZ8795 in its current form, even if that register exists. This
> creates an even stronger motivation to try to do something to normalize
> the way in which this driver abstracts away register field movement from
> one switch family to another.
> 
> As I had proposed in that thread, reg_fields from regmap propose to
> solve exactly this problem. This patch contains a COMPLETELY UNTESTED
> rework of the driver, so that accesses done through the following
> registers (for demonstration purposes):
> - REG_IND_BYTE - a global register
> - REG_IND_CTRL_0 - another global register
> - P_LOCAL_CTRL - a port register
> - P_FORCE_CTRL - another port register
> - P_XMII_CTRL_0 and P_XMII_CTRL_1 - either port register, or global
>   registers, depending on which manual you read!
> 
> are converted to the regfields API.
> 
> !! WARNING !! I only attempted to add a ksz_reg_fields structure for
> KSZ8795. The other switch families will currently crash!
> 
> For easier partial migration, I have renamed the "REG_" or "P_" prefixes
> of the enum ksz_regs values into a common "RF_" (for reg field) prefix
> for a new enum type: ksz_rf. Eventually, enum ksz_regs, as well as the
> masks, should disappear completely, being replaced by reg fields.
> 
> Link: https://lore.kernel.org/netdev/Y%2FYPfxg8Ackb8zmW@shell.armlinux.org.uk/
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> diff --git a/drivers/net/dsa/microchip/ksz8863_smi.c b/drivers/net/dsa/microchip/ksz8863_smi.c
> index 5871f27451cb..f9d22a444146 100644
> --- a/drivers/net/dsa/microchip/ksz8863_smi.c
> +++ b/drivers/net/dsa/microchip/ksz8863_smi.c
> @@ -136,11 +136,16 @@ static const struct regmap_config ksz8863_regmap_config[] = {
>  
>  static int ksz8863_smi_probe(struct mdio_device *mdiodev)
>  {
> +	const struct ksz_chip_data *chip;
>  	struct regmap_config rc;
>  	struct ksz_device *dev;
>  	int ret;
>  	int i;
>  
> +	chip = device_get_match_data(ddev);

s/ddev/&mdiodev->dev/

> +	if (!chip)
> +		return -EINVAL;
> +
>  	dev = ksz_switch_alloc(&mdiodev->dev, mdiodev);
>  	if (!dev)
>  		return -ENOMEM;
> @@ -159,6 +164,10 @@ static int ksz8863_smi_probe(struct mdio_device *mdiodev)
>  		}
>  	}
>  
> +	ret = ksz_regfields_init(dev, chip);
> +	if (ret)
> +		return ret;
> +
>  	if (mdiodev->dev.platform_data)
>  		dev->pdata = mdiodev->dev.platform_data;
>  
> diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
> index 497be833f707..2cbd76aed974 100644
> --- a/drivers/net/dsa/microchip/ksz9477_i2c.c
> +++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
> @@ -16,10 +16,15 @@ KSZ_REGMAP_TABLE(ksz9477, not_used, 16, 0, 0);
>  
>  static int ksz9477_i2c_probe(struct i2c_client *i2c)
>  {
> +	const struct ksz_chip_data *chip;
>  	struct regmap_config rc;
>  	struct ksz_device *dev;
>  	int i, ret;
>  
> +	chip = device_get_match_data(ddev);

s/ddev/&i2c->dev/

> +	if (!chip)
> +		return -EINVAL;
> +
>  	dev = ksz_switch_alloc(&i2c->dev, i2c);
>  	if (!dev)
>  		return -ENOMEM;
> @@ -35,6 +40,10 @@ static int ksz9477_i2c_probe(struct i2c_client *i2c)
>  		}
>  	}
>  
> +	ret = ksz_regfields_init(dev, chip);
> +	if (ret)
> +		return ret;
> +
>  	if (i2c->dev.platform_data)
>  		dev->pdata = i2c->dev.platform_data;
>  
