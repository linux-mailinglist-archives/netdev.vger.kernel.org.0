Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C705D6C9304
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 09:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbjCZH52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 03:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCZH50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 03:57:26 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2097.outbound.protection.outlook.com [40.107.244.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3F293F7;
        Sun, 26 Mar 2023 00:57:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V+wHjVfBGPrhaleUt6AFFAto8SEsBjfXb/2BGpJmot/aVIi9J4LxpS3GOyMo2avaLnMbuT4+MBQQQDDsqS8y0/Qb/2ZsmoFcLE846dxkJI5vFhqqiiAzANH2Uiyfh20IO0lE2UaDM/UopInV2w+91ZERnF/KjO33yaPEoZF4ajJVWngj1ap2sFTTcj36feIH/AfmMSnRETEJcVOSpq5210hN4uzMe7PiEQ2s60sRLXipPsNGMiabYeh8cYLoapocRmBoVxRYQ1fa5S/z91vMmrxnc3JtZxAE3FsLKaH+11rc9mhteMnOqzTblLMNFgXl+0booUQmf7MKo0bdPkvYdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bMNnv/QLCi+AVONCYsFPk3gfvDgvNZTeVzTMAwWUhq0=;
 b=ZoU7+uPvDMjAEQE8/LxzftMTVQQ2zOYgBmjcFaH7EOEofbflUH8BrAEzQ3SFTaJeKxcJV4J6OCWLFZv7zEjazDLZgVQFCLClb6AF+CXvc+PltN1ff2Y6XZryTA/2Q8lhJeM8KQu1Hjiv2BdPU4Epe6zd27ox3XeBMZ4Doh2cUuWJ9FB47y6XVcVVThJu/iDwYafL9ksh1aRRxpqZd7wy/gw7HteD2tm8a5W80jJP7T75nlvdDWwnQOdYeELGd+32LtYgdfWpdXw2i7xSLTebeUakmqSaGtZVbs/pMFVor0HMC64tZo8Cx1P1vzqJ3xbgtrs8ch0bE4Lj2edTBbMp0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bMNnv/QLCi+AVONCYsFPk3gfvDgvNZTeVzTMAwWUhq0=;
 b=oCSt7qOBuJRt8r4AMBCVxZk44Y6ruS2EfE0p9sPLJyQI91RlzVrHgqchZr61PPa/vUKS23N6qDMFXTYjuZ9PcCGEy2m01+BsP84/7GognTpYOFhd0EnfQ0lfRGKBf3IdIUsTHHlymJlwrF5vlBjWyH3Z2NWyS68hsGnSFi917PI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB4471.namprd13.prod.outlook.com (2603:10b6:a03:1db::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sun, 26 Mar
 2023 07:57:24 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Sun, 26 Mar 2023
 07:57:23 +0000
Date:   Sun, 26 Mar 2023 09:57:17 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 10/10] net: sunhme: Consolidate common probe
 tasks
Message-ID: <ZB/63cE1DtYNpgtV@corigine.com>
References: <20230324175136.321588-1-seanga2@gmail.com>
 <20230324175136.321588-11-seanga2@gmail.com>
 <ZB66hgG2+nn6CxS7@corigine.com>
 <a4ecd20b-5d13-893b-2329-f6dd0c565ad5@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4ecd20b-5d13-893b-2329-f6dd0c565ad5@gmail.com>
X-ClientProxiedBy: AM0PR04CA0005.eurprd04.prod.outlook.com
 (2603:10a6:208:122::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB4471:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f6e8a4c-04b9-469c-05fd-08db2dcfbbd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /T+XMR8fkohZmcq7gaheREI+jdMSjkfR8gpixId1WKyGoAIIejkAd/Vo0KM/sbZ+kryP8xAyBWOVnPDbWN/Ou+tw9b+wNdxPKkWnyrLgLFAibOGsR7t7OOfKYDFtqwLcFM6NAO44XECLoeOsKMUmvKEHyp6gIT6CkVOvUi6zfiZeEHo7iil5jXVcZjPWZLGuHtaxevrs8iVFGMeUOWSIRfL8vp8kK1jVf0OtrNnj11Jkx7FTc+crJ67ghDOnC1w66TDyaZCT1zAT+Cd5e8oX8CJiB4azrnDWHxy6ckOTRdTOEI0JIw4HgbWegCmCbfPEojjUMTCRSQcJewPrDCVoDxdgRPy9ZnXU7hb8F+/JAYVgmIIzQAN69Vu0hbIjApHI/ywQIEU1GAWb234YqJJI+YtHGWbYp3s0LLbefUBXKwRN8MH25PlczYMK/P48W9h+pou4Oc66NxrFCnOQRZYimbF//3C6NXE+LzOgFQ7wXui2v2Fo6jAuWzd94jyvMeN6Hw2UkRq7iKyKnN3NPVJhUr7Z6yip7O8+iobEMGPoElgXFOV9VwmoFf8IBzN7SVtO3zmzleiIyLre7CNtZuTO6YXICyaWFLUGYXVcLfDOeWY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(396003)(346002)(39830400003)(376002)(451199021)(54906003)(36756003)(4326008)(41300700001)(8676002)(186003)(316002)(478600001)(6916009)(8936002)(5660300002)(2906002)(38100700002)(44832011)(53546011)(2616005)(6512007)(6506007)(6486002)(66946007)(66556008)(66476007)(6666004)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?laKD/mmlFLothW47o1IV7Wd7EqECqv94ov/KsLb3MAacuSBKp5MFyUzrr+Tb?=
 =?us-ascii?Q?/VLmLJeTRjwlxR3/OVqPtSxuAr0JM1BtThtJ4D/74UaiIEJuRoe+Lam2pzq+?=
 =?us-ascii?Q?XKpwUK881ZgwBNsr6PcCEv2P3OYlWRYgGlIOpohU8ykAx28UlIlO3DOgAzjR?=
 =?us-ascii?Q?geosZVch8behvm/cd1imTQuvdG6qIBdw69toIJMMqcZfUkvaKC9Wn3w0CxwX?=
 =?us-ascii?Q?GPWXrEDHMB/O2zilbJe5F0ytR25jVUXWCcOAlkX7PSjcKIDoYSvkO68G+j+m?=
 =?us-ascii?Q?xkz5XPAXcDmDzBdCd41fNAYXCId6Q7JakWT7nrnJEPKhH5BxoPHBTif7Qws/?=
 =?us-ascii?Q?gYulowqT1FNIbP++QZhkktDafMszxnO8L5OFcY7hj9b0wQEuqsS2N0x3ZteQ?=
 =?us-ascii?Q?AsrRjxCwUc2lmFpxe/Kp8TIt0KlkEXD2ei9BRxLk0pbKxupuCnNxPZodlE8D?=
 =?us-ascii?Q?0lVufva/hTMy54u+aqCd1eNoSgmm3bfNoXykTuNGyMbNe2QXFJwamaMUWATM?=
 =?us-ascii?Q?bf22VpkcXdna0H7XxGhQloiZNPTQ195pHfiJNYsd2s8wJ46KaOsE2QXNc/ve?=
 =?us-ascii?Q?fd9sxC1sMEfZdU+bnbaKpatWrbiD8TylGLXYW0m6yf4lA3BQJzlgC0b08BFw?=
 =?us-ascii?Q?6bMXc3W4YAMdSgnvGcQQLRN8JGm2NGZs43Do0amESgg3XYEtHZgflWpfR5vd?=
 =?us-ascii?Q?n2cXqoWJoCISJBv1mD2KIxIncYk6gsgKQu7bhkgQAeLb82oJ2UxuLPsstV5I?=
 =?us-ascii?Q?7Qi6ik19RL9c7z9Rz1dR+01IRUYcSCGIsyik+Gtwu8MoKIhhiXGOqm1V4SqJ?=
 =?us-ascii?Q?a0cL/5tB14i7dNq09Y4OLK1z5Y9BVKY4tDSM4o4XkS0Tv6gKHSHbdpVT1jXH?=
 =?us-ascii?Q?4E2u8/IKy/J54IW2yqFyyEcUShc9Qid+4Azd8D+ZdpasLyBTnmvtoLsFtMRN?=
 =?us-ascii?Q?mKZBdCRrlomdQ3IJq1Eo1JBDS/S6aPqHdy2zF3pGvTOQ9PNEYmyBAtemuade?=
 =?us-ascii?Q?DMvEsA4uc5j0o+QjqWXFiHnAcnGyuMi8f30C8ScmkeAqivt1zPEATC/1j0ny?=
 =?us-ascii?Q?U4+h0XIQ7G3Cezg6nC6MRRxUVJWwChAcI6FTRQ7OouRlMCmA+PP7CIWKCgTM?=
 =?us-ascii?Q?003m/x+c9Ipd6qD9ugaYC6x7AkAySJobKqHVg+JgU211gHFUKELmHihQb8Uw?=
 =?us-ascii?Q?MWTfReMnA0bl5hjGaDyPLd4y8LghLCfRPKodHFkDPZbMQ6kF5+cNbaZ4WirK?=
 =?us-ascii?Q?TjzNcnkRuv8UraNBNu88bRZ9cDxv4PbRc8tV4OgWJCMOuGOkT9xZANiQGeKm?=
 =?us-ascii?Q?5aJpPghYcpI+Hn+LeO5jozxweqsnkOzsx4ypwNjBIV911/nIH+U0KRvBjHz+?=
 =?us-ascii?Q?MWzzxpJ9/ajYIqObwDKrycrisZx5+ExMrUV80vhfCKKbhTZJ6tzLjIwG1eg6?=
 =?us-ascii?Q?jRElBG2u+6xDtisEyaERvzJWIpjSkY8755ZckQt9nBJKLNSF71qVSRLJSb64?=
 =?us-ascii?Q?JPs1UmNUDdWcnBbWGvWPaB6cBtW35Scfy50eXfwWaWzzJd+NvkzIzUfHQogU?=
 =?us-ascii?Q?kJChWtIIxVNnSwsCQUh2QYTtE0Gd2Igs57y4ew5peBemdZ/5k8oPuFUQS1Gb?=
 =?us-ascii?Q?KWUK1eDvNTvmNJuywjjdjNT9T1Dn4cFjXoH/mbF6bE025shXo/umx99WiciE?=
 =?us-ascii?Q?snmPpA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f6e8a4c-04b9-469c-05fd-08db2dcfbbd0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 07:57:23.8715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /q7rs4whdFpPxH2cqhyU1V//1GJlI9/AmCaQW4EpK/712YhFMrG3zo4aaMNeDPkAYotFjf0bekGMhjDaOPEthtaDXELSXIs0P/UMYQvwJmE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB4471
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 25, 2023 at 12:06:41PM -0400, Sean Anderson wrote:
> On 3/25/23 05:10, Simon Horman wrote:
> > On Fri, Mar 24, 2023 at 01:51:36PM -0400, Sean Anderson wrote:
> > > Most of the second half of the PCI/SBUS probe functions are the same.
> > > Consolidate them into a common function.
> > > 
> > > Signed-off-by: Sean Anderson <seanga2@gmail.com>
> > 
> > Hi Sean,
> > 
> > overall this looks good.
> > But I (still?) have some concerns about handling hm_revision.
> > 
> > ...
> > 
> > > diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
> > > index bd1925f575c4..ec85aef35bf9 100644
> > > --- a/drivers/net/ethernet/sun/sunhme.c
> > > +++ b/drivers/net/ethernet/sun/sunhme.c
> > > @@ -2430,6 +2430,58 @@ static void happy_meal_addr_init(struct happy_meal *hp,
> > >   	}
> > >   }
> > > +static int happy_meal_common_probe(struct happy_meal *hp,
> > > +				   struct device_node *dp)
> > > +{
> > > +	struct net_device *dev = hp->dev;
> > > +	int err;
> > > +
> > > +#ifdef CONFIG_SPARC
> > > +	hp->hm_revision = of_getintprop_default(dp, "hm-rev", hp->hm_revision);
> > 
> > Previously the logic, for SPARC for PCI went something like this:
> > 
> > 	/* in happy_meal_pci_probe() */
> > 	hp->hm_revision = of_getintprop_default(dp, "hm-rev", 0xff);
> > 	if (hp->hm_revision == 0xff)
> > 		hp->hm_revision = 0xc0 | (pdev->revision & 0x0f);
> > 
> > Now it goes something like this:
> > 
> > 	/* in happy_meal_pci_probe() */
> > 	hp->hm_revision = 0xc0 | (pdev->revision & 0x0f);
> > 	/* in happy_meal_common_probe() */
> > 	hp->hm_revision = of_getintprop_default(dp, "hm-rev", hp->hm_revision);
> > 
> > Is this intentional?
> > 
> > Likewise, for sbus (which implies SPARC) the logic was something like:
> > 
> > 	/* in happy_meal_sbus_probe_one() */
> > 	hp->hm_revision = of_getintprop_default(dp, "hm-rev", 0xff);
> > 	if (hp->hm_revision == 0xff)
> > 		 hp->hm_revision = 0xa0;
> > 
> > And now goes something like this:
> > 
> > 	/* in happy_meal_pci_probe() */
> > 	hp->hm_revision = 0xa0;
> > 	/* in happy_meal_common_probe() */
> > 	hp->hm_revision = of_getintprop_default(dp, "hm-rev", hp->hm_revision);
> 
> Yes, this is intentional. Logically, they are the same; we just set up the default
> before calling of_getintprop_default instead of after.

Thanks, I see that now :)

And I have no further questions about this patch.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
