Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 357416B450B
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 15:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbjCJOai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 09:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232505AbjCJOaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 09:30:16 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2095.outbound.protection.outlook.com [40.107.237.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B52FF4D87;
        Fri, 10 Mar 2023 06:29:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PvYTcOIUCChG3I7p/lRXAtOD4YxJjJqKKCy4pAov+vty+tl+ehnvL/1B7JxNu2PHQJkpOfJMVzdpiKbJR18XS3zSzMxy3v7dbyBU1XblNGfrK4ncM0v68ADmhWDNQUUAcPLbLxD2nzO34VATgoIDtcGQeec4YrNzUNvgReoQNUh2QBHezIOOmgZ9g5vCyR48m85hgQHsxMjdduTZI6zWENSvB6ZzVRF8NgI84SISQkxI958Vp1YJAwfuGGQw/YYjCIRj2m1wnTAL2xXX8U3JwUq0+l9ZhS2Xtvit+XVm5bl4Zs0mo8umjA34Qpc6Y5vcBVef1NzsIlZY8h0CSF6c7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ybqA30W45pYwAr/5w7CqzvPvYLuMWbJFkoayKaHQKw=;
 b=hBBqQTsudAyyVYbxpMB47/42aKVMhFD2NDeJ8HS/7ZpCk/WuDaJHkvBdeAiGJqJTDZuwl0TLUf6oDYk8ly1hVAPSixdxM4peiElz0hBDC6b1g1V2Jm9yqogvcAWUOwkHNRKOHd+AUJANo6uWZ5IZNZEsj0UEokVWzDNDy01gTMYlFssp6xs3Tsd7R7TE/RpnEMvCnUbkC76MOkAjHddfc9ej1NvnusZkFoVgHzZfXkkvMrTrhI/zKVG0OpHzmFy29dz/u2lPxnq19Co3VLgmitsQ3KrQMrezUCKGkdsSaUfvoVKwMX2XE8w/5GtZcFLzSzR0qpcp8FC57PzehRTd2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ybqA30W45pYwAr/5w7CqzvPvYLuMWbJFkoayKaHQKw=;
 b=Y1n+B/S/2QRj7g50GiJz+wbq9ZYnRotC84EOCwO0hHRowAlzzpTriloDyngxfaWblJ/GWyhnQfxRxJg9KznS053IMXPY31kro8q5guUhYTeJFvMHtNEVZPWwkDcPCe3PZTzwZBuZ3JN1zc6ZhfWry5S3O3D+duaTrDKqGznKdOw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB6108.namprd13.prod.outlook.com (2603:10b6:510:29b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 14:28:59 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.020; Fri, 10 Mar 2023
 14:28:59 +0000
Date:   Fri, 10 Mar 2023 15:28:51 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc:     Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@collabora.com,
        kernel-janitors@vger.kernel.org, aleksander.lobakin@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3] qede: remove linux/version.h and
 linux/compiler.h
Message-ID: <ZAs+o2UaD/nCF/Cf@corigine.com>
References: <20230309225206.2473644-1-usama.anjum@collabora.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309225206.2473644-1-usama.anjum@collabora.com>
X-ClientProxiedBy: AS4P195CA0036.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:65a::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB6108:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c496397-895c-4afe-ea9f-08db2173c98c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yfDR2F8B0W/80bbbOQAu/KYM1PU/KtqYCIIkxAh07EpXe9rxf4VyvUY0bpr24A+k48coZe4UggbOgZa2xuEPuMkONzXiS9gBxXxz8kog0oIP3du+0pD2MnoicNrsuP+n8pE4o7jG1VmvDJhZ81C1ZCspUHnH7W3BG47S2+2WMvpH/x1Xj9lL+aczBPtykzclOWAKU9sgflGLaR4zZv8d6M0vW2OAlVyvOSYuYJEo/PRmqKNl30qlh3Gc2Kh3ytACi+IPMN4wXvYdlgeVoVd3rtn8V7/V7Hz+3/UziBmJDAv3ssde00qY01CTqt+175nTtH/ka4puzPHU0Gg13uyMUFrd/bmxVLEab0qZDC4yI3iOVg9F0TkjOBZDrvXbNit+16lxln+rHMMjc0pz3DvenzdGnkqUu0wNlWq+l9RVezkk+eUc9vDLoNAoJK2CYGmFHUg4lrxVuvL1mrK7FavksmXDuYQl9xGjKAcZmAehvLxt+C64wZ6nZrWcHNmH62S4mIFfdf2RwrQtIgdZzgEVh7FmZS8bZnLm648mYcLkRjX1wnZOOvJwCADf0Qes0HbgKapmY3UHkuh3eb8b0TsmstT+mLHRqBsNpvZMW1AdjGI3aoELX0eYeaU4fL4tIMYw+Lk5WaMx8uMfCHNxSzoc1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(39840400004)(366004)(346002)(396003)(451199018)(8936002)(36756003)(4744005)(5660300002)(7416002)(6506007)(6666004)(38100700002)(186003)(2616005)(86362001)(6512007)(54906003)(316002)(8676002)(4326008)(66946007)(6916009)(41300700001)(66556008)(66476007)(478600001)(6486002)(2906002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o5sL0KNEQ3hRdAJAnY/mapjqjniteZ6/YMIo7KqF9aCw4L7NI5yaVurQ22ao?=
 =?us-ascii?Q?hc98E9UN5/nTdJ86jl+W99GOPRtPtbgi8FAyXIHnGO1ID2v58y//5hJVJf8e?=
 =?us-ascii?Q?Rn6pJCVSSyjXOGDMmVrwNfeLvqinoZad4RuWOrEYmd9Xku6DwENa/N8iBBg7?=
 =?us-ascii?Q?HfFrZ9evStZ5MtKBwNlr1ZU8F2dud4m7lysi/4vWxAN+cxSKfqoP7Sxt/s3E?=
 =?us-ascii?Q?855AavPLAozBKvAeIiqrdxIdhdpTcJjm9VRtxilNS558118D/AEr2iXHEmCB?=
 =?us-ascii?Q?xX65AXUd2ookq6ilF5ey0fRMEErmaDDL5X2pP2XEJTpui0E15GsKy3KDkwK/?=
 =?us-ascii?Q?mlCBDetn4Z+bg54cBwgjyroq4SDiCuldWkzifVrt1VHY29LHv+SOnXcg+riU?=
 =?us-ascii?Q?8Oa1xp67RpVPbTCMbKFegt6npAMQ5Zh88Xo7TxeFG5YdoTgsgax67rnsFvDW?=
 =?us-ascii?Q?2avERSKcCTHEvGZNVZn5BB3+8cemYdLdOJN8fL1qYAZt4DtcJVeOhK18ZaBl?=
 =?us-ascii?Q?vwletwzf73YqYdCf4TTpW54HcelLUnQLf8chrEy4EYVzb8uRPp+bAIbWbDgQ?=
 =?us-ascii?Q?b53qTnFkBilfUTr6cGVVXdoPtAsyds9zZ7ac6vdIdRbxLRMyg0smEoDHpl1P?=
 =?us-ascii?Q?Up/t3kD3kJKNFlc6RKtG1yICnpImzU/xWTIVPuN7S1etLV9VZ9TPrja04JNE?=
 =?us-ascii?Q?PXSjGpvdFb90IImrmdkzKItTxwya+GP9TEVmA749gZfDdTi9U6CEGTKxy58Q?=
 =?us-ascii?Q?jV/lG8gSu+nVMTu3ZtOgIAUYOoZSkR4queTC8IV94hN1h/xXwQIuLXxwAgyV?=
 =?us-ascii?Q?uRXNLtSHSSCd75MImho+/tC/BxNbMlGJQO4iFDkqu+9I7JU2Ao8rWp8Ej8Ga?=
 =?us-ascii?Q?oTuEwBsF8IuXQ6j8zC2KpqAUKVGheNSa2/Zvqstu+L2qOA5w667gURUkebR/?=
 =?us-ascii?Q?6PiVHOHPEt5gW+ji2q7MI+I5+xPeWDzTCTMGz5np5ECvI8eLd979f3woqmiZ?=
 =?us-ascii?Q?9IMRNU/o8mtZlTTgYK6fwEMCMDoDDpVtxrK34TQhFeJ6MYrQBOsHOTZAcSXB?=
 =?us-ascii?Q?c7whOxNxXYyVN8X4/QusoDu4u3YBu1hKRASOM+7bBEyR3XZZVuz+KEbnQwZG?=
 =?us-ascii?Q?g25zWcXrW1Bgk0nZiQ6N75LA2URgbFbSaGIyxnAXMSNgHK35vEQnuk/O3m1d?=
 =?us-ascii?Q?CHA/eXaoLyqQqGD1bADUMIsqeyqS57x6tj/lLp8NJTdfRhkDO5Y7+19jPAOQ?=
 =?us-ascii?Q?NreDQX8oxXCfhpWA1gTPHfWWm17XsJiVZ8WCYv3/d096s0dD+4HUSRh20f83?=
 =?us-ascii?Q?vYlr4dTjG2T/sUqQPAlz/IquvgMudSkSE+f+rJYgmdLO0WBFC+UxMBDUgu+v?=
 =?us-ascii?Q?zdIqMKTyMgTmDiqKKz8usQQb66o//iCsQw1D6vPlW6rkXqhkt/KwAGGPEpzi?=
 =?us-ascii?Q?81zszydhdMjrczxnaJvb1AiLl4iF5XU989n9XH4aTpYlVakY+Ahny2E1Gfpm?=
 =?us-ascii?Q?NDUee5r16f8YhG734ZhOuDL/V2of8856xdxkymbYZ20Fyp1SxTKbeZkX1FBe?=
 =?us-ascii?Q?WaDgY3S2SaWM14B5xxENpr9lyT3f6HxXLdn/4YycWhkGC0iKu+LgKdXbGeNO?=
 =?us-ascii?Q?uHDE3jYJvIfaCQOrNQL8E+WTX36IHWvC6T2h4A0MpO7IyLL6hz8H8AjQzTc4?=
 =?us-ascii?Q?rBQLsA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c496397-895c-4afe-ea9f-08db2173c98c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 14:28:59.1342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 00+8ni/Nr/66BDxeGPcbhT3F3ldJldu4UGdUykAbTEuHajX6ei/TumfMkaI/mhGpQzcp84xFUFVHz57BaGH+q2fUmvipMHKsrd1br26p5yw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB6108
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 03:52:05AM +0500, Muhammad Usama Anjum wrote:
> make versioncheck reports the following:
> ./drivers/net/ethernet/qlogic/qede/qede.h: 10 linux/version.h not needed.
> ./drivers/net/ethernet/qlogic/qede/qede_ethtool.c: 7 linux/version.h not needed.
> 
> So remove linux/version.h from both of these files. Also remove
> linux/compiler.h while at it as it is also not being used.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

