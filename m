Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC857542702
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbiFHFlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 01:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236085AbiFHFky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 01:40:54 -0400
Received: from EX-PRD-EDGE01.vmware.com (ex-prd-edge01.vmware.com [208.91.3.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C3940BA5B;
        Tue,  7 Jun 2022 20:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
    s=s1024; d=vmware.com;
    h=from:to:cc:subject:date:message-id:in-reply-to:mime-version:
      content-type;
    bh=q1Tg/wqCzr6O6IDRP6nkjppRtmGVU7CRSaKK5KQoZrA=;
    b=gM+7zrFYzjuT6XB249YrR14hDSE0pNgadBb5EYVQBxpkux77eDEerMCkNigeDr
      VX6ec/RkYldNjjdjNkC9dSCkhTJsL+27eDaJz+Wm+4N+T8AtGr7m9bVIq2C8d/
      dhn6J1AQpqzipRJ7BPGBgUKzSKT2Ysbu1tdVppMyHslNiKc=
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX-PRD-EDGE01.vmware.com (10.188.245.6) with Microsoft SMTP Server id
 15.1.2308.20; Tue, 7 Jun 2022 20:23:53 -0700
Received: from htb-1n-eng-dhcp122.eng.vmware.com (unknown [10.20.114.216])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 9C6692346F;
        Tue,  7 Jun 2022 20:24:08 -0700 (PDT)
Received: by htb-1n-eng-dhcp122.eng.vmware.com (Postfix, from userid 0)
        id 96D69AA454; Tue,  7 Jun 2022 20:24:08 -0700 (PDT)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 net-next 7/8] vmxnet3: use ext1 field to indicate encapsulated packet
Date:   Tue, 7 Jun 2022 20:23:52 -0700
Message-ID: <20220608032353.964-8-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220608032353.964-1-doshir@vmware.com>
References: <20220608032353.964-1-doshir@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX-PRD-EDGE01.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Till vmxnet3 version 6, om field of transmit descriptor was used
to indicate encapsulated offload packet and msscof was used to
indirectly indicate TSO/CSO. From version 7 and later, ext1 field
will be used to indicate whether packet is encapsulated or not and
om fields will continue to indicate if the packet is TSO or CSO.

Signed-off-by: Ronak Doshi <doshir@vmware.com>
Acked-by: Guolin Yang <gyang@vmware.com>
---
 drivers/net/vmxnet3/vmxnet3_defs.h | 14 ++++++++------
 drivers/net/vmxnet3/vmxnet3_drv.c  | 18 +++++++++++++++---
 2 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_defs.h b/drivers/net/vmxnet3/vmxnet3_defs.h
index cb9dc72f2b3d..41d6767283a6 100644
--- a/drivers/net/vmxnet3/vmxnet3_defs.h
+++ b/drivers/net/vmxnet3/vmxnet3_defs.h
@@ -148,17 +148,17 @@ struct Vmxnet3_TxDesc {
 
 #ifdef __BIG_ENDIAN_BITFIELD
 	u32 msscof:14;  /* MSS, checksum offset, flags */
-	u32 ext1:1;
+	u32 ext1:1;     /* set to 1 to indicate inner csum/tso, vmxnet3 v7 */
 	u32 dtype:1;    /* descriptor type */
-	u32 oco:1;
+	u32 oco:1;      /* Outer csum offload */
 	u32 gen:1;      /* generation bit */
 	u32 len:14;
 #else
 	u32 len:14;
 	u32 gen:1;      /* generation bit */
-	u32 oco:1;
+	u32 oco:1;      /* Outer csum offload */
 	u32 dtype:1;    /* descriptor type */
-	u32 ext1:1;
+	u32 ext1:1;     /* set to 1 to indicate inner csum/tso, vmxnet3 v7 */
 	u32 msscof:14;  /* MSS, checksum offset, flags */
 #endif  /* __BIG_ENDIAN_BITFIELD */
 
@@ -262,11 +262,13 @@ struct Vmxnet3_RxCompDesc {
 	u32		rqID:10;      /* rx queue/ring ID */
 	u32		sop:1;        /* Start of Packet */
 	u32		eop:1;        /* End of Packet */
-	u32		ext1:2;
+	u32		ext1:2;       /* bit 0: indicating v4/v6/.. is for inner header */
+				      /* bit 1: indicating rssType is based on inner header */
 	u32		rxdIdx:12;    /* Index of the RxDesc */
 #else
 	u32		rxdIdx:12;    /* Index of the RxDesc */
-	u32		ext1:2;
+	u32		ext1:2;       /* bit 0: indicating v4/v6/.. is for inner header */
+				      /* bit 1: indicating rssType is based on inner header */
 	u32		eop:1;        /* End of Packet */
 	u32		sop:1;        /* Start of Packet */
 	u32		rqID:10;      /* rx queue/ring ID */
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 2ee3a2e39f10..5c42b4a008e8 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1161,7 +1161,12 @@ vmxnet3_tq_xmit(struct sk_buff *skb, struct vmxnet3_tx_queue *tq,
 	if (ctx.mss) {
 		if (VMXNET3_VERSION_GE_4(adapter) && skb->encapsulation) {
 			gdesc->txd.hlen = ctx.l4_offset + ctx.l4_hdr_size;
-			gdesc->txd.om = VMXNET3_OM_ENCAP;
+			if (VMXNET3_VERSION_GE_7(adapter)) {
+				gdesc->txd.om = VMXNET3_OM_TSO;
+				gdesc->txd.ext1 = 1;
+			} else {
+				gdesc->txd.om = VMXNET3_OM_ENCAP;
+			}
 			gdesc->txd.msscof = ctx.mss;
 
 			if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_TUNNEL_CSUM)
@@ -1178,8 +1183,15 @@ vmxnet3_tq_xmit(struct sk_buff *skb, struct vmxnet3_tx_queue *tq,
 			    skb->encapsulation) {
 				gdesc->txd.hlen = ctx.l4_offset +
 						  ctx.l4_hdr_size;
-				gdesc->txd.om = VMXNET3_OM_ENCAP;
-				gdesc->txd.msscof = 0;		/* Reserved */
+				if (VMXNET3_VERSION_GE_7(adapter)) {
+					gdesc->txd.om = VMXNET3_OM_CSUM;
+					gdesc->txd.msscof = ctx.l4_offset +
+							    skb->csum_offset;
+					gdesc->txd.ext1 = 1;
+				} else {
+					gdesc->txd.om = VMXNET3_OM_ENCAP;
+					gdesc->txd.msscof = 0;		/* Reserved */
+				}
 			} else {
 				gdesc->txd.hlen = ctx.l4_offset;
 				gdesc->txd.om = VMXNET3_OM_CSUM;
-- 
2.11.0

