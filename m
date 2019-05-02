Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFC9111C0
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 04:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfEBC5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 22:57:12 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36735 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbfEBC5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 22:57:11 -0400
Received: by mail-pl1-f193.google.com with SMTP id w20so337515plq.3
        for <netdev@vger.kernel.org>; Wed, 01 May 2019 19:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8Nrjvyj6qd708xqXhnjCr3uxGyr+0a6mHeXatNFr/L0=;
        b=slqcucVXH9x3l05ANzPUBW1/XtrwzKbAXTrrpEnUwi+cnoe6/hlcL8UzypGfFRdTAv
         RucbXHRdPmCnR/hUinwc4Hzwcq2AQumPgqUdWFOSB2mPG4xWOYm4ZsVytlfj9iJV55d3
         2vKjpeXhjkncnW6hfybPUDDZHckf6i/XLFNdC3ENJHDL1HB1oYGnEzyMdkQ3bY2iT9AL
         AtOc0sOoZCHw1RBNTijUJeBp3vardoW/ZrV3wv93b7EfkV2U6T2WdO7VEQVYuemBB6Y+
         2zo/DotBga0CNTiuiVCs8cHVvBZ+sTO/nobiaHGVnQtud3mccBilS+R63LoXrfXX4pky
         bhdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8Nrjvyj6qd708xqXhnjCr3uxGyr+0a6mHeXatNFr/L0=;
        b=PSfsqX24s9PQ7WOE9jGCbqqmXOwAniO8OanUiNF9u28JloFfYTpJFC5ot5nJWikclb
         lbfdAHWZBVJBT9dkH/LuSIRq4g8FVH6kx97UAWxkOvS/J4sPHwoNaD/H8/7MGYKSL3yb
         istRs+Um4G+FRRWi2KRXPjvsDEA/kkLBQycGvXu7x+89DFHsTzZXw/7hPPONyHOvhLXr
         uK618a836O9Vr2tqDQb4FZTKeyewE21cIVR/GBbkwiWHHdjO1/ojxgZahdCdbtE8SaZZ
         YHWvwgninrKbox9gq+9lNRns8lWFd7nTgOGGp9WSelM3e5kkfMlk8ummyfPFyPSoIcPZ
         QWMw==
X-Gm-Message-State: APjAAAVZ2dITRR/GgPx5eVC4YyI7j+kdHES96+HMURtu2DEW7Njvc3OW
        InE8K4arCKz9OKU5oG/e1y6xlSBr
X-Google-Smtp-Source: APXvYqxJqKX3VjRm4d2+sud1MR1dy3Y7gemk4uuFwXAGiT1BCeUTJNraREOYGrC9BH5PkXAKXcK7jQ==
X-Received: by 2002:a17:902:8306:: with SMTP id bd6mr1080118plb.134.1556765831030;
        Wed, 01 May 2019 19:57:11 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id 144sm8419112pfy.49.2019.05.01.19.57.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 01 May 2019 19:57:09 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [Patch net-next v2] net: add a generic tracepoint for TX queue timeout
Date:   Wed,  1 May 2019 19:56:59 -0700
Message-Id: <20190502025659.30351-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although devlink health report does a nice job on reporting TX
timeout and other NIC errors, unfortunately it requires drivers
to support it but currently only mlx5 has implemented it.
Before other drivers could catch up, it is useful to have a
generic tracepoint to monitor this kind of TX timeout. We have
been suffering TX timeout with different drivers, we plan to
start to monitor it with rasdaemon which just needs a new tracepoint.

Sample output:

  ksoftirqd/1-16    [001] ..s2   144.043173: net_dev_xmit_timeout: dev=ens3 driver=e1000 queue=0

Cc: Eran Ben Elisha <eranbe@mellanox.com>
Cc: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 include/trace/events/net.h | 23 +++++++++++++++++++++++
 net/sched/sch_generic.c    |  2 ++
 2 files changed, 25 insertions(+)

diff --git a/include/trace/events/net.h b/include/trace/events/net.h
index 1efd7d9b25fe..2399073c3afc 100644
--- a/include/trace/events/net.h
+++ b/include/trace/events/net.h
@@ -95,6 +95,29 @@ TRACE_EVENT(net_dev_xmit,
 		__get_str(name), __entry->skbaddr, __entry->len, __entry->rc)
 );
 
+TRACE_EVENT(net_dev_xmit_timeout,
+
+	TP_PROTO(struct net_device *dev,
+		 int queue_index),
+
+	TP_ARGS(dev, queue_index),
+
+	TP_STRUCT__entry(
+		__string(	name,		dev->name	)
+		__string(	driver,		netdev_drivername(dev))
+		__field(	int,		queue_index	)
+	),
+
+	TP_fast_assign(
+		__assign_str(name, dev->name);
+		__assign_str(driver, netdev_drivername(dev));
+		__entry->queue_index = queue_index;
+	),
+
+	TP_printk("dev=%s driver=%s queue=%d",
+		__get_str(name), __get_str(driver), __entry->queue_index)
+);
+
 DECLARE_EVENT_CLASS(net_dev_template,
 
 	TP_PROTO(struct sk_buff *skb),
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 848aab3693bd..cce1e9ee85af 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -32,6 +32,7 @@
 #include <net/pkt_sched.h>
 #include <net/dst.h>
 #include <trace/events/qdisc.h>
+#include <trace/events/net.h>
 #include <net/xfrm.h>
 
 /* Qdisc to use by default */
@@ -441,6 +442,7 @@ static void dev_watchdog(struct timer_list *t)
 			}
 
 			if (some_queue_timedout) {
+				trace_net_dev_xmit_timeout(dev, i);
 				WARN_ONCE(1, KERN_INFO "NETDEV WATCHDOG: %s (%s): transmit queue %u timed out\n",
 				       dev->name, netdev_drivername(dev), i);
 				dev->netdev_ops->ndo_tx_timeout(dev);
-- 
2.20.1

