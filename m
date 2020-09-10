Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5250265361
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgIJVd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:33:58 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:28203 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728211AbgIJVdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 17:33:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599773620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VzqpgwsSPyL8k8/955/V+X5MV+uN6KUA7NH0shdDPBE=;
        b=OyEPpnq6SAii+38jakVN3vonGbrVoV1QLY3jWff7VIwLYw73vwgiQhclRssdKPuoSD8xgW
        Md7l28qjp5LWgs0kH7EmI7ZLWlY/+wcj9LY9HeoB380ZsbAcz8t93snb9AQe71xnIK5lgx
        pUywfv97KEbxYOeCkvIrroN+jeGb4eE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-j3mdZzn_OEWu_maq7kjsLQ-1; Thu, 10 Sep 2020 17:33:38 -0400
X-MC-Unique: j3mdZzn_OEWu_maq7kjsLQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D04C4100746B;
        Thu, 10 Sep 2020 21:33:37 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-112-6.ams2.redhat.com [10.36.112.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37A777E8EB;
        Thu, 10 Sep 2020 21:33:35 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next v2] net: try to avoid unneeded backlog flush
Date:   Thu, 10 Sep 2020 23:33:18 +0200
Message-Id: <07fa2be86a3b54d0cf0b771ca3c8b2ebbbca314f.1599758369.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

v1 -> v2:
 - explicitly clear flushed cpu mask - Eric

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/core/dev.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 47 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 152ad3b578de..cf7bb8d8b803 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5621,17 +5621,60 @@ static void flush_backlog(struct work_struct *work)
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
+	static cpumask_t flush_cpus;
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
+	cpumask_clear(&flush_cpus);
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

