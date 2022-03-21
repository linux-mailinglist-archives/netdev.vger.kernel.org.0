Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C60494E2484
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 11:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346420AbiCUKn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 06:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235208AbiCUKn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 06:43:56 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2132.outbound.protection.outlook.com [40.107.243.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E59B55230
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 03:42:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fcsyZfj4lYqgMeopxHB6zDoJWHIKB8lQ/8deKJIgE4sxaHje4XEWyJDT3/Yl1SGabSAIaW6y63A2UyMRpZifGYoTkfAEU1heZjwvY/j6M9hvFY9MXInP0CPlJmf9FNmhd3t8wDBaQpGUasu0Clg5npIy9bb4yRD2b4j1a/e6DauyTKAmmiUPGuKkx6+cZa+OEBmWDH9vjUkawMA5PW/FyCzZ2ty5iDN9CbaTqmo+zFvaVvqQqh6JUvJSdkujGrgPo/8vq+lfd9S4aSdBKWIBo5e1aS3lVFyATyeLmTRTENlRCiIGRsFTWX9aJtIHaohfjNd28qs4E8/tBNhMvAyS2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mePERMytINHTcTbsGMvak/zqafyKjUW/+yKBvLtUII8=;
 b=ZbAfUNw4AQD5/wUII376mAFBf8XLuv01jKvW7iBGmtiCfMJQvXoJXAvfM1kheaMOf7x5oxB3vxhwO5TAfUBTEox5U0uNWQQZpnNRDPbxQW05zzzdR2++z6BNirAUMOFQ6GR9D1hDJuRG4sl2CfMunrw9kmj466f2lDDel9kMnKDvNZc0I7yM0EaUiZLUjHr3HLmJwcW3QJUQA0/BNog+KCx5KBIp37N/tUZRI+4geh6ArXdmenhfc2WAsY+TYDF38zcLjwOA7AlLLMbHUovDa5Q8pnfUSJkQ1x15wUWtu3jtjk9vqUckNzyp78RspJTit8fvrY4WgHJKZ6nkwuh8yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mePERMytINHTcTbsGMvak/zqafyKjUW/+yKBvLtUII8=;
 b=ugzZbcNkag7Uud/pvjztAHBbyhjjFQD8w8msIO637jU3BOHJG7uAz1apbO/F78LF4X6fI7uKCQ5DFLDtigNecrUhnYsFUu0gzbw43gSRcRfYS4BrehAg64fBWEzZX6Zf2/AU22PBVWGe+mtjY+NqtXaH0xjgB99wPA5MbXc9aiY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CY4PR13MB1512.namprd13.prod.outlook.com (2603:10b6:903:12f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.15; Mon, 21 Mar
 2022 10:42:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7077:d057:db6b:3113]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7077:d057:db6b:3113%4]) with mapi id 15.20.5102.015; Mon, 21 Mar 2022
 10:42:25 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Yinjun Zhang <yinjun.zhang@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: [PATCH net-next v2 00/10] nfp: support for NFP-3800
Date:   Mon, 21 Mar 2022 11:41:59 +0100
Message-Id: <20220321104209.273535-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0001.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f21719d0-ffe8-40b1-c80b-08da0b277d19
X-MS-TrafficTypeDiagnostic: CY4PR13MB1512:EE_
X-Microsoft-Antispam-PRVS: <CY4PR13MB1512463AF18ACFCA5A0B6E2AE8169@CY4PR13MB1512.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 94wTRCIF6TZcQlKko4kUSe16Xw1XjJv85OTq2yE/2rb4wbpZvlzSAH8ckjVCx5qtt4eeirDIxpy21Dbe1ZQSa9jbp+tQdfUQ8IY73eM6VDlEKqjBE0rzkFF31+EG/x4CEWU2Ca/ckn1EmCEAd5DSEeVZIhq+Eri7asu2e2hIL9siVAwe7+bIOfqY91XBi2u/PTxpGswYqsh2Q6zg1tjUnntx1ffGfGrUfg11fdmRsbe3ASCxe1OTFg/JKw4KJYxRiodL0zl0X041qgacR+5MzQqBkzmqeqZoeSGQ+OOryuWubZ/efG9BlseZJf3ZCispgfgj/nMjgEhB4lHTk7f9kDoL3FTs/90IJYFhq7vG/kEKPgFflWH8AAuIgLctviEEdzt0l2w9KhGA0slxWX8ziw1ahtyHjC4bXLIORW/K6toJH8uoI7QEbY7FRu+/S/kxWBVUkCxJvWFSwC9jMzVBilZkaULqzGGAKc93TFb1dku4MthFU8KiFcxUyxjL3kKylv0Dz08g5M6Uk47Lg1pcIoYeNkO+AdCgo9sUE6001lJWfhH8/ch5H/0vOIizsQ0FOoSjsMvtZzMV7y11luYmVI/5BCPHjql8GZfnamCR1n3pGAuT4ND+b/D85vQveGVt8GbTItpECS9S+YzoBPAXrQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(136003)(396003)(376002)(366004)(346002)(8936002)(186003)(1076003)(6512007)(110136005)(6506007)(2906002)(8676002)(5660300002)(86362001)(52116002)(107886003)(6666004)(6486002)(44832011)(66946007)(4326008)(38100700002)(66556008)(2616005)(66476007)(316002)(83380400001)(508600001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5mR9WK/4kya4hjUcwAFh8EbXMFD/fCazmWQx2AwBS+57jZA6ewfTQj8HW5HQ?=
 =?us-ascii?Q?ljJxm9CS0gJyzF+20ahBFeJFaMSq+ThSFfpuCMaBK7oLSR8ayVfIaR5JoMOg?=
 =?us-ascii?Q?vcP7Ks93wiw0gp+NgITmSY9iJpGcbhE5bYQhzY2Wy0MYli4V/Yx63DAyqC9X?=
 =?us-ascii?Q?6Zip1HYJUQoS0aVz16xJcv1Z25r7zXAL42kTqidJwzz/kSA6Oo0GIwqwZJPv?=
 =?us-ascii?Q?Qu2LVuWLCnKYS6e7i6cdVD4s4lKPoJ9HnPKfT+r1vfndugRKiXZa5ouRH/tl?=
 =?us-ascii?Q?fKuWOpw5LK3C1TwgVY27+4dPD/mcw1LJN2kETHZ4z/kjtzJ7tfBAdk8GtJKc?=
 =?us-ascii?Q?8TuTJLzieqYrq77TwjB7EdDQHt7rF8WQBEHoXCVKZEFYnQ2z8EFYh5HpZdKe?=
 =?us-ascii?Q?oPqz9X6OZfQv1m3lHBTUL8vtYxd9hs6jWv+evD2RCvQpMR1Ck9fuAvrkZZAX?=
 =?us-ascii?Q?tF/znlRyccxt6/DH52D1oOPEpdIxHYVG/L6hCMluxisz/dv2lb6Dh1N077qg?=
 =?us-ascii?Q?wFQZt893PVrvwraTdVDeTef+qmk9Ew6iqX+d+VC1CEq8U6gtBhnJ84u0mLm3?=
 =?us-ascii?Q?mnXwYVXsVbtUg0d44bxnIwTFswXNRQKOrXUreSGNDgJujpDJtWY1wVmfMREN?=
 =?us-ascii?Q?szhcIjJr0pYcPRF8t73gncY2tEDddEmNd6ps5BEAQEB9dcpGSnjU+34Vgc+m?=
 =?us-ascii?Q?H9LO1s5VEdqVk73tyQgDCzEUub8jbNMTIE/XeMW3e35TDdSC4h60+vjsCTge?=
 =?us-ascii?Q?YVvXFbc6T8kNj65hUZQV38+ta1yhdOb+fB4aT8w/kly5fydbpLo1Y3Rctlle?=
 =?us-ascii?Q?Iwn9zZk5MFxvop1Gbwe7qJmmiA+zxmhaLcrct4mgOMuqVn6VBiBb0Li+I60f?=
 =?us-ascii?Q?Wj5OeOnDVazz3CDmn4SCbJTR8HqCoh3Hie1IDn2Lu+PywtWNEHHacbQasrGm?=
 =?us-ascii?Q?ieL3QEvy85/shD/zFIAIygieRgQXdy6c/fseE+RYkzz3wgPxF6zyWNNCq4ED?=
 =?us-ascii?Q?hUA/Hs9MUuadrbDGqdtqZRQU8f+th6CjDw03VA2Hbc05dW7riLGss1mG1DDf?=
 =?us-ascii?Q?BqsCarNjRS36WO3JqvS489Le73xaAH7wvv1WMPyRe9ZJg36E3hFrKByOHe0b?=
 =?us-ascii?Q?vV4WGUm7MbENFWUsSDplLLMu1ChYxd8d7OBpPqR97E8oZ1Q/pc1pBpXTxcQx?=
 =?us-ascii?Q?uiadluJFGWfV+IvrjwSwXSHKBfTdwsH5FY8UQ3ogg+wgX4g5hquvg+apbFrX?=
 =?us-ascii?Q?R+IQVvUD/SKGCkDp0dm9152ztuOMm1KepZa+f6M6t+HS4KC9YyuI40oRNfVJ?=
 =?us-ascii?Q?QOz0t0Hh8GVDyUe6eLWnGz/fxWDTx5R2PgllcHQSNa4BDiUq1QcQ+xEDla86?=
 =?us-ascii?Q?jZL3vj+wv03ubdg6rowZ7AoqytJ1aPxGNlZr/NoaUrJZ5RNnIY7zpX+Iy116?=
 =?us-ascii?Q?IX4XYCARMUs2goiSn1ReR9hdBzQY24rraQYf1NLIpikzhFtVtdFCq7JsWjif?=
 =?us-ascii?Q?1kRkaAFKD7MgCaPwTdb++6+ANbsIuMFx6VSbVKzkGk+jXh+qBOHNoqAQ5Q?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f21719d0-ffe8-40b1-c80b-08da0b277d19
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 10:42:25.7911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kD1uyC+02ul/h2RsUI3rqOQ6cauWqkni4VNnM0vNh58lmQsFWwHsumEcZRWOl/R3E8YbMqLeIQKLJwQ++utliJDATNZBOWq+mhCEpUdZHqk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR13MB1512
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Yinjun Zhan says:

This is the second of a two part series to support the NFP-3800 device.

To utilize the new hardware features of the NFP-3800, driver adds support
of a new data path NFDK. This series mainly does some refactor work to the
data path related implementations. The data path specific implementations
are now separated into nfd3 and nfdk directories respectively, and the
common part is also moved into a new file.

* The series starts with a small refinement in Patch 1/10. Patches 2/10 and
  3/10 are the main refactoring of data path implementation, which prepares
  for the adding the NFDK data path.
* Before the introduction of NFDK, there's some more preparation work
  for NFP-3800 features, such as multi-descriptor per-packet and write-back
  mechanism of TX pointer, which is done in patches 4/10, 5/10, 6/10, 7/10.
* Patch 8/10 allows the driver to select data path according
  to firmware version. Finally, patches 9/10 and 10/10 introduce the new
  NFDK data path.

Changes between v1 and v2
* Correct kdoc for nfp_nfdk_tx()
* Correct build warnings on 32-bit

Thanks to everyone who contributed to this work.


Jakub Kicinski (9):
  nfp: calculate ring masks without conditionals
  nfp: move the fast path code to separate files
  nfp: use callbacks for slow path ring related functions
  nfp: prepare for multi-part descriptors
  nfp: move tx_ring->qcidx into cold data
  nfp: use TX ring pointer write back
  nfp: add per-data path feature mask
  nfp: choose data path based on version
  nfp: add support for NFDK data path

Yinjun Zhang (1):
  nfp: nfdk: implement xdp tx path for NFDK

 drivers/net/ethernet/netronome/nfp/Makefile   |    6 +
 drivers/net/ethernet/netronome/nfp/nfd3/dp.c  | 1350 ++++++++++
 .../net/ethernet/netronome/nfp/nfd3/nfd3.h    |  106 +
 .../net/ethernet/netronome/nfp/nfd3/rings.c   |  275 +++
 drivers/net/ethernet/netronome/nfp/nfd3/xsk.c |  408 +++
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c  | 1524 ++++++++++++
 .../net/ethernet/netronome/nfp/nfdk/nfdk.h    |  129 +
 .../net/ethernet/netronome/nfp/nfdk/rings.c   |  195 ++
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |  159 +-
 .../ethernet/netronome/nfp/nfp_net_common.c   | 2180 +----------------
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |    5 +-
 .../ethernet/netronome/nfp/nfp_net_debugfs.c  |   51 +-
 .../net/ethernet/netronome/nfp/nfp_net_dp.c   |  442 ++++
 .../net/ethernet/netronome/nfp/nfp_net_dp.h   |  215 ++
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  |   10 +-
 .../net/ethernet/netronome/nfp/nfp_net_main.c |    9 +-
 .../net/ethernet/netronome/nfp/nfp_net_xsk.c  |  440 +---
 .../net/ethernet/netronome/nfp/nfp_net_xsk.h  |   16 +-
 .../ethernet/netronome/nfp/nfp_netvf_main.c   |    9 +-
 19 files changed, 4890 insertions(+), 2639 deletions(-)
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfd3/dp.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfd3/nfd3.h
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfd3/rings.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfd3/xsk.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfdk/dp.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfdk/rings.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfp_net_dp.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfp_net_dp.h

-- 
2.30.2

