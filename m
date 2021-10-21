Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5E9436794
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 18:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbhJUQZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 12:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbhJUQZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 12:25:24 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CCBC061243
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 09:23:08 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id e10so768473plh.8
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 09:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s1stloSYxu083kFvymqt3Z08n7JsHCUpgo2FwN9CJVs=;
        b=OlPisfMM1WO8LmPnZHh/PQoIk78PqQB8XPNaY3NlL1X3fQLGvPFGpQfhpDqsoVKoa5
         pP433iEpby3ku93PY4E6x3IucrnjQ1o4DVeOQQjSklBVZ0Cgo77xr4QDm2bzE2c3TlJx
         aMuQcvWIlyc08McpxKAmoCRMzxQ+KsDsXH6T8o0+Gl/r/l5QPwd+agwmjIendRNy9EY9
         T1/tSFUGnKGoTzsJDL0BLuu5vcgENU8uIswhKqAezwGdK4XsNRuH6N/rt/fnI5Y1Piij
         NCT76+tXYFr8/yY0HzTT6weA6cQPf539LC4gPf90c1ITQAKgoL8QrYuxIO6jWZNv2mgH
         xUKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s1stloSYxu083kFvymqt3Z08n7JsHCUpgo2FwN9CJVs=;
        b=WhLlV5z+80wemmYifc9iMSdpzKX2GEmsRU0Z/myrmHrpeWthuoxuhGKtCSIu9MznJT
         dOG54L/LFjuYNdvtRRxd+OUZOYAKrtzRYiviC+AJMzVLoh+2sjaB3bVtY2bixc372fvL
         /NcPODPq2u8WW/btkLI/MfBC4NIHsUntrmZywXeHMd8PGzmlng+K+vPoH359N0sME8Zc
         URCa4a+zhbJyTJqizD6bDNl4eQ1f0XLjIS28/9Yj+s6meX+G9kO5GXLukJWAUNu0dAT7
         XVIN0oJ7xaqOUOTTNjxoZnu5BC56T7fdnkzdVuwSUaIQOvp0Gi3+ggYBdHCCzDq0hklf
         ge3w==
X-Gm-Message-State: AOAM533Azj8G09iHYxJ1wfGC4pfSAHWfM92a57Yk+noPUSmYnLl9J8QQ
        qoa2bOEO8Gwv6TM2iaRlodM=
X-Google-Smtp-Source: ABdhPJysMv6tvNfbF66GEXRftHJ3MIcoAWDYQkD10uhcyKuE024B/jHzcnNNtl1rRGwcByQ/yrHX7A==
X-Received: by 2002:a17:90a:b391:: with SMTP id e17mr7891813pjr.137.1634833387901;
        Thu, 21 Oct 2021 09:23:07 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c17a:20ce:f4d9:d04c])
        by smtp.gmail.com with ESMTPSA id n22sm6719291pfo.15.2021.10.21.09.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 09:23:07 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH net-next 4/9] net: avoid dirtying sk->sk_rx_queue_mapping
Date:   Thu, 21 Oct 2021 09:22:48 -0700
Message-Id: <20211021162253.333616-7-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211021162253.333616-1-eric.dumazet@gmail.com>
References: <20211021162253.333616-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

sk_rx_queue_mapping is located in a cache line that should be kept read mostly.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 99c4194cb61add848e3a35db0f952c4193f5ea1f..b4d3744b188ad869b4ec55f78e04236b710898de 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1916,10 +1916,8 @@ static inline void sk_rx_queue_set(struct sock *sk, const struct sk_buff *skb)
 	if (skb_rx_queue_recorded(skb)) {
 		u16 rx_queue = skb_get_rx_queue(skb);
 
-		if (WARN_ON_ONCE(rx_queue == NO_QUEUE_MAPPING))
-			return;
-
-		sk->sk_rx_queue_mapping = rx_queue;
+		if (unlikely(READ_ONCE(sk->sk_rx_queue_mapping) != rx_queue))
+			WRITE_ONCE(sk->sk_rx_queue_mapping, rx_queue);
 	}
 #endif
 }
-- 
2.33.0.1079.g6e70778dc9-goog

