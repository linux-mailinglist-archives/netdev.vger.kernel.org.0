Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 546E56A96C0
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 12:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbjCCLxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 06:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjCCLxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 06:53:20 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2134.outbound.protection.outlook.com [40.107.212.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA41B93ED
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 03:53:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MdJ6Irc31r25aU7yQiyFJk+jZvfs7JIJuG8zOVylyStzsWwUuASR56ZgYFqiF9qbNDMkAF7r/H489WsQSTlnTusXvRIftieQvfGJhKSCVMbrp7QmHersNfaSC7WCLShO8EjJPT8F/HvLwbDQH7h7v0QDB8E3FGhGW7x1T7W8WcTG7kWxRjCeax6ciLO+oHZC3O8PI0Ccem4UqoSd+xpJdsAAQWrPh2dbuU/c4AvNiXLQtJ2K68OO97M/KEdnkgUHnXpf6vtW/+b/KFPeWCxXbkvp2rIxpjtarKTWcZuGuZOmdyLtvzx6/15H18dhoK5iP6J17NEi4XWkXI/Wp0Wkew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j0fs/73lVzn7KwkRHIri2GnuT77qS85koX8VvF05z0k=;
 b=XxfoaGIHY2TebrqPbeRXTugUyubYcn2YP7ZoqyHxfURUHnpcHY6o0EjOriz24SIrlirz/ECDxLqzsGVVFqsI8XkCUYELNvCiR9Wj2p+e368rRzQyYfDG6Sck+UHt3MIau03egQlNqqrIpIOE0hEZYSGbCIXpUqQIzIN8m+Cm4uqO+UbhGhshqwKHNwqFQ5Wc6zUj0IfaBWPkpqgyvTl59itUf+VXD63aavMBG60R1tatSyd3wkQSWs9FFInLtBaUF4lwlzEL1rLiEEzgzDOpFRxQLzGxIDNYG4gmPNpEXb8toTYXJ+fffI/Waf+ZqkVyCYpFWPZjbfjWGZRUT0r0fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j0fs/73lVzn7KwkRHIri2GnuT77qS85koX8VvF05z0k=;
 b=Dx2I9qUfzzUos0up+SP1/dkF85m0iMoIxJAcgvExy2IAzZdrviwHjGSARFkxskUMnXh+pDYqhSpIwMMhBbkyI/eX0bi3xMh2TnzXomYevvGwp9RbDHEUYC+a3e/5H4ZZQbbkp6rjTd4n4fHpix1pKZgEoCI03S/AYKjDxQoOdhk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5974.namprd13.prod.outlook.com (2603:10b6:510:16d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.19; Fri, 3 Mar
 2023 11:53:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6156.021; Fri, 3 Mar 2023
 11:53:18 +0000
Date:   Fri, 3 Mar 2023 12:53:11 +0100
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
Subject: Re: [PATCH RFC v2 net-next 3/4] net: ena: Recalculate TX state
 variables every device reset
Message-ID: <ZAHfp1l4FipxNZGz@corigine.com>
References: <20230302203045.4101652-1-shayagr@amazon.com>
 <20230302203045.4101652-4-shayagr@amazon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230302203045.4101652-4-shayagr@amazon.com>
X-ClientProxiedBy: AM0PR03CA0012.eurprd03.prod.outlook.com
 (2603:10a6:208:14::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5974:EE_
X-MS-Office365-Filtering-Correlation-Id: aabd8225-8e30-44f1-3830-08db1bdde121
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XA0xgNWjm53xjznpYYfRG0u/UDEMlclcUt1eiGRVF2AMMRFQsQ14AR5C+3f7VgbjHI/AyXcGzygkm4zIfKW/32J3cAfHnwLdLsNelFYt+bANNDtClBpDUGIbh0prYzP4k4bdgU7dpmJdJ25BPa417vXy6gIMdEt0NY40+Ea7wQ/R0B3Ktk2ncEHORKGdhsTRquk8vBjig8gj4oR1p2c/xSLlY9ipsEhUGC9SOY7CBpqtTxyayisJLwN/RQwFfK5v7AZ/inuP8AyywYwTDAkYkhlPLLGLJJUvfm9EXiweqLecWHLsSvfhNkLJUepZ8IXEUsFT973SfTYGl3MRV0Afye65P8KPsmUMj8/WjOwqmjH/DzoX/bHEBJjyi4wRgQKxYJA2EZltz3GmAz7rf7pN0pN8ud+VSS9+rynt3ESkd2Ovjsh0szDNLRDiJVCufsSqvDpGvlx+r5sWo6DoF2LnZwUaHFI7xkoaSp5fFQ0E6kdMY4DAZ+vh9DDSlw+uSJIbLTXZvhFzeY5o0taA+t9qUnYBGQGOpu5bBcVD/3l22lbivntx71+c4oTkM+RupjtfMXdSum4X8O1BSTpMwiFaQRdso5RynfAnq6wTS9sLRaAkLUI/26QSezjJFmPCY2DMASIQPr3VJwB1jkub9TuyXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(39840400004)(396003)(366004)(451199018)(86362001)(54906003)(36756003)(2616005)(66556008)(66476007)(186003)(66946007)(8936002)(41300700001)(8676002)(4326008)(6512007)(6486002)(6506007)(6666004)(316002)(5660300002)(38100700002)(478600001)(4744005)(6916009)(2906002)(7416002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DcxKQ/uv0NwhL9uOUU9epIq6XcoZwX995XwOn1Lsz1YWfz5CiAFut2lXQkKO?=
 =?us-ascii?Q?HgAlfxb/MCsSxg+f+6SBd5LjuHz7BtqalWwCb6HHIIuGLMRyajL/Zz1uSUez?=
 =?us-ascii?Q?WUEbpwjbqT/vWLv/552B07UAKeAv5m12TxHzg+p4nDj/Kd41kJEsS33YLD6K?=
 =?us-ascii?Q?veXLgcSGwOupuRtEHnOOfPhBVGWbKb3JHssAYUuDuMXr5qoeADBZcYJ7Ztxt?=
 =?us-ascii?Q?J3djqbUxD9HDPhudvVmhV07Wz9pt61gzNeHbV7HiDPPDnpTzI0GkNsuArXPA?=
 =?us-ascii?Q?/AirkR71bOToQnbzG++Xn5F+gn3nsmmffQbYWJYkt5IwWuE/75HZLDmsRbgv?=
 =?us-ascii?Q?IUuS0qO3WX+sKg4rqAcAsZkIH8bfk47Tc8QM4yTKjscLwaLS63xPmErbqMjk?=
 =?us-ascii?Q?9VE+Y2gnR8FthhiQWp4JlfR4Qm3lQD6er1BSSIPjRKFCts1enOadK2FGnOl2?=
 =?us-ascii?Q?Uzr4L7j6mtXj+wdwGlnsH1O41GIATlZCwSOCzzyGTMPVRO28jO++7AM54YBO?=
 =?us-ascii?Q?YHpcVZJTqGYWEkD0Mxag1blOOdV5nj8lPP1zj8TuuH3epi0Hd/oAbIxX8jny?=
 =?us-ascii?Q?22eFeWH7ChO/2Ph/GowPONZ9zFVCTQFC2C0eOXVAEMDU+mhlc0glEPnnWIiR?=
 =?us-ascii?Q?UQG3KEfaN669gXhRyj9tpI0RK+0yiK4qUUEhd35oPSFrdXb4rd1Jnb8mmxth?=
 =?us-ascii?Q?QriXEem2HGlPzWK67wys0SsroFxSuzB1n9IVKpK3G+3/6rGK3XKhkyVs+wCz?=
 =?us-ascii?Q?cOmPT2mLW9uxRCBJIisICAgXKr7xJXE9u+AeXPTh538Xxw2VqAZzs18t4+G+?=
 =?us-ascii?Q?o68mWZlVHePYs2B7g94IBebVPAuWbtv6FrnWbx5L9bzcfmwixpscNdEeNGcF?=
 =?us-ascii?Q?bVtyMUslb8eC3CmUcMV4/OAdKUGXKzwJ7S30FYuZ9Y0jMmcYUBzcpq4VOp9C?=
 =?us-ascii?Q?Dx3Os4l5mf9DPi6sHccl3vA3n30dQEy66uxkSn2Faoc4WWnBNVAsCO9FtxX7?=
 =?us-ascii?Q?jF0rIUgpJ8CV2D+TY3QbodL+mLJqwNe8ulqJL5AEiyh9F0uAu+9v0ETHFAa6?=
 =?us-ascii?Q?/k5bQ1yXxsmRjz5khsHeMGFMvxotxUm3R7ea3HNG9N8jfHrxXJATnT3Fp0IN?=
 =?us-ascii?Q?kerfXFCqImDKti7XtIcdD6Sv9VpTDtUcW1qSrBRaTzUICxxE/hNKrwBKuGl3?=
 =?us-ascii?Q?G1e6l9X0iPgbm5AZE3gL0oCS2QFbuywbVwKw5ewpQbZCrcUWseNgAkGgUxq4?=
 =?us-ascii?Q?cbJMn4aLM5A6Y7uPqyLAXEGKYllU+y8Ba0zAvMTnrmc8HEXW380/UiIKPb+J?=
 =?us-ascii?Q?ZrMWPSdMmfXyrMiGfyBdf9+XWM5WwQYNX5cbwaeWUAceVZKMfQi3Xl9jFzcj?=
 =?us-ascii?Q?5e7ox22asQLGPccLXLRnH3UWemOoS+wKw4esz7NaCVfjA0Vw/qyeJzEyKzY1?=
 =?us-ascii?Q?qrrR3R86alDlnwefdzAXSvjqTJX4IvKlFJa5UaLHQFYQRqdyqukeJ9YCQHhq?=
 =?us-ascii?Q?5pdly9rDxTztLN4SOnJQjsATF6QWHmYfWkW0H6lltgQeA0wKc6QYD8Kv33VA?=
 =?us-ascii?Q?0HX8DORMK3sxu5/NxVJGtmcKR5jKrDg4oblplkzNwFUTbyveqEPznWLNEdI8?=
 =?us-ascii?Q?8CiXHWYdaZ0k/56q9emHsArFrcdgJHRcEHykopNKtceuOUJ5LPAfW+b7n1t/?=
 =?us-ascii?Q?4x9ryA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aabd8225-8e30-44f1-3830-08db1bdde121
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2023 11:53:18.4017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HngYqBsa8l2tB7VJNcdH2gySkBMuwd5Uy5uGtb5P5yzjpN8Ip4AdE6ry9Tyh1yTiDlr+BRHgYB5BzDqxS2YRB9Kpucu9W728bG0C4NpMhDo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5974
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 02, 2023 at 10:30:44PM +0200, Shay Agroskin wrote:
> With the ability to modify LLQ entry size, the size of packet's
> payload that can be written directly to the device changes.
> This patch makes the driver recalculate this information every device
> negotiation (also called device reset).
> 
> Signed-off-by: Shay Agroskin <shayagr@amazon.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

