Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5458643847
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 23:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233865AbiLEWnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 17:43:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbiLEWnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 17:43:09 -0500
Received: from EX-PRD-EDGE02.vmware.com (EX-PRD-EDGE02.vmware.com [208.91.3.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18E2FDB;
        Mon,  5 Dec 2022 14:43:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
    s=s1024; d=vmware.com;
    h=from:to:cc:subject:date:message-id:in-reply-to:mime-version:
      content-type;
    bh=B2CFhb1/uLnnSDm/9F7z3okCJJ3GNu+p5WEbSseyeCU=;
    b=lE82u+e9z6wM/tXjl4IlmOsb6PWNTM9/yI80ru8wxPV4a3uj9AM1FFxLPCxn/l
      +Dpjs6UU7sczyCFpl1Lc7Lf07lZNNZIe//KpkjtdQbxW7SlRHI3k320wPj/GZS
      urbRkEY0wuExzf83RT0JU15hlIMXZdgzu6F4ZJv3dqNcQyw=
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX-PRD-EDGE02.vmware.com (10.188.245.7) with Microsoft SMTP Server id
 15.1.2308.14; Mon, 5 Dec 2022 14:42:45 -0800
Received: from htb-1n-eng-dhcp122.eng.vmware.com (unknown [10.20.114.216])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 3A3D020287;
        Mon,  5 Dec 2022 14:43:01 -0800 (PST)
Received: by htb-1n-eng-dhcp122.eng.vmware.com (Postfix, from userid 0)
        id 34E09AE1A8; Mon,  5 Dec 2022 14:43:01 -0800 (PST)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     <stable@vger.kernel.org>, Ronak Doshi <doshir@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 net  1/2] vmxnet3: correctly report encapsulated LRO packet
Date:   Mon, 5 Dec 2022 14:42:54 -0800
Message-ID: <20221205224256.22830-2-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20221205224256.22830-1-doshir@vmware.com>
References: <20221205224256.22830-1-doshir@vmware.com>
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

Commit dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload
support") added support for encapsulation offload. However, the
pathc did not report correctly the encapsulated packet which is
LRO'ed by the hypervisor.

This patch fixes this issue by using correct callback for the LRO'ed
encapsulated packet.

Fixes: dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload support")
Signed-off-by: Ronak Doshi <doshir@vmware.com>
Acked-by: Guolin Yang <gyang@vmware.com>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index d3e7b27eb933..3111a8a6b26a 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1396,6 +1396,7 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 	};
 	u32 num_pkts = 0;
 	bool skip_page_frags = false;
+	bool encap_lro = false;
 	struct Vmxnet3_RxCompDesc *rcd;
 	struct vmxnet3_rx_ctx *ctx = &rq->rx_ctx;
 	u16 segCnt = 0, mss = 0;
@@ -1556,13 +1557,18 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 			if (VMXNET3_VERSION_GE_2(adapter) &&
 			    rcd->type == VMXNET3_CDTYPE_RXCOMP_LRO) {
 				struct Vmxnet3_RxCompDescExt *rcdlro;
+				union Vmxnet3_GenericDesc *gdesc;
+
 				rcdlro = (struct Vmxnet3_RxCompDescExt *)rcd;
+				gdesc = (union Vmxnet3_GenericDesc *)rcd;
 
 				segCnt = rcdlro->segCnt;
 				WARN_ON_ONCE(segCnt == 0);
 				mss = rcdlro->mss;
 				if (unlikely(segCnt <= 1))
 					segCnt = 0;
+				encap_lro = (le32_to_cpu(gdesc->dword[0]) &
+					(1UL << VMXNET3_RCD_HDR_INNER_SHIFT));
 			} else {
 				segCnt = 0;
 			}
@@ -1630,7 +1636,7 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 			vmxnet3_rx_csum(adapter, skb,
 					(union Vmxnet3_GenericDesc *)rcd);
 			skb->protocol = eth_type_trans(skb, adapter->netdev);
-			if (!rcd->tcp ||
+			if ((!rcd->tcp && !encap_lro) ||
 			    !(adapter->netdev->features & NETIF_F_LRO))
 				goto not_lro;
 
@@ -1639,7 +1645,7 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 					SKB_GSO_TCPV4 : SKB_GSO_TCPV6;
 				skb_shinfo(skb)->gso_size = mss;
 				skb_shinfo(skb)->gso_segs = segCnt;
-			} else if (segCnt != 0 || skb->len > mtu) {
+			} else if ((segCnt != 0 || skb->len > mtu) && !encap_lro) {
 				u32 hlen;
 
 				hlen = vmxnet3_get_hdr_len(adapter, skb,
@@ -1668,6 +1674,7 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 				napi_gro_receive(&rq->napi, skb);
 
 			ctx->skb = NULL;
+			encap_lro = false;
 			num_pkts++;
 		}
 
-- 
2.11.0

