Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24AF534E72
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbfFDRIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:08:06 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37153 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727757AbfFDRIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:08:06 -0400
Received: by mail-wr1-f68.google.com with SMTP id h1so16648344wro.4;
        Tue, 04 Jun 2019 10:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=U5siZUAA5ZHmsavSrnq/Yb6jigFUfw9klIPK+hJh9mI=;
        b=JrcoW3EcXnKWIWVaL3Vq2WgZ6zJiNmJU5WkMSP8ycQo+lr4qpW5tZDW3UUISVI3t0L
         kDKZEPaxkqYxU2c93MaFzi+CP4+IQwEOXH6QqJ7hlvz0P8xSQhW3r6zK6gYhhBsOoaJe
         lR6gUFMtmdgJjGwbvt4x0FDh+7O86VjLKBba52VsoHz3DrGChuNmL180BJq8Z/2EkrhG
         Qxlhk30uKQNuW1YcNRnJ7MqN48WOpDyYPeUvHWKPhE+9am26WLZbUaX8b/Kd6Tfxvky2
         3C541Z2FB1eRC47Phu5w1sfUO2idS7OqQa754tZs+UcSoTAf7ItuER8eIMYijVbd1Fq/
         Qj4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=U5siZUAA5ZHmsavSrnq/Yb6jigFUfw9klIPK+hJh9mI=;
        b=Wyrfw75o9vp7RxJhlEEaXWjEwAU4Hnin8ThCEmqfWg/14N59Ph4qdYCmKxpzuhcrXm
         aorO+LJmddsmiuVTzc4uwbD+4L9ahxpgyB5rOjccckURdRJMs0o6LJPWJwwEGRGzJZk/
         E8556h0pPlf4oRVUI5BQIsvv1JxJJS0sBMdkDimj/FFS4exqkZYaVAufIY8Rozqfchn1
         NPpjfFnYkIUJAL92LG4c6hTKpXKQ1W18bclYsO/b6tTMAG5Sd6DI0vHnKCdIMM8ym7AH
         hgECRCNvhL/R1kxCzl2wA73Vc9sj0l4Kkafgb8KzxwpBG46bTY0vYocSMp7EnaIbCQcb
         qjjA==
X-Gm-Message-State: APjAAAVEgm5Op1nbXf9BrvTsscwprvrnpyn+6KHrWNjO2/gaE37G7VWC
        90dxDx+1hygk6NQEygd1FUE=
X-Google-Smtp-Source: APXvYqwSz7KH8VAUyIQE7ycOa/iSHPnLUZQHkTO9OA09PoXiLao30HB8bGfL/ok3GQY+BbXtabHrMg==
X-Received: by 2002:a5d:6207:: with SMTP id y7mr3455983wru.265.1559668084339;
        Tue, 04 Jun 2019 10:08:04 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id f2sm19692218wme.12.2019.06.04.10.08.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 10:08:03 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 01/17] net: dsa: Keep a pointer to the skb clone for TX timestamping
Date:   Tue,  4 Jun 2019 20:07:40 +0300
Message-Id: <20190604170756.14338-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190604170756.14338-1-olteanv@gmail.com>
References: <20190604170756.14338-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For drivers that use deferred_xmit for PTP frames (such as sja1105),
there is no need to perform matching between PTP frames and their egress
timestamps, since the sending process can be serialized.

In that case, it makes sense to have the pointer to the skb clone that
DSA made directly in the skb->cb. It will be used for pushing the egress
timestamp back in the application socket's error queue.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v3:

None.

Changes in v2:

Patch is new. Forgot to send in v1.

 net/dsa/slave.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 1e2ae9d59b88..59d7c9e0270f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -427,6 +427,8 @@ static void dsa_skb_tx_timestamp(struct dsa_slave_priv *p,
 	if (!clone)
 		return;
 
+	DSA_SKB_CB(skb)->clone = clone;
+
 	if (ds->ops->port_txtstamp(ds, p->dp->index, clone, type))
 		return;
 
@@ -464,6 +466,7 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
 	u64_stats_update_end(&s->syncp);
 
 	DSA_SKB_CB(skb)->deferred_xmit = false;
+	DSA_SKB_CB(skb)->clone = NULL;
 
 	/* Identify PTP protocol packets, clone them, and pass them to the
 	 * switch driver
-- 
2.17.1

