Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6DB439C09
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 18:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234108AbhJYQvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 12:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234086AbhJYQu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 12:50:58 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5A3C061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:48:36 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id e65so11519645pgc.5
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s3s8ot4Es9NTH17Lse9dDj9nkiczkTxReRTzDV1hgqc=;
        b=Lvy6NyJQiqpXB5KvCN33Gw6wiMTdmOTBUrvVaMpUf8qkx/APUldCgwZouz3NQHHEjd
         uFzsAp/hn8vcNjiMxW7Go1SUqaYDe5sNLksbrtd1movgMm1IDokxvaaIciml6Ng0OmhP
         xQNCMyXkvwBltLiVLkrgrgX8btOL5NLIyJHmcwR4nffEcOo15KP92jl3DDpOgea8EiT0
         h55e27r8zBzai8zX1VLsOb79vvROeeqvL5BlwfC6L4W7MfDUNCb8cHY/8edi1gOmn/f/
         yVOT5SgWn9Ycp6gPWeUu+OfN9b1OH4x+JbEv3sdcrvd+HZ89klhi3BlsYy4an3YRWB8H
         u+yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s3s8ot4Es9NTH17Lse9dDj9nkiczkTxReRTzDV1hgqc=;
        b=a1J39LFuNtZZT1Iitx8oz43FQf/kz+2kHKQd8pbzQju3O6tX6g2ipj8vlAP1lsQQow
         ETsdIF9pXYPaFMsG9MeXiPFY0tbV51JTuetxsS+s1ZLyF1YXUSBjIhL3NIw/pRBU9dY1
         3FxnaEQEyg9Mhv3KCCGcxWMIvKtJBKOZcrfT9hg4TW+hvjq1WwYMOdwfI/oocj/nkAb6
         NeyFu9tHTbR32tHDeYOYuRJD0eNVnXvPlSUznx/lL9Q1D/tkuBSPB9w40dVISD6eQWey
         W82xfhUYCnPPCV3Xxk59Wtunyfilahs7OoX4xSbvX7tUJ5UZoMkO6ruuuuEBrd7nHqAK
         GjvA==
X-Gm-Message-State: AOAM530cOOJoM6J9Un3CXXZg9eiAi0Hc77ciufRSxZj80nTbLGHIIKX4
        Z1k+vtfq+7RYjMAY/xnJhaM=
X-Google-Smtp-Source: ABdhPJxv8Gh9J1CM2YOM4TgM8iIwAtYS3ZqzETs48WkBmbrlsIpElAYO0VfI7OVJQv0XZ/Htwtrvzw==
X-Received: by 2002:a63:9844:: with SMTP id l4mr14789625pgo.271.1635180516195;
        Mon, 25 Oct 2021 09:48:36 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b7cd:daa3:a144:1652])
        by smtp.gmail.com with ESMTPSA id b3sm17052582pfm.54.2021.10.25.09.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 09:48:35 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH v2 net-next 06/10] ipv6: annotate data races around np->min_hopcount
Date:   Mon, 25 Oct 2021 09:48:21 -0700
Message-Id: <20211025164825.259415-7-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211025164825.259415-1-eric.dumazet@gmail.com>
References: <20211025164825.259415-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

No report yet from KCSAN, yet worth documenting the races.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
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
index 50d9578e945bd2965247a46bc6d8b1adeb21d2f4..c93b2d48bb89a845c880679572c75a8791589525 100644
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
@@ -1726,7 +1727,8 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
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

