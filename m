Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAFD96BF922
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 10:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjCRJAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 05:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCRJAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 05:00:16 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2091.outbound.protection.outlook.com [40.107.244.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF193D083;
        Sat, 18 Mar 2023 02:00:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MChJ+wPMpq5vMWe++l6JMUmk7GwblqskUVLlJiskKM9fJHaAN4WuhKmJHyTehhExDyUD2390c3s/16xGv/Dw+9KgUeA2HOU7kwmBM0DQu76jQFK8n5ATnPeygtCzBS39dul2y/Ute8zIpSzPNtNuZrjWXOahbx8v+FBZk5OgDNgbIeuN9wqY37eT/nh409GI1YBUg/hKnUbl7otl7pswI8Zvo1GlYsh/EkbKSC8W2shYXB5aBMEBCr5QhhjNVzI4nMQoZoy/IWna2q3kGGS+zJAoEQSUnPTV53fNgKeqXWUjIb+5rbiBfGSdjtt1K7bpH6b/Eht+qJfeu74BiqRdAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h5AJiAaVx1+PR0GKuhAw6oHU/PwO3iEWNM/ovJYgDQg=;
 b=baWzlYcK9rlQ5CIUmJlaYH5pvAhlioTkBSjGMS7u9MsX9fhVyneCM3tnY7vcLYxe6Qchson2dvsFbT+0G/haViqAUhzI/g4g68nkYrVncx+ukSC7tuYuoOPazkxg+CGt0MX4WEZ35Pwn2muyaxKnoyUdRMOTq6zHExU3yHRG2fP+GGr7I30W2JF530qU8wD8Ggirz1GLhFlFUKsiqqJeqpygLM0YrpGgEAlg6xVev4V/+aSnhPxzlxWzYAnRZTSntPPdOcY/62WTR7ARQp4Z7aU8DbGsgzgbd3EK1God0Wv21Kf7SUGFb3hdKHfLk2iqMVT40ofWKdkm8RZK4zS64Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h5AJiAaVx1+PR0GKuhAw6oHU/PwO3iEWNM/ovJYgDQg=;
 b=ZB9xmOteOIiODIKSR1D4q+xHZ0lyZt0PES9/t4nsj1ReU1ShCdVNDFQxIXnVf5VZ2eISLFZC8WwfCD+YIHJxOmHaK2f0HDqHNrYD+icLV1wV6eZPvhY90IwVaW6gKdq6YYqcWwBV7hUcwFBOZenSD3GIdBdEWnyYyQzIywKPvns=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4985.namprd13.prod.outlook.com (2603:10b6:510:96::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Sat, 18 Mar
 2023 09:00:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.036; Sat, 18 Mar 2023
 09:00:12 +0000
Date:   Sat, 18 Mar 2023 10:00:05 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 6/9] net: sunhme: Consolidate mac address
 initialization
Message-ID: <ZBV9lT1I/gO7G3AQ@corigine.com>
References: <20230314003613.3874089-1-seanga2@gmail.com>
 <20230314003613.3874089-7-seanga2@gmail.com>
 <ZBV9M28EhKFYrHnc@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBV9M28EhKFYrHnc@corigine.com>
X-ClientProxiedBy: AM4PR07CA0009.eurprd07.prod.outlook.com
 (2603:10a6:205:1::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4985:EE_
X-MS-Office365-Filtering-Correlation-Id: 41cdaf5d-d2bc-48bd-8101-08db278f2e6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hWUCxLsC2zmEWNJkhWSGyn0QIW8NeQCKLKOmgB1dt38ajiHXXSvQYcXX1QRGg9nYV6fphhD95r2ETirUUF2KplIhTd4dl+Vx6Oq1xxDgohR1CjLg3IPLXJFt2v08YoAqQCoeOTE6NsFKSuiYY2qmh/v1mmf9rL73TkgUh/1k8GD+R18jNjvWXIY+baVYWnBctxiwCcsFRg5NnkqrlF3PlhWQSnE+yDZoWho6UB+hqUAd0dLGZjGhUZaL8yKj6L2qiOchhGJ8SSYlS/scdEfa63bwZ7el4ujmHdC0W93OiMb3wpDx83UkIxR5XxiuTXkLFKQQBLklpQI6YICWvvu8w7ZAj3b9IYPSPLom2N2fgSAWmKrh0NKcEpui3GI0QqE98poeb50A7UCDi8vAtR25ekRQo3XozVELunIrTQw9yhbMuHryrWX5iNPVkeF42PNPGJqmjglZdYX41hIvMLWwN1Z7AhxCMJkCBUaLU2lXK/ZCPS5a1/0KnJ70eSkbc5y3W1fLUfpS1SfxK3nugy4bS1BJfr6q/T4SggjUoMo8AQKsN4FZbVC8Oh+NUFXOjI/QUgK4RibLzVF/71gPwA/dZupkYd8fTJNllqfB4cK4mJtDDEE+rkYNQGFCi/SaL/qJxb8iwLmGFlDPsSqD+T2YGMeionn/qNf2Lbk1eb0DwKEB2YpgmrRXrkzH8Zcto45U
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39840400004)(366004)(376002)(396003)(346002)(451199018)(8936002)(44832011)(2616005)(5660300002)(6486002)(316002)(54906003)(83380400001)(6512007)(6506007)(86362001)(478600001)(38100700002)(2906002)(36756003)(6666004)(66556008)(66946007)(66476007)(6916009)(41300700001)(8676002)(4326008)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?73EFJe7Kw4R7ZzL7lWBIuevmTmw62ZzlI0/KMEI7fjAiclJTRcu+ujHe06p8?=
 =?us-ascii?Q?g+x7tq5tZyCRpo3bVnIYEkFxzCChswqrEVd1lT4/vhhzHAObNNqgdn9kLEBl?=
 =?us-ascii?Q?38jPuTbwU/iaB6bFMjh7hy/sANtkO3KdZFoVPeotHPzVjxxfZJotJc2LjMX/?=
 =?us-ascii?Q?b8ltf/GmhdtcxguhaSdE/rPmklgMOQASgKlAe/jG6qfpeHm45pMMY3kB40Dv?=
 =?us-ascii?Q?u7AJ43hABfAJDw6Bg8IiXZNOe08Z+bQzg+wsOqcLk8M3+Y9etIgGC4lWVcda?=
 =?us-ascii?Q?a5mo6q6ym71JzGWu0b+XumeH7vC3kpyy/SE3i6UR1A38a2tFKnYOfOKhf4Vi?=
 =?us-ascii?Q?bnwLlspEOtKUt7QTIhb2zdsq3dcDBt1PfHtvyfaXYwtTf+BnGer7cw2fkBof?=
 =?us-ascii?Q?w8b6S5S2W4dfl6qE5usqzbLC9rCqo+Lk9H22jpymlfvzmEGLZUoRx/9GrKO8?=
 =?us-ascii?Q?haeNg5bWOYYhmMCkNDtgIM3sALC72Aa0YNfDiCzGBJyda9acgchHxlurW1kt?=
 =?us-ascii?Q?G8GawirvdMmBNUxbU30DacFHI/4p+bbo10mQK0VadyV3MmvZ8LHDWHJdv9ly?=
 =?us-ascii?Q?VJuS1qfOssRz2q1uBYMfMEOpHRObjU1PpW7qvvF0PxmdrsJ1OIRFjPvqbmIj?=
 =?us-ascii?Q?3CZn82idDbHV3TCgF5f8nPp1fZx5D1kTd0yx6gxoh7CxLD9xTZY6lQ5qRBQ+?=
 =?us-ascii?Q?jT6wA8ADv3Lj+m9xuRMYlRcEb6awEVJtIXTN9gLjg77DHzSrPTEZv5vzfamK?=
 =?us-ascii?Q?mg838w+o27b0OdVzWpVQf+OLbOxgVO33k7/7lD7Y49s93PXtjuwnSwcTGGkV?=
 =?us-ascii?Q?XRisf/t/WREWmJERa5WM0dnb79duikcDkEjffOttOrAmVPvlC1NPC/CIRMKc?=
 =?us-ascii?Q?4pPnYiXEIRSEqik+o7RMeOAnVSG9UemxDGZ8L8WMl66yi3jiiJUHV77La2QR?=
 =?us-ascii?Q?Rx0nmsFRr3w8XtC8H9mC8EX0O7gHQ43iGuoZMESEC9LgLo0H8kASR/INvaTN?=
 =?us-ascii?Q?oiJuzfaodyz3U92X/y33wTfG0FpoSxmYrl9VB0MHR1vLItoVbb1c8Jn96I3o?=
 =?us-ascii?Q?j1fchAYhSx1Aj81yP2MZJ5kyljSDoW0VMDRjlFlzrGkyB0aR8/x5LDwadsVC?=
 =?us-ascii?Q?Mgfb9J08+KF4ayqIrkJAKG4nM45DYOsN0bjgVTnmgJ4W9QhpWVXet4J7ezrn?=
 =?us-ascii?Q?aE8aYPwq2i/Cc1nuitjq0O0bb/IWaNtc3o08r0ht5PjKD2q85aozLn5TnirG?=
 =?us-ascii?Q?QVC4sU5b5XLqRPdlPLps8HT/9owfxCynn0VrF7iY1QOgr1+Bx8Vmm/IyIirf?=
 =?us-ascii?Q?eDyL+u8OuUMMLcPLHA/C+S4E4Nw2EH7d3yL0b1kQcv44FVdVCoyusmTnbwKA?=
 =?us-ascii?Q?nQNMApcz6wVnnPvjRy14Lr3JQIVPLA8PAmYDunbCkHRy6t4i4TU5sCwkAj8Y?=
 =?us-ascii?Q?WmGpj7l3Y7B55eW9mrLfNgK/5uwlRyvdVzUTzw+Ygufn3JgQ6dyZmyiiBqnh?=
 =?us-ascii?Q?ygr45242eMiAx8SCTU5xeDeLVTVvNnzaI84j4SfZKAGW0dFzBlVR5YgdrgVs?=
 =?us-ascii?Q?/V+9EPX2KbEy9QW8ImdrgDjXasfFFf/vdz9LNQo514OUtK+ubqn2UOpCYm84?=
 =?us-ascii?Q?vsd1DXtRfmFdvM1f4PqC+7zFc4jTtNCRdZlmpzpgHzwmZBbnQSLxTjBc4bd3?=
 =?us-ascii?Q?xUk6ZQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41cdaf5d-d2bc-48bd-8101-08db278f2e6d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2023 09:00:11.8448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TJW7hFfziFDPfYLjGDt1/uXAbV/bGeFwG7PRkPDOEkX+ljgjR08w0P1WphDQBbOdcbwutVLeeWYXx1VVMfmB9FkHCqINHvOaxSK9ipYP4cs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4985
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 18, 2023 at 09:58:35AM +0100, Simon Horman wrote:
> On Mon, Mar 13, 2023 at 08:36:10PM -0400, Sean Anderson wrote:
> > The mac address initialization is braodly the same between PCI and SBUS,
> > and one was clearly copied from the other. Consolidate them. We still have
> > to have some ifdefs because pci_(un)map_rom is only implemented for PCI,
> > and idprom is only implemented for SPARC.
> > 
> > Signed-off-by: Sean Anderson <seanga2@gmail.com>
> 
> Hi Sean,
> 
> Nits aside, this looks good to me.
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> 
> > diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
> > index 3072578c334a..c2737f26afbe 100644
> > --- a/drivers/net/ethernet/sun/sunhme.c
> > +++ b/drivers/net/ethernet/sun/sunhme.c
> 
> ...
> 
> > +static void __maybe_unused get_hme_mac_nonsparc(struct pci_dev *pdev,
> > +						unsigned char *dev_addr)
> > +{
> > +	size_t size;
> > +	void __iomem *p = pci_map_rom(pdev, &size);
> 
> nit: reverse xmas tree - longest line to shortest - would be nice here.
> 
> 	void __iomem *p;
> 	size_t size;
> 
> 	p = pci_map_rom(pdev, &size);

Oops, I now see that you got this in patch 7/9.
Thanks!

> > +
> > +	if (p) {
> > +		int index = 0;
> > +		int found;
> > +
> > +		if (is_quattro_p(pdev))
> > +			index = PCI_SLOT(pdev->devfn);
> > +
> > +		found = readb(p) == 0x55 &&
> > +			readb(p + 1) == 0xaa &&
> > +			find_eth_addr_in_vpd(p, (64 * 1024), index, dev_addr);
> > +		pci_unmap_rom(pdev, p);
> > +		if (found)
> > +			return;
> > +	}
> > +
> > +	/* Sun MAC prefix then 3 random bytes. */
> > +	dev_addr[0] = 0x08;
> > +	dev_addr[1] = 0x00;
> > +	dev_addr[2] = 0x20;
> > +	get_random_bytes(&dev_addr[3], 3);
> 
> nit: Maybe as a follow-up using eth_hw_addr_random() could be considered here.
> 
> > +}
> > +#endif /* !(CONFIG_SPARC) */
> 
> ...
> 
> >  static int happy_meal_pci_probe(struct pci_dev *pdev,
> >  				const struct pci_device_id *ent)
> >  {
> >  	struct quattro *qp = NULL;
> > -#ifdef CONFIG_SPARC
> > -	struct device_node *dp;
> > -#endif
> > +	struct device_node *dp = NULL;
> 
> nit: if dp was added above qp then then
>      things would move closer to reverse xmas tree.
> 
> >  	struct happy_meal *hp;
> >  	struct net_device *dev;
> >  	void __iomem *hpreg_base;
> >  	struct resource *hpreg_res;
> > -	int i, qfe_slot = -1;
> > +	int qfe_slot = -1;
> 
> nit: if qfe_slot was added below prom_name[64] then then
>      things would move closer to reverse xmas tree.
> 
> >  	char prom_name[64];
> > -	u8 addr[ETH_ALEN];
> >  	int err;
> >  
> >  	/* Now make sure pci_dev cookie is there. */
> 
> ...
