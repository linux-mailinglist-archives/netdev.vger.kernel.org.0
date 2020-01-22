Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84888145ACB
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 18:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbgAVRZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 12:25:48 -0500
Received: from mail-dm6nam11on2115.outbound.protection.outlook.com ([40.107.223.115]:17761
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725802AbgAVRZs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 12:25:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lOtShsErt39k5ZsNL4UBHlDGfQ8LD9I5MjjlCnI/OVioCUzmNz+Wlv8KjAzvEtng4mw0qMQHLu3nEPfcspu0KJKceDb+0kQpaGT7SNzWSjtJ0mFjghaJ7MID9CjpwxMpS9/mPUGiqNUrh5ed8Ef9awm4UgJ7mt6LdeIzQ4E6QHoxVyH34tlzioNSEP7NVXNxatR/WAlA1V/ATlCYOi1HzgdSS5cPm1ui4ef0HVBCqU7CSRnC3aWUzoiY6//31HEi2PcD3aruiizoDkS+sLKTV6KKvQN0w8lI99wuciWqCykjjY6CqjuGmo4ep/pdE029gCfW3vdYPC3AybzIDbSdVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eq4fxfoVx4d+FZa42roMASVzLnje7OXlkF2rNKRvMP0=;
 b=QDq2b8D2ZVHcDuU6KCbFadf/73QvT5wcQgVx/uBHyrHEr55iHR/w2cWj50YUw8MKju8SmcuoM78i89OcWSti+zI3OvDhZ7N9KqbshBeD8dJAUieT7oqTzVgK5c01Q52YAWMtRBN5Bwj1GfemCp4ja2bimet3WPi8XVplf6o6iT4NpdY0poSEMP21/nfoS4XMzPujtWWyqHAIqmTMz0xc1IZlG8XUdwTLu9t0eZsMFC1jqXiRI4BizUdWedz1bKKlWAFV4cKKuqw9NHcOkgLRYrvs5tbFmjmQa3gE1m9+nf4sAKuPcr2vbOtNnFRZr5SXmz6GECOzonUzuByRtikv3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eq4fxfoVx4d+FZa42roMASVzLnje7OXlkF2rNKRvMP0=;
 b=i+lBj0EHj7SsBOHlFi5646p8RSwiq9J6b97HOm4L9jRSe/T1rowA4mGIn3BWDWx8jPZM4NbXUqtQboVCh/yD1YIYP+2uMz+VNg+s0qcxz9v/bgnYjJntsXH114HX+Cb2DgHxsk2OuV8XCOIl/ujZtN1C8CITpZTKdIL4w9m0FYk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com (52.132.132.158) by
 DM5PR2101MB0918.namprd21.prod.outlook.com (52.132.132.163) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.3; Wed, 22 Jan 2020 17:24:55 +0000
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::b51c:186a:8630:127e]) by DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::b51c:186a:8630:127e%9]) with mapi id 15.20.2686.008; Wed, 22 Jan 2020
 17:24:55 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH V3,net-next, 1/2] hv_netvsc: Add XDP support
Date:   Wed, 22 Jan 2020 09:23:33 -0800
Message-Id: <1579713814-36061-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1579713814-36061-1-git-send-email-haiyangz@microsoft.com>
References: <1579713814-36061-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MWHPR12CA0039.namprd12.prod.outlook.com
 (2603:10b6:301:2::25) To DM5PR2101MB0901.namprd21.prod.outlook.com
 (2603:10b6:4:a7::30)
MIME-Version: 1.0
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MWHPR12CA0039.namprd12.prod.outlook.com (2603:10b6:301:2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 22 Jan 2020 17:24:54 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 24bd67b9-e4c9-4ea8-3ba5-08d79f5fff2c
X-MS-TrafficTypeDiagnostic: DM5PR2101MB0918:|DM5PR2101MB0918:|DM5PR2101MB0918:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR2101MB0918DBE9A2117D80BD444960AC0C0@DM5PR2101MB0918.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-Forefront-PRVS: 029097202E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(199004)(189003)(16526019)(186003)(316002)(6486002)(52116002)(4326008)(26005)(81156014)(6506007)(81166006)(8676002)(6512007)(8936002)(36756003)(2906002)(66946007)(66476007)(478600001)(5660300002)(66556008)(2616005)(30864003)(956004)(10290500003)(6666004);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR2101MB0918;H:DM5PR2101MB0901.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eNQsPxmFvGv7mkBFDdLjVnGuWlo90pmBazwHSHVPjaUV5kHgx3wbNFFPrl+8l+ec1LMFfZJjQPkpYvc39/HChx+5uGRPlLKbqlmUYe4I8qjh/CVEJbprM8IP1ti/Dal2h1NZs1YTykZbGi/dYRDeULIb47mI9vVwwoiRI6VtdWoOE6jDK7Auy4ONR+LZrPtaCSjypZD4ZasGhuZLeoLxI4OqfrH+yLd76qa8Axv2wTJv6O5Oil2MOzg4lAK/aUZe3ZjtpLQ6XJlvSTZHC6pBoKy1GkB4PsKdrLLbeRNw+G+wzhzPviwS89QkyhTGGk9Ilm1UX1QZHcBh70bZcCkLNi7TcbUPzLj4ZYDNK7lmq/7QbBAn2k2mxzxv0hWP8W9/Y4k12ZZFjtVpkKBwP1UCPEP81Gc4AlVu2b4qSPRu1rKXUCbWUneDn3tmrKAR93C3
X-MS-Exchange-AntiSpam-MessageData: ttb8TSMwmrb1x3g95vde4bbEzaoDLEUJcqB4ADTNk+3mncSFKqCzCS1B6mGjnv002MVQMLHjEIYCraQxIKCvIM9Xzjlsnx8TEP7NyPFgVkCv6V0BeH3LqN3SLE5YNERIm822VzNu8q6Y/Y+8CbIWWw==
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24bd67b9-e4c9-4ea8-3ba5-08d79f5fff2c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2020 17:24:55.4689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mmn9BkWCp0JmS9TncDmT5UlD2+E2CD34p3FOP589uY2gdfC0ZKsTo5zQf1+5cNoWJF1Ge60mN3q8TmNquzukGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB0918
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support of XDP in native mode for hv_netvsc driver, and
transparently sets the XDP program on the associated VF NIC as well.

Setting / unsetting XDP program on synthetic NIC (netvsc) propagates to
VF NIC automatically. Setting / unsetting XDP program on VF NIC directly
is not recommended, also not propagated to synthetic NIC, and may be
overwritten by setting of synthetic NIC.

The Azure/Hyper-V synthetic NIC receive buffer doesn't provide headroom
for XDP. We thought about re-use the RNDIS header space, but it's too
small. So we decided to copy the packets to a page buffer for XDP. And,
most of our VMs on Azure have Accelerated  Network (SRIOV) enabled, so
most of the packets run on VF NIC. The synthetic NIC is considered as a
fallback data-path. So the data copy on netvsc won't impact performance
significantly.

XDP program cannot run with LRO (RSC) enabled, so you need to disable LRO
before running XDP:
        ethtool -K eth0 lro off

XDP actions not yet supported:
        XDP_REDIRECT

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

---
Changes:
	v3: Minor code and comment updates.
        v2: Added XDP_TX support. Addressed review comments.
---
 drivers/net/hyperv/Makefile       |   2 +-
 drivers/net/hyperv/hyperv_net.h   |  21 +++-
 drivers/net/hyperv/netvsc.c       |  31 +++++-
 drivers/net/hyperv/netvsc_bpf.c   | 209 ++++++++++++++++++++++++++++++++++++++
 drivers/net/hyperv/netvsc_drv.c   | 175 +++++++++++++++++++++++++------
 drivers/net/hyperv/rndis_filter.c |   2 +-
 6 files changed, 401 insertions(+), 39 deletions(-)
 create mode 100644 drivers/net/hyperv/netvsc_bpf.c

diff --git a/drivers/net/hyperv/Makefile b/drivers/net/hyperv/Makefile
index 3a2aa07..0db7cca 100644
--- a/drivers/net/hyperv/Makefile
+++ b/drivers/net/hyperv/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_HYPERV_NET) += hv_netvsc.o
 
-hv_netvsc-y := netvsc_drv.o netvsc.o rndis_filter.o netvsc_trace.o
+hv_netvsc-y := netvsc_drv.o netvsc.o rndis_filter.o netvsc_trace.o netvsc_bpf.o
diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index dc44819..abda736 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -142,6 +142,8 @@ struct netvsc_device_info {
 	u32  send_section_size;
 	u32  recv_section_size;
 
+	struct bpf_prog *bprog;
+
 	u8 rss_key[NETVSC_HASH_KEYLEN];
 };
 
@@ -189,7 +191,8 @@ int netvsc_send(struct net_device *net,
 		struct hv_netvsc_packet *packet,
 		struct rndis_message *rndis_msg,
 		struct hv_page_buffer *page_buffer,
-		struct sk_buff *skb);
+		struct sk_buff *skb,
+		bool xdp_tx);
 void netvsc_linkstatus_callback(struct net_device *net,
 				struct rndis_message *resp);
 int netvsc_recv_callback(struct net_device *net,
@@ -198,6 +201,16 @@ int netvsc_recv_callback(struct net_device *net,
 void netvsc_channel_cb(void *context);
 int netvsc_poll(struct napi_struct *napi, int budget);
 
+u32 netvsc_run_xdp(struct net_device *ndev, struct netvsc_channel *nvchan,
+		   struct xdp_buff *xdp);
+unsigned int netvsc_xdp_fraglen(unsigned int len);
+struct bpf_prog *netvsc_xdp_get(struct netvsc_device *nvdev);
+int netvsc_xdp_set(struct net_device *dev, struct bpf_prog *prog,
+		   struct netlink_ext_ack *extack,
+		   struct netvsc_device *nvdev);
+int netvsc_vf_setxdp(struct net_device *vf_netdev, struct bpf_prog *prog);
+int netvsc_bpf(struct net_device *dev, struct netdev_bpf *bpf);
+
 int rndis_set_subchannel(struct net_device *ndev,
 			 struct netvsc_device *nvdev,
 			 struct netvsc_device_info *dev_info);
@@ -832,6 +845,8 @@ struct nvsp_message {
 #define RNDIS_MAX_PKT_DEFAULT 8
 #define RNDIS_PKT_ALIGN_DEFAULT 8
 
+#define NETVSC_XDP_HDRM 256
+
 struct multi_send_data {
 	struct sk_buff *skb; /* skb containing the pkt */
 	struct hv_netvsc_packet *pkt; /* netvsc pkt pending */
@@ -867,6 +882,7 @@ struct netvsc_stats {
 	u64 bytes;
 	u64 broadcast;
 	u64 multicast;
+	u64 xdp_drop;
 	struct u64_stats_sync syncp;
 };
 
@@ -972,6 +988,9 @@ struct netvsc_channel {
 	atomic_t queue_sends;
 	struct nvsc_rsc rsc;
 
+	struct bpf_prog __rcu *bpf_prog;
+	struct xdp_rxq_info xdp_rxq;
+
 	struct netvsc_stats tx_stats;
 	struct netvsc_stats rx_stats;
 };
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index eab83e7..ae3f308 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -122,8 +122,10 @@ static void free_netvsc_device(struct rcu_head *head)
 	vfree(nvdev->send_buf);
 	kfree(nvdev->send_section_map);
 
-	for (i = 0; i < VRSS_CHANNEL_MAX; i++)
+	for (i = 0; i < VRSS_CHANNEL_MAX; i++) {
+		xdp_rxq_info_unreg(&nvdev->chan_table[i].xdp_rxq);
 		vfree(nvdev->chan_table[i].mrc.slots);
+	}
 
 	kfree(nvdev);
 }
@@ -900,7 +902,8 @@ int netvsc_send(struct net_device *ndev,
 		struct hv_netvsc_packet *packet,
 		struct rndis_message *rndis_msg,
 		struct hv_page_buffer *pb,
-		struct sk_buff *skb)
+		struct sk_buff *skb,
+		bool xdp_tx)
 {
 	struct net_device_context *ndev_ctx = netdev_priv(ndev);
 	struct netvsc_device *net_device
@@ -923,10 +926,11 @@ int netvsc_send(struct net_device *ndev,
 	packet->send_buf_index = NETVSC_INVALID_INDEX;
 	packet->cp_partial = false;
 
-	/* Send control message directly without accessing msd (Multi-Send
-	 * Data) field which may be changed during data packet processing.
+	/* Send a control message or XDP packet directly without accessing
+	 * msd (Multi-Send Data) field which may be changed during data packet
+	 * processing.
 	 */
-	if (!skb)
+	if (!skb || xdp_tx)
 		return netvsc_send_pkt(device, packet, net_device, pb, skb);
 
 	/* batch packets in send buffer if possible */
@@ -1392,6 +1396,21 @@ struct netvsc_device *netvsc_device_add(struct hv_device *device,
 		nvchan->net_device = net_device;
 		u64_stats_init(&nvchan->tx_stats.syncp);
 		u64_stats_init(&nvchan->rx_stats.syncp);
+
+		ret = xdp_rxq_info_reg(&nvchan->xdp_rxq, ndev, i);
+
+		if (ret) {
+			netdev_err(ndev, "xdp_rxq_info_reg fail: %d\n", ret);
+			goto cleanup2;
+		}
+
+		ret = xdp_rxq_info_reg_mem_model(&nvchan->xdp_rxq,
+						 MEM_TYPE_PAGE_SHARED, NULL);
+
+		if (ret) {
+			netdev_err(ndev, "xdp reg_mem_model fail: %d\n", ret);
+			goto cleanup2;
+		}
 	}
 
 	/* Enable NAPI handler before init callbacks */
@@ -1437,6 +1456,8 @@ struct netvsc_device *netvsc_device_add(struct hv_device *device,
 
 cleanup:
 	netif_napi_del(&net_device->chan_table[0].napi);
+
+cleanup2:
 	free_netvsc_device(&net_device->rcu);
 
 	return ERR_PTR(ret);
diff --git a/drivers/net/hyperv/netvsc_bpf.c b/drivers/net/hyperv/netvsc_bpf.c
new file mode 100644
index 0000000..20adfe5
--- /dev/null
+++ b/drivers/net/hyperv/netvsc_bpf.c
@@ -0,0 +1,209 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2019, Microsoft Corporation.
+ *
+ * Author:
+ *   Haiyang Zhang <haiyangz@microsoft.com>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/ethtool.h>
+#include <linux/bpf.h>
+#include <linux/bpf_trace.h>
+#include <linux/kernel.h>
+#include <net/xdp.h>
+
+#include <linux/mutex.h>
+#include <linux/rtnetlink.h>
+
+#include "hyperv_net.h"
+
+u32 netvsc_run_xdp(struct net_device *ndev, struct netvsc_channel *nvchan,
+		   struct xdp_buff *xdp)
+{
+	void *data = nvchan->rsc.data[0];
+	u32 len = nvchan->rsc.len[0];
+	struct page *page = NULL;
+	struct bpf_prog *prog;
+	u32 act = XDP_PASS;
+
+	xdp->data_hard_start = NULL;
+
+	rcu_read_lock();
+	prog = rcu_dereference(nvchan->bpf_prog);
+
+	if (!prog)
+		goto out;
+
+	/* allocate page buffer for data */
+	page = alloc_page(GFP_ATOMIC);
+	if (!page) {
+		act = XDP_DROP;
+		goto out;
+	}
+
+	xdp->data_hard_start = page_address(page);
+	xdp->data = xdp->data_hard_start + NETVSC_XDP_HDRM;
+	xdp_set_data_meta_invalid(xdp);
+	xdp->data_end = xdp->data + len;
+	xdp->rxq = &nvchan->xdp_rxq;
+	xdp->handle = 0;
+
+	memcpy(xdp->data, data, len);
+
+	act = bpf_prog_run_xdp(prog, xdp);
+
+	switch (act) {
+	case XDP_PASS:
+	case XDP_TX:
+	case XDP_DROP:
+		break;
+
+	case XDP_ABORTED:
+		trace_xdp_exception(ndev, prog, act);
+		break;
+
+	default:
+		bpf_warn_invalid_xdp_action(act);
+	}
+
+out:
+	rcu_read_unlock();
+
+	if (page && act != XDP_PASS && act != XDP_TX) {
+		__free_page(page);
+		xdp->data_hard_start = NULL;
+	}
+
+	return act;
+}
+
+unsigned int netvsc_xdp_fraglen(unsigned int len)
+{
+	return SKB_DATA_ALIGN(len) +
+	       SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+}
+
+struct bpf_prog *netvsc_xdp_get(struct netvsc_device *nvdev)
+{
+	return rtnl_dereference(nvdev->chan_table[0].bpf_prog);
+}
+
+int netvsc_xdp_set(struct net_device *dev, struct bpf_prog *prog,
+		   struct netlink_ext_ack *extack,
+		   struct netvsc_device *nvdev)
+{
+	struct bpf_prog *old_prog;
+	int buf_max, i;
+
+	old_prog = netvsc_xdp_get(nvdev);
+
+	if (!old_prog && !prog)
+		return 0;
+
+	buf_max = NETVSC_XDP_HDRM + netvsc_xdp_fraglen(dev->mtu + ETH_HLEN);
+	if (prog && buf_max > PAGE_SIZE) {
+		netdev_err(dev, "XDP: mtu:%u too large, buf_max:%u\n",
+			   dev->mtu, buf_max);
+		NL_SET_ERR_MSG_MOD(extack, "XDP: mtu too large");
+
+		return -EOPNOTSUPP;
+	}
+
+	if (prog && (dev->features & NETIF_F_LRO)) {
+		netdev_err(dev, "XDP: not support LRO\n");
+		NL_SET_ERR_MSG_MOD(extack, "XDP: not support LRO");
+
+		return -EOPNOTSUPP;
+	}
+
+	if (prog)
+		bpf_prog_add(prog, nvdev->num_chn);
+
+	for (i = 0; i < nvdev->num_chn; i++)
+		rcu_assign_pointer(nvdev->chan_table[i].bpf_prog, prog);
+
+	if (old_prog)
+		for (i = 0; i < nvdev->num_chn; i++)
+			bpf_prog_put(old_prog);
+
+	return 0;
+}
+
+int netvsc_vf_setxdp(struct net_device *vf_netdev, struct bpf_prog *prog)
+{
+	struct netdev_bpf xdp;
+	bpf_op_t ndo_bpf;
+
+	ASSERT_RTNL();
+
+	if (!vf_netdev)
+		return 0;
+
+	ndo_bpf = vf_netdev->netdev_ops->ndo_bpf;
+	if (!ndo_bpf)
+		return 0;
+
+	memset(&xdp, 0, sizeof(xdp));
+
+	xdp.command = XDP_SETUP_PROG;
+	xdp.prog = prog;
+
+	return ndo_bpf(vf_netdev, &xdp);
+}
+
+static u32 netvsc_xdp_query(struct netvsc_device *nvdev)
+{
+	struct bpf_prog *prog = netvsc_xdp_get(nvdev);
+
+	if (prog)
+		return prog->aux->id;
+
+	return 0;
+}
+
+int netvsc_bpf(struct net_device *dev, struct netdev_bpf *bpf)
+{
+	struct net_device_context *ndevctx = netdev_priv(dev);
+	struct netvsc_device *nvdev = rtnl_dereference(ndevctx->nvdev);
+	struct net_device *vf_netdev = rtnl_dereference(ndevctx->vf_netdev);
+	struct netlink_ext_ack *extack = bpf->extack;
+	int ret;
+
+	if (!nvdev || nvdev->destroy) {
+		if (bpf->command == XDP_QUERY_PROG) {
+			bpf->prog_id = 0;
+			return 0; /* Query must always succeed */
+		} else {
+			return -ENODEV;
+		}
+	}
+
+	switch (bpf->command) {
+	case XDP_SETUP_PROG:
+		ret = netvsc_xdp_set(dev, bpf->prog, extack, nvdev);
+
+		if (ret)
+			return ret;
+
+		ret = netvsc_vf_setxdp(vf_netdev, bpf->prog);
+
+		if (ret) {
+			netdev_err(dev, "vf_setxdp failed:%d\n", ret);
+			NL_SET_ERR_MSG_MOD(extack, "vf_setxdp failed");
+
+			netvsc_xdp_set(dev, NULL, extack, nvdev);
+		}
+
+		return ret;
+
+	case XDP_QUERY_PROG:
+		bpf->prog_id = netvsc_xdp_query(nvdev);
+		return 0;
+
+	default:
+		return -EINVAL;
+	}
+}
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index f3f9eb8..bb1ace4 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <linux/rtnetlink.h>
 #include <linux/netpoll.h>
+#include <linux/bpf.h>
 
 #include <net/arp.h>
 #include <net/route.h>
@@ -519,7 +520,7 @@ static int netvsc_vf_xmit(struct net_device *net, struct net_device *vf_netdev,
 	return rc;
 }
 
-static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
+static int netvsc_xmit(struct sk_buff *skb, struct net_device *net, bool xdp_tx)
 {
 	struct net_device_context *net_device_ctx = netdev_priv(net);
 	struct hv_netvsc_packet *packet = NULL;
@@ -686,7 +687,7 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 	/* timestamp packet in software */
 	skb_tx_timestamp(skb);
 
-	ret = netvsc_send(net, packet, rndis_msg, pb, skb);
+	ret = netvsc_send(net, packet, rndis_msg, pb, skb, xdp_tx);
 	if (likely(ret == 0))
 		return NETDEV_TX_OK;
 
@@ -709,6 +710,11 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 	goto drop;
 }
 
+static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+{
+	return netvsc_xmit(skb, ndev, false);
+}
+
 /*
  * netvsc_linkstatus_callback - Link up/down notification
  */
@@ -751,6 +757,14 @@ void netvsc_linkstatus_callback(struct net_device *net,
 	schedule_delayed_work(&ndev_ctx->dwork, 0);
 }
 
+static int netvsc_xdp_xmit(struct sk_buff *skb, struct net_device *ndev)
+{
+	skb->queue_mapping = skb_get_rx_queue(skb);
+	__skb_push(skb, ETH_HLEN);
+
+	return netvsc_xmit(skb, ndev, true);
+}
+
 static void netvsc_comp_ipcsum(struct sk_buff *skb)
 {
 	struct iphdr *iph = (struct iphdr *)skb->data;
@@ -760,7 +774,8 @@ static void netvsc_comp_ipcsum(struct sk_buff *skb)
 }
 
 static struct sk_buff *netvsc_alloc_recv_skb(struct net_device *net,
-					     struct netvsc_channel *nvchan)
+					     struct netvsc_channel *nvchan,
+					     struct xdp_buff *xdp)
 {
 	struct napi_struct *napi = &nvchan->napi;
 	const struct ndis_pkt_8021q_info *vlan = nvchan->rsc.vlan;
@@ -768,18 +783,37 @@ static struct sk_buff *netvsc_alloc_recv_skb(struct net_device *net,
 						nvchan->rsc.csum_info;
 	const u32 *hash_info = nvchan->rsc.hash_info;
 	struct sk_buff *skb;
+	void *xbuf = xdp->data_hard_start;
 	int i;
 
-	skb = napi_alloc_skb(napi, nvchan->rsc.pktlen);
-	if (!skb)
-		return skb;
+	if (xbuf) {
+		unsigned int hdroom = xdp->data - xdp->data_hard_start;
+		unsigned int xlen = xdp->data_end - xdp->data;
+		unsigned int frag_size = netvsc_xdp_fraglen(hdroom + xlen);
 
-	/*
-	 * Copy to skb. This copy is needed here since the memory pointed by
-	 * hv_netvsc_packet cannot be deallocated
-	 */
-	for (i = 0; i < nvchan->rsc.cnt; i++)
-		skb_put_data(skb, nvchan->rsc.data[i], nvchan->rsc.len[i]);
+		skb = build_skb(xbuf, frag_size);
+
+		if (!skb) {
+			__free_page(virt_to_page(xbuf));
+			return NULL;
+		}
+
+		skb_reserve(skb, hdroom);
+		skb_put(skb, xlen);
+		skb->dev = napi->dev;
+	} else {
+		skb = napi_alloc_skb(napi, nvchan->rsc.pktlen);
+
+		if (!skb)
+			return NULL;
+
+		/* Copy to skb. This copy is needed here since the memory
+		 * pointed by hv_netvsc_packet cannot be deallocated.
+		 */
+		for (i = 0; i < nvchan->rsc.cnt; i++)
+			skb_put_data(skb, nvchan->rsc.data[i],
+				     nvchan->rsc.len[i]);
+	}
 
 	skb->protocol = eth_type_trans(skb, net);
 
@@ -829,13 +863,25 @@ int netvsc_recv_callback(struct net_device *net,
 	struct vmbus_channel *channel = nvchan->channel;
 	u16 q_idx = channel->offermsg.offer.sub_channel_index;
 	struct sk_buff *skb;
-	struct netvsc_stats *rx_stats;
+	struct netvsc_stats *rx_stats = &nvchan->rx_stats;
+	struct xdp_buff xdp;
+	u32 act;
 
 	if (net->reg_state != NETREG_REGISTERED)
 		return NVSP_STAT_FAIL;
 
+	act = netvsc_run_xdp(net, nvchan, &xdp);
+
+	if (act != XDP_PASS && act != XDP_TX) {
+		u64_stats_update_begin(&rx_stats->syncp);
+		rx_stats->xdp_drop++;
+		u64_stats_update_end(&rx_stats->syncp);
+
+		return NVSP_STAT_SUCCESS; /* consumed by XDP */
+	}
+
 	/* Allocate a skb - TODO direct I/O to pages? */
-	skb = netvsc_alloc_recv_skb(net, nvchan);
+	skb = netvsc_alloc_recv_skb(net, nvchan, &xdp);
 
 	if (unlikely(!skb)) {
 		++net_device_ctx->eth_stats.rx_no_memory;
@@ -849,7 +895,6 @@ int netvsc_recv_callback(struct net_device *net,
 	 * on the synthetic device because modifying the VF device
 	 * statistics will not work correctly.
 	 */
-	rx_stats = &nvchan->rx_stats;
 	u64_stats_update_begin(&rx_stats->syncp);
 	rx_stats->packets++;
 	rx_stats->bytes += nvchan->rsc.pktlen;
@@ -860,6 +905,11 @@ int netvsc_recv_callback(struct net_device *net,
 		++rx_stats->multicast;
 	u64_stats_update_end(&rx_stats->syncp);
 
+	if (act == XDP_TX) {
+		netvsc_xdp_xmit(skb, net);
+		return NVSP_STAT_SUCCESS;
+	}
+
 	napi_gro_receive(&nvchan->napi, skb);
 	return NVSP_STAT_SUCCESS;
 }
@@ -886,10 +936,11 @@ static void netvsc_get_channels(struct net_device *net,
 /* Alloc struct netvsc_device_info, and initialize it from either existing
  * struct netvsc_device, or from default values.
  */
-static struct netvsc_device_info *netvsc_devinfo_get
-			(struct netvsc_device *nvdev)
+static
+struct netvsc_device_info *netvsc_devinfo_get(struct netvsc_device *nvdev)
 {
 	struct netvsc_device_info *dev_info;
+	struct bpf_prog *prog;
 
 	dev_info = kzalloc(sizeof(*dev_info), GFP_ATOMIC);
 
@@ -897,6 +948,8 @@ static void netvsc_get_channels(struct net_device *net,
 		return NULL;
 
 	if (nvdev) {
+		ASSERT_RTNL();
+
 		dev_info->num_chn = nvdev->num_chn;
 		dev_info->send_sections = nvdev->send_section_cnt;
 		dev_info->send_section_size = nvdev->send_section_size;
@@ -905,6 +958,12 @@ static void netvsc_get_channels(struct net_device *net,
 
 		memcpy(dev_info->rss_key, nvdev->extension->rss_key,
 		       NETVSC_HASH_KEYLEN);
+
+		prog = netvsc_xdp_get(nvdev);
+		if (prog) {
+			bpf_prog_inc(prog);
+			dev_info->bprog = prog;
+		}
 	} else {
 		dev_info->num_chn = VRSS_CHANNEL_DEFAULT;
 		dev_info->send_sections = NETVSC_DEFAULT_TX;
@@ -916,6 +975,17 @@ static void netvsc_get_channels(struct net_device *net,
 	return dev_info;
 }
 
+/* Free struct netvsc_device_info */
+static void netvsc_devinfo_put(struct netvsc_device_info *dev_info)
+{
+	if (dev_info->bprog) {
+		ASSERT_RTNL();
+		bpf_prog_put(dev_info->bprog);
+	}
+
+	kfree(dev_info);
+}
+
 static int netvsc_detach(struct net_device *ndev,
 			 struct netvsc_device *nvdev)
 {
@@ -927,6 +997,8 @@ static int netvsc_detach(struct net_device *ndev,
 	if (cancel_work_sync(&nvdev->subchan_work))
 		nvdev->num_chn = 1;
 
+	netvsc_xdp_set(ndev, NULL, NULL, nvdev);
+
 	/* If device was up (receiving) then shutdown */
 	if (netif_running(ndev)) {
 		netvsc_tx_disable(nvdev, ndev);
@@ -960,7 +1032,8 @@ static int netvsc_attach(struct net_device *ndev,
 	struct hv_device *hdev = ndev_ctx->device_ctx;
 	struct netvsc_device *nvdev;
 	struct rndis_device *rdev;
-	int ret;
+	struct bpf_prog *prog;
+	int ret = 0;
 
 	nvdev = rndis_filter_device_add(hdev, dev_info);
 	if (IS_ERR(nvdev))
@@ -976,6 +1049,13 @@ static int netvsc_attach(struct net_device *ndev,
 		}
 	}
 
+	prog = dev_info->bprog;
+	if (prog) {
+		ret = netvsc_xdp_set(ndev, prog, NULL, nvdev);
+		if (ret)
+			goto err1;
+	}
+
 	/* In any case device is now ready */
 	netif_device_attach(ndev);
 
@@ -985,7 +1065,7 @@ static int netvsc_attach(struct net_device *ndev,
 	if (netif_running(ndev)) {
 		ret = rndis_filter_open(nvdev);
 		if (ret)
-			goto err;
+			goto err2;
 
 		rdev = nvdev->extension;
 		if (!rdev->link_state)
@@ -994,9 +1074,10 @@ static int netvsc_attach(struct net_device *ndev,
 
 	return 0;
 
-err:
+err2:
 	netif_device_detach(ndev);
 
+err1:
 	rndis_filter_device_remove(hdev, nvdev);
 
 	return ret;
@@ -1046,7 +1127,7 @@ static int netvsc_set_channels(struct net_device *net,
 	}
 
 out:
-	kfree(device_info);
+	netvsc_devinfo_put(device_info);
 	return ret;
 }
 
@@ -1153,7 +1234,7 @@ static int netvsc_change_mtu(struct net_device *ndev, int mtu)
 		dev_set_mtu(vf_netdev, orig_mtu);
 
 out:
-	kfree(device_info);
+	netvsc_devinfo_put(device_info);
 	return ret;
 }
 
@@ -1378,8 +1459,8 @@ static int netvsc_set_mac_addr(struct net_device *ndev, void *p)
 /* statistics per queue (rx/tx packets/bytes) */
 #define NETVSC_PCPU_STATS_LEN (num_present_cpus() * ARRAY_SIZE(pcpu_stats))
 
-/* 4 statistics per queue (rx/tx packets/bytes) */
-#define NETVSC_QUEUE_STATS_LEN(dev) ((dev)->num_chn * 4)
+/* 5 statistics per queue (rx/tx packets/bytes, rx xdp_drop) */
+#define NETVSC_QUEUE_STATS_LEN(dev) ((dev)->num_chn * 5)
 
 static int netvsc_get_sset_count(struct net_device *dev, int string_set)
 {
@@ -1411,6 +1492,7 @@ static void netvsc_get_ethtool_stats(struct net_device *dev,
 	struct netvsc_ethtool_pcpu_stats *pcpu_sum;
 	unsigned int start;
 	u64 packets, bytes;
+	u64 xdp_drop;
 	int i, j, cpu;
 
 	if (!nvdev)
@@ -1439,9 +1521,11 @@ static void netvsc_get_ethtool_stats(struct net_device *dev,
 			start = u64_stats_fetch_begin_irq(&qstats->syncp);
 			packets = qstats->packets;
 			bytes = qstats->bytes;
+			xdp_drop = qstats->xdp_drop;
 		} while (u64_stats_fetch_retry_irq(&qstats->syncp, start));
 		data[i++] = packets;
 		data[i++] = bytes;
+		data[i++] = xdp_drop;
 	}
 
 	pcpu_sum = kvmalloc_array(num_possible_cpus(),
@@ -1489,6 +1573,8 @@ static void netvsc_get_strings(struct net_device *dev, u32 stringset, u8 *data)
 			p += ETH_GSTRING_LEN;
 			sprintf(p, "rx_queue_%u_bytes", i);
 			p += ETH_GSTRING_LEN;
+			sprintf(p, "rx_queue_%u_xdp_drop", i);
+			p += ETH_GSTRING_LEN;
 		}
 
 		for_each_present_cpu(cpu) {
@@ -1785,10 +1871,27 @@ static int netvsc_set_ringparam(struct net_device *ndev,
 	}
 
 out:
-	kfree(device_info);
+	netvsc_devinfo_put(device_info);
 	return ret;
 }
 
+static netdev_features_t netvsc_fix_features(struct net_device *ndev,
+					     netdev_features_t features)
+{
+	struct net_device_context *ndevctx = netdev_priv(ndev);
+	struct netvsc_device *nvdev = rtnl_dereference(ndevctx->nvdev);
+
+	if (!nvdev || nvdev->destroy)
+		return features;
+
+	if ((features & NETIF_F_LRO) && netvsc_xdp_get(nvdev)) {
+		features ^= NETIF_F_LRO;
+		netdev_info(ndev, "Skip LRO - unsupported with XDP\n");
+	}
+
+	return features;
+}
+
 static int netvsc_set_features(struct net_device *ndev,
 			       netdev_features_t features)
 {
@@ -1875,12 +1978,14 @@ static void netvsc_set_msglevel(struct net_device *ndev, u32 val)
 	.ndo_start_xmit =		netvsc_start_xmit,
 	.ndo_change_rx_flags =		netvsc_change_rx_flags,
 	.ndo_set_rx_mode =		netvsc_set_rx_mode,
+	.ndo_fix_features =		netvsc_fix_features,
 	.ndo_set_features =		netvsc_set_features,
 	.ndo_change_mtu =		netvsc_change_mtu,
 	.ndo_validate_addr =		eth_validate_addr,
 	.ndo_set_mac_address =		netvsc_set_mac_addr,
 	.ndo_select_queue =		netvsc_select_queue,
 	.ndo_get_stats64 =		netvsc_get_stats64,
+	.ndo_bpf =			netvsc_bpf,
 };
 
 /*
@@ -2167,6 +2272,7 @@ static int netvsc_register_vf(struct net_device *vf_netdev)
 {
 	struct net_device_context *net_device_ctx;
 	struct netvsc_device *netvsc_dev;
+	struct bpf_prog *prog;
 	struct net_device *ndev;
 	int ret;
 
@@ -2211,6 +2317,9 @@ static int netvsc_register_vf(struct net_device *vf_netdev)
 	vf_netdev->wanted_features = ndev->features;
 	netdev_update_features(vf_netdev);
 
+	prog = netvsc_xdp_get(netvsc_dev);
+	netvsc_vf_setxdp(vf_netdev, prog);
+
 	return NOTIFY_OK;
 }
 
@@ -2252,6 +2361,8 @@ static int netvsc_unregister_vf(struct net_device *vf_netdev)
 
 	netdev_info(ndev, "VF unregistering: %s\n", vf_netdev->name);
 
+	netvsc_vf_setxdp(vf_netdev, NULL);
+
 	netdev_rx_handler_unregister(vf_netdev);
 	netdev_upper_dev_unlink(vf_netdev, ndev);
 	RCU_INIT_POINTER(net_device_ctx->vf_netdev, NULL);
@@ -2363,14 +2474,14 @@ static int netvsc_probe(struct hv_device *dev,
 	list_add(&net_device_ctx->list, &netvsc_dev_list);
 	rtnl_unlock();
 
-	kfree(device_info);
+	netvsc_devinfo_put(device_info);
 	return 0;
 
 register_failed:
 	rtnl_unlock();
 	rndis_filter_device_remove(dev, nvdev);
 rndis_failed:
-	kfree(device_info);
+	netvsc_devinfo_put(device_info);
 devinfo_failed:
 	free_percpu(net_device_ctx->vf_stats);
 no_stats:
@@ -2398,8 +2509,10 @@ static int netvsc_remove(struct hv_device *dev)
 
 	rtnl_lock();
 	nvdev = rtnl_dereference(ndev_ctx->nvdev);
-	if (nvdev)
+	if (nvdev) {
 		cancel_work_sync(&nvdev->subchan_work);
+		netvsc_xdp_set(net, NULL, NULL, nvdev);
+	}
 
 	/*
 	 * Call to the vsc driver to let it know that the device is being
@@ -2472,11 +2585,11 @@ static int netvsc_resume(struct hv_device *dev)
 
 	ret = netvsc_attach(net, device_info);
 
-	rtnl_unlock();
-
-	kfree(device_info);
+	netvsc_devinfo_put(device_info);
 	net_device_ctx->saved_netvsc_dev_info = NULL;
 
+	rtnl_unlock();
+
 	return ret;
 }
 static const struct hv_vmbus_device_id id_table[] = {
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index e66d77d..b81ceba 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -235,7 +235,7 @@ static int rndis_filter_send_request(struct rndis_device *dev,
 	trace_rndis_send(dev->ndev, 0, &req->request_msg);
 
 	rcu_read_lock_bh();
-	ret = netvsc_send(dev->ndev, packet, NULL, pb, NULL);
+	ret = netvsc_send(dev->ndev, packet, NULL, pb, NULL, false);
 	rcu_read_unlock_bh();
 
 	return ret;
-- 
1.8.3.1

