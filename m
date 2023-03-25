Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3D236C8C81
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 09:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbjCYIRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 04:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjCYIRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 04:17:49 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on20708.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::708])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188CC11152;
        Sat, 25 Mar 2023 01:17:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k1It4l2UxxSKKwQOrrQGlnq3H8KeXqoYukBuQDspHDWAU/6DIrS4u3EdqEq4hGYbJjC17s8hKbTDogE1Eb1MPE/93A2k//QoNu0Vt5DJV44EzfztR1rbjU6Wxtrp+o9sg3iqFA/SuyOVaoyfSepKEqp62C5PAGpqMiGfumy6PP1PmLSx0HL50BMElH69x+UrYtXlDT+nucwubDLDzBUWtlWfunm4+SnvPwZz4XJyxAv8U1JWXKYwbudKbz6H0siTOt47SQ2QWAuAY8l695MB/UL7H5rHyWWKV5v3xpaja1n9dc2Vf3ANx+HQFLC9+x7dU8DB19xKE/dqXp0ks1sJcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fki+czBDrXWUJYYiN0OAApFJ8OBc/xIcCXTlRsh/HIA=;
 b=d5Bc3oNIVys+YYiaih9Cqw+0xj0Mc74cJ8EsOUAuV3mJlep8Mcg5CfqzO+JpsjJw3QQdtKHQ5io1gIlXWuYE0mYcCIJrTY8fUXvhF+H6cl8373tiFE89X4N6zOt0J5k6V5NW5RwhVGE5gKKUSC2+5xDN1sM6+Q9/lfkVDXrzp3paqDWrwBlON1EhB8lrnGkfLBrL0o3/+3gJlrNoxS5Gy8NG3yMDhTJ7AQ9v5LKzjPHHxKQ5Rrcp+SFdiBFCRTnwAC6jbC5KfXzgEjGMkYQYuh4VQHRHVKknWJblq8b9kHfrPZ9bh9khDlNRB1nsAqoecIBrKZXiWdJObFgyhw3DDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fki+czBDrXWUJYYiN0OAApFJ8OBc/xIcCXTlRsh/HIA=;
 b=AZBe7Vs/6JPNFrIEzXjVe1qkfnfazQyjxz8khFJamgAdLNybP71rIZP+uxPo4vXQIi6Xdwra1t44UG3BwG7ViVlcMGi+YivjMjoULqO8uiyc05j2KM9tuUCuJpHD48ykd2GYuDgr1VIQyxMlnFsqeCsF1DdnBzpeTTF4ElqkSRU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3944.namprd13.prod.outlook.com (2603:10b6:208:267::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Sat, 25 Mar
 2023 08:17:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.041; Sat, 25 Mar 2023
 08:17:10 +0000
Date:   Sat, 25 Mar 2023 09:17:03 +0100
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
Message-ID: <ZB6t/64NoGejdxUG@corigine.com>
References: <20230324175136.321588-1-seanga2@gmail.com>
 <20230324175136.321588-2-seanga2@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324175136.321588-2-seanga2@gmail.com>
X-ClientProxiedBy: AM9P192CA0006.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3944:EE_
X-MS-Office365-Filtering-Correlation-Id: 10c178d3-d36b-4d82-685d-08db2d095483
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YfwsxPwYAGdZ04LLizCkWI8jrGFv9A+HPNgza44MJkeJXKFmpdGcIRUV5pUd97Zupm1xwK0yTZokyyEcVnb+z79tJugXA9Pt1E337N0/VVoIzopyVtEkBzMOk8ceoP4ektNDjD883yVuYp9SOjS6Q1MGOwGHnVwEmmC+t76F3ulPdU1MnA2YfRrThwtaYYZ7yHhEkXvil0XkzB4swdqn84RcG67SReuaTdKjJ7tnCw0IjYKQwQPjR7hQWuU8OTxsWXo8K7SLojqfDpaPDjDuFX5z8n+Riyvf3UYssbKt/LQmkGAJKvcYnVu8sv9NNzhN2D8AWyHtexIboteMn9qP6WXMDRI3RjMLuJndYwN7lBgidc4LumdCxm8fszQoKaJ/O58tG1xQYnX0BVWEovH7theLA4IIpmldSYPJyvHVc6eo7N4i5CrEl6jt8+UBOHWjeaJ8bQxHpZK0yXe5yoTipKl+kyKGLzVt+uEsUi4/IFm4GBVwt4ZJcBT/sA3xefmcmN5qRx82vqJH9Wxs0o/wXJApYcT0ztvGs0B7FcAfo1FgkMKfMlG/xSC1JxwfJY8XmMtD+oQWrmH/kaPY9sAGtw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(346002)(376002)(396003)(39840400004)(451199021)(5660300002)(8936002)(41300700001)(2616005)(86362001)(44832011)(2906002)(83380400001)(66556008)(8676002)(6512007)(966005)(38100700002)(6666004)(36756003)(478600001)(66946007)(316002)(66476007)(6916009)(6486002)(4326008)(6506007)(54906003)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M43OOLVtVGHUkKryj8tV8hBvnwLUTQbofjCrf3B9Ps03afOo55t4e7SaobAJ?=
 =?us-ascii?Q?5ehOj5IzY0C2BvCyJbMcx8uq/Or0fNxm1rsHDSl0/5RMyugDl2pKRQHOuA47?=
 =?us-ascii?Q?FUFE5+B7rRnPS0qfi1bKQ2yqEabVYOPYwB6iXUDbk04/U6JMDWXPO+m/iBMp?=
 =?us-ascii?Q?NUCXmMqu5Js+p1i50p9GWp+XJ1hrtwkgWLj3664r3XBNBTpD/Fn6uv5L9t5N?=
 =?us-ascii?Q?7MhVifzwZnmhC8On2DoAp+ehdwoPujQwqKPbYBQffkflyObSdVHnhWE4JJpv?=
 =?us-ascii?Q?ZpM1OTAxf0lFieuRuYjchsIAfwWzq+riMvV6tIPVWJQ88ffhTfgjeISXyERh?=
 =?us-ascii?Q?XcpXud2oM2vFOnet1vREItekJyAAficXOqbfTB54i0L4aFPxvAxsGFKaBgWl?=
 =?us-ascii?Q?jeYNh+l6BqcosTtg58HdQtptM3WlSszU+mg087mKocQ8mFBpOepcT3iE/yi9?=
 =?us-ascii?Q?Tlsqq+yWpHana5wbA/8LLt5u1v2ZdsnuqipwBO7Gii6vPFjkbDoA7W05oxLB?=
 =?us-ascii?Q?M1y6xpl1+yk4Ry04zO2ML+kkPJHjYzk/jRq4rNuLIboCkhC99IQA2u4FEkMu?=
 =?us-ascii?Q?xuXKmF/yNV/o27lAaxVgXhV8N7/0LUnvazPQlTXpb0JAG49usQIdZuh6F2hQ?=
 =?us-ascii?Q?FRa5fAJ7VtOPwskvAg96/0o+cPBAjwl7N3DXVLmsKEBriEZXpuFjBCNdrqhr?=
 =?us-ascii?Q?2oSsvdvEuIEdDvd/lJz4PadAodS4uiYC60Mxr+5pLwMrUmyBXnAaVb6D+xOT?=
 =?us-ascii?Q?IBCgmMv89zaO88eao6gF1AD6rjK6oihlOilSrtLNhXUV7jJ7XEuaIh13TVrp?=
 =?us-ascii?Q?YmfkKM7Uk0V7z1F+V+9o2hKKZCO9liCOBGFR+NbYPDExn18yiB00s2L+En0W?=
 =?us-ascii?Q?NAk4pBOxMTZuFbyQ0u16mGfqo3aDTFOxNKFfLa+WCMB+1Iqcp2ctrtwCwT2F?=
 =?us-ascii?Q?5YPctChMYnaoS5U7RF0kDBEja9uIFh3XNFV5eF6pRpkMqwBjnzWgD8npUAIm?=
 =?us-ascii?Q?9izISPejd3IGxY7dZDcAk5oxXjIERsry6OdFRTSyLIlMgUrCMJ9d6nClZCWK?=
 =?us-ascii?Q?BFZXtur5Wle4aku2WO75TXzuEh+iUQVZ3+Hcf5odP/Y9r394md4mkjEZrT//?=
 =?us-ascii?Q?8ADHjgrSjkcROsPdcL9Brsxsgqpkn2sqjqT15FvL8QQoDPboM7xOH3HDmhLx?=
 =?us-ascii?Q?dkN6npS1IP6acaUsZMGauZYa0gPBQ1e5qx/mHZERvgyAjkci0S3ZsA3dWODH?=
 =?us-ascii?Q?Ex3OzLbd8jUo2NYJy8kSVBOrBWyzzpwTSViz9q8AVEuQOKb2O3FWb4aUMROj?=
 =?us-ascii?Q?NmwIh8X8xcQVW4IZQG2kxzUJjgsE90ELR4sZ7PGLsI7cb5DSgvRgvc0XK9yh?=
 =?us-ascii?Q?nf1uehAGuT4tyrEy/jz6ZOhfI5PHan1rMVygLemDppH9GR03fhL0Xl5ygJkp?=
 =?us-ascii?Q?ZrzyKFVBBe1eIxkdNtN2TBNJ5XClsT3kMOjzbgOIlAEg9QHN8tsf4A6/iO9z?=
 =?us-ascii?Q?7asxbvEnjMK4wIAMSGcc1uwDFMrPHlIU/mdZJNERV/vB1qXebIGv1zzmJ6Km?=
 =?us-ascii?Q?OYVCczS+V+1msC9pVWQKjBDQ5+hULn9miD/kbaKt7Ymb0dIzSreSue/6QzZg?=
 =?us-ascii?Q?FLR5ouR8vgSlwTAtzb2Mmkd3XfHj520OnyHBVg2y9LVXCUi0akpbmBmMTrpM?=
 =?us-ascii?Q?7mRS0g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10c178d3-d36b-4d82-685d-08db2d095483
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2023 08:17:10.2816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i2kREi2bcvy/8BlRplW7s5pRwco5B+o8n8cB21EWWjCaAZkO7FV7PgYjdWfpLHBkKgjnRuEOZcN4iOvxGs+w1YAm+QvhQw21Q0vgQ2YD6Rk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3944
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sean,

On Fri, Mar 24, 2023 at 01:51:27PM -0400, Sean Anderson wrote:
> Fix an uninitialized return code if we never found a qfe slot. It would be
> a bug if we ever got into this situation, but it's good to return something
> tracable.
> 
> Fixes: acb3f35f920b ("sunhme: forward the error code from pci_enable_device()")

I think it might be,

Fixes: 5b3dc6dda6b1 ("sunhme: Regularize probe errors")

> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <error27@gmail.com>

Checkpatch requests a Link tag after Reported-by tags.

Link: https://lore.kernel.org/oe-kbuild/20230222135715.hjXBN9H5dr7nCnI_Ye2s5H--HsnWom4o9AMScThhDRM@z/T/

> Signed-off-by: Sean Anderson <seanga2@gmail.com>
> ---
> 
> Changes in v4:
> - Move this fix to its own commit
> 
>  drivers/net/ethernet/sun/sunhme.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
> index b0c7ab74a82e..7cf8210ebbec 100644
> --- a/drivers/net/ethernet/sun/sunhme.c
> +++ b/drivers/net/ethernet/sun/sunhme.c
> @@ -2834,7 +2834,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
>  	int i, qfe_slot = -1;
>  	char prom_name[64];
>  	u8 addr[ETH_ALEN];
> -	int err;
> +	int err = -ENODEV;
>  
>  	/* Now make sure pci_dev cookie is there. */
>  #ifdef CONFIG_SPARC

Unfortunately I don't think this is the right fix,
and indeed smatch still complains with it applied.

The reason is that a few lines further down there is:

        err = pcim_enable_device(pdev);
        if (err)
                goto err_out;

Which overrides the initialisation of err.
Before getting to the line that smatch highlights, correctly as far
as I can tell, as having a missing error code.

			if (qfe_slot == 4)
				goto err_out;

As err_out simply calls 'return err' one could just return here.
And perhaps that is a nice cleanup to roll out at some point.
But to be in keeping with the style of the function, as a minimal fix,
I think the following might be appropriate.

Note, with this applied err doesn't need to be initialised at the top of
the function (as far as my invocation of smatch is concerned).

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index b0c7ab74a82e..d6df778a0052 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2863,8 +2863,10 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 			if (!qp->happy_meals[qfe_slot])
 				break;
 
-		if (qfe_slot == 4)
+		if (qfe_slot == 4) {
+			err = -ENODEV;
 			goto err_out;
+		}
 	}
 
 	dev = devm_alloc_etherdev(&pdev->dev, sizeof(struct happy_meal));
