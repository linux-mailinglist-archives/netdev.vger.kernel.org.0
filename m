Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA521B2695
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 14:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbgDUMqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 08:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726628AbgDUMqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 08:46:21 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0E4C061A10
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 05:46:20 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id p25so6535585pfn.11
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 05:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ejp10WfwO87H34zTieBKXiUSbiSed9ZAth27A6USfXQ=;
        b=NXPLAVNWDljgfgcCZwj+30SSwpmUPe77D2cF6VHEfAPhw3Qov8bxCsBLQXqQ5EDl6K
         dRP+ce9zKOSlpkwBGeuGFtfTOcDR975DNPXPOmrpRaHtzUeOcUM7AmbD5QFJwJ83wcQ+
         OaT2nc/kyyPFe6PlVRZt/HObOC/8jJMB+T9Nfdi0JFjUHC+k048SRfhkciqobyTFwN9O
         aITUZC5xhTz5KkcENIDJCHLMq4z41W3T+4gExxl6jwnQYc8XM9yOeI4OH51AANSxfTlW
         EQC6ppibxW2MZ/Pqsqi4NJLnIXibFCXI90xfj5agDWAKz30oZ+bP78HBTHHKKLE4ANbf
         GMKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ejp10WfwO87H34zTieBKXiUSbiSed9ZAth27A6USfXQ=;
        b=lu0QUpZlzcHe8tdX6n759+QCJ/tZzxmgiE+IG4ORoG1VHR9uqoRnTY/L+S95YnihDt
         EKaW+1hx2j7QJbdYxs5Cum6iiM6A7JU2QXP5iIO9ZFDdmyVVe75f3i3Cf4x7ZDkuh1nW
         feBK9wYJkqnZ9peJ6+5HSm3LVXpRId/frKaIWB/YGBxhw4lOBCUaTmrw0hqm6ccn0WlQ
         1DC4qmbK//tnzXaR1Kf6KURZDaic4XMiRj4OhmTYw+1yWPsHRuzZ+DeRhKe2AWGx1K+o
         Mek18zERN6pjA+SoH/9wt449muAWsHUOOuu05gC9yPdYa3yTsPFDEWX+V2ZCV2U/0EGT
         tfFg==
X-Gm-Message-State: AGi0PuZ79WYicMQVAjS7KCgr3Qif2cpZR+cmDgfgGu2Um+laWEjIXrYH
        EE/Ct6L0gXI9nYkfleY1q22fOAKW
X-Google-Smtp-Source: APiQypL/TLLWQWwNeR8C7Y1u4BKCbmEEA3NcOZuprpFeD+4XiGAhD65T9NA2lHi2poy4bW3letshAw==
X-Received: by 2002:a05:6a00:2cf:: with SMTP id b15mr21309440pft.174.1587473179452;
        Tue, 21 Apr 2020 05:46:19 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o63sm2441448pjb.40.2020.04.21.05.46.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Apr 2020 05:46:18 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Su Yanjun <suyj.fnst@cn.fujitsu.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec] ip_vti: receive ipip packet by calling ip_tunnel_rcv
Date:   Tue, 21 Apr 2020 20:46:11 +0800
Message-Id: <ce41ba7497a377260905d75349aeb8f6cc803e20.1587473171.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 net/ipv4/ip_vti.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 1b4e6f2..1dda7c1 100644
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
2.1.0

