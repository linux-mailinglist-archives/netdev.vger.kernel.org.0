Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4B74D9780
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 10:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346533AbiCOJUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 05:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346526AbiCOJUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 05:20:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 431C31DA42
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 02:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647335928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2b9QpGNlzLlPNztQY8QsHO4+YlZtG/kDWHOkJSbcmqM=;
        b=aEbeqxK27nshuV3hPmVy6sDhn38Q50olu/1u30e0rZe6/s90U7conW5KmovVlezN7IC1yo
        lMbnk3GNJpg5IohPNWVuKZQK9HPORVphiOlFVcZSeEIxa4cg8WPPCgW3Y3fqpOIb6gD51J
        51vsV2a22yox8tuluNN9S/3H8qLnewg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-AfFaYcxpP6auWLahOtqCfA-1; Tue, 15 Mar 2022 05:18:45 -0400
X-MC-Unique: AfFaYcxpP6auWLahOtqCfA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 325C6802809;
        Tue, 15 Mar 2022 09:18:45 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.152])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF5075B4237;
        Tue, 15 Mar 2022 09:18:41 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     edumazet@google.com, bigeasy@linutronix.de, atenart@kernel.org,
        imagedong@tencent.com, petrm@nvidia.com, arnd@arndb.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH net-next] net: set default rss queues num to physical cores / 2
Date:   Tue, 15 Mar 2022 10:18:32 +0100
Message-Id: <20220315091832.13873-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Network drivers can call to netif_get_num_default_rss_queues to get the
default number of receive queues to use. Right now, this default number
is min(8, num_online_cpus()).

Instead, as suggested by Jakub, use the number of physical cores divided
by 2 as a way to avoid wasting CPU resources and to avoid using both CPU
threads, but still allowing to scale for high-end processors with many
cores.

As an exception, select 2 queues for processors with 2 cores, because
otherwise it won't take any advantage of RSS despite being SMP capable.

Tested: Processor Intel Xeon E5-2620 (2 sockets, 6 cores/socket, 2
threads/core). NIC Broadcom NetXtreme II BCM57810 (10GBps). Ran some
tests with `perf stat iperf3 -R`, with parallelisms of 1, 8 and 24,
getting the following results:
- Number of queues: 6 (instead of 8)
- Network throughput: not affected
- CPU usage: utilized 0.05-0.12 CPUs more than before (having 24 CPUs
  this is only 0.2-0.5% higher)
- Reduced the number of context switches by 7-50%, being more noticeable
  when using a higher number of parallel threads.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 include/linux/netdevice.h |  1 -
 net/core/dev.c            | 20 ++++++++++++++++----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 0d994710b335..db9874ed79d9 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3664,7 +3664,6 @@ static inline unsigned int get_netdev_rx_queue_index(
 }
 #endif
 
-#define DEFAULT_MAX_NUM_RSS_QUEUES	(8)
 int netif_get_num_default_rss_queues(void);
 
 enum skb_free_reason {
diff --git a/net/core/dev.c b/net/core/dev.c
index 75bab5b0dbae..8e0cc5f2020d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2990,13 +2990,25 @@ EXPORT_SYMBOL(netif_set_real_num_queues);
 /**
  * netif_get_num_default_rss_queues - default number of RSS queues
  *
- * This routine should set an upper limit on the number of RSS queues
- * used by default by multiqueue devices.
+ * Default value is the number of physical cores if there are only 1 or 2, or
+ * divided by 2 if there are more.
  */
 int netif_get_num_default_rss_queues(void)
 {
-	return is_kdump_kernel() ?
-		1 : min_t(int, DEFAULT_MAX_NUM_RSS_QUEUES, num_online_cpus());
+	cpumask_var_t cpus;
+	int cpu, count = 0;
+
+	if (unlikely(is_kdump_kernel() || !zalloc_cpumask_var(&cpus, GFP_KERNEL)))
+		return 1;
+
+	cpumask_copy(cpus, cpu_online_mask);
+	for_each_cpu(cpu, cpus) {
+		++count;
+		cpumask_andnot(cpus, cpus, topology_sibling_cpumask(cpu));
+	}
+	free_cpumask_var(cpus);
+
+	return count > 2 ? DIV_ROUND_UP(count, 2) : count;
 }
 EXPORT_SYMBOL(netif_get_num_default_rss_queues);
 
-- 
2.34.1

