Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6B71F25C
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 14:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729840AbfEOMDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 08:03:10 -0400
Received: from forwardcorp1p.mail.yandex.net ([77.88.29.217]:37698 "EHLO
        forwardcorp1p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730124AbfEOMDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 08:03:08 -0400
X-Greylist: delayed 442 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 May 2019 08:03:06 EDT
Received: from mxbackcorp1g.mail.yandex.net (mxbackcorp1g.mail.yandex.net [IPv6:2a02:6b8:0:1402::301])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id D738C2E0ABC;
        Wed, 15 May 2019 14:55:42 +0300 (MSK)
Received: from smtpcorp1o.mail.yandex.net (smtpcorp1o.mail.yandex.net [2a02:6b8:0:1a2d::30])
        by mxbackcorp1g.mail.yandex.net (nwsmtp/Yandex) with ESMTP id 7Uaf6EnKr8-tgsS7u6u;
        Wed, 15 May 2019 14:55:42 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1557921342; bh=CfT2mw9Voryfx7z4pzvbGxS8fdbuS8Bjj6c0PWDezKs=;
        h=Message-ID:Date:To:From:Subject;
        b=J2Ynm2oDP1Lw2/V1Y9ufeN0W22FUMXnolWMJrZE6QZQ3N9yRRA+POCOF3gWyPv2d7
         JlSLIwIdfa3ZsjusBfq51I9nYvXGu0NIorP9fsPGzs+NUcDwaazaG0SrYIc13KDJE9
         AgFvJ6E+avYNVjR2T1fMO4kxaFzu/iFhiWAqq5MY=
Authentication-Results: mxbackcorp1g.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-red.dhcp.yndx.net (dynamic-red.dhcp.yndx.net [2a02:6b8:0:40c:ed19:3833:7ce1:2324])
        by smtpcorp1o.mail.yandex.net (nwsmtp/Yandex) with ESMTPSA id GGfHxKOueD-tglO5KqC;
        Wed, 15 May 2019 14:55:42 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
Subject: [PATCH RFC] proc/meminfo: add NetBuffers counter for socket buffers
From:   Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Wed, 15 May 2019 14:55:41 +0300
Message-ID: <155792134187.1641.3858215257559626632.stgit@buzz>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Socket buffers always were dark-matter that lives by its own rules.
This patch adds line NetBuffers that exposes most common kinds of them.

TCP and UDP are most important species.
SCTP is added as example of modular protocol.
UNIX have no memory counter for now, should be easy to add.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 fs/proc/meminfo.c  |    5 ++++-
 include/linux/mm.h |    6 ++++++
 mm/page_alloc.c    |    3 ++-
 net/core/sock.c    |   20 ++++++++++++++++++++
 net/sctp/socket.c  |    2 +-
 5 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index 7bc14716fc5d..0ee2300a916d 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -41,6 +41,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 	unsigned long sreclaimable, sunreclaim, misc_reclaimable;
 	unsigned long kernel_stack_kb, page_tables, percpu_pages;
 	unsigned long anon_pages, file_pages, swap_cached;
+	unsigned long net_buffers;
 	long kernel_misc;
 	int lru;
 
@@ -66,12 +67,13 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 	kernel_stack_kb = global_zone_page_state(NR_KERNEL_STACK_KB);
 	page_tables = global_zone_page_state(NR_PAGETABLE);
 	percpu_pages = pcpu_nr_pages();
+	net_buffers = total_netbuffer_pages();
 
 	/* all other kinds of kernel memory allocations */
 	kernel_misc = i.totalram - i.freeram - anon_pages - file_pages
 		      - sreclaimable - sunreclaim - misc_reclaimable
 		      - (kernel_stack_kb >> (PAGE_SHIFT - 10))
-		      - page_tables - percpu_pages;
+		      - page_tables - percpu_pages - net_buffers;
 	if (kernel_misc < 0)
 		kernel_misc = 0;
 
@@ -137,6 +139,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 	show_val_kb(m, "VmallocUsed:    ", 0ul);
 	show_val_kb(m, "VmallocChunk:   ", 0ul);
 	show_val_kb(m, "Percpu:         ", percpu_pages);
+	show_val_kb(m, "NetBuffers:     ", net_buffers);
 	show_val_kb(m, "KernelMisc:     ", kernel_misc);
 
 #ifdef CONFIG_MEMORY_FAILURE
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0e8834ac32b7..d0a58355bfb7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2254,6 +2254,12 @@ extern void si_meminfo_node(struct sysinfo *val, int nid);
 extern unsigned long arch_reserved_kernel_pages(void);
 #endif
 
+#ifdef CONFIG_NET
+extern unsigned long total_netbuffer_pages(void);
+#else
+static inline unsigned long total_netbuffer_pages(void) { return 0; }
+#endif
+
 extern __printf(3, 4)
 void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...);
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3b13d3914176..fcdd7c6e72b9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5166,7 +5166,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 		" active_file:%lu inactive_file:%lu isolated_file:%lu\n"
 		" unevictable:%lu dirty:%lu writeback:%lu unstable:%lu\n"
 		" slab_reclaimable:%lu slab_unreclaimable:%lu\n"
-		" mapped:%lu shmem:%lu pagetables:%lu bounce:%lu\n"
+		" mapped:%lu shmem:%lu pagetables:%lu bounce:%lu net_buffers:%lu\n"
 		" free:%lu free_pcp:%lu free_cma:%lu\n",
 		global_node_page_state(NR_ACTIVE_ANON),
 		global_node_page_state(NR_INACTIVE_ANON),
@@ -5184,6 +5184,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 		global_node_page_state(NR_SHMEM),
 		global_zone_page_state(NR_PAGETABLE),
 		global_zone_page_state(NR_BOUNCE),
+		total_netbuffer_pages(),
 		global_zone_page_state(NR_FREE_PAGES),
 		free_pcp,
 		global_zone_page_state(NR_FREE_CMA_PAGES));
diff --git a/net/core/sock.c b/net/core/sock.c
index 75b1c950b49f..dfca4e024b74 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -142,6 +142,7 @@
 #include <trace/events/sock.h>
 
 #include <net/tcp.h>
+#include <net/udp.h>
 #include <net/busy_poll.h>
 
 static DEFINE_MUTEX(proto_list_mutex);
@@ -3573,3 +3574,22 @@ bool sk_busy_loop_end(void *p, unsigned long start_time)
 }
 EXPORT_SYMBOL(sk_busy_loop_end);
 #endif /* CONFIG_NET_RX_BUSY_POLL */
+
+#if IS_ENABLED(CONFIG_IP_SCTP)
+atomic_long_t sctp_memory_allocated;
+EXPORT_SYMBOL_GPL(sctp_memory_allocated);
+#endif
+
+unsigned long total_netbuffer_pages(void)
+{
+	unsigned long ret = 0;
+
+#if IS_ENABLED(CONFIG_IP_SCTP)
+	ret += atomic_long_read(&sctp_memory_allocated);
+#endif
+#ifdef CONFIG_INET
+	ret += atomic_long_read(&tcp_memory_allocated);
+	ret += atomic_long_read(&udp_memory_allocated);
+#endif
+	return ret;
+}
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index e4e892cc5644..9d11afdeeae4 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -107,7 +107,7 @@ static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
 			     enum sctp_socket_type type);
 
 static unsigned long sctp_memory_pressure;
-static atomic_long_t sctp_memory_allocated;
+extern atomic_long_t sctp_memory_allocated;
 struct percpu_counter sctp_sockets_allocated;
 
 static void sctp_enter_memory_pressure(struct sock *sk)

