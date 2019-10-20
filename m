Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 211F4DDF41
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 17:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfJTPqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 11:46:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49287 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726467AbfJTPqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 11:46:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571586383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=NYB5YLU3InOkXCV2AcZVtukurd9BwBDSqfTnbkNJyC8=;
        b=bq/XcSfkXbhphf9CLs5z6dK3sKoTap6FyvaWccsshUz0wmjjMZ64ssyLZw8ZbEomNiKZAX
        Jkn6k4RzARE/B/zunKnBSgQcIvXcYZR8QMrzBcXVKaZi4Zz5tdAKJ6xLtLtP04Ya8FxVrN
        RYQ2QxhLuzmA68of5b34iDv8qM1pSSg=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-lbe6vLRoPcO70WN52X9t2Q-1; Sun, 20 Oct 2019 11:46:22 -0400
Received: by mail-yb1-f198.google.com with SMTP id o141so8905425yba.15
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 08:46:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Alu6ppHvSW114ed3pBahWURj9wM8iWBEEGZ8MLoKgAk=;
        b=J5sEhSmk3aCQDPktQJMemloe6Sf7N17a9Xlp56vce72qfZeGklKmrpMRUsjWcHjuj4
         QGD7mBVAuP/HhCuikad7pFAS1NSrkh8IjpAUT4UIJje6tcG+tQjkDq8HNFymzC3Ecwgg
         sGQvsHeivhcKjAdQtW72nA6E6o1L2b+MW80zka+Yz4bEB9cJOPtMGdqLZUA2YVI6p836
         /PmtsBo/yCa+mh1gWFPC6fyU+fW7MNxIm5SYDraZXV/fKvmxJxulTw56pDMdfH3JPy5a
         tz8u9zKeUgECAi5+5YD9rR+b87EBQKnP9d9mNLsgOqkMUxjSXn4Gltm+FNrMyqUezk4Q
         dmpA==
X-Gm-Message-State: APjAAAXxyQsj8PfyyEVFfDJ5E5dWexxgaQmE3KNLj6F9LHkwuhBF7ZD+
        +9TXE5BR0PsjfTpgr8NruWbQ8m7KQRLvYxJY9TikthkV/xHxjmQZFxLuM6ro8aOEdgIBY2kKt+b
        BMpjojWuhMhgvNhh/wcfKdHRlo/WvYFCQ
X-Received: by 2002:a25:2005:: with SMTP id g5mr11581344ybg.233.1571586381778;
        Sun, 20 Oct 2019 08:46:21 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxyKemkRcFRU3wzlgi/T4+K9AZ2BopYayuoVNBd36p+ggns4HBGKTFdfgg55BfQj8iXlviOeklLwD73HIE9Azs=
X-Received: by 2002:a25:2005:: with SMTP id g5mr11581330ybg.233.1571586381452;
 Sun, 20 Oct 2019 08:46:21 -0700 (PDT)
MIME-Version: 1.0
From:   Tom Rix <trix@redhat.com>
Date:   Sun, 20 Oct 2019 08:46:10 -0700
Message-ID: <CACVy4SVuw0Qbjiv6PLRn1symoxGzyBMZx2F5O23+jGZG6WHuYA@mail.gmail.com>
Subject: [PATCH] xfrm : lock input tasklet skb queue
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-MC-Unique: lbe6vLRoPcO70WN52X9t2Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On PREEMPT_RT_FULL while running netperf, a corruption
of the skb queue causes an oops.

This appears to be caused by a race condition here
        __skb_queue_tail(&trans->queue, skb);
        tasklet_schedule(&trans->tasklet);
Where the queue is changed before the tasklet is locked by
tasklet_schedule.

The fix is to use the skb queue lock.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 net/xfrm/xfrm_input.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 9b599ed66d97..226dead86828 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -758,12 +758,16 @@ static void xfrm_trans_reinject(unsigned long data)
     struct xfrm_trans_tasklet *trans =3D (void *)data;
     struct sk_buff_head queue;
     struct sk_buff *skb;
+    unsigned long flags;

     __skb_queue_head_init(&queue);
+    spin_lock_irqsave(&trans->queue.lock, flags);
     skb_queue_splice_init(&trans->queue, &queue);

     while ((skb =3D __skb_dequeue(&queue)))
         XFRM_TRANS_SKB_CB(skb)->finish(dev_net(skb->dev), NULL, skb);
+
+    spin_unlock_irqrestore(&trans->queue.lock, flags);
 }

 int xfrm_trans_queue(struct sk_buff *skb,
@@ -771,15 +775,20 @@ int xfrm_trans_queue(struct sk_buff *skb,
                    struct sk_buff *))
 {
     struct xfrm_trans_tasklet *trans;
+    unsigned long flags;

     trans =3D this_cpu_ptr(&xfrm_trans_tasklet);
+    spin_lock_irqsave(&trans->queue.lock, flags);

-    if (skb_queue_len(&trans->queue) >=3D netdev_max_backlog)
+    if (skb_queue_len(&trans->queue) >=3D netdev_max_backlog) {
+        spin_unlock_irqrestore(&trans->queue.lock, flags);
         return -ENOBUFS;
+    }

     XFRM_TRANS_SKB_CB(skb)->finish =3D finish;
     __skb_queue_tail(&trans->queue, skb);
     tasklet_schedule(&trans->tasklet);
+    spin_unlock_irqrestore(&trans->queue.lock, flags);
     return 0;
 }
 EXPORT_SYMBOL(xfrm_trans_queue);
--=20
2.23.0

