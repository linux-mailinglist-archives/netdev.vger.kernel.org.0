Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEC75E68CE
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 18:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiIVQuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 12:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231615AbiIVQul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 12:50:41 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82C2E9CE9
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 09:50:40 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id fs14so10366928pjb.5
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 09:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=qk+UZ5UXgMzkB4GoBNYkt+GxFVxX/1Bl76a1aryb1Ec=;
        b=Wm9Ot9wniz5QVmesxO+He2mKkAuEH7q5xX2oj9RBVXaPF2oqOT0BxnNMGQuCA1eJEx
         aFpVx/9QuAYGt4ljiTUXJAuRZ10DSWvjMfF/FHptVihHqX1Swn2YpjvRImFlrbgdtRTU
         vVkxyYT8q46LiiZ325Bmq0QHzoaGNsx3y8N2wCNPhrDEb7QRqeE5Gk1EdoA93cvAfg7n
         RA1NJjaXtJo550TvUwH44qHPem8c0nfxmAgKfWdt2/a1lIwse8b6QqwDHAVMBxXdXa9z
         12iAKJOwfPI2V9/X5nLV1qKEHoWNt1oWdPsd2Csk4R5ATHv8kMp0ZfnvcfXPAlW08BL6
         AX5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=qk+UZ5UXgMzkB4GoBNYkt+GxFVxX/1Bl76a1aryb1Ec=;
        b=ISugE0NsbGZ2W5O+Q15CAiR6i7Q4dPfjCvEb/t1LbogfT84nGaNTQGyKquKCUKmEiX
         TktB+nqM1/gljv7Xq7FtKTN0pKPAzepXM/gV8ON+0lJ1rmCUhUylBV0z62IpP0AbGcKz
         lLfTqcn8oOuz22YWbWnKkZQtabo+yFocRYo83bwFE5tK15RVIGLMtSMZHsHcj2tVbWDJ
         nltE9zkxupnB8TQXFjL0u1yUQf5rrYLzV7GHGqABD1tnorETYgrxIcGu02D2sNlCPaKY
         gH80PdllIY8wWg6cUunMpelW8c1QaT1smPF6/1nLOP62j842fiuqQ+7hkAnmesaOKzS8
         j2Cg==
X-Gm-Message-State: ACrzQf1zLIL97+7RCQ15Kc1z94z8FcM/xrxZjkwaBYYlvwWwTUdQwXEm
        C701WntYPM2fRyDp+u97thIA8XxlGto=
X-Google-Smtp-Source: AMsMyM61ArqnqqqR0TGiMncLtkU6qutjlTmNb9ysNIuX6eLjlmihspZk2YDXw9qX/zvc+5C0tCXdMg==
X-Received: by 2002:a17:902:d503:b0:178:2663:dc8e with SMTP id b3-20020a170902d50300b001782663dc8emr4188344plg.52.1663865440242;
        Thu, 22 Sep 2022 09:50:40 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:1de5:4256:3093:37f4])
        by smtp.gmail.com with ESMTPSA id 128-20020a620586000000b0053ea3d2ecd6sm4663947pff.94.2022.09.22.09.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 09:50:39 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] ipv6: tcp: send consistent autoflowlabel in RST packets
Date:   Thu, 22 Sep 2022 09:50:36 -0700
Message-Id: <20220922165036.1795862-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
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

From: Eric Dumazet <edumazet@google.com>

Blamed commit added a txhash parameter to tcp_v6_send_response()
but forgot to update tcp_v6_send_reset() accordingly.

Fixes: aa51b80e1af4 ("ipv6: tcp: send consistent autoflowlabel in SYN_RECV state")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/tcp_ipv6.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 06beed4e23bf0cf6269ac03e60cfa4849c45ec76..a8adda623da15f9d396257c53d267c935e995be0 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1001,6 +1001,7 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 	__be32 label = 0;
 	u32 priority = 0;
 	struct net *net;
+	u32 txhash = 0;
 	int oif = 0;
 
 	if (th->rst)
@@ -1073,10 +1074,12 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 			if (np->repflow)
 				label = ip6_flowlabel(ipv6h);
 			priority = sk->sk_priority;
+			txhash = sk->sk_hash;
 		}
 		if (sk->sk_state == TCP_TIME_WAIT) {
 			label = cpu_to_be32(inet_twsk(sk)->tw_flowlabel);
 			priority = inet_twsk(sk)->tw_priority;
+			txhash = inet_twsk(sk)->tw_txhash;
 		}
 	} else {
 		if (net->ipv6.sysctl.flowlabel_reflect & FLOWLABEL_REFLECT_TCP_RESET)
@@ -1084,7 +1087,7 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 	}
 
 	tcp_v6_send_response(sk, skb, seq, ack_seq, 0, 0, 0, oif, key, 1,
-			     ipv6_get_dsfield(ipv6h), label, priority, 0);
+			     ipv6_get_dsfield(ipv6h), label, priority, txhash);
 
 #ifdef CONFIG_TCP_MD5SIG
 out:
-- 
2.37.3.998.g577e59143f-goog

