Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F9525FC43
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 16:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729948AbgIGOtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 10:49:41 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:57729 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729987AbgIGOsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 10:48:40 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U8EuKxN_1599490077;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0U8EuKxN_1599490077)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 07 Sep 2020 22:47:58 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Satoru Moriya <satoru.moriya@hds.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH] net: tracepoint: fix print wrong sysctl_mem value
Date:   Mon,  7 Sep 2020 22:47:57 +0800
Message-Id: <20200907144757.43389-1-dust.li@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sysctl_mem is an point, and tracepoint entry do not support
been visited like an array. Use 3 long type to get sysctl_mem
instead.

tracpoint output with and without this fix:
- without fix:
   28821.074 sock:sock_exceed_buf_limit:proto:UDP
   sysctl_mem=-1741233440,19,322156906942464 allocated=19 sysctl_rmem=4096
   rmem_alloc=75008 sysctl_wmem=4096 wmem_alloc=1 wmem_queued=0
   kind=SK_MEM_RECV

- with fix:
  2126.136 sock:sock_exceed_buf_limit:proto:UDP
  sysctl_mem=18,122845,184266 allocated=19 sysctl_rmem=4096
  rmem_alloc=73728 sysctl_wmem=4096 wmem_alloc=1 wmem_queued=0
  kind=SK_MEM_RECV

Fixes: 3847ce32aea9fdf ("core: add tracepoints for queueing skb to rcvbuf")
Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
---
 include/trace/events/sock.h | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/trace/events/sock.h b/include/trace/events/sock.h
index a966d4b5ab37..9118dd2353b7 100644
--- a/include/trace/events/sock.h
+++ b/include/trace/events/sock.h
@@ -98,7 +98,9 @@ TRACE_EVENT(sock_exceed_buf_limit,
 
 	TP_STRUCT__entry(
 		__array(char, name, 32)
-		__field(long *, sysctl_mem)
+		__field(long, sysctl_mem0)
+		__field(long, sysctl_mem1)
+		__field(long, sysctl_mem2)
 		__field(long, allocated)
 		__field(int, sysctl_rmem)
 		__field(int, rmem_alloc)
@@ -110,7 +112,9 @@ TRACE_EVENT(sock_exceed_buf_limit,
 
 	TP_fast_assign(
 		strncpy(__entry->name, prot->name, 32);
-		__entry->sysctl_mem = prot->sysctl_mem;
+		__entry->sysctl_mem0 = prot->sysctl_mem[0];
+		__entry->sysctl_mem1 = prot->sysctl_mem[1];
+		__entry->sysctl_mem2 = prot->sysctl_mem[2];
 		__entry->allocated = allocated;
 		__entry->sysctl_rmem = sk_get_rmem0(sk, prot);
 		__entry->rmem_alloc = atomic_read(&sk->sk_rmem_alloc);
@@ -122,9 +126,9 @@ TRACE_EVENT(sock_exceed_buf_limit,
 
 	TP_printk("proto:%s sysctl_mem=%ld,%ld,%ld allocated=%ld sysctl_rmem=%d rmem_alloc=%d sysctl_wmem=%d wmem_alloc=%d wmem_queued=%d kind=%s",
 		__entry->name,
-		__entry->sysctl_mem[0],
-		__entry->sysctl_mem[1],
-		__entry->sysctl_mem[2],
+		__entry->sysctl_mem0,
+		__entry->sysctl_mem1,
+		__entry->sysctl_mem2,
 		__entry->allocated,
 		__entry->sysctl_rmem,
 		__entry->rmem_alloc,
-- 
2.19.1.3.ge56e4f7

