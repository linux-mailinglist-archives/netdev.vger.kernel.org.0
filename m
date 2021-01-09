Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF8452F02F0
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 19:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbhAISzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 13:55:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:46784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbhAISzX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 13:55:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 857A4239E5;
        Sat,  9 Jan 2021 18:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610218450;
        bh=8zbVRxGf2M4Osm7pxjgzY7XF3L0l0RzuiM80vqBm6r0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o6W5CsUjqTeHjUGlDC9nhz89uoZQIZD/IlO+hDfLfE3d8R2Yp7ASrhX/raitxvrO7
         vtSS5nIuWFp0TMoYxp30nrTENBnYanRILKN4hW/P4W3e5z4heb8nga1UWk4VIxYOhy
         gmgPrSsp6Lv9al9XwxgxBo+PSFw59WN20gtpImCPgPmwgKmwe4991cLkbYKXtEpVUd
         mS6dCX1qmkFUMNlM5hjXb8KU62/ySJhBv7bzz0D6aC55d0U+WFQY+KN06VEPMkD4m1
         FdHCe1eHYXUkpqNeeT7oYEDOaY0/PlL8FS5zrV07wdICRhVyuxqJOMnPOE35parsUa
         j4mJJ4KVWRY6Q==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, schoen@loyalty.org,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 06/11] selftests: Use separate stdout and stderr buffers in nettest
Date:   Sat,  9 Jan 2021 11:53:53 -0700
Message-Id: <20210109185358.34616-7-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20210109185358.34616-1-dsahern@kernel.org>
References: <20210109185358.34616-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

When a single instance of nettest is doing both client and
server modes, stdout and stderr messages can get interlaced
and become unreadable. Allocate a new set of buffers for the
child process handling server mode.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/nettest.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index 176709eb8b16..ab3e268c12a9 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -1705,9 +1705,27 @@ static char *random_msg(int len)
 
 static int ipc_child(int fd, struct sock_args *args)
 {
+	char *outbuf, *errbuf;
+	int rc;
+
+	outbuf = malloc(4096);
+	errbuf = malloc(4096);
+	if (!outbuf || !errbuf) {
+		fprintf(stderr, "server: Failed to allocate buffers for stdout and stderr\n");
+		return 1;
+	}
+
+	setbuffer(stdout, outbuf, 4096);
+	setbuffer(stderr, errbuf, 4096);
+
 	server_mode = 1; /* to tell log_msg in case we are in both_mode */
 
-	return do_server(args, fd);
+	rc = do_server(args, fd);
+
+	free(outbuf);
+	free(errbuf);
+
+	return rc;
 }
 
 static int ipc_parent(int cpid, int fd, struct sock_args *args)
-- 
2.24.3 (Apple Git-128)

