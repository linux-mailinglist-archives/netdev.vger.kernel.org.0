Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3203B6A25CC
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 01:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjBYAiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 19:38:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjBYAiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 19:38:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E38CC05
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 16:38:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57B33B81C9D
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 00:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9419AC433EF;
        Sat, 25 Feb 2023 00:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677285486;
        bh=AdX72jlVm/0+yvkNH/fT0q6J2rJaaih3c4R3702wQQk=;
        h=From:To:Cc:Subject:Date:From;
        b=D6kdNU/nZHi9de5/IuwSPejzElzeeZjacBr0ru9HvZZGh94ICRdkO7uP1JNbvWMb6
         DTJlfiiOKWqxput9bPoBmtbVxiVRKb35Q3ZVHI72DbFfffzsjmJWe9Co90nzLnVVjY
         XviRiO3mOzIW/H+8SZOygKRC0Apg/0qEH6cCv2PdnmqIu8BiWlCC21OZcUT3xwn7rE
         cSjNkY2z/Z11yl2bWbEP7sWp4KoLxas/+NrbCcvPEv5bZkDOrBo6IuQeAiR37LktnL
         99vTwbUNU1m0PNTyszkvR4+RoxWM3v8QfJ68JHhBSfvF/oA7iwo6I4b98dOUXyHhaV
         Xi04xb5ZehoGA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     stephen@networkplumber.org
Cc:     dsahern@gmail.com, jhs@mojatatu.com, netdev@vger.kernel.org,
        johannes@sipsolutions.net, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH iproute2] genl: print caps for all families
Date:   Fri, 24 Feb 2023 16:37:54 -0800
Message-Id: <20230225003754.1726760-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Back in 2006 kernel commit 334c29a64507 ("[GENETLINK]: Move
command capabilities to flags.") removed some attributes and
moved the capabilities to flags. Corresponding iproute2
commit 26328fc3933f ("Add controller support for new features
exposed") added the ability to print those caps.

Printing is gated on version of the family, but we're checking
the version of each individual family rather than the control
family. The format of attributes in the control family
is dictated by the version of the control family alone.

In fact the entire version check is not strictly necessary.
The code is not using the old attributes, so on older kernels
it will simply print nothing either way.

Families can't use flags for random things, because kernel core
has a fixed interpretation.

Thanks to this change caps will be shown for all families
(assuming kernel newer than 2.6.19), not just those which
by coincidence have their local version >= 2.

For instance devlink, before:

  $ genl ctrl get name devlink
  Name: devlink
	ID: 0x15  Version: 0x1  header size: 0  max attribs: 179
	commands supported:
		#1:  ID-0x1
		#2:  ID-0x5
		#3:  ID-0x6
		...

after:

  $ genl ctrl get name devlink
  Name: devlink
	ID: 0x15  Version: 0x1  header size: 0  max attribs: 179
	commands supported:
		#1:  ID-0x1
		Capabilities (0xe):
 		  can doit; can dumpit; has policy

		#2:  ID-0x5
		Capabilities (0xe):
 		  can doit; can dumpit; has policy

		#3:  ID-0x6
		Capabilities (0xb):
 		  requires admin permission; can doit; has policy

Fixes: 26328fc3933f ("Add controller support for new features exposed")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 genl/ctrl.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/genl/ctrl.c b/genl/ctrl.c
index a2d87af0ad07..8d2e944802ba 100644
--- a/genl/ctrl.c
+++ b/genl/ctrl.c
@@ -57,7 +57,7 @@ static void print_ctrl_cmd_flags(FILE *fp, __u32 fl)
 	fprintf(fp, "\n");
 }
 
-static int print_ctrl_cmds(FILE *fp, struct rtattr *arg, __u32 ctrl_ver)
+static int print_ctrl_cmds(FILE *fp, struct rtattr *arg)
 {
 	struct rtattr *tb[CTRL_ATTR_OP_MAX + 1];
 
@@ -70,7 +70,7 @@ static int print_ctrl_cmds(FILE *fp, struct rtattr *arg, __u32 ctrl_ver)
 		fprintf(fp, " ID-0x%x ",*id);
 	}
 	/* we are only gonna do this for newer version of the controller */
-	if (tb[CTRL_ATTR_OP_FLAGS] && ctrl_ver >= 0x2) {
+	if (tb[CTRL_ATTR_OP_FLAGS]) {
 		__u32 *fl = RTA_DATA(tb[CTRL_ATTR_OP_FLAGS]);
 		print_ctrl_cmd_flags(fp, *fl);
 	}
@@ -78,7 +78,7 @@ static int print_ctrl_cmds(FILE *fp, struct rtattr *arg, __u32 ctrl_ver)
 
 }
 
-static int print_ctrl_grp(FILE *fp, struct rtattr *arg, __u32 ctrl_ver)
+static int print_ctrl_grp(FILE *fp, struct rtattr *arg)
 {
 	struct rtattr *tb[CTRL_ATTR_MCAST_GRP_MAX + 1];
 
@@ -109,7 +109,6 @@ static int print_ctrl(struct rtnl_ctrl_data *ctrl,
 	int len = n->nlmsg_len;
 	struct rtattr *attrs;
 	FILE *fp = (FILE *) arg;
-	__u32 ctrl_v = 0x1;
 
 	if (n->nlmsg_type !=  GENL_ID_CTRL) {
 		fprintf(stderr, "Not a controller message, nlmsg_len=%d "
@@ -148,7 +147,6 @@ static int print_ctrl(struct rtnl_ctrl_data *ctrl,
 	if (tb[CTRL_ATTR_VERSION]) {
 		__u32 *v = RTA_DATA(tb[CTRL_ATTR_VERSION]);
 		fprintf(fp, " Version: 0x%x ",*v);
-		ctrl_v = *v;
 	}
 	if (tb[CTRL_ATTR_HDRSIZE]) {
 		__u32 *h = RTA_DATA(tb[CTRL_ATTR_HDRSIZE]);
@@ -198,7 +196,7 @@ static int print_ctrl(struct rtnl_ctrl_data *ctrl,
 		for (i = 0; i < GENL_MAX_FAM_OPS; i++) {
 			if (tb2[i]) {
 				fprintf(fp, "\t\t#%d: ", i);
-				if (0 > print_ctrl_cmds(fp, tb2[i], ctrl_v)) {
+				if (0 > print_ctrl_cmds(fp, tb2[i])) {
 					fprintf(fp, "Error printing command\n");
 				}
 				/* for next command */
@@ -221,7 +219,7 @@ static int print_ctrl(struct rtnl_ctrl_data *ctrl,
 		for (i = 0; i < GENL_MAX_FAM_GRPS; i++) {
 			if (tb2[i]) {
 				fprintf(fp, "\t\t#%d: ", i);
-				if (0 > print_ctrl_grp(fp, tb2[i], ctrl_v))
+				if (0 > print_ctrl_grp(fp, tb2[i]))
 					fprintf(fp, "Error printing group\n");
 				/* for next group */
 				fprintf(fp,"\n");
-- 
2.39.2

