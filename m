Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1676CA090
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 11:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbjC0Jye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 05:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232424AbjC0Jyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 05:54:32 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2109.outbound.protection.outlook.com [40.107.243.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B26549DD
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 02:54:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VxMsOrpgQJ+or1xENuzG1lZL3YYMz9UrmivBjoIXXLdRypgnfo2NWTfHpEgL9MILK9tngdIvz8jkYMFFCU1Tl3xGYuuuqM+j7PVHYzGJ2d9AGFE5fIlhAlVz9dGLoqg4R3HmDVNKkp9P5raLrnHGTqQWglRxRUdMvflySeAJj1IhRz7UHWmrsBWAoWo5dKCS0h7lwp5q0EhK14AoBXmoJH7yE+oZy4VAkXLoCaAzbxWIiBlhx2N6vIhGEiCpk+hlObUj+rRbLJo5bgXxRQdfbHJVQ0hon8isbzjhsTP2G9ks6lO0/IJuCrFZAlww+FDI+NoFO3dO2oSyh9EhEiZSLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QTG9/aScWq0P7xPQpUJAMtbExVrIJBKQowCwugqEIaE=;
 b=VTsiz0C8BZ7goChrohcbmX3POyQqSL4jSfYB06pj7TwddAlT6/RI0LIkgxAdI8D+gO2Y25gq/epYhkrhteDTOVlh8tf5njWtpjdJUtwhirUdIR7dmGeaU54CqqK6XHPud4ZSrCjpaQMoAfmvZOZ+PZCS2MvMs+ACK5vKKBwJXh1jKtjP2YRuo+8tJK6XSvlFeRK9xOCJKWB88SlBW7TctU+8LaC4TFXc5Qbdql7HteZdlhhYg0uctO4f62lz5CIFZ2vy72a2xOPFGggOUXrcS2eHNi5IXB7ySkb3O7F0PGuKVyzVdorpaf/hVMHhqalgfVEi/1GGgSyn4BpJRIMvCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QTG9/aScWq0P7xPQpUJAMtbExVrIJBKQowCwugqEIaE=;
 b=T3jFRI8boD3upBXXLaVGOe7qTcaaHunfD7NEwuhfux7kewQqq763IYZkmE1uaFoVVHSmIhLbUBXWImXArWhN3zXvqBbwcHVUAGnifEVTACE7wqt/T4/ohlXxOnL+lu6GB8U7C2BEet6cxqbDruAeAF6XAkqlpmNH6HxK1U3EdbI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6090.namprd13.prod.outlook.com (2603:10b6:510:2bd::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Mon, 27 Mar
 2023 09:54:29 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Mon, 27 Mar 2023
 09:54:29 +0000
Date:   Mon, 27 Mar 2023 11:54:20 +0200
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
        "Abboud, Osama" <osamaabb@amazon.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Johannes Berg <johannes@sipsolutions.net>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Michal Kubiak <michal.kubiak@intel.com>
Subject: Re: [PATCH v8 net-next 3/7] net: ena: Make few cosmetic preparations
 to support large LLQ
Message-ID: <ZCFnzIiwgoOf+SFi@corigine.com>
References: <20230323195923.1731790-1-shayagr@amazon.com>
 <20230323195923.1731790-4-shayagr@amazon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323195923.1731790-4-shayagr@amazon.com>
X-ClientProxiedBy: AM0PR02CA0179.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6090:EE_
X-MS-Office365-Filtering-Correlation-Id: 8653b129-1330-4e16-a868-08db2ea941fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6fWvsGjLCSKHRheS/gEuEe+6YvaImhYqiZc4fTtxqeJStEK6JV5US6Hkt/4htqpTrBQDz7yjxb6Qb7Z5BXcOvukU9lwnMMdAtjsbksxT24xE/s6P+jJBjd9Hc3yZvqSSif3QapCKeKSVJPH9A7oH/i7ADG5aVZxNdRBR82lBjJ4P6Gu4wmDb8uHwwrl/f0B2hhkKt7KgDPI9v1ygTUiAKXKd0NE5RO5dnMAcjMU+Z2zJQM4F8l+qfFlYEPXqdJG7DRzVvHsvb4CQaVSlRgbDOYZgEjtdqzlc9Xx+177AmR7AJTQZtVnAkgJrhmYueBZfKyqZ0pCnXHLaAI32tX7N+/N64h11DI2ZdrhnG60TnwHKci6tORrp/e/KZiRla8fo4+je2QZk3f1gCmV3Hdb2hKWWJyN/ggnuLCiVTfYL/x+a8OWe+wUMFoBrh+wS4lHzUut3pZGem8LuXs+L/f8c18LIqCxqO4y8b8GwRSHMFUzgOD/Gi9XRMtVzNugcAAUfZrbf47tLkO5T3xJcNJ19mfrc0QgONR/A6CjXC2SAKR+r9M9G3moQRheLQ3vDTZWRDnJX2pf7wWdzY3KTIvyTm/NK4FL2gAsdX9b8cUtk5XI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(396003)(376002)(39840400004)(136003)(451199021)(6506007)(6666004)(186003)(66946007)(38100700002)(36756003)(54906003)(6486002)(41300700001)(316002)(8676002)(4744005)(86362001)(66476007)(8936002)(478600001)(66556008)(2906002)(6916009)(2616005)(7416002)(44832011)(4326008)(5660300002)(6512007)(83380400001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wilPe6OqhpnqvDlJHlq16H+0n5QpURpiwsU1zrpN7IORF15bUjve4Ku+fCj2?=
 =?us-ascii?Q?FBeqYwzbhi2AbXzxs3wGnFAjgW79Kbg3NfrHGMCSgHg2gRVi1Kq0F7tYvdco?=
 =?us-ascii?Q?qEFP2y14XECamI6itjvLY5DbBsCqFc8AnPev88YGggpV9L1oHrpJGLutJMP1?=
 =?us-ascii?Q?D+RbK7717T2VTbJ8BaDD6vPMKluaexF+cc1N2A8l1RQ5ePfEByYQoHPNG9D2?=
 =?us-ascii?Q?NR75tZmtGTJ9POhgPEd2ZCAp0MpPZeB+o1Mkyec5KFnbY5X+R2ealtFyyE7s?=
 =?us-ascii?Q?k9v1h8jjk7WHpBj4jfp9AvWvKkuy4PNaDLofAZOJiuJllg+r/liAT8F7FyjE?=
 =?us-ascii?Q?+nanh96Pk/nc6BfOsbV/QdZK5qr7PoJudLmgEDDaV1IWc2A7/oTqUAE9tM/m?=
 =?us-ascii?Q?+nlg8eXfxkyXw0+I1pkKu50/rtnwPss/FlYL8/qUSiwB8ttpLVOeb5TH7xCE?=
 =?us-ascii?Q?JmSoqoL2OdtPUdhskifFaVVTuZD1foYAxwt5zENw+vMSthSJ/GssQ2log94O?=
 =?us-ascii?Q?3Esq1jfgdeSCCaHs0JHRiMwtDfG3oCyFqODoMurERuAaRS+08B4OWom6+rrc?=
 =?us-ascii?Q?I3mLVNJNb0ykD5vZgScr1zA/A7CEd4EjwYMgNsSrCI7HsjOv27hjHRUyjSgI?=
 =?us-ascii?Q?sVolgpnMkbPg5fYk7hbHOQRN8YzN9E/8qVr5cBFC3yqBJiaBHLfHvag2BXWr?=
 =?us-ascii?Q?I181eH4zGkFZXcapvEEguCB8P+y9lVE0i7NyU693PyVYFHOZQTZBJkgd1qUn?=
 =?us-ascii?Q?orFCxxMh54uPbkpqcvD+HTLh7Lc6IRdPw9hexITNIHOtydibIrQQWoXcJiqd?=
 =?us-ascii?Q?HJrTtsbvO04Dw5kjH0tl6lbX+VO7jz6ji65u6MUKlPpC5h1xqE3i7J/px+z3?=
 =?us-ascii?Q?5PM0tl9h+skaqN9pkzt+tPkFtNT+z7GhHkLeWd8NV1owOj033ac8HxZywpue?=
 =?us-ascii?Q?0pHBGYp/RWaSWg53L+gD6tC80dXJCExAaLmJTyMJ9jFgGf9MB7wthT/dob6A?=
 =?us-ascii?Q?H0cOYslAq5oz2LBTvlkFBn1MLUm4vtgEs2E2tFh+D3kQ0kG+ocRSBWHjrBvR?=
 =?us-ascii?Q?fQoRegRzvXcB9CXv71Xzc8tdY1c67qWDjwqZoQi00E2t3aNH9qc3b6jD9KBi?=
 =?us-ascii?Q?pJgp+olRtXZmDFdoTx7v+bgEN+w90ulFBCdCd4g79WileSw3pitzBpRKUkXg?=
 =?us-ascii?Q?Qz/tjlwgJ7QWx2omATmPmFgcXv+HBP6Wj8nwOn/qfW1dzwbWIcM9/IqdvzHk?=
 =?us-ascii?Q?RC704Sh+uWtPCg48YWhP1mRBagxdj7YC2zhY6RDUXOhhzExK3mDSvPzhc4KO?=
 =?us-ascii?Q?0BVFXm0j1BylNIqwOzfcQbvv6VK5x5VnisL8bc6wBD5lYN52Azbbl5jJUiNd?=
 =?us-ascii?Q?ts89eMd05flxTI0dM82HeU29+u9viOBEJJKGoFmSir1+r36/YnZ5kA3B4C1R?=
 =?us-ascii?Q?Qjc5cmh0CcrMfaYUj2v0VxGoUCn79oUZen3JA8TK7R5rytwO3Wr7ZjEt6AXm?=
 =?us-ascii?Q?dBrlvEe4TEwNi2DaETdoas/JufEGzjjzVqn6t6n4oYFdN0EkJmSZHpMMk/za?=
 =?us-ascii?Q?DTPcYZkibC3Z0J4uPNj4U9oJv32pC0+Gnmr8rN8XRb4wTnlcVGnKuryDp5O7?=
 =?us-ascii?Q?aKDqu/dOti53V4qWYy9lH+kfKJ4mrRMwemSws2ohjjP35m++1BolNbVmHvdN?=
 =?us-ascii?Q?QiUbTg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8653b129-1330-4e16-a868-08db2ea941fa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 09:54:29.8652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WWzqIr8gstJM+ZFNmtlCEm6RRxztXxBwffd6dPeSse9M2v0zgYKysL+0AlGn8Jkh0bqFNPFRftGcTyeDv4uTlK5P1LrMuMEB96vutTSdQyI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6090
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 09:59:19PM +0200, Shay Agroskin wrote:
> Move ena_calc_io_queue_size() implementation closer to the file's
> beginning so that it can be later called from ena_device_init()
> function without adding a function declaration.
> 
> Also add an empty line at some spots to separate logical blocks in
> funcitons.

nit: s/funcitons/functions/

> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
> Signed-off-by: Shay Agroskin <shayagr@amazon.com>
