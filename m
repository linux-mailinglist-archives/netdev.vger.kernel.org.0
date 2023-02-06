Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC4D68C5C7
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 19:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjBFSbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 13:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjBFSbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 13:31:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F0A2412C
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 10:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675708242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YSt5InimOLrMdc6TA7x199D2dXYWE0pOGxfiU+DRYSc=;
        b=e+RAb/bTxfIz7u1PlUW+jpwEloRc6xjexCYCnA7fKBMWo3RmuA6Dc1/1ozz0BNVFe7myxm
        0gffnUpIc5H7UbB7dGNp4WrKdnB+Oz5IJjhFl0jwa/4M7RrLLCQqrCMsgAr4jXxjpiNgxD
        lUGowcBsgUCkkQbgCA6eCDVCYDgci9M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-bGIPMhl-N7KVEFXg0xAoRw-1; Mon, 06 Feb 2023 13:30:36 -0500
X-MC-Unique: bGIPMhl-N7KVEFXg0xAoRw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A92D858F0E;
        Mon,  6 Feb 2023 18:30:36 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE7A21121315;
        Mon,  6 Feb 2023 18:30:34 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>
Subject: [PATCH v3 net-next 1/4] net-sysctl: factor out cpumask parsing helper
Date:   Mon,  6 Feb 2023 19:30:19 +0100
Message-Id: <f171c4f78c17c259deb0cae78a26dc274afe9fce.1675708062.git.pabeni@redhat.com>
In-Reply-To: <cover.1675708062.git.pabeni@redhat.com>
References: <cover.1675708062.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
new in v3
---
 net/core/sysctl_net_core.c | 45 +++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 18 deletions(-)

diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index e7b98162c632..31a5adc1ba94 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -45,6 +45,32 @@ EXPORT_SYMBOL(sysctl_fb_tunnels_only_for_init_net);
 int sysctl_devconf_inherit_init_net __read_mostly;
 EXPORT_SYMBOL(sysctl_devconf_inherit_init_net);
 
+#if IS_ENABLED(CONFIG_NET_FLOW_LIMIT)
+void dump_cpumask(void *buffer, size_t *lenp, loff_t *ppos, struct cpumask *mask)
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
@@ -155,13 +181,6 @@ static int flow_limit_cpu_sysctl(struct ctl_table *table, int write,
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
@@ -171,17 +190,7 @@ static int flow_limit_cpu_sysctl(struct ctl_table *table, int write,
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

