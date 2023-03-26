Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0DC6C9390
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 11:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbjCZJcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 05:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbjCZJcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 05:32:12 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2108.outbound.protection.outlook.com [40.107.93.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55984974A;
        Sun, 26 Mar 2023 02:31:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U6dXjOSnYl4YXPyZz+Bk03tFBsxPl3SWYIJVGbHWuc8M5rKzipjQdweRVMHkv0V1LBxLVy5/snpLurs86TefvePjb+xlhP5gLzwYaNKEvA6ujrF+aKmeeHsSFjdFWXlnfT3rBnsPj6ZEIahfnBVKaDkWqEkalWqQj2PryxNYlJffDoJXpDOuPp+qBMsEkquBUnwDTOipQwKhQMP7Qq6+k2ZqYLsK6PuYA5gtYMJjCiRFM9mtq+1ve/9HprEKkumf1hWgN0lTHx3cKTC2l8iqcRd7eRaoIyDJ+ocob5psmq3YAgxlJg9njRDkehAEKlh5OW74cgbryYCiBpxpzsjcBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jLLx7arQJN/qAoXFm/mt8bug/ohlgV5bvizkjIhQrIE=;
 b=mQKvvbHPhBI8Ws0rohvFNMzh4oiykMcoRY5N7lc4Qyet9HZi6Rntcw+dSo0y4FJ2Ktvmwti4cSdfAoOUyxzB5wabiIzqtAg0FuqjfJdaArct0595NS+48mBbxe0NJ6V7wE9s+/3JqUc/8Osrhu7siq1x43N2hDX4jn9XOm5V8sNeK+Wl/fe7pP+XB/j3D3DutvANxFkpLZH9geIcyIoSoK8FJ5tplqHQtVTgpyLcHhRWU1wD9igmawfB1/aaYdOq2eixTJMZq25tQKR2hI+xLIycL8vLtsrpzxZ9g9qU8M9FuGRogpKjfO+BiXRK+2ZX4PuFkO50tQL6PZC02y7ONw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jLLx7arQJN/qAoXFm/mt8bug/ohlgV5bvizkjIhQrIE=;
 b=uIckuBrtVsdNkK/IMSkzRvg5NzfFPsDTXRVUJES3RBQezfic95q7LOjn/dwqe3jug/IzkYgMtO8Lu20MsW/pVDAq4FGW2TMxYZpqUAWVlpZEoc+KjpbOXu0gzb6dAJ0A1lvffgDfSXYY5eOCVL6SC1zP4jbNLA3Jbv4y5ct/Qik=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5463.namprd13.prod.outlook.com (2603:10b6:303:196::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sun, 26 Mar
 2023 09:31:47 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Sun, 26 Mar 2023
 09:31:47 +0000
Date:   Sun, 26 Mar 2023 11:31:40 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Cai Huoqing <cai.huoqing@linux.dev>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Ping-Ke Shih <pkshih@realtek.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org
Subject: Re: [PATCH 4/5] wifi: rtw88: Remove redundant pci_clear_master
Message-ID: <ZCAQ/Gr/x/paleCF@corigine.com>
References: <20230323112613.7550-1-cai.huoqing@linux.dev>
 <20230323112613.7550-4-cai.huoqing@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323112613.7550-4-cai.huoqing@linux.dev>
X-ClientProxiedBy: AM0PR04CA0119.eurprd04.prod.outlook.com
 (2603:10a6:208:55::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5463:EE_
X-MS-Office365-Filtering-Correlation-Id: cbe4e2ab-91e9-4c13-fb02-08db2ddceb9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yMDhjAqCnZ3aAp3QEZYVSLsu31UKJ8QXYkaEvekcd5CVdyr7VYv20IpJHX09X/5QsKq0kdPi6zF6Qm5+NMdvidihhkou4h/4+15NJPQiSAy3fFLwRXLagFgcxsK2y3G9y7vXDbwq+8TQZvIb9SiBYijGStIMsIlZBZ1a4W7GshXz21wl3oWnHVPg3euK9KaLQz5eLygNt427K/wO5LJtDnRKnVJx77cIHIfwP7qp0GgjOIDW5na73YKrGuguoBLchMB2e3e+DmVg3zw5MIKLCpbbRSKmPTgiGDigYHts8hNBN0DEPFt1swstm6UEH42QXEP/3xwDqOuN5j0rmtUx/j7v+/gIexSgtbjGiHYNPOL1zXmCrKLk/VNpUYbE2MuG8cVTwFynKH3Dv7gbk3tN6K8OvgKXCtUpTPDQ6OdPcIYp9BtwBxSTgUHy+RWZbiSpnrR0gnoiLO5Vo4ip+g4iAr6m7nrfYgb5XI4ZeJ67p1ZkRxzxI9lqAT+7JsCAdSOHeAWqc9ynNYXnZDBNtHbqZdbh57CA31e+c7wV/SRsi6jwy7byTdu6fG413IrO/V8d
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(366004)(396003)(346002)(376002)(136003)(451199021)(478600001)(6486002)(38100700002)(66556008)(186003)(66476007)(66946007)(6666004)(6506007)(316002)(6512007)(54906003)(4744005)(7416002)(5660300002)(4326008)(8676002)(6916009)(2906002)(41300700001)(36756003)(86362001)(2616005)(8936002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8Tvw91rG9t0o3AYyb3jrwHIt5fS+6HlmhPJJJ3U2lr0Myjld4fkUipi1Z7Fg?=
 =?us-ascii?Q?6io/eqkB+i7JVQ10PUQH8Ay3sjg0CN6zHyan1xaqXTKhwDS6TVIwnGjwatt5?=
 =?us-ascii?Q?bla95li/qID5ftsfoepkkswgMqQlPARNJu/jWY30ao+E89sKgPswCFgcxPX8?=
 =?us-ascii?Q?sV3ggQX4acGXmpM03XqpegWeCT74CNiAjS1WdrrCFt8TzDvge2jurBB222Cb?=
 =?us-ascii?Q?VjHLoxZ+7kRhI0wKxuThnSYQz9bZUrMxNLZ5AYgEO8x6dMIcXFz6GsBjid93?=
 =?us-ascii?Q?331v4A4twEHI0uXSQGvPIWs/DxgATkNAFEQHB40I1L6u3rpe1BAhHtKye+Ul?=
 =?us-ascii?Q?XZFEwsGrugFCmWxcN44mLwY9f6wrSnrwQXHYUQVdPD8QAbMNMnPW+N+p7e8n?=
 =?us-ascii?Q?B1GG+/+R4bVs/haXl5RI3zf8IWRS33nrTTB/Vjo6O2F90TvSzqPDz3t+L9Kq?=
 =?us-ascii?Q?IqeONS6aFDTER/958PuMZ14a6f5a7l8e3RPbJU97m6ltHuAke2g66+8ilTgH?=
 =?us-ascii?Q?knvN301PrzsIEh7AW1Z3bG9WAaphl6LKRpZiHq9teAUArif8NfSpMNdRgTgj?=
 =?us-ascii?Q?oiT0H1zqyeow1pOJXxUyzVDHgtqBmJdljZA2ZI9JCdbGdc3JhQqPebeNBoZo?=
 =?us-ascii?Q?9hjgKxQzzNYctp3/qgf8RRTWes0IXbid8XB2VmRMmMn+MtbBUjJEgFw+5k7Z?=
 =?us-ascii?Q?zDtFHlW3M4D3xVtlMu+s+5mI7AZwUl1laxf9UrbEc4nngWhWkA3rsNXleMsG?=
 =?us-ascii?Q?sjdQ0MdqyixicOQWVFYxTdLQ2wr8gzX/XEsTHFX4akcOr3UuBuPc9xVQRcsy?=
 =?us-ascii?Q?F7jBLRmKWx11TwAHrLDx8yoqF/31trZnjfn8Hzl7ycLCgcjz1qL69JLlRPcc?=
 =?us-ascii?Q?Bi531ndicchFcd3FZ7pRP2dMxzJ+G/AktikkRTaCDVeO8/sWtqXTaGun6zqf?=
 =?us-ascii?Q?0m55HN/RpNTvkUWx7Gj1ne0eiKHslXbm2Tt3PgSVLD5jCrngZJlHYV8O5SUz?=
 =?us-ascii?Q?T45X07zu6E7wO9aHwBeF6+opr3ZqIg7oMUOzoSmDgkbfOq+cmxKJamCbDqp/?=
 =?us-ascii?Q?ZDdI2bRa7jRNNpryAERnuLkrYdOUYFE2DoruA/fo1kj4pSyQJWwBnyA3FN3K?=
 =?us-ascii?Q?Abl0JdcUI1BjdeT15Kdc1REcejfbVPKmYaJIC+w/KzAvQfhmn2p79lPkIQZ7?=
 =?us-ascii?Q?/c3AAPiq/Y8L+/SBHP9IEUQnOdsVLQd4WDe3My+Tsshbjhn3ddRPHrtjSy8L?=
 =?us-ascii?Q?zw1YAivHCFUM09d8m6jpUJFCZtOg5UWvqa5cI/V+ijjE5mQjCBUDXibsa/Gf?=
 =?us-ascii?Q?DfejJBnszloORf4FhDe6QfbEqwUd3Ytm2hVei4+mOUGVqCakGJYj6rlftQp6?=
 =?us-ascii?Q?OLgMEqad5wxtoxDOM8JW9QBGWe4hDMTh/VVPkaRsNEGjSjIoSZVCJ0+tVggY?=
 =?us-ascii?Q?awwPXf2frwj0PcZ6M2BUxog/9l61z2sNRg/D2L58JgH5I5AtKLtiXuTTCAHB?=
 =?us-ascii?Q?8SVbwGddRwY16ewiCalK6hK5sZ0PaslT/QlWmzuPk4qP7c6oTBT+JOe8Pd+B?=
 =?us-ascii?Q?g8/rduRo2oM8MCAV+xKk1p+rGjmlEknc40X/sQiBl/AFZ5xqOzF/byhXTZ3R?=
 =?us-ascii?Q?TIX6GLdHdtE83h6i8CQcWdjVtO9RecQtgkOaJ7XK5ecP+jDa54vwuPOTTisn?=
 =?us-ascii?Q?HFBO2w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbe4e2ab-91e9-4c13-fb02-08db2ddceb9f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 09:31:47.4010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zpcOkkP3yhFryAzw9kFYzJCoyH1xvolXJWJilXZ83b6yKVkAHGp8BhFsyCx9etMzAFp6kMtsMBQc4qoc5GMbosBs1VaWiw8AT5GQUkgpmJk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5463
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 07:26:12PM +0800, Cai Huoqing wrote:
> Remove pci_clear_master to simplify the code,
> the bus-mastering is also cleared in do_pci_disable_device,
> like this:
> ./drivers/pci/pci.c:2197
> static void do_pci_disable_device(struct pci_dev *dev)
> {
> 	u16 pci_command;
> 
> 	pci_read_config_word(dev, PCI_COMMAND, &pci_command);
> 	if (pci_command & PCI_COMMAND_MASTER) {
> 		pci_command &= ~PCI_COMMAND_MASTER;
> 		pci_write_config_word(dev, PCI_COMMAND, pci_command);
> 	}
> 
> 	pcibios_disable_device(dev);
> }.
> And dev->is_busmaster is set to 0 in pci_disable_device.
> 
> Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

