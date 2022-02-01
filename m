Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 764764A62B1
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 18:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241464AbiBARkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 12:40:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51109 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241585AbiBARkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 12:40:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643737218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y04lGEKjC/hmo1MyxrvxM+WIGyydNovofQoZFDBLn54=;
        b=TljBxXn1l62+GT7PEG2LbxIRwB/1bOl9TNkoDr9NyLUFiG1z3bZ4yjXv0tt0ViF+M2Il0j
        BkNE3NAuUehd60SzcPPQDRABm8Wc/GklwIRd03B/9v8QOhZGoXXLeE8XRlLYIiZY9KjJ1Z
        w9SjDPXGWRmnuWjTDoZ0G9Qu+gWoeaE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-jnGFxkrBM_mvHvbhVT8IOQ-1; Tue, 01 Feb 2022 12:40:16 -0500
X-MC-Unique: jnGFxkrBM_mvHvbhVT8IOQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B404810144E3;
        Tue,  1 Feb 2022 17:39:53 +0000 (UTC)
Received: from tc2.redhat.com (unknown [10.39.195.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E65DD1903;
        Tue,  1 Feb 2022 17:39:52 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com,
        markzhang@nvidia.com, leonro@nvidia.com
Subject: [PATCH iproute2 1/3] lib/fs: fix memory leak in get_task_name()
Date:   Tue,  1 Feb 2022 18:39:24 +0100
Message-Id: <c7d57346ddc4d9eaaabc0f004911d038c95238af.1643736038.git.aclaudi@redhat.com>
In-Reply-To: <cover.1643736038.git.aclaudi@redhat.com>
References: <cover.1643736038.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

asprintf() allocates memory which is not freed on the error path of
get_task_name(), thus potentially leading to memory leaks.

This commit fixes this using free() on error paths.

Fixes: 81bfd01a4c9e ("lib: move get_task_name() from rdma")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 lib/fs.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/lib/fs.c b/lib/fs.c
index f6f5f8a0..5692e2d3 100644
--- a/lib/fs.c
+++ b/lib/fs.c
@@ -354,11 +354,15 @@ char *get_task_name(pid_t pid)
 		return NULL;
 
 	f = fopen(comm, "r");
-	if (!f)
+	if (!f) {
+		free(comm);
 		return NULL;
+	}
 
-	if (fscanf(f, "%ms\n", &comm) != 1)
-		comm = NULL;
+	if (fscanf(f, "%ms\n", &comm) != 1) {
+		free(comm);
+		return NULL;
+	}
 
 	fclose(f);
 
-- 
2.34.1

