Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8A7C142286
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 05:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729091AbgATEvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 23:51:17 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37518 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729043AbgATEvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 23:51:17 -0500
Received: by mail-pf1-f196.google.com with SMTP id p14so15196866pfn.4
        for <netdev@vger.kernel.org>; Sun, 19 Jan 2020 20:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XiNQBMy4emzr+DnqvKqpf3nLjG9MXGI38+suTtUz/4o=;
        b=N6iXYBgMs0M9ErBGWK2gyka9jHGB/uGZmiPPgrUj0fakA4oVHFcFmtJB8M2gGlONXP
         l96+9/dd97fhCQ6IYInsWIECMmyL3YfOPhaPOyuAcH0FoD3thvJzXJvmnyUkodPgCHiV
         77Ztb4wOhwnQA5EYA4gyORmgcaG4n5CKea6praHbifHYvWgohjo5sxRSiOHMdbgjHgZ4
         7t/rXyErTrPyb9WodVxlE+M2A270AeVjFkrx0H+XGM4i6RX0LHidahEH44Qecyb0Gg9K
         rD56tnJJtpaswbNJLT/l9hsnqeRkL2/8kmLIBJ/tkHY2MV5ruoVv9op2rye4Hn9nvlUE
         MeAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XiNQBMy4emzr+DnqvKqpf3nLjG9MXGI38+suTtUz/4o=;
        b=KdsCe3OsD6VWqRrmbg4/Pfr1ueCkcoUThXDdKyKuuC3cIyHAsKBFkj1Bu61NGV2ZCI
         MprWttwI1LEyfUxgz/xWGulPV17MGcc8h1b/lG5DTZjW8YAqfcrUqZzahnArqvhsIMX0
         +UvOsfdIiEgHauOlb6a4YDGWldeGXh4nSj9p1T5z4GZUQbSn0nTzHi6zueHD0IKOUD8p
         0DVcEqojnBWbJwIWXoEcjkKZvI8JSW/sNL+cjdj+nOz5NsfH/WRJvzSOAYzj1KflRPMc
         5levFbZ0ZyUn1iM/Gyzrds1H1KKXEpa/w2DAh0iAvCbizsgvBgr9HtPh+vDhZUvniSIK
         pODg==
X-Gm-Message-State: APjAAAWIcZR4P1bCrSbU2ABLNane2yxRCvhD8yx8rNuvLYRZG99lcBc+
        Iwbf6/cOriZJ4IsFIHQ19kQyr9W78Qo=
X-Google-Smtp-Source: APXvYqz9hvRAO8qbsq5V7fZ6dPWA864URfqHNkrQJkOnBVaF4K7VBvlI3RtcvSFLTrJZJ7Cvw0lcZQ==
X-Received: by 2002:a63:1502:: with SMTP id v2mr57726216pgl.376.1579495876193;
        Sun, 19 Jan 2020 20:51:16 -0800 (PST)
Received: from localhost.localdomain ([203.104.128.122])
        by smtp.gmail.com with ESMTPSA id b20sm37974212pfi.153.2020.01.19.20.51.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 19 Jan 2020 20:51:15 -0800 (PST)
From:   Yuki Taguchi <tagyounit@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        dlebrun@google.com, david.lebrun@uclouvain.be,
        Yuki Taguchi <tagyounit@gmail.com>
Subject: [PATCH net] ipv6: sr: remove SKB_GSO_IPXIP6 on End.D* actions
Date:   Mon, 20 Jan 2020 13:48:37 +0900
Message-Id: <20200120044837.76789-1-tagyounit@gmail.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After LRO/GRO is applied, SRv6 encapsulated packets have
SKB_GSO_IPXIP6 feature flag, and this flag must be removed right after
decapulation procedure.

Currently, SKB_GSO_IPXIP6 flag is not removed on End.D* actions, which
creates inconsistent packet state, that is, a normal TCP/IP packets
have the SKB_GSO_IPXIP6 flag. This behavior can cause unexpected
fallback to GSO on routing to netdevices that do not support
SKB_GSO_IPXIP6. For example, on inter-VRF forwarding, decapsulated
packets separated into small packets by GSO because VRF devices do not
support TSO for packets with SKB_GSO_IPXIP6 flag, and this degrades
forwarding performance.

This patch removes encapsulation related GSO flags from the skb right
after the End.D* action is applied.

Fixes: d7a669dd2f8b ("ipv6: sr: add helper functions for seg6local")
Signed-off-by: Yuki Taguchi <tagyounit@gmail.com>
---
 net/ipv6/seg6_local.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 85a5447a3e8d..7cbc19731997 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -23,6 +23,7 @@
 #include <net/addrconf.h>
 #include <net/ip6_route.h>
 #include <net/dst_cache.h>
+#include <net/ip_tunnels.h>
 #ifdef CONFIG_IPV6_SEG6_HMAC
 #include <net/seg6_hmac.h>
 #endif
@@ -135,7 +136,8 @@ static bool decap_and_validate(struct sk_buff *skb, int proto)
 
 	skb_reset_network_header(skb);
 	skb_reset_transport_header(skb);
-	skb->encapsulation = 0;
+	if (iptunnel_pull_offloads(skb))
+		return false;
 
 	return true;
 }
-- 
2.20.1 (Apple Git-117)

