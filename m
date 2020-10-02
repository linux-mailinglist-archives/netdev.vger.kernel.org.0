Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989B028108D
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 12:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387652AbgJBK0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 06:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgJBK0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 06:26:14 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B492EC0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 03:26:14 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kOIGT-00FBIl-19; Fri, 02 Oct 2020 12:26:13 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH] genl: ctrl: print op -> policy idx mapping
Date:   Fri,  2 Oct 2020 12:26:09 +0200
Message-Id: <20201002102609.224150-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Newer kernels can dump per-op policies, so print out the new
mapping attribute to indicate which op has which policy.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 genl/ctrl.c                    | 10 ++++++++++
 include/uapi/linux/genetlink.h |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/genl/ctrl.c b/genl/ctrl.c
index 68099fe97f1a..c62212b40fa3 100644
--- a/genl/ctrl.c
+++ b/genl/ctrl.c
@@ -162,6 +162,16 @@ static int print_ctrl(struct rtnl_ctrl_data *ctrl,
 		__u32 *ma = RTA_DATA(tb[CTRL_ATTR_MAXATTR]);
 		fprintf(fp, " max attribs: %d ",*ma);
 	}
+	if (tb[CTRL_ATTR_OP_POLICY]) {
+		const struct rtattr *pos;
+
+		rtattr_for_each_nested(pos, tb[CTRL_ATTR_OP_POLICY]) {
+			__u32 *v = RTA_DATA(pos);
+
+			fprintf(fp, " op %d has policy %d",
+				pos->rta_type, *v);
+		}
+	}
 	if (tb[CTRL_ATTR_POLICY])
 		nl_print_policy(tb[CTRL_ATTR_POLICY], fp);
 
diff --git a/include/uapi/linux/genetlink.h b/include/uapi/linux/genetlink.h
index 7c6c390c48ee..adb59b9fb9a3 100644
--- a/include/uapi/linux/genetlink.h
+++ b/include/uapi/linux/genetlink.h
@@ -64,6 +64,8 @@ enum {
 	CTRL_ATTR_OPS,
 	CTRL_ATTR_MCAST_GROUPS,
 	CTRL_ATTR_POLICY,
+	CTRL_ATTR_OP,
+	CTRL_ATTR_OP_POLICY,
 	__CTRL_ATTR_MAX,
 };
 
-- 
2.26.2

