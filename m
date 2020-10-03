Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A27828229D
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 10:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbgJCIph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 04:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbgJCIph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 04:45:37 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B6EC0613D0
        for <netdev@vger.kernel.org>; Sat,  3 Oct 2020 01:45:36 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kOdAd-00Fme3-58; Sat, 03 Oct 2020 10:45:35 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH v3] genl: ctrl: print op -> policy idx mapping
Date:   Sat,  3 Oct 2020 10:45:32 +0200
Message-Id: <20201003084532.59283-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Newer kernels can dump per-op policies, so print out the new
mapping attribute to indicate which op has which policy.

v2:
 * print out both do/dump policy idx
v3:
 * fix userspace API which renumbered after patch rebasing

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 genl/ctrl.c                    | 27 +++++++++++++++++++++++++++
 include/uapi/linux/genetlink.h | 11 +++++++++++
 2 files changed, 38 insertions(+)

diff --git a/genl/ctrl.c b/genl/ctrl.c
index 68099fe97f1a..549bc6635831 100644
--- a/genl/ctrl.c
+++ b/genl/ctrl.c
@@ -162,6 +162,33 @@ static int print_ctrl(struct rtnl_ctrl_data *ctrl,
 		__u32 *ma = RTA_DATA(tb[CTRL_ATTR_MAXATTR]);
 		fprintf(fp, " max attribs: %d ",*ma);
 	}
+	if (tb[CTRL_ATTR_OP_POLICY]) {
+		const struct rtattr *pos;
+
+		rtattr_for_each_nested(pos, tb[CTRL_ATTR_OP_POLICY]) {
+			struct rtattr *ptb[CTRL_ATTR_POLICY_DUMP_MAX + 1];
+			struct rtattr *pattrs = RTA_DATA(pos);
+			int plen = RTA_PAYLOAD(pos);
+
+			parse_rtattr_flags(ptb, CTRL_ATTR_POLICY_DUMP_MAX,
+					   pattrs, plen, NLA_F_NESTED);
+
+			fprintf(fp, " op %d policies:",
+				pos->rta_type & ~NLA_F_NESTED);
+
+			if (ptb[CTRL_ATTR_POLICY_DO]) {
+				__u32 *v = RTA_DATA(ptb[CTRL_ATTR_POLICY_DO]);
+
+				fprintf(fp, " do=%d", *v);
+			}
+
+			if (ptb[CTRL_ATTR_POLICY_DUMP]) {
+				__u32 *v = RTA_DATA(ptb[CTRL_ATTR_POLICY_DUMP]);
+
+				fprintf(fp, " dump=%d", *v);
+			}
+		}
+	}
 	if (tb[CTRL_ATTR_POLICY])
 		nl_print_policy(tb[CTRL_ATTR_POLICY], fp);
 
diff --git a/include/uapi/linux/genetlink.h b/include/uapi/linux/genetlink.h
index 7c6c390c48ee..9fa720ee87ae 100644
--- a/include/uapi/linux/genetlink.h
+++ b/include/uapi/linux/genetlink.h
@@ -64,6 +64,8 @@ enum {
 	CTRL_ATTR_OPS,
 	CTRL_ATTR_MCAST_GROUPS,
 	CTRL_ATTR_POLICY,
+	CTRL_ATTR_OP_POLICY,
+	CTRL_ATTR_OP,
 	__CTRL_ATTR_MAX,
 };
 
@@ -85,6 +87,15 @@ enum {
 	__CTRL_ATTR_MCAST_GRP_MAX,
 };
 
+enum {
+	CTRL_ATTR_POLICY_UNSPEC,
+	CTRL_ATTR_POLICY_DO,
+	CTRL_ATTR_POLICY_DUMP,
+
+	__CTRL_ATTR_POLICY_DUMP_MAX,
+	CTRL_ATTR_POLICY_DUMP_MAX = __CTRL_ATTR_POLICY_DUMP_MAX - 1
+};
+
 #define CTRL_ATTR_MCAST_GRP_MAX (__CTRL_ATTR_MCAST_GRP_MAX - 1)
 
 
-- 
2.26.2

