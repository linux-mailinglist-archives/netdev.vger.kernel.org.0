Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C432F58FB
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbhANDLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 22:11:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:53062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727521AbhANDLS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 22:11:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C285B23787;
        Thu, 14 Jan 2021 03:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610593800;
        bh=vUaYP8Hi9hjLrmV7JP5BErEhnxwbLhof13DtOQujLX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VSqoe1f6mt60GjMW05GF7wG26L8f+2wI0BPV2YBlhtKUhK0QLcsCn7xQRgWmpT5i/
         pPDyHZoek3nsg7L1j9VvBNzGDnaMrzJhBh2UHPrGfAlDy0PoXFv2Tqnn3DG4qb3jIa
         t2NFDilXRV4Yt3v+57TWp4FwSmiUvpOZr4kw5GbOAlzJXekFNPP2PIgexPobDHXi5T
         NX18nYjYS6IkFayqtI6zA6y8evVlLsjKOhDQPVEJmCvrQWn80yEHQqZlvWb3+Koh2b
         G+KOp2yCRwusiCvyPtYK83dUufM/PFa82HB7GQSo4GAchFgUzwREL2/9oHdJIQV9dT
         Cjo7RTQscQTIQ==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, schoen@loyalty.org,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next v4 06/13] selftests: Use separate stdout and stderr buffers in nettest
Date:   Wed, 13 Jan 2021 20:09:42 -0700
Message-Id: <20210114030949.54425-7-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20210114030949.54425-1-dsahern@kernel.org>
References: <20210114030949.54425-1-dsahern@kernel.org>
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
 tools/testing/selftests/net/nettest.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index 685cbe8933de..aba3615ce977 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -1707,9 +1707,28 @@ static char *random_msg(int len)
 
 static int ipc_child(int fd, struct sock_args *args)
 {
+	char *outbuf, *errbuf;
+	int rc = 1;
+
+	outbuf = malloc(4096);
+	errbuf = malloc(4096);
+	if (!outbuf || !errbuf) {
+		fprintf(stderr, "server: Failed to allocate buffers for stdout and stderr\n");
+		goto out;
+	}
+
+	setbuffer(stdout, outbuf, 4096);
+	setbuffer(stderr, errbuf, 4096);
+
 	server_mode = 1; /* to tell log_msg in case we are in both_mode */
 
-	return do_server(args, fd);
+	rc = do_server(args, fd);
+
+out:
+	free(outbuf);
+	free(errbuf);
+
+	return rc;
 }
 
 static int ipc_parent(int cpid, int fd, struct sock_args *args)
-- 
2.24.3 (Apple Git-128)

