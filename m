Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A714623FAA
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 11:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiKJKVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 05:21:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiKJKVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 05:21:51 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A35F13F20;
        Thu, 10 Nov 2022 02:21:51 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id e129so1364578pgc.9;
        Thu, 10 Nov 2022 02:21:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xIm/Oyzmfn3evXzwG3HkXqcHPzlLZjBFReRVxCcbrAk=;
        b=XDhrPgcY1K4+93HyVhQPSTJ0vB/sm8roe8+cR0Hoov6m6lmmBaBQ1Cd2KwcXos6m8c
         R7hlFZNR4mZEwWpR62nGHfj+4rH4SSDj4lSRrqxFj80256RqdHnaBmLp0zixOHADL9+y
         hAIX/hXsGAcTybCd2Ig4k0sGOfMd0dmPcNAv8G/kZD8VjU3vJxtN2wULWzY/UOjvDdQZ
         rhtrC/RpbCF1WGKHURiUm3u2UYygoEsiIH29Czty9U8QNeRsTBZXeXrgxKArXKNjvokH
         +1MklRcBYNGBZwiuDHtIoJvyYZmko4vNSXqYF0QXgoVhWxtuezTrbzWFP5O51s83RQBc
         3rZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xIm/Oyzmfn3evXzwG3HkXqcHPzlLZjBFReRVxCcbrAk=;
        b=L68RDvxQm3IAsJFGXhRnLV6uVNwXhACB6L5g27sKTNb7GuS66ZXntHiUnNaXuragM1
         7zjTc1x9SK8T16vERVwYoHWM5+4y49xOCsYbu/JaDWnYEzODcOjJH0Y1lVEgDob3jy7s
         C7hEHkX+eSIID47zJmvhJxdZ3iLWIPDqUDSLjXdh4YCvH6Ek2dKCgrF/9YNzeAVOjsRF
         5Y57hB7o7Up5OEPSSqeGeG8YK+pK+oEJDcf4Rsq3jsK2KkBEhTk1OlsskL+ZoP1MICWU
         Io36mjDIwPTDmgDF6R0GMw1GtBFw/e6otlZFQbMHvXeb7owe6IJOXYr4C3fOz8ESC/WV
         2Ctg==
X-Gm-Message-State: ACrzQf1wGRg4TmmAFYdRpPX6NH+/GTaOrhF2s35Znle18Q3G7j7McZOJ
        +mlKMEk9SlSSVVoPdhEBtww=
X-Google-Smtp-Source: AMsMyM679F6jR6QYSI/kDqrmdS98OsEZraooCbgRxeiTKXz2BMl7xPF6j70DiRZEclSvLwuctAuMzA==
X-Received: by 2002:aa7:9dd0:0:b0:56c:394d:c675 with SMTP id g16-20020aa79dd0000000b0056c394dc675mr2270370pfq.17.1668075710593;
        Thu, 10 Nov 2022 02:21:50 -0800 (PST)
Received: from localhost.localdomain ([110.147.198.134])
        by smtp.gmail.com with ESMTPSA id y13-20020aa78f2d000000b0056ddd2b5e9bsm9741907pfr.41.2022.11.10.02.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 02:21:50 -0800 (PST)
From:   Jamie Bainbridge <jamie.bainbridge@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jamie Bainbridge <jamie.bainbridge@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tcp: Add listening address to SYN flood message
Date:   Thu, 10 Nov 2022 21:21:06 +1100
Message-Id: <f847459dc0a0e2d8ffa1d290d06e0e4a226a6f39.1668075479.git.jamie.bainbridge@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SYN flood message prints the listening port number, but on a system
with many processes bound to the same port on different IPs, it's
impossible to tell which socket is the problem.

Add the listen IP address to the SYN flood message. It might have been
nicer to print the address first, but decades of monitoring tools are
watching for the string "SYN flooding on port" so don't break that.

Tested with each protcol's "any" address and a host address:

 Possible SYN flooding on port 9001. IP 0.0.0.0.
 Possible SYN flooding on port 9001. IP 127.0.0.1.
 Possible SYN flooding on port 9001. IP ::.
 Possible SYN flooding on port 9001. IP fc00::1.

Signed-off-by: Jamie Bainbridge <jamie.bainbridge@gmail.com>
---
 net/ipv4/tcp_input.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 0640453fce54b6daae0861d948f3db075830daf6..fb86056732266fedc8ad574bbf799dbdd7a425a3 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6831,9 +6831,19 @@ static bool tcp_syn_flood_action(const struct sock *sk, const char *proto)
 		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPREQQFULLDROP);
 
 	if (!queue->synflood_warned && syncookies != 2 &&
-	    xchg(&queue->synflood_warned, 1) == 0)
-		net_info_ratelimited("%s: Possible SYN flooding on port %d. %s.  Check SNMP counters.\n",
-				     proto, sk->sk_num, msg);
+	    xchg(&queue->synflood_warned, 1) == 0) {
+#if IS_ENABLED(CONFIG_IPV6)
+		if (sk->sk_family == AF_INET6) {
+			net_info_ratelimited("%s: Possible SYN flooding on port %d. IP %pI6c. %s.  Check SNMP counters.\n",
+					proto, sk->sk_num,
+					&sk->sk_v6_rcv_saddr, msg);
+		} else
+#endif
+		{
+			net_info_ratelimited("%s: Possible SYN flooding on port %d. IP %pI4. %s.  Check SNMP counters.\n",
+					proto, sk->sk_num, &sk->sk_rcv_saddr, msg);
+		}
+	}
 
 	return want_cookie;
 }
-- 
2.38.1

