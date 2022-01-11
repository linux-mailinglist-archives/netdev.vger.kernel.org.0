Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B59348A4F5
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346323AbiAKBZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:25:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346264AbiAKBY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 20:24:58 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C152DC061759;
        Mon, 10 Jan 2022 17:24:50 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id h10so19951237wrb.1;
        Mon, 10 Jan 2022 17:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WDqDCJ5NL4LuLdFrIrWhPcUdc5NRFY/X6Wj3QPHSD+0=;
        b=jUYWI+ZeIL9Eiqqj4RXjPaskEPvUgcrcURe2yNVDLyZRX1LnViGUVMjDsSC77TINMQ
         IrqQoFOg2TN1nHYrY8EM7Y8ti03U3rg74bgeP8kp0GzT4NNahvLzxdx0KnyHCCaBBNyW
         ChlkqU9CWK/qWwlkYKFwkK+D/8QbOeLyw7OVWkJAeQp1jdwKN5o4U42VEtfEWHLknuWz
         PPiLtK2X2WkicUrITJLx3K6p6T5VP6zRrlPyXC71pc5RzWn2+qnu6J1rLOkjvGr7X2lw
         IS6MYmr5b7dafDZfj3Dwrzs3ReaxpFAV6iMDb4sxipPa/FwWpd4MNyt3ZQyUvFP8w37/
         U4Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WDqDCJ5NL4LuLdFrIrWhPcUdc5NRFY/X6Wj3QPHSD+0=;
        b=QuiyUTlXqxrspaoQRp85+F0dq7L5bTPBtKgqrtjvaXQcP9NRb6iuTn8c0NeLCGzEhl
         ODWFF9V2s+T98bZw3E9/yVAW5B7KzQXxIuv8IWrh0fwPFJqXflq2kXyZxb2E3Rc1QFcm
         mQhfoyRjWRMa+qhxzs2iendHRQRYhL1LD+L80rPaCxQ1D7EBcd/vQw6q8bWAQxlTobBL
         xnZIJEY5BtQvAYxskGItEvKj6ENF/cfMLnCWhJZcqEyIt7AOSFE3o9uaA7rLec/L38kc
         Ypbw7d2AlYn4gD8BAogRT39FSJ5LVzbQWy7Gx17ybH8/+7cTNFfvWI2KoREFZnYJrYsM
         VCeg==
X-Gm-Message-State: AOAM5321sOSdhPvlIi5yPwLeL5BaiXSComUTcPBiVC2KZBcwBA9pgjFw
        dWe1KSTQkIAvK470pvitgYuTlrlfXd0=
X-Google-Smtp-Source: ABdhPJycpZT0wJ2aEQqt0aii/EvocEROihH3EMOvsKk1uk9kd6TX8js7d3DSqsahDk+Q3bcxdwCoYg==
X-Received: by 2002:a5d:4c84:: with SMTP id z4mr1569710wrs.318.1641864289271;
        Mon, 10 Jan 2022 17:24:49 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.129.73])
        by smtp.gmail.com with ESMTPSA id i8sm709886wru.26.2022.01.10.17.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 17:24:49 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 06/14] ipv6: pass full cork into __ip6_append_data()
Date:   Tue, 11 Jan 2022 01:21:38 +0000
Message-Id: <56c58d7537b65a5bcadf5d17f86e010dbba81485.1641863490.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1641863490.git.asml.silence@gmail.com>
References: <cover.1641863490.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert a struct inet_cork argument in __ip6_append_data() to struct
inet_cork_full. As one struct contains another inet_cork is still can
be accessed via ->base field. It's a preparation patch making further
changes a bit cleaner.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index b8fdda9ac797..62da09819750 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1424,7 +1424,7 @@ static int ip6_setup_cork(struct sock *sk, struct inet_cork_full *cork,
 static int __ip6_append_data(struct sock *sk,
 			     struct flowi6 *fl6,
 			     struct sk_buff_head *queue,
-			     struct inet_cork *cork,
+			     struct inet_cork_full *cork_full,
 			     struct inet6_cork *v6_cork,
 			     struct page_frag *pfrag,
 			     int getfrag(void *from, char *to, int offset,
@@ -1433,6 +1433,7 @@ static int __ip6_append_data(struct sock *sk,
 			     unsigned int flags, struct ipcm6_cookie *ipc6)
 {
 	struct sk_buff *skb, *skb_prev = NULL;
+	struct inet_cork *cork = &cork_full->base;
 	unsigned int maxfraglen, fragheaderlen, mtu, orig_mtu, pmtu;
 	struct ubuf_info *uarg = NULL;
 	int exthdrlen = 0;
@@ -1797,7 +1798,7 @@ int ip6_append_data(struct sock *sk,
 		transhdrlen = 0;
 	}
 
-	return __ip6_append_data(sk, fl6, &sk->sk_write_queue, &inet->cork.base,
+	return __ip6_append_data(sk, fl6, &sk->sk_write_queue, &inet->cork,
 				 &np->cork, sk_page_frag(sk), getfrag,
 				 from, length, transhdrlen, flags, ipc6);
 }
@@ -1993,7 +1994,7 @@ struct sk_buff *ip6_make_skb(struct sock *sk,
 	if (ipc6->dontfrag < 0)
 		ipc6->dontfrag = inet6_sk(sk)->dontfrag;
 
-	err = __ip6_append_data(sk, fl6, &queue, &cork->base, &v6_cork,
+	err = __ip6_append_data(sk, fl6, &queue, cork, &v6_cork,
 				&current->task_frag, getfrag, from,
 				length + exthdrlen, transhdrlen + exthdrlen,
 				flags, ipc6);
-- 
2.34.1

