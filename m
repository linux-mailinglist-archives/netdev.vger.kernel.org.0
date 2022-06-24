Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5622D55A3A2
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 23:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbiFXVe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 17:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbiFXVe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 17:34:57 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00AD287B47
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 14:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1656106490; x=1687642490;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=St1JhCgS3DBz3obnidFPdLvT2bzefQ4nHlZZKUa4KCY=;
  b=zjglHBqNk85zCIiP4OGpciV1hX7WVnBt+Su/Oi08ypc40agRqIUOaWm2
   xIMxW1ub+/Qy1DDN8/lpRR0QYD1x/94FYWU8KpBCLb3VTGgIB5NIGdSZu
   3utou/dU8F2DJwyrP0SLLClfI+xcnyJDFoZWub8wpK8Q7rp6TPfk1hwR+
   4=;
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 24 Jun 2022 14:34:50 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg05-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 14:34:50 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 24 Jun 2022 14:34:49 -0700
Received: from subashab-lnx.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 24 Jun 2022 14:34:48 -0700
From:   Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <quic_jzenner@quicinc.com>, <cong.wang@bytedance.com>,
        <qitao.xu@bytedance.com>, <bigeasy@linutronix.de>,
        <rostedt@goodmis.org>, <mingo@redhat.com>
CC:     Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        "Sean Tranchetti" <quic_stranche@quicinc.com>
Subject: [PATCH net-next v2] net: Print hashed skb addresses for all net and qdisc events
Date:   Fri, 24 Jun 2022 15:34:25 -0600
Message-ID: <1656106465-26544-1-git-send-email-quic_subashab@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following commits added support for printing the real address-
65875073eddd ("net: use %px to print skb address in trace_netif_receive_skb")
70713dddf3d2 ("net_sched: introduce tracepoint trace_qdisc_enqueue()")
851f36e40962 ("net_sched: use %px to print skb address in trace_qdisc_dequeue()")

However, tracing the packet traversal shows a mix of hashes and real
addresses. Pasting a sample trace for reference-

ping-14249   [002] .....  3424.046612: netif_rx_entry: dev=lo napi_id=0x3 queue_mapping=0
skbaddr=00000000dcbed83e vlan_tagged=0 vlan_proto=0x0000 vlan_tci=0x0000 protocol=0x0800
ip_summed=0 hash=0x00000000 l4_hash=0 len=84 data_len=0 truesize=768 mac_header_valid=1
mac_header=-14 nr_frags=0 gso_size=0 gso_type=0x0
ping-14249   [002] .....  3424.046615: netif_rx: dev=lo skbaddr=ffffff888e5d1000 len=84

Switch the trace print formats to %p for all the events to have a
consistent format of printing the hashed addresses in all cases.

Signed-off-by: Sean Tranchetti <quic_stranche@quicinc.com>
Signed-off-by: Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
---
v1->v2: Switch to printing hashed addresses in all cases as mentioned by Eric.

 include/trace/events/net.h   | 2 +-
 include/trace/events/qdisc.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/trace/events/net.h b/include/trace/events/net.h
index 032b431..da611a7 100644
--- a/include/trace/events/net.h
+++ b/include/trace/events/net.h
@@ -136,7 +136,7 @@ DECLARE_EVENT_CLASS(net_dev_template,
 		__assign_str(name, skb->dev->name);
 	),
 
-	TP_printk("dev=%s skbaddr=%px len=%u",
+	TP_printk("dev=%s skbaddr=%p len=%u",
 		__get_str(name), __entry->skbaddr, __entry->len)
 )
 
diff --git a/include/trace/events/qdisc.h b/include/trace/events/qdisc.h
index 59c945b..a399592 100644
--- a/include/trace/events/qdisc.h
+++ b/include/trace/events/qdisc.h
@@ -41,7 +41,7 @@ TRACE_EVENT(qdisc_dequeue,
 		__entry->txq_state	= txq->state;
 	),
 
-	TP_printk("dequeue ifindex=%d qdisc handle=0x%X parent=0x%X txq_state=0x%lX packets=%d skbaddr=%px",
+	TP_printk("dequeue ifindex=%d qdisc handle=0x%X parent=0x%X txq_state=0x%lX packets=%d skbaddr=%p",
 		  __entry->ifindex, __entry->handle, __entry->parent,
 		  __entry->txq_state, __entry->packets, __entry->skbaddr )
 );
@@ -70,7 +70,7 @@ TRACE_EVENT(qdisc_enqueue,
 		__entry->parent	 = qdisc->parent;
 	),
 
-	TP_printk("enqueue ifindex=%d qdisc handle=0x%X parent=0x%X skbaddr=%px",
+	TP_printk("enqueue ifindex=%d qdisc handle=0x%X parent=0x%X skbaddr=%p",
 		  __entry->ifindex, __entry->handle, __entry->parent, __entry->skbaddr)
 );
 
-- 
2.7.4

