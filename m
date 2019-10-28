Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF136E7C56
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 23:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbfJ1W2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 18:28:11 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35234 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726940AbfJ1W2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 18:28:10 -0400
Received: by mail-pl1-f196.google.com with SMTP id x6so2383947pln.2;
        Mon, 28 Oct 2019 15:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SLsHdSpGVghNKZAiodqcIoULrVap1KUhD8kKjq3mW3w=;
        b=etrXUoaoXhqfA3Q1EsxZxmK/UylppXThWsAkHLSrPRyhpTBBcNvvrE9zjHDnKQQ909
         CODjX43WiLRzKgDae2iOOmxdsD2wf8ZF6cQQn5ax8Kuu9sfgxEqiTHiXGhczYhK2kBbM
         yn0X1x1JBOnNKgAiBB0oK33KGoExQKL+qx81qpuXBjeg/FNu9F4PL9bQNFlT+TVryPVj
         QM+40wMH5Azwuk4fVktYRVE+hEtsXzs7nWoulBTwtGh1oeE+U439MoTXq51IhxlwEnaR
         IiNX+DoUOyRWbwsphzgtR5kIdeUxXxdkR+75rRqckCxygdljuI4CobNSflzV63cjQAB5
         Kv7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SLsHdSpGVghNKZAiodqcIoULrVap1KUhD8kKjq3mW3w=;
        b=Sr52vXa+41f5OM+a9V7iOb+q2syf+FK1D/ZzGCArfrRyJskDpW9pi6ED4eWxTCqWbi
         omAVc5/z63PSjIcET4yRHUt/y1kAcjm9IBTNaxqIAVc/aDJGPkyXVe1S2ATwtLtQITdR
         mwfRbLgQqzcnxaNxnI0qzytKrnIqe4mLrrxS5BL0c9/mGY38GErASVdt8WRQ0GHzHF6e
         NYpvOfVl/mE4VDbYmC/4vxZLYwm9o44Z3YVlzR2ak2iv/BRuvWSXfwHdUwFvFtnpzTWo
         sNTj67pw/Gij4fYJPb+JI7RjxoeCFIHKarq2bmxIi9poGgJbOuXaFc1HrckNdAAInvsN
         xfEg==
X-Gm-Message-State: APjAAAXl77y3wu+tcdrLsmh0y5U/mJqOvXElGFT5UA9u08ZorBwl3OZM
        Qz0QfIluE/kWcqufu3ZdAQ==
X-Google-Smtp-Source: APXvYqxTiC2yKJTCrJObOPIWqo/33IL+bt/CPiCOSqR/SAp/3gnhsThPcUTZEgRt84EktFmQmi311w==
X-Received: by 2002:a17:902:6901:: with SMTP id j1mr402271plk.185.1572301688154;
        Mon, 28 Oct 2019 15:28:08 -0700 (PDT)
Received: from localhost.localdomain ([216.52.21.4])
        by smtp.gmail.com with ESMTPSA id p4sm483060pjo.3.2019.10.28.15.28.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 28 Oct 2019 15:28:07 -0700 (PDT)
From:   Praveen Chaudhary <praveen5582@gmail.com>
X-Google-Original-From: Praveen Chaudhary <pchaudhary@linkedin.com>
To:     davem@davemloft.net, fw@strlen.de, kadlec@netfilter.org,
        pablo@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Zhenggen Xu <zxu@linkedin.com>,
        Andy Stracner <astracner@linkedin.com>
Subject: [PATCH] [netfilter]: Fix skb->csum calculation when netfilter manipulation for NF_NAT_MANIP_SRC\DST is done on IPV6 packet.
Date:   Mon, 28 Oct 2019 15:27:55 -0700
Message-Id: <1572301675-5403-2-git-send-email-pchaudhary@linkedin.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1572301675-5403-1-git-send-email-pchaudhary@linkedin.com>
References: <1572301675-5403-1-git-send-email-pchaudhary@linkedin.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No need to update skb->csum in function inet_proto_csum_replace16(),
even if skb->ip_summed == CHECKSUM_COMPLETE, because change in L4
header checksum field and change in IPV6 header cancels each other
for skb->csum calculation.

Signed-off-by: Praveen Chaudhary <pchaudhary@linkedin.com>
Signed-off-by: Zhenggen Xu <zxu@linkedin.com>
Signed-off-by: Andy Stracner <astracner@linkedin.com>
---
Changes in V2.
1.) Updating diff as per email discussion with Florian Westphal.
    Since inet_proto_csum_replace16() does incorrect calculation
    for skb->csum in all cases.
2.) Change in Commmit logs.
---
---
 net/core/utils.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/core/utils.c b/net/core/utils.c
index 6b6e51d..cec9924 100644
--- a/net/core/utils.c
+++ b/net/core/utils.c
@@ -438,6 +438,12 @@ void inet_proto_csum_replace4(__sum16 *sum, struct sk_buff *skb,
 }
 EXPORT_SYMBOL(inet_proto_csum_replace4);
 
+/**
+ * No need to update skb->csum in this function, even if
+ * skb->ip_summed == CHECKSUM_COMPLETE, because change in
+ * L4 header checksum field and change in IPV6 header
+ * cancels each other for skb->csum calculation.
+ */
 void inet_proto_csum_replace16(__sum16 *sum, struct sk_buff *skb,
 			       const __be32 *from, const __be32 *to,
 			       bool pseudohdr)
@@ -449,9 +455,6 @@ void inet_proto_csum_replace16(__sum16 *sum, struct sk_buff *skb,
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

