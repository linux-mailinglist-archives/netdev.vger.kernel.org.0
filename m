Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB2D6A2B57
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 19:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjBYSjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 13:39:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjBYSjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 13:39:51 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2111.outbound.protection.outlook.com [40.107.93.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07C51285E;
        Sat, 25 Feb 2023 10:39:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JE5hIELLfqwfE/dWqQHTkHxm4XbLoxdfBf65wLmyJNCdVWED4xd7/ODpiYTg8/4XwRqqswkAm3c9aZ8VS1KhNiYYq5bVg3VD3wQq73UUXU6uwpEhzW044i2roBJ6S4kIE736EhscyvTiZ8fd+WSqFZPcnQ0TK1N2Omk9GiMWwmAnEIM3qwsLBKG+7CBRIm9hsZvXAYEVC8HBImk0XGzlQE5QWsjsGqHP2dgoX6r5NQKD3CEWmHdz7tzh4/iUwgDUSLlkU7Nhzrg6KJdS3ME/LXW9hS1a9Ajksmj0I/4ROt5ID7nvN+aeWnfnd5M8TLzUWEbgPplq9HgkqJ21Vb4q9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CLaXVvw0j+b+XMvLmcCp6mW2CyEASSb72xFZcupMm8Q=;
 b=NwrJtes37S89xeK9m44NvwZ1yADGTE1R4oTK5Q3IzS4/GLGelLvOlT4aih7dgNUgU0+kSWPGayE94frUCk3UQ/T5U1guNrJ24AmiOErMsVuh7fvxnMiow4b2kVG9S4KfqaJ323fLU4y1PbIOwD0eJ790eOjDrmqw29xxkDoFsu68+sIpYyvSsI9K3uZBK4YJE8frGwtyVpVw7l6n4LF+rUUQoVPEmbrc8ohFY1yJOmgtTA7wCqRPEyvvUaAJqZplGh4BkIW15i05uNfDSN20Pj87ZzP2kZ3LE/h8GVJ+xLa8azkcEm+ec4yDtWt8d0FRIgXVSXBsHyWfDMtZlAX7SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CLaXVvw0j+b+XMvLmcCp6mW2CyEASSb72xFZcupMm8Q=;
 b=h0MZeEVNMffKWJZwClFcR0utsuii/3qXMFQBoOntcBsZByZQ/Ul90Gv/fTazKvgOaTGjpg0xamJwOWk7XE1SedGUapnvwEiANYU61H16+zxE4p498X2/oILb1nDLZsobqQqZA9aw5aj4hGxOH9OmojQz0Yo/QMAzsA4Wehhw694=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6171.namprd13.prod.outlook.com (2603:10b6:510:242::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Sat, 25 Feb
 2023 18:39:43 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6134.025; Sat, 25 Feb 2023
 18:39:43 +0000
Date:   Sat, 25 Feb 2023 19:39:36 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 6/7] net: sunhme: Consolidate mac address
 initialization
Message-ID: <Y/pV6KDgopeiPEPo@corigine.com>
References: <20230222210355.2741485-1-seanga2@gmail.com>
 <20230222210355.2741485-7-seanga2@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230222210355.2741485-7-seanga2@gmail.com>
X-ClientProxiedBy: AS4P190CA0025.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6171:EE_
X-MS-Office365-Filtering-Correlation-Id: 35a928a6-6564-4e31-cb1b-08db175fa8ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z+T7VMOUNif7dTs/ZfCx166PNH0NqgjhHK80imslADu7xWQfSMwgEc9yY/VdjDpN8FyZSFfbLk1H+DAVeFvYELVi40MUhAP1Xav44bnszdTK36lcPNX7nT3jgtr59A32x6WLsFsXyUoNBEo8WO8bpI718WhIew0l7pnDsbQsxqWjshtMshkxnGEcidyD9WAADNnx+kWhTOnQTh8W66hl3hoxjMS9Tr+Qh5eTNrMnlG1t5w6B18UDnSPkGhbbZC8M7ix+xKtwUj7CyCTQgSPdCzhaXXbL1+eUbqCP3W/3+IW3+qNJrOYkbtBv5YP77/KkgV5Q5zXZNeQuP4nkZBAiV2q2B1mCdivj6Q7JAnuK6nJ71oPbk7m+Lj67Nn6goeeijT26VJkozcmKDlW2lWN2dTEfI3rYt0YFs7v+7IBIIXzCYrpsXF3htks/SbE8jrUIsRh1GwiAzNEXhigzxlGjZ0/vD91oCu/VZejUYne0uWpAEcYZEVGQgyk150VG087xSNHYH9QhAMwkkT6wf3B0naU4mMpWbNPo69WUaYFQ9tcP2pncKX4M7QXWEzJVCNFnoiSikh9bMJHSyhlP4K4vTXUjQ2CbfcCiE/TeEr7gqUbM8ISVXdyVN8AgeKInDdsxGhcQlFFcgeuwfyWjYFX06PACcfVgWpQVE48ZTacKJKFI0CsGcqjLsCuFXGw5zsWZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39830400003)(366004)(376002)(396003)(346002)(451199018)(83380400001)(2616005)(38100700002)(8936002)(5660300002)(44832011)(41300700001)(2906002)(6666004)(6512007)(6506007)(186003)(86362001)(316002)(478600001)(54906003)(6486002)(8676002)(6916009)(66946007)(66556008)(66476007)(4326008)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IkwkZuITD2w9JAwHw4hZ6Bj6HHh446IpZ6UJlfyhA4IUskpO4CB/YmV3vhst?=
 =?us-ascii?Q?E1qeh39GAx07x077AL2FXqd8Pntc3TX1MNAJX6Ld49Ee6f8+3O5PBEZg8RjT?=
 =?us-ascii?Q?JJQI85qkD2XxyEOx5ip0v6e0Ao7CZA+3LVwduNyU1JMCXvnJjeZB/Yz+lvV3?=
 =?us-ascii?Q?zF9gjgCkzWaae/Gn/SuRizawONO+Pen+VvMIYyXjQJFjKYiFqk7O9Nu6uVeU?=
 =?us-ascii?Q?ABu/2hknDdDLtG61V0FCO6a8AuUvfzXupYAPm0SF+9gCcb/ppdYhi8mw3+zg?=
 =?us-ascii?Q?7fswSqFa8ff0N4Y1LrsjZ0R0daWKcY2x8THxDdYqOH0qw28bV1J1HuVIPMnY?=
 =?us-ascii?Q?Gyo2XNDT8bTsXw+fV334SeSKQ3lg4syQxm20eW/8fF6NzCaFtAPrjnN2qK/x?=
 =?us-ascii?Q?dapAb6yxgr0zipcWA0lA4nbFEpVt4dLYEMu4p7Jp/4A+V5WUtZk7Hm+l8YcF?=
 =?us-ascii?Q?FUiWcZseCqrWu1luGWZzm1cqGTfJQKrLZm2DA9rca+5S0nAglVC2kl9zVcat?=
 =?us-ascii?Q?4hnyU/xKmLJNhgnLDBJwQZcrZrHDxN7wKfaQw3bvg129KcSjPviEzkGFtfkt?=
 =?us-ascii?Q?POenLgC8dwuxYu3vuc4o8kyCBir4zmOz2O5CU93M6maUK2aykLa8LYovGNeL?=
 =?us-ascii?Q?tSOjeepgj8hoeMEwamlv4UEJYEUVs6Pp7a9HU2oQ/IU4RPNcMYxxHRHBv8VK?=
 =?us-ascii?Q?RoV5sCKpPJzyHMULLERmvUj+wSTReaa3ds1eY2axal4ER5JJ/BqbXyTx5YH5?=
 =?us-ascii?Q?XcAkFyRceZB1ejDjWVaxeVVi4BqSTUbgBbXjHheePKW7PLaxovnQvnz0RbzV?=
 =?us-ascii?Q?9fkH/SOggqT273Pv2SKCBnUuFF4P+rvrTchwjAONU/rVArYURQpzsDh/NYUj?=
 =?us-ascii?Q?zFCb4h6LYFhu3U0eWi/+y3sRi7yfY6YOToxOG4FIl/VZh8Jn9JcTwWhIyZys?=
 =?us-ascii?Q?nph7x6j9gbNkIBfprdcFN7JDdhWz9EQP4WEqOM8ycNUfFAcXwTJcZFsPRv8L?=
 =?us-ascii?Q?y26PX5ukq/kEZ/vvH/WMuA0NDru7whIJ0//+1AYQmZlV6+mDaCw9v3qr7UZJ?=
 =?us-ascii?Q?r9eplvHtk2yvfhn/otIDL6kzCFlw+/R9X7MPlsLVczBcbCJir4dZTwExFxCN?=
 =?us-ascii?Q?N336BU602UQG8fhIXdPLQVQ3RUXK15PvBCteImqT9QRU9qPPPVkgzmngqidq?=
 =?us-ascii?Q?fjHSYYxpV0Q+07fypKt1khTGSaclpK6bAkQ9RaYpe+DMgWGk0JYSZxbfqq+8?=
 =?us-ascii?Q?xjNEpjtVqlEjALIY9aZ/bSsX4UjQavUl0D4aYbzwWxepJ5ZyxmMffDYTTaxx?=
 =?us-ascii?Q?/tba7WtEyXTR8xbPhnGZN0TK8f84pM6L5TX3bEndawZRuoC5SlkOw2szKj6U?=
 =?us-ascii?Q?QG90ufyszAcD6AuQJldHCHSn7rnRrSoNCd0NFw07VuYuNt+3C8ha4BxKEHqy?=
 =?us-ascii?Q?IILF0TlOCOx67rdBA7JhBsFaOFg8f4yO8xkdRCok5+SwM40KEXXN7V2vEzPp?=
 =?us-ascii?Q?Avc9GeRCd0Y0J7UZRAgm/tQip3/Fa/2VCpMupljll+YBkLVHhM+e7r9nzi0c?=
 =?us-ascii?Q?tmmEQLE5DpQGNEaapiyNCfdFQpzAYoQ3LVVRqOR5kIPHYwQXD32nZ5SYPAit?=
 =?us-ascii?Q?gNIuAUbu7y/E5J2XcJjJtvXiqvayylbvZ650ExgsPwHQD0bxECl8rGRO4ENd?=
 =?us-ascii?Q?scY2PA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35a928a6-6564-4e31-cb1b-08db175fa8ea
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2023 18:39:43.0701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gB3daVa/4JQknWGHIZ5vemZuo5Rdye89LTa+7j/jyHWO1JZBC0dlMeY93x4yALmT+Vw1TxdMYdN5QAdOUu4G/QHy21c2ETfVB6bwPPDN52o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6171
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 04:03:54PM -0500, Sean Anderson wrote:
> The mac address initialization is braodly the same between PCI and SBUS,
> and one was clearly copied from the other. Consolidate them. We still have
> to have some ifdefs because pci_(un)map_rom is only implemented for PCI,
> and idprom is only implemented for SPARC.
> 
> Signed-off-by: Sean Anderson <seanga2@gmail.com>

Overall this looks to correctly move code around as suggest.
Some minor nits and questions inline.

> ---
> 
>  drivers/net/ethernet/sun/sunhme.c | 284 ++++++++++++++----------------
>  1 file changed, 135 insertions(+), 149 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
> index 75993834729a..9b55adbe61df 100644
> --- a/drivers/net/ethernet/sun/sunhme.c
> +++ b/drivers/net/ethernet/sun/sunhme.c
> @@ -34,6 +34,7 @@
>  #include <linux/mm.h>
>  #include <linux/module.h>
>  #include <linux/netdevice.h>
> +#include <linux/of.h>
>  #include <linux/random.h>
>  #include <linux/skbuff.h>
>  #include <linux/slab.h>
> @@ -47,7 +48,6 @@
>  #include <asm/oplib.h>
>  #include <asm/prom.h>
>  #include <linux/of_device.h>
> -#include <linux/of.h>
>  #endif
>  #include <linux/uaccess.h>
>  

nit: The above hunks don't seem related to the rest of this patch.

> @@ -2313,6 +2313,133 @@ static const struct net_device_ops hme_netdev_ops = {
>  	.ndo_validate_addr	= eth_validate_addr,
>  };
>  
> +#ifdef CONFIG_PCI
> +static int is_quattro_p(struct pci_dev *pdev)

nit: I know you are moving code around here,
     and likewise for many of my other comments.
     But I think bool would be a better return type for this function.

> +{
> +	struct pci_dev *busdev = pdev->bus->self;
> +	struct pci_dev *this_pdev;
> +	int n_hmes;
> +
> +	if (!busdev || busdev->vendor != PCI_VENDOR_ID_DEC ||
> +	    busdev->device != PCI_DEVICE_ID_DEC_21153)
> +		return 0;
> +
> +	n_hmes = 0;
> +	list_for_each_entry(this_pdev, &pdev->bus->devices, bus_list) {
> +		if (this_pdev->vendor == PCI_VENDOR_ID_SUN &&
> +		    this_pdev->device == PCI_DEVICE_ID_SUN_HAPPYMEAL)
> +			n_hmes++;
> +	}
> +
> +	if (n_hmes != 4)
> +		return 0;
> +
> +	return 1;
> +}
> +
> +/* Fetch MAC address from vital product data of PCI ROM. */
> +static int find_eth_addr_in_vpd(void __iomem *rom_base, int len, int index, unsigned char *dev_addr)

nit: At some point it might be better
     to update this function to return 0 on success and
     an error otherwise.

> +{
> +	int this_offset;
> +
> +	for (this_offset = 0x20; this_offset < len; this_offset++) {
> +		void __iomem *p = rom_base + this_offset;
> +
> +		if (readb(p + 0) != 0x90 ||
> +		    readb(p + 1) != 0x00 ||
> +		    readb(p + 2) != 0x09 ||
> +		    readb(p + 3) != 0x4e ||
> +		    readb(p + 4) != 0x41 ||
> +		    readb(p + 5) != 0x06)
> +			continue;
> +
> +		this_offset += 6;
> +		p += 6;
> +
> +		if (index == 0) {
> +			int i;
> +
> +			for (i = 0; i < 6; i++)

nit: This could be,

			for (int i = 0; i < 6; i++)

> +				dev_addr[i] = readb(p + i);
> +			return 1;
> +		}
> +		index--;
> +	}

nit: blank line

> +	return 0;
> +}
> +
> +static void __maybe_unused get_hme_mac_nonsparc(struct pci_dev *pdev,
> +						unsigned char *dev_addr)
> +{
> +	size_t size;
> +	void __iomem *p = pci_map_rom(pdev, &size);

nit: reverse xmas tree.

> +
> +	if (p) {
> +		int index = 0;
> +		int found;
> +
> +		if (is_quattro_p(pdev))
> +			index = PCI_SLOT(pdev->devfn);
> +
> +		found = readb(p) == 0x55 &&
> +			readb(p + 1) == 0xaa &&
> +			find_eth_addr_in_vpd(p, (64 * 1024), index, dev_addr);
> +		pci_unmap_rom(pdev, p);
> +		if (found)
> +			return;
> +	}
> +
> +	/* Sun MAC prefix then 3 random bytes. */
> +	dev_addr[0] = 0x08;
> +	dev_addr[1] = 0x00;
> +	dev_addr[2] = 0x20;
> +	get_random_bytes(&dev_addr[3], 3);
> +}
> +#endif /* !(CONFIG_SPARC) */

Should this be CONFIG_PCI ?

...

> @@ -2346,34 +2472,11 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
>  		return -ENOMEM;
>  	SET_NETDEV_DEV(dev, &op->dev);
>  
> -	/* If user did not specify a MAC address specifically, use
> -	 * the Quattro local-mac-address property...
> -	 */
> -	for (i = 0; i < 6; i++) {
> -		if (macaddr[i] != 0)
> -			break;
> -	}
> -	if (i < 6) { /* a mac address was given */
> -		for (i = 0; i < 6; i++)
> -			addr[i] = macaddr[i];
> -		eth_hw_addr_set(dev, addr);
> -		macaddr[5]++;
> -	} else {
> -		const unsigned char *addr;
> -		int len;
> -
> -		addr = of_get_property(dp, "local-mac-address", &len);
> -
> -		if (qfe_slot != -1 && addr && len == ETH_ALEN)
> -			eth_hw_addr_set(dev, addr);
> -		else
> -			eth_hw_addr_set(dev, idprom->id_ethaddr);
> -	}
> -
>  	hp = netdev_priv(dev);
> -
> +	hp->dev = dev;

I'm not clear how this change relates to the rest of the patch.

>  	hp->happy_dev = op;
>  	hp->dma_dev = &op->dev;
> +	happy_meal_addr_init(hp, dp, qfe_slot);
>  
>  	spin_lock_init(&hp->happy_lock);
>  
> @@ -2451,7 +2554,6 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
>  
>  	timer_setup(&hp->happy_timer, happy_meal_timer, 0);
>  
> -	hp->dev = dev;
>  	dev->netdev_ops = &hme_netdev_ops;
>  	dev->watchdog_timeo = 5*HZ;
>  	dev->ethtool_ops = &hme_ethtool_ops;

...

>  static int happy_meal_pci_probe(struct pci_dev *pdev,
>  				const struct pci_device_id *ent)
>  {
>  	struct quattro *qp = NULL;
> -#ifdef CONFIG_SPARC
> -	struct device_node *dp;

Was dp not being initialised previously a bug?

> -#endif
> +	struct device_node *dp = NULL;

nit: I think it would be good to move towards, rather than away from,
reverse xmas tree here.

>  	struct happy_meal *hp;
>  	struct net_device *dev;
>  	void __iomem *hpreg_base;
>  	struct resource *hpreg_res;
> -	int i, qfe_slot = -1;
> +	int qfe_slot = -1;
>  	char prom_name[64];
> -	u8 addr[ETH_ALEN];
>  	int err;
>  
>  	/* Now make sure pci_dev cookie is there. */

...

> @@ -2680,35 +2695,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
>  		goto err_out_clear_quattro;
>  	}
>  
> -	for (i = 0; i < 6; i++) {
> -		if (macaddr[i] != 0)
> -			break;
> -	}
> -	if (i < 6) { /* a mac address was given */
> -		for (i = 0; i < 6; i++)
> -			addr[i] = macaddr[i];
> -		eth_hw_addr_set(dev, addr);
> -		macaddr[5]++;
> -	} else {
> -#ifdef CONFIG_SPARC
> -		const unsigned char *addr;
> -		int len;
> -
> -		if (qfe_slot != -1 &&
> -		    (addr = of_get_property(dp, "local-mac-address", &len))
> -			!= NULL &&
> -		    len == 6) {
> -			eth_hw_addr_set(dev, addr);
> -		} else {
> -			eth_hw_addr_set(dev, idprom->id_ethaddr);
> -		}
> -#else
> -		u8 addr[ETH_ALEN];
> -
> -		get_hme_mac_nonsparc(pdev, addr);
> -		eth_hw_addr_set(dev, addr);
> -#endif
> -	}
> +	happy_meal_addr_init(hp, dp, qfe_slot);
>  
>  	/* Layout registers. */
>  	hp->gregs      = (hpreg_base + 0x0000UL);
> @@ -2757,7 +2744,6 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
>  	timer_setup(&hp->happy_timer, happy_meal_timer, 0);
>  
>  	hp->irq = pdev->irq;
> -	hp->dev = dev;
>  	dev->netdev_ops = &hme_netdev_ops;
>  	dev->watchdog_timeo = 5*HZ;
>  	dev->ethtool_ops = &hme_ethtool_ops;
> -- 
> 2.37.1
> 
