Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA101F7090
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 00:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgFKWro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 18:47:44 -0400
Received: from mail-vi1eur05on2064.outbound.protection.outlook.com ([40.107.21.64]:6125
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726277AbgFKWrn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 18:47:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UZo8OCCDdUsjFhwgqcffIwA604wc6M+g7JXBJSRK14K0NhxrcerwMoehFSa2BSG3rrFBGUHYHmiajEFNole49S9l/1suDjFim9gmRvh6b9tuzrwcbjM0c8oOMxdY7y2ch1zU31TzIHRo50HU7FsXKb6SSEJJcDAKKEEm+4+K0r4PkDIsmgwR4mERUcjwbLEIki8t5Etdn6GXTCbieQCOUm0LygZzlItLoOogSk2B4d5/tt+hh2zuhvSGkJQex09rq5waZbn+YUPP2jG9CHpz8SNU+1Dvu2bd1X+zKsXZ30RGIVGupUXDmZQM23WJnqLhwAiXU4+ximQ1mtq0sXewBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EvxqB6O8MIsVx3V8EKXCHOLkhTBBBvMb85AA9xy+SMQ=;
 b=TelIuSoPFQgp/A4zk1vTveTWAiKNYf6OI8vcCr6LcQxfxJ311SbDquHrXk94G9LiQrwBuk0Ebrx/ffHk6tfO90jPKw4naLD0ynm0GEwbqiaXe30h2o3f8l74xhmkPlF6mg3TaWo5s0L05z3NfI1Zq5oeen1ogy1OgYhm+s0UJu3kZMtjUGiTXYNjWUd0q5WNo5bV6v/cO8VCa+Gey3L80ufFyab+MonVyHdkROqNmTjh4HaPaW9Xl1YSqMUsLSH1F3fH473yeMcS1v3vUikjaSh0B1dWELax7ADIpmCUZj+557yarExIcnXpHC1hNd+NR6MRO/3pk0JKcG8IiUnt3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EvxqB6O8MIsVx3V8EKXCHOLkhTBBBvMb85AA9xy+SMQ=;
 b=r5GIxJBczxLo/mzGLUOPAzhOUgFTiru2AgMEpVDOLZ7DUQz0ROzsVCW92G+hmrvsczxMqxbAAQEZj6bg9YWguQRm4rq4RwGR79i3ZBMYkMg+YMOlyBC3Hw20h5dp9JtyAuX2pyA9kyYkGTa3aYeJRG7/sCOoGMDwdMKv0mBzc+I=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4464.eurprd05.prod.outlook.com (2603:10a6:803:44::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.22; Thu, 11 Jun
 2020 22:47:39 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3088.021; Thu, 11 Jun 2020
 22:47:39 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Shay Drory <shayd@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 01/10] net/mlx5: drain health workqueue in case of driver load error
Date:   Thu, 11 Jun 2020 15:46:59 -0700
Message-Id: <20200611224708.235014-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200611224708.235014-1-saeedm@mellanox.com>
References: <20200611224708.235014-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0066.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::43) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0066.namprd06.prod.outlook.com (2603:10b6:a03:14b::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.20 via Frontend Transport; Thu, 11 Jun 2020 22:47:37 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6e7ad67a-6ca0-4243-82fc-08d80e597139
X-MS-TrafficTypeDiagnostic: VI1PR05MB4464:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB446472EAACC5BFA14A7A6F70BE800@VI1PR05MB4464.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0431F981D8
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HpBzxIw9CvJq/R5dpPifTUvqh/xfLpkDRwjgl6saBXTG47b/4KgWWfB1VP9mBr0d6zSLsGlxvmLzHIrHMbFgRck4UYVadbyJe06ArdX4kKqJQXUViiiWsI+rKs+mrcrd6FVTdZgC1nz1iPW3YHdcXj9fo7XUjyxf/dMPAulDXn/JuV1ViXA8V53BtC5/ypTCSxxCXXdR+0c8b1DpWUiSA2TR12zlyD+afA3yxSQjTRGarSuYQd/vaBsyGiqrm5KAIBvtsNE0LHCE3xIiiA0ILqN1lC76g7fhUEHXqolQZfhYIhtqefnhuA67xDa/DY8/5PqJnj022+2TRmXigmrgjQ13a6tLs2TreseJWjbHybbBgPUFb8M6tf/zGqOwX2tY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(8936002)(16526019)(186003)(4326008)(316002)(8676002)(107886003)(5660300002)(478600001)(26005)(956004)(2616005)(6666004)(66556008)(86362001)(6512007)(6486002)(66946007)(54906003)(1076003)(6506007)(36756003)(45080400002)(66476007)(83380400001)(2906002)(52116002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: lWl0OSO7Ib1CkWF5K03bdn9LujGf1Qc9kX1mLhewi0omgrbJ1K/Dg4ykPk2SwtmePFT10cT6MGHCGpOtFnUO0NjUV5gEoC3PODZa1GBX52iUoHZYtVHXWWQPtLN7B7k0f6Sz9P4BzTq94gDAbdohBylCg6caSSoDwaHM/UWnxLDDfNcXbGZ3uOk27h+TiAEPKuLEiRjQwXDVCikbMkDXRa7gU4wL9HoINLL0H9ZJEh+r15aais8w1R8G1jMcmOOp3oWQ1J7Qd1vsTokTQT+zwqrSy/5v6MrVPAAkQiWHMz4hci2thuQ8BalmDX37df4HzD8mM5KkFm7/CTtiKbTmWYKLFknfdaYKRVguRMk18efNJdREQ38edW7RsDZ4rOpEylF8LFb0ob8xd8BCRjNRiRfUK3EDEeeu1CcWDkqRJaXGs85GOknH2PCdULfa5BtnrkjG0J7rkN/Czqj8dNsBvRhZB0QoKzDcbQziqO0+lM8=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e7ad67a-6ca0-4243-82fc-08d80e597139
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2020 22:47:39.3464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YYhKx9Mlfe5hWHV57MNWdLWhfm6jTOe5KJsIbo0tykWmS6Lo9Sgkr/PW9NcJy5kz1UpkWJZ9VDz1x/NNGpqVbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4464
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@mellanox.com>

In case there is a work in the health WQ when we teardown the driver,
in driver load error flow, the health work will try to read dev->iseg,
which was already unmap in mlx5_pci_close().
Fix it by draining the health workqueue first thing in mlx5_pci_close().

Trace of the error:
BUG: unable to handle page fault for address: ffffb5b141c18014
PF: supervisor read access in kernel mode
PF: error_code(0x0000) - not-present page
PGD 1fe95d067 P4D 1fe95d067 PUD 1fe95e067 PMD 1b7823067 PTE 0
Oops: 0000 [#1] SMP PTI
CPU: 3 PID: 6755 Comm: kworker/u128:2 Not tainted 5.2.0-net-next-mlx5-hv_stats-over-last-worked-hyperv #1
Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  04/28/2016
Workqueue: mlx5_healtha050:00:02.0 mlx5_fw_fatal_reporter_err_work [mlx5_core]
RIP: 0010:ioread32be+0x30/0x40
Code: 00 77 27 48 81 ff 00 00 01 00 76 07 0f b7 d7 ed 0f c8 c3 55 48 c7 c6 3b ee d5 9f 48 89 e5 e8 67 fc ff ff b8 ff ff ff ff 5d c3 <8b> 07 0f c8 c3 66 66 2e 0f 1f 84 00 00 00 00 00 48 81 fe ff ff 03
RSP: 0018:ffffb5b14c56fd78 EFLAGS: 00010292
RAX: ffffb5b141c18000 RBX: ffff8e9f78a801c0 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffff8e9f7ecd7628 RDI: ffffb5b141c18014
RBP: ffffb5b14c56fd90 R08: 0000000000000001 R09: 0000000000000000
R10: ffff8e9f372a2c30 R11: ffff8e9f87f4bc40 R12: ffff8e9f372a1fc0
R13: ffff8e9f78a80000 R14: ffffffffc07136a0 R15: ffff8e9f78ae6f20
FS:  0000000000000000(0000) GS:ffff8e9f7ecc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffb5b141c18014 CR3: 00000001c8f82006 CR4: 00000000003606e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ? mlx5_health_try_recover+0x4d/0x270 [mlx5_core]
 mlx5_fw_fatal_reporter_recover+0x16/0x20 [mlx5_core]
 devlink_health_reporter_recover+0x1c/0x50
 devlink_health_report+0xfb/0x240
 mlx5_fw_fatal_reporter_err_work+0x65/0xd0 [mlx5_core]
 process_one_work+0x1fb/0x4e0
 ? process_one_work+0x16b/0x4e0
 worker_thread+0x4f/0x3d0
 kthread+0x10d/0x140
 ? process_one_work+0x4e0/0x4e0
 ? kthread_cancel_delayed_work_sync+0x20/0x20
 ret_from_fork+0x1f/0x30
Modules linked in: nfsv3 rpcsec_gss_krb5 nfsv4 nfs fscache 8021q garp mrp stp llc ipmi_devintf ipmi_msghandler rpcrdma rdma_ucm ib_iser rdma_cm ib_umad iw_cm ib_ipoib libiscsi scsi_transport_iscsi ib_cm mlx5_ib ib_uverbs ib_core mlx5_core sb_edac crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 mlxfw crypto_simd cryptd glue_helper input_leds hyperv_fb intel_rapl_perf joydev serio_raw pci_hyperv pci_hyperv_mini mac_hid hv_balloon nfsd auth_rpcgss nfs_acl lockd grace sunrpc sch_fq_codel ip_tables x_tables autofs4 hv_utils hid_generic hv_storvsc ptp hid_hyperv hid hv_netvsc hyperv_keyboard pps_core scsi_transport_fc psmouse hv_vmbus i2c_piix4 floppy pata_acpi
CR2: ffffb5b141c18014
---[ end trace b12c5503157cad24 ]---
RIP: 0010:ioread32be+0x30/0x40
Code: 00 77 27 48 81 ff 00 00 01 00 76 07 0f b7 d7 ed 0f c8 c3 55 48 c7 c6 3b ee d5 9f 48 89 e5 e8 67 fc ff ff b8 ff ff ff ff 5d c3 <8b> 07 0f c8 c3 66 66 2e 0f 1f 84 00 00 00 00 00 48 81 fe ff ff 03
RSP: 0018:ffffb5b14c56fd78 EFLAGS: 00010292
RAX: ffffb5b141c18000 RBX: ffff8e9f78a801c0 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffff8e9f7ecd7628 RDI: ffffb5b141c18014
RBP: ffffb5b14c56fd90 R08: 0000000000000001 R09: 0000000000000000
R10: ffff8e9f372a2c30 R11: ffff8e9f87f4bc40 R12: ffff8e9f372a1fc0
R13: ffff8e9f78a80000 R14: ffffffffc07136a0 R15: ffff8e9f78ae6f20
FS:  0000000000000000(0000) GS:ffff8e9f7ecc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffb5b141c18014 CR3: 00000001c8f82006 CR4: 00000000003606e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
BUG: sleeping function called from invalid context at ./include/linux/percpu-rwsem.h:38
in_atomic(): 0, irqs_disabled(): 1, pid: 6755, name: kworker/u128:2
INFO: lockdep is turned off.
CPU: 3 PID: 6755 Comm: kworker/u128:2 Tainted: G      D           5.2.0-net-next-mlx5-hv_stats-over-last-worked-hyperv #1
Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  04/28/2016
Workqueue: mlx5_healtha050:00:02.0 mlx5_fw_fatal_reporter_err_work [mlx5_core]
Call Trace:
 dump_stack+0x63/0x88
 ___might_sleep+0x10a/0x130
 __might_sleep+0x4a/0x80
 exit_signals+0x33/0x230
 ? blocking_notifier_call_chain+0x16/0x20
 do_exit+0xb1/0xc30
 ? kthread+0x10d/0x140
 ? process_one_work+0x4e0/0x4e0

Fixes: 52c368dc3da7 ("net/mlx5: Move health and page alloc init to mdev_init")
Signed-off-by: Shay Drory <shayd@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index df46b1fce3a70..18d6c3752abe8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -785,6 +785,11 @@ static int mlx5_pci_init(struct mlx5_core_dev *dev, struct pci_dev *pdev,
 
 static void mlx5_pci_close(struct mlx5_core_dev *dev)
 {
+	/* health work might still be active, and it needs pci bar in
+	 * order to know the NIC state. Therefore, drain the health WQ
+	 * before removing the pci bars
+	 */
+	mlx5_drain_health_wq(dev);
 	iounmap(dev->iseg);
 	pci_clear_master(dev->pdev);
 	release_bar(dev->pdev);
-- 
2.26.2

