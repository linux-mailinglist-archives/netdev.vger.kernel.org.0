Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 935C06D5666
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 04:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbjDDCHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 22:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232676AbjDDCHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 22:07:02 -0400
Received: from DM5PR00CU002.outbound.protection.outlook.com (mail-centralusazon11021027.outbound.protection.outlook.com [52.101.62.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C481BC9;
        Mon,  3 Apr 2023 19:07:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ba/g2AC2i3t3THuqOp/m4EwyDjB/3i21WfboiwzV/F3fujCq/k517D5YzLgWIacxWwLlsPmI28hz+cF/AUHMhyLaBEzkJu5WYjHlTFEBqEekV48h2OS2EhIOBBs6AWliPGO3sVn/2kxG8YSTI1xMH9ZzA3rLprNNgdWd4J0xEPmmgfT3hqZE5RcZ/lsQmfUn2ekdpISGdSPYPIL+sFVkS2vJqRUDvyH+3NwSWGGrVs6JzjlPVXJ8uWoJb4VDv854XQ7wJL31B6BSb4ugpx7/aTKphpe0O18NUUcOxENstgL05DVNTsTNjcLWq0QXYy43eTeV/z+vMLvoQq6HhYL7pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l5P8l4br+1d9DXbcCdavHVwhDuEVJ0uH+LnGsJjs4KU=;
 b=eGr6EayJVP17yA+gQ5VRjtUXuopZkZIrQmQoJ4Zk4zBCCitqrhWqLrTZdTMvADojB6dS3y/hD18gNoVOHaG2zy9YfP8zuwTU29EAajQgiPRbgdskhFodblz7LFV6uGItQHzqdNfmp58jKDx2jn/nnGKtkSd6ieo5qg4Nqfc/3INBl+/SW9P9OB9TgzZoVm7ouLJIlJf9dzLY5LaSyhJMEG+nF+T6QLOk/TnEfoOD6pH2D6fUYbaEJaYeD0hHtg4eNu7LaIFeDbzAkjnlBlwAMIAqI9Iuf2InOUNeLhgATLqSC4utBFlJiNZa0OMzFrOx5CZX1qSIyfWn3cPi1pIMPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l5P8l4br+1d9DXbcCdavHVwhDuEVJ0uH+LnGsJjs4KU=;
 b=HudTc0aZ9RXTeXtmqnuoBfXWjSs9mfAb1lWoyh3T+Fpya/BfMfxAcg+AXPiPYYclMuz6Px3GshQttzzeZ7FAwdqKE7bJ9Pa8Wv3qywQJn632DX8Q1/dLeMp8VKDkiKQIq3573vQviNLyc6ilEA401Vg1educJlkmAtLYqLSq3lA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by PH8PR21MB3959.namprd21.prod.outlook.com
 (2603:10b6:510:23b::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.11; Tue, 4 Apr
 2023 02:06:57 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::97b2:25ca:c44:9b7]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::97b2:25ca:c44:9b7%6]) with mapi id 15.20.6298.010; Tue, 4 Apr 2023
 02:06:57 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     bhelgaas@google.com, davem@davemloft.net, decui@microsoft.com,
        edumazet@google.com, haiyangz@microsoft.com, jakeo@microsoft.com,
        kuba@kernel.org, kw@linux.com, kys@microsoft.com, leon@kernel.org,
        linux-pci@vger.kernel.org, lpieralisi@kernel.org,
        mikelley@microsoft.com, pabeni@redhat.com, robh@kernel.org,
        saeedm@nvidia.com, wei.liu@kernel.org, longli@microsoft.com,
        boqun.feng@gmail.com, ssengar@microsoft.com, helgaas@kernel.org
Cc:     linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 0/6] pci-hyper: Fix race condition bugs for fast device hotplug
Date:   Mon,  3 Apr 2023 19:05:39 -0700
Message-Id: <20230404020545.32359-1-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: MW4P221CA0019.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::24) To BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR2101MB1092:EE_|PH8PR21MB3959:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a669683-ff62-48b4-6071-08db34b14499
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MsZLbRU8zyx+jA8PySaE1qY8TIOErziQL95/Q8AdrTY5ttFWDeXcKAus/Tegsbz/IFb+Tn1i+9q7y9yVhIZewxOCS4tBsIWHlS6tKyV5J43mO8EW9nXjq583O/QL4wOIUQ1O4g79HVj3s/8A+xhrCNh4KgrOBathcDLwxUdGPMWhuA9hbZkkpVxRHa5LSChGavuFb9iWo3+qIseevayDM7nSt5Opgy1K8mDgqPLuutThEvwZUFqzFnQrettUpdhhsKhaG5im+33PHiQ/R5kyA39pl3lOqqQClFi4C02/w+kyndYGyfeTxuay2sWjMHh/D2givV2xDnMxvMPCS0yOWLNvOBVlmgxRzn04j8JotWUdvLA2AsPhg8j18RQVhVBPNGvLPQaAeZhumSf2orpIxkLvSSBB0H8ZGSW0MkGT3Z943y7S26ptKcZPgWrFhQbboH+4EDHtyQPpA8JwfEWmAGsn9gJpdVs7/7D0aGtUnseU9YLmvAhBqgcrYCuOzgXrUDAhXVt2F2d16hKzw6C5cANHpq+0kmTAysM9MaBlY8z1ZJxQC/YaVXSIHRwaWdgurEjUJ6thM54gAe6ObwcZVGvAtyir1u65hGn8unpxrDdrnGoTRHYCQ3e4vNMU6d6y0sfGxTuaGgMg9hq53F6F6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(451199021)(966005)(6486002)(5660300002)(82950400001)(82960400001)(36756003)(478600001)(921005)(10290500003)(38100700002)(66946007)(66556008)(66476007)(8676002)(4326008)(86362001)(41300700001)(786003)(316002)(52116002)(8936002)(2616005)(186003)(6512007)(6506007)(1076003)(2906002)(6666004)(7416002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UqMTRDxSb6p47fmuw/cujRWhtIj8v2EDaQ39wDRB4rlAaIVP9VSkOOIeB3cm?=
 =?us-ascii?Q?HnppvCxY8PfcP8IZ7O0UPWJ0SgebrnzTkfyNFVnpLG6UbBBuywllNQ3gPcye?=
 =?us-ascii?Q?xvPCeYvPRW1drUgRVQonkeMqCj4TciVTsTswNBi5bEkCIgmwmfGeG+tqjZSZ?=
 =?us-ascii?Q?TRpkYu2CckRzbUBSRu4Gh3gBtedIYx5lhCvcFAe85rnDOovJycwe9eRr44en?=
 =?us-ascii?Q?2zMrhkdqxljcj08KcUoNRgXsdopmLgVLXdFeVPMKtnkPOBiggXE5ntzZVHPi?=
 =?us-ascii?Q?m9Xo2rnqkIlJun4x6aplWw3Jsr9J+ocweahwWiwHMCyxKGB7zyDCmhGhhVp5?=
 =?us-ascii?Q?Sl734FSHJYyvZ+I0A3yeFpKjtcceveAMjuls3ZHz2nuyJk7hpsp6M5p6ay/D?=
 =?us-ascii?Q?uZNe+G7dBzKAPZrUY+zWeyDy1Q9ndAMTZfcYRIiOLjRH010osecYinjLkNM/?=
 =?us-ascii?Q?25BYPjHJxbwQWx/WzG3h/meIXDk0k3uQZo/1WrIpbnYWYarfZdW/nTToL+qT?=
 =?us-ascii?Q?T2U7bsb2/V/EOHkLCc/4ZoL8Tg5Lkv3Ug7HeWjc+U0iGfWs65loOt8YAM5YZ?=
 =?us-ascii?Q?sHYYB3rr1mvhTtadUmGyYg6ForndKDDMsj4DFJurbQ1JchsvYPsgLFj+Tgbb?=
 =?us-ascii?Q?zQSzuqbTWtbblVA3zls6gT+AfRyzAB+T6NE1fyrr1HOieQWddBNGVuVDVzno?=
 =?us-ascii?Q?JuLuZt1pa7R7ikZ9oAzLGA6lqQWu3fiPrivDx1+QVJ9IURCzhry41nEIYVfq?=
 =?us-ascii?Q?ihIBBxL/FQwV2Z2pacqkGiD5am3+yGtSfnAtpwv5K9/ycA88OGtcRQzBneFP?=
 =?us-ascii?Q?teM3Xi2/NvGOsPPEkpviO8LEHv4jWlPnINzu5hAxRwwvtNqPF6Vfwl3hpPk7?=
 =?us-ascii?Q?/gEe+JNJzaCeko+i+AfjRmNfq4TEt+M6q+Op9elldlJBepZpsPSfAjLF0myS?=
 =?us-ascii?Q?dbUkO17VXNjZqlMr8nChlN3zOg4fAxti6J/dLmmUa3wpfxufdFs40QcjQAHZ?=
 =?us-ascii?Q?trXChouLq7ASro88Usip+2RKX75eQaomWKeIh0CJ7jW9XIOUXdvYLS/jioZF?=
 =?us-ascii?Q?5Z7WCzZFW12V0UUuiOfStnOAYw4uGo8C1R1TYKTJfuqYdXlX/fVHiNMmlRmE?=
 =?us-ascii?Q?WXZI8EcPCFMibpC+GZQa85xy+BGYCZNBR0uFGnkwBwhApnNlb2bnvOFF7fHY?=
 =?us-ascii?Q?+HkYzA5SuL/vcxEYSKGyAQnaAAT02Dm451lZhW6yOafvzrUz9H/Zv/Tw1+hm?=
 =?us-ascii?Q?pWduiqtiUzTQ2brXh/VqBojyKhXWDCgOKk2Mr9EPjZeNXU4peEXUKC+yeInw?=
 =?us-ascii?Q?L0oJ13HnR1pleu1ZdrxMuIk0vQNPGRuwkDNsxikVp1mzX7NynLDyctrb21cm?=
 =?us-ascii?Q?oxki++MaG6GuZPHpp6LytwhmRcIN+palYzj91SQLGXvsj+w5hBnaEO65q+QF?=
 =?us-ascii?Q?ZDCo/cGoTafx3k4cncTnNFHOFF8+tWMU2KEfibSXfVtgvrZuP+Yds351AaB9?=
 =?us-ascii?Q?N3g7VUhVjVpHw6tO5BNtx5Lf3dBn9v6yu7w6sxJoet/S+BnYoiXX5YsETSKP?=
 =?us-ascii?Q?GLRnCn0l7lCuN//XV9pk349XTfxReZ/OcaKlNSgL2Y78lHkitGwVXmiVyJPC?=
 =?us-ascii?Q?qk5VDQLewuKsr4pQYckeRy6aBgOVu+Bl3vJVZ6sC/8/0?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a669683-ff62-48b4-6071-08db34b14499
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 02:06:57.4476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qkck1vu8RJ70N/6y20OaFS1Zn5crk2e6ZCcZC7htwLkb5Y85IAg063F5Qf4GX624CFJYRkUnwa/AheNVjQVc0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR21MB3959
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before the guest finishes probing a device, the host may be already starting
to remove the device. Currently there are multiple race condition bugs in the
pci-hyperv driver, which can cause the guest to panic.  The patchset fixes
the crashes.

The patchset also does some cleanup work: patch 3 removes the useless
hv_pcichild_state, and patch 4 reverts an old patch which is not really
useful (without patch 4, it would be hard to make patch 5 clean).

Patch 6 removes the use of a global mutex lock, and enables async-probing
to allow concurrent device probing for faster boot.

In v2, I dropped the "debug code" before the real patch body to avoid
confusion; I fixed some minor issues pointed out by Michael Kelely:
fixed "goto release_state_lock" in patch 5, and improved the commit log
of patch 6; I added Wei Hu's Acked-by to patch 4. I added the cc:stable
tag to all the 6 patches.

v2 is based on v6.3-rc5.

I have been testing the patchset with
https://lwn.net/ml/linux-kernel/20230316091540.494366-1-alexander.stein%40ew.tq-group.com/
for several days, and no panic/hang is observed (earlier the kernel
would panic/hang within 1 day in my long haul testing).

The patchset is also availsble in my github branch:
https://github.com/dcui/tdx/commits/decui/vpci/v6.3-rc5-v2

v1 can be found here:
https://lwn.net/ml/linux-kernel/20230328045122.25850-1-decui%40microsoft.com/

Please review. Thanks!

Dexuan Cui (6):
  PCI: hv: Fix a race condition bug in hv_pci_query_relations()
  PCI: hv: Fix a race condition in hv_irq_unmask() that can cause panic
  PCI: hv: Remove the useless hv_pcichild_state from struct hv_pci_dev
  Revert "PCI: hv: Fix a timing issue which causes kdump to fail
    occasionally"
  PCI: hv: Add a per-bus mutex state_lock
  PCI: hv: Use async probing to reduce boot time

 drivers/pci/controller/pci-hyperv.c | 145 +++++++++++++++++-----------
 1 file changed, 86 insertions(+), 59 deletions(-)

-- 
2.25.1

