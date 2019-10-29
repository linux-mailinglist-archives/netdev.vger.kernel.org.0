Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D492E865D
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 12:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728898AbfJ2LN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 07:13:28 -0400
Received: from cache12.mydevil.net ([128.204.216.223]:45630 "EHLO
        cache12.mydevil.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728152AbfJ2LN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 07:13:28 -0400
From:   =?UTF-8?q?Micha=C5=82=20=C5=81yszczek?= <michal.lyszczek@bofc.pl>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Micha=C5=82=20=C5=81yszczek?= <michal.lyszczek@bofc.pl>
Subject: [PATCH v2 iproute2] libnetlink.c, ss.c: properly handle fread() errors
Date:   Tue, 29 Oct 2019 12:13:11 +0100
Message-Id: <20191029111311.7000-1-michal.lyszczek@bofc.pl>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191028212128.1b8c5054@hermes.lan>
References: <20191028212128.1b8c5054@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AV-Check: Passed
X-System-Sender: michal.lyszczek@bofc.pl
X-Spam-Flag: NO
X-Spam-Status: NO, score=0.8 required=5.0, tests=(BAYES_50=0.8,
        NO_RELAYS=-0.001, URIBL_BLOCKED=0.001) autolearn=disabled
        version=3.4.2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fread(3) returns size_t data type which is unsigned, thus check
`if (fread(...) < 0)' is always false. To check if fread(3) has
failed, user should check error indicator with ferror(3).

This commit also changes read logic a little bit by being less
forgiving for errors. Previous logic was checking if fread(3)
read *at least* required ammount of data, now code checks if
fread(3) read *exactly* expected ammount of data. This makes
sense because code parses very specific binary file, and reading
even 1 less/more byte than expected, will later corrupt data anyway.

Signed-off-by: Michał Łyszczek <michal.lyszczek@bofc.pl>

---
v1 -> v2: fread(3) can also return error on truncated reads and
            not only on 0bytes read (suggested by Stephen Hemminger)

---
 lib/libnetlink.c | 26 +++++++++++++-------------
 misc/ss.c        | 26 +++++++++++++-------------
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index 6ce8b199..e02d6294 100644
--- a/lib/libnetlink.c
+++ b/lib/libnetlink.c
@@ -1174,7 +1174,7 @@ int rtnl_listen(struct rtnl_handle *rtnl,
 int rtnl_from_file(FILE *rtnl, rtnl_listen_filter_t handler,
 		   void *jarg)
 {
-	int status;
+	size_t status;
 	char buf[16384];
 	struct nlmsghdr *h = (struct nlmsghdr *)buf;
 
@@ -1184,14 +1184,15 @@ int rtnl_from_file(FILE *rtnl, rtnl_listen_filter_t handler,
 
 		status = fread(&buf, 1, sizeof(*h), rtnl);
 
-		if (status < 0) {
-			if (errno == EINTR)
-				continue;
-			perror("rtnl_from_file: fread");
+		if (status == 0 && feof(rtnl))
+			return 0;
+		if (status != sizeof(*h)) {
+			if (ferror(rtnl))
+				perror("rtnl_from_file: fread");
+			if (feof(rtnl))
+				fprintf(stderr, "rtnl-from_file: truncated message\n");
 			return -1;
 		}
-		if (status == 0)
-			return 0;
 
 		len = h->nlmsg_len;
 		l = len - sizeof(*h);
@@ -1204,12 +1205,11 @@ int rtnl_from_file(FILE *rtnl, rtnl_listen_filter_t handler,
 
 		status = fread(NLMSG_DATA(h), 1, NLMSG_ALIGN(l), rtnl);
 
-		if (status < 0) {
-			perror("rtnl_from_file: fread");
-			return -1;
-		}
-		if (status < l) {
-			fprintf(stderr, "rtnl-from_file: truncated message\n");
+		if (status != NLMSG_ALIGN(l)) {
+			if (ferror(rtnl))
+				perror("rtnl_from_file: fread");
+			if (feof(rtnl))
+				fprintf(stderr, "rtnl-from_file: truncated message\n");
 			return -1;
 		}
 
diff --git a/misc/ss.c b/misc/ss.c
index 363b4c8d..efa87781 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -3329,28 +3329,28 @@ static int tcp_show_netlink_file(struct filter *f)
 	}
 
 	while (1) {
-		int status, err2;
+		int err2;
+		size_t status, nitems;
 		struct nlmsghdr *h = (struct nlmsghdr *)buf;
 		struct sockstat s = {};
 
 		status = fread(buf, 1, sizeof(*h), fp);
-		if (status < 0) {
-			perror("Reading header from $TCPDIAG_FILE");
-			break;
-		}
 		if (status != sizeof(*h)) {
-			perror("Unexpected EOF reading $TCPDIAG_FILE");
+			if (ferror(fp))
+				perror("Reading header from $TCPDIAG_FILE");
+			if (feof(fp))
+				fprintf(stderr, "Unexpected EOF reading $TCPDIAG_FILE");
 			break;
 		}
 
-		status = fread(h+1, 1, NLMSG_ALIGN(h->nlmsg_len-sizeof(*h)), fp);
+		nitems = NLMSG_ALIGN(h->nlmsg_len - sizeof(*h));
+		status = fread(h+1, 1, nitems, fp);
 
-		if (status < 0) {
-			perror("Reading $TCPDIAG_FILE");
-			break;
-		}
-		if (status + sizeof(*h) < h->nlmsg_len) {
-			perror("Unexpected EOF reading $TCPDIAG_FILE");
+		if (status != nitems) {
+			if (ferror(fp))
+				perror("Reading $TCPDIAG_FILE");
+			if (feof(fp))
+				fprintf(stderr, "Unexpected EOF reading $TCPDIAG_FILE");
 			break;
 		}
 
-- 
2.23.0

