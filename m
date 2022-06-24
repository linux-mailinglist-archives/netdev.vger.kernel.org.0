Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C810E559310
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 08:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiFXGJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 02:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiFXGJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 02:09:37 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E6DBCBB
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 23:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1656050977; x=1687586977;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=rv1k6X//9OaSQPC9tpsLmjD+xK7Xgug8WDL3mTU64gI=;
  b=rx1v1ktbhA5HJUwHqotkl/HIaT15Oe4WXqBlSFiS45ardLg1E/DJQnk3
   TTRGlVFqsC3JxFghRiaLTXs6UVwwSAZ9DQgJ6Iu6OHjxqpBifOGzdktSw
   T8hqFJ9GMe5HP6o2z0lu8Jr2TBJnjdJCFeTjdEdkSgrGx4+xOeakK+EwC
   M=;
Received: from ironmsg09-lv.qualcomm.com ([10.47.202.153])
  by alexa-out.qualcomm.com with ESMTP; 23 Jun 2022 23:09:36 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg09-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 23:09:35 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Thu, 23 Jun 2022 23:09:35 -0700
Received: from subashab-lnx.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Thu, 23 Jun 2022 23:09:34 -0700
From:   Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <quic_jzenner@quicinc.com>, <cong.wang@bytedance.com>,
        <qitao.xu@bytedance.com>
CC:     Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        "Sean Tranchetti" <quic_stranche@quicinc.com>
Subject: [PATCH net-next] net: Print real skb addresses for all net events
Date:   Fri, 24 Jun 2022 00:09:16 -0600
Message-ID: <1656050956-9762-1-git-send-email-quic_subashab@quicinc.com>
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

Commit 65875073eddd ("net: use %px to print skb address in trace_netif_receive_skb")
added support for printing the real addresses for the events using
net_dev_template.

However, tracing the packet traversal shows a mix of hashes and real
addresses. Pasting a sample trace for reference-

ping-14249   [002] .....  3424.046612: netif_rx_entry: dev=lo napi_id=0x3 queue_mapping=0
skbaddr=00000000dcbed83e vlan_tagged=0 vlan_proto=0x0000 vlan_tci=0x0000 protocol=0x0800
ip_summed=0 hash=0x00000000 l4_hash=0 len=84 data_len=0 truesize=768 mac_header_valid=1
mac_header=-14 nr_frags=0 gso_size=0 gso_type=0x0
ping-14249   [002] .....  3424.046615: netif_rx: dev=lo skbaddr=ffffff888e5d1000 len=84

Switch the trace print formats to %px for all the events to have a
consistent format of printing the real addresses in all cases.

Signed-off-by: Sean Tranchetti <quic_stranche@quicinc.com>
Signed-off-by: Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
---
 include/trace/events/net.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/trace/events/net.h b/include/trace/events/net.h
index 032b431..2651350 100644
--- a/include/trace/events/net.h
+++ b/include/trace/events/net.h
@@ -58,7 +58,7 @@ TRACE_EVENT(net_dev_start_xmit,
 		__entry->gso_type = skb_shinfo(skb)->gso_type;
 	),
 
-	TP_printk("dev=%s queue_mapping=%u skbaddr=%p vlan_tagged=%d vlan_proto=0x%04x vlan_tci=0x%04x protocol=0x%04x ip_summed=%d len=%u data_len=%u network_offset=%d transport_offset_valid=%d transport_offset=%d tx_flags=%d gso_size=%d gso_segs=%d gso_type=%#x",
+	TP_printk("dev=%s queue_mapping=%u skbaddr=%px vlan_tagged=%d vlan_proto=0x%04x vlan_tci=0x%04x protocol=0x%04x ip_summed=%d len=%u data_len=%u network_offset=%d transport_offset_valid=%d transport_offset=%d tx_flags=%d gso_size=%d gso_segs=%d gso_type=%#x",
 		  __get_str(name), __entry->queue_mapping, __entry->skbaddr,
 		  __entry->vlan_tagged, __entry->vlan_proto, __entry->vlan_tci,
 		  __entry->protocol, __entry->ip_summed, __entry->len,
@@ -91,7 +91,7 @@ TRACE_EVENT(net_dev_xmit,
 		__assign_str(name, dev->name);
 	),
 
-	TP_printk("dev=%s skbaddr=%p len=%u rc=%d",
+	TP_printk("dev=%s skbaddr=%px len=%u rc=%d",
 		__get_str(name), __entry->skbaddr, __entry->len, __entry->rc)
 );
 
@@ -215,7 +215,7 @@ DECLARE_EVENT_CLASS(net_dev_rx_verbose_template,
 		__entry->gso_type = skb_shinfo(skb)->gso_type;
 	),
 
-	TP_printk("dev=%s napi_id=%#x queue_mapping=%u skbaddr=%p vlan_tagged=%d vlan_proto=0x%04x vlan_tci=0x%04x protocol=0x%04x ip_summed=%d hash=0x%08x l4_hash=%d len=%u data_len=%u truesize=%u mac_header_valid=%d mac_header=%d nr_frags=%d gso_size=%d gso_type=%#x",
+	TP_printk("dev=%s napi_id=%#x queue_mapping=%u skbaddr=%px vlan_tagged=%d vlan_proto=0x%04x vlan_tci=0x%04x protocol=0x%04x ip_summed=%d hash=0x%08x l4_hash=%d len=%u data_len=%u truesize=%u mac_header_valid=%d mac_header=%d nr_frags=%d gso_size=%d gso_type=%#x",
 		  __get_str(name), __entry->napi_id, __entry->queue_mapping,
 		  __entry->skbaddr, __entry->vlan_tagged, __entry->vlan_proto,
 		  __entry->vlan_tci, __entry->protocol, __entry->ip_summed,
-- 
2.7.4

