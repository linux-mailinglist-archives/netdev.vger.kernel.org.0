Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 428416273F8
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 02:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235524AbiKNBAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 20:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233069AbiKNBAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 20:00:19 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A936FCE08;
        Sun, 13 Nov 2022 17:00:18 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id y203so9667254pfb.4;
        Sun, 13 Nov 2022 17:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Sxm0v4ki9XH0i93sKSXzV9I8SQkMNsVCRGZp4tRqchU=;
        b=gDcUauMnLRDVoMQppoMjGo5pQxvTnfAb8QxYhVyzyYjl1PoGmSsU0ipmvAUn8skJRD
         DYeUf1hNZAhOtnIr6Ecq4I5i/pUNLPyS17ZtBopqB5motUzw14wcn4w6WWn1f7wOy8XH
         +1AOfqW8wUdCVpoMohFYiUB4MK3/Y7lQvAKNpyJb3+hOAqL40Kj2ABPEXgYDavlakPx0
         jBcZxtChJXYwm73O12yLS/5bBavqNHB45FmnRvLKRTpo+OpIj8bVH0EeeXk04UngrI+v
         CwLMnDUAtoXDEYl8toKbNUViKLgP6Zw7acyYsOHzo1d9xMiL8pExzHSoqlGcaijabZlD
         C9MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sxm0v4ki9XH0i93sKSXzV9I8SQkMNsVCRGZp4tRqchU=;
        b=NP2FurV6rl8Z9Chtt1WOXTTBOweozOMBSauAQl+vie32VRTrO8v6gZHiMjuQzdHMyW
         4ZB5HEQnylHQdchtIdnrGfFYFz1OPFkug500sq7LYDdJfoXlaJ4qDFLADKKg9FDMbFKN
         X6RLMkbwrFpWygrbWmG4wD5iUH+PC767DtE0ZTyYJP2VtJoc1YSqrxMV11V0vfKPs9iu
         gMpu5Gnr2qAiSzzy48sb0cV72jG8S0+XwEBsLhVRjVho214tTIUmQ29SCHqr+K9wASRH
         zxMNOq+q6B2x5l9aBaVP8rpefcWIm3ncgkNQ2xTTo/64McB8pWnGpxsL7h86pz9roU6f
         DKXw==
X-Gm-Message-State: ANoB5pkgiydo41PRdBWa8/Z9KL2mfOXkMw5SvMu4Xgjbj78q946TplsF
        hM/1Ea/6pSyO6alau8o9FHQ=
X-Google-Smtp-Source: AA0mqf7ZAScJgvE2SqnIyJSc3nzXq8V1qszOi3zGEMBpzWO4efW1GuVNtUqCjXguLGVg/kLE4SIBgA==
X-Received: by 2002:a63:d156:0:b0:46e:beb0:9d2c with SMTP id c22-20020a63d156000000b0046ebeb09d2cmr10307426pgj.117.1668387618213;
        Sun, 13 Nov 2022 17:00:18 -0800 (PST)
Received: from localhost.localdomain ([181.41.202.223])
        by smtp.gmail.com with ESMTPSA id r17-20020a170903411100b00186c3727294sm5780740pld.270.2022.11.13.17.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Nov 2022 17:00:17 -0800 (PST)
From:   Jamie Bainbridge <jamie.bainbridge@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jamie Bainbridge <jamie.bainbridge@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] tcp: Add listening address to SYN flood message
Date:   Mon, 14 Nov 2022 12:00:08 +1100
Message-Id: <4fedab7ce54a389aeadbdc639f6b4f4988e9d2d7.1668386107.git.jamie.bainbridge@gmail.com>
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

Add the listen IP address to the SYN flood message.

For IPv6 use "[IP]:port" as per RFC-5952 and to provide ease of
copy-paste to "ss" filters. For IPv4 use "IP:port" to match.

Each protcol's "any" address and a host address now look like:

 Possible SYN flooding on port 0.0.0.0:9001.
 Possible SYN flooding on port 127.0.0.1:9001.
 Possible SYN flooding on port [::]:9001.
 Possible SYN flooding on port [fc00::1]:9001.

Signed-off-by: Jamie Bainbridge <jamie.bainbridge@gmail.com>
---
v2: Place IS_ENABLED() inside if condition c/o Andrew Lunn.
    Change port printf to unsigned c/o Stephen Hemminger.
    Remove long and unhelpful "Check SNMP counters" c/o Stephen H.
v3: Use "IP:port" format c/o Eric Duamzet and Stephen H.
---
 net/ipv4/tcp_input.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 0640453fce54b6daae0861d948f3db075830daf6..6e51d8eefe19075721ec6d31036ecae9b6e0d698 100644
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
+			net_info_ratelimited("%s: Possible SYN flooding on port [%pI6c]:%u. %s.\n",
+					proto, &sk->sk_v6_rcv_saddr,
+					sk->sk_num, msg);
+		} else {
+			net_info_ratelimited("%s: Possible SYN flooding on port %pI4:%u. %s.\n",
+					proto, &sk->sk_rcv_saddr,
+					sk->sk_num, msg);
+		}
+	}
 
 	return want_cookie;
 }
-- 
2.38.1

