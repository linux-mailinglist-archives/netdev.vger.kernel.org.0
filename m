Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDB306B2AE0
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 17:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjCIQfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 11:35:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbjCIQeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 11:34:21 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2111.outbound.protection.outlook.com [40.107.94.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BED322CA4
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 08:26:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E8+vq4afbBCrgaDJeiXOwcPvxcFYpl7V9k+xO8OXl0hzZtpgBsGPyNWQru+XxA3JL4QAiMEU9hMH6DHOcMJ1zjdNyS+2py787RPpWQ0wMxJ6ObLnqNEAYG5Yq4keQb9jKn+yLjqbHBLf2inicKyPxPfjYFtFkozOkTnPuAdDD5at3bq/Y8r6VKKpMdncqXKa0c7doZJtuiJbK4ZfiDLdtV3d9X/hPdQF1jQTjgVIfsiZsFSNGmDLthAVek7uHiJZU7T74QF27+wb1wqeFNwCX2eu+w/p74KWVVEuBmhoDoeWXlABVMNuC2w2q5sKB+T6q1TkGuL75Giw99lv2DmJ0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GeQiF8MfF0nQmi8pOww9MBog2DaiI+b2phe6hT1xR04=;
 b=dqP8VOfpChM+eaNCEJa60LdA8kIPn01DrjZ/VjmlQrk6eAodSvVkeD0Yrjja+T5qBBriZok3pgHpsPkk3YGkbFYcJpR4P31X9XswqDu3qXDWTSOpdW4WbC9puPOR16TGVkMmCApZS8UvHuOD92VxWKYIp690id2ZMMKPvNgwl1n98dZ32eE8gNXCRWib+g2Hum711C+QTOU76OOdYcUoTQxXAXIX4eOPz7G3AEgyiwceQ5P3Hn88XmZx1fF5FMZtf3PFGb7+A/XOqrgwhxAXSWlf7gpm6cWbA7amASbEumrKADlFqMdpzKoUSlFoc4HpQ8+hkvQ9yOB8ohAStrrEHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GeQiF8MfF0nQmi8pOww9MBog2DaiI+b2phe6hT1xR04=;
 b=VLjaS0IMxMIAL9SWeUGVBNsMoRjcASYegiAc4Aw/s5YRn6aStt1e6Y7Ytywupy+BfXSzAL4WQwf864r+f//yz4HIjaKjSqVNyQ1U2Yo6F66Be3epC369sJzaftIpK7sPcZ8qHeeMYhDvG9LsjQ9aZzECG7G7L+XCZ/X6aoWYuuc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5037.namprd13.prod.outlook.com (2603:10b6:806:1aa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Thu, 9 Mar
 2023 16:25:43 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 16:25:43 +0000
Date:   Thu, 9 Mar 2023 17:25:33 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: Re: [PATCH v4 net-next 1/5] ethtool: Add support for configuring
 tx_push_buf_len
Message-ID: <ZAoIfZqNaCG9d/1H@corigine.com>
References: <20230309131319.2531008-1-shayagr@amazon.com>
 <20230309131319.2531008-2-shayagr@amazon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309131319.2531008-2-shayagr@amazon.com>
X-ClientProxiedBy: AM3PR05CA0113.eurprd05.prod.outlook.com
 (2603:10a6:207:2::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5037:EE_
X-MS-Office365-Filtering-Correlation-Id: f4b9c496-aa5e-4847-ca15-08db20baed7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q4/Dz9l5hlPwWehyA5xY4UtD6yYd9mndROv65gVDJQC9DIayUC4i7ymdxMOIVtPxH6VR5ffGHp1UVS/uGBFWBOKTk8go6p5KPFSRFZEEvBlyVtZNQUoyYkejvcciAjy7TzZs6UAw4MP66sv/KuniKnhledun56SI+jmr0wKO6DEfpLte7YH715+tITxWmykoXkJ6YHaVveY54omzj4oaiQjBatU6HlOpTgeVe3maVQ39Z0T07UUtBMLu1xXFmDeUAYMrRZaohv9gMRLI24kmmD4TBMkpuwatXow/SbrOKLu5jfxQJWil5lD5HVeElLjZQ8OuZK/R2r7rXEE+NNavuTASedCbI94Un6oheICheVTHDS3uMy5K/N5rrn/waWDgAgPKLthYs5W5iJXMcYLimO5fNU0aOo5Jj4egIAEEHh0tm24SJoznJLLGJCtVCeBNWB8Qs9R2qs1aFToL57URV62gxbwrvPemV4Fpq7qpwd8HPcyedIme+82M9fADPVHIVYCixLIuZi+Tnd0PWnGAOjqFxWId/P6L703wd5dFuycBDEduz5VhC9mNXC04aEl4vLPLQ7CNJL14lcjUEgMAYUlseZb1ixiI5fzG7TgIxEqYOnvXNdn7BVsih9yBdbsKMEmpqsGhsVX9s4boC4cbUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39840400004)(376002)(136003)(346002)(396003)(451199018)(66476007)(66556008)(66946007)(316002)(41300700001)(8676002)(4326008)(54906003)(36756003)(38100700002)(8936002)(6916009)(2616005)(186003)(478600001)(5660300002)(2906002)(4744005)(44832011)(7416002)(6666004)(86362001)(6512007)(6486002)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fAI9iVQ8b8J53+nO9SNeOMwrcmh1bKO2zXYDs/5uit7YXmLtcEObochrMRly?=
 =?us-ascii?Q?qy6NreK1Ni5K1r3yxVkZFrv6x2AABLvT8NbIy8AqkTE3Uv54aER8Ql+IYFFp?=
 =?us-ascii?Q?c+je/Xi1+rwYOOZXk0N1t5TfaISyyVWsm++3h+Bp8bOxK2cTuCqY1zSi4aio?=
 =?us-ascii?Q?T3OWlJvKBoZ9Cx4LQBrpRRyg1aHnp9LNPi5XACSdDJpPL3ICoVftwMAW9iPZ?=
 =?us-ascii?Q?+o7zZKn8nciKfzjBREUmUWr0GT59WdYBwf13HBywvCjY+Y5NQzvlSwB93FNj?=
 =?us-ascii?Q?9uOZwPla9j1Ac9+g/KRcAcSblbB0q51UMhj6oFE2nOR2xfGCckik08BFd0Mq?=
 =?us-ascii?Q?Qvd4ZHyJxJhiqXKWUKxGC73po+/oF70GVZQrb6VmrbjIrjlv/L7YATH1acmj?=
 =?us-ascii?Q?EeYYg8EqBz65jKL0KlTOS4ggfl2dp89twDfV5xDCbQXKECuyeuSb5t+6+gqH?=
 =?us-ascii?Q?6EY9JZef9EjdMa8l0wMNBG9W48omEp60jY8LJg0m+DG0hev+MhN/voOgOVJc?=
 =?us-ascii?Q?biT/XvLcwqwrkdQNSXcQPivyMCeNNHX3H2/8JXai7HOZMWSrj/wbeEeaJN/q?=
 =?us-ascii?Q?0Rf+uTH8CewXKKPWaUQejsQI7l3I/hU5VYRyFEsrTS5tOJHv2AZdS/fLXMwJ?=
 =?us-ascii?Q?/cOFtKAYFfMvNGdCJwLfWzhIqXXNBhJw1Lfn7JGo8qvYAe3tRYVvwHG9RH/r?=
 =?us-ascii?Q?FBzekqNDnN/t4RnBHyc7Nm1jkc6Awpk6SH/gyZN9Ilss/GAVbav9x3Qo7XYs?=
 =?us-ascii?Q?jA7l9IQQVjpb1q9Ead8b0qrBTn8mLoQu4UoZw3fvInJiwDroU+uMH61e+yCi?=
 =?us-ascii?Q?J6tSiBKB0oEP5la3D473rZgNf9b0UbT3Vv9A6J8ZoRzQ+kiIahEYEXjxhBTB?=
 =?us-ascii?Q?ND0934QiGdEXC/oeJ0VrsFMZa5ke1+HwxWNGdKwyK0MLxg5PddEMvCPApT60?=
 =?us-ascii?Q?WzdtRI8URZDKe+8nzEGAMmKd4YV3rovo3u5X/m5Nnt8xMzCk2cG2IanS26hj?=
 =?us-ascii?Q?wtEtWnkm6hi+K2GFAuySXbPPc43BRiNqcokLGZrHm9sB4+l5ONx8l9v3Q8cy?=
 =?us-ascii?Q?t1QJJDq47WFFYh5YAazx8szPgaMz37OOEikQPSefCI6kZnhql56LeSBNvtnX?=
 =?us-ascii?Q?1l7/caSZc+BJ03k5mcBgWmllhhNd4OIxL4l5liew2gmY66VK4SNug1NqNTCD?=
 =?us-ascii?Q?Yiwr4LKmqtnAktD9bQA3Zm9f2rE0UQXU4eAytc0qQ8THtFVYuSDmIXKNPVpd?=
 =?us-ascii?Q?sEqqPQnZlmLS963bXUMeDaMdos7pwLHoRgfzKTDYPzemAtbxPGDK+v9b8DDX?=
 =?us-ascii?Q?nGFu4UrcainM0woKuZlPSG9VJutcFYDQI4d7OLeZLyXPGNd6db17tofYNlOH?=
 =?us-ascii?Q?glSNB+v7WNlH0U+M3cawkn/Cyl2niG5wu7CNpvEHE1wVPCm11VIJ5OcNSm9w?=
 =?us-ascii?Q?qCtIJkf+2+95D/U66XogMzB24BH00kHVNhEkAZCt4ZH3/linCF9vb5iSbmF6?=
 =?us-ascii?Q?Ov8jy3FLC0sNj6+F1cwpTKsBZtZwrafDeYs+NL6TKyCnqeNG8YF4yUCfi4rV?=
 =?us-ascii?Q?o0gwEsZItxqaat48k0R+hudSauahOKMLaAQn9lA/D6G1aphmi7goV8Mux4ax?=
 =?us-ascii?Q?sjm2rR9wXPHOJNFUvMy1XazwRKI6ajuGlAm68yHl7x5pywn1Q7cYSyYdSIGY?=
 =?us-ascii?Q?pEidhw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4b9c496-aa5e-4847-ca15-08db20baed7c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 16:25:43.3283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +fLuhQGKTZpmkHYRafmLpmhMcL+rkAEjMnE6JNy42gn2HMcXvM+tBYn5FoGHbUWpZ8+Xq9TyXeKw+nriDW//I86LaM9ZP7XWGMIqwLJqAuA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5037
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 03:13:15PM +0200, Shay Agroskin wrote:
> This attribute, which is part of ethtool's ring param configuration
> allows the user to specify the maximum number of the packet's payload
> that can be written directly to the device.
> 
> Example usage:
>     # ethtool -G [interface] tx-push-buf-len [number of bytes]
> 
> Co-developed-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Shay Agroskin <shayagr@amazon.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

