Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF8F6AD713
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 07:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbjCGGCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 01:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbjCGGCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 01:02:00 -0500
Received: from out0-219.mail.aliyun.com (out0-219.mail.aliyun.com [140.205.0.219])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3DE75854
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 22:01:54 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047194;MF=amy.saq@antgroup.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---.RfuWwi1_1678168912;
Received: from localhost(mailfrom:amy.saq@antgroup.com fp:SMTPD_---.RfuWwi1_1678168912)
          by smtp.aliyun-inc.com;
          Tue, 07 Mar 2023 14:01:52 +0800
From:   "=?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?=" <amy.saq@antgroup.com>
To:     netdev@vger.kernel.org
Cc:     <willemdebruijn.kernel@gmail.com>, <mst@redhat.com>,
        <davem@davemloft.net>, <jasowang@redhat.com>,
        "=?UTF-8?B?6LCI6Ym06ZSL?=" <henry.tjf@antgroup.com>,
        "=?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?=" <amy.saq@antgroup.com>
Subject: [PATCH v3] net/packet: support mergeable feature of virtio
Date:   Tue, 07 Mar 2023 14:01:51 +0800
Message-Id: <1678168911-337042-1-git-send-email-amy.saq@antgroup.com>
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

Mergeable buffers, as a virtio feature, is worthy of supporting: packets
that are larger than one-mbuf size will be dropped in vhost worker's
handle_rx if mrg_rxbuf feature is not used, but large packets
cannot be avoided and increasing mbuf's size is not economical.

With this mergeable feature enabled by virtio-user, packet sockets with
hardcoded 10-byte virtio net header will parse mac head incorrectly in
packet_snd by taking the last two bytes of virtio net header as part of
mac header.
This incorrect mac header parsing will cause packet to be dropped due to
invalid ether head checking in later under-layer device packet receiving.

By adding extra field vnet_hdr_sz with utilizing holes in struct
packet_sock to record currently used virtio net header size and supporting
extra sockopt PACKET_VNET_HDR_SZ to set specified vnet_hdr_sz, packet
sockets can know the exact length of virtio net header that virtio user
gives.
In packet_snd, tpacket_snd and packet_recvmsg, instead of using
hardcoded virtio net header size, it can get the exact vnet_hdr_sz from
corresponding packet_sock, and parse mac header correctly based on this
information to avoid the packets being mistakenly dropped.

Besides, has_vnet_hdr field in struct packet_sock is removed since all 
the information it provides is covered by vnet_hdr_sz field: a packet
socket has a vnet header if and only if its vnet_hdr_sz is not zero.

Signed-off-by: Jianfeng Tan <henry.tjf@antgroup.com>
Co-developed-by: Anqi Shen <amy.saq@antgroup.com>
Signed-off-by: Anqi Shen <amy.saq@antgroup.com>
---

V2 -> V3:
* remove has_vnet_hdr field and use vnet_hdr_sz to indicate whether
there is a vnet header;
* refactor PACKET_VNET_HDR and PACKET_VNET_HDR_SZ sockopt to remove
redundant code.

 include/uapi/linux/if_packet.h |  1 +
 net/packet/af_packet.c         | 82 ++++++++++++++++++++++++++++--------------
 net/packet/diag.c              |  2 +-
 net/packet/internal.h          |  4 +--
 4 files changed, 60 insertions(+), 29 deletions(-)

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
index 8ffb19c..ce2feff 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2092,18 +2092,18 @@ static unsigned int run_filter(struct sk_buff *skb,
 }
 
 static int packet_rcv_vnet(struct msghdr *msg, const struct sk_buff *skb,
-			   size_t *len)
+			   size_t *len, int vnet_hdr_sz)
 {
-	struct virtio_net_hdr vnet_hdr;
+	struct virtio_net_hdr_mrg_rxbuf vnet_hdr = { .num_buffers = 0 };
 
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
@@ -2310,8 +2310,8 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 		netoff = TPACKET_ALIGN(po->tp_hdrlen +
 				       (maclen < 16 ? 16 : maclen)) +
 				       po->tp_reserve;
-		if (po->has_vnet_hdr) {
-			netoff += sizeof(struct virtio_net_hdr);
+		if (po->vnet_hdr_sz != 0) {
+			netoff += po->vnet_hdr_sz;
 			do_vnet = true;
 		}
 		macoff = netoff - maclen;
@@ -2552,16 +2552,27 @@ static int __packet_snd_vnet_parse(struct virtio_net_hdr *vnet_hdr, size_t len)
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
+	if (ret)
+		return ret;
+
+	/* move iter to point to the start of mac header */
+	if (vnet_hdr_sz != sizeof(struct virtio_net_hdr))
+		iov_iter_advance(&msg->msg_iter, vnet_hdr_sz - sizeof(struct virtio_net_hdr));
+
+	return 0;
 }
 
 static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
@@ -2730,6 +2741,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 	int status = TP_STATUS_AVAILABLE;
 	int hlen, tlen, copylen = 0;
 	long timeo = 0;
+	int vnet_hdr_sz;
 
 	mutex_lock(&po->pg_vec_lock);
 
@@ -2780,7 +2792,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 	size_max = po->tx_ring.frame_size
 		- (po->tp_hdrlen - sizeof(struct sockaddr_ll));
 
-	if ((size_max > dev->mtu + reserve + VLAN_HLEN) && !po->has_vnet_hdr)
+	if ((size_max > dev->mtu + reserve + VLAN_HLEN) && po->vnet_hdr_sz == 0)
 		size_max = dev->mtu + reserve + VLAN_HLEN;
 
 	reinit_completion(&po->skb_completion);
@@ -2809,10 +2821,11 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 		status = TP_STATUS_SEND_REQUEST;
 		hlen = LL_RESERVED_SPACE(dev);
 		tlen = dev->needed_tailroom;
-		if (po->has_vnet_hdr) {
+		if (po->vnet_hdr_sz != 0) {
 			vnet_hdr = data;
-			data += sizeof(*vnet_hdr);
-			tp_len -= sizeof(*vnet_hdr);
+			vnet_hdr_sz = po->vnet_hdr_sz;
+			data += vnet_hdr_sz;
+			tp_len -= vnet_hdr_sz;
 			if (tp_len < 0 ||
 			    __packet_snd_vnet_parse(vnet_hdr, tp_len)) {
 				tp_len = -EINVAL;
@@ -2837,7 +2850,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 					  addr, hlen, copylen, &sockc);
 		if (likely(tp_len >= 0) &&
 		    tp_len > dev->mtu + reserve &&
-		    !po->has_vnet_hdr &&
+		    (po->vnet_hdr_sz == 0) &&
 		    !packet_extra_vlan_len_allowed(dev, skb))
 			tp_len = -EMSGSIZE;
 
@@ -2856,7 +2869,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 			}
 		}
 
-		if (po->has_vnet_hdr) {
+		if (po->vnet_hdr_sz != 0) {
 			if (virtio_net_hdr_to_skb(skb, vnet_hdr, vio_le())) {
 				tp_len = -EINVAL;
 				goto tpacket_error;
@@ -2947,6 +2960,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 	int offset = 0;
 	struct packet_sock *po = pkt_sk(sk);
 	bool has_vnet_hdr = false;
+	int vnet_hdr_sz;
 	int hlen, tlen, linear;
 	int extra_len = 0;
 
@@ -2990,8 +3004,9 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 
 	if (sock->type == SOCK_RAW)
 		reserve = dev->hard_header_len;
-	if (po->has_vnet_hdr) {
-		err = packet_snd_vnet_parse(msg, &len, &vnet_hdr);
+	if (po->vnet_hdr_sz != 0) {
+		vnet_hdr_sz = po->vnet_hdr_sz;
+		err = packet_snd_vnet_parse(msg, &len, &vnet_hdr, vnet_hdr_sz);
 		if (err)
 			goto out_unlock;
 		has_vnet_hdr = true;
@@ -3068,7 +3083,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 		err = virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le());
 		if (err)
 			goto out_free;
-		len += sizeof(vnet_hdr);
+		len += vnet_hdr_sz;
 		virtio_net_hdr_set_proto(skb, &vnet_hdr);
 	}
 
@@ -3451,11 +3466,11 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 
 	packet_rcv_try_clear_pressure(pkt_sk(sk));
 
-	if (pkt_sk(sk)->has_vnet_hdr) {
-		err = packet_rcv_vnet(msg, skb, &len);
+	if (pkt_sk(sk)->vnet_hdr_sz != 0) {
+		vnet_hdr_len = pkt_sk(sk)->vnet_hdr_sz;
+		err = packet_rcv_vnet(msg, skb, &len, vnet_hdr_len);
 		if (err)
 			goto out_free;
-		vnet_hdr_len = sizeof(struct virtio_net_hdr);
 	}
 
 	/* You lose any data beyond the buffer you gave. If it worries
@@ -3921,8 +3936,10 @@ static void packet_flush_mclist(struct sock *sk)
 		return 0;
 	}
 	case PACKET_VNET_HDR:
+	case PACKET_VNET_HDR_SZ:
 	{
 		int val;
+		int hdr_len = 0;
 
 		if (sock->type != SOCK_RAW)
 			return -EINVAL;
@@ -3931,11 +3948,21 @@ static void packet_flush_mclist(struct sock *sk)
 		if (copy_from_sockptr(&val, optval, sizeof(val)))
 			return -EFAULT;
 
+		if (optname == PACKET_VNET_HDR_SZ) {
+			if (val != sizeof(struct virtio_net_hdr) &&
+			    val != sizeof(struct virtio_net_hdr_mrg_rxbuf))
+				return -EINVAL;
+			hdr_len = val;
+		} else {
+			if (!!val)
+				hdr_len = sizeof(struct virtio_net_hdr);
+		}
+
 		lock_sock(sk);
 		if (po->rx_ring.pg_vec || po->tx_ring.pg_vec) {
 			ret = -EBUSY;
 		} else {
-			po->has_vnet_hdr = !!val;
+			po->vnet_hdr_sz = hdr_len;
 			ret = 0;
 		}
 		release_sock(sk);
@@ -4068,7 +4095,10 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
 		val = po->origdev;
 		break;
 	case PACKET_VNET_HDR:
-		val = po->has_vnet_hdr;
+		val = !!po->vnet_hdr_sz;
+		break;
+	case PACKET_VNET_HDR_SZ:
+		val = po->vnet_hdr_sz;
 		break;
 	case PACKET_VERSION:
 		val = po->tp_version;
diff --git a/net/packet/diag.c b/net/packet/diag.c
index 07812ae..4e544da 100644
--- a/net/packet/diag.c
+++ b/net/packet/diag.c
@@ -27,7 +27,7 @@ static int pdiag_put_info(const struct packet_sock *po, struct sk_buff *nlskb)
 		pinfo.pdi_flags |= PDI_AUXDATA;
 	if (po->origdev)
 		pinfo.pdi_flags |= PDI_ORIGDEV;
-	if (po->has_vnet_hdr)
+	if (po->vnet_hdr_sz != 0)
 		pinfo.pdi_flags |= PDI_VNETHDR;
 	if (po->tp_loss)
 		pinfo.pdi_flags |= PDI_LOSS;
diff --git a/net/packet/internal.h b/net/packet/internal.h
index 48af35b..9b52d93 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -119,9 +119,9 @@ struct packet_sock {
 	unsigned int		running;	/* bind_lock must be held */
 	unsigned int		auxdata:1,	/* writer must hold sock lock */
 				origdev:1,
-				has_vnet_hdr:1,
 				tp_loss:1,
-				tp_tx_has_off:1;
+				tp_tx_has_off:1,
+				vnet_hdr_sz:8;
 	int			pressure;
 	int			ifindex;	/* bound device		*/
 	__be16			num;
-- 
1.8.3.1

