Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14E556BE209
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 08:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbjCQHnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 03:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbjCQHnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 03:43:12 -0400
Received: from out0-199.mail.aliyun.com (out0-199.mail.aliyun.com [140.205.0.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151F83E0B0
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 00:43:08 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R361e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047190;MF=amy.saq@antgroup.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---.RrQfeZR_1679038985;
Received: from localhost(mailfrom:amy.saq@antgroup.com fp:SMTPD_---.RrQfeZR_1679038985)
          by smtp.aliyun-inc.com;
          Fri, 17 Mar 2023 15:43:06 +0800
From:   "=?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?=" <amy.saq@antgroup.com>
To:     netdev@vger.kernel.org
Cc:     <willemdebruijn.kernel@gmail.com>, <mst@redhat.com>,
        <davem@davemloft.net>, <jasowang@redhat.com>,
        "=?UTF-8?B?6LCI6Ym06ZSL?=" <henry.tjf@antgroup.com>,
        "=?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?=" <amy.saq@antgroup.com>
Subject: [PATCH v5] net/packet: support mergeable feature of virtio
Date:   Fri, 17 Mar 2023 15:43:04 +0800
Message-Id: <20230317074304.275598-1-amy.saq@antgroup.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

With this virtio feature enabled by virtio-user, packet sockets with
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

Signed-off-by: Jianfeng Tan <henry.tjf@antgroup.com>
Co-developed-by: Anqi Shen <amy.saq@antgroup.com>
Signed-off-by: Anqi Shen <amy.saq@antgroup.com>
---

V4 -> V5:
* add READ_ONCE() macro when initializing local vnet_hdr_sz variable;
* fix some nits. 

 include/uapi/linux/if_packet.h |  1 +
 net/packet/af_packet.c         | 85 +++++++++++++++++++++-------------
 net/packet/diag.c              |  2 +-
 net/packet/internal.h          |  2 +-
 4 files changed, 57 insertions(+), 33 deletions(-)

diff --git a/include/uapi/linux/if_packet.h b/include/uapi/linux/if_packet.h
index 78c981d6a9d4..9efc42382fdb 100644
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
index 8ffb19c643ab..e79d2ff4765a 100644
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
@@ -2253,6 +2253,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 	bool is_drop_n_account = false;
 	unsigned int slot_id = 0;
 	bool do_vnet = false;
+	int vnet_hdr_sz;
 
 	/* struct tpacket{2,3}_hdr is aligned to a multiple of TPACKET_ALIGNMENT.
 	 * We may add members to them until current aligned size without forcing
@@ -2310,8 +2311,9 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 		netoff = TPACKET_ALIGN(po->tp_hdrlen +
 				       (maclen < 16 ? 16 : maclen)) +
 				       po->tp_reserve;
-		if (po->has_vnet_hdr) {
-			netoff += sizeof(struct virtio_net_hdr);
+		vnet_hdr_sz = READ_ONCE(po->vnet_hdr_sz);
+		if (vnet_hdr_sz) {
+			netoff += vnet_hdr_sz;
 			do_vnet = true;
 		}
 		macoff = netoff - maclen;
@@ -2552,16 +2554,26 @@ static int __packet_snd_vnet_parse(struct virtio_net_hdr *vnet_hdr, size_t len)
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
@@ -2723,6 +2735,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 	void *ph;
 	DECLARE_SOCKADDR(struct sockaddr_ll *, saddr, msg->msg_name);
 	bool need_wait = !(msg->msg_flags & MSG_DONTWAIT);
+	int vnet_hdr_sz = READ_ONCE(po->vnet_hdr_sz);
 	unsigned char *addr = NULL;
 	int tp_len, size_max;
 	void *data;
@@ -2780,7 +2793,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 	size_max = po->tx_ring.frame_size
 		- (po->tp_hdrlen - sizeof(struct sockaddr_ll));
 
-	if ((size_max > dev->mtu + reserve + VLAN_HLEN) && !po->has_vnet_hdr)
+	if ((size_max > dev->mtu + reserve + VLAN_HLEN) && !vnet_hdr_sz)
 		size_max = dev->mtu + reserve + VLAN_HLEN;
 
 	reinit_completion(&po->skb_completion);
@@ -2809,10 +2822,10 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 		status = TP_STATUS_SEND_REQUEST;
 		hlen = LL_RESERVED_SPACE(dev);
 		tlen = dev->needed_tailroom;
-		if (po->has_vnet_hdr) {
+		if (vnet_hdr_sz) {
 			vnet_hdr = data;
-			data += sizeof(*vnet_hdr);
-			tp_len -= sizeof(*vnet_hdr);
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
+		    !vnet_hdr_sz &&
 		    !packet_extra_vlan_len_allowed(dev, skb))
 			tp_len = -EMSGSIZE;
 
@@ -2856,7 +2869,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 			}
 		}
 
-		if (po->has_vnet_hdr) {
+		if (vnet_hdr_sz) {
 			if (virtio_net_hdr_to_skb(skb, vnet_hdr, vio_le())) {
 				tp_len = -EINVAL;
 				goto tpacket_error;
@@ -2946,7 +2959,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 	struct virtio_net_hdr vnet_hdr = { 0 };
 	int offset = 0;
 	struct packet_sock *po = pkt_sk(sk);
-	bool has_vnet_hdr = false;
+	int vnet_hdr_sz = READ_ONCE(po->vnet_hdr_sz);
 	int hlen, tlen, linear;
 	int extra_len = 0;
 
@@ -2990,11 +3003,10 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 
 	if (sock->type == SOCK_RAW)
 		reserve = dev->hard_header_len;
-	if (po->has_vnet_hdr) {
-		err = packet_snd_vnet_parse(msg, &len, &vnet_hdr);
+	if (vnet_hdr_sz) {
+		err = packet_snd_vnet_parse(msg, &len, &vnet_hdr, vnet_hdr_sz);
 		if (err)
 			goto out_unlock;
-		has_vnet_hdr = true;
 	}
 
 	if (unlikely(sock_flag(sk, SOCK_NOFCS))) {
@@ -3064,11 +3076,11 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 
 	packet_parse_headers(skb, sock);
 
-	if (has_vnet_hdr) {
+	if (vnet_hdr_sz) {
 		err = virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le());
 		if (err)
 			goto out_free;
-		len += sizeof(vnet_hdr);
+		len += vnet_hdr_sz;
 		virtio_net_hdr_set_proto(skb, &vnet_hdr);
 	}
 
@@ -3410,7 +3422,7 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	struct sock *sk = sock->sk;
 	struct sk_buff *skb;
 	int copied, err;
-	int vnet_hdr_len = 0;
+	int vnet_hdr_len = READ_ONCE(pkt_sk(sk)->vnet_hdr_sz);
 	unsigned int origlen = 0;
 
 	err = -EINVAL;
@@ -3451,11 +3463,10 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 
 	packet_rcv_try_clear_pressure(pkt_sk(sk));
 
-	if (pkt_sk(sk)->has_vnet_hdr) {
-		err = packet_rcv_vnet(msg, skb, &len);
+	if (vnet_hdr_len) {
+		err = packet_rcv_vnet(msg, skb, &len, vnet_hdr_len);
 		if (err)
 			goto out_free;
-		vnet_hdr_len = sizeof(struct virtio_net_hdr);
 	}
 
 	/* You lose any data beyond the buffer you gave. If it worries
@@ -3921,8 +3932,9 @@ packet_setsockopt(struct socket *sock, int level, int optname, sockptr_t optval,
 		return 0;
 	}
 	case PACKET_VNET_HDR:
+	case PACKET_VNET_HDR_SZ:
 	{
-		int val;
+		int val, hdr_len;
 
 		if (sock->type != SOCK_RAW)
 			return -EINVAL;
@@ -3931,11 +3943,19 @@ packet_setsockopt(struct socket *sock, int level, int optname, sockptr_t optval,
 		if (copy_from_sockptr(&val, optval, sizeof(val)))
 			return -EFAULT;
 
+		hdr_len = val ? sizeof(struct virtio_net_hdr) : 0;
+		if (optname == PACKET_VNET_HDR_SZ) {
+			if (val && val != sizeof(struct virtio_net_hdr) &&
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
+			po->vnet_hdr_sz = hdr_len;
 			ret = 0;
 		}
 		release_sock(sk);
@@ -4068,7 +4088,10 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
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
index 07812ae5ca07..dfec603a86e6 100644
--- a/net/packet/diag.c
+++ b/net/packet/diag.c
@@ -27,7 +27,7 @@ static int pdiag_put_info(const struct packet_sock *po, struct sk_buff *nlskb)
 		pinfo.pdi_flags |= PDI_AUXDATA;
 	if (po->origdev)
 		pinfo.pdi_flags |= PDI_ORIGDEV;
-	if (po->has_vnet_hdr)
+	if (po->vnet_hdr_sz)
 		pinfo.pdi_flags |= PDI_VNETHDR;
 	if (po->tp_loss)
 		pinfo.pdi_flags |= PDI_LOSS;
diff --git a/net/packet/internal.h b/net/packet/internal.h
index 48af35b1aed2..154c6bb70507 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -119,9 +119,9 @@ struct packet_sock {
 	unsigned int		running;	/* bind_lock must be held */
 	unsigned int		auxdata:1,	/* writer must hold sock lock */
 				origdev:1,
-				has_vnet_hdr:1,
 				tp_loss:1,
 				tp_tx_has_off:1;
+	u8			vnet_hdr_sz;
 	int			pressure;
 	int			ifindex;	/* bound device		*/
 	__be16			num;
-- 
2.19.1.6.gb485710b

