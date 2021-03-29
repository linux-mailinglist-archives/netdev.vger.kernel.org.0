Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A341F34DC5D
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 01:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhC2XWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 19:22:42 -0400
Received: from mail-dm6nam12on2094.outbound.protection.outlook.com ([40.107.243.94]:29921
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229656AbhC2XWa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 19:22:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a+oHkM2ds32L9tzj6IKz1/4nBRWU3dHmUfJQTfiTs50nzifRYzzDnTg/r/brg/vQ/wWSHTUlt1S8Z7WJJKQTXsiyLkcegVnu8WAIue6aUh/+bCR6lmj9aje9IaChZ2P3OxbZbphbW1NUnXGm3RYh9D/QaYU8501uTVRlojpkuJAmFqdmDpjUXGITBRhI1IiznyNmnfxSQh4VqfvQfJ52MDfQNQYcn4+RXoHYaqsiIDNPr3n9CQxLIo11FtXnvkAqV4GYT5DM14rnb7frAXUPZHRPFQcqfKpRnBcXaOGvi6sKzvgQh5qLIoW3DccCO70niKkMfTm/daAT1SYG55eavA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z9BiTapiTcpKrXmlfpMPj0RVrbDF23+KbjtVVAamkvo=;
 b=mIkXkiqHo+Tj0NfQV+WGgtFJqVXXfzJUWW6FZ8VHkmTW8RFP9QhctoLqDKFZJMC9wT3/2ssAVHQClaPtfJdZvCUzXi634yb0NtlW1yyBs8OcYhEwtDFGynhT7F3DnXSDZ4wDys29kW9IJsn7xuiDyaDXFOujDCVsFycLBVWKFGqo7mE1LW61L8L9eTVllLFnpc3OKHeqrix9Q1FxGIr5zMz40gNVvk94oHteosQAGFULcgb5c4glN7r/RTfWSMKyFySK8cxi2TmM9eMI/usIzyUGeKslYRFnwS3QyYCziYYxdi3TBkL8KIxFPx6kedIpNrhdhSxBL9UEXpzfGCCp1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z9BiTapiTcpKrXmlfpMPj0RVrbDF23+KbjtVVAamkvo=;
 b=DSQC2WG3FHXLBtJMEarYEtFn8txJfbaDA/Za7Xbq02X2w2ZUhBrtJd1gkcteh5YQb/I0UB2BHXqi17Cpc0CB5HalR1lzVmqZ8HIVIJBrs7BKOLxW4ajSGaKfV8Oj5URyrSVQrSnLj4fjb/GqywxXx1esLC4m8bXPFxpLTG8Hh1Q=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=microsoft.com;
Received: from BL0PR2101MB1331.namprd21.prod.outlook.com
 (2603:10b6:208:92::17) by MN2PR21MB1502.namprd21.prod.outlook.com
 (2603:10b6:208:20b::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.1; Mon, 29 Mar
 2021 23:22:27 +0000
Received: from BL0PR2101MB1331.namprd21.prod.outlook.com
 ([fe80::e594:9393:d1b8:c235]) by BL0PR2101MB1331.namprd21.prod.outlook.com
 ([fe80::e594:9393:d1b8:c235%7]) with mapi id 15.20.3999.019; Mon, 29 Mar 2021
 23:22:27 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] hv_netvsc: Add error handling while switching data path
Date:   Mon, 29 Mar 2021 16:21:35 -0700
Message-Id: <1617060095-31582-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-Originating-IP: [13.77.154.182]
X-ClientProxiedBy: CO2PR04CA0164.namprd04.prod.outlook.com
 (2603:10b6:104:4::18) To BL0PR2101MB1331.namprd21.prod.outlook.com
 (2603:10b6:208:92::17)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by CO2PR04CA0164.namprd04.prod.outlook.com (2603:10b6:104:4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Mon, 29 Mar 2021 23:22:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4a82c287-fe49-471b-2ab2-08d8f30983e0
X-MS-TrafficTypeDiagnostic: MN2PR21MB1502:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <MN2PR21MB15028515E843CC7876D7B87BAC7E9@MN2PR21MB1502.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:519;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L9KnY3FOad/54v9IvcwW1AP3DL/SkD4O6sNo02tbOq5WkVU9KOO7hOAvO39JOGpzTvkiuSWMMWqfHviDPzoZbqcXmShGe/1IyY4lV2TgnS7AS6sZuc1zKMxVLEuhY/4L4BjELLzi0644Mc0IUlaKzlFJDemy9IdRg+gESd3jRpzX5iIbXHXFSfhBVHBxHUgN4WRofz2sgKNVLIbkjzNfOQwEfs2p55yvRZfFeUdopgwqmf4y6EHTSGH1fBCkHk/5G1ObrWQdvllXr9453ze2L2YuPLFAWoJgf6bg5s3LHDaZ+KYxEeXTCZJfdyUq2s0TtObIN9WV4DFJALPHtBHmKllMKoK3euDZMZY2SWkrOCdqkI+64RR/2eaQt2Kz3YCTk9SsDF+lDYhaRqeSQEcQCNUa/i7aPqJI6Wq1Wz6N7DRmphgzWXMolxPKvi6OW11d51WFb1ecbQTVUEyaFKLi2RdDtLGtHv3OdeULDb8dLRIGCnF128jPPWwk6ypMuT7fd5mRzi2I/mSvZ0pU2F8L73hTp09fgiP9s/MpXws3tUbKDBpWO6vVXUWl6yrCAzZJngLoG9N22iMAE08MxlLFirrQWNoCcuxqBdDJYmvjGkL1+G6lE1y7N/hcxuN+CE9uCmHJjs1GAVZ7rnTMtRi+YA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1331.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(136003)(376002)(366004)(956004)(82960400001)(316002)(5660300002)(6512007)(6506007)(82950400001)(16526019)(52116002)(83380400001)(2616005)(6666004)(2906002)(26005)(186003)(10290500003)(66476007)(478600001)(8676002)(6486002)(66946007)(66556008)(38100700001)(36756003)(8936002)(7846003)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?vFATl4L8eRn3cOXBRpQUhMh6mkAX2wyA/EtsUQNhBFWTy+ssQEaa+aNDKRr7?=
 =?us-ascii?Q?IsMuRvbbzpSj7kFRxbwyV1DyHm4Vl2DJoyHSIIbv2eaeQp7vGwbTBlMcNq9s?=
 =?us-ascii?Q?cbM6NKZ4cSjsc7EomoUYCAfQLy8OFGV2Mo0zc8p8R4N4eWRIFW7VtkBoyera?=
 =?us-ascii?Q?e33NADw6hjU4xzLfzT92GBcIzfqGXhLU3hUAIp9yutY2RvmE6czLwwjYj0M+?=
 =?us-ascii?Q?HBhNOpzG2jA14X2m/eNYYfucz/+DW1fsB9skBSLgjNh9FbzivSV/RSm4+VIU?=
 =?us-ascii?Q?eYqgq8wsCf2kGh2xxGrGlIwr3WwpKPEEoOshWdBhAOyVY3/j8GfnKRhqC54y?=
 =?us-ascii?Q?uRD/wv3fN1vSN3s4EnbH3PP3cBQ4VpzoXO7Q1QLbNH0yVqy+3/tskONAETxm?=
 =?us-ascii?Q?zrsVRu22CytuuWZicRCVsA8nmfBXxUsYPZqSAC5sTp0nrFQ4BRPAs1zX7s0d?=
 =?us-ascii?Q?ht5IU43g0gJ8vTT8V9inUhXPxz4uWFDt814XIAq1HkWXEC8sK9KSNrl/Y6M8?=
 =?us-ascii?Q?tP/GM8Jkgh/pypQcsATzvkdgkmYcaq0n8F7hAZx8hOawZ9pEoMMl1xeazmfJ?=
 =?us-ascii?Q?BtbQfgvZIbUNSVaj70sSmOfEuhkhSkXPZW/WgN5ahkb6hBOdXmSkMq0WuPv0?=
 =?us-ascii?Q?meIvngeohfETXWSJKCE9Ik7epg/zYS/16tOaU+JMnqXmbS1KoumkNxA5kqQw?=
 =?us-ascii?Q?BbsB+UmY8vU+WvX5+g2+Ee7L+w5FTz9w+QiEreHHqNWnMH64hT/QPahvlAah?=
 =?us-ascii?Q?pT1dfUxiKTDCV3EV5zqti6qOQxN1G3HjgWW4yv1HInDvyudsrWNN6o9RsB8g?=
 =?us-ascii?Q?Hz7negOt7eoGY1cJgP1LCdRVnvQOdyZeAcr56wfoe3kGDOF8uHtS4f+dFwIm?=
 =?us-ascii?Q?JTU0/DJ8Lp5cEM+T/PWt5qHqtYbnoL71a5N0TrYk0sFf4mHGeoYVFa2B2SdC?=
 =?us-ascii?Q?y7U1xst3KEvZlKjav9J2pwkwIMzTZCPP/F+a57dE1+hBFBMkDaltgX8IcBWf?=
 =?us-ascii?Q?eyRIVyIl8pg93kFBEgVa5OMNDyM9yEsXF6lZ5mJXQGsrhHfc2mY1OGa3a3X2?=
 =?us-ascii?Q?SJtjeYMVvRlyf0yUFIbh/S1lP4snfHzufS0suPKHZmiNkR8UeGuM+PcWtl34?=
 =?us-ascii?Q?PAnvmidSDCKiIE6NzPwRR+qMjqmg4O1/vqg0q/VWporj3mkz8H9G3E/C9bkb?=
 =?us-ascii?Q?doX3OeHYE2+ZKlDMop9xLrcif+Mk0UNd675L24SXwja8GuNCYxdbuKEujm9I?=
 =?us-ascii?Q?A20sHeDwskpo+j9EXU6XsGZCQpW6tBU4ATYWxL6+E1poEPxODoQCSSpV1pMM?=
 =?us-ascii?Q?hMVSNS5ORqZ4vGFnudNopreG?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a82c287-fe49-471b-2ab2-08d8f30983e0
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1331.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2021 23:22:27.4846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ys/cS3ERmv5Sb1bhtnsUUzsnOzLtKLhBUppzHnKowykAmMwHtTLP3qmQvl3exnjUk2OfAFJnUXgW50XJVBk69Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1502
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add error handling in case of failure to send switching data path message
to the host.

Reported-by: Shachar Raindel <shacharr@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

---
 drivers/net/hyperv/hyperv_net.h |  6 +++++-
 drivers/net/hyperv/netvsc.c     | 35 +++++++++++++++++++++++++++++----
 drivers/net/hyperv/netvsc_drv.c | 18 +++++++++++------
 3 files changed, 48 insertions(+), 11 deletions(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index 59ac04a610ad..442c520ab8f3 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -269,7 +269,7 @@ int rndis_filter_receive(struct net_device *ndev,
 int rndis_filter_set_device_mac(struct netvsc_device *ndev,
 				const char *mac);
 
-void netvsc_switch_datapath(struct net_device *nv_dev, bool vf);
+int netvsc_switch_datapath(struct net_device *nv_dev, bool vf);
 
 #define NVSP_INVALID_PROTOCOL_VERSION	((u32)0xFFFFFFFF)
 
@@ -1718,4 +1718,8 @@ struct rndis_message {
 #define TRANSPORT_INFO_IPV6_TCP 0x10
 #define TRANSPORT_INFO_IPV6_UDP 0x20
 
+#define RETRY_US_LO	5000
+#define RETRY_US_HI	10000
+#define RETRY_MAX	2000	/* >10 sec */
+
 #endif /* _HYPERV_NET_H */
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 5bce24731502..9d07c9ce4be2 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -31,12 +31,13 @@
  * Switch the data path from the synthetic interface to the VF
  * interface.
  */
-void netvsc_switch_datapath(struct net_device *ndev, bool vf)
+int netvsc_switch_datapath(struct net_device *ndev, bool vf)
 {
 	struct net_device_context *net_device_ctx = netdev_priv(ndev);
 	struct hv_device *dev = net_device_ctx->device_ctx;
 	struct netvsc_device *nv_dev = rtnl_dereference(net_device_ctx->nvdev);
 	struct nvsp_message *init_pkt = &nv_dev->channel_init_pkt;
+	int ret, retry = 0;
 
 	/* Block sending traffic to VF if it's about to be gone */
 	if (!vf)
@@ -51,15 +52,41 @@ void netvsc_switch_datapath(struct net_device *ndev, bool vf)
 		init_pkt->msg.v4_msg.active_dp.active_datapath =
 			NVSP_DATAPATH_SYNTHETIC;
 
+again:
 	trace_nvsp_send(ndev, init_pkt);
 
-	vmbus_sendpacket(dev->channel, init_pkt,
+	ret = vmbus_sendpacket(dev->channel, init_pkt,
 			       sizeof(struct nvsp_message),
-			       (unsigned long)init_pkt,
-			       VM_PKT_DATA_INBAND,
+			       (unsigned long)init_pkt, VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
+
+	/* If failed to switch to/from VF, let data_path_is_vf stay false,
+	 * so we use synthetic path to send data.
+	 */
+	if (ret) {
+		if (ret != -EAGAIN) {
+			netdev_err(ndev,
+				   "Unable to send sw datapath msg, err: %d\n",
+				   ret);
+			return ret;
+		}
+
+		if (retry++ < RETRY_MAX) {
+			usleep_range(RETRY_US_LO, RETRY_US_HI);
+			goto again;
+		} else {
+			netdev_err(
+				ndev,
+				"Retry failed to send sw datapath msg, err: %d\n",
+				ret);
+			return ret;
+		}
+	}
+
 	wait_for_completion(&nv_dev->channel_init_wait);
 	net_device_ctx->data_path_is_vf = vf;
+
+	return 0;
 }
 
 /* Worker to setup sub channels on initial setup
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 97b5c9b60503..7349a70af083 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -38,9 +38,6 @@
 #include "hyperv_net.h"
 
 #define RING_SIZE_MIN	64
-#define RETRY_US_LO	5000
-#define RETRY_US_HI	10000
-#define RETRY_MAX	2000	/* >10 sec */
 
 #define LINKCHANGE_INT (2 * HZ)
 #define VF_TAKEOVER_INT (HZ / 10)
@@ -2402,6 +2399,7 @@ static int netvsc_vf_changed(struct net_device *vf_netdev, unsigned long event)
 	struct netvsc_device *netvsc_dev;
 	struct net_device *ndev;
 	bool vf_is_up = false;
+	int ret;
 
 	if (event != NETDEV_GOING_DOWN)
 		vf_is_up = netif_running(vf_netdev);
@@ -2418,9 +2416,17 @@ static int netvsc_vf_changed(struct net_device *vf_netdev, unsigned long event)
 	if (net_device_ctx->data_path_is_vf == vf_is_up)
 		return NOTIFY_OK;
 
-	netvsc_switch_datapath(ndev, vf_is_up);
-	netdev_info(ndev, "Data path switched %s VF: %s\n",
-		    vf_is_up ? "to" : "from", vf_netdev->name);
+	ret = netvsc_switch_datapath(ndev, vf_is_up);
+
+	if (ret) {
+		netdev_err(ndev,
+			   "Data path failed to switch %s VF: %s, err: %d\n",
+			   vf_is_up ? "to" : "from", vf_netdev->name, ret);
+		return NOTIFY_DONE;
+	} else {
+		netdev_info(ndev, "Data path switched %s VF: %s\n",
+			    vf_is_up ? "to" : "from", vf_netdev->name);
+	}
 
 	return NOTIFY_OK;
 }
-- 
2.25.1

