Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A95C29274B
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 14:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgJSM1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 08:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727666AbgJSM1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 08:27:22 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1825FC0613CE;
        Mon, 19 Oct 2020 05:27:22 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id y14so5904950pfp.13;
        Mon, 19 Oct 2020 05:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=zpcgNpTt1Eopd9QaDKGy8sWqns6Rwfi4+2UKE6Sn+wQ=;
        b=EnR/t6Yefl4ynppM/Pt6u5FR1UyrGnGg/6sh/Cdzd5DBzocLVy1Nc7oEUyTxa4Z7QG
         LpyrkAaGEUC0pJzIvQAMP6qfzESXbD/EBORKE/QytC+ZT9M2GKEIimiRefjqCXUnm9Gs
         nDS4QgHyOg2hXmGCRNvzBBDmiYIttvliDkzMghiwr+F7GZnfhcu5b6LHaiS0E3tHhhyD
         1YGMKGVfrgaMrA9lMJob4osVoN7ClLLpm2WC2fhwf6F62s5rc6drMbP9avClI+Oc8BUw
         64Av6xPyO7zcOd2ZXF0AdCuxqk26AOZEipQkgpmDHGU6mExTPLkx0cGFtN+QYfQUHrM3
         ECWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=zpcgNpTt1Eopd9QaDKGy8sWqns6Rwfi4+2UKE6Sn+wQ=;
        b=W3+Mdvce1au+VoZYHjMF+Luruc8ms5PWNc4LqYYzmAnzWtYQjJXLoDT/+jXbd7n2GE
         lUKYvbFd4AOVRx8qebsixKbjwG1LtTr5AVVDnkh+TFHm111TZ8PUnBZXvRRShFf67wp6
         mFEc83HQBhV1MBd21snkO2gtkjRh/NFZeSaM+aDm6yBzjRknComw6Sn19i5oT7iybzmj
         A8VjSHwMHi/SIuNPa4oPvmCxSCdXvfkltT5r0oH+uOLCuJhARyIiq6gJb6Pj1yE8EoCf
         IsBnLQUGIxEMq6nVP/H7qchaZDU66XouGZsRfbB3v3EDe9brXyJC7xaSyM9yLi3WbHcT
         LStg==
X-Gm-Message-State: AOAM532vKdK9Ch/PyC2DibjYZxhODc5LRPwiVZ7sDQKkaMGMIMN2EOEB
        yHOMoztDu9GcLUXvjAC5yeZN2FpiQ6g=
X-Google-Smtp-Source: ABdhPJyPocIw1l8i+r2wkfmTucmipKkjcna1qVo0575izXjVJ1EokZ5RtjzmqCGk6JJhL5udCmqxsQ==
X-Received: by 2002:a62:6202:0:b029:15c:dac8:866 with SMTP id w2-20020a6262020000b029015cdac80866mr7896296pfb.72.1603110441368;
        Mon, 19 Oct 2020 05:27:21 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s126sm11985641pgc.27.2020.10.19.05.27.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Oct 2020 05:27:20 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCHv4 net-next 13/16] sctp: support for sending packet over udp6 sock
Date:   Mon, 19 Oct 2020 20:25:30 +0800
Message-Id: <15f6150aa59acd248129723df647d55ea1169d85.1603110316.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <2cac0eaff47574dbc07a4a074500f5e0300cff3e.1603110316.git.lucien.xin@gmail.com>
References: <cover.1603110316.git.lucien.xin@gmail.com>
 <71b3af0fb347f27b5c3bf846dbd34485d9f80af0.1603110316.git.lucien.xin@gmail.com>
 <de3a89ece8f3abd0dca08064d9fc4d36ca7ddba2.1603110316.git.lucien.xin@gmail.com>
 <5f06ac649f4b63fc5a254812a963cada3183f136.1603110316.git.lucien.xin@gmail.com>
 <e99845af51be8fdaa53a2575e8967b8c3c8d423a.1603110316.git.lucien.xin@gmail.com>
 <7a2f5792c1a428c16962fff08b7bcfedc21bd5e2.1603110316.git.lucien.xin@gmail.com>
 <7cfd72e42b8b1cde268ad4062c96c08a56c4b14f.1603110316.git.lucien.xin@gmail.com>
 <d55a0eaefa4b8a671e54535a1899ea4c00bc2de8.1603110316.git.lucien.xin@gmail.com>
 <25013493737f5b488ce48c38667a077ca6573dd5.1603110316.git.lucien.xin@gmail.com>
 <fe0630fd48830058df1bfdd53a9e6b9fbf83b498.1603110316.git.lucien.xin@gmail.com>
 <8547ef8c7056072bdeca8f5e9eb0d7fec5cdb210.1603110316.git.lucien.xin@gmail.com>
 <e8d627d45c604460c57959a124b21aaeddfb3808.1603110316.git.lucien.xin@gmail.com>
 <2cac0eaff47574dbc07a4a074500f5e0300cff3e.1603110316.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1603110316.git.lucien.xin@gmail.com>
References: <cover.1603110316.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This one basically does the similar things in sctp_v6_xmit as does for
udp4 sock in the last patch, just note that:

  1. label needs to be calculated, as it's the param of
     udp_tunnel6_xmit_skb().

  2. The 'nocheck' param of udp_tunnel6_xmit_skb() is false, as
     required by RFC.

v1->v2:
  - Use sp->udp_port instead in sctp_v6_xmit(), which is more safe.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/ipv6.c | 43 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 11 deletions(-)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index a064bf2..814754d 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -55,6 +55,7 @@
 #include <net/inet_common.h>
 #include <net/inet_ecn.h>
 #include <net/sctp/sctp.h>
+#include <net/udp_tunnel.h>
 
 #include <linux/uaccess.h>
 
@@ -191,33 +192,53 @@ static int sctp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
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
 
 	SCTP_INC_STATS(sock_net(sk), SCTP_MIB_OUTSCTPPACKS);
 
-	rcu_read_lock();
-	res = ip6_xmit(sk, skb, fl6, sk->sk_mark, rcu_dereference(np->opt),
-		       tclass, sk->sk_priority);
-	rcu_read_unlock();
-	return res;
+	if (!t->encap_port || !sctp_sk(sk)->udp_port) {
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
+	label = ip6_make_flowlabel(sock_net(sk), skb, fl6->flowlabel, true, fl6);
+
+	return udp_tunnel6_xmit_skb(dst, sk, skb, NULL, &fl6->saddr,
+				    &fl6->daddr, tclass, ip6_dst_hoplimit(dst),
+				    label, sctp_sk(sk)->udp_port, t->encap_port, false);
 }
 
 /* Returns the dst cache entry for the given source and destination ip
-- 
2.1.0

