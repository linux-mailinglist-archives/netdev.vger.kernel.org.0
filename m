Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B60361A09F
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 20:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiKDTNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 15:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiKDTNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 15:13:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA794AF1A
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 12:13:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2644B82CD4
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 19:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC2DC433B5;
        Fri,  4 Nov 2022 19:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667589227;
        bh=YcbSssnL6pz5AMDkjvR2SMIJDO+wh5xCjQFRj5Yevmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YoBuqirki9+UuA0unWlC+928wD+90Uf8n+y1fYfc9cRlgmh9nWLJFoyHVFuQ2PNZK
         xagJxO+KxKNGhQYv8UFy2cJGEiYbgRgYnUmMZwficTvzElCuE/K9wEP3x76uUZQUIs
         k9ElTSGyYN2doBs+cDlxO5GngCRunvDRGPxYl4nvo9JB8RpeDHKFu0CLAqXfDXMEcg
         8RtsaRSzcs4ssgL/+84yVrMPp62k6gjqaHLbmzgJq4ozzpNu4hHu1m1YQRDxCEse9A
         TQSJ002S6R7Tqi27fuShynldp2JmD2zeYPdCXgonNXbCkqFqR51g3n7dp58sLD7P8w
         H9b5y6R5Xla6w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 01/13] genetlink: refactor the cmd <> policy mapping dump
Date:   Fri,  4 Nov 2022 12:13:31 -0700
Message-Id: <20221104191343.690543-2-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221104191343.690543-1-kuba@kernel.org>
References: <20221104191343.690543-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code at the top of ctrl_dumppolicy() dumps mappings between
ops and policies. It supports dumping both the entire family and
single op if dump is filtered. But both of those cases are handled
inside a loop, which makes the logic harder to follow and change.
Refactor to split the two cases more clearly.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
v2: bring the comment back
---
 net/netlink/genetlink.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 3e16527beb91..0a7a856e9ce0 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1319,21 +1319,24 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 	void *hdr;
 
 	if (!ctx->policies) {
-		while (ctx->opidx < genl_get_cmd_cnt(ctx->rt)) {
-			struct genl_ops op;
+		struct genl_ops op;
 
-			if (ctx->single_op) {
-				int err;
+		if (ctx->single_op) {
+			int err;
 
-				err = genl_get_cmd(ctx->op, ctx->rt, &op);
-				if (WARN_ON(err))
-					return skb->len;
+			err = genl_get_cmd(ctx->op, ctx->rt, &op);
+			if (WARN_ON(err))
+				return err;
 
-				/* break out of the loop after this one */
-				ctx->opidx = genl_get_cmd_cnt(ctx->rt);
-			} else {
-				genl_get_cmd_by_index(ctx->opidx, ctx->rt, &op);
-			}
+			if (ctrl_dumppolicy_put_op(skb, cb, &op))
+				return skb->len;
+
+			/* don't enter the loop below */
+			ctx->opidx = genl_get_cmd_cnt(ctx->rt);
+		}
+
+		while (ctx->opidx < genl_get_cmd_cnt(ctx->rt)) {
+			genl_get_cmd_by_index(ctx->opidx, ctx->rt, &op);
 
 			if (ctrl_dumppolicy_put_op(skb, cb, &op))
 				return skb->len;
-- 
2.38.1

