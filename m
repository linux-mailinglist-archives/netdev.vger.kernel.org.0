Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA056D4C77
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 17:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbjDCPt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 11:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbjDCPty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 11:49:54 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2102.outbound.protection.outlook.com [40.107.212.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C516710F3
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 08:49:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JHscscljmc/Zr5E1DpqUz/08l0hydmdgDdkwkDXowz0f0k3Nvx3K+rX8UdYZsdIE5Xy6B8/Pw90hNacf/+hs3kzp/4T4+tTqJIKyv0rRUZb+TWYYXMV3GDulJfbIdU6EP28ojTiKhQvtd7iyhKiEoRuCpSg/hDWVM4PtY786s+9hyIrMpCuC/2aicItyARtTpbihBh64SnaXfffzfInnbQ2JUks0JGQVu25LvrwNwEOg3SLUG959OAi+WMI7UQU01iyAizKtR2f6c+qQ/7ZT/V0DEAro+ue54XXmHE76AaAZ9ic35KlXNI0O58A+WKisBSl1KfNlFaDFsZWCi4zXzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z5e69aiLuwGrvqYjdvSoD9nazFfpicpHgH1tuRbbG08=;
 b=EyIk3vgaRkpZRGEHi9U2o7jYbgkA//hZVKWOVtdu7pLeDhWGUmuQvJbk/kkIyjNoXqG8ELfMKvkp6lu9paMzy1rwkacbr4DlHJpiGOGmaSQBQTRLGXTFUelWCZtX9rjZRsB3reAz8k3rv/S/wawCt8Zcqcs8uhmxlMoy+23BZgBvQsPhWWJ/e60ADYhTVFawpWJdI1J9XCsu62Q75IqwJY4R57yae/td8+BUn5FIdh7exFV511ihDNWn2V2PDqJtSJSTUnY7gFT4RMAkpgU08gLwAB9kH1kZP6XBFQ0l0071k/nuGJg6q9YAqMERoWXb45jrZLMBrbwBJhkQOpylgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z5e69aiLuwGrvqYjdvSoD9nazFfpicpHgH1tuRbbG08=;
 b=IRHlL6lzWhHnQ8lUv8ERwFt3DAp9E5hBH3IVkmODLcFZQ/F+Il5H0LPsvAynMwHUEf6NI4mqIoxttfEh54+hIGgMXo4krmeN/7FzOMe1n4LurdvfSWs4y2V3b0Vh7IeOqCpaO6/YRUmWZVR4RENByUMjVXkQBmEPgdvBtee8Qck=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB5171.namprd13.prod.outlook.com (2603:10b6:610:f6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 15:49:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.030; Mon, 3 Apr 2023
 15:49:18 +0000
Date:   Mon, 3 Apr 2023 17:49:11 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: Re: [PATCH net-next 05/11] net: stmmac: dwmac-dwc-qos-eth: Convert
 to platform remove callback returning void
Message-ID: <ZCr1d2e9rJkXv/2M@corigine.com>
References: <20230402143025.2524443-1-u.kleine-koenig@pengutronix.de>
 <20230402143025.2524443-6-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230402143025.2524443-6-u.kleine-koenig@pengutronix.de>
X-ClientProxiedBy: AM0PR04CA0055.eurprd04.prod.outlook.com
 (2603:10a6:208:1::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB5171:EE_
X-MS-Office365-Filtering-Correlation-Id: 426bd88d-308e-4037-4a01-08db345afbd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1fuSD7W3dliCfquyZOp/y8CA7vd5FbJLC/DuYH+kqZBx8Fay1cTPrDJ064MyDdHFHMs0DzuDeRtE/raEswBbAqpPGVXw068Bzdt1HEFQZ7Ui0PB1Pk8cRkRWYF+p2aNP6Mxsj01GEh0UQrkzHB+Zj17n7XAiC35nO4M25IKrKnFWGziB6rzrHRBETe0cgUDo9W4mYKZWu48ywZqnHTCEb0yozDE0M3hNpzdE+VI3JEMu9rDyNubFt6HuJ8qD3do9usvwKvg1Jza5ngsDAbyNsxsROnRG4rG73EO44/297OYNMcxi+hUadJkthbxSUzbGS8V4RkEWmZpGtUcJvd+1+6uPPip09df9Y/tROexeN7TkKjOXNVTNqrEZ6siFfjhnS2OLadW4K5kzr/3exAuIyYpD7xP+aGwqEyv5+AS6h0y1vmB6/+uLRafI08fOkTo8Iznon/dg+z+7XOY/vBLKd1pSQJ862XPUq593DDXXT2c+Xg9RtJm6eqY3mFL7m1Z/J0KCsNoBv1YeBb2ddLoc5lmoqd1gN87JDk6mcOpedeAvJPFC5wtoG47Z2tbP2sbm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39840400004)(136003)(396003)(366004)(346002)(451199021)(6666004)(6916009)(6486002)(4326008)(54906003)(316002)(66556008)(66946007)(66476007)(41300700001)(36756003)(86362001)(2616005)(6506007)(4744005)(2906002)(8936002)(478600001)(7416002)(8676002)(5660300002)(44832011)(6512007)(186003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MDF1ejgvK2VBSnlqb2RuSHgweHd6b3N6UmpQcS9EWm9OSXhwcmlyK1hBRFly?=
 =?utf-8?B?UG13bVpncnNyazZidFpXakdmM0tMWnhVSDlvWGl4aUdEQk0rL2c2R3BtR2NG?=
 =?utf-8?B?eGEzTWpCTGhBWVZZK3VrRjJwaHcwQlp3TGtsaVlnNExoS29JOU9PSjVlUjB0?=
 =?utf-8?B?SFhPcSszRU5XOFNJVGRzbUpoUHZHcC92bVFQM016aGlpR2hELzBnYzdzM3N6?=
 =?utf-8?B?QldiOEZ6QmdjS1A4b0kwYm9xMTdtNGFzcFpSUW1HZUVMRGcxTm5SQm9kT0VP?=
 =?utf-8?B?dHlQSEpvdDVsb2R2T2xrdFJqUWhKako1dXRpaVFyc1ZialR0WWxpeWVPalRr?=
 =?utf-8?B?VlVoWnJ0Vm1iMmQ4bzJRTVpPQUNnb05mYzdlVEpJWFBoY1BRUUFiT0ZnaVFM?=
 =?utf-8?B?QzNXVFoyT0gwTVhGbXRJQ2hwbW9NT0tWeFgxZ1ZrTTc3eTdmVkZqem9xYy9P?=
 =?utf-8?B?KzlZRlBPZitBYy8zMjN6Z1hxZE1YeHZTdnd2ZkRaTmllNWVINVg1dnErQVBP?=
 =?utf-8?B?Y1lpblNoQ1VNQU16bXAzUm5wNGRTQjFucXRmUkNCVWRldWdKTm9BQ2o2aElL?=
 =?utf-8?B?TXhBUjRPaVlFRlgzMGJZNTJwQStUbVpyMGk3M0ZSK1ljblo0eUtYZUliNnA4?=
 =?utf-8?B?aUN0dWJWb3VxR0VkQmp3Zys0QkhQUTczdkovVnYvZE5Mb2NuU3hzcFcvdnA0?=
 =?utf-8?B?eHVjYk9lc1FNMk04LzIwUitwK1ZSNXFrcDZVWjBlY21TR2VNYWVLelFHRktV?=
 =?utf-8?B?WkEzbVJkaVk4TWVSSkFpb09JanltMjkvWVZRMXNrdmw1MU5GN09teFRKenhD?=
 =?utf-8?B?NGdSSDR5eHlpT1dxV29sc29XMmREZzVxSTY0QmJKamlXMEd0UmZyQkZ0RUk3?=
 =?utf-8?B?ck1mSWpHOG94R3I2WC84RUQ0T0MrUkZwdEozYnpPWGh3aXF1bkMzcXZMcEI1?=
 =?utf-8?B?UEFrRzRPdXh5VUFlb3lQcFRpZVJxc2FIK0NTNVJuaUhNbXpBVldjQzNyV3N5?=
 =?utf-8?B?TlN0L2hFT09oeXZpVzV2SDN6T0g1OTBVNWQ5ZFlWUWpRT01mcjdBSm5QUVE1?=
 =?utf-8?B?VmlYT2pMUFdMYnRuUjE5Y1hzNEh2QW1aUWhJTTBvVG5LZ2o2UHBsM3dueE82?=
 =?utf-8?B?ek1WbzVYbmVnQURzbnhKei9sK1FoSDJaMFFWaXFEaE5CMFpSK1lqbnlaUW5X?=
 =?utf-8?B?dmV6di9NWitPZ05ucDliQTIrUitjV2lEZEpKdWhyT1Q0L0pnRHRONStwNWhw?=
 =?utf-8?B?KzkrVTZNNDl4ckdCeWRzVU1iVmZTOVpwcDVDcytTVEdZdnhMRlArQTF3UVc3?=
 =?utf-8?B?UXJaNVc5SlZtcmhkanR1VDRtVXlhSlI1NjRPQjVQQmYyUVVob1pFSnhnN2c3?=
 =?utf-8?B?YVB5UnlGQzdiT0dpSFlCT3FGY3NJQjkyVE53aVp4eEFLUTZKaUtML1FRUXdj?=
 =?utf-8?B?NFVsTUJmMGkzZ1YrSGlPRHVaV3gvditFMTVkYlBaQmZmbEJOQWNQR1o2YjhB?=
 =?utf-8?B?UUFwL25kZUZLckZCaC9FNnV4SDJuT2tBSUtMVWNnRVdNblZHZ2JDbkZlRTN3?=
 =?utf-8?B?d1FHM2IrN2NHMVN0YXByRzdJUFcxR2NsSVdHNUxHVTZUNUgvcHBvNUFESTJW?=
 =?utf-8?B?WmJEdEhBdS9FSkFrWThJc2MrTmJvZkxWOFhYRlB2RC8wak5qRmxaVDBJSjRW?=
 =?utf-8?B?N282NkhPVXFnMG5jdThFeVdwRXNjeW0yaWtySGNKU2hySFJpMEtsdTRIYjdB?=
 =?utf-8?B?M2J4Wm4zUVY4d2pYZmdHTEJWV1NxdkFLYW9CUVVkL1lORlRBZUJaQzJSeGRo?=
 =?utf-8?B?V3JiTkxOZXo0VUVEVWF1M0t3ZU5VL05TaTlqbUl6cExlQWZXclIvbUhmTmln?=
 =?utf-8?B?dmZMMXJ3Y3gzZVpzcFdSWlhTQlloOVBHaTlVWEgzeFhmb1lqS3ZFdWMyaWU3?=
 =?utf-8?B?dktxb2ttV25JVFdQdjVrY1FUa1JReUFHWUFNcm4xUk5tNVVGZHFYenJKOXpJ?=
 =?utf-8?B?dXlSNDRta0M4aEZabnhFQ09FOHdYSFNGWXoxTi8rVmw5czhhRnF3WlU5T0VH?=
 =?utf-8?B?WlRhdC83QnRGMVViVUJNcW8xMVUzK2lKRCtlMzE5UCtkRlRzRTZ5RmlLR2tB?=
 =?utf-8?B?Ky8weXZ6ZjN5czVvN1BkVmVibjBaMXNQMkR3a1NENktiYnlKUnFWUHVlQWc2?=
 =?utf-8?B?dXJiU2hHdlRDa1pCeithbk0rNHEwZmRaQ3gyNmtvOGFKVkFIckZEejhsTU54?=
 =?utf-8?B?diswRmlyWW0vNTdUMGV6T1pvSGlBPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 426bd88d-308e-4037-4a01-08db345afbd8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 15:49:18.2126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eoHqNZvy+jYboDvg8iH/H6N2YRCPCGIThafatL3lmVoZ04dSSrOfhVVEZHdz6PvYeJ2pT7TkRVduJcSb3EuuDVla89mmPpPLmwDD/uOJySM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB5171
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 02, 2023 at 04:30:19PM +0200, Uwe Kleine-König wrote:
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is (mostly) ignored
> and this typically results in resource leaks. To improve here there is a
> quest to make the remove callback return void. In the first step of this
> quest all drivers are converted to .remove_new() which already returns
> void.
> 
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

