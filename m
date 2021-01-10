Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F102F0488
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 01:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbhAJAUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 19:20:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:52786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbhAJAUQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 19:20:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF52F2388E;
        Sun, 10 Jan 2021 00:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610237939;
        bh=ppmmOSJFy36hpgY0WZy1gnJNRRD2LhWm17mpL121yIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OPvyOao/Z6fSirm4hqFCcxbFGfw1c7sNc88DosDZr6sRylUTSyZkb3IJ+oYtK2MNe
         SHTumHXeZdvv6JnC/VuXrE9+zMNYJdPxo5Q3LIPXCYfOIfmadMmSvbDTgmV4LA8V8E
         qLTEObm4A+Yc3pIpWN+gmxQtc4OJ0o4TSLfnK6eIOOQzjdgUmfv+EvrGp27Gn4Gxzn
         9B6Vwq0M00HTSjHVI6mE1jvwLR+8H7H+D94Jdt62ihtLnoHPXTAXNqCPvHHK+6TwXE
         r16HvvfLbD1KHdD9WqRL2ETIT+PzxIdMq7lDIOyoTokw1W9u4J7hR0ZMdnz6PoTyfN
         bDHoSC1IT/q3Q==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, schoen@loyalty.org,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next v2 06/11] selftests: Use separate stdout and stderr buffers in nettest
Date:   Sat,  9 Jan 2021 17:18:47 -0700
Message-Id: <20210110001852.35653-7-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20210110001852.35653-1-dsahern@kernel.org>
References: <20210110001852.35653-1-dsahern@kernel.org>
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
index 0e4196027d63..13c74774e357 100644
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

