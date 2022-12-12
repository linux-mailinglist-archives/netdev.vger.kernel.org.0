Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B602A6499C9
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 08:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbiLLHyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 02:54:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbiLLHyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 02:54:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62410B84D
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 23:54:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2105FB80B83
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 07:54:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3CDC433EF;
        Mon, 12 Dec 2022 07:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670831669;
        bh=9Z9fWa06tNgRSrIq7xZY1/Knp1gppPuspRW3Zh83VwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W97oiqtyRrl0qMilMRwJMSUEeP5Lkv5ysuBhSuvtxp21+BQTMwVXrGUgpkQxUOF/t
         MvKpm3r18hpPdiC3JeLPkHzW7g+HvKHu6+986GXf59f+oO8xlb7PufPa3iUDgnmQNe
         FEWEzcPt/me/O41Viwj4U7SJFeNrBiL5126a4HJ/FYal7iX0prBdaCrFDejEQ0PiRx
         WEU1/Tl503WOE6GM8Jus1y4WtlFauInrLRGFaCdRJ1SUr96z0KDXnYcpqFb4fBKxgH
         SDhqk4cArcNRsHTjxJ2yGk/5C+d7HaDfrXEGMWDRXLkJaAx7P4ocUtDbMbmPX0PSGp
         GRaoqly1J4IBQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        David Ahern <dsahern@gmail.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>
Subject: [PATCH iproute2-next v1 3/4] xfrm: add packet offload mode to xfrm state
Date:   Mon, 12 Dec 2022 09:54:05 +0200
Message-Id: <9cbedf046af7c8014bc3295005d645e56a230da4.1670830561.git.leonro@nvidia.com>
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

Allow users to configure xfrm states with packet offload type.

Packet offload mode:
  ip xfrm state offload packet dev <if-name> dir <in|out>
Crypto offload mode:
  ip xfrm state offload crypto dev <if-name> dir <in|out>
  ip xfrm state offload dev <if-name> dir <in|out>

The latter variant configures crypto offload mode and is needed
to provide backward compatibility.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 ip/ipxfrm.c        |  6 ++++--
 ip/xfrm_state.c    | 16 ++++++++++++++--
 man/man8/ip-xfrm.8 |  1 +
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/ip/ipxfrm.c b/ip/ipxfrm.c
index 1c59596a..deb45817 100644
--- a/ip/ipxfrm.c
+++ b/ip/ipxfrm.c
@@ -895,8 +895,10 @@ void xfrm_xfrma_print(struct rtattr *tb[], __u16 family,
 
 		xuo = (struct xfrm_user_offload *)
 			RTA_DATA(tb[XFRMA_OFFLOAD_DEV]);
-		fprintf(fp, "dev %s dir %s", ll_index_to_name(xuo->ifindex),
-			(xuo->flags & XFRM_OFFLOAD_INBOUND) ? "in" : "out");
+		fprintf(fp, "dev %s dir %s mode %s",
+			ll_index_to_name(xuo->ifindex),
+			(xuo->flags & XFRM_OFFLOAD_INBOUND) ? "in" : "out",
+			(xuo->flags & XFRM_OFFLOAD_PACKET) ? "packet" : "crypto");
 		fprintf(fp, "%s", _SL_);
 	}
 	if (tb[XFRMA_IF_ID]) {
diff --git a/ip/xfrm_state.c b/ip/xfrm_state.c
index 6de2d28d..16c65e23 100644
--- a/ip/xfrm_state.c
+++ b/ip/xfrm_state.c
@@ -61,7 +61,7 @@ static void usage(void)
 		"        [ replay-seq-hi SEQ ] [ replay-oseq-hi SEQ ]\n"
 		"        [ flag FLAG-LIST ] [ sel SELECTOR ] [ LIMIT-LIST ] [ encap ENCAP ]\n"
 		"        [ coa ADDR[/PLEN] ] [ ctx CTX ] [ extra-flag EXTRA-FLAG-LIST ]\n"
-		"        [ offload dev DEV dir DIR ]\n"
+		"        [ offload [ crypto | packet ] dev DEV dir DIR ]\n"
 		"        [ output-mark OUTPUT-MARK [ mask MASK ] ]\n"
 		"        [ if_id IF_ID ] [ tfcpad LENGTH ]\n"
 		"Usage: ip xfrm state allocspi ID [ mode MODE ] [ mark MARK [ mask MASK ] ]\n"
@@ -307,7 +307,7 @@ static int xfrm_state_modify(int cmd, unsigned int flags, int argc, char **argv)
 	struct xfrm_user_offload xuo = {};
 	unsigned int ifindex = 0;
 	__u8 dir = 0;
-	bool is_offload = false;
+	bool is_offload = false, is_packet_offload = false;
 	__u32 replay_window = 0;
 	__u32 seq = 0, oseq = 0, seq_hi = 0, oseq_hi = 0;
 	char *idp = NULL;
@@ -425,6 +425,16 @@ static int xfrm_state_modify(int cmd, unsigned int flags, int argc, char **argv)
 				  (void *)&ctx, ctx.sctx.len);
 		} else if (strcmp(*argv, "offload") == 0) {
 			NEXT_ARG();
+			/* If user doesn't provide offload mode, treat it as
+			 * crypto one for the backward compatibility.
+			 */
+			if (strcmp(*argv, "crypto") == 0)
+				NEXT_ARG();
+			else if (strcmp(*argv, "packet") == 0) {
+				is_packet_offload = true;
+				NEXT_ARG();
+			}
+
 			if (strcmp(*argv, "dev") == 0) {
 				NEXT_ARG();
 				ifindex = ll_name_to_index(*argv);
@@ -608,6 +618,8 @@ static int xfrm_state_modify(int cmd, unsigned int flags, int argc, char **argv)
 	if (is_offload) {
 		xuo.ifindex = ifindex;
 		xuo.flags = dir;
+		if (is_packet_offload)
+			xuo.flags |= XFRM_OFFLOAD_PACKET;
 		addattr_l(&req.n, sizeof(req.buf), XFRMA_OFFLOAD_DEV, &xuo,
 			  sizeof(xuo));
 	}
diff --git a/man/man8/ip-xfrm.8 b/man/man8/ip-xfrm.8
index 4243a023..a65cfa5f 100644
--- a/man/man8/ip-xfrm.8
+++ b/man/man8/ip-xfrm.8
@@ -66,6 +66,7 @@ ip-xfrm \- transform configuration
 .RB "[ " if_id
 .IR IF-ID " ]"
 .RB "[ " offload
+.RB "[ " crypto | packet " ]"
 .RB dev
 .IR DEV "
 .RB dir
-- 
2.38.1

