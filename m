Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9EA15E9B43
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 09:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbiIZHzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 03:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234484AbiIZHxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 03:53:47 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2100.outbound.protection.outlook.com [40.107.94.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FED3E749
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 00:49:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eDB7/xzAnXyFK1zGgbMu6YraVQFQ7kgdWADor3bSL/jUSKA81H6d2EmL9GQy1t8ddyvmETcDj1Dp+xeNpALREWceG9PclHamg5kcNDIXg7NONUpeZHIeQ4+/5lS3eMg52aoQSo48uEnaYGPJq5swjuDHLnwEf0ZCSP+Yy+mYLqP7G8LzydarLtF2qeZviwZwUoI7Vt+Ee3TtBs5NKWYJkKK0nM5LIk1IplluZtVFbxlLcSaeDtB2++2HDzhD+GBZ2j54NjZ64Wa9HN4rqrCiLTmCGnG1/wUuC8WCpJYQS2UmaY+fKYgEyjqcUHF8BlEpYXu9t1d+Z4RHRovn0SX53g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1eZE2BGvLbtYUfhntGz8Rr/03Z8j7o1JV0fJ3p7f1oU=;
 b=VaR2m9vLHcuKLGjCxzlN75i23rAKdb+bkwhs/bQAAHJVZXf0NLmpryJHWLH32x2IG/zxVuHBeCOlPUjp8MMqpIdP8peD7NjiZBifwI5FVoiBbUhqsbw53X9vo5jBX2AQGj2B7ZwF7gyhQwH0F+7IIFBvyCM24vcHfBjXQYnGMYbiEYfxv6JtyxNw/Z1gYNuxFISVbBeRJ7Orcjvvja3lrz8MzqOf0m21E8W5my1EGO5uePoeHhhP6ByfsPsxS4Y760Ne0Z+ZzDDBjkyCuD8t8qVmx0y2Bbmh3WlJ72a+HvC6dNSfMXIGPEOEQzFtefcex9/QiAYIE/WSoAmHzkce/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1eZE2BGvLbtYUfhntGz8Rr/03Z8j7o1JV0fJ3p7f1oU=;
 b=OmN1UVXjxntwGdveWFpwGdAluLx1u634jT5vlwXOzf9SJqVQP9g8a5w3XbL2Ws7YPumzy26AQ7x+yx7z7c41DSGxTAHdN+l7k2QBcKhXqHmgOgL49JLkST/KqgDidsIIzuMdd9dXTwJ/zewOo6zhIm7rofwetSRQyzdGqO5Tv6g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB4121.namprd13.prod.outlook.com (2603:10b6:303:5b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.14; Mon, 26 Sep
 2022 07:48:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54%5]) with mapi id 15.20.5676.011; Mon, 26 Sep 2022
 07:48:21 +0000
Date:   Mon, 26 Sep 2022 09:48:15 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Juhee Kang <claudiajkang@gmail.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, skhan@linuxfoundation.org,
        oss-drivers@netronome.com
Subject: Re: [PATCH net-next 3/3] nfp: abm: use netdev_unregistering instead
 of open code
Message-ID: <YzFZP7W7cSXDsnuu@corigine.com>
References: <20220923160937.1912-1-claudiajkang@gmail.com>
 <20220923160937.1912-3-claudiajkang@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923160937.1912-3-claudiajkang@gmail.com>
X-ClientProxiedBy: AM8P251CA0027.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB4121:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d717e9e-56ef-45d8-bde9-08da9f937bcb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K0Kij2WxU6C7ICeMIjWBsc1MrZ6EA5EELB2p94I1YsmcIktKgcD4ibTIR4mn9rAKX1woatfip/o6RmTxS7+tNKl4pDogz7Ix/hxrHW3tWd1ivb5BJNNdMXRZ9oOfLtKNqxPvkQ/M2lbaHl+0D7Z5wp7sbJxDlu33sRkZ5H9+ZC9cEONZaTQPIqUcZnZJq/sUogZdxrN4BbG/zdVrwm3bdGnskzMgkXwfVXXXs9XadMHvlXTl/iBp1i7wVvxf8RPxsZrbFgyY4b3KX6OythuaU+3mTqmxf/TJfCrlALIg3eemGXP624GyRE9c1/+zwe/giw2JV3CVlOoitDGqPA0K3yAZQaR06b9+NrW9zfTYRizRABH1NdMEidPkopsVN9vLa4p8Gv4lmpWRhO6c49EWSxaeG2J1ncu+nymoSXCw24cgCTaE3uyr4g7GLUTmj7SkbmAx+iofuLjH6B0ASOwtAlY5JMZe1Rr8cVddn73NF53wEeAYEMxdmEgyt7Mct8GIXnUxnL7BgglYP7Cl5NJb8KzWbC3uhvkPp5TBbPQ/bOqhGvf2v1EGEnhj7F8YlVZ0y3FErpF3Bv4SzMViJki3YIyqUWMY7wAolTxeeECsubuGRlmrzNQahROo2ISXzLW7R5JvhmlJ90OEj6kbnsnuB8xUGyjOZ28oB4XmHa9bFoRknveJbnAoU8QB9ZkYPDXTqMo7Gg42UacaGw0RdHFeN5ahqJywrHEpArW2hkCLQit78VedMRETBwUZZEy6UPBx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(39840400004)(376002)(396003)(136003)(451199015)(86362001)(8936002)(4744005)(44832011)(316002)(6916009)(41300700001)(5660300002)(66556008)(8676002)(66946007)(66476007)(4326008)(38100700002)(966005)(6666004)(52116002)(6506007)(478600001)(2616005)(186003)(6486002)(6512007)(36756003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Nu1uonb4zqS/4l83J0vFfF9j0XLLkIcxvdG5gvMuHJF0KRcy9mCVXQwGFDOy?=
 =?us-ascii?Q?/UsPCM5ONel6042EgQAuFPswdoR3OQAyiZsN62eBqw0JRmUMR9t3hKfuX04n?=
 =?us-ascii?Q?ZQlBc9y4QX/3zo9Pu/RCGyk1pTNQzFh1SqCTALgBizraLBmNIDFfnq2j4IiR?=
 =?us-ascii?Q?a55ykAC7nfXTu9FKmZXhk3LBYHhotrrpbiQHaZgcvNKaefM98ytth1+mGaGD?=
 =?us-ascii?Q?QXrCpwWQAbzNbAdj6PYehe2mGYo7hKk9Sq4UEWG8QslBDbleueTD2TB+MvnV?=
 =?us-ascii?Q?v/Hqbth9Ift3oH/dX2itEtcXEJjMq95LY5O8Dfd5fR850DC4yt6BvmQp5QiW?=
 =?us-ascii?Q?ogboJ4zz366M0H1yAFK+2K3DXA2zBA47Wnx6kslUHpEGVvltjdqUjtJLcWVn?=
 =?us-ascii?Q?GTUm4Lu46Lc9ndGp1nOMHVBGGqONAjBxpEQj6ImpHP9f6d3sv8y9VYX3dezc?=
 =?us-ascii?Q?XUGIut2XILuaG/EyWEgKrAE2NAIL5um3OhF4I/dKcA6X/fBqntU0kowAyuwI?=
 =?us-ascii?Q?6+yfEv0uVBz4kEkCh9GRacgBBbVsdA5eK0mfMqCw8PNjEslLv0LOvZY2BnkP?=
 =?us-ascii?Q?860TcDb6+PAEA+4FYfZ8fVaeR2NIk5UHLOc4SUAYz0eiiiugRDtPMkbdU1ju?=
 =?us-ascii?Q?lj3J7EeG5CoyvL9GfApmEEL3JuWkg/YNFjVILNsyUJwTFuZb1SCYLhPf9yn/?=
 =?us-ascii?Q?LvXNhV5RsaDd9f2Iw3UM2AlsdzSW02m4C0e2ARKqwmJX5jh0Pxas2RpwHm0G?=
 =?us-ascii?Q?aVBtG5PHhWETGrJMAkmfOluwEhBUBDBzgUN8Rpar4JJwX4IvzkAmkBKo8aHz?=
 =?us-ascii?Q?xEJ2iRD4iVXud0W2ImWzdq05tJA8iMtVumF8H3jt4llYFWMLTvjcBVQwpEP0?=
 =?us-ascii?Q?Rz7bxKEPzWSPo1xG8DsR/jPKzlRJlbw4XH5a5U5/nPaijBQu1ZcxzAuHKfjB?=
 =?us-ascii?Q?cifuEjC2PKrhrz+vnu9HmmcRep+CYSnhAu+Hs6OvhNwYb6YXQMrGy0+P95B7?=
 =?us-ascii?Q?v/xZa9NVJUDELPGf7X8kds3ZSpLyhrr7BKI9xjS5U6E4TeKkXI9wCN5EGcdB?=
 =?us-ascii?Q?4oieh42CzYORdhodHCPc4o5+TKKq/okcpM49dvLTQL3zVn0tUkMe2c4rwy1A?=
 =?us-ascii?Q?nrSiDHIJjDBqJb2KA1pPL7KrUe+foORYWsDXDMui7zlM+ipro6HcE31w72K+?=
 =?us-ascii?Q?iwIDb+LagtEScQ0FV6SPtLSGWESNSJfn6zZ0hvpasALeoys5WF5HXaV3ngM2?=
 =?us-ascii?Q?T/LCC9oEWXVFrk9iDbxxnc/CtfBYfGc21YvDhyiQsPMJx0CUyBEquc1SY3+H?=
 =?us-ascii?Q?fpKsEDXLv4YbeDISyw0JPd2KuIpuwk7R1lhTvIh8en9hsYNG8XTWAuwhnICc?=
 =?us-ascii?Q?e0zHykrB1bKYgEflAthgMORwEHV3qYfXmbwuCKa6r+z64fDIrYLLQoth7PbD?=
 =?us-ascii?Q?R0j7loSjWArPd40sNSJ9TEgrouoRulRsfdQKhQErHBNw+qZT8xS6nd6MTybW?=
 =?us-ascii?Q?V6DFR9na5tOfyCjxINeHMfVxwmlp6vAIto1mVEUDEA0op1WKoautznDafTp0?=
 =?us-ascii?Q?VNAwYWN52ZTcCd2zgNqTCnqUFuTv5iBV2Iz/KSiSeN0XZmxwvDNko8iNNFMJ?=
 =?us-ascii?Q?6At36SXS/b9HHKX44D1uwtusbUnzH4HjJ0rEt7TT15VHP+7EMyzea0zzJuq3?=
 =?us-ascii?Q?GH84cA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d717e9e-56ef-45d8-bde9-08da9f937bcb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 07:48:21.3398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NRhXghS+zbc+z5Y1VkkioOBZre9RA/o6wU+VGhjOiXVcBmc+SEeUQ1Dm74+7KFjQlM2rNgJ5+UjkRIra5xV8cMPajAFMRQ1mFJaQtyUlfWs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB4121
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+oss-drivers@netronome.com

On Sat, Sep 24, 2022 at 01:09:37AM +0900, Juhee Kang wrote:
> [You don't often get email from claudiajkang@gmail.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> The open code is defined as a helper function(netdev_unregistering)
> on netdev.h, which the open code is dev->reg_state == NETREG_UNREGISTERING.
> Thus, netdev_unregistering() replaces the open code. This patch doesn't
> change logic.
> 
> Signed-off-by: Juhee Kang <claudiajkang@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

