Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1E94F09A5
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 15:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358718AbiDCNLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 09:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358533AbiDCNKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 09:10:32 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01361158
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 06:08:37 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id m30so10675822wrb.1
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 06:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KwpUHaq2Ufbfs+a40mjnOExLVtmmwM2j4c3BJ8ZmRlg=;
        b=kTS5cZCq7+GiSsDmzKbxRyntTfa7midbA4Lua4Ie444m5qSsrCEAY0yV0cG6Fv7NMQ
         /ys79InODOShzlWuue63nHwy+BFUt9lHemO2ybStKRRMqs4zqomFzu31WHEiAfRUfaOb
         jxPF7RqN+ZOZIRCJW4aaJ2E793tWvyjhc8BCD1DobIdf7ETKaoIENtUPf77NvGhZKxFh
         PEIjPtipEm438OG7C2IpHr/SKqu6ZJdSL971uEvijRjVR+RGbCfx6bvoyQCNX0790Ub4
         oB1H0dzUQkZz4X5/nGdVoJKt//1prd9Ay51WZbDGYjdxcGb8/WGWtb+gCkxN0RVtm2h1
         VenA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KwpUHaq2Ufbfs+a40mjnOExLVtmmwM2j4c3BJ8ZmRlg=;
        b=M49nhys9uzGpM7U6bXk/mNDR5zrCVysKNvuI42gWdoKXEO1FMlSiXFDSzB/9llLsoP
         iETwAIBDprdV9cjUOl8W/RqUS2PfPUgTt4h/RK8QEKGVVSaCa0y9nlXn+vgvA0dMc2nL
         i91G7BVK71HAFKcT9MB0B58eCE/TDSWRftCoS5o3TCTCJoDhEKireUo4+yR2DwP3lPdN
         6w+AR+hBIeq4jmRSgoi44yk78+XINwu3agP1Y/E5fhMghC5wn90R1JJhKn0IR/VHCpVF
         AhHEL5g2s2fBavMaAqiBeJ9Fa6LuI33s5O+0ir7blRVkrs4dR2O+hpf66sep+5YnpqRR
         QZXg==
X-Gm-Message-State: AOAM533IXiMcagWuLzNH0GmYzz2RGpr9sRtfqcoIAYkWkpf+bSatScV7
        xwY8X7Vy4NAzj44KX6UX2dSglxe7Yeo=
X-Google-Smtp-Source: ABdhPJz98a7Y0UztvBcKPWvaz7l+1ihpEC7/rXRRTWdIRxYPHg0E8N8VrfCeEBemmAnImzb1huwa4A==
X-Received: by 2002:a5d:6945:0:b0:206:bd5:bf90 with SMTP id r5-20020a5d6945000000b002060bd5bf90mr3092868wrw.252.1648991316324;
        Sun, 03 Apr 2022 06:08:36 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-233-133.dab.02.net. [82.132.233.133])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b00381141f4967sm7866995wmq.35.2022.04.03.06.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 06:08:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 22/27] udp/ipv6: optimise udpv6_sendmsg() daddr checks
Date:   Sun,  3 Apr 2022 14:06:34 +0100
Message-Id: <0af7aa19e575c9bd9d8be3bc3e7814af4b3a09b7.1648981571.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1648981570.git.asml.silence@gmail.com>
References: <cover.1648981570.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All paths taking udpv6_sendmsg() to the ipv6_addr_v4mapped() check set a
non zero daddr, we can safely kill the NULL check just before it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/udp.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 707e26ed45a4..cbb11316a526 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1383,19 +1383,18 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		daddr = &sk->sk_v6_daddr;
 	}
 
-	if (daddr) {
-		if (ipv6_addr_v4mapped(daddr)) {
-			struct sockaddr_in sin;
-			sin.sin_family = AF_INET;
-			sin.sin_port = sin6 ? sin6->sin6_port : inet->inet_dport;
-			sin.sin_addr.s_addr = daddr->s6_addr32[3];
-			msg->msg_name = &sin;
-			msg->msg_namelen = sizeof(sin);
+	if (ipv6_addr_v4mapped(daddr)) {
+		struct sockaddr_in sin;
+
+		sin.sin_family = AF_INET;
+		sin.sin_port = sin6 ? sin6->sin6_port : inet->inet_dport;
+		sin.sin_addr.s_addr = daddr->s6_addr32[3];
+		msg->msg_name = &sin;
+		msg->msg_namelen = sizeof(sin);
 do_udp_sendmsg:
-			if (__ipv6_only_sock(sk))
-				return -ENETUNREACH;
-			return udp_sendmsg(sk, msg, len);
-		}
+		if (__ipv6_only_sock(sk))
+			return -ENETUNREACH;
+		return udp_sendmsg(sk, msg, len);
 	}
 
 	ulen += sizeof(struct udphdr);
-- 
2.35.1

