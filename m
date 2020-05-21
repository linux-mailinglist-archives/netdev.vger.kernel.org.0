Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B71E1DD9AC
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 23:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730017AbgEUVtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 17:49:43 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:36017 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729374AbgEUVtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 17:49:42 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from huyn@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 May 2020 00:49:39 +0300
Received: from sw-mtx-011.mtx.labs.mlnx. (sw-mtx-011.mtx.labs.mlnx [10.9.150.38])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 04LLnaRT032127;
        Fri, 22 May 2020 00:49:37 +0300
From:   Huy Nguyen <huyn@mellanox.com>
To:     davem@davemloft.net
Cc:     steffen.klassert@secunet.com, saeedm@mellanox.com,
        borisp@mellanox.com, raeds@mellanox.com, netdev@vger.kernel.org,
        huyn@nvidia.com, Huy Nguyen <huyn@mellanox.com>
Subject: [PATCH] xfrm: Fix double ESP trailer insertion in IPsec crypto offload
Date:   Thu, 21 May 2020 16:49:33 -0500
Message-Id: <1590097773-14776-1-git-send-email-huyn@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During IPsec performance testing, we see bad ICMP checksum. The issue is that
the error packet that has duplicated ESP trailer. For example, this below ping reply skb is
collected at mlx5e_xmit. This ping reply skb length is 154 because it has
extra duplicate 20 bytes of ESP trailer. The correct length is 134.
  skb len=154 headroom=2 headlen=154 tailroom=36
  mac=(2,14) net=(16,20) trans=36
  shinfo(txflags=0 nr_frags=0 gso(size=0 type=0 segs=0))
  csum(0xd21a62ff ip_summed=0 complete_sw=0 valid=0 level=0)
  hash(0x0 sw=0 l4=0) proto=0x0800 pkttype=0 iif=0
  dev name=enp4s0f0np0 feat=0x0x001ca1829fd14ba9
  sk family=2 type=3 proto=1
  skb headroom: 00000000: 00 00
  skb linear:   00000000: b8 59 9f da d6 6a b8 59 9f da d5 52 08 00 45 00
  skb linear:   00000010: 00 8c 76 0f 00 00 40 32 80 5f c0 a8 01 41 c0 a8
  skb linear:   00000020: 01 40 8e 20 a1 20 00 39 03 28 c0 a8 01 41 c0 a8
  skb linear:   00000030: 01 40 00 00 12 ec cf ba 03 24 97 cf a9 5e 00 00
  skb linear:   00000040: 00 00 13 34 07 00 00 00 00 00 10 11 12 13 14 15
  skb linear:   00000050: 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 24 25
  skb linear:   00000060: 26 27 28 29 2a 2b 2c 2d 2e 2f 30 31 32 33 34 35
  skb linear:   00000070: 36 37 01 02 02 01 00 00 00 00 00 00 00 00 00 00
  skb linear:   00000080: 00 00 00 00 00 00 01 02 02 01 00 00 00 00 00 00
  skb linear:   00000090: 00 00 00 00 00 00 00 00 00 00
  skb tailroom: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 a8 50 69 d7
  skb tailroom: 00000010: 96 9f ff ff a8 50 69 d7 96 9f ff ff c0 01 58 d0
  skb tailroom: 00000020: 96 9f ff ff

We figure out that the packet goes through two sch_direct_xmit from qdsic.
The first one is from ip_output and the later one is from NET_TX
softirq. Below are the two stack traces on the same packet. The first one
fails to send the packet because netif_xmit_frozen_or_stopped is true and
the packet gets dev_requeue_skb. However at this stage, the packet
already has the ESP trailer. Fix by marking the skb with XFRM_XMIT bit after
the packet is handled by validate_xmit_xfrm to avoid duplicate ESP trailer insertion.

1st one via ip_output
  dump_stack+0x66/0x90
  esp_output_head+0x21a/0x520 [esp4]
  esp_xmit+0x12e/0x270 [esp4_offload]
  ? ktime_get+0x36/0xa0
  validate_xmit_xfrm+0x247/0x2f0
  ? validate_xmit_skb+0x1d/0x270
  validate_xmit_skb_list+0x46/0x70
  sch_direct_xmit+0x18a/0x320
  __qdisc_run+0x144/0x530
  __dev_queue_xmit+0x3bb/0x8a0
  ip_finish_output2+0x3ee/0x5b0
  ip_output+0x6d/0xe0

2nd one via NET_TX softirq
  dump_stack+0x66/0x90
  esp_output_head.cold.29+0x22/0x27 [esp4]
  esp_xmit+0x12e/0x270 [esp4_offload]
  validate_xmit_xfrm+0x247/0x2f0
  ? validate_xmit_skb+0x1d/0x270
  validate_xmit_skb_list+0x46/0x70
  sch_direct_xmit+0x18a/0x320
  __qdisc_run+0x144/0x530
  net_tx_action+0x15d/0x240
  __do_softirq+0xdf/0x2e5
  irq_exit+0xdb/0xe0
  smp_apic_timer_interrupt+0x74/0x130
  apic_timer_interrupt+0xf/0x20

issue: 2143007
Fixes: f6e27114a60a ("net: Add a xfrm validate function to validate_xmit_skb")
Change-Id: I2bc1a189b8160cd90b66b44212b4d44bbdebcaea
Signed-off-by: Huy Nguyen <huyn@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Reviewed-by: Raed Salem <raeds@mellanox.com>
---
 include/net/xfrm.h     | 1 +
 net/xfrm/xfrm_device.c | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 8f71c11..0302470 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1013,6 +1013,7 @@ struct xfrm_offload {
 #define	XFRM_GRO		32
 #define	XFRM_ESP_NO_TRAILER	64
 #define	XFRM_DEV_RESUME		128
+#define	XFRM_XMIT		256
 
 	__u32			status;
 #define CRYPTO_SUCCESS				1
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 6cc7f7f..c122e3e 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -110,7 +110,7 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 	struct xfrm_offload *xo = xfrm_offload(skb);
 	struct sec_path *sp;
 
-	if (!xo)
+	if (!xo || (xo->flags & XFRM_XMIT))
 		return skb;
 
 	if (!(features & NETIF_F_HW_ESP))
@@ -131,6 +131,8 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 		return skb;
 	}
 
+	xo->flags |= XFRM_XMIT;
+
 	if (skb_is_gso(skb)) {
 		struct net_device *dev = skb->dev;
 
-- 
1.8.3.1

