Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A56EC3E1BDC
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 20:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242087AbhHES61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 14:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241909AbhHES6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 14:58:19 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA14C0613D5
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 11:58:04 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id u25so8699038oiv.5
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 11:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k0oWnw1iEzGMxCm97S2VjsBDNn5HqcZNLXK2S6kEYuc=;
        b=bcFzV2AicWck3498wHLkQ4LAahxz4vUuDfO/1AEdjppHx8UlCMVIB5pDdWqnVoAsIW
         l6Lux6H5pMyelGL/0/asyRCWYwvhwwY3+Suud3JOGLusG+LxOleSd1AqKFK3TEJs42ta
         oU05g1MHkxNylEWz9QACUZvnE5YZcqPsVmYVSKbmn4k7KU2MOmCbeGToAj8rMIpeU4ma
         PacRiwgSI9hrvYrrgcAkQy1qPUAE2mOyi3MwRNv3ZvRN/ny0x3A3RAWyik/IfNbQVvkm
         W1fVy55B2bDG3/gDhNFs5KkMcubR1+VYKwnf40y4xq8LqYKKvRdduuucxbTPNxIDogG3
         cdZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k0oWnw1iEzGMxCm97S2VjsBDNn5HqcZNLXK2S6kEYuc=;
        b=BYUzrmG0O7M+ypgzCSnJXGdj3cfNQibeVz6cj4YokaBgQDA/l8Hy8Mg54I6aqe186S
         xSkdKxhspfZVD2SB0eBhZFx9ZJRGLCb8F0cZ/XJctV0Zr/VfdZpV4HTAqyPWdL0KSnzE
         CXN8ZsOIXesIY8Eie3VV2HhhMn5kQSWxqK+/uYHOFYwriQIZTfivXbKmMa9wkoIqJ0SX
         fuJwjQqhQYzN5jRUnsvZ53H+fMAHlR+S7UdqopaQ3tcm6tKe/QBSYo//lj06oeTOyLnT
         vKfIxVqC6OowD74fE9mkRUSkGfC7t0mq97xeI+44q4s+psgr7YukWMsXsGmcx/WErUcT
         qqgA==
X-Gm-Message-State: AOAM532FtCqp3NQv0P495zR9hzMr9LjotTqbig7odQjYwRlyKBDycIA9
        6QRCEUyHC5NQxVczKu/KS4iZXjN1u1E=
X-Google-Smtp-Source: ABdhPJz14R3OHwaMBgxymiZxVSm1SuKUYJwvDaKZPW3HBPkV7TmrkvjrNARm4Ripc2QZh9X+bJ1gcQ==
X-Received: by 2002:a05:6808:4d0:: with SMTP id a16mr1394030oie.166.1628189884251;
        Thu, 05 Aug 2021 11:58:04 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:c64b:2366:2e53:c024])
        by smtp.gmail.com with ESMTPSA id r5sm358678otk.71.2021.08.05.11.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 11:58:03 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch net-next 11/13] tcp: introduce tracepoint trace_tcp_v4_rcv()
Date:   Thu,  5 Aug 2021 11:57:48 -0700
Message-Id: <20210805185750.4522-12-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
References: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qitao Xu <qitao.xu@bytedance.com>

Tracepoint trace_tcp_v4_rcv() is introduced to trace skb at
the entrance of TCP layer on RX side.

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
---
 include/trace/events/tcp.h | 7 +++++++
 net/ipv4/tcp_ipv4.c        | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/include/trace/events/tcp.h b/include/trace/events/tcp.h
index 6147528d93ba..adf84866dee9 100644
--- a/include/trace/events/tcp.h
+++ b/include/trace/events/tcp.h
@@ -109,6 +109,13 @@ DEFINE_EVENT(tcp_event_sk_skb, tcp_retransmit_skb,
 	TP_ARGS(sk, skb)
 );
 
+DEFINE_EVENT(tcp_event_sk_skb, tcp_v4_rcv,
+
+	TP_PROTO(const struct sock *sk, const struct sk_buff *skb),
+
+	TP_ARGS(sk, skb)
+);
+
 /*
  * skb of trace_tcp_send_reset is the skb that caused RST. In case of
  * active reset, skb should be NULL
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 2e62e0d6373a..a0c4aa488659 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2093,6 +2093,8 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	bh_unlock_sock(sk);
 	if (skb_to_free)
 		__kfree_skb(skb_to_free);
+	if (!ret)
+		trace_tcp_v4_rcv(sk, skb);
 
 put_and_return:
 	if (refcounted)
-- 
2.27.0

