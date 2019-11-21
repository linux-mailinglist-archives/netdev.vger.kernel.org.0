Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18FC8105C04
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 22:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfKUVek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 16:34:40 -0500
Received: from mail-eopbgr740134.outbound.protection.outlook.com ([40.107.74.134]:34736
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726293AbfKUVek (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 16:34:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kCic6vZmjaYrxokk08oe2IdTYpy8kcAPpAXMQtbIev7gwhlCoEFJ6nB8B41AoNHiKeKzpuZL/wcS08jttN7+CKj3cGPT5WQk7xMNQEfhLztE0+ujzm6nY2touJiBKYtFMSIrMaqle+aDJZHVtFjvmKL6U+S3kui3+jmGP6h1ij8eRUuhEB01DdTfw4KwX+52yB+eu/a3L+zXfG1x5Qn/c7Pg+pbdHHVzv4cNpy/jsGH7f0fl3nQMdWgvR2YiTgAk7nI6VjA6sgt12vRqxLyhVgT8byW5Kf9o6xov2obXOGQTpxjgezOrGjNFEThVnvcK/dvj+amfi7vM0NhKNx8eJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gwAAh/D+x0wMosMRxeTTqq8Doou1v7nDiYyoJaloh0U=;
 b=ZK8gux0DtgH8JCNpYuMlIUu8zMAx9pi2ATDavYqfOKh4dDUXGiq2GC7yyV4rwqmyDB28Z763NpYdWe+IIZiUl7wa89rXlJh4xLRkzRzI6p6bc8SmG82KXrtW7PizGIvh/VJeNyo30ebmfeYIVK7CeUYmjSmhLhhXv9xrR9i2klFuskBFAh5GM2eeFTXxrP/tYA6Z4if9OI72H00WHvDzqyvnP+PAChrFVDcQKf5T9nZs1O2+r7hKr2Bk5yrZIO0v+fVHELP1pH7m9V4fZuTaJu9PHjBxB4b/hwBXzcr0h6iCLZXdwfsnwE9YF5zg/MCfzoJG4Smlv1nl9j22IgUzAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gwAAh/D+x0wMosMRxeTTqq8Doou1v7nDiYyoJaloh0U=;
 b=OAo0g7T1qeZSRxR/NnwS2xpMSH54Fhnqdh4wpum5ms4xtVtVIdgHjvRIwctdeY/8fqqn/PTNxvuBOzZauCgrDS0sHuFmosb1nQqrCNiOcYXEYkTyY3PXfzf59Bf0zt8zKhe8Mz76jqON0wYZ2b38RvEwGqPmEq46P3N5I38plOE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1228.namprd21.prod.outlook.com (20.179.50.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.8; Thu, 21 Nov 2019 21:34:37 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::a8b2:cdb:8839:3031]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::a8b2:cdb:8839:3031%4]) with mapi id 15.20.2495.010; Thu, 21 Nov 2019
 21:34:37 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH net,v2 0/2] Fix send indirection table offset
Date:   Thu, 21 Nov 2019 13:33:39 -0800
Message-Id: <1574372021-29439-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MWHPR1401CA0005.namprd14.prod.outlook.com
 (2603:10b6:301:4b::15) To DM6PR21MB1242.namprd21.prod.outlook.com
 (2603:10b6:5:169::22)
MIME-Version: 1.0
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MWHPR1401CA0005.namprd14.prod.outlook.com (2603:10b6:301:4b::15) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Thu, 21 Nov 2019 21:34:36 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 816fc429-0fdb-4938-c1f7-08d76eca9b8c
X-MS-TrafficTypeDiagnostic: DM6PR21MB1228:|DM6PR21MB1228:|DM6PR21MB1228:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM6PR21MB1228DFDF5A0403FE80D1E3C1AC4E0@DM6PR21MB1228.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-Forefront-PRVS: 0228DDDDD7
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(199004)(189003)(10090500001)(2906002)(50226002)(16586007)(6436002)(22452003)(48376002)(6486002)(36756003)(25786009)(66476007)(66556008)(16526019)(316002)(26005)(186003)(6116002)(4326008)(3846002)(50466002)(6506007)(52116002)(51416003)(386003)(305945005)(10290500003)(81166006)(66946007)(81156014)(4720700003)(478600001)(5660300002)(956004)(2616005)(7736002)(47776003)(8676002)(66066001)(8936002)(6512007)(4744005)(142933001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1228;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uOtgifRuXGY5o3UylJI4Hjc65i/WoeSCizayTOi980IphAu0+3in7mckgJ1FhI7nNKrF3vdmyVOIE5wakWBuK1fnkyozRC5L3WbNN1BtOf6y4akxUZM/KO8/vyG2U2451lW3wk4jq011FDWac813VFB0VkVRWFmLYdHnkJK+nCfNSXJZ1NZ3k+XbB2ggcnYFusO6SlVwxt1p1ShbXoB6E2d72QPzNi5zcglBkKQstIMsA9vBMd15B3SMOJItQqX4FhEyaQyPHDbckGbIiFe57t1bNJZD/ei9/1/B6i7LyLvMEQQzagRJHQURmEq0IneEL4L38cXFupMChG7Sb/Wglx7KW7In+BRGcPd6GrwXIl0CHKnj8pZML2i2gOI7ZpfvgVa3UGgzLf0kIQdHDd1Q+Z8L6B9P3jsVt3Xc8QPZNQx5qigHNV/edOVBzt/pKNxu
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 816fc429-0fdb-4938-c1f7-08d76eca9b8c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2019 21:34:37.1395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3KfJoiwWu0neQ6xPKcXfm9E/dqZGZ9K3QkeYNEoZmdAnCRM1uZ1/OBUheSCWtkAa4aRUTmeHi8hnkCXh7+Lltg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1228
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix send indirection table offset issues related to guest and
host bugs.

Haiyang Zhang (2):
  hv_netvsc: Fix offset usage in netvsc_send_table()
  hv_netvsc: Fix send_table offset in case of a host bug

 drivers/net/hyperv/hyperv_net.h |  3 ++-
 drivers/net/hyperv/netvsc.c     | 38 ++++++++++++++++++++++++++++++--------
 2 files changed, 32 insertions(+), 9 deletions(-)

-- 
1.8.3.1

