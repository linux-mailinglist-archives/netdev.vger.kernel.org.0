Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B09876B2B33
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 17:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbjCIQv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 11:51:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbjCIQvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 11:51:02 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C26510B1E5;
        Thu,  9 Mar 2023 08:41:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jGpycB8Y/REP2YlVQADFQZtQ8G29D04APoCZlsFdaZzaWxpXiHXV6Hl98w4o/iEqTIWZe5DM8ndH4uoj/U2M3bwelRe2bFxSxQIxUgYYZIOyAg1G6Z0q24wAxGAe40oFuIuWvSy0NP3fzO3UVCED/T2tja4vPffMqAFNwxdFOT40SYwSJlNDv6ZRYtHEEhgawfQQVa/TFhGTbdjqgXeVHLkgcRCWheykGWW45JC33ZE6svWX73WRPQ4u9dBhD4vImwP4iryLx+sw3BTEBKekqZAHBvRygoCVw2Cq+4spTIcH23AQmi9w0wFZzAopWGLekmY/9rt5DosWB6/L8gFfag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZY/YdPrtyhQy66iKZjG47+IaaxRkoaUr+LqVS2b4A7A=;
 b=oTD2RgyL0mQ4Kav5Vz6F5EWIY6mVUQVrrCFlDalALmHJO9aQh3HVUEfD7svEiXT7NGVZemh58joXWC5cQKMKQnWF1QgMzMJvQSjsTRMVF9UcsllKtVFlkVoIEbmmSiE5usNIefnzcmdoHEwi8QYFtWtiZh8oZreA3uORJcsh4TW7+UlavS3TWCAgEnzmvn+cea5vlLJo7hI5KryF7kFmTr09Hz9oZJ8GeOoHLBpWRaLbDBZmIs15PvluPSDM8hCCT9ffnCK9JaHFWeFgNLNHrxGVSg4uWK+SnDr/ZLKlQQCyPxwEQuvkBUC9onjExDaAlxJCoXS6dTvZHDqzwmNj8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZY/YdPrtyhQy66iKZjG47+IaaxRkoaUr+LqVS2b4A7A=;
 b=O4HhG4r8SVbp8CfXf016WhlJHdj6y+m9EPsELNj2yyDEFu4ysoXuZ4/IF5s/a3msLqoBsEUNyFmXctuEcqWiLbFLVPEEmjHUEfTxWavBPnM3XfpIL/0l5uSG1geD8Ut99G5ckKabYVh6BhnwDaXQDU5tcOJcr3DxrGfBEhOsAFs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB5188.namprd13.prod.outlook.com (2603:10b6:610:fd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Thu, 9 Mar
 2023 16:41:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 16:41:36 +0000
Date:   Thu, 9 Mar 2023 17:41:28 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Minsuk Kang <linuxlovemin@yonsei.ac.kr>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org,
        syzbot+1e608ba4217c96d1952f@syzkaller.appspotmail.com
Subject: Re: [PATCH] nfc: pn533: initialize struct pn533_out_arg properly
Message-ID: <ZAoMOJFi9uXhEveK@corigine.com>
References: <20230306214838.237801-1-pchelkin@ispras.ru>
 <ZAdcGkqnfRDwJq5y@corigine.com>
 <20230309161025.bfezdhoazzirykbr@fpc>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309161025.bfezdhoazzirykbr@fpc>
X-ClientProxiedBy: AM3PR07CA0144.eurprd07.prod.outlook.com
 (2603:10a6:207:8::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB5188:EE_
X-MS-Office365-Filtering-Correlation-Id: c6e8ed7a-94de-4274-3fd7-08db20bd25fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hdMNTKHtR7T8jGLkFHxUxZtFLfm6qsvS0155DuOT50dgCQW32KDzRyig42PblXFS0nLDRfI0xFdRK4Tdwzn6SjUyl8L6FwMXmly9pYWCxLwxrDXWGusXZTzgcGiFjiokMjL/LdC38yP/U3q0ehlsoKS3BoGe9LwG3zqOqEz5rYs1CffPG460K76nwQGUStniBL8puBRpFECkvFq5WWcgPNcs90rGq+E/4wJY4P4ysrSzOUwpD7n/v0Jis7yW4bMdW06oAlvVEnryrB3zgmNX48ItueA4nPwN2UhGytfIXppIk6baii+wfOoVeuj5KRzRZ3UCZJ/UenZlDHlNhzwOWswv9e1yh00Ov00P/EXJrZc7SqOrkZHztTtlAdXbcq65xaoGulzgMMzitYkm/zOff4T1DnmHZHLxf2i6iJDqFXMsWpkLYxn6zuG2Vx2Nk6rpZw8XPLPKy6HY7+HJPcxDEcbaIPzNX7T6ZHVRuQ1VcWf+J46kA7xKShWJNY3sUm0vGqTcokmiplQwtNoMe29AZzbNudkhQI2uPBIMUL460q6f4QKbSuMrdE/GGswEwh55nuo/bQH6smAvK6kOTFa4mEHen2J9CW+0k+nUeg5KUA8lwARXxi2WbS/0wzfK042ahHy6HSqbDCkc+NaWgqlPKnSi4Y4QKOL5QkSU2LEi8/uE6RCSjyn5UrjPsS/CzClV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(136003)(366004)(346002)(39840400004)(451199018)(36756003)(83380400001)(6486002)(6666004)(4744005)(2616005)(186003)(6506007)(6512007)(8936002)(66476007)(6916009)(66556008)(4326008)(86362001)(66946007)(2906002)(7416002)(8676002)(5660300002)(41300700001)(44832011)(316002)(38100700002)(478600001)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OAFXEG2/dXAB/5IlH24sNpWxDVv04OZ6C3ZfsmZfZwF9RTq9JF2Cu2+MR5h8?=
 =?us-ascii?Q?QsBB3EyAAi5fqdIKrHhpnTOO66/v9BpgDGosbpCwW/eX7c8VyZPc8zn8u27Z?=
 =?us-ascii?Q?9+itKS8AE6tcd4tXtcLnwNcR5RtbVSr1kNUxAJ005A0IAyQofCpUFYO0RpfU?=
 =?us-ascii?Q?K4VSB+W037PFoRmSgxCLKHQ1J8ZYUygTwvcYeQVVAqIdZgRBFvylb4JhQsKv?=
 =?us-ascii?Q?PewVOPMn5DqdULQgRFX52nxzf3yurnsgOjt9i7hzxaPtvPHHjAId7N9O1mQx?=
 =?us-ascii?Q?jPTQQghF3/njNSddaScjuFD1oxEyBlej6n2CKPSmPmjyzJGpcI/UgwIiGbL0?=
 =?us-ascii?Q?Rwu1nPDxVaDdzZ1o8VFF1cA06Av3ffMUmGy+yL1Q0dobQbAx/L9NBJJmNk2t?=
 =?us-ascii?Q?NRuLgpIBi7nVEoocnXhS6H5GoaaA9l2FBoN4apvz0cpJ0PLg0rg+WsRdCdn3?=
 =?us-ascii?Q?qzwzgYlKGPSFBnA4PnU23ky1xhbtrvmSPXu8lMQo/xhX9+/6d/s9ih/IdSem?=
 =?us-ascii?Q?IpDX3EmvbP17EzU56Fy5Deg9ZUrJBVhv3clmfCLd/1/1hHpIcLseYjWFAFLB?=
 =?us-ascii?Q?oRgY9F4nc26P6Zlpxrzd2stcRRM3iLVtzDGqRrEiwR7AUSEY4q6RQX2706S8?=
 =?us-ascii?Q?W6GVGGODklMmLkPqSp6FlhqfRFznNODBkYDcIRJAjBverZFEypU6djduO+0Q?=
 =?us-ascii?Q?t+OBXNqh/jCijD9hPLiJ5dOS6EY3pIQYkFxkAtaVPl/MezKXmg5xAKElwnhH?=
 =?us-ascii?Q?gG1MQcNINm0Eo6spIwMvrawg5NbcSqBFHBT29smJ1DwgMUgg7yYxRybteppZ?=
 =?us-ascii?Q?4x33RAViLTNINWClRLpXOCZoRU+n3dxa+BXtdKNS4cF7/6EYCIyw88eLeqf3?=
 =?us-ascii?Q?PJbCyBDihYiMca4CmAMyS9JQhCwNzzZ597+bXcUbjGdgQdI6cLHbsQJpv9Gu?=
 =?us-ascii?Q?fDaNsf21mTC2rt0/oYkL4dOtZDohQaeWN6aApD3n0Ro8vjugS5jEcV5arG/H?=
 =?us-ascii?Q?GGP1ugwX4HFBMHqFXMhUUJMaJmEFqeuLEy9kDB3xdasfSs6bZZy30vccvRPe?=
 =?us-ascii?Q?iriHmJA/jKdk5WL27Zsh9nIIeh3dHPUqxjUVHjPPzygBkCP5LlmcpNXD4FXw?=
 =?us-ascii?Q?kGflZYGXa6bDtdfV3WB3NCfXLyj0/qosPi2zRdvjC3J4eNL4VtBm8L567H/E?=
 =?us-ascii?Q?GrU1ZffbxOyY0LOYRaVDuq3Ue75gWbMXCfGzue6r8i9551r3ZT0/yoQGTwlT?=
 =?us-ascii?Q?BezBXTeyFzUK99zrN/fosxjoDHEhQSqz0pkFWsXdFUIE9u3O39eWzFHTz6hG?=
 =?us-ascii?Q?MinRz4iVpBPvGMtREc/YlfsTwmi5HEwFd+hgG3tXnGkQ3p4cST1Yp4+vVwH5?=
 =?us-ascii?Q?2yd3Kpa1yXmUiDrQ/UUsWc3opiJyKb0Zd6VN1S670VCEEz9RxoI6QoO2Qucm?=
 =?us-ascii?Q?KDY3gxaVJS7FPsdq7GnlHRBjaIDpN7qcr97ZLNHENxrqHjTHUR9GuxOFGX6z?=
 =?us-ascii?Q?5LBYK9qir1fKJMVw4Xy/Mu2s9l7Aer4/ECtxqujqJy+JcHuOJH7T4kD6lG97?=
 =?us-ascii?Q?CTIXv6y6h4/lor+7QgtFMQ1vDihW3MJteSrNvXYnDjyiROLoLhr3oJnCfqcZ?=
 =?us-ascii?Q?f++4ibSWYReICTOGFfHe3J+8ccqCOq4ysu4+QFpmZgTPgwZUr4v13mRVVSJz?=
 =?us-ascii?Q?H0zPBQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6e8ed7a-94de-4274-3fd7-08db20bd25fd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 16:41:36.2881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZEEPoCIAZO4epbQgH0ZifEIwtb1weFeZm1Fp8L4pmzwsH4yrp83M4LdRl/Pet45DH4swBPJSgsf6bDLdy7musfoptLeD8FmPHifjEp1H/lc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB5188
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 07:10:25PM +0300, Fedor Pchelkin wrote:
> On Tue, Mar 07, 2023 at 04:45:30PM +0100, Simon Horman wrote:
> > 
> > nit: This doesn't follow reverse xmas tree ordering - longest to shortest line.
> >      It's probably not worth respinning, but I expect the preferred
> >      approach is (*completely untested!*)
> > 
> > 	...
> > 	struct pn533_out_arg arg;
> > 	...
> > 
> > 	arg.phy = phy;
> > 
> 
> That is much prettier, thanks for advice!
> 
> BTW, is reverse xmas tree ordering considered to be a general
> recommendation for all new kernel patches?

I think that the situation is that some subsystem maintainers require it,
while other's do not. So no.
