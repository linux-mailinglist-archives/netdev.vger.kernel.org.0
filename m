Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150746CDA2A
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 15:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbjC2NJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 09:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbjC2NI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 09:08:56 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2131.outbound.protection.outlook.com [40.107.223.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93E74C06
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 06:08:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G0PiNDFbCss9yYLJBeJDpkm4YVc3Hwt1nU2DhjRZncF9auZPEJQJy9ONl0u24t2NxX6GuA2D9Dpd3OVqdrRlVyzszXYkNISBG51h8qNHCp6KD01v8tTYnmp8/BH9tf76QhalomgabyZbdCAnTkHgpfNcKQ8gjxgm25LuQy3gOuc5T1VJ9wsTrotvoLVYcURoGfuxgvA6ayIuT9EUPegtGBAgrkneaW50yXGBgF6PkhHv1jkcwFtV6XV0lVa2PtA78F13+8KIhd1foqvnFxKBOHwUBtjWccRqVTN3y+nhrpFwjoQyoVMRuhAc2u7gnu8odft9P6erslfDKxo1KhE9ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JbmEMKbzU5XLYtkTddRZ/ghpNxHS0mIXWOojgH7wZis=;
 b=Ids9CJuH+JKEa9JNcxoaGI9KVwlmrP+eLfFcyAFJYLmVB2XiSvTfiUK/Hcalj8NJgv2gYMZ6Ecif4movxX24NC060l4OUGn/r1d6tBDrxT2pWH2z9rEQMWQ/RtVzpwlzF78x0fqOgdm1lxuOZBR4l8E9qgUqENhPBvjHiZIfArmM6F1UJ2vZV2ALESyVYDNaLCh/SBuFUTgKAgNAOUj0eynvu2x5+BFIKx1LcmKgJieCEERgqmBylJv0E7Q3Ag8J2RFIQEBukjqY01DCc13WI4m1ECQHqPmB8zDNzDQAhz3ml8HwOjfQhR70L4wtJ47oPDJs/bjStu1ze5KJaD2tjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JbmEMKbzU5XLYtkTddRZ/ghpNxHS0mIXWOojgH7wZis=;
 b=DkU4JWuGX5Je+fpy9Ep6giKa5Qck9/3Lt6Ezy/nxSVjGTUMIu9zV4IeOlMvPqRqJi5CwLbROWue+WVShGa84/pc2rFdhLDavXorNNN4SIFWifZNLKjeCzqR1pwb/liqQi2ezbHG07biGV9eB8tEXUlo56RUlnJz8muUUkj3xovc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4132.namprd13.prod.outlook.com (2603:10b6:5:2ad::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Wed, 29 Mar
 2023 13:08:51 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Wed, 29 Mar 2023
 13:08:50 +0000
Date:   Wed, 29 Mar 2023 15:08:44 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, gospo@broadcom.com,
        Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>
Subject: Re: [PATCH net 2/3] bnxt_en: Fix typo in PCI id to device
 description string mapping
Message-ID: <ZCQ4XCOmE24jod9X@corigine.com>
References: <20230329013021.5205-1-michael.chan@broadcom.com>
 <20230329013021.5205-3-michael.chan@broadcom.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329013021.5205-3-michael.chan@broadcom.com>
X-ClientProxiedBy: AM0PR01CA0125.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4132:EE_
X-MS-Office365-Filtering-Correlation-Id: b77706c7-a4ae-4bbf-5cd3-08db3056bd6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MnHUV07W4E+EB5+BKj0TGsG9AJfh7ahEiKFR1+WrV6b8s5r8lITPWjQsq83g6CB3g5Z7qo5K4mMuuR4JF2owErscXEp52ra0HvgvRZH8tAlSnmBNzf8WHxDSy8GFhHgT6KTrbWNwIdB3rW2GOAcITCt5uYCfJcrR6S52OjLwbbJviFD+x6zdmcWH01FOjaV8VUwJ9pnNff27twTCUwYu5xE8cARdPuGWvKh6taKSrNBYZTfsmNDeebkIhhq9Qp3bBgwgkr0PMXhRe9ff281sKtfgSK20VhxEuh7AlCrSFAj3AZn54Pqn0qNGCZHABHzSYEcbkk8eZYFlbX0aSh9mgzR2r+WoCqA56a3/0rFtLYY0/7zmD437VEnhxtRHhQU1NxNnBm1FaPTIKBRIoyX5hSEflcIXVSvcDTGQnwqBYXYTtS9wX18iWJMERmXzwQkctRh3woNVvRNLRnwVH/7qP12JkSTJhXWkb1N2yM8dxekwXEcJKCuIxY/XXdTDz+x7zGnDDbNai1hMYlnq8RDX1AgiAUVShYox3HqFkPlhopV0bauXfWbbLVGkreslCyJ12aa6hq1zs3hzsQiOy2tbGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(346002)(376002)(39840400004)(396003)(451199021)(6666004)(6506007)(6512007)(86362001)(8936002)(83380400001)(186003)(2616005)(6486002)(966005)(2906002)(38100700002)(44832011)(5660300002)(478600001)(4326008)(6916009)(41300700001)(66476007)(8676002)(316002)(66556008)(66946007)(36756003)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m4553juPkSfV/xAoKOlwelzsxftMYqenFYEOOGzPQQEtLnj+MZJhxat3OXfg?=
 =?us-ascii?Q?kreIu0h0RV4wOPh5kKMfYT5yCUUifbTNBZo4nfo6D82qzbBNiAdKPhVwMgy7?=
 =?us-ascii?Q?s+Szf+rvLdmm5NAKwEyVbk5BgN2TV2wDwQ8oxQ64WTvRxzKv6y0G70YwABQM?=
 =?us-ascii?Q?NMoH5jjry+t9cij3tCkX+7j94SwSgW49vypZQH0zqkZFL4IisQDKLsry6aAN?=
 =?us-ascii?Q?rpc27uslWmr8PHZcP9ju+4pC83eH0h08YvzPqpQTNoW6Ver8tieemdWzBjTv?=
 =?us-ascii?Q?MdXQPGGyHfobTU2tEUH1juRJJYzw8xfvHdYNqBlkVEJeqrVZJG6y+53suWfA?=
 =?us-ascii?Q?Jg+BRD/dz+Rb4kjEPaGXdr3zgaiIXtZNNJkObbyotfMAfxt1A9g9gnfmujcx?=
 =?us-ascii?Q?jr+dzA0NmpYmRcSCCmHcdH+EqSAhzaCvh21joSIij4hjrCl4OsrN0+gT9hsg?=
 =?us-ascii?Q?O6XUr9Jz165KutGXrlx/aLMoZ2P/A5UVoOq4N7mTzPa01TJvsk+Yj6FJ5p7Q?=
 =?us-ascii?Q?c5PtD/P6hrJ9SqEKPAW5GB02DUkS5pxzV7xip7pfdmtgWcJdEFNxw1lGHnMg?=
 =?us-ascii?Q?rhqgQPq3LNuriczZ0qR0iI8/D+hsjPBtF6ckq1DaeBAkykjRjpqLrWCCv9BV?=
 =?us-ascii?Q?PF+WDhP6dYykLU4P09uM1QqteoY0b637p5uhm6Op46Qt6T6/0mGu8h0bYVyF?=
 =?us-ascii?Q?0TCwtslFyKIWj+JW21ViJSskQ+Sfp8w9zfa41wYdwKYuYWamJ5dwiO9DnohE?=
 =?us-ascii?Q?EDm9IXr9ztAkFvJJdJ+AwkMYYdocwmrs3HMIOWtuJdPwUyxbvyNj4Kj5Ymxx?=
 =?us-ascii?Q?2OwjQNDxTpdaBoanQYN/iEtdDYOaNgxTmPARSBjzP7jQPtHnQYdFws67ygm+?=
 =?us-ascii?Q?cdni1cqCWEuJuZTjdwBvxHFx5zYoXHNocxJNW6RCYf9d9aYtUYYrADubA1VY?=
 =?us-ascii?Q?1rqnRy/EDJec0LbN2DNb9kMcntZWysoOyeL4D2HCQOU4YA8MGsld007k/Vlk?=
 =?us-ascii?Q?iSbKsZJFqGVWTelBT1rldS2EcGUDmPg8vRI+Ghm9OBmr3Vc8RSl2ImmF75c5?=
 =?us-ascii?Q?sEQ2emZLpVd97dPsdZlDva3iAzlAF9sO3h/sHBKnmoaZEMTQUlEjBw0OBAE/?=
 =?us-ascii?Q?FKKoflH5BvR3ZtpBUhKwkQcGoZa79NlckHfDEfhSPj+LkYE8K1JCppe4fjS6?=
 =?us-ascii?Q?Hf2hNaq2mRFMnIhB99ZPC56DkgWAAdkGl/Iwv7u9RW2gmpiHMqo227gu9pf4?=
 =?us-ascii?Q?TGN+6xRjFUN6g4r4ATy8Qa9K2iJMBut9PrZ5LN/IJiuzfcqG9pgP3oPeOJHh?=
 =?us-ascii?Q?Q8ggP0zWy/G0QnLE1lozVw0rSeoe+yraFRemFIAuSQx+0XKBpGtCMLkpvzr2?=
 =?us-ascii?Q?34kbkDS3rVWYpauTv2NLvpa6nJ7iE1C6Z4Yc7DPW5DJGflyFHUqjMJDKLV20?=
 =?us-ascii?Q?Shq2OvBrQQLi6d+wNfunYKD9r7BzKEnfiyp4nWzhPztyuoowcLNxp31Z9sJ2?=
 =?us-ascii?Q?bU25XopT89+ariuZk5k7QVk6I/ngDIJwawTREGg/Zsyix242sOyLN5W5VgOM?=
 =?us-ascii?Q?kgoIvznO0z+Nqw0SBlr+p1uf8OJFtRfFos1lnBx88bmwXavldZoK5WAH7REf?=
 =?us-ascii?Q?gjcZzZc3vSByrZnGp3rlBx64EzpySx9bpGH5VWKyzP8Vt4uVnYqKOv3Q3vkn?=
 =?us-ascii?Q?hCi4PA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b77706c7-a4ae-4bbf-5cd3-08db3056bd6e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 13:08:50.8522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aZiZk38Hmr1PRRmcAaEn00BS9+1LvEsb4iS/6HP56W69M71vysudvo75h9H0pTyLBazhUuVZ80IBIcCf0ihgY8wHkjsO1ZXtB0w7BEnume4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4132
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 06:30:20PM -0700, Michael Chan wrote:
> From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
> 
> Fix 57502 and 57508 NPAR description string entries.  The typos
> caused these devices to not match up with lspci output.
> 
> Fixes: 49c98421e6ab ("bnxt_en: Add PCI IDs for 57500 series NPAR devices.")
> Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
> Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

Note: I checked that this corresponds to
      https://pci-ids.ucw.cz/read/PC/14e4

> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> index e2e2c986c82b..c23e3b397bcf 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -175,12 +175,12 @@ static const struct pci_device_id bnxt_pci_tbl[] = {
>  	{ PCI_VDEVICE(BROADCOM, 0x1750), .driver_data = BCM57508 },
>  	{ PCI_VDEVICE(BROADCOM, 0x1751), .driver_data = BCM57504 },
>  	{ PCI_VDEVICE(BROADCOM, 0x1752), .driver_data = BCM57502 },
> -	{ PCI_VDEVICE(BROADCOM, 0x1800), .driver_data = BCM57508_NPAR },
> +	{ PCI_VDEVICE(BROADCOM, 0x1800), .driver_data = BCM57502_NPAR },
>  	{ PCI_VDEVICE(BROADCOM, 0x1801), .driver_data = BCM57504_NPAR },
> -	{ PCI_VDEVICE(BROADCOM, 0x1802), .driver_data = BCM57502_NPAR },
> -	{ PCI_VDEVICE(BROADCOM, 0x1803), .driver_data = BCM57508_NPAR },
> +	{ PCI_VDEVICE(BROADCOM, 0x1802), .driver_data = BCM57508_NPAR },
> +	{ PCI_VDEVICE(BROADCOM, 0x1803), .driver_data = BCM57502_NPAR },
>  	{ PCI_VDEVICE(BROADCOM, 0x1804), .driver_data = BCM57504_NPAR },
> -	{ PCI_VDEVICE(BROADCOM, 0x1805), .driver_data = BCM57502_NPAR },
> +	{ PCI_VDEVICE(BROADCOM, 0x1805), .driver_data = BCM57508_NPAR },
>  	{ PCI_VDEVICE(BROADCOM, 0xd802), .driver_data = BCM58802 },
>  	{ PCI_VDEVICE(BROADCOM, 0xd804), .driver_data = BCM58804 },
>  #ifdef CONFIG_BNXT_SRIOV
> -- 
> 2.18.1
> 


