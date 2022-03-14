Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D78DB4D7FBB
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 11:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237620AbiCNKX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 06:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234054AbiCNKX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 06:23:26 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C31943484
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 03:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=37iRZzgcz08aeekCIRPNzzqIgSISC+vDx+4ci1PLfTQ=; b=MGT9tEtlnfh1fGRcHq3pTOoL87
        Hx7keBJEKOXOGcC4nAjCS3B8HMhmgQA4TqIEfz06wEGQgQ5SWpew5juXB1HSOK/q8hpzecjmKXcGx
        R2G0grsQkG0E5kjuV2dxPWfFZImBuz4zPJ9r+y5wShutU4Wu4NXwEoyc0eUWZ7yKYZWk=;
Received: from p200300daa7204f006c015a90d6b6c4d6.dip0.t-ipconnect.de ([2003:da:a720:4f00:6c01:5a90:d6b6:c4d6] helo=Maecks.lan)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nThqA-0005bs-JQ
        for netdev@vger.kernel.org; Mon, 14 Mar 2022 11:22:14 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org
Subject: [PATCH] net: xdp: allow user space to request a smaller packet headroom requirement
Date:   Mon, 14 Mar 2022 11:22:10 +0100
Message-Id: <20220314102210.92329-1-nbd@nbd.name>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most ethernet drivers allocate a packet headroom of NET_SKB_PAD. Since it is
rounded up to L1 cache size, it ends up being at least 64 bytes on the most
common platforms.
On most ethernet drivers, having a guaranteed headroom of 256 bytes for XDP
adds an extra forced pskb_expand_head call when enabling SKB XDP, which can
be quite expensive.
Many XDP programs need only very little headroom, so it can be beneficial
to have a way to opt-out of the 256 bytes headroom requirement.

Add an extra flag XDP_FLAGS_SMALL_HEADROOM that can be set when attaching
the XDP program, which reduces the minimum headroom to 64 bytes.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/linux/netdevice.h          | 1 +
 include/uapi/linux/bpf.h           | 1 +
 include/uapi/linux/if_link.h       | 4 +++-
 net/core/dev.c                     | 9 ++++++++-
 tools/include/uapi/linux/if_link.h | 4 +++-
 5 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 0d994710b335..f6f270a5e301 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2274,6 +2274,7 @@ struct net_device {
 	bool			proto_down;
 	unsigned		wol_enabled:1;
 	unsigned		threaded:1;
+	unsigned		xdp_small_headroom:1;
 
 	struct list_head	net_notifier_list;
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4eebea830613..7635dfb02313 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5688,6 +5688,7 @@ struct bpf_xdp_sock {
 };
 
 #define XDP_PACKET_HEADROOM 256
+#define XDP_PACKET_HEADROOM_SMALL 64
 
 /* User return codes for XDP prog type.
  * A valid XDP program must return one of these defined values. All other
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index e003a0b9b4b2..acb996334910 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -1275,11 +1275,13 @@ enum {
 #define XDP_FLAGS_DRV_MODE		(1U << 2)
 #define XDP_FLAGS_HW_MODE		(1U << 3)
 #define XDP_FLAGS_REPLACE		(1U << 4)
+#define XDP_FLAGS_SMALL_HEADROOM	(1U << 5)
 #define XDP_FLAGS_MODES			(XDP_FLAGS_SKB_MODE | \
 					 XDP_FLAGS_DRV_MODE | \
 					 XDP_FLAGS_HW_MODE)
 #define XDP_FLAGS_MASK			(XDP_FLAGS_UPDATE_IF_NOEXIST | \
-					 XDP_FLAGS_MODES | XDP_FLAGS_REPLACE)
+					 XDP_FLAGS_MODES | XDP_FLAGS_REPLACE | \
+					 XDP_FLAGS_SMALL_HEADROOM)
 
 /* These are stored into IFLA_XDP_ATTACHED on dump. */
 enum {
diff --git a/net/core/dev.c b/net/core/dev.c
index 8d25ec5b3af7..cb12379b8f11 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4722,6 +4722,7 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 				     struct xdp_buff *xdp,
 				     struct bpf_prog *xdp_prog)
 {
+	int min_headroom = XDP_PACKET_HEADROOM;
 	u32 act = XDP_DROP;
 
 	/* Reinjected packets coming from act_mirred or similar should
@@ -4730,12 +4731,15 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	if (skb_is_redirected(skb))
 		return XDP_PASS;
 
+	if (skb->dev->xdp_small_headroom)
+		min_headroom = XDP_PACKET_HEADROOM_SMALL;
+
 	/* XDP packets must be linear and must have sufficient headroom
 	 * of XDP_PACKET_HEADROOM bytes. This is the guarantee that also
 	 * native XDP provides, thus we need to do it here as well.
 	 */
 	if (skb_cloned(skb) || skb_is_nonlinear(skb) ||
-	    skb_headroom(skb) < XDP_PACKET_HEADROOM) {
+	    skb_headroom(skb) < min_headroom) {
 		int hroom = XDP_PACKET_HEADROOM - skb_headroom(skb);
 		int troom = skb->tail + skb->data_len - skb->end;
 
@@ -9135,6 +9139,9 @@ static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack
 			return err;
 	}
 
+	if (mode == XDP_MODE_SKB)
+		dev->xdp_small_headroom = !!(flags & XDP_FLAGS_SMALL_HEADROOM);
+
 	if (link)
 		dev_xdp_set_link(dev, mode, link);
 	else
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index e1ba2d51b717..0df737a6c489 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -1185,11 +1185,13 @@ enum {
 #define XDP_FLAGS_DRV_MODE		(1U << 2)
 #define XDP_FLAGS_HW_MODE		(1U << 3)
 #define XDP_FLAGS_REPLACE		(1U << 4)
+#define XDP_FLAGS_SMALL_HEADROOM	(1U << 5)
 #define XDP_FLAGS_MODES			(XDP_FLAGS_SKB_MODE | \
 					 XDP_FLAGS_DRV_MODE | \
 					 XDP_FLAGS_HW_MODE)
 #define XDP_FLAGS_MASK			(XDP_FLAGS_UPDATE_IF_NOEXIST | \
-					 XDP_FLAGS_MODES | XDP_FLAGS_REPLACE)
+					 XDP_FLAGS_MODES | XDP_FLAGS_REPLACE | \
+					 XDP_FLAGS_SMALL_HEADROOM)
 
 /* These are stored into IFLA_XDP_ATTACHED on dump. */
 enum {
-- 
2.35.1

