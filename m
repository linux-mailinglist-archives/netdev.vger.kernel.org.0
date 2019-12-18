Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36ED7124636
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 12:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfLRLyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 06:54:02 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34575 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbfLRLyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 06:54:02 -0500
Received: by mail-pg1-f194.google.com with SMTP id r11so1174833pgf.1
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 03:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QdkaOVsoAFoVyxfzVxITXMwt3y0ntQQxMzH7sOqTxfA=;
        b=ibUiLvHtoTXpoNpFrr7uauQsBAA81zzvpL8UgI8NAxE9RvJWahoGrr2byQrzxGOOdO
         J80R8huO9lAW9SmDESubVV71xJ0PsTWWR5TvPNLldQhRu99N3elnSwhCthSVmFwHO0QN
         5vHUZczWYEgKsytIqSWmJdZTXlZoEapdSwGSJ3fpXNa3v7AUwXT6FabbxJ5p7pV+Ts2P
         eu6kfs6v/O70hb/s8DrrXUQHCjqqy5nUBeCvj/cAtUG3pvtV2ISMztmeikFvrZsIHymR
         ZU5FOkq8I+23FAY6ngrCMNh4V1f4tJjvZk70D2ueKYCo3umWNnpzkVT8QLoxhzA+d4EP
         1oOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QdkaOVsoAFoVyxfzVxITXMwt3y0ntQQxMzH7sOqTxfA=;
        b=OrpIT3pM7DrkatS/zURiTHKTUKUgQPxwGK/xlV7jYOVPAUNydvVcOJW0vZZ7R6opvP
         MMxaQhJozfBdU0zxsD9GXIgGwxksz8KlRwrDiRyRjgD7uxwJbCxASv9zjW7kYa5OVfwh
         lpFDQsvYc2mlFL0M2YSA9JeY0LSQolChBoESN7ba9+M0swwtdVlxeYpcq+s7gB9JZd77
         qVELIhkZuC0U23Y2DqB0cXWj1GByvBowo0ySWrqoTsYt/t1WRK7KeaP9gtOeSiZHo6JT
         uYapYI0DVlUK2LYG0CHU1aIVzo4kYbmEy0rxUWQLAVzeKyRFc1hzjglHEz1QcnQeqfKB
         DYcQ==
X-Gm-Message-State: APjAAAVcdqyedq2g+d1OZFJunThA9SDwJx6g3dle9gW+XIziPAwoI4yd
        0o1cYEKe2QELM0WMgQ+ZLPVFslw7A7Y=
X-Google-Smtp-Source: APXvYqywEzuiZoDTZBYZ02swoK1PRJNpLJ/OiU7oE1fj91eCD2yOHB0ulRk5FE67Q9WIsLeHrKWI9g==
X-Received: by 2002:a65:4501:: with SMTP id n1mr2557404pgq.336.1576670041087;
        Wed, 18 Dec 2019 03:54:01 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x33sm2961067pga.86.2019.12.18.03.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 03:54:00 -0800 (PST)
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
Subject: [PATCH net-next 5/8] tunnel: do not confirm neighbor when do pmtu update
Date:   Wed, 18 Dec 2019 19:53:10 +0800
Message-Id: <20191218115313.19352-6-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191218115313.19352-1-liuhangbin@gmail.com>
References: <20191203021137.26809-1-liuhangbin@gmail.com>
 <20191218115313.19352-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When do IPv6 tunnel PMTU update and calls __ip6_rt_update_pmtu() in the end,
we should not call dst_confirm_neigh() as there is no two-way communication.

Although ipv4 tunnel is not affected as __ip_rt_update_pmtu() does not call
dst_confirm_neigh(), we still not do neigh confirm to keep consistency with
IPv6 code.

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

