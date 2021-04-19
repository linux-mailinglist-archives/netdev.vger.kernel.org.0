Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A98364544
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 15:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240434AbhDSNvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 09:51:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55791 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238504AbhDSNvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 09:51:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618840232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nuYFqWuZgWl58fYVoVKeZ4mScVf4y3HHnAqtA2ULG/g=;
        b=fFwR14cuc8s8IX0gk+PCW68R/MbwXCrfBOo92l2mgPRYrPLC6idTr3hV3aRbPB1AcCo7xc
        apDcFKpOcMulbJUyHjpod94JPrG/vRSIrP3XpcDqTIsPDu1EJF6YleAUYEG3ajoio2KybW
        OsvD1SnFWuJU2/LsJEM+0Uj16L1TB6Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-G7AVt9gCNHSEHhEKDBiC_Q-1; Mon, 19 Apr 2021 09:50:31 -0400
X-MC-Unique: G7AVt9gCNHSEHhEKDBiC_Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D5E98143F0;
        Mon, 19 Apr 2021 13:50:30 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-159.ams2.redhat.com [10.36.112.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 24EFD5B4B0;
        Mon, 19 Apr 2021 13:50:28 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2 2/2] lib: bpf_legacy: fix missing socket close when connect() fails
Date:   Mon, 19 Apr 2021 15:49:57 +0200
Message-Id: <0c07eb9675f0f9f4a48a9c99e01a6518c5192d23.1618839527.git.aclaudi@redhat.com>
In-Reply-To: <cover.1618839527.git.aclaudi@redhat.com>
References: <cover.1618839527.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In functions bpf_{send,recv}_map_fds(), when connect fails after a
socket is successfully opened, we return with error missing a close on
the socket.

Fix this closing the socket if opened and using a single return point
for both the functions.

Fixes: 6256f8c9e45f ("tc, bpf: finalize eBPF support for cls and act front-end")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 lib/bpf_legacy.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/lib/bpf_legacy.c b/lib/bpf_legacy.c
index 7ff10e4f..7ec9ce9d 100644
--- a/lib/bpf_legacy.c
+++ b/lib/bpf_legacy.c
@@ -3092,13 +3092,13 @@ int bpf_send_map_fds(const char *path, const char *obj)
 		.st  = &ctx->stat,
 		.obj = obj,
 	};
-	int fd, ret;
+	int fd, ret = -1;
 
 	fd = socket(AF_UNIX, SOCK_DGRAM, 0);
 	if (fd < 0) {
 		fprintf(stderr, "Cannot open socket: %s\n",
 			strerror(errno));
-		return -1;
+		goto out;
 	}
 
 	strlcpy(addr.sun_path, path, sizeof(addr.sun_path));
@@ -3107,7 +3107,7 @@ int bpf_send_map_fds(const char *path, const char *obj)
 	if (ret < 0) {
 		fprintf(stderr, "Cannot connect to %s: %s\n",
 			path, strerror(errno));
-		return -1;
+		goto out;
 	}
 
 	ret = bpf_map_set_send(fd, &addr, sizeof(addr), &bpf_aux,
@@ -3117,7 +3117,9 @@ int bpf_send_map_fds(const char *path, const char *obj)
 			path, strerror(errno));
 
 	bpf_maps_teardown(ctx);
-	close(fd);
+out:
+	if (fd >= 0)
+		close(fd);
 	return ret;
 }
 
@@ -3125,13 +3127,13 @@ int bpf_recv_map_fds(const char *path, int *fds, struct bpf_map_aux *aux,
 		     unsigned int entries)
 {
 	struct sockaddr_un addr = { .sun_family = AF_UNIX };
-	int fd, ret;
+	int fd, ret = -1;
 
 	fd = socket(AF_UNIX, SOCK_DGRAM, 0);
 	if (fd < 0) {
 		fprintf(stderr, "Cannot open socket: %s\n",
 			strerror(errno));
-		return -1;
+		goto out;
 	}
 
 	strlcpy(addr.sun_path, path, sizeof(addr.sun_path));
@@ -3140,7 +3142,7 @@ int bpf_recv_map_fds(const char *path, int *fds, struct bpf_map_aux *aux,
 	if (ret < 0) {
 		fprintf(stderr, "Cannot bind to socket: %s\n",
 			strerror(errno));
-		return -1;
+		goto out;
 	}
 
 	ret = bpf_map_set_recv(fd, fds, aux, entries);
@@ -3149,7 +3151,10 @@ int bpf_recv_map_fds(const char *path, int *fds, struct bpf_map_aux *aux,
 			path, strerror(errno));
 
 	unlink(addr.sun_path);
-	close(fd);
+
+out:
+	if (fd >= 0)
+		close(fd);
 	return ret;
 }
 
-- 
2.30.2

