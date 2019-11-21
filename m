Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8FAC105C07
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 22:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfKUVev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 16:34:51 -0500
Received: from mail-eopbgr740132.outbound.protection.outlook.com ([40.107.74.132]:10144
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726293AbfKUVeu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 16:34:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GrTcDSZ0gncuy7q5dynLeseWegyd2Tp7hYYy1v5kdY2jQC9mUx8JeIfVgWITSdVJ0FRSZ/4o/J+/X3A4LFPcZHtKJKguAiNyKhspMCqimfTACzh9zKjUg4J/mVdJxQFxh2wBlCu4jwt6W0iiQct2ttXjMGt2Sf/IVcWGXXMMYBuS5VpGCl3ylg+DBEOtVu7MsZri6aVKuIKz57/NitQScUWJ2QyMs0tLLG53X+RfK0HP5BfY0QwatPH8uSbqYUC/7R41buVL8yeg679OMoajI7JNHBJIm9Zc8lEUU7WQy8WHvySGom0Wpf1zXHolF8HPRP4u5RTpTZh/b64Hzp6lfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tVJU1JHm0yTBVAZZe7NsXXGzAOulDp6JnA5C7B90Isw=;
 b=fXay9Lc3oEZHG8wtZytz1ZnlLdXURszIdvgy2XL5KpKZYhn+eSrE4CR6C2NWR13s9562oc6LwWwVqRE3PhT9qRQoTMimRLkMYf3ZsbHAs0AnWilqfwAwQkTzwWnjOWqioLxpMpBEOFQ8AIKyeRcFMyoLD4XslMO0AkWgiPb0uMFtph/PwjdcvUnzRGb0/fA9wXrjDHckQzJkEN9+TwvQamYaaHdWA2v2cWwKlynlnlrlcMI+8QF+G2nq7vMjf3Pab9K/7Lyg70+i40RGfJ2a2j5SyQGrDr4h+GeOlAl8sfFBy712sGUl1KRBkQ6kPjclfhiWZ+35yWztnQJeFuxbZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tVJU1JHm0yTBVAZZe7NsXXGzAOulDp6JnA5C7B90Isw=;
 b=esZmlSBqX9YM2d0Wh+2NmhfpmlssD+YmvCJIeCgL883zxB8WvUY3s+f4lfe/bfewNT4srEkpFpfQlXYYyY8v0cM767Phng/lyzia231wKO1S+p444OJpSGyuVJMqymWJbH7fYnfeTW/S/JTuF108z16ccgXFIQd+5G+6pAhtxl4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1228.namprd21.prod.outlook.com (20.179.50.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.8; Thu, 21 Nov 2019 21:34:47 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::a8b2:cdb:8839:3031]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::a8b2:cdb:8839:3031%4]) with mapi id 15.20.2495.010; Thu, 21 Nov 2019
 21:34:46 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH net,v2 1/2] hv_netvsc: Fix offset usage in netvsc_send_table()
Date:   Thu, 21 Nov 2019 13:33:40 -0800
Message-Id: <1574372021-29439-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574372021-29439-1-git-send-email-haiyangz@microsoft.com>
References: <1574372021-29439-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MWHPR1401CA0005.namprd14.prod.outlook.com
 (2603:10b6:301:4b::15) To DM6PR21MB1242.namprd21.prod.outlook.com
 (2603:10b6:5:169::22)
MIME-Version: 1.0
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MWHPR1401CA0005.namprd14.prod.outlook.com (2603:10b6:301:4b::15) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Thu, 21 Nov 2019 21:34:46 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 22989ac6-b38d-4e50-3bfe-08d76ecaa177
X-MS-TrafficTypeDiagnostic: DM6PR21MB1228:|DM6PR21MB1228:|DM6PR21MB1228:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM6PR21MB12283B921C580DEBBD019CCFAC4E0@DM6PR21MB1228.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0228DDDDD7
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(199004)(189003)(10090500001)(446003)(2906002)(50226002)(16586007)(6436002)(6666004)(22452003)(48376002)(6486002)(36756003)(25786009)(66476007)(66556008)(16526019)(316002)(26005)(186003)(6116002)(76176011)(4326008)(3846002)(50466002)(6506007)(52116002)(51416003)(386003)(305945005)(10290500003)(81166006)(66946007)(81156014)(4720700003)(11346002)(478600001)(5660300002)(956004)(2616005)(7736002)(47776003)(8676002)(66066001)(8936002)(6512007)(142933001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1228;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v24YeE9guzRn3Y98+aEk12i/5ryrF/wyfkbUCxtUIIHKcmdAg4UdHlQ+gTCWIuBAZFs3hGiVpcEh/C+JMPxNcNmBk212IvaiLThuz4K0opbPbH1TybMvocjDT6DraUAZ997XG9sRNz0Qb30MdqixAZydrfbNFIKZUzFBFPKnTQHQqVAa3b69/ZuFv2CxF1sMjhIT0hzT/q7dnxqNldBrOwn+lDknm8MwWOiMPGqVmQuEoOahu3nbyAqqCIrM4Ctfy+HVZ2ARrzSX8bSe8zW3Ympgn9TOAFb44YW0gv8W7AUX5XtKcBlQZhIRaqaXsTvUwrxbphIy3IrS54p9DLWtwl9d9oevP9xQlSME5dZsF5e+9mV0emDWYoUXxPVUFpyEA6DRwe+x+Rfq4Lb4pt9aAjWGnapmW0nDnALuUYdhBbRQNDblQOS1FfyawTZANG83
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22989ac6-b38d-4e50-3bfe-08d76ecaa177
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2019 21:34:46.9388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k2OvEqy5WBqvAbjBhXyBr8G0oyAoBaRBQxqIdRS+SnlvjxFJ2U7QCwz8XsBwqIbfNtMkD1571h58b/vq+3zceQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1228
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To reach the data region, the existing code adds offset in struct
nvsp_5_send_indirect_table on the beginning of this struct. But the
offset should be based on the beginning of its container,
struct nvsp_message. This bug causes the first table entry missing,
and adds an extra zero from the zero pad after the data region.
This can put extra burden on the channel 0.

So, correct the offset usage. Also add a boundary check to ensure
not reading beyond data region.

Fixes: 5b54dac856cb ("hyperv: Add support for virtual Receive Side Scaling (vRSS)")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/hyperv/hyperv_net.h |  3 ++-
 drivers/net/hyperv/netvsc.c     | 26 ++++++++++++++++++--------
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index 670ef68..fb547f3 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -609,7 +609,8 @@ struct nvsp_5_send_indirect_table {
 	/* The number of entries in the send indirection table */
 	u32 count;
 
-	/* The offset of the send indirection table from top of this struct.
+	/* The offset of the send indirection table from the beginning of
+	 * struct nvsp_message.
 	 * The send indirection table tells which channel to put the send
 	 * traffic on. Each entry is a channel number.
 	 */
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index d22a36f..9b0532e 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -1178,20 +1178,28 @@ static int netvsc_receive(struct net_device *ndev,
 }
 
 static void netvsc_send_table(struct net_device *ndev,
-			      const struct nvsp_message *nvmsg)
+			      const struct nvsp_message *nvmsg,
+			      u32 msglen)
 {
 	struct net_device_context *net_device_ctx = netdev_priv(ndev);
-	u32 count, *tab;
+	u32 count, offset, *tab;
 	int i;
 
 	count = nvmsg->msg.v5_msg.send_table.count;
+	offset = nvmsg->msg.v5_msg.send_table.offset;
+
 	if (count != VRSS_SEND_TAB_SIZE) {
 		netdev_err(ndev, "Received wrong send-table size:%u\n", count);
 		return;
 	}
 
-	tab = (u32 *)((unsigned long)&nvmsg->msg.v5_msg.send_table +
-		      nvmsg->msg.v5_msg.send_table.offset);
+	if (offset > msglen - count * sizeof(u32)) {
+		netdev_err(ndev, "Received send-table offset too big:%u\n",
+			   offset);
+		return;
+	}
+
+	tab = (void *)nvmsg + offset;
 
 	for (i = 0; i < count; i++)
 		net_device_ctx->tx_table[i] = tab[i];
@@ -1209,12 +1217,13 @@ static void netvsc_send_vf(struct net_device *ndev,
 		    net_device_ctx->vf_alloc ? "added" : "removed");
 }
 
-static  void netvsc_receive_inband(struct net_device *ndev,
-				   const struct nvsp_message *nvmsg)
+static void netvsc_receive_inband(struct net_device *ndev,
+				  const struct nvsp_message *nvmsg,
+				  u32 msglen)
 {
 	switch (nvmsg->hdr.msg_type) {
 	case NVSP_MSG5_TYPE_SEND_INDIRECTION_TABLE:
-		netvsc_send_table(ndev, nvmsg);
+		netvsc_send_table(ndev, nvmsg, msglen);
 		break;
 
 	case NVSP_MSG4_TYPE_SEND_VF_ASSOCIATION:
@@ -1232,6 +1241,7 @@ static int netvsc_process_raw_pkt(struct hv_device *device,
 {
 	struct vmbus_channel *channel = nvchan->channel;
 	const struct nvsp_message *nvmsg = hv_pkt_data(desc);
+	u32 msglen = hv_pkt_datalen(desc);
 
 	trace_nvsp_recv(ndev, channel, nvmsg);
 
@@ -1247,7 +1257,7 @@ static int netvsc_process_raw_pkt(struct hv_device *device,
 		break;
 
 	case VM_PKT_DATA_INBAND:
-		netvsc_receive_inband(ndev, nvmsg);
+		netvsc_receive_inband(ndev, nvmsg, msglen);
 		break;
 
 	default:
-- 
1.8.3.1

