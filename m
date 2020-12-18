Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCEE2DE9A8
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 20:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733183AbgLRTQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 14:16:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39295 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733170AbgLRTQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 14:16:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608318874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1A5KnGNmwF5n0yn9HURhvCq30IxDsuKeH4KfEcyOkvs=;
        b=M6NJ4dud4pFblN/TvN3LoG3/DRs42S9+AXw2fmqU1XbEMJeNsBYXwqNyVZgzsbN++kKJyd
        rRIZYYmZW6pXNIVDShNKrQI+c45Uv/VclReiLT7zDrvlxHoFqGQBc/xaAlO+r6OA6vc5xO
        RL8ozbA44t8pAR+bE04/APHBbK1CtTM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-GvrgJq7WPmehweBZcBw9qA-1; Fri, 18 Dec 2020 14:14:33 -0500
X-MC-Unique: GvrgJq7WPmehweBZcBw9qA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 399E4802B40;
        Fri, 18 Dec 2020 19:14:32 +0000 (UTC)
Received: from localhost.localdomain (ovpn-114-0.ams2.redhat.com [10.36.114.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 655C12C01B;
        Fri, 18 Dec 2020 19:14:31 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2 2/2] lib/fs: Fix single return points for get_cgroup2_*
Date:   Fri, 18 Dec 2020 20:09:23 +0100
Message-Id: <9b07b59c4c422b29d6c8297f7f7ec0f2dcc7fb3f.1608315719.git.aclaudi@redhat.com>
In-Reply-To: <cover.1608315719.git.aclaudi@redhat.com>
References: <cover.1608315719.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Functions get_cgroup2_id() and get_cgroup2_path() uncorrectly performs
cleanup on the single return point. Both of them may get to use close()
with a negative argument, if open() fails.

Fix this adding proper labels and gotos to make sure we clean up only
resources we are effectively used before.

Fixes: d5e6ee0dac64 ("ss: introduce cgroup2 cache and helper functions")
Fixes: 8f1cd119b377 ("lib: fix checking of returned file handle size for cgroup")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 lib/fs.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/lib/fs.c b/lib/fs.c
index 2ae506ec..77414e99 100644
--- a/lib/fs.c
+++ b/lib/fs.c
@@ -139,27 +139,31 @@ __u64 get_cgroup2_id(const char *path)
 		mnt_fd = open(mnt, O_RDONLY);
 		if (mnt_fd < 0) {
 			fprintf(stderr, "Failed to open cgroup2 mount\n");
-			goto out;
+			goto out_clean_mnt;
 		}
 
 		fhp->handle_bytes = sizeof(__u64);
 		if (name_to_handle_at(mnt_fd, path, fhp, &mnt_id, 0) < 0) {
 			fprintf(stderr, "Failed to get cgroup2 ID: %s\n",
 					strerror(errno));
-			goto out;
+			goto out_clean_all;
 		}
 	}
 	if (fhp->handle_bytes != sizeof(__u64)) {
 		fprintf(stderr, "Invalid size of cgroup2 ID\n");
-		goto out;
+		if (mnt_fd < 0)
+			goto out;
+		goto out_clean_all;
 	}
 
 	memcpy(cg_id.bytes, fhp->f_handle, sizeof(__u64));
 
-out:
+out_clean_all:
 	close(mnt_fd);
+out_clean_mnt:
 	free(mnt);
 
+out:
 	return cg_id.id;
 }
 
@@ -183,17 +187,17 @@ char *get_cgroup2_path(__u64 id, bool full)
 
 	if (!id) {
 		fprintf(stderr, "Invalid cgroup2 ID\n");
-		return NULL;
+		goto out;
 	}
 
 	mnt = find_cgroup2_mount(false);
 	if (!mnt)
-		return NULL;
+		goto out;
 
 	mnt_fd = open(mnt, O_RDONLY);
 	if (mnt_fd < 0) {
 		fprintf(stderr, "Failed to open cgroup2 mount\n");
-		goto out;
+		goto out_clean_mnt;
 	}
 
 	fhp->handle_bytes = sizeof(__u64);
@@ -203,7 +207,7 @@ char *get_cgroup2_path(__u64 id, bool full)
 	fd = open_by_handle_at(mnt_fd, fhp, 0);
 	if (fd < 0) {
 		fprintf(stderr, "Failed to open cgroup2 by ID\n");
-		goto out;
+		goto out_clean_mntfd;
 	}
 
 	snprintf(fd_path, sizeof(fd_path), "/proc/self/fd/%d", fd);
@@ -212,7 +216,7 @@ char *get_cgroup2_path(__u64 id, bool full)
 		fprintf(stderr,
 			"Failed to read value of symbolic link %s\n",
 			fd_path);
-		goto out;
+		goto out_clean_all;
 	}
 	link_buf[link_len] = '\0';
 
@@ -224,11 +228,14 @@ char *get_cgroup2_path(__u64 id, bool full)
 		fprintf(stderr,
 			"Failed to allocate memory for cgroup2 path\n");
 
-out:
+out_clean_all:
 	close(fd);
+out_clean_mntfd:
 	close(mnt_fd);
+out_clean_mnt:
 	free(mnt);
 
+out:
 	return path;
 }
 
-- 
2.29.2

