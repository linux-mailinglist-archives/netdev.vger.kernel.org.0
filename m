Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D28F4E89B
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 15:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfFUNKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 09:10:00 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:55594 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbfFUNKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 09:10:00 -0400
Received: by mail-qk1-f201.google.com with SMTP id p206so7417547qke.22
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 06:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=l+B6a9nBzRCfLuir3Z6pi3stYHyjDaAL9NKv8M9pOhQ=;
        b=cwUC/BgClX46gMepC8mcQNZuDwHEth/A9TkLba8xOn5rTtDSi71ILI9TEibLGmBVJi
         LtDMoATUpcymBI3iU875rYUhT9V2FrHw0UTJUaW9NILXMLrta1vtq6nPkqxWQ/lSMuvY
         bJEWcEyRWcpbBPM3UPKvAHfNOFPEBsaSMmNHj0VOAOyzq9+N7iVrLqbKLSjUaiFt1wsB
         lEoVl+3WH+GR7KA3+IFb/Mm21z00eXib4a5d+Q8ClkFVG8m64FBxbj4/F/XDPX0JEFc2
         StNqKxtcW96V6dizyKoBiYyFZ2RQT3vOjrEN2Bs/c+wqz/ZodCPBLm1TqdJ3SbQuvtc0
         tu/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=l+B6a9nBzRCfLuir3Z6pi3stYHyjDaAL9NKv8M9pOhQ=;
        b=P27helbCsrZvT55gexFM6RdG73wXPIK6x7Ubuy4dWNliE3xG/jy51+Tdc2a2Z1Duwr
         DO7k0S5+Ojrek4sWT+eVs3IwyBXBOlC3WCsZPIzndxnAj+0DR3V7/O45XA3IdR6DmK3u
         gU8Rf1EJ942zNC1UiaXEwArmv1HmSxhvguaGyv/7h89cTAMYxf5E85m8wwKiVRswEBLS
         XeBjD7lFoON1JE3t7kpQlS42sx3wbDFhkZzezCfZ9BjwFet/drBa5AG2gm4/sgthT9+g
         y3HBN9ZebCKtPi65bZztBWueIw+1kwTVeprSFdqjiNS91aXoYg/S7IARnL2WPvpbGvuZ
         fmdA==
X-Gm-Message-State: APjAAAVdhEIzo7wqf9Lzm1rFsRUD2uLDPYFiEGRhs2IgadLs2kBzCg9L
        Jda4Ih9Yf+kvZmoJIo3hfXF2Mjywu6aG9Q==
X-Google-Smtp-Source: APXvYqxTuByYPwtrE0Qmep6wftktnh3vfQqzeqQorc3Sx+GxWKcHyrsrL22gdHU+4kaxgpxNU6bDsckFwpaThg==
X-Received: by 2002:aed:3f10:: with SMTP id p16mr52527157qtf.110.1561122599139;
 Fri, 21 Jun 2019 06:09:59 -0700 (PDT)
Date:   Fri, 21 Jun 2019 06:09:55 -0700
Message-Id: <20190621130955.147974-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH net] tcp: refine memory limit test in tcp_fragment()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Paasch <cpaasch@apple.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcp_fragment() might be called for skbs in the write queue.

Memory limits might have been exceeded because tcp_sendmsg() only
checks limits at full skb (64KB) boundaries.

Therefore, we need to make sure tcp_fragment() wont punish applications
that might have setup very low SO_SNDBUF values.

Fixes: f070ef2ac667 ("tcp: tcp_fragment() should apply sane memory limits")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Christoph Paasch <cpaasch@apple.com>
---
 net/ipv4/tcp_output.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 00c01a01b547ec67c971dc25a74c9258563cf871..0ebc33d1c9e5099d163a234930e213ee35e9fbd1 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1296,7 +1296,8 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
 	if (nsize < 0)
 		nsize = 0;
 
-	if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf)) {
+	if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf &&
+		     tcp_queue != TCP_FRAG_IN_WRITE_QUEUE)) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPWQUEUETOOBIG);
 		return -ENOMEM;
 	}
-- 
2.22.0.410.gd8fdbe21b5-goog

