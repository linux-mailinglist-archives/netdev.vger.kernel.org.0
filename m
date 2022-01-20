Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6251494E21
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 13:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242956AbiATMpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 07:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242806AbiATMpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 07:45:36 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF15DC061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 04:45:35 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id h23so5264216pgk.11
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 04:45:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YeFcL9tLlqmrw76U1McQ+9mTOu7/vyu2aqwGsyzCSMc=;
        b=UA3DebP7SaGEooSc5dcPRzkA5+Uvq5HccMQrhHmsx8jyk+dM1TGBXPAsjDjb1Ry94T
         h4oMevaqdjyt7OczAQcb1YjemMxe+bwvVQ2UI2EnFLxHBNzthIRg04aJIc2H7Ym+bBWE
         sjwHRpZBPojYk2DbWehtn4f8D28wbJcFkDmW++MO1QtEsTWrRtaIfUWjcSv+doEiKyCO
         7iACOGULwCT+2xEfeVGzTGES2KDpkDcOUE6w5Zh/c8II+FzUsFfTurfCzqTjocMt0IlP
         4W1eh+/XNZEmrTdUdrTWog7pV/OgTYrao7KLJS/onuqRv+aDN1zcHQfHF6d/Iv3lf1pT
         iDJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YeFcL9tLlqmrw76U1McQ+9mTOu7/vyu2aqwGsyzCSMc=;
        b=uCON+pwjbtz0VpctBp56nlKcGQNFRXOZgBap/oRMAFyis9yszqdNw3L4aLB/TWK0+t
         Rj49YatSQ8QgERxwu66UtjR1MXIxGPgfwvCkxxlMEmn0UBQpF7Zxh+uB0zH3aM2USvLj
         4fk6WoCiSrwtgAbJUn3pZjuyc792nH64EbXzYcJfaObIpSPQuZW0oRJBncx3BOFq59Z9
         PU4NxxlcBSc83iBVLatBuDXLM9sQEIH630mnF34ShCgqNs+zs2580XlwRF6saxdWdrhZ
         jDPrKVLKSzzhgA83vwJr69OWh2Uj+0+UzmOQl24/4plqvLE+cyHAQVVMHWlEGiZQbh9k
         /6RQ==
X-Gm-Message-State: AOAM530mXt6lVbFkEDeG82yUpxxlPJSbthIJPaGvDtU62SKYolAReo/w
        ZTkbRmRhOPN0dhXJdq0t5/U=
X-Google-Smtp-Source: ABdhPJwIrDx2QF9orUms6NRcp/9Ch3/oDNXmk4b/MZQhm4Js2jLKofyizWjrvlxiCwlyMl8chB1gWA==
X-Received: by 2002:a63:ef18:: with SMTP id u24mr30127115pgh.362.1642682734668;
        Thu, 20 Jan 2022 04:45:34 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e06d:351f:4073:b0eb])
        by smtp.gmail.com with ESMTPSA id f7sm3710095pfv.30.2022.01.20.04.45.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 04:45:34 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Gal Pressman <gal@nvidia.com>
Subject: [PATCH net] tcp: add a missing sk_defer_free_flush() in tcp_splice_read()
Date:   Thu, 20 Jan 2022 04:45:30 -0800
Message-Id: <20220120124530.925607-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Without it, splice users can hit the warning
added in commit 79074a72d335 ("net: Flush deferred skb free on socket destroy")

Fixes: f35f821935d8 ("tcp: defer skb freeing after socket lock is released")
Fixes: 79074a72d335 ("net: Flush deferred skb free on socket destroy")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Gal Pressman <gal@nvidia.com>
---
 net/ipv4/tcp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 3b75836db19b07b0f178ef4457bda0ec641fd40d..78e81465f5f3632f54093495d2f2a064e60c7237 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -842,6 +842,7 @@ ssize_t tcp_splice_read(struct socket *sock, loff_t *ppos,
 	}
 
 	release_sock(sk);
+	sk_defer_free_flush(sk);
 
 	if (spliced)
 		return spliced;
-- 
2.34.1.703.g22d0c6ccf7-goog

