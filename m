Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B7130B5DC
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 04:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbhBBDd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 22:33:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbhBBDd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 22:33:26 -0500
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FF1C061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 19:32:46 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id j8so4822493oon.3
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 19:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NJR/Fwp6+Z/DKx4EkaP3cWudy4jC+pP9zKV4f/4HbeQ=;
        b=i1y0Jajhz/6gkwLGTfPRMiSabs3tJRWR7Mm+zeyspJviAdcVt963EVYoglSxh7upNd
         l5PcWvtbED2A7r64cxqTbL2ygDunlSvRcZBeaiWerQs9qxFrCbH0jfZJwtUvft1qtyct
         mgUmbBi/99dWJw6czf9J/0mjuYgcGD8lO8bggdzW5JKqfy01Zq5J87oGy6iD26fjkmZb
         Tl6V4q2+zMmYPSVphNoUC8QdTJeJi39faHjtCWFUSCPF/teOlr35wHcrpMn/9geNjKj6
         Ne7wv1XoWH24jrNj9UHp342fhrsGQc0oldnUQmEKz6twE3Ny8sfXSP3suDT70gUXkwGG
         tPgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NJR/Fwp6+Z/DKx4EkaP3cWudy4jC+pP9zKV4f/4HbeQ=;
        b=O6lxzGYuhxv/g3wKRVFSYQY4LyO/bVhsV66J/6zRIv7NAj+7AGDVi01TOfUDs+Nu5V
         wn46GJLLQmRvE45grO9pLWJL5T9cF3p3FF/e1nf+SAZLlK9gcHE/lExP6Qd3l10FmVch
         6Av6tDN79EONGVe2sHUQVsWSo4duU/Wuc5ZcCj+wJCvrD+3Pa+ZgULZvQefQuDfNM7co
         Nd5CetNUMpofZv8IymEGZ8sgEUVyS9i6plryALJ9zd0lzOrJCJ65Vz0x3hZ54ebHANWu
         5z5iQAe2Cmn5HoN64ngemZOTfcoHYfhXDZiujkMLEvmKrK9vEJkuiAAAzfcTSgW2zJRm
         8VbQ==
X-Gm-Message-State: AOAM533/5f1jAR/2xslnBBe4tzadkQHuAYcwc1EZlTSHe5cg9XZHbmtv
        UmI6xH45YI3wWyuTBSu7VzjkK1pIRdw2nA==
X-Google-Smtp-Source: ABdhPJylsSn0t1a3GL3Xs8r+g5o9rWd59zZbeLvEUxfiuq32jC0cHahLJR1tXLyqc7fEcvyZ6wG2Ug==
X-Received: by 2002:a4a:bc8d:: with SMTP id m13mr13838706oop.72.1612236765801;
        Mon, 01 Feb 2021 19:32:45 -0800 (PST)
Received: from tardis.. (c-67-182-242-199.hsd1.ut.comcast.net. [67.182.242.199])
        by smtp.gmail.com with ESMTPSA id c10sm4396241otm.22.2021.02.01.19.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 19:32:44 -0800 (PST)
From:   Thayne McCombs <astrothayne@gmail.com>
To:     dsahern@gmail.com
Cc:     netdev@vger.kernel.org, Thayne McCombs <astrothayne@gmail.com>
Subject: [PATCH ip-route2-next v2] ss: always prefer family as part of host condition to default family
Date:   Mon,  1 Feb 2021 20:32:10 -0700
Message-Id: <20210202033210.2863-1-astrothayne@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <6d0eff35-b982-7d8d-d3c7-742411e93046@gmail.com>
References: <6d0eff35-b982-7d8d-d3c7-742411e93046@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've fixed the indentation to use tabs instead of spaces. 

-- >8 --
ss accepts an address family both with the -f option and as part of a
host condition. However, if the family in the host condition is
different than the the last -f option, then which family is actually
used depends on the order that different families are checked.

This changes parse_hostcond to check all family prefixes before parsing
the rest of the address, so that the host condition's family always has
a higher priority than the "preferred" family.

Signed-off-by: Thayne McCombs <astrothayne@gmail.com>
---
 misc/ss.c | 50 ++++++++++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/misc/ss.c b/misc/ss.c
index 0593627b..aefa1c2f 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -2119,24 +2119,39 @@ void *parse_hostcond(char *addr, bool is_port)
 	int fam = preferred_family;
 	struct filter *f = &current_filter;
 
-	if (fam == AF_UNIX || strncmp(addr, "unix:", 5) == 0) {
+	if (strncmp(addr, "unix:", 5) == 0) {
+		fam = AF_UNIX;
+		addr += 5;
+	} else if (strncmp(addr, "link:", 5) == 0) {
+		fam = AF_PACKET;
+		addr += 5;
+	} else if (strncmp(addr, "netlink:", 8) == 0) {
+		fam = AF_NETLINK;
+		addr += 8;
+	} else if (strncmp(addr, "vsock:", 6) == 0) {
+		fam = AF_VSOCK;
+		addr += 6;
+	} else if (strncmp(addr, "inet:", 5) == 0) {
+		fam = AF_INET;
+		addr += 5;
+	} else if (strncmp(addr, "inet6:", 6) == 0) {
+		fam = AF_INET6;
+		addr += 6;
+	}
+
+	if (fam == AF_UNIX) {
 		char *p;
 
 		a.addr.family = AF_UNIX;
-		if (strncmp(addr, "unix:", 5) == 0)
-			addr += 5;
 		p = strdup(addr);
 		a.addr.bitlen = 8*strlen(p);
 		memcpy(a.addr.data, &p, sizeof(p));
-		fam = AF_UNIX;
 		goto out;
 	}
 
-	if (fam == AF_PACKET || strncmp(addr, "link:", 5) == 0) {
+	if (fam == AF_PACKET) {
 		a.addr.family = AF_PACKET;
 		a.addr.bitlen = 0;
-		if (strncmp(addr, "link:", 5) == 0)
-			addr += 5;
 		port = strchr(addr, ':');
 		if (port) {
 			*port = 0;
@@ -2155,15 +2170,12 @@ void *parse_hostcond(char *addr, bool is_port)
 				return NULL;
 			a.addr.data[0] = ntohs(tmp);
 		}
-		fam = AF_PACKET;
 		goto out;
 	}
 
-	if (fam == AF_NETLINK || strncmp(addr, "netlink:", 8) == 0) {
+	if (fam == AF_NETLINK) {
 		a.addr.family = AF_NETLINK;
 		a.addr.bitlen = 0;
-		if (strncmp(addr, "netlink:", 8) == 0)
-			addr += 8;
 		port = strchr(addr, ':');
 		if (port) {
 			*port = 0;
@@ -2181,16 +2193,13 @@ void *parse_hostcond(char *addr, bool is_port)
 			if (nl_proto_a2n(&a.addr.data[0], addr) == -1)
 				return NULL;
 		}
-		fam = AF_NETLINK;
 		goto out;
 	}
 
-	if (fam == AF_VSOCK || strncmp(addr, "vsock:", 6) == 0) {
+	if (fam == AF_VSOCK) {
 		__u32 cid = ~(__u32)0;
 
 		a.addr.family = AF_VSOCK;
-		if (strncmp(addr, "vsock:", 6) == 0)
-			addr += 6;
 
 		if (is_port)
 			port = addr;
@@ -2212,20 +2221,9 @@ void *parse_hostcond(char *addr, bool is_port)
 				return NULL;
 		}
 		vsock_set_inet_prefix(&a.addr, cid);
-		fam = AF_VSOCK;
 		goto out;
 	}
 
-	if (fam == AF_INET || !strncmp(addr, "inet:", 5)) {
-		fam = AF_INET;
-		if (!strncmp(addr, "inet:", 5))
-			addr += 5;
-	} else if (fam == AF_INET6 || !strncmp(addr, "inet6:", 6)) {
-		fam = AF_INET6;
-		if (!strncmp(addr, "inet6:", 6))
-			addr += 6;
-	}
-
 	/* URL-like literal [] */
 	if (addr[0] == '[') {
 		addr++;
-- 
2.30.0

