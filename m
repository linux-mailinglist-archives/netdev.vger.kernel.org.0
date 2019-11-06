Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD39F2226
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 23:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732727AbfKFWwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 17:52:13 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45652 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727154AbfKFWwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 17:52:13 -0500
Received: by mail-pf1-f196.google.com with SMTP id z4so240260pfn.12;
        Wed, 06 Nov 2019 14:52:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=u2/FunqG+UkKDpn0+06WTLYPLK034XiOIhC0cH32hb0=;
        b=r7Gp67AJ5944FsNaRkIK0VzE8k70kSwtF8LpsbOJLHSXK074PHQiFDu2eEwNYuM5GL
         aHi3RAV2vkptxLiM7NlaIYx+St7ORVUaLJAjK/qzHeIqFObe8Pk0doBPXCv0TRagI/bS
         KJKDKozHexwdJPz7FhW2FUmclwtpv+dJK40maU+hsjXG/Z7h3heyL2DHDyWuATjAOZjH
         dlw59UnVlOhl7uO0SUXhA9Fei8q/0OIEdbejECPEhTJogkjQGep8IuU+yZ6nsO/nV9SK
         KRLVXCL4bwj0Kb0uimhDc97SPta19ngqXrZ5gO1tByS5h2ULCVPc+R++ElX9wNp42Upu
         i3lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=u2/FunqG+UkKDpn0+06WTLYPLK034XiOIhC0cH32hb0=;
        b=nyBWqBykw64dkFFzci+te2wik8KHb6oSISkg298KPOsAKZLcHXEEFdKm519d/vdvNY
         uoW5rJjcKnlq+3vLQ+LibuviAetqR4Xs6B0N9VKXAk589wRQir4u93XNk+Yat0QLb5Da
         pKhULrONr4MsPjPOMfuOIfdiYvRzVYGSa0ULdJRxTYI/Mz/5WK7hQNRYoBnUFF8Z0FSv
         o+V8tXjjcxZQcEARDYa9Sq5pIW0uxPgBdIYDqWfKRx1lQ9l1ASbqabkYqPTgfvwLO4y/
         2VRB+KkURJNIp2ncyMsxUoOIb+5a1wcKdn3oXkRvnmXgBM0PvVDjtjw5wHWzgCsNh480
         iO9A==
X-Gm-Message-State: APjAAAX0sYhKcp5VWVF+eqxS4glMdPWyfL5m9zKwxqNuqthgGSH06HLN
        3Z3OK1PdpKpuXftfcAH8eA==
X-Google-Smtp-Source: APXvYqwqKvO/yHrO7tYHxUprIGc69ItBfq7sQsOr1wVRxcn8zb8PQiShJz8QAXswaLRRaxjZVbhVFQ==
X-Received: by 2002:a62:6086:: with SMTP id u128mr6562692pfb.4.1573080732152;
        Wed, 06 Nov 2019 14:52:12 -0800 (PST)
Received: from localhost.localdomain ([216.52.21.4])
        by smtp.gmail.com with ESMTPSA id q26sm102679pgk.60.2019.11.06.14.52.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 06 Nov 2019 14:52:11 -0800 (PST)
From:   Praveen Chaudhary <praveen5582@gmail.com>
X-Google-Original-From: Praveen Chaudhary <pchaudhary@linkedin.com>
To:     fw@strlen.de, pablo@netfilter.org, davem@davemloft.net,
        kadlec@netfilter.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Zhenggen Xu <zxu@linkedin.com>,
        Andy Stracner <astracner@linkedin.com>
Subject: [PATCH v3] [net]: Fix skb->csum update in inet_proto_csum_replace16().
Date:   Wed,  6 Nov 2019 14:52:09 -0800
Message-Id: <1573080729-3102-2-git-send-email-pchaudhary@linkedin.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573080729-3102-1-git-send-email-pchaudhary@linkedin.com>
References: <1573080729-3102-1-git-send-email-pchaudhary@linkedin.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb->csum is updated incorrectly, when manipulation for NF_NAT_MANIP_SRC\DST
is done on IPV6 packet.

Fix:
No need to update skb->csum in function inet_proto_csum_replace16(), even if
skb->ip_summed == CHECKSUM_COMPLETE, because change in L4 header checksum field
and change in IPV6 header cancels each other for skb->csum calculation.

Signed-off-by: Praveen Chaudhary <pchaudhary@linkedin.com>
Signed-off-by: Zhenggen Xu <zxu@linkedin.com>
Signed-off-by: Andy Stracner <astracner@linkedin.com>

Reviewed-by: Florian Westphal <fw@strlen.de>
---
Changes in V2.
1.) Updating diff as per email discussion with Florian Westphal.
    Since inet_proto_csum_replace16() does incorrect calculation
    for skb->csum in all cases.
2.) Change in Commmit logs.
---

---
Changes in V3.
Addressing Pablo`s Suggesion.
1.) Updated Subject and description
2.) Added full documentation of function.
---
---
 net/core/utils.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/core/utils.c b/net/core/utils.c
index 6b6e51d..af3b5cb 100644
--- a/net/core/utils.c
+++ b/net/core/utils.c
@@ -438,6 +438,21 @@ void inet_proto_csum_replace4(__sum16 *sum, struct sk_buff *skb,
 }
 EXPORT_SYMBOL(inet_proto_csum_replace4);
 
+/**
+ * inet_proto_csum_replace16 - update L4 header checksum field as per the
+ * update in IPv6 Header. Note, there is no need to update skb->csum in this
+ * function, even if skb->ip_summed == CHECKSUM_COMPLETE, because change in L4
+ * header checksum field and change in IPV6 header cancels each other for
+ * skb->csum calculation.
+ *
+ * @sum: L4 header checksum field
+ * @skb: sk_buff for the packet
+ * @from: old IPv6 address
+ * @to: new IPv6 address
+ * @pseudohdr: True if L4 header checksum includes pseudoheader
+ *
+ * Return void
+ */
 void inet_proto_csum_replace16(__sum16 *sum, struct sk_buff *skb,
 			       const __be32 *from, const __be32 *to,
 			       bool pseudohdr)
@@ -449,9 +464,6 @@ void inet_proto_csum_replace16(__sum16 *sum, struct sk_buff *skb,
 	if (skb->ip_summed != CHECKSUM_PARTIAL) {
 		*sum = csum_fold(csum_partial(diff, sizeof(diff),
 				 ~csum_unfold(*sum)));
-		if (skb->ip_summed == CHECKSUM_COMPLETE && pseudohdr)
-			skb->csum = ~csum_partial(diff, sizeof(diff),
-						  ~skb->csum);
 	} else if (pseudohdr)
 		*sum = ~csum_fold(csum_partial(diff, sizeof(diff),
 				  csum_unfold(*sum)));
-- 
2.7.4

