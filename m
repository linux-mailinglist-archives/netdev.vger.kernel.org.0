Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECDD27CFEC
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 15:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730757AbgI2NvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 09:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728367AbgI2NvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 09:51:24 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1741C061755;
        Tue, 29 Sep 2020 06:51:23 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id a9so2711321pjg.1;
        Tue, 29 Sep 2020 06:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=OHJXMkcYNxQ8jVivOpoiy0ndt2mH0O/0WP8+Tt4Q51o=;
        b=fFucPKxSCAwk2Uh0M/DsQImF07xfmlUNmbZ67rTyRZ6Mcex/afmC9AftphuwLc5cBX
         KNTYTTCuFtWRK0gZeJxXG+DZIw/wSYmBySO/TtLrt+nGjsWSQMKojfrGWJH132Ndf70L
         Ml+KiNcq2EW87DNxMHu+WmKjU2NTy/t1xPeZJ1XDb3r9sClWRG7cnn8ItZ9onuYNB3Lz
         /l31i9A9Sw7O7MLfFZ2VxqaEr5Z+LN/A6MFUc3lfjwTrWpbrOM8beLNel0fTfLM2cRT9
         8TwZ9WyQyo3JKSwVuRFD3g8wzWTMBmwPyK0XVzXap3GZq5tlOAcSB2hE0mV/kHDnPbAe
         0g0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=OHJXMkcYNxQ8jVivOpoiy0ndt2mH0O/0WP8+Tt4Q51o=;
        b=ZiXrDNkC+1ERHnVl2im8rSyWVjz+jtCaVB2WsxsMWKEOaDr64uhG55RnG8LYQCxdxk
         xIZSnZPnCFGNkMWXytlX6eWeoceXtKJ3Szmumk45sYuFRCeU5DkN/zinIKQ+0q0poPaU
         8Id46iOrUqIq6WWzbi6CXu3ln81bU0qWY5yhUt2mtJ1Q95U44D7Qt4fg/63aalaoiyr8
         yUfqDc+n1KRhdfLr2dBMcfPsFKg7ZiMRiipVgARbrgdQcnnfGo9QjjG7dhQbc+FrqIQr
         CwTVjjM+RCf5qaitm5B/CH+XM+2PPjUaIiPes41bn+Y6ksd4GnRZE13IaokbboJC1pi4
         /x3Q==
X-Gm-Message-State: AOAM533rNRk0UGKEPTyc15fNUmk1NVef7CIRaikUZYMY7YpwvbdL85p2
        OtgqfZhss/7bJ62JgAOGAK9A5B9m/eI=
X-Google-Smtp-Source: ABdhPJzFW1MLgb5nfCYumfjnRi2q5qd2wBH+sAHBcD5BRJOFiMkrsjQoIUoTTVfXJ7Y2wHbwD1eqAg==
X-Received: by 2002:a17:90a:8588:: with SMTP id m8mr3828792pjn.91.1601387482534;
        Tue, 29 Sep 2020 06:51:22 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u2sm4905725pji.50.2020.09.29.06.51.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Sep 2020 06:51:21 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        Tom Herbert <therbert@google.com>, davem@davemloft.net
Subject: [PATCH net-next 14/15] sctp: support for sending packet over udp6 sock
Date:   Tue, 29 Sep 2020 21:49:06 +0800
Message-Id: <6388faf30ca428c5026e5a62fdf484dcad7e0da2.1601387231.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <82b358f40c81cfdecbfc394113be40fd1f682043.1601387231.git.lucien.xin@gmail.com>
References: <cover.1601387231.git.lucien.xin@gmail.com>
 <51c1fdad515076f3014476711aec1c0a81c18d36.1601387231.git.lucien.xin@gmail.com>
 <65f713004ab546e0b6ec793572c72c1d0399f0fe.1601387231.git.lucien.xin@gmail.com>
 <49a1cbb99341f50304b514aeaace078d0b065248.1601387231.git.lucien.xin@gmail.com>
 <97963ca7171b92486f46477b55928182abe44806.1601387231.git.lucien.xin@gmail.com>
 <ddf990677d003f4d0be245b88f4b0f25d54f26d5.1601387231.git.lucien.xin@gmail.com>
 <ec4b75d8c69ba640a9104158ab875c4011cb533d.1601387231.git.lucien.xin@gmail.com>
 <f9f58a248df8194bbf6f4a83a05ec4e98d2955f1.1601387231.git.lucien.xin@gmail.com>
 <e1ff8bac558dd425b2f29044c3136bf680babcad.1601387231.git.lucien.xin@gmail.com>
 <ff57fb1ff7c477ff038cebb36e9f0554d26d5915.1601387231.git.lucien.xin@gmail.com>
 <3f1b88ab88b5cc5321ffe094bcfeff68a3a5ef2c.1601387231.git.lucien.xin@gmail.com>
 <7ff312f910ada8893fa4db57d341c628d1122640.1601387231.git.lucien.xin@gmail.com>
 <3716fc0699dc1d5557574b5227524e80b7fd76b8.1601387231.git.lucien.xin@gmail.com>
 <82b358f40c81cfdecbfc394113be40fd1f682043.1601387231.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1601387231.git.lucien.xin@gmail.com>
References: <cover.1601387231.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This one basically does the similar things in sctp_v6_xmit as does for
udp4 sock in the last patch, just note that:

  1. label needs to be calculated, as it's the param of
     udp_tunnel6_xmit_skb().

  2. The 'nocheck' param of udp_tunnel6_xmit_skb() is false, as
     required by RFC.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/ipv6.c | 47 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 35 insertions(+), 12 deletions(-)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index a064bf2..5c831f3 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -55,6 +55,7 @@
 #include <net/inet_common.h>
 #include <net/inet_ecn.h>
 #include <net/sctp/sctp.h>
+#include <net/udp_tunnel.h>
 
 #include <linux/uaccess.h>
 
@@ -191,33 +192,55 @@ static int sctp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	return ret;
 }
 
-static int sctp_v6_xmit(struct sk_buff *skb, struct sctp_transport *transport)
+static int sctp_v6_xmit(struct sk_buff *skb, struct sctp_transport *t)
 {
+	struct dst_entry *dst = dst_clone(t->dst);
+	struct flowi6 *fl6 = &t->fl.u.ip6;
 	struct sock *sk = skb->sk;
 	struct ipv6_pinfo *np = inet6_sk(sk);
-	struct flowi6 *fl6 = &transport->fl.u.ip6;
+	struct net *net = sock_net(sk);
 	__u8 tclass = np->tclass;
-	int res;
+	__be32 label;
 
 	pr_debug("%s: skb:%p, len:%d, src:%pI6 dst:%pI6\n", __func__, skb,
 		 skb->len, &fl6->saddr, &fl6->daddr);
 
-	if (transport->dscp & SCTP_DSCP_SET_MASK)
-		tclass = transport->dscp & SCTP_DSCP_VAL_MASK;
+	if (t->dscp & SCTP_DSCP_SET_MASK)
+		tclass = t->dscp & SCTP_DSCP_VAL_MASK;
 
 	if (INET_ECN_is_capable(tclass))
 		IP6_ECN_flow_xmit(sk, fl6->flowlabel);
 
-	if (!(transport->param_flags & SPP_PMTUD_ENABLE))
+	if (!(t->param_flags & SPP_PMTUD_ENABLE))
 		skb->ignore_df = 1;
 
-	SCTP_INC_STATS(sock_net(sk), SCTP_MIB_OUTSCTPPACKS);
+	SCTP_INC_STATS(net, SCTP_MIB_OUTSCTPPACKS);
 
-	rcu_read_lock();
-	res = ip6_xmit(sk, skb, fl6, sk->sk_mark, rcu_dereference(np->opt),
-		       tclass, sk->sk_priority);
-	rcu_read_unlock();
-	return res;
+	if (!t->encap_port || !net->sctp.udp_port) {
+		int res;
+
+		skb_dst_set(skb, dst);
+		rcu_read_lock();
+		res = ip6_xmit(sk, skb, fl6, sk->sk_mark,
+			       rcu_dereference(np->opt),
+			       tclass, sk->sk_priority);
+		rcu_read_unlock();
+		return res;
+	}
+
+	if (skb_is_gso(skb))
+		skb_shinfo(skb)->gso_type |= SKB_GSO_UDP_TUNNEL_CSUM;
+
+	skb->encapsulation = 1;
+	skb_reset_inner_mac_header(skb);
+	skb_reset_inner_transport_header(skb);
+	skb_set_inner_ipproto(skb, IPPROTO_SCTP);
+	label = ip6_make_flowlabel(net, skb, fl6->flowlabel, true, fl6);
+
+	return udp_tunnel6_xmit_skb(dst, sk, skb, NULL, &fl6->saddr,
+				    &fl6->daddr, tclass, ip6_dst_hoplimit(dst),
+				    label, htons(net->sctp.udp_port),
+				    htons(t->encap_port), false);
 }
 
 /* Returns the dst cache entry for the given source and destination ip
-- 
2.1.0

