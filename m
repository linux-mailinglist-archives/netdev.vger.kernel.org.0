Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 554DC625222
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 05:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbiKKEEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 23:04:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232446AbiKKEDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 23:03:54 -0500
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02EF68AC0
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 20:02:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1668139377; x=1699675377;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6l51Ob3RRgzM3/cp30UwaxfJ/FzHXp9p8PoJz8d5xSQ=;
  b=Zz+7OWnmS511C+tXsITONxgWzh9d+uBaL4cqtbiYIuZKPpL60TgTrMv2
   /9D5oQhGKKs3DFSUTcbF1GObG0K4U7W2iNxAUtOUThImqVnjdVWvBQ8p4
   lioaha4lF2rQmD9Z7n78rT3Ut/V/xh0Swr43/DulnXW2yQNU5odxOCxHq
   M=;
X-IronPort-AV: E=Sophos;i="5.96,155,1665446400"; 
   d="scan'208";a="149759733"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-f05d30a1.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2022 04:02:56 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-f05d30a1.us-east-1.amazon.com (Postfix) with ESMTPS id E259F85B6F;
        Fri, 11 Nov 2022 04:02:53 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Fri, 11 Nov 2022 04:02:51 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.223) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Fri, 11 Nov 2022 04:02:49 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 net-next 5/6] udp: Add bitmap in udp_table.
Date:   Thu, 10 Nov 2022 20:00:33 -0800
Message-ID: <20221111040034.29736-6-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221111040034.29736-1-kuniyu@amazon.com>
References: <20221111040034.29736-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.223]
X-ClientProxiedBy: EX13D42UWA003.ant.amazon.com (10.43.160.101) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We use a bitmap in udp_lib_get_port() to search for an available
port.  Currently, the bitmap size is fixed and has enough room for
UDP_HTABLE_SIZE_MIN.

The following patch adds the per-netns hash table for UDP, whose size
can be smaller than UDP_HTABLE_SIZE_MIN.  If we define a bitmap with
enough size on the stack, it will be over CONFIG_FRAME_WARN.  To avoid
that, we allocate bitmaps for each udp_table->hash[slot] in advance.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/linux/udp.h |  1 +
 include/net/udp.h   | 20 ++++++++++++++++++++
 net/ipv4/udp.c      | 12 +++++++++---
 3 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/include/linux/udp.h b/include/linux/udp.h
index dea57aa37df6..779a7c065a32 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -23,6 +23,7 @@ static inline struct udphdr *udp_hdr(const struct sk_buff *skb)
 	return (struct udphdr *)skb_transport_header(skb);
 }
 
+#define UDP_MAX_PORT_LOG		16
 #define UDP_HTABLE_SIZE_MIN		(CONFIG_BASE_SMALL ? 128 : 256)
 
 static inline u32 udp_hashfn(const struct net *net, u32 num, u32 mask)
diff --git a/include/net/udp.h b/include/net/udp.h
index de4b528522bb..314dd51a2cc6 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -72,11 +72,31 @@ struct udp_hslot {
 struct udp_table {
 	struct udp_hslot	*hash;
 	struct udp_hslot	*hash2;
+	unsigned long		*bitmap;
 	unsigned int		mask;
 	unsigned int		log;
 };
 extern struct udp_table udp_table;
 void udp_table_init(struct udp_table *, const char *);
+
+static inline unsigned int udp_bitmap_size(struct udp_table *table)
+{
+	return 1 << (UDP_MAX_PORT_LOG - table->log);
+}
+
+static inline unsigned long *udp_hashbitmap(struct udp_table *table,
+					    struct net *net, unsigned int num)
+{
+	unsigned long *bitmap;
+	unsigned int size;
+
+	size = udp_bitmap_size(table);
+	bitmap = &table->bitmap[udp_hashfn(net, num, table->mask) * BITS_TO_LONGS(size)];
+	bitmap_zero(bitmap, size);
+
+	return bitmap;
+}
+
 static inline struct udp_hslot *udp_hashslot(struct udp_table *table,
 					     struct net *net, unsigned int num)
 {
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 37e79158d145..42d7b84a5f16 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -129,7 +129,6 @@ DEFINE_PER_CPU(int, udp_memory_per_cpu_fw_alloc);
 EXPORT_PER_CPU_SYMBOL_GPL(udp_memory_per_cpu_fw_alloc);
 
 #define MAX_UDP_PORTS 65536
-#define PORTS_PER_CHAIN (MAX_UDP_PORTS / UDP_HTABLE_SIZE_MIN)
 
 static struct udp_table *udp_get_table_prot(struct sock *sk)
 {
@@ -243,9 +242,9 @@ int udp_lib_get_port(struct sock *sk, unsigned short snum,
 	int error = 1;
 
 	if (!snum) {
-		DECLARE_BITMAP(bitmap, PORTS_PER_CHAIN);
 		unsigned short first, last;
 		int low, high, remaining;
+		unsigned long *bitmap;
 		unsigned int rand;
 
 		inet_get_local_port_range(net, &low, &high);
@@ -260,8 +259,8 @@ int udp_lib_get_port(struct sock *sk, unsigned short snum,
 		last = first + udptable->mask + 1;
 		do {
 			hslot = udp_hashslot(udptable, net, first);
-			bitmap_zero(bitmap, PORTS_PER_CHAIN);
 			spin_lock_bh(&hslot->lock);
+			bitmap = udp_hashbitmap(udptable, net, first);
 			udp_lib_lport_inuse(net, snum, hslot, bitmap, sk,
 					    udptable->log);
 
@@ -3290,6 +3289,13 @@ void __init udp_table_init(struct udp_table *table, const char *name)
 		table->hash2[i].count = 0;
 		spin_lock_init(&table->hash2[i].lock);
 	}
+
+	table->bitmap = kmalloc_array(table->mask + 1,
+				      BITS_TO_LONGS(udp_bitmap_size(table)) *
+				      sizeof(unsigned long),
+				      GFP_KERNEL);
+	if (!table->bitmap)
+		panic("UDP: failed to alloc bitmap\n");
 }
 
 u32 udp_flow_hashrnd(void)
-- 
2.30.2

