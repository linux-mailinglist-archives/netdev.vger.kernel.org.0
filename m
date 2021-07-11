Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044BA3C3ED5
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 21:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbhGKTGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 15:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhGKTGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 15:06:09 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19384C0613DD
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 12:03:21 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id z12so12111613qtj.3
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 12:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=olE1p8t6bJ0GRj5U1Uz9/BHCvrL8dNzA2ret69hHCsQ=;
        b=t+8ejIzezQPgj3aWZYQ91RyodFzFhsHn+7sODycK9V7cLg6/+eqk+YbJb5NVlsLwDY
         FDO4DB6P5oXm5qhi9ykzzWLenzMK0+DoYBJZW7JHV1VUXQXZMt+IN7g/vHzO8qiDLp7S
         d3xTzTgodNW/8fmEN5hhJ4kgCxiMRfsGX5PCkPLWOshwko598VifWTKvMfQebmoA3kCF
         gYLpol1tSYIIgaZ4W6ZLXHYuVf1lPXcb0V8a7gW2g4ppreJ3nDwtbI349KUf8U9D4P5v
         ZaAhzsIsBq/OUlONZtCDCftXsEGFbhrKgjHUFPpo/JWGjx7VTZj7gbhMEkWBEQ2UbfIp
         99gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=olE1p8t6bJ0GRj5U1Uz9/BHCvrL8dNzA2ret69hHCsQ=;
        b=OFYIEhudeJW7JWSLbxoH8hJ6yPlr3AAMX7uNyKKGy9755w1+mVfTZ3kuVjjS5s3kJD
         c+yrx+hQe3hGRlKpkhlzLQ+fTm17GVHvOUyEa4Y/9CmiAs6kXz8yayBI5fRNYJXsMDcE
         gp29BlKaITNYoSFY8BSCGbTyzQrfHfAJrPVfv2XOLwgQRU0x3S+RYPH4Zz8Sa8ljwy2D
         QAAcejO0+a+1GSzc60mypLgAUaRmH7mjrb34EHcxFyGn8yr8Ak8u3SAEm/wocoKPA+bI
         2sec7VbrqH2oOZCrsOiQOVGPN3T9oI06I9PWCi3wE6Y0Rkc03Gy8aWX8W2AqkFAzLlP9
         6aEw==
X-Gm-Message-State: AOAM531OqsS8iKtCrbQAk7YddH5B1E6OEeR/gMpL4u2/k1a85te88Td5
        EP9zUj/3zw8mh21cCNidCT3kbmBT1vU=
X-Google-Smtp-Source: ABdhPJycKsgBVJXxzpgsPkWNxLzTk6v8dOHOhF0UYWaf29+Rhpwo4bUUmyXRxer/u1fJCv5g3t+LRA==
X-Received: by 2002:a05:622a:170d:: with SMTP id h13mr43579531qtk.264.1626030200008;
        Sun, 11 Jul 2021 12:03:20 -0700 (PDT)
Received: from unknown.attlocal.net (76-217-55-94.lightspeed.sntcca.sbcglobal.net. [76.217.55.94])
        by smtp.gmail.com with ESMTPSA id f16sm2455179qtf.19.2021.07.11.12.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 12:03:19 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     xiangxia.m.yue@gmail.com, Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net-next v2] net_sched: introduce tracepoint trace_qdisc_enqueue()
Date:   Sun, 11 Jul 2021 12:03:08 -0700
Message-Id: <20210711190308.8476-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qitao Xu <qitao.xu@bytedance.com>

Tracepoint trace_qdisc_enqueue() is introduced to trace skb at
the entrance of TC layer on TX side. This is kinda symmetric to
trace_qdisc_dequeue(), and together they can be used to calculate
the packet queueing latency. It is more accurate than
trace_net_dev_queue(), because we already successfully enqueue
the packet at that point.

Note, trace ring buffer is only accessible to privileged users,
it is safe to use %px to print a real kernel address here.

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
---
 include/trace/events/qdisc.h | 26 ++++++++++++++++++++++++++
 net/core/dev.c               |  9 +++++++++
 2 files changed, 35 insertions(+)

diff --git a/include/trace/events/qdisc.h b/include/trace/events/qdisc.h
index 58209557cb3a..c3006c6b4a87 100644
--- a/include/trace/events/qdisc.h
+++ b/include/trace/events/qdisc.h
@@ -46,6 +46,32 @@ TRACE_EVENT(qdisc_dequeue,
 		  __entry->txq_state, __entry->packets, __entry->skbaddr )
 );
 
+TRACE_EVENT(qdisc_enqueue,
+
+	TP_PROTO(struct Qdisc *qdisc, const struct netdev_queue *txq, struct sk_buff *skb),
+
+	TP_ARGS(qdisc, txq, skb),
+
+	TP_STRUCT__entry(
+		__field(struct Qdisc *, qdisc)
+		__field(void *,	skbaddr)
+		__field(int, ifindex)
+		__field(u32, handle)
+		__field(u32, parent)
+	),
+
+	TP_fast_assign(
+		__entry->qdisc = qdisc;
+		__entry->skbaddr = skb;
+		__entry->ifindex = txq->dev ? txq->dev->ifindex : 0;
+		__entry->handle	 = qdisc->handle;
+		__entry->parent	 = qdisc->parent;
+	),
+
+	TP_printk("enqueue ifindex=%d qdisc handle=0x%X parent=0x%X skbaddr=%px",
+		  __entry->ifindex, __entry->handle, __entry->parent, __entry->skbaddr)
+);
+
 TRACE_EVENT(qdisc_reset,
 
 	TP_PROTO(struct Qdisc *q),
diff --git a/net/core/dev.c b/net/core/dev.c
index c253c2aafe97..20b9376de301 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -131,6 +131,7 @@
 #include <trace/events/napi.h>
 #include <trace/events/net.h>
 #include <trace/events/skb.h>
+#include <trace/events/qdisc.h>
 #include <linux/inetdevice.h>
 #include <linux/cpu_rmap.h>
 #include <linux/static_key.h>
@@ -3864,6 +3865,8 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 			if (unlikely(!nolock_qdisc_is_empty(q))) {
 				rc = q->enqueue(skb, q, &to_free) &
 					NET_XMIT_MASK;
+				if (rc == NET_XMIT_SUCCESS)
+					trace_qdisc_enqueue(q, txq, skb);
 				__qdisc_run(q);
 				qdisc_run_end(q);
 
@@ -3880,6 +3883,9 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 		}
 
 		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
+		if (rc == NET_XMIT_SUCCESS)
+			trace_qdisc_enqueue(q, txq, skb);
+
 		qdisc_run(q);
 
 no_lock_out:
@@ -3924,6 +3930,9 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 		rc = NET_XMIT_SUCCESS;
 	} else {
 		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
+		if (rc == NET_XMIT_SUCCESS)
+			trace_qdisc_enqueue(q, txq, skb);
+
 		if (qdisc_run_begin(q)) {
 			if (unlikely(contended)) {
 				spin_unlock(&q->busylock);
-- 
2.27.0

