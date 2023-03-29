Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC616CDB08
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 15:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjC2Nll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 09:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjC2Nlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 09:41:40 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2130.outbound.protection.outlook.com [40.107.244.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7170C11C;
        Wed, 29 Mar 2023 06:41:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E19gZbu5frkuQWcZi+a22hAtB5uIfSAQntkX7c9VbZUSrFJ866qxvnJMpeoRh2uuleAvPw/msqND5B7RWSAJ4Ngcb7CoDZ+33hZGT526K1QRyoJXso4xYAmHm+xUULTU9+cAObBm7uLWkluo1Z6y/74Su/oS9xCkIACOFSYp0TxaSsONN8qAal0agoi+gPIXWZw9Ex4oyKKHDH1PSos2Fz4IZeX6S5oqDR9p0T3Ng4V0+KMGIwalALdW9mik7X9h1FLa+V7iy0PyJf16k7RGfeUFupOQLY8EJzNHDwUrPNEC7K/bzICT4XRhWMlM/vlsPee+tnhR98sKK1ygOqa2JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xYhLdOr4JCH+8cH4MHMQemhqRcE2NSTuVjYCSVXnmLg=;
 b=JzmyfKFRrpZgx2HD0axrmhby1kF5WevHU9KOHMyFFaizHnOE21MEJhsoCXhraZw+3P0a3VWR20A6TQmcXwnRa1g0cBszrev8CDYW94rE4xi3oE+aA1a09PasXHtncKipMZz3EsBZgfLMCbyOa+faYgQKjoCwDXLOKvCQQRxqJfKU+KfX5bPB1z7Wrgq48a0EEgxQjfGJFPF6dq5tnjlITSvAkeojgTL2ZTlschum+SK/M2OBtN4PpJUmeYexZj10sIrbonQpnAY6U0tq4QyHSfOhlcKuply98Qy4HaHpLPuR9nPbH2Wxt8P8P1/N/ltVcbohkbZDSY2X3MdvxHNH0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xYhLdOr4JCH+8cH4MHMQemhqRcE2NSTuVjYCSVXnmLg=;
 b=QqqyJVsu47BTRNd8hWGaC+ZxIejWKYBRgbYjFOpA0xw1b65/CBTbJE2vY/aFohtk9dFposuitx3Q5keDiPYNaZoo0Apd/QZkunVNeuQ7X3pF4AOM608e3E50+NBkvQbZs6/HzXGak9dyVSRzgFVJUR8k8V2wWUXBrbyjBfPRpY4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5281.namprd13.prod.outlook.com (2603:10b6:510:f1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Wed, 29 Mar
 2023 13:41:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Wed, 29 Mar 2023
 13:41:33 +0000
Date:   Wed, 29 Mar 2023 15:41:26 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Tom Rix <trix@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, nathan@kernel.org, ndesaulniers@google.com,
        petrm@nvidia.com, leon@kernel.org, shayagr@amazon.com,
        wsa+renesas@sang-engineering.com, yangyingliang@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH] net: ksz884x: remove unused change variable
Message-ID: <ZCRABhzLVCwfEgeQ@corigine.com>
References: <20230329125929.1808420-1-trix@redhat.com>
 <ZCQ70Rb311WzqPIJ@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCQ70Rb311WzqPIJ@corigine.com>
X-ClientProxiedBy: AM0PR03CA0094.eurprd03.prod.outlook.com
 (2603:10a6:208:69::35) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5281:EE_
X-MS-Office365-Filtering-Correlation-Id: 64cf0b1e-e9eb-4410-4715-08db305b4f3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fu0Bcd4ZTDzNhRbbXexsu1YdFc4X4y3advQ3YTbgYMD2OnVQVG7qG0WTH7eXuwayKS88bAFRhlAQSSKdDJEhYBjZMF/bk9CmzEULZGvc5ewPnfQSuolxW8OoGCeDoAmSzy2GIdGLM+RGSD+Fnu3MtV6fmzHNaMRSDm6JkplZXDSLg0+2MYVTxQKwL3NW6316XORUzAVyarp1e5HSaMVCLhXB4kIoIH5ar/xHFQL1UWrnHfX41Iqj8a0QJ0Ah4g+EaHLhX1iAqMGEZty5WxiUJOkTNYiFtRdsPEHXhnNJs5Zi9OtS67W9dkz2mNvo24ULeatXdFlsiSfF/OxNkaesrwhgxeT0wzHDExgwVH+O0ZFTAB5Xt4YudCdp5GN7uF+ixpigVd7sc1aYN4osmXTVEQ/mGajnia7vfrqX78fLMVIb+Sh5Mh5cYw3wZAKtsSL7Po1PR/9/38a73WtXe7AqMaVPuBnWNYlMRz569FPnuG1ip/Er5ECOvP8/tiZn0DhZ7o0HerlLoUtQQg+z78ZU0TBQ+LRLsuSU0AkJ9npcYlroR4J9+nL6weeBv9Fcrgni
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(39840400004)(346002)(396003)(376002)(451199021)(6506007)(6512007)(316002)(6486002)(4326008)(6666004)(186003)(66946007)(66476007)(6916009)(8676002)(66556008)(478600001)(41300700001)(7416002)(4744005)(5660300002)(44832011)(38100700002)(2906002)(36756003)(83380400001)(2616005)(86362001)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0vRObrZW6VBiu7UYgXxXhbPyxTRC7nePpmmmt++INGt8MxS/O3hUUajJfq92?=
 =?us-ascii?Q?zAWgHdlRP67452hQ0CA2InIhVUsA7bdnQNebviWVVfYWn0Rrwze2TDbxZVgZ?=
 =?us-ascii?Q?pOG6vWF1krXQ9d4iDQGnY7TwDefqXtIk7F5xOJ3DhGAjCKMasOHbMwiL8f3f?=
 =?us-ascii?Q?fE+g+Wel44Jxw4hFCWy4N123xwcPiz0TMnlVZw0Jfsj5uPE8yZCXFDo/2CBk?=
 =?us-ascii?Q?KYFEvJp1jZEn1cq/hWNmhFUou5wgBa+ZiP5ukAw+vwCkT3YNIPuRZZ2bMXL5?=
 =?us-ascii?Q?Vu2QP3z+vxVRHfZCM9f6w63q5hDqR1lWQnAzTW5yA7lL2lIDZKVTFYrDwZxj?=
 =?us-ascii?Q?LGS00uBvFrxfFTc5SqZEP2U3jBPCBhAM0ilddTVE4HgdFG5fNYShH53hBTRS?=
 =?us-ascii?Q?vbytTWRnylyzqMvjJFRi3L0hJQYoflbPOE6ihd2d5lCej3RezUozyX35MU60?=
 =?us-ascii?Q?54NYFySlAPeNNTBD1buogxziJFSiWd1g8xVViZ28GtxNLLM/Upnglfy493Yi?=
 =?us-ascii?Q?BB+6+gPTfVFCcMSAEcE8Sk5EN57548b+f/6ccyz+XYlp90j+18AnWLwmg/VY?=
 =?us-ascii?Q?HT/MKCd3sFFHkfH/c0vZ9d87A9ErZO9pkip82CR71i7gWvldq1HaiEeqrM5V?=
 =?us-ascii?Q?RXjJ/zRcSW/WSJoZ2pP8nb9+7/NCODlduhG3IupvEndJnG6cBdCgoWT9O8fp?=
 =?us-ascii?Q?eRda3S6b3FvhmH9aNxAq1FiHGWEaEMKJXOl63VsGr3UCOaARvXgf3gsDtA1A?=
 =?us-ascii?Q?08HxK5ILEDpR1u2vODQ8cWnHRIhbpAaVVpBDgApNXv9Ese4ePIvHuuJLbxtN?=
 =?us-ascii?Q?gBLWu8S1GG+QYu+clQ61q/Gou2xbMRUU51gKAE/1HrSV4dy2zDo07XTrEBRn?=
 =?us-ascii?Q?G4OiFBbuQ8DVWCWg7KNgyrheICiH16qOWxhFQNua6pMQvKkhQ44bGtU3Z7V5?=
 =?us-ascii?Q?ExgmwdJVYLrXfsVDVvsrK5z8GoA7SMOsEIJ35GF7rML3iMbJlq0FjqH30dMK?=
 =?us-ascii?Q?Ns2OwUU/csrNLMpUR/FrgtUKn2pTlJ3st50vFUOp0wM76wDIOooJrrcMUTM0?=
 =?us-ascii?Q?1xnB7zs5PK+97NHAIGFMap/lqKRvLC590wZiPJfmJh5R5rwjLjCQFYEzN4L+?=
 =?us-ascii?Q?VWQYXTveQzJ+Fn7mzL0oMP4NaGPEA0YlC7k6th+KWlc72wnO+g1QVZ+hai2o?=
 =?us-ascii?Q?jQ+YWfth6PHqwsIS+P86D7OF3iChQT63ueHKXo/BUnavWBBW+4RtSPBKuD26?=
 =?us-ascii?Q?rDx4vaOGW8BpwiRdDso6UfniW58JbQ4QqeOWTZ0asnz44nQ89Afct0LEZNXp?=
 =?us-ascii?Q?ZjHdEbuChw/8GPXhY7BiHzb3VVKAJYA7EUrnbJwPvGCfxZsEKL59ENPXTQ6O?=
 =?us-ascii?Q?8ch9jKhjnB5yuVbSMCS/2Wo/sGBfgAyYI5Vb08hPNjSNGsFQAL8VSi5jglbp?=
 =?us-ascii?Q?ZlS/vKd0aTW+7E8C5la5ZOvYukLw3R1jEzGDFvR0/Gue2uff0UdTqnf+tEqc?=
 =?us-ascii?Q?SqZR2ro2HSr1Mf+VCWcdZcV/4g5Anjf87z2RSiMiGqNsPLBpQgXYOzREw+qk?=
 =?us-ascii?Q?QkBuFdB8j77FP1FzDihtnKKhRRyXSGn9PiXbY6RMW1L3x1cNenSJ/6iPtPVI?=
 =?us-ascii?Q?fWtwqkGDvmvVN2G8JlOuJOVgLHTYVtNVyTMJWsx42UvvopWg2wdorIXQd9SY?=
 =?us-ascii?Q?aKTrxQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64cf0b1e-e9eb-4410-4715-08db305b4f3f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 13:41:33.4329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /k9RNY1IUUbncntAAn/kyGlfFhGk00NdGTVgtCSoZNCnt2e53xxQHvBgnN0XsWbsizLd/VovCpEuxXrTWII+NhPAfPpLlwQv/zne4AwmHCY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5281
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 03:23:38PM +0200, Simon Horman wrote:
> On Wed, Mar 29, 2023 at 08:59:29AM -0400, Tom Rix wrote:
> > clang with W=1 reports
> > drivers/net/ethernet/micrel/ksz884x.c:3216:6: error: variable
> >   'change' set but not used [-Werror,-Wunused-but-set-variable]
> >         int change = 0;
> >             ^
> > This variable is not used so remove it.
> > 
> > Signed-off-by: Tom Rix <trix@redhat.com>
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Hi Tom,

I notice a very large number of unused functions in ksz884x.c.
And I think this means some corresponding #defines can also be removed.

I'm wondering if you happen to be looking at this.
If not, I'll see about preparing a patch.
