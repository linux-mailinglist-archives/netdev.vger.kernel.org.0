Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9401C1524D
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 19:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfEFRJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 13:09:54 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:56226 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727031AbfEFRJy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 May 2019 13:09:54 -0400
Received: from localhost ([::1]:41084 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hNh7g-0005Nm-Cn; Mon, 06 May 2019 19:09:52 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: [iproute PATCH v2] ip-xfrm: Respect family in deleteall and list commands
Date:   Mon,  6 May 2019 19:09:56 +0200
Message-Id: <20190506170956.8684-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow to limit 'ip xfrm {state|policy} list' output to a certain address
family and to delete all states/policies by family.

Although preferred_family was already set in filters, the filter
function ignored it. To enable filtering despite the lack of other
selectors, filter.use has to be set if family is not AF_UNSPEC.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Fix code indenting in first chunk.
---
 ip/xfrm_policy.c   | 6 +++++-
 ip/xfrm_state.c    | 6 +++++-
 man/man8/ip-xfrm.8 | 6 +++---
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/ip/xfrm_policy.c b/ip/xfrm_policy.c
index 4a63e9ab602d7..9898435055d6f 100644
--- a/ip/xfrm_policy.c
+++ b/ip/xfrm_policy.c
@@ -410,6 +410,10 @@ static int xfrm_policy_filter_match(struct xfrm_userpolicy_info *xpinfo,
 	if (!filter.use)
 		return 1;
 
+	if (filter.xpinfo.sel.family != AF_UNSPEC &&
+	    filter.xpinfo.sel.family != xpinfo->sel.family)
+		return 0;
+
 	if ((xpinfo->dir^filter.xpinfo.dir)&filter.dir_mask)
 		return 0;
 
@@ -780,7 +784,7 @@ static int xfrm_policy_list_or_deleteall(int argc, char **argv, int deleteall)
 	char *selp = NULL;
 	struct rtnl_handle rth;
 
-	if (argc > 0)
+	if (argc > 0 || preferred_family != AF_UNSPEC)
 		filter.use = 1;
 	filter.xpinfo.sel.family = preferred_family;
 
diff --git a/ip/xfrm_state.c b/ip/xfrm_state.c
index 9360143756016..f27270709d2fb 100644
--- a/ip/xfrm_state.c
+++ b/ip/xfrm_state.c
@@ -898,6 +898,10 @@ static int xfrm_state_filter_match(struct xfrm_usersa_info *xsinfo)
 	if (!filter.use)
 		return 1;
 
+	if (filter.xsinfo.family != AF_UNSPEC &&
+	    filter.xsinfo.family != xsinfo->family)
+		return 0;
+
 	if (filter.id_src_mask)
 		if (xfrm_addr_match(&xsinfo->saddr, &filter.xsinfo.saddr,
 				    filter.id_src_mask))
@@ -1170,7 +1174,7 @@ static int xfrm_state_list_or_deleteall(int argc, char **argv, int deleteall)
 	struct rtnl_handle rth;
 	bool nokeys = false;
 
-	if (argc > 0)
+	if (argc > 0 || preferred_family != AF_UNSPEC)
 		filter.use = 1;
 	filter.xsinfo.family = preferred_family;
 
diff --git a/man/man8/ip-xfrm.8 b/man/man8/ip-xfrm.8
index 9547808539a08..cfce1e40b7f7d 100644
--- a/man/man8/ip-xfrm.8
+++ b/man/man8/ip-xfrm.8
@@ -89,7 +89,7 @@ ip-xfrm \- transform configuration
 .IR MASK " ] ]"
 
 .ti -8
-.BR "ip xfrm state " deleteall " ["
+.BR ip " [ " -4 " | " -6 " ] " "xfrm state deleteall" " ["
 .IR ID " ]"
 .RB "[ " mode
 .IR MODE " ]"
@@ -99,7 +99,7 @@ ip-xfrm \- transform configuration
 .IR FLAG-LIST " ]"
 
 .ti -8
-.BR "ip xfrm state " list " ["
+.BR ip " [ " -4 " | " -6 " ] " "xfrm state list" " ["
 .IR ID " ]"
 .RB "[ " nokeys " ]"
 .RB "[ " mode
@@ -257,7 +257,7 @@ ip-xfrm \- transform configuration
 .IR PTYPE " ]"
 
 .ti -8
-.BR "ip xfrm policy" " { " deleteall " | " list " }"
+.BR ip " [ " -4 " | " -6 " ] " "xfrm policy" " { " deleteall " | " list " }"
 .RB "[ " nosock " ]"
 .RI "[ " SELECTOR " ]"
 .RB "[ " dir
-- 
2.21.0

