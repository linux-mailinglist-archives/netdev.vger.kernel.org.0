Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 687C530AE33
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 18:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbhBARmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 12:42:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232366AbhBARmV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 12:42:21 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF548C0613ED
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 09:41:41 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id 33so11943895pgv.0
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 09:41:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=2dJAjQqhEjIVgRLObUehhbawcyx+wTN2wrBIU5NRBZE=;
        b=Zb/6M+XHCJqrYdZT8bW7liJK+lRA/UwvDlzWoPO9OSJe+MU0zDUVkXerihD2tPtBGy
         Y+7ql7AboELh2KMeBGcua+lWzDtZtPENDrtrQe0DbT2p7mJpopsG0a96OYplzBXgqe1Y
         jq2TWCS90Lc0PNuwHXHS+PHQQArIKfKzA3FoHcUXhmNFkUwX+wYGDdbEEmUG2bth0G3J
         Yz1AefphnCPqH8ilfPBZWyk3j7uGZzaGJaCN7fWfd7ZkyaNXo/2clrmqhyh61vSGfiXw
         FwHdfR+Kk/OyR+T3+Fp+Bna8zeSjxYtBox+K2wIPa4ZspdkCgLg5CW67jUDP12eAui+i
         54xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2dJAjQqhEjIVgRLObUehhbawcyx+wTN2wrBIU5NRBZE=;
        b=mD40jmVkfWyCqmA9Wfn9xgR032YCdaYc0smvOt67uFlqsXRiEUJ41JLbBO/PfQ7tI1
         6+NVY+I9Fzrf+lwdtfVu920PfSTyvkISsMzcw+RXRG8qflcR3Jrt+gOvFcNh2s/jXezI
         bwBTARB/8t1aLXis31SWakQzJ+NP2BqNayXQyhHCCctx41SAtV/vZGzwCPF+7a2jNZn2
         nUW0cFtSk/JtxtLxWd1ddTA9WAyfde3PxpWv3YtuBAdKIq+ZfUqdhVv2Bhwtlisp5GoX
         0HmgcWEe1PNI7dupwVlpYiW4Q3E2Shg5Ba0uZTPNlhLKwJyhLZ6bIBzbh/+pZPiPyvwe
         BfOQ==
X-Gm-Message-State: AOAM530L+kVcmnj9pyBGRhB3y6x2mwK4U7JV1P+SIu5DvMXu0XZqPdpa
        OD/bN2k0h90a6/kMcPdSZCiirRK0r6Xi
X-Google-Smtp-Source: ABdhPJwszdqrA7PQM3vXcsFbL6bN4F9MVIa13mv0vYJ1Yg3YeutC/qcpkrPALAIpNJCkpMk5/CMi5SzLL4MG
Sender: "brianvv via sendgmr" <brianvv@brianvv.c.googlers.com>
X-Received: from brianvv.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:348])
 (user=brianvv job=sendgmr) by 2002:a63:3648:: with SMTP id
 d69mr18173594pga.155.1612201301026; Mon, 01 Feb 2021 09:41:41 -0800 (PST)
Date:   Mon,  1 Feb 2021 17:41:29 +0000
In-Reply-To: <20210201174132.3534118-1-brianvv@google.com>
Message-Id: <20210201174132.3534118-2-brianvv@google.com>
Mime-Version: 1.0
References: <20210201174132.3534118-1-brianvv@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH net-next v3 1/4] net: use indirect call helpers for dst_input
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
ip_local_deliver and ip6_input

Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 include/net/dst.h   | 6 +++++-
 net/ipv4/ip_input.c | 1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index 10f0a8399867..98cf6e8c06c4 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -18,6 +18,7 @@
 #include <linux/refcount.h>
 #include <net/neighbour.h>
 #include <asm/processor.h>
+#include <linux/indirect_call_wrapper.h>
 
 struct sk_buff;
 
@@ -441,10 +442,13 @@ static inline int dst_output(struct net *net, struct sock *sk, struct sk_buff *s
 	return skb_dst(skb)->output(net, sk, skb);
 }
 
+INDIRECT_CALLABLE_DECLARE(int ip6_input(struct sk_buff *));
+INDIRECT_CALLABLE_DECLARE(int ip_local_deliver(struct sk_buff *));
 /* Input packet from network to transport.  */
 static inline int dst_input(struct sk_buff *skb)
 {
-	return skb_dst(skb)->input(skb);
+	return INDIRECT_CALL_INET(skb_dst(skb)->input,
+				  ip6_input, ip_local_deliver, skb);
 }
 
 static inline struct dst_entry *dst_check(struct dst_entry *dst, u32 cookie)
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index b0c244af1e4d..3a025c011971 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -253,6 +253,7 @@ int ip_local_deliver(struct sk_buff *skb)
 		       net, NULL, skb, skb->dev, NULL,
 		       ip_local_deliver_finish);
 }
+EXPORT_SYMBOL(ip_local_deliver);
 
 static inline bool ip_rcv_options(struct sk_buff *skb, struct net_device *dev)
 {
-- 
2.30.0.365.g02bc693789-goog

