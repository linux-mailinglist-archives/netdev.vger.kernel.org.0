Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126222D4634
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 16:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730619AbgLIP67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 10:58:59 -0500
Received: from david.siemens.de ([192.35.17.14]:59031 "EHLO david.siemens.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729303AbgLIP67 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 10:58:59 -0500
Received: from mail1.siemens.de (mail1.siemens.de [139.23.33.14])
        by david.siemens.de (8.15.2/8.15.2) with ESMTPS id 0B9EbS7n007624
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Dec 2020 15:37:28 +0100
Received: from tsnlaptop.atstm41.nbgm.siemens.de ([144.145.220.34])
        by mail1.siemens.de (8.15.2/8.15.2) with ESMTP id 0B9EbGp2002581;
        Wed, 9 Dec 2020 15:37:25 +0100
From:   Erez Geva <erez.geva.ext@siemens.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Arnd Bergmann <arnd@arndb.de>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Alexei Starovoitov <ast@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Eyal Birger <eyal.birger@gmail.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Ogness <john.ogness@linutronix.de>,
        Jon Rosen <jrosen@cisco.com>,
        Kees Cook <keescook@chromium.org>,
        Mao Wenan <maowenan@huawei.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Martin KaFai Lau <kafai@fb.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Andrei Vagin <avagin@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Or Cohen <orcohen@paloaltonetworks.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Willem de Bruijn <willemb@google.com>,
        Xie He <xie.he.0141@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladis Dronov <vdronov@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
        Ines Molzahn <ines.molzahn@siemens.com>,
        Simon Sudler <simon.sudler@siemens.com>,
        Andreas Meisinger <andreas.meisinger@siemens.com>,
        Andreas Bucher <andreas.bucher@siemens.com>,
        Henning Schild <henning.schild@siemens.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Andreas Zirkler <andreas.zirkler@siemens.com>,
        Ermin Sakic <ermin.sakic@siemens.com>,
        An Ninh Nguyen <anninh.nguyen@siemens.com>,
        Michael Saenger <michael.saenger@siemens.com>,
        Bernd Maehringer <bernd.maehringer@siemens.com>,
        Gisela Greinert <gisela.greinert@siemens.com>,
        Erez Geva <erez.geva.ext@siemens.com>,
        Erez Geva <ErezGeva2@gmail.com>
Subject: [PATCH 2/3] Pass TX sending hardware timestamp to a socket's buffer.
Date:   Wed,  9 Dec 2020 15:37:05 +0100
Message-Id: <20201209143707.13503-3-erez.geva.ext@siemens.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201209143707.13503-1-erez.geva.ext@siemens.com>
References: <20201209143707.13503-1-erez.geva.ext@siemens.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass TX sending hardware timestamp from the socket layer to
 a socket's buffer. The TC ETC Qdisc will pass it
 to the interface network driver.

 - Add the hardware timestamp to the IP cork, to support
   the use of IP/UDP with the TX sending hardware timestamp
   when sending through the TC ETF Qdisc
 - Pass the TX sending hardware timestamp to a socket's buffer
   using the hardware timestamp on the socket's buffer shared information.

 Note: The socket buffer's hardware timestamp is used by
       the network interface driver to send the actual sending timestamp
       back to the application.
       The timestamp is used by the TC ETF before the buffer
       arrives in the network interface driver.

Signed-off-by: Erez Geva <erez.geva.ext@siemens.com>
---
 include/net/inet_sock.h | 1 +
 net/ipv4/ip_output.c    | 2 ++
 net/ipv4/raw.c          | 1 +
 net/ipv6/ip6_output.c   | 2 ++
 net/ipv6/raw.c          | 1 +
 net/packet/af_packet.c  | 3 +++
 6 files changed, 10 insertions(+)

diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index 89163ef8cf4b..e74e8dabf63d 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -160,6 +160,7 @@ struct inet_cork {
 	char			priority;
 	__u16			gso_size;
 	u64			transmit_time;
+	u64			transmit_hw_time;
 	u32			mark;
 };
 
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 879b76ae4435..416598c864e3 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1282,6 +1282,7 @@ static int ip_setup_cork(struct sock *sk, struct inet_cork *cork,
 	cork->mark = ipc->sockc.mark;
 	cork->priority = ipc->priority;
 	cork->transmit_time = ipc->sockc.transmit_time;
+	cork->transmit_hw_time = ipc->sockc.transmit_hw_time;
 	cork->tx_flags = 0;
 	sock_tx_timestamp(sk, ipc->sockc.tsflags, &cork->tx_flags);
 
@@ -1545,6 +1546,7 @@ struct sk_buff *__ip_make_skb(struct sock *sk,
 	skb->priority = (cork->tos != -1) ? cork->priority: sk->sk_priority;
 	skb->mark = cork->mark;
 	skb->tstamp = cork->transmit_time;
+	skb_hwtstamps(skb)->hwtstamp = ns_to_ktime(cork->transmit_hw_time);
 	/*
 	 * Steal rt from cork.dst to avoid a pair of atomic_inc/atomic_dec
 	 * on dst refcount
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 7d26e0f8bdae..213a47fb2df8 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -378,6 +378,7 @@ static int raw_send_hdrinc(struct sock *sk, struct flowi4 *fl4,
 	skb->priority = sk->sk_priority;
 	skb->mark = sockc->mark;
 	skb->tstamp = sockc->transmit_time;
+	skb_hwtstamps(skb)->hwtstamp = ns_to_ktime(sockc->transmit_hw_time);
 	skb_dst_set(skb, &rt->dst);
 	*rtp = NULL;
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 749ad72386b2..8cff05f5aa8a 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1375,6 +1375,7 @@ static int ip6_setup_cork(struct sock *sk, struct inet_cork_full *cork,
 	cork->base.length = 0;
 
 	cork->base.transmit_time = ipc6->sockc.transmit_time;
+	cork->base.transmit_hw_time = ipc6->sockc.transmit_hw_time;
 
 	return 0;
 }
@@ -1841,6 +1842,7 @@ struct sk_buff *__ip6_make_skb(struct sock *sk,
 	skb->mark = cork->base.mark;
 
 	skb->tstamp = cork->base.transmit_time;
+	skb_hwtstamps(skb)->hwtstamp = ns_to_ktime(cork->base.transmit_hw_time);
 
 	skb_dst_set(skb, dst_clone(&rt->dst));
 	IP6_UPD_PO_STATS(net, rt->rt6i_idev, IPSTATS_MIB_OUT, skb->len);
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 6e4ab80a3b94..417f21867782 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -648,6 +648,7 @@ static int rawv6_send_hdrinc(struct sock *sk, struct msghdr *msg, int length,
 	skb->priority = sk->sk_priority;
 	skb->mark = sockc->mark;
 	skb->tstamp = sockc->transmit_time;
+	skb_hwtstamps(skb)->hwtstamp = ns_to_ktime(sockc->transmit_hw_time);
 
 	skb_put(skb, length);
 	skb_reset_network_header(skb);
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 7a18ffff8551..c762d5bcecc2 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1986,6 +1986,7 @@ static int packet_sendmsg_spkt(struct socket *sock, struct msghdr *msg,
 	skb->priority = sk->sk_priority;
 	skb->mark = sk->sk_mark;
 	skb->tstamp = sockc.transmit_time;
+	skb_hwtstamps(skb)->hwtstamp = ns_to_ktime(sockc.transmit_hw_time);
 
 	skb_setup_tx_timestamp(skb, sockc.tsflags);
 
@@ -2500,6 +2501,7 @@ static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
 	skb->priority = po->sk.sk_priority;
 	skb->mark = po->sk.sk_mark;
 	skb->tstamp = sockc->transmit_time;
+	skb_hwtstamps(skb)->hwtstamp = ns_to_ktime(sockc->transmit_hw_time);
 	skb_setup_tx_timestamp(skb, sockc->tsflags);
 	skb_zcopy_set_nouarg(skb, ph.raw);
 
@@ -2975,6 +2977,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 	skb->priority = sk->sk_priority;
 	skb->mark = sockc.mark;
 	skb->tstamp = sockc.transmit_time;
+	skb_hwtstamps(skb)->hwtstamp = ns_to_ktime(sockc.transmit_hw_time);
 
 	if (has_vnet_hdr) {
 		err = virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le());
-- 
2.20.1

