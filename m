Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB85316833F
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 17:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgBUQ06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 11:26:58 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:34884 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbgBUQ06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 11:26:58 -0500
Received: by mail-pj1-f65.google.com with SMTP id q39so973512pjc.0;
        Fri, 21 Feb 2020 08:26:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=yAiMcPC8Fsdh3sF/o6bSGnkKQ3Dm47KWIMRyu7ofJ5A=;
        b=V49ASkJ+RyKiTpOQYTvgubqkotfVDwDU7UL+/N/g32CniyMwH3T4QowQc449sGC7+1
         VQ3V4Oo2ThQ/6dfjndNgZvhFQScyYw32BkolMuZiziwg6BwTU16kt0rG5+taJ12oHxDY
         8t19kXJuIKEhuzjkx3djfELiYCAYfoBwKC0CQ7qQ+yOtaBuxk+E4iD5K5oTvv2wbCLaL
         shq37+h+AG/s4gJxHOd+gWbL8cLDGkZXoJtBiJxuVQE5S9L0+aP5+adnA/+3E35LEcI1
         smTgNhnSWMFCIQ0WRXi4xYVMRov+K3osVzVWe7M05zE1N1IEZz/MLPTM6ikkp3yOGZFn
         LE2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yAiMcPC8Fsdh3sF/o6bSGnkKQ3Dm47KWIMRyu7ofJ5A=;
        b=fZepcdFCM2UZ55S6QvfxXEeVkEls+iKaxeLW66fCDnx83/6Y8yXLqlbMIco0p99GBg
         fbNMfTzP+0Y/fWMgTwBtnLsitqkYfK2UULeoA6FK3YL+X1e9D/bjaxtWb7/82MgYBwib
         4lRm8b4sYU+8tz9pwuFAckoS7iXYyv6ODFVHBwSlXXjsiXjSkUm21zgRzL8/mA7b8F8R
         0/j4/3rbYmYKAHidMdJIdZbyNi4JCQm9mb3CdqUfEfD9PJvY88lda8ZCN8XYoheuFFK/
         iZd4rPZ0eZkBusjN3P8OwkblNG5qqusq5EjksS4+Y2zXwgdFY/W5sTN+sUgDee0VjVMP
         sBSA==
X-Gm-Message-State: APjAAAXNaqiFtHwVuTJCOLV1A6W2JVvsecSboorMiBlAt77nsxf13N5q
        CE8/2uvya2TrBcJeMBEaaQ==
X-Google-Smtp-Source: APXvYqy6cPZ/Deoo2WCfAKDgesbS0VH8ghs5Q6eG52JEhqfDqVaOB3BBP8C8Don0YjxornSvQzSDIQ==
X-Received: by 2002:a17:90a:9b88:: with SMTP id g8mr4025235pjp.72.1582302417855;
        Fri, 21 Feb 2020 08:26:57 -0800 (PST)
Received: from madhuparna-HP-Notebook.nitk.ac.in ([112.79.48.60])
        by smtp.gmail.com with ESMTPSA id r8sm3031402pjo.22.2020.02.21.08.26.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 08:26:56 -0800 (PST)
From:   madhuparnabhowmik10@gmail.com
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        joel@joelfernandes.org, frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH] ipv6: xfrm6_tunnel.c: Use built-in RCU list checking
Date:   Fri, 21 Feb 2020 21:54:47 +0530
Message-Id: <20200221162447.23998-1-madhuparnabhowmik10@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

hlist_for_each_entry_rcu() has built-in RCU and lock checking.

Pass cond argument to list_for_each_entry_rcu() to silence
false lockdep warning when CONFIG_PROVE_RCU_LIST is enabled
by default.

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
---
 net/ipv6/xfrm6_tunnel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/xfrm6_tunnel.c b/net/ipv6/xfrm6_tunnel.c
index e11bdb0aaa15..25b7ebda2fab 100644
--- a/net/ipv6/xfrm6_tunnel.c
+++ b/net/ipv6/xfrm6_tunnel.c
@@ -78,7 +78,7 @@ static struct xfrm6_tunnel_spi *__xfrm6_tunnel_spi_lookup(struct net *net, const
 
 	hlist_for_each_entry_rcu(x6spi,
 			     &xfrm6_tn->spi_byaddr[xfrm6_tunnel_spi_hash_byaddr(saddr)],
-			     list_byaddr) {
+			     list_byaddr, lockdep_is_held(&xfrm6_tunnel_spi_lock)) {
 		if (xfrm6_addr_equal(&x6spi->addr, saddr))
 			return x6spi;
 	}
-- 
2.17.1

