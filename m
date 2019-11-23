Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B98A2108121
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 00:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbfKWXvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 18:51:22 -0500
Received: from mail-eopbgr800135.outbound.protection.outlook.com ([40.107.80.135]:29472
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726759AbfKWXvW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Nov 2019 18:51:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cESjzx+jltVYNz8+f5CDfp5ysh6yQT2s1XEymXhrXLpLXw2Cn21JyDgYmBh4bHUGyFk8xvC55HugKpmrOcVIBnwsGR9NUQ/HSsYn/exZSTBTXtVsS4uFKqmI+jKKDOwm6KUHMUEMCgoPDPi2mvxNLnkq1N3py0iNfunjCEQ5sEU95E6ggtnNKTaJI+TmQ6Waw2eKNE0DawVhF6c85kaWR7J0lwAKs+UmAWKcFtQr8+L9qe77PceMlbwsth3eC9Jx89Ou+1cSrK4oKdTB4KfpSKlm1Mq/Hk50NBtPUtoEJz2Sp58m5QdhCP33F1KAKP7npnaM3EiTsVlCM/1swxMwJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wPoyttWIAfCmtSiJzboeCBHnD1CjPwsA9DGskvn+/O0=;
 b=OxznLbviZyMzBS9YF4zQLhy+q1K1vgrKIGWyTX5Bn8huzAhi4FdK6ds0f6ZAx3xPuwIjbuf/fay1ysA9KuPHigO9TqU73ex18Dm13hyrVpws+Aqizkb3y6tFhjQ6byhleQRquE+1LwzmgF57RS13EeEfpTCPN7cDUegEV/C+3aeNC1D/HLcOyi03A8cxC6pv14W2i7gRUcXmTqTF6147r8Wb5OfCaqOhaDNSfOkm1XzfCNdKdzTkd7bqHmCDN90IhsoNZY4iaO2YLGipgeQ+iLzhWBDFsN9w24+jCG2ge7fP0DrjfOOhN0Mhy75I2rKdvsmi1QG+Oh+P4LdwEtMBjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wPoyttWIAfCmtSiJzboeCBHnD1CjPwsA9DGskvn+/O0=;
 b=ZNI2h/psy4puvKiMYW+jfOOeA4QB+WCND/PzWvMMvuNGkU7e3zbgnwm29AaCeKrvR1OH+mJGVuTXZSuxyK88IgPZtzbqRgnL4EVa2M55ogPV51BMDR3uYkVTUsh8/7UnO75fRxDSZspQJbMpk0Flc8qv8NuDQngsGkzkhejDkGE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1180.namprd21.prod.outlook.com (20.179.48.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.3; Sat, 23 Nov 2019 23:51:18 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::a8b2:cdb:8839:3031]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::a8b2:cdb:8839:3031%4]) with mapi id 15.20.2495.010; Sat, 23 Nov 2019
 23:51:18 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] hv_netvsc: make recording RSS hash depend on feature flag
Date:   Sat, 23 Nov 2019 15:50:17 -0800
Message-Id: <1574553017-87877-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MWHPR19CA0024.namprd19.prod.outlook.com
 (2603:10b6:300:d4::34) To DM6PR21MB1242.namprd21.prod.outlook.com
 (2603:10b6:5:169::22)
MIME-Version: 1.0
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MWHPR19CA0024.namprd19.prod.outlook.com (2603:10b6:300:d4::34) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Sat, 23 Nov 2019 23:51:17 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 48485434-9539-4f9a-3ac0-08d7707008cf
X-MS-TrafficTypeDiagnostic: DM6PR21MB1180:|DM6PR21MB1180:|DM6PR21MB1180:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM6PR21MB1180D4AEB0B6051F2856D37EAC480@DM6PR21MB1180.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-Forefront-PRVS: 0230B09AC4
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(396003)(366004)(346002)(376002)(39860400002)(136003)(199004)(189003)(8676002)(305945005)(50226002)(16526019)(186003)(6436002)(6506007)(4326008)(36756003)(22452003)(52116002)(51416003)(6486002)(26005)(48376002)(956004)(386003)(66476007)(2616005)(50466002)(16586007)(66946007)(316002)(10090500001)(47776003)(2906002)(66066001)(4720700003)(8936002)(6116002)(10290500003)(478600001)(3846002)(81166006)(66556008)(7736002)(25786009)(6512007)(81156014)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1180;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 521CIfvlXbHlFwWdZkDLqx9OxEStgB3PkJJBmTwsztAPvK/mELqDmSmcWGew0QKRAO6kyZMZP0aNcPZkXGKSU4ZRONx8RZgcE0BEAxL7GlnLaDiruNDP2ZKzFTJQTzgBzdKwGZzMfM1592qYzgp5HpRt8dMAZNstT6wrchHNuNc0gKUnXSlLF5ewoRVJ/6rg+3bnphj4nRdA/orZpFCM/PQlTCJ/o3t3uEhSrt3BP8zE3t9OLYYqksq7niJWBeIlUIKZxWATe/WXxw0dXK5ldLClRZ1OyT1sbNIUCPeohiDaw9cBX4AyoPAba4W+Ca79lXBM+Rk6mJm3KiOrKDT1XpYnKIh6dxvNNKWQtjGIFHE1RUEYOtJzuJCENXReX2Y5AilW0Cowhnh7MklSnV7uuGOzpXGXBtbdclDA44ChOHmyo9+0tiAG0TIfcUrFZr7n
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48485434-9539-4f9a-3ac0-08d7707008cf
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2019 23:51:18.6169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 51zfMmdZ8SX9w5M/4+VmVUhENCBO0eMABkNk+vgTusLbrBCVp/7VGngYipHpRh/YduRGSjqiabvrxnolp8iY+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <sthemmin@microsoft.com>

The recording of RSS hash should be controlled by NETIF_F_RXHASH.

Fixes: 1fac7ca4e63b ("hv_netvsc: record hardware hash in skb")
Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/hyperv/hyperv_net.h   | 3 ++-
 drivers/net/hyperv/netvsc_drv.c   | 2 +-
 drivers/net/hyperv/rndis_filter.c | 1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index 4209d1cf57f6..0be5ce90dc7c 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -822,7 +822,8 @@ struct nvsp_message {
 
 #define NETVSC_SUPPORTED_HW_FEATURES (NETIF_F_RXCSUM | NETIF_F_IP_CSUM | \
 				      NETIF_F_TSO | NETIF_F_IPV6_CSUM | \
-				      NETIF_F_TSO6 | NETIF_F_LRO | NETIF_F_SG)
+				      NETIF_F_TSO6 | NETIF_F_LRO | \
+				      NETIF_F_SG | NETIF_F_RXHASH)
 
 #define VRSS_SEND_TAB_SIZE 16  /* must be power of 2 */
 #define VRSS_CHANNEL_MAX 64
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 5fa5c49e481b..868e22e286ca 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -803,7 +803,7 @@ static struct sk_buff *netvsc_alloc_recv_skb(struct net_device *net,
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 	}
 
-	if (hash_info)
+	if (hash_info && (net->features & NETIF_F_RXHASH))
 		skb_set_hash(skb, *hash_info, PKT_HASH_TYPE_L4);
 
 	if (vlan) {
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index c06178380ac8..206b4e77eaf0 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1214,6 +1214,7 @@ static int rndis_netdev_set_hwcaps(struct rndis_device *rndis_device,
 	/* Compute tx offload settings based on hw capabilities */
 	net->hw_features |= NETIF_F_RXCSUM;
 	net->hw_features |= NETIF_F_SG;
+	net->hw_features |= NETIF_F_RXHASH;
 
 	if ((hwcaps.csum.ip4_txcsum & NDIS_TXCSUM_ALL_TCP4) == NDIS_TXCSUM_ALL_TCP4) {
 		/* Can checksum TCP */
-- 
2.20.1

