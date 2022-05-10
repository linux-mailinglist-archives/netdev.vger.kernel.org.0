Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA5B5212B9
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 12:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239336AbiEJKy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 06:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240187AbiEJKxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 06:53:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39FE82B0320
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 03:49:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 489FBB81CB3
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 10:49:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EEC1C385A6;
        Tue, 10 May 2022 10:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652179765;
        bh=f3wAxzZuaJVvubs7UniuqApoN0KAZ1lQTiDkYSb6WiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qrz+IHd9A+JdI3EdlF2+NmE5rvLXhP0PK0Yspnf0n2UrZGSmInyt+GcfosxxilUBJ
         9or42yAKJtpyidsK52CwKgZMelVKSb0l5zmMnZlFzb8TGMWJ+lu52TBQsDYO4gQLji
         wpBPDSuRZoPSlJna1ClDm+U/JQgbRMNMDWksAw9wwKtq2BwpgUN66uFpYo1E+mLnXU
         +ldARwHgm8vu5/t3xiuOiTDZN504VfZEJILRTKFSRu4hWf3fuPzTlw6HG9lrlUOB86
         bwxXb+r5YkTPOzPCBSluGN4oHpp4LU61x6PVL2bKyOu+wg+4Br1LfLbf94zbHzcOFU
         6TjjgzWuF/R8w==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        David Ahern <dsahern@gmail.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH iproute2-next 3/4] xfrm: add full offload mode to xfrm state
Date:   Tue, 10 May 2022 13:49:07 +0300
Message-Id: <100d6a0e10432177c75624965604e57ada077f2c.1652179360.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1652179360.git.leonro@nvidia.com>
References: <cover.1652179360.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Allow users to configure xfrm states with full offload type.

Full offload mode:
  ip xfrm state offload full dev <if-name> dir <in|out>
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
index 1c59596a..5117f483 100644
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
+			(xuo->flags & XFRM_OFFLOAD_FULL) ? "full" : "crypto");
 		fprintf(fp, "%s", _SL_);
 	}
 	if (tb[XFRMA_IF_ID]) {
diff --git a/ip/xfrm_state.c b/ip/xfrm_state.c
index 9b6659a1..44887249 100644
--- a/ip/xfrm_state.c
+++ b/ip/xfrm_state.c
@@ -61,7 +61,7 @@ static void usage(void)
 		"        [ replay-seq-hi SEQ ] [ replay-oseq-hi SEQ ]\n"
 		"        [ flag FLAG-LIST ] [ sel SELECTOR ] [ LIMIT-LIST ] [ encap ENCAP ]\n"
 		"        [ coa ADDR[/PLEN] ] [ ctx CTX ] [ extra-flag EXTRA-FLAG-LIST ]\n"
-		"        [ offload dev DEV dir DIR ]\n"
+		"        [ offload [ crypto | full ] dev DEV dir DIR ]\n"
 		"        [ output-mark OUTPUT-MARK [ mask MASK ] ]\n"
 		"        [ if_id IF_ID ] [ tfcpad LENGTH ]\n"
 		"Usage: ip xfrm state allocspi ID [ mode MODE ] [ mark MARK [ mask MASK ] ]\n"
@@ -312,7 +312,7 @@ static int xfrm_state_modify(int cmd, unsigned int flags, int argc, char **argv)
 	struct xfrm_user_offload xuo = {};
 	unsigned int ifindex = 0;
 	__u8 dir = 0;
-	bool is_offload = false;
+	bool is_offload = false, is_full_offload = false;
 	__u32 replay_window = 0;
 	__u32 seq = 0, oseq = 0, seq_hi = 0, oseq_hi = 0;
 	char *idp = NULL;
@@ -430,6 +430,16 @@ static int xfrm_state_modify(int cmd, unsigned int flags, int argc, char **argv)
 				  (void *)&ctx, ctx.sctx.len);
 		} else if (strcmp(*argv, "offload") == 0) {
 			NEXT_ARG();
+			/* If user doesn't provide offload mode, treat it as
+			 * crypto one for the backward compatibility.
+			 */
+			if (strcmp(*argv, "crypto") == 0)
+				NEXT_ARG();
+			else if (strcmp(*argv, "full") == 0) {
+				is_full_offload = true;
+				NEXT_ARG();
+			}
+
 			if (strcmp(*argv, "dev") == 0) {
 				NEXT_ARG();
 				ifindex = ll_name_to_index(*argv);
@@ -613,6 +623,8 @@ static int xfrm_state_modify(int cmd, unsigned int flags, int argc, char **argv)
 	if (is_offload) {
 		xuo.ifindex = ifindex;
 		xuo.flags = dir;
+		if (is_full_offload)
+			xuo.flags |= XFRM_OFFLOAD_FULL;
 		addattr_l(&req.n, sizeof(req.buf), XFRMA_OFFLOAD_DEV, &xuo,
 			  sizeof(xuo));
 	}
diff --git a/man/man8/ip-xfrm.8 b/man/man8/ip-xfrm.8
index 4243a023..e1b8aaab 100644
--- a/man/man8/ip-xfrm.8
+++ b/man/man8/ip-xfrm.8
@@ -66,6 +66,7 @@ ip-xfrm \- transform configuration
 .RB "[ " if_id
 .IR IF-ID " ]"
 .RB "[ " offload
+.RB "[ " crypto | full " ]"
 .RB dev
 .IR DEV "
 .RB dir
-- 
2.35.1

