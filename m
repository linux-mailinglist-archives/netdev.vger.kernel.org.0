Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848902D82CB
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 00:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437322AbgLKXfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 18:35:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437378AbgLKXfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 18:35:04 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA66C06179C
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 15:33:47 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id f33so7646442qtb.1
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 15:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=MX1YVAbjIk4NS3LSQ5K/SDqAMs0Ae9oVxTK7O+e9jJk=;
        b=q7Dhkncz3LLhhmIhwiXDzR1rMtv9+cy5sdJwhwgXBdQ44/UjmbnD91P+ZHy9vcH8XW
         b0V6rSVpZhFjPfDEG5w/GfRKAX6hqs3yAV7Wf1yEPIG5D2d95UamjiEqq02q2+Mp7CRo
         E9NlRtwfwIS6Hf9zjiMYqljKDkSou7KfONvRSBqfvjHhL3eI3XUGI0J3NupNgVi0a6Dp
         86V38oAU2mL81eh6qoYY5AOOwg2DrPJd1uUqt2iwucT9rOW8Zij0Z4+h5izz6jftw8j+
         R0/YE5RVcTQEzFGJhPfFQBRTFctWKvX6h2O00enVymBpu/Wqp31k9b6IxwEb5prLI0wx
         rHEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MX1YVAbjIk4NS3LSQ5K/SDqAMs0Ae9oVxTK7O+e9jJk=;
        b=eoy7cq2R3EPJuXiyQ3j5ZhFKoL/phLvlQCpZvtgbZFqafQYiQRPDrPtype2HYpP3Ir
         zZEewQZRGW+TieaLdHI+aic2Qp4wfPsVbOdD8ERrS8W2lIW/a0RhbhhyKpv+LUma7h9V
         7YWVyvO8oy416iShWk93yzN1QFYV3j5sur4BGJ81Dg0m7vE9c346EN0S9U1ifFyEA7mf
         4/mGrEwmqhavJYv6496NyfjFhqxZnd57h26qjipfXj96VcLCCnr+3jAMsvrKF/TpKaR1
         LxugahdsGdoN4JRb40MocwVmzOthCxrfq7NVXUgE9Q46ZXWLQN+9aZQbJXlTS8MnKRmo
         y01Q==
X-Gm-Message-State: AOAM533lt2qRUcA0ptDuEiqHC+82m0EEipinibebRJtZjzf02PtTCd3Y
        BiwepdZvSFjgjgc13zvglXDDRlJL3qHd
X-Google-Smtp-Source: ABdhPJzFhUFDksca4LZ72OWaoirzsXuJI06ZCePCe73bfdStAohrSjfGXMPxAD24ZaproOJeaaokhRUyYldJ
Sender: "brianvv via sendgmr" <brianvv@brianvv.c.googlers.com>
X-Received: from brianvv.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:348])
 (user=brianvv job=sendgmr) by 2002:a0c:c242:: with SMTP id
 w2mr2943361qvh.33.1607729626852; Fri, 11 Dec 2020 15:33:46 -0800 (PST)
Date:   Fri, 11 Dec 2020 23:33:38 +0000
In-Reply-To: <20201211233340.1503242-1-brianvv@google.com>
Message-Id: <20201211233340.1503242-3-brianvv@google.com>
Mime-Version: 1.0
References: <20201211233340.1503242-1-brianvv@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH net-next v2 2/4] net: use indirect call helpers for dst_output
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: brianvv <brianvv@google.com>

This patch avoids the indirect call for the common case:
ip6_output and ip_output

Signed-off-by: brianvv <brianvv@google.com>
---
 include/net/dst.h     | 8 +++++++-
 net/ipv4/ip_output.c  | 1 +
 net/ipv6/ip6_output.c | 1 +
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index 98cf6e8c06c4..3932e9931f08 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -436,10 +436,16 @@ static inline void dst_set_expires(struct dst_entry *dst, int timeout)
 		dst->expires = expires;
 }
 
+INDIRECT_CALLABLE_DECLARE(int ip6_output(struct net *, struct sock *,
+					 struct sk_buff *));
+INDIRECT_CALLABLE_DECLARE(int ip_output(struct net *, struct sock *,
+					 struct sk_buff *));
 /* Output packet to network from transport.  */
 static inline int dst_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
-	return skb_dst(skb)->output(net, sk, skb);
+	return INDIRECT_CALL_INET(skb_dst(skb)->output,
+				  ip6_output, ip_output,
+				  net, sk, skb);
 }
 
 INDIRECT_CALLABLE_DECLARE(int ip6_input(struct sk_buff *));
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 879b76ae4435..356c89575b08 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -434,6 +434,7 @@ int ip_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 			    ip_finish_output,
 			    !(IPCB(skb)->flags & IPSKB_REROUTED));
 }
+EXPORT_SYMBOL(ip_output);
 
 /*
  * copy saddr and daddr, possibly using 64bit load/stores
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 749ad72386b2..1260c0cac592 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -178,6 +178,7 @@ int ip6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 			    ip6_finish_output,
 			    !(IP6CB(skb)->flags & IP6SKB_REROUTED));
 }
+EXPORT_SYMBOL(ip6_output);
 
 bool ip6_autoflowlabel(struct net *net, const struct ipv6_pinfo *np)
 {
-- 
2.29.2.576.ga3fc446d84-goog

