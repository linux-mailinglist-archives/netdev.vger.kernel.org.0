Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74D72652E0
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgIJVYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:24:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38771 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731015AbgIJOXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 10:23:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599747794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wHP5sYGvevfhfD86Z14pcTljV0gAdC62C43bs8xTbcc=;
        b=jVC+n2XpOFb8ixivgIsTvmajEshmFuG6+8ip6YsLa6CD8bl+B/urt6FxvqxUxx+feK4uKe
        TD+1UXmbxpg56NZWRnycIehhPOuN5kvJfPvGRbejyZ8vOx5mXTp9pzTUY7GFPDdtg++m5h
        zdBKzn81gtmzMKbyahJ3gGUcyV+rlUo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-h-A8RKtHNtSSBXpyhXU63w-1; Thu, 10 Sep 2020 10:21:09 -0400
X-MC-Unique: h-A8RKtHNtSSBXpyhXU63w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A6DB410BBED9;
        Thu, 10 Sep 2020 14:21:07 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-113-172.ams2.redhat.com [10.36.113.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 61B8C81C48;
        Thu, 10 Sep 2020 14:21:06 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next] net: try to avoid unneeded backlog flush
Date:   Thu, 10 Sep 2020 16:20:57 +0200
Message-Id: <0d64ac9b321104d58270822c204845ccb31368f8.1599747321.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

flush_all_backlogs() may cause deadlock on systems
running processes with FIFO scheduling policy.

The above is critical in -RT scenarios, where user-space
specifically ensure no network activity is scheduled on
the CPU running the mentioned FIFO process, but still get
stuck.

This commit tries to address the problem checking the
backlog status on the remote CPUs before scheduling the
flush operation. If the backlog is empty, we can skip it.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/core/dev.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 46 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 152ad3b578de..fdef40bf4b88 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5621,17 +5621,59 @@ static void flush_backlog(struct work_struct *work)
 	local_bh_enable();
 }
 
+static bool flush_required(int cpu)
+{
+#if IS_ENABLED(CONFIG_RPS)
+	struct softnet_data *sd = &per_cpu(softnet_data, cpu);
+	bool do_flush;
+
+	local_irq_disable();
+	rps_lock(sd);
+
+	/* as insertion into process_queue happens with the rps lock held,
+	 * process_queue access may race only with dequeue
+	 */
+	do_flush = !skb_queue_empty(&sd->input_pkt_queue) ||
+		   !skb_queue_empty_lockless(&sd->process_queue);
+	rps_unlock(sd);
+	local_irq_enable();
+
+	return do_flush;
+#endif
+	/* without RPS we can't safely check input_pkt_queue: during a
+	 * concurrent remote skb_queue_splice() we can detect as empty both
+	 * input_pkt_queue and process_queue even if the latter could end-up
+	 * containing a lot of packets.
+	 */
+	return true;
+}
+
 static void flush_all_backlogs(void)
 {
+	static cpumask_t flush_cpus  = { CPU_BITS_NONE };
 	unsigned int cpu;
 
+	/* since we are under rtnl lock protection we can use static data
+	 * for the cpumask and avoid allocating on stack the possibly
+	 * large mask
+	 */
+	ASSERT_RTNL();
+
 	get_online_cpus();
 
-	for_each_online_cpu(cpu)
-		queue_work_on(cpu, system_highpri_wq,
-			      per_cpu_ptr(&flush_works, cpu));
+	for_each_online_cpu(cpu) {
+		if (flush_required(cpu)) {
+			queue_work_on(cpu, system_highpri_wq,
+				      per_cpu_ptr(&flush_works, cpu));
+			cpumask_set_cpu(cpu, &flush_cpus);
+		}
+	}
 
-	for_each_online_cpu(cpu)
+	/* we can have in flight packet[s] on the cpus we are not flushing,
+	 * synchronize_net() in rollback_registered_many() will take care of
+	 * them
+	 */
+	for_each_cpu(cpu, &flush_cpus)
 		flush_work(per_cpu_ptr(&flush_works, cpu));
 
 	put_online_cpus();
-- 
2.26.2

