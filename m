Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09944F9037
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 14:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfKLNIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 08:08:09 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:59582 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725985AbfKLNIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 08:08:09 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R601e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0ThuOeKd_1573564085;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0ThuOeKd_1573564085)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 12 Nov 2019 21:08:06 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     xiyou.wangcong@gmail.com, eric.dumazet@gmail.com,
        shemminger@osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] net: add trace events for net_device refcnt
Date:   Tue, 12 Nov 2019 21:05:13 +0800
Message-Id: <20191112130510.91570-2-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191112130510.91570-1-tonylu@linux.alibaba.com>
References: <20191112130510.91570-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The net_device refcnt leak is hard to trace and debug for now. We need
the ability to know when and who manipulated the refcnt.

Adding the trace events for net_device pcpu_refcnt and also tracepoints
in dev_put()/dev_hold(), provides the history of net_device refcnt inc
and desc. With trace logs analysis, paring the put and hold history, we
can find out who leaked.

Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
 include/trace/events/net.h | 41 ++++++++++++++++++++++++++++++++++++++
 net/core/dev.c             |  4 ++++
 2 files changed, 45 insertions(+)

diff --git a/include/trace/events/net.h b/include/trace/events/net.h
index 3b28843652d2..3bf6dd738882 100644
--- a/include/trace/events/net.h
+++ b/include/trace/events/net.h
@@ -326,6 +326,47 @@ DEFINE_EVENT(net_dev_rx_exit_template, netif_receive_skb_list_exit,
 	TP_ARGS(ret)
 );
 
+DECLARE_EVENT_CLASS(net_dev_refcnt_template,
+
+	TP_PROTO(struct net_device *dev, void *location),
+
+	TP_ARGS(dev, location),
+
+	TP_STRUCT__entry(
+		__string(	name,		dev->name	)
+		__field(	int,		refcnt		)
+		__field(	void *,		location	)
+	),
+
+	TP_fast_assign(
+		int i, refcnt = 0;
+
+		for_each_possible_cpu(i)
+			refcnt += *per_cpu_ptr(dev->pcpu_refcnt, i);
+
+		__assign_str(name, dev->name);
+		__entry->refcnt = refcnt;
+		__entry->location = location;
+	),
+
+	TP_printk("dev=%s refcnt=%d location=%p",
+		__get_str(name), __entry->refcnt, __entry->location)
+);
+
+DEFINE_EVENT(net_dev_refcnt_template, net_dev_put,
+
+	TP_PROTO(struct net_device *dev, void *location),
+
+	TP_ARGS(dev, location)
+);
+
+DEFINE_EVENT(net_dev_refcnt_template, net_dev_hold,
+
+	TP_PROTO(struct net_device *dev, void *location),
+
+	TP_ARGS(dev, location)
+);
+
 #endif /* _TRACE_NET_H */
 
 /* This part must be outside protection */
diff --git a/net/core/dev.c b/net/core/dev.c
index 620fb3d6718a..163870a09984 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1302,6 +1302,8 @@ EXPORT_SYMBOL(netdev_notify_peers);
  */
 void dev_put(struct net_device *dev)
 {
+	trace_net_dev_put(dev, __builtin_return_address(0));
+
 	this_cpu_dec(*dev->pcpu_refcnt);
 }
 EXPORT_SYMBOL(dev_put);
@@ -1314,6 +1316,8 @@ EXPORT_SYMBOL(dev_put);
  */
 void dev_hold(struct net_device *dev)
 {
+	trace_net_dev_hold(dev, __builtin_return_address(0));
+
 	this_cpu_inc(*dev->pcpu_refcnt);
 }
 EXPORT_SYMBOL(dev_hold);
-- 
2.24.0

