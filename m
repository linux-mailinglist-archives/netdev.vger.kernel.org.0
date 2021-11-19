Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB9145680D
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 03:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbhKSC1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 21:27:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbhKSC1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 21:27:00 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49AD5C061574
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 18:23:59 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so9890400pja.1
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 18:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=usKakFSJS8zH/zMn8Uu2TXXgwbLwTCNeSWtLo9jQAhc=;
        b=caIfTRLDr8qFD8PiZ5OypVdbdi99+ugYnIDer8V3BRZnxlQWlZNn16VZLz2LiY1V4w
         w78jDPnkJlevNcovsepMfmQo+isDR5aJe85M83ZlBVtqgAf0/eyLRW27Ru641c16BpVh
         pxmrLrifEJkg9Xxy7JqGh4HGktc6/+MZKy7s0Hye8br/XNCyAoRt+hWTbuZtpAqY8dJv
         mNA7Pod6tLZjj7v+qHkr0LUzfMWIUPjr1D0fQvtDaLR7b/Bjv7qwIB5gsLtrSq6BpnnL
         ELJaaCNjCZAPklpEKonmgq/DKvhiTuVbNVO1Up5+HhQ/l/r1SFaDdmuQv98p8lFee6bI
         cgOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=usKakFSJS8zH/zMn8Uu2TXXgwbLwTCNeSWtLo9jQAhc=;
        b=6uERJbVI/o32Ql6JrWrt57KIYkIlkiwyiDU0hcmrgB7VdWQaEoGwzE2VK6L4HxWcwn
         r/3QMuchYRHIbY8UL9P7dBwdRuG8bF3JOn65GTkKykDjEG0l+4pldq4B8dFmz+styrXG
         dJFxbHZ53WKpJC5SKtYAf5KkJtkRony/ubCs414H9MH4EJopM6En/FMiHxszu4pviJOM
         j6WtdefNKtzmznMrcQl2as7e65Bu/y5dMOMBHhxptrAWXBSZ+BMtrtGlj6lsXm/25Ur7
         i8DQnVr3AeGv8n/XBcxZnI+thkTaKV8KkiOml44stDExtY4suZGKfPoFYpnpdYVjCMM+
         iATg==
X-Gm-Message-State: AOAM533hMklu5VjCX290VBCVppKNmsEWAav56SMsHtlw7Tse703a7U/p
        eNUtFJ6DlFcx6a7/M8/WT6g=
X-Google-Smtp-Source: ABdhPJxksTCHa4whD+icGEbZP0JxmA1teF4CUIL4MaKP7OzCQvaUkw4RlUM51rKTyLVwN3RLOnDZgg==
X-Received: by 2002:a17:902:7b82:b0:143:a6d6:34ab with SMTP id w2-20020a1709027b8200b00143a6d634abmr68111260pll.30.1637288638690;
        Thu, 18 Nov 2021 18:23:58 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:fc03:ed5a:3e05:8b5e])
        by smtp.gmail.com with ESMTPSA id j1sm896133pfu.47.2021.11.18.18.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 18:23:58 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] ipv6: ip6_skb_dst_mtu() cleanups
Date:   Thu, 18 Nov 2021 18:23:55 -0800
Message-Id: <20211119022355.2985984-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Use const attribute where we can, and cache skb_dst()

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/ip6_route.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 5efd0b71dc6732d97257fae0637b67516a5b9261..ca2d6b60e1eceeb3839f413726fb4f93e1835a0e 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -263,19 +263,19 @@ static inline bool ipv6_anycast_destination(const struct dst_entry *dst,
 int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		 int (*output)(struct net *, struct sock *, struct sk_buff *));
 
-static inline unsigned int ip6_skb_dst_mtu(struct sk_buff *skb)
+static inline unsigned int ip6_skb_dst_mtu(const struct sk_buff *skb)
 {
-	unsigned int mtu;
-
-	struct ipv6_pinfo *np = skb->sk && !dev_recursion_level() ?
+	const struct ipv6_pinfo *np = skb->sk && !dev_recursion_level() ?
 				inet6_sk(skb->sk) : NULL;
+	const struct dst_entry *dst = skb_dst(skb);
+	unsigned int mtu;
 
 	if (np && np->pmtudisc >= IPV6_PMTUDISC_PROBE) {
-		mtu = READ_ONCE(skb_dst(skb)->dev->mtu);
-		mtu -= lwtunnel_headroom(skb_dst(skb)->lwtstate, mtu);
-	} else
-		mtu = dst_mtu(skb_dst(skb));
-
+		mtu = READ_ONCE(dst->dev->mtu);
+		mtu -= lwtunnel_headroom(dst->lwtstate, mtu);
+	} else {
+		mtu = dst_mtu(dst);
+	}
 	return mtu;
 }
 
-- 
2.34.0.rc2.393.gf8c9666880-goog

