Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B826499CB
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 08:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbiLLHyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 02:54:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbiLLHyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 02:54:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F490B84D
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 23:54:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9C9DB80B83
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 07:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C08FAC433D2;
        Mon, 12 Dec 2022 07:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670831678;
        bh=GTwvNyugaQUC66kTKwraZVvM6vyshj9vpIpNccMIgIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Crh85dGDl0D1OUo5yaY7Gn/9BhBWpy7+YZO2Asb7bK8d1OrP4//g6cZPlhCz4bjLU
         z2BE5G73PL9Awq4y0hxZrNu8bGl0PYIz97f0xwo+PDCtqJshdPCHWoylwcKcEid9/x
         A4mrgc4XLUEMhf8UPwkW/QvUL7GlUFZ+FeJtc8MLM5NItgVY9Wi3fxxFmhDCkgYeXu
         ETw6E00maQbhRewJL5AUR1uittJYWmPozsF+vg3t0GFsa0X1mqSwRj8cg/983j3lOM
         VamLgyKmnmgGDea2wEtGK9ZdWaaY5jkyFfE1ZL26p9l9022V3C3wv14i25Y48g4i7h
         FUGV4SGZQHKVg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        David Ahern <dsahern@gmail.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>
Subject: [PATCH iproute2-next v1 2/4] xfrm: prepare state offload logic to set mode
Date:   Mon, 12 Dec 2022 09:54:04 +0200
Message-Id: <0daa98d7cfb4e70856d13444d4bf6c4b3270a826.1670830561.git.leonro@nvidia.com>
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

The offload in xfrm state requires to provide device and direction
in order to activate it. However, in the help section, device and
direction were displayed as an optional.

As a preparation to addition of packet offload, let's fix the help
section and refactor the code to be more clear.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 ip/xfrm_state.c    | 35 +++++++++++++++++++----------------
 man/man8/ip-xfrm.8 |  5 +++++
 2 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/ip/xfrm_state.c b/ip/xfrm_state.c
index b2294d9f..6de2d28d 100644
--- a/ip/xfrm_state.c
+++ b/ip/xfrm_state.c
@@ -61,7 +61,7 @@ static void usage(void)
 		"        [ replay-seq-hi SEQ ] [ replay-oseq-hi SEQ ]\n"
 		"        [ flag FLAG-LIST ] [ sel SELECTOR ] [ LIMIT-LIST ] [ encap ENCAP ]\n"
 		"        [ coa ADDR[/PLEN] ] [ ctx CTX ] [ extra-flag EXTRA-FLAG-LIST ]\n"
-		"        [ offload [dev DEV] dir DIR ]\n"
+		"        [ offload dev DEV dir DIR ]\n"
 		"        [ output-mark OUTPUT-MARK [ mask MASK ] ]\n"
 		"        [ if_id IF_ID ] [ tfcpad LENGTH ]\n"
 		"Usage: ip xfrm state allocspi ID [ mode MODE ] [ mark MARK [ mask MASK ] ]\n"
@@ -267,7 +267,7 @@ static int xfrm_state_extra_flag_parse(__u32 *extra_flags, int *argcp, char ***a
 	return 0;
 }
 
-static int xfrm_offload_dir_parse(__u8 *dir, int *argcp, char ***argvp)
+static bool xfrm_offload_dir_parse(__u8 *dir, int *argcp, char ***argvp)
 {
 	int argc = *argcp;
 	char **argv = *argvp;
@@ -277,12 +277,12 @@ static int xfrm_offload_dir_parse(__u8 *dir, int *argcp, char ***argvp)
 	else if (strcmp(*argv, "out") == 0)
 		*dir = 0;
 	else
-		invarg("DIR value is invalid", *argv);
+		return false;
 
 	*argcp = argc;
 	*argvp = argv;
 
-	return 0;
+	return true;
 }
 
 static int xfrm_state_modify(int cmd, unsigned int flags, int argc, char **argv)
@@ -424,24 +424,27 @@ static int xfrm_state_modify(int cmd, unsigned int flags, int argc, char **argv)
 			addattr_l(&req.n, sizeof(req.buf), XFRMA_SEC_CTX,
 				  (void *)&ctx, ctx.sctx.len);
 		} else if (strcmp(*argv, "offload") == 0) {
-			is_offload = true;
 			NEXT_ARG();
 			if (strcmp(*argv, "dev") == 0) {
 				NEXT_ARG();
 				ifindex = ll_name_to_index(*argv);
-				if (!ifindex) {
-					invarg("value after \"offload dev\" is invalid", *argv);
-					is_offload = false;
-				}
-				NEXT_ARG();
-			}
+				if (!ifindex)
+					invarg("Invalid device name", *argv);
+			} else
+				invarg("Missing dev keyword", *argv);
+
+			NEXT_ARG();
 			if (strcmp(*argv, "dir") == 0) {
+				bool is_dir;
+
 				NEXT_ARG();
-				xfrm_offload_dir_parse(&dir, &argc, &argv);
-			} else {
-				invarg("value after \"offload dir\" is invalid", *argv);
-				is_offload = false;
-			}
+				is_dir = xfrm_offload_dir_parse(&dir, &argc,
+								&argv);
+				if (!is_dir)
+					invarg("DIR value is invalid", *argv);
+			} else
+				invarg("Missing DIR keyword", *argv);
+			is_offload = true;
 		} else if (strcmp(*argv, "output-mark") == 0) {
 			NEXT_ARG();
 			if (get_u32(&output_mark.v, *argv, 0))
diff --git a/man/man8/ip-xfrm.8 b/man/man8/ip-xfrm.8
index bf725cab..4243a023 100644
--- a/man/man8/ip-xfrm.8
+++ b/man/man8/ip-xfrm.8
@@ -65,6 +65,11 @@ ip-xfrm \- transform configuration
 .IR MASK " ] ]"
 .RB "[ " if_id
 .IR IF-ID " ]"
+.RB "[ " offload
+.RB dev
+.IR DEV "
+.RB dir
+.IR DIR " ]"
 .RB "[ " tfcpad
 .IR LENGTH " ]"
 
-- 
2.38.1

