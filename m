Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83AA768ECB6
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 11:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjBHKXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 05:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBHKXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 05:23:33 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2091.outbound.protection.outlook.com [40.107.93.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340B73B3EC
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 02:23:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=as+3HVmSjDF4uTJZ1wr2+3V6wSLNkGdgbbL/adRav92ZChY7cF28g6Gc2Jo8ryISmb4C22/hFYen+Pjrakzll6ZwqG40eQkx4McUpcy0y1HpruVQVWdB040986ZE3LrElTK6VfwG0ZIzPpShjoGDurbDzSXzk3Au5L8Y8GrcTJu68ls+IgNhF/7D8WxWpF6ImQTILjfJt9O6pIjypxx5fS7wEakueAIRNTygOxb3sDKJITMBbkVfQm6ihKtHZAnunwb/RDXl/YRMdLCFuwe0619OLbfQ9kftH+M9kGmkq6pc99pIRp35iz9Smv0HgeVc2MnmHpt+CxdPvkothY7aeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=niBuY/Pj0LGKTNJZBPYqbAubLg11WCi2VYm1P534P8k=;
 b=kme20zCW0BKNAieYNc8Kysi6F8nvmkBbR5XRrhOvmw2dK3mzCC8q5IP6gXRRUK33uiFXVTwWJ8KJu0/bL+tbOFRyYxFLYiYvCjo693JAoaBHwVZGQ6pIAMZvo2i+qzeGcp8H1BvcVUWPPcQORuKyxr9cY10maiNe+nJExJkC6rt8HD45GE+8lxFbBtCh+vX8dwG/vkrQy/20AEOo30D4HdsLhKmqtlh/lm6nv8Mf3B3fEx2d+l6bMGATvsSnigq+jTc3HStxK0wEn5uoyULMNRyfG4T7dJLEMJ19cjo6ciefOSqBdzpE3U1fO5Ebg2yw9shiElEN2rZnOcEhIbLZEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=niBuY/Pj0LGKTNJZBPYqbAubLg11WCi2VYm1P534P8k=;
 b=T6MPgAAcOk1o3800Y3EK1dMS9quXzJX4l26ScFvj+H2ZuYm5XjUk70s7ZjJ0eqnxGa1RLmTp40V6ANRDbuX2xhFzVCJD2C7K/CqG1jGs1xwpSyhNg/fDeKYoUZAVY3umo7XVMtScreT+r2hxBfJxa1yS47OSPNj/k66M9gTKExY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5490.namprd13.prod.outlook.com (2603:10b6:806:231::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Wed, 8 Feb
 2023 10:23:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 10:23:28 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Leon Romanovsky <leon@kernel.org>,
        Chentian Liu <chengtian.liu@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net 0/2] nfp: fix schedule in atomic context when offloading sa
Date:   Wed,  8 Feb 2023 11:22:56 +0100
Message-Id: <20230208102258.29639-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P251CA0008.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5490:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ff06cbc-b97a-43f1-21de-08db09be84d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eupLTndT2BRJjVcB2lMrkSjbQNyqIDlX/FrXOtiUev1uHnDUVWuwz+9/sLVFwqPIvjvjHB5+ZJnKZW/ufalZra/Ln14UMa9HURc9f49DWDiDAaeUsJKJhLY54Ejyrc+FwoWLXhZrupfjty5hoshgSt/PlM4WV5+o3irUMUpb5YSjQ68rm2ONhEaeyYJVV8NaOhkeKvtkDAZR3lUePd99af+KX4RcH4T7yKGO4msH1gaI1JHUSYCPrzuLFlMFRn1VfN6YnXDJ05jFcJARlrc/QQwkJawrOHU09cY5/47b3wN3lssqa9NeZfamu5DFxWgKzoR4jRXGnW4U9PesqZh0g+BdP9AVgC3diVbu3/9lPLN9+p7KGy0TqKlvHNKlBpTgAgw5J5qEdWfgB8DJewccmDxuk1f2VNHULqui1yw0NKppklTUIOwuAqQOln8TeOnjWzl5h2rTfQFmDhYq8mzMhGHXCfT4BzXlGaDiGvvq/WHI7gQC11qRa8NxhfgvpojLKR+xPvoqxi+cysxGT/cvf3TNGsJrdBN7GNdjpLXSBrgTuCAspCTUDqcLnb1Tk+cuuv55YmLxsCftjr6yEd5jMUO7Pu2YlQHWK0YgwMp6xjzXZXR9ZL+p+EZQJjBIO1m5gIcJJwhY56+KVIvpC2avKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(396003)(136003)(376002)(346002)(39840400004)(451199018)(66556008)(66946007)(8676002)(66476007)(4326008)(83380400001)(41300700001)(2616005)(38100700002)(5660300002)(86362001)(107886003)(6666004)(6512007)(186003)(316002)(54906003)(6506007)(1076003)(36756003)(6486002)(110136005)(52116002)(2906002)(44832011)(8936002)(478600001)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p0ggEdyvQ6O/M0jzlfZiW0cDYu4Jd/TL1ynnow4AQI0kPB7mScoJV4LbMowp?=
 =?us-ascii?Q?ywgLkN9539WaWPI0WbRiY3u13u+baI8PtEX0khwAbN5w+Z4L2IxRyHGObtnW?=
 =?us-ascii?Q?zdIJygLKvnWpr6dlGKM+WBccBMu1bDiARA0MAnIqH3tn1OOb30WDBknF15v9?=
 =?us-ascii?Q?/+bxtaeaTsXIF4CqPWe4FqUZ+pnCo7yJqybOVtCYZIDpfBDzfUkf9RZI+ua3?=
 =?us-ascii?Q?RaZR2NE/Fmrn+5jQzwS4NeuEDL8mUDmq8Sbz4kXEOwr+XAnispsayMwzyuDj?=
 =?us-ascii?Q?RmtaMH6wKHMmmfzg6VJREN8w8beapQk4h2ZzXi0wkMJ4gDfv+e66mGGG+jw4?=
 =?us-ascii?Q?1e2QPVNs8kMSgwxIOXpWYB6XFnCkravg0axKk25EIz2tkU4W3rjE8BWYIOsP?=
 =?us-ascii?Q?mjP8EdeFsyHsHwKTeJYZ1ASOgIWTLWDi5n6N+v00ta9ifoAOwB9RkrJEDwgR?=
 =?us-ascii?Q?+SsOBucIidjsJUMGEb2OttYKTaAhWDYWt7sT43ZgLMQl0hTO6kuPytWE9NUB?=
 =?us-ascii?Q?clxfK2lzPIE/exwpWP5R91WuFL4RzqXI26a9BZFtyB2NYFkY7vPPCLl6HRuz?=
 =?us-ascii?Q?3b9OWPDE2fldONeD9pf1EWxBLQz5/Zs3+CndlXkwpzwRMGz9SLUa4YFSYWnI?=
 =?us-ascii?Q?FUFhBHGDSVv6/TBCv06D6aV7s4BA+5BP8QiEf1+xCyaMGaOvC6LhZOndJ1Jl?=
 =?us-ascii?Q?Dmv+k5nBbnVpSBySfy5Ex3S2wmYp4YZ/zRIeTLblX9gLvID0oVSo5bpneAYV?=
 =?us-ascii?Q?glpLXol3jFP39hmPKJxmn8eUnVtPA3xlpXO6Dsxy5Fss4bavSS/p7/p84214?=
 =?us-ascii?Q?TUFBPu35BgWYV/kfngSiKPHLxYqERCInC3PgVPYFJLn1cq2itd4Qti/vUz0o?=
 =?us-ascii?Q?xxLp9zVQj1PYH9FVq1jM6cQ88/Ji3LK3VByUn5WTDzsG60SByxnzcsjY0C1s?=
 =?us-ascii?Q?OZCFjavUug5UQ3Re8nnQATVwxLWmytWX33SHxSLqAZzmqliSMci7+RQUzVzy?=
 =?us-ascii?Q?gRYMHmYNgZSBG6S3JSMfuXNXYBPAWJ0JPNPBsBCAhDbi3Avj8PRPluhOVdFi?=
 =?us-ascii?Q?ff6K6iRW4RI3F/cVlGpJOK+drzl2W5/JrjcW702Tx7Qz8koXDIzOIW0H2SFB?=
 =?us-ascii?Q?Lja//l0IZ4gp0Yu/VJB3ULEp2qJJn72M9/0Ip7doX3iISgtG1HSHh7cQ4y9t?=
 =?us-ascii?Q?eQ6reG9kltjFzDtOLiVlbS5q7IN4GHEsmq0PW47Uj5Qp4a6K5WJ3SC0XDHE0?=
 =?us-ascii?Q?c7m6HHEWtpYdMZqvRGZYUmN3jQiqzm8e85LMTs7e7kvW/5BpPqON+h8EUAwH?=
 =?us-ascii?Q?BTwBew2FMN9I7WwMLi7G9pxkGKUjcJC52/MT6hci6COIijN8Xc0OfoJHMXC+?=
 =?us-ascii?Q?0M7V96P78VFo+v2fQXRHTnETdDeBKrnQaP9nl+hkauCsSyrjP4QZlvz5ts2z?=
 =?us-ascii?Q?FH+XcQtQraLy/xCPEVvs5FSK79PU64Qj4HRiE82Hdm62met5zlQ6ahtXVulf?=
 =?us-ascii?Q?yh78TBrFhhYgt4w+Dkl5SDFg6UExt85RFkscbWt2B8cWSS1EdWs7KKiQkeHo?=
 =?us-ascii?Q?0QLnnu0r8zz1tIuP5GJZH8oP6vVi4KZr1q7tXt8nuV2yNApmHdVXShTRNjRR?=
 =?us-ascii?Q?mADKRqwnNJO7rCSlxMrvFGXq1SXFkG2YHOveVs2f1b6vzPb6k61C3WLn6ZNT?=
 =?us-ascii?Q?DzFV8w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ff06cbc-b97a-43f1-21de-08db09be84d9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 10:23:28.3908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sEGlKoTSgN/7/SjSYU0ZOwDhpLWWezuP0Ruqk1Z/nmt40JHKsmkHdyAPjUNlFZPIEw0vktdxUVAcAqIMY00zwVd7KiIJ315qIFPG17voKs4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5490
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yinjun Zhang says:

IPsec offloading callbacks may be called in atomic context, sleep is
not allowed in the implementation. Now use workqueue mechanism to
avoid this issue.

Extend existing workqueue mechanism for multicast configuration only
to universal use, so that all configuring through mailbox asynchoronously
can utilize it.

Also fix another two incorrect use of mailbox in IPsec:
1. Need lock for race condition when accessing mbox
2. Offset of mbox access should depends on tlv caps

Yinjun Zhang (2):
  nfp: fix incorrect use of mbox in IPsec code
  nfp: fix schedule in atomic context when offloading sa

 .../net/ethernet/netronome/nfp/crypto/ipsec.c |  39 ++++---
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |  25 +++-
 .../ethernet/netronome/nfp/nfp_net_common.c   | 108 +++++++++---------
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |   1 -
 4 files changed, 99 insertions(+), 74 deletions(-)

-- 
2.30.2

