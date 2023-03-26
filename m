Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B95386C9308
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 10:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbjCZID4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 04:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCZIDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 04:03:55 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2099.outbound.protection.outlook.com [40.107.100.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF3B9ECC;
        Sun, 26 Mar 2023 01:03:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FzfdRzkf7lJLk/wdtpRlDNHVZ/vd0F3jfDzYbK9AOJUnLlS4VpuqbjI2KmNzhw4u6HCNDraOxh2RZeArTQRnfbY6fIx+MI788MTviC5T3OXRBjGhj8iDb4X6dkbuhuD/foQdFHqCC1KXTTUnwhSgGL5ZvPucaTu8DC8uzqCRAhIPyyW+hBiHqHJHoLZZHUq6lmwTqRsNnjz9Pr/WXT8Bh1uefnYaBUYrbL58SqkKhA3RGru9asJoT1z8JYnukBkqKZ2agnUrUtdkqtgMffvnvVKOBZm8VlZbskGmqAN21lv/TRlmjo9erSTeK4lH3/nL0TjLO8iTr+EwSMg3vnapAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1q384apwXOgKJdInRSxA4Fg1CyKUyRYJ2QfOtvAyGnE=;
 b=DB0/fbEsZwLYBIhnltbR0m+y8TWTmpyHrqhS7N0S2q/n9Eq1J50Z1kXUpNlggq2afQfbhh76nCCqT/tfDeHrmwOnuJhJLl+wogDOdU4JJuDqx/UmoKglEGljr+djTdEIu/NoGBv65sdMd+nsm96PCDZeUDH47BPeY8IodKbUBtc57KrdHWlNVfEUkt0aucEfBTyGSbOLJFfmUTcNCDj0D3JzHpfR6+ULAaOyaF1v0M8BhCG7NRyZDP2WMZEVPgy7odPtsrKnNJqWtcL1Ye0/Pp2tdxZK6dBb3VWUkSsX6oYZuEr6wlNteO0mvee4wh8/tiX7qDvkuOSzGxXigs+K1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1q384apwXOgKJdInRSxA4Fg1CyKUyRYJ2QfOtvAyGnE=;
 b=IYZTjA7vzwEpUxNZmL9kS9l9sX2OwgSF4xx/2mSYMbZd1wbcPNQSjo7y4CQvkYrIdpYGQRqTZ1IDREH6Vj4cHgLyf6ktmJV6XTIe6MVZwBtZ4hkI6hpMcndH+IzU95LA9qED0IPLo3sLLXY+RfDRlRFmuVG0gRJEthcXv8p6k5c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5665.namprd13.prod.outlook.com (2603:10b6:510:110::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sun, 26 Mar
 2023 08:03:50 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Sun, 26 Mar 2023
 08:03:50 +0000
Date:   Sun, 26 Mar 2023 10:03:44 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Wei Chen <harperchen1110@gmail.com>
Cc:     pkshih@realtek.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless: rtlwifi: fix incorrect error codes in
 rtl_debugfs_set_write_rfreg()
Message-ID: <ZB/8YDQwc6uzHbZo@corigine.com>
References: <20230325083429.3571917-1-harperchen1110@gmail.com>
 <ZB7DSn3wfjU9OVgJ@corigine.com>
 <CAO4mrfduRPKLruShN76VDOMAeZF=A7f84=vcamnHPCtMLGuRvA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO4mrfduRPKLruShN76VDOMAeZF=A7f84=vcamnHPCtMLGuRvA@mail.gmail.com>
X-ClientProxiedBy: AM3PR03CA0065.eurprd03.prod.outlook.com
 (2603:10a6:207:5::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5665:EE_
X-MS-Office365-Filtering-Correlation-Id: dee9b8ae-f66e-4209-f6c4-08db2dd0a21d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9kkvOHaKwcaTQVRLafBzcoKrFpxoH6eq7b62a1AxnckjburVNyXoI/vtDEBlVtj9O/Hck/khgAYIOpgKVXLgKuc4fVRaZ1iD4WrnshF/sRxEP3+/zdBGQIKuzgBRkurJA8xmVpw2Qnm8WyuNW6vzq5hQ+m6j17EvXJTsiuHSDQS7wBzztRqVkO0h4Df9ymWtq8FsYP+4CVgovcRSRIfnWoiYI9+6mBLIaK8DQaJHMqupg/tme8f5LV/Js19evM7CaVCURUvQiaAJV9Oiq/KXs65KzQSJWJ2S5nGI8zizgBmIu5Vvgnu5i/bfHWyn808OKzBX0aUUEboUMiJegBbpVnrV1k8ujLzo2yz7TSN3TOUXi0WDWG8aTqzLO3wKiSXvZjP1ENWpY9iG6oN25LL/o0Hp2PPdZFpkKt3UMYQzTf1x9XUFDgyG/jGY/lWLwDfQpb03Q23ekco+jccr3hc8HOy3lxbJPotm3krJCqnN7yMEEWuj1jxwjTyLmAvZKoy7bjeYKqYEMQD59Sx/CE5ijPHmyw1afXlAIVS2HpNDv4wMhPgkhGUUUgNP0lBXVLj6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(346002)(376002)(39830400003)(136003)(451199021)(6666004)(316002)(86362001)(83380400001)(2616005)(6506007)(6512007)(186003)(6486002)(8936002)(41300700001)(44832011)(38100700002)(36756003)(478600001)(6916009)(8676002)(66946007)(4326008)(66556008)(7416002)(4744005)(2906002)(66476007)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0vzyQx6CBwlaH2aYSS5mN5YuBndV27hsRKMcTL4b5Amap1pT9aBeU4u4CK92?=
 =?us-ascii?Q?cnzqkHOD11Jc4RhCu0h4koffVBVZ8cPR6btFP92d1ek9iXjuoiTElPxUeZok?=
 =?us-ascii?Q?F2nIgtgFP0Hsw2B8ohFnQ6/fniVkQvou1l3mXGsSh5KRWVinxnBtT7pGhtu8?=
 =?us-ascii?Q?ZGJi6yDIDvbbNlMigbZmfK+fZA/y0tuLKe6Skab2AV4dxxSJGQ12ZjNxz3Q2?=
 =?us-ascii?Q?aXyAVeJTqfWoj+P4RNDy4ARodHiaWxg1/Fq7YIgU/r+Ia8hncBfIUSmVwLFO?=
 =?us-ascii?Q?64WvTmjFiQhnJQPBUKOqMh/OIAnGioGCS+zyBdZs4uh7e0I37AbLtQ72LznE?=
 =?us-ascii?Q?QLp0cXUvbHDCuNIjxiSRwULHDuqiw+BwvleqPCYMgSJN4YcGgu4dOiIUlYQk?=
 =?us-ascii?Q?XyM+1h3tx8lQIanCT3cUV8mDoB+TpzY7zbulutdEHbH5hdxKAyzkMUuXYds+?=
 =?us-ascii?Q?g9aGux+LFOtqyvt1cXdaLFbSRCC4hlawyHILmzjvnr9iXGg/775FfGEL4l42?=
 =?us-ascii?Q?ql8bNcMYMGCSXasA9aRIE+3pSep1ocCXtqTDfpKXptlc4xOqtltcm/zzkAHS?=
 =?us-ascii?Q?qPcFYJC5fbmKH4U9OQu77/Y5kudvSNvdeehX2GUhyFK3RLP0HHC1Q7MjxTaj?=
 =?us-ascii?Q?RKWpKwN+cO/BmfUKP2NwU17fnfknBnyp1W2Sk8hvBjsmC4x7bk+fxO4NtYvY?=
 =?us-ascii?Q?emElME/fmbhjJIWS4y+kejTyc34nawE9wHBqIcZuK2JE+j4OUqsfjW7DItPC?=
 =?us-ascii?Q?QIRIwvJp37tnD/YMsCdjGXG8jzQU5gPpdtsWy20h4FqlyNczH+gtKe1vVNOm?=
 =?us-ascii?Q?M69IayGc6H2E8/xcFgyQXeI+nQZf37zgbeggvsePpX2ArOcwwlEifrURORCV?=
 =?us-ascii?Q?ItYZsKFeGfdt6CE2BzQ9rGQmbcZDf54Q76TpdqkS1lMTheSbtRNpB/ojQ3cv?=
 =?us-ascii?Q?nsC3Jqwhy4c1xB5kyTMMHbrr0hu5Km7l+emxkQyskzh+VRQLv9mBTslwaqJH?=
 =?us-ascii?Q?bbeO2PnzneddKhxwfA9sreV1V+jEJsyCvJsEyDxjKdQ7XhAySVgdArUHNL/X?=
 =?us-ascii?Q?9EujBrp5acqQ0r47dj3qr8zFLNeKDog/gK9aqtpjdFCXuQvmDtT2pBtrDNSd?=
 =?us-ascii?Q?1xojCOE0o0OTo7iWBr/S1dcSNAfCM95kQHRwgmxy03n3H3FBJCXCZBi3p2S3?=
 =?us-ascii?Q?J/bS23JxHu4iUijE+A8+aUJ5Q8ovkd+crXOJJIMtdPTEpKftYWX+7YQJ9LCM?=
 =?us-ascii?Q?K9qWlWXukLxHvsSGtkFmxMvC8EFfN5jhTX1VKf2k/LXqnvH5xenGwWK28amm?=
 =?us-ascii?Q?okvL4yLlwaHhAvq62AZFmWnmMDtuLoCEp9XL8p6PVMvMUXpx2oLHKJobzOsG?=
 =?us-ascii?Q?YjxHr1ZhRJP61bquASBEPFykeyG3G++rDAjMcR2QyJkC9m81FkPe0njA+Ilr?=
 =?us-ascii?Q?tDh/IKmmJkCAxR8spIZyuqIk7BdVwEAzHPcRElM8tPpSIFrrhWLVW3E3h16v?=
 =?us-ascii?Q?m2D/dVKPI/GkX/tePDvNYvcQEXxcZRosqFcvBmqpsO+wmHbK+2+4kCFkkomt?=
 =?us-ascii?Q?tBrk6H4wimqWEI9nUjasG6IIPabj8y/2/VaKFvDRMv//XNa2Js3loUbgqSO4?=
 =?us-ascii?Q?s+D6J8/g8+xyXwOx8gbZKU9JPhnMBZcr5ikl30snbxIOXvbcInAqaQkrnIYz?=
 =?us-ascii?Q?uDK7fA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dee9b8ae-f66e-4209-f6c4-08db2dd0a21d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 08:03:50.1017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lsOi5xT9fhTx4jrAHu7pkOPRNbNny6Tt8H8PDicNBBAx7kf0AhNuQXbKrrErnz9E647znbxpBQem/Q0IcdZq2H7y3e3YgFBKneM+e18mLkA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5665
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 26, 2023 at 01:47:51PM +0800, Wei Chen wrote:
> Dear Simon,
> 
> Thanks for the advice and review. I have sent the second version of the patch.
> 
> Besides, rtl_debugfs_set_write_reg also suffers from the incorrect
> error code problem. I also sent v2 of the corresponding patch. Hope
> there is no confusion between these two patches.

Thanks. I now see there are two similar but different patches. My bad.
