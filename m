Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC5A5B00DB
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 11:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiIGJsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 05:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiIGJsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 05:48:17 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2122.outbound.protection.outlook.com [40.107.96.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366819D8E3
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 02:48:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hFU+eYgCcJLcVshbzNuqhN7k8d9xEy7l3nPzu9xxJ94UwYxh6G2iw1tqXS42ENPVE0wfJgIqJwTYa/tRJMgmt5rAX7Xl4H75GngTU08UL9jvKdwA5UvRyxVm4EmSU8NZ8H6MVGgzhjx4+r2uExtpeKkkSiOCEyx5tFtGUKYy++QB2xfI6WlMbs3j3/YNraawZK4VNwllSz6dhZW79vCdn5Vzzq6tosiJYX2yqk1pnCwtL6icXas2UriLncHj88OKBQsouwtoLKIB8v3DAC9urzpcllf2WXvYpcoEYKvDnrlrfMa2ZI/J4U1AZpLiQ1Cq/ZrDlJFliWjpb1FbNE8ejA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A5QiYM/RacOjRFgaaSwEfTtrsGPeA+5VNmCqXUrNZag=;
 b=QJTb5CN8JnZ7Z6bC4RvUVSmFRVnZOHv++Byw4X27xd+k1kMMszqVDFcbu+EMGY+Q81RecOkTq06lg+61nm/8Kg4h03D/TaJI/1YgvfZfntvY7oupGWy/+CCgUkoplADXLZ2vPL0WDH/6XoS5wLF9rrAvvueWWxwF7+1wtczawweAhzOk7PL0tkMWH3LOLoswPmlRgJnqdJpsvxo11J5sBD1I1mVsUwm01kv8ibMmg263kKObKnFY0CJ7ry6RjJGgJ9kkmPfO+Fp6dWdrnUwoGSiZj6B9C6XwvTsggur4l84sDbbz9Ns4iZtYpMjm0XbJfQqXLro1YosrY1CNgf1/Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A5QiYM/RacOjRFgaaSwEfTtrsGPeA+5VNmCqXUrNZag=;
 b=JvARGwH7p5A58nhgtDiGF+KN0F9gq2MwIvLvSFkBR2OT0qie0T5qAGN1NPTFk0er1fHtJpd6vJBZ5YMeuu+Ir1sCDpzMT/HjM1nYiQ7kgAla156jyyoRR0ekouwBBPysEkR8ypFHrzBHAvfodiWRVra7EAO38UgMlLHM+5qLuao=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5876.namprd13.prod.outlook.com (2603:10b6:510:168::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.5; Wed, 7 Sep
 2022 09:48:14 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576%9]) with mapi id 15.20.5612.014; Wed, 7 Sep 2022
 09:48:14 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 0/3] nfp: IPsec offload support
Date:   Wed,  7 Sep 2022 11:47:55 +0200
Message-Id: <20220907094758.35571-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0093.eurprd04.prod.outlook.com
 (2603:10a6:208:be::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5876:EE_
X-MS-Office365-Filtering-Correlation-Id: bdb56eb0-f145-4b3d-f794-08da90b6157d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +sO5o6xPkK2YftnSLySF92GTLUR586eHyrO4+C5X43gYX8vD5YbEEinTTHfoESxLCn1jR2+l3TV3FcTUUfgzWh2RGZDLxUjtAHlFPP+nzPRSj9/czguqaORiKcAV2zd5uh3eIVwu6A2oR+jdBqxIkELG2u8921nh7EZ14XLxgErs5bdaZ9nvhh4F5MJKor6+ywcESOaOoAy2pLis2jXAQPcwYM8czH2ptZQqsHE5OvwEQ3q0u82aAoXiIcfwEXlRRPdzS3GeDwCrvTPMZara6rnxveNhfHOWtJFlVIIP8k1W39TChxnQr2JyLL7PMLfcsDQRva0xdnzjpNGdbmnNt4oyzaXP8FYsOMVeO58QDW/sd4Z3NhYSA7uxEZexaoHpotP/a3zNn8slfk447BrmEGzMO57u0GvDDhvb7D11OcwPpZxyI6GZ2XxOpwRzxg2dpRRBq7J8t1E6Yo/O32OEfzj4qnW0DCqT9Lrt2Fr2okCh8BOXOT+N+366lg32k6P5m97v0PfQwGsM19b1NWnHCij4YCWdE4r2Ft7gpiLl2RA43xyfZvZNQ7agUOAcasJJqgkefM8dKvPu9VpaQzDgNTsaoE5yY7odydl8LQO7U2PIqZ27Zm5IyGoILUpnRfs5yL7ng/XjlftOxnsHnvWESQW36ryZLhpYTq7c9pN62QgmwSmpNEnrVIN7TNBzm9Aarv8vkoNCrDljB+mgLy+xOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(366004)(346002)(39830400003)(136003)(36756003)(66556008)(66946007)(4326008)(110136005)(316002)(8936002)(8676002)(5660300002)(478600001)(44832011)(2906002)(66476007)(6486002)(6506007)(52116002)(1076003)(83380400001)(2616005)(6512007)(6666004)(186003)(107886003)(86362001)(41300700001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0MeT2NCbJdVTX9Rojmu7wot4NhXEwmUAgoSYYFtvF7izUezxlW4ql3LgcBLC?=
 =?us-ascii?Q?KdJ0HUHQL0RSZ3tJEGCGTvet+U4k5nsScwMGBzfB4xWZOXQ444p8wV4oxCxr?=
 =?us-ascii?Q?hb8o/F96s+ggzaTzVQv8AVDsptdQBVT2GQFC2+oHLtNHA9w/O4fZtC4m9pOr?=
 =?us-ascii?Q?Wu8LsOaIs2yECAY7O3Xem1gDWkRmTswGsxryqYQnWOnk7qro8zdHE51J7tJP?=
 =?us-ascii?Q?200lcAZfnP2PK4hfApq23lBGHnFN+CWIsxKqAuByAUdINEsW3zEzGDPYw0Fr?=
 =?us-ascii?Q?5q7J16Oem7YK1S9eTVP78uW7wkTKcXH7332BJ7enrb6u5IFEWkj1+me6pK7a?=
 =?us-ascii?Q?jMfFJSuCPyjF/pM92vEJucbCKa2y+KJXfcJVgp2TWVxSOUSbtpPAzBTztgDH?=
 =?us-ascii?Q?V9C2R4BW3ScH+1ZZx/lRdFvRte2JVLNPdF9syh8t9a5VxKmtwwh0SFkdDxXX?=
 =?us-ascii?Q?j7qTTPaTkGSQma92RSZgX9YHKOItpORn/zx9dBC7fyGRvbLeD0JjUvFRoyfa?=
 =?us-ascii?Q?rsre3+xv7U1qZFm9m6NyAhf0Gtrg+NJ5MEOnYtkb67pk6b8bJUD/axWe5cOW?=
 =?us-ascii?Q?y8Ie2Y+o/j+rjPezo2Fx6Tx/t9j4qplfQjRLz7SNMlhDvfH4uGtMp7SdgUkG?=
 =?us-ascii?Q?klpfqiyjtiuMkWCO9bnPZivg6OwHDY2ZEzLq+6hln0QYUhr8wHGh4zUdSkci?=
 =?us-ascii?Q?mN4Ml4VoddcoF4aittj284brrRz+kuhORq1OH0qmlhtDFU4ibqVM+9BbJwg/?=
 =?us-ascii?Q?QeLxsAsp0OPMnnL6sdbJtOJpPQjQ1J8z1CBn+AD4bN4XtHjHYhA8A89ciDuw?=
 =?us-ascii?Q?Mbt55d3oz1c1w8EbBIb9Oh2uaSw1WS56A+p1fkDB6G5Sa9PR56DFfRoFnYLq?=
 =?us-ascii?Q?jjuSTtncfWmuvQc1VHorPLL7iPQSbDOwhS7oNogYtGrGYgoiznnWxakA5i3V?=
 =?us-ascii?Q?RAMv8HSahsZL8uFxgK/RbezUmLzkOR3lfnWtSUgVcsZrb8aSTOsCm54J7PM4?=
 =?us-ascii?Q?dYArGGPXEG544y9UFNyF/VaDlTz0ymh7p/NR1z3E5NtHm2aE9XgSWTx7deFd?=
 =?us-ascii?Q?5EUNoRJ0xxbseKNW+OJ7ABiVrhrka6wjVcgZ5hoWqlUzwJ6TG1UJNkMvj8Xg?=
 =?us-ascii?Q?2nUMGwIqMVaYtMoQukNKVPyIg+gdMA0smXNTOO+Gc8KmOU5Q62tpOMtzfGQH?=
 =?us-ascii?Q?n5c58WfVHNLAqhc1dHGGHM2/A+NTTlurRaENgAsCG8rKjIMPVDQZdduYm4AO?=
 =?us-ascii?Q?8fGohuSCRRS5BXVnzTWxIAsCC7zfxO0CmXY5oC+28JtWeeHKUxirERVajg1n?=
 =?us-ascii?Q?jJm0JIn1oMt8WauLq9N0OFjeiqgObWY69f2Y42XCc77Jx5zu425Nw0fMl5R8?=
 =?us-ascii?Q?5+UxmOfnpuhkZKo3MkHxrnEGYUd3/ynUmccw3Z8JrLctWlz37ctZgKIHyO+k?=
 =?us-ascii?Q?qYvYO6aYqS/LERlzA9EJJ0lRo7NOmSh4dlXdkSyx57T6Jre08dx3sHaZdMRq?=
 =?us-ascii?Q?XCVeWgxZFJpDvSwZcFbgxJS7oXeGIuW4DE3y4L1R5Tf7ltSZOen9zrI7PU75?=
 =?us-ascii?Q?AOZtycHSo4uwNVb8wBvBx9yHJ9dbOK+Jcq0Ugv39TILVD9MJeFBeciOEFQMF?=
 =?us-ascii?Q?e8LgebvVwMBocn6Q/4a4Zvi1Q3Pf+TqY1v7ZLC+IjmW02dFkdl2c7Bkb1PLT?=
 =?us-ascii?Q?HaIBIw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5876
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Huanhuan Wang says:

this short series is support IPsec offload for the NFP driver.

It covers three enhancements:

1. Patches 1/3:
   - Extend the capability word and control word to to support
     new features.

2. Patch 2/3:
   - Add framework to support ipsec offloading for NFP driver,
     but IPsec offload control plane interface xfrm callbacks which
     interact with upper layer are not implemented in this patch.

3. Patch 3/3:
   - IPsec control plane interface xfrm callbacks are implemented
     in this patch.


Huanhuan Wang (2):
  nfp: add framework to support ipsec offloading
  nfp: implement xfrm callbacks and expose ipsec offload feature to
    upper layer

Yinjun Zhang (1):
  nfp: extend capability and control words

 drivers/net/ethernet/netronome/Kconfig        |  11 +
 drivers/net/ethernet/netronome/nfp/Makefile   |   6 +
 .../ethernet/netronome/nfp/crypto/crypto.h    |  35 +
 .../net/ethernet/netronome/nfp/crypto/ipsec.c | 764 ++++++++++++++++++
 drivers/net/ethernet/netronome/nfp/nfd3/dp.c  |  43 +-
 .../net/ethernet/netronome/nfp/nfd3/ipsec.c   |  19 +
 .../net/ethernet/netronome/nfp/nfd3/nfd3.h    |   8 +
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |  11 +
 .../ethernet/netronome/nfp/nfp_net_common.c   |  17 +-
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |  22 +-
 10 files changed, 924 insertions(+), 12 deletions(-)
 create mode 100644 drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c

-- 
2.30.2

