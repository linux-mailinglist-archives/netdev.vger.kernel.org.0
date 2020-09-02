Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C6625B500
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 22:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgIBUC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 16:02:28 -0400
Received: from st43p00im-zteg10062001.me.com ([17.58.63.166]:50794 "EHLO
        st43p00im-zteg10062001.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726298AbgIBUC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 16:02:26 -0400
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Sep 2020 16:02:25 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1599076619;
        bh=o0y/fN/rP+hq5M4jtySLmCBt/KZNT6Zf55ZoB6vEMgo=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=1M4DwZJdxpYzGfRy3gVp3IZjg/sfh5YU6T51DQE4jqvTstzCCQSSkUSK5VkznJg7p
         tgTi8ztlDGfD25ZfdcDnv1ADj54piv5X8s4gvebxO3xnxe27rHKWmgMt5xh7hRh3Nx
         KHas3uv1nWn/sXcRKAars1zT2y/uYyO8mpF7sneYEPhlRkhuzde7BLun7hIbwMKfiP
         al2csdiR2CYzd79/gGr4DRAWagKwsaKC2iRi+Yaq8V9Yg+UT+p2D0/VO/8BseJ9R4c
         gVqh2qw6KBzbLM1L37eLGmxawlqLYsOHx2t8oUcQUMfqbRd1NlH0TRLmrjbpWhI/Au
         yKoy9QSHUoW6A==
Received: from michi-vb.fritz.box (unknown [141.98.102.148])
        by st43p00im-zteg10062001.me.com (Postfix) with ESMTPSA id 4828F6C0B86;
        Wed,  2 Sep 2020 19:56:59 +0000 (UTC)
From:   Mihail Milev <mmilev_ml@icloud.com>
To:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] Sysctl parameter to disable TCP RST packet to unknown socket
Date:   Wed,  2 Sep 2020 21:56:56 +0200
Message-Id: <20200902195656.7538-1-mmilev_ml@icloud.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-02_14:2020-09-02,2020-09-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011 mlxscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2006250000 definitions=main-2009020186
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

What?

Create a new sysctl parameter called tcp_disable_rst_unkn_socket,
which by default is set to 0 - "disabled". When this parameter is
set to 1 - "enabled", it suppresses sending a TCP RST packet as a
response to received TCP packets destined for a socket, which is
unknown to the kernel.

Important!

By enabling this sysctl parameter, the TCP stack becomes non-
conformal to RFC 793, which clearly states (as of revision
September 1981) in the listing on page 36, point 1:
"1. If the connection does not exist (CLOSED) then a reset is sent
in response to any incoming segment except another reset. ..."

Why?

This modification is targeted to network protocol developers,
testers and problem investigators. When new protocols on top of
the TCP stack are developed using raw sockets, the incoming
packets nevertheless go through the kernel TCP stack, if the
PROTOCOL field in the IP packet is set to 0x06 = TCP. Since in
such situations there is no socket, which has been opened in the
normal way - using connect or bind, the kernel does not know
where to send these incoming packets and discards them and also
sends the aforementioned RST packet. This packet interferes with
the protocol development and it is meaningful to have the option
to disable its generation.

In another scenario, software and/or security testers often need
to validate the correctness of software implementation. They can
create an unusual situation by disabling the TCP RST packet and
observe how the software under test performs in such situations.

How?

1. Define a new element inside include/uapi/linux/sysctl.h for
   the /proc/sys/net/ipv4 enum.
2. Define a new variable to hold the value of the sysctl
   parameter inside include/net/netns/ipv4.h for the netns_ipv4
   struct.
3. Modify the control table named ipv4_table inside net/ipv4/
   sysctl_net_ipv4.c, by adding the procname
   tcp_disable_rst_unkn_socket. Point it to the variable defined
   in point 2 above and limit its values to either 0 or 1 by
   using proc_douintvec_minmax with SYSCTL_ZERO and SYSCTL_ONE as
   extra1 and extra2.
4. Create a definition for the default value of 0 inside include/
   net/tcp.h
5. In the tcp_sk_init function in net/ipv4/tcp_ipv4.c assign the
   default value to the variable defined in point 2.
6. In the same file place the call to tcp_v4_send_reset inside
   the function tcp_v4_rcv inside an if, which checks the value
   of the variable defined in point 2.

Signed-off-by: Mihail Milev <mmilev_ml@icloud.com>
---
 include/net/netns/ipv4.h    | 1 +
 include/net/tcp.h           | 5 +++++
 include/uapi/linux/sysctl.h | 1 +
 net/ipv4/sysctl_net_ipv4.c  | 9 +++++++++
 net/ipv4/tcp_ipv4.c         | 6 +++++-
 5 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 9e36738c1fe1..1d74959ff6fe 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -177,6 +177,7 @@ struct netns_ipv4 {
 	struct inet_timewait_death_row tcp_death_row;
 	int sysctl_max_syn_backlog;
 	int sysctl_tcp_fastopen;
+	unsigned int sysctl_tcp_disable_rst_unkn_socket;
 	const struct tcp_congestion_ops __rcu  *tcp_congestion_control;
 	struct tcp_fastopen_context __rcu *tcp_fastopen_ctx;
 	spinlock_t tcp_fastopen_ctx_lock;
diff --git a/include/net/tcp.h b/include/net/tcp.h
index eab6c7510b5b..cdd46be2cc94 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -241,6 +241,11 @@ void tcp_time_wait(struct sock *sk, int state, int timeo);
  */
 #define	TFO_SERVER_WO_SOCKOPT1	0x400
 
+/* The default value is 0 = do not disable the RST packet, when a packet
+ * for an unknown socket comes in.
+ */
+#define TCP_DISABLE_RST_UNKN_SOCKET 0
+
 
 /* sysctl variables for tcp */
 extern int sysctl_tcp_max_orphans;
diff --git a/include/uapi/linux/sysctl.h b/include/uapi/linux/sysctl.h
index 27c1ed2822e6..79fa12dd2110 100644
--- a/include/uapi/linux/sysctl.h
+++ b/include/uapi/linux/sysctl.h
@@ -426,6 +426,7 @@ enum
 	NET_TCP_ALLOWED_CONG_CONTROL=123,
 	NET_TCP_MAX_SSTHRESH=124,
 	NET_TCP_FRTO_RESPONSE=125,
+	NET_IPV4_TCP_DISABLE_RST_UNKN_SOCKET=126,
 };
 
 enum {
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 54023a46db04..304bbaaac94f 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -588,6 +588,15 @@ static struct ctl_table ipv4_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_do_static_key,
 	},
+	{
+		.procname	= "tcp_disable_rst_unkn_socket",
+		.data		= &init_net.ipv4.sysctl_tcp_disable_rst_unkn_socket,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_douintvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
 	{ }
 };
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 80b42d5c76fe..1a5a9ad84dd1 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2049,7 +2049,9 @@ int tcp_v4_rcv(struct sk_buff *skb)
 bad_packet:
 		__TCP_INC_STATS(net, TCP_MIB_INERRS);
 	} else {
-		tcp_v4_send_reset(NULL, skb);
+		if(!net->ipv4.sysctl_tcp_disable_rst_unkn_socket) {
+			tcp_v4_send_reset(NULL, skb);
+		}
 	}
 
 discard_it:
@@ -2894,6 +2896,8 @@ static int __net_init tcp_sk_init(struct net *net)
 	else
 		net->ipv4.tcp_congestion_control = &tcp_reno;
 
+	net->ipv4.sysctl_tcp_disable_rst_unkn_socket = TCP_DISABLE_RST_UNKN_SOCKET;
+
 	return 0;
 fail:
 	tcp_sk_exit(net);
-- 
2.25.1

