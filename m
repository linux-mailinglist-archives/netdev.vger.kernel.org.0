Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3742F0484
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 01:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbhAJATh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 19:19:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:52636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbhAJATg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 19:19:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C964D2389B;
        Sun, 10 Jan 2021 00:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610237936;
        bh=AXL/SfAhp3iipMrDDhPgxZ5OeO7xe0IeTSwbThZ9jfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VDptoICBnnljPOMxnjhzkCIg35f4ekGt1VuV2Ny0cXpgy0FTaNviDtHFzCTPDouee
         ybMcdB3WqRdxNZYws7EY1oSHXnpxh21BZfS3H4ld221yYiwKkxhXF+8FlLLO5nhlAj
         7XR5PtVljUWQti8WpUOg4Lj34s7ZAAySWYIBCaNCvzIQ7n4U8r24r7jrDouM3ICpCa
         s3in82nZ01lFxEkCkOnWJN2SyM4KzOIDi1wlsBhwDwngSwn8LIS/yJQJfpMKMTaweQ
         3zUtk0cyPCd68GevEEdLl05iwSicHuMnGwFdRiGmsZejOf4t63gvvXEV2Z7C2Ay9Uv
         RtFvkwDJtx9fQ==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, schoen@loyalty.org,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next v2 01/11] selftests: Move device validation in nettest
Date:   Sat,  9 Jan 2021 17:18:42 -0700
Message-Id: <20210110001852.35653-2-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20210110001852.35653-1-dsahern@kernel.org>
References: <20210110001852.35653-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Later patch adds support for switching network namespaces before
running client, server or both. Device validations need to be
done after the network namespace switch, so add a helper to do it
and invoke in server and client code versus inline with argument
parsing. Move related argument checks as well.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/nettest.c | 64 ++++++++++++++++++---------
 1 file changed, 42 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index f75c53ce0a2d..2bb06a3e6880 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -84,6 +84,7 @@ struct sock_args {
 	unsigned int prefix_len;
 
 	/* expected addresses and device index for connection */
+	const char *expected_dev;
 	int expected_ifindex;
 
 	/* local address */
@@ -522,6 +523,33 @@ static int str_to_uint(const char *str, int min, int max, unsigned int *value)
 	return -1;
 }
 
+static int resolve_devices(struct sock_args *args)
+{
+	if (args->dev) {
+		args->ifindex = get_ifidx(args->dev);
+		if (args->ifindex < 0) {
+			log_error("Invalid device name\n");
+			return 1;
+		}
+	}
+
+	if (args->expected_dev) {
+		unsigned int tmp;
+
+		if (str_to_uint(args->expected_dev, 0, INT_MAX, &tmp) == 0) {
+			args->expected_ifindex = (int)tmp;
+		} else {
+			args->expected_ifindex = get_ifidx(args->expected_dev);
+			if (args->expected_ifindex < 0) {
+				fprintf(stderr, "Invalid expected device\n");
+				return 1;
+			}
+		}
+	}
+
+	return 0;
+}
+
 static int expected_addr_match(struct sockaddr *sa, void *expected,
 			       const char *desc)
 {
@@ -1190,6 +1218,9 @@ static int do_server(struct sock_args *args)
 	fd_set rfds;
 	int rc;
 
+	if (resolve_devices(args))
+		return 1;
+
 	if (prog_timeout)
 		ptval = &timeout;
 
@@ -1375,6 +1406,16 @@ static int do_client(struct sock_args *args)
 		return 1;
 	}
 
+	if (resolve_devices(args))
+		return 1;
+
+	if ((args->use_setsockopt || args->use_cmsg) && !args->ifindex) {
+		fprintf(stderr, "Device binding not specified\n");
+		return 1;
+	}
+	if (args->use_setsockopt || args->use_cmsg)
+		args->dev = NULL;
+
 	switch (args->version) {
 	case AF_INET:
 		sin.sin_port = htons(args->port);
@@ -1703,11 +1744,6 @@ int main(int argc, char *argv[])
 			break;
 		case 'd':
 			args.dev = optarg;
-			args.ifindex = get_ifidx(optarg);
-			if (args.ifindex < 0) {
-				fprintf(stderr, "Invalid device name\n");
-				return 1;
-			}
 			break;
 		case 'i':
 			interactive = 1;
@@ -1738,16 +1774,7 @@ int main(int argc, char *argv[])
 
 			break;
 		case '2':
-			if (str_to_uint(optarg, 0, INT_MAX, &tmp) == 0) {
-				args.expected_ifindex = (int)tmp;
-			} else {
-				args.expected_ifindex = get_ifidx(optarg);
-				if (args.expected_ifindex < 0) {
-					fprintf(stderr,
-						"Invalid expected device\n");
-					return 1;
-				}
-			}
+			args.expected_dev = optarg;
 			break;
 		case 'q':
 			quiet = 1;
@@ -1769,13 +1796,6 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
-	if ((args.use_setsockopt || args.use_cmsg) && !args.ifindex) {
-		fprintf(stderr, "Device binding not specified\n");
-		return 1;
-	}
-	if (args.use_setsockopt || args.use_cmsg)
-		args.dev = NULL;
-
 	if (iter == 0) {
 		fprintf(stderr, "Invalid number of messages to send\n");
 		return 1;
-- 
2.24.3 (Apple Git-128)

