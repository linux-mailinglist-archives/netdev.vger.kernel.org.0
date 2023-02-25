Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7B86A2BA8
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 21:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjBYU10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 15:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjBYU1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 15:27:25 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2136.outbound.protection.outlook.com [40.107.244.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627AC13D62;
        Sat, 25 Feb 2023 12:27:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ce8F2kWSKLcxhzlM2UDk+HKNT42ZXn8cgwWH4Cb9DF5lQKsUvfhYDx7wxLMPAXfABbgmiKAUr4S88CiUcD5c8ca+GzTDvF7xbcvQHp1AkKXuR6b1U/k/+3BstSr+sfxA0deL4xpNc/AJEo3wOawOkInKsyRblmNMPU6o0HxvHwIeAYpEn+w+EPZPzTv6k3Hl6XxwjShi6XVl14m40VjE4j7ScMWnCQD1H+GqmAfD7ZzW+i90fgMdg/XCEIrpgvFhRl0mP8Y1ZAsp0Tcw6bz4SJLCXVf85FbmsvwBe5cC6PSd7NtSzc1hLrh4tEXrMscFSKtqXTzW/4Z8uf3KWCi/Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=INrfJlaSgYmKA/H3dosPLXX/9fnXwo1Vk9KLgW38K40=;
 b=Me2AOVFiqe5BiqFGW5qc4LeUbEwM5Femv5Ly9lQdCpj6c+IaCdX2tkJ4cbX0YVAdNEM2IqLVrCpE0DneDiFtAsF6zEpE7WPtJD++eS40fyLFKmvsfaxm88h7CuxfEcYbMShKD/LwkegAAW4VONnKlewT7cCPMoV2GBFE/7yL1gyGuUjDyIguBXiYq0CnQ825M6/pGhBxGo466KTnDgXdFwfx+GbbIihZLGO4CqdKLyqrvXT7ff9n/2RLeC8K2sAzEeUWhaWbvlzuOjaBtfoxGU3wEweosIdNiD9M1VlH+Z25HWWBlhnismL5orjEoUug7fs2v17X/iTv0+YEgRXSTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=INrfJlaSgYmKA/H3dosPLXX/9fnXwo1Vk9KLgW38K40=;
 b=jQ+RgzfN7o4N/okPweH1xkTrOJ8GhpVOkG7V/gySKe1bRPBB4P6F/3EgND99KT2iAETPwa2a8b9LA6X9PvP0L/Mat4oqfFW2EFj1SuDl7vZ7KQLn69x0uJsgAe8UPEZlkiP1YAOhvB8WI8s+H2UN9c96CYuRN4Lzvn7ppjEdhgM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5373.namprd13.prod.outlook.com (2603:10b6:806:20c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Sat, 25 Feb
 2023 20:27:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6134.025; Sat, 25 Feb 2023
 20:27:18 +0000
Date:   Sat, 25 Feb 2023 21:27:05 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 6/7] net: sunhme: Consolidate mac address
 initialization
Message-ID: <Y/pvGVvjGkjTAXXM@corigine.com>
References: <20230222210355.2741485-1-seanga2@gmail.com>
 <20230222210355.2741485-7-seanga2@gmail.com>
 <Y/pV6KDgopeiPEPo@corigine.com>
 <0b105dca-c273-1fd2-339d-26e08b29c44c@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b105dca-c273-1fd2-339d-26e08b29c44c@gmail.com>
X-ClientProxiedBy: AS4P190CA0041.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5373:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c4a4a6f-f2c5-4e50-9ad9-08db176eb04b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IuxCL4ei9eDxBJDBPLsxRMYjN1E2Echt5Kw0aqYtPDq2e6mUKoFzgqGTEzqjh/jekusMSgC9Rr2KFPpMDf/+tN6eYXOr1XVnQSAtWVwU+EhS0FiDIQcmBebn8uSUaW8PVYJbC+/oiUKPxQDGgYBQsVkvgom0JHI6m8b/SW1PyIOwA5ByojYgxypOrV78koGQsZ7jHAecAEIL9SrTKQ8/1cTxHK+Al6cddxIeoJiwBl8dtke88aRp2YxJcrkr7rcueywKJ46bPLojgXq3ad+68876jY2PL1qPfQuipzkhv6ZXMsyg7oUhUxnaj+RmaxWiM5IRKUqQB6ckdtlFP5WMhOzOYyKUWWT85eQZwoPFWWl1H4c7T+IdJQJ8fmiB8TtSYcssXRElERUuZI8ObcEUCSzIfBPsElb5JNmAOFCcYpV0LxdgNqRhZa3p0epqKoT6dw8lg4Tniddzs/lPoK2eLWyrj++0rTOd/Oyd1qostNTK5wKnecXWerfB2VGjNPtyzYWud9JmLGpI/IXqNrVDmss/pwF3/bTaTBwDj5OlV/REBLWYTPfZLkXWiWr1tpD2uGObBA+adiwtvmCg1VTG7OlULD4zQDCk8XGRAIBvSJGBymi/bj8u7y6CtI/DNwqIt7pN1sNLl+KT1fp21rQq/zxNO+uCZYLGIQc4r3y1oiFMRwrPI0tbvf45d40pDLNV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(346002)(39840400004)(396003)(366004)(451199018)(316002)(5660300002)(186003)(53546011)(41300700001)(4326008)(66946007)(8676002)(6916009)(66476007)(54906003)(6486002)(86362001)(6506007)(66556008)(6512007)(478600001)(36756003)(2906002)(6666004)(38100700002)(83380400001)(8936002)(44832011)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IbRhtgL/3y+u97Prk6csQRzjLnYfh1STA2KFd2NXhack4WYeMHRuNL+PqJVv?=
 =?us-ascii?Q?GBqqAnBgaGUSqr/tzTp6mu1NLiqVyCM4Mw0laSzyo+jsPmuP3JKzC/1G5W98?=
 =?us-ascii?Q?4eIZNlJEwiRI4lD4Zorfu127w7Hd+OhuhQKEKWQRxpuWug4epKKoBy8fN67R?=
 =?us-ascii?Q?4xFv3uBLaosv4S1gk5pGszI+wsn42tjE9wKsdXgPyByBiN7L2Z8a4QvyXuPC?=
 =?us-ascii?Q?crY5vb4+WIuTmKFrSxANMJT5trsmaCGkeWcQmmoSYMMzCO8AYOWlaMcTs9tZ?=
 =?us-ascii?Q?Lme+Up4XqsCljs4I9UT3PqVIHk8Nl3Ozzgdhf8sDN9Opul7cLpNSGGsDmQGV?=
 =?us-ascii?Q?jTJXo3td9girl2Tek7i/OGyWUAh78Le5y4LVUl3dgE9X6JWhgFjyZJqCwxLT?=
 =?us-ascii?Q?oaA4cwj3zXBpZsC4EcajXyARaCdMqms2vxnFn8eMeTBKLlTssFRLQi/bC1rJ?=
 =?us-ascii?Q?wHOWOhusrYC5Mx5KlV3Yf+QOUyGI9vFOFGBdAJF4FHSQ6wX7YqQLhYlLPg2j?=
 =?us-ascii?Q?zJ49vwpTaouGXZAHdQJa0otRP2M0rbZpcg76a18egUJcKf4ppgu4Wy3EPxis?=
 =?us-ascii?Q?/pn5lHfByncoawUR8/hE6AJ2PSrcwp/ncpL1cUg5Nww/lIighYhtRwHgQLaa?=
 =?us-ascii?Q?IlF9urcqXHATGemYEnx7Sec59nBIqFXi4akjRLEZBo/xsoUcm2TLcHlbjESl?=
 =?us-ascii?Q?RJPmpYrKJbonbYBDJA0AYQlOlrU32Qz8On/ZIw0BxDSz6eY2sQl+J34l8f1C?=
 =?us-ascii?Q?Uo8Y0PJwGOQT+lDy2DxSzsOqxNiKYtUnd94TrkQSX2x0EjqI1pVhX4DEATjZ?=
 =?us-ascii?Q?GVJgq52jHTjAQVyba25JqnQP2vhusIyHNZjx/SOwwHGhplH81lwWIK46/yAQ?=
 =?us-ascii?Q?J5mk9Hp25e7tMf6CJVf5tYNDSUQwFJltOPsHoBbVnY88uXkEAuOIB8ho9LLh?=
 =?us-ascii?Q?fqQEhF1pA608mdW2IDQt3DPhTHq6Y1kuUmNxpe66B9oc1nAAg7dCSjRYtyWQ?=
 =?us-ascii?Q?WcDMIBCYlKFb7dC0eXnPy3dxc0Wc+k8Wb2YgnR/YKaORI95Pd6GANmC4yE8Y?=
 =?us-ascii?Q?xGK+0ZyaA3ikEXH96DXFSjFjZKnRI9SGCfLJSmjtZiYQVk9KgCw2DazgAAdF?=
 =?us-ascii?Q?LAbxsTbnUcevlyKJfkjspTlGgxDak99nYgVf7+LueEe2RxBDI7HKElWgTFMU?=
 =?us-ascii?Q?NGqnIYEULYW09WtGHrXA5zsr4fuNjdzobmLRbPS0D5uTfkjzL+yhB2sTm9j4?=
 =?us-ascii?Q?GOTKk0cJnPjdSdesDPp+cPWfb7o2PQtAa/GLi5BrXG8De+utY9T6ajraN//M?=
 =?us-ascii?Q?d+t4bf9lW4NlPyGVBBJvfPzHfoujXca2PKtsEHWwxhL+FlUiEZ1ohhyWm26u?=
 =?us-ascii?Q?NQ3X6r4i/GMsKcNx2hpEr2S5VIsV754FNHENEdTQix1yp+Uz2L8bAvJG0Ccy?=
 =?us-ascii?Q?ROhdhTdAkDG4MtViN6HWIVB4CPMaRsP2LNvYXrp3xkuyOhN6Hp7K6b3PF+4g?=
 =?us-ascii?Q?2xujH2OAwiKgmk42+eTZb+JxEr3VC0IzWWArwm5CK3s7zcY8/3q4vQp9myx0?=
 =?us-ascii?Q?Tp4/YjEkyJm8LIKu19rIuUP6PBnUpm6jQYXR2f1lHkmbj2yP1kbZo4v5NcgY?=
 =?us-ascii?Q?2crBTssYYttM9z8EkX/clLXSPttb/TBtaVp0Dhj7GAccoaqU4zo+/lOh1gSN?=
 =?us-ascii?Q?JJd5gA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c4a4a6f-f2c5-4e50-9ad9-08db176eb04b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2023 20:27:17.8383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2B7d4tXTBLIxHux2GVRzbVHXqlL8LJF1gQHtxEnZUKBtfuQYEolmvIP429zI0abWFWmJCCsmcWZpWzTx6znd76gWaa4/QYwydPemHPi/lbg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5373
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 25, 2023 at 01:59:33PM -0500, Sean Anderson wrote:
> On 2/25/23 13:39, Simon Horman wrote:
> > On Wed, Feb 22, 2023 at 04:03:54PM -0500, Sean Anderson wrote:
> > > The mac address initialization is braodly the same between PCI and SBUS,
> > > and one was clearly copied from the other. Consolidate them. We still have
> > > to have some ifdefs because pci_(un)map_rom is only implemented for PCI,
> > > and idprom is only implemented for SPARC.
> > > 
> > > Signed-off-by: Sean Anderson <seanga2@gmail.com>
> > 
> > Overall this looks to correctly move code around as suggest.
> > Some minor nits and questions inline.
> > 
> > > ---
> > > 
> > >   drivers/net/ethernet/sun/sunhme.c | 284 ++++++++++++++----------------
> > >   1 file changed, 135 insertions(+), 149 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
> > > index 75993834729a..9b55adbe61df 100644
> > > --- a/drivers/net/ethernet/sun/sunhme.c
> > > +++ b/drivers/net/ethernet/sun/sunhme.c
> > > @@ -34,6 +34,7 @@
> > >   #include <linux/mm.h>
> > >   #include <linux/module.h>
> > >   #include <linux/netdevice.h>
> > > +#include <linux/of.h>
> > >   #include <linux/random.h>
> > >   #include <linux/skbuff.h>
> > >   #include <linux/slab.h>
> > > @@ -47,7 +48,6 @@
> > >   #include <asm/oplib.h>
> > >   #include <asm/prom.h>
> > >   #include <linux/of_device.h>
> > > -#include <linux/of.h>
> > >   #endif
> > >   #include <linux/uaccess.h>
> > 
> > nit: The above hunks don't seem related to the rest of this patch.
> 
> I think I originally included this because I referenced some of_ thing from non-sparc
> code. But it seems like that got refactored out.
> 
> > > @@ -2313,6 +2313,133 @@ static const struct net_device_ops hme_netdev_ops = {
> > >   	.ndo_validate_addr	= eth_validate_addr,
> > >   };
> > > +#ifdef CONFIG_PCI
> > > +static int is_quattro_p(struct pci_dev *pdev)
> > 
> > nit: I know you are moving code around here,
> >       and likewise for many of my other comments.
> >       But I think bool would be a better return type for this function.
> 
> I agree. I will address these sorts of things in a separate patch.

Thanks.

> > > +{
> > > +	struct pci_dev *busdev = pdev->bus->self;
> > > +	struct pci_dev *this_pdev;
> > > +	int n_hmes;
> > > +
> > > +	if (!busdev || busdev->vendor != PCI_VENDOR_ID_DEC ||
> > > +	    busdev->device != PCI_DEVICE_ID_DEC_21153)
> > > +		return 0;
> > > +
> > > +	n_hmes = 0;
> > > +	list_for_each_entry(this_pdev, &pdev->bus->devices, bus_list) {
> > > +		if (this_pdev->vendor == PCI_VENDOR_ID_SUN &&
> > > +		    this_pdev->device == PCI_DEVICE_ID_SUN_HAPPYMEAL)
> > > +			n_hmes++;
> > > +	}
> > > +
> > > +	if (n_hmes != 4)
> > > +		return 0;
> > > +
> > > +	return 1;
> > > +}
> > > +
> > > +/* Fetch MAC address from vital product data of PCI ROM. */
> > > +static int find_eth_addr_in_vpd(void __iomem *rom_base, int len, int index, unsigned char *dev_addr)
> > 
> > nit: At some point it might be better
> >       to update this function to return 0 on success and
> >       an error otherwise.
> > 
> > > +{
> > > +	int this_offset;
> > > +
> > > +	for (this_offset = 0x20; this_offset < len; this_offset++) {
> > > +		void __iomem *p = rom_base + this_offset;
> > > +
> > > +		if (readb(p + 0) != 0x90 ||
> > > +		    readb(p + 1) != 0x00 ||
> > > +		    readb(p + 2) != 0x09 ||
> > > +		    readb(p + 3) != 0x4e ||
> > > +		    readb(p + 4) != 0x41 ||
> > > +		    readb(p + 5) != 0x06)
> > > +			continue;
> > > +
> > > +		this_offset += 6;
> > > +		p += 6;
> > > +
> > > +		if (index == 0) {
> > > +			int i;
> > > +
> > > +			for (i = 0; i < 6; i++)
> > 
> > nit: This could be,
> > 
> > 			for (int i = 0; i < 6; i++)
> 
> That's kosher now?

I can't vouch for all architectures (e.g. sparc).
But in general, yes, I think so.

> > > +	/* Sun MAC prefix then 3 random bytes. */
> > > +	dev_addr[0] = 0x08;
> > > +	dev_addr[1] = 0x00;
> > > +	dev_addr[2] = 0x20;
> > > +	get_random_bytes(&dev_addr[3], 3);
> > > +}
> > > +#endif /* !(CONFIG_SPARC) */
> > 
> > Should this be CONFIG_PCI ?
> 
> No idea. I think I will just remove it...

Yes, that would remove the problem quite nicely.

> > > @@ -2346,34 +2472,11 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
> > >   		return -ENOMEM;
> > >   	SET_NETDEV_DEV(dev, &op->dev);
> > > -	/* If user did not specify a MAC address specifically, use
> > > -	 * the Quattro local-mac-address property...
> > > -	 */
> > > -	for (i = 0; i < 6; i++) {
> > > -		if (macaddr[i] != 0)
> > > -			break;
> > > -	}
> > > -	if (i < 6) { /* a mac address was given */
> > > -		for (i = 0; i < 6; i++)
> > > -			addr[i] = macaddr[i];
> > > -		eth_hw_addr_set(dev, addr);
> > > -		macaddr[5]++;
> > > -	} else {
> > > -		const unsigned char *addr;
> > > -		int len;
> > > -
> > > -		addr = of_get_property(dp, "local-mac-address", &len);
> > > -
> > > -		if (qfe_slot != -1 && addr && len == ETH_ALEN)
> > > -			eth_hw_addr_set(dev, addr);
> > > -		else
> > > -			eth_hw_addr_set(dev, idprom->id_ethaddr);
> > > -	}
> > > -
> > >   	hp = netdev_priv(dev);
> > > -
> > > +	hp->dev = dev;
> > 
> > I'm not clear how this change relates to the rest of the patch.
> 
> This mirrors the initialization on the PCI side. Makes their equivalence
> more obvious.

Thanks, understood.

> > >   	hp->happy_dev = op;
> > >   	hp->dma_dev = &op->dev;
> > > +	happy_meal_addr_init(hp, dp, qfe_slot);
> > >   	spin_lock_init(&hp->happy_lock);
> > > @@ -2451,7 +2554,6 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
> > >   	timer_setup(&hp->happy_timer, happy_meal_timer, 0);
> > > -	hp->dev = dev;
> > >   	dev->netdev_ops = &hme_netdev_ops;
> > >   	dev->watchdog_timeo = 5*HZ;
> > >   	dev->ethtool_ops = &hme_ethtool_ops;
> > 
> > ...
> > 
> > >   static int happy_meal_pci_probe(struct pci_dev *pdev,
> > >   				const struct pci_device_id *ent)
> > >   {
> > >   	struct quattro *qp = NULL;
> > > -#ifdef CONFIG_SPARC
> > > -	struct device_node *dp;
> > 
> > Was dp not being initialised previously a bug?
> 
> No. All uses are protected by CONFIG_SPARC. But passing garbage to other
> functions is bad form.

Thanks, agreed.

> > > -#endif
> > > +	struct device_node *dp = NULL;
> > 
> > nit: I think it would be good to move towards, rather than away from,
> > reverse xmas tree here.
> 
> Which is why this line comes first ;)

Yes, silly me.

> But I am not a fan of introducing churn just to organize line lengths. So the
> following will stay as-is until it needs to be reworked further.
> 

Yes, no objections there.
I just misread the diff. Sorry.

...
