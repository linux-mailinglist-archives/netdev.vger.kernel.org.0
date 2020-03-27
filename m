Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA2E19595B
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 15:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgC0OzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 10:55:08 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44327 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgC0OzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 10:55:08 -0400
Received: by mail-wr1-f65.google.com with SMTP id m17so11698670wrw.11
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 07:55:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dkjDNxHqfw8p3Bv3ASEW+QYzvlvaL2VPgOyH92PkIFc=;
        b=jDhcnXAjIz9a8g0A4rd0YgzXSGBV+O4oZ0lIhtA0/H+Ks673RmNSV1Pqx1dj84lkqL
         q0VwGH9ee72PXZMZjF/JXnt+YmgyAB9sTJQdyKtZfTfwFE1giITInbPcfnNhLfVDw6DI
         x/X8GJ73xxCuBdcaR8/DZt+AFUJgUOLruAM4p+fwBFnXswVv5GfeCjjcvQDA9TiMaNjN
         KayvFNnhYcN0hZvSSY1454KorPs792tuWxrgeubUZF+O+N+1FtqCBLVmKccB2XG307aK
         iq6Wi6co70VuhhVcie1QwUNKpXCa/0LIlHcEyPCtQ2pssNdMEgKOiouPQc1FSZCsaoB8
         Qh4g==
X-Gm-Message-State: ANhLgQ3oMe7frHGzjWGeEaSzIWm2lixPF6S25fNbxu1VcD2Hg+iEJ4tf
        zIxo1LZ97i/r7ysGUObUw/RyIeLzLoU=
X-Google-Smtp-Source: ADFU+vtb3islZQwVVMNc2KOwhWPw6nhtbQEqwh4+Buq6JDT1uadZHoBHP3HGUa4YHZxj7vi3KF5Nmg==
X-Received: by 2002:adf:f503:: with SMTP id q3mr15703968wro.135.1585320905446;
        Fri, 27 Mar 2020 07:55:05 -0700 (PDT)
Received: from dontpanic.criteois.lan ([2a01:e35:243a:cf10:6bd:73a4:bc42:c458])
        by smtp.gmail.com with ESMTPSA id f12sm3976186wrm.94.2020.03.27.07.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 07:55:04 -0700 (PDT)
From:   William Dauchy <w.dauchy@criteo.com>
To:     netdev@vger.kernel.org
Cc:     William Dauchy <w.dauchy@criteo.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH v2 net] net, ip_tunnel: fix interface lookup with no key
Date:   Fri, 27 Mar 2020 15:54:44 +0100
Message-Id: <20200327145444.61875-1-w.dauchy@criteo.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200325150304.5506-1-w.dauchy@criteo.com>
References: <20200325150304.5506-1-w.dauchy@criteo.com>
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
index 74e1d964a615..b30485615426 100644
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
+		if ((flags & TUNNEL_KEY && t->parms.i_key != key) ||
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

