Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE81332A58
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 16:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231983AbhCIPZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 10:25:22 -0500
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:24765 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231699AbhCIPYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 10:24:48 -0500
Received: from localhost.localdomain ([153.202.107.157])
        by mwinf5d20 with ME
        id eFQD2400T3PnFJp03FQjo9; Tue, 09 Mar 2021 16:24:47 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Tue, 09 Mar 2021 16:24:47 +0100
X-ME-IP: 153.202.107.157
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Tom Herbert <therbert@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [RFC PATCH 1/1] dql: add dql_set_min_limit()
Date:   Wed, 10 Mar 2021 00:23:54 +0900
Message-Id: <20210309152354.95309-2-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210309152354.95309-1-mailhol.vincent@wanadoo.fr>
References: <20210309152354.95309-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a function to set the dynamic queue limit minimum value.

This function is to be used by network drivers which are able to
prove, at least through empirical tests, that they reach better
performances with a specific predefined dql.min_limit value.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 include/linux/dynamic_queue_limits.h | 3 +++
 lib/dynamic_queue_limits.c           | 8 ++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/dynamic_queue_limits.h b/include/linux/dynamic_queue_limits.h
index 407c2f281b64..32437f168a35 100644
--- a/include/linux/dynamic_queue_limits.h
+++ b/include/linux/dynamic_queue_limits.h
@@ -103,6 +103,9 @@ void dql_reset(struct dql *dql);
 /* Initialize dql state */
 void dql_init(struct dql *dql, unsigned int hold_time);
 
+/* Set the dql minimum limit */
+void dql_set_min_limit(struct dql *dql, unsigned int min_limit);
+
 #endif /* _KERNEL_ */
 
 #endif /* _LINUX_DQL_H */
diff --git a/lib/dynamic_queue_limits.c b/lib/dynamic_queue_limits.c
index fde0aa244148..8b6ad1e0a2e3 100644
--- a/lib/dynamic_queue_limits.c
+++ b/lib/dynamic_queue_limits.c
@@ -136,3 +136,11 @@ void dql_init(struct dql *dql, unsigned int hold_time)
 	dql_reset(dql);
 }
 EXPORT_SYMBOL(dql_init);
+
+void dql_set_min_limit(struct dql *dql, unsigned int min_limit)
+{
+#ifdef CONFIG_BQL
+	dql->min_limit = min_limit;
+#endif
+}
+EXPORT_SYMBOL(dql_set_min_limit);
-- 
2.26.2

