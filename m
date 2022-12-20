Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE96651738
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 01:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232726AbiLTArJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 19:47:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiLTArI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 19:47:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044FFDF8C;
        Mon, 19 Dec 2022 16:47:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86E9B61166;
        Tue, 20 Dec 2022 00:47:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89814C433F0;
        Tue, 20 Dec 2022 00:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671497226;
        bh=bd2xDZMGKClu9pB0PLW4rTKBrXiSlJjJNAS+REMWbe8=;
        h=From:To:Cc:Subject:Date:From;
        b=OBSnvldohsaH2riZWNyeuK+gyQf91MBX5bJ8vtEnRlOg+2V/jdI8uFxucwuh0xoaz
         q/sNEhqrEw37e+/rk0uSJf503XA2NyzmEQfxcHXKAlh6IKXio216sg16/CMA1Xib9H
         jhwT8dHxZnvU8AHNAn4oq5rZ5aOFdyRCG0Q8beVKxgvDLHK6rO38geU7LmRrct1nPG
         vtfTVi+t5JszevGLwSh8ivMMZQFu1Za88t+9VZ052yqK8deagkEGBBVHcSbCBlxsPq
         yJTk/qFEcqR+3qFY+w2Zic/OS4dNQiu7n1RNAKAzsdTNNdiLuW0esDWmCj5CeI8CYQ
         YGD4hpmUDdG2w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Anand Parthasarathy <anpartha@meta.com>, martin.lau@linux.dev,
        song@kernel.org, john.fastabend@gmail.com, sdf@google.com
Subject: [PATCH bpf 1/2] bpf: pull before calling skb_postpull_rcsum()
Date:   Mon, 19 Dec 2022 16:47:00 -0800
Message-Id: <20221220004701.402165-1-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
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

Anand hit a BUG() when pulling off headers on egress to a SW tunnel.
We get to skb_checksum_help() with an invalid checksum offset
(commit d7ea0d9df2a6 ("net: remove two BUG() from skb_checksum_help()")
converted those BUGs to WARN_ONs()).
He points out oddness in how skb_postpull_rcsum() gets used.
Indeed looks like we should pull before "postpull", otherwise
the CHECKSUM_PARTIAL fixup from skb_postpull_rcsum() will not
be able to do its job:

	if (skb->ip_summed == CHECKSUM_PARTIAL &&
	    skb_checksum_start_offset(skb) < 0)
		skb->ip_summed = CHECKSUM_NONE;

Reported-by: Anand Parthasarathy <anpartha@meta.com>
Fixes: 6578171a7ff0 ("bpf: add bpf_skb_change_proto helper")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: daniel@iogearbox.net
CC: martin.lau@linux.dev
CC: song@kernel.org
CC: john.fastabend@gmail.com
CC: sdf@google.com
CC: bpf@vger.kernel.org
---
 net/core/filter.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 929358677183..43cc1fe58a2c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3180,15 +3180,18 @@ static int bpf_skb_generic_push(struct sk_buff *skb, u32 off, u32 len)
 
 static int bpf_skb_generic_pop(struct sk_buff *skb, u32 off, u32 len)
 {
+	void *old_data;
+
 	/* skb_ensure_writable() is not needed here, as we're
 	 * already working on an uncloned skb.
 	 */
 	if (unlikely(!pskb_may_pull(skb, off + len)))
 		return -ENOMEM;
 
-	skb_postpull_rcsum(skb, skb->data + off, len);
-	memmove(skb->data + len, skb->data, off);
+	old_data = skb->data;
 	__skb_pull(skb, len);
+	skb_postpull_rcsum(skb, old_data + off, len);
+	memmove(skb->data, old_data, off);
 
 	return 0;
 }
-- 
2.38.1

