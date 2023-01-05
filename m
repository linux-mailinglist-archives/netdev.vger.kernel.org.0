Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6634765EA1D
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 12:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232482AbjAELoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 06:44:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231710AbjAELoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 06:44:22 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2093.outbound.protection.outlook.com [40.107.244.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7343356887;
        Thu,  5 Jan 2023 03:44:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lvbDacmqfNSE81vMgGq7Nq2Th4jIcf795igCGbDEja7tA6AB8DcjdIg7E4zaeqQhoHv29OWdVVIkCgiFf0meA+A9DSd0xmg4PrxO5X7h32eXSmTzOZCYPy5/ELdG2UjeH0QUC5jzePdQ/NIdPc6JIxoqkQLT/ZtW5xqgPr1AVIcaAGYSkl0IdUl54pJEVSIaYs/2eOHvbZ0IsrmZvP4Ig3sibsyzCpFKFlv3CNqIXtCZbw4BnQkYBd9AjQ2LyP2Ke6zah79EZIeEmBbpN9v43IcePgHlLWOhotfQVG82QB7qwG23ww1hrzRLJpAuSzlP8lILXzpDgpo8fINL8kfAIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f6ZyqmhPsKybnCA/44UNjOAu2BB1zPzPITaY4dfNdng=;
 b=iqRx31+AutREpYC1IVGJJ+W3Deq9pXTzSitx7PzzhrZ98SaRIbdESEpqgiohr/MjRFR4yh+AsKgjxUIVuaudV0ZBzs8Nwoz5nK1ZhGdWKaRtLxJSbIcq3YHUli91EjY/M53Z1ry/jh2UrfFratzxRAp5mLxU6CPI6po/u+rdfWBsn3yPXf55U3mNqYLdgCNdrrYAtXiu6lZSYPnTeIPAtCFCWq/iG4ca7ziwflbXCDXmyJ5TCxzhKi+A327ve+olj0Ije2GtU/u7xWm+bdigxeepDkVajnhUqoq37h0KLi2aCaXt6DPuAGdz+jTWtMonne2cap6Apooiexq4A1TjWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f6ZyqmhPsKybnCA/44UNjOAu2BB1zPzPITaY4dfNdng=;
 b=E412ILdFstpUwWTkovfaGkBEDllQ1/rFASYjfELEztQo03rm/sGD/dRY6svFcQFHksJGr2qEgGvtSWBe3ruR8KskCxmKe+hEZa22VEOnYphmX5ky9NfxSpM6E5dVvqc/wSS/h6tYECXSL/91Bx5X8kmLbLn1YLDR3Fa5kGtBvHs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB4086.namprd13.prod.outlook.com (2603:10b6:208:26f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 11:44:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 11:44:16 +0000
Date:   Thu, 5 Jan 2023 12:44:09 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     yang.yang29@zte.com.cn
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xu.panda@zte.com.cn
Subject: Re: [PATCH wireless-next v2] wl18xx: use strscpy() to instead of
 strncpy()
Message-ID: <Y7a4CTV+RNhoI/S7@corigine.com>
References: <202212261914060599112@zte.com.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202212261914060599112@zte.com.cn>
X-ClientProxiedBy: AM0PR01CA0129.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB4086:EE_
X-MS-Office365-Filtering-Correlation-Id: 910e77fb-6758-43e0-5569-08daef122c65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1PxTfwHSlsjPxFO0w2ye8Mo+8EfYLOd7n1onWCos7tUwOE5w5wAbATn08J4L/2QczQ8R8AwGFOWCEyFQIG30q59bcfRFeWGVFaUu1PXWFXCdMsGP4xUy0FsMB/KytNjJ9kAhqdgydNV1CBaFVzTdlwR5ggabJRK9+24vQOkwwBex1gK66z0Um7hgkOgZoKfnNpoitaNAv/mLgf0HOuRkrqcAWvSdcfIOQbJDuQIPd6yg/Y9tbvVpzmSLyWzkZgklAUlF2v8nWhJKudjfBY0KUwYOWqSG9JTTZ19JAsjqr32m3fX4oKLqO9RB6nygfggQoFrCZ7iY3QPpJsgNg0QpodtIc6UYiVnHjLmL2J0HAUrLhD/O7uA0mN6N/fQWJlA5S4B6L/vWKtE8IQHqehVnIG4xncLsCLwb/TdBAzKmdGMQTIURPdZl6GoscnMvgpzztGXfCk5pG05B1bFlvP+iZvQGJOfm87N6ER3EyN3KhWzjzof8kNtwPokFdZoZGzPcxIrVBiIyUWSJp3AyU/B1jHKqKwSyDoh2TDZwnO2OM/V6D1NsCRDiJyAQU5hL+NvUJs5fPThjhvX5QHNsif0n3dLkInoHN6KQP/jd2KrvIBS5f7vWO+jxb5OH1dPw2kvuyDpUWzw/ABxVM3+5qLSBjMoAwjDuje/6M5hECAoXwzipWslzrkr04fL0lK2C9dQK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39840400004)(136003)(366004)(396003)(376002)(451199015)(186003)(6666004)(478600001)(66476007)(66556008)(2616005)(6486002)(66946007)(6512007)(44832011)(8676002)(8936002)(5660300002)(7416002)(4744005)(41300700001)(4326008)(2906002)(316002)(86362001)(38100700002)(6916009)(6506007)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JBuViVc6xjo7kHxZ5QHUk6dDoIeK3pWXPzwk6CYz3YROr/CfG0q2yJaoU2nc?=
 =?us-ascii?Q?P7yR+lB/OTQMGJf05C5LmWxWYuROIC3Quxlgb5rqOfr/dyryftMloZWBtkeG?=
 =?us-ascii?Q?97IB6A+Dlf19Fw8tUTL/iLEbAONRCnCVL4KCrOltwFTT2zLYB2QsItSdnH/q?=
 =?us-ascii?Q?rDsD9fRtcd24ynYLt8rcLJFUDOsjpTIb9oxqAkUPsFGvIsXu1JNuL6SV31sg?=
 =?us-ascii?Q?U0lizAcGhpADY/E+uZXfnlsNIHA/O03rDI69KinPik5Za1mJRubktKsMvHGg?=
 =?us-ascii?Q?G4zuyFfii0Zab9BRH4GJiwFsvFjM+ef1h/n5N3KOwmsfKHbx304OvZ1bmwll?=
 =?us-ascii?Q?hFoWUCseGCj7QFjA2yF/SWx6sO1X/I3wURVBAKg+y9XmiRp1p0VOAzVw6zRd?=
 =?us-ascii?Q?1oOMM12xOHzHAVsvbRCqavaEsxBcBbu/fFzh9CnI0LQi6fp4Sc5NgNVUduUy?=
 =?us-ascii?Q?kaishdafSh5dgpHYz9fCCCvahR9AFn6+0OcHdLeE26AXR9LTkOl+MqOPvM9V?=
 =?us-ascii?Q?DHUFnqJRaV3D8UOIDhZSHINBvoKaEXUWlttDu73KII5exS/Ekacc79m40ETq?=
 =?us-ascii?Q?reEwvDhwb5UGnFbazQ9gZ0yBAGAp1FYS5DRezgNQJpifx1eGbemXc7Gys05m?=
 =?us-ascii?Q?VjvNdlaZcVm8UvIqQboDHV7e2rSyfwf0lq1i/R+zjsMttIPg7PI/JiEHfuVS?=
 =?us-ascii?Q?14UZGdza8wStlOeyxxE97kWoAQh9oyWhSlfldNFTbGV83WZ4yWKDmlXmx4su?=
 =?us-ascii?Q?onWili+Y9fxefuAeF9jdItrMULq1WW1z4emI+r/e4I7V8nL3SDyy6x9qTHlR?=
 =?us-ascii?Q?azneCwdtr0yp/U769PkPRryOK7hO1rPWuQwFoDyFIM93IeU3LmPyH2cZZbY+?=
 =?us-ascii?Q?bOEQzZjAZw/cFGtCKJ8IdP2M/s9iJX/ECSA79eWKDFZjQyBM0yEWqns7Rtnn?=
 =?us-ascii?Q?mXzT/sKnl0gE+OJ8w974FKhtOix+Bxzi5CWF5KcKfRdzU7/hN39N1Knr1MUh?=
 =?us-ascii?Q?SA+D7YfpU056MFGEqTGpfUtit4+v2anJRXDzmHyu8NqkAvsSxJndsLU6yjY5?=
 =?us-ascii?Q?RNhdfszJCqBRAgU+/VhkI95ndFexxG82Sseg3srCSLJUdVrSDl3m68vI0I0E?=
 =?us-ascii?Q?YhrhIRtWIMR6+JW/gsiXt54cLCbYa127mywF1vejN8qX/5q6Hz5k1c53B5Bb?=
 =?us-ascii?Q?bsgP2rE7IqIHbwn/+CkqYLj1dehY2D8DJOGVLkavhfvVxUCsgIjotkpMtn+9?=
 =?us-ascii?Q?LP3vzcI5iBoAVUc0BVXAOARzLPLmjXmH1BJEv5y7poiwXqVR9ApR+DsKu9By?=
 =?us-ascii?Q?xOlYknRrkDJGtniCV6+fo9HFkqwJ5auOHhznRGw5HYbxpXDMZPkgfaSVyXMz?=
 =?us-ascii?Q?uY/OgUUK79F4gLNp+1ADXmfFtJnGSoZSW1RsBKsnIlIl820RoChX8ZDiQCrH?=
 =?us-ascii?Q?hVIvGKvW9OYbGL0Rgpg9r9+K9cHJKXdr+UwDg5nwH668JuckkWwxReaYy85H?=
 =?us-ascii?Q?ogxYVagPUG/HnNGPoTjuPFGqoJvly4Hx+BYPYOmpV42R0YkmcplVQyhfC+G9?=
 =?us-ascii?Q?u5GS1MozPqkzVm0cy78TL/JOl6dElhE1OjIlrCuMjDV48ZTBb6cDiihuQsCc?=
 =?us-ascii?Q?CDHGPQHQR2g96zrGrQ81eyafYhpOn4ZWdhzovnUGWEwDwaOQUp6xpgfIQDNw?=
 =?us-ascii?Q?qdBOVw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 910e77fb-6758-43e0-5569-08daef122c65
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 11:44:16.2447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i14c3lXchRrQspgbSnXVYrlH+UCitG89CdmfjszKs/cmTwLCqQrLhfzTj0cvLwJc5pi0bvC7a9E7XpZ6uUctaYdQpnfKU12g38HSmYWVsyg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB4086
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 26, 2022 at 07:14:06PM +0800, yang.yang29@zte.com.cn wrote:
> From: Xu Panda <xu.panda@zte.com.cn>
> 
> The implementation of strscpy() is more robust and safer.
> That's now the recommended way to copy NUL-terminated strings.
> 
> Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
> Signed-off-by: Yang Yang <yang.yang29@zte.com>
> ---
> change for v2
>  - use the right tag of wireless-next. 

Reviewed-by: Simon Horman <simon.horman@corigine.com>

