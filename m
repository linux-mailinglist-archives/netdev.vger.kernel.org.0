Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B483B18C7
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 13:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhFWL0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 07:26:39 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:57171 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbhFWL0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 07:26:38 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 15NBO6rnC023398, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 15NBO6rnC023398
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 23 Jun 2021 19:24:06 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 23 Jun 2021 19:24:06 +0800
Received: from localhost.localdomain (172.21.177.191) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 23 Jun 2021 19:24:05 +0800
From:   Edward Wu <edwardwu@realtek.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, Edward Wu <edwardwu@realtek.com>
Subject: [PATCH net-next resend] net: Exposing more skb fields in netif_receive_skb trace event
Date:   Wed, 23 Jun 2021 19:23:39 +0800
Message-ID: <20210623112339.29453-1-edwardwu@realtek.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210609093656.8984-1-edwardwu@realtek.com>
References: <20210609093656.8984-1-edwardwu@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.177.191]
X-ClientProxiedBy: RTEXMBS02.realtek.com.tw (172.21.6.95) To
 RTEXDAG01.realtek.com.tw (172.21.6.100)
X-KSE-ServerInfo: RTEXDAG01.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: trusted connection
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/23/2021 11:03:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzYvMjMgpFekyCAwODowNjowMA==?=
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-ServerInfo: RTEXH36502.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 06/23/2021 11:01:21
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164570 [Jun 23 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: edwardwu@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;realtek.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/23/2021 11:03:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This exposing helps to analyze network behavior.

In performance tuning, we will check nr_frags to analyze
GRO aggregation behavior. By this commit, we can
enable netif_receive_skb trace event for dynamic debugging.

Signed-off-by: Edward Wu <edwardwu@realtek.com>
---
 include/trace/events/net.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/trace/events/net.h b/include/trace/events/net.h
index 2399073c3afc..48aa7168b68f 100644
--- a/include/trace/events/net.h
+++ b/include/trace/events/net.h
@@ -147,13 +147,6 @@ DEFINE_EVENT(net_dev_template, net_dev_queue,
 	TP_ARGS(skb)
 );
 
-DEFINE_EVENT(net_dev_template, netif_receive_skb,
-
-	TP_PROTO(struct sk_buff *skb),
-
-	TP_ARGS(skb)
-);
-
 DEFINE_EVENT(net_dev_template, netif_rx,
 
 	TP_PROTO(struct sk_buff *skb),
@@ -239,6 +232,13 @@ DEFINE_EVENT(net_dev_rx_verbose_template, napi_gro_receive_entry,
 	TP_ARGS(skb)
 );
 
+DEFINE_EVENT(net_dev_rx_verbose_template, netif_receive_skb,
+
+	TP_PROTO(const struct sk_buff *skb),
+
+	TP_ARGS(skb)
+);
+
 DEFINE_EVENT(net_dev_rx_verbose_template, netif_receive_skb_entry,
 
 	TP_PROTO(const struct sk_buff *skb),
-- 
2.17.1

