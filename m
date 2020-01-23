Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0410147361
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 22:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729137AbgAWVxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 16:53:15 -0500
Received: from mail-mw2nam12on2130.outbound.protection.outlook.com ([40.107.244.130]:50528
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728911AbgAWVxO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 16:53:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fhPEAaEpkHEbn5OcI1sMdSRbr5oasx9uufyZKaVr0bgcrS2xk+qZp9b7LveIZirDA2leTC7QaEy18YFfHvs7U7HQvyttmBdV0NvZF0PEGda1MCJWgiPituSTroza9pEcXLVn/BohpRe+pZoVzy2u4WPqoFv67fC1XGse6vGTWz6q//fSB0YVJa1Qgtv4hkswc1vPV0F28xpj5ZYuXn8uUTwx/TZOU6uszHNrc7XmZI0HOnXcKJ3iReSbEdk7EID+ygTGR5QAgjrpP+elG2iYbPkULufgVn2iqebEEL+zyfyxyKbZtrMVoVk7oRvv8LZGlpp2qap6Nb7Z5LTw6yQ1ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nuic2a1uCVgd9bFlUQjot6XbH19YApR1igYcKKu3KX4=;
 b=UN1cTz3LWmgNmrvQhyC+q6i/rzJY2obGqIKAJnMxjmjXYxOxIaHrO6xffDDYr0AgaD6dGzCWcgHP3nsHQlzuK2MK/g53YQNU3U0AzBAC7NqtdsUNVMZLEcDV9lG4ULGBU9PIita09l1UG1TF9mbcmCW+cq/eUHJ6MuvQm1TaokgGSxsOp6C8BD2Wbfn5C+0s51i38aFDq0o2M965qpeiwmsxkUDF4KHGeM50V2RgVB8aLtquaZ/GbkH8utN5L3B8sK/twzeX1KpirEwU0qHhZGfdi35fExCZIfXRBUc6xMbDG1kfSwGl1Anzc4uQhHdIsLpvxjALvnYPyevNd6bwVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nuic2a1uCVgd9bFlUQjot6XbH19YApR1igYcKKu3KX4=;
 b=hb2qLtUBbsUGYLcMpL2T7rae+8iIAZC6pXK6Z7r6FGOTftmn7xhhPRk6F7V6h9VoIwvTjJPB07+E5Q3VaeuuHI1u+KaobGj3yh//HRBuKm/VUJ/kBNBl2/T9yF0uSdZgkAH5eF+4GMvNlmlsvAvPsL0+1u8fFraHJbR0AbHZZHw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com (52.132.132.158) by
 DM5PR2101MB0887.namprd21.prod.outlook.com (52.132.132.156) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.9; Thu, 23 Jan 2020 21:53:10 +0000
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::b51c:186a:8630:127e]) by DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::b51c:186a:8630:127e%9]) with mapi id 15.20.2686.008; Thu, 23 Jan 2020
 21:53:09 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH V4,net-next, 0/2] hv_netvsc: Add XDP support
Date:   Thu, 23 Jan 2020 13:52:33 -0800
Message-Id: <1579816355-6933-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MWHPR15CA0039.namprd15.prod.outlook.com
 (2603:10b6:300:ad::25) To DM5PR2101MB0901.namprd21.prod.outlook.com
 (2603:10b6:4:a7::30)
MIME-Version: 1.0
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MWHPR15CA0039.namprd15.prod.outlook.com (2603:10b6:300:ad::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.20 via Frontend Transport; Thu, 23 Jan 2020 21:53:09 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 85d42dc9-02be-461d-b8bf-08d7a04ea2ce
X-MS-TrafficTypeDiagnostic: DM5PR2101MB0887:|DM5PR2101MB0887:|DM5PR2101MB0887:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR2101MB0887528A6802332CD03D1647AC0F0@DM5PR2101MB0887.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-Forefront-PRVS: 029174C036
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(376002)(346002)(136003)(39860400002)(396003)(199004)(189003)(66946007)(66476007)(2616005)(956004)(66556008)(186003)(6506007)(16526019)(6666004)(26005)(5660300002)(36756003)(10290500003)(6486002)(4744005)(8676002)(478600001)(8936002)(4326008)(6512007)(2906002)(81166006)(81156014)(316002)(52116002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR2101MB0887;H:DM5PR2101MB0901.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q8uHyoTpn9OhQZHQW2JW+yfR6kgSie5fVm+8uHWRSBRsA3Jbxl5IF41I0tiO5U5RrPYCihYpK6p96gcFAq/lrN+v2svYyBjwQrj/mQ4/Rj/15N2VtbPupS8k353YJL85BZue63PSEjzaNnc7fhFoKtGfniZTvqoN3yfamg0sHUUnY1jYnk14YCv3zv+JvfhxH6R6qjz5nvMkucPQmeLMXhBeOJmQBCs2QBuHB4G3dbqN2/5krhmIs5cZC2/NsTxohjGxRaz7IwagVMGpstr3IlY6znBTFZLQojr4GmnhNuYyX+40u5iQTQ0ENxyDQVTPmYJ3Hgc6xHCLWzVJdJNzl9AktXkaaymAt1c156HXOgzShi69Ap2M1nDumpJhU8ZxiM+ibWJjY9SRJlWbVIsnlZJ2YaEV1UWhCKQ32e+9pwjrWt6EzoZyNUd97UmDfH5T
X-MS-Exchange-AntiSpam-MessageData: P+DzfEnEROFT5DK02XP2KN0cZYz9TcRrSVna7jzqiicUf8gLwYVBcKfeci/j889H+KK3QgfwmNdjSmHdRbYx3vuj+OBOaQcca48zJBtrfbVCxaMQ2nedLJY/UbKet3NjkYafqN7PQqgRB8Uc5gclUg==
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85d42dc9-02be-461d-b8bf-08d7a04ea2ce
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2020 21:53:09.8562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fHVBrlHofS9Xnf7me57owh8mBuEnbBCiNhHUzLzbrM4Fmt4IebdITpemapL823HPa1uY3PyWiznxrtUUj9K+WQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB0887
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
 drivers/net/hyperv/netvsc_drv.c                    | 183 +++++++++++++++---
 drivers/net/hyperv/rndis_filter.c                  |   2 +-
 7 files changed, 430 insertions(+), 39 deletions(-)
 create mode 100644 drivers/net/hyperv/netvsc_bpf.c

-- 
1.8.3.1

