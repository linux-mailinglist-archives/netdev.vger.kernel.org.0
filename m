Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5675FD619
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 10:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiJMIWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 04:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiJMIWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 04:22:10 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2071e.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::71e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40223334A
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 01:22:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eIfJhyhaH2mtNn7lhRCFYzQjUPbNw+Tan4JtIwqiuPZSqm2TnVQMBwIuK7yXvNI4HyNu31CPLt+aBEACSGu7uuXU+oQOA/aukEpzC2LSTfY53lK6AjHxc9uwzES0vX1W6DXpYKw9hb+1uE23w/bNMf1uj4mYHx245GWpHDdW2Oktp38Z6z4AqP3V4aUnEl/SZc9j+eNE7CL9A4Onuwax3oEFXhLQxYfZ6aU/SH+P/b8Xjwc/PcRAzGAcotBDhPrQ1S0/1OMbyrhnOtbZFpYJw9NBg8DgoMA2sIK23JyKFZUucVPFgi1GKDKvSrvzpTXYi7ucVwnL+adQHaIQKR0OFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6mTw7zZ4nzGketSGG5dEIILF9s8JEH8+1HHCCnrQKpE=;
 b=MS03nyx+Wdxg9L4v/e6j/BstK96AThCxMU5pfDgua3CmUxrTYgyOVnGfNrmW5pZQwuiiCUXa3ACpFrqbP36gZPfvZyEtKsig8+YhkBoR3A8mrqFzZIGE/OdjDtOpIpOZ9AQ9y34YzO5sFKkOb/vjVAMTol25Fhjf2SpTl1IYFIs1oq4MxJMY9zyDZEi61xp3xrDFBeA9Fu8w9ZdsmdIWC5dyOpLDL8Lgfs654H3zcNJIoEX4DqK3S1nPxh2JnXB4Es8DLzzzA9wdmsb/gm361FZ+8R5L/2Y7cBnkHCVCm+tP3YGax65PuFfROgNub9gLYLB9U9OvKiec4xvfqDuCOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6mTw7zZ4nzGketSGG5dEIILF9s8JEH8+1HHCCnrQKpE=;
 b=q44qHa//ZQaPGt3dyUbN8vyoExL1mT1z/jbGudYfO3eQJvv4tpLeiqQQ8y8tyxtMZN51f+alBPHipMYhcd7L/xQDcC0XUqNx2enBqV1lRcmaPke8Mn+1Gj3FQya1LlZhdsgtkScomO+MAOjZeY2viWFrgHp3cbFT8gaAQpREd1c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by SN4PR13MB5811.namprd13.prod.outlook.com (2603:10b6:806:21b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.19; Thu, 13 Oct
 2022 08:22:03 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::3442:65a7:de0a:4d35]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::3442:65a7:de0a:4d35%8]) with mapi id 15.20.5723.020; Thu, 13 Oct 2022
 08:22:03 +0000
Date:   Thu, 13 Oct 2022 16:21:54 +0800
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Cc: chengtian.liu@corigine.com, ;
        Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com,
        Huanhuan Wang <huanhuan.wang@corigine.com>
Illegal-Object: Syntax error in Cc: addresses found on vger.kernel.org:
        Cc:     ;Simon Horman <simon.horman@corigine.com>
                        ^-extraneous tokens in mailbox, missing end of mailbox
Subject: Re: [PATCH net-next v2 2/3] nfp: add framework to support ipsec
 offloading
Message-ID: <20221013082154.GA33254@nj-rack01-04.nji.corigine.com>
References: <20220927102707.479199-1-simon.horman@corigine.com>
 <20220927102707.479199-3-simon.horman@corigine.com>
 <YzVS5IVrynGFYXwi@unreal>
 <20221010070512.GA21559@nj-rack01-04.nji.corigine.com>
 <Y0UsS9oxEuac8fmj@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0UsS9oxEuac8fmj@unreal>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: SI1PR02CA0054.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::13) To DM6PR13MB3705.namprd13.prod.outlook.com
 (2603:10b6:5:24c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB3705:EE_|SN4PR13MB5811:EE_
X-MS-Office365-Filtering-Correlation-Id: 34a5b06a-7a9c-4479-1148-08daacf40248
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: imkv5Wi/BCL7rrhhAkvJiePtrF64Rg2O8bjC9svL8TZy82qJL+X2tO8z355XkKUWR594SKmHBazPehMKX7z1K0wxE2gKirTezYpqnoyskfUIgx0M+vZpxG1S5KvMwVA0hRsklHBt+tNqC6rxnO7cx8eiQdsrnG4BGxpJg0um3Y9mpvWYzAMFJxHCFowRoHDeQuIjg+jB/EgK/SqeAQ2RCZ9TSIlzl81TOvbScPJjmZvrLSKKgG7S+/NDCvgSdT1MpOym6FBD+Sp5+YOfKKR6nBtZY+j1OoGMCx5GMB95NsEH5htIl2nBbVaxcZsibdkAjGKy+smz7dm2lGlH/T3OzRhUPX33ki18bfzs3OQ8X6N/Ejev5/tDS8q2CUhArGjmb/n0H6dNlHTj9SBCeHunfBmyjpat5DEUzY3LG6egp0oWgeri+INEQcQcNkaSA2PQZn7REUDfAV0G2aRk5I34kvLjRKljt+KAGOfmb+6B4FagZ2W5pnsVIsfwUupA7cx5K6htbFAYnpsWUwrIkFyXXbxYPcLU0OWCgOgkpWRT3rcUabrGJNSyClvg+1cdDSGeCRelmGVm2Epdi3QVWqIMhsDTTQbvqncnVC1A0Y5yJ1lscGB8xB+veqI10BnmZ13nTOV7dHxWehmFsgcjH6ksswWLSJhrqzVh4sdC/OaHEhsuAYRwVsTS+HDXFsL9bzn6El6N2zOl1W+ZgmfhViikvkM8t8JKibjqrFWomV6SvqKkHO4IbGuE6XCK4X4YosKI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39840400004)(346002)(396003)(136003)(376002)(451199015)(44832011)(8936002)(86362001)(41300700001)(38100700002)(5660300002)(4326008)(8676002)(38350700002)(66476007)(66556008)(33656002)(52116002)(2906002)(6512007)(478600001)(186003)(26005)(6506007)(6486002)(6666004)(83380400001)(316002)(54906003)(1076003)(66946007)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rxidjaTUPyCxTQVy3PFX0uiaDn93s312pLSeLLBXwB7Q7Bw3XBA7LbHCpauf?=
 =?us-ascii?Q?Rhx3j6ccbDjaJfKWxAbYZnadWjR74botBAFK7qQo8tIyUGRP1KNs6VebpKze?=
 =?us-ascii?Q?Er9XuK1ZmaGlnjXYca99ceJqQ7v0o69ei792L18XsErFzS7hxaNMD6jQXZGY?=
 =?us-ascii?Q?PP1d7M9PAWqHKn+38xC3CSk+HAAXaVW+BDX3mQZghbuzs4Wfda8FZRx58IPg?=
 =?us-ascii?Q?zOVwSpCCpRJfkFNDOO1198+N+/jL8ir2ogJvRRHQA1nASF+azCOfrQbio1vQ?=
 =?us-ascii?Q?Xrgj+awEZS8PIbm1uN2s/uzY2dAsJMSLOXD9URBU44DrW4z8cPMrUnOMCqrA?=
 =?us-ascii?Q?9Kr9lJYTzIuNt3HnXwbXEsIw4k7nFOYEUtwCoWKp5NBGVkEQSJAYH4rVRr40?=
 =?us-ascii?Q?/g7oWLIdJBqzWyCEH7S73TRUAALDW1hvDtGQiMa6PUYkXH+9Ook2uFbPZf5j?=
 =?us-ascii?Q?4BNbuG3lny8PGwl6A01TQi1Sk1r6XzXHESlXwcj0SGXM5NoeGmc4t5dkNIiv?=
 =?us-ascii?Q?gUVNGxo85mtg4P+2EGCRGCTscrafJBtaP9hM2XRQ6hXOohwnQQSygCplmNk6?=
 =?us-ascii?Q?dXYarvrV1ufmI0awOHvTmbZi7jOrozmuS2M5CHDNCqQyGZNRlVUXyFEhko9z?=
 =?us-ascii?Q?RlLQQ+wUPEC/BOvzKOkcIxfn5bq8u1VabeVao7k6j391+8YxvCUvfeXP/CxD?=
 =?us-ascii?Q?X1YOeShS+FUgunhrbJHZndxLGTR57qmYwXpftjlEP62qMh4m8+tOR9MLQliT?=
 =?us-ascii?Q?VkIynlFlILpsicjATk7Lpo83eUnn//n2biR8yGmh01jBkgEA9coA4ovYJseG?=
 =?us-ascii?Q?Rkzqkj5vEb8V6szMPCqa4m09Sd0zBxS2bySAFVdwFbN6I+bS2KXhpuT/BNh7?=
 =?us-ascii?Q?Hmj5hnqZGA6Aw+lmiZNRnkHqXJmyRLetIdUC+bOv0ITeXXFRMVzp6/ZuNk8P?=
 =?us-ascii?Q?AWLOfMPbjQOONtU+pk7UgNwh6KMOaRXozd1/3/cjLp6L3WNqmF9hdcOVNK6B?=
 =?us-ascii?Q?us4Q9ozAhwWxawKr8Qqduhlsn0EAtHBoMUjtsf2GE34XNdT8t03drKRjhYgT?=
 =?us-ascii?Q?vv1jEesEGNXehmPJL/iSaJOKvUe7mMCScH9y0tXIm+kSo/csndYd3LQnzQVS?=
 =?us-ascii?Q?7fT08Gu2Bof1nuJR7XMrbTaQW4iQIHPK8jZmW3ZNl9slTHVhWx0gyLqRm2ft?=
 =?us-ascii?Q?1Fah6+nCwswoO9GyPhLvi0nQuN41NP60SavhSpbmSmWtrIdoCcVg/ZCGkEr0?=
 =?us-ascii?Q?mgGjV+EkB+UAAF3OZDkdcv53watm+f8NnEz0Q+7Pg+wvtblB4B/mQoGX7t7Q?=
 =?us-ascii?Q?rKNfPwoo30XJF1IV7b4wvYM9VZpj10uhiIJ3X+PZUqqfnz/uVz9uH73/jdQi?=
 =?us-ascii?Q?yP5KSasmKJ2zAgyROyo1dKfCJkaELLguO+Y8A4bH7gFxgn/9Q55mli0Qb9e7?=
 =?us-ascii?Q?x+7fWCdvLedhwrchKbTGNQ+dwCLPbFXZ6PHtfrbKtRP62jSy2F+KGyJdT1Mk?=
 =?us-ascii?Q?Fr6du/M393B6o7gq8a06s17H7HikeyxZQY8HP7XQFttD3QU+vdsGGlZVavVY?=
 =?us-ascii?Q?R19iFxWHoTI62OlW4S3YBzyRpiodb4O3vKnLN2PhSeV/R3m1Ckcl2xuicobg?=
 =?us-ascii?Q?PA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34a5b06a-7a9c-4479-1148-08daacf40248
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2022 08:22:03.8039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: atral7JnW9fHHUrB/mI+2Kf/zakg9vd5vwKyy2UmA4URrQzU1/T66nsif92B8gR5tIhfX5hMXhV3mQX9tAwE27QhkcqFOK6Z4IqU4ZmBzzs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5811
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 11, 2022 at 11:41:47AM +0300, Leon Romanovsky wrote:
> > 
> > `sa_free_stack` is used to maintain the used/available sa entries, which
> > is initialized in `nfp_net_ipsec_init`.
> > Yes, it's indeed a big array, and we're going to use pointer instead of array
> > here.
> 
> Why do you want to use array and not Xarray?
> 

We'll try that. Thanks.

> > 
> > > > +bool nfp_net_ipsec_tx_prep(struct nfp_net_dp *dp, struct sk_buff *skb,
> > > > +			   struct nfp_ipsec_offload *offload_info)
> > > > +{
> > > > +	struct xfrm_offload *xo = xfrm_offload(skb);
> > > > +	struct xfrm_state *x;
> > > > +
> > > > +	if (!xo)
> > > > +		return false;
> > > 
> > > How is it possible in offload path?
> > > Why do all drivers check sec_path length and not xo?
> > > 
> > 
> > `tx_prep` is called in the tx datapath, we use `xo` to check if the
> > packet needs offload-encrypto or not.
> 
> You didn't answer on any of my questions above.
> 
> How is it possible in offload path?
> Why do all drivers check sec_path length and not xo?
> 

It's not a offload-only path, but a normal tx data path. Only if xo is
not NULL, we're going to do crypto-offload. Not every transimitted
packet needs crypto, right? 
We're going to move this check to its parent function to avoid
unnecessary jump when it's not a to-crypto packet.

> > 
> > > > +	saidx = meta->ipsec_saidx - 1;
> > > > +	if (saidx > NFP_NET_IPSEC_MAX_SA_CNT || saidx < 0) {
> > > > +		nn_dp_warn(dp, "Invalid SAIDX from NIC %d\n", saidx);
> > > 
> > > No prints in data path that can be triggered from the network, please.
> > > 
> > 
> > It's a ratelimit print, and it means severe error happens, probably
> > unrecoverable, when running into this path.
> 
> The main part of the sentence is "... can be triggered from the network ..."

OK, we'll remove this print, and maybe introduce some error counters instead in
following patch series.

> 
> Thanks
