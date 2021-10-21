Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23BE8436797
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 18:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbhJUQZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 12:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbhJUQZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 12:25:28 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47BEEC061764
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 09:23:12 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id o4-20020a17090a3d4400b001a1c8344c3fso1413202pjf.3
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 09:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YwyvtW42o6k4NUXLTo2LNQBxBmdqEY5CXK69JvWzulU=;
        b=PsJEs4pJ58s5qcVOH2dtX32J36DG3dBrAYKkUyxm73TTbrlpfHqYozACZY6L7Mhi3q
         GWrGeUbJPfoTzv8n+NnJBzJ+rB17KgCJJpQDns2qOeD6c83YYIc7cLQletI54Hn4jOqZ
         3AwvWSrJNApN3EztyT0+BSOcigVFswezc9Q+Fu0A2HlkNUsoSadmex598Fq7lWuSqegm
         oFNaXdGVagRZu90YP0gPLdasVhkc4KAGRjB1LtnB80jVgL9acDQnlk+MmLDgr53pZcJF
         UelZ5JYLMrmjl5RBMXmveujdpiCOm9nxadWsOHDIit8xc+hw3auLxIKoJVQt+XiF4vlu
         Dung==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YwyvtW42o6k4NUXLTo2LNQBxBmdqEY5CXK69JvWzulU=;
        b=SBDi6MIN6D6/s6k/xvb41KsGpa05MGde7PxaR0LApFHd2GP2+QHOsg3BJtfDvbwXeB
         FueQCIHJu68MHWjvfOzjZgii+qlyMI0OLeBEjzZX2ep5Yu62tgRxaVvB3sPkggBBu262
         cT4h0HVQkU1OUFdqN1pQZqHnTH3CSJkEOIDm8uFuFMN1s+8dB+zijvsSkvLMNwup/CPM
         FYuwv3w2juhTqAPJ38SYkVDfAF/6J3/0htYcZJ4P9VIedj6WlJuIAzla9TvHNKEPSLjx
         YJdseiBW/kYppOI0S3XpVNT/9PyVPfT+czOmiEYbiLm5GmSKgbWmEv9/X0u+oA68d2zN
         1Xww==
X-Gm-Message-State: AOAM532mAYL7+So17BpTnkHhjkebgEeHzDomrx7LjoswJYuAZiYN9FNn
        FDO+ZKnk9AuWpM2LDfrJxok=
X-Google-Smtp-Source: ABdhPJzPyign1MCB84l0+29usY0XSchU3YaXyaVFD1+FQHN10NeKJLPD6NzB16CMYOR/IJgtGzke3Q==
X-Received: by 2002:a17:90a:4595:: with SMTP id v21mr7678631pjg.43.1634833391799;
        Thu, 21 Oct 2021 09:23:11 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c17a:20ce:f4d9:d04c])
        by smtp.gmail.com with ESMTPSA id n22sm6719291pfo.15.2021.10.21.09.23.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 09:23:11 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH net-next 7/9] ipv4: annotate data races arount inet->min_ttl
Date:   Thu, 21 Oct 2021 09:22:51 -0700
Message-Id: <20211021162253.333616-10-eric.dumazet@gmail.com>
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
 net/ipv4/ip_sockglue.c | 5 ++++-
 net/ipv4/tcp_ipv4.c    | 7 +++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index b297bb28556ec5cf383068f67ee910af38591cc3..d5487c8580674a01df8c7d8ce88f97c9add846b6 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -1352,7 +1352,10 @@ static int do_ip_setsockopt(struct sock *sk, int level, int optname,
 			goto e_inval;
 		if (val < 0 || val > 255)
 			goto e_inval;
-		inet->min_ttl = val;
+		/* tcp_v4_err() and tcp_v4_rcv() might read min_ttl
+		 * while we are changint it.
+		 */
+		WRITE_ONCE(inet->min_ttl, val);
 		break;
 
 	default:
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index e8ca8539b436cf8a8af5b53645a25923003afc41..97b8acf726d0cdcb6b87b6ef45e366591d997a2b 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -508,7 +508,8 @@ int tcp_v4_err(struct sk_buff *skb, u32 info)
 	if (sk->sk_state == TCP_CLOSE)
 		goto out;
 
-	if (unlikely(iph->ttl < inet_sk(sk)->min_ttl)) {
+	/* min_ttl can be changed concurrently from do_ip_setsockopt() */
+	if (unlikely(iph->ttl < READ_ONCE(inet_sk(sk)->min_ttl))) {
 		__NET_INC_STATS(net, LINUX_MIB_TCPMINTTLDROP);
 		goto out;
 	}
@@ -2049,7 +2050,9 @@ int tcp_v4_rcv(struct sk_buff *skb)
 			return 0;
 		}
 	}
-	if (unlikely(iph->ttl < inet_sk(sk)->min_ttl)) {
+
+	/* min_ttl can be changed concurrently from do_ip_setsockopt() */
+	if (unlikely(iph->ttl < READ_ONCE(inet_sk(sk)->min_ttl))) {
 		__NET_INC_STATS(net, LINUX_MIB_TCPMINTTLDROP);
 		goto discard_and_relse;
 	}
-- 
2.33.0.1079.g6e70778dc9-goog

