Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85680436795
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 18:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbhJUQZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 12:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbhJUQZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 12:25:25 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91529C061220
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 09:23:09 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id ls18so867297pjb.3
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 09:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6wiiQ7sBiLnaUvF7+3f+M8Xxmred+r5+dtf2RzCMq14=;
        b=LPktCy6yjNy1EeLbwBXG1Km3a8HUk7IbiTqOwWmjyoN5rwysX+n5L2c3Cme/8LSe7o
         lUKJNpI34irW45/+SYMcnfmxPOiOVXlCPW1kYen+ry28yX8PfRD6QndNCDMiRknj8TbH
         0o6VQESBZLvJcb0nIrRWM1KciTycvaAVM1mz3zmko1jak5BCIgEPZE6EIG3skHejdeVw
         fozpv+6WSPnvtx3vG/sXZx8yJeoWWdAP0cHSG+xZ4xg2ozUoJTHQQ5of6m9xdJ2ip5rB
         Fd5SAJpmty7hixHmLBOmJ/KKKypBsX3elmVYEHwVbRQKQ0BsElwuEByYoZlp4Ghfrtbb
         agVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6wiiQ7sBiLnaUvF7+3f+M8Xxmred+r5+dtf2RzCMq14=;
        b=hVdx5FiKu8T8MzWvQW5sL3t1KMd8FN8zZgVUj5dvLa+e99o+6scWojcZlj6kybfZZA
         bTbGKHXsk94uuAcWXULJeS9f6q2zrIQzCUoPxNI22kVSajahYmn24oNQSC/aRhczP8yB
         zcIJopVP8WuRhsB6nFjG54NJbVnkviMLq7dTwpHcOjdau0AQRUu7Pd86WRR7YUxNmPEf
         UergcbEMjK18hHht9IuFcUgfnStH0tif3c2x26scsdMLikQhE9D8R2n5E20BYx0wwACl
         ZiLbYD7Vyz6Wzw4sxEjixZ4UlCFie1SiBx8MclgPPdAM3//Rg4pttO6e8INHaZAJs2yn
         LIiA==
X-Gm-Message-State: AOAM531/+RFELvxoPSW48xxqNez3/H35P4VzpyGkZbhav5GLVm2gRGKU
        n/kuOuF5Ko5ktCrNyyPXgLQ=
X-Google-Smtp-Source: ABdhPJyxobPcNReIKYI7oxeBZHMWd6uYTpX287nCaivWAz18vHoTD8QLCIxSz28vfE5LHj5yP2VS7Q==
X-Received: by 2002:a17:90b:3ec6:: with SMTP id rm6mr7807302pjb.27.1634833389073;
        Thu, 21 Oct 2021 09:23:09 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c17a:20ce:f4d9:d04c])
        by smtp.gmail.com with ESMTPSA id n22sm6719291pfo.15.2021.10.21.09.23.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 09:23:08 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH net-next 5/9] ipv6: annotate data races around np->min_hopcount
Date:   Thu, 21 Oct 2021 09:22:49 -0700
Message-Id: <20211021162253.333616-8-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211021162253.333616-1-eric.dumazet@gmail.com>
References: <20211021162253.333616-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

No report yet from KCSAN, yet worth documenting the races.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/ipv6_sockglue.c | 5 ++++-
 net/ipv6/tcp_ipv6.c      | 6 ++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index e4bdb09c558670f342f1abad5dfd8252f497aa68..9c3d28764b5c3a47a73491ea5d656867ece4fed2 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -950,7 +950,10 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 			goto e_inval;
 		if (val < 0 || val > 255)
 			goto e_inval;
-		np->min_hopcount = val;
+		/* tcp_v6_err() and tcp_v6_rcv() might read min_hopcount
+		 * while we are changing it.
+		 */
+		WRITE_ONCE(np->min_hopcount, val);
 		retv = 0;
 		break;
 	case IPV6_DONTFRAG:
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 360c79c8e3099e54d125d454b7f5eb406678c91f..2247f525364b16e89afedbec8f4ec3367bf88aa8 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -414,7 +414,8 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	if (sk->sk_state == TCP_CLOSE)
 		goto out;
 
-	if (ipv6_hdr(skb)->hop_limit < tcp_inet6_sk(sk)->min_hopcount) {
+	/* min_hopcount can be changed concurrently from do_ipv6_setsockopt() */
+	if (ipv6_hdr(skb)->hop_limit < READ_ONCE(tcp_inet6_sk(sk)->min_hopcount)) {
 		__NET_INC_STATS(net, LINUX_MIB_TCPMINTTLDROP);
 		goto out;
 	}
@@ -1723,7 +1724,8 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 			return 0;
 		}
 	}
-	if (hdr->hop_limit < tcp_inet6_sk(sk)->min_hopcount) {
+	/* min_hopcount can be changed concurrently from do_ipv6_setsockopt() */
+	if (hdr->hop_limit < READ_ONCE(tcp_inet6_sk(sk)->min_hopcount)) {
 		__NET_INC_STATS(net, LINUX_MIB_TCPMINTTLDROP);
 		goto discard_and_relse;
 	}
-- 
2.33.0.1079.g6e70778dc9-goog

