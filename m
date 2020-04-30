Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70EC31BF8BD
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 15:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgD3NC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 09:02:28 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:20629 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726809AbgD3NCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 09:02:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588251743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6/tIXiI8rwsMYAQUCaoN+AvbC3Qap7IFj/xIJfTtxtM=;
        b=ZD8TCDhlJQ96wIyXSVxATmMMpCtN0V2PzGKxYGTFtU3Iqmf7+d2oI5Xu8tXyZm8aTKIfF5
        WISYfq0pF3Th8RAfKD5oRdPVVHocQuV88JrDy5golY80JMJ12HcjTSR/W9FAzyYGbNEBIf
        g57mjmUMFx/btRlYnWNiu91i9/llx5c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-c2auOnUWPBWX3N5xeNw3hg-1; Thu, 30 Apr 2020 09:02:16 -0400
X-MC-Unique: c2auOnUWPBWX3N5xeNw3hg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4594D80B70C;
        Thu, 30 Apr 2020 13:02:15 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-219.ams2.redhat.com [10.36.114.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE4DB6606F;
        Thu, 30 Apr 2020 13:02:12 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christoph Paasch <cpaasch@apple.com>, mptcp@lists.01.org
Subject: [PATCH net v2 2/5] mptcp: move option parsing into  mptcp_incoming_options()
Date:   Thu, 30 Apr 2020 15:01:52 +0200
Message-Id: <0d74ddb8189a33b2121b58a90a6839b2e036783c.1588243786.git.pabeni@redhat.com>
In-Reply-To: <cover.1588243786.git.pabeni@redhat.com>
References: <cover.1588243786.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mptcp_options_received structure carries several per
packet flags (mp_capable, mp_join, etc.). Such fields must
be cleared on each packet, even on dropped ones or packet
not carrying any MPTCP options, but the current mptcp
code clears them only on TCP option reset.

On several races/corner cases we end-up with stray bits in
incoming options, leading to WARN_ON splats. e.g.:

[  171.164906] Bad mapping: ssn=3D32714 map_seq=3D1 map_data_len=3D32713
[  171.165006] WARNING: CPU: 1 PID: 5026 at net/mptcp/subflow.c:533 warn_=
bad_map (linux-mptcp/net/mptcp/subflow.c:533 linux-mptcp/net/mptcp/subflo=
w.c:531)
[  171.167632] Modules linked in: ip6_vti ip_vti ip_gre ipip sit tunnel4 =
ip_tunnel geneve ip6_udp_tunnel udp_tunnel macsec macvtap tap ipvlan macv=
lan 8021q garp mrp xfrm_interface veth netdevsim nlmon dummy team bonding=
 vcan bridge stp llc ip6_gre gre ip6_tunnel tunnel6 tun binfmt_misc intel=
_rapl_msr intel_rapl_common rfkill kvm_intel kvm irqbypass crct10dif_pclm=
ul crc32_pclmul ghash_clmulni_intel joydev virtio_balloon pcspkr i2c_piix=
4 sunrpc ip_tables xfs libcrc32c crc32c_intel serio_raw virtio_console at=
a_generic virtio_blk virtio_net net_failover failover ata_piix libata
[  171.199464] CPU: 1 PID: 5026 Comm: repro Not tainted 5.7.0-rc1.mptcp_f=
227fdf5d388+ #95
[  171.200886] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S 1.12.0-2.fc30 04/01/2014
[  171.202546] RIP: 0010:warn_bad_map (linux-mptcp/net/mptcp/subflow.c:53=
3 linux-mptcp/net/mptcp/subflow.c:531)
[  171.206537] Code: c1 ea 03 0f b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d=
0 7c 04 84 d2 75 1d 8b 55 3c 44 89 e6 48 c7 c7 20 51 13 95 e8 37 8b 22 fe=
 <0f> 0b 48 83 c4 08 5b 5d 41 5c c3 89 4c 24 04 e8 db d6 94 fe 8b 4c
[  171.220473] RSP: 0018:ffffc90000150560 EFLAGS: 00010282
[  171.221639] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000000=
0000000
[  171.223108] RDX: 0000000000000000 RSI: 0000000000000008 RDI: fffff5200=
002a09e
[  171.224388] RBP: ffff8880aa6e3c00 R08: 0000000000000001 R09: fffffbfff=
2ec9955
[  171.225706] R10: ffffffff9764caa7 R11: fffffbfff2ec9954 R12: 000000000=
0007fca
[  171.227211] R13: ffff8881066f4a7f R14: ffff8880aa6e3c00 R15: 000000000=
0000020
[  171.228460] FS:  00007f8623719740(0000) GS:ffff88810be00000(0000) knlG=
S:0000000000000000
[  171.230065] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  171.231303] CR2: 00007ffdab190a50 CR3: 00000001038ea006 CR4: 000000000=
0160ee0
[  171.232586] Call Trace:
[  171.233109]  <IRQ>
[  171.233531] get_mapping_status (linux-mptcp/net/mptcp/subflow.c:691)
[  171.234371] mptcp_subflow_data_available (linux-mptcp/net/mptcp/subflo=
w.c:736 linux-mptcp/net/mptcp/subflow.c:832)
[  171.238181] subflow_state_change (linux-mptcp/net/mptcp/subflow.c:1085=
 (discriminator 1))
[  171.239066] tcp_fin (linux-mptcp/net/ipv4/tcp_input.c:4217)
[  171.240123] tcp_data_queue (linux-mptcp/./include/linux/compiler.h:199=
 linux-mptcp/net/ipv4/tcp_input.c:4822)
[  171.245083] tcp_rcv_established (linux-mptcp/./include/linux/skbuff.h:=
1785 linux-mptcp/./include/net/tcp.h:1774 linux-mptcp/./include/net/tcp.h=
:1847 linux-mptcp/net/ipv4/tcp_input.c:5238 linux-mptcp/net/ipv4/tcp_inpu=
t.c:5730)
[  171.254089] tcp_v4_rcv (linux-mptcp/./include/linux/spinlock.h:393 lin=
ux-mptcp/net/ipv4/tcp_ipv4.c:2009)
[  171.258969] ip_protocol_deliver_rcu (linux-mptcp/net/ipv4/ip_input.c:2=
04 (discriminator 1))
[  171.260214] ip_local_deliver_finish (linux-mptcp/./include/linux/rcupd=
ate.h:651 linux-mptcp/net/ipv4/ip_input.c:232)
[  171.261389] ip_local_deliver (linux-mptcp/./include/linux/netfilter.h:=
307 linux-mptcp/./include/linux/netfilter.h:301 linux-mptcp/net/ipv4/ip_i=
nput.c:252)
[  171.265884] ip_rcv (linux-mptcp/./include/linux/netfilter.h:307 linux-=
mptcp/./include/linux/netfilter.h:301 linux-mptcp/net/ipv4/ip_input.c:539=
)
[  171.273666] process_backlog (linux-mptcp/./include/linux/rcupdate.h:65=
1 linux-mptcp/net/core/dev.c:6135)
[  171.275328] net_rx_action (linux-mptcp/net/core/dev.c:6572 linux-mptcp=
/net/core/dev.c:6640)
[  171.280472] __do_softirq (linux-mptcp/./arch/x86/include/asm/jump_labe=
l.h:25 linux-mptcp/./include/linux/jump_label.h:200 linux-mptcp/./include=
/trace/events/irq.h:142 linux-mptcp/kernel/softirq.c:293)
[  171.281379] do_softirq_own_stack (linux-mptcp/arch/x86/entry/entry_64.=
S:1083)
[  171.282358]  </IRQ>

We could address the issue clearing explicitly the relevant fields
in several places - tcp_parse_option, tcp_fast_parse_options,
possibly others.

Instead we move the MPTCP option parsing into the already existing
mptcp ingress hook, so that we need to clear the fields in a single
place.

This allows us dropping an MPTCP hook from the TCP code and
removing the quite large mptcp_options_received from the tcp_sock
struct. On the flip side, the MPTCP sockets will traverse the
option space twice (in tcp_parse_option() and in
mptcp_incoming_options(). That looks acceptable: we already
do that for syn and 3rd ack packets, plain TCP socket will
benefit from it, and even MPTCP sockets will experience better
code locality, reducing the jumps between TCP and MPTCP code.

v1 -> v2:
 - rebased on current '-net' tree

Fixes: 648ef4b88673 ("mptcp: Implement MPTCP receive path")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/linux/tcp.h  | 51 ----------------------------------
 include/net/mptcp.h  |  2 --
 net/ipv4/tcp_input.c |  4 ---
 net/mptcp/options.c  | 66 +++++++++++++++++++++++++-------------------
 net/mptcp/protocol.c |  6 ++--
 net/mptcp/protocol.h | 43 +++++++++++++++++++++++++++--
 net/mptcp/subflow.c  | 65 ++++++++++++++++++++++---------------------
 7 files changed, 115 insertions(+), 122 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 421c99c12291..4f8159e90ce1 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -78,47 +78,6 @@ struct tcp_sack_block {
 #define TCP_SACK_SEEN     (1 << 0)   /*1 =3D peer is SACK capable, */
 #define TCP_DSACK_SEEN    (1 << 2)   /*1 =3D DSACK was received from pee=
r*/
=20
-#if IS_ENABLED(CONFIG_MPTCP)
-struct mptcp_options_received {
-	u64	sndr_key;
-	u64	rcvr_key;
-	u64	data_ack;
-	u64	data_seq;
-	u32	subflow_seq;
-	u16	data_len;
-	u16	mp_capable : 1,
-		mp_join : 1,
-		dss : 1,
-		add_addr : 1,
-		rm_addr : 1,
-		family : 4,
-		echo : 1,
-		backup : 1;
-	u32	token;
-	u32	nonce;
-	u64	thmac;
-	u8	hmac[20];
-	u8	join_id;
-	u8	use_map:1,
-		dsn64:1,
-		data_fin:1,
-		use_ack:1,
-		ack64:1,
-		mpc_map:1,
-		__unused:2;
-	u8	addr_id;
-	u8	rm_id;
-	union {
-		struct in_addr	addr;
-#if IS_ENABLED(CONFIG_MPTCP_IPV6)
-		struct in6_addr	addr6;
-#endif
-	};
-	u64	ahmac;
-	u16	port;
-};
-#endif
-
 struct tcp_options_received {
 /*	PAWS/RTTM data	*/
 	int	ts_recent_stamp;/* Time we stored ts_recent (for aging) */
@@ -136,9 +95,6 @@ struct tcp_options_received {
 	u8	num_sacks;	/* Number of SACK blocks		*/
 	u16	user_mss;	/* mss requested by user in ioctl	*/
 	u16	mss_clamp;	/* Maximal mss, negotiated at connection setup */
-#if IS_ENABLED(CONFIG_MPTCP)
-	struct mptcp_options_received	mptcp;
-#endif
 };
=20
 static inline void tcp_clear_options(struct tcp_options_received *rx_opt=
)
@@ -148,13 +104,6 @@ static inline void tcp_clear_options(struct tcp_opti=
ons_received *rx_opt)
 #if IS_ENABLED(CONFIG_SMC)
 	rx_opt->smc_ok =3D 0;
 #endif
-#if IS_ENABLED(CONFIG_MPTCP)
-	rx_opt->mptcp.mp_capable =3D 0;
-	rx_opt->mptcp.mp_join =3D 0;
-	rx_opt->mptcp.add_addr =3D 0;
-	rx_opt->mptcp.rm_addr =3D 0;
-	rx_opt->mptcp.dss =3D 0;
-#endif
 }
=20
 /* This is the max number of SACKS that we'll generate and process. It's=
 safe
diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 4ecfa7d5e0c7..3bce2019e4da 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -68,8 +68,6 @@ static inline bool rsk_is_mptcp(const struct request_so=
ck *req)
 	return tcp_rsk(req)->is_mptcp;
 }
=20
-void mptcp_parse_option(const struct sk_buff *skb, const unsigned char *=
ptr,
-			int opsize, struct tcp_options_received *opt_rx);
 bool mptcp_syn_options(struct sock *sk, const struct sk_buff *skb,
 		       unsigned int *size, struct mptcp_out_options *opts);
 bool mptcp_synack_options(const struct request_sock *req, unsigned int *=
size,
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 81425542da44..b996dc1069c5 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3926,10 +3926,6 @@ void tcp_parse_options(const struct net *net,
 				 */
 				break;
 #endif
-			case TCPOPT_MPTCP:
-				mptcp_parse_option(skb, ptr, opsize, opt_rx);
-				break;
-
 			case TCPOPT_FASTOPEN:
 				tcp_parse_fastopen_option(
 					opsize - TCPOLEN_FASTOPEN_BASE,
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 8fea686a5562..eadbd59586e4 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -16,10 +16,10 @@ static bool mptcp_cap_flag_sha256(u8 flags)
 	return (flags & MPTCP_CAP_FLAG_MASK) =3D=3D MPTCP_CAP_HMAC_SHA256;
 }
=20
-void mptcp_parse_option(const struct sk_buff *skb, const unsigned char *=
ptr,
-			int opsize, struct tcp_options_received *opt_rx)
+static void mptcp_parse_option(const struct sk_buff *skb,
+			       const unsigned char *ptr, int opsize,
+			       struct mptcp_options_received *mp_opt)
 {
-	struct mptcp_options_received *mp_opt =3D &opt_rx->mptcp;
 	u8 subtype =3D *ptr >> 4;
 	int expected_opsize;
 	u8 version;
@@ -283,12 +283,20 @@ void mptcp_parse_option(const struct sk_buff *skb, =
const unsigned char *ptr,
 }
=20
 void mptcp_get_options(const struct sk_buff *skb,
-		       struct tcp_options_received *opt_rx)
+		       struct mptcp_options_received *mp_opt)
 {
-	const unsigned char *ptr;
 	const struct tcphdr *th =3D tcp_hdr(skb);
-	int length =3D (th->doff * 4) - sizeof(struct tcphdr);
+	const unsigned char *ptr;
+	int length;
=20
+	/* initialize option status */
+	mp_opt->mp_capable =3D 0;
+	mp_opt->mp_join =3D 0;
+	mp_opt->add_addr =3D 0;
+	mp_opt->rm_addr =3D 0;
+	mp_opt->dss =3D 0;
+
+	length =3D (th->doff * 4) - sizeof(struct tcphdr);
 	ptr =3D (const unsigned char *)(th + 1);
=20
 	while (length > 0) {
@@ -308,7 +316,7 @@ void mptcp_get_options(const struct sk_buff *skb,
 			if (opsize > length)
 				return;	/* don't parse partial options */
 			if (opcode =3D=3D TCPOPT_MPTCP)
-				mptcp_parse_option(skb, ptr, opsize, opt_rx);
+				mptcp_parse_option(skb, ptr, opsize, mp_opt);
 			ptr +=3D opsize - 2;
 			length -=3D opsize;
 		}
@@ -797,41 +805,41 @@ void mptcp_incoming_options(struct sock *sk, struct=
 sk_buff *skb,
 {
 	struct mptcp_subflow_context *subflow =3D mptcp_subflow_ctx(sk);
 	struct mptcp_sock *msk =3D mptcp_sk(subflow->conn);
-	struct mptcp_options_received *mp_opt;
+	struct mptcp_options_received mp_opt;
 	struct mptcp_ext *mpext;
=20
-	mp_opt =3D &opt_rx->mptcp;
-	if (!check_fully_established(msk, sk, subflow, skb, mp_opt))
+	mptcp_get_options(skb, &mp_opt);
+	if (!check_fully_established(msk, sk, subflow, skb, &mp_opt))
 		return;
=20
-	if (mp_opt->add_addr && add_addr_hmac_valid(msk, mp_opt)) {
+	if (mp_opt.add_addr && add_addr_hmac_valid(msk, &mp_opt)) {
 		struct mptcp_addr_info addr;
=20
-		addr.port =3D htons(mp_opt->port);
-		addr.id =3D mp_opt->addr_id;
-		if (mp_opt->family =3D=3D MPTCP_ADDR_IPVERSION_4) {
+		addr.port =3D htons(mp_opt.port);
+		addr.id =3D mp_opt.addr_id;
+		if (mp_opt.family =3D=3D MPTCP_ADDR_IPVERSION_4) {
 			addr.family =3D AF_INET;
-			addr.addr =3D mp_opt->addr;
+			addr.addr =3D mp_opt.addr;
 		}
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
-		else if (mp_opt->family =3D=3D MPTCP_ADDR_IPVERSION_6) {
+		else if (mp_opt.family =3D=3D MPTCP_ADDR_IPVERSION_6) {
 			addr.family =3D AF_INET6;
-			addr.addr6 =3D mp_opt->addr6;
+			addr.addr6 =3D mp_opt.addr6;
 		}
 #endif
-		if (!mp_opt->echo)
+		if (!mp_opt.echo)
 			mptcp_pm_add_addr_received(msk, &addr);
-		mp_opt->add_addr =3D 0;
+		mp_opt.add_addr =3D 0;
 	}
=20
-	if (!mp_opt->dss)
+	if (!mp_opt.dss)
 		return;
=20
 	/* we can't wait for recvmsg() to update the ack_seq, otherwise
 	 * monodirectional flows will stuck
 	 */
-	if (mp_opt->use_ack)
-		update_una(msk, mp_opt);
+	if (mp_opt.use_ack)
+		update_una(msk, &mp_opt);
=20
 	mpext =3D skb_ext_add(skb, SKB_EXT_MPTCP);
 	if (!mpext)
@@ -839,8 +847,8 @@ void mptcp_incoming_options(struct sock *sk, struct s=
k_buff *skb,
=20
 	memset(mpext, 0, sizeof(*mpext));
=20
-	if (mp_opt->use_map) {
-		if (mp_opt->mpc_map) {
+	if (mp_opt.use_map) {
+		if (mp_opt.mpc_map) {
 			/* this is an MP_CAPABLE carrying MPTCP data
 			 * we know this map the first chunk of data
 			 */
@@ -851,12 +859,12 @@ void mptcp_incoming_options(struct sock *sk, struct=
 sk_buff *skb,
 			mpext->dsn64 =3D 1;
 			mpext->mpc_map =3D 1;
 		} else {
-			mpext->data_seq =3D mp_opt->data_seq;
-			mpext->subflow_seq =3D mp_opt->subflow_seq;
-			mpext->dsn64 =3D mp_opt->dsn64;
-			mpext->data_fin =3D mp_opt->data_fin;
+			mpext->data_seq =3D mp_opt.data_seq;
+			mpext->subflow_seq =3D mp_opt.subflow_seq;
+			mpext->dsn64 =3D mp_opt.dsn64;
+			mpext->data_fin =3D mp_opt.data_fin;
 		}
-		mpext->data_len =3D mp_opt->data_len;
+		mpext->data_len =3D mp_opt.data_len;
 		mpext->use_map =3D 1;
 	}
 }
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 6e0188f5d3f3..e1f23016ed3f 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1334,7 +1334,7 @@ static struct ipv6_pinfo *mptcp_inet6_sk(const stru=
ct sock *sk)
 #endif
=20
 struct sock *mptcp_sk_clone(const struct sock *sk,
-			    const struct tcp_options_received *opt_rx,
+			    const struct mptcp_options_received *mp_opt,
 			    struct request_sock *req)
 {
 	struct mptcp_subflow_request_sock *subflow_req =3D mptcp_subflow_rsk(re=
q);
@@ -1373,9 +1373,9 @@ struct sock *mptcp_sk_clone(const struct sock *sk,
=20
 	msk->write_seq =3D subflow_req->idsn + 1;
 	atomic64_set(&msk->snd_una, msk->write_seq);
-	if (opt_rx->mptcp.mp_capable) {
+	if (mp_opt->mp_capable) {
 		msk->can_ack =3D true;
-		msk->remote_key =3D opt_rx->mptcp.sndr_key;
+		msk->remote_key =3D mp_opt->sndr_key;
 		mptcp_crypto_key_sha(msk->remote_key, NULL, &ack_seq);
 		ack_seq++;
 		msk->ack_seq =3D ack_seq;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index a2b3048037d0..e4ca6320ce76 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -91,6 +91,45 @@
 #define MPTCP_WORK_RTX		2
 #define MPTCP_WORK_EOF		3
=20
+struct mptcp_options_received {
+	u64	sndr_key;
+	u64	rcvr_key;
+	u64	data_ack;
+	u64	data_seq;
+	u32	subflow_seq;
+	u16	data_len;
+	u16	mp_capable : 1,
+		mp_join : 1,
+		dss : 1,
+		add_addr : 1,
+		rm_addr : 1,
+		family : 4,
+		echo : 1,
+		backup : 1;
+	u32	token;
+	u32	nonce;
+	u64	thmac;
+	u8	hmac[20];
+	u8	join_id;
+	u8	use_map:1,
+		dsn64:1,
+		data_fin:1,
+		use_ack:1,
+		ack64:1,
+		mpc_map:1,
+		__unused:2;
+	u8	addr_id;
+	u8	rm_id;
+	union {
+		struct in_addr	addr;
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+		struct in6_addr	addr6;
+#endif
+	};
+	u64	ahmac;
+	u16	port;
+};
+
 static inline __be32 mptcp_option(u8 subopt, u8 len, u8 nib, u8 field)
 {
 	return htonl((TCPOPT_MPTCP << 24) | (len << 16) | (subopt << 12) |
@@ -331,10 +370,10 @@ int mptcp_proto_v6_init(void);
 #endif
=20
 struct sock *mptcp_sk_clone(const struct sock *sk,
-			    const struct tcp_options_received *opt_rx,
+			    const struct mptcp_options_received *mp_opt,
 			    struct request_sock *req);
 void mptcp_get_options(const struct sk_buff *skb,
-		       struct tcp_options_received *opt_rx);
+		       struct mptcp_options_received *mp_opt);
=20
 void mptcp_finish_connect(struct sock *sk);
 void mptcp_data_ready(struct sock *sk, struct sock *ssk);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 84f6408594c9..bad998529767 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -124,12 +124,11 @@ static void subflow_init_req(struct request_sock *r=
eq,
 {
 	struct mptcp_subflow_context *listener =3D mptcp_subflow_ctx(sk_listene=
r);
 	struct mptcp_subflow_request_sock *subflow_req =3D mptcp_subflow_rsk(re=
q);
-	struct tcp_options_received rx_opt;
+	struct mptcp_options_received mp_opt;
=20
 	pr_debug("subflow_req=3D%p, listener=3D%p", subflow_req, listener);
=20
-	memset(&rx_opt.mptcp, 0, sizeof(rx_opt.mptcp));
-	mptcp_get_options(skb, &rx_opt);
+	mptcp_get_options(skb, &mp_opt);
=20
 	subflow_req->mp_capable =3D 0;
 	subflow_req->mp_join =3D 0;
@@ -142,16 +141,16 @@ static void subflow_init_req(struct request_sock *r=
eq,
 		return;
 #endif
=20
-	if (rx_opt.mptcp.mp_capable) {
+	if (mp_opt.mp_capable) {
 		SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_MPCAPABLEPASSIVE);
=20
-		if (rx_opt.mptcp.mp_join)
+		if (mp_opt.mp_join)
 			return;
-	} else if (rx_opt.mptcp.mp_join) {
+	} else if (mp_opt.mp_join) {
 		SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINSYNRX);
 	}
=20
-	if (rx_opt.mptcp.mp_capable && listener->request_mptcp) {
+	if (mp_opt.mp_capable && listener->request_mptcp) {
 		int err;
=20
 		err =3D mptcp_token_new_request(req);
@@ -159,13 +158,13 @@ static void subflow_init_req(struct request_sock *r=
eq,
 			subflow_req->mp_capable =3D 1;
=20
 		subflow_req->ssn_offset =3D TCP_SKB_CB(skb)->seq;
-	} else if (rx_opt.mptcp.mp_join && listener->request_mptcp) {
+	} else if (mp_opt.mp_join && listener->request_mptcp) {
 		subflow_req->ssn_offset =3D TCP_SKB_CB(skb)->seq;
 		subflow_req->mp_join =3D 1;
-		subflow_req->backup =3D rx_opt.mptcp.backup;
-		subflow_req->remote_id =3D rx_opt.mptcp.join_id;
-		subflow_req->token =3D rx_opt.mptcp.token;
-		subflow_req->remote_nonce =3D rx_opt.mptcp.nonce;
+		subflow_req->backup =3D mp_opt.backup;
+		subflow_req->remote_id =3D mp_opt.join_id;
+		subflow_req->token =3D mp_opt.token;
+		subflow_req->remote_nonce =3D mp_opt.nonce;
 		pr_debug("token=3D%u, remote_nonce=3D%u", subflow_req->token,
 			 subflow_req->remote_nonce);
 		if (!subflow_token_join_request(req, skb)) {
@@ -221,6 +220,7 @@ static bool subflow_thmac_valid(struct mptcp_subflow_=
context *subflow)
 static void subflow_finish_connect(struct sock *sk, const struct sk_buff=
 *skb)
 {
 	struct mptcp_subflow_context *subflow =3D mptcp_subflow_ctx(sk);
+	struct mptcp_options_received mp_opt;
 	struct sock *parent =3D subflow->conn;
 	struct tcp_sock *tp =3D tcp_sk(sk);
=20
@@ -237,16 +237,17 @@ static void subflow_finish_connect(struct sock *sk,=
 const struct sk_buff *skb)
=20
 	subflow->conn_finished =3D 1;
=20
-	if (subflow->request_mptcp && tp->rx_opt.mptcp.mp_capable) {
+	mptcp_get_options(skb, &mp_opt);
+	if (subflow->request_mptcp && mp_opt.mp_capable) {
 		subflow->mp_capable =3D 1;
 		subflow->can_ack =3D 1;
-		subflow->remote_key =3D tp->rx_opt.mptcp.sndr_key;
+		subflow->remote_key =3D mp_opt.sndr_key;
 		pr_debug("subflow=3D%p, remote_key=3D%llu", subflow,
 			 subflow->remote_key);
-	} else if (subflow->request_join && tp->rx_opt.mptcp.mp_join) {
+	} else if (subflow->request_join && mp_opt.mp_join) {
 		subflow->mp_join =3D 1;
-		subflow->thmac =3D tp->rx_opt.mptcp.thmac;
-		subflow->remote_nonce =3D tp->rx_opt.mptcp.nonce;
+		subflow->thmac =3D mp_opt.thmac;
+		subflow->remote_nonce =3D mp_opt.nonce;
 		pr_debug("subflow=3D%p, thmac=3D%llu, remote_nonce=3D%u", subflow,
 			 subflow->thmac, subflow->remote_nonce);
 	} else if (subflow->request_mptcp) {
@@ -343,7 +344,7 @@ static int subflow_v6_conn_request(struct sock *sk, s=
truct sk_buff *skb)
=20
 /* validate hmac received in third ACK */
 static bool subflow_hmac_valid(const struct request_sock *req,
-			       const struct tcp_options_received *rx_opt)
+			       const struct mptcp_options_received *mp_opt)
 {
 	const struct mptcp_subflow_request_sock *subflow_req;
 	u8 hmac[MPTCPOPT_HMAC_LEN];
@@ -360,7 +361,7 @@ static bool subflow_hmac_valid(const struct request_s=
ock *req,
 			      subflow_req->local_nonce, hmac);
=20
 	ret =3D true;
-	if (crypto_memneq(hmac, rx_opt->mptcp.hmac, sizeof(hmac)))
+	if (crypto_memneq(hmac, mp_opt->hmac, sizeof(hmac)))
 		ret =3D false;
=20
 	sock_put((struct sock *)msk);
@@ -416,7 +417,7 @@ static struct sock *subflow_syn_recv_sock(const struc=
t sock *sk,
 {
 	struct mptcp_subflow_context *listener =3D mptcp_subflow_ctx(sk);
 	struct mptcp_subflow_request_sock *subflow_req;
-	struct tcp_options_received opt_rx;
+	struct mptcp_options_received mp_opt;
 	bool fallback_is_fatal =3D false;
 	struct sock *new_msk =3D NULL;
 	bool fallback =3D false;
@@ -424,7 +425,10 @@ static struct sock *subflow_syn_recv_sock(const stru=
ct sock *sk,
=20
 	pr_debug("listener=3D%p, req=3D%p, conn=3D%p", listener, req, listener-=
>conn);
=20
-	opt_rx.mptcp.mp_capable =3D 0;
+	/* we need later a valid 'mp_capable' value even when options are not
+	 * parsed
+	 */
+	mp_opt.mp_capable =3D 0;
 	if (tcp_rsk(req)->is_mptcp =3D=3D 0)
 		goto create_child;
=20
@@ -439,22 +443,21 @@ static struct sock *subflow_syn_recv_sock(const str=
uct sock *sk,
 			goto create_msk;
 		}
=20
-		mptcp_get_options(skb, &opt_rx);
-		if (!opt_rx.mptcp.mp_capable) {
+		mptcp_get_options(skb, &mp_opt);
+		if (!mp_opt.mp_capable) {
 			fallback =3D true;
 			goto create_child;
 		}
=20
 create_msk:
-		new_msk =3D mptcp_sk_clone(listener->conn, &opt_rx, req);
+		new_msk =3D mptcp_sk_clone(listener->conn, &mp_opt, req);
 		if (!new_msk)
 			fallback =3D true;
 	} else if (subflow_req->mp_join) {
 		fallback_is_fatal =3D true;
-		opt_rx.mptcp.mp_join =3D 0;
-		mptcp_get_options(skb, &opt_rx);
-		if (!opt_rx.mptcp.mp_join ||
-		    !subflow_hmac_valid(req, &opt_rx)) {
+		mptcp_get_options(skb, &mp_opt);
+		if (!mp_opt.mp_join ||
+		    !subflow_hmac_valid(req, &mp_opt)) {
 			SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINACKMAC);
 			return NULL;
 		}
@@ -494,9 +497,9 @@ static struct sock *subflow_syn_recv_sock(const struc=
t sock *sk,
 			/* with OoO packets we can reach here without ingress
 			 * mpc option
 			 */
-			ctx->remote_key =3D opt_rx.mptcp.sndr_key;
-			ctx->fully_established =3D opt_rx.mptcp.mp_capable;
-			ctx->can_ack =3D opt_rx.mptcp.mp_capable;
+			ctx->remote_key =3D mp_opt.sndr_key;
+			ctx->fully_established =3D mp_opt.mp_capable;
+			ctx->can_ack =3D mp_opt.mp_capable;
 		} else if (ctx->mp_join) {
 			struct mptcp_sock *owner;
=20
--=20
2.21.1

