Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785AE321565
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 12:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhBVLsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 06:48:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26991 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230144AbhBVLrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 06:47:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613994372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=L6mN7doHXzloP4gWDCdNpN3ylnoo/urvoAJwToU266c=;
        b=EMQv1Ip6MYEWiqA0MRRCe0QaS9sP9TDp6WsiRkgB+PP0CWC9SEc0uGuKlpLxgsWzoxBbMZ
        0IPuwyw5SYLIUA53IE2hECPQD6CvyCRMCj+DOmNkp14Jn+R3Kl0pWzA1s9j+7ArXNteeep
        97gBlGpT+dSrsc069+V6V4JhisMWJWI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-rKew35hfPxeFRsz6E2brNQ-1; Mon, 22 Feb 2021 06:46:10 -0500
X-MC-Unique: rKew35hfPxeFRsz6E2brNQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B5FDB1934100;
        Mon, 22 Feb 2021 11:46:09 +0000 (UTC)
Received: from localhost.localdomain (ovpn-115-141.ams2.redhat.com [10.36.115.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D584D60622;
        Mon, 22 Feb 2021 11:46:08 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2] lib/namespace: fix ip -all netns return code
Date:   Mon, 22 Feb 2021 12:40:36 +0100
Message-Id: <c6b4c6811f761103ae79ec8a06ae694b65f40317.1613916538.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When ip -all netns {del,exec} are called and no netns is present, ip
exit with status 0. However this does not happen if no netns has been
created since boot time: in that case, indeed, the NETNS_RUN_DIR is not
present and netns_foreach() exit with code 1.

$ ls /var/run/netns
ls: cannot access '/var/run/netns': No such file or directory
$ ip -all netns exec ip link show
$ echo $?
1
$ ip -all netns del
$ echo $?
1
$ ip netns add test
$ ip netns del test
$ ip -all netns del
$ echo $?
0
$ ls -a /var/run/netns
.  ..

This leaves us in the unpleasant situation where the same command, when
no netns is present, does the same stuff (in this case, nothing), but
exit with two different statuses.

Fix this treating ENOENT in a different way from other errors, similarly
to what we already do in ipnetns.c netns_identify_pid()

Fixes: e998e118ddc3 ("lib: Exec func on each netns")
Reported-by: Jianlin Shi <jishi@redhat.com>
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 lib/namespace.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/lib/namespace.c b/lib/namespace.c
index 06ae0a48..45a7dedd 100644
--- a/lib/namespace.c
+++ b/lib/namespace.c
@@ -122,8 +122,14 @@ int netns_foreach(int (*func)(char *nsname, void *arg), void *arg)
 	struct dirent *entry;
 
 	dir = opendir(NETNS_RUN_DIR);
-	if (!dir)
+	if (!dir) {
+		if (errno == ENOENT)
+			return 0;
+
+		fprintf(stderr, "Failed to open directory %s: %s\n",
+			NETNS_RUN_DIR, strerror(errno));
 		return -1;
+	}
 
 	while ((entry = readdir(dir)) != NULL) {
 		if (strcmp(entry->d_name, ".") == 0)
-- 
2.29.2

