Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 935CE128C62
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 03:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfLVCvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 21:51:54 -0500
Received: from mail-pj1-f44.google.com ([209.85.216.44]:39776 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbfLVCvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 21:51:54 -0500
Received: by mail-pj1-f44.google.com with SMTP id t101so5895719pjb.4
        for <netdev@vger.kernel.org>; Sat, 21 Dec 2019 18:51:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k/8b52iOiNqJSzu1d2qra78LN3BCpDQ3S+5D3mFVV1Q=;
        b=FcZqfZtwrsSpY87oXyAG/OgXD80bV/l5Or6ZvN4Cxhn/kgDH7NPNcet5+fQIlFxWeU
         ttTms6vslSn1dgkvGImBOGJ5SF6NLG2P4IraPsxv9q14QutlJ3tT08S5gKRqz2oWOpD/
         MgNJ/a4Sa6gCj0+HEHt+rqzmmulLVb4r950TGN9w8mMyjazoElD3EJ3GFmetFype7Haf
         tiUPgmMKdoYdUw47LjhTwBeq5Y7e+M6QKAi+JV/oiCPsmKplQXBDgsijvS7K3g1SrR7G
         LMS0pVan+70gxae6eWPHuO7uFImRruo59uhh/DoAaf090ZUXWdJFS8ZSqfxnyC00zvb3
         mMRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k/8b52iOiNqJSzu1d2qra78LN3BCpDQ3S+5D3mFVV1Q=;
        b=boY7xo7i6ORZm2KIje5gedeiut0+s88qNCeQ1W5E0uom951zs2YK+8pvM4WnokQso4
         iN4Un3JNBojH96Gt8GS7URzLyH7HZGAidjgO2Ujgy+nn785kvsFNPIDtOFs8gMQtg6aH
         gfdjtSYBDUdqp+QfaQUOviDppQeMxjWN09+tFbAGB6KEcpRm7pVtEB/EoQKgF5GQo2CN
         hPvgygiirSXAAEpK9YN+VXD5gqpfW+OgM8vkLn9wb+jwIFp+qNVUiRB8GA/sAtXfJ1pI
         FGdJnUKC3IFP9Q/PJ9bAQIiJNJpSIr/ovg9Nqs/dHfS8UzY+roASVIsk7XU51yk6C75v
         NH1A==
X-Gm-Message-State: APjAAAW/nsLiyEELH9a6esxjzMQzWNJbLFdWg5I/opyCH9QTudPiiHsK
        kLqpG2XLRfcex2AT2T3xwJw0C5erM00=
X-Google-Smtp-Source: APXvYqwm7VTpI7UELPVOQnBJPVwYPGVXJHpqh9fOL5w3O1k0P6ry01GBu/PTepwSBhdRyi8kcL6+lQ==
X-Received: by 2002:a17:902:b901:: with SMTP id bf1mr23781164plb.283.1576983113432;
        Sat, 21 Dec 2019 18:51:53 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k9sm1866775pjo.19.2019.12.21.18.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 18:51:53 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Julian Anastasov <ja@ssi.bg>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Pablo Neira <pablo@netfilter.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexey Kodanev <alexey.kodanev@oracle.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv5 net 5/8] tunnel: do not confirm neighbor when do pmtu update
Date:   Sun, 22 Dec 2019 10:51:13 +0800
Message-Id: <20191222025116.2897-6-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191222025116.2897-1-liuhangbin@gmail.com>
References: <20191220032525.26909-1-liuhangbin@gmail.com>
 <20191222025116.2897-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When do tunnel PMTU update and calls __ip6_rt_update_pmtu() in the end,
we should not call dst_confirm_neigh() as there is no two-way communication.

v5: No Change.
v4: Update commit description
v3: Do not remove dst_confirm_neigh, but add a new bool parameter in
    dst_ops.update_pmtu to control whether we should do neighbor confirm.
    Also split the big patch to small ones for each area.
v2: Remove dst_confirm_neigh in __ip6_rt_update_pmtu.

Fixes: 0dec879f636f ("net: use dst_confirm_neigh for UDP, RAW, ICMP, L2TP")
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Tested-by: Guillaume Nault <gnault@redhat.com>
Acked-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv4/ip_tunnel.c  | 2 +-
 net/ipv6/ip6_tunnel.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 38c02bb62e2c..0fe2a5d3e258 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -505,7 +505,7 @@ static int tnl_update_pmtu(struct net_device *dev, struct sk_buff *skb,
 		mtu = skb_valid_dst(skb) ? dst_mtu(skb_dst(skb)) : dev->mtu;
 
 	if (skb_valid_dst(skb))
-		skb_dst_update_pmtu(skb, mtu);
+		skb_dst_update_pmtu_no_confirm(skb, mtu);
 
 	if (skb->protocol == htons(ETH_P_IP)) {
 		if (!skb_is_gso(skb) &&
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 754a484d35df..2f376dbc37d5 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -640,7 +640,7 @@ ip4ip6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 		if (rel_info > dst_mtu(skb_dst(skb2)))
 			goto out;
 
-		skb_dst_update_pmtu(skb2, rel_info);
+		skb_dst_update_pmtu_no_confirm(skb2, rel_info);
 	}
 
 	icmp_send(skb2, rel_type, rel_code, htonl(rel_info));
@@ -1132,7 +1132,7 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 	mtu = max(mtu, skb->protocol == htons(ETH_P_IPV6) ?
 		       IPV6_MIN_MTU : IPV4_MIN_MTU);
 
-	skb_dst_update_pmtu(skb, mtu);
+	skb_dst_update_pmtu_no_confirm(skb, mtu);
 	if (skb->len - t->tun_hlen - eth_hlen > mtu && !skb_is_gso(skb)) {
 		*pmtu = mtu;
 		err = -EMSGSIZE;
-- 
2.19.2

