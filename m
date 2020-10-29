Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35F129E3CE
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbgJ2HVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbgJ2HVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:21:01 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F45BC08E935;
        Thu, 29 Oct 2020 00:05:37 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 15so1560971pgd.12;
        Thu, 29 Oct 2020 00:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=NWswMQFNrJpmgSXJFGyvzsyral3mRo2RUwnr9RHwTGk=;
        b=FMzkrdpLP8LJTwRS870cQ1c+l6LVaM3fL+0yvxGcRnBXWQyht7dRNBbjlrHAGPtEXz
         1MiW4Yjpc9o/wjibwDdR4eVImAAmO4zvOWx2+mjMuxLJ6g/ZKhORI+srJmyghC3KponD
         KmXTT6rYqDzJGHPMRpqB1yK+4D1TwNUSLILDikGfwTnBM+gCbX5/A5yLfOFaCULf4ZHH
         kePH0p+ircE2q0tzoGVwTeR+CDBbgImjIITmiQUfX6GVN/kfZCV/wBiVv0KO8Y1e++Db
         WVUaIGEgabfZBdnK/8UITiBsOYHqYh1Jq0+RmWye0wWpxkGIQ1YWkOggSQspIx2yCSNS
         VFQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=NWswMQFNrJpmgSXJFGyvzsyral3mRo2RUwnr9RHwTGk=;
        b=mH84WkJ7bWd8MOQs4v5ScgKzViIZ9ZsdRJkLc20OJzCK3OU4F6RlXNrZXg1SsAPBMF
         KJGFIun1x+myjIf0MNx0WOpXUjWnM4Uq2yhqkZC34TBgUaQ8Qk5k2I2z+8rCxyImVYPE
         XijH/wjG8fbJeAgizKvGvHyoiobLKn8xevLwuQ5AF3PmlQnMZkr4e8SsRhCc0iExRe2T
         fAOj7m3qpTOD3ssalneBghR81CGhZ0zgBMmy8vjw3aC2oETVr3mIt+MFH6mv2bREnRFY
         LVPMK9+wre322nZfpN/OUuJBcJaKEjaOX5r4NTNoaiX4RlSSja9OiJhfJvLRVxkM33EA
         7ukQ==
X-Gm-Message-State: AOAM531jWn1UqTcb1ltX4Qck7NAzGucizgfJQrTYz5Xq6c8hIGgRYTCS
        uOHiLNEP7oiwD/cHU1n+EGXnRuzA9L0=
X-Google-Smtp-Source: ABdhPJzStPrIlge1Q43JVmvhe1k1tol7OuaYSsrqLtqxO8Nk1ZkijtrrkUoYoO/WtG02W5s9k8PO5Q==
X-Received: by 2002:a17:90a:7024:: with SMTP id f33mr2889200pjk.114.1603955136359;
        Thu, 29 Oct 2020 00:05:36 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g1sm1713226pjj.3.2020.10.29.00.05.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Oct 2020 00:05:35 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, gnault@redhat.com,
        pabeni@redhat.com, willemdebruijn.kernel@gmail.com
Subject: [PATCHv5 net-next 02/16] udp6: move the mss check after udp gso tunnel processing
Date:   Thu, 29 Oct 2020 15:04:56 +0800
Message-Id: <4f439ed717442a649ba78dc0efc6f121208a9995.1603955040.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <48053c3bf48a46899bc0130dc43adca1e6925581.1603955040.git.lucien.xin@gmail.com>
References: <cover.1603955040.git.lucien.xin@gmail.com>
 <48053c3bf48a46899bc0130dc43adca1e6925581.1603955040.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1603955040.git.lucien.xin@gmail.com>
References: <cover.1603955040.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For some protocol's gso, like SCTP, it's using GSO_BY_FRAGS for
gso_size. When using UDP to encapsulate its packet, it will
return error in udp6_ufo_fragment() as skb->len < gso_size,
and it will never go to the gso tunnel processing.

So we should move this check after udp gso tunnel processing,
the same as udp4_ufo_fragment() does.

v1->v2:
  - no change.
v2->v3:
  - not do any cleanup.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv6/udp_offload.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
index 584157a..aa602af 100644
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -28,10 +28,6 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_buff *skb,
 	int tnl_hlen;
 	int err;
 
-	mss = skb_shinfo(skb)->gso_size;
-	if (unlikely(skb->len <= mss))
-		goto out;
-
 	if (skb->encapsulation && skb_shinfo(skb)->gso_type &
 	    (SKB_GSO_UDP_TUNNEL|SKB_GSO_UDP_TUNNEL_CSUM))
 		segs = skb_udp_tunnel_segment(skb, features, true);
@@ -48,6 +44,10 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_buff *skb,
 		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
 			return __udp_gso_segment(skb, features);
 
+		mss = skb_shinfo(skb)->gso_size;
+		if (unlikely(skb->len <= mss))
+			goto out;
+
 		/* Do software UFO. Complete and fill in the UDP checksum as HW cannot
 		 * do checksum of UDP packets sent as multiple IP fragments.
 		 */
-- 
2.1.0

