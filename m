Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C732E69FD4B
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 22:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbjBVVAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 16:00:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbjBVVAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 16:00:01 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2128.outbound.protection.outlook.com [40.107.93.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1EC538E88;
        Wed, 22 Feb 2023 12:59:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SNiYzPxg3q9ey6ft6ISgYf+Wlx7o3Cc16cJ4u5pIaU+b+WVQ9ysvF4UCb34ZZTBv5NYYM7XUnOFSOCYlDHGSSPr0+ExhRR5PRJN0Ouhs/CCPfVSve01ANdM7RXP0dROfVBc32jr5AdPzU6vPEZaww7PQRQE5bPZIcIsIL+4F26PGg55nXy+uyz45oPBdzLvjUED0ilDGB2p4igivgKzETA3NKaaPRQDwYqiTU+TtJ1EfVTga8s9fAufzwtsrSYaT9fZxbwihYlaYil9dAmUJPzhydF9KydELsA6dOnYJMXIBhIli8MvTYYnW7leZP3NB1Di9ibgpQeg3xOsPCV5stg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tnsLNlxMkSrvUCDRFWp/yBht9nCped62TXcZxjBAvNs=;
 b=F866DFag6t0mb0umYPUYXzAn94g6Xfwv2d0ax1JFXexXrYR0DjHcil/fugAAMNAVW5HcfFO3LXwyyiz48ZdBvVfzTA34YTNW5wOVi9diHl0F0PheRDTfs9JbZFKYqDpYlkhGUiqVPHJx9TaY5rbA5KmfXlQHPBbY3RYG4JbcUYVsWOI1hfII+fTbKzRHekdZbzsyAfAox1wUoJczHZE8B2LPua43eIvRiSbnJlpqgjXY8c8w3zDx3fFJOP6yh8lOmwY5//LwCsJV+RExCpMjV4Ry2PYGgH4ZbctrCXd7G4nWLAIiYV1sKkZzQ8igGZVDNzcU8mOQYbJsLbfd/LXoAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tnsLNlxMkSrvUCDRFWp/yBht9nCped62TXcZxjBAvNs=;
 b=AEOcEUK1hnWsiYIbA2n8dfIhLRF8vJuw/n3Hr/TLpePTZUts9uUFYoQTc8f1CdW35QuUZtTAn41cGWs04uvc3lG1TFE/GRTDaPXC/xmzJzlY5ggtTrWFpXY84e8bS5CF2TYvDJhtO0TBth14th0ndtGMkvKd29DXiRJcUog3uJo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5880.namprd13.prod.outlook.com (2603:10b6:303:1cb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Wed, 22 Feb
 2023 20:59:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6134.019; Wed, 22 Feb 2023
 20:59:40 +0000
Date:   Wed, 22 Feb 2023 21:59:33 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH net] net: sunhme: Return an error when we are out of slots
Message-ID: <Y/aCNSlx2p62iDYk@corigine.com>
References: <20230222170935.1820939-1-seanga2@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230222170935.1820939-1-seanga2@gmail.com>
X-ClientProxiedBy: AM3PR04CA0145.eurprd04.prod.outlook.com (2603:10a6:207::29)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5880:EE_
X-MS-Office365-Filtering-Correlation-Id: 35488ab7-4008-4d8a-1511-08db1517b6be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MIXsBPIEiS8mfNPTj/rQF/8T+dgyNVXAIUxqaknsOvFTgijmOa6pjdmzepALzRTzyy+lekU5yHPssmSfyM/ctRnBYU8VsQcjT8wClGcF3NY37lS06pJOqA03BgWlttDHA1c31g13952E0DG3ONlP3wrM68PJUbYPUnBmWuzY/RjJ/PMh8MR4d45RrNprtcas8kpb/DsXmfUgD/iseN1vD53GXxWv/Q4pBSGWM4E6pgmbkKI8D/5JW5CfUCGo6f5Dy5+jkFleN7dnSIMzSTH4KjWaXM3rKt143N+FQoh8r7ote1D+3yFhrFzDWccGobpn4DV68s7N9c2Yz4xCN4/PHpb2mo+H+wvuiLumlr733rODQGWtl1TBeOj1mE9EGXy2XFx8wswAEpb3Uw0UiyX1igmlfNLTE5JEGfl8Iaik2DYFp7iGeU1kIE0LzN/RYEZMDwwcbwHa9xnK2Bv7K9glja2+UCFNB6LL1s/lPLec0wemDtLXP3E0vUoa59FDLICKU49Pv1xABU5iCqB7jVbqixRWtRwQ+gQ1aikXrb+7xY+C+hxWzSfdY49CiEDVJnlyHWg696D8c4zAVZYcuc3hEVl+dpTeNG9KvkgSQ803cbV/qeoM3XSdl0l6dzhkqTAl7qnqlASQaWhtKGnXQIX5yQTc+cv2WuBs87ip0l6uVOqqnzfltuQyO8gVCYVGa9X1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(366004)(376002)(136003)(346002)(396003)(451199018)(54906003)(316002)(41300700001)(5660300002)(44832011)(6486002)(478600001)(8936002)(7416002)(66476007)(8676002)(4326008)(66556008)(66946007)(86362001)(38100700002)(2906002)(6916009)(6506007)(6512007)(6666004)(2616005)(83380400001)(36756003)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+nxJsdJ0N/LfcKtC/ZUP8MtiAFpj8KAwrmtOw8jJZgq+C2t2EEpJEMa/KYm3?=
 =?us-ascii?Q?mh9LO+pTaP3AQEBH+SRpRCk0eAHmAhILUuv3ofsHmRwXniTx+NoFBUo/nrch?=
 =?us-ascii?Q?BYYX+N7c7EvNkRKiiQK43NQ+6VIZtajlcH7w9fgh/8+IAtsyW+ijJRQN1OuB?=
 =?us-ascii?Q?p5ealTR4/0I+b4xowvqPzKyucUh/iXNXHbdyWc8YKlfVzfBqfSIkJsKSIj60?=
 =?us-ascii?Q?moQ8asZp6GW3oVDxuGrbUXSgu8OmwXzSGdvLKMNuql4ejFvdSZIm7fo89+JZ?=
 =?us-ascii?Q?T5UEpvQxfmod4dQiWPY9/i14qU9dBZ3YE8np0ieMTCqJXlMRfLhH1XO2zAXi?=
 =?us-ascii?Q?s47zGxerevASqAKb+wJcFcL12ja7YyoJZOI4hv1TUYC+vX34nNo8w0MZ2fVt?=
 =?us-ascii?Q?WC0W3wxqTHfS5YwyAvr4OhRESRTdtrhgxwKFohx7doh2lMEiGIWRiqg41PCZ?=
 =?us-ascii?Q?ojSrdw/84CnrYYSv+prDr1qogFyEZSsyMcLLfHo8K/g47RambS1N2+409yrW?=
 =?us-ascii?Q?SREKFXF1FhDGbOL8aVfOpds1j4gWjviYn0+csvwWf5g+cEVGJkkN72+m/kNR?=
 =?us-ascii?Q?g/vmL4OHUi/VljYbzRhHgD2ewGwuqbKkgfipW2crVBrrby0vSdspX5zibTvs?=
 =?us-ascii?Q?YYjBKZTuH+ku72yBp9KkbHfUUl/9t64HCdUVxtcG3jA9onmYTrjE/ChR3vu1?=
 =?us-ascii?Q?U6mA/6mCHUcox6ZfDN8mbAWhcXIG37ehV/s7YOhEYlOA1q8f8wWif2OPWl6p?=
 =?us-ascii?Q?q+IbXf06LvNyDH66INfD/eNrXSTi7knPcYdQH7zQ0OEbzn9c9lA8aWdLzdfi?=
 =?us-ascii?Q?u3eDky5kaes4vfNSGFfHuRCd7RDgYZxMsQmwO9KAhSWvE/aqDv7rRHv5u6Xo?=
 =?us-ascii?Q?kWjArhqbdmxre73/f3hKK/QEcTPrEJzncuYOAq5Af2GMOJuQXdAUeLmc9bUu?=
 =?us-ascii?Q?kghrSRce4ztH6n1SqB7nd6U2BxHuuAE6GH9jAvcTYrRGCZcy0TzW7cBeqKEK?=
 =?us-ascii?Q?8Ge1YJe48Qns1OrbIkf0L9Uzt29uYzM1Re5U8MqSLVriVlAKoPQCSlmf/Pvn?=
 =?us-ascii?Q?BDvlxirWJAXTnhnGBSuavW9AbHVDEZnxgCG8lmITRc1WLi4NsFSndj+/Frrp?=
 =?us-ascii?Q?FcmBxpcPjKxvCttidhxDPjL2M3VfFtdOIOZMLNDTH/hQYkXSKmAlpIHo96GA?=
 =?us-ascii?Q?Wlm5TZOLIzv/pRGzqolhR+1y/xmGdW/xHsblpPJ2XVNgERDbc2BDdZeLHMZf?=
 =?us-ascii?Q?suqLGEHuhB341nLZqVi8fUwGb6SAVSZI5oEGhgfguzWvF4f5Et6n/SNwYTqo?=
 =?us-ascii?Q?GRuGCNPODqLQyk6RCj1iz4e/J04wHzZhr6HjyMijcDLNGQB4SPHpJiUlhFPt?=
 =?us-ascii?Q?45Sxf08L1xMqL6LxX0DLa4EDrDX4Z4tP6FKfHmC6GiqPbo0br7wdFh5S3Rz2?=
 =?us-ascii?Q?BxFkL80yPaqlIlx0r/oilmwgxDrgenEWdteot+rO64/INfrQKVZ/fLcXiKc3?=
 =?us-ascii?Q?rk0e2V/mEviIgEQso7iMQiybiPEq3lwEZCRiv51QGg4IrTE/5g2gan0Tz5ri?=
 =?us-ascii?Q?P5T5DKZ5zdveQDgdw7sSko8XuHS/BytRbjkh4OyMRvZHH4aWOo8hzHM0yTXT?=
 =?us-ascii?Q?t79Jp1M3/ZZRU/+vNr7MuFVln2upm0fHyw2UxHDLmm6e9P1w4ZN05sLa3itC?=
 =?us-ascii?Q?3so0CA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35488ab7-4008-4d8a-1511-08db1517b6be
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 20:59:40.1460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tWOExlagUCtt1r4CL15GSO+CU21lG673PKShKH7TsyIPaG2c8fk+0fcsY99307gxywlEp2YFZodRQ5AOfs8Lr2F2yJua48nUxTzVGA/4fWI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5880
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 12:09:35PM -0500, Sean Anderson wrote:
> We only allocate enough space for four devices when the parent is a QFE. If
> we couldn't find a spot (because five devices were created for whatever
> reason), we would not return an error from probe(). Return ENODEV, which
> was what we did before.
> 
> Fixes: 96c6e9faecf1 ("sunhme: forward the error code from pci_enable_device()")

I think the hash for that commit is acb3f35f920b.

However, I also think this problem was introduced by the first hunk of
5b3dc6dda6b1 ("sunhme: Regularize probe errors").

Which is:

--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2945,7 +2945,6 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	if (err)
 		goto err_out;
 	pci_set_master(pdev);
-	err = -ENODEV;
 
 	if (!strcmp(prom_name, "SUNW,qfe") || !strcmp(prom_name, "qfe")) {
 		qp = quattro_pci_find(pdev);


Which leads me to wonder if simpler fixes would be either:

1) Reverting the hunk above
2) Or, more in keeping with the rest of that patch,
   explicitly setting err before branching to err_out,
   as you your patch does, but without other logic changes.

   Something like this (*compile tested only!*:

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 1c16548415cd..2409e7d6c29e 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2863,8 +2863,10 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 			if (!qp->happy_meals[qfe_slot])
 				break;
 
-		if (qfe_slot == 4)
+		if (qfe_slot == 4) {
+			err = -ENOMEM;
 			goto err_out;
+		}
 	}
 
 	dev = devm_alloc_etherdev(&pdev->dev, sizeof(struct happy_meal));

Also, I am curious why happy_meal_pci_probe() doesn't just return instaed
of branching to err_out. As err_out only returns err.  I guess there is a
reason for it. But simply returning would probably simplify error handling.
(I'm not suggesting that approach for this fix.)

> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <error27@gmail.com>
> Signed-off-by: Sean Anderson <seanga2@gmail.com>
> ---
> 
>  drivers/net/ethernet/sun/sunhme.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
> index 1c16548415cd..523e26653ec8 100644
> --- a/drivers/net/ethernet/sun/sunhme.c
> +++ b/drivers/net/ethernet/sun/sunhme.c
> @@ -2861,12 +2861,13 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
>  
>  		for (qfe_slot = 0; qfe_slot < 4; qfe_slot++)
>  			if (!qp->happy_meals[qfe_slot])
> -				break;
> +				goto found_slot;
>  
> -		if (qfe_slot == 4)
> -			goto err_out;
> +		err = -ENODEV;
> +		goto err_out;
>  	}
>  
> +found_slot:
>  	dev = devm_alloc_etherdev(&pdev->dev, sizeof(struct happy_meal));
>  	if (!dev) {
>  		err = -ENOMEM;
> -- 
> 2.37.1
> 
