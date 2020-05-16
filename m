Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF2B1D5DDE
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 04:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgEPCRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 22:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726946AbgEPCRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 22:17:52 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214DFC05BD09
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 19:17:49 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id p24so5517235pju.1
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 19:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=0f4+wbqmNuQybJXObVLjzOmL1/TFimYYqW2mJ7P8jvA=;
        b=WYdOsqAqb2S/WxL0Yxbmz9UNEVydVDAHmD4XEuZ1pysS2DBdZrwHJnz2+xLeW48swd
         pQc4iantDggMHqehg4/x9XMeiFUDD4NRgOxSg2U74WgfQ5hQxzKcgD/c2VRMWbPvt0AG
         xs43CAH7WhqMqyA/Wbsy94stDGe9QAtHBilLRpeHW8smkkNkB1dc4LKDaVjtM07PrVru
         R5B5w9oJH4O76H8G/G2ttcQX0+c76Pg384+18VL41QtnQqGmGGEQ0H8GBucyMetTS456
         8ePee1/fW1YpJlRpdi82RQaFRjV73Xij2ldILpKzLPNuu+2tO79wB83pCoZEVdbQuI9d
         AKtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=0f4+wbqmNuQybJXObVLjzOmL1/TFimYYqW2mJ7P8jvA=;
        b=im7d7PYu/34/nxU1i3tlqmWIykjhozYtHmdL4N/1tBLWWLmXSW8OYkZy2O/93Wj8oq
         U1FAXmPOfoMQnDjN0lveU2V9owZVQiBDZGWT6tH87WqopwSPheyA5PcdqlxGWTV5QdFW
         3flnbwHH5fkc/u8ca1NmXilwgxnUlgrTSiFLCBPRXC0ARzpzqsnMJPdleNUhIaTN9pqT
         ZrXtrpflC3N5/vWTdtOT8IUoGQyN6t479sjVv6qY0mc/PzAJLQiSwu68lBG3/rGtRlp4
         FPJRRpAsIRvAQwB9bri7e+4M7HKxfLpmFqAJlVPtJS4pPKmrwpT2oSrPO3lPAgBL5YCb
         8Khg==
X-Gm-Message-State: AOAM533YYs9yVfWDJORLRS/hBwNjjxomz7D8+hGfqV1Na7J8Mp1pqzMX
        9GihbOmac/b+HX3VBg2uYnUGB47CW2o8mQ==
X-Google-Smtp-Source: ABdhPJyeepV8Yb/Dvt4uWdALUG5pDYOCm1g70MhDrwbuzZwPAforTnJkYuyITdPQYy8OArKILB78NelHkeBolA==
X-Received: by 2002:a17:90a:8c98:: with SMTP id b24mr6832646pjo.226.1589595467480;
 Fri, 15 May 2020 19:17:47 -0700 (PDT)
Date:   Fri, 15 May 2020 19:17:36 -0700
Message-Id: <20200516021736.226222-1-shakeelb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH] net/packet: simply allocations in alloc_one_pg_vec_page
From:   Shakeel Butt <shakeelb@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shakeel Butt <shakeelb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the initial allocation for pg_vec buffers are done through
page allocator with __GFP_NORETRY, the first fallbacks is vzalloc and
the second fallback is page allocator without __GFP_NORETRY.

First, there is no need to do vzalloc if the order is 0 and second the
vzalloc internally use GFP_KERNEL for each individual page allocation
and thus there is no need to have any fallback after vzalloc.

Signed-off-by: Shakeel Butt <shakeelb@google.com>
---
 net/packet/af_packet.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 29bd405adbbd..d6f96b9f5b01 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4243,19 +4243,12 @@ static char *alloc_one_pg_vec_page(unsigned long order)
 	if (buffer)
 		return buffer;
 
-	/* __get_free_pages failed, fall back to vmalloc */
-	buffer = vzalloc(array_size((1 << order), PAGE_SIZE));
-	if (buffer)
-		return buffer;
+	/* __get_free_pages failed, fall back to vmalloc for high order. */
+	if (order)
+		return vzalloc(array_size((1 << order), PAGE_SIZE));
 
-	/* vmalloc failed, lets dig into swap here */
 	gfp_flags &= ~__GFP_NORETRY;
-	buffer = (char *) __get_free_pages(gfp_flags, order);
-	if (buffer)
-		return buffer;
-
-	/* complete and utter failure */
-	return NULL;
+	return (char *)__get_free_pages(gfp_flags, order);
 }
 
 static struct pgv *alloc_pg_vec(struct tpacket_req *req, int order)
-- 
2.26.2.761.g0e0b3e54be-goog

