Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECD962521B
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 05:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbiKKEDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 23:03:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232728AbiKKECi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 23:02:38 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B3F6BDDE;
        Thu, 10 Nov 2022 20:01:02 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id y203so3880592pfb.4;
        Thu, 10 Nov 2022 20:01:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BWnTIIQeoks9JfmRMbsiRNYxrY/7LOgk1YEB5MJbrY4=;
        b=R+zS9sgm9JYzIh8VWXJ3esOJ75LGdDqWGdcsMdrYjo5gF5dtVtB7TIGhhO/fsxaWUN
         CPuCD3Jb/30Z9q1QQmGqwrDhGBxl79hW530Zb84WGvIToP8eTGroJq7Npq3RDhKjR8+I
         zaSkECDr2nCb/esq7hF091xrJXqWAOGw+JA0ki2CPQn6TyHeN7NjjK/0josBSJZtfgMH
         fcv9ifbJcojN9alevhDNg88Cv67iwP+OF1S4u32cMaesEwC9T7RTjEdcgXnHmFexo9hK
         /0HTAJzjjQ/VQYSjutzKFHeFmhgHNoBiFiGpiewk0h8m8TYL4aeo10uffG2oE49U87YA
         fNrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BWnTIIQeoks9JfmRMbsiRNYxrY/7LOgk1YEB5MJbrY4=;
        b=eCZ+EeaCQu0bqogl70AkLiAPVfrgsLbJG7xVZaQjtB4BQVc6zsi3/xAd662xmC9jsS
         x0K91/jzycVNn0VxVICWGnRyMo7nXySO4KDXqEVq7rMdFzqfmkkv33ohJCFO9kxmjHMj
         PQhSEUiAsLccloiICjAtvZo9J8ML2BSzsMjFhVYqpLKI6KC8L5rPJRFjJYFtOb4wml6P
         sUxxG2K5m7BarwweSMV8p7JZHexDkyVJopWahT6nsSj3KbkkDW2DVVYsxXHHWBoxc+Sq
         gxdof5svcdwhl2hmk/GQyejTQMu2JrzT6vbEbmnm4SvHuAM2zXYWT26UpGgVKagb+31k
         DUZg==
X-Gm-Message-State: ANoB5pkbGic72OkIJ8huzm5cPPARY/iNl2skJqq4k78usmLL8xs8KQEv
        jM2SdSJNOzYPakGd5E0+UHY=
X-Google-Smtp-Source: AA0mqf4opk2VEFwESZfXyg3GMlRHYyF5qgXyV3DKfVhttC+UiUzjzKTTkANZ0EWkZ++C/HwA4NPMmw==
X-Received: by 2002:a62:1494:0:b0:56d:4670:6e2a with SMTP id 142-20020a621494000000b0056d46706e2amr683601pfu.77.1668139260816;
        Thu, 10 Nov 2022 20:01:00 -0800 (PST)
Received: from localhost.localdomain ([110.147.198.134])
        by smtp.gmail.com with ESMTPSA id t2-20020a170902b20200b00186fa988a13sm486875plr.166.2022.11.10.20.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 20:01:00 -0800 (PST)
From:   Jamie Bainbridge <jamie.bainbridge@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jamie Bainbridge <jamie.bainbridge@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] tcp: Add listening address to SYN flood message
Date:   Fri, 11 Nov 2022 14:59:32 +1100
Message-Id: <7ccd58e8e26bcdd82e66993cbd53ff59eebe3949.1668139105.git.jamie.bainbridge@gmail.com>
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

The SYN flood message prints the listening port number, but with many
processes bound to the same port on different IPs, it's impossible to
tell which socket is the problem.

Add the listen IP address to the SYN flood message in the "IP.port"
format like most other tools (eg: tcpdump).

Each protcol's "any" address and a host address now look like:

 Possible SYN flooding on port 0.0.0.0.9001.
 Possible SYN flooding on port 127.0.0.1.9001.
 Possible SYN flooding on port ::.9001.
 Possible SYN flooding on port fc00::1.9001.

Signed-off-by: Jamie Bainbridge <jamie.bainbridge@gmail.com>
---
v2: Place IS_ENABLED() inside if condition c/o Andrew Lunn.
    Change port printf to unsigned c/o Stephen Hemminger.
    Remove long and unhelpful "Check SNMP counters" c/o Stephen.
    Use IP.port format c/o Eric Dumazet.
---
 net/ipv4/tcp_input.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 0640453fce54b6daae0861d948f3db075830daf6..5b156dfc13b3d45c20e4fe6a45af7c42f39b2c66 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6831,9 +6831,17 @@ static bool tcp_syn_flood_action(const struct sock *sk, const char *proto)
 		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPREQQFULLDROP);
 
 	if (!queue->synflood_warned && syncookies != 2 &&
-	    xchg(&queue->synflood_warned, 1) == 0)
-		net_info_ratelimited("%s: Possible SYN flooding on port %d. %s.  Check SNMP counters.\n",
-				     proto, sk->sk_num, msg);
+	    xchg(&queue->synflood_warned, 1) == 0) {
+		if (IS_ENABLED(CONFIG_IPV6) && sk->sk_family == AF_INET6) {
+			net_info_ratelimited("%s: Possible SYN flooding on port %pI6c.%u. %s.\n",
+					proto, &sk->sk_v6_rcv_saddr,
+					sk->sk_num, msg);
+		} else {
+			net_info_ratelimited("%s: Possible SYN flooding on port %pI4.%u. %s.\n",
+					proto, &sk->sk_rcv_saddr,
+					sk->sk_num, msg);
+		}
+	}
 
 	return want_cookie;
 }
-- 
2.38.1

