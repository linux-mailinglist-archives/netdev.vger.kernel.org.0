Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38372442FCE
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 15:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhKBOLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 10:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhKBOLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 10:11:07 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36140C061714;
        Tue,  2 Nov 2021 07:08:32 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id DD9BEC01C; Tue,  2 Nov 2021 15:08:28 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id E5AFFC009;
        Tue,  2 Nov 2021 15:08:25 +0100 (CET)
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 27490f23;
        Tue, 2 Nov 2021 13:46:12 +0000 (UTC)
From:   Dominique Martinet <dominique.martinet@atmark-techno.com>
To:     v9fs-developer@lists.sourceforge.net
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 3/4] 9p v9fs_parse_options: replace simple_strtoul with kstrtouint
Date:   Tue,  2 Nov 2021 22:46:07 +0900
Message-Id: <20211102134608.1588018-4-dominique.martinet@atmark-techno.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211102134608.1588018-1-dominique.martinet@atmark-techno.com>
References: <20211102134608.1588018-1-dominique.martinet@atmark-techno.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dominique Martinet <asmadeus@codewreck.org>

This is also a checkpatch change, but this one might have more implications
so keeping this separate

Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---
 fs/9p/v9fs.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index d92e5fdae111..e32dd5f7721b 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -164,7 +164,7 @@ static int v9fs_parse_options(struct v9fs_session_info *v9ses, char *opts)
 	substring_t args[MAX_OPT_ARGS];
 	char *p;
 	int option = 0;
-	char *s, *e;
+	char *s;
 	int ret = 0;
 
 	/* setup defaults */
@@ -321,12 +321,13 @@ static int v9fs_parse_options(struct v9fs_session_info *v9ses, char *opts)
 				v9ses->flags |= V9FS_ACCESS_CLIENT;
 			} else {
 				uid_t uid;
+
 				v9ses->flags |= V9FS_ACCESS_SINGLE;
-				uid = simple_strtoul(s, &e, 10);
-				if (*e != '\0') {
-					ret = -EINVAL;
-					pr_info("Unknown access argument %s\n",
-						s);
+				r = kstrtouint(s, 10, &uid);
+				if (r) {
+					ret = r;
+					pr_info("Unknown access argument %s: %d\n",
+						s, r);
 					kfree(s);
 					continue;
 				}
-- 
2.31.1

