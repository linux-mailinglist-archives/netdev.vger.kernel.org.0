Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1488636452F
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 15:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242020AbhDSNmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 09:42:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44086 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242347AbhDSNid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 09:38:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618839483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rs8GHvEawg6tRUwjRhjrusXlH8dSiQinI4lZMgAt53s=;
        b=ElYcES5Ha8O1ubI215lrdkCO/dft7QLrjgy+75YIb62oqfAAYe3gB2nTbRQY+bACstBnrR
        gEIF4SzKlCBYYMRb2warDaPfTsh31wL7I01YMMe0jPOugLsQ4soaDKQ3ks8Id9+zh2DNpk
        Tck5LFHP7bMQ3DF5ZCgfxU9Xv8Kx6KM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-597-iqNZd4YnMya2Z8jlTgc9Aw-1; Mon, 19 Apr 2021 09:38:01 -0400
X-MC-Unique: iqNZd4YnMya2Z8jlTgc9Aw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C731310054F6;
        Mon, 19 Apr 2021 13:37:59 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-159.ams2.redhat.com [10.36.112.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E680D5D9C0;
        Mon, 19 Apr 2021 13:37:58 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2] ip: netns: fix missing netns close on some error paths
Date:   Mon, 19 Apr 2021 15:37:25 +0200
Message-Id: <b802d516accfe4b8fcf217bd4e9e992fbc59e64f.1618839246.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In functions netns_pids() and netns_identify_pid(), the netns file is
not closed on some error paths.

Fix this using a conditional close and a single return point on both
functions.

Fixes: 44b563269ea1 ("ip-nexthop: support flush by id")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 ip/ipnetns.c | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/ip/ipnetns.c b/ip/ipnetns.c
index 3e96d267..12035349 100644
--- a/ip/ipnetns.c
+++ b/ip/ipnetns.c
@@ -579,18 +579,18 @@ static int netns_pids(int argc, char **argv)
 {
 	const char *name;
 	char net_path[PATH_MAX];
-	int netns;
+	int netns = -1, ret = -1;
 	struct stat netst;
 	DIR *dir;
 	struct dirent *entry;
 
 	if (argc < 1) {
 		fprintf(stderr, "No netns name specified\n");
-		return -1;
+		goto out;
 	}
 	if (argc > 1) {
 		fprintf(stderr, "extra arguments specified\n");
-		return -1;
+		goto out;
 	}
 
 	name = argv[0];
@@ -599,18 +599,18 @@ static int netns_pids(int argc, char **argv)
 	if (netns < 0) {
 		fprintf(stderr, "Cannot open network namespace: %s\n",
 			strerror(errno));
-		return -1;
+		goto out;
 	}
 	if (fstat(netns, &netst) < 0) {
 		fprintf(stderr, "Stat of netns failed: %s\n",
 			strerror(errno));
-		return -1;
+		goto out;
 	}
 	dir = opendir("/proc/");
 	if (!dir) {
 		fprintf(stderr, "Open of /proc failed: %s\n",
 			strerror(errno));
-		return -1;
+		goto out;
 	}
 	while ((entry = readdir(dir))) {
 		char pid_net_path[PATH_MAX];
@@ -627,15 +627,19 @@ static int netns_pids(int argc, char **argv)
 			printf("%s\n", entry->d_name);
 		}
 	}
+	ret = 0;
 	closedir(dir);
-	return 0;
+out:
+	if (netns >= 0)
+		close(netns);
+	return ret;
 
 }
 
 int netns_identify_pid(const char *pidstr, char *name, int len)
 {
 	char net_path[PATH_MAX];
-	int netns;
+	int netns = -1, ret = -1;
 	struct stat netst;
 	DIR *dir;
 	struct dirent *entry;
@@ -647,22 +651,24 @@ int netns_identify_pid(const char *pidstr, char *name, int len)
 	if (netns < 0) {
 		fprintf(stderr, "Cannot open network namespace: %s\n",
 			strerror(errno));
-		return -1;
+		goto out;
 	}
 	if (fstat(netns, &netst) < 0) {
 		fprintf(stderr, "Stat of netns failed: %s\n",
 			strerror(errno));
-		return -1;
+		goto out;
 	}
 	dir = opendir(NETNS_RUN_DIR);
 	if (!dir) {
 		/* Succeed treat a missing directory as an empty directory */
-		if (errno == ENOENT)
-			return 0;
+		if (errno == ENOENT) {
+			ret = 0;
+			goto out;
+		}
 
 		fprintf(stderr, "Failed to open directory %s:%s\n",
 			NETNS_RUN_DIR, strerror(errno));
-		return -1;
+		goto out;
 	}
 
 	while ((entry = readdir(dir))) {
@@ -685,8 +691,12 @@ int netns_identify_pid(const char *pidstr, char *name, int len)
 			strlcpy(name, entry->d_name, len);
 		}
 	}
+	ret = 0;
 	closedir(dir);
-	return 0;
+out:
+	if (netns >= 0)
+		close(netns);
+	return ret;
 
 }
 
-- 
2.30.2

