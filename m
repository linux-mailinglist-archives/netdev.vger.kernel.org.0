Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01F74105C09
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 22:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfKUVey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 16:34:54 -0500
Received: from mail-eopbgr740132.outbound.protection.outlook.com ([40.107.74.132]:10144
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726840AbfKUVex (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 16:34:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qy+XoBzziNznr6ML0sEhqjZ0lyNZMoEOrCbxY9uWmbjRzsJqX3rY4F7z5URWg1b018WfFT+YKDOjRX+rP7PVFCbUMYC/osSC5r6933IpAV1UVl23Jl/dyki99IrEoxjpb3rOD9fZu0BBaAyiwrkhxNuE1UqVivZWmgTt4GjfDpOmQmMmP240F1+gURdskkmmVoEmgX8VSfsyMFx2gTj86jdcpE8K3LKS3LQnGm8KPzUoAVXeo258dCK5vzwR31eWd5igrUy8lsQwgHpkT+1LpPIeUk37WDJB4fAEAXyoCE5yZTD7OJRPAFFjzt2rWBuW7gQ5lxu64ioZf6aZ49GyRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PeOZopHmlIW/l1KUh/KCiAmKtVnLTKqzjDlxkpqIcSc=;
 b=My1SKqNLU15k2grumlncST+dazB7Vd10SJAL9VzTT6tAzDYsv+P0LvMLsxBY6jD4JIbcg13o9YlSf/9TQ9PECJc0fcf5/lADUqvejRlZa+UwNjxzBtgSR7j1obI0IHLWoDbuknVd0y16feqnA9lEbarhqRuff8t7cEnZmcwIoz4dqgkTNkiuO1sDC5Sm5O5ov8BbAwgC/sDYYGwbSdtBm2xK8hyNONt/fuqovN8eN5cs4EQwTP2dXQ9hw+2u1DgSaAw8gAXXjwvJXPm4jnO2g0vQN+ZzQHbvsCbGiQYHtUczRJBooWLS9HuFumJWU0X+ZHdkaadnGzybUvhX06cedg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PeOZopHmlIW/l1KUh/KCiAmKtVnLTKqzjDlxkpqIcSc=;
 b=deuD4GP+zWRq0clHOh6+U983bBLTZSEFdtQ71zOXhlhH65TP2ZbnK/nESFtQMP82gvDBVHOnrMBotsaGhEqEkkBZMQ+akoOxRe/1F1bz2IoubZ6MJjKndAlxyZGZWha7kk2T5E0kX4esZ6DchhXq5LXueGB/nbkZd3WJ1ObquTM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1228.namprd21.prod.outlook.com (20.179.50.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.8; Thu, 21 Nov 2019 21:34:49 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::a8b2:cdb:8839:3031]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::a8b2:cdb:8839:3031%4]) with mapi id 15.20.2495.010; Thu, 21 Nov 2019
 21:34:49 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH net,v2 2/2] hv_netvsc: Fix send_table offset in case of a host bug
Date:   Thu, 21 Nov 2019 13:33:41 -0800
Message-Id: <1574372021-29439-3-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574372021-29439-1-git-send-email-haiyangz@microsoft.com>
References: <1574372021-29439-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MWHPR1401CA0005.namprd14.prod.outlook.com
 (2603:10b6:301:4b::15) To DM6PR21MB1242.namprd21.prod.outlook.com
 (2603:10b6:5:169::22)
MIME-Version: 1.0
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MWHPR1401CA0005.namprd14.prod.outlook.com (2603:10b6:301:4b::15) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Thu, 21 Nov 2019 21:34:48 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e3cdd14a-1381-40ad-3594-08d76ecaa2c5
X-MS-TrafficTypeDiagnostic: DM6PR21MB1228:|DM6PR21MB1228:|DM6PR21MB1228:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM6PR21MB1228A450BF9E5EF9A20B722EAC4E0@DM6PR21MB1228.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 0228DDDDD7
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(199004)(189003)(10090500001)(446003)(2906002)(50226002)(16586007)(6436002)(6666004)(22452003)(48376002)(6486002)(36756003)(25786009)(66476007)(66556008)(16526019)(316002)(26005)(186003)(6116002)(76176011)(4326008)(3846002)(50466002)(6506007)(52116002)(51416003)(386003)(305945005)(10290500003)(81166006)(66946007)(81156014)(4720700003)(11346002)(478600001)(5660300002)(956004)(2616005)(7736002)(47776003)(8676002)(66066001)(8936002)(6512007)(142933001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1228;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jrt86CrQzNXOYMH+KzSFCicny2kLiOOZbldOrchiflDxaGYDzwJNJ9ZQAhxysEkRTViwLbnGC5eSd/HmpXFUSfNANu6HOIx66bMbncivNCMNuiJOxHK4UA1kBsL/N95doGWLFWkO31CfbYkqwZC96nbQ5aUKvR1u+wxbBsBF9Ra71XucatirIofyFFhzwPd+xlpwRYDeAYgDqy+yAwEkBvlDwyQCYrX1PCFxZdfvj+RTINgRfep+sIF1H1tLBWbb4nD3IKgmZXLVMm08kGjOD4ABGbLygpbowKoMCyZGoY3GWprnWgoScoyQGphR818e4DPGcjd1xjILgVERyyKrLWSaj7H0Jnkm8fT8d32j+RjBxfK83p8LznyMdJmQbYG/+EBKcSC3+mtZnKrHLexYNip2eRtpx+/yKFktl70rhym2q4ZvPrJE+WBAsJ0u2Bh7
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3cdd14a-1381-40ad-3594-08d76ecaa2c5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2019 21:34:49.0406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Ioz8BwHFycldOtpUe2b3Te1ftYgubdBYYaM+AB1D4KrjKKZP7jloZ1wsdj2wRx0R2B5ApptoJdNu0LJ+Q9cVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1228
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If negotiated NVSP version <= NVSP_PROTOCOL_VERSION_6, the offset may
be wrong (too small) due to a host bug. This can cause missing the
end of the send indirection table, and add multiple zero entries from
leading zeros before the data region. This bug adds extra burden on
channel 0.

So fix the offset by computing it from the data structure sizes. This
will ensure netvsc driver runs normally on unfixed hosts, and future
fixed hosts.

Fixes: 5b54dac856cb ("hyperv: Add support for virtual Receive Side Scaling (vRSS)")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/hyperv/netvsc.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 9b0532e..eab83e7 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -1178,6 +1178,7 @@ static int netvsc_receive(struct net_device *ndev,
 }
 
 static void netvsc_send_table(struct net_device *ndev,
+			      struct netvsc_device *nvscdev,
 			      const struct nvsp_message *nvmsg,
 			      u32 msglen)
 {
@@ -1193,6 +1194,16 @@ static void netvsc_send_table(struct net_device *ndev,
 		return;
 	}
 
+	/* If negotiated version <= NVSP_PROTOCOL_VERSION_6, the offset may be
+	 * wrong due to a host bug. So fix the offset here.
+	 */
+	if (nvscdev->nvsp_version <= NVSP_PROTOCOL_VERSION_6 &&
+	    msglen >= sizeof(struct nvsp_message_header) +
+	    sizeof(union nvsp_6_message_uber) + count * sizeof(u32))
+		offset = sizeof(struct nvsp_message_header) +
+			 sizeof(union nvsp_6_message_uber);
+
+	/* Boundary check for all versions */
 	if (offset > msglen - count * sizeof(u32)) {
 		netdev_err(ndev, "Received send-table offset too big:%u\n",
 			   offset);
@@ -1218,12 +1229,13 @@ static void netvsc_send_vf(struct net_device *ndev,
 }
 
 static void netvsc_receive_inband(struct net_device *ndev,
+				  struct netvsc_device *nvscdev,
 				  const struct nvsp_message *nvmsg,
 				  u32 msglen)
 {
 	switch (nvmsg->hdr.msg_type) {
 	case NVSP_MSG5_TYPE_SEND_INDIRECTION_TABLE:
-		netvsc_send_table(ndev, nvmsg, msglen);
+		netvsc_send_table(ndev, nvscdev, nvmsg, msglen);
 		break;
 
 	case NVSP_MSG4_TYPE_SEND_VF_ASSOCIATION:
@@ -1257,7 +1269,7 @@ static int netvsc_process_raw_pkt(struct hv_device *device,
 		break;
 
 	case VM_PKT_DATA_INBAND:
-		netvsc_receive_inband(ndev, nvmsg, msglen);
+		netvsc_receive_inband(ndev, net_device, nvmsg, msglen);
 		break;
 
 	default:
-- 
1.8.3.1

