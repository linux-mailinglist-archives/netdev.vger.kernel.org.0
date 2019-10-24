Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75FEDE3E09
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 23:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbfJXVUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 17:20:09 -0400
Received: from cache12.mydevil.net ([128.204.216.223]:63766 "EHLO
        cache12.mydevil.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727838AbfJXVUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 17:20:09 -0400
From:   =?UTF-8?q?Micha=C5=82=20=C5=81yszczek?= <michal.lyszczek@bofc.pl>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Micha=C5=82=20=C5=81yszczek?= <michal.lyszczek@bofc.pl>
Subject: [PATCH iproute2] libnetlink.c, ss.c: properly handle fread() error
Date:   Thu, 24 Oct 2019 23:20:01 +0200
Message-Id: <20191024212001.7020-1-michal.lyszczek@bofc.pl>
X-Mailer: git-send-email 2.21.0
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
failed, user should check if return is 0 and then check error
indicator with ferror(3).

Signed-off-by: Michał Łyszczek <michal.lyszczek@bofc.pl>
---
 lib/libnetlink.c | 6 +++---
 misc/ss.c        | 7 ++++---
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index 6ce8b199..76c383f9 100644
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
 
@@ -1184,7 +1184,7 @@ int rtnl_from_file(FILE *rtnl, rtnl_listen_filter_t handler,
 
 		status = fread(&buf, 1, sizeof(*h), rtnl);
 
-		if (status < 0) {
+		if (status == 0 && ferror(rtnl)) {
 			if (errno == EINTR)
 				continue;
 			perror("rtnl_from_file: fread");
@@ -1204,7 +1204,7 @@ int rtnl_from_file(FILE *rtnl, rtnl_listen_filter_t handler,
 
 		status = fread(NLMSG_DATA(h), 1, NLMSG_ALIGN(l), rtnl);
 
-		if (status < 0) {
+		if (status == 0 && ferror(rtnl)) {
 			perror("rtnl_from_file: fread");
 			return -1;
 		}
diff --git a/misc/ss.c b/misc/ss.c
index 363b4c8d..769332e9 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -3329,12 +3329,13 @@ static int tcp_show_netlink_file(struct filter *f)
 	}
 
 	while (1) {
-		int status, err2;
+		int err2;
+		size_t status;
 		struct nlmsghdr *h = (struct nlmsghdr *)buf;
 		struct sockstat s = {};
 
 		status = fread(buf, 1, sizeof(*h), fp);
-		if (status < 0) {
+		if (status == 0 && ferror(fp)) {
 			perror("Reading header from $TCPDIAG_FILE");
 			break;
 		}
@@ -3345,7 +3346,7 @@ static int tcp_show_netlink_file(struct filter *f)
 
 		status = fread(h+1, 1, NLMSG_ALIGN(h->nlmsg_len-sizeof(*h)), fp);
 
-		if (status < 0) {
+		if (status == 0 && ferror(fp)) {
 			perror("Reading $TCPDIAG_FILE");
 			break;
 		}
-- 
2.21.0

