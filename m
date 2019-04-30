Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8EEFFF1
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 20:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbfD3Sub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 14:50:31 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40576 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbfD3Sub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 14:50:31 -0400
Received: by mail-pf1-f193.google.com with SMTP id u17so3541330pfn.7
        for <netdev@vger.kernel.org>; Tue, 30 Apr 2019 11:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Dk+SRFmdShElIDRsyWWMw21s4/WV+XtoSmZqJ4gaY0I=;
        b=Ut7eBbJRpgQIZZuEZMeT3rmZmJCs/mi1wzhhrEMBB6y4dLC/J2k8CoABfcKs39388d
         Xl27FL/ObRYgi52jKBrEu7Mgg22QWMiqasQ3v3PBniEX9yrNswRZQ8Y06Ws2d3arq5fY
         81MW1lwi6iB8Cu9hgLLx0w3YY8Ky9522y1i0mzljyW50tnMps+AmWjGWwRw/OVvAu6OB
         JArwel/hxAS5CJB9MLOpIHQkEMdLztKbj789HfEFr84+lt6qsZTDkOFAkWFkHR5hZv8U
         6cWWQuwB5xxxx2OP1Ber7SMevYQW22Vo5cTJ7LrrphtLA9crW1amusAz3jA38uu4s9ET
         WrCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Dk+SRFmdShElIDRsyWWMw21s4/WV+XtoSmZqJ4gaY0I=;
        b=qaLELu41HVsWBQTnCa4m0ZBiERC4pIdzf2fhjRS1mbgF09oVII+/je3iAlK6b84OiI
         9+jMElyBMuPMBGuk9EFcYfasxxlq+r3bBoyeqpBKQVqZaacQF/BL/L0uvEG7O4eDTWG0
         XjxbbcQGPgVyRuNxiHgrgzaos8KdfeQfNBE3opAY3LmUkODs2fV9N1yjCVhc0ZYgN0ww
         FIwUT8rkX+EFrTsqVaTiP5TfXBCLVTFTXQIUtmbbX1JbsZK6IS5aS7IH6G71B5ugofuf
         CAVVqJtUrLF+yiEVDvrQXd3EsXfoZ5DTZv39v95l2pmLkRwUi3s0dKeWFfjS9JOpyvU4
         e/uA==
X-Gm-Message-State: APjAAAWIXHOQygWkzPTBwwe+ow/pBqtczFp6dAkiFGD25nLlrWrmPTdW
        6X2I0vRQlFFZR6kEDcy4bMev42m2
X-Google-Smtp-Source: APXvYqyxtbILNQnmVq3obQMSRLKqSLvi74DTPlfgAjLQtQxu2/9LgVx5z2f7UL2AGtzPdY+r6XgwJQ==
X-Received: by 2002:a62:e411:: with SMTP id r17mr27595661pfh.127.1556650230614;
        Tue, 30 Apr 2019 11:50:30 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id o2sm54013222pgq.1.2019.04.30.11.50.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 30 Apr 2019 11:50:29 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [Patch net-next] net: add a generic tracepoint for TX queue timeout
Date:   Tue, 30 Apr 2019 11:50:09 -0700
Message-Id: <20190430185009.20456-1-xiyou.wangcong@gmail.com>
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
index 1efd7d9b25fe..002d6f04b9e5 100644
--- a/include/trace/events/net.h
+++ b/include/trace/events/net.h
@@ -303,6 +303,29 @@ DEFINE_EVENT(net_dev_rx_exit_template, netif_receive_skb_list_exit,
 	TP_ARGS(ret)
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
 #endif /* _TRACE_NET_H */
 
 /* This part must be outside protection */
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

