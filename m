Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95AF86C8C9B
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 09:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbjCYI0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 04:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbjCYI0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 04:26:42 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2131.outbound.protection.outlook.com [40.107.95.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48EEDDBF4;
        Sat, 25 Mar 2023 01:26:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZS9+gBPy7UrlqYPfQXqNFKYxd2gn5E0CNX24oHa9riZWd7QZCrmcxqCmN3HGsdSrl0flQs+x+lORp+I+xuBN2mORkNQTm5bZUO7h50AMygbr+9dH9unE+SOgpaL1XXLfGt6Z0g29vdB41cRb1GfvHYVVSELQMoT6qbBQHRDk43vnpn0d7VfhQzAkd3EU/SOTVFOFQEhePFtaBDzkg/62iWoRBbdLKQ7vgviqzWh4+r0nfuIFp7ZVe8DJRrxeNFQGfsIUfsuD4Mefd2JrLIIrm3OJLx0yenTW0/86KACp7ZXb2ITXN/97jNjax0ZufxYrUThwkGeR6wzDOPDnyAAccQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J2AXC6ep3Mut8VNO5W2ceoPXK6rkaxE+J5EN1P6Rdd8=;
 b=BoX4h+GnaJv3PIpo5sCFu3W/rg4eHtbKB6aofEUVuyJgaYFpFQxd+xIZ3f0CTvN6DJwPhymY4zL+XeCQJO3P64c7daj1dpl95GZ+cBOTFp0wVOZvExLOOs+ls8Q8uEJEXw/igo5jcHkDZdhAzypbqgNnPNiRyAY21E9k2+zU/WtyEXlaomJElXr5hKyRTZRk3YIg59k46MGnOm+1nK+kIC6P5I8xFiry0Z7aXRV6aARmn3pEh9MRtwBBC5PpyN+eaFC2bwTXEfP+rMmfwTwuWUI3H7QVWhloKQF9STBnBTFtaT4yTpPgRDp3ChbUkLIISm5y36zdFQPCkStONI7DAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J2AXC6ep3Mut8VNO5W2ceoPXK6rkaxE+J5EN1P6Rdd8=;
 b=Gj4ZghNaZ+/NbszvoHwHTm9tVZzzpYNEuATKL+b29+ya7csw5QsKIKBm14SwkWMmQwvBehvLvhS/dJ6E54oJ3l/DVL95KCb4Q7osCSWkDcHUBmWGYk45+vy2aW40qUUUbpcQ1u+/oBSI9DDxMi/2z/quy49HXLDkHbz9MSNqBDg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM4PR13MB5834.namprd13.prod.outlook.com (2603:10b6:8:41::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.41; Sat, 25 Mar 2023 08:26:38 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.041; Sat, 25 Mar 2023
 08:26:38 +0000
Date:   Sat, 25 Mar 2023 09:26:31 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH net-next v4 01/10] net: sunhme: Fix uninitialized return
 code
Message-ID: <ZB6wNwHr3hViHC2O@corigine.com>
References: <20230324175136.321588-1-seanga2@gmail.com>
 <20230324175136.321588-2-seanga2@gmail.com>
 <ZB6t/64NoGejdxUG@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZB6t/64NoGejdxUG@corigine.com>
X-ClientProxiedBy: AM9P195CA0005.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM4PR13MB5834:EE_
X-MS-Office365-Filtering-Correlation-Id: 3710f2dd-bb93-4b58-2618-08db2d0aa738
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bUN3+odeOozRESBGO9ryTGQzW+MKjvW1w4T6tifk2oir11glRh2Mhtn9tzLbU30JPYakB3gYpeGDAb71tYinsG09ci0MdLMl3cd1IM21ftcpCGh9eaNchNW+ualCdAm9M6/BGHqjdqy6vHuawZKeZamySmFGduJIgXYcNZq6XQdDS30O6jzUg44u7/iklmwPwKuMU0MniH7YKITQpMbSkyjhKFeAqYkTtXZxvByaDR/rwcvuLCA2O5Ctx1gNG0+W8DLsOowovnFM+jGax5KqdrYuYnk90bGPCvV6os4A6zOpDkdQcXKzOupqS2Q8Fl6YgfMIQksSssSMezDJu1kbL3BHvTVhnOPDSxugUCEox83oLrgVX1RgSfYRiqBArusuYVx5i9XjZV8bR1OMoGjkRQmKPU+7s3Y9MCTSOFSCr27zvpxoNlAY5sixV127/ddt5sExWJeD0mrS0iwA0ngH+vflb7RNaQnttrrhydpCaIhm9ZhcAxy6tofPwfPxY8ks2Tc1tWO+gTnW5/IZja2jbiADuokokhx+nf7arUhe7Nk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39840400004)(376002)(136003)(346002)(396003)(451199021)(8676002)(6916009)(4326008)(83380400001)(2906002)(6486002)(66476007)(66556008)(44832011)(66946007)(186003)(6506007)(6512007)(5660300002)(86362001)(966005)(316002)(41300700001)(8936002)(54906003)(6666004)(38100700002)(478600001)(36756003)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yZDv4RWEtQL+EEQnZ+EQsdOACXrdpAaKSctbOJXj1077/jYlbfLfbVjjRsti?=
 =?us-ascii?Q?tL3HJxQo5aMAXv5En3Q+wV/j1bVlFvHemyoT9W2jH/alVeVQVSsduInN93j+?=
 =?us-ascii?Q?1mcMBOHa9VLj9cOiSmWceEni7i6cOa9AWC8DJ4Qsnpz+XrNFBmCjirXb9zIC?=
 =?us-ascii?Q?Tu+749vkurnnemDnYr59B/H2fc49TPjdNvtuwr8k/d6yrTofBgHjnazrdOsW?=
 =?us-ascii?Q?KRc5OTBOZnSiZLOCNszV5/rHseeKex/blRDmxWEeNKdB08kMOqe7HtymfW1J?=
 =?us-ascii?Q?hHJRrTTuMo6a8yjLnQLRcta/499yqtlD6J04nJyHNf/XlpeJy0TyAficdvhx?=
 =?us-ascii?Q?J2GM1gBN3CsSZN0rSANZZJXAZPqbGm2xtNarHDXSZ9ixAgqLDJHMIW/C9/xw?=
 =?us-ascii?Q?psGhFVmYDTKEgLSaFwUUs3ECc2IEVoi3RAX/ZQ5hEVAUcfqEG7tdiCS4iOoE?=
 =?us-ascii?Q?cAIzqwDUa2Iee+MasUJj6n7rVd62+q+Z1ejyevB9s9+4iNiAsi98qHbj1BV+?=
 =?us-ascii?Q?JU571qYB661iETBE3kME0zRc6VgiokChzRXRW7uzNDpeI3p3YIs6i//5YErn?=
 =?us-ascii?Q?EenHe3L2LWLzoLg8W5s7i2Aa51ZCAVr+JI1X7ZDcTZHF/wi8onjLoAveVpoR?=
 =?us-ascii?Q?QbtK7k3jm5hpGkPgheJO+GHExelaIUSJvCj18WLudRMT9OwYuC0cxLx6A7Uu?=
 =?us-ascii?Q?EAAxX+qdCI1m68pnf1mADGCusv4qALR2v4Pa0h29e+6x32YrAKaA+N/dNxcG?=
 =?us-ascii?Q?TUP8BRx8E5HNk194Oh4WC3X6RuFCaP2/Gp8rjajFR3cPKQKSOjybZ6NRSF3Z?=
 =?us-ascii?Q?K9crqDImjrXmb8kjTB8AQ9WJxpw/JO+2R7k9ssdJWsWh69Z571rXB26Na4jY?=
 =?us-ascii?Q?nYJdCCjlWN029t6Wdg6vM2ZSE6WPyjQnxzcn3hZ7QdbhbA2STqMH4liSwys2?=
 =?us-ascii?Q?oe1cfvee2w0KiPPGE1R1cq1vRPv0kmI90aASVTNrqexVhha74G1xjXZMDcoU?=
 =?us-ascii?Q?DSF57ZHLd5KgLTQYC4zHZDD/Xk/nfgETG8t7r2CXdzvkqO0JOXy/xhOGPB8z?=
 =?us-ascii?Q?Jibv2iev2Q+ufPB8wxLVn8SLIKqNkGu4cp5b2Gs9GotY5XRja3fDMqNp2+aC?=
 =?us-ascii?Q?FVdZvI9Utjrjc8GiWpnFE+z73+YxiHfBMXqSgzK0E6Way0GUWcA84p4gmOt2?=
 =?us-ascii?Q?e+T6Lr5lMzOnd5QI0E1jhZRV6q+aVhLHwGRZLXX4ewQ73mC0bREeeXe+L9RD?=
 =?us-ascii?Q?+bk9oYLhFNkm+imJOsi+SdDyX2SFxhzOsQfx7XqwszSsdezdlsANxCOEmCQP?=
 =?us-ascii?Q?bRo3rmUQBpC8oeKK2cTOA+11dnK0zwpHI3mCkW44PrJMuHq5UI63fQsJR7Qn?=
 =?us-ascii?Q?aWTACXqKnAxWOsGAFkHJ5i1EvAXqeg5Q0KnWaKY/tDG9aJ0GcLruQfn4fyos?=
 =?us-ascii?Q?VRbUf8ITlq7g5fHjHlx4CQHqE5lA21Rc5/p+eFGB8fjoDLMLAvTNeb7/egzW?=
 =?us-ascii?Q?uMRDCa9meZqDQ2pmunMC5Ac5iYzNxm8D6tyE/3nUPw88cTKZH7hp08BHh7Vk?=
 =?us-ascii?Q?NvKIJv3U47I9Uo9qsdZ54NENb6yj4rJZkI6BM4qkF6x6bQvHmLIGaGH6zdwN?=
 =?us-ascii?Q?bIIPsoyCIfi+2FTTPyLbtGK4MHjShOTp/FH5SDtRfRUDi7HufAOjxCChi861?=
 =?us-ascii?Q?vd8wiw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3710f2dd-bb93-4b58-2618-08db2d0aa738
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2023 08:26:38.4423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0FXSkFGTRKRyrsjmTLcW/ynUdbCiazp6DwuKxilDpiUkdhrL3skUcrCMn3o6juYFzvezF6qsdmBj5P6t7pK7MENWROGUrJ1pCyuKp7d//Y0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR13MB5834
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 25, 2023 at 09:17:03AM +0100, Simon Horman wrote:
> Hi Sean,
> 
> On Fri, Mar 24, 2023 at 01:51:27PM -0400, Sean Anderson wrote:
> > Fix an uninitialized return code if we never found a qfe slot. It would be
> > a bug if we ever got into this situation, but it's good to return something
> > tracable.
> > 
> > Fixes: acb3f35f920b ("sunhme: forward the error code from pci_enable_device()")
> 
> I think it might be,
> 
> Fixes: 5b3dc6dda6b1 ("sunhme: Regularize probe errors")
> 
> > Reported-by: kernel test robot <lkp@intel.com>
> > Reported-by: Dan Carpenter <error27@gmail.com>
> 
> Checkpatch requests a Link tag after Reported-by tags.
> 
> Link: https://lore.kernel.org/oe-kbuild/20230222135715.hjXBN9H5dr7nCnI_Ye2s5H--HsnWom4o9AMScThhDRM@z/T/
> 
> > Signed-off-by: Sean Anderson <seanga2@gmail.com>
> > ---
> > 
> > Changes in v4:
> > - Move this fix to its own commit
> > 
> >  drivers/net/ethernet/sun/sunhme.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
> > index b0c7ab74a82e..7cf8210ebbec 100644
> > --- a/drivers/net/ethernet/sun/sunhme.c
> > +++ b/drivers/net/ethernet/sun/sunhme.c
> > @@ -2834,7 +2834,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
> >  	int i, qfe_slot = -1;
> >  	char prom_name[64];
> >  	u8 addr[ETH_ALEN];
> > -	int err;
> > +	int err = -ENODEV;
> >  
> >  	/* Now make sure pci_dev cookie is there. */
> >  #ifdef CONFIG_SPARC
> 
> Unfortunately I don't think this is the right fix,
> and indeed smatch still complains with it applied.
> 
> The reason is that a few lines further down there is:
> 
>         err = pcim_enable_device(pdev);
>         if (err)
>                 goto err_out;
> 
> Which overrides the initialisation of err.
> Before getting to the line that smatch highlights, correctly as far
> as I can tell, as having a missing error code.
> 
> 			if (qfe_slot == 4)
> 				goto err_out;
> 
> As err_out simply calls 'return err' one could just return here.
> And perhaps that is a nice cleanup to roll out at some point.

I see that point is patch 9/10, which also fixes the bug
reported by smatch :)

> But to be in keeping with the style of the function, as a minimal fix,
> I think the following might be appropriate.
> 
> Note, with this applied err doesn't need to be initialised at the top of
> the function (as far as my invocation of smatch is concerned).
> 
> diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
> index b0c7ab74a82e..d6df778a0052 100644
> --- a/drivers/net/ethernet/sun/sunhme.c
> +++ b/drivers/net/ethernet/sun/sunhme.c
> @@ -2863,8 +2863,10 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
>  			if (!qp->happy_meals[qfe_slot])
>  				break;
>  
> -		if (qfe_slot == 4)
> +		if (qfe_slot == 4) {
> +			err = -ENODEV;
>  			goto err_out;
> +		}
>  	}
>  
>  	dev = devm_alloc_etherdev(&pdev->dev, sizeof(struct happy_meal));
> 
