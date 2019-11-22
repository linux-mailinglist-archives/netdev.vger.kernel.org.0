Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 821201064CC
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729406AbfKVGTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 01:19:37 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36933 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728971AbfKVGTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 01:19:35 -0500
Received: by mail-pf1-f196.google.com with SMTP id p24so2983415pfn.4
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 22:19:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SAWYz9Wrob3MYFJdWQnJNXci4p36nTV8hDr1KIREL2g=;
        b=TrErOBhccbrlzlq8Gd9KISuzngnj7JJ0ZpaNoujHdkFko7MPMSHHtkAZpQhbyFmjmp
         GzSZ3ZBmzu6C076rPRqLjZZQuB6d+xn/XM/vA/85os/z/fKk7n24puSntGmCW7/aI+4I
         nH+vibHUZwjI2wZTL2bAaMU5GgdijQeuJhtElrDbS9JmnkZAOOfI6NuAKTFmWPkvDKaG
         AqyjozudtXgIGZVWhssCGYOq0gIDIfgZw+GF0MnlezW205f9t+/kfeqTD8R5SMJqmAs6
         NyWb+L1ztKddnwG1J/rsgr+B1s/VpopUA1pXpug4uOiNfoUYXIquOMMavCfLiWzVx6X1
         Ko3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SAWYz9Wrob3MYFJdWQnJNXci4p36nTV8hDr1KIREL2g=;
        b=Rmb+EpKG0hduVxy9FBqK5SSe+MBuad+yxicGrO9eYFZNKiHXCE4Vefw9rY99fEXEDX
         hJotsOTUntbc0yzJTvZmezE5ylSkr/o+gGyXrb0+9bwVOoZpw+ObZVlDwTaTuBtby0d9
         lZiQZDsjFL20BW+pRaLz7NvDc8MWn3e1bJLM3t7co1kzycvm2mFa1+KTvKO+GbFumq3h
         LqLiAB0sVNMtjm0nDZNWrLkKuLQyWthW+WxImzKzqKy1PsYrj3Xe5D1EtEXxctus5d4X
         lskdC5mobK7E0ohzD+9EZDO2fQqh74c36V4yGUW/SEIUHKa7s+n20gWFuVT4go1uR8OG
         JM4A==
X-Gm-Message-State: APjAAAUON5m1q0VkOEcaT5cJYLl2ZxJmGMuo2q6RwpkMoVF0NnzapqA0
        CC70R8XH6LwGC4jy4F3Wj6ZR21TlL8A=
X-Google-Smtp-Source: APXvYqxSi01uZ4ocq2nxwlbumxnuZUeNzL62MDbU1tfi5B4LIhXNtwGaAbu/SR/C6CD13gPAYi1VPQ==
X-Received: by 2002:aa7:93a7:: with SMTP id x7mr15528323pff.36.1574403574506;
        Thu, 21 Nov 2019 22:19:34 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b200sm5914279pfb.86.2019.11.21.22.19.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 22:19:33 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Julian Anastasov <ja@ssi.bg>,
        "David S . Miller" <davem@davemloft.net>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] ipv6/route: only update neigh confirm time if pmtu changed
Date:   Fri, 22 Nov 2019 14:19:19 +0800
Message-Id: <20191122061919.26157-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we setup a pair of gretap, ping each other and create neighbour cache.
Then delete and recreate one side. We will never be able to ping6 to the new
created gretap.

The reason is when we ping6 remote via gretap, we will call like

gre_tap_xmit()
 - ip_tunnel_xmit()
   - tnl_update_pmtu()
     - skb_dst_update_pmtu()
       - ip6_rt_update_pmtu()
         - __ip6_rt_update_pmtu()
           - dst_confirm_neigh()
             - ip6_confirm_neigh()
               - __ipv6_confirm_neigh()
                 - n->confirmed = now

As the confirmed time updated, in neigh_timer_handler() the check for
NUD_DELAY confirm time will pass and the neigh state will back to
NUD_REACHABLE. So the old/wrong mac address will be used again.

If we do not update the confirmed time, the neigh state will go to
neigh->nud_state = NUD_PROBE; then go to NUD_FAILED and re-create the
neigh later, which is what IPv4 does.

Fix it by reordering the dst_confirm_neigh() and only update it when
pmtu changed.

Fixes: 0dec879f636f ("net: use dst_confirm_neigh for UDP, RAW, ICMP, L2TP")
Reported-by: Jianlin Shi <jishi@redhat.com>
Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv6/route.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 3f83ea851ebf..6fbef61b8f64 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2713,11 +2713,12 @@ static void __ip6_rt_update_pmtu(struct dst_entry *dst, const struct sock *sk,
 		daddr = NULL;
 		saddr = NULL;
 	}
-	dst_confirm_neigh(dst, daddr);
 	mtu = max_t(u32, mtu, IPV6_MIN_MTU);
 	if (mtu >= dst_mtu(dst))
 		return;
 
+	dst_confirm_neigh(dst, daddr);
+
 	if (!rt6_cache_allowed_for_pmtu(rt6)) {
 		rt6_do_update_pmtu(rt6, mtu);
 		/* update rt6_ex->stamp for cache */
-- 
2.19.2

