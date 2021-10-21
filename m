Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C16436799
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 18:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbhJUQZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 12:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbhJUQZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 12:25:31 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0669AC0613B9
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 09:23:15 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id f21so790707plb.3
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 09:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Tp6na0t+X0SDpQWMbmuqv49PPB2H80BGCxXgsnVFAKA=;
        b=WVQZQE5fOD4sEF+Nx0tVIzfC45Dt2Gf3WW5OvZVn3V9CDBx1lQXnPYcF44JnNogp80
         JZ8YvkWsJgRRUpBqqKWpJXMrqhrrlPNHd6gC6G2ndkvkjr4rhAZhWxIl2i/0XHYVh1xr
         fBy76gUx+2G072EIBp0qgkjHK26clTN1feogvO/xh4oOogugbGY5hgtO8WBb6mmdB9MJ
         ygKGFc54CeBvsy1lWBGvN85CdvjsCIzInK4q0hXnMR+nOhRbsGvOLpWWbElmk4t3VKPQ
         UR19YzaSp5JhMef31WNedvnAYLtt0eju5yMXIitlBKhLGU8kJutYbXkENhhglo6fNZHG
         B5+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Tp6na0t+X0SDpQWMbmuqv49PPB2H80BGCxXgsnVFAKA=;
        b=wpAO4/0Rofy5LdeyFEQKpYTyu5ZX0CsBZ03LAS3lI67nVbCx83seWim0NRdQcizXg3
         f/2clKKz6lnty4uIRVQ4fUHExNu3/qXSOuhR7Qe0uXRwMU2v8HlJ9QpKdNOYoDyYsa9i
         qTtQ0CTWRTFkgtReZxDx44o1ND+W4S5jhASdunJqjJKFCmHW3wUK5K9Iufcz7+cRg3Cf
         5hc7vaSoeKDj4X+J/Hk/OHKuA8Xq9wpFmEPTNX2b9bw0KYfrOlzfb6+717ZiSvduJMtI
         cQfhRwuRStwFiL0DIWcNHOth6PYjpHl3KrpCS4D1D2ohtJJhZ/aiUsjHEqAsWYqoA8a0
         UAlg==
X-Gm-Message-State: AOAM533qdEaaX/UwGRwP1Bi9AoP/QKbR4HjHuIn0G97pkB4gGqFzbvrd
        bKn+HcyfUWomMURPuliAp8I=
X-Google-Smtp-Source: ABdhPJwsQ058r0n3kPEKxq1mSXoDAOX+mLtGecM3rDLHpn0DimpfIgZPEOo7dRU0xC6/q34aV2jTkA==
X-Received: by 2002:a17:90b:4a05:: with SMTP id kk5mr7728353pjb.25.1634833394633;
        Thu, 21 Oct 2021 09:23:14 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c17a:20ce:f4d9:d04c])
        by smtp.gmail.com with ESMTPSA id n22sm6719291pfo.15.2021.10.21.09.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 09:23:14 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH net-next 9/9] ipv6/tcp: small drop monitor changes
Date:   Thu, 21 Oct 2021 09:22:53 -0700
Message-Id: <20211021162253.333616-12-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211021162253.333616-1-eric.dumazet@gmail.com>
References: <20211021162253.333616-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Two kfree_skb() calls must be replaced by consume_skb()
for skbs that are not technically dropped.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/tcp_ipv6.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index bbff3df27d1c24d7a47849b28297ba129baafc99..5504564f7e252e048df456156cf1183b5f01826c 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -572,7 +572,7 @@ static int tcp_v6_send_synack(const struct sock *sk, struct dst_entry *dst,
 static void tcp_v6_reqsk_destructor(struct request_sock *req)
 {
 	kfree(inet_rsk(req)->ipv6_opt);
-	kfree_skb(inet_rsk(req)->pktopts);
+	consume_skb(inet_rsk(req)->pktopts);
 }
 
 #ifdef CONFIG_TCP_MD5SIG
@@ -1591,7 +1591,7 @@ static int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 		}
 	}
 
-	kfree_skb(opt_skb);
+	consume_skb(opt_skb);
 	return 0;
 }
 
-- 
2.33.0.1079.g6e70778dc9-goog

