Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D8B286540
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 18:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbgJGQvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 12:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgJGQvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 12:51:16 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C211C061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 09:51:16 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x22so1626058pfo.12
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 09:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8nKvd4lpu9L+XjnWJLp5IXIS3kkZ7itOyedqI+btxy0=;
        b=LkZRYrttCcNdKKgsrJ/zRTjAGdS17UdsXGN0hmH0PJbWiMAnEdSTWPCiRGdnypQTlu
         VAszkgMWRFtuXFiRoZ6aFFz0IidqG3eroE5Q0bc7upSuLEy+SCgrwAd71yvwcDhlFLOE
         1pn5WvG14sGG0sgxwZ+O0rJB36UNrI7cSF6QphAUERkpBtrCGlfITzo/CEmQ/qDoSf51
         7EZZZkNzQtVyIKIjiGApaUCG8Rl6MOcMt2+YKlh6n+uOfHkItYTvKy7G69Bet/HyoHTI
         McvJKMKm3HXg4Lm+zkXXk9aaUrg1a7MbYftes0+ZzCLezmWGhSTdNvdYXLpe7Vawl4t0
         PISQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8nKvd4lpu9L+XjnWJLp5IXIS3kkZ7itOyedqI+btxy0=;
        b=ngLhltqrtRwtCuefcH1TX/HI1wOegHmykgW6yqxyKVbdpySoGuxVO0ydwYv6i2ESSb
         4iTt6e7oIRRUUtH970HgWSKP7DF7bpHMoye2oEv5RbivWB1iphlBPc+1qbJka/spdOVV
         jWBiknseShINpFhqnOgNtsRyPInDNR+gd4EdlTv4WI+RV8ByMwBgtKrbk+3JTpuFG5rk
         sGcI5anZrO2pKaKF7QC0l86U97miBV2XZqvZ+0uUyIdYzL48naSZiCFLhkw2ro6hLdTV
         0CEGKIl8+ChcLJdh7thaF6BhuA+uJqzasXf0ni2v2SQoSetGNf+FH3Kfzdo86+oJmRYc
         DLfg==
X-Gm-Message-State: AOAM533Rwkic5YqZkYvdOHZL6kdAmS61Qm6ecXRGK0EcI3rz2fHQ/gki
        fMJrMAN+ctq51AoDXNGFAvQ=
X-Google-Smtp-Source: ABdhPJyfSGC4aaO8YngLxFYYmXuTu9PuaWM24lB4RJLEy4DJZtnRHEtL/Nj+KWnc/rVLMsLd3rJbnQ==
X-Received: by 2002:a62:2985:0:b029:142:2501:35d3 with SMTP id p127-20020a6229850000b0290142250135d3mr3820473pfp.51.1602089475869;
        Wed, 07 Oct 2020 09:51:15 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id v3sm3032470pju.44.2020.10.07.09.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 09:51:15 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH net-next] net/sched: get rid of qdisc->padded
Date:   Wed,  7 Oct 2020 09:51:11 -0700
Message-Id: <20201007165111.172419-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

kmalloc() of sufficiently big portion of memory is cache-aligned
in regular conditions. If some debugging options are used,
there is no reason qdisc structures would need 64-byte alignment
if most other kernel structures are not aligned.

This get rid of QDISC_ALIGN and QDISC_ALIGNTO.

Addition of privdata field will help implementing
the reverse of qdisc_priv() and documents where
the private data is.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Allen Pais <allen.lkml@gmail.com>
---
 include/net/pkt_sched.h   |  5 +----
 include/net/sch_generic.h |  5 ++++-
 net/sched/sch_generic.c   | 23 +++++------------------
 3 files changed, 10 insertions(+), 23 deletions(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index ac8c890a2657e35546ec51fe8b8a993a2bd0c91b..4ed32e6b020145afb015c3c07d2ec3a613f1311d 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -19,12 +19,9 @@ struct qdisc_walker {
 	int	(*fn)(struct Qdisc *, unsigned long cl, struct qdisc_walker *);
 };
 
-#define QDISC_ALIGNTO		64
-#define QDISC_ALIGN(len)	(((len) + QDISC_ALIGNTO-1) & ~(QDISC_ALIGNTO-1))
-
 static inline void *qdisc_priv(struct Qdisc *q)
 {
-	return (char *) q + QDISC_ALIGN(sizeof(struct Qdisc));
+	return &q->privdata;
 }
 
 /* 
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 6c762457122fd0091cb0f2bf41bda73babc4ac12..d8fd8676fc724110630904909f64d7789f3a4b47 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -91,7 +91,7 @@ struct Qdisc {
 	struct net_rate_estimator __rcu *rate_est;
 	struct gnet_stats_basic_cpu __percpu *cpu_bstats;
 	struct gnet_stats_queue	__percpu *cpu_qstats;
-	int			padded;
+	int			pad;
 	refcount_t		refcnt;
 
 	/*
@@ -112,6 +112,9 @@ struct Qdisc {
 	/* for NOLOCK qdisc, true if there are no enqueued skbs */
 	bool			empty;
 	struct rcu_head		rcu;
+
+	/* private data */
+	long privdata[] ____cacheline_aligned;
 };
 
 static inline void qdisc_refcount_inc(struct Qdisc *qdisc)
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 54c417244642a1445c618e6adf0e38b2d4f84565..49eae93d1489dc3513b41c237ca3f572e21ff203 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -802,9 +802,8 @@ struct Qdisc *qdisc_alloc(struct netdev_queue *dev_queue,
 			  const struct Qdisc_ops *ops,
 			  struct netlink_ext_ack *extack)
 {
-	void *p;
 	struct Qdisc *sch;
-	unsigned int size = QDISC_ALIGN(sizeof(*sch)) + ops->priv_size;
+	unsigned int size = sizeof(*sch) + ops->priv_size;
 	int err = -ENOBUFS;
 	struct net_device *dev;
 
@@ -815,22 +814,10 @@ struct Qdisc *qdisc_alloc(struct netdev_queue *dev_queue,
 	}
 
 	dev = dev_queue->dev;
-	p = kzalloc_node(size, GFP_KERNEL,
-			 netdev_queue_numa_node_read(dev_queue));
+	sch = kzalloc_node(size, GFP_KERNEL, netdev_queue_numa_node_read(dev_queue));
 
-	if (!p)
+	if (!sch)
 		goto errout;
-	sch = (struct Qdisc *) QDISC_ALIGN((unsigned long) p);
-	/* if we got non aligned memory, ask more and do alignment ourself */
-	if (sch != p) {
-		kfree(p);
-		p = kzalloc_node(size + QDISC_ALIGNTO - 1, GFP_KERNEL,
-				 netdev_queue_numa_node_read(dev_queue));
-		if (!p)
-			goto errout;
-		sch = (struct Qdisc *) QDISC_ALIGN((unsigned long) p);
-		sch->padded = (char *) sch - (char *) p;
-	}
 	__skb_queue_head_init(&sch->gso_skb);
 	__skb_queue_head_init(&sch->skb_bad_txq);
 	qdisc_skb_head_init(&sch->q);
@@ -873,7 +860,7 @@ struct Qdisc *qdisc_alloc(struct netdev_queue *dev_queue,
 
 	return sch;
 errout1:
-	kfree(p);
+	kfree(sch);
 errout:
 	return ERR_PTR(err);
 }
@@ -941,7 +928,7 @@ void qdisc_free(struct Qdisc *qdisc)
 		free_percpu(qdisc->cpu_qstats);
 	}
 
-	kfree((char *) qdisc - qdisc->padded);
+	kfree(qdisc);
 }
 
 static void qdisc_free_cb(struct rcu_head *head)
-- 
2.28.0.806.g8561365e88-goog

