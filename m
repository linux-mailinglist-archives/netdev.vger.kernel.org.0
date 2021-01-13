Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFD52F42BD
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 05:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbhAMECF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 23:02:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:48674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726419AbhAMECE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 23:02:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 999ED23134;
        Wed, 13 Jan 2021 04:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610510460;
        bh=z77A4FqxmEQb3l8+v2cJPr8MTYpTtyTN67PWqkJTU8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hPh45XQMniN+5znlk8x6yDI6Lbnq3tl4cgtv1MUpbbh7UsS02yUIrQliKZ+plh4vs
         ZjkXK8daCBiTGRt0o5M5VScI18r+Z/yboROeyW0sDhgdWKjaltzOlFmpqqBEi6AR+S
         8AB5kjGPLm1X6NQK+sQAxrKiCYDo/2Jqlq8OfXgd9y+G2fkYxYaF4pWBu1EuvrSB/B
         X6fGb8eQnfHMjJCwqMWU0c4c+OgcgNJp0SbKQzuC2KiabpB1VQ1JO60JQMPbYsMvdo
         1Ce3A75BS2rn8XD+eeDw8JumoMq7E6UyCmZP5wxe8i1BlPFCUIviOptLP3pVzDNMps
         DDwKZ9Xtb9Aqg==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, schoen@loyalty.org,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next v3 06/13] selftests: Use separate stdout and stderr buffers in nettest
Date:   Tue, 12 Jan 2021 21:00:33 -0700
Message-Id: <20210113040040.50813-7-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20210113040040.50813-1-dsahern@kernel.org>
References: <20210113040040.50813-1-dsahern@kernel.org>
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
index 685cbe8933de..9114bc823092 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -1707,9 +1707,27 @@ static char *random_msg(int len)
 
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

