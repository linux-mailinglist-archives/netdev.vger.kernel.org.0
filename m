Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C19658616C
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 22:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237816AbiGaUpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 16:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbiGaUpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 16:45:19 -0400
X-Greylist: delayed 333 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 31 Jul 2022 13:45:16 PDT
Received: from forward107j.mail.yandex.net (forward107j.mail.yandex.net [IPv6:2a02:6b8:0:801:2::252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D148262FD
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 13:45:15 -0700 (PDT)
Received: from forward101q.mail.yandex.net (forward101q.mail.yandex.net [IPv6:2a02:6b8:c0e:4b:0:640:4012:bb98])
        by forward107j.mail.yandex.net (Yandex) with ESMTP id 05EB5885049;
        Sun, 31 Jul 2022 23:39:41 +0300 (MSK)
Received: from vla5-047c0c0d12a6.qloud-c.yandex.net (vla5-047c0c0d12a6.qloud-c.yandex.net [IPv6:2a02:6b8:c18:3484:0:640:47c:c0d])
        by forward101q.mail.yandex.net (Yandex) with ESMTP id 009FD13E80013;
        Sun, 31 Jul 2022 23:39:41 +0300 (MSK)
Received: by vla5-047c0c0d12a6.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id NpXOvmMWhn-ddi4bq9Z;
        Sun, 31 Jul 2022 23:39:40 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ya.ru; s=mail; t=1659299980;
        bh=lUu2cT/YmTyIfIZPs0Z29UrAYH+ZcVofGfKndkT/xm8=;
        h=Date:Message-ID:Subject:From:To;
        b=iV+defv319vTFgiynmIGrIQzr4WU3PKJ5h/sJjje/gRXu8me9cTFsQAgG2VFWPxrS
         zTJMD/qcOxY0Sz81hKI/NyvdBbPyx+zcNbDUrH+1H+tRB5cQ3OQHAtVmDXOFzgX6Sn
         a6viWvatGbj31jSMtaPd+pxxRuJ8tlGIrodqgHUI=
Authentication-Results: vla5-047c0c0d12a6.qloud-c.yandex.net; dkim=pass header.i=@ya.ru
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        tkhai@ya.ru
From:   Kirill Tkhai <tkhai@ya.ru>
Subject: [PATCH] net: skb content must be visible for lockless skb_peek() and
 its variations
Message-ID: <de516124-ffd7-d159-2848-00c65a8573a8@ya.ru>
Date:   Sun, 31 Jul 2022 23:39:39 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kirill Tkhai <tkhai@ya.ru>

Currently, there are no barriers, and skb->xxx update may become invisible on cpu2.
In the below example var2 may point to intial_val0 instead of expected var1:

[cpu1]					[cpu2]
skb->xxx = initial_val0;
...
skb->xxx = var1;			skb = READ_ONCE(prev_skb->next);
<no barrier>				<no barrier>
WRITE_ONCE(prev_skb->next, skb);	var2 = skb->xxx;

This patch adds barriers and fixes the problem. Note, that __skb_peek() is not patched,
since it's a lowlevel function, and a caller has to understand the things it does (and
also __skb_peek() is used under queue lock in some places).

Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
---
Hi, David, Eric and other developers,

picking unix sockets code I found this problem, and for me it looks like it exists. If there
are arguments that everything is OK and it's expected, please, explain.

Best wishes,
Kirill

 include/linux/skbuff.h |    9 ++++++---
 net/core/skbuff.c      |    6 ++++++
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index ca8afa382bf2..2939a5dc0ad7 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2018,7 +2018,8 @@ static inline struct sk_buff *skb_unshare(struct sk_buff *skb,
  */
 static inline struct sk_buff *skb_peek(const struct sk_buff_head *list_)
 {
-	struct sk_buff *skb = list_->next;
+	/* Pairs with mb in skb_queue_tail() and variations */
+	struct sk_buff *skb = smp_load_acquire(&list_->next);
 
 	if (skb == (struct sk_buff *)list_)
 		skb = NULL;
@@ -2048,7 +2049,8 @@ static inline struct sk_buff *__skb_peek(const struct sk_buff_head *list_)
 static inline struct sk_buff *skb_peek_next(struct sk_buff *skb,
 		const struct sk_buff_head *list_)
 {
-	struct sk_buff *next = skb->next;
+	/* Pairs with mb in skb_queue_tail() and variations */
+	struct sk_buff *next = smp_load_acquire(&skb->next);
 
 	if (next == (struct sk_buff *)list_)
 		next = NULL;
@@ -2070,7 +2072,8 @@ static inline struct sk_buff *skb_peek_next(struct sk_buff *skb,
  */
 static inline struct sk_buff *skb_peek_tail(const struct sk_buff_head *list_)
 {
-	struct sk_buff *skb = READ_ONCE(list_->prev);
+	/* Pairs with mb in skb_queue_tail() and variations */
+	struct sk_buff *skb = smp_load_acquire(&list_->prev);
 
 	if (skb == (struct sk_buff *)list_)
 		skb = NULL;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 974bbbbe7138..1de46eb91405 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3373,6 +3373,8 @@ void skb_queue_head(struct sk_buff_head *list, struct sk_buff *newsk)
 	unsigned long flags;
 
 	spin_lock_irqsave(&list->lock, flags);
+	/* Pairs with mb in skb_peek() and variations */
+	smp_mb__after_spinlock();
 	__skb_queue_head(list, newsk);
 	spin_unlock_irqrestore(&list->lock, flags);
 }
@@ -3394,6 +3396,8 @@ void skb_queue_tail(struct sk_buff_head *list, struct sk_buff *newsk)
 	unsigned long flags;
 
 	spin_lock_irqsave(&list->lock, flags);
+	/* Pairs with mb in skb_peek() and variations */
+	smp_mb__after_spinlock();
 	__skb_queue_tail(list, newsk);
 	spin_unlock_irqrestore(&list->lock, flags);
 }
@@ -3434,6 +3438,8 @@ void skb_append(struct sk_buff *old, struct sk_buff *newsk, struct sk_buff_head
 	unsigned long flags;
 
 	spin_lock_irqsave(&list->lock, flags);
+	/* Pairs with mb in skb_peek() and variations */
+	smp_mb__after_spinlock();
 	__skb_queue_after(list, old, newsk);
 	spin_unlock_irqrestore(&list->lock, flags);
 }
