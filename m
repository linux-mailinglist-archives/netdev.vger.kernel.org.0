Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E89946B9C06
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbjCNQqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjCNQqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:46:10 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2089.outbound.protection.outlook.com [40.107.22.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8FD3A42FB;
        Tue, 14 Mar 2023 09:45:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XVWevYG97wwJxb8PXrrctrJ6im++viBdNxmT8LXESC2zO2Vijw2S3LhObgGeW6bxHeshTwmW3juefEKRhOd6HWLeSCCyZHmLA7Y73KUwt8m5XDjDWsVBaF0thCNU9sO90gYGQVU81cAbpHZQXWAsvv9wUFfH8mYhls7640PpnNkP4rtchsqeoDfNNqf6zFh4kf2Zss+tpyjTflB5IPredV9PhTa0cTmVW/eWMO5ksqqEQYYZSx9GIgbgyPDoSyNRykuSLUYqKP+tx6LD+Sv+W4OEZLsdh8vAA/oTtoG519r3mWUs6/k5TIOKgj+w3uYdhubX9naCNsq4dAIG2FZisQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zXNpWr17owU/I2AusINgnxJPhUxSiJcyNLy9SfKKiIM=;
 b=KGMDnruw4hTGStChFk/eDzywxtMjbb5i2G5pqlnoG9U+1ikxfh9UHzjLotz2ipAPJp9oijNF06BCwnP1LTq3vsdvBB1jTuyaLATcDQ4Yv8YabsHXG6SoSjw0wqM9lG0RV/OUX23UyfbzxUxfluFlmBfG8UQVBokPRwwQnzQJ9xgtRTGHMVpE+Z35Uk6IQqSSHbpe+e2fxhcKHQyuA0dhH+CKz4Dg65+ETfMStfN0s2nkk4ZA0PA3sAHGxvGtJJUs6Cd0/JFa7JJ3IXLhzqjAkHkNF6mMNU7gc9FhxFi5tbul0js7lk1rPo3WH305siKpUJWdX6Uu28gd4BKsNlDiAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zXNpWr17owU/I2AusINgnxJPhUxSiJcyNLy9SfKKiIM=;
 b=WoXjxQVeRHfVzKSO1BxX09EOLfJQ+9I7zwbJHdXGVw07zBxDA17wXMF/74JOBOuDIf3iPJL77GC4+mGtdJgS/3cVWBtdj1SxZNFJWZ3hi9l48kn1HQLvHxfjUXYXrk6ktNSqXykrw1cW7m4bCcj8hTzfAJA3tOOwhWOg+/YMBeY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PA4PR04MB8013.eurprd04.prod.outlook.com (2603:10a6:102:c4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 16:45:50 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 16:45:50 +0000
Date:   Tue, 14 Mar 2023 18:45:47 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: phy: mscc: fix deadlock in
 phy_ethtool_{get,set}_wol()
Message-ID: <20230314164547.5s55hmoeytrdevvb@skbuf>
References: <20230314153025.2372970-1-vladimir.oltean@nxp.com>
 <a9bfe427-4d76-44ea-9890-3b0c44ccb551@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9bfe427-4d76-44ea-9890-3b0c44ccb551@lunn.ch>
X-ClientProxiedBy: AM0PR02CA0167.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::34) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PA4PR04MB8013:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c868de4-8811-4c2e-760e-08db24ab91a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gKoQc4Of1JP5FaWmqRlpm3246b6Fyonw6QSMqfZdmQ0cP8NsxrT2qzpPwmRa1uHleu+dqf0EwLL1Nze2GGyHmxXuUQHQrFao6ckbRl9Ls+o6vgvr489xQaIrNP2k4mo6jP95p+hs9kD/uCJWVkNBujJUp9AHAzqTiQYs1ubKoN+fF3/qna7DyoK8EUnyfb3PIffmGmGWJ5rNvPt55npygq2E2mu8tIkJmJj0be2W1ZZPBndkQwviUvrmuYjbVtY9qHu2RLg6mhr7GBm+HtBOVnX+cdkiswbqYX4FnNbhh9ciX7laRBForoZP49jED+mzVC5l9I9z2fTYp5zl9ybew4ubbFVNV+nMEMHfS+1vyD8hfBlt4Hssjqim6mO8WFSlPe1xUDejz7k77+9ObmaPxQUrjUYY1AUFAfiBvXzpg2YNuGueZJArmjH2t7LU+MOv/xDLEYXAllQ2wxFH8J/wn7SodOOt+ceqBX6oPNtsChbkgNDEB9QmrelxzTfFiytjTvDW2kBUec6gOs95BIX8AAsjyrhmP/vn4TeCwedjPrEXQG3Gg+f3WSDlKkCCSw9LryYFKw4QwUUtbH12Yv7s0ZYRT0gI5F4LY6cSVUWxVcY9cXfak7G6N0Xyqj8CbIvJ6QMLlU/GSBXcsERkjV13rQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(451199018)(54906003)(316002)(86362001)(38100700002)(83380400001)(6506007)(6512007)(1076003)(26005)(9686003)(186003)(6666004)(33716001)(5660300002)(6486002)(478600001)(41300700001)(8936002)(4744005)(2906002)(4326008)(8676002)(6916009)(66556008)(66476007)(66946007)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Pha5bGEFmnsj3rg7ykqLVMLiGRBLSj4KnrPyHuW57z3rN+CuBt3MmgaD8/RM?=
 =?us-ascii?Q?+M+RRq90aJbuJdESUaHqZn/VJU/fE2lVIqQpY/5idOGyf5hLlXaBs03C0CwG?=
 =?us-ascii?Q?n9Bfy2JlT88I8RppBRg2qtt5TASEmYueG4v+Ld25m2UC6I34ZAjU4hGoNPzz?=
 =?us-ascii?Q?3GCSM8289zimJxVL+G25THEYmmdlbbLXmEPvglfpps18kCMu6yCRng1hHta2?=
 =?us-ascii?Q?uhU6bYaZqJtdL4Mu0ZDIAUZzcZEVdUYfTS7JgU1H0oTpSQBjJ6QvJoJY0cay?=
 =?us-ascii?Q?F/Lh/pmwIYSflSVvT2lTAsf6dy+II5/IUe0QRmns/66cx6qPncR8GhL5WM/2?=
 =?us-ascii?Q?BwrzBvmSqfMc4AC98KkDq7qhI7CGnyo3vF3+3rBzCoxKRSr7kgpEFbTNR+xu?=
 =?us-ascii?Q?xdXJpr/9kAq1YTF0med4e5pTwsvlAwmsjqw5+Ui71uZS+NsnC9vC9EqlcrGs?=
 =?us-ascii?Q?hWkCtEtunBTsP0VKukPCjcSSp4x1rxHh9IKbePf9cBa91Lr0Nl94hED+ope/?=
 =?us-ascii?Q?czBLQVvXDiPALMcpiGb+b6sUr9nt5Jnp0E6aVZTfUDsIFKWDAw+82a0HDjE6?=
 =?us-ascii?Q?2P4xZadbuQ+oH3qyNEOL4dPAs4Vf4jimNzZt3PmN6T0Yk8yDeC272xpTSjcz?=
 =?us-ascii?Q?h5p4eWWZDHAN3FUCmonepx1UXhaGSWFdvWBKknK3Ru9nSsYkb9FgIrEGeWx2?=
 =?us-ascii?Q?xP+JdE7n72XdfDIrINoE8cBt1/vC511An+YQjn/EdoDb2MNvGScicBObtZFC?=
 =?us-ascii?Q?naHjZRde01gewuLSkQugWFIehy4PkePCv5kTrgUCAXuMmJarAMQiRLPALEsQ?=
 =?us-ascii?Q?DkRUbGCUoB8Vx/dBcGhZIz10PQDWhjiYvFggoyoakVGFVflKN+7OfX/FqZLa?=
 =?us-ascii?Q?iVo0Uu7in/B918gECxOosVDrKrrWNSYfHykomuoV0PSaZFQrFSceyVg/Gdg1?=
 =?us-ascii?Q?XZvagt3Kx8Nnc7eBTApHIzKrs8Gc/M2tWEt5bUt4HlM/VCMzen0B28cIO3t6?=
 =?us-ascii?Q?Gph7d8gUZH4x+GB0uzXPUjfr7+BfnKXP6cYM1mAcIwSqf+21AxEAsifKwi5W?=
 =?us-ascii?Q?JwdHrpnwK7RmfpfyBHHHmWUSP6E1ugQ4feTpYlwSPl5YXTmmbwsGQ89O4xgQ?=
 =?us-ascii?Q?1fThp2vzeaHeXyRjMX7QLkj6keE8Fp7ou1iXInHiBPccEuilkbXrkN//dI+Z?=
 =?us-ascii?Q?ePr0hSdAJqQba3CUwYdG5X4S71aNg5Zt3DUGuWsf9N2XCh9C4NUjMTguV3/h?=
 =?us-ascii?Q?MP5iKEhJ8ZuZNiuS/vVdtA7pkDDiFPLDjIcSB1W2cj0r4Bz8kO8CWvvR4Q4A?=
 =?us-ascii?Q?v1s0fA9s3WipjQW31NQkjBWRENoryYd6BjoEGaybwTnwTP9g/sz+5nhu/OAY?=
 =?us-ascii?Q?GhA5SXujzZHsIMbp+umtryLl7fAsaFeyogoCI+X54aXI6zoAEB+L4GE/Q6v8?=
 =?us-ascii?Q?8gmM/etCYDNimCDjzROiFPyBbIpM7301x7NR6mqL6bjGmnNEzEHFXoL5b+a/?=
 =?us-ascii?Q?W4H0rRzHUaS6gY2b0ZLkMgKIZaGKBaqQ4fub9gIBPNDPwqw0OS0rBLdv/ogV?=
 =?us-ascii?Q?JOTUkDrlZTlKAv7Xp4DhLTOoUnMGslU4P0OwEyliusGha79jDigfJTeMj7yA?=
 =?us-ascii?Q?Yw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c868de4-8811-4c2e-760e-08db24ab91a5
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 16:45:50.6167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9domj+MBBa8hnN2VwxmzLWz/3K188pO1HQRHbk7K/F4esdcVZV7cutkdjVjWAIuzI+n+LMx4Z8HRn7pectDkJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB8013
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 05:31:45PM +0100, Andrew Lunn wrote:
> [Goes and checks to see if the same problem exists for other PHY drivers]

Here's a call path I am not sure how to interpret (but doesn't look like
there's anything preventing it).

linkstate_get_sqi()
-> mutex_lock(&phydev->lock)
   -> phydev->drv->get_sqi(phydev);
      -> lan87xx_get_sqi()
         -> access_ereg()
            -> lan937x_dsp_workaround()
               -> mutex_lock(&phydev->lock);
               -> mutex_unlock(&phydev->lock);
-> mutex_unlock(&phydev->lock)
