Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 949646C938B
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 11:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbjCZJay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 05:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbjCZJax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 05:30:53 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2097.outbound.protection.outlook.com [40.107.101.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E392383E6;
        Sun, 26 Mar 2023 02:30:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iaoreg+6FGxZpnDx0h4qUnYQG6s/zaQ/rhmZUDxSFOg7S9GfaiQDLQZZaOZldEvE0oxQU3/sewRLn1EOj2EbP+VhWjJhPV1UQgfHH80v2UjIHkU/0sdLd0U/U9gGwxQaASbbJfWM2753NWilzLTmP4eXEFFmmrlpWZRTX36eVnyz9AAmXWYkW/50sQv3TfbBWSGL8xkxwq0q9/k/2w6V82gTTwltBHgtH8EJ8qhyNPlYo9+3/oD2RBNZf2s7VJC8V7jkrQAvIfJO3VoJYJWn9IOJf+ervQ/d6CyI3qeL/8WCQOcaM/nxzuzMeHgejvr6v0Ome23mjhOl+TEThIVvIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Imj6Tv+dN5hyzVkSz4O4BSx6irW6AEb+b3UntEbj/Tw=;
 b=oHYMdLdJ2X715Js2FuKWqLr0Y+iteyxZ/vZYaMZLmCTRkHNRIxeGc8XnpTiuzaeNHW1T43eSoWsKSs3g9dXGRtEQEpn+ndzCso3DeiCr2jCkdn751UT103UW7uUpCJIKKDtu67Xxf+KW8PNeGNddrsvXuFmEveCJRM53IzTo8vRW/SEUe4kBNzmcgbv/jMGBQK8WC7D2Xj3ThB9nk/x/hxx/EShPbqx1S62pajcPezGQ5q1khxj62I9fy9qlslcsfWnTjc0Y12+HnmyCKL5kr9OPGfB5bgsYkWql/IirtksUOiShRr68UgRbY27e06Uyr/ClOygDlT4GVv9N1zioHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Imj6Tv+dN5hyzVkSz4O4BSx6irW6AEb+b3UntEbj/Tw=;
 b=OBmTQUvryOp/+JH0RwJQAJ+iIkBgY8EYbnvCNKVBv+6XWykGMvt4pNES/6X3y+7/4hJF30dHTe7o/O6BYjD9VY0/BrxAWZkplhgQReKZwZNmC/anfzgMD+yswdxwuhktdt9zmdQu/Aa+IKOuQdc4Tb+OvWQO3wl1kLW9YWEGiKY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5463.namprd13.prod.outlook.com (2603:10b6:303:196::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sun, 26 Mar
 2023 09:30:41 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Sun, 26 Mar 2023
 09:30:41 +0000
Date:   Sun, 26 Mar 2023 11:30:34 +0200
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
Subject: Re: [PATCH 2/5] wifi: ath10k: Remove redundant pci_clear_master
Message-ID: <ZCAQukNHjYvl4RXh@corigine.com>
References: <20230323112613.7550-1-cai.huoqing@linux.dev>
 <20230323112613.7550-2-cai.huoqing@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323112613.7550-2-cai.huoqing@linux.dev>
X-ClientProxiedBy: AS4P189CA0010.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d7::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5463:EE_
X-MS-Office365-Filtering-Correlation-Id: 473cb93c-e6b9-443e-eb96-08db2ddcc406
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3MILFtwvGB7fD0JzjbYHRgCLPuD3I99rR2L0R0q3BVE0Uga9FfNfGzLFl92Txi97eXyh0vuyQR/oAgBFsmArg7GZqW9CQ/npwgKL9Cwtr/czP8hvmP9dyjDFdaSVYQOfwIbHkzBNc8g/idKFjS1LjVyG6y6IDF2T8ytoxAH2afJrY9/N8XgL2vTxXp+WXxyX919hl4VAlYyNBOO8R39oy1syZns6gW6T4SVknt0bIaOK+mc0I8vLG+83p30laoqNXql0r0hg5zYolGtGG1B/fT6j9OVwQ3yIPLNPuxOWPThC82ISl6W7zV/DHBcYLhORK13Cn5lrQZh6hxYfa7VG1q3cmZum6aFjz5sUxlTta8o/9CyEvrkVujv8n4LsYCBkRTqDt9HTrsA70pnRB5+miDI9ArWhSdu4yvIg9FVGMasevldugOC3RYp10ANjJw+TuY/fp/1FR2+ZM/Qstc+3GNPptWNn6rnRmXokkzSRdfG3RDaBT+vmnM5xKLPROn0na3YqRk35OTWB8ctm9zvwugUfOQ+zFfKjtmDQKyyOl90MPHZx5k2QTZh4QTrqSIsA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(366004)(396003)(346002)(376002)(136003)(451199021)(478600001)(6486002)(38100700002)(66556008)(186003)(66476007)(66946007)(6666004)(6506007)(316002)(6512007)(54906003)(4744005)(7416002)(5660300002)(4326008)(8676002)(6916009)(2906002)(41300700001)(36756003)(86362001)(2616005)(8936002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UnRxBtO5YAkLPUbjGECXaSO4yvTc9oRvpW/gM9ZJ3MgQxnSjbWYwcvmC+Zcl?=
 =?us-ascii?Q?ijD3yx4IpDujM8MhU7AM1XehB6Bc8P9qseW8QVn1Z5fyeFbE9Bn+4oW4qajw?=
 =?us-ascii?Q?L8Boy1fMprxakMvRG+o7KKQHSVoNXilt57eWTL8FNSKxPLg+GG4Wm1On7py5?=
 =?us-ascii?Q?2rrttfUO/CNuhTf/WBsFx/RPq2LA1gVaPiQ8Ubs9mZXgE+rL39ft6sBEixdI?=
 =?us-ascii?Q?ND19t2OezILr3bOs18+slo9rR3yoeaxmFBFc2vFeZADUxlSvLAK8pZ7fgLrT?=
 =?us-ascii?Q?c8ssj0zxdV/8lN7dskgTJ/M19I3nUVvHxg5Q2xuZZDoUvzw9X/u32sABUKRD?=
 =?us-ascii?Q?tlHfImdx5kJoFrwE1JHcM/MQ0ynUFp/DWNwdJFSdyfzgqkAxKVeebxe0e6YM?=
 =?us-ascii?Q?jzFIhB8shUNbc7D6OYcpbxOZCuL1gNjh4TOTUZj5YCfLhb0N8TurgR+EUT1O?=
 =?us-ascii?Q?954CB07gyQQJmxOiRNMg7EhE8d+GWQIVWQe2rwQgoYRuevR/+JixYo/05vOl?=
 =?us-ascii?Q?o8EhLxTAE46og7/a1WNuiJzaDGoJ71dREXNlxZeDhPrkcerckQC1onABxrDS?=
 =?us-ascii?Q?tSZODZuI29iLNrAxuwiaBvn8kA0Dc7h97Vqm06KoHIYVuJDHk5JR1ho5Nydc?=
 =?us-ascii?Q?QDzqvXpKqTWr4aruduGhAwIq+HqRaBlbON/n08wg7NmlbvaLiBrZJFKNgBBs?=
 =?us-ascii?Q?lkpQBIIbrGHxpM3HkFfImEfld5BpEadyGDH/Hw0o2oYS68mKHWATym8GlFnh?=
 =?us-ascii?Q?uWpLY1V54+TlMkv9vGOSeIhNYR95Gx2qbzQH+mBhXBJqcBzJse/4q7Y56D7n?=
 =?us-ascii?Q?Wj+ftKfv2L0654SVNGTBCd+7eV//jUjr91wN4YacZF/4UWmWji8FpvMEXjGE?=
 =?us-ascii?Q?7U00mhxoQiOKogIKq1dGaLM9tiBkm0jBr0WHlR2nwM6uTGP98Us7dWrFTStB?=
 =?us-ascii?Q?3PfsggHRfG5LjLygqMf1HS7DpYwu6EK+cPfd309nMsNC5IN8Inq24lE7oylP?=
 =?us-ascii?Q?4d7CnwVz6EvXTZ5G/dxqS6hbJntdr5Y8gTmLDkzOqhZbpCbyrzlmsLoEmW70?=
 =?us-ascii?Q?uxVQDGXFhvjnCgO7ZEHYjlDGwwY6DWxOkKGAV/9rVnUffTEQEixpdaLYY6de?=
 =?us-ascii?Q?myLhMyt6zOrx5EdZNbLvg1FkEutuUNMhyda/h1L784K8lg67178d9tuuT6Jn?=
 =?us-ascii?Q?hWF+pOJWjrmcl8xnp91NA4n12JFuTkE7qyE015zyB122xCKwbVKPStWtFD8A?=
 =?us-ascii?Q?wbwUeWoCIJC/Xt5vKuyYkUMXn3dyjtATyVZGElLdTKXY42aZyReHm9oHc4Bl?=
 =?us-ascii?Q?q/ZYza5+f9uiPW2RZrz/+rNuYQyxkEYbkII0JbPuwSZaACBTCWURRddzEk3h?=
 =?us-ascii?Q?GMDFmMHcJkLVK1u8r/p0WkoYYGEGhsTvf5W9cMBgrdUDpE545TCxTf9pzCOL?=
 =?us-ascii?Q?xgePPhljzqYUUNJrxxpV6HzGqF/61wE2Kg1mNcE4CC0jBC6gfOpmBqk8cHt/?=
 =?us-ascii?Q?LiojSH8qDuR2NRJhIdcYbTzUftaNCD5Oi6LOVY0wE9t98Krw33WFrVRLylON?=
 =?us-ascii?Q?dutyuh3mVexM89OkF+ylMGELY8UcRhm0IdFYPFs2VZR0CTnkR1T1hPsNBOkP?=
 =?us-ascii?Q?qULKyTZrkz14d+POLXjqp6Snv4la24ltCJed8NzuVUWEnNJq13G9SxE1jCRY?=
 =?us-ascii?Q?2UlKGw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 473cb93c-e6b9-443e-eb96-08db2ddcc406
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 09:30:40.9680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tEkJLk5IdH51KZCEl6kiCRMxM5tj6RnZKUKQqGtrzfMBc6GRpECNr94hAj3UGz4wJGu3PeRS8oa3tkFO7Deg7Zx3XHUQKLcFVLqjhWmh0+k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5463
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 07:26:10PM +0800, Cai Huoqing wrote:
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

