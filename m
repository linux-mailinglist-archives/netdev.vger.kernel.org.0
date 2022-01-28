Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E156249F7A7
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 11:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347926AbiA1Ky2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 05:54:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38881 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244101AbiA1Ky1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 05:54:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643367266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1OQl7XkliQ4yNH+1O9433V+T3kmdHJRLmXsz6UCb4Nw=;
        b=UftmFMP1Dr2E0WrGZtGf31wKFnjeRToi92grI7PIHXxdX0mD6SJRVjA9P/twtL1oh8O2dS
        vLxlUovEa4BbvxB2w9Uozqo7pflk6EgjnChS+kwZVtMaOUVMOaPO7NsV/Gn3p8AaTo98vk
        DKHyfFHU2aGT0EzgdziTJKbwl+3QMOM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-222-z3ZxYjiWMJe4RI12KPOz8g-1; Fri, 28 Jan 2022 05:54:23 -0500
X-MC-Unique: z3ZxYjiWMJe4RI12KPOz8g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D71F1923E22;
        Fri, 28 Jan 2022 10:54:22 +0000 (UTC)
Received: from tc2.station (unknown [10.39.195.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8430D1F451;
        Fri, 28 Jan 2022 10:54:21 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2] ss: use freecon() instead of free() when appropriate
Date:   Fri, 28 Jan 2022 11:53:58 +0100
Message-Id: <db01fe572f2ecd8720debf06d2b263f93e5fd205.1643367186.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to SELinux API, when resources are allocated using getpidcon()
of getfilecon(), they should be freed using freecon().

This commit makes ss use freecon() where appropriate, defining a stub
function executing a free() useful when iproute2 is compiled without
SELinux support.

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 misc/ss.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/misc/ss.c b/misc/ss.c
index b39f63fe..f7d36914 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -97,6 +97,11 @@ static int security_get_initial_context(char *name,  char **context)
 	*context = NULL;
 	return -1;
 }
+
+static void freecon(char *context)
+{
+	free(context);
+}
 #endif
 
 int preferred_family = AF_UNSPEC;
@@ -618,7 +623,7 @@ static void user_ent_hash_build(void)
 		snprintf(name + nameoff, sizeof(name) - nameoff, "%d/fd/", pid);
 		pos = strlen(name);
 		if ((dir1 = opendir(name)) == NULL) {
-			free(pid_context);
+			freecon(pid_context);
 			continue;
 		}
 
@@ -667,9 +672,9 @@ static void user_ent_hash_build(void)
 			}
 			user_ent_add(ino, p, pid, fd,
 					pid_context, sock_context);
-			free(sock_context);
+			freecon(sock_context);
 		}
-		free(pid_context);
+		freecon(pid_context);
 		closedir(dir1);
 	}
 	closedir(dir);
@@ -4725,7 +4730,7 @@ static int netlink_show_one(struct filter *f,
 			getpidcon(pid, &pid_context);
 
 		out(" proc_ctx=%s", pid_context ? : "unavailable");
-		free(pid_context);
+		freecon(pid_context);
 	}
 
 	if (show_details) {
-- 
2.34.1

