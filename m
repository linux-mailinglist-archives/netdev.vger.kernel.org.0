Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0CFE30C429
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 16:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235713AbhBBPnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 10:43:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233306AbhBBPma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 10:42:30 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D204C061573
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 07:41:50 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id e12so3483143pls.4
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 07:41:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2O6kF5iiw0UfOuyh1anKkeNVJ9BrmHgvUSBLx0dgbao=;
        b=NehVQB1EpbqvPonREgLUw2J1paC3wejVoaFez6ovLp1ZfnFvwHPa1tsk6hXTQJrVOp
         M56AZf4i38DpaiYyFKmy5XEVkkFTkmOYVbCXZEh/MTq0fxMEwtS07Q5I7tAYUELgYHgE
         ASsX0CqvCGOMp2bSL4uizhXKwxpZxEXnOzzclayRktgvVIETdXBtF7zowwOJZubFk03q
         ZvaX9cYq+qGJSP6S0lfhAdSMFdVUi9Nf5lW0phQx+xnutnED4xfzCY/Ehi7oKUcs8n0V
         zJnzNLTPgP6cpE8iJhbO+f9ffaCv1xDas8l5O9ipvgOkLGKB+G5RJIf8nVIlhX/oJVUe
         CYBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2O6kF5iiw0UfOuyh1anKkeNVJ9BrmHgvUSBLx0dgbao=;
        b=f9yFzw7oz5Bc/zlc0UC1e/S9xAy/NMKNu04kbmBubGaUbs7VeHA3lSm+wLTCSMnaJA
         7tP9Db7s3QKZm02cSneAzeNICAQxtbAQzCtDFpHshPr8nrpMuSq7mKNItQmqgk/Yrr2a
         mT7AtJ+xFF8K6PuaZXjWxvn3JdBP7tvSdVgLQwAVDjv07X6UPRuoMDoQ1ZO9WsWFtSpV
         pQ35vr2ZWKrgztB7IarkjIKw+VbtYOB39q2L14JjmDEdaUzxOdDukg7p0j/EY2onlhCK
         HyAvKFe2S1MkGvY2vWTAouDXgSPXKRyXqi/FVyi21QbQRSVkGGaUxyfmM0UWQEVEDf+A
         DiWw==
X-Gm-Message-State: AOAM533P8To21S1aQ2Nh/GR0PN9JgaMEMSnaIDCMQAowJuok4zYjxotW
        /ZypDkDPtXpYiWdcFPPPI7c=
X-Google-Smtp-Source: ABdhPJxGzVcthPyccJ1JVjEhxZdT44yeQ4+XL1xq0/+LUOI3VtuDiMuBZN7Jmc+Vg0g4n4ZB+MQNmQ==
X-Received: by 2002:a17:90a:67ca:: with SMTP id g10mr5080904pjm.28.1612280509693;
        Tue, 02 Feb 2021 07:41:49 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4dda:fb1a:cb1f:eea5])
        by smtp.gmail.com with ESMTPSA id v1sm22991175pga.63.2021.02.02.07.41.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 07:41:48 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH net-next] inet: do not export inet_gro_{receive|complete}
Date:   Tue,  2 Feb 2021 07:41:45 -0800
Message-Id: <20210202154145.1568451-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

inet_gro_receive() and inet_gro_complete() are part
of GRO engine which can not be modular.

Similarly, inet_gso_segment() does not need to be exported,
being part of GSO stack.

In other words, net/ipv6/ip6_offload.o is part of vmlinux,
regardless of CONFIG_IPV6.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
---
 net/ipv4/af_inet.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index b94fa8eb831bf3b18917529ef6a9263edb968592..be43c8d95af56624c4deee30e5f737eacdb884c1 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1419,7 +1419,6 @@ struct sk_buff *inet_gso_segment(struct sk_buff *skb,
 out:
 	return segs;
 }
-EXPORT_SYMBOL(inet_gso_segment);
 
 static struct sk_buff *ipip_gso_segment(struct sk_buff *skb,
 					netdev_features_t features)
@@ -1550,7 +1549,6 @@ struct sk_buff *inet_gro_receive(struct list_head *head, struct sk_buff *skb)
 
 	return pp;
 }
-EXPORT_SYMBOL(inet_gro_receive);
 
 static struct sk_buff *ipip_gro_receive(struct list_head *head,
 					struct sk_buff *skb)
@@ -1636,7 +1634,6 @@ int inet_gro_complete(struct sk_buff *skb, int nhoff)
 
 	return err;
 }
-EXPORT_SYMBOL(inet_gro_complete);
 
 static int ipip_gro_complete(struct sk_buff *skb, int nhoff)
 {
-- 
2.30.0.365.g02bc693789-goog

