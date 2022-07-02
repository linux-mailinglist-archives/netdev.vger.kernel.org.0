Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48052563EEE
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 09:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbiGBHgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 03:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbiGBHgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 03:36:11 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2124.outbound.protection.outlook.com [40.107.94.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B581C12E
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 00:36:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qd5UeZJf9EQUuNH5t94Lfuk7A84BRdBqrphA/EvLR9LMfe11yT4XIM8R5hmJMA+QRL8JprULBx94aRmX+H2ilT3Vg7SBjsW680lPD6xdANXiCVYxX1BdCEJ3Ay28QiKFdKFaiZgM6FeFP5llxXJL9UQ0p73GrzPE74I8FsuVB5l95guYeM7aas1GARBSwhTMulFYbfxm5C9Js5Xo9CmjWaufvIlEwqvSBT2/RQPg2gANPWn21OLHWr14jH0fVMskoJR2H3qrWWc0gegsbqq3SNn66CtLGif/hXE/3b9ayPf479ktjZ4tn1qDWcdN0MZ1jMUztKJPrgiUfcLd9aZ5Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V/53cl+9Kr7dfgXzA3BEou4RVT74KSPvzCAAxo7jkqc=;
 b=k4ipWURJqfQlhDHbr5xBWEkRxMrRTMHzjeR77SZUOqO+65oE1EkARAF/dlAcPK4msEaCGd/KRmZSmnjsEPhEdV8ZtRxKuWBgXK8HMcU8DpAwIejwOah6OW6jPrRHCA2NAiKFOjoCrkmCOaFN7f9KDDZEil/8HwyJjv5gssQr2E+qqFLBVgVd4MgADYD5m9/XsVrklVSaOxt64z0PeH3m8J1RXDd9T1VDeD3ytnaDnFdJprWXwNAqisVCOyBUBgVTQz2EBAipi+VuX5GpuCyDeZ+OKrOMjp+L02e8bz0ebfMBtZ0Cj4b57Ooqe4XHDjBozixMwY7znvt3PJ6VOAFSsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V/53cl+9Kr7dfgXzA3BEou4RVT74KSPvzCAAxo7jkqc=;
 b=Pr2XdmuQNb3MSaaFAIj9w6Vnu2wlpcCPgtenSUIQz3rGxkTPqweSh3dKy6/I5/WP1Mdv625tyKwBuxFEwLHGHmm6TvtRT3RTDirmf6dIT+UQL5nxK6cS5rlYavwhS1u54/Cz+ZNnxHChDQiqbTexBOpPOzm0nMcx3wu1rFCSe1c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM5PR13MB1068.namprd13.prod.outlook.com (2603:10b6:3:71::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5417.8; Sat, 2 Jul 2022 07:36:07 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::bd99:64d1:83ec:1b2]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::bd99:64d1:83ec:1b2%7]) with mapi id 15.20.5417.011; Sat, 2 Jul 2022
 07:36:07 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Diana Wang <na.wang@corigine.com>
Subject: [PATCH net-next 0/2] nfp: support VLAN strip and insert
Date:   Sat,  2 Jul 2022 09:35:49 +0200
Message-Id: <20220702073551.610012-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P250CA0017.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9605c707-8aaf-422b-1ea5-08da5bfd8674
X-MS-TrafficTypeDiagnostic: DM5PR13MB1068:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0MQ/hwkDQ/4v1bmkjoh2Mpt++4ZlmgdVqcFQa09LFLR+0jujME7DjF/UP0ZCPvePz+m1zzeLXyU5jIXEPGHDCTU5WUrWNuF5xRtz/q+LRS4Wf76bnGINh3Eehgc2FLQ/RSIodXha0RQ+T3SZ5U+Ck2KDVm/G3lKgul3MfGoqi56K7hnJ+1yGQHWTbHAdxrmDrfQoeekAb/E+/t3x4+/ma6jnPRzYzd3x2uSNZq/tmJfAbX4opymm1fipZhCbLsa9wgsMftGfBBXo1IsAIsKZEoTqNggSHYrZhv6zs/6yP4cfUJynZuS6KH01tFoKdfdNYFF3XXauUyjdlkySjmwzK3su4IZKt48SxBdhJBSBFlBvEg1drks/FRX7T+Y1FWDgPHrXlHwNtKYEtqxCNTX6Awsnca+eFuuW/v1qFRBkyDiI5xsC6FU+BBeM1ZcepsUKJHm4dmvWq8NbfQHQTGxKsichCZoe5qooItmDXDkzOXPV2rO9SuAOl3pC7+Q+tl388T6UMVhww7teuQs6jVwU2S5ihTz1cgaF8ls8h2P/+Rf9oPAyxGtZ/wAeMRXbzw7dpvXM+62VQuvLARR5c9iP+HMB4U2jDWDTvaWmaYtK+EUOCl0rdBA2UuWGP2mOzNNazsQNOfd8jOXEuH0qA7eYNHZpitqxp73xyAQC04MpJC5GM1AV7n2+0aed/XuXiHX8jvOpAYY9p0r+YgUY2hWh623NB747Ff+wzL6Dsq02xdSWvSBpH0uDLw5PONelPFe3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39830400003)(376002)(366004)(136003)(346002)(38100700002)(478600001)(6506007)(83380400001)(2616005)(186003)(110136005)(1076003)(52116002)(6666004)(6512007)(6486002)(41300700001)(316002)(44832011)(2906002)(8676002)(4326008)(86362001)(107886003)(5660300002)(4744005)(66476007)(66556008)(8936002)(36756003)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tLcpcGnob6PNWKInSaaermqbLP+Bh4AqNoXj4g0Qm6Gx/ffCejmRZxxLfWOb?=
 =?us-ascii?Q?VvJe5soYbEMPlsPijtXaONj/umpyKB3gTuGRVeRohcN+AdQF2YWwRXrgiz39?=
 =?us-ascii?Q?65iofR9HoZY2DhMP+/l7O/b3aedXfIk+zqvRjt2Rl76zpN07HVyMLplkS8oh?=
 =?us-ascii?Q?/juQ0TDlJWpHfn6GzkPQ09lMS6sCJiaw+CKucMlrD9jQRUiYMxIv1hB27bGj?=
 =?us-ascii?Q?kmst3EhRwgh+rOg1a3zxiv7xoKwCoCo90x46jd79lQQ7s68OG150xLhxlurR?=
 =?us-ascii?Q?BXgb1t80LB+jskikfAs8nYzWGIzzkwXcP5FL69SMAGELSjWxJUKRYQRu3tJs?=
 =?us-ascii?Q?MpEqB19o+Qrp3dEfu36t6IoGnupa7L4CcjQLYsJiHnEgNT0f3i4JgbFSFQVI?=
 =?us-ascii?Q?Ap+cbf2RcCrsQz81Bc+0EBMz9Dy6ppnXw3wD8yUKR+0v6pqAOtLzfpxb7EFk?=
 =?us-ascii?Q?MdLqfZ7Vkq0/MqS3qA+FiD/xO2udYHMD0zWcUyE4wXTPvM7w+u0/yJd/hxjc?=
 =?us-ascii?Q?34HZwtQClh7jiNp5XwRt0g606QF6YqLN+Jk9neBg4IgdDQzKai1D4s0mtYy/?=
 =?us-ascii?Q?V8h3LsW1jr4lN2ojIsn06ZTaPj4iVT0sceG4RFOevjibnllt7DatSp0AFxYJ?=
 =?us-ascii?Q?dUpsSfEFNQIsHYhnOtr5K/wGcmqrJVXUFEneiI1pMrp49WcsD2FNSfJ36ATF?=
 =?us-ascii?Q?uyNHT6O0tA7vk6ZDjv0mbLs/8nObiYKKTDfpKRcPs+uzGWbIBa2AbWKNZBHu?=
 =?us-ascii?Q?0TK+pbUJ7Xs8Q+THtAnh1OkOHcVsNh6uEsBHbQWDCdl+uxpdhbVRPpOx/16b?=
 =?us-ascii?Q?vAV/e9JgvU5OB+5Lsso5zVmS2tv9Vu7URyGubTIe5M3OqI30dlE0GyvLHOil?=
 =?us-ascii?Q?TzPTBcVDmSt+LY6LgLOV5hyaYsoJaGYdWapvLS+1SGPFTVZ7mjQqmwr7yHGv?=
 =?us-ascii?Q?7XyKAqQZvoHaGGfo4WmMIk2SB3dtfJZOMQSAPFM3hdxNbwnanmGWHgL+qLXm?=
 =?us-ascii?Q?toLknPG6AmcJxnnrbhRor+9N8c272e8+jFJqOGkrdpIllZDBFaMsuOY0Z1h/?=
 =?us-ascii?Q?AyGZMr4HY30OdDTqPF/fIeHG2IzHKnCPJHi2ni+d8FyQ8V5dC35orsg1oIJ1?=
 =?us-ascii?Q?GNNo28hbNMyyEOuFy5B5LdS0bQxCpLwmFpbCdILj/r96plnYRptn2yiETwPo?=
 =?us-ascii?Q?SwLkWO4e5MLgpffZdt9pLxq5z4DtGwRZBPaighOT5MkBNhbTlY2sLl/Kf8jr?=
 =?us-ascii?Q?Rasuqj9GQGcvdyvn+zJo4Y7eqbxb/ZDZRuOpBzeESvX/fP4jZjruvu9VGP/o?=
 =?us-ascii?Q?sdAiynAVRgFS5gS86q4gl1/twCTNw2VRvdNys5z8fUCBmzCEB3BhwsNkvCqI?=
 =?us-ascii?Q?COwT9UYsZb8KSWwv8U27Basu8iJOROB+P6OYf/WVrWUpy54tz6s71NEfytjx?=
 =?us-ascii?Q?nL21UFnPsfTu5BUw8IP4nJA5hptaVEqniwSg7ueEd6nAKRiABUiTf512WNxL?=
 =?us-ascii?Q?ZTqqDLVUR+Kj8oavM91u8WsjRGtdm0ctf2KTJ1/Fpng1uC4eSu4Cl6IZNZTl?=
 =?us-ascii?Q?bP/7UHelJ8Qwnbr+2+92UHz7JjfiJGSH1XBxZosrvA9CAATCINBRy1m8pWol?=
 =?us-ascii?Q?7kkaYtIF0Q//4rheJMJY9GOYfnilqitzSkfszSWsGFd+pSOU5NyIY62hFNSw?=
 =?us-ascii?Q?eNyBhQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9605c707-8aaf-422b-1ea5-08da5bfd8674
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2022 07:36:06.9769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gTmUZrqWoQUIaojFJcgjmu1mvDXfNSQTAfvt3LZ8VJivA8Z87OritnwekglgFVQqFv+kHVFIPrZWMDvw72MsUcA6Wx0cOkiY6bwzHyZxs0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR13MB1068
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this series adds support to the NFP driver for HW offload of both:

* RX VLAN ctag/stag strip
* TX VLAN ctag insert

Diana Wang (2):
  nfp: support RX VLAN ctag/stag strip
  nfp: support TX VLAN ctag insert

 drivers/net/ethernet/netronome/nfp/nfd3/dp.c  | 63 ++++++++++++-----
 .../net/ethernet/netronome/nfp/nfd3/rings.c   |  2 +
 drivers/net/ethernet/netronome/nfp/nfd3/xsk.c |  9 ++-
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c  | 21 ++++--
 .../net/ethernet/netronome/nfp/nfdk/rings.c   |  1 +
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |  7 ++
 .../ethernet/netronome/nfp/nfp_net_common.c   | 68 +++++++++++++++----
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h | 17 +++++
 .../net/ethernet/netronome/nfp/nfp_net_dp.c   | 24 +++++++
 .../net/ethernet/netronome/nfp/nfp_net_dp.h   |  2 +
 .../net/ethernet/netronome/nfp/nfp_net_repr.c | 13 ++--
 11 files changed, 187 insertions(+), 40 deletions(-)

-- 
2.30.2

