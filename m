Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48128442FD0
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 15:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbhKBOLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 10:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbhKBOLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 10:11:10 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693E9C061714;
        Tue,  2 Nov 2021 07:08:35 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 084D5C009; Tue,  2 Nov 2021 15:08:33 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 433CEC009;
        Tue,  2 Nov 2021 15:08:28 +0100 (CET)
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 4a9f868c;
        Tue, 2 Nov 2021 13:46:12 +0000 (UTC)
From:   Dominique Martinet <dominique.martinet@atmark-techno.com>
To:     v9fs-developer@lists.sourceforge.net
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 4/4] 9p p9mode2perm: remove useless strlcpy and check sscanf return code
Date:   Tue,  2 Nov 2021 22:46:08 +0900
Message-Id: <20211102134608.1588018-5-dominique.martinet@atmark-techno.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211102134608.1588018-1-dominique.martinet@atmark-techno.com>
References: <20211102134608.1588018-1-dominique.martinet@atmark-techno.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dominique Martinet <asmadeus@codewreck.org>

This is also a checkpatch warning fix but this one might have implications
so keeping it separate

Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---
 fs/9p/vfs_inode.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 139dfee23b98..328c338ff304 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -109,7 +109,7 @@ static int p9mode2perm(struct v9fs_session_info *v9ses,
 static umode_t p9mode2unixmode(struct v9fs_session_info *v9ses,
 			       struct p9_wstat *stat, dev_t *rdev)
 {
-	int res;
+	int res, r;
 	u32 mode = stat->mode;
 
 	*rdev = 0;
@@ -127,11 +127,16 @@ static umode_t p9mode2unixmode(struct v9fs_session_info *v9ses,
 		res |= S_IFIFO;
 	else if ((mode & P9_DMDEVICE) && (v9fs_proto_dotu(v9ses))
 		 && (v9ses->nodev == 0)) {
-		char type = 0, ext[32];
+		char type = 0;
 		int major = -1, minor = -1;
 
-		strlcpy(ext, stat->extension, sizeof(ext));
-		sscanf(ext, "%c %i %i", &type, &major, &minor);
+		r = sscanf(stat->extension, "%c %i %i", &type, &major, &minor);
+		if (r != 3) {
+			p9_debug(P9_DEBUG_ERROR,
+				 "invalid device string, umode will be bogus: %s\n",
+				 stat->extension);
+			return res;
+		}
 		switch (type) {
 		case 'c':
 			res |= S_IFCHR;
-- 
2.31.1

