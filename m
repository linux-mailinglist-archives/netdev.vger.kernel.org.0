Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA0422F02EC
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 19:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbhAISyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 13:54:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:46664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbhAISyp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 13:54:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 224A3239A4;
        Sat,  9 Jan 2021 18:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610218444;
        bh=PIpDU/5vI9LiiHwZu2LAm6kiJ3JUGGMhfCQy+iaTPcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z03lL8ZKS7q3AM6kdRkoaAh6iHCfEbGHu326pZasy1yxvpPHH6un7FRY9BU42/6kU
         M4Ei2g9mf66wZcYMgD36N74yPtfMO4IvwvHcgcztEtPL6HamnTRSiKzsWWe0/iQKVZ
         AXDJ2t4pd5PVgnW8yqz3Lq0x6MQwP7aoIKB7TvWaDIYPIT1wbBfuYFCnimXHoUFCtg
         sZTQOqHoN673qTawB9bKZkl8lsg9sFltOEmnIDsUOUY2IthyM1ZHqxRDdcRXok8uld
         SyXpwNz/EghXwNhCODCB+ZidylwlAfXfqeDHqLqA5C4brUi5xYqjTW+lbw8wpIM3b3
         +vgdSsJSnQA0Q==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, schoen@loyalty.org,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 02/11] selftests: Move convert_addr up in nettest
Date:   Sat,  9 Jan 2021 11:53:49 -0700
Message-Id: <20210109185358.34616-3-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20210109185358.34616-1-dsahern@kernel.org>
References: <20210109185358.34616-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

convert_addr needs to be invoked in a different location. Move
the code up to avoid a forward declaration.

Code move only.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/nettest.c | 252 +++++++++++++-------------
 1 file changed, 126 insertions(+), 126 deletions(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index 2bb06a3e6880..337ae54e252d 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -627,6 +627,132 @@ static int show_sockstat(int sd, struct sock_args *args)
 	return rc;
 }
 
+enum addr_type {
+	ADDR_TYPE_LOCAL,
+	ADDR_TYPE_REMOTE,
+	ADDR_TYPE_MCAST,
+	ADDR_TYPE_EXPECTED_LOCAL,
+	ADDR_TYPE_EXPECTED_REMOTE,
+	ADDR_TYPE_MD5_PREFIX,
+};
+
+static int convert_addr(struct sock_args *args, const char *_str,
+			enum addr_type atype)
+{
+	int pfx_len_max = args->version == AF_INET6 ? 128 : 32;
+	int family = args->version;
+	char *str, *dev, *sep;
+	struct in6_addr *in6;
+	struct in_addr  *in;
+	const char *desc;
+	void *addr;
+	int rc = 0;
+
+	str = strdup(_str);
+	if (!str)
+		return -ENOMEM;
+
+	switch (atype) {
+	case ADDR_TYPE_LOCAL:
+		desc = "local";
+		addr = &args->local_addr;
+		break;
+	case ADDR_TYPE_REMOTE:
+		desc = "remote";
+		addr = &args->remote_addr;
+		break;
+	case ADDR_TYPE_MCAST:
+		desc = "mcast grp";
+		addr = &args->grp;
+		break;
+	case ADDR_TYPE_EXPECTED_LOCAL:
+		desc = "expected local";
+		addr = &args->expected_laddr;
+		break;
+	case ADDR_TYPE_EXPECTED_REMOTE:
+		desc = "expected remote";
+		addr = &args->expected_raddr;
+		break;
+	case ADDR_TYPE_MD5_PREFIX:
+		desc = "md5 prefix";
+		if (family == AF_INET) {
+			args->md5_prefix.v4.sin_family = AF_INET;
+			addr = &args->md5_prefix.v4.sin_addr;
+		} else if (family == AF_INET6) {
+			args->md5_prefix.v6.sin6_family = AF_INET6;
+			addr = &args->md5_prefix.v6.sin6_addr;
+		} else
+			return 1;
+
+		sep = strchr(str, '/');
+		if (sep) {
+			*sep = '\0';
+			sep++;
+			if (str_to_uint(sep, 1, pfx_len_max,
+					&args->prefix_len) != 0) {
+				fprintf(stderr, "Invalid port\n");
+				return 1;
+			}
+		} else {
+			args->prefix_len = pfx_len_max;
+		}
+		break;
+	default:
+		log_error("unknown address type");
+		exit(1);
+	}
+
+	switch (family) {
+	case AF_INET:
+		in  = (struct in_addr *) addr;
+		if (str) {
+			if (inet_pton(AF_INET, str, in) == 0) {
+				log_error("Invalid %s IP address\n", desc);
+				rc = -1;
+				goto out;
+			}
+		} else {
+			in->s_addr = htonl(INADDR_ANY);
+		}
+		break;
+
+	case AF_INET6:
+		dev = strchr(str, '%');
+		if (dev) {
+			*dev = '\0';
+			dev++;
+		}
+
+		in6 = (struct in6_addr *) addr;
+		if (str) {
+			if (inet_pton(AF_INET6, str, in6) == 0) {
+				log_error("Invalid %s IPv6 address\n", desc);
+				rc = -1;
+				goto out;
+			}
+		} else {
+			*in6 = in6addr_any;
+		}
+		if (dev) {
+			args->scope_id = get_ifidx(dev);
+			if (args->scope_id < 0) {
+				log_error("Invalid scope on %s IPv6 address\n",
+					  desc);
+				rc = -1;
+				goto out;
+			}
+		}
+		break;
+
+	default:
+		log_error("Invalid address family\n");
+	}
+
+out:
+	free(str);
+	return rc;
+}
+
 static int get_index_from_cmsg(struct msghdr *m)
 {
 	struct cmsghdr *cm;
@@ -1460,132 +1586,6 @@ static int do_client(struct sock_args *args)
 	return rc;
 }
 
-enum addr_type {
-	ADDR_TYPE_LOCAL,
-	ADDR_TYPE_REMOTE,
-	ADDR_TYPE_MCAST,
-	ADDR_TYPE_EXPECTED_LOCAL,
-	ADDR_TYPE_EXPECTED_REMOTE,
-	ADDR_TYPE_MD5_PREFIX,
-};
-
-static int convert_addr(struct sock_args *args, const char *_str,
-			enum addr_type atype)
-{
-	int pfx_len_max = args->version == AF_INET6 ? 128 : 32;
-	int family = args->version;
-	char *str, *dev, *sep;
-	struct in6_addr *in6;
-	struct in_addr  *in;
-	const char *desc;
-	void *addr;
-	int rc = 0;
-
-	str = strdup(_str);
-	if (!str)
-		return -ENOMEM;
-
-	switch (atype) {
-	case ADDR_TYPE_LOCAL:
-		desc = "local";
-		addr = &args->local_addr;
-		break;
-	case ADDR_TYPE_REMOTE:
-		desc = "remote";
-		addr = &args->remote_addr;
-		break;
-	case ADDR_TYPE_MCAST:
-		desc = "mcast grp";
-		addr = &args->grp;
-		break;
-	case ADDR_TYPE_EXPECTED_LOCAL:
-		desc = "expected local";
-		addr = &args->expected_laddr;
-		break;
-	case ADDR_TYPE_EXPECTED_REMOTE:
-		desc = "expected remote";
-		addr = &args->expected_raddr;
-		break;
-	case ADDR_TYPE_MD5_PREFIX:
-		desc = "md5 prefix";
-		if (family == AF_INET) {
-			args->md5_prefix.v4.sin_family = AF_INET;
-			addr = &args->md5_prefix.v4.sin_addr;
-		} else if (family == AF_INET6) {
-			args->md5_prefix.v6.sin6_family = AF_INET6;
-			addr = &args->md5_prefix.v6.sin6_addr;
-		} else
-			return 1;
-
-		sep = strchr(str, '/');
-		if (sep) {
-			*sep = '\0';
-			sep++;
-			if (str_to_uint(sep, 1, pfx_len_max,
-					&args->prefix_len) != 0) {
-				fprintf(stderr, "Invalid port\n");
-				return 1;
-			}
-		} else {
-			args->prefix_len = pfx_len_max;
-		}
-		break;
-	default:
-		log_error("unknown address type");
-		exit(1);
-	}
-
-	switch (family) {
-	case AF_INET:
-		in  = (struct in_addr *) addr;
-		if (str) {
-			if (inet_pton(AF_INET, str, in) == 0) {
-				log_error("Invalid %s IP address\n", desc);
-				rc = -1;
-				goto out;
-			}
-		} else {
-			in->s_addr = htonl(INADDR_ANY);
-		}
-		break;
-
-	case AF_INET6:
-		dev = strchr(str, '%');
-		if (dev) {
-			*dev = '\0';
-			dev++;
-		}
-
-		in6 = (struct in6_addr *) addr;
-		if (str) {
-			if (inet_pton(AF_INET6, str, in6) == 0) {
-				log_error("Invalid %s IPv6 address\n", desc);
-				rc = -1;
-				goto out;
-			}
-		} else {
-			*in6 = in6addr_any;
-		}
-		if (dev) {
-			args->scope_id = get_ifidx(dev);
-			if (args->scope_id < 0) {
-				log_error("Invalid scope on %s IPv6 address\n",
-					  desc);
-				rc = -1;
-				goto out;
-			}
-		}
-		break;
-
-	default:
-		log_error("Invalid address family\n");
-	}
-
-out:
-	free(str);
-	return rc;
-}
-
 static char *random_msg(int len)
 {
 	int i, n = 0, olen = len + 1;
-- 
2.24.3 (Apple Git-128)

