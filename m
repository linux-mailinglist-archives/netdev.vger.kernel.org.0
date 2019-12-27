Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB1A12B058
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 02:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbfL0BmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 20:42:21 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50504 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbfL0BmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 20:42:20 -0500
Received: by mail-wm1-f68.google.com with SMTP id a5so7038532wmb.0;
        Thu, 26 Dec 2019 17:42:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jOrvQNI+LQ4nQP6ABrg57U7Wq2Xttks3TXMfcHTK/GE=;
        b=F4c6pMYXNDzA1s/dwsTHXlnzSZpcdo07x/PwPjAhX8ZrPu4O9RrLCxUnwx1dnVB5Q8
         rqdfN8/mAnolPuIx1Fk2cykuFE6l/HXqYcYtgSMSvwwScb6lFHeh9L6YesdAxxhCXuDo
         i2Wcmypv6u+lWXyEeCgo7U3kXBF0nQCXL+mtQJwhHAb9SNPb2Uq0z01ho10VqIMpqIFl
         DhR///zWiwoScMcjf8IJ49la211Ebe7stGtZ1OOAL6dlIexwB3sYn10871/kPQ7T73Q2
         lzdGtqbopavPzzRuc2Y0ngO8KUPQXPgb7jK5REzjqWHlbN8XnxSj/fn7W7M0jxXRBKI/
         u2SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jOrvQNI+LQ4nQP6ABrg57U7Wq2Xttks3TXMfcHTK/GE=;
        b=mH5DbWZ0XJeEOmzdEe9OwroiKpxI7nnXk7O6Wot7rJbIm9pr+ECHglbbHy4PlV06Lj
         C0ajzH1WldqQsHNID6fGpj1EffSsD7uf64K6qozFCETKA1ocN67rfFK66o/9sM5TXVx9
         po7K8cuG4+bbXx+IUM7TEXTXs90b1GR222tJdG/9PqJwcaIiZo/mDRd7OGFGr53tM16P
         B3NCh2azGAEPchAPou+ZYzu359D3gd4koq3NCNMnUyethxpp50USPJnpqzuI7Kv/ErRk
         gd71jpyO67pzHOd/1i2vfILJP++3AFHObHz720AafPaM/ohNCcSYdNTzQv8buB/rrAIk
         wQPg==
X-Gm-Message-State: APjAAAUqt2EredczWQDc7RRBgGi0eiXAwW/2FuSLM/ELGRvbV/z3Qblj
        TuVKvbM64SuXxLvcfd1jWJo=
X-Google-Smtp-Source: APXvYqyq2Fa+h9Dmoua7/5yJGo/bgiv2N1pLxPfvoMOxOg9YjQlT2pSAeL+m5qOYQvdePQVbEHQX7g==
X-Received: by 2002:a05:600c:a:: with SMTP id g10mr17045672wmc.14.1577410938124;
        Thu, 26 Dec 2019 17:42:18 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id q11sm32622130wrp.24.2019.12.26.17.42.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 17:42:17 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 1/2] net: dsa: Remove deferred_xmit from dsa_skb_cb
Date:   Fri, 27 Dec 2019 03:42:07 +0200
Message-Id: <20191227014208.7189-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191227014208.7189-1-olteanv@gmail.com>
References: <20191227014208.7189-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The introduction of the deferred xmit mechanism in DSA has made the
hotpath slightly more inefficient for everybody, since
DSA_SKB_CB(skb)->deferred_xmit needed to be initialized to false for
every transmitted frame, in order to figure out whether the driver
requested deferral or not. That was necessary to avoid kfree_skb from
freeing the skb.

But actually we can just remove that variable in the skb->cb and
counteract the effect of kfree_skb with skb_get, much to the same
effect. The advantage, of course, being that anybody who doesn't use
deferred xmit doesn't need to do any extra operation in the hotpath.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 include/net/dsa.h |  1 -
 net/dsa/slave.c   | 12 ++++++------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 6767dc3f66c0..5d510a4da5d0 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -88,7 +88,6 @@ struct dsa_device_ops {
 
 struct dsa_skb_cb {
 	struct sk_buff *clone;
-	bool deferred_xmit;
 };
 
 struct __dsa_skb_cb {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 78ffc87dc25e..9f7e47dcdc20 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -518,7 +518,6 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
 	s->tx_bytes += skb->len;
 	u64_stats_update_end(&s->syncp);
 
-	DSA_SKB_CB(skb)->deferred_xmit = false;
 	DSA_SKB_CB(skb)->clone = NULL;
 
 	/* Identify PTP protocol packets, clone them, and pass them to the
@@ -531,8 +530,7 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
 	 */
 	nskb = p->xmit(skb, dev);
 	if (!nskb) {
-		if (!DSA_SKB_CB(skb)->deferred_xmit)
-			kfree_skb(skb);
+		kfree_skb(skb);
 		return NETDEV_TX_OK;
 	}
 
@@ -543,10 +541,12 @@ void *dsa_defer_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 
-	DSA_SKB_CB(skb)->deferred_xmit = true;
-
-	skb_queue_tail(&dp->xmit_queue, skb);
+	/* Increase refcount so the kfree_skb in dsa_slave_xmit
+	 * won't really free the packet.
+	 */
+	skb_queue_tail(&dp->xmit_queue, skb_get(skb));
 	schedule_work(&dp->xmit_work);
+
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(dsa_defer_xmit);
-- 
2.17.1

