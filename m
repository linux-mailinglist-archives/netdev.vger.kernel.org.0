Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCBA6CC521
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 17:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbjC1PMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 11:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231381AbjC1PMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 11:12:22 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2072b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7ea9::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2944FE1B4;
        Tue, 28 Mar 2023 08:11:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JD/5KE9Vf383SxHMdAkBwNcQ7uQD252Q3M5d4o1PpGyWIgHLe0S05r3DHWlamyVidQP5AxeMkxahtwz+YnS2YUu6HcrarkWvlIcwkW841Cw3fxKiR6XUF9Ex1B8e2w0uxdJYUJHU4jtb7zj1NYX4W1kB6opB7nEkAmm8iIViPkqH8IoQWP8DtxlGblWeRPWkRbhG9KP354Z9n8QEnMLg7Lqpy02yYRJ2IMq0rELC5/8d8zxHGxFkuBfG4YMx8VrfbHWKeoBMtz4dQ3bfdO4ynsLzS/sKBfdZ6f5Kwqp+ihcHx2xKun3Rv424K/MstrZOF9DdII9Ghvp+NZF0nOGCGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LMgZGM7wytGSMAYnt037zHSvEr+Vrcs/rW0M2wP6NNk=;
 b=PIb3X7YMFHTcsrfO3qdGbjBbchbvmxt8ibNs4TuonGfItiWWGqDwSLlLsH2ril+G9yp35A7hExKDVS8D/C06IGjLQGDxryXRIMg29k/dQ4RgZaAqv9qZwPK/q+HBCVcZj0vqJfIti3DUdWUdA1Gia/U913XZP8pRl8t8CxlDR+tDA3MdaxwXd/jewouvoucnMgmhmydG6LEj45KCZfgx5oP2ivcm5CZQnmJkTSUvSi5mZbidRBMpRrELGxc/cWmhtviflZN1VnFeKIb3Fn+3lImstG/J+pa/E5CfPn+aM/WoYQjzeOIlfBaqAd9EJ6ArNpjYzozEX7syD5Qy5ii7Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LMgZGM7wytGSMAYnt037zHSvEr+Vrcs/rW0M2wP6NNk=;
 b=Xvpe2wBJ5dmfDEneSkBLiztMbpetcphTYiLQHfUYz7gtV5bkxlJ9Y9txxVPMC8O1FE1N8NMmhA3glH0zhvCQkOShqzSlsorGUEUo48a68+Byk9f5ocqqupCRAVwnfG1wahuIVx40YmX+/TrJWDhcb/MEYDDJjYmkdkeJy4dMXiA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5696.namprd13.prod.outlook.com (2603:10b6:806:1ef::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.32; Tue, 28 Mar
 2023 15:09:56 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Tue, 28 Mar 2023
 15:09:56 +0000
Date:   Tue, 28 Mar 2023 17:09:48 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Tom Rix <trix@redhat.com>
Cc:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        nathan@kernel.org, ndesaulniers@google.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] brcmsmac: ampdu: remove unused suc_mpdu variable
Message-ID: <ZCMDPJOMs22Ba7Zf@corigine.com>
References: <20230327151151.1771350-1-trix@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327151151.1771350-1-trix@redhat.com>
X-ClientProxiedBy: AM8P190CA0005.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5696:EE_
X-MS-Office365-Filtering-Correlation-Id: 94f48d73-da9e-4d3f-e601-08db2f9e7d92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6rIm8OGG1k8GWfZ9WwLNx/Zp/qw3vh3orhSkb1+i6WhiINa/4mj++/9PKePMUDardKeZzLZiKbxsZWHmdFMmddppG7/idqF7RWXYW0UOB5xloZs9233nOt7p5WZKOKNRsSceBAUYneFq3YGG5tXF5syzGcQyoYQupH6lAcAdae1R7Uaaci8UJXZdp+N3xXqHGVr/lJmg38VKF2OExe09klWMPyR8Aw5bwK0qgG36MxCCAeFZHyYjTmARKoQBbKHc0Wf0Z21f+UBBb5Sme1BHKdvl2tLXLpCrwyoG4LrD/1kJyLdyHIj3XjMyKVWL1M5+dnypdOB1m3M9ihXmRFLxl/EF80zaNYkETlx79TdLps2pGszw8fe1gE2HY34QihXNQKYtCpeJUIJ1ezthNyh3uenWNR7rsQyp0iTPY8hRCZQFgQEysjnE+KPNppxdK1OB1GHdijFMgTQYGZbE8tN0ngbPX+zVVVeJrx8tNDrl39F3V4sgyxYTdko4S3G6p3NaMhrP4eaWfxpxvCP0QuzPSoofKqC6UQohbCyhSVhaE1eUfKWbkEW3TqbBqLNq/6sR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(366004)(346002)(39840400004)(136003)(451199021)(478600001)(66946007)(41300700001)(38100700002)(66556008)(66476007)(4326008)(6916009)(8676002)(316002)(8936002)(5660300002)(4744005)(7416002)(44832011)(6486002)(2906002)(6506007)(36756003)(186003)(6512007)(2616005)(6666004)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?drUuv19pliNRjPaKHU1gm1DVkzT92l07Cej/F7c6BUonZ7ReqZVVRPUOIf6a?=
 =?us-ascii?Q?rAjiV/uGY4XQGAl3GJ5XZoBdNgvBelKLyUVtNDTlzT68j7kaS18hmge/bg+k?=
 =?us-ascii?Q?D0SN8KxkA8Si2NF01lTwslD3g2Rc1RLEcNDSR+igmycp7lQh4pzN1WGEwjb/?=
 =?us-ascii?Q?RnVmnz8UQL/JJLWv4SlOgsnDrt49ch44Xj1xF1Zu/IKLVOgcOoCb/fX9Lwq4?=
 =?us-ascii?Q?zH5oFeu5o3GkLWPdVjcUPkV+ZO0JM8PNtl6AsSe5BjxX1o/gsdJF/fVZdbPD?=
 =?us-ascii?Q?xBAB7uiYXCiNdLnUqUByhCfMdNhey5BfE8OFIHYY6BJRw4LqaoWT2m3e14AI?=
 =?us-ascii?Q?q09Wblra+MCasgRulN68BQQLN1wO0AmjbGI71cFso8yMCi8qtmKRYLDFCuQi?=
 =?us-ascii?Q?ZRrdjLSGU/d9LaHAiUWBDmvJb/IcHDsfjp+rRwCYG+iPn6+7HUuhxZHZiwLj?=
 =?us-ascii?Q?z8rIkCqNgLDoOWM4rE673ID4esvFv6LeKHCXi0IVqhMtdxMss0Rv/1aC7XjZ?=
 =?us-ascii?Q?uNoAmNW6CfpQrVC7Cvks8XBiviJte+qDHOmvtuv4lIMWkv1+mCC21St2XVYR?=
 =?us-ascii?Q?JolT21YzpyYDUfbXgS6MPI/4ctHEAtCGivZKYsjyxRpW25ig1f8zfKSCT9pC?=
 =?us-ascii?Q?53QIiqhHteRBkJ7rXfKJv/izqR7lIgMBoFF2C/NDrILPe10x2aOhzFb72Ghf?=
 =?us-ascii?Q?G7ACEIQhWKcQFU7DFYiYupQ4sCCw+UPv6xcjTuhOt+FiPU/7UlqwQ1Sn87aJ?=
 =?us-ascii?Q?u27ew843voKbMmPUD2uU/M3VW7ykyL3nLr+cyGL+hMkBpGCuhZTM1gvhQuY4?=
 =?us-ascii?Q?c/Kzw3vN/Z4LOSuPXpuXZUYDToaa/3V15WhPPtWMCicyNbvySN6FiThU5mgT?=
 =?us-ascii?Q?loiWRiLX/+Fr6I5+vTsbV8TnSl35V8UwL+GwN0VYT8qNm9xA7Rk1nEHqj6oO?=
 =?us-ascii?Q?U3zn+egbrgIiUXxdz9VJeSrdK2LVH98ysIB3elyKmqyfagRW7MLjKS/iMpwE?=
 =?us-ascii?Q?z6x4xtFlPC7z5aKFXYlzuYiXOZbR+qmGKOCnxtgL/Hagp/Sjv5Ima87lblzi?=
 =?us-ascii?Q?lRmxt0Tt7QJSQdWHFV3UULtnjS1rOAaofeR1Ip0ocemE9nsqZf/yaZoXUwUA?=
 =?us-ascii?Q?TIXhqNbDutQ91NGFF9veycAfEeHT/x6lNjYiKdiuEy3dShkRIaTrcmjIkpiD?=
 =?us-ascii?Q?tBFAwrxErpAPIWhATDospmypALjHGec+u52xnUI0f0jdUfclpur2uLIgYGbG?=
 =?us-ascii?Q?iNB86o7qr0UzeiW0GPvunLGWeF8CGmZSFy83nmmFrGlVKKuOTQ2NGcbkdB+s?=
 =?us-ascii?Q?QS7C9LU20npW5ixoW8fyBIPcGH6qLDqkUZ+S4k6nCvacrhcUriNRz0rM73S2?=
 =?us-ascii?Q?h39Dolju+bcbBz+XVl1QbuZbDP5Xn8f13Igvay2sFwJCGJfsvZC5fYvoPzLz?=
 =?us-ascii?Q?ucuhGVgNMAkIbTytHDfwKWS1pHytD5o41UPnnHUU2AR271kH5+XovEgtT+01?=
 =?us-ascii?Q?7IYE0wUPywqDrLsDYrphfAwdtjwHLkQ6eE/fpOY9qBDqgFaot3FVVMzSYuKW?=
 =?us-ascii?Q?Us1j9iHBYg15zVzt6540PiVo+OyvA2G8QhAVp8BMOeuND8mZrpRxJDsT9aEH?=
 =?us-ascii?Q?H7xBTxUgihYpjL+KNtoOlHQL8X0SOC4aCGvc4bB0Up7RvX7cOv+oIhO8bAza?=
 =?us-ascii?Q?HjqASQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94f48d73-da9e-4d3f-e601-08db2f9e7d92
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 15:09:56.4092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8zMUh+BxafFVYwOQit5O/2JI6NHgJXjApghcFxAC6/waUtKV8eiN+B8xTi+G3niIDSkmI4l3NdeYwDsJ5+fI1cBxZqEWEMWlE5ajZAcnY3E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5696
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 11:11:51AM -0400, Tom Rix wrote:
> clang with W=1 reports
> drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c:848:5: error: variable
>   'suc_mpdu' set but not used [-Werror,-Wunused-but-set-variable]
>         u8 suc_mpdu = 0, tot_mpdu = 0;
>            ^
> This variable is not used so remove it.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

