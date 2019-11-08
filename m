Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4ABF3CDA
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 01:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbfKHA1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 19:27:47 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:56229 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727544AbfKHA1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 19:27:47 -0500
Received: by mail-pf1-f202.google.com with SMTP id u21so3264995pfm.22
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 16:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZB1DQPt+Ee4dP/wIoHZ3BJeJG78VF2B33/zeURUKstc=;
        b=JepHcwtjXnk9zF4ypsawGB8jWRSkF/+iBliiah0zT/U+PQ0TOL39Mi+B1XB3FlxmRc
         MCpXP6eUIo5dbocSDTxAIA4iV12z0JVlzmlI2d+0/PLyUjsEtfYNbGvnGyq7Rx87zfGI
         oy/NLKghmMzQTzH+Po0sdTHH6BdzbJ3oowrr8zbuIwTkS0VZdzlZcqIkNVkeZyHUjAKz
         OxKVVTXSfldbEyFKLHK3xEyBf+iWnjQxAwc70btQCXWm8bRDXTPeAXOch9QjwKI3BQtx
         qi8JsY7/FsiZiEIuVrazYGvwSK17cdVkkhVVF3r9I9lwbQqeXs+pfK06M8FC3mXZt0Dz
         U3vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZB1DQPt+Ee4dP/wIoHZ3BJeJG78VF2B33/zeURUKstc=;
        b=iQ9kJuFrhGveRdRnREfmEO7HhqBeEinrBeTbs1/gm47tM1JSYqwphSJ84FZhyEUaUf
         RFGEOwnc6IPGJnVdSUf3sWsnRbfMm9kMCxZ3jqgtpVq+W77LKvKHpEi0LJ9UZT3hMygn
         aB18P9D1omIlezXZHG6MowvsX2FO3TZFEbbZDtAVckz2OiUcxYIagwG6V6/Sdz1BM8yK
         FpI3yrWPlipcL9ugXfzHt5nnD32jcsSXVuSHGu2pyzub3MLVzP4PQeRDp/0K6SZNuMKY
         nWf4LhR1nBwd7NjxHn53Ohwk3X4fZYoW31S1xnYI2GQbhujbzNmUE43xZjaEyTMKV+4Q
         35Tg==
X-Gm-Message-State: APjAAAXogzrm0f/tZSHg3XGxMFn5Dl6Yojsd34thM1jM5Agiig5LgEh7
        cLrIC46P2quiMpDzmzadf0Q6tHjx+6XfqQ==
X-Google-Smtp-Source: APXvYqxeyZSVYI5BoZPJRYuEdJoMDV58F8UdIf4Rr9toJ2XtTRiXtnruQCd+oo9PBiBEbTtiC88MkjM0sT4ohg==
X-Received: by 2002:a63:cf42:: with SMTP id b2mr8351038pgj.113.1573172865146;
 Thu, 07 Nov 2019 16:27:45 -0800 (PST)
Date:   Thu,  7 Nov 2019 16:27:18 -0800
In-Reply-To: <20191108002722.129055-1-edumazet@google.com>
Message-Id: <20191108002722.129055-6-edumazet@google.com>
Mime-Version: 1.0
References: <20191108002722.129055-1-edumazet@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH net-next 5/9] vsockmon: use standard dev_lstats_add() and dev_lstats_read()
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

This cleanup will ease u64_stats_t adoption in a single location.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/vsockmon.c | 31 ++-----------------------------
 1 file changed, 2 insertions(+), 29 deletions(-)

diff --git a/drivers/net/vsockmon.c b/drivers/net/vsockmon.c
index 14e324b846171437bca40ce197c8588e20fc036b..e8563acf98e8d8fef019f89d814e28e979b8ba2c 100644
--- a/drivers/net/vsockmon.c
+++ b/drivers/net/vsockmon.c
@@ -47,13 +47,7 @@ static int vsockmon_close(struct net_device *dev)
 
 static netdev_tx_t vsockmon_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	int len = skb->len;
-	struct pcpu_lstats *stats = this_cpu_ptr(dev->lstats);
-
-	u64_stats_update_begin(&stats->syncp);
-	stats->bytes += len;
-	stats->packets++;
-	u64_stats_update_end(&stats->syncp);
+	dev_lstats_add(dev, skb->len);
 
 	dev_kfree_skb(skb);
 
@@ -63,30 +57,9 @@ static netdev_tx_t vsockmon_xmit(struct sk_buff *skb, struct net_device *dev)
 static void
 vsockmon_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 {
-	int i;
-	u64 bytes = 0, packets = 0;
-
-	for_each_possible_cpu(i) {
-		const struct pcpu_lstats *vstats;
-		u64 tbytes, tpackets;
-		unsigned int start;
-
-		vstats = per_cpu_ptr(dev->lstats, i);
+	dev_lstats_read(dev, &stats->rx_packets, &stats->rx_bytes);
 
-		do {
-			start = u64_stats_fetch_begin_irq(&vstats->syncp);
-			tbytes = vstats->bytes;
-			tpackets = vstats->packets;
-		} while (u64_stats_fetch_retry_irq(&vstats->syncp, start));
-
-		packets += tpackets;
-		bytes += tbytes;
-	}
-
-	stats->rx_packets = packets;
 	stats->tx_packets = 0;
-
-	stats->rx_bytes = bytes;
 	stats->tx_bytes = 0;
 }
 
-- 
2.24.0.432.g9d3f5f5b63-goog

