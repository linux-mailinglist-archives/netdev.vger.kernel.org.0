Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 680DC14729A
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 21:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbgAWUdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 15:33:42 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44963 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbgAWUdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 15:33:41 -0500
Received: by mail-pl1-f196.google.com with SMTP id d9so1824258plo.11;
        Thu, 23 Jan 2020 12:33:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=f0+S9564eaUdaVntJFA619acREnhDqTMtFRxd+yrr/g=;
        b=XDS7ahLWl3lQUIyBeoFQ3YBHYyZ9lM3910LDhcOemIhoy43IGRDMNMp6AkKiD1JNTI
         WOkiQh9+7iFGfdUJgwm2Y33pI0rANe3TM1qjsPFG3vMVGnuQDeMY/9PB5zxVdeVVDLdC
         LeQBCjGnb3jVrx8tSfJR8EbcsSBa3Fg+I+WECWrJKuZPwPVoC5jqv7tN0T41ipfk0pu2
         1iDEvmvhP5pAei6lHWdrgrP4cmwH3JBPuOYJmpqSIHMPaVC2huOdhq6hfQ7VNnl5vctY
         AMmu22ail4Rnu4aQES2K4DgqyM5ZTRTCkej3G1eUWZTi/rYkjD/L7cBSPno2etWxpxPn
         hh6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=f0+S9564eaUdaVntJFA619acREnhDqTMtFRxd+yrr/g=;
        b=Uu5iLoc2FTjQdKgYtu4O8HAsHr4OHq7BjsHfO08LbsKKspt4FCmDmjsq+GjzVFnF51
         ByzL1Q0voNckrWuFYx9rYbBGgVGUgJRvyVbxJE55EAV0gE8b7KwDDkbab9iiBF/ofHtm
         quEbvFJWxSoMftpMmEIzeJGq9ghT8C4NW1MCPpLASEd7x3OarBA/+tYc/AFM2Z8mdVcG
         G/xwo9ArWv7dlw0x1CNAIrmdVnqQkt1/Wcsb5fG1PsVeycPsS7q6xpGHQJUvz0Aj1xv0
         fR2n5ii3T9xt8Tbm6g/LWzEgoERErAZiA+lrS9RMsRZ/P6+p60PASZl5xGjFOBUGoyjW
         V97Q==
X-Gm-Message-State: APjAAAUyI3fzNVIQ2GdQ4Ei/XK0RyBvQ7WoW5+WfF06aCYTjHIt1rL8W
        OGcpkLcE5NscLJ2+oq9yOg==
X-Google-Smtp-Source: APXvYqwa0AUWXoRz1qA3JM82TYC9l3mMKiMkL4N+M+/KAdVOC+b8cSaX0Y5XUqvN78D74Iidc6fjwQ==
X-Received: by 2002:a17:902:b407:: with SMTP id x7mr18081270plr.301.1579811620224;
        Thu, 23 Jan 2020 12:33:40 -0800 (PST)
Received: from localhost.localdomain ([216.52.21.4])
        by smtp.gmail.com with ESMTPSA id 71sm3816790pfb.123.2020.01.23.12.33.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 23 Jan 2020 12:33:39 -0800 (PST)
From:   Praveen Chaudhary <praveen5582@gmail.com>
X-Google-Original-From: Praveen Chaudhary <pchaudhary@linkedin.com>
To:     fw@strlen.de, pablo@netfilter.org, davem@davemloft.net,
        kadlec@netfilter.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Zhenggen Xu <zxu@linkedin.com>,
        Andy Stracner <astracner@linkedin.com>
Subject: [PATCH v4] [net]: Fix skb->csum update in inet_proto_csum_replace16().
Date:   Thu, 23 Jan 2020 12:33:28 -0800
Message-Id: <1579811608-688-2-git-send-email-pchaudhary@linkedin.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1579811608-688-1-git-send-email-pchaudhary@linkedin.com>
References: <20200123142929.GV795@breakpoint.cc>
 <1579811608-688-1-git-send-email-pchaudhary@linkedin.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb->csum is updated incorrectly, when manipulation for NF_NAT_MANIP_SRC\DST
is done on IPV6 packet.

Fix:
There is no need to update skb->csum in inet_proto_csum_replace16(), because
update in two fields a.) IPv6 src/dst address and b.) L4 header checksum
cancels each other for skb->csum calculation.
Whereas inet_proto_csum_replace4 function needs to update skb->csum,
because update in 3 fields a.) IPv4 src/dst address, b.) IPv4 Header checksum
and c.) L4 header checksum results in same diff as L4 Header checksum for
skb->csum calculation.

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
Changes in V4.
Addressing Daniel`s Suggesion.
1.) Updated Commit Message.
2.) Updated documentation of function to include, why inet_proto_csum_replace4
    needs to update skb->csum.
---
---
 net/core/utils.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/net/core/utils.c b/net/core/utils.c
index 6b6e51d..e2f8290 100644
--- a/net/core/utils.c
+++ b/net/core/utils.c
@@ -438,6 +438,25 @@ void inet_proto_csum_replace4(__sum16 *sum, struct sk_buff *skb,
 }
 EXPORT_SYMBOL(inet_proto_csum_replace4);
 
+/**
+ * inet_proto_csum_replace16 - update L4 header checksum field as per the
+ * update in IPv6 src/dst address.
+ * Note: there is no need to update skb->csum in this function, because
+ * update in two fields a.) IPv6 src/dst address and b.) L4 header checksum
+ * cancels each other for skb->csum calculation.
+ * Whereas inet_proto_csum_replace4 function needs to update skb->csum,
+ * because update in 3 fields a.) IPv4 src/dst address, b.) IPv4 Header checksum
+ * and c.) L4 header checksum results in same diff as L4 Header checksum for
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
@@ -449,9 +468,6 @@ void inet_proto_csum_replace16(__sum16 *sum, struct sk_buff *skb,
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

