Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074D03FC0AB
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 04:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239388AbhHaCDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 22:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239354AbhHaCDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 22:03:09 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE43FC061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 19:02:14 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id g14so13740328pfm.1
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 19:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IpWj79w4DCksvKkbGkU+GnfyJ+N8dwDpZvcP9wMYFvo=;
        b=fiWNIM2eYSAt2smfcC/nzo5vEQnguzMg40zQ8AUQnSr4Y7+kpKC/wXxrGUKzWns/gN
         L4oVG51EcMA3qVI5rzGeRV7LA0lJotVpNQzru/lvnkOz0qunno6l1l51byl8b6h7s7WJ
         QrqWo1NCbY4OLRl6sd4aoVG07frS1KRGSlRT6ZAdA5a7TANWSPmyqD8rRhch69xYhOOc
         zaF3WMyIFNEgW2QSD7PGnyrh/3faHSI8hJeh61Bg5xkuXjeeDNG85l2gboWz49rfhGrO
         gv+sMsFTqCPO2IqPji56SxmeJ3QHXPfq/mvYwKlwJBpPNU6t9wvP69eKTiRF+3bdp7aD
         eKig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IpWj79w4DCksvKkbGkU+GnfyJ+N8dwDpZvcP9wMYFvo=;
        b=sHPVMVT+N8Ql+8FM5Qi/yGxlbzgTbJaaMmL4osjsYdyXZNEmx7/zO1+a2ndFIanu9Y
         /hnaZdyv3dJ2rumuJ7oypNS/AfahoFTUdc7Qjq02KUpF42pHh4UCP6kx+xGChC5+/U7h
         0GLCLQGVZIcDWNPQ2+eGPsxi1VUfAEyLV+V+WuemQ7Y84a6e/fu7cM+lqKpNQ/7Zb5w3
         3JpfkcGesluKzxbgdncoGK+yS1iA3kug6zfwLq97XIN/NYo3EbuvcKaEdrzqO9wwRsvi
         VtOPS0tCD4vuVbFbLpUv/NnMcKccswCCAHjV2hJ/J8Yo3w8tB9cTLt+H2f64DVWTvGw9
         A/wA==
X-Gm-Message-State: AOAM5314Sv8SmgnKn+LL+A44hen62fO5MrJajVPv1uD7Im+A0o0Xe9mK
        r1AWK6srlXRdzZ0bTkpt0nQ=
X-Google-Smtp-Source: ABdhPJwd4q6rPA+8KC3oUHs5pIxoQ/zXOfpZIQC4oRL9r9Ai+tLktHAgirdRv7NL0Z+rU8VAsIkKJQ==
X-Received: by 2002:a65:44c4:: with SMTP id g4mr24437126pgs.254.1630375334340;
        Mon, 30 Aug 2021 19:02:14 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:9d39:21f7:8d5a:bfe])
        by smtp.gmail.com with ESMTPSA id me10sm687537pjb.51.2021.08.30.19.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 19:02:13 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH net] ipv4: fix endianness issue in inet_rtm_getroute_build_skb()
Date:   Mon, 30 Aug 2021 19:02:10 -0700
Message-Id: <20210831020210.726942-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

The UDP length field should be in network order.
This removes the following sparse error:

net/ipv4/route.c:3173:27: warning: incorrect type in assignment (different base types)
net/ipv4/route.c:3173:27:    expected restricted __be16 [usertype] len
net/ipv4/route.c:3173:27:    got unsigned long

Fixes: 404eb77ea766 ("ipv4: support sport, dport and ip_proto in RTM_GETROUTE")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Roopa Prabhu <roopa@nvidia.com>
Cc: David Ahern <dsahern@kernel.org>
---
 net/ipv4/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 225714b5efc0b9c6bcd2d58a62d4656cdc5a1cde..94e33d3eaf621d99baeab338e4e847471d835215 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -3184,7 +3184,7 @@ static struct sk_buff *inet_rtm_getroute_build_skb(__be32 src, __be32 dst,
 		udph = skb_put_zero(skb, sizeof(struct udphdr));
 		udph->source = sport;
 		udph->dest = dport;
-		udph->len = sizeof(struct udphdr);
+		udph->len = htons(sizeof(struct udphdr));
 		udph->check = 0;
 		break;
 	}
-- 
2.33.0.259.gc128427fd7-goog

