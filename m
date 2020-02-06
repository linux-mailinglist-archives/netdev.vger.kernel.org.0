Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA455154E81
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 23:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbgBFWCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 17:02:17 -0500
Received: from mail-dm6nam11on2112.outbound.protection.outlook.com ([40.107.223.112]:21472
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726765AbgBFWCR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Feb 2020 17:02:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hevyWhjc+87kuG9I+CopraHBI0wsJywY/tBl/Sx9OXPyOSctigMKMsibI8+eEAYZGVjSZ0dxfaIq7apnaMGbYioURjmSGr+B1MqYogUxR1U9C8o3UOGSUHUolEEUYEnKoP9ddJlLVYeUw6tDdopIkdjA9Q8mmU00lz/DFDJHpfzMWFgPVZFibgZVFuWK/5Gn2Az0qordW5nkKj59bwt8CSJ00Ew6Mclxa6ScTTgW2Etc1u2rgv9jPIVP44iBAVdiIwxzcDVLOvSESByM13KjClSeF0wzi6f5imgd3iQLdJ1k0NG5QE6mPlmG0KbfYwQDLm0eAQx2/eGbnS7HVzyn7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vN+XbgcGvfhWvx4AwrA6NIW1wUNIurLg4CELjId3Fz8=;
 b=EXGWzL2X4h9Z5udl2v3+d6P3h7xtAatt2qi+EZBbv083/JPRTf4oO0dg3G5z9TYaPYZ1/RmfgmxG/QjEAOexQFuiyR9qaDWsdKSc/PNOhciYomoDMMd4Mde6D0E0LSt4kRAHZnzKx3PhTIgHjUvnImcBCmzkAew/RDlcEtKdxY4+czODZP0zTnVrXkcL1J56dKdrng0KP8IPsQrrimZr78D5IznxCsDomFjy8v9oGMt1hcnod8SY9hgDdghBLiWx3ogw+/z+K3h9+t4QikoX7YXK9c5ks/UW1KRTAl32noiDr81cCtTXDewlah+qSiT8qy5VbSPSFjfwYjqY6OOFIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vN+XbgcGvfhWvx4AwrA6NIW1wUNIurLg4CELjId3Fz8=;
 b=Gf7WPThYu0SePsdsQYf02NJPYuqJLbFmbzIpVjCWtOzWkDNXtuXSKI7KirMXXYxZFV5Y4NS3VOF2qjX9zSRYDNMz2rMEjqGjgb2xOVRpySXQpD9/kK30OXiuNvXMKft5OtPnBlHWlTHRVdEu1b7yQR0js5i9ZsstZ3FL5AeZUN8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
Received: from BL0PR2101MB0897.namprd21.prod.outlook.com (52.132.23.146) by
 BL0PR2101MB1108.namprd21.prod.outlook.com (52.132.24.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.5; Thu, 6 Feb 2020 22:01:34 +0000
Received: from BL0PR2101MB0897.namprd21.prod.outlook.com
 ([fe80::dfe:c227:1ff0:ff55]) by BL0PR2101MB0897.namprd21.prod.outlook.com
 ([fe80::dfe:c227:1ff0:ff55%5]) with mapi id 15.20.2729.004; Thu, 6 Feb 2020
 22:01:34 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] hv_netvsc: Fix XDP refcnt for synthetic and VF NICs
Date:   Thu,  6 Feb 2020 14:01:05 -0800
Message-Id: <1581026465-36161-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MWHPR21CA0056.namprd21.prod.outlook.com
 (2603:10b6:300:db::18) To BL0PR2101MB0897.namprd21.prod.outlook.com
 (2603:10b6:207:36::18)
MIME-Version: 1.0
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MWHPR21CA0056.namprd21.prod.outlook.com (2603:10b6:300:db::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.6 via Frontend Transport; Thu, 6 Feb 2020 22:01:31 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2644a06a-c446-4f71-669e-08d7ab502065
X-MS-TrafficTypeDiagnostic: BL0PR2101MB1108:|BL0PR2101MB1108:|BL0PR2101MB1108:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <BL0PR2101MB11082360CA77F1842E9FC284AC1D0@BL0PR2101MB1108.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0305463112
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(376002)(346002)(136003)(39860400002)(396003)(189003)(199004)(36756003)(8676002)(6486002)(2616005)(956004)(10290500003)(81166006)(8936002)(478600001)(2906002)(4326008)(6666004)(81156014)(6512007)(52116002)(186003)(316002)(5660300002)(66946007)(66556008)(26005)(16526019)(6506007)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:BL0PR2101MB1108;H:BL0PR2101MB0897.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QuhZXqwl3tpX0fpcH7k/LC6XiUKVJtrXvuUESao7sqVryrFhPpEYNNVCV9QOPyqr0T3ESHNl/vSx1O8akg5TRN4aAHC01kCR1fKzxtU9NFwCORVNayw/+9AP4Lrr6GiC3LPgk2M7vToQQy0lOWOcAZbfuOHBWx4VSlvdh6+Gj7Cip045+gROO6pnTU449qSKPIUhONBmxt6Zbjp8qBdiNNXAl0KzvcpHFG6lH+Mebrp3MfO9fMT0bOEJlIoZb4+aShxiplYbPUKM+8/aUGTaJnVTyesomN2hNNoIdyREXS/M+gyUIvJgO6a5t3ixFEbdwmTJ69kCKbJl5ObdzCkRUz91w7l72+hUtuIQbQOHuZPSDbchxR6b2glV1uxNQnWmVSXNocIOWRpUhTbPSu872/Ja1/xjqamnUiivdiWP1IywpbvM9dHU0GeXqrf2Azxw
X-MS-Exchange-AntiSpam-MessageData: +fhKuXs10z/P/Nr76A8Q0eIYYFIoyJhvSeGs0RHmI1Ax0jkhlS+NxCul8SlrmoC4K++Vu5dAaH3O926S3V8BLS4HPCkKjhZ3H20LpotE0o0LASIdPN+sr33hhyDOuSKTn0/+mnmxeKZ40cTOif1xYA==
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2644a06a-c446-4f71-669e-08d7ab502065
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2020 22:01:34.1324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cAAgOQ2WTjlLtUBIXSDZ+WiNAxSE3vK8dWC0CeZ6PGnAvk6NjTp4PzpqmhM+F6VkpsPSzmFFwA2xPO/IDsTE6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1108
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The caller of XDP_SETUP_PROG has already incremented refcnt in
__bpf_prog_get(), so drivers should only increment refcnt by
num_queues - 1.

To fix the issue, update netvsc_xdp_set() to add the correct number
to refcnt.

Hold a refcnt in netvsc_xdp_set()’s other caller, netvsc_attach().

And, do the same in netvsc_vf_setxdp(). Otherwise, every time when VF is
removed and added from the host side, the refcnt will be decreased by one,
which may cause page fault when unloading xdp program.

Fixes: 351e1581395f ("hv_netvsc: Add XDP support")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/hyperv/netvsc_bpf.c | 13 +++++++++++--
 drivers/net/hyperv/netvsc_drv.c |  5 ++++-
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_bpf.c b/drivers/net/hyperv/netvsc_bpf.c
index 20adfe5..b866110 100644
--- a/drivers/net/hyperv/netvsc_bpf.c
+++ b/drivers/net/hyperv/netvsc_bpf.c
@@ -120,7 +120,7 @@ int netvsc_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	}
 
 	if (prog)
-		bpf_prog_add(prog, nvdev->num_chn);
+		bpf_prog_add(prog, nvdev->num_chn - 1);
 
 	for (i = 0; i < nvdev->num_chn; i++)
 		rcu_assign_pointer(nvdev->chan_table[i].bpf_prog, prog);
@@ -136,6 +136,7 @@ int netvsc_vf_setxdp(struct net_device *vf_netdev, struct bpf_prog *prog)
 {
 	struct netdev_bpf xdp;
 	bpf_op_t ndo_bpf;
+	int ret;
 
 	ASSERT_RTNL();
 
@@ -148,10 +149,18 @@ int netvsc_vf_setxdp(struct net_device *vf_netdev, struct bpf_prog *prog)
 
 	memset(&xdp, 0, sizeof(xdp));
 
+	if (prog)
+		bpf_prog_inc(prog);
+
 	xdp.command = XDP_SETUP_PROG;
 	xdp.prog = prog;
 
-	return ndo_bpf(vf_netdev, &xdp);
+	ret = ndo_bpf(vf_netdev, &xdp);
+
+	if (ret && prog)
+		bpf_prog_put(prog);
+
+	return ret;
 }
 
 static u32 netvsc_xdp_query(struct netvsc_device *nvdev)
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 8fc71bd..65e12cb 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1059,9 +1059,12 @@ static int netvsc_attach(struct net_device *ndev,
 
 	prog = dev_info->bprog;
 	if (prog) {
+		bpf_prog_inc(prog);
 		ret = netvsc_xdp_set(ndev, prog, NULL, nvdev);
-		if (ret)
+		if (ret) {
+			bpf_prog_put(prog);
 			goto err1;
+		}
 	}
 
 	/* In any case device is now ready */
-- 
1.8.3.1

