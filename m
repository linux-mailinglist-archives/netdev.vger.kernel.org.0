Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A5D54BBB4
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 22:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358158AbiFNU3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 16:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358147AbiFNU3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 16:29:30 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-centralusazon11021015.outbound.protection.outlook.com [52.101.62.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4954E39D;
        Tue, 14 Jun 2022 13:29:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Won06YF0yfBfUsmncsubGjDoIIBpNSxEIrGHXtW4NGs0AWJnO3Xrbwnv56OKUosfO+iXViJkg4imv93a/myFzbrdqVJxMAu+tH8yIRcpqPXDrRecHm7tsv8NptUrP4PFzjEDkXXxkuuD1ejpeD55QlohB6+o2VFo1QvBP1TVmhWeIgYIKt6yXnlT4/4003r8jmdMWeQOPppocpF1ONM1BfjjdNeG3nc9qZHOUtqox/698qRuZdJKlOz5cPUORFgtM3vDR4ZBN002Kh2WnQztldmf9EEKAbQORrxFWUBdnAc0tuo/lmo/nh/24UWjq5OeAKd6ZEpvzTXpMZp37/3oYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p6QMxEqA2iGGLukTTl0VpGpIOMNiCbSxVnHUTRKm4n4=;
 b=cMo6IB9nAdclJk+cllMtf4wQGZRWUR6Oa2cG6d3EuSbWXqaDZ0RjEcfkF3/07d2T7vbfhY6oqy2FhsNALhpS+78B98wQ8yU9CFqdfNMQC3Y7qBsCpxIfqUpxeuGPkhCyyUY/QIky/3XsIGwimwPA8Ea/oUlPjUiUIi66lDKcFbx45/pa8345dRdAQTqWy5xiFbKA1Y3GH/m8PEOBq+UxM9e+XC6WbPy1G4niBUjEBONQbBrbA7m6zl4AQ6YwVAos+5aguqSAuDrbvErgRNgNQf2x++EEksSL+tAyyXjfy0vgfTyNvucac0XS4AgbfTIJ2429ROuhOehu/5zaTB5oBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p6QMxEqA2iGGLukTTl0VpGpIOMNiCbSxVnHUTRKm4n4=;
 b=RCTcG1yilVZXuS6YmLF2JuNJK15wyn8+J7tjsjBeRAimTrkRyqcTSDAtYxsqcq3/A3DNVRC84tZVVgdFWRliLn256J1smlspwQ+1f8ie0tOD9LCuzj69FIuU3FRh85MJlcoVoBkNv7tHFAn3oWUmj+M8eRzYQ9RwvfZdPfJ70Z4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BYAPR21MB1223.namprd21.prod.outlook.com (2603:10b6:a03:103::11)
 by MN0PR21MB3314.namprd21.prod.outlook.com (2603:10b6:208:37f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.8; Tue, 14 Jun
 2022 20:29:26 +0000
Received: from BYAPR21MB1223.namprd21.prod.outlook.com
 ([fe80::7ceb:34aa:b695:d8ac]) by BYAPR21MB1223.namprd21.prod.outlook.com
 ([fe80::7ceb:34aa:b695:d8ac%5]) with mapi id 15.20.5353.001; Tue, 14 Jun 2022
 20:29:26 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, decui@microsoft.com, kys@microsoft.com,
        sthemmin@microsoft.com, paulros@microsoft.com,
        shacharr@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: [PATCH net-next,v2,0/2] net: mana: Add PF and XDP_REDIRECT support
Date:   Tue, 14 Jun 2022 13:28:53 -0700
Message-Id: <1655238535-19257-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0313.namprd04.prod.outlook.com
 (2603:10b6:303:82::18) To BYAPR21MB1223.namprd21.prod.outlook.com
 (2603:10b6:a03:103::11)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2353201-be1f-4826-b9f6-08da4e44934d
X-MS-TrafficTypeDiagnostic: MN0PR21MB3314:EE_
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <MN0PR21MB331425AE4DDAF22FC685030CACAA9@MN0PR21MB3314.namprd21.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4mXgmYhpqp3huUh2AbnLiWnGiQielPzxyosPU9pKx0zcnNOL88KzUzouw9WWC2C3VI4RVcEbkQ6t0Wo3C+wKOSYjxP9DCjZCAi8x7QgiaYqGHRP7a2DpqEcXCUx9CUgYMyvlqGidkc7kWGwaACbWmRDavWsCU+nlCwR/+nwgpDVLMJzrb4HFITjGNuDtfnadLNwJvOu04TMtjaEv6TW+6dKUt13in4+u1KQ+qwpr/60MMa8lw5oX9rlp0Vo4w7smhGhsRzxFUu3FJ+6IIbVLmRQuvc3/ldcrzwmtvHUVW/eLrJ6NpcyAPVKiDOy1SPbGTeJrXFlAL2Mfi7KUD6tyUoBX2qHbIC4InIeB6YKoE90n5MWJWE9iChO0Qugrjs+GoYh6Fse3+sPFgorBL/aWMIMdUrseWLxkthYYb/mca8GNv7Jz3ohSSs0Wk7XQXguXBjXzE+omjyk8uQmOYBsUJ8vmii5IhvKkTOPZ5k/9XLpCq/2kLNFvxSoirok2fJigrsC7MuDmmU+tK4Yi4znA1xcLNCweebw28YQyTlFiOFJoNEznMItsd5BHAJN6mTuClz5axxIYxTg+zP/rqRewbO/zT5PyeEal+BQi69mao1kWw2Jvij45GHLRrV1BHsDlmLcZVr77O+AIhREbJlroqEhnMnKKWHI5ZjVX+TUWMkzZMxN+FdxFinTjfqLXoh4CVrvIQt2sQKach1v8siUnqmqIn2dhIcZV3C8WX9fSMlWf0Dig0NXGK6GdE39UYvuw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1223.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(451199009)(6666004)(6506007)(186003)(52116002)(2616005)(6512007)(26005)(38100700002)(82960400001)(38350700002)(82950400001)(83380400001)(5660300002)(66946007)(4744005)(36756003)(8676002)(4326008)(8936002)(6486002)(316002)(2906002)(66556008)(66476007)(10290500003)(7846003)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZHoxwIafPovFVcks+A+TdG/ecZgEXsK3MmH4ofw/Tz607g4bKvZNPEcC6fIs?=
 =?us-ascii?Q?T5oE99NIjRVp1dPBVOqSk7NlTAerKyeub92+/ERo3Yg9sGY9W/gsznopnZKs?=
 =?us-ascii?Q?HFxfVVrvfHrzrNaNrh0+zOsYhwX1hZXhBF9OzqGKdjwmIpAAfjVwgicU79XP?=
 =?us-ascii?Q?nl+3eomzmJRfqwmb51zikhMWl/I5kUCOkvUKaIWBQ5/3GIkOoc+NODKE6oDf?=
 =?us-ascii?Q?ZbPfWYi42wDxcGo/K3rSi+DkDdMcxstlu5n/QgO0FHFdeFEpWxz2OvmPDnor?=
 =?us-ascii?Q?SaTVn/LwNwnxsDtKj+dYze3hXm+g49vMcjFVY/hEE+TFeKE4cxVN5QtpljqR?=
 =?us-ascii?Q?zb679qzc4U67x3613tWNTkfa/0hnp51Gk5//Tq5yg+Y0lOfGe/u4zB3I4QbY?=
 =?us-ascii?Q?sCmJ60kqL+cFVmySuSpW5KBfldGZc3F6upGXm84hjeVqk+bZIPNuqHaZ6NiW?=
 =?us-ascii?Q?CzSnjgwCNolZWPZaA/YvYI+RoYN0UzjlqyUd8GCFDxlHI/8ZRjlOXFBHufFQ?=
 =?us-ascii?Q?c+SGPAeZwxrK4F+73M4ciuJ/MNngCRGU0SwocSbyA+8oOylFil0VlSM6tvKG?=
 =?us-ascii?Q?VXDLM3TJp53dnd12toMbypse57LmjcqsyRuD9cobsIcBNYifAOD9qBplCTIw?=
 =?us-ascii?Q?7J88EzAAmCFcYHwXDNsB+OCNOOlYLvTpoRy77tsCft4sPxrn/RmXAkl2AgAM?=
 =?us-ascii?Q?M5RtaG/cnxXCYgEmejp0M9Mv4jQHjOl69rxKI9CMnrKw1SI1iZzjYaGyhm7v?=
 =?us-ascii?Q?bj95y/tXt2JC0H7PuNHxLCEbe1VEGx/yv2urrW+9b4VMJwB3oyDLRgulKHY0?=
 =?us-ascii?Q?igJyEfulQSgkP7XAKcVlY0QDidBthr3Sd3zOK/sPaTaUZ/TwXNpgyAJP40Pf?=
 =?us-ascii?Q?yuTHqYVygZGzFuIa31fQOCbksm23tufW+ou9OUoKLLTzGDjozISpkTrW4NbL?=
 =?us-ascii?Q?lGAiKJzugdcLDu9sbm4lELq80fm8efytWvK5OANptfuU6gD95TZDGXaU6Fjm?=
 =?us-ascii?Q?ikDfyZJAgAOyB3KnLxmxIC/ZBtmA7NKgeJ5vhQOeaoTwXRTHQwLne2o7g2lr?=
 =?us-ascii?Q?wqakxWAvLzVq7zf7A8yLU8z6GBeaOEh27DLtvfCxIwEHq1FRh/19tkyKMfbu?=
 =?us-ascii?Q?9tuAg0M0q6nyZpbYEQXovx2Ic5tawyQCOM6uJ+j2LzWGKcGtjQm8Ito4xtTF?=
 =?us-ascii?Q?asgk3IblaQOsLVy6YsTNhhJAq7nOJhUe1AsSIemRMN/Q7HgqdQVbHMVJ4Z5M?=
 =?us-ascii?Q?1DWipNUJ389h02qM/tzHyBYZwAzOBMWmnf5FuXBWhbm53NurhdgyECKY0YpL?=
 =?us-ascii?Q?+kYbjwS8pFrUSMy4EQ+TpYkcuyBiTfvcb/yTL1I9UwcyRBpBr/oUeXS+LmoU?=
 =?us-ascii?Q?0EnmOveXAP4pip5v7W4Kd0y/LlB3ZtBh9z++T0f8nhkkoZDshPk4rsIwFyVX?=
 =?us-ascii?Q?Rs4WU4EJZ0ehwvitE7prP4NsdPVM7bWJ52C3XcYfacTDf8kFwiRe7R5q09Hp?=
 =?us-ascii?Q?X++YbGkVT2KTP0+v16pu1BVSenyuvXVaH8QhTLFxJ2qoIFZj6SPgN0OGaAvk?=
 =?us-ascii?Q?psfKAUG/o2wtS48IFji+fZxxjo/3vwRCF0Zt/sQfYpIfBsN79ESJ5InnpqkH?=
 =?us-ascii?Q?jOMVBujki3/v3ee2cl6KHqWWP5j5fD92aqsMiwwL/NyNAdydqU1xdv6QSX1B?=
 =?us-ascii?Q?8k2lxe9W7+ShFKS4rqeDfKpkd5lyeKTC+/c89X+9s41ByKt6dFDzCk9CoZk0?=
 =?us-ascii?Q?UqbIcyUBHg=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2353201-be1f-4826-b9f6-08da4e44934d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1223.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2022 20:29:26.7589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5fofsw3ipmluQeJrjmgeyWvJhaWZzfU2hC1S2z0AYJgHSoWmSt/A4U2e+/G/CTN4l+pn8960piA/qURY5I2h3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3314
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch set adds PF and XDP_REDIRECT support.

Dexuan Cui (1):
  net: mana: Add the Linux MANA PF driver

Haiyang Zhang (1):
  net: mana: Add support of XDP_REDIRECT action

 drivers/net/ethernet/microsoft/mana/gdma.h    |  10 ++
 .../net/ethernet/microsoft/mana/gdma_main.c   |  39 ++++-
 .../net/ethernet/microsoft/mana/hw_channel.c  |  18 ++-
 .../net/ethernet/microsoft/mana/hw_channel.h  |   5 +
 drivers/net/ethernet/microsoft/mana/mana.h    |  70 +++++++++
 .../net/ethernet/microsoft/mana/mana_bpf.c    |  64 ++++++++
 drivers/net/ethernet/microsoft/mana/mana_en.c | 148 +++++++++++++++++-
 .../ethernet/microsoft/mana/mana_ethtool.c    |  12 +-
 8 files changed, 360 insertions(+), 6 deletions(-)

-- 
2.25.1

