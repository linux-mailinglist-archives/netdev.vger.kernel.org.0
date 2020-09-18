Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2593B270182
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 18:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgIRQBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 12:01:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55409 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726115AbgIRQBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 12:01:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600444878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=5eN4nNcD42KXZSKM9zBnVU3lBrCBeehYq0w/GPTTTps=;
        b=Y5N4GtgI+00RwZ+KkyiUcw5kvuNtRxXGVsxNLpPWUGmLbJpf5v8LKsbM5+HUUzKf4ntDWq
        d7aB/Px34DDs2tA9eYu6O0Q9WmL55/aYU7bAzgVMyGM+5Sh6m3GdjYGFEp7KNflToPelUx
        w1m8GIkhAdUuaCSd2NkPuRsU49oV17M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-WRtydvPkM2WDFuye-u6jAA-1; Fri, 18 Sep 2020 12:01:16 -0400
X-MC-Unique: WRtydvPkM2WDFuye-u6jAA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3206E890EB0;
        Fri, 18 Sep 2020 16:00:59 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-107.ams2.redhat.com [10.36.114.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1475A55764;
        Fri, 18 Sep 2020 16:00:57 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH net-next] net-sysfs: add backlog len and CPU id to softnet data
Date:   Fri, 18 Sep 2020 18:00:46 +0200
Message-Id: <5e503da366e0261632ab87559a72db2fff0e78a4.1600444637.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the backlog status in not exposed to user-space.
Since long backlogs (or simply not empty ones) can be a
source of noticeable latency, -RT deployments need some way
to inspect it.

Additionally, there isn't a direct match between 'softnet_stat'
lines and the related CPU - sd for offline CPUs are not dumped -
so this patch also includes the CPU id into such entry.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/core/net-procfs.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index 6bbd06f7dc7d..c714e6a9dad4 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -116,6 +116,12 @@ static int dev_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
+static u32 softnet_backlog_len(struct softnet_data *sd)
+{
+	return skb_queue_len_lockless(&sd->input_pkt_queue) +
+	       skb_queue_len_lockless(&sd->process_queue);
+}
+
 static struct softnet_data *softnet_get_online(loff_t *pos)
 {
 	struct softnet_data *sd = NULL;
@@ -159,12 +165,17 @@ static int softnet_seq_show(struct seq_file *seq, void *v)
 	rcu_read_unlock();
 #endif
 
+	/* the index is the CPU id owing this sd. Since offline CPUs are not
+	 * displayed, it would be othrwise not trivial for the user-space
+	 * mapping the data a specific CPU
+	 */
 	seq_printf(seq,
-		   "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x\n",
+		   "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x\n",
 		   sd->processed, sd->dropped, sd->time_squeeze, 0,
 		   0, 0, 0, 0, /* was fastroute */
 		   0,	/* was cpu_collision */
-		   sd->received_rps, flow_limit_count);
+		   sd->received_rps, flow_limit_count,
+		   softnet_backlog_len(sd), (int)seq->index);
 	return 0;
 }
 
-- 
2.26.2

