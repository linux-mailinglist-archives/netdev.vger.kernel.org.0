Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7486C314B
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 13:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbjCUMMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 08:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjCUMMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 08:12:51 -0400
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5B933CE4;
        Tue, 21 Mar 2023 05:12:49 -0700 (PDT)
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4Pgr8c4Llhz6FK2Q;
        Tue, 21 Mar 2023 20:12:48 +0800 (CST)
Received: from szxlzmapp04.zte.com.cn ([10.5.231.166])
        by mse-fl2.zte.com.cn with SMTP id 32LCCQTh002869;
        Tue, 21 Mar 2023 20:12:26 +0800 (+08)
        (envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxlzmapp03[null])
        by mapi (Zmail) with MAPI id mid14;
        Tue, 21 Mar 2023 20:12:29 +0800 (CST)
Date:   Tue, 21 Mar 2023 20:12:29 +0800 (CST)
X-Zmail-TransId: 2b0564199f2d308-a24cd
X-Mailer: Zmail v1.0
Message-ID: <202303212012296834902@zte.com.cn>
Mime-Version: 1.0
From:   <yang.yang29@zte.com.cn>
To:     <edumazet@google.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xu.xin16@zte.com.cn>,
        <jiang.xuexin@zte.com.cn>, <zhang.yunkai@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIXSBycHM6IHByb2Nlc3MgdGhlIHNrYiBkaXJlY3RseSBpZiBycHMgY3B1IG5vdCBjaGFuZ2Vk?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl2.zte.com.cn 32LCCQTh002869
X-Fangmail-Gw-Spam-Type: 0
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 64199F40.000/4Pgr8c4Llhz6FK2Q
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xu xin <xu.xin16@zte.com.cn>

In the RPS procedure of NAPI receiving, regardless of whether the
rps-calculated CPU of the skb equals to the currently processing CPU, RPS
will always use enqueue_to_backlog to enqueue the skb to per-cpu backlog,
which will trigger a new NET_RX softirq.

Actually, it's not necessary to enqueue it to backlog when rps-calculated
CPU id equals to the current processing CPU, and we can call
__netif_receive_skb or __netif_receive_skb_list to process the skb directly.
The benefit is that it can reduce the number of softirqs of NET_RX and reduce
the processing delay of skb.

The measured result shows the patch brings 50% reduction of NET_RX softirqs.
The test was done on the QEMU environment with two-core CPU by iperf3.
taskset 01 iperf3 -c 192.168.2.250 -t 3 -u -R;
taskset 02 iperf3 -c 192.168.2.250 -t 3 -u -R;

Previous RPS:
		    	CPU0       CPU1
NET_RX:         45          0    (before iperf3 testing)
NET_RX:        1095         241   (after iperf3 testing)

Patched RPS:
                CPU0       CPU1
NET_RX:         28          4    (before iperf3 testing)
NET_RX:         573         32   (after iperf3 testing)

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Reviewed-by: Zhang Yunkai <zhang.yunkai@zte.com.cn>
Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
Cc: Xuexin Jiang <jiang.xuexin@zte.com.cn>
---
 net/core/dev.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index c7853192563d..c33ddac3c012 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5666,8 +5666,9 @@ static int netif_receive_skb_internal(struct sk_buff *skb)
 	if (static_branch_unlikely(&rps_needed)) {
 		struct rps_dev_flow voidflow, *rflow = &voidflow;
 		int cpu = get_rps_cpu(skb->dev, skb, &rflow);
+		int current_cpu = smp_processor_id();

-		if (cpu >= 0) {
+		if (cpu >= 0 && cpu != current_cpu) {
 			ret = enqueue_to_backlog(skb, cpu, &rflow->last_qtail);
 			rcu_read_unlock();
 			return ret;
@@ -5699,8 +5700,9 @@ void netif_receive_skb_list_internal(struct list_head *head)
 		list_for_each_entry_safe(skb, next, head, list) {
 			struct rps_dev_flow voidflow, *rflow = &voidflow;
 			int cpu = get_rps_cpu(skb->dev, skb, &rflow);
+			int current_cpu = smp_processor_id();

-			if (cpu >= 0) {
+			if (cpu >= 0 && cpu != current_cpu) {
 				/* Will be handled, remove from list */
 				skb_list_del_init(skb);
 				enqueue_to_backlog(skb, cpu, &rflow->last_qtail);
-- 
2.15.2
