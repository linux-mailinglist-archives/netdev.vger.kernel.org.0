Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9600192ACA
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 15:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbgCYOI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 10:08:57 -0400
Received: from m12-18.163.com ([220.181.12.18]:49046 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727685AbgCYOI5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 10:08:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Jdzx/
        DsogFDV3HQbtZg62guprKu2a0s0mALZZTOTcTc=; b=Ub4gkSEqot3y3+gQzaHo8
        KHf1q63oMBj16s1+9FFXeTEpdL+PQffJJbi4Ar93zae+/K/PuzptpcjwdS43oARf
        KXVk1wJVC8mqnr+wwMT4++11dR73AWGKob+1ses5TVlAG3dq7pijCsk5wef7YNrU
        PB9VQQcbPqpLwj7D+imLd8=
Received: from yangyi0100.home.langchao.com (unknown [221.221.244.114])
        by smtp14 (Coremail) with SMTP id EsCowADH5CzuZXteFGoUBQ--.279S2;
        Wed, 25 Mar 2020 22:08:47 +0800 (CST)
From:   yang_y_yi@163.com
To:     netdev@vger.kernel.org
Cc:     u9012063@gmail.com, yangyi01@inspur.com, yang_y_yi@163.com
Subject: [PATCH net-next] net/packet: fix TPACKET_V3 performance issue in case of TSO
Date:   Wed, 25 Mar 2020 22:08:45 +0800
Message-Id: <20200325140845.11840-1-yang_y_yi@163.com>
X-Mailer: git-send-email 2.19.2.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EsCowADH5CzuZXteFGoUBQ--.279S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxWr17JF43Cw1rWr17Jr45trb_yoWrGF4fpa
        yYkF92y3y5Ga12ga1xA39xJr13W34kJr9rK3yDXw1SyFyDJrWSq3yqyFyUuFyDAF97Za1j
        gFyktF1UCw1qgFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UCNt3UUUUU=
X-Originating-IP: [221.221.244.114]
X-CM-SenderInfo: 51dqwsp1b1xqqrwthudrp/xtbBEA-xi1UMP9jjiwAAsz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yi Yang <yangyi01@inspur.com>

TPACKET_V3 performance is very very bad in case of TSO, it is even
worse than non-TSO case. For Linux kernels which set CONFIG_HZ to
1000, req.tp_retire_blk_tov = 1 can help improve it a bit, but some
Linux distributions set CONFIG_HZ to 250, so req.tp_retire_blk_tov = 1
actually means req.tp_retire_blk_tov = 4, it won't have any help.

This fix patch can fix the aforementioned performance issue, it can
boost the performance from 3.05Gbps to 16.9Gbps, a very huge
improvement. It will retire current block as early as possible in
case of TSO in order that userspace application can consume it
in time.

Signed-off-by: Yi Yang <yangyi01@inspur.com>
---
 net/packet/af_packet.c | 42 ++++++++++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index e5b0986..cbe9052 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1005,7 +1005,8 @@ static void prb_fill_curr_block(char *curr,
 /* Assumes caller has the sk->rx_queue.lock */
 static void *__packet_lookup_frame_in_block(struct packet_sock *po,
 					    struct sk_buff *skb,
-					    unsigned int len
+					    unsigned int len,
+					    bool retire_cur_block
 					    )
 {
 	struct tpacket_kbdq_core *pkc;
@@ -1041,7 +1042,8 @@ static void *__packet_lookup_frame_in_block(struct packet_sock *po,
 	end = (char *)pbd + pkc->kblk_size;
 
 	/* first try the current block */
-	if (curr+TOTAL_PKT_LEN_INCL_ALIGN(len) < end) {
+	if (BLOCK_NUM_PKTS(pbd) == 0 ||
+	    (!retire_cur_block && curr+TOTAL_PKT_LEN_INCL_ALIGN(len) < end)) {
 		prb_fill_curr_block(curr, pkc, pbd, len);
 		return (void *)curr;
 	}
@@ -1066,7 +1068,8 @@ static void *__packet_lookup_frame_in_block(struct packet_sock *po,
 
 static void *packet_current_rx_frame(struct packet_sock *po,
 					    struct sk_buff *skb,
-					    int status, unsigned int len)
+					    int status, unsigned int len,
+					    bool retire_cur_block)
 {
 	char *curr = NULL;
 	switch (po->tp_version) {
@@ -1076,7 +1079,8 @@ static void *packet_current_rx_frame(struct packet_sock *po,
 					po->rx_ring.head, status);
 		return curr;
 	case TPACKET_V3:
-		return __packet_lookup_frame_in_block(po, skb, len);
+		return __packet_lookup_frame_in_block(po, skb, len,
+						      retire_cur_block);
 	default:
 		WARN(1, "TPACKET version not supported\n");
 		BUG();
@@ -2174,6 +2178,9 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 	__u32 ts_status;
 	bool is_drop_n_account = false;
 	bool do_vnet = false;
+	struct virtio_net_hdr vnet_hdr;
+	int vnet_hdr_ok = 0;
+	bool retire_cur_block = false;
 
 	/* struct tpacket{2,3}_hdr is aligned to a multiple of TPACKET_ALIGNMENT.
 	 * We may add members to them until current aligned size without forcing
@@ -2269,17 +2276,32 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 			do_vnet = false;
 		}
 	}
+
+	if (do_vnet) {
+		vnet_hdr_ok = virtio_net_hdr_from_skb(skb, &vnet_hdr,
+						      vio_le(), true, 0);
+		/* Improve performance by retiring current block for
+		 * TPACKET_V3 in case of TSO.
+		 */
+		if (vnet_hdr_ok == 0) {
+			retire_cur_block = true;
+		}
+	}
+
 	spin_lock(&sk->sk_receive_queue.lock);
 	h.raw = packet_current_rx_frame(po, skb,
-					TP_STATUS_KERNEL, (macoff+snaplen));
+					TP_STATUS_KERNEL, (macoff+snaplen),
+					retire_cur_block);
 	if (!h.raw)
 		goto drop_n_account;
 
-	if (do_vnet &&
-	    virtio_net_hdr_from_skb(skb, h.raw + macoff -
-				    sizeof(struct virtio_net_hdr),
-				    vio_le(), true, 0))
-		goto drop_n_account;
+	if (do_vnet) {
+		if (vnet_hdr_ok != 0)
+			goto drop_n_account;
+		else
+			memcpy(h.raw + macoff - sizeof(struct virtio_net_hdr),
+			       &vnet_hdr, sizeof(vnet_hdr));
+	}
 
 	if (po->tp_version <= TPACKET_V2) {
 		packet_increment_rx_head(po, &po->rx_ring);
-- 
1.8.3.1


