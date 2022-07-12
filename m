Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C38B57159A
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 11:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232738AbiGLJVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 05:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbiGLJVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 05:21:14 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2139.outbound.protection.outlook.com [40.107.102.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC30733A01;
        Tue, 12 Jul 2022 02:21:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lZDZsbVhMvNF0ZZ7ZAZ3RC07yywikRQF2lkmSIX0hpeu4xmGNi/wWCWcvCvzvHwtiMPqnkS9pFNCSqX1/QI1J24p19ffBZ9r6wNlhYConh80hfskjAqnTDEvloZfYOizesAZYqU973hs3fjIiI2EHtp+00m9JU9qvoSWZSPlLs1lSvEamnzD8sgJw9n2/DMTppy/T88g3ZvjJkCgobUyou2jIT1jB1Krd8kHSN6H4wBTAx/hTXggcs27p2VOFLQ1oFwVKi6WUkzr7l75M69cHtzA68tPx1bQ4PzsQQn75rc6IO/e9sMSMhHZALEzoC7DTHJ38umpfQPzq/EvPMMJCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sVUJl4CwulCat/vBDd2HPb89Ic9AQPWnfp4jAjLeAQA=;
 b=erJVb9hsxki8/PFtV4Xim6a5d2rsWZofCQnxsTjHj7TPgl2vUXLlRxl79LXABUtnn7iEhoio/2oeu8G3lTZsBHyo0dT564Rrv7lvz9WauOmy57M/1D/w1lCCrpVcFRLsSVCEKaVZwzloxugnR7VCjmP0uCRSvBOx8RMPKe00bL8LFLvYIxdtP/UB3iC9a7rxJgMPbiVCJgPT7KGGGh5S2sR+c3HRvL16Fd4KnN8yQB2WDM7Cb4zMYMFoM7kVgJksFZ2fncy/kJrZbjNCYn6LHDicdnbfqLxYqKTBcbr6bewNRC5/iGTYM1ZCM1tOpwEkfMdU8oZKbEyH0QHfaZOBCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sVUJl4CwulCat/vBDd2HPb89Ic9AQPWnfp4jAjLeAQA=;
 b=Jmbe5DaXGJwsg15Lk/4WEokxsEgWxAKRhzJA7iiVgxgfCHabML6KVxFIta/qB/VBxnx+5klju7DYj3ENx8nOMPbmULAte1xhR2QXvl/ed6cbbIEsbsXXlrW1FzKTAG3kUH4X3q6hELYg1e/2yUuiIyuBctmtqFFO3WYES2SZkYw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3700.namprd13.prod.outlook.com (2603:10b6:a03:21b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.10; Tue, 12 Jul
 2022 09:21:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::bd99:64d1:83ec:1b2]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::bd99:64d1:83ec:1b2%9]) with mapi id 15.20.5438.011; Tue, 12 Jul 2022
 09:21:10 +0000
Date:   Tue, 12 Jul 2022 11:21:03 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Justin Stitt <justinstitt@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Fei Qin <fei.qin@corigine.com>,
        Yu Xiao <yu.xiao@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Leon Romanovsky <leon@kernel.org>, oss-drivers@corigine.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH] nfp: fix clang -Wformat warnings
Message-ID: <Ys08/1BjtahTIIvJ@corigine.com>
References: <20220712000152.2292031-1-justinstitt@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712000152.2292031-1-justinstitt@google.com>
X-ClientProxiedBy: AS4P190CA0021.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 942dc8a9-5b88-40cd-63c7-08da63e7dbb4
X-MS-TrafficTypeDiagnostic: BY5PR13MB3700:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vehwo24KI+MT+XD+0ECLR43da00duK1QzlG8pqBIU3ZVQ4At9PTlevrmF5cfUPsfZrzS0tyCb5wqyRcTN4sAvaG1tBbYp85CKsNBoCywsBiBj95oWxAy9pkEOlOgeR2y3O8L6tQSbNha5HUeJq004ubOwuiEd2O+KbCpjE7QXVYR8qTHnrUG3LBaEQBdo2ZP+Nq9KVKIiD6GTslqr+YnklO/vaBXyWhlMHXt3/6v71lwZvElOnobqLwqNS3cFSi4soFABS/53fmD6LgNn5pXZ1fwp754HylyCZud1cPZEOw3saYnPq8bHldg0zXD+/awTmKxghuTYArUXFStmNiBDgPjTpIh4A36825UblEuzUeKUECQ+cPiCmFmPo7IcO58uxhZA4KPmUQsy8jeUZqvTchnW3lhz7+OkaH9T7ymBTAVC6Br5JouXTw0lfWuu4YoKfJVfhgX5d6kvKDP8qYdlDo8zClKh9Noxmn0ygAe/ago/T4v0GVltGl6djM8RMjmLPQRiFssS29aXSswhn2gukbSfNc846rJ+zJNipXASBUKhcySH1MzDkA3ez44aotzQ+Q/XRUo6ynKc7xJqbIbDDLDb00Vz6l0x6fqFpwveyuHrxM16ICYJuXBpqwimBLfZoEaBGej+1BdajmC9b9zW8z1mRrx0PNQix+Ym6CvwgR3jxJQoDKGn7WNY4ZV+Yn4RFjO4pK8pRx1N609dDJgnhWMqYj4fLdACekvoEnOP+HdyhCD0SBxsNYLajmlhG4O34CcGd5gdFREVJAZ4NkuZGajK5kG0XYUeYS0sJkUMvk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(366004)(39850400004)(396003)(346002)(86362001)(38100700002)(478600001)(8936002)(44832011)(966005)(2906002)(7416002)(6486002)(41300700001)(316002)(5660300002)(6916009)(54906003)(8676002)(66556008)(66946007)(4326008)(186003)(66476007)(52116002)(6666004)(6506007)(83380400001)(6512007)(2616005)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yl94m2deNnUWPJJOiDWTLgk4v+uRRRh0EbmoPl7p/pHNqN5PNalzG+7D+Nvl?=
 =?us-ascii?Q?6RMjzOAGItwfT8z36m+zkpTax9FpoWtxfBYJP9foH0a3xmxFMgCzEptYd9Iq?=
 =?us-ascii?Q?Nv1+XC3GLBk4jcqYsp17jHBZ2f3lSTXuNxpSe3bzExT2KFoPUzX9U0TMqSpo?=
 =?us-ascii?Q?QYS2CkmHVNDMbZSRWPi4GaBmzJ3aWMSeO2NfSEEt5TMiJjIFEvBMkeBavWwF?=
 =?us-ascii?Q?FVozgoAOqUB+yrhu4tTb5yx3zDN/LB5YUyyW+PvlSEmCE1nDCekF1+boOt2p?=
 =?us-ascii?Q?Ge0Oe5Bj4rFu6abzFyThKbG2DJ/doxPUVI6SNodPXfu1rtx6uLgWXrsDILLB?=
 =?us-ascii?Q?9FFMb1HKbJAMa81M9CcU45zTYqbJ3TPq2PJZia7syCdOLGr5QyKx1I3jT1AA?=
 =?us-ascii?Q?GtkuOZgiVMDhc1QtUuShpQ4GIb6ji2w7zbOEInVPTNLXK0T08mtfJRbpSSdY?=
 =?us-ascii?Q?qtO6OpVhpZ4l67cJSzRK47Bn1qZfWOvNBEoiatIhpq0xD2h8GU8NHKrHFdDm?=
 =?us-ascii?Q?NObgXVVY/xwJVEtnl6jHEXRm7te475lcg2OrUoQSnEfEugo7lkrTBhbuzv+B?=
 =?us-ascii?Q?4++t1BpOq9KkBqdEVo0DHlhfgC84JQ1jo44DClWQ67amWd/nWQkx0mzfqZzo?=
 =?us-ascii?Q?DrWschVmLSiD6X2jllj26PSf1j2hVRUsoZvoOZCFZ8bMzczcTfoDYf7KHA1s?=
 =?us-ascii?Q?1BJl8IcpDnq6GgZGDZFH/hdyETsUg+Ifom+RQcR1cY5rFim/FRNTnQq5vYo7?=
 =?us-ascii?Q?Trx9qIL3kt1Nuoejbh06N0yK6UdFG2rBnuyF40eDR1gSGb+cSy2gVATAXQ2Z?=
 =?us-ascii?Q?HR3Q9rAjZnFRlSdJ+v51Q+JftBZ+PfLnfcw49jl5Rirg0WXQ4qYj7VzucHhF?=
 =?us-ascii?Q?eLqpHgilPTxvDq6TZOlzwo34hpP4OfhoRfFAJqvWv+9AD5vY+tkXWalGFdvs?=
 =?us-ascii?Q?85OeeS0NYWusxcibcI58RWj0IrTztIA/kqvX3LXKCMA4grFQZ9/Uk+43FKDX?=
 =?us-ascii?Q?DkeINd1Ye1KLYvVk8+WwhQYIwjs0LF64ReTrj+hCLLnakFBBWod2edwQotjQ?=
 =?us-ascii?Q?STaZDnhmPongph9zdDFrasaZve0i+zAiKVMEepHprxq3C576M/Pd+m0v7aDl?=
 =?us-ascii?Q?Q8IGX70WSqq0mnn1BUeq6Mwj6H+bkJapP1cm1sdh9PFE7j4XoSruOX3xXWj+?=
 =?us-ascii?Q?A+tV5Gr50nVUt7ektvPpfsRAZvMuoGAlBGQtgFCgKbO1KZoSAu9QPgVdJMhZ?=
 =?us-ascii?Q?Y1JACXcWTyGFEbhdyHkcBTmpcmp6BirqVG3oRr0m27vm7Yhc89hThh4ICaxE?=
 =?us-ascii?Q?IRS5GJw6OzD0fmZjkWEOcfXOEX+SCIETqdmJXvXmQy6bSUg7oTKHRa8Z9Dxw?=
 =?us-ascii?Q?IFs0TRKaf3azTQZ3j5vWWLxhrisGMxBYynAOOoRj0SILziCYfI4g013toD2k?=
 =?us-ascii?Q?3XrOnV6+4isUyFOHFW2z6kBg4DOwcfPY2YK4Z4af+4aE2vi/RKbe0bH9q/jh?=
 =?us-ascii?Q?skp4/T0tHjVvFOL0ZTJYyJ8iiJ0IhNq1G5PuvbnCA4oU3imqJMPkkwHVOH1B?=
 =?us-ascii?Q?VFQAb8NPpAfPLPccUpFvVUVK1XKcCgsiM5YNumzjC9Al4cx3Iw6Qu7hyoiay?=
 =?us-ascii?Q?IUfzv4zclVLSB2zD2V4KYSQkRv4+74YvBg313yAtzvLhSbhh3fBWWOSxzhJB?=
 =?us-ascii?Q?0lR8IQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 942dc8a9-5b88-40cd-63c7-08da63e7dbb4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 09:21:10.2380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gxdfDBOg/0ukukGGzRa75XeWapw9ugcOCyb/HSrwtihMXN9IqfeHFOQ1R6FDkRvcukEKpmWRBpjS+erpNGT3HZpOEO0/6mlHW65VT17NCRc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3700
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 05:01:52PM -0700, Justin Stitt wrote:
> When building with Clang we encounter these warnings:
> | drivers/net/ethernet/netronome/nfp/nfp_app.c:233:99: error: format
> | specifies type 'unsigned char' but the argument has underlying type
> | 'unsigned int' [-Werror,-Wformat] nfp_err(pf->cpp, "unknown FW app ID
> | 0x%02hhx, driver too old or support for FW not built in\n", id);
> -
> | drivers/net/ethernet/netronome/nfp/nfp_main.c:396:11: error: format
> | specifies type 'unsigned char' but the argument has type 'int'
> | [-Werror,-Wformat] serial, interface >> 8, interface & 0xff);
> 
> Correct format specifier for `id` is `%x` since the default type for the
> `nfp_app_id` enum is `unsigned int`. The second warning is also solved
> by using the `%x` format specifier as the expressions involving
> `interface` are implicity promoted to integers (%x is used to maintain
> hexadecimal representation).
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/378
> Signed-off-by: Justin Stitt <justinstitt@google.com>

Thanks for improving the nfp driver.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
