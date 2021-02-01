Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA1B30AE4A
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 18:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbhBARp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 12:45:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232369AbhBARmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 12:42:23 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F031C061788
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 09:41:43 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id v16so11959239pgl.23
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 09:41:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=NcltcDqOq5jfVgNgE4Zs8YLWrxohZXbzvJpJOu5kKM0=;
        b=bgVs72YUN8C3ZjrbaPgvenUy5a0pg03EZvRNGvqcnLwK/I5gyrNYTz0eqaRoQhI1WG
         sh8PDhT9g1kiI/FlFVvhKbLc+Zs7VeV3uB+QEx+6FP92zH403gAsmaQ+qmAt7xD36A5q
         0q1X+hOLK4aVzt2KuKFn/bQcPHZEQrOrvYQHBvs5AmgZ4PGOy8DB3+MbxfNygLCPvypm
         InCksWC5HzOWCrCJfvpoLF10DuECxsF5A0TPGE0qe3jksp810bSOcHmUsFGR7JFEYxc+
         gC6BG5ZxVr/j4hnV953hTacyBZI8SbsCrk3d0/7bWE/QzcmW2L/ERQBOqGNUPKh/U5K/
         vFHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NcltcDqOq5jfVgNgE4Zs8YLWrxohZXbzvJpJOu5kKM0=;
        b=n6rOhHYSPa9MTvCIlzTf2TdUW/6n+fieQp5mf89948++iYG8jmgbLNlEvlrolF+2rl
         CLw9bstJNyND18J7/ZNp0Q7GyhpCXyHuTbRcRXsQcyrxytIWdQz2iD/1OVqjVmCCgVHJ
         J7hflY3GTruJQ4VGtgSXrrpBKhtanO7/MR9py9Bm+lYVz1rtAkA2nfMFD339BtrwTTKi
         IOIPJo5yIYzGX721WZdi2XCJFkxjOsqiJXX1tOERC8GezNON8q/4wq0jXzSP78l9Bwya
         e0hW27uy0jSsiR24jaWb3bo2Gu54JomADIeERzV8DEESIocpgUb+EPALLkvpa2wmKsQJ
         znFg==
X-Gm-Message-State: AOAM531fel8wmfCojZTNAWK1S9YUI5NgSRqNp7s7801j7jNzNaDWO93u
        s8LtrDbDq3hkSH2qWc92M5TiZ1Nivhzl
X-Google-Smtp-Source: ABdhPJyBJ+1Rx0HRaXptdpPTEM27jYAjDtS4OkVBnJuYCXQFFfzBmZEsCRbNyRZt/c8XDctpLPgHiMmnyb3o
Sender: "brianvv via sendgmr" <brianvv@brianvv.c.googlers.com>
X-Received: from brianvv.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:348])
 (user=brianvv job=sendgmr) by 2002:a17:90a:3f08:: with SMTP id
 l8mr75880pjc.1.1612201302661; Mon, 01 Feb 2021 09:41:42 -0800 (PST)
Date:   Mon,  1 Feb 2021 17:41:30 +0000
In-Reply-To: <20210201174132.3534118-1-brianvv@google.com>
Message-Id: <20210201174132.3534118-3-brianvv@google.com>
Mime-Version: 1.0
References: <20210201174132.3534118-1-brianvv@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH net-next v3 2/4] net: use indirect call helpers for dst_output
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Luigi Rizzo <lrizzo@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch avoids the indirect call for the common case:
ip6_output and ip_output

Signed-off-by: Brian Vazquez <brianvv@google.com>
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
index 959b94e32f2b..3aab53beb4ea 100644
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
index 117cd95df213..ff4f9ebcf7f6 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -217,6 +217,7 @@ int ip6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 			    ip6_finish_output,
 			    !(IP6CB(skb)->flags & IP6SKB_REROUTED));
 }
+EXPORT_SYMBOL(ip6_output);
 
 bool ip6_autoflowlabel(struct net *net, const struct ipv6_pinfo *np)
 {
-- 
2.30.0.365.g02bc693789-goog

