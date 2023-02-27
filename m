Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92C496A40B2
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 12:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjB0Ldy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 06:33:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjB0Ldx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 06:33:53 -0500
Received: from out0-194.mail.aliyun.com (out0-194.mail.aliyun.com [140.205.0.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA53A1EFC2
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 03:33:49 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047209;MF=amy.saq@antgroup.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---.RY9apix_1677497626;
Received: from localhost(mailfrom:amy.saq@antgroup.com fp:SMTPD_---.RY9apix_1677497626)
          by smtp.aliyun-inc.com;
          Mon, 27 Feb 2023 19:33:47 +0800
From:   "=?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?=" <amy.saq@antgroup.com>
To:     netdev@vger.kernel.org
Cc:     <willemdebruijn.kernel@gmail.com>, <mst@redhat.com>,
        <davem@davemloft.net>, <jasowang@redhat.com>,
        "=?UTF-8?B?6LCI6Ym06ZSL?=" <henry.tjf@antgroup.com>,
        "=?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?=" <amy.saq@antgroup.com>
Subject: [PATCH v2] net/packet: support mergeable feautre of virtio
Date:   Mon, 27 Feb 2023 19:33:45 +0800
Message-Id: <1677497625-351024-1-git-send-email-amy.saq@antgroup.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianfeng Tan <henry.tjf@antgroup.com>

Packet sockets, like tap, can be used as the backend for kernel vhost.
In packet sockets, virtio net header size is currently hardcoded to be
the size of struct virtio_net_hdr, which is 10 bytes; however, it is not
always the case: some virtio features, such as mrg_rxbuf, need virtio
net header to be 12-byte long.

Mergeable buffers, as a virtio feature, is worthy to support: packets
that larger than one-mbuf size will be dropped in vhost worker's
handle_rx if mrg_rxbuf feature is not used, but large packets
cannot be avoided and increasing mbuf's size is not economical.

With this virtio feature enabled, packet sockets with hardcoded 10-byte
virtio net header will parse mac head incorrectly in packet_snd by taking
the last two bytes of virtio net header as part of mac header as well.
This incorrect mac header parsing will cause packet be dropped due to
invalid ether head checking in later under-layer device packet receiving.

By adding extra field vnet_hdr_sz with utilizing holes in struct
packet_sock to record current using virtio net header size and supporting
extra sockopt PACKET_VNET_HDR_SZ to set specified vnet_hdr_sz, packet
sockets can know the exact length of virtio net header that virtio user
gives.
In packet_snd, tpacket_snd and packet_recvmsg, instead of using hardcode
virtio net header size, it can get the exact vnet_hdr_sz from corresponding
packet_sock, and parse mac header correctly based on this information to
avoid the packets being mistakenly dropped.

Signed-off-by: Jianfeng Tan <henry.tjf@antgroup.com>
Co-developed-by: Anqi Shen <amy.saq@antgroup.com>
Signed-off-by: Anqi Shen <amy.saq@antgroup.com>
---

V1 -> V2:
* refactor the implementation of PACKET_VNET_HDR and PACKET_VNET_HDR_SZ
socketopts to get rid of redundate code;
* amend packet_rcv_vnet in af_packet.c to avoid extra function invocation 

 include/uapi/linux/if_packet.h |  1 +
 net/packet/af_packet.c         | 65 ++++++++++++++++++++++++++++++------------
 net/packet/internal.h          |  3 +-
 3 files changed, 50 insertions(+), 19 deletions(-)

diff --git a/include/uapi/linux/if_packet.h b/include/uapi/linux/if_packet.h
index 78c981d..9efc423 100644
--- a/include/uapi/linux/if_packet.h
+++ b/include/uapi/linux/if_packet.h
@@ -59,6 +59,7 @@ struct sockaddr_ll {
 #define PACKET_ROLLOVER_STATS		21
 #define PACKET_FANOUT_DATA		22
 #define PACKET_IGNORE_OUTGOING		23
+#define PACKET_VNET_HDR_SZ		24
 
 #define PACKET_FANOUT_HASH		0
 #define PACKET_FANOUT_LB		1
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 8ffb19c..52be616 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2092,18 +2092,19 @@ static unsigned int run_filter(struct sk_buff *skb,
 }
 
 static int packet_rcv_vnet(struct msghdr *msg, const struct sk_buff *skb,
-			   size_t *len)
+			   size_t *len, int vnet_hdr_sz)
 {
-	struct virtio_net_hdr vnet_hdr;
+	struct virtio_net_hdr_mrg_rxbuf vnet_hdr = { .num_buffers = 0 };
+	int ret;
 
-	if (*len < sizeof(vnet_hdr))
+	if (*len < vnet_hdr_sz)
 		return -EINVAL;
-	*len -= sizeof(vnet_hdr);
+	*len -= vnet_hdr_sz;
 
-	if (virtio_net_hdr_from_skb(skb, &vnet_hdr, vio_le(), true, 0))
+	if (virtio_net_hdr_from_skb(skb, (struct virtio_net_hdr *)&vnet_hdr, vio_le(), true, 0))
 		return -EINVAL;
 
-	return memcpy_to_msg(msg, (void *)&vnet_hdr, sizeof(vnet_hdr));
+	return memcpy_to_msg(msg, (void *)&vnet_hdr, vnet_hdr_sz);
 }
 
 /*
@@ -2311,7 +2312,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 				       (maclen < 16 ? 16 : maclen)) +
 				       po->tp_reserve;
 		if (po->has_vnet_hdr) {
-			netoff += sizeof(struct virtio_net_hdr);
+			netoff += po->vnet_hdr_sz;
 			do_vnet = true;
 		}
 		macoff = netoff - maclen;
@@ -2552,16 +2553,23 @@ static int __packet_snd_vnet_parse(struct virtio_net_hdr *vnet_hdr, size_t len)
 }
 
 static int packet_snd_vnet_parse(struct msghdr *msg, size_t *len,
-				 struct virtio_net_hdr *vnet_hdr)
+				 struct virtio_net_hdr *vnet_hdr, int vnet_hdr_sz)
 {
-	if (*len < sizeof(*vnet_hdr))
+	int ret;
+
+	if (*len < vnet_hdr_sz)
 		return -EINVAL;
-	*len -= sizeof(*vnet_hdr);
+	*len -= vnet_hdr_sz;
 
 	if (!copy_from_iter_full(vnet_hdr, sizeof(*vnet_hdr), &msg->msg_iter))
 		return -EFAULT;
 
-	return __packet_snd_vnet_parse(vnet_hdr, *len);
+	ret = __packet_snd_vnet_parse(vnet_hdr, *len);
+
+	/* move iter to point to the start of mac header */
+	if (ret == 0)
+		iov_iter_advance(&msg->msg_iter, vnet_hdr_sz - sizeof(struct virtio_net_hdr));
+	return ret;
 }
 
 static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
@@ -2730,6 +2738,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 	int status = TP_STATUS_AVAILABLE;
 	int hlen, tlen, copylen = 0;
 	long timeo = 0;
+	int vnet_hdr_sz;
 
 	mutex_lock(&po->pg_vec_lock);
 
@@ -2811,8 +2820,9 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 		tlen = dev->needed_tailroom;
 		if (po->has_vnet_hdr) {
 			vnet_hdr = data;
-			data += sizeof(*vnet_hdr);
-			tp_len -= sizeof(*vnet_hdr);
+			vnet_hdr_sz = po->vnet_hdr_sz;
+			data += vnet_hdr_sz;
+			tp_len -= vnet_hdr_sz;
 			if (tp_len < 0 ||
 			    __packet_snd_vnet_parse(vnet_hdr, tp_len)) {
 				tp_len = -EINVAL;
@@ -2947,6 +2957,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 	int offset = 0;
 	struct packet_sock *po = pkt_sk(sk);
 	bool has_vnet_hdr = false;
+	int vnet_hdr_sz;
 	int hlen, tlen, linear;
 	int extra_len = 0;
 
@@ -2991,7 +3002,8 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 	if (sock->type == SOCK_RAW)
 		reserve = dev->hard_header_len;
 	if (po->has_vnet_hdr) {
-		err = packet_snd_vnet_parse(msg, &len, &vnet_hdr);
+		vnet_hdr_sz = po->vnet_hdr_sz;
+		err = packet_snd_vnet_parse(msg, &len, &vnet_hdr, vnet_hdr_sz);
 		if (err)
 			goto out_unlock;
 		has_vnet_hdr = true;
@@ -3068,7 +3080,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 		err = virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le());
 		if (err)
 			goto out_free;
-		len += sizeof(vnet_hdr);
+		len += vnet_hdr_sz;
 		virtio_net_hdr_set_proto(skb, &vnet_hdr);
 	}
 
@@ -3452,10 +3464,10 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	packet_rcv_try_clear_pressure(pkt_sk(sk));
 
 	if (pkt_sk(sk)->has_vnet_hdr) {
-		err = packet_rcv_vnet(msg, skb, &len);
+		vnet_hdr_len = pkt_sk(sk)->vnet_hdr_sz;
+		err = packet_rcv_vnet(msg, skb, &len, vnet_hdr_len);
 		if (err)
 			goto out_free;
-		vnet_hdr_len = sizeof(struct virtio_net_hdr);
 	}
 
 	/* You lose any data beyond the buffer you gave. If it worries
@@ -3921,8 +3933,10 @@ static void packet_flush_mclist(struct sock *sk)
 		return 0;
 	}
 	case PACKET_VNET_HDR:
+	case PACKET_VNET_HDR_SZ:
 	{
 		int val;
+		int hdr_len = 0;
 
 		if (sock->type != SOCK_RAW)
 			return -EINVAL;
@@ -3931,11 +3945,23 @@ static void packet_flush_mclist(struct sock *sk)
 		if (copy_from_sockptr(&val, optval, sizeof(val)))
 			return -EFAULT;
 
+		if (optname == PACKET_VNET_HDR_SZ) {
+			if (val != sizeof(struct virtio_net_hdr) &&
+			    val != sizeof(struct virtio_net_hdr_mrg_rxbuf))
+				return -EINVAL;
+			hdr_len = val;
+		}
+
 		lock_sock(sk);
 		if (po->rx_ring.pg_vec || po->tx_ring.pg_vec) {
 			ret = -EBUSY;
 		} else {
-			po->has_vnet_hdr = !!val;
+			if (optname == PACKET_VNET_HDR) {
+				po->has_vnet_hdr = !!val;
+				if (po->has_vnet_hdr)
+					hdr_len = sizeof(struct virtio_net_hdr);
+			}
+			po->vnet_hdr_sz = hdr_len;
 			ret = 0;
 		}
 		release_sock(sk);
@@ -4070,6 +4096,9 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
 	case PACKET_VNET_HDR:
 		val = po->has_vnet_hdr;
 		break;
+	case PACKET_VNET_HDR_SZ:
+		val = po->vnet_hdr_sz;
+		break;
 	case PACKET_VERSION:
 		val = po->tp_version;
 		break;
diff --git a/net/packet/internal.h b/net/packet/internal.h
index 48af35b..e27b47d 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -121,7 +121,8 @@ struct packet_sock {
 				origdev:1,
 				has_vnet_hdr:1,
 				tp_loss:1,
-				tp_tx_has_off:1;
+				tp_tx_has_off:1,
+				vnet_hdr_sz:8;	/* vnet header size should use */
 	int			pressure;
 	int			ifindex;	/* bound device		*/
 	__be16			num;
-- 
1.8.3.1

