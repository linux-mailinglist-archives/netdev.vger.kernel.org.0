Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D37D4BEFCD
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 04:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239326AbiBVDLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 22:11:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiBVDLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 22:11:44 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A145B852
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 19:11:20 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 27so10649943pgk.10
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 19:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cyP8rcfFp7Y/J1fM9NYVfdlkJMqmwPGOjZHEAPm7QeM=;
        b=lc/7cRMcNgN9QpC+YQPUehfSDcBXh7t4NSzBjQdPwn7SyYTNqNmb+4OCOavX9Yfoza
         W2tyFZb4fwrHHV5p4607Ch/SSFRZ0YcBk0wOfjDWOeGFfSAflysJGIgvP2+w9gcOv5Ui
         FYuTtx9vkBFMKXACleDayV/MyjH69YffKxaSINxfUvWkFBMpn30Wv2cAU1N45/1MLDRW
         4si38xmEM357WtqaqGhL2ZxK5tYVBA5niaLJiH5UDjXYDvKNEdKY3LCaIZ/eYlKfXpJ8
         wy9Zpp5jqSfv+/lUfmdIOv3C+lxzikrHDFA2tXnex7zxAVYjZG2FqSa4j7pcp739Gszg
         bWJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cyP8rcfFp7Y/J1fM9NYVfdlkJMqmwPGOjZHEAPm7QeM=;
        b=zGZsVTUT35Dx9qXXxHMMkj4rSWJ/0OXY5rdCjbogG1aE6cDtLdHxmixe91kTObxAvg
         wMdTJ+r3vb1gfZQWBc85wAbx6BpSuGGtYRDXelwDpNtR2uWbM1y/0oandpGiWArDQkAE
         WY4F2ExpdKqpMFv4cvms3sKHV/WhKAYVTaSCi/oL9BsAzg+5w1nYMwRnOuXLC3sQNY3a
         J0+1e4RxTBAbtCBq/JQt/OOJU1Of55s7DRPf1X8FP6n3xT5BspETfFh4iID9J8dMA6ly
         qxs7iM7IdrO+b1lfNfkutbBdBUtAKWb/R+V0JBpQ2uHzhg3eMmMdkufw5GIVsSIjvp0v
         9AvQ==
X-Gm-Message-State: AOAM533O7pU+7HkFLDAjoYk5eI96oIKiBH96wtAEMsI0FCPRFP8oCCfN
        y1oAdBotr7jiSfyjCM3TwLzQ5zEI2mQ=
X-Google-Smtp-Source: ABdhPJzVt0OwzQXTeaPiZTBAT8jIkBcywrHv8a4BhqAFAfJ5+5RBIkhuJ7lK7S4oMHLVIBAr/HQthQ==
X-Received: by 2002:a63:5110:0:b0:374:2312:1860 with SMTP id f16-20020a635110000000b0037423121860mr8668930pgb.146.1645499479701;
        Mon, 21 Feb 2022 19:11:19 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f99a:9263:216c:fd72])
        by smtp.gmail.com with ESMTPSA id n34sm11462524pfv.24.2022.02.21.19.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 19:11:19 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] ipv6: tcp: consistently use MAX_TCP_HEADER
Date:   Mon, 21 Feb 2022 19:11:15 -0800
Message-Id: <20220222031115.4005060-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
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

From: Eric Dumazet <edumazet@google.com>

All other skbs allocated for TCP tx are using MAX_TCP_HEADER already.

MAX_HEADER can be too small for some cases (like eBPF based encapsulation),
so this can avoid extra pskb_expand_head() in lower stacks.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/tcp_ipv6.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 0c648bf07f395d5e1ec0917d32fe55a46e853912..309a8a583bcac089ff93daef6da2eadebd018092 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -921,12 +921,11 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 	}
 #endif
 
-	buff = alloc_skb(MAX_HEADER + sizeof(struct ipv6hdr) + tot_len,
-			 GFP_ATOMIC);
+	buff = alloc_skb(MAX_TCP_HEADER, GFP_ATOMIC);
 	if (!buff)
 		return;
 
-	skb_reserve(buff, MAX_HEADER + sizeof(struct ipv6hdr) + tot_len);
+	skb_reserve(buff, MAX_TCP_HEADER);
 
 	t1 = skb_push(buff, tot_len);
 	skb_reset_transport_header(buff);
-- 
2.35.1.473.g83b2b277ed-goog

