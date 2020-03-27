Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6AC9195DFC
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 19:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbgC0S4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 14:56:48 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43324 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgC0S4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 14:56:48 -0400
Received: by mail-wr1-f65.google.com with SMTP id m11so6833478wrx.10
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 11:56:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ydN4nqx2Q3IGKcoNT+U17HLZoguGYhG+byGm3/Tewug=;
        b=LcQ3f3ZcT6Taj+6KNzekQIJUr8MkdY4pWsnVTPZBRMsV+mW8h3iD7Di9rWdGEQhxfz
         buWtfsEInwP6LP2GHSYFzALRyX8a92tfFLR/mhha3tqPzuk0eci+3FsLKqlOTo9fIpH0
         bXUvod0EJms3O7khEeYgX8LRejqJ85bIq8KQOE6l60Urn667yMFwkD7wnbWGow0pZX1u
         4q72sPSUfNlurWi946HO3WB1JI6HdMPk5HhI6vJ/slN5NG3t4Okf7x2Ht+bTr5o6/NQf
         lhqT78Gfq8SQiwgw23fKeY3Ohz1C7H2lXd206FjmhFgUgvAKATb13cKQdKEohzJkm+nc
         7zgA==
X-Gm-Message-State: ANhLgQ0gs+iDpk506f8W0uZ95qasy3L9JOsslAeuliXiR1UNFS+75HB9
        RmgJQ1oS00wU/PjeOT1fQ/O8nR4GQQs=
X-Google-Smtp-Source: ADFU+vuEJ+7jT3QKUNrlRkQja5JAtWB+T7Mj7In1pP3nqmrlkTvWaQftDmR4Xk65UlIn8GlkzeAiZw==
X-Received: by 2002:a05:6000:1090:: with SMTP id y16mr811982wrw.281.1585335403949;
        Fri, 27 Mar 2020 11:56:43 -0700 (PDT)
Received: from dontpanic.criteois.lan ([2a01:e35:243a:cf10:6bd:73a4:bc42:c458])
        by smtp.gmail.com with ESMTPSA id d124sm9077641wmd.37.2020.03.27.11.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 11:56:42 -0700 (PDT)
From:   William Dauchy <w.dauchy@criteo.com>
To:     netdev@vger.kernel.org
Cc:     William Dauchy <w.dauchy@criteo.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH v3 net] net, ip_tunnel: fix interface lookup with no key
Date:   Fri, 27 Mar 2020 19:56:39 +0100
Message-Id: <20200327185639.71238-1-w.dauchy@criteo.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200327145444.61875-1-w.dauchy@criteo.com>
References: <20200327145444.61875-1-w.dauchy@criteo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

when creating a new ipip interface with no local/remote configuration,
the lookup is done with TUNNEL_NO_KEY flag, making it impossible to
match the new interface (only possible match being fallback or metada
case interface); e.g: `ip link add tunl1 type ipip dev eth0`

To fix this case, adding a flag check before the key comparison so we
permit to match an interface with no local/remote config; it also avoids
breaking possible userland tools relying on TUNNEL_NO_KEY flag and
uninitialised key.

context being on my side, I'm creating an extra ipip interface attached
to the physical one, and moving it to a dedicated namespace.

Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
Signed-off-by: William Dauchy <w.dauchy@criteo.com>
---
 net/ipv4/ip_tunnel.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 74e1d964a615..cd4b84310d92 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -142,11 +142,8 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
 			cand = t;
 	}
 
-	if (flags & TUNNEL_NO_KEY)
-		goto skip_key_lookup;
-
 	hlist_for_each_entry_rcu(t, head, hash_node) {
-		if (t->parms.i_key != key ||
+		if ((!(flags & TUNNEL_NO_KEY) && t->parms.i_key != key) ||
 		    t->parms.iph.saddr != 0 ||
 		    t->parms.iph.daddr != 0 ||
 		    !(t->dev->flags & IFF_UP))
@@ -158,7 +155,6 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
 			cand = t;
 	}
 
-skip_key_lookup:
 	if (cand)
 		return cand;
 
-- 
2.25.1

