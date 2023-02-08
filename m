Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD58468FA51
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 23:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbjBHWj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 17:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbjBHWj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 17:39:27 -0500
Received: from EX-PRD-EDGE02.vmware.com (EX-PRD-EDGE02.vmware.com [208.91.3.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E13E252B8;
        Wed,  8 Feb 2023 14:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
    s=s1024; d=vmware.com;
    h=from:to:cc:subject:date:message-id:mime-version:content-type;
    bh=e1HmfK/JiHvjn+oDuK3z3WPembSenG3/BCuinhbUzt0=;
    b=UOOAeYQsZrqgVbOEJ6/Pbc2BoaeyBkbMVTn2qpStp9RHheY5dZFhg778L7sTkG
      Z0aooN3K8quz/AA0yOqeofWZXH4hrTsaZ7LzCl0WOwEvDvEJAGuGDKKmeT1vv0
      7sucBssz5qKITxJjTxEgwZEbXQF7UvSfpYbcP4cLNk5yO40=
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX-PRD-EDGE02.vmware.com (10.188.245.7) with Microsoft SMTP Server id
 15.1.2375.34; Wed, 8 Feb 2023 14:38:49 -0800
Received: from htb-1n-eng-dhcp122.eng.vmware.com (unknown [10.20.114.216])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id C646B20135;
        Wed,  8 Feb 2023 14:39:01 -0800 (PST)
Received: by htb-1n-eng-dhcp122.eng.vmware.com (Postfix, from userid 0)
        id BE4E7AE43E; Wed,  8 Feb 2023 14:39:01 -0800 (PST)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     <stable@vger.kernel.org>, Ronak Doshi <doshir@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guolin Yang <gyang@vmware.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH net v3] vmxnet3: move rss code block under eop descriptor
Date:   Wed, 8 Feb 2023 14:38:59 -0800
Message-ID: <20230208223900.5794-1-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX-PRD-EDGE02.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit b3973bb40041 ("vmxnet3: set correct hash type based on
rss information") added hashType information into skb. However,
rssType field is populated for eop descriptor. This can lead
to incorrectly reporting of hashType for packets which use
multiple rx descriptors. Multiple rx descriptors are used
for Jumbo frame or LRO packets, which can hit this issue.

This patch moves the RSS codeblock under eop descritor.

Cc: stable@vger.kernel.org
Fixes: b3973bb40041 ("vmxnet3: set correct hash type based on rss information")
Signed-off-by: Ronak Doshi <doshir@vmware.com>
Acked-by: Peng Li <lpeng@vmware.com>
Acked-by: Guolin Yang <gyang@vmware.com>
---
v1->v2: added Fixes tag and CC stable
v2->v3: update commit msg
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 50 +++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 56267c327f0b..682987040ea8 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1546,31 +1546,6 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 				rxd->len = rbi->len;
 			}
 
-#ifdef VMXNET3_RSS
-			if (rcd->rssType != VMXNET3_RCD_RSS_TYPE_NONE &&
-			    (adapter->netdev->features & NETIF_F_RXHASH)) {
-				enum pkt_hash_types hash_type;
-
-				switch (rcd->rssType) {
-				case VMXNET3_RCD_RSS_TYPE_IPV4:
-				case VMXNET3_RCD_RSS_TYPE_IPV6:
-					hash_type = PKT_HASH_TYPE_L3;
-					break;
-				case VMXNET3_RCD_RSS_TYPE_TCPIPV4:
-				case VMXNET3_RCD_RSS_TYPE_TCPIPV6:
-				case VMXNET3_RCD_RSS_TYPE_UDPIPV4:
-				case VMXNET3_RCD_RSS_TYPE_UDPIPV6:
-					hash_type = PKT_HASH_TYPE_L4;
-					break;
-				default:
-					hash_type = PKT_HASH_TYPE_L3;
-					break;
-				}
-				skb_set_hash(ctx->skb,
-					     le32_to_cpu(rcd->rssHash),
-					     hash_type);
-			}
-#endif
 			skb_record_rx_queue(ctx->skb, rq->qid);
 			skb_put(ctx->skb, rcd->len);
 
@@ -1653,6 +1628,31 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 			u32 mtu = adapter->netdev->mtu;
 			skb->len += skb->data_len;
 
+#ifdef VMXNET3_RSS
+			if (rcd->rssType != VMXNET3_RCD_RSS_TYPE_NONE &&
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
+				skb_set_hash(skb,
+					     le32_to_cpu(rcd->rssHash),
+					     hash_type);
+			}
+#endif
 			vmxnet3_rx_csum(adapter, skb,
 					(union Vmxnet3_GenericDesc *)rcd);
 			skb->protocol = eth_type_trans(skb, adapter->netdev);
-- 
2.11.0

