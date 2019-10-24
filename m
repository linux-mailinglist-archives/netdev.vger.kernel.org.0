Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA34E2A0D
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 07:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407022AbfJXFpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 01:45:00 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:56399 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404418AbfJXFo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 01:44:59 -0400
Received: by mail-pf1-f202.google.com with SMTP id b17so18071393pfo.23
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 22:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PjVtn+zCLXRdABVLSnGlxbEadwsdS9nIPoe7y2yPI7M=;
        b=UgsyRuer/EE8/e0RrBJzGRemNAndHhSCai/8kb5lPuM+IB/Ir0ULmk/mxCC2Smy9Fj
         wWDgfpSN8s8CW4OQVah4KoreQ0kTXpMugc+v2TapR/0vHb1tuMzasnyTZWp2YgQaXPWp
         6RknJcpnwKGKeRn8QWrC2PCPsAdkwr4emA7U3atxsuZRVzwAc/7VumbwwKtbm16B6wlC
         kvwVK7AMICG9K2G8Fl+x7tfKi1MDaRF6GQS7wfHWR01xqJH5nR4/iGAzeJO8pIcbueph
         FE//SKasg+mtAVPLbElfjpAMCbAYJDbO+WPaE0WEnvXicIlpaTGto/R4IuN4ifclMJCX
         F0SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PjVtn+zCLXRdABVLSnGlxbEadwsdS9nIPoe7y2yPI7M=;
        b=Yy4C8TTzDTMYPu560NclSLEgk4Cm6IgrigbbdcAtBKtfRFnq6B2AVfbwWGtjtyYhTJ
         cw3i9P1GSO7E2Qw/0dMHJjj9J4YPH3K+CUzy1X6+zNy2v9RCsnFICvYsh6QhzOEjJSKl
         QfQ/EPg6+0uCrragHavbwsB43nLe2OdsY4XUre1uFlSO3h4r6XcdoSoi3H4rFOrIz+S/
         7147+2AU1iSY/0rXs/9WQcX5Lb5ceBA44ROWRlF5I1wnGuz/AjNQNymVnAYNJpnEHuDI
         aUNe5mboBB940cjh4tn0d9reoYdDIJJ2rQPNXBCG+FlQXqrelQkPN4Z9kAPbtb/K2dFW
         Dmbg==
X-Gm-Message-State: APjAAAXQXCxLqYC5cEEccmh7OTSwEvNcnOJ2A/izJ/jqNLVTBNlDjT2v
        O5N8VaMnDsIjb1yGRsRYLtUWdenU/pjvqg==
X-Google-Smtp-Source: APXvYqwWsBnZex8g6xzI3Fj/VgfERV9Jgpyaoo8H92nK4pOBUJ1+gtVnb2hiihKQ5A6/p1IeeUem7vaO3BQSFA==
X-Received: by 2002:a63:5762:: with SMTP id h34mr14810732pgm.235.1571895898641;
 Wed, 23 Oct 2019 22:44:58 -0700 (PDT)
Date:   Wed, 23 Oct 2019 22:44:48 -0700
In-Reply-To: <20191024054452.81661-1-edumazet@google.com>
Message-Id: <20191024054452.81661-2-edumazet@google.com>
Mime-Version: 1.0
References: <20191024054452.81661-1-edumazet@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH net 1/5] net: add skb_queue_empty_lockless()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some paths call skb_queue_empty() without holding
the queue lock. We must use a barrier in order
to not let the compiler do strange things, and avoid
KCSAN splats.

Adding a barrier in skb_queue_empty() might be overkill,
I prefer adding a new helper to clearly identify
points where the callers might be lockless. This might
help us finding real bugs.

The corresponding WRITE_ONCE() should add zero cost
for current compilers.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/skbuff.h | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a391147c03d4090252117e106a0df8f612955634..64a395c7f6895ce4dc439571de2eec8673b393e4 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1495,6 +1495,19 @@ static inline int skb_queue_empty(const struct sk_buff_head *list)
 	return list->next == (const struct sk_buff *) list;
 }
 
+/**
+ *	skb_queue_empty_lockless - check if a queue is empty
+ *	@list: queue head
+ *
+ *	Returns true if the queue is empty, false otherwise.
+ *	This variant can be used in lockless contexts.
+ */
+static inline bool skb_queue_empty_lockless(const struct sk_buff_head *list)
+{
+	return READ_ONCE(list->next) == (const struct sk_buff *) list;
+}
+
+
 /**
  *	skb_queue_is_last - check if skb is the last entry in the queue
  *	@list: queue head
@@ -1848,9 +1861,11 @@ static inline void __skb_insert(struct sk_buff *newsk,
 				struct sk_buff *prev, struct sk_buff *next,
 				struct sk_buff_head *list)
 {
-	newsk->next = next;
-	newsk->prev = prev;
-	next->prev  = prev->next = newsk;
+	/* see skb_queue_empty_lockless() for the opposite READ_ONCE() */
+	WRITE_ONCE(newsk->next, next);
+	WRITE_ONCE(newsk->prev, prev);
+	WRITE_ONCE(next->prev, newsk);
+	WRITE_ONCE(prev->next, newsk);
 	list->qlen++;
 }
 
@@ -1861,11 +1876,11 @@ static inline void __skb_queue_splice(const struct sk_buff_head *list,
 	struct sk_buff *first = list->next;
 	struct sk_buff *last = list->prev;
 
-	first->prev = prev;
-	prev->next = first;
+	WRITE_ONCE(first->prev, prev);
+	WRITE_ONCE(prev->next, first);
 
-	last->next = next;
-	next->prev = last;
+	WRITE_ONCE(last->next, next);
+	WRITE_ONCE(next->prev, last);
 }
 
 /**
@@ -2006,8 +2021,8 @@ static inline void __skb_unlink(struct sk_buff *skb, struct sk_buff_head *list)
 	next	   = skb->next;
 	prev	   = skb->prev;
 	skb->next  = skb->prev = NULL;
-	next->prev = prev;
-	prev->next = next;
+	WRITE_ONCE(next->prev, prev);
+	WRITE_ONCE(prev->next, next);
 }
 
 /**
-- 
2.23.0.866.gb869b98d4c-goog

