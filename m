Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D663823A8
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 07:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234022AbhEQFLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 01:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbhEQFLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 01:11:36 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87CB9C061573
        for <netdev@vger.kernel.org>; Sun, 16 May 2021 22:10:20 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1liVWD-0005ay-Sw; Mon, 17 May 2021 07:10:17 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     dsahern@gmail.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH iproute2 v3] libgenl: make genl_add_mcast_grp set errno on error
Date:   Mon, 17 May 2021 07:10:10 +0200
Message-Id: <20210517051010.1355-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

genl_add_mcast_grp doesn't set errno in all cases.

On kernels that support mptcp but lack event support (all kernels <= 5.11)
MPTCP_PM_EV_GRP_NAME won't be found and ip will exit with

    "can't subscribe to mptcp events: Success"

Set errno to a meaningful value (ENOENT) when the group name isn't found
and also cover other spots where it returns nonzero with errno unset.

Fixes: ff619e4fd370 ("mptcp: add support for event monitoring")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Change since v2: include errno.h
 Change since v1: fix libgenl instead of setting errno in the caller.
 lib/libgenl.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/lib/libgenl.c b/lib/libgenl.c
index 4c51d47af46b..fca07f9fe768 100644
--- a/lib/libgenl.c
+++ b/lib/libgenl.c
@@ -3,6 +3,7 @@
  * libgenl.c	GENL library
  */
 
+#include <errno.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
@@ -84,6 +85,7 @@ static int genl_parse_grps(struct rtattr *attr, const char *name, unsigned int *
 		}
 	}
 
+	errno = ENOENT;
 	return -1;
 }
 
@@ -108,17 +110,22 @@ int genl_add_mcast_grp(struct rtnl_handle *grth, __u16 fnum, const char *group)
 	ghdr = NLMSG_DATA(answer);
 	len = answer->nlmsg_len;
 
-	if (answer->nlmsg_type != GENL_ID_CTRL)
+	if (answer->nlmsg_type != GENL_ID_CTRL) {
+		errno = EINVAL;
 		goto err_free;
+	}
 
 	len -= NLMSG_LENGTH(GENL_HDRLEN);
-	if (len < 0)
+	if (len < 0) {
+		errno = EINVAL;
 		goto err_free;
+	}
 
 	attrs = (struct rtattr *) ((char *) ghdr + GENL_HDRLEN);
 	parse_rtattr(tb, CTRL_ATTR_MAX, attrs, len);
 
 	if (tb[CTRL_ATTR_MCAST_GROUPS] == NULL) {
+		errno = ENOENT;
 		fprintf(stderr, "Missing mcast groups TLV\n");
 		goto err_free;
 	}
-- 
2.26.3

