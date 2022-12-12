Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 999A66499CA
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 08:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbiLLHyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 02:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbiLLHyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 02:54:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B17CE2D
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 23:54:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55181B80B9A
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 07:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7003CC433F0;
        Mon, 12 Dec 2022 07:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670831674;
        bh=2wzGZKeJQvdu1+8luLE7TSHGEkwo6i7uf+AgmcJcad4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gbz1KfPvvULQue2sSs02kCGmCAoUPubhXVeXHotXDqej7ZeYfcjsPljnJhwh27LLd
         sEtBxSvXKV/c43O2rtTE+bmY1GWGHvce2fepCt4zIXNJRxgXjy9Hl1rfg0qnU6Dbv8
         /yGY7wtEOD8PF/NDkLHkQm+328KYXG41e63VDjxsQlOLutpBaa2oOPKQOfaTqxkmor
         V+Fumn1BGrZIA/bW3GS7QtHCGzvIR/OuYXnvAqGprDMpE1C4FvaeqDHsgeco8mrpOr
         9WaH0DXYigLssDrpEMAlqW0y7jk41fg2+UT1dJibuc2/B/lBOR9HNgIKn142u/6CVA
         ic5heRGJsxfTQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        David Ahern <dsahern@gmail.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>
Subject: [PATCH iproute2-next v1 4/4] xfrm: add an interface to offload policy
Date:   Mon, 12 Dec 2022 09:54:06 +0200
Message-Id: <b4a4601523a55b99d0ffdb3ffbcd7103c29cc0fe.1670830561.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670830561.git.leonro@nvidia.com>
References: <cover.1670830561.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

Extend at "ip xfrm policy" to allow policy offload to specific device.
The syntax and the code follow already established pattern from the
state offload.

The only difference between them is that direction was already mandatory
argument in policy configuration commands, so don't need to add direction
handling logic like it was done for the state offload.

The syntax is as follows:
 $ ip xfrm policy .... offload packet dev <if-name>

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 ip/ipxfrm.c        | 17 ++++++++++-------
 ip/xfrm.h          |  4 ++--
 ip/xfrm_monitor.c  |  2 +-
 ip/xfrm_policy.c   | 26 ++++++++++++++++++++++++++
 man/man8/ip-xfrm.8 |  8 ++++++++
 5 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/ip/ipxfrm.c b/ip/ipxfrm.c
index deb45817..7a1ebc95 100644
--- a/ip/ipxfrm.c
+++ b/ip/ipxfrm.c
@@ -688,8 +688,8 @@ done:
 	return 0;
 }
 
-void xfrm_xfrma_print(struct rtattr *tb[], __u16 family,
-		      FILE *fp, const char *prefix, bool nokeys)
+void xfrm_xfrma_print(struct rtattr *tb[], __u16 family, FILE *fp,
+		      const char *prefix, bool nokeys, bool dir)
 {
 	if (tb[XFRMA_MARK]) {
 		struct rtattr *rta = tb[XFRMA_MARK];
@@ -895,9 +895,12 @@ void xfrm_xfrma_print(struct rtattr *tb[], __u16 family,
 
 		xuo = (struct xfrm_user_offload *)
 			RTA_DATA(tb[XFRMA_OFFLOAD_DEV]);
-		fprintf(fp, "dev %s dir %s mode %s",
-			ll_index_to_name(xuo->ifindex),
-			(xuo->flags & XFRM_OFFLOAD_INBOUND) ? "in" : "out",
+		fprintf(fp, "dev %s ",
+			ll_index_to_name(xuo->ifindex));
+		if (dir)
+			fprintf(fp, "dir %s ",
+			(xuo->flags & XFRM_OFFLOAD_INBOUND) ? "in" : "out");
+		fprintf(fp, "mode %s",
 			(xuo->flags & XFRM_OFFLOAD_PACKET) ? "packet" : "crypto");
 		fprintf(fp, "%s", _SL_);
 	}
@@ -990,7 +993,7 @@ void xfrm_state_info_print(struct xfrm_usersa_info *xsinfo,
 		fprintf(fp, " (0x%s)", strxf_mask8(xsinfo->flags));
 	fprintf(fp, "%s", _SL_);
 
-	xfrm_xfrma_print(tb, xsinfo->family, fp, buf, nokeys);
+	xfrm_xfrma_print(tb, xsinfo->family, fp, buf, nokeys, true);
 
 	if (!xfrm_selector_iszero(&xsinfo->sel)) {
 		char sbuf[STRBUF_SIZE];
@@ -1096,7 +1099,7 @@ void xfrm_policy_info_print(struct xfrm_userpolicy_info *xpinfo,
 	if (show_stats > 0)
 		xfrm_lifetime_print(&xpinfo->lft, &xpinfo->curlft, fp, buf);
 
-	xfrm_xfrma_print(tb, xpinfo->sel.family, fp, buf, false);
+	xfrm_xfrma_print(tb, xpinfo->sel.family, fp, buf, false, false);
 }
 
 int xfrm_id_parse(xfrm_address_t *saddr, struct xfrm_id *id, __u16 *family,
diff --git a/ip/xfrm.h b/ip/xfrm.h
index 17dcf3fe..6f251603 100644
--- a/ip/xfrm.h
+++ b/ip/xfrm.h
@@ -124,8 +124,8 @@ const char *strxf_proto(__u8 proto);
 const char *strxf_ptype(__u8 ptype);
 void xfrm_selector_print(struct xfrm_selector *sel, __u16 family,
 			 FILE *fp, const char *prefix);
-void xfrm_xfrma_print(struct rtattr *tb[], __u16 family,
-		      FILE *fp, const char *prefix, bool nokeys);
+void xfrm_xfrma_print(struct rtattr *tb[], __u16 family, FILE *fp,
+		      const char *prefix, bool nokeys, bool dir);
 void xfrm_state_info_print(struct xfrm_usersa_info *xsinfo,
 			    struct rtattr *tb[], FILE *fp, const char *prefix,
 			   const char *title, bool nokeys);
diff --git a/ip/xfrm_monitor.c b/ip/xfrm_monitor.c
index f67424c5..b0056d9d 100644
--- a/ip/xfrm_monitor.c
+++ b/ip/xfrm_monitor.c
@@ -199,7 +199,7 @@ static int xfrm_report_print(struct nlmsghdr *n, void *arg)
 
 	parse_rtattr(tb, XFRMA_MAX, XFRMREP_RTA(xrep), len);
 
-	xfrm_xfrma_print(tb, family, fp, "  ", nokeys);
+	xfrm_xfrma_print(tb, family, fp, "  ", nokeys, true);
 
 	if (oneline)
 		fprintf(fp, "\n");
diff --git a/ip/xfrm_policy.c b/ip/xfrm_policy.c
index 4d825025..be5fcfed 100644
--- a/ip/xfrm_policy.c
+++ b/ip/xfrm_policy.c
@@ -57,6 +57,7 @@ static void usage(void)
 		"	[ mark MARK [ mask MASK ] ] [ index INDEX ] [ ptype PTYPE ]\n"
 		"	[ action ACTION ] [ priority PRIORITY ] [ flag FLAG-LIST ]\n"
 		"	[ if_id IF_ID ] [ LIMIT-LIST ] [ TMPL-LIST ]\n"
+		"	[ offload packet dev DEV] } ]\n"
 		"Usage: ip xfrm policy { delete | get } { SELECTOR | index INDEX } dir DIR\n"
 		"	[ ctx CTX ] [ mark MARK [ mask MASK ] ] [ ptype PTYPE ]\n"
 		"	[ if_id IF_ID ]\n"
@@ -260,6 +261,7 @@ static int xfrm_policy_modify(int cmd, unsigned int flags, int argc, char **argv
 	char *ptypep = NULL;
 	char *sctxp = NULL;
 	struct xfrm_userpolicy_type upt = {};
+	struct xfrm_user_offload xuo = {};
 	char tmpls_buf[XFRM_TMPLS_BUF_SIZE] = {};
 	int tmpls_len = 0;
 	struct xfrm_mark mark = {0, 0};
@@ -268,6 +270,8 @@ static int xfrm_policy_modify(int cmd, unsigned int flags, int argc, char **argv
 		char	str[CTX_BUF_SIZE];
 	} ctx = {};
 	bool is_if_id_set = false;
+	unsigned int ifindex = 0;
+	bool is_offload = false;
 	__u32 if_id = 0;
 
 	while (argc > 0) {
@@ -342,6 +346,21 @@ static int xfrm_policy_modify(int cmd, unsigned int flags, int argc, char **argv
 			if (get_u32(&if_id, *argv, 0))
 				invarg("IF_ID value is invalid", *argv);
 			is_if_id_set = true;
+		} else if (strcmp(*argv, "offload") == 0) {
+			NEXT_ARG();
+			if (strcmp(*argv, "packet") == 0)
+				NEXT_ARG();
+			else
+				invarg("Invalid offload mode", *argv);
+
+			if (strcmp(*argv, "dev") == 0) {
+				NEXT_ARG();
+				ifindex = ll_name_to_index(*argv);
+				if (!ifindex)
+					invarg("Invalid device name", *argv);
+			} else
+				invarg("Missing dev keyword", *argv);
+			is_offload = true;
 		} else {
 			if (selp)
 				duparg("unknown", *argv);
@@ -387,6 +406,13 @@ static int xfrm_policy_modify(int cmd, unsigned int flags, int argc, char **argv
 	if (is_if_id_set)
 		addattr32(&req.n, sizeof(req.buf), XFRMA_IF_ID, if_id);
 
+	if (is_offload) {
+		xuo.ifindex = ifindex;
+		xuo.flags |= XFRM_OFFLOAD_PACKET;
+		addattr_l(&req.n, sizeof(req.buf), XFRMA_OFFLOAD_DEV, &xuo,
+			  sizeof(xuo));
+	}
+
 	if (rtnl_open_byproto(&rth, 0, NETLINK_XFRM) < 0)
 		exit(1);
 
diff --git a/man/man8/ip-xfrm.8 b/man/man8/ip-xfrm.8
index a65cfa5f..3270f336 100644
--- a/man/man8/ip-xfrm.8
+++ b/man/man8/ip-xfrm.8
@@ -252,6 +252,10 @@ ip-xfrm \- transform configuration
 .IR FLAG-LIST " ]"
 .RB "[ " if_id
 .IR IF-ID " ]"
+.RB "[ " offload
+.RB packet
+.RB dev
+.IR DEV " ]"
 .RI "[ " LIMIT-LIST " ] [ " TMPL-LIST " ]"
 
 .ti -8
@@ -593,6 +597,10 @@ of the packets emitted by the state
 .I IF-ID
 xfrm interface identifier used to in both xfrm policies and states
 
+.TP
+.I DEV
+Network interface name used to offload policies and states
+
 .sp
 .PP
 .TS
-- 
2.38.1

