Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6857532057B
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 14:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbhBTNCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 08:02:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhBTNCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Feb 2021 08:02:16 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281F8C061786
        for <netdev@vger.kernel.org>; Sat, 20 Feb 2021 05:01:36 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id 7so13709380wrz.0
        for <netdev@vger.kernel.org>; Sat, 20 Feb 2021 05:01:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ij5ehOJSiN6EA4auQ/FW3CzNNh9nmDnOAz6H8yltV5U=;
        b=Yo7Rh2r1ucQAVXM5wiq9lJqS4gtDcJ95qUCc0Q6fEuMmmV8RCVxrbhYHU6blHqFCfp
         DUDd+0NiYybY6yFG63s0mexsa2J97VLixbUWfZhRIp7vQgkTXpm1zVs3vgg+BVQD87/N
         /seCBLpxOFGtWGhZ/LYCF6h4l3czJI5Zst3SYZ+Xrvx+6RNluhBPsP2Okr6+fatiwnWt
         NvTMx37h5X4/NV6nvoH3345d9+f27V0/RnUILYd1F0wWAHgVJ5+bEQGe1faX+0nndpxA
         Ong2pFS67jC1puw6ax9Eb1EYjRTeCEv3VlAHtnOllSItMr758x0DdQWT8N/ZdSo3vzwY
         I4XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ij5ehOJSiN6EA4auQ/FW3CzNNh9nmDnOAz6H8yltV5U=;
        b=WLJVhO45Xj+744RU5Ajr/7HRShLA7dujP7waPTHJ2Euh2yMMDBsrgBWjvDt6O1vsLm
         YaIjiXYA1PWWBqFYzRlU9Dg0T/x5WKIO2w/pbCDHGPPiaXNPAo28eH/MfiT/JTOBM+Px
         uSgRH3mz5lDyUxrxmJb3TZjLJtzQbpbhYLS/N+KwBLVodc6/bG5tyZkpv4MUn/RKyxG2
         CoRfX3h+Th8OWU56L+qatvZci9BhGFlRx9h8YZazKOPbdZwcXnsOujsdFIzTVqtObudR
         TbX5EhDwCLzEIzPfDpzaOsdTR+Wk4spueqyED+ZKrnV7Z8Yw/Bv8kLqMZHz8rLIeavrT
         7+Rg==
X-Gm-Message-State: AOAM5313puyBwOz3KyNJmGgytVkqrRuqLzhDOYYqcytpLe/l1pzbpz0b
        Bg7uLeZD7J+m9t3x5OK1JHw=
X-Google-Smtp-Source: ABdhPJwLA8rnoudnuv4c9QZ680Cw0C2SOpHaxmlb+kVBcP0/VP/9uSmHBq3Kol7ledspdtR9yCgGUA==
X-Received: by 2002:a5d:60c4:: with SMTP id x4mr3214425wrt.384.1613826094800;
        Sat, 20 Feb 2021 05:01:34 -0800 (PST)
Received: from localhost.localdomain ([213.57.166.51])
        by smtp.gmail.com with ESMTPSA id c12sm7188685wru.71.2021.02.20.05.01.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Feb 2021 05:01:33 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, sd@queasysnail.net,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH ipsec,v2] xfrm: interface: fix ipv4 pmtu check to honor ip header df
Date:   Sat, 20 Feb 2021 15:01:15 +0200
Message-Id: <20210220130115.2914135-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Frag needed should only be sent if the header enables DF.

This fix allows packets larger than MTU to pass the xfrm interface
and be fragmented after encapsulation, aligning behavior with
non-interface xfrm.

Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

-----

v2: better align coding with ip_vti
---
 net/xfrm/xfrm_interface.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 697cdcfbb5e1..3f42c2f15ba4 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -305,6 +305,8 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 
 			icmpv6_ndo_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
 		} else {
+			if (!(ip_hdr(skb)->frag_off & htons(IP_DF)))
+				goto xmit;
 			icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
 				      htonl(mtu));
 		}
@@ -313,6 +315,7 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 		return -EMSGSIZE;
 	}
 
+xmit:
 	xfrmi_scrub_packet(skb, !net_eq(xi->net, dev_net(dev)));
 	skb_dst_set(skb, dst);
 	skb->dev = tdev;
-- 
2.25.1

