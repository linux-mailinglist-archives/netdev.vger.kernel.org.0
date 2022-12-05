Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 558F1642C51
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 16:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbiLEPxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 10:53:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbiLEPxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 10:53:54 -0500
X-Greylist: delayed 600 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 05 Dec 2022 07:53:50 PST
Received: from serv108.segi.ulg.ac.be (serv108.segi.ulg.ac.be [139.165.32.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252AB1208A;
        Mon,  5 Dec 2022 07:53:50 -0800 (PST)
Received: from ubuntu.home (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id DE4CC200DF9A;
        Mon,  5 Dec 2022 16:36:20 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be DE4CC200DF9A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1670254581;
        bh=9RCpom6IfP/9eHB8wsuAhrtCGUOdEGP7ADW4IxYZHfs=;
        h=From:To:Cc:Subject:Date:From;
        b=1CQbneuAakFYezm9c49Pe85BrUfEgHmlUWWiJymF+Mj0VyLhPmDGvk4jFGtMA2NCl
         NNf6pra9lKs6aOzcrpfQSokivThebnH2bn/0CHsq2kM86DyAhRkgXTE81//a32CV9E
         RHZom6WGKuBgKqtCDKKaTzGzKpKZv12kWkaGLyj+tfJXzKhNRV4ue8QGJSsDl5wsUH
         Rz0w59W/epwIvfz4kOAFrSzmSHXgp28uAh6A8cldID5qZXlJt4Sl2VgOGpPjIPlWfm
         kYJxcUfkzKIstyNpheyanVQyV2Mzm+RlEVTsFqWjBbx1rNVM+pd6/o8O0u+gKtfbYd
         kuY/huEGvddRg==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, pabeni@redhat.com, edumazet@google.com,
        justin.iurman@uliege.be, stable@vger.kernel.org
Subject: [RFC net] Fixes: b63c5478e9cb ("ipv6: ioam: Support for Queue depth data field")
Date:   Mon,  5 Dec 2022 16:35:57 +0100
Message-Id: <20221205153557.28549-1-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEXHASH_WORD,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes a NULL qdisc pointer when retrieving the TX queue depth
for IOAM.

IMPORTANT: I suspect this fix is local only and the bug goes deeper (see
reasoning below).

Kernel panic:
[...]
RIP: 0010:ioam6_fill_trace_data+0x54f/0x5b0
[...]

...which basically points to the call to qdisc_qstats_qlen_backlog
inside net/ipv6/ioam6.c.

From there, I directly thought of a NULL pointer (queue->qdisc). To make
sure, I added some printk's to know exactly *why* and *when* it happens.
Here is the (summarized by queue) output:

skb for TX queue 1, qdisc is ffff8b375eee9800, qdisc_sleeping is ffff8b375eee9800
skb for TX queue 2, qdisc is ffff8b375eeefc00, qdisc_sleeping is ffff8b375eeefc00
skb for TX queue 3, qdisc is ffff8b375eeef800, qdisc_sleeping is ffff8b375eeef800
skb for TX queue 4, qdisc is ffff8b375eeec800, qdisc_sleeping is ffff8b375eeec800
skb for TX queue 5, qdisc is ffff8b375eeea400, qdisc_sleeping is ffff8b375eeea400
skb for TX queue 6, qdisc is ffff8b375eeee000, qdisc_sleeping is ffff8b375eeee000
skb for TX queue 7, qdisc is ffff8b375eee8800, qdisc_sleeping is ffff8b375eee8800
skb for TX queue 8, qdisc is ffff8b375eeedc00, qdisc_sleeping is ffff8b375eeedc00
skb for TX queue 9, qdisc is ffff8b375eee9400, qdisc_sleeping is ffff8b375eee9400
skb for TX queue 10, qdisc is ffff8b375eee8000, qdisc_sleeping is ffff8b375eee8000
skb for TX queue 11, qdisc is ffff8b375eeed400, qdisc_sleeping is ffff8b375eeed400
skb for TX queue 12, qdisc is ffff8b375eeea800, qdisc_sleeping is ffff8b375eeea800
skb for TX queue 13, qdisc is ffff8b375eee8c00, qdisc_sleeping is ffff8b375eee8c00
skb for TX queue 14, qdisc is ffff8b375eeea000, qdisc_sleeping is ffff8b375eeea000
skb for TX queue 15, qdisc is ffff8b375eeeb800, qdisc_sleeping is ffff8b375eeeb800
skb for TX queue 16, qdisc is NULL, qdisc_sleeping is NULL

What the hell? So, not sure why queue #16 would *never* have a qdisc
attached. Is it something expected I'm not aware of? As an FYI, here is
the output of "tc qdisc list dev xxx":

qdisc mq 0: root
qdisc fq_codel 0: parent :10 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
qdisc fq_codel 0: parent :f limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
qdisc fq_codel 0: parent :e limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
qdisc fq_codel 0: parent :d limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
qdisc fq_codel 0: parent :c limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
qdisc fq_codel 0: parent :b limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
qdisc fq_codel 0: parent :a limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
qdisc fq_codel 0: parent :9 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
qdisc fq_codel 0: parent :8 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
qdisc fq_codel 0: parent :7 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
qdisc fq_codel 0: parent :6 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
qdisc fq_codel 0: parent :5 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
qdisc fq_codel 0: parent :4 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
qdisc fq_codel 0: parent :3 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
qdisc fq_codel 0: parent :2 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
qdisc fq_codel 0: parent :1 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64

By the way, the NIC is an Intel XL710 40GbE QSFP+ (i40e driver, firmware
version 8.50 0x8000b6c7 1.3082.0) and it was tested on latest "net"
version (6.1.0-rc7+). Is this a bug in the i40e driver?

Cc: stable@vger.kernel.org
Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 net/ipv6/ioam6.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
index 571f0e4d9cf3..2472a8a043c4 100644
--- a/net/ipv6/ioam6.c
+++ b/net/ipv6/ioam6.c
@@ -727,10 +727,13 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 			*(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
 		} else {
 			queue = skb_get_tx_queue(skb_dst(skb)->dev, skb);
-			qdisc = rcu_dereference(queue->qdisc);
-			qdisc_qstats_qlen_backlog(qdisc, &qlen, &backlog);
-
-			*(__be32 *)data = cpu_to_be32(backlog);
+			if (!queue->qdisc) {
+				*(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
+			} else {
+				qdisc = rcu_dereference(queue->qdisc);
+				qdisc_qstats_qlen_backlog(qdisc, &qlen, &backlog);
+				*(__be32 *)data = cpu_to_be32(backlog);
+			}
 		}
 		data += sizeof(__be32);
 	}
-- 
2.25.1

