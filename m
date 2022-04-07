Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0092F4F8911
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 00:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiDGUgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 16:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiDGUgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 16:36:04 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-centralusazon11021027.outbound.protection.outlook.com [52.101.62.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0062AE9F0;
        Thu,  7 Apr 2022 13:22:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PMzs5HGBjcM2Dln+yR27gjYUV/KF7gR+Oi3FtQbXKaaGN4bA5fMTMen7pwy5fI+DyUEQ1fIKU3FG8nayFOhFUo6FUXxqTkg5lh1GK+1G7xgOfKrB7v5fUa79S1pw7Nj+YScuzA1LA5P5EGMtoyk/LevvIHp1oRqK8teo+QH8SM12+CiPaDH+q3N0h/R3HRr86htm/WBbpiisOXb8cEld4MZYoff2fT9N1kBEO/XyRcKOvKrnJnsfdPhNrEiM4xxD8/03nBZCeNakndmzlXARM47vSeqSpnhhtZy4CCUv+wUamL7m3rDunS5lvrRD5gRUvik80Zyr1Ddk3riNxvSsqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bdP6xhpyA/8AwxuoTeH2SjGb8lc7OQ55+SiTl2YFbsQ=;
 b=Jb1iZYddsrQM7o8x2+v1cshsnf/WV8RhMYZynY30WyIlji+6kPAKB5+J9JJleaVT194IDfrtTg2bdf76J+aXL4DBxNc0Pff7S3QtJe+MozeiySsMoAUDhzOYd+xLTG7ImZ5jIrAR2YCJJyYZ290L06xD2dPv+mto5ysaMu3tQE2vkd6XZWYBQpEqK1vTV1Dpxx5m7h7rXorMOnljDenQhzslb8iF8s7dmjt+3rLiLo5afau/fErJgOWlNELKRjabol1C/IqjvGbCOCesABAHkIhCDDzUI4+teifaEhCcZt1TZqNycvxR+Z+DkUYDfLd5F37Dy3aS6ITf1MN+kU4b2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bdP6xhpyA/8AwxuoTeH2SjGb8lc7OQ55+SiTl2YFbsQ=;
 b=jjwdFotTO19S1LJb8Z1b11XnUzCQLw2zEOM/GDjbrf9MS78PTEcFbrtcrZJiwOnai71Sf8g0Zc+h48KoUh5Esydc3HZtTDKDMe6gkmcveIEMwLKyTGV/vDzvSWMmPpGWFX6CcKzl0+Dl8yQcNruvbq3i+N9D+NZb3rCYLrQ7yVA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from SJ0PR21MB1310.namprd21.prod.outlook.com (2603:10b6:a03:3fc::11)
 by DM5PR2101MB1078.namprd21.prod.outlook.com (2603:10b6:4:a2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.11; Thu, 7 Apr
 2022 20:21:57 +0000
Received: from SJ0PR21MB1310.namprd21.prod.outlook.com
 ([fe80::5dd5:e759:27ff:6d1f]) by SJ0PR21MB1310.namprd21.prod.outlook.com
 ([fe80::5dd5:e759:27ff:6d1f%7]) with mapi id 15.20.5164.008; Thu, 7 Apr 2022
 20:21:57 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] hv_netvsc: Add support for XDP_REDIRECT
Date:   Thu,  7 Apr 2022 13:21:34 -0700
Message-Id: <1649362894-20077-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0101.namprd04.prod.outlook.com
 (2603:10b6:303:83::16) To SJ0PR21MB1310.namprd21.prod.outlook.com
 (2603:10b6:a03:3fc::11)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eef0bb47-d94c-4406-5026-08da18d4438f
X-MS-TrafficTypeDiagnostic: DM5PR2101MB1078:EE_
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-AtpMessageProperties: SA|SL
X-Microsoft-Antispam-PRVS: <DM5PR2101MB10786F78545762C8EC4B3EE3ACE69@DM5PR2101MB1078.namprd21.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y99F068V4HetU1qnPY2PNYinZ27JZ1l66qfhh+lzKBmmgfN4CVp1UcroyPc08RyKjzA+gc2IgvXvZhlPiGyL2A0sZBGGAgW4eSeMQqBoBGg61oxw4vX6GrsZkafA53yTdLJBhXeXK/sJmz7bcUbFil8zaLjs4JVp6kqo/prJhLNXAmL+PC2cu6/reTyn4/qugNvpQvmKB+DOGV/kVZzpKx0dvZuBExTLZ/6X1HcYIAqHVEj3/y85Y0E5xBG2Zsl65B9UeNe72V8RLMigxLANgl21OGiFmqjp9ZFpX0NbAhYK16folDz8wyDwGxF+FBsqSSwRCsDpLrxmoYl7xbiQDCmz543BisWypbGUCVHXtHIlRncv6Ygphrk3XyokZnmoO90aGfYvGZSZtYeY52/1KS9Vw77cA9sisN7u9aVUftPVdAlWk2VFaQrnu4h9g9KdDzORqLemVOSIoaP6jV9z3yEl2Uze5sK1rF4xnjNvNruq+DnmlRddQAb07H8a+ANDE/f+89U+9bQuymRp7dK3xOzMkvaQ8eaiEGZ1Fx5zYzv3+1vDwHd3INgIY93E3wzN59Y1ce8HWA0n1+zbWyPlLfHoIHnZljQUy0bTDb6FIaAzSeCZkIxHjhW4PwISj7F6XvX7NFxgXoJ8TNMW3q0TH6JMPNCyNrc+gXWsEVK56+iLhkfaQN5tlNo/f3E+ZJm5JD/8/5NxCQvqs3s2o9foI4qed1eWDuj5kbgADfDi/BhrGMAqf1O/PavPKi2KeXcj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR21MB1310.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(52116002)(508600001)(6486002)(30864003)(6506007)(7846003)(5660300002)(6512007)(36756003)(2906002)(83380400001)(6666004)(8936002)(10290500003)(66476007)(38350700002)(8676002)(186003)(26005)(316002)(82950400001)(4326008)(38100700002)(66946007)(66556008)(82960400001)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DEfGgf7qk0Gj39VPq2F/V22NF2mAdryab+nzh+/Rg6TKhckdRuL7rdpyhKPP?=
 =?us-ascii?Q?PMfDRYa2EsOiJoOB7FmgJY16LRJwyKW3KSroo1mEnlJji3a9fmeLuQ5ikbPr?=
 =?us-ascii?Q?3pZdXv9LXk9ZTaij4vsHm+wo/sGJZ1Q3m6ppokxtk8v22X8AJdWAUR+rZ63L?=
 =?us-ascii?Q?0kamLL4uNDQRohToLPdfo4cC/i6lAC+GkZ+HXzW9kExZT650DzII88V/jyj7?=
 =?us-ascii?Q?bHyZwllX3TlfIzTO2xoegdyVyfNfX0zVeUWuJ6kErRcE3NDaJfc6bH/Mfibl?=
 =?us-ascii?Q?uy/2PMO4cGNNlhQlMH7Qgf8mc6U7aiDoSw7kWBoTn+btHEyFVzulIAttkhRa?=
 =?us-ascii?Q?YCg6adc39+P5mETkM+0RzrAZ70LO3uQsO2dJPE2sw0SD+aKIYRJpxhTJ94fI?=
 =?us-ascii?Q?v3CBCnc7FQ/MXbZF5SZNIZluty2IHwEwLV+6kJdUKvu07K75WxWtL/5mZrcx?=
 =?us-ascii?Q?9Eh0x1tZflB2mmkf3fmhklnW5LI+gOMWHOgO3w8e68K0kMdbhbOgoUKCYjGj?=
 =?us-ascii?Q?EAgClhOa09H8OABSRS0fcNqIz8qRFYTlgLyZDzO8C9IHFKacc7P+qcuCgtIi?=
 =?us-ascii?Q?G/AfOiRRQ/3piHe3qWSiB3rRkm5QRG/c1twdb4hTI2pWMs7ufbfW/v2+EwUT?=
 =?us-ascii?Q?d0yQQidX13mTcCX+AQa8JrP2sx/txLr9hstFE4OKkBlRP+QzqJ3/BSia8ema?=
 =?us-ascii?Q?HTutFKrRAb6UFGZPwn7kddx0QsCQpsm3I5yznpu+2hZ2i1C4lDyvUFwmtQLT?=
 =?us-ascii?Q?dqPctazN4tAlAh7vsYSNNVpEnUOQ+LH728HUfpE55sKHpGqbkTXV3d/FbA0Q?=
 =?us-ascii?Q?oNTZUTC6AwFDl3t9Gyf0JwViJ3Xs7V08krufPkMON8xCHRBli7LtTGCy0J4e?=
 =?us-ascii?Q?pg+jGbqVhiNs0UOnZTY/Ur8PZ8laSf4/b1yJRmgfe+wQiV3Do/BCGHrugz22?=
 =?us-ascii?Q?PM3uFVY5l52Wc3Y7s7dDYSU67QvLmkMDsO5bi8AEG/qAritm1fDpIajrw0Fb?=
 =?us-ascii?Q?+odwnsZN7odXq4UpEAT63awfSSMN0vzi74jekFqW9ldgBuBJpCL8Avra+o03?=
 =?us-ascii?Q?FM39DoxQQoPTlmE3G0TgxUbEZBXkWmpagWVkH53vFHXj6iv+n5wEWhWlFOcg?=
 =?us-ascii?Q?xjpEyUlAuxyVBpsvno5/SL5MRKjh4XaX5s0nQgEfYUxjhCM+CJUOsIAou3TE?=
 =?us-ascii?Q?dY9YWVsvqYo1Tg7O9/5aNNlT4vGHl4LoE2sgt5rukznh3tzrdaTj9hdbC1T7?=
 =?us-ascii?Q?jjniaYQWiQStp8RPhnrGiAJrBqsLvIRRPpixI8zPPAZjQTfOnIQTwavmYTZn?=
 =?us-ascii?Q?0dVydWL41RhSjlq0COCt0YONwJ6JEfAuonXuIL3kuDxvn6+XLdIDkYMGwgnE?=
 =?us-ascii?Q?rjHbWnhqfaO1IgPWwAp7ODliUOZ6BhvY3ucTopo5qpevrQz0gW/RB0wEh9SV?=
 =?us-ascii?Q?AeFcDqwLpU5IeCmfJ3YIaHJgiNkpGt1R/a3Oee2vdZysSCOTOIrOekpBSysD?=
 =?us-ascii?Q?gzmDwcAw0PoX4SSethw6qlPf1JY0lgkf6mLkojg9FRmff8QWL+xVd4A62guS?=
 =?us-ascii?Q?OpS1MesejQWmwe8NCnYpsgl1Blil+YP59TfUOf0e6iW0QuzyNVpw5wvD/b6C?=
 =?us-ascii?Q?1pQ8br71luqiYHTf1eA2ExyOaNlvfhKGyNQi8waBfilSzgtGYSTwZGc+rzTq?=
 =?us-ascii?Q?SUYAkGz9mbktnAON1+fFsQVUYryBeWM4GnW6MkTLL0aWJevLvmlgsO4tXK3/?=
 =?us-ascii?Q?/i/kcaR0QA=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eef0bb47-d94c-4406-5026-08da18d4438f
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR21MB1310.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 20:21:57.6794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f9kF8AOk043kg05APFwmXVCu5ajGcWjbO6pAOVoYXeiE6IjnGWFtcUSNb/d8oJh3k4Ntsk7MEmZrdc91H6VCcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB1078
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Handle XDP_REDIRECT action in netvsc driver.
Also, transparently pass ndo_xdp_xmit to VF when available.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/hyperv/hyperv_net.h |  69 ++++++++++++++-
 drivers/net/hyperv/netvsc.c     |   8 +-
 drivers/net/hyperv/netvsc_bpf.c |  95 +++++++++++++++++++-
 drivers/net/hyperv/netvsc_drv.c | 150 +++++++++++++-------------------
 4 files changed, 228 insertions(+), 94 deletions(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index cf69da0e296c..25b38a374e3c 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -15,6 +15,7 @@
 #include <linux/list.h>
 #include <linux/hyperv.h>
 #include <linux/rndis.h>
+#include <linux/jhash.h>
 
 /* RSS related */
 #define OID_GEN_RECEIVE_SCALE_CAPABILITIES 0x00010203  /* query only */
@@ -237,6 +238,7 @@ int netvsc_recv_callback(struct net_device *net,
 void netvsc_channel_cb(void *context);
 int netvsc_poll(struct napi_struct *napi, int budget);
 
+void netvsc_xdp_xmit(struct sk_buff *skb, struct net_device *ndev);
 u32 netvsc_run_xdp(struct net_device *ndev, struct netvsc_channel *nvchan,
 		   struct xdp_buff *xdp);
 unsigned int netvsc_xdp_fraglen(unsigned int len);
@@ -246,6 +248,8 @@ int netvsc_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 		   struct netvsc_device *nvdev);
 int netvsc_vf_setxdp(struct net_device *vf_netdev, struct bpf_prog *prog);
 int netvsc_bpf(struct net_device *dev, struct netdev_bpf *bpf);
+int netvsc_ndoxdp_xmit(struct net_device *ndev, int n,
+		       struct xdp_frame **frames, u32 flags);
 
 int rndis_set_subchannel(struct net_device *ndev,
 			 struct netvsc_device *nvdev,
@@ -942,12 +946,21 @@ struct nvsc_rsc {
 #define NVSC_RSC_CSUM_INFO	BIT(1)	/* valid/present bit for 'csum_info' */
 #define NVSC_RSC_HASH_INFO	BIT(2)	/* valid/present bit for 'hash_info' */
 
-struct netvsc_stats {
+struct netvsc_stats_tx {
+	u64 packets;
+	u64 bytes;
+	u64 xdp_xmit;
+	struct u64_stats_sync syncp;
+};
+
+struct netvsc_stats_rx {
 	u64 packets;
 	u64 bytes;
 	u64 broadcast;
 	u64 multicast;
 	u64 xdp_drop;
+	u64 xdp_redirect;
+	u64 xdp_tx;
 	struct u64_stats_sync syncp;
 };
 
@@ -1046,6 +1059,55 @@ struct net_device_context {
 	struct netvsc_device_info *saved_netvsc_dev_info;
 };
 
+/* Azure hosts don't support non-TCP port numbers in hashing for fragmented
+ * packets. We can use ethtool to change UDP hash level when necessary.
+ */
+static inline u32 netvsc_get_hash(struct sk_buff *skb,
+				  const struct net_device_context *ndc)
+{
+	struct flow_keys flow;
+	u32 hash, pkt_proto = 0;
+	static u32 hashrnd __read_mostly;
+
+	net_get_random_once(&hashrnd, sizeof(hashrnd));
+
+	if (!skb_flow_dissect_flow_keys(skb, &flow, 0))
+		return 0;
+
+	switch (flow.basic.ip_proto) {
+	case IPPROTO_TCP:
+		if (flow.basic.n_proto == htons(ETH_P_IP))
+			pkt_proto = HV_TCP4_L4HASH;
+		else if (flow.basic.n_proto == htons(ETH_P_IPV6))
+			pkt_proto = HV_TCP6_L4HASH;
+
+		break;
+
+	case IPPROTO_UDP:
+		if (flow.basic.n_proto == htons(ETH_P_IP))
+			pkt_proto = HV_UDP4_L4HASH;
+		else if (flow.basic.n_proto == htons(ETH_P_IPV6))
+			pkt_proto = HV_UDP6_L4HASH;
+
+		break;
+	}
+
+	if (pkt_proto & ndc->l4_hash) {
+		return skb_get_hash(skb);
+	} else {
+		if (flow.basic.n_proto == htons(ETH_P_IP))
+			hash = jhash2((u32 *)&flow.addrs.v4addrs, 2, hashrnd);
+		else if (flow.basic.n_proto == htons(ETH_P_IPV6))
+			hash = jhash2((u32 *)&flow.addrs.v6addrs, 8, hashrnd);
+		else
+			return 0;
+
+		__skb_set_sw_hash(skb, hash, false);
+	}
+
+	return hash;
+}
+
 /* Per channel data */
 struct netvsc_channel {
 	struct vmbus_channel *channel;
@@ -1060,9 +1122,10 @@ struct netvsc_channel {
 
 	struct bpf_prog __rcu *bpf_prog;
 	struct xdp_rxq_info xdp_rxq;
+	bool xdp_flush;
 
-	struct netvsc_stats tx_stats;
-	struct netvsc_stats rx_stats;
+	struct netvsc_stats_tx tx_stats;
+	struct netvsc_stats_rx rx_stats;
 };
 
 /* Per netvsc device */
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 9442f751ad3a..240f88d9c520 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -20,6 +20,7 @@
 #include <linux/vmalloc.h>
 #include <linux/rtnetlink.h>
 #include <linux/prefetch.h>
+#include <linux/filter.h>
 
 #include <asm/sync_bitops.h>
 #include <asm/mshyperv.h>
@@ -805,7 +806,7 @@ static void netvsc_send_tx_complete(struct net_device *ndev,
 		struct hv_netvsc_packet *packet
 			= (struct hv_netvsc_packet *)skb->cb;
 		u32 send_index = packet->send_buf_index;
-		struct netvsc_stats *tx_stats;
+		struct netvsc_stats_tx *tx_stats;
 
 		if (send_index != NETVSC_INVALID_INDEX)
 			netvsc_free_send_slot(net_device, send_index);
@@ -1670,12 +1671,17 @@ int netvsc_poll(struct napi_struct *napi, int budget)
 	if (!nvchan->desc)
 		nvchan->desc = hv_pkt_iter_first(channel);
 
+	nvchan->xdp_flush = false;
+
 	while (nvchan->desc && work_done < budget) {
 		work_done += netvsc_process_raw_pkt(device, nvchan, net_device,
 						    ndev, nvchan->desc, budget);
 		nvchan->desc = hv_pkt_iter_next(channel, nvchan->desc);
 	}
 
+	if (nvchan->xdp_flush)
+		xdp_do_flush();
+
 	/* Send any pending receive completions */
 	ret = send_recv_completions(ndev, net_device, nvchan);
 
diff --git a/drivers/net/hyperv/netvsc_bpf.c b/drivers/net/hyperv/netvsc_bpf.c
index 7856905414eb..d0c8e54d4b1f 100644
--- a/drivers/net/hyperv/netvsc_bpf.c
+++ b/drivers/net/hyperv/netvsc_bpf.c
@@ -10,6 +10,7 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
+#include <linux/netpoll.h>
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
 #include <linux/kernel.h>
@@ -23,11 +24,13 @@
 u32 netvsc_run_xdp(struct net_device *ndev, struct netvsc_channel *nvchan,
 		   struct xdp_buff *xdp)
 {
+	struct netvsc_stats_rx *rx_stats = &nvchan->rx_stats;
 	void *data = nvchan->rsc.data[0];
 	u32 len = nvchan->rsc.len[0];
 	struct page *page = NULL;
 	struct bpf_prog *prog;
 	u32 act = XDP_PASS;
+	bool drop = true;
 
 	xdp->data_hard_start = NULL;
 
@@ -60,9 +63,34 @@ u32 netvsc_run_xdp(struct net_device *ndev, struct netvsc_channel *nvchan,
 	switch (act) {
 	case XDP_PASS:
 	case XDP_TX:
+		drop = false;
+		break;
+
 	case XDP_DROP:
 		break;
 
+	case XDP_REDIRECT:
+		if (!xdp_do_redirect(ndev, xdp, prog)) {
+			nvchan->xdp_flush = true;
+			drop = false;
+
+			u64_stats_update_begin(&rx_stats->syncp);
+
+			rx_stats->xdp_redirect++;
+			rx_stats->packets++;
+			rx_stats->bytes += nvchan->rsc.pktlen;
+
+			u64_stats_update_end(&rx_stats->syncp);
+
+			break;
+		} else {
+			u64_stats_update_begin(&rx_stats->syncp);
+			rx_stats->xdp_drop++;
+			u64_stats_update_end(&rx_stats->syncp);
+		}
+
+		fallthrough;
+
 	case XDP_ABORTED:
 		trace_xdp_exception(ndev, prog, act);
 		break;
@@ -74,7 +102,7 @@ u32 netvsc_run_xdp(struct net_device *ndev, struct netvsc_channel *nvchan,
 out:
 	rcu_read_unlock();
 
-	if (page && act != XDP_PASS && act != XDP_TX) {
+	if (page && drop) {
 		__free_page(page);
 		xdp->data_hard_start = NULL;
 	}
@@ -199,3 +227,68 @@ int netvsc_bpf(struct net_device *dev, struct netdev_bpf *bpf)
 		return -EINVAL;
 	}
 }
+
+static int netvsc_ndoxdp_xmit_fm(struct net_device *ndev,
+				 struct xdp_frame *frame, u16 q_idx)
+{
+	struct sk_buff *skb;
+
+	skb = xdp_build_skb_from_frame(frame, ndev);
+	if (unlikely(!skb))
+		return -ENOMEM;
+
+	netvsc_get_hash(skb, netdev_priv(ndev));
+
+	skb_record_rx_queue(skb, q_idx);
+
+	netvsc_xdp_xmit(skb, ndev);
+
+	return 0;
+}
+
+int netvsc_ndoxdp_xmit(struct net_device *ndev, int n,
+		       struct xdp_frame **frames, u32 flags)
+{
+	struct net_device_context *ndev_ctx = netdev_priv(ndev);
+	const struct net_device_ops *vf_ops;
+	struct netvsc_stats_tx *tx_stats;
+	struct netvsc_device *nvsc_dev;
+	struct net_device *vf_netdev;
+	int i, count = 0;
+	u16 q_idx;
+
+	/* Don't transmit if netvsc_device is gone */
+	nvsc_dev = rcu_dereference_bh(ndev_ctx->nvdev);
+	if (unlikely(!nvsc_dev || nvsc_dev->destroy))
+		return 0;
+
+	/* If VF is present and up then redirect packets to it.
+	 * Skip the VF if it is marked down or has no carrier.
+	 * If netpoll is in uses, then VF can not be used either.
+	 */
+	vf_netdev = rcu_dereference_bh(ndev_ctx->vf_netdev);
+	if (vf_netdev && netif_running(vf_netdev) &&
+	    netif_carrier_ok(vf_netdev) && !netpoll_tx_running(ndev) &&
+	    vf_netdev->netdev_ops->ndo_xdp_xmit &&
+	    ndev_ctx->data_path_is_vf) {
+		vf_ops = vf_netdev->netdev_ops;
+		return vf_ops->ndo_xdp_xmit(vf_netdev, n, frames, flags);
+	}
+
+	q_idx = smp_processor_id() % ndev->real_num_tx_queues;
+
+	for (i = 0; i < n; i++) {
+		if (netvsc_ndoxdp_xmit_fm(ndev, frames[i], q_idx))
+			break;
+
+		count++;
+	}
+
+	tx_stats = &nvsc_dev->chan_table[q_idx].tx_stats;
+
+	u64_stats_update_begin(&tx_stats->syncp);
+	tx_stats->xdp_xmit += count;
+	u64_stats_update_end(&tx_stats->syncp);
+
+	return count;
+}
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index fde1c492ca02..27f6bbca6619 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -242,56 +242,6 @@ static inline void *init_ppi_data(struct rndis_message *msg,
 	return ppi + 1;
 }
 
-/* Azure hosts don't support non-TCP port numbers in hashing for fragmented
- * packets. We can use ethtool to change UDP hash level when necessary.
- */
-static inline u32 netvsc_get_hash(
-	struct sk_buff *skb,
-	const struct net_device_context *ndc)
-{
-	struct flow_keys flow;
-	u32 hash, pkt_proto = 0;
-	static u32 hashrnd __read_mostly;
-
-	net_get_random_once(&hashrnd, sizeof(hashrnd));
-
-	if (!skb_flow_dissect_flow_keys(skb, &flow, 0))
-		return 0;
-
-	switch (flow.basic.ip_proto) {
-	case IPPROTO_TCP:
-		if (flow.basic.n_proto == htons(ETH_P_IP))
-			pkt_proto = HV_TCP4_L4HASH;
-		else if (flow.basic.n_proto == htons(ETH_P_IPV6))
-			pkt_proto = HV_TCP6_L4HASH;
-
-		break;
-
-	case IPPROTO_UDP:
-		if (flow.basic.n_proto == htons(ETH_P_IP))
-			pkt_proto = HV_UDP4_L4HASH;
-		else if (flow.basic.n_proto == htons(ETH_P_IPV6))
-			pkt_proto = HV_UDP6_L4HASH;
-
-		break;
-	}
-
-	if (pkt_proto & ndc->l4_hash) {
-		return skb_get_hash(skb);
-	} else {
-		if (flow.basic.n_proto == htons(ETH_P_IP))
-			hash = jhash2((u32 *)&flow.addrs.v4addrs, 2, hashrnd);
-		else if (flow.basic.n_proto == htons(ETH_P_IPV6))
-			hash = jhash2((u32 *)&flow.addrs.v6addrs, 8, hashrnd);
-		else
-			return 0;
-
-		__skb_set_sw_hash(skb, hash, false);
-	}
-
-	return hash;
-}
-
 static inline int netvsc_get_tx_queue(struct net_device *ndev,
 				      struct sk_buff *skb, int old_idx)
 {
@@ -804,7 +754,7 @@ void netvsc_linkstatus_callback(struct net_device *net,
 }
 
 /* This function should only be called after skb_record_rx_queue() */
-static void netvsc_xdp_xmit(struct sk_buff *skb, struct net_device *ndev)
+void netvsc_xdp_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	int rc;
 
@@ -925,7 +875,7 @@ int netvsc_recv_callback(struct net_device *net,
 	struct vmbus_channel *channel = nvchan->channel;
 	u16 q_idx = channel->offermsg.offer.sub_channel_index;
 	struct sk_buff *skb;
-	struct netvsc_stats *rx_stats = &nvchan->rx_stats;
+	struct netvsc_stats_rx *rx_stats = &nvchan->rx_stats;
 	struct xdp_buff xdp;
 	u32 act;
 
@@ -934,6 +884,9 @@ int netvsc_recv_callback(struct net_device *net,
 
 	act = netvsc_run_xdp(net, nvchan, &xdp);
 
+	if (act == XDP_REDIRECT)
+		return NVSP_STAT_SUCCESS;
+
 	if (act != XDP_PASS && act != XDP_TX) {
 		u64_stats_update_begin(&rx_stats->syncp);
 		rx_stats->xdp_drop++;
@@ -958,6 +911,9 @@ int netvsc_recv_callback(struct net_device *net,
 	 * statistics will not work correctly.
 	 */
 	u64_stats_update_begin(&rx_stats->syncp);
+	if (act == XDP_TX)
+		rx_stats->xdp_tx++;
+
 	rx_stats->packets++;
 	rx_stats->bytes += nvchan->rsc.pktlen;
 
@@ -1353,28 +1309,29 @@ static void netvsc_get_pcpu_stats(struct net_device *net,
 	/* fetch percpu stats of netvsc */
 	for (i = 0; i < nvdev->num_chn; i++) {
 		const struct netvsc_channel *nvchan = &nvdev->chan_table[i];
-		const struct netvsc_stats *stats;
+		const struct netvsc_stats_tx *tx_stats;
+		const struct netvsc_stats_rx *rx_stats;
 		struct netvsc_ethtool_pcpu_stats *this_tot =
 			&pcpu_tot[nvchan->channel->target_cpu];
 		u64 packets, bytes;
 		unsigned int start;
 
-		stats = &nvchan->tx_stats;
+		tx_stats = &nvchan->tx_stats;
 		do {
-			start = u64_stats_fetch_begin_irq(&stats->syncp);
-			packets = stats->packets;
-			bytes = stats->bytes;
-		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+			start = u64_stats_fetch_begin_irq(&tx_stats->syncp);
+			packets = tx_stats->packets;
+			bytes = tx_stats->bytes;
+		} while (u64_stats_fetch_retry_irq(&tx_stats->syncp, start));
 
 		this_tot->tx_bytes	+= bytes;
 		this_tot->tx_packets	+= packets;
 
-		stats = &nvchan->rx_stats;
+		rx_stats = &nvchan->rx_stats;
 		do {
-			start = u64_stats_fetch_begin_irq(&stats->syncp);
-			packets = stats->packets;
-			bytes = stats->bytes;
-		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+			start = u64_stats_fetch_begin_irq(&rx_stats->syncp);
+			packets = rx_stats->packets;
+			bytes = rx_stats->bytes;
+		} while (u64_stats_fetch_retry_irq(&rx_stats->syncp, start));
 
 		this_tot->rx_bytes	+= bytes;
 		this_tot->rx_packets	+= packets;
@@ -1406,27 +1363,28 @@ static void netvsc_get_stats64(struct net_device *net,
 
 	for (i = 0; i < nvdev->num_chn; i++) {
 		const struct netvsc_channel *nvchan = &nvdev->chan_table[i];
-		const struct netvsc_stats *stats;
+		const struct netvsc_stats_tx *tx_stats;
+		const struct netvsc_stats_rx *rx_stats;
 		u64 packets, bytes, multicast;
 		unsigned int start;
 
-		stats = &nvchan->tx_stats;
+		tx_stats = &nvchan->tx_stats;
 		do {
-			start = u64_stats_fetch_begin_irq(&stats->syncp);
-			packets = stats->packets;
-			bytes = stats->bytes;
-		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+			start = u64_stats_fetch_begin_irq(&tx_stats->syncp);
+			packets = tx_stats->packets;
+			bytes = tx_stats->bytes;
+		} while (u64_stats_fetch_retry_irq(&tx_stats->syncp, start));
 
 		t->tx_bytes	+= bytes;
 		t->tx_packets	+= packets;
 
-		stats = &nvchan->rx_stats;
+		rx_stats = &nvchan->rx_stats;
 		do {
-			start = u64_stats_fetch_begin_irq(&stats->syncp);
-			packets = stats->packets;
-			bytes = stats->bytes;
-			multicast = stats->multicast + stats->broadcast;
-		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+			start = u64_stats_fetch_begin_irq(&rx_stats->syncp);
+			packets = rx_stats->packets;
+			bytes = rx_stats->bytes;
+			multicast = rx_stats->multicast + rx_stats->broadcast;
+		} while (u64_stats_fetch_retry_irq(&rx_stats->syncp, start));
 
 		t->rx_bytes	+= bytes;
 		t->rx_packets	+= packets;
@@ -1515,8 +1473,8 @@ static const struct {
 /* statistics per queue (rx/tx packets/bytes) */
 #define NETVSC_PCPU_STATS_LEN (num_present_cpus() * ARRAY_SIZE(pcpu_stats))
 
-/* 5 statistics per queue (rx/tx packets/bytes, rx xdp_drop) */
-#define NETVSC_QUEUE_STATS_LEN(dev) ((dev)->num_chn * 5)
+/* 8 statistics per queue (rx/tx packets/bytes, XDP actions) */
+#define NETVSC_QUEUE_STATS_LEN(dev) ((dev)->num_chn * 8)
 
 static int netvsc_get_sset_count(struct net_device *dev, int string_set)
 {
@@ -1543,12 +1501,16 @@ static void netvsc_get_ethtool_stats(struct net_device *dev,
 	struct net_device_context *ndc = netdev_priv(dev);
 	struct netvsc_device *nvdev = rtnl_dereference(ndc->nvdev);
 	const void *nds = &ndc->eth_stats;
-	const struct netvsc_stats *qstats;
+	const struct netvsc_stats_tx *tx_stats;
+	const struct netvsc_stats_rx *rx_stats;
 	struct netvsc_vf_pcpu_stats sum;
 	struct netvsc_ethtool_pcpu_stats *pcpu_sum;
 	unsigned int start;
 	u64 packets, bytes;
 	u64 xdp_drop;
+	u64 xdp_redirect;
+	u64 xdp_tx;
+	u64 xdp_xmit;
 	int i, j, cpu;
 
 	if (!nvdev)
@@ -1562,26 +1524,32 @@ static void netvsc_get_ethtool_stats(struct net_device *dev,
 		data[i++] = *(u64 *)((void *)&sum + vf_stats[j].offset);
 
 	for (j = 0; j < nvdev->num_chn; j++) {
-		qstats = &nvdev->chan_table[j].tx_stats;
+		tx_stats = &nvdev->chan_table[j].tx_stats;
 
 		do {
-			start = u64_stats_fetch_begin_irq(&qstats->syncp);
-			packets = qstats->packets;
-			bytes = qstats->bytes;
-		} while (u64_stats_fetch_retry_irq(&qstats->syncp, start));
+			start = u64_stats_fetch_begin_irq(&tx_stats->syncp);
+			packets = tx_stats->packets;
+			bytes = tx_stats->bytes;
+			xdp_xmit = tx_stats->xdp_xmit;
+		} while (u64_stats_fetch_retry_irq(&tx_stats->syncp, start));
 		data[i++] = packets;
 		data[i++] = bytes;
+		data[i++] = xdp_xmit;
 
-		qstats = &nvdev->chan_table[j].rx_stats;
+		rx_stats = &nvdev->chan_table[j].rx_stats;
 		do {
-			start = u64_stats_fetch_begin_irq(&qstats->syncp);
-			packets = qstats->packets;
-			bytes = qstats->bytes;
-			xdp_drop = qstats->xdp_drop;
-		} while (u64_stats_fetch_retry_irq(&qstats->syncp, start));
+			start = u64_stats_fetch_begin_irq(&rx_stats->syncp);
+			packets = rx_stats->packets;
+			bytes = rx_stats->bytes;
+			xdp_drop = rx_stats->xdp_drop;
+			xdp_redirect = rx_stats->xdp_redirect;
+			xdp_tx = rx_stats->xdp_tx;
+		} while (u64_stats_fetch_retry_irq(&rx_stats->syncp, start));
 		data[i++] = packets;
 		data[i++] = bytes;
 		data[i++] = xdp_drop;
+		data[i++] = xdp_redirect;
+		data[i++] = xdp_tx;
 	}
 
 	pcpu_sum = kvmalloc_array(num_possible_cpus(),
@@ -1622,9 +1590,12 @@ static void netvsc_get_strings(struct net_device *dev, u32 stringset, u8 *data)
 		for (i = 0; i < nvdev->num_chn; i++) {
 			ethtool_sprintf(&p, "tx_queue_%u_packets", i);
 			ethtool_sprintf(&p, "tx_queue_%u_bytes", i);
+			ethtool_sprintf(&p, "tx_queue_%u_xdp_xmit", i);
 			ethtool_sprintf(&p, "rx_queue_%u_packets", i);
 			ethtool_sprintf(&p, "rx_queue_%u_bytes", i);
 			ethtool_sprintf(&p, "rx_queue_%u_xdp_drop", i);
+			ethtool_sprintf(&p, "rx_queue_%u_xdp_redirect", i);
+			ethtool_sprintf(&p, "rx_queue_%u_xdp_tx", i);
 		}
 
 		for_each_present_cpu(cpu) {
@@ -2057,6 +2028,7 @@ static const struct net_device_ops device_ops = {
 	.ndo_select_queue =		netvsc_select_queue,
 	.ndo_get_stats64 =		netvsc_get_stats64,
 	.ndo_bpf =			netvsc_bpf,
+	.ndo_xdp_xmit =			netvsc_ndoxdp_xmit,
 };
 
 /*
-- 
2.25.1

