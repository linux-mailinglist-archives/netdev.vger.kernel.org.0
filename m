Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66146439C06
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 18:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234093AbhJYQu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 12:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234071AbhJYQuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 12:50:55 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D052BC061348
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:48:32 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id c4so11504960pgv.11
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sYXfm/4e8postm1njOaXmHy+JuD2lpfYTQAHOwn6i88=;
        b=Ab28K0ihWm8FsFYwesYLdcCxJzuZrZ8GlKPQ/hwZ3Mtrrg9ptqMOynD4b/xaYsD47e
         OLOF4cJo/OeIeK/dM9g4QsmP5A388T7D5THpV3HwbEl5KIBoFznXrVS6CnIzcTrEuasA
         D+lkmxSXqZMtsHcvXq9DdalPZponHGo0ABeUAG44c8bOG7+mj3367WMHtcrwfJGj7WLh
         q0AANbM4QXCQyruW3fpvMXcSVhprcoZODYv9P1eX453PQh2a9vO6BALjgQCPcx33dVZ6
         p2NBX0rD9hHlvBIACZvKJMj0TM3wl03wHebW5pPn4xyxGZ3pYScGgvb/O4qZvaw2OoBw
         GlaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sYXfm/4e8postm1njOaXmHy+JuD2lpfYTQAHOwn6i88=;
        b=A5Ss+lWpQqtzn/BVDZclXGXbdikhCTcBHD9dfD0x92L+E3TSe+CwIIULEhFBzk4MX8
         2nsD1CvFBkmzsM0oHMU9zGWN7Zv9CuE3jzzT6Z223OqA0ZMzoi+fy0lZI7IoeD2at/CW
         dc7jyfsLtyPUN9WOaGps6oWNO2p52k4KI1YzrNpEdud8E8Sz3xTJOekI2VsgSs87byfo
         p5AcezjfKXUphnwM6txJs6WzdmuKORB42MDxMMeVrFMkC9EPOVrNodxix72dreKGwGu4
         Z+740LuIZQ0JXZ5HLVq1Fbk2P8cjFqWaTequo9Ca9AD3SD1Y9YnkN4dnLLq3gmycP1sj
         efhw==
X-Gm-Message-State: AOAM531wFimjNO8xe3DAmmqlsh+8rq8DYNL8Ska5K8bh9McfQg1LoFuq
        YxeEPPZSZoReTxdpw9l1VgI=
X-Google-Smtp-Source: ABdhPJzBrTx25uZ+ZbA/bbW+MEsLU81GuBzOyERRqx/Iiu5cBGZzAh58P5ztD03QkbzAtFcFQVxwpg==
X-Received: by 2002:a63:f306:: with SMTP id l6mr14405955pgh.72.1635180512470;
        Mon, 25 Oct 2021 09:48:32 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b7cd:daa3:a144:1652])
        by smtp.gmail.com with ESMTPSA id b3sm17052582pfm.54.2021.10.25.09.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 09:48:32 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH v2 net-next 03/10] net: avoid dirtying sk->sk_napi_id
Date:   Mon, 25 Oct 2021 09:48:18 -0700
Message-Id: <20211025164825.259415-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211025164825.259415-1-eric.dumazet@gmail.com>
References: <20211025164825.259415-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

sk_napi_id is located in a cache line that can be kept read mostly.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
---
 include/net/busy_poll.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index 40296ed976a9778ceb239b99ad783cb99b8b92ef..4202c609bb0b09345c0f1c5105adf409a3a89f74 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -130,7 +130,8 @@ static inline void skb_mark_napi_id(struct sk_buff *skb,
 static inline void sk_mark_napi_id(struct sock *sk, const struct sk_buff *skb)
 {
 #ifdef CONFIG_NET_RX_BUSY_POLL
-	WRITE_ONCE(sk->sk_napi_id, skb->napi_id);
+	if (unlikely(READ_ONCE(sk->sk_napi_id) != skb->napi_id))
+		WRITE_ONCE(sk->sk_napi_id, skb->napi_id);
 #endif
 	sk_rx_queue_set(sk, skb);
 }
-- 
2.33.0.1079.g6e70778dc9-goog

