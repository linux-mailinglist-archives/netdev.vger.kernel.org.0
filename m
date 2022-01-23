Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB63497050
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 07:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235654AbiAWGAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 01:00:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235591AbiAWGAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 01:00:04 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95433C06173B
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 22:00:04 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id e16so2734145pgn.4
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 22:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=moy-cat.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=r75LVJTM+RC9fX0WmsgQ9HouuTJ4i5d8pG0eENX2RhU=;
        b=GYHPgv06geAZG+KySi+tWoFx5/rnwpFUJR8unB2mu6Geiqki8FrEszlYzOxX05BN/s
         Vk2m2e99rY4xCZg5NBuJO/z34GVfV6r9olZYXREQOhUiyCZFl6rlHEb2k305J4E1unhe
         6sDlM1DarteqMMBl5nC/b/mDLKG2sAnjJC0rJwZ3ivSqSjYPe7UttOEd0zctVnkKzSB7
         N2mai9aUyXr+eRoWD7DMhqHLwi3qvi4uOPshU2VfvFaF+4E2r7EhxEcARslL90RrI3PI
         u0UCHxOLSA+G1mw0npnHVVLaVbY0wTleevvxV1B5pySRxTsxO5VncwKtyLhWa7kfkXqo
         egFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=r75LVJTM+RC9fX0WmsgQ9HouuTJ4i5d8pG0eENX2RhU=;
        b=kvKuDjUYm6/rD1McwdrESxEr2AiQDv3li8ZcA1lwxTktr/7RnpSQqMj2pC/b7WxDhD
         2/UaoVg7Y9F195xDNvnnjc0deK9Vjx09PD80VAGIZt07rCQr4yRrnARE0BPSYEy/tmg4
         5vrNQm6Wj0qnfPdNHwIWgLZCWgFINqNC4xOXfMRGVior6Z63reU4/VrKiEhoVTfNPrrE
         8L/Pdy9Qx1FUllbAZWDjeDD0SOTMBle3V4+4g2svpzjpPww0vuN3JMeMqs3/13yIOs/p
         BtpcGIvb32sFnZ+szK0W82oBHMvzn2g8toiRWo0t5Rh9b3dKfPWOIeOuFk513e8S3WWr
         wTrQ==
X-Gm-Message-State: AOAM5309CmBzCtMdahZDbPKf3ApdXSBX1sBcU6X30tDZL35s94LT+FV5
        T7yhf0oE1Fqa5yJ0uZKWACg2+Q==
X-Google-Smtp-Source: ABdhPJxC7Pgcz50mJVJU9q07uLNE+zYRQ2VUl/y84SDdce77JYEIoOLE7pk4bKP7Bq7mhTXIAzEH5Q==
X-Received: by 2002:a62:6415:0:b0:4c6:fe2f:6a94 with SMTP id y21-20020a626415000000b004c6fe2f6a94mr9849111pfb.25.1642917604089;
        Sat, 22 Jan 2022 22:00:04 -0800 (PST)
Received: from localhost ([2408:8207:18a1:2c30:5813:d8ff:fe37:e87a])
        by smtp.gmail.com with ESMTPSA id mp22sm9589948pjb.28.2022.01.22.22.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Jan 2022 22:00:03 -0800 (PST)
Date:   Sun, 23 Jan 2022 14:00:00 +0800
From:   Qing Deng <i@moy.cat>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ip6_tunnel: allow routing IPv4 traffic in NBMA mode
Message-ID: <20220123060000.GA12551@devbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since IPv4 routes support IPv6 gateways now, we can route IPv4 traffic in
NBMA tunnels.

Signed-off-by: Qing Deng <i@moy.cat>
---
 net/ipv6/ip6_tunnel.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index fe786df4f849..2bcffc3fc4ae 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1121,6 +1121,11 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 
 			memcpy(&fl6->daddr, addr6, sizeof(fl6->daddr));
 			neigh_release(neigh);
+		} else if (skb->protocol == htons(ETH_P_IP)) {
+			struct rtable *rt = skb_rtable(skb);
+
+			if (rt->rt_gw_family == AF_INET6)
+				memcpy(&fl6->daddr, &rt->rt_gw6, sizeof(fl6->daddr));
 		}
 	} else if (t->parms.proto != 0 && !(t->parms.flags &
 					    (IP6_TNL_F_USE_ORIG_TCLASS |

base-commit: 1f40caa080474d0420e0b0e6c896e455acb6e236
-- 
2.32.0 (Apple Git-132)

