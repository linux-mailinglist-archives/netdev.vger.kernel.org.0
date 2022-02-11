Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3064B3162
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 00:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354243AbiBKXiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 18:38:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354212AbiBKXiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 18:38:54 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28208D5A;
        Fri, 11 Feb 2022 15:38:51 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1644622729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=31MUCHZBUqKnOoPCFE4xKxjwK4MB46HtfvObgBajBJ0=;
        b=fOW7/azEk4F6fnpJckS0zQXrQmiJGiXRlLDXLC2EXSVMJq712Zrrr5tkMh9ijglkMET/fR
        lG1ZcxJvsEiL7I+3EyTpETnqWsRYHG67fOMjuJykz9bfnQQ0W6cdQz8F1Hxhrb/Om6P6Dr
        HokNS1VoSGTO7GUNUliPuGF/VrSlD7md9P26fQlO3TiW8ovMF0XQcsdIDgmfF1HblXVvR2
        0zk0puOlAhZ4J6L2TnJUjumIJHNWTKUJes3S+8OsTNoNF1aQT6mDiXhTDF/nNy4Q6GL+B5
        n5vgySG8wcHZsm+8OzQjrlz9zfXmoDTp8AkdfP8Tgl4xS2x9nqKxEEp17YskrA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1644622729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=31MUCHZBUqKnOoPCFE4xKxjwK4MB46HtfvObgBajBJ0=;
        b=wM67+okYMR+HRS8c++4E6FJh60SbQrdt0tk+2OGloJudcyA4PTrAH+VqHb5prRjelm0RfV
        d77qkd9+ax87JWDw==
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH net-next v3 2/3] net: dev: Makes sure netif_rx() can be invoked in any context.
Date:   Sat, 12 Feb 2022 00:38:38 +0100
Message-Id: <20220211233839.2280731-3-bigeasy@linutronix.de>
In-Reply-To: <20220211233839.2280731-1-bigeasy@linutronix.de>
References: <20220211233839.2280731-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dave suggested a while ago (eleven years by now) "Let's make netif_rx()
work in all contexts and get rid of netif_rx_ni()". Eric agreed and
pointed out that modern devices should use netif_receive_skb() to avoid
the overhead.
In the meantime someone added another variant, netif_rx_any_context(),
which behaves as suggested.

netif_rx() must be invoked with disabled bottom halves to ensure that
pending softirqs, which were raised within the function, are handled.
netif_rx_ni() can be invoked only from process context (bottom halves
must be enabled) because the function handles pending softirqs without
checking if bottom halves were disabled or not.
netif_rx_any_context() invokes on the former functions by checking
in_interrupts().

netif_rx() could be taught to handle both cases (disabled and enabled
bottom halves) by simply disabling bottom halves while invoking
netif_rx_internal(). The local_bh_enable() invocation will then invoke
pending softirqs only if the BH-disable counter drops to zero.

Eric is concerned about the overhead of BH-disable+enable especially in
regard to the loopback driver. As critical as this driver is, it will
receive a shortcut to avoid the additional overhead which is not needed.

Add a local_bh_disable() section in netif_rx() to ensure softirqs are
handled if needed.
Provide __netif_rx() which does not disable BH and has a lockdep assert
to ensure that interrupts are disabled. Use this shortcut in the
loopback driver and in drivers/net/*.c.
Make netif_rx_ni() and netif_rx_any_context() invoke netif_rx() so they
can be removed once they are no more users left.

Link: https://lkml.kernel.org/r/20100415.020246.218622820.davem@davemloft.n=
et
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
---
 drivers/net/amt.c          |  4 +--
 drivers/net/geneve.c       |  4 +--
 drivers/net/gtp.c          |  2 +-
 drivers/net/loopback.c     |  4 +--
 drivers/net/macsec.c       |  6 ++--
 drivers/net/macvlan.c      |  4 +--
 drivers/net/mhi_net.c      |  2 +-
 drivers/net/ntb_netdev.c   |  2 +-
 drivers/net/rionet.c       |  2 +-
 drivers/net/sb1000.c       |  2 +-
 drivers/net/veth.c         |  2 +-
 drivers/net/vrf.c          |  2 +-
 drivers/net/vxlan.c        |  2 +-
 include/linux/netdevice.h  | 14 ++++++--
 include/trace/events/net.h | 14 --------
 net/core/dev.c             | 67 +++++++++++++++++---------------------
 16 files changed, 60 insertions(+), 73 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index f1a36d7e2151c..10455c9b9da0e 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -2373,7 +2373,7 @@ static bool amt_membership_query_handler(struct amt_d=
ev *amt,
 	skb->pkt_type =3D PACKET_MULTICAST;
 	skb->ip_summed =3D CHECKSUM_NONE;
 	len =3D skb->len;
-	if (netif_rx(skb) =3D=3D NET_RX_SUCCESS) {
+	if (__netif_rx(skb) =3D=3D NET_RX_SUCCESS) {
 		amt_update_gw_status(amt, AMT_STATUS_RECEIVED_QUERY, true);
 		dev_sw_netstats_rx_add(amt->dev, len);
 	} else {
@@ -2470,7 +2470,7 @@ static bool amt_update_handler(struct amt_dev *amt, s=
truct sk_buff *skb)
 	skb->pkt_type =3D PACKET_MULTICAST;
 	skb->ip_summed =3D CHECKSUM_NONE;
 	len =3D skb->len;
-	if (netif_rx(skb) =3D=3D NET_RX_SUCCESS) {
+	if (__netif_rx(skb) =3D=3D NET_RX_SUCCESS) {
 		amt_update_relay_status(tunnel, AMT_STATUS_RECEIVED_UPDATE,
 					true);
 		dev_sw_netstats_rx_add(amt->dev, len);
diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index c1fdd721a730d..a895ff756093a 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -925,7 +925,7 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct =
net_device *dev,
 		}
=20
 		skb->protocol =3D eth_type_trans(skb, geneve->dev);
-		netif_rx(skb);
+		__netif_rx(skb);
 		dst_release(&rt->dst);
 		return -EMSGSIZE;
 	}
@@ -1021,7 +1021,7 @@ static int geneve6_xmit_skb(struct sk_buff *skb, stru=
ct net_device *dev,
 		}
=20
 		skb->protocol =3D eth_type_trans(skb, geneve->dev);
-		netif_rx(skb);
+		__netif_rx(skb);
 		dst_release(dst);
 		return -EMSGSIZE;
 	}
diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 24e5c54d06c15..bf087171bcf04 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -207,7 +207,7 @@ static int gtp_rx(struct pdp_ctx *pctx, struct sk_buff =
*skb,
=20
 	dev_sw_netstats_rx_add(pctx->dev, skb->len);
=20
-	netif_rx(skb);
+	__netif_rx(skb);
 	return 0;
=20
 err:
diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index ed0edf5884ef8..d05f86fe78c95 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -78,7 +78,7 @@ static netdev_tx_t loopback_xmit(struct sk_buff *skb,
=20
 	skb_orphan(skb);
=20
-	/* Before queueing this packet to netif_rx(),
+	/* Before queueing this packet to __netif_rx(),
 	 * make sure dst is refcounted.
 	 */
 	skb_dst_force(skb);
@@ -86,7 +86,7 @@ static netdev_tx_t loopback_xmit(struct sk_buff *skb,
 	skb->protocol =3D eth_type_trans(skb, dev);
=20
 	len =3D skb->len;
-	if (likely(netif_rx(skb) =3D=3D NET_RX_SUCCESS))
+	if (likely(__netif_rx(skb) =3D=3D NET_RX_SUCCESS))
 		dev_lstats_add(dev, len);
=20
 	return NETDEV_TX_OK;
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 3d08743317634..832f09ac075e7 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1033,7 +1033,7 @@ static enum rx_handler_result handle_not_macsec(struc=
t sk_buff *skb)
 				else
 					nskb->pkt_type =3D PACKET_MULTICAST;
=20
-				netif_rx(nskb);
+				__netif_rx(nskb);
 			}
 			continue;
 		}
@@ -1056,7 +1056,7 @@ static enum rx_handler_result handle_not_macsec(struc=
t sk_buff *skb)
=20
 		nskb->dev =3D ndev;
=20
-		if (netif_rx(nskb) =3D=3D NET_RX_SUCCESS) {
+		if (__netif_rx(nskb) =3D=3D NET_RX_SUCCESS) {
 			u64_stats_update_begin(&secy_stats->syncp);
 			secy_stats->stats.InPktsUntagged++;
 			u64_stats_update_end(&secy_stats->syncp);
@@ -1288,7 +1288,7 @@ static rx_handler_result_t macsec_handle_frame(struct=
 sk_buff **pskb)
=20
 		macsec_reset_skb(nskb, macsec->secy.netdev);
=20
-		ret =3D netif_rx(nskb);
+		ret =3D __netif_rx(nskb);
 		if (ret =3D=3D NET_RX_SUCCESS) {
 			u64_stats_update_begin(&secy_stats->syncp);
 			secy_stats->stats.InPktsUnknownSCI++;
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 6ef5f77be4d0a..d87c06c317ede 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -410,7 +410,7 @@ static void macvlan_forward_source_one(struct sk_buff *=
skb,
 	if (ether_addr_equal_64bits(eth_hdr(skb)->h_dest, dev->dev_addr))
 		nskb->pkt_type =3D PACKET_HOST;
=20
-	ret =3D netif_rx(nskb);
+	ret =3D __netif_rx(nskb);
 	macvlan_count_rx(vlan, len, ret =3D=3D NET_RX_SUCCESS, false);
 }
=20
@@ -468,7 +468,7 @@ static rx_handler_result_t macvlan_handle_frame(struct =
sk_buff **pskb)
 			/* forward to original port. */
 			vlan =3D src;
 			ret =3D macvlan_broadcast_one(skb, vlan, eth, 0) ?:
-			      netif_rx(skb);
+			      __netif_rx(skb);
 			handle_res =3D RX_HANDLER_CONSUMED;
 			goto out;
 		}
diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
index aaa628f859fd4..0b1b6f650104b 100644
--- a/drivers/net/mhi_net.c
+++ b/drivers/net/mhi_net.c
@@ -225,7 +225,7 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_=
dev,
 		u64_stats_inc(&mhi_netdev->stats.rx_packets);
 		u64_stats_add(&mhi_netdev->stats.rx_bytes, skb->len);
 		u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
-		netif_rx(skb);
+		__netif_rx(skb);
 	}
=20
 	/* Refill if RX buffers queue becomes low */
diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
index 98ca6b18415e7..80bdc07f2cd33 100644
--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -119,7 +119,7 @@ static void ntb_netdev_rx_handler(struct ntb_transport_=
qp *qp, void *qp_data,
 	skb->protocol =3D eth_type_trans(skb, ndev);
 	skb->ip_summed =3D CHECKSUM_NONE;
=20
-	if (netif_rx(skb) =3D=3D NET_RX_DROP) {
+	if (__netif_rx(skb) =3D=3D NET_RX_DROP) {
 		ndev->stats.rx_errors++;
 		ndev->stats.rx_dropped++;
 	} else {
diff --git a/drivers/net/rionet.c b/drivers/net/rionet.c
index 1a95f3beb784d..39e61e07e4894 100644
--- a/drivers/net/rionet.c
+++ b/drivers/net/rionet.c
@@ -109,7 +109,7 @@ static int rionet_rx_clean(struct net_device *ndev)
 		skb_put(rnet->rx_skb[i], RIO_MAX_MSG_SIZE);
 		rnet->rx_skb[i]->protocol =3D
 		    eth_type_trans(rnet->rx_skb[i], ndev);
-		error =3D netif_rx(rnet->rx_skb[i]);
+		error =3D __netif_rx(rnet->rx_skb[i]);
=20
 		if (error =3D=3D NET_RX_DROP) {
 			ndev->stats.rx_dropped++;
diff --git a/drivers/net/sb1000.c b/drivers/net/sb1000.c
index 57a6d598467b2..c3f8020571add 100644
--- a/drivers/net/sb1000.c
+++ b/drivers/net/sb1000.c
@@ -872,7 +872,7 @@ printk("cm0: IP identification: %02x%02x  fragment offs=
et: %02x%02x\n", buffer[3
=20
 	/* datagram completed: send to upper level */
 	skb_trim(skb, dlen);
-	netif_rx(skb);
+	__netif_rx(skb);
 	stats->rx_bytes+=3Ddlen;
 	stats->rx_packets++;
 	lp->rx_skb[ns] =3D NULL;
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 354a963075c5f..6754fb8d9fabc 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -286,7 +286,7 @@ static int veth_forward_skb(struct net_device *dev, str=
uct sk_buff *skb,
 {
 	return __dev_forward_skb(dev, skb) ?: xdp ?
 		veth_xdp_rx(rq, skb) :
-		netif_rx(skb);
+		__netif_rx(skb);
 }
=20
 /* return true if the specified skb has chances of GRO aggregation
diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index e0b1ab99a359e..714cafcf6c6c8 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -418,7 +418,7 @@ static int vrf_local_xmit(struct sk_buff *skb, struct n=
et_device *dev,
=20
 	skb->protocol =3D eth_type_trans(skb, dev);
=20
-	if (likely(netif_rx(skb) =3D=3D NET_RX_SUCCESS))
+	if (likely(__netif_rx(skb) =3D=3D NET_RX_SUCCESS))
 		vrf_rx_stats(dev, len);
 	else
 		this_cpu_inc(dev->dstats->rx_drps);
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 359d16780dbbc..d0dc90d3dac28 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2541,7 +2541,7 @@ static void vxlan_encap_bypass(struct sk_buff *skb, s=
truct vxlan_dev *src_vxlan,
 	tx_stats->tx_bytes +=3D len;
 	u64_stats_update_end(&tx_stats->syncp);
=20
-	if (netif_rx(skb) =3D=3D NET_RX_SUCCESS) {
+	if (__netif_rx(skb) =3D=3D NET_RX_SUCCESS) {
 		u64_stats_update_begin(&rx_stats->syncp);
 		rx_stats->rx_packets++;
 		rx_stats->rx_bytes +=3D len;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index e490b84732d16..c9e883104adb1 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3669,8 +3669,18 @@ u32 bpf_prog_run_generic_xdp(struct sk_buff *skb, st=
ruct xdp_buff *xdp,
 void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog);
 int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb);
 int netif_rx(struct sk_buff *skb);
-int netif_rx_ni(struct sk_buff *skb);
-int netif_rx_any_context(struct sk_buff *skb);
+int __netif_rx(struct sk_buff *skb);
+
+static inline int netif_rx_ni(struct sk_buff *skb)
+{
+	return netif_rx(skb);
+}
+
+static inline int netif_rx_any_context(struct sk_buff *skb)
+{
+	return netif_rx(skb);
+}
+
 int netif_receive_skb(struct sk_buff *skb);
 int netif_receive_skb_core(struct sk_buff *skb);
 void netif_receive_skb_list_internal(struct list_head *head);
diff --git a/include/trace/events/net.h b/include/trace/events/net.h
index 78c448c6ab4c5..032b431b987b6 100644
--- a/include/trace/events/net.h
+++ b/include/trace/events/net.h
@@ -260,13 +260,6 @@ DEFINE_EVENT(net_dev_rx_verbose_template, netif_rx_ent=
ry,
 	TP_ARGS(skb)
 );
=20
-DEFINE_EVENT(net_dev_rx_verbose_template, netif_rx_ni_entry,
-
-	TP_PROTO(const struct sk_buff *skb),
-
-	TP_ARGS(skb)
-);
-
 DECLARE_EVENT_CLASS(net_dev_rx_exit_template,
=20
 	TP_PROTO(int ret),
@@ -312,13 +305,6 @@ DEFINE_EVENT(net_dev_rx_exit_template, netif_rx_exit,
 	TP_ARGS(ret)
 );
=20
-DEFINE_EVENT(net_dev_rx_exit_template, netif_rx_ni_exit,
-
-	TP_PROTO(int ret),
-
-	TP_ARGS(ret)
-);
-
 DEFINE_EVENT(net_dev_rx_exit_template, netif_receive_skb_list_exit,
=20
 	TP_PROTO(int ret),
diff --git a/net/core/dev.c b/net/core/dev.c
index 0d13340ed4054..7d90f565e540a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4815,66 +4815,57 @@ static int netif_rx_internal(struct sk_buff *skb)
 	return ret;
 }
=20
+/**
+ *	__netif_rx	-	Slightly optimized version of netif_rx
+ *	@skb: buffer to post
+ *
+ *	This behaves as netif_rx except that it does not disable bottom halves.
+ *	As a result this function may only be invoked from the interrupt context
+ *	(either hard or soft interrupt).
+ */
+int __netif_rx(struct sk_buff *skb)
+{
+	int ret;
+
+	lockdep_assert_once(hardirq_count() | softirq_count());
+
+	trace_netif_rx_entry(skb);
+	ret =3D netif_rx_internal(skb);
+	trace_netif_rx_exit(ret);
+	return ret;
+}
+EXPORT_SYMBOL(__netif_rx);
+
 /**
  *	netif_rx	-	post buffer to the network code
  *	@skb: buffer to post
  *
  *	This function receives a packet from a device driver and queues it for
- *	the upper (protocol) levels to process.  It always succeeds. The buffer
- *	may be dropped during processing for congestion control or by the
- *	protocol layers.
+ *	the upper (protocol) levels to process via the backlog NAPI device. It
+ *	always succeeds. The buffer may be dropped during processing for
+ *	congestion control or by the protocol layers.
+ *	The network buffer is passed via the backlog NAPI device. Modern NIC
+ *	driver should use NAPI and GRO.
+ *	This function can used from any context.
  *
  *	return values:
  *	NET_RX_SUCCESS	(no congestion)
  *	NET_RX_DROP     (packet was dropped)
  *
  */
-
 int netif_rx(struct sk_buff *skb)
 {
 	int ret;
=20
+	local_bh_disable();
 	trace_netif_rx_entry(skb);
-
 	ret =3D netif_rx_internal(skb);
 	trace_netif_rx_exit(ret);
-
+	local_bh_enable();
 	return ret;
 }
 EXPORT_SYMBOL(netif_rx);
=20
-int netif_rx_ni(struct sk_buff *skb)
-{
-	int err;
-
-	trace_netif_rx_ni_entry(skb);
-
-	preempt_disable();
-	err =3D netif_rx_internal(skb);
-	if (local_softirq_pending())
-		do_softirq();
-	preempt_enable();
-	trace_netif_rx_ni_exit(err);
-
-	return err;
-}
-EXPORT_SYMBOL(netif_rx_ni);
-
-int netif_rx_any_context(struct sk_buff *skb)
-{
-	/*
-	 * If invoked from contexts which do not invoke bottom half
-	 * processing either at return from interrupt or when softrqs are
-	 * reenabled, use netif_rx_ni() which invokes bottomhalf processing
-	 * directly.
-	 */
-	if (in_interrupt())
-		return netif_rx(skb);
-	else
-		return netif_rx_ni(skb);
-}
-EXPORT_SYMBOL(netif_rx_any_context);
-
 static __latent_entropy void net_tx_action(struct softirq_action *h)
 {
 	struct softnet_data *sd =3D this_cpu_ptr(&softnet_data);
--=20
2.34.1

