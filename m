Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DF41E7B4B
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 13:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgE2LKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 07:10:45 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:39908 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726167AbgE2LKo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 07:10:44 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B7E5A205E5;
        Fri, 29 May 2020 13:10:42 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id UEP4zPNxmfYp; Fri, 29 May 2020 13:10:42 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id D66DE205CD;
        Fri, 29 May 2020 13:10:41 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 29 May 2020 13:10:41 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 29 May
 2020 13:10:40 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 3747A31806E8;
 Fri, 29 May 2020 13:04:12 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 10/15] ip_vti: receive ipip packet by calling ip_tunnel_rcv
Date:   Fri, 29 May 2020 13:04:03 +0200
Message-ID: <20200529110408.6349-11-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200529110408.6349-1-steffen.klassert@secunet.com>
References: <20200529110408.6349-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

In Commit dd9ee3444014 ("vti4: Fix a ipip packet processing bug in
'IPCOMP' virtual tunnel"), it tries to receive IPIP packets in vti
by calling xfrm_input(). This case happens when a small packet or
frag sent by peer is too small to get compressed.

However, xfrm_input() will still get to the IPCOMP path where skb
sec_path is set, but never dropped while it should have been done
in vti_ipcomp4_protocol.cb_handler(vti_rcv_cb), as it's not an
ipcomp4 packet. This will cause that the packet can never pass
xfrm4_policy_check() in the upper protocol rcv functions.

So this patch is to call ip_tunnel_rcv() to process IPIP packets
instead.

Fixes: dd9ee3444014 ("vti4: Fix a ipip packet processing bug in 'IPCOMP' virtual tunnel")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/ip_vti.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 1b4e6f298648..1dda7c155c48 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -93,7 +93,28 @@ static int vti_rcv_proto(struct sk_buff *skb)
 
 static int vti_rcv_tunnel(struct sk_buff *skb)
 {
-	return vti_rcv(skb, ip_hdr(skb)->saddr, true);
+	struct ip_tunnel_net *itn = net_generic(dev_net(skb->dev), vti_net_id);
+	const struct iphdr *iph = ip_hdr(skb);
+	struct ip_tunnel *tunnel;
+
+	tunnel = ip_tunnel_lookup(itn, skb->dev->ifindex, TUNNEL_NO_KEY,
+				  iph->saddr, iph->daddr, 0);
+	if (tunnel) {
+		struct tnl_ptk_info tpi = {
+			.proto = htons(ETH_P_IP),
+		};
+
+		if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb))
+			goto drop;
+		if (iptunnel_pull_header(skb, 0, tpi.proto, false))
+			goto drop;
+		return ip_tunnel_rcv(tunnel, skb, &tpi, NULL, false);
+	}
+
+	return -EINVAL;
+drop:
+	kfree_skb(skb);
+	return 0;
 }
 
 static int vti_rcv_cb(struct sk_buff *skb, int err)
-- 
2.17.1

