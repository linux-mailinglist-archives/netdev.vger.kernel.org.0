Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5106C5145
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 17:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbjCVQvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 12:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbjCVQvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 12:51:43 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2074.outbound.protection.outlook.com [40.107.7.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25DB5CEFC;
        Wed, 22 Mar 2023 09:51:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ajIAvypgjmfEwIuduVPtWONpAwcjy+JS7NMBzdoV6AZVW+h4ZwSkrHBOy/7yJz3YYavJwEgeg4j0xpqsL2/MeP7TgSi14VyA9syoil+ODGXdAkqYWBDph5XIiAqsnd9O5MOi4Pu8kW50kXV7L+qQ/Hsu4dlMy9l8Slj1idZ4cStazH3D8Ao60kqEG/vLAp/UyzSemawRA7iXmvtEpIOMTqDAtOVtHOBs6dLbKL043DTWyHbm4D8cNoe54EQF1Dh9FkXcG+GcaIDg8KSX7c0LcL1fdLbXYDldNx8zsYQX6/6sg+PsbRGoGLts0NbD0hmqLg3vYzygYaFyfdMj6T5Xfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2so59M/n6KVe1P0FmSxTwqnubwLxHA5SVWqjoSuUJk8=;
 b=mywuyx5zc9uJbIcZjztHrG+xqdARxwA4a+zQIcNpHPLs9b8GDQ31j+BSUPPFOWqXrBHrR113KCp5pFBoM8sWkiJX9qexFbPIpSqSbc2B/ZGTpcgo5Q8xnVZuUCoxmpe8lZi38+rGqoFIWuo4vFD6q+kbCwFL2sc+E1z3lgU786oI0W1wL7h2tn+faSkAD17xQHyLgfESqbuxL9bEToAgrxUkaokjZ4Fb4ZeCKOQt6jaj+bGm/RQC5Q1JAAmaKB806J2QPxJzHdFJaKLdAfO5jts3rMS5WvP6oVACWn4GXKz8XX8Arag0d+x41ox5RutC76Vk5BI5+kQxU95ghc5d9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2so59M/n6KVe1P0FmSxTwqnubwLxHA5SVWqjoSuUJk8=;
 b=Eh4wtcYb55UTHvFhpj2VTKxCAw7+t9D0eJge8Sw8fxugc0PQy563JxXstMGgLuhunanPy2MN5GEW1rr/sGK9f7SQgi/0ktRqUvRKhyrpAJhwefb8ZUmcpNsslQe9uDh95xq9J6GWmjaSVmT1PrTKvVxH05w3iwHJI8K6+TPvEro=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM0PR04MB6852.eurprd04.prod.outlook.com (2603:10a6:208:18c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 16:51:30 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 16:51:30 +0000
Date:   Wed, 22 Mar 2023 18:51:26 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: enetc: fix aggregate RMON counters not showing
 the ranges
Message-ID: <20230322165126.23bwb4rnnbuuwlnx@skbuf>
References: <20230321232831.1200905-1-vladimir.oltean@nxp.com>
 <ZBsw/SRtCgfadtlC@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBsw/SRtCgfadtlC@corigine.com>
X-ClientProxiedBy: AM0PR05CA0091.eurprd05.prod.outlook.com
 (2603:10a6:208:136::31) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM0PR04MB6852:EE_
X-MS-Office365-Filtering-Correlation-Id: 564d57b0-917d-4102-cd24-08db2af5af2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KRTyXrCMwsS9jIFtmp4Q4m86HOVBsf+m055LT5+EGMDrmg8EdL5EcGvdsjDWBmkkaGQVNFCRfSzPygCdReBRtvpO9ipIIWYXBGqDGl4sC68b2aXZfW5FHjYpEEPVZuzVDKVVCFwmBeKfPpd3HlCkffPlQzXCV7JcEFK/cFHmqHdNybgb1oAFuwHiCOH7IAbSZebEADUt7asNAQCOEGJ3F+we20jNB2JztN+nbb2T4MlSTWxQ4AT5RjvCzuoIyj4nFuKoaKp0S4xyY7Ezaf2iblghy2vSOXY+R/cxRN/75nYFLNewom6zZhfYMgzjKO+BRYJ6wByWKQvf3b1AsoJkasLAe+7nkEYRjbkGaIE3zOyXjlL6kWT8J5ofwbJrBx8jwyR75IIXoJl//Vwzukvf0O36T+oo/z9eqZO4ck8WekREHMlsULH8ujy1itKYwuB5jpEO3Ij37R/IGsFdst4NDCDYXTW+8769HURErwg6jiIm8++CUU5gYlFtR4xAI5foQheAYKZ1xdJEHvTy0dNxwIaYzrt1AlaIbFOFFNbTvqassYw5OpPTmyABbQcqHfKIYK7XzCIWuTkf1JajIeCR0frVTtJoBVLy9ajCdlmOPWAfzZUWBhF7O+MIE8yUxXXEdDA90HwdgD8qPQE5DAsEEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(136003)(396003)(346002)(376002)(366004)(39860400002)(451199018)(9686003)(6666004)(6486002)(1076003)(6506007)(26005)(186003)(6512007)(33716001)(38100700002)(478600001)(2906002)(86362001)(44832011)(316002)(54906003)(8676002)(66946007)(66476007)(41300700001)(8936002)(6916009)(5660300002)(4326008)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YjHwXTbFUmJg81Ku30RyDzGCSvu1rntBD8hO2KhL2y9ifLeDQ5s71+lYkHaC?=
 =?us-ascii?Q?ZiN7/L6IT9cxMrS7yu+CPG/Gq5MtsAQ14YkCIRwxQxDMjgq0NuLwCojLjAP1?=
 =?us-ascii?Q?uHHfZdGrK+rmj9s+Sd36w05zfMNX6L2DOCLYA7q3wQyZlF4fhrXCxi34dynL?=
 =?us-ascii?Q?R7yK0L29fgnILzyy4/phLUP2p2pxAndJKVGKaTKkAVURh6tkXq2BAnPs2YBa?=
 =?us-ascii?Q?uzk0FsL699wTBEUWMnKoMnRFazQUY3JVHBaqdeRuvOdJD0Olg8QD/EuaPLUA?=
 =?us-ascii?Q?c2cuzFGAlNq1DvXvxCJrMkhqGNQY8R+arlD4hGNLF43be2YPh+Pvfzq3xqaQ?=
 =?us-ascii?Q?FMvcVIJ0CApCTLY2lbG+bzYk0MJJocdJ6BV6AIorjaTkb9SQYBtYwjZ2f6Xt?=
 =?us-ascii?Q?lVSANXQzgCSahwHyFuSt8I+TrocLaZsyGU3KhEuUbFDyEFQTuhcNqTP9yJ9/?=
 =?us-ascii?Q?ZpkwLR3bv3VGhp9DDaMYlXD24iItsEZJ6MxCtsOlZjwCPZGVjVuBCocCCNH6?=
 =?us-ascii?Q?gziG8nMpJoMl9c47QUiJ4EkzoKkjpDWMvQC5MnhOx5cK0ki5RIeyrvNYltoq?=
 =?us-ascii?Q?g6RU/OLC4URZJUtFIs8lnOTH9wlNhfvnBjndfyyx/ufPoRb3IlucJt7cLTqC?=
 =?us-ascii?Q?SOjBva0bkNvR459QH90L1bPjZI7QSUAdV7cymuMC3wGSY9uufkDUDx7uB+ft?=
 =?us-ascii?Q?Un7K/VISSdL4eLUWSs7Eq/htuu1Uuc51zXPsbUu8VPMY73u2m108XuaJ+4F/?=
 =?us-ascii?Q?upqZvja5ioRx9nTiUHn2o7im1q3Rs3Ok178kdtdFhzbjkFWpvz16BE/YjE1q?=
 =?us-ascii?Q?Z6YtdV7Nbx3gruK+mHs/qY+ryrez2fnTAllnqmgHcNRqmseRSjzExILqibNJ?=
 =?us-ascii?Q?CHakYqahDkckSvL2ln6inL9SAiS+QelCgSPfUl0EqRMkArfod0NBZJDnz+q/?=
 =?us-ascii?Q?0PXB0iiNg1xZt5uIJTpNxFvQSZOT5a5/u2PGRC1w9eYmxaz/aeUJuXgTKjzm?=
 =?us-ascii?Q?NLcLjFUYlptcARxDale3DepPe4AaPvhExe0pJdXOThvBRdPD05PZXCVXb+Ty?=
 =?us-ascii?Q?v/+RcHLg6bqGIOl3mmdcv6XCmcIp3dPeEMzK2LenM+azxTXZEWUiZnmKODYQ?=
 =?us-ascii?Q?QEwadn4hOXbsbV2D5+tdliqMFcDvRZwTEnCMdaAgr8Is8xdmGHO9hO2GGHV5?=
 =?us-ascii?Q?Y2tGFnUhrLPgMCqlJtH10j0tD3byfiEoBHsyBpqu25YuBQXfhe9U2a/LSvfs?=
 =?us-ascii?Q?w1EIOpCYzAPq0fkq7dKMnlWTb9FHfSV/WQXHAaSFVmHCK+zZmw5Xkxsfom/i?=
 =?us-ascii?Q?qYQrTPhCTNgsKHg4wGIFGxP3Fabs6WKxqB+pFwIadbTNM3/Ku1WybGM93FBc?=
 =?us-ascii?Q?+AgqwWQGu5/cozgjLZ8pvFJ/iATMac1hYeSmzJ4vtUjVlGejgcKa6g2iv2YP?=
 =?us-ascii?Q?/agc3caMII2fq2jPgEOfFUcA+lm+BrLrhZOf369QQ9baCQ1GVLG2lP12ZT1E?=
 =?us-ascii?Q?jcpi2wx6cX5wHPsScZg2UuzgbCc1OSuA7zpQCz9XWHUTgPlUC02Avzp+vQZ4?=
 =?us-ascii?Q?nq+fJplhOU55E1leRBa5Se635G5x5g72YSL1Gcqye9QT/cZQ1Ge5is/kjuBW?=
 =?us-ascii?Q?pQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 564d57b0-917d-4102-cd24-08db2af5af2a
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 16:51:30.0197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nehNIRlOStZrH/IdYBeIWB2lZDPQjUQhu/qBVaQZxxH2BV6BgkzFT+3OJtfH6skRG/VvybUs1jIDYbBi0sXYqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6852
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 05:46:53PM +0100, Simon Horman wrote:
> This feels a bit more like an enhancement than a fix to me,
> but I don't feel strongly about it.

How so?

Since commit 38b922c91227 ("net: enetc: expose some standardized ethtool
counters") - merged in kernel v6.1 - the user could run this command and
see this output:

$ ethtool -S eno0 --groups rmon
Standard stats for eno0:
rmon-etherStatsUndersizePkts: 0
rmon-etherStatsOversizePkts: 0
rmon-etherStatsFragments: 0
rmon-etherStatsJabbers: 0
rx-rmon-etherStatsPkts64to64Octets: 0
rx-rmon-etherStatsPkts65to127Octets: 0
rx-rmon-etherStatsPkts128to255Octets: 0
rx-rmon-etherStatsPkts256to511Octets: 0
rx-rmon-etherStatsPkts512to1023Octets: 0
rx-rmon-etherStatsPkts1024to1522Octets: 0
rx-rmon-etherStatsPkts1523to9600Octets: 0
tx-rmon-etherStatsPkts64to64Octets: 0
tx-rmon-etherStatsPkts65to127Octets: 0
tx-rmon-etherStatsPkts128to255Octets: 0
tx-rmon-etherStatsPkts256to511Octets: 0
tx-rmon-etherStatsPkts512to1023Octets: 0
tx-rmon-etherStatsPkts1024to1522Octets: 0
tx-rmon-etherStatsPkts1523to9600Octets: 0

After the blamed commit - merged in the v6.3 release candidates - the
same command produces the following output:

$ ethtool -S eno0 --groups rmon
Standard stats for eno0:
rmon-etherStatsUndersizePkts: 0
rmon-etherStatsOversizePkts: 0
rmon-etherStatsFragments: 0
rmon-etherStatsJabbers: 0

So why is this an enhancement?
