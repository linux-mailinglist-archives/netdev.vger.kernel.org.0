Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776373CBF57
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 00:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238130AbhGPWjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 18:39:49 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:11610 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237231AbhGPWjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 18:39:39 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 16 Jul 2021 15:36:37 -0700
Received: from htb-1n-eng-dhcp122.eng.vmware.com (unknown [10.20.114.3])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id A3E7820374;
        Fri, 16 Jul 2021 15:36:42 -0700 (PDT)
Received: by htb-1n-eng-dhcp122.eng.vmware.com (Postfix, from userid 0)
        id 9FD3AAA043; Fri, 16 Jul 2021 15:36:42 -0700 (PDT)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>,
        "maintainer:VMWARE VMXNET3 ETHERNET DRIVER" <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 5/7] vmxnet3: set correct hash type based on rss information
Date:   Fri, 16 Jul 2021 15:36:24 -0700
Message-ID: <20210716223626.18928-6-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210716223626.18928-1-doshir@vmware.com>
References: <20210716223626.18928-1-doshir@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As vmxnet3 supports IP/TCP/UDP RSS, this patch sets appropriate
hash type based on the type of RSS performed.

Signed-off-by: Ronak Doshi <doshir@vmware.com>
Acked-by: Guolin Yang <gyang@vmware.com>
---
 drivers/net/vmxnet3/vmxnet3_defs.h | 16 +++++++++-------
 drivers/net/vmxnet3/vmxnet3_drv.c  | 22 ++++++++++++++++++++--
 2 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_defs.h b/drivers/net/vmxnet3/vmxnet3_defs.h
index a9c108166a52..bc82bbbcb1ab 100644
--- a/drivers/net/vmxnet3/vmxnet3_defs.h
+++ b/drivers/net/vmxnet3/vmxnet3_defs.h
@@ -344,13 +344,15 @@ struct Vmxnet3_RxCompDescExt {
 #define VMXNET3_TXD_EOP_SIZE 1
 
 /* value of RxCompDesc.rssType */
-enum {
-	VMXNET3_RCD_RSS_TYPE_NONE     = 0,
-	VMXNET3_RCD_RSS_TYPE_IPV4     = 1,
-	VMXNET3_RCD_RSS_TYPE_TCPIPV4  = 2,
-	VMXNET3_RCD_RSS_TYPE_IPV6     = 3,
-	VMXNET3_RCD_RSS_TYPE_TCPIPV6  = 4,
-};
+#define VMXNET3_RCD_RSS_TYPE_NONE     0
+#define VMXNET3_RCD_RSS_TYPE_IPV4     1
+#define VMXNET3_RCD_RSS_TYPE_TCPIPV4  2
+#define VMXNET3_RCD_RSS_TYPE_IPV6     3
+#define VMXNET3_RCD_RSS_TYPE_TCPIPV6  4
+#define VMXNET3_RCD_RSS_TYPE_UDPIPV4  5
+#define VMXNET3_RCD_RSS_TYPE_UDPIPV6  6
+#define VMXNET3_RCD_RSS_TYPE_ESPIPV4  7
+#define VMXNET3_RCD_RSS_TYPE_ESPIPV6  8
 
 
 /* a union for accessing all cmd/completion descriptors */
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 41e694d13c92..4fd6ce15a860 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1478,10 +1478,28 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 
 #ifdef VMXNET3_RSS
 			if (rcd->rssType != VMXNET3_RCD_RSS_TYPE_NONE &&
-			    (adapter->netdev->features & NETIF_F_RXHASH))
+			    (adapter->netdev->features & NETIF_F_RXHASH)) {
+				enum pkt_hash_types hash_type;
+
+				switch (rcd->rssType) {
+				case VMXNET3_RCD_RSS_TYPE_IPV4:
+				case VMXNET3_RCD_RSS_TYPE_IPV6:
+					hash_type = PKT_HASH_TYPE_L3;
+					break;
+				case VMXNET3_RCD_RSS_TYPE_TCPIPV4:
+				case VMXNET3_RCD_RSS_TYPE_TCPIPV6:
+				case VMXNET3_RCD_RSS_TYPE_UDPIPV4:
+				case VMXNET3_RCD_RSS_TYPE_UDPIPV6:
+					hash_type = PKT_HASH_TYPE_L4;
+					break;
+				default:
+					hash_type = PKT_HASH_TYPE_L3;
+					break;
+				}
 				skb_set_hash(ctx->skb,
 					     le32_to_cpu(rcd->rssHash),
-					     PKT_HASH_TYPE_L3);
+					     hash_type);
+			}
 #endif
 			skb_put(ctx->skb, rcd->len);
 
-- 
2.11.0

