Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32716260823
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 04:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbgIHCJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 22:09:45 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:38431 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728085AbgIHCJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 22:09:44 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0U8GuXYh_1599530980;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0U8GuXYh_1599530980)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 08 Sep 2020 10:09:40 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Satoru Moriya <satoru.moriya@hds.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH v2] net: tracepoint: fix print wrong sysctl_mem value
Date:   Tue,  8 Sep 2020 10:09:39 +0800
Message-Id: <20200908020939.7653-1-dust.li@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sysctl_mem is an point, and tracepoint entry do not support
been visited like an array. Use an __array(3) to store sysctl_mem
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

v2: use __array(3) instead of 3 long type to store sysctl_mem

Fixes: 3847ce32aea9fdf ("core: add tracepoints for queueing skb to rcvbuf")
Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
---
 include/trace/events/sock.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/sock.h b/include/trace/events/sock.h
index a966d4b5ab37..914e58938480 100644
--- a/include/trace/events/sock.h
+++ b/include/trace/events/sock.h
@@ -98,7 +98,7 @@ TRACE_EVENT(sock_exceed_buf_limit,
 
 	TP_STRUCT__entry(
 		__array(char, name, 32)
-		__field(long *, sysctl_mem)
+		__array(long, sysctl_mem, 3)
 		__field(long, allocated)
 		__field(int, sysctl_rmem)
 		__field(int, rmem_alloc)
@@ -110,7 +110,9 @@ TRACE_EVENT(sock_exceed_buf_limit,
 
 	TP_fast_assign(
 		strncpy(__entry->name, prot->name, 32);
-		__entry->sysctl_mem = prot->sysctl_mem;
+		__entry->sysctl_mem[0] = prot->sysctl_mem[0];
+		__entry->sysctl_mem[1] = prot->sysctl_mem[1];
+		__entry->sysctl_mem[2] = prot->sysctl_mem[2];
 		__entry->allocated = allocated;
 		__entry->sysctl_rmem = sk_get_rmem0(sk, prot);
 		__entry->rmem_alloc = atomic_read(&sk->sk_rmem_alloc);
-- 
2.19.1.3.ge56e4f7

