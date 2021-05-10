Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9578378D4E
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 15:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344909AbhEJMjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 08:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343524AbhEJMNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 08:13:49 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22F8C0611B4
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 05:06:19 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lg4fx-0000J3-TS; Mon, 10 May 2021 14:06:17 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     dsahern@gmail.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH iproute2 v2] libgenl: make genl_add_mcast_grp set errno on error
Date:   Mon, 10 May 2021 14:06:02 +0200
Message-Id: <20210510120602.29288-1-fw@strlen.de>
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
 Change since v1: fix libgenl instead of setting errno in the caller.

 lib/libgenl.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/lib/libgenl.c b/lib/libgenl.c
index 4c51d47af46b..8b22c06e7941 100644
--- a/lib/libgenl.c
+++ b/lib/libgenl.c
@@ -84,6 +84,7 @@ static int genl_parse_grps(struct rtattr *attr, const char *name, unsigned int *
 		}
 	}
 
+	errno = ENOENT;
 	return -1;
 }
 
@@ -108,17 +109,22 @@ int genl_add_mcast_grp(struct rtnl_handle *grth, __u16 fnum, const char *group)
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

