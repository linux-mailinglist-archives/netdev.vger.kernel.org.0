Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4692527B38
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 12:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730328AbfEWK6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 06:58:39 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:35441 "EHLO
        tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbfEWK6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 06:58:39 -0400
Received: from vc2.ecl.ntt.co.jp (vc2.ecl.ntt.co.jp [129.60.86.154])
        by tama500.ecl.ntt.co.jp (8.13.8/8.13.8) with ESMTP id x4NAwHWn029945;
        Thu, 23 May 2019 19:58:17 +0900
Received: from vc2.ecl.ntt.co.jp (localhost [127.0.0.1])
        by vc2.ecl.ntt.co.jp (Postfix) with ESMTP id 5B4B9639047;
        Thu, 23 May 2019 19:58:17 +0900 (JST)
Received: from jcms-pop21.ecl.ntt.co.jp (jcms-pop21.ecl.ntt.co.jp [129.60.87.134])
        by vc2.ecl.ntt.co.jp (Postfix) with ESMTP id 50022638C92;
        Thu, 23 May 2019 19:58:17 +0900 (JST)
Received: from makita-ubuntu.m.ecl.ntt.co.jp (eb8460w-makita.sic.ecl.ntt.co.jp [129.60.241.47])
        by jcms-pop21.ecl.ntt.co.jp (Postfix) with ESMTPSA id 45B314007AA;
        Thu, 23 May 2019 19:58:17 +0900 (JST)
From:   Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
Subject: [PATCH bpf-next 2/3] xdp: Add tracepoint for bulk XDP_TX
Date:   Thu, 23 May 2019 19:56:47 +0900
Message-Id: <1558609008-2590-3-git-send-email-makita.toshiaki@lab.ntt.co.jp>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558609008-2590-1-git-send-email-makita.toshiaki@lab.ntt.co.jp>
References: <1558609008-2590-1-git-send-email-makita.toshiaki@lab.ntt.co.jp>
X-CC-Mail-RelayStamp: 1
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org
X-TM-AS-MML: disable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is introduced for admins to check what is happening on XDP_TX when
bulk XDP_TX is in use.

Signed-off-by: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
---
 include/trace/events/xdp.h | 25 +++++++++++++++++++++++++
 kernel/bpf/core.c          |  1 +
 2 files changed, 26 insertions(+)

diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
index e95cb86..e06ea65 100644
--- a/include/trace/events/xdp.h
+++ b/include/trace/events/xdp.h
@@ -50,6 +50,31 @@
 		  __entry->ifindex)
 );
 
+TRACE_EVENT(xdp_bulk_tx,
+
+	TP_PROTO(const struct net_device *dev,
+		 int sent, int drops, int err),
+
+	TP_ARGS(dev, sent, drops, err),
+
+	TP_STRUCT__entry(
+		__field(int, ifindex)
+		__field(int, drops)
+		__field(int, sent)
+		__field(int, err)
+	),
+
+	TP_fast_assign(
+		__entry->ifindex	= dev->ifindex;
+		__entry->drops		= drops;
+		__entry->sent		= sent;
+		__entry->err		= err;
+	),
+
+	TP_printk("ifindex=%d sent=%d drops=%d err=%d",
+		  __entry->ifindex, __entry->sent, __entry->drops, __entry->err)
+);
+
 DECLARE_EVENT_CLASS(xdp_redirect_template,
 
 	TP_PROTO(const struct net_device *dev,
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 242a643..7687488 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2108,3 +2108,4 @@ int __weak skb_copy_bits(const struct sk_buff *skb, int offset, void *to,
 #include <linux/bpf_trace.h>
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(xdp_exception);
+EXPORT_TRACEPOINT_SYMBOL_GPL(xdp_bulk_tx);
-- 
1.8.3.1


