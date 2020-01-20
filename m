Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 372E51433DC
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 23:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbgATWWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 17:22:55 -0500
Received: from mail-dm6nam12on2095.outbound.protection.outlook.com ([40.107.243.95]:42464
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726752AbgATWWz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jan 2020 17:22:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJJE2yA2U7ra/7GjIdlgTaL/azevkWNfjEaMl27smphUuQywHeDdZK+3/TqTJZCfRZCVnAHgaknkFzck7RNkdnuSRbP4YdKXWNWD+Vjyf5uPyoGD6gEuLF/MPEMuJ5oTpumw19RCMKJSZWEwXxC2QoEBIzvOegsyewGPLATVvV75BbsvUgHc47poiwNIIOt9cHqninSmie6RuvlTkF5VdO79h9EJwmQuIRCCLmAWRJTbkeGq1GoCq7AUG4BFcm80fTk9h6w1uM96PHjEv40OLoiFDvR7CROVdFPmysPUYEyMUs7a1CkfMK7u0c0uxNIGHaetLEtJKU4XAtb+sllWNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZGg24GLpR8rlRDZn4MB5mIrPL3AeZtftuO6XpWAhj1I=;
 b=fF8oSajLhoWRVJb2KeuQDGGxw2fPnSo7AAcMPa/8iM4uksQMfAChzT5K1hMw7uI9byhXNkmWNsYAPrBfMTeHSt1SN66roAw6MSRaZUKKgVeTohEWu+rStinGQwi5yHHrADMYaKTuN6l5sj52rT2dwcNrxbTmI+TeK/vfo1Zp6MDz2H2OPCXlmZrhdUUTlMA/rtoL6BU+rZS4oUlYs+denBcMKN4ESw04gt4x+0cyUvOOsEvgaYkNPPIdgyrFqV7HXtfU7UxoAGSlGVxhTP33JuPqDEDN154gEyFN/TiI+ZvXSCpiED7gS+Qkiup51EzrFaCvRz2u5oxhSRUKyGdGyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZGg24GLpR8rlRDZn4MB5mIrPL3AeZtftuO6XpWAhj1I=;
 b=eeUM6+Ak0UhYGIs+n7FPMZtmHu32bUwQBUPLUohNIFvmrCif+hOE53Zbuo0qyc0bYzBZPmHId4AmL6IavI66OPpfRq2oPaLEoXURqZssHrIfK36AtF4AVzQr6tf4g3zZ4mhHhjcn0eWgE/+regucdWwAnKEnWGmuoZke2DhHqTo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com (52.132.132.158) by
 DM5PR2101MB1094.namprd21.prod.outlook.com (52.132.130.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.3; Mon, 20 Jan 2020 22:22:52 +0000
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::b084:4e21:c292:6bb2]) by DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::b084:4e21:c292:6bb2%9]) with mapi id 15.20.2644.024; Mon, 20 Jan 2020
 22:22:52 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2,net-next, 0/2] hv_netvsc: Add XDP support
Date:   Mon, 20 Jan 2020 14:22:35 -0800
Message-Id: <1579558957-62496-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MWHPR15CA0043.namprd15.prod.outlook.com
 (2603:10b6:300:ad::29) To DM5PR2101MB0901.namprd21.prod.outlook.com
 (2603:10b6:4:a7::30)
MIME-Version: 1.0
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MWHPR15CA0043.namprd15.prod.outlook.com (2603:10b6:300:ad::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.19 via Frontend Transport; Mon, 20 Jan 2020 22:22:50 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4ac75e67-fe62-4833-4365-08d79df74912
X-MS-TrafficTypeDiagnostic: DM5PR2101MB1094:|DM5PR2101MB1094:|DM5PR2101MB1094:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR2101MB1094DF8C60D3F0C5E15C95BFAC320@DM5PR2101MB1094.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-Forefront-PRVS: 0288CD37D9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(189003)(199004)(66556008)(66946007)(66476007)(52116002)(6486002)(478600001)(2616005)(6666004)(4326008)(8936002)(10290500003)(36756003)(26005)(4744005)(6506007)(316002)(6512007)(16526019)(2906002)(186003)(8676002)(956004)(81166006)(81156014)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR2101MB1094;H:DM5PR2101MB0901.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kDLE0PV63L93YR0/0CTCUPn52BSFvFbxB2wOstMXwp01UEqbDyWj7Tp2LXSGzt1H4KcyPlN0ZMbFWMJ/89KwIZg3n2IMfuXx0eVW2Dw0vQUYnQZ+tXdgxqMMlk5mvgz9EdBX4ERn9jAWchAHa4J9Nc2ivaGa5XGGLaMN0Lax71XvbYAfiDArS4mlHLc11s87dcvz+XXKl/rhB8u1kdMTV9pZgPBQFnKmwxNgUM+9NM0dHJTcpghDudkDslujNmj24tRPW1mIRqKimPH6ftrV6TrxA502qSeqpHDkBl2KHanODvDIkNPyodpUTTqQWsB8Bb3b7jokca5JUdhxewj9WEgWwRz+w1u4cAZ9trxaTq9KvSx3BMaHUMOL5I3j6G6LCHLGMagRemyxoTm+p37MVojrQG9AJzgiLrg5gD7BOqWKWcRZEPaXNyNpXomuoR+F
X-MS-Exchange-AntiSpam-MessageData: P9tUO46zWl5G8wuXGphgBIXZc0dRBVmbsAjkR6Dw3dbauvuKNZ0X1AKxkiUTn6l63Af9UlMSatthKJz33RfX+ab0cn++czcr0ing/veUwxaoPJ76A9w+DLy0jFVyF+9RTcvWGcP+o7/sU3Wnmns9Gw==
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ac75e67-fe62-4833-4365-08d79df74912
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2020 22:22:52.6378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iXc3MpKaWwuA6xe3bVNaZ7o1JVZ0yN1PLLRYJzvIsQwzpomAnZeNRT1fLV39tk+7juSbKMAQSEK9jdJsqMJoWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB1094
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

