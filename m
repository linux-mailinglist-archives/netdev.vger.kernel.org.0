Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31B5EE0F23
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 02:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733098AbfJWAWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 20:22:20 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37582 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732674AbfJWAWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 20:22:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571790137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=BRtNNhXUxGj/iKOpVn/NIU4B21BikmHUzRYNqGSNsWA=;
        b=FetI7HPExsWO2dNfy3mGlUddt/L+vGzUdnFZJOBb4LiUqqxvhHV/zFJtBspYKWODKHcL7+
        SfHDNu/ETgCJZiwYJm+e/HkRFD/JcTiw/Q5MrDuOt1qOtVymBCwl2ryXM/3gD7qfsgbUzP
        PG47OjGiclfEaqycaXO9ZKIBLC6ROlY=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-0DGcz_o2PICEq0LvPhBpbw-1; Tue, 22 Oct 2019 20:22:16 -0400
Received: by mail-yb1-f198.google.com with SMTP id k79so14610360ybf.21
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 17:22:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=+IXJWBytrC/xK/Bmd9e8MMpXuNGH/WR5SvJe1bLIZuI=;
        b=GcU0S3c1Qt6IOcJnxbAXEaDO1fLs8A9GfsRCghdSyLYJbXKYx1OBG1U8MGETigG+cu
         C8xs55u5uz4H2jYK3CVEc0cKMcwfxPHmUcipGdpcGOhlasUHRdImZyIwTYLcRrqQN4xG
         JsVh+TQ3/fcGUMACiQVf3twInEj8vgtx43lnNHaAs6dv/fzEeCxQp0rM/6r4vyV01ecN
         b6RuRST432dZDDqEYjSE2qPQaB3L4TBp4Wi4tv0MKcWD7U2/5meRZvASzCRkdSK6DC+Q
         T6X9G5axTB7V1bJuiQMO7pJknV3gsQ2K61v3BxD1xaQhochiTafA2hOLTKJy29NUwRBt
         SzZw==
X-Gm-Message-State: APjAAAXZdSKRkc+0mEy9zYewSwEgVt9peOt9ruRs3HwK9YD6rCr+gxyt
        CJDwpIQU9+059ltGPNqttoPLKkCGi91a3Di2ogvVyfREKIabA5Bfk33Yu9H4sRwK7yQTLscBkGZ
        bSN9TwyOY1REwBOSZuAgymQf+nyFgt7zE
X-Received: by 2002:a25:b6ca:: with SMTP id f10mr4835415ybm.376.1571790135333;
        Tue, 22 Oct 2019 17:22:15 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxI7865C7FbMjHafWESnBA/nOolnjjYIAPJZxe09kuTpOgpGHlm0WoGto+SV1G5gY7LUkg625qYOyF/uv18VNA=
X-Received: by 2002:a25:b6ca:: with SMTP id f10mr4835396ybm.376.1571790134960;
 Tue, 22 Oct 2019 17:22:14 -0700 (PDT)
MIME-Version: 1.0
From:   Tom Rix <trix@redhat.com>
Date:   Tue, 22 Oct 2019 17:22:04 -0700
Message-ID: <CACVy4SUkfn4642Vne=c1yuWhne=2cutPZQ5XeXz_QBz1g67CrA@mail.gmail.com>
Subject: [PATCH v2 1/1] xfrm : lock input tasklet skb queue
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joerg Vehlow <lkml@jv-coder.de>
X-MC-Unique: 0DGcz_o2PICEq0LvPhBpbw-1
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

This is the original work of Joerg Vehlow <joerg.vehlow@aox-tech.de>
https://lkml.org/lkml/2019/9/9/111
  xfrm_input: Protect queue with lock

  During the skb_queue_splice_init the tasklet could have been preempted
  and __skb_queue_tail called, which led to an inconsistent queue.

ifdefs for CONFIG_PREEMPT_RT_FULL added to reduce runtime effects
on the normal kernel.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 net/xfrm/xfrm_input.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 9b599ed66d97..decd515f84cf 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -755,13 +755,21 @@ EXPORT_SYMBOL(xfrm_input_resume);

 static void xfrm_trans_reinject(unsigned long data)
 {
+#ifdef CONFIG_PREEMPT_RT_FULL
+    unsigned long flags;
+#endif
     struct xfrm_trans_tasklet *trans =3D (void *)data;
     struct sk_buff_head queue;
     struct sk_buff *skb;

     __skb_queue_head_init(&queue);
+#ifdef CONFIG_PREEMPT_RT_FULL
+    spin_lock_irqsave(&trans->queue.lock, flags);
+#endif
     skb_queue_splice_init(&trans->queue, &queue);
-
+#ifdef CONFIG_PREEMPT_RT_FULL
+    spin_unlock_irqrestore(&trans->queue.lock, flags);
+#endif
     while ((skb =3D __skb_dequeue(&queue)))
         XFRM_TRANS_SKB_CB(skb)->finish(dev_net(skb->dev), NULL, skb);
 }
@@ -778,7 +786,11 @@ int xfrm_trans_queue(struct sk_buff *skb,
         return -ENOBUFS;

     XFRM_TRANS_SKB_CB(skb)->finish =3D finish;
+#ifdef CONFIG_PREEMPT_RT_FULL
+    skb_queue_tail(&trans->queue, skb);
+#else
     __skb_queue_tail(&trans->queue, skb);
+#endif
     tasklet_schedule(&trans->tasklet);
     return 0;
 }
@@ -798,7 +810,11 @@ void __init xfrm_input_init(void)
         struct xfrm_trans_tasklet *trans;

         trans =3D &per_cpu(xfrm_trans_tasklet, i);
+#ifdef CONFIG_PREEMPT_RT_FULL
+        skb_queue_head_init(&trans->queue);
+#else
         __skb_queue_head_init(&trans->queue);
+#endif
         tasklet_init(&trans->tasklet, xfrm_trans_reinject,
                  (unsigned long)trans);
     }
--=20
2.23.0

