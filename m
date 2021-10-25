Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F11439C08
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 18:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234098AbhJYQu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 12:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234101AbhJYQu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 12:50:57 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60429C061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:48:35 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id m21so11500060pgu.13
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6T/8l40zJhUEXxcfn1C0FlUH4x2qZwvVYGnNQT7HqYY=;
        b=DW0FyiITdO/z4ikE1P9inF9yhPlyvQFle/i8HAN8i3ZKzEicEoupuhV15hGKiir/G2
         BL9l+lxOFK47Kmna2uEIzbhSilcPU7iFsifvsNgtHUSOJqcs8geXPIapcj9ISUbV9l4U
         ZWoziDYMFNQr4nov3GweuClqgr2Jsqq3vAg8fO7vvDm3L+gz9AOpB/87YRNxkfbhkdXY
         SBSqM8MDhuHBlGt1ABjCaWQVDicHdVUfSg5wlhZCIt1sMgtj87UdfUi6N6ymOy93NZh2
         Qxi0pvb79l8y6COMHRir3zJUA9Nt0M0Lmq8Pr9SiNXzFjoS7btkZUQNNjqmjqVKYnneA
         LxfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6T/8l40zJhUEXxcfn1C0FlUH4x2qZwvVYGnNQT7HqYY=;
        b=xGQMKCgn8ijnZ7KW5yhvIZ0xZwYyDqwANRi/GeWce/1Mix0moCttP735kA4IDh/TjP
         le4v9V2oMmJdSp/fAw15WC8Y1BkYzJlnyVrKJ0qhOlJuttPBEYhhGs0YgqvUMEC1NSgW
         b0fIAJH/Jy4RYOLWaSOSNtEOy9oiOehv1O6xvxQbz9qwn0shmem58ONffL3XxhPIsv+5
         b3BxfR9qikG+oWW0Vk9lpi4eX7JEiSP6W+JuKDojuIL4bA4ZSGgtmovSiQ0WxYTlejF8
         IqB2OuxUTQjkZmuhKQbxRmlmCeBNhdzLD2B2vzh1I1veGHJepK50khAK3+JDa/ijFYVP
         JGJg==
X-Gm-Message-State: AOAM533OlOgpNcwDHY8HwJNNzKmZQzDylQATVL80cFeqoH9pYeSPL7I4
        ervgOTkhMI9QJCSRoIqTjWE=
X-Google-Smtp-Source: ABdhPJy82QGWtJzWNQ6A0sqCRR/WswVCp5se6wHcgiamgBewpeD1cKTMN6OLQ4o6lz4E3iwHYqwVrw==
X-Received: by 2002:a05:6a00:1352:b0:44d:4573:3ac2 with SMTP id k18-20020a056a00135200b0044d45733ac2mr20306869pfu.12.1635180514903;
        Mon, 25 Oct 2021 09:48:34 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b7cd:daa3:a144:1652])
        by smtp.gmail.com with ESMTPSA id b3sm17052582pfm.54.2021.10.25.09.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 09:48:34 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH v2 net-next 05/10] net: annotate accesses to sk->sk_rx_queue_mapping
Date:   Mon, 25 Oct 2021 09:48:20 -0700
Message-Id: <20211025164825.259415-6-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211025164825.259415-1-eric.dumazet@gmail.com>
References: <20211025164825.259415-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

sk->sk_rx_queue_mapping can be modified locklessly,
add a couple of READ_ONCE()/WRITE_ONCE() to document this fact.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index b4d3744b188ad869b4ec55f78e04236b710898de..b76be30674efc88434ed45d46b9c4600261b6271 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1925,15 +1925,19 @@ static inline void sk_rx_queue_set(struct sock *sk, const struct sk_buff *skb)
 static inline void sk_rx_queue_clear(struct sock *sk)
 {
 #ifdef CONFIG_SOCK_RX_QUEUE_MAPPING
-	sk->sk_rx_queue_mapping = NO_QUEUE_MAPPING;
+	WRITE_ONCE(sk->sk_rx_queue_mapping, NO_QUEUE_MAPPING);
 #endif
 }
 
 static inline int sk_rx_queue_get(const struct sock *sk)
 {
 #ifdef CONFIG_SOCK_RX_QUEUE_MAPPING
-	if (sk && sk->sk_rx_queue_mapping != NO_QUEUE_MAPPING)
-		return sk->sk_rx_queue_mapping;
+	if (sk) {
+		int res = READ_ONCE(sk->sk_rx_queue_mapping);
+
+		if (res != NO_QUEUE_MAPPING)
+			return res;
+	}
 #endif
 
 	return -1;
-- 
2.33.0.1079.g6e70778dc9-goog

