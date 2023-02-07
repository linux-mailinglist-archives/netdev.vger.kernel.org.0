Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 932BC68E06B
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 19:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbjBGSqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 13:46:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbjBGSqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 13:46:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82ACD23131
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 10:46:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675795562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jn7pdUpd4gCq5vqvKWsEZ1YZE9c/IKW6rWYbHqtlflo=;
        b=iskzXN0UqcmvLNuBs7G7n9gLYLRPydLBpiwvvLDBbQjUo6CKENAxSTZgRSm6o8Wb/5HpKe
        ai0TEoYli0oLxq+Mzkln7H8WWdhJn+ADkSIp5H7KxkmLh0lmQNQGHvmVPrxIKm5R8IViQX
        lYO6JL0qWvNqq/QVz15bBYAuGiJqPNg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-361-Kp17B37fPL2ePv3UL1CBpA-1; Tue, 07 Feb 2023 13:46:01 -0500
X-MC-Unique: Kp17B37fPL2ePv3UL1CBpA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E0DD885625;
        Tue,  7 Feb 2023 18:46:00 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 677DD40B40C7;
        Tue,  7 Feb 2023 18:45:59 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>
Subject: [PATCH v4 net-next 1/4] net-sysctl: factor out cpumask parsing helper
Date:   Tue,  7 Feb 2023 19:44:55 +0100
Message-Id: <8e69455b0e3bc339ca6c00f04fe86660e2aad58b.1675789134.git.pabeni@redhat.com>
In-Reply-To: <cover.1675789134.git.pabeni@redhat.com>
References: <cover.1675789134.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Will be used by the following patch to avoid code
duplication. No functional changes intended.

The only difference is that now flow_limit_cpu_sysctl() will
always compute the flow limit mask on each read operation,
even when read() will not return any byte to user-space.

Note that the new helper is placed under a new #ifdef at
the file start to better fit the usage in the later patch

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
v3 -> v4:
 - fix warning reported by the kernel test robot
---
 net/core/sysctl_net_core.c | 46 +++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index e7b98162c632..6935ecdc84b0 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -45,6 +45,33 @@ EXPORT_SYMBOL(sysctl_fb_tunnels_only_for_init_net);
 int sysctl_devconf_inherit_init_net __read_mostly;
 EXPORT_SYMBOL(sysctl_devconf_inherit_init_net);
 
+#if IS_ENABLED(CONFIG_NET_FLOW_LIMIT)
+static void dump_cpumask(void *buffer, size_t *lenp, loff_t *ppos,
+			 struct cpumask *mask)
+{
+	char kbuf[128];
+	int len;
+
+	if (*ppos || !*lenp) {
+		*lenp = 0;
+		return;
+	}
+
+	len = min(sizeof(kbuf) - 1, *lenp);
+	len = scnprintf(kbuf, len, "%*pb", cpumask_pr_args(mask));
+	if (!len) {
+		*lenp = 0;
+		return;
+	}
+
+	if (len < *lenp)
+		kbuf[len++] = '\n';
+	memcpy(buffer, kbuf, len);
+	*lenp = len;
+	*ppos += len;
+}
+#endif
+
 #ifdef CONFIG_RPS
 static int rps_sock_flow_sysctl(struct ctl_table *table, int write,
 				void *buffer, size_t *lenp, loff_t *ppos)
@@ -155,13 +182,6 @@ static int flow_limit_cpu_sysctl(struct ctl_table *table, int write,
 write_unlock:
 		mutex_unlock(&flow_limit_update_mutex);
 	} else {
-		char kbuf[128];
-
-		if (*ppos || !*lenp) {
-			*lenp = 0;
-			goto done;
-		}
-
 		cpumask_clear(mask);
 		rcu_read_lock();
 		for_each_possible_cpu(i) {
@@ -171,17 +191,7 @@ static int flow_limit_cpu_sysctl(struct ctl_table *table, int write,
 		}
 		rcu_read_unlock();
 
-		len = min(sizeof(kbuf) - 1, *lenp);
-		len = scnprintf(kbuf, len, "%*pb", cpumask_pr_args(mask));
-		if (!len) {
-			*lenp = 0;
-			goto done;
-		}
-		if (len < *lenp)
-			kbuf[len++] = '\n';
-		memcpy(buffer, kbuf, len);
-		*lenp = len;
-		*ppos += len;
+		dump_cpumask(buffer, lenp, ppos, mask);
 	}
 
 done:
-- 
2.39.1

