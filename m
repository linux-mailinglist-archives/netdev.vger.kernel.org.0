Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3E9A67C4E5
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbjAZHav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:30:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjAZHaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:30:14 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2124.outbound.protection.outlook.com [40.107.93.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7414765EE6
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:30:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ImrFftR3mqto37Mk6sNIIZ0pCUgWKxUolYQnIyiZT8ujOuMW9lt280CbfjHoUTIm9giTbr/C+9hWMD6W4TBnzCSdiPhTprm1ueoLlKUdQY7oyEnZyGpR9or3JqsKZm2B+4YNA3z/IBgiMDM4NUCg1AjcXFMRMq7qGnCBzOE6wYEwK0UyfzuuQ/noqecfyKqzLRFCUZSvOnM25nWtC3mgwFjt0kjhtVtngNELPlZFzk/x8WMPc5pppeR0/DgbvqtrSNG42e9iZsoQT7eXuJDsM0jBaomDOrIkvbixT6XeoHNaG2p/7rwqwd1K/4X14wvf/69WZOBjhaoLv2+LIZtqCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iALbejCfAQ3vuoNEVIpmwHvczF0zoA59A2Sbjt20K+g=;
 b=iq6hmvvaEixdinkt4dlS005ZL5FyH/cMZVZTDd9DDMmclZReGkeJstx9LeR91CqkJ9uKzM9ECqjKXW/v4H1xX8+G/R7ixMlRoyAbIU6ebK8gqppBn+jteJvTUm7SPn4shZfcVQ7fycsH0l0a2xl2uoC/sWbeFcOTQzTPNS9U3bOufTZexaqZNHv/uOxIB8b+yEKsM+v7dLWlslcSWOXv0UBtFeeGaD6rySNt088WCHHUFctpJ0wakdEEg9M67Ng3Qr0aSvK1YCelRYYsC3O1fdIf+vkQ1/YwXMHrfeVwN46VYwD8kShOKt8fM6hxKYZKzDhyoBKAExbvuyEyKxzVXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iALbejCfAQ3vuoNEVIpmwHvczF0zoA59A2Sbjt20K+g=;
 b=RDTUcef7vBs8+AdTcfMBsdHgaJGWZfKXVk3q4zaxdnXAgTa8r289onP6wE1lS5C6jyyk4E/5qBRMmIf0CM1WHOnTtvWhs3neMilHpcP/raYrvx+ogjQrcu+ptwDkrcKo3ZN0lRPZ+T9Tb/6T0Yayd5ckE8CEqqb9AS8Dagfp5oI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3731.namprd13.prod.outlook.com (2603:10b6:a03:219::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 07:30:00 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6043.021; Thu, 26 Jan 2023
 07:29:59 +0000
Date:   Thu, 26 Jan 2023 08:29:52 +0100
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
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH v4 net 1/3] net: mediatek: sgmii: ensure the SGMII PHY is
 powered down on configuration
Message-ID: <Y9Ir8AQd8wmhIIiQ@corigine.com>
References: <20230125181602.861843-1-bjorn@mork.no>
 <20230125181602.861843-2-bjorn@mork.no>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230125181602.861843-2-bjorn@mork.no>
X-ClientProxiedBy: AM0PR10CA0093.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::46) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3731:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a256855-9709-4f3d-b40b-08daff6f218d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U9ImDPeubIVDTNXa++ChVaw8gFxDYvhdizviHP3DYTqUIKCj65xAr8qZ9i0Xi6EPJdovZ2Lf7PdZSge9jP1dv7rjr5iZEZxewb851z/CDW3DORU30XYklH5WxUYaYyJNGUip/RMnds8FDnAr7X5b4mBnEnFKrcrtQnJcjyg56PNicX/Ar8OJko6sbl9kKY+bqRVf/IBEXrDQqxmdijLazmIdRemjXc3KQdpNOi1KE28YzsuZtuVpZCUubqa34R3cYIwV5SARrrenmBsdq3ixPiyp3NxRtzmXGShCrMGVPBIOJFmsp4QKQ0RTHdLoxYE46LK3zCkF4E2YRsElIkwarEdJtvfnthtwXNrt6gLONp8zU5AHy4dk/fBpne6wm2g4jeBaC1bSmTiRmqh33AORqRpoQ+b5pPaN3M6zmoO3lgg+7S7Qnm5JaWGR9xb0ZRCJMMM2cfZnLWMC+NI0a+ygBO24H8MK3WgRbNzZ/coNwWILodXZ+eVpp+tjths/v2wAhYwxq8SHXlEHlb20IS7iiCTLOR1qjpeukiYs8SuFX7Y2b2IrhtZ6AGgmGEkd482YYOVvLBnNQCXPHFqptgmGwjm4EsL/z8E8sSA0ZFZiiuIspxsQiXRZc1kuqk1azQIQc7YT1t06KQ4Xav/oOx0vaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(366004)(136003)(396003)(39830400003)(451199018)(54906003)(316002)(38100700002)(41300700001)(8676002)(6916009)(66476007)(66556008)(4326008)(66946007)(44832011)(7416002)(5660300002)(86362001)(8936002)(36756003)(2906002)(6506007)(6666004)(6512007)(186003)(478600001)(6486002)(83380400001)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S0o2cWoxbEtUYkM1eVJLSHlZT3Nnc1QvU0RQMVFWMmZxM2VuV3ZDdDFSUXFo?=
 =?utf-8?B?bFNOQktmZWluditNdFhEd2lHNHE5U2J4eDFHYWhVOHFlK3ozaml6MTdYaXJl?=
 =?utf-8?B?ZFNzakVyUnZjNHFzTm8wc1oyUGtMTmo0Y1g3dEJNSmpBN0lzanpNVm1JWTky?=
 =?utf-8?B?R0lJVUF1ODBiTzBjak5kN0pTNmJpRXdWS05od21CK2ZOSHFKajFGOFNTV2Z3?=
 =?utf-8?B?dUx2ei9yZ3prRkNMYnIwQWNqd2FMdTZDTlk1ZUduVUdZUWpGOVhYUnJIc1d1?=
 =?utf-8?B?N0JZM2FHK1ZkSFF4aTRHdHlPR0w1cmxvQm8yMXhhR2lBVlhxTmhNWlR4ejNL?=
 =?utf-8?B?Ukd1V0piSGo1L1EzYmxmcGs2SmpRaFd3UFpwWkFPakt2ZDB3SVlhUTlGU0Jz?=
 =?utf-8?B?RENlaytzMmpwMld3aWFQaWlRRnlMeUdUNnkwUjc5ODlqK0dzK25WRUIvTEM5?=
 =?utf-8?B?cjczbE5SWXcrYmV1aGJ0Q0h0NklMbnhjV3YvUG5OSkFsTjhiUnpDZmtwYWRn?=
 =?utf-8?B?RGwwWk4vZ1crNUEyYjQ1WG10Sm5PM2xBRldObnFUbVQzaitra1lNQWJhMWhW?=
 =?utf-8?B?WmlWOWU4emVxK2ZpUmNBZW83M3cwOXA5cTA0SlBYRW9ueXd0VVcwZmxsUzhT?=
 =?utf-8?B?Z0cxK1pEaDBiMm1xZkV0V3dFZ1JVS1BYWGVvOUUvS2hrSFlxNUY0U1BJa1g5?=
 =?utf-8?B?akluaG1RYzYvUXZZNU5RNmdBRGhhbWZjdFAwbGR0VnBZZHZZamd3YlhCNFV0?=
 =?utf-8?B?d3oydzMxY0lrQjBNektoSG1CRUppYWVuQ240WitBbmRlOGxGaThwdk8wQXpv?=
 =?utf-8?B?KzhDY2NxTkZpZlpnVGFpVmdkdzBaN1ZrUkV5TDhvSjFIdDNxaDNlR0tHSFgv?=
 =?utf-8?B?ZVlWaFoyV3JIY1QyNW5xM1Q3ME1SV2FQaUcySHoycnlFbHdtSFlnNTE1N2tw?=
 =?utf-8?B?Z0ErQzNnOUF4SVk3QTJ5ZjAwaE1rT0Y1ZXU1anRMYkx2SFFjZm5SdE45UDVp?=
 =?utf-8?B?WnczVDVQOUlqVWQ2dTZreHBybFhLYUtDbG9HZ2x4Z1d0TEJ4UDViaWNxeTlJ?=
 =?utf-8?B?ZXZxMmF6aWNiUS9hQkEvYndjVlNHRW1wN2MzZjVLTHNWdXl1QXdYR3IvNHhh?=
 =?utf-8?B?anVhZTd4WjVybDExTXJWdEQ2RlVWQ2lJaEVlclREemZBcUdhTnFpZUNlSmRO?=
 =?utf-8?B?STFoUGUvcS93eDN1QUxhM29GenNRSTFGemd6cm5jblI5ZkJFODI1WGJNSVAx?=
 =?utf-8?B?TEVoQTh3alNRZm9FQ2hDTDJSVThwdDlYTUhhcDFWVnpiR2xvalU3QUNzdTRJ?=
 =?utf-8?B?NC9Db1FZR2ZneHBzdHJIbjhTNUhVc3ozK1pvd1F0aStnRE55MkhydlA2UENT?=
 =?utf-8?B?bFRXUUZVbmFMTk9GSGUxVWZSMEJTRmppUU1GazJGb2NPTkNjSDZrQmlKdVlF?=
 =?utf-8?B?WmU4OUpFU0JaYVlQU0RwcHdoL0dvY2hwWFh0R1pVZ0ZRVDgvaFVwNXBXdmZJ?=
 =?utf-8?B?Zy9Ec0JmaW9DcmhIeWt3Mnc2aDVaV2dBUnc4cXRwUEF5UndwWG1nUWg4enpF?=
 =?utf-8?B?MG5wekx6dWltSE5PSE5WckwySG9hYTF4dWNoRGs4czNTZDdTSzRqR3BvTzBI?=
 =?utf-8?B?QzdjRUhjRkxSMWhaQ2RrTGdkMmdUWHpjSVhxMURpay9EZk9LS1cyNDdwRmFZ?=
 =?utf-8?B?dUlWdlNNRklmcitDZklFc01ST2lJcGREN1BVUTJycE03eGNocUNIVE1sZ0M5?=
 =?utf-8?B?Y2NlODVZbDhBeE5UQnZMV2hFSTNraEU2RG9ZR0RJVEk5WjA2cFU4T01STTdL?=
 =?utf-8?B?VUQ5RmhDQ2lEbGVMeXh3WDRZcmRmanNyQ2ZCQi9XWjlVT09aWWR6Nmp0d0F3?=
 =?utf-8?B?N0psSTFqRUNaNEdicTBGOGNrTkJFWld6NlR0WU1xaFdjSkRvclcvL0d5L2My?=
 =?utf-8?B?MVpCbHV5U0l5VmVGNm1xZVY1RTFYRXpZT3B5R2tscmlHaE55N2NlS2xGd3Zy?=
 =?utf-8?B?NjNpWG1aRTl0LzJUNkNnTHptUkRtdjhZZXJTS25paE5UQ2tWaXBsUytqeWxT?=
 =?utf-8?B?VHNxeE9JUkY2dTlNeittZXhVUlArZUhlSXVlNnJVSlVHcmZvVU5mZzRKWFU2?=
 =?utf-8?B?UjFaeTZqOVN3OE5uY3N6ZXhkZzg1WEtrS2g3K1FuOGhJUXF1NGtKVUxXbDJT?=
 =?utf-8?B?eFAyR28wMGVjSlY2K2J2S2NWeHRPSVBReExzMi9kMUR2MTR5WlVkNnBzWEty?=
 =?utf-8?B?YVV3SXBrbU15YytFbS9YNG5DYlh3PT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a256855-9709-4f3d-b40b-08daff6f218d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 07:29:59.6983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AXXXYiWhrjfkDfHI3hQN9cJ0Eo2LoyN9Lloz644idbSEdCbTGv/1vQ9rrS7LOq5bqTU/StW58KkcskaanQoyY5MI8McS8wX4C1LaJraH3pI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3731
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 07:16:00PM +0100, Bjørn Mork wrote:
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
> Fixes: 42c03844e93d ("net-next: mediatek: add support for MediaTek MT7622 SoC")
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
> index 18a50529ce7b..b299a7df3c30 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> @@ -1037,10 +1037,12 @@ struct mtk_soc_data {
>   *                     SGMII modes
>   * @ana_rgc3:          The offset refers to register ANA_RGC3 related to regmap
>   * @pcs:               Phylink PCS structure
> + * @interface:         Currently configured interface mode

nit: @interface should probably be above @pcs

>   */
>  struct mtk_pcs {
>  	struct regmap	*regmap;
>  	u32             ana_rgc3;
> +	phy_interface_t	interface;
>  	struct phylink_pcs pcs;
>  };

Thanks for tweaking the location of the interface field so
there is no hole in mtk_pcs. Looks good (on x86_64).
