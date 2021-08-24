Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0762E3F6350
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 18:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbhHXQwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 12:52:01 -0400
Received: from mail-centralus01namln1000.outbound.protection.outlook.com ([40.93.8.0]:23291
        "EHLO outbound.mail.eo.outlook.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232910AbhHXQwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 12:52:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AD1B8JAFPNOSvFAPj8izUjDWqk1AmmMnak1G/MhwUXsz58Wawj4Wcf6/pNEUW5fOoM7+gm1txElDGR0VapvOVXNqrk8U/CCFEqVe3qW7f4AI13vQu0JifB+bXmuRizSDkYU4kprVC78cGGneZCH1XUbJbBULW+k5w0GUUSxlqxGqgvkOUrtr1UEKMEvQj+cmB8o6sUbHQZ41ulC053BTgi18c8Gw5985w7A5Hgr6Z46ev9djQkcLzHhNetBD9Yl/1jjkpvgZ7LynyWBfp4oS1soSBXuG4oweKsrPN63UmHQeOJA0wqylSmg7dCAE7tA2XiVd0j5ByWhXOc7yZE7cHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=oeOIVxNDZ3b7MUedfkTeXsYZabkilixzBOjhDqjyki4=;
 b=RYBocYk2G8t43mSI+3DcLTkwc+zQJYLGeaihtzduv6CFgyXd3GYEDRxIVJBIMZk6AERgWLQOvjL1h+IDpuP7FQBuS4ItjnCSYAB2GsyuWIxZMq06yxSVAO2RB2CKOfPK8rzyZRjq05vl1Pygh1UfXVrOAPrCYLX8P81dU9Fk0IVWxLqlArRKM4GR0H8pL9G+Y+zxvpu32gJprxo82mQyMH09kZACuf1NT80LfFc6ReidH0ZXPNdpNVp5EURrRb1sqIp2uOvBDwb63xTHp6uFSu+fibJXl2JX5TNI+wL1NHcH7+lZR4cMbdMEWPQ46tfF0M9xMoz6rlUOdqT42dfPoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oeOIVxNDZ3b7MUedfkTeXsYZabkilixzBOjhDqjyki4=;
 b=LIB+ZyILYauh6zVipr6+kdKRjIVnK+spFSk4QWKAUDF56JDRVbRurjaxyqN6WyjPx6nIOvRXj4eEatZ81L0q6iXvAdFaAkf9CvcVAoXw+BHaPFbyf7jdwk2OCX5hBiQtyND4RJ7t+TFNljWoI/CK5wSSISRA1GQ/HzJAT/jSOu4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1340.namprd21.prod.outlook.com (2603:10b6:5:175::19)
 by DM5PR21MB1765.namprd21.prod.outlook.com (2603:10b6:4:a4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.2; Tue, 24 Aug
 2021 16:46:32 +0000
Received: from DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::a09a:c9ba:8030:2247]) by DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::a09a:c9ba:8030:2247%9]) with mapi id 15.20.4478.005; Tue, 24 Aug 2021
 16:46:32 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        paulros@microsoft.com, shacharr@microsoft.com, olaf@aepfle.de,
        vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2,net-next, 0/3] net: mana: Add support for EQ sharing
Date:   Tue, 24 Aug 2021 09:45:58 -0700
Message-Id: <1629823561-2261-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: CO2PR04CA0133.namprd04.prod.outlook.com (2603:10b6:104::11)
 To DM6PR21MB1340.namprd21.prod.outlook.com (2603:10b6:5:175::19)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by CO2PR04CA0133.namprd04.prod.outlook.com (2603:10b6:104::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 16:46:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2370bb58-e2e5-4b00-5f21-08d9671eba5e
X-MS-TrafficTypeDiagnostic: DM5PR21MB1765:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR21MB1765F4F583E2EE41B97A92B0ACC59@DM5PR21MB1765.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GNmg4Ky4IRovxHLS38Eq7rZYFOO1gRGJ8nrP930i8SKupjH21ABSqTK42/efpk9PF3MUgguHeq+FuadPI5bS5jrcK1/ll2WxDPs5CUjYSzCv22/Z0VWAAwV9KE55k8Si/BuGGBq24BbC8EqbWaKkT69x+9JozFm2skSc0ZU/VUPAy8lj38Beqwhr0LE/L2/AFNvn+9nF9i1zgfjkbC0wXVUEKZyLZmhzxx1nbjqEQEy0r4e3mHFM1tD/hVxAoHaY/QgT4MLxa1g8+H05eKRtpOOb3N63fio2nhkr9hn3Vonhz3KMXPVn3awELNPwfJmSetLzh80EzFXTspYTVhkf2BBZc112eZ1P3gPZNyGqShNKUF8PnwmpFQGuPLxPFyK3NsJ05A3OAkTkjwVyiA8d/O4KtPyYAAK+mKjUnyPaHyLL6xdFiIoGXD5z9QfM4JkBkpQpd0dK6ps1tegkA7VoKIMgCgXOkl/zsI6s6vAt7WvkgNIfOItN81M/2UXMQXihNaqA6aHPiiDX+E3jxRcPP876WmnNVkSSKgKSXprNro2uGDYifzrUiSGaoCpuI5/AUZdV4UoBR6t9D2eaIXN5S/aj/N2FX4Hbw82+U+Vmz1MLfejQJloa7+d4ZNEt4+Rd7V66c0JG0/YC6ior87KLlOfALkppTqGxJdh7/o688+oEHMMHCUYU7o3w/FbnsHW3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1340.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(82950400001)(5660300002)(4744005)(6486002)(316002)(10290500003)(82960400001)(956004)(6512007)(7846003)(36756003)(2616005)(38100700002)(66946007)(38350700002)(66556008)(66476007)(186003)(2906002)(26005)(6666004)(8676002)(83380400001)(4326008)(52116002)(6506007)(8936002)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ADmherk0H3CJOCsLX/kYUfUS9A7Hv1v2ZmLdM9gJR7zG7xKAquHr10IfMB1G?=
 =?us-ascii?Q?tk2a616mxolnT0M39cUu4ywB9Xtcyv9rSHdELWE7Yb2GYVjaXe3kqltJefR8?=
 =?us-ascii?Q?7Cg6DY8eiMWWnkzKDjfFOpAlIA8Qw7LFx1ymYHuuI7AlZGORnd1EBzaFfgSH?=
 =?us-ascii?Q?GTWO4nI4YtJjuGYZOw/ZJ1xCwqA8BLxFctMr4FO3KhiUb4xm4/Lm3UTqsOK5?=
 =?us-ascii?Q?GbjqZfOWMqNpwtGPYy7LwgzZ69O94qp5A3NYmnCcgkgo32UNpzD2yAPwOmr3?=
 =?us-ascii?Q?8xDJ8EW7XDG/0AiVDraBJPp1OtwMWEaC9/M5iNZGLULVxVWdlt/PyDRu9sf2?=
 =?us-ascii?Q?7GkwlMxLFi8WFYvWWe1Z4IYE8PQDs1gUqiQP++861trsv1CaM1ZEMC0UpXuI?=
 =?us-ascii?Q?TwGPt0QJ5c20aViTNmxySUtRp9UL3i3DfodAE1WKjQX6C07az7dNWwp2/wAR?=
 =?us-ascii?Q?7xIyNgmznMRh4+03JGpZ93obyRFiBt+7ofV+H5Apzn6WJc6Mk9pghZH51B1x?=
 =?us-ascii?Q?I4ILRaIRdzoiGRcl0fTPyWLu29EWCxbZcJZ6pBISeE0q6neLxpdYpaFlz5MS?=
 =?us-ascii?Q?OiHvNAON5nXG7pXVDe+U8Llzt81F7iLKpuacEilIy90wCJQf5nz+AjzYI/dj?=
 =?us-ascii?Q?so+j14c1Wn7SivkUdSSqHkR5SUhkfE0QMJI2Tm9AFfKQ1aIostmjaySEepa+?=
 =?us-ascii?Q?vKUlTTC4FPyrbmpdm4JgxOl8YAtgSi5brnoIjqBsqYbb3+vdZCZ/LFeCUIwM?=
 =?us-ascii?Q?HSSwCEazigDmQKf4OXmsjO8agXC5FiINzNUad9Nxp/3cFhTCC+MGy498zALI?=
 =?us-ascii?Q?JJPXdw+s10Ze7sSyC6EhNlsPJIzjULaNRT8cw55ThyxS7P1cCCA14RLYv4AC?=
 =?us-ascii?Q?pptd4aCzFcfLreYd+U/cJ0Wl4KdQKaBHKLHuNVLeJVGYwV61aFrsFxw1NlSd?=
 =?us-ascii?Q?HWCRZTMKevN45j7ohXhqmMkxOxurUmKB3ZgxcA3KL5kA/BqxUbcwQxhAml1g?=
 =?us-ascii?Q?hN5spmSH69Lb63poerBwjXgdNxVFxh1argOf2wZI1cQJhStJv7jNax1VkO7U?=
 =?us-ascii?Q?x1aIsfbjkK6YUrfE29AqPiKGgmxkIOEumU4Jycc+32IPPIuNM9bF5iWuabpY?=
 =?us-ascii?Q?XdGBry1bKL0VxtZlzXEOIXgLgKbOguk7WXrq1yGuxlGgk2b6xBF5aLLpSQuL?=
 =?us-ascii?Q?Km4CzVxSrJmXdmBX2rdr7goab99CV2H5qZbFtXpBbspFxFdcnuF3mePLLNEe?=
 =?us-ascii?Q?Jpoouai/wR3lrz+XQUEBDTCyr6bRpqXM0pVXv3YgWHfncbixEfMchjnQ7Qsk?=
 =?us-ascii?Q?J7QNchCYgBAbwYUWhulxXSVJ?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2370bb58-e2e5-4b00-5f21-08d9671eba5e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1340.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 16:46:32.6178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OBmPcYCyxk124nfw63t/JMVfJ7yf/8x9rl+uP0s3Nr1teGwNGjm4L8tsUMyTcwkefEtSa0AfC9xVj7NI5wZseg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB1765
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The existing code uses (1 + #vPorts * #Queues) MSIXs, which may exceed
the device limit.

Support EQ sharing, so that multiple vPorts can share the same set of
MSIXs.

Haiyang Zhang (3):
  net: mana: Move NAPI from EQ to CQ
  net: mana: Add support for EQ sharing
  net: mana: Add WARN_ON_ONCE in case of CQE read overflow

 drivers/net/ethernet/microsoft/mana/gdma.h    |  32 ++--
 .../net/ethernet/microsoft/mana/gdma_main.c   |  88 +++-------
 .../net/ethernet/microsoft/mana/hw_channel.c  |   2 +-
 drivers/net/ethernet/microsoft/mana/mana.h    |  29 ++--
 drivers/net/ethernet/microsoft/mana/mana_en.c | 162 ++++++++++--------
 5 files changed, 153 insertions(+), 160 deletions(-)

-- 
2.25.1

