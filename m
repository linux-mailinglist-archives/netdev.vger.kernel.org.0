Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 235F9324F9
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 23:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbfFBVkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 17:40:03 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41709 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbfFBVkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 17:40:03 -0400
Received: by mail-wr1-f66.google.com with SMTP id c2so9998054wrm.8;
        Sun, 02 Jun 2019 14:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/vrUJNDgeyPo+xhFDSJA5uqE6jYDoawRIu6XRowdO9E=;
        b=NRW5iwMoU3FO6lj7ZrrRuQ1//Vq6QcU+0rdtIldLkFDc2gkaNeaEuk6DOVUEsCqnMf
         PK+GmIuHS0epX4PYShyQpisKpn+/AyXg90kYu43dYtXfoUZs2U0YgyESAPu4UcFigwyE
         doGR6U2ncgHoLQNpa5xkTU+1SR2Yg4nGuw95100OqvrQavZLYqHJVjN0YdYAivaSxJXC
         DwcQauasLOaarABQGZx3PdVuVzPGl11Z9j5jafQ1keb9DIKNjLq8N/yk1r3/50If6SG6
         cexRAnR66FoPot8oM5Zvm9MSmVfbr9dOtBc3EeBxQbZOO8XAcbsVI5CIL3WsLMzvLjTu
         HwAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/vrUJNDgeyPo+xhFDSJA5uqE6jYDoawRIu6XRowdO9E=;
        b=QZr6eahp+wX5eenXapNih3e5IqFFwgCODkkUffdi7elxTQgaav4yDbP+H44D8IdISs
         7kVxFQgLO8+uc6aYvrNK58iEBpK8rnqWLaN76coWCCrVWSrRHFb3NWRqYLO91QDcusM8
         xGRMuW7onpkgpsCUhuTfXJWWpNswd4AOBohfIukZAb9z43Ga/sq0MzQPV1aU8iekkgsA
         aG6hsXw6FAgei1Sk7hC9Qx3v+bMWgdtrXk2vHDhgT9j6use3KVfUIxyLg4dWHSpawfKw
         oASSkGfiKImupUkTHm17vBco084oEft7GC/yO8/Atidvctt6EgZ4QXiYP/nbhoaq3IUp
         hXXQ==
X-Gm-Message-State: APjAAAUMbAxkHXnaqdKDlTZoNxsm2hp6/K6+UFu3LKpCsGCfA13RoPlo
        01/NLtryB8CTUgkgOnfXM2g=
X-Google-Smtp-Source: APXvYqw9hLfNmJhXU+tDNUVzSBsWFo4FhxoJbZY/izQ965T6paNwZgRJ2rzxpTuK89R5ZbKZ4hQAVg==
X-Received: by 2002:adf:f00d:: with SMTP id j13mr14202622wro.178.1559511601657;
        Sun, 02 Jun 2019 14:40:01 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id 65sm26486793wro.85.2019.06.02.14.40.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 14:40:01 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 01/10] net: dsa: Keep a pointer to the skb clone for TX timestamping
Date:   Mon,  3 Jun 2019 00:39:17 +0300
Message-Id: <20190602213926.2290-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190602213926.2290-1-olteanv@gmail.com>
References: <20190602213926.2290-1-olteanv@gmail.com>
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

