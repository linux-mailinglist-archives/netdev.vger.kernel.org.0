Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2054B249A63
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 12:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgHSK3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 06:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727841AbgHSK3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 06:29:08 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D97C061342
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 03:29:07 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1k8LL7-006mIZ-Qd; Wed, 19 Aug 2020 12:29:05 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 2/2] genl: ctrl: support dumping netlink policy
Date:   Wed, 19 Aug 2020 12:29:03 +0200
Message-Id: <20200819102903.21740-2-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200819102903.21740-1-johannes@sipsolutions.net>
References: <20200819102903.21740-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support dumping the netlink policy of a given generic netlink
family, the policy (with any sub-policies if appropriate) is
exported by the kernel in a general fashion.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 genl/ctrl.c | 91 +++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 85 insertions(+), 6 deletions(-)

diff --git a/genl/ctrl.c b/genl/ctrl.c
index 0fb464b01cfb..7767fffe63ea 100644
--- a/genl/ctrl.c
+++ b/genl/ctrl.c
@@ -28,13 +28,15 @@
 static int usage(void)
 {
 	fprintf(stderr,"Usage: ctrl <CMD>\n" \
-		       "CMD   := get <PARMS> | list | monitor\n" \
+		       "CMD   := get <PARMS> | list | monitor | policy <PARMS>\n" \
 		       "PARMS := name <name> | id <id>\n" \
 		       "Examples:\n" \
 		       "\tctrl ls\n" \
 		       "\tctrl monitor\n" \
 		       "\tctrl get name foobar\n" \
-		       "\tctrl get id 0xF\n");
+		       "\tctrl get id 0xF\n"
+		       "\tctrl policy name foobar\n"
+		       "\tctrl policy id 0xF\n");
 	return -1;
 }
 
@@ -100,6 +102,30 @@ static int print_ctrl_grp(FILE *fp, struct rtattr *arg, __u32 ctrl_ver)
 
 }
 
+static const char *get_nla_type_str(unsigned int attr)
+{
+	switch (attr) {
+#define C(x) case NL_ATTR_TYPE_ ## x: return #x
+	C(U8);
+	C(U16);
+	C(U32);
+	C(U64);
+	C(STRING);
+	C(FLAG);
+	C(NESTED);
+	C(NESTED_ARRAY);
+	C(NUL_STRING);
+	C(BINARY);
+	C(S8);
+	C(S16);
+	C(S32);
+	C(S64);
+	C(BITFIELD32);
+	default:
+		return "unknown";
+	}
+}
+
 /*
  * The controller sends one nlmsg per family
 */
@@ -123,7 +149,8 @@ static int print_ctrl(struct rtnl_ctrl_data *ctrl,
 	    ghdr->cmd != CTRL_CMD_DELFAMILY &&
 	    ghdr->cmd != CTRL_CMD_NEWFAMILY &&
 	    ghdr->cmd != CTRL_CMD_NEWMCAST_GRP &&
-	    ghdr->cmd != CTRL_CMD_DELMCAST_GRP) {
+	    ghdr->cmd != CTRL_CMD_DELMCAST_GRP &&
+	    ghdr->cmd != CTRL_CMD_GETPOLICY) {
 		fprintf(stderr, "Unknown controller command %d\n", ghdr->cmd);
 		return 0;
 	}
@@ -136,7 +163,7 @@ static int print_ctrl(struct rtnl_ctrl_data *ctrl,
 	}
 
 	attrs = (struct rtattr *) ((char *) ghdr + GENL_HDRLEN);
-	parse_rtattr(tb, CTRL_ATTR_MAX, attrs, len);
+	parse_rtattr_flags(tb, CTRL_ATTR_MAX, attrs, len, NLA_F_NESTED);
 
 	if (tb[CTRL_ATTR_FAMILY_NAME]) {
 		char *name = RTA_DATA(tb[CTRL_ATTR_FAMILY_NAME]);
@@ -159,6 +186,52 @@ static int print_ctrl(struct rtnl_ctrl_data *ctrl,
 		__u32 *ma = RTA_DATA(tb[CTRL_ATTR_MAXATTR]);
 		fprintf(fp, " max attribs: %d ",*ma);
 	}
+	if (tb[CTRL_ATTR_POLICY]) {
+		const struct rtattr *pos;
+
+		rtattr_for_each_nested(pos, tb[CTRL_ATTR_POLICY]) {
+			const struct rtattr *attr;
+
+			fprintf(fp, " policy[%u]:", pos->rta_type & ~NLA_F_NESTED);
+
+			rtattr_for_each_nested(attr, pos) {
+				struct rtattr *tp[NL_POLICY_TYPE_ATTR_MAX + 1];
+
+				parse_rtattr_nested(tp, ARRAY_SIZE(tp) - 1, attr);
+
+				if (tp[NL_POLICY_TYPE_ATTR_TYPE])
+					fprintf(fp, "attr[%u]: type=%s",
+						attr->rta_type & ~NLA_F_NESTED,
+						get_nla_type_str(rta_getattr_u32(tp[NL_POLICY_TYPE_ATTR_TYPE])));
+
+				if (tp[NL_POLICY_TYPE_ATTR_POLICY_IDX])
+					fprintf(fp, " policy:%u",
+						rta_getattr_u32(tp[NL_POLICY_TYPE_ATTR_POLICY_IDX]));
+
+				if (tp[NL_POLICY_TYPE_ATTR_POLICY_MAXTYPE])
+					fprintf(fp, " maxattr:%u",
+						rta_getattr_u32(tp[NL_POLICY_TYPE_ATTR_POLICY_MAXTYPE]));
+
+				if (tp[NL_POLICY_TYPE_ATTR_MIN_VALUE_S] && tp[NL_POLICY_TYPE_ATTR_MAX_VALUE_S])
+					fprintf(fp, " range:[%lld,%lld]",
+						(signed long long)rta_getattr_u64(tp[NL_POLICY_TYPE_ATTR_MIN_VALUE_S]),
+						(signed long long)rta_getattr_u64(tp[NL_POLICY_TYPE_ATTR_MAX_VALUE_S]));
+
+				if (tp[NL_POLICY_TYPE_ATTR_MIN_VALUE_U] && tp[NL_POLICY_TYPE_ATTR_MAX_VALUE_U])
+					fprintf(fp, " range:[%llu,%llu]",
+						(unsigned long long)rta_getattr_u64(tp[NL_POLICY_TYPE_ATTR_MIN_VALUE_U]),
+						(unsigned long long)rta_getattr_u64(tp[NL_POLICY_TYPE_ATTR_MAX_VALUE_U]));
+
+				if (tp[NL_POLICY_TYPE_ATTR_MIN_LENGTH])
+					fprintf(fp, " min len:%u",
+						rta_getattr_u32(tp[NL_POLICY_TYPE_ATTR_MIN_LENGTH]));
+
+				if (tp[NL_POLICY_TYPE_ATTR_MAX_LENGTH])
+					fprintf(fp, " max len:%u",
+						rta_getattr_u32(tp[NL_POLICY_TYPE_ATTR_MAX_LENGTH]));
+			}
+		}
+	}
 	/* end of family definitions .. */
 	fprintf(fp,"\n");
 	if (tb[CTRL_ATTR_OPS]) {
@@ -235,7 +308,9 @@ static int ctrl_list(int cmd, int argc, char **argv)
 		exit(1);
 	}
 
-	if (cmd == CTRL_CMD_GETFAMILY) {
+	if (cmd == CTRL_CMD_GETFAMILY || cmd == CTRL_CMD_GETPOLICY) {
+		req.g.cmd = cmd;
+
 		if (argc != 2) {
 			fprintf(stderr, "Wrong number of params\n");
 			return -1;
@@ -260,7 +335,9 @@ static int ctrl_list(int cmd, int argc, char **argv)
 			fprintf(stderr, "Wrong params\n");
 			goto ctrl_done;
 		}
+	}
 
+	if (cmd == CTRL_CMD_GETFAMILY) {
 		if (rtnl_talk(&rth, nlh, &answer) < 0) {
 			fprintf(stderr, "Error talking to the kernel\n");
 			goto ctrl_done;
@@ -273,7 +350,7 @@ static int ctrl_list(int cmd, int argc, char **argv)
 
 	}
 
-	if (cmd == CTRL_CMD_UNSPEC) {
+	if (cmd == CTRL_CMD_UNSPEC || cmd == CTRL_CMD_GETPOLICY) {
 		nlh->nlmsg_flags = NLM_F_ROOT|NLM_F_MATCH|NLM_F_REQUEST;
 		nlh->nlmsg_seq = rth.dump = ++rth.seq;
 
@@ -324,6 +401,8 @@ static int parse_ctrl(struct genl_util *a, int argc, char **argv)
 	    matches(*argv, "show") == 0 ||
 	    matches(*argv, "lst") == 0)
 		return ctrl_list(CTRL_CMD_UNSPEC, argc-1, argv+1);
+	if (matches(*argv, "policy") == 0)
+		return ctrl_list(CTRL_CMD_GETPOLICY, argc-1, argv+1);
 	if (matches(*argv, "help") == 0)
 		return usage();
 
-- 
2.26.2

