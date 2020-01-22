Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5D3145AC2
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 18:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbgAVRYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 12:24:49 -0500
Received: from mail-dm6nam10on2093.outbound.protection.outlook.com ([40.107.93.93]:4961
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725802AbgAVRYt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 12:24:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M3pQbclcUiidf8dC/cSoCfb1bgYSj8l2LCBRvxeVMeUwDd+1NvxBGqAx5LAbxwzzZwEhSnIl48y/0gzSB3EWjJWguUxhJSCfxSWEhYfZP+g/cXWQLwiX3/ZicHT/CbmIGVgFaW5q1zJTQm2U6O20ZEPanDuxYZwbWOOoqutIGKJPu67nyqx7j3xYtbMUacXveKQFMXXvxz/13DYxjfa5bSbfHf4Gz9/tPwMomjfcd4uA2+W4KXw1fLKxEGt4xPJflBBH4pLtWzxuQWSXQc+a7Vo7o7M9rETAbN5P0lQ02XdaMh/lXgsqg8zgoOKbz72l4J00UYni7n3fKaKg1eQgmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZGg24GLpR8rlRDZn4MB5mIrPL3AeZtftuO6XpWAhj1I=;
 b=HdnYj7gljZaNlLmwTiZx1TRKwE2R3VclQBm3tkb+SUhUrkgZuC2GUbkTeD4FCUkYokSKY2x2KpwQGHnUiGwvqRZ3NIpVzxCee8eOMSslMZCExuReBMOylje/BWzgBylspV5NQ0fpVqeq4tMUGsn0DGvtoSFV9MVwnEKc7idR/gIuOtYPe34bq86cgvtwGYAaBkSp58Ar94jnADEnB5pWU6OjhkWlXP8tn+akA4sxZzivWAppcCFKP3g3KMbx6nXXXoDjj6J648CpXiDTSIc/PR32rpzwRHFuTQwIe/viDJdSdkLOVcNVAe4VJ2dgjFTqFERnF5E0tonZq/n5afns+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZGg24GLpR8rlRDZn4MB5mIrPL3AeZtftuO6XpWAhj1I=;
 b=hCxyxTT1RXHKjpWp945UBaJJR3AsqmUeghqoX+T+jO4NCT5F0lPLW9MaZbYt0KWcEli0UOtFk8dkxP0XBsJT4s34+T1UbVBkNJ2dzITrWzU1mStLK8HIOKu7TfH+r84e1+U1rO/PPF6BGuSSQ92hxm+xWHfmxYN3mCL0qbXpKlA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com (52.132.132.158) by
 DM5PR2101MB0918.namprd21.prod.outlook.com (52.132.132.163) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.3; Wed, 22 Jan 2020 17:24:46 +0000
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::b51c:186a:8630:127e]) by DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::b51c:186a:8630:127e%9]) with mapi id 15.20.2686.008; Wed, 22 Jan 2020
 17:24:46 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH V3,net-next, 0/2] hv_netvsc: Add XDP support
Date:   Wed, 22 Jan 2020 09:23:32 -0800
Message-Id: <1579713814-36061-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MWHPR12CA0039.namprd12.prod.outlook.com
 (2603:10b6:301:2::25) To DM5PR2101MB0901.namprd21.prod.outlook.com
 (2603:10b6:4:a7::30)
MIME-Version: 1.0
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MWHPR12CA0039.namprd12.prod.outlook.com (2603:10b6:301:2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 22 Jan 2020 17:24:42 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b3f17f13-5336-4683-8e4a-08d79f5ff80d
X-MS-TrafficTypeDiagnostic: DM5PR2101MB0918:|DM5PR2101MB0918:|DM5PR2101MB0918:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR2101MB09187D58EB8904FD38A458F5AC0C0@DM5PR2101MB0918.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-Forefront-PRVS: 029097202E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(199004)(189003)(16526019)(186003)(316002)(6486002)(52116002)(4326008)(26005)(81156014)(6506007)(81166006)(8676002)(6512007)(8936002)(36756003)(2906002)(66946007)(66476007)(478600001)(5660300002)(4744005)(66556008)(2616005)(956004)(10290500003)(6666004);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR2101MB0918;H:DM5PR2101MB0901.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GebU0p9oFx06WjAxJnoH45FpYfc6g5Rhfv8OfjwJE1vRmYpnk8jDoSa++jzx1C4UQfb0cPRtKRm40MlFfm8vled8uzMhZejA4RgZ7MeWDhSnXALIGfjrhyaQSxG9H4ZP+ZC0HlNg/KmWWhPCxiy4aBcoLrWumOm4igW7h3HE0M7cGWKAKLdky+/9GX5WTOZ15y4hpOy7oUHFRP9Lk4kUbbdAkybGxxLa6yKkv4NFHvnTNs+InGh3iPaie/pIT9BmDddTqX0PbLQfeQ9XzPOpUrhrig7zUtArC7Tgz0h675uUIpDkHUO0L7nWXXZaJU8aSd949n1DZjX9ERL/PV5DiYLCbwukzdmO6BFK19qFj/K1R1yQIYPwCaS+LUwA5+dnSftIduazyL45F0ERCZm7CSTI4PpR0HdHVLxdshOm/8pK5ElXcObDjsZljmQQLaIz
X-MS-Exchange-AntiSpam-MessageData: nP6+JkXw1+NKG3GVAQ0w60QiLS6JyBDT/8H6Ck+7/K5f5AJK2NU7eWpeJOw9BlQxpoZS/Nk4h0ZoupnidHK7Q0TRnT028g4yxgcGgJZGT7OwMLGK7gwrSKSvXyhNrMfR+gLT3TY5UOe1IpiJA2Ji2g==
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3f17f13-5336-4683-8e4a-08d79f5ff80d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2020 17:24:46.4361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uQr6xNXmV7wVWFXrx0MgIFlf6DIn3MXZZ8Y5piJFfn+yqB/1kn4UkwjgfzeBzC4pmPSJtxXDAOe8REeQfTB+9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB0918
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add XDP support and update related document.

Haiyang Zhang (2):
  hv_netvsc: Add XDP support
  hv_netvsc: Update document for XDP support

 .../networking/device_drivers/microsoft/netvsc.txt |  21 +++
 drivers/net/hyperv/Makefile                        |   2 +-
 drivers/net/hyperv/hyperv_net.h                    |  21 ++-
 drivers/net/hyperv/netvsc.c                        |  31 ++-
 drivers/net/hyperv/netvsc_bpf.c                    | 209 +++++++++++++++++++++
 drivers/net/hyperv/netvsc_drv.c                    | 175 ++++++++++++++---
 drivers/net/hyperv/rndis_filter.c                  |   2 +-
 7 files changed, 422 insertions(+), 39 deletions(-)
 create mode 100644 drivers/net/hyperv/netvsc_bpf.c

-- 
1.8.3.1

