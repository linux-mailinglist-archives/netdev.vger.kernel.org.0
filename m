Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1A756CC9C9
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 19:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjC1R5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 13:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjC1R5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 13:57:24 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 239F3EB44;
        Tue, 28 Mar 2023 10:57:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R96V5Bw+6LyFckBrs1B3mCTnuSQ3wEtX257BpplXqVcxUSQ16kABN2eAgPO5BT4CdjFkbUNPOx2HzCqUTcBATzdNBjYVWk+9P0nDjGXtDv78iDE5tS9Be6ru695lNqU5EBhiQNK9l+yZrYrxjorHPIt/pkleTk1+4kULAWhjeYBDasubQfp6zUt5XB3IvJWuixMRP4ZbMnGdiK/nxQmPngUV6ijtFHWanD2CfWZ6wpYdHvFEj2aoKs4k7r+KRwLTjNpQfA1f3Jsoqsc8iGGHQfXNRBEYjEJM8qXY8pOBWcHDzL/ZVa36sqZTS4ukE0+yFL+uXOx5zgfuDpBH7d7PYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jZlOeWS3n5N8yOu5j93oakkIWGy2EppgQTl53ntrAZM=;
 b=Gipu6OdHW7ajP7AVMexzwa/yrwNW8N1vtbUcmBu4EWhgjF4+544ISJhI8nrLEvD+1+zEF97e6fxqIvB1j7OqZQs1Ur74hskMWaoHUMTwMAFxBpnaP+hGO/GVuT3jRFqHBCwVak2680ADNSbksBdAWosSjggOt5ZwXY4o3cB5kKuXq9bVEb63pHEAxfI90+zGYsn1mXnjfGacRM9tQ8+M9L3Z4AtFuesqMzxc0Dq8pZWa9OFnbhz8RVzW2hkYTGsIZQMWhziV99f8VMq+RUg3V7QugcaF96I4OnP2EpZ5pW7NTTvGHNAyT5kOFZUtmq1eEkOURBZEk0uxwSp3DEHGqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jZlOeWS3n5N8yOu5j93oakkIWGy2EppgQTl53ntrAZM=;
 b=iqKXyI02IrAcUUvQ+c1GSJPPozO2vkQaRmZdYcXcZVXPw5o4JMsGJGy9rcWAmI+7pFLT64/MnTSA7/71/VtzYz6joEYDKsLrOO0Mx+9kWeGkI1l1p1r2yixS8RbiwtzRA1kiW5VH/6wxgXbj+gT+Kpq3zH7aLzVwwvK+qWJISDU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5592.namprd13.prod.outlook.com (2603:10b6:510:12b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Tue, 28 Mar
 2023 17:57:17 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Tue, 28 Mar 2023
 17:57:17 +0000
Date:   Tue, 28 Mar 2023 19:57:10 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Tom Rix <trix@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, nathan@kernel.org, ndesaulniers@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH] net: ethernet: 8390: axnet_cs: remove unused xfer_count
 variable
Message-ID: <ZCMqdkZI8SyNIxWr@corigine.com>
References: <20230327235423.1777590-1-trix@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327235423.1777590-1-trix@redhat.com>
X-ClientProxiedBy: AS4P190CA0031.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5592:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f4b53d6-881b-4d81-6742-08db2fb5de58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VMZ8oVJdD9K1vEVpwPjLluUVdNDUtkxTzxnmSLf4edQCiTwUY8oWewp09OnIHB9uj+72Hjq+1676YnJu+ZW4FpKoCd5wIawDumRZ7exHDXx/lHa/O4W0yiPOAOwcQpnC2u97OwkLhI1rrqdAor9EbYV2TmmMWvvUOtXsU1k35cmc1CovJBCbDDwT09rQdqr0Hvbd7cyuG/SGD9JUfjaWL1DZhas3yYEqpWRA3yb6PKaMerziNxidTgFbt7/pdd4YqMAxeAM0qFx+4GhnUWj8UONYXM302usdxR8bQmFeNx/BQ5f5WRvhidl/wqj6HtSz1zdIE1Nd6NTapKNzIK0FaAv/o53WpUkvWb9YqsnmWxsqkOFd9zUWGqCbOphK3naNuQ4JS2Njk3YchQeEsOyKmBXedFNZVF6ft0DGNE91kzubvm606wNocwkyL5bLz9GNtcOSk3571jdKDu7KE8j6wGu9GiGyYX1nzjTmmX+ighsXls5Wo/W1Zj6q2Eek8LzsZ8fFGshNmHeiOfK36pvqV7aMU8ncYt/zasSsrfSKdK05CeLb9KOtIL++LZVCEwFQYqwo7eTa3AgX15JyBf3+j9sf0vuH6fUFSmi/bvFZ1Bo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(346002)(376002)(396003)(136003)(366004)(451199021)(478600001)(6666004)(6486002)(6506007)(6512007)(316002)(8936002)(8676002)(66946007)(66476007)(66556008)(6916009)(41300700001)(2616005)(4326008)(4744005)(36756003)(2906002)(5660300002)(186003)(7416002)(86362001)(38100700002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bavOMYO/nkRH7w7uDvu7Pq9TK+YbNfM/VJ6/JqmacVKzif+uphlbE5AHYWct?=
 =?us-ascii?Q?oIKb8k54LBhTXUUNYpSj4prwF6tcyfTMDwAPoAubTAJMeCPFQOoFkQ8loohd?=
 =?us-ascii?Q?mNIdtdmnKaUvSK4/wvedmYhOrPFo2Gay2YItSXTRoI5b3EvhXan1nYTdprCR?=
 =?us-ascii?Q?vn6tcgWxWLmKX72nBLL6glM/51La88j1VYleIgY+SNoOZIHcdgXWWhcDaTwi?=
 =?us-ascii?Q?efDvskoy4gITn1mmIMqOsGhAp/zp45YcGwglX09FJ5g+DathFskxeLZsYBRG?=
 =?us-ascii?Q?C5Lc58ct21a0ObKG2BfsM1t4SL26MYXiBn9qon54N+EbWavotMLDi8erSMw8?=
 =?us-ascii?Q?VgLMs8A5qDmoPy4Ml5r4Pjb+38bNwzjA/HJbPXLLAUVewPrtocDJd/Tf8hJA?=
 =?us-ascii?Q?4IMdMT5Q9xXy/IqxV7Op9s7PMxwTv0hKxUpqKpbBx9jpHXB6goYj3Y86Q6PF?=
 =?us-ascii?Q?iHXLPydT2AE2PFfxYqu7ZmfqtPTZd3aNcE67AItcmSO9B8Pvj9y/weMk8u5Y?=
 =?us-ascii?Q?6Vj48L3o/OtEOAU/+O0OrvYjbG/4KwnpcDBHLJVrgNKg0hxw1l8VuFzVu8Tf?=
 =?us-ascii?Q?+MDbwlIfjznxiPCljllpLenY9oqIYs4J3tGDU4cdyV65uESnAfRuwQNsIPMk?=
 =?us-ascii?Q?GuungqUp1kqO4ZY6ODN16d4o3rvPD1z0K+pqgZLAfmW4NcCHNSORzYiFFJUY?=
 =?us-ascii?Q?etO72cEv3rGSKxth2tDv/MiZgyoH90QDwYWIjemoA10ChUOxSElOn9nspAss?=
 =?us-ascii?Q?gRxs43PEpt1sGh7q/Z248Nse6/1D46frSOi0P/D66Or8L3f1/FpOsMO38C57?=
 =?us-ascii?Q?tSyLZB7IC/uiQYWWHln9/qvBceM1NtstwybRQG0OqTgrVbaRUUu24dvEkMlY?=
 =?us-ascii?Q?2LEnRTRA6xmNGtM+z3tXEuAqqXAVEZFGSMrojqg1MR2FBmCwA+47d0c52CPS?=
 =?us-ascii?Q?AYKI6OKbHN1jczRBoEuOuCa5xr2owYeJR/X63tr1HJ4ZNIl8/Sad5nzkVccV?=
 =?us-ascii?Q?+zbOkInnM3kT65ZeCxAB5oAwNBdYIfx4dJd/jtLm8sg6tqzJHk9tYjeH5pyl?=
 =?us-ascii?Q?vSAWsUKmS0OuwgdXzt6mXijbcprPoFOFrisSuIPRuFb3QAJ7X2IGEM4A4Hit?=
 =?us-ascii?Q?Q/VrVZOzLIKAZXm/wYZLcskyuouwJN1dY97WooYNZLq5XmAITayYhAEH9bmw?=
 =?us-ascii?Q?L1n8Nh3X27sRNFMZV4iCH6RN5Ac6IvRSJVF/teKtPAlQmrNxe/aaCAWQ4//L?=
 =?us-ascii?Q?7oq5kkQJliTHCFETBLnnqEAqW1t4hr5fiY+TQ5Jw3rZV5B70akBKEt/PLW7+?=
 =?us-ascii?Q?1FCjxUIKHibpwkOvGzOUbVJhRwzBy5GDUSEsKUtPrLHsM7fvzJPgbAcw3OVU?=
 =?us-ascii?Q?+TKsHKi/l8d54M7g8aFczbpEHHZnsofBJZsEr3JXT5YGEqd17hHiefS69scB?=
 =?us-ascii?Q?XDYeOXreefw2ziujjAUEgHz2jpO7UUljqBjlXPA3SBTQn1pmb1LNVm+Ex7Yg?=
 =?us-ascii?Q?7+VVwDFofRfvY4yrO8EyMRddS91huwVQDjc5LByAiVko8TSeTerlu2nIGzVP?=
 =?us-ascii?Q?FGWlwoevzLh1Nk+bBbKeICPyTSZcbN3DkAyRrIbVfDJOjSh1pEupV/h0fTk7?=
 =?us-ascii?Q?mwf/qW/T5saxlkH4ov6fXkYspJGjYI0hz4LFANtrSglG/nRq3dtBcI83XUKv?=
 =?us-ascii?Q?yqIqsw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f4b53d6-881b-4d81-6742-08db2fb5de58
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 17:57:17.1849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ex5BjmBW5HCFJzrJ5LRE/GLfTy9qeNxVBvJ8NnzlseimvEcgoz+ZbJ5KPZbJ0bgUHmeBaqR2d+8VBvjgavITvQxu5f9hPYF7QRj3xq9GHAQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5592
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 07:54:23PM -0400, Tom Rix wrote:
> clang with W=1 reports
> drivers/net/ethernet/8390/axnet_cs.c:653:9: error: variable
>   'xfer_count' set but not used [-Werror,-Wunused-but-set-variable]
>     int xfer_count = count;
>         ^
> This variable is not used so remove it.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

