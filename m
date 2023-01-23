Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF80267791C
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 11:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbjAWKZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 05:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjAWKZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 05:25:08 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2099.outbound.protection.outlook.com [40.107.220.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1210BEC7D
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 02:25:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DNZLUBAPjgHNBRMQTjIK8O+ovHXBfAWG98XuCy/zY6Q+kHkszbVX4AUNKVAXJ3z5wOL99SFqtOaUwEZI1H/7gm3hZsNEJv4vZzCJu9pKf0G/4e7aGqOgPzecXOhHIL625B7nvuvZg8ULnH/fsMRHC0wh4JSiN7vZWxKudPvMSe6Zn7O3fPgPl/7sSZQmW0dV0ME8pFF6LQZ7rfDAAdSWahRTZnHpqoRsHWRM+Vob8lXPHsfzlojjvQtki/DK88Fqq2YZ6J7IzRw1i+xp8v+cwJbNHB03F6sC5AaTLicgZu1U74IuPYaT1qHFONpODFgDKpFy+1aVJBhePj4f49bzLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GA9uPlXY4uCkEV1CxPAAGccQg11GqJ9HRnc2S9aFCIg=;
 b=aUC8QG3ca6ohmd+Da0NItEA0wZDZ0ynoz6Blr7jUjCrENO8ef/j66Ab04mGFbDPix9N245R4FkCzd7u/nGLxvba+XDudS6wZ6Uxn6735E/0RP1idvU1U7Qz1m8bF+P1ElG0enEqzU/ZB75KsFT5KBNOX2Fj0WM9NGzFKwqY9CA0hlaL3qIDXsJZtB8+fr6MzSYEHAeY70KXsXEZC4mbkVWbT1CwK6+DFvja9ax+ChqFS5sYhEoHAtUQfcxlrMVCgF5XgCTbTATEpUw8O4Etgv33RfVBfxxwdo44Tw5j0/6LRdAi+YWdzrE29p6Wvqut8/TdpFWTOvqO18CLT7Mrsig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GA9uPlXY4uCkEV1CxPAAGccQg11GqJ9HRnc2S9aFCIg=;
 b=bd3I69RMrh+U+YCT5p6q3fZ11q7teZSXc/vTCKfFqoefW/dmwyDKspYiiRY9xmTcj8LGZa5o/jo9xr05j7Tx94YvC3+ECZArZpcpSEJ+9xnwv6dl7LUl+HUmU09fAmeZN/Ak5vNxhDcs8Jvh5WSPbJmc2kNJwuC0UoP9hTlTQ+4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS0PR13MB6276.namprd13.prod.outlook.com (2603:10b6:8:12f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Mon, 23 Jan
 2023 10:25:05 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 10:25:05 +0000
Date:   Mon, 23 Jan 2023 11:24:58 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc:     netdev@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Daniel Golle <daniel@makrotopia.org>,
        Alexander Couzens <lynxis@fe80.eu>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH v3 net 1/3] net: mediatek: sgmii: ensure the SGMII PHY is
 powered down on configuration
Message-ID: <Y85gevlt7u/0KpWp@corigine.com>
References: <20230122212153.295387-1-bjorn@mork.no>
 <20230122212153.295387-2-bjorn@mork.no>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230122212153.295387-2-bjorn@mork.no>
X-ClientProxiedBy: AM9P195CA0004.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS0PR13MB6276:EE_
X-MS-Office365-Filtering-Correlation-Id: 144cd6a7-c13e-4b39-66c5-08dafd2c181d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ksKR3gIxBRAhEcYFSSuxGtRz/cgcL+IuXlBhqV3XIPkbtGu7ixH6tlNiVtj8pI/5063V9l2AIpiYVtorG64JxuSxysLxdbZnXlTpPsik1QgqI2AskUKC6tj8n7U/BlgrdbFpoZ/+Py9FIANswM/Z7vyAPyqg9hMaH7yq/gwF8m18Mr8rgBZ3uupVFeGb5P5HDtLZ6yo2/i7flkeK2dW3xwDG9bTKvviZA1GFQaBqqgGhEoIWodbnkEQk+C4wsPFKR37XOdOxG9RFdcUyhpnC3ZSwyzocK+CKRIu0Zzv9H3lwg4LSsGDrMVd862tnWlApkCLdJZRETrugIlH+lpMbgTqueQp9/3VTkvy8fMW9FFZIJ0MAamNhjEgdJD/o0e7hS4/iI9YNL3JCWqU0S7e5kVsFrgXlKuzwKHDcOjKqlS6rGXEQxTy94WCldlQp6LMQZDo9zt4WPW8B8LnRhVUG9uG0obYgahBBQJarN1ptEshHMNutiyuBgG9ijGc+MImuopu76NZnY66cex1t6tnrb87eJXp0viF7abvi9UsyfSs0Z/vDN1Cm1zj2hgvhkVt0FXlK25jIoBn36nfN4kr6Qro+LgtD7Ff8LNBSY7+6RLB4YTcR8wi6SEpYapYXNSz5RwYW7/fp/0xVJj9dyQZhNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(39830400003)(366004)(136003)(346002)(451199015)(2906002)(186003)(54906003)(2616005)(6486002)(36756003)(316002)(6666004)(38100700002)(478600001)(83380400001)(6512007)(6506007)(86362001)(41300700001)(4326008)(44832011)(7416002)(8936002)(5660300002)(6916009)(66556008)(66946007)(66476007)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UUdNWnpsUnBuN0ltazBvRFRWUlF3dXA2SVQ4dDlVSklHcGRaTnNBRTArSm1v?=
 =?utf-8?B?ZGNvS2JTV21CbVdwaEppVnBvQzd4SG01dWZzeThlOE5uQkd2aGpPSy91a1k1?=
 =?utf-8?B?ZXJCSjc5azlwRTQ3bCtCRXozcEdoakx2K3lBMmJxSUN6M2lkaTZFb2VuZnB4?=
 =?utf-8?B?ZVh5R2RNdlNSZ0lwYWVSbEFKK0NZM1B5ZmpLdGhaZjhQdWFXbHBDTUF0R2VC?=
 =?utf-8?B?RDhGL1BaVmtCZG0vQWp5Zmp6U3FqRTc0cjdNN3FhYll1cE5LQUdjY1FhNXJV?=
 =?utf-8?B?dUJGakVwd3lzb3JMR2pGM3Y1ajZDMFQ4eFdkOVowdjdZNzdIRTlaZjAvZ1g2?=
 =?utf-8?B?cTJlK0lOQkE3ZWFMbXd6ZTE4dUxobmc4VEM0bG9aNmFCQzY5VFpLK254YmFj?=
 =?utf-8?B?dTQvdy9HL2lGcHg4cVJQVnZCVG5CaFRpNDRVL1BINFl0ZytWc3lQK0loMSsr?=
 =?utf-8?B?MzJLeGZtMVI3M3BxTnAyKzZBejR5b1VIeXF5WnNFRUM5a2swTWNUaXFWUzQ2?=
 =?utf-8?B?WjYyb1k0UXJ3SWx0N01UNlAzWnhWL2pkSzY3OTRrNHRYY0o5blUvM0lwUHhv?=
 =?utf-8?B?QjkrclBlV056RWtMa083SFQxL3lWTGQ1Y2pxQ0hSUU9UcU8xaDRhd2hOOFZ0?=
 =?utf-8?B?RlEydjdhRlBnWnVMZ3NHdDVpcFBFd2tJRTVuazZ5aUE2MzMrSStBVGYyRWFL?=
 =?utf-8?B?ZXcrdUx6ZXdreCtzYytTMW13ZVkrWnpOT2FBRFRsa2VrK242a2N2dkFZc3d1?=
 =?utf-8?B?eXA2N2k0L3JQSGJnTGFyOGlEVlRjZlpWWW1KY29NRmg1N2VpNys0SHYvM2dO?=
 =?utf-8?B?UHBmLzhSMFNPUitveHJSZWM5TUI5REtaeVN3cDJ4NXdvNHg0akRselRaWkpr?=
 =?utf-8?B?WDNGN0JtU29GWmswamozbE82MG9WUnYzYnBuaW1FVjV5T25iSmUyaVJnaDNp?=
 =?utf-8?B?cVVEbFhNTFA1b3BTS1QzTkllKzNnUFc1eHhGZFBiVjkvUE5obTFLbDVsM2Zw?=
 =?utf-8?B?MUZxeWhtdi9FV2VLMklNRmhmUE5hcE84SXN5eXBBc25ZK0lXWnRGRXpQL3Zx?=
 =?utf-8?B?a1lsT3owTnByOWF1enl1ZDYzSXVXV1B5bkFza3hlRUw3MkdZT0o0aE9CQndl?=
 =?utf-8?B?STM0NjJnbW1KUzRWSHlha2cxdEJpM1JUd0JVYU9ibVRrd0hUTjdhSTFDbk83?=
 =?utf-8?B?RFdKUFhSb01MSmlQZnhxS1VUK1BnSDU5L3VzdHdSOXdPMGxHcEZkbnlkcWVq?=
 =?utf-8?B?VmE3VmdwUXJ3OEhieHNMUE5EZmR1bWZIalZWeHJTOVVMQnJLbEl1bVNPaGJn?=
 =?utf-8?B?aWhKckl4WWZCdDJUdzZxUnJKekQ5UW5aK3dPK0d3NllCZStpY0RWWlAzbTVF?=
 =?utf-8?B?Sm9TVmtOZEI5OXpvTGVhQWtBK3BIWklabzJWbHJlazhHM1hwbms1eXRMblVL?=
 =?utf-8?B?SlR5Tm82RHcvUG9weU0rSUI5SU5tcnBFaDJKWUpDaitBNFJXdDJPNHhVTDNE?=
 =?utf-8?B?YkwwT1I3UXdmOUF3U2ZlZy9iSDJuMm80MXRvUHprTzFweTdqblJoQ1N0eHFj?=
 =?utf-8?B?bVdGdUVJNldyUDlWR0QyNGMrNlhoZG9hQlJ0Y2pNaDRqaGdxY3U1eURqN0FC?=
 =?utf-8?B?L1huMTFnbVJxdEo3c1dER1lMM2o0Yi9XVjBIclFSeGdPWXN2MThqcGorZ3Ju?=
 =?utf-8?B?ZGJtSThCQ0JGZXlta1B3bkRrMkhOdHgwazFZMjZodFFYR01GWUtleWRkY2M3?=
 =?utf-8?B?Tm9tSmJVRTdZdEZnd25DY3ZPS0sxcUlHTDdMV1NNSVI5UWx2OXRVQTF5V3hx?=
 =?utf-8?B?TXNScHhsOVRiajZFQWpBWDJkY1haN0VEekhydFd6MHR3UzczL3o4eVNuN2h5?=
 =?utf-8?B?eFpzOFZiMEJjVTlzMlZ5RHJuTEJOSUQ5SDBnQ2pkM3RhTVdXNnVWcUlzaEVQ?=
 =?utf-8?B?dXB5V0V1bXdzZjVLSyt5TWQ5Zmxqbnd6cU5aa2dxN0RCZ0ZxUFN3dWJuTlkz?=
 =?utf-8?B?aWFEUHBac0QvT1Y1ZGJQY3h1Q3F2WjQvZ3llY3NrVDh6OXNoZWNYSmRuR1Jw?=
 =?utf-8?B?ZkgyOWZnRGVXdHhzR284Z1RLNW1iTWNaVE5tUEhjVzI5amNueFRBWFNuS2t0?=
 =?utf-8?B?cEZzQjZTNUlONnpVMkV2UjhXT21XNDBDblNXMzRQVXN5SFFhTnZBamdLNHpu?=
 =?utf-8?B?dFFCeWRXZjVYakgxemo5bXlDTFZwSGd3S0tvYkl0UmNUcmhXSkZ1bWtnbHpX?=
 =?utf-8?B?QzlpVEJqNnUwekR6bE8vRmVMK3NnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 144cd6a7-c13e-4b39-66c5-08dafd2c181d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 10:25:05.3189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yTYl3KNQjHviiOEXbkghC8hbjywTr8Yko275NKMeUkx/VnXRyYKlGSIaZca4Xrftm/HTSDjHd6jqJkof/FTXbBAkbLgx9X5xqlOD5pwvEbk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR13MB6276
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 22, 2023 at 10:21:51PM +0100, Bjørn Mork wrote:
> From: Alexander Couzens <lynxis@fe80.eu>
> 
> The code expect the PHY to be in power down which is only true after reset.
> Allow changes of the SGMII parameters more than once.
> 
> Only power down when reconfiguring to avoid bouncing the link when there's
> no reason to - based on code from Russell King.
> 
> There are cases when the SGMII_PHYA_PWD register contains 0x9 which
> prevents SGMII from working. The SGMII still shows link but no traffic
> can flow. Writing 0x0 to the PHYA_PWD register fix the issue. 0x0 was
> taken from a good working state of the SGMII interface.
> 
> Suggested-by: Russell King (Oracle) <linux@armlinux.org.uk>
> Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
> [ bmork: rebased and squashed into one patch ]
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Bjørn Mork <bjorn@mork.no>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.h |  2 ++
>  drivers/net/ethernet/mediatek/mtk_sgmii.c   | 39 +++++++++++++++------
>  2 files changed, 30 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> index dff0e3ad2de6..70e729468a95 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> @@ -1067,11 +1067,13 @@ struct mtk_soc_data {
>   *                     SGMII modes
>   * @ana_rgc3:          The offset refers to register ANA_RGC3 related to regmap
>   * @pcs:               Phylink PCS structure
> + * @interface:         Currently configured interface mode
>   */
>  struct mtk_pcs {
>  	struct regmap	*regmap;
>  	u32             ana_rgc3;

nit: on x86_64 (at least) there is a 4 byte hole here.
It could be filled by the interface field.

>  	struct phylink_pcs pcs;
> +	phy_interface_t	interface;
>  };

...
