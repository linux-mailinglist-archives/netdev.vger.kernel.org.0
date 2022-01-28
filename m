Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D3849F462
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 08:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346834AbiA1Hd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 02:33:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346823AbiA1Hd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 02:33:57 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669D7C061714;
        Thu, 27 Jan 2022 23:33:57 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id d18so5148869plg.2;
        Thu, 27 Jan 2022 23:33:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rmUqM+JYtP9hKEr5gUjT2LuBcGNasQZbfimvB5akS00=;
        b=A51w6brukyQ4/JOO9YY7pEYG7W9fZTomsnU/EMNXcRRsUQ3uC0gKgk0jXMHSK4Ff1Y
         knHTRConLJa4UM5sVQBXsL/It2YNTDFJsqH8sFuuUAlAtLr1y8+NMt/rMjhaa8C9jLmu
         quDYJRA+fw0KrSga5501g220oYiqi5SI6oLK6+16PhWAkUbzKAimfwlGtZHfQNEofWzT
         LPPmWS7UrdAiD+FuKSke+A98FgEbSiSAqi7JlCvjc8TrtkBHQENalLXQtaKXqKfHVKYQ
         WL3r4QJMtjjyLfMHzIc3xoGpXTkVEFsC7H3wKpc624PAJcrUS7rY7E0awQ/2P6stSEEk
         Z1Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rmUqM+JYtP9hKEr5gUjT2LuBcGNasQZbfimvB5akS00=;
        b=oyOcpKNwCVI12HtmN9mev+m2SbreLvDinTR21jz81iPTXwem9etqjV/k/ftw/6dfFj
         9s+KKoUxzXQ5bBgKBPZW4PiB5PHzjp8bJlplailoqG5Wzp3kBh8Lqv3ZuT9SFMB8gMC9
         N1Hd2pzWV2gOtACdlMBJd/bfQcoKAsJXeTOze6hclm2BcnHEH4Ijizd8zimc7zTvnZUG
         FJHwbMXVRiFSM+zfD8jhH/0G0gdDczTsuRwp6OJ1OKKk+nBZ+5DXwFWnBJOtUfrnZBMq
         3QBbbbo53AZXP/h4LkFwFuKxFBhxVLJFJqfCOVjPryyZDXOL6NzFzzo5ZEMDj793myyt
         ZynQ==
X-Gm-Message-State: AOAM532UoQQTs5Si0vVDW7zgdg4BmzFipOMVAs7JsXKUPrlDfQtyGl4T
        raciZ5KjQwh8g+6CTgyt5C4=
X-Google-Smtp-Source: ABdhPJzen6GbyG5Hj9xj0f5UIHVBNzYusLx/GOWAooc4fha5g5Z8xsPHIeDAMtQvQGC2tCh00CA9yw==
X-Received: by 2002:a17:903:41c6:: with SMTP id u6mr1885132ple.6.1643355237000;
        Thu, 27 Jan 2022 23:33:57 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id q17sm8548846pfu.160.2022.01.27.23.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 23:33:56 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, imagedong@tencent.com, edumazet@google.com,
        alobakin@pm.me, paulb@nvidia.com, keescook@chromium.org,
        talalahmad@google.com, haokexin@gmail.com, memxor@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        cong.wang@bytedance.com, mengensun@tencent.com
Subject: [PATCH v3 net-next 2/7] net: netfilter: use kfree_drop_reason() for NF_DROP
Date:   Fri, 28 Jan 2022 15:33:14 +0800
Message-Id: <20220128073319.1017084-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220128073319.1017084-1-imagedong@tencent.com>
References: <20220128073319.1017084-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Replace kfree_skb() with kfree_skb_reason() in nf_hook_slow() when
skb is dropped by reason of NF_DROP. Following new drop reasons
are introduced:

SKB_DROP_REASON_NETFILTER_DROP

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v2:
- add document for SKB_DROP_REASON_NETFILTER_DROP
---
 include/linux/skbuff.h     | 1 +
 include/trace/events/skb.h | 1 +
 net/netfilter/core.c       | 3 ++-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 5c5615a487e7..786ea2c2334e 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -320,6 +320,7 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_TCP_CSUM,	/* TCP checksum error */
 	SKB_DROP_REASON_SOCKET_FILTER,	/* dropped by socket filter */
 	SKB_DROP_REASON_UDP_CSUM,	/* UDP checksum error */
+	SKB_DROP_REASON_NETFILTER_DROP,	/* dropped by netfilter */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index a8a64b97504d..3d89f7b09a43 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -16,6 +16,7 @@
 	EM(SKB_DROP_REASON_TCP_CSUM, TCP_CSUM)			\
 	EM(SKB_DROP_REASON_SOCKET_FILTER, SOCKET_FILTER)	\
 	EM(SKB_DROP_REASON_UDP_CSUM, UDP_CSUM)			\
+	EM(SKB_DROP_REASON_NETFILTER_DROP, NETFILTER_DROP)	\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 354cb472f386..d1c9dfbb11fa 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -621,7 +621,8 @@ int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state,
 		case NF_ACCEPT:
 			break;
 		case NF_DROP:
-			kfree_skb(skb);
+			kfree_skb_reason(skb,
+					 SKB_DROP_REASON_NETFILTER_DROP);
 			ret = NF_DROP_GETERR(verdict);
 			if (ret == 0)
 				ret = -EPERM;
-- 
2.34.1

