Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E08A10F4DA
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 03:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbfLCCLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 21:11:55 -0500
Received: from mail-pl1-f180.google.com ([209.85.214.180]:46161 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfLCCLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 21:11:55 -0500
Received: by mail-pl1-f180.google.com with SMTP id k20so966109pll.13
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 18:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NP1bNkObOs13ITLFCws6hG1aWUJGw+J1euJGu+MNLxw=;
        b=GV3/pKbNTKb4cb1LWhMsbvWr0Qa0wQX93QyRoa6maMbvpFMHX282cUdL8HheGdb+Tg
         CSHDn4zXU3kYaWwRSeYtV5eSA8iQyXTYosnw6aDA9FS5Z7xhGsvhc8mnO3YpFpnCIe7u
         38IHXXxrUXfHvmIGNT4ueJDNOwCfXoEVDMxJzFsDQ5DTPeV1vRjR9RWxcEGQcP/5uQKH
         +qz2ZB8JX/yoTpjkexSgGPX476oPS0PIJ4w5KHLJXviEThDBrMiewVXtPiyAwaSYXS0B
         bWyFvB7WcHvyz8/Qt0U49LE5fUdFmkY3/RV5z86yf/7v+AzqdWBlhrM4ns97RMAfjCu5
         mJhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NP1bNkObOs13ITLFCws6hG1aWUJGw+J1euJGu+MNLxw=;
        b=fw+4eLq+LwnFJjGIuqP5e5qgZfgCiwqBPCRc+LTcO/33p7Jg/3/ZBJp2S+vFuU/8r0
         MxGcWUUSSoKzh4H04iZXFObGCPVo7vkmpCzTA7aW+aL9FIA2f4tkNtOfQA7OdoBo+WEU
         WFpmIhY7j2qt7Ty8ph0VOHqOEMaMEFALkUtHnyrPnCg7OYNTA7riWcj2OSyzi7fzx9i1
         iDAluCv5DeevsEdKnP7E6/wNv5ZWTojC/YBNAlOXDXNLJjZGPKlcEt0RvAvwjgLOV+UC
         tbVUoJ3kAt0STYpJpQIX+12lFa64e2Q4GadXvFteHDZKu5z0E6abSxIexzDEI4bvZET8
         B2Hg==
X-Gm-Message-State: APjAAAVLs1gd3XjGXh8etZBSgua+qMQb8DSlldfQytZtVWANsr9ZbVEf
        M3kxTbSRdqC3A9DQ/NGsAz/XMnC8zChm1Q==
X-Google-Smtp-Source: APXvYqwD7n4MtJ3wDx7BLQ5ySiv0cLMh2vETUiANdJO7ZEjwF8XsuaKZslmEF8ii2jiZX8XfFNviXw==
X-Received: by 2002:a17:902:be02:: with SMTP id r2mr2535126pls.76.1575339114401;
        Mon, 02 Dec 2019 18:11:54 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v10sm908556pgr.37.2019.12.02.18.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 18:11:53 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Julian Anastasov <ja@ssi.bg>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net] ipv6/route: should not update neigh confirm time during PMTU update
Date:   Tue,  3 Dec 2019 10:11:37 +0800
Message-Id: <20191203021137.26809-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191122061919.26157-1-liuhangbin@gmail.com>
References: <20191122061919.26157-1-liuhangbin@gmail.com>
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

Fix it by removing the dst_confirm_neigh() in __ip6_rt_update_pmtu() as
there is no two-way communication during PMTU update.

v2: remove dst_confirm_neigh directly as David Miller pointed out.

Fixes: 0dec879f636f ("net: use dst_confirm_neigh for UDP, RAW, ICMP, L2TP")
Reported-by: Jianlin Shi <jishi@redhat.com>
Suggested-by: David Miller <davem@davemloft.net>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv6/route.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index b59940416cb5..335ed36a5c78 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2710,7 +2710,6 @@ static void __ip6_rt_update_pmtu(struct dst_entry *dst, const struct sock *sk,
 		daddr = NULL;
 		saddr = NULL;
 	}
-	dst_confirm_neigh(dst, daddr);
 	mtu = max_t(u32, mtu, IPV6_MIN_MTU);
 	if (mtu >= dst_mtu(dst))
 		return;
-- 
2.19.2

