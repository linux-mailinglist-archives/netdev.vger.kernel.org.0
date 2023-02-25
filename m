Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A13DD6A2AD6
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 17:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbjBYQrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 11:47:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBYQrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 11:47:03 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2110.outbound.protection.outlook.com [40.107.93.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E2C1286E
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 08:47:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GaI7vj8mOKc6lXRf+XbutPBA2HVy0pyjN9b19eqtURYkkBMu2mq/9ezg08XfF/7v0xDi2XdpA3N1LEtwWygNCGsBCJ2Rsux8eu6kXtLL+DR1sb2h07Cbh7sJ6q6yhmICX0fNct3cwxhVX04VAC6BAsnFZyYwxouHDJHEjOjZBb3btccLYCMxwzow+fKrF15x6zKFlI3iI0ihfCNulXE7DbBFeaGyLyP3RtY1RufGHuX9CWM6dpWjaQykjaxUPFe4eZhDw9xLO+K4NO5fn68Ivptn5lql8DlbqsHk5fGzdrXSCs+9ORI4j9ec02VIKXOEXI9kXBksGUBoTwj2dz1kTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K0NSJ8tqH7tvP4XXJdYwGTXHSLXdUiED3HmwEhklY7A=;
 b=WEz5Ptym1u2bvkCkgRHKDzeXnNqjFlm95JamFulZuKAGpI8lEnwyj92IK3YzDvTYjxFlXOZtKW7c8Ms1608an7atAEEV1WheWam1qioAgtrG70iLKR3g0HuHCis/LrSLrCsMiu8nouXIi5HMKHW/0QnUzSbSTU71JSwDZsSp72HMhbfq+dZD/KltUIzhSexdUazNh35bGz1+KfClZ/aPF7Or80Igz95mNPZSZpZllAE3LP4YJHaeQflOw0VXALemSGpWFAcxNO9Mx19SZd+zCjpKhzIizXQLpBUlLN9i0lnRl9uGl9ndAj/vHAJBxEpipQm7TYFpFEwKhK+ZzKxRDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K0NSJ8tqH7tvP4XXJdYwGTXHSLXdUiED3HmwEhklY7A=;
 b=eM1u2QC1I9UfRzyx61t07yW7EHMesoDw1oMjwwduVWaIR3Nc98lzla3lIT2RRNXaBybN/p8vfntH6ZFeoioMgxxlcF91HoLh1vPEguPzJgSRaXNO5dC7vwcgwrx9rINlaiqb1IA/JEh9simlU1hyQQ4Gwq8o2q+nLRSw110N4sM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5682.namprd13.prod.outlook.com (2603:10b6:510:111::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Sat, 25 Feb
 2023 16:47:00 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6134.025; Sat, 25 Feb 2023
 16:47:00 +0000
Date:   Sat, 25 Feb 2023 17:46:52 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Daniel Golle <daniel@makrotopia.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH RFC net-next 1/4] net: mtk_eth_soc: tidy
 mtk_gmac0_rgmii_adjust()
Message-ID: <Y/o7fDIaiekzCqOe@corigine.com>
References: <Y/ivHGroIVTe4YP/@shell.armlinux.org.uk>
 <E1pVXJ5-00CT9m-CT@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pVXJ5-00CT9m-CT@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: AM0PR10CA0109.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5682:EE_
X-MS-Office365-Filtering-Correlation-Id: c25bd72b-6866-457e-b484-08db174fe9b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iMTDsQ5K05YTH2qlA40Bb3pBvPSFABu377ZUgFSM8HCICmXEhEs+w2r7zMqFmSZWMyBKDire8GZ0I2OZDFuq4SiMEQx5zGFZdKawPAW/syo6Immt/uwce1C9OZQWd52+eGKNKdogytpwBDLU+jVo9Rg+JBSiGduepI8PagRJ2JwePJFFMENhkHFsAIbet9WYZoSPYO53V+30jcqTN+mBLLB2fCWNCtscTNCO6kN2E+Ym4/QSP2ZiuY2WKTwhRmq+fG2wz8GcykLSQKnA1nYCpZ/SzWHfKaF3jASC2BnqbqdKJuLpfQ+yL5ls0fJ8bhWPJoZ9dN5Fo4JqfKMOBp/SaYCQKBwck36BkY2cGZYbYPqGbrYcX67+ypFejagCgyqfsST0XiDLMnseK+m1kPGtXwmeLC6KjgmSeFh64MXRdYp13WnTuZddwLEiAX93N46CUNVyE2QT9dyoq6VIBAx2vGW4vT5Ji5CxJFDJ7b4aUdkB0jVWx2JBI3CZOetc3tNS2WHUeY/l+LQGMr9w7OvY+5ll464ILF2jtpkdPVpHOw5AOdth/utPpbCLFWYO4Bw+05IHJ/5IdqMwNY1yr+/HJEPBLDMB8hu953oO/ADu4WocyiXVh0sAqGfgr0ERd5S9KNlhlE2NRI3aatGxuzS2Xw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(366004)(396003)(376002)(39830400003)(451199018)(7416002)(41300700001)(8936002)(44832011)(4744005)(2906002)(4326008)(5660300002)(66946007)(8676002)(66476007)(66556008)(6666004)(54906003)(6512007)(316002)(478600001)(6506007)(36756003)(6486002)(186003)(2616005)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MYUT2vr49tLiugol1RSB2lOX6I9ax8mA5r6F5T5XfA2CVu5HTaYsB5xQPVdA?=
 =?us-ascii?Q?ZAnwjDQIYKhm/Eylo4ZLOt2u+V2eHWwkrkg2sLle4v1AfFFwb5v5eB2rAYA7?=
 =?us-ascii?Q?NiGRwJbYURPkzItC55TD0FFu3cAi0XseHCKw/M3HSu1qRIx85xyI6iW7K+xx?=
 =?us-ascii?Q?jwCOUkCFxJB0RYE4npO1sQKNrhT9DgTVv1V2Np1fBYiTGxxS1Yg1aurOtlGZ?=
 =?us-ascii?Q?H+8X8VrYd0hBnz4KTMCqomJkx2GOKGmTMRn4Xd9gVrsRQsV3KhHMT4VVV6Id?=
 =?us-ascii?Q?F2bv0NcciLWU/dVB4+dSg4QGnyZeysZxy3OyJfdhlF/hHfI4sMdv6ejDu/Lc?=
 =?us-ascii?Q?k2d8zVmSZ9h2HWB7gqUMkIjhNXhoX4ssLiBE9IERERQSztXezziJg+JGur0Y?=
 =?us-ascii?Q?d44DpGd5ebR+R9cmKVijl2HyKdheMPBPxkItoNFNBRwTkdESIFsAn5BptXIq?=
 =?us-ascii?Q?re9GqPtX9IsWAhKSp3WtoDo6IiMQP/fHGZrQ2LVQdaQp4cOnJBVMrzsMaf0J?=
 =?us-ascii?Q?thrG3Z5CgaZnLQ0N3chHrpTJvtbCxGcVFgw+p5+5DRPEBhjYCEyVfbNj7mvd?=
 =?us-ascii?Q?AEUKUzQPu/KPmTaNu70HP10QAi5wRjibox/zyczSX/mI3eSBhfLZUvfZ0D94?=
 =?us-ascii?Q?0/XI7Il0/G6BzAZ+XvT/baaa2OMPAsE+C1Po4FhDhIPLPUep6bkrDQ1cDFde?=
 =?us-ascii?Q?bPM44zH95L2ygry28IdsORJNkQ9sHBPKqKquI9WDFH9LXpXVBdIyp4UQoUiR?=
 =?us-ascii?Q?8uUCaZG01npwIOuDyG4I9BkCY+REQP75FpkjEfoMmKwh64z1M2umrO9WiVnM?=
 =?us-ascii?Q?UIsh6mRPCkxM8eIfgfjCpK6ffsXqBEjQOh3qrGP71bQc+WNTssIj8bR2ko33?=
 =?us-ascii?Q?AWt5HVBMwdMnomboHgaRMkrGmKS6k47Wibkv0ZgwHSgu04eRtQYw4ceVJE6D?=
 =?us-ascii?Q?5VG+4w2vNLtiOgMd915VbR65UxbUdw9imYAj+o/lZCbwkiHwRNz3Twa4NxiM?=
 =?us-ascii?Q?qDi6j2UU3uessqeA1Bee45Yl7JRLloTujjEneXf6kPCVH1hnrNZNiy2RcFWj?=
 =?us-ascii?Q?46Kktn4WxRZpNNp5bssdjOakKV8qlWmahADvuLTHFLVtyM3KWRO5EovHM3gG?=
 =?us-ascii?Q?1eEaLFjzP4ngnrdMZdK4/xoJpVKV5eYQyAOE+6XS4xJBUwkpHyPJ4HgS6x4P?=
 =?us-ascii?Q?Fr/zqJjePX/WLIFI0ovB/vcsBZ9JGIzyFedCrhU3fND7apfVub/e4TaiSG94?=
 =?us-ascii?Q?R8O/sB9gskPuziHCg0zRY2hg+4ZKNUVQoPJzmRoqWVu7vQuiUZDvXQr9Os5J?=
 =?us-ascii?Q?1E9FSP3skpDugfZxh94OOhkRvhjKFnKhuo/ZiB3RWmuiofxtHiHC2imh8gJX?=
 =?us-ascii?Q?o1HJxyzJ23AHd1ViwXtG5OqyS85dW2RJ9+09PG7tJY+XGDDauk5yOoEkbAmq?=
 =?us-ascii?Q?rP0zxQr1TMfCUHDAa+NH30o+DTcWPq51QdDk+B9VTL8Dm2We9SNecFn3vlZU?=
 =?us-ascii?Q?hSC6DckTAeEZVoXvMLtDC/QcatEfLZdykUrk0oi7Fc+3wdPeXHTyiQWQlxW6?=
 =?us-ascii?Q?QIr1tn5ND+bI8EaDT6lCms/d3Brl/Mc7NWq1XLWJvozWdTQ/Wqi2H1zrR/g4?=
 =?us-ascii?Q?7ADOvmxOk0MLR6QVA9XNqN+yeV+Zq1TAJHLkByTGgFFQgkn+Vu37C4Ynvvu2?=
 =?us-ascii?Q?v5hO/Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c25bd72b-6866-457e-b484-08db174fe9b6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2023 16:46:59.5695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bEM27qahMD8wWM9P3s5ra/ViKvNcU1PYwFA+H9Id7hgyIZfOqkIbBcKPtF0mEdaXVBmaW+mP6sP78k/o4XIWOOMTGof32zTNWl//iK85uS4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5682
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 12:36:11PM +0000, Russell King (Oracle) wrote:
> Get rid of the multiple tenary operators in mtk_gmac0_rgmii_adjust()
> replacing them with a single if(), thus making the code easier to read.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

