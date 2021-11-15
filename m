Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18150451D8F
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345797AbhKPAbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:31:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345779AbhKOT3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 14:29:21 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1B6C0BC9A0
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:03 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id p18so15197508plf.13
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HUrBJZSDcvJUwz5P7+s6J9RNx1WuMqW7KYHmoyPKCEA=;
        b=Jj731c456blPGTO2Gph0c8OiZjCR4I65YJ3hJcNMbQOhGC0OjppnNirFFpH72+2m8t
         FzMLderViepUfYpWqWgT9M/eEFnXmNSObeR63rAd8qrWFGqBhRrqKM4ygRbhcPIgdZCK
         NpnxavLoXErQMJMeVIWfbBUBJCq7CS4U9cUTrlWPAPLEfxg9yaTIzUjcFra2Zg9H+spO
         eR5IgvXhl14E97Uy45kPR9hIj7lTHlnFGU3+leoIJMe1VI/9qrOSET4aEsbKNhZwdS4P
         +bOH/7lof95T1N73uq2zIcqn7ThC0/mkc2VLb3ybbK6WsCsSgip8VKUFulYBqP5LGOzB
         KeVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HUrBJZSDcvJUwz5P7+s6J9RNx1WuMqW7KYHmoyPKCEA=;
        b=SjfRQSJ1iidec7Lfd2x8FUIh+5DpuIWKLtoCjehV64vAHONiMP6vlmc0WXLK2Ay7Np
         z3JCOSpSQlXh7GNGkg3P7LnpOxO9s34vzx1ieMEXBTiP18S+xv1AFeJuyw9Kkfh9AWSZ
         Sc7krB1tR437lt3SlTxO2xTQOb5zQTkdERtg098RX1Z9KfGpjPlWZ9j9ENR6+xARZiRQ
         5QTTHNDU3+A0YP9ob69U8FJdCYz+Ar8vbMzHMGh6HG3emCpqg3/nN0P/1xKZvBZ0WCUH
         /LrY9j203DY9rA7X9ANN7QX3nNelPdJJ47LHG5/gVs9Ukn+qoDzr8IM8gtLIs3uDpWq5
         cF2A==
X-Gm-Message-State: AOAM533WCoreL68POMxvaAA88AEaOsaMtNIwTAmRPamNGpf3y4SC+qQw
        5mlg97jjcQ1cd+e0az5tUJGVeeXv02w=
X-Google-Smtp-Source: ABdhPJyn8FqanG9/bcEtTtt8qvHpTjgo94s9cYqY01FhfT+Q1gNEhl0k85I6hsKKEjrBJ9GU50Dm2g==
X-Received: by 2002:a17:902:da8e:b0:142:1142:b794 with SMTP id j14-20020a170902da8e00b001421142b794mr38249013plx.82.1637002982777;
        Mon, 15 Nov 2021 11:03:02 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id f21sm11850834pfe.69.2021.11.15.11.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 11:03:01 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Subject: [PATCH net-next 02/20] tcp: remove dead code in __tcp_v6_send_check()
Date:   Mon, 15 Nov 2021 11:02:31 -0800
Message-Id: <20211115190249.3936899-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211115190249.3936899-1-eric.dumazet@gmail.com>
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

For some reason, I forgot to change __tcp_v6_send_check() at
the same time I removed (ip_summed == CHECKSUM_PARTIAL) check
in __tcp_v4_send_check()

Fixes: 98be9b12096f ("tcp: remove dead code after CHECKSUM_PARTIAL adoption")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/ip6_checksum.h | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/include/net/ip6_checksum.h b/include/net/ip6_checksum.h
index b3f4eaa88672a2e64ec3fbb3e77a60fe383e59d9..ea681910b7a3af3624b7248651ba8fdc587bafba 100644
--- a/include/net/ip6_checksum.h
+++ b/include/net/ip6_checksum.h
@@ -65,15 +65,9 @@ static inline void __tcp_v6_send_check(struct sk_buff *skb,
 {
 	struct tcphdr *th = tcp_hdr(skb);
 
-	if (skb->ip_summed == CHECKSUM_PARTIAL) {
-		th->check = ~tcp_v6_check(skb->len, saddr, daddr, 0);
-		skb->csum_start = skb_transport_header(skb) - skb->head;
-		skb->csum_offset = offsetof(struct tcphdr, check);
-	} else {
-		th->check = tcp_v6_check(skb->len, saddr, daddr,
-					 csum_partial(th, th->doff << 2,
-						      skb->csum));
-	}
+	th->check = ~tcp_v6_check(skb->len, saddr, daddr, 0);
+	skb->csum_start = skb_transport_header(skb) - skb->head;
+	skb->csum_offset = offsetof(struct tcphdr, check);
 }
 
 static inline void tcp_v6_gso_csum_prep(struct sk_buff *skb)
-- 
2.34.0.rc1.387.gb447b232ab-goog

