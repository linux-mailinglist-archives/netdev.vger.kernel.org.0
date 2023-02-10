Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7BE2692666
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232946AbjBJTcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:32:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233320AbjBJTcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:32:11 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2072.outbound.protection.outlook.com [40.107.15.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A35539294;
        Fri, 10 Feb 2023 11:32:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DxQ96yDxrstQ+wKQMcxcolKls1qkq99bWihr7/N7cfqE+2XJU5t4/4z+LIh3chHopDJ35uBsH8hIXghtrYD5sgei005oHhhsdj4lh1VHjFXri9PnvTP2B4C/Gda1RoPcZY0U1r08zsXL2yvuM+ZoZK0MSl3PlnOFRQkquM11TgwKRpP5X+0+z+QTryfnLGw/fmEOuxKMRHyUCs/Phu/OLH0uMNuKVZ5RYqKHTKCKnf533ltMU8TW46VZTXHgDtAR0O7q6HDzFG2yNlKSztGqQ05QBo6VQbw1nNCRpczqweXjYuaD1IC40sh9ng3KchVrvtHMKNqjJx2S/K3swfZPpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=In9O50SdQZE/vf/f1qC3XeCGtJO74dZDXsCT1QvJyB4=;
 b=k1GjqnwUXq/b2zV7iyG+WaBWf2DQHn5fvQoALscptzOocTGXSJaxtkHC5/L13rWVq9CKcuTx6OjWELHzIgT5K2Ynnufx7cVwSKCTCm0+tVcSfV6LXxk3oVoObLeiDDAt/n4ex7IUNV8SR0AQKQY0FkPf16wAUrDt5GscQY/RR7q09WcM3ojtJZlsMVRRYw8Y5lKM08U+xVKYcPku1ZfLDIc9gzxyx0Nq18u+xG9bgaS64Djbak0yQj67VQAVPfdi1//+G1Wr4qYhaxBqDLUtshZYV04uEhHKRAlcr8GkMtD2ZIlggOqcFzRxvzxyw6PK++YF+JQfryBwUb+TzGQLmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=In9O50SdQZE/vf/f1qC3XeCGtJO74dZDXsCT1QvJyB4=;
 b=WZWXJpU/mJ3NZRwHCKYL7pRWLS3rP7Kr7ppxyEXHc4eeesLj381NFCp2+sA4f+up/cPdSMO18TumvzlPshFyt4UVmjK3E4XCbF7hf9t+8EbQtgdp2Su8QH2Nwjxh4MiE9gWgqqDCmSWCmOqITUO7IkYQiT28H1CgbVAo9WOyUM8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8660.eurprd04.prod.outlook.com (2603:10a6:20b:42b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21; Fri, 10 Feb
 2023 19:32:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.019; Fri, 10 Feb 2023
 19:32:04 +0000
Date:   Fri, 10 Feb 2023 21:31:59 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next] net: pcs: tse: port to pcs-lynx
Message-ID: <20230210193159.qmbtvwtx6kqagvxy@skbuf>
References: <20230210190949.1115836-1-maxime.chevallier@bootlin.com>
 <20230210190949.1115836-1-maxime.chevallier@bootlin.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210190949.1115836-1-maxime.chevallier@bootlin.com>
 <20230210190949.1115836-1-maxime.chevallier@bootlin.com>
X-ClientProxiedBy: AM0PR01CA0162.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::31) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8660:EE_
X-MS-Office365-Filtering-Correlation-Id: ccc70c5c-9473-4e4a-868c-08db0b9d7cc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OcC+XIni1UFmP3lePCmOfLv7dAEmQoKyfzRVRkVzkR2MmetxUWitYZLuQqy5GuXH33AIMSBWaqYCm/wq9dGBtOQCp0JZQLPOccXkfB04nf0VLyZ5N+9oRC0/GQ0CrA0rflVbmijKrOX3LF7a+zn1aeg60uzmPk/j59trSn4lZGVPbYNoGYxRXxHACzggVA16ew9Ai9kVRKqQBGCjyIJkxv+ZA5SabiCa4I5UfS18KjfKVUBAfmuPESrQ2TMJFGZJVD/38wPe+co/g2laOC/BRVJOs/KzBnCkzoxa5C+RA1pW05Zkb2kwRGWBUZ4+X8Un1R/EjOVyd4Up+JqN/Q0vvJZM+i2L4YHngc7WMQxPJzBYVQlHaXT2NbGrk/OYND7BSZg4ufesHt1oSvEvtiyGhW66QL28OjqHkFkFy6vS7malb+1rPi4rlqf48/v9bm71xTOKEKojVdIFA5WY28YhRSBXP5QVe9CcCZZ11zZpHmT1IPijak/GtG6PMk9yn3Zv/7pgfVlM1Y/fFotUm58AjtXWR8En+M0XDkpoGsTReb3Y6efRLsVxKEdN6sV4xSLsRJs0+xT8N4GSKyv9I7kUFt5zdefovzgR5urh0ZQ70ELqMVfdDd5KvMjpyoB++bT3+vT2wQY8yjTP/J04vnnQbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(136003)(39860400002)(346002)(376002)(396003)(366004)(451199018)(33716001)(2906002)(478600001)(6486002)(316002)(7416002)(5660300002)(8936002)(38100700002)(54906003)(86362001)(6512007)(9686003)(83380400001)(186003)(6506007)(1076003)(26005)(30864003)(66946007)(44832011)(6666004)(4326008)(6916009)(41300700001)(8676002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9pZEqURHg6Bc1AhgmzzQoXP0DU19Lcni+ByW47XofAVzVYPnpF851cF1DXyi?=
 =?us-ascii?Q?8EV3jO4dIGN0tYqsy+eQX3mThx0BzHZvXz9f4+8WJHLnZFRwgAKQJOdlmqXG?=
 =?us-ascii?Q?JLnQpbBHSDivLk+DyUMqpwpel1bBRqyeDT/pZrprqqYXyy5rbLkHpZ5e4Zm2?=
 =?us-ascii?Q?qSpa27jNRiKbFKO67MXouXmJFDqIK8ZYIsyLfU/rIwBZ9kOvgGGIUiMWXlO8?=
 =?us-ascii?Q?+CbkuymQS9GiCL7Hin2QQGgSpRl6q5xZDKx/IHwQMUs5dopku3LucZ3L8M2m?=
 =?us-ascii?Q?+3O5zVwplPb+r+Z/1gFY3xQXrPuGPiP6jzmXIc+raAZr8ZyVQBNWl3yfxp55?=
 =?us-ascii?Q?lKVAYBmIUb/yOpzt/CkQ8ciRT6YPiCHTjhsAJ64RtzyF2MzS91LOQyKEa0E7?=
 =?us-ascii?Q?AtbNhn0qLwpBDKX64DoMhSfnfXYIEc433A6sUT9eAlh1XN7kX8PvqAHBbkSS?=
 =?us-ascii?Q?UAIOcbvreVnrfDulkZ20YHDDVGCZeS4hOgYrMxljB42UMwlU9jcnbeyVfShM?=
 =?us-ascii?Q?1bbAlnT5Vvct+zdBBN6q4QBK4KBiRb/S2YpzBUGBrhG/YrWQj/johPnLOduX?=
 =?us-ascii?Q?3VyKtT1mvpFhXKQKPsydBB7myce7zWlCLIzaTemxwGBG2gOTl/dsHSduBAVd?=
 =?us-ascii?Q?mH8DRfwe07pK1BtVnGkfEcBJ6kOuWsA5Chavbvs+Q0nnwMC1lUqSbVWf/nWV?=
 =?us-ascii?Q?HkxtuTGRWsn48Fn0aThMvYqlbQzRICpJyqLgXd1o9dKeIWdwYN1hrV90fZcn?=
 =?us-ascii?Q?W7nBryumOsAwToEvCeR/AkPVN7YGLXfPdvhyKOts1bgy8XDQAoydyhbNHswW?=
 =?us-ascii?Q?UjFEfG9kh9d/6zs+ds7HS0FeyZdmGLPIdNRDa+vk7qPBE5apRiOLv7Y7bpRK?=
 =?us-ascii?Q?kj4EpWeUA10BwJlRLSLOmDqQtYdtaHv4qF/Qj5Et3QSwqpRRQnl/I8sJsmZ7?=
 =?us-ascii?Q?fIkVxvJZfc9t7W98uKc2dNV5an4E5rhCe3FN9MslTIC3VEixFO5gmWwM+nIg?=
 =?us-ascii?Q?35x4NgvlxtvyN0eIIu1Vcr1OSl+nnjcp55fL0OE8xnApeSmrp30uvn8YcZzF?=
 =?us-ascii?Q?9YPzmdfBH9HiHfLxAioaI0epJp+6notdtqb/1Tr6Oaa2DcWXbc6LHlTScbaz?=
 =?us-ascii?Q?A8Jfdmdsh/pnJlW/NlEkr5jpvgU1PdmQnsXt14t/flQQSkU0RJfvy7WU7d3d?=
 =?us-ascii?Q?Ebai0yagEvfM/BcSpPRMlr5tdutKAf3Cq1K+EFzy0KjI0MJ05b/ZmZXVy0bo?=
 =?us-ascii?Q?7rxxNfxFQBSh0AueuKvLAyP7tXu5d/ma+er2+lKBpJuePQOxpu8dWqgAqLDR?=
 =?us-ascii?Q?UQTxQdZ8jFGuZ1e/c1rS1eemL02O90XvPs+3Ef30ag8NcmbBLkEz8ix2fsqI?=
 =?us-ascii?Q?XNexa1dV4SMsmXDU3lelPsx6zqVrOnGPZA/R4CqQ6KB/vjKpqBtRIj8VBjgC?=
 =?us-ascii?Q?6P3OOymro/GwLc6YErlfNU+jipcDyA7hhClxuPbpurcqG1fpopAhBlHFMOoj?=
 =?us-ascii?Q?zhLGdSZ4U8Vc8Gb67O3CuFVc2gMVH+8RXCMX9aGzFbf14W8IAsYCnAxQG7jh?=
 =?us-ascii?Q?qkJd4Lc6Q9KPvXfREi5IUrrh4OGL/cZc8jCrHQfBesud3FuUP8riIue+XiJK?=
 =?us-ascii?Q?SA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccc70c5c-9473-4e4a-868c-08db0b9d7cc1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 19:32:04.1229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y4Mw7jeZgWbLMTzj7RU5HsQTK1h1ryc3UszNjgWsn9hiFAwkA8eHAv57YA1jaTsyKouyXQrEp2y0qvrZzbjXqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8660
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 08:09:49PM +0100, Maxime Chevallier wrote:
> When submitting the initial driver for the Altera TSE PCS, Russell King
> noted that the register layout for the TSE PCS is very similar to the
> Lynx PCS. The main difference being that TSE PCS's register space is
> memory-mapped, whereas Lynx's is exposed over MDIO.
> 
> Convert the TSE PCS to reuse the whole logic from Lynx, by allowing
> the creation of a dummy MDIO bus, and a dummy MDIO device located at
> address 0 on that bus. The MAC driver that uses this PCS must provide
> callbacks to read/write the MMIO.
> 
> Also convert the Altera TSE MAC driver to this new way of using the TSE
> PCS.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
>  drivers/net/ethernet/altera/altera_tse.h      |   2 +-
>  drivers/net/ethernet/altera/altera_tse_main.c |  50 ++++-
>  drivers/net/pcs/Kconfig                       |   4 +
>  drivers/net/pcs/pcs-altera-tse.c              | 194 +++++++-----------
>  include/linux/pcs-altera-tse.h                |  22 +-
>  5 files changed, 142 insertions(+), 130 deletions(-)

The glue layer is larger than the duplicated PCS code? :(

> 
> diff --git a/drivers/net/ethernet/altera/altera_tse.h b/drivers/net/ethernet/altera/altera_tse.h
> index db5eed06e92d..f4e3fddb639a 100644
> --- a/drivers/net/ethernet/altera/altera_tse.h
> +++ b/drivers/net/ethernet/altera/altera_tse.h
> @@ -476,7 +476,7 @@ struct altera_tse_private {
>  
>  	struct phylink *phylink;
>  	struct phylink_config phylink_config;
> -	struct phylink_pcs *pcs;
> +	struct altera_tse_pcs *pcs;
>  };
>  
>  /* Function prototypes
> diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
> index 66e3af73ec41..109b7ed90c6e 100644
> --- a/drivers/net/ethernet/altera/altera_tse_main.c
> +++ b/drivers/net/ethernet/altera/altera_tse_main.c
> @@ -87,6 +87,36 @@ static inline u32 tse_tx_avail(struct altera_tse_private *priv)
>  	return priv->tx_cons + priv->tx_ring_size - priv->tx_prod - 1;
>  }
>  
> +static int altera_tse_pcs_read(void *priv, int regnum)
> +{
> +	struct altera_tse_private *tse = priv;
> +
> +	if (tse->pcs_base)
> +		return readw(tse->pcs_base + (regnum * 2));
> +	else
> +		return readl(tse->mac_dev + tse_csroffs(mdio_phy0) +
> +			     (regnum * 4));
> +	return 0;

code after return

Usual practice to avoid this is

	if (tse->pcs_base)
		return readw(tse->pcs_base + regnum * 2);

	return readl(tse->mac_dev + tse_csroffs(mdio_phy0) + regnum * 4);

also, multiplication has higher operator precedence over addition, so ()
not needed.

> +}
> +
> +static int altera_tse_pcs_write(void *priv, int regnum, u16 value)
> +{
> +	struct altera_tse_private *tse = priv;
> +
> +	if (tse->pcs_base)
> +		writew(value, tse->pcs_base + (regnum * 2));
> +	else
> +		writel(value, tse->mac_dev + tse_csroffs(mdio_phy0) +
> +			(regnum * 4));
> +
> +	return 0;
> +}
> +
> +static struct altera_tse_pcs_ops tse_ops = {
> +	.read = altera_tse_pcs_read,
> +	.write = altera_tse_pcs_write,
> +};
> +
>  /* MDIO specific functions
>   */
>  static int altera_tse_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
> @@ -1090,7 +1120,7 @@ static struct phylink_pcs *alt_tse_select_pcs(struct phylink_config *config,
>  
>  	if (interface == PHY_INTERFACE_MODE_SGMII ||
>  	    interface == PHY_INTERFACE_MODE_1000BASEX)
> -		return priv->pcs;
> +		return altera_tse_pcs_to_phylink_pcs(priv->pcs);
>  	else
>  		return NULL;
>  }
> @@ -1143,7 +1173,6 @@ static int altera_tse_probe(struct platform_device *pdev)
>  	struct resource *pcs_res;
>  	struct net_device *ndev;
>  	void __iomem *descmap;
> -	int pcs_reg_width = 2;
>  	int ret = -ENODEV;
>  
>  	ndev = alloc_etherdev(sizeof(struct altera_tse_private));
> @@ -1262,10 +1291,6 @@ static int altera_tse_probe(struct platform_device *pdev)
>  	 */
>  	ret = request_and_map(pdev, "pcs", &pcs_res,
>  			      &priv->pcs_base);
> -	if (ret) {
> -		priv->pcs_base = priv->mac_dev + tse_csroffs(mdio_phy0);
> -		pcs_reg_width = 4;
> -	}
>  
>  	/* Rx IRQ */
>  	priv->rx_irq = platform_get_irq_byname(pdev, "rx_irq");
> @@ -1389,7 +1414,11 @@ static int altera_tse_probe(struct platform_device *pdev)
>  			 (unsigned long) control_port->start, priv->rx_irq,
>  			 priv->tx_irq);
>  
> -	priv->pcs = alt_tse_pcs_create(ndev, priv->pcs_base, pcs_reg_width);
> +	priv->pcs = alt_tse_pcs_create(ndev, &tse_ops, priv);
> +	if (!priv->pcs) {
> +		ret = -ENODEV;
> +		goto err_init_phy;
> +	}
>  
>  	priv->phylink_config.dev = &ndev->dev;
>  	priv->phylink_config.type = PHYLINK_NETDEV;
> @@ -1412,11 +1441,12 @@ static int altera_tse_probe(struct platform_device *pdev)
>  	if (IS_ERR(priv->phylink)) {
>  		dev_err(&pdev->dev, "failed to create phylink\n");
>  		ret = PTR_ERR(priv->phylink);
> -		goto err_init_phy;
> +		goto err_pcs;
>  	}
>  
>  	return 0;
> -
> +err_pcs:
> +	alt_tse_pcs_destroy(priv->pcs);
>  err_init_phy:
>  	unregister_netdev(ndev);
>  err_register_netdev:
> @@ -1438,6 +1468,8 @@ static int altera_tse_remove(struct platform_device *pdev)
>  	altera_tse_mdio_destroy(ndev);
>  	unregister_netdev(ndev);
>  	phylink_destroy(priv->phylink);
> +	alt_tse_pcs_destroy(priv->pcs);
> +
>  	free_netdev(ndev);
>  
>  	return 0;
> diff --git a/drivers/net/pcs/Kconfig b/drivers/net/pcs/Kconfig
> index 6e7e6c346a3e..768e8cefe17c 100644
> --- a/drivers/net/pcs/Kconfig
> +++ b/drivers/net/pcs/Kconfig
> @@ -28,8 +28,12 @@ config PCS_RZN1_MIIC
>  
>  config PCS_ALTERA_TSE
>  	tristate
> +	select PCS_LYNX
>  	help
>  	  This module provides helper functions for the Altera Triple Speed
>  	  Ethernet SGMII PCS, that can be found on the Intel Socfpga family.
> +	  This PCS appears to be a Lynx PCS exposed over mmio instead of a
> +	  mdio device, so the core logic from Lynx PCS is re-used and wrapped
> +	  around a virtual mii bus and mdio device.
>  
>  endmenu
> diff --git a/drivers/net/pcs/pcs-altera-tse.c b/drivers/net/pcs/pcs-altera-tse.c
> index d616749761f4..3adf6b1c0823 100644
> --- a/drivers/net/pcs/pcs-altera-tse.c
> +++ b/drivers/net/pcs/pcs-altera-tse.c
> @@ -9,151 +9,109 @@
>  #include <linux/phy.h>
>  #include <linux/phylink.h>
>  #include <linux/pcs-altera-tse.h>
> +#include <linux/pcs-lynx.h>
>  
> -/* SGMII PCS register addresses
> - */
> -#define SGMII_PCS_LINK_TIMER_0	0x12
> -#define SGMII_PCS_LINK_TIMER_1	0x13
> -#define SGMII_PCS_IF_MODE	0x14
> -#define   PCS_IF_MODE_SGMII_ENA		BIT(0)
> -#define   PCS_IF_MODE_USE_SGMII_AN	BIT(1)
> -#define   PCS_IF_MODE_SGMI_HALF_DUPLEX	BIT(4)
> -#define   PCS_IF_MODE_SGMI_PHY_AN	BIT(5)
> -#define SGMII_PCS_SW_RESET_TIMEOUT 100 /* usecs */
> -
> -struct altera_tse_pcs {
> -	struct phylink_pcs pcs;
> -	void __iomem *base;
> -	int reg_width;
> -};
> -
> -static struct altera_tse_pcs *phylink_pcs_to_tse_pcs(struct phylink_pcs *pcs)
> +static int altera_tse_pcs_mdio_write(struct mii_bus *bus, int mii_id, int regnum,

Confusing name "mii_id" (may suggest a connection to MII_PHYSID1/MII_PHYSID2
when there is none). Would suggest something more conventional, like "addr"
or "phyad".

> +				     u16 value)
>  {
> -	return container_of(pcs, struct altera_tse_pcs, pcs);
> -}
> +	struct altera_tse_pcs *tse_pcs = bus->priv;
>  
> -static u16 tse_pcs_read(struct altera_tse_pcs *tse_pcs, int regnum)
> -{
> -	if (tse_pcs->reg_width == 4)
> -		return readl(tse_pcs->base + regnum * 4);
> -	else
> -		return readw(tse_pcs->base + regnum * 2);
> +	return tse_pcs->ops->write(tse_pcs->priv, regnum, value);
>  }
>  
> -static void tse_pcs_write(struct altera_tse_pcs *tse_pcs, int regnum,
> -			  u16 value)
> +static int altera_tse_pcs_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
>  {
> -	if (tse_pcs->reg_width == 4)
> -		writel(value, tse_pcs->base + regnum * 4);
> -	else
> -		writew(value, tse_pcs->base + regnum * 2);
> -}
> +	struct altera_tse_pcs *tse_pcs = bus->priv;
>  
> -static int tse_pcs_reset(struct altera_tse_pcs *tse_pcs)
> -{
> -	u16 bmcr;
> -
> -	/* Reset PCS block */
> -	bmcr = tse_pcs_read(tse_pcs, MII_BMCR);
> -	bmcr |= BMCR_RESET;
> -	tse_pcs_write(tse_pcs, MII_BMCR, bmcr);
> +	if (mii_id != 0)
> +		return 0;

This doesn't look well at all in the patch delta, but it makes altera_tse_pcs_mdio_read()
return 0 for reads from unknown (not emulated) PHY address. Would -ENODEV make more sense?
It would accelerate the failure (not sure when/if the lynx pcs driver would fail if
all its registers returned 0; I suppose it would be non-obvious).

>  
> -	return read_poll_timeout(tse_pcs_read, bmcr, (bmcr & BMCR_RESET),
> -				 10, SGMII_PCS_SW_RESET_TIMEOUT, 1,
> -				 tse_pcs, MII_BMCR);
> +	return tse_pcs->ops->read(tse_pcs->priv, regnum);
>  }
>  
> -static int alt_tse_pcs_validate(struct phylink_pcs *pcs,
> -				unsigned long *supported,
> -				const struct phylink_link_state *state)
> +static struct altera_tse_pcs *
> +altera_tse_pcs_mdio_create(struct net_device *dev,
> +			   struct altera_tse_pcs_ops *ops,
> +			   void *priv)
>  {
> -	if (state->interface == PHY_INTERFACE_MODE_SGMII ||
> -	    state->interface == PHY_INTERFACE_MODE_1000BASEX)
> -		return 1;
> -
> -	return -EINVAL;
> -}
> -
> -static int alt_tse_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
> -			      phy_interface_t interface,
> -			      const unsigned long *advertising,
> -			      bool permit_pause_to_mac)
> -{
> -	struct altera_tse_pcs *tse_pcs = phylink_pcs_to_tse_pcs(pcs);
> -	u32 ctrl, if_mode;
> -
> -	ctrl = tse_pcs_read(tse_pcs, MII_BMCR);
> -	if_mode = tse_pcs_read(tse_pcs, SGMII_PCS_IF_MODE);
> -
> -	/* Set link timer to 1.6ms, as per the MegaCore Function User Guide */
> -	tse_pcs_write(tse_pcs, SGMII_PCS_LINK_TIMER_0, 0x0D40);
> -	tse_pcs_write(tse_pcs, SGMII_PCS_LINK_TIMER_1, 0x03);
> -
> -	if (interface == PHY_INTERFACE_MODE_SGMII) {
> -		if_mode |= PCS_IF_MODE_USE_SGMII_AN | PCS_IF_MODE_SGMII_ENA;
> -	} else if (interface == PHY_INTERFACE_MODE_1000BASEX) {
> -		if_mode &= ~(PCS_IF_MODE_USE_SGMII_AN | PCS_IF_MODE_SGMII_ENA);
> +	struct altera_tse_pcs *tse_pcs;
> +	struct mii_bus *mii_bus;
> +	int ret;
> +
> +	tse_pcs = kzalloc(sizeof(*tse_pcs), GFP_KERNEL);
> +	if (IS_ERR(tse_pcs))
> +		return NULL;
> +
> +	tse_pcs->ops = ops;
> +	tse_pcs->priv = priv;
> +
> +	mii_bus = mdiobus_alloc();
> +	if (!mii_bus)
> +		goto out_free_pcs;
> +
> +	mii_bus->name = "Altera TSE PCS MDIO";
> +	mii_bus->read = &altera_tse_pcs_mdio_read;
> +	mii_bus->write = &altera_tse_pcs_mdio_write;
> +	snprintf(mii_bus->id, MII_BUS_ID_SIZE, "%s-%s", mii_bus->name,
> +		 dev->name);
> +
> +	mii_bus->priv = tse_pcs;
> +	mii_bus->parent = &dev->dev;
> +
> +	ret = mdiobus_register(mii_bus);
> +	if (ret)
> +		goto out_free_mdio;
> +
> +	tse_pcs->mii_bus = mii_bus;
> +	tse_pcs->mdiodev = mdio_device_create(mii_bus, 0);

Maybe a #define TSE_PCS_PHYAD 0, to make it clear that this 0 is the
same as the other 0?

> +	if (IS_ERR(tse_pcs->mdiodev)) {
> +		ret = PTR_ERR(tse_pcs->mdiodev);
> +		goto out_unregister_mdio;
>  	}
>  
> -	ctrl |= (BMCR_SPEED1000 | BMCR_FULLDPLX | BMCR_ANENABLE);
> -
> -	tse_pcs_write(tse_pcs, MII_BMCR, ctrl);
> -	tse_pcs_write(tse_pcs, SGMII_PCS_IF_MODE, if_mode);
> +	return tse_pcs;
>  
> -	return tse_pcs_reset(tse_pcs);
> +out_unregister_mdio:
> +	mdiobus_unregister(mii_bus);
> +out_free_mdio:
> +	mdiobus_free(mii_bus);
> +out_free_pcs:
> +	kfree(tse_pcs);
> +	return NULL;
>  }
>  
> -static void alt_tse_pcs_get_state(struct phylink_pcs *pcs,
> -				  struct phylink_link_state *state)
> +void alt_tse_pcs_destroy(struct altera_tse_pcs *tse_pcs)
>  {
> -	struct altera_tse_pcs *tse_pcs = phylink_pcs_to_tse_pcs(pcs);
> -	u16 bmsr, lpa;
> -
> -	bmsr = tse_pcs_read(tse_pcs, MII_BMSR);
> -	lpa = tse_pcs_read(tse_pcs, MII_LPA);
> -
> -	phylink_mii_c22_pcs_decode_state(state, bmsr, lpa);
> +	mdio_device_free(tse_pcs->mdiodev);
> +	mdiobus_unregister(tse_pcs->mii_bus);
> +	mdiobus_free(tse_pcs->mii_bus);
> +	kfree(tse_pcs);
>  }
>  
> -static void alt_tse_pcs_an_restart(struct phylink_pcs *pcs)
> +struct altera_tse_pcs *alt_tse_pcs_create(struct net_device *dev,
> +					  struct altera_tse_pcs_ops *ops,
> +					  void *priv)
>  {
> -	struct altera_tse_pcs *tse_pcs = phylink_pcs_to_tse_pcs(pcs);
> -	u16 bmcr;
> -
> -	bmcr = tse_pcs_read(tse_pcs, MII_BMCR);
> -	bmcr |= BMCR_ANRESTART;
> -	tse_pcs_write(tse_pcs, MII_BMCR, bmcr);
> -
> -	/* This PCS seems to require a soft reset to re-sync the AN logic */
> -	tse_pcs_reset(tse_pcs);
> -}
> +	struct altera_tse_pcs *tse_pcs;
> +	struct phylink_pcs *pcs;
>  
> -static const struct phylink_pcs_ops alt_tse_pcs_ops = {
> -	.pcs_validate = alt_tse_pcs_validate,
> -	.pcs_get_state = alt_tse_pcs_get_state,
> -	.pcs_config = alt_tse_pcs_config,
> -	.pcs_an_restart = alt_tse_pcs_an_restart,
> -};
> +	tse_pcs = altera_tse_pcs_mdio_create(dev, ops, priv);
> +	if (!tse_pcs)
> +		return NULL;
>  
> -struct phylink_pcs *alt_tse_pcs_create(struct net_device *ndev,
> -				       void __iomem *pcs_base, int reg_width)
> -{
> -	struct altera_tse_pcs *tse_pcs;
> +	pcs = lynx_pcs_create(tse_pcs->mdiodev);
> +	if (!pcs)
> +		goto out_free_mdio;
>  
> -	if (reg_width != 4 && reg_width != 2)
> -		return ERR_PTR(-EINVAL);
> +	tse_pcs->pcs = pcs;
>  
> -	tse_pcs = devm_kzalloc(&ndev->dev, sizeof(*tse_pcs), GFP_KERNEL);
> -	if (!tse_pcs)
> -		return ERR_PTR(-ENOMEM);
> +	return tse_pcs;
>  
> -	tse_pcs->pcs.ops = &alt_tse_pcs_ops;
> -	tse_pcs->base = pcs_base;
> -	tse_pcs->reg_width = reg_width;
> +out_free_mdio:
> +	alt_tse_pcs_destroy(tse_pcs);
>  
> -	return &tse_pcs->pcs;
> +	return NULL;
>  }
> -EXPORT_SYMBOL_GPL(alt_tse_pcs_create);
>  
>  MODULE_LICENSE("GPL");
>  MODULE_DESCRIPTION("Altera TSE PCS driver");
> diff --git a/include/linux/pcs-altera-tse.h b/include/linux/pcs-altera-tse.h
> index 92ab9f08e835..67be242a468e 100644
> --- a/include/linux/pcs-altera-tse.h
> +++ b/include/linux/pcs-altera-tse.h
> @@ -11,7 +11,25 @@
>  struct phylink_pcs;
>  struct net_device;
>  
> -struct phylink_pcs *alt_tse_pcs_create(struct net_device *ndev,
> -				       void __iomem *pcs_base, int reg_width);
> +struct altera_tse_pcs_ops {
> +	int (*read)(void *priv, int regnum);
> +	int (*write)(void *priv, int regnum, u16 value);
> +};
> +
> +struct altera_tse_pcs {
> +	struct phylink_pcs *pcs;
> +	struct altera_tse_pcs_ops *ops;
> +	struct mii_bus *mii_bus;
> +	struct mdio_device *mdiodev;
> +	void *priv;
> +};

Don't expose struct altera_tse_pcs to include/linux/pcs-altera-tse.h if
only drivers/net/pcs/pcs-altera-tse.c is going to access it. Put in in
pcs-altera-tse.c.

> +
> +#define altera_tse_pcs_to_phylink_pcs(tse_pcs)	((tse_pcs)->pcs)
> +
> +struct altera_tse_pcs *alt_tse_pcs_create(struct net_device *ndev,
> +					  struct altera_tse_pcs_ops *ops,
> +					  void *priv);

Also, it seems trivial for this to return the more generic struct phylink_pcs
type.

> +
> +void alt_tse_pcs_destroy(struct altera_tse_pcs *tse_pcs);
>  
>  #endif /* __LINUX_PCS_ALTERA_TSE_H */
> -- 
> 2.39.1
>
