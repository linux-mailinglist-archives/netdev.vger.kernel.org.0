Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0726B9ACA
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjCNQNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbjCNQNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:13:35 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2110.outbound.protection.outlook.com [40.107.93.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2E97C941;
        Tue, 14 Mar 2023 09:13:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lHDDc60G8M9QuNXgtm44m+Epde1uWdTQNuujiz/9hTfTJrm9+yacj9pARBF2y4uJfqNReNN3QjgZylpdbgZgtyDgY/7w3Xbq2av1wucOPvQs1zvYINiuGO9PWjfgzi3bahmjD6MErNgGOGnS13cdH06DxpWtEpv0aMQzaWuOEI5RSHvkvTBgg9xerbwuMF8HdWG3mQQUSsI+CZe7HVWsY7Rp61UT4JVLxtSI7sC10nGfGJQ/72bDfyWfUz1IOonl+ym4GpAH3+VTzIWcogF1xiSofxeR47+QAPRrh490uV4r2ogkYp7ZodKs+L+sphXvOScCQXnSKz8oNKdeJjLbgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oh9Bd3BtP1etpEwzyIZeWczI4CnTw4cXnwHjyatZmhQ=;
 b=C07XyI8WbUPL7KjuBDI1lRCt1QCveDuOid3ziQab/B1u29TnxeotamGPookPPa699jjckyZndvj4fASYoEWPx/H7/YBIg5BlkqdIgS7JOWV78A28yRcucrqXZWJfHGHvx9Q9+580Dz49AvjRJxfn72vPXJ/Z3B3Dzih0ZvvfTQffpet0aCxyRQA0TCR05bbL2TMtAtLGFuiAjqFfA6xNEuzevQpZZfpJcuv/SYVfMP5Fa9g0cIJIDy1FcX1VxxQ2kGzGpqfzr/86NDodPk3+Qf7j1tfVJKYYzwbm2dmrzNwVk07aatWf902lQgt8RoeVTyp3vy+2msE+onLTgEwGvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oh9Bd3BtP1etpEwzyIZeWczI4CnTw4cXnwHjyatZmhQ=;
 b=E6rdKQeNtCkUJF0v4vDXZ8qLaIIi52QiMwFTvfRnHRtZFtq8fWlQpn3ypf1+dhnznggGWHhflNLZv8dSWLJptsLaSSTNd3Ogp/ndwz7QLnelXt1KTEwGJtcP3VcgYyPFr+8/9ZaqqzBtVu4KbU4HMwvR77oENSfh3i89lVVOLIQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5365.namprd13.prod.outlook.com (2603:10b6:a03:3df::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 16:13:20 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 16:13:20 +0000
Date:   Tue, 14 Mar 2023 17:13:06 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] dt-bindings: can: tcan4x5x: Add tcan4552 and
 tcan4553 variants
Message-ID: <ZBCdEr/W6ZHjqTEq@corigine.com>
References: <20230314151201.2317134-1-msp@baylibre.com>
 <20230314151201.2317134-2-msp@baylibre.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314151201.2317134-2-msp@baylibre.com>
X-ClientProxiedBy: AM0PR06CA0109.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5365:EE_
X-MS-Office365-Filtering-Correlation-Id: e01a35f8-08d7-4bfb-b7a0-08db24a7071d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eYnOVF8MQfwntspimEg3fd0mRiX6BpxMWMdNrvs3BIkZJHo3+2aSZqPMkCc5+CDXQlEaxqL5j7Q1pCJha6C0xRpDZzXNYjEc4OkmVJxwH12mJgwVaRypRbSd5KKndzTzWSFx0/uhaPCfP3VTIrt0OHfjk9SYwWgGfQXKoXe+BoEQQuYnD6Xbup9esjGEe0eoKUSB4kGWCwI2hMe9SeLXPDihlq3VLSY770JFX2oea7AUaocUnNz9yrxhhZkVEb8Pdx3i/Np/3oH163TpDOGZQMU1OT6gLxNsm8s9ynnNt3iK1DPk4uXJlMVGllWdMADTS3pV9IPYBvOlMUdVa7KqyD0IWJPBV+VuTxYGKdPuVgHtulDNIrqDg2inGPp8OAv3cm5Oy2BbUdLPBdfrlyKFztZA1MDD56Jic/vkAWWrfEs/vGXI3EQZE07IDLZYnStsljGNzqHfa/4r7XCBtq+QfDGExyTuk+G/uIJZb709MohLUWFhzJ0pOtSSKd1wNwkOKu751e2TdW3CS1ofoqYXK5v5q0FEim2jqsUYuaRZw3B06j/rfZLoWaf+RLGNkoK51RrnBgD0ZAX2KelwRNHCX1wQ8demYwkSjwRbJZJ6SjkeaAL2qIRhTbXrZAB753VK+pjweOM1soyx+TpRZHXj2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(396003)(376002)(136003)(39840400004)(451199018)(2906002)(41300700001)(83380400001)(7416002)(36756003)(5660300002)(44832011)(8676002)(8936002)(66946007)(4326008)(6916009)(316002)(38100700002)(54906003)(86362001)(66476007)(478600001)(66556008)(2616005)(6486002)(186003)(6666004)(6506007)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w/OtrKptWW78mWcvTYy2W5NUCt7hd82SSMNNPt9ThAeV6Vdyjlp/pBjIONuU?=
 =?us-ascii?Q?UbLj7wFKGOhg9wrOYZ42LSC0V5dNIY+lI0VXG4xc9w08Xc504u3+tQq70st5?=
 =?us-ascii?Q?/+JkmpVCy2wrdS7TL9zegbFJobI7kyaqshsb38ldMMwmLSAYKA4M1uNg8VBf?=
 =?us-ascii?Q?z3aae14llox3emb5oe1dr2I+WRskaemHR82K84QtRfrAJF/xvmad3z3g4qAG?=
 =?us-ascii?Q?XkHoXHpwZhCxXp3Trz+mb/3f7YZJcfJb/oX8QVom19nNBkE16yCCEIRDWFpc?=
 =?us-ascii?Q?5VoTVTeN/R73gfUyQuPSQvJaIuGkaKaUcXylElII2kQ3L4m4pmm9/c5TuxNv?=
 =?us-ascii?Q?zo5MYhBNnwAbimTTLZ5Vid7P9GasVPRq5JIZUlZwQrru9UkNd4ivYnRzEdp1?=
 =?us-ascii?Q?yYeMgZJ4eo8cOlqXsYgLCHBZSg+FlwK5AHEpRlD/0Wq2vnfclg5JZErvbaJd?=
 =?us-ascii?Q?SwFUdI4ws4nsRpJNftWbKAfap5/JEbeSG2PSgJhDMnc2tZXv29DpYKp4PGbe?=
 =?us-ascii?Q?qr3cui+GkO0tn+jt53P67KsrSLlhucULHXp2pTpJp5p6PoRd1sjfmr+dSZgY?=
 =?us-ascii?Q?8qoRQwsD+oeXacPUsqNIkDg79oDkghGfWpN4SKWhAGiyjXQ5HDSShv9qVkr2?=
 =?us-ascii?Q?nuzo4WZoR6URDIegtjiVLaO8dBs16QNilyJ1/zyJtXhAwqIJtqySTmMbcXYB?=
 =?us-ascii?Q?eGUZHQzmur9VyAn+0yQjl3StwTftZ7gnOeTslH4nRK40JF0bePlfL5jRgvb+?=
 =?us-ascii?Q?0/rQ2JCb4VZ6JqDmSgj8Z36xJjTYmY1fdFsajn5YzIRIU/agRCjAS5DbC9RL?=
 =?us-ascii?Q?pKv5JvsRM3ZqXFBN450Xqm4d8/BdoWxlAzMsxnNzSS3clqUjAZq7pPCJjhnG?=
 =?us-ascii?Q?JLgc4c0KoaatheX2m5hzARN0qUFE80dPQDoTHT5fxHQu1XpfhGVIa3dW9GvB?=
 =?us-ascii?Q?flckv20p5EVCK8CeffcNEcUkFEShNLgIw7aV3A5Vx1Jw24ytUoFAFxCGsYhE?=
 =?us-ascii?Q?ZmXm8vTSTjvrM8iGlkxbTzaEC4zfNmiVq2FYA1ofv3gv1+x5IaLB8i3EG8C4?=
 =?us-ascii?Q?gmL7qxKpTpdomahjvZmgE2l/otBWk3xOtrJn4NSyl7tvMJ/3AXRqgLaKepVi?=
 =?us-ascii?Q?NCmCnjSCeAyPetyz1KynAhDRxn0SyOYbJSfBEbgID+32uB0SYJBgLziBCQj5?=
 =?us-ascii?Q?rFhnjhnG3S0daa7+c1GhU74zDHKuTHX9H+nBj+h3VJ6K8NiI9MPeMSZh+K/j?=
 =?us-ascii?Q?t4H9dduiWmCjhiooFqs8pogMVOYzNg5cy1vu70oivv0F8Iw0F3mrEWLfEJPf?=
 =?us-ascii?Q?OP6jB+amhqA2VEpmCEhfBlCTur+9371PIMzB8G/OSa85+xCogmw2D/gaGyMh?=
 =?us-ascii?Q?YQgs4AoahkTjdlPUOL1NbOOQYLHmjHO5iZJnjiQKaBk+KxqQPtuQPDCrLJqI?=
 =?us-ascii?Q?UmAQTUKh6QIjsu5KivpnFF2+UORbzQZmoV2qkh8N1Hw40+LsVR2am5hIjPta?=
 =?us-ascii?Q?16jlhO+2KtA0lDuSFY8h5L4BCwQbvbdRzS4bXmx/a36OM1zlbZDAoaQ6EIVX?=
 =?us-ascii?Q?ON5x8D4+eH1cfmv0OT4jkv6T1dKrDKSyT439zWWt2wC2NSLfjeBkaxXRR1vi?=
 =?us-ascii?Q?2ZRqXAniGOg7p+6HVZ57Phqu8IA6aZYCqEGiEVfheI65lBkNedoBi5FwgYeh?=
 =?us-ascii?Q?3aeBLA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e01a35f8-08d7-4bfb-b7a0-08db24a7071d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 16:13:20.2458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FN99tpUe5EwqOUF4Vy/9RwgmwejHYrNuqvfLqA2kgyTF4QfTiPx85bNTulyF0qE7wr/HgSIv4QbRKR5H0HvEO3d5GstIDLpiKLHZCl0m370=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5365
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 04:11:57PM +0100, Markus Schneider-Pargmann wrote:
> These two new chips do not have state or wake pins.
> 
> Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>

Not a requirement from my side,
but perhaps it would be worth converting this binding to yaml
at some point.

> ---
>  .../devicetree/bindings/net/can/tcan4x5x.txt          | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/can/tcan4x5x.txt b/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
> index e3501bfa22e9..38a2b5369b44 100644
> --- a/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
> +++ b/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
> @@ -4,7 +4,10 @@ Texas Instruments TCAN4x5x CAN Controller
>  This file provides device node information for the TCAN4x5x interface contains.
>  
>  Required properties:
> -	- compatible: "ti,tcan4x5x"
> +	- compatible:
> +		"ti,tcan4x5x" or
> +		"ti,tcan4552" or
> +		"ti,tcan4553"
>  	- reg: 0
>  	- #address-cells: 1
>  	- #size-cells: 0
> @@ -21,8 +24,10 @@ Optional properties:
>  	- reset-gpios: Hardwired output GPIO. If not defined then software
>  		       reset.
>  	- device-state-gpios: Input GPIO that indicates if the device is in
> -			      a sleep state or if the device is active.
> -	- device-wake-gpios: Wake up GPIO to wake up the TCAN device.
> +			      a sleep state or if the device is active. Not
> +			      available with tcan4552/4553.
> +	- device-wake-gpios: Wake up GPIO to wake up the TCAN device. Not
> +			     available with tcan4552/4553.
>  
>  Example:
>  tcan4x5x: tcan4x5x@0 {
> -- 
> 2.39.2
> 
