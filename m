Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67FBB39F8A
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 14:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbfFHMFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 08:05:40 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37845 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727259AbfFHMFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 08:05:38 -0400
Received: by mail-wm1-f67.google.com with SMTP id 22so4194987wmg.2;
        Sat, 08 Jun 2019 05:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tdx4t+pmAJ9cCw5ZkiOFYLBacE5gtlSylQvZBX7TkWc=;
        b=RfbS+VS5iAGfHVNHoPGLflPsc8gV7d5blfeprjWPbXKjAPiDZMoW6GA6EuPkkReF8R
         wGTT/lZKTMY1NiayDtsnBbpr71zx5jIjaqufZGk3vWCN7BI00Z6YpoWG3w36B513TNv3
         Ovpzo2oQyXIufJvrSwYqOKSQ0DhwlY8RR70MHPwKGmYsNT6YwMoX7q5XACUkR5VVXfx+
         d7LeEXCd+I36wMOgORhP4R3b220Y91gqQ8MF5dxF47IpkEl/63mYvR57UxgFLYVAwc8x
         JHo7gJEjGdATnumaUtAbtV76pCK9r4P0qZJygO8p9TU/nYqQqB/13TRX052huD8JKQzJ
         4DBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tdx4t+pmAJ9cCw5ZkiOFYLBacE5gtlSylQvZBX7TkWc=;
        b=oIZf1HIqljsUTCrpxy6CyCRJFft5PwJAptueOCqBpspAHtFGH6G2IDkj82wK1HSNhB
         TDhZMoBOD0fSdVRx6ywTQdOj3f3WQ9jzJMfyvbhbHx7lv8dQukk/4RECWGM0w5G3ndoj
         tzP7tzdv8gpP1VtojXZrHMl6D2/Eol7QkSjJi7iDJnCis0YOU98MmB7IlZUmhEYIgHkV
         Od40bviWmF3XfM0aGfOY5O/i2ecsWVi8O5zjlxP+Nt/KjanBlAqr7D4UafnaDwj+b+yc
         ZN55EhuIotRTmQAZr7ERRhNawGr11cA0dqRm1PXsW8v7rlfg9GQuiHCZN9HRE9NIneOD
         mwsw==
X-Gm-Message-State: APjAAAUedmOc7dnlGGaVO+QD843yfPBUmIly8m4fP9+k9IeVz1w2wAqZ
        T5x4IrEtTTyqC2I/TczXNas=
X-Google-Smtp-Source: APXvYqwpdrnWsXllf8hBpnru6FLoCAt3RxiuBfuBka/deYgsSEXGJG0sGsa4PCW3Ho1ipJJo2SkXEw==
X-Received: by 2002:a1c:c74a:: with SMTP id x71mr7045876wmf.121.1559995535454;
        Sat, 08 Jun 2019 05:05:35 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id j16sm5440030wre.94.2019.06.08.05.05.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 05:05:35 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v4 net-next 01/17] net: dsa: Keep a pointer to the skb clone for TX timestamping
Date:   Sat,  8 Jun 2019 15:04:27 +0300
Message-Id: <20190608120443.21889-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190608120443.21889-1-olteanv@gmail.com>
References: <20190608120443.21889-1-olteanv@gmail.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:

None.

Changes in v3:

None.

Changes in v2:

Patch is new. Forgot to send in v1.

 net/dsa/slave.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 5bab82d46f0c..289a6aa4b51c 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -423,6 +423,8 @@ static void dsa_skb_tx_timestamp(struct dsa_slave_priv *p,
 	if (!clone)
 		return;
 
+	DSA_SKB_CB(skb)->clone = clone;
+
 	if (ds->ops->port_txtstamp(ds, p->dp->index, clone, type))
 		return;
 
@@ -460,6 +462,7 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
 	u64_stats_update_end(&s->syncp);
 
 	DSA_SKB_CB(skb)->deferred_xmit = false;
+	DSA_SKB_CB(skb)->clone = NULL;
 
 	/* Identify PTP protocol packets, clone them, and pass them to the
 	 * switch driver
-- 
2.17.1

