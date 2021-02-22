Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14EB6321F17
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 19:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbhBVSWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 13:22:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28666 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232394AbhBVSV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 13:21:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614018002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=77O8dSXMdWHkv4MTs443H2Uihx057ilNee9Auo5qZRc=;
        b=f2sJnfdG/XqzlAwF9/DswV/XPFlKZ8ozedEboJSF8KwnycOJbGNYYK9q9clb+vZlDHKK+D
        c6Mue+yNiDnENgZOFmKGI/vdeNCZ4Oik6yUVltu0pCgzXC5TA2FhUOK/j35rqVr23hh0I9
        lVghCDeh6lWoqVlnmKyujrqXWZhQbts=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-dyXNqRXTOEWo6ep7T_T0pQ-1; Mon, 22 Feb 2021 13:20:00 -0500
X-MC-Unique: dyXNqRXTOEWo6ep7T_T0pQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75AF4107ACE8;
        Mon, 22 Feb 2021 18:19:59 +0000 (UTC)
Received: from localhost.localdomain (ovpn-115-141.ams2.redhat.com [10.36.115.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F0731001281;
        Mon, 22 Feb 2021 18:19:58 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2 v2 2/2] lib/fs: Fix single return points for get_cgroup2_*
Date:   Mon, 22 Feb 2021 19:14:32 +0100
Message-Id: <f02b1bb76fbcd8691e2d511ca5f0487ab717dbda.1614016514.git.aclaudi@redhat.com>
In-Reply-To: <cover.1614016514.git.aclaudi@redhat.com>
References: <cover.1614016514.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Functions get_cgroup2_id() and get_cgroup2_path() may call close() with
a negative argument.
Avoid that making the calls conditional on the file descriptors.

get_cgroup2_path() may also return NULL leaking a file descriptor.
Ensure this does not happen using a single return point.

Fixes: d5e6ee0dac64 ("ss: introduce cgroup2 cache and helper functions")
Fixes: 8f1cd119b377 ("lib: fix checking of returned file handle size for cgroup")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 lib/fs.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/lib/fs.c b/lib/fs.c
index 2ae506ec..ee0b130b 100644
--- a/lib/fs.c
+++ b/lib/fs.c
@@ -157,7 +157,8 @@ __u64 get_cgroup2_id(const char *path)
 	memcpy(cg_id.bytes, fhp->f_handle, sizeof(__u64));
 
 out:
-	close(mnt_fd);
+	if (mnt_fd >= 0)
+		close(mnt_fd);
 	free(mnt);
 
 	return cg_id.id;
@@ -179,16 +180,16 @@ char *get_cgroup2_path(__u64 id, bool full)
 	char *path = NULL;
 	char fd_path[64];
 	int link_len;
-	char *mnt;
+	char *mnt = NULL;
 
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
@@ -225,8 +226,10 @@ char *get_cgroup2_path(__u64 id, bool full)
 			"Failed to allocate memory for cgroup2 path\n");
 
 out:
-	close(fd);
-	close(mnt_fd);
+	if (fd >= 0)
+		close(fd);
+	if (mnt_fd >= 0)
+		close(mnt_fd);
 	free(mnt);
 
 	return path;
-- 
2.29.2

