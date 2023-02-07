Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3D6768E13E
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 20:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbjBGTcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 14:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjBGTcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 14:32:31 -0500
X-Greylist: delayed 60 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 07 Feb 2023 11:32:29 PST
Received: from EX-PRD-EDGE02.vmware.com (ex-prd-edge02.vmware.com [208.91.3.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C133B643;
        Tue,  7 Feb 2023 11:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
    s=s1024; d=vmware.com;
    h=from:to:cc:subject:date:message-id:mime-version:content-type;
    bh=w20m7ZH8tXbL4t7e7imS4F+uFWiE4c1+HH+ypew424E=;
    b=sVQCLMQgXBiOrXV0m35GyHLLkNzp0DAxen2R0I+YwK2pToKGBMmHUG+nMST8Oy
      71AzWApYLrHg6s4CWNjfmLAcpGGSYFUfumxX2XJGsv0qamB+zU1+W027AGqaEV
      xHiJqUam3UryujtGEHa+SBs0z1LAg75XM7pM+tb41tEyFS0=
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX-PRD-EDGE02.vmware.com (10.188.245.7) with Microsoft SMTP Server id
 15.1.2375.34; Tue, 7 Feb 2023 11:28:49 -0800
Received: from htb-1n-eng-dhcp122.eng.vmware.com (unknown [10.20.114.216])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 735CF202C5;
        Tue,  7 Feb 2023 11:29:01 -0800 (PST)
Received: by htb-1n-eng-dhcp122.eng.vmware.com (Postfix, from userid 0)
        id 6FEF2AE43C; Tue,  7 Feb 2023 11:29:01 -0800 (PST)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     <stable@vger.kernel.org>, Ronak Doshi <doshir@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH net ] vmxnet3: move rss code block under eop descriptor
Date:   Tue, 7 Feb 2023 11:28:49 -0800
Message-ID: <20230207192849.2732-1-doshir@vmware.com>
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
rssType field is populated for eop descriptor.

This patch moves the RSS codeblock under eop descritor.

Signed-off-by: Ronak Doshi <doshir@vmware.com>
Acked-by: Peng Li <lpeng@vmware.com>
Acked-by: Guolin Yang <gyang@vmware.com>
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

