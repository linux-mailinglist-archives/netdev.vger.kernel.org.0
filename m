Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F31C2D6DDD
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 03:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395003AbgLKB70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 20:59:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730749AbgLKB7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 20:59:13 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18320C061794
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 17:58:33 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id j30so5418824pgj.17
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 17:58:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=JZuBMUjdVVVxh6WnK4CWaG8XFlwg5qneM5nzLNIVeag=;
        b=ko6IbsPShEqsmfAfsfV9qvC127/jPkMqeofdfguKVDhv4nl4PDHYX0VMp3YLRGQHpd
         M9FIEZPyHzEjhCzMvJS1Q3kmPNYL88oBazzPo+UWk5Bj9slbUNmN+z7RIEwVb7od+GtU
         sW1+wy9m4H3MrISFx6vRt3pCu3UUUrpSQsw1Cv3EOAXbhNBzj+hFbcT72q90susNYJuM
         2g3YmJtYWRQnDygT5FJIG5GfVA7FvANcKmFVmI1MtfOzZ2Rv2CsQLe7zpQ3sMnV+zzs+
         j7rSlK/ixBtETx6kq03jHXYo2XnRMuM4/XE1PAsbJ1WtZBuErSpMuVfVKX3cUoY1yn0T
         JHyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JZuBMUjdVVVxh6WnK4CWaG8XFlwg5qneM5nzLNIVeag=;
        b=tfKLl5hUA+qeiTYQ8duqjmzky23HZE4XT05qoqfq1YYRvln3GPgdVFIE+z6wEvDakI
         Upn2Qub0GVqvgsv/CZI6wuzCxj2uGtX6G2r45dz6blSv5KSGLGwhODZ3zasZv7kuz49l
         nOS3OAb8WMDhYsqYZAYzMdZNgbwNgvbnWp4jbJIE+2Mu7cv3IyTm7YGRrkYedhy6V+Qq
         Ub2KuvXX2UE7IsnrX/SC09QD2p2zI4YuBewuW6nnWzu3ZvtgQ3ZKgKCTSP+OansHyag5
         rTUHW6QqGgMjzuWicbypYt949S+PkNriqYSJgRG2WtESOHLVs77xjWpVDlb6e5V3yP8G
         aesQ==
X-Gm-Message-State: AOAM533FbLxH2DOKYytINRXEmp6On6Mfhr6lN3w4nYRo4kIqWA6G10AE
        Cgi+ZHgOR/4n8EyuRPb5OPXUU4fRqe56
X-Google-Smtp-Source: ABdhPJx/ZdLB8Kbh0dsoZNXoyjhao5SR68H1LrrwYVUeY7aVjpBjpUw3heJ5jdAZ1rEM4Qyww7Y4lrqeEZ5q
Sender: "brianvv via sendgmr" <brianvv@brianvv.c.googlers.com>
X-Received: from brianvv.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:348])
 (user=brianvv job=sendgmr) by 2002:a17:90b:50a:: with SMTP id
 r10mr10755699pjz.103.1607651912600; Thu, 10 Dec 2020 17:58:32 -0800 (PST)
Date:   Fri, 11 Dec 2020 01:58:21 +0000
In-Reply-To: <20201211015823.1079574-1-brianvv@google.com>
Message-Id: <20201211015823.1079574-3-brianvv@google.com>
Mime-Version: 1.0
References: <20201211015823.1079574-1-brianvv@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH net-next 2/4] net: use indirect call helpers for dst_output
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
 include/net/dst.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

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
-- 
2.29.2.576.ga3fc446d84-goog

