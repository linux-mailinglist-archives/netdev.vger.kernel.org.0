Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF14B58BFE9
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 03:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242954AbiHHBo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Aug 2022 21:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242765AbiHHBmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Aug 2022 21:42:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4D6DF5F;
        Sun,  7 Aug 2022 18:35:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66A1860DDA;
        Mon,  8 Aug 2022 01:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97592C433D6;
        Mon,  8 Aug 2022 01:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922547;
        bh=y4Aevf3JyDfY01pNXfphhFLZRFuuzUzFl6WyuCwGXNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IRbBqORWn8HRNmbfT0IfJJhboul3BCiJ5x4MNZbc4dPjsqqc4MIeKpXnqk2mwvggb
         SemoJwrCyWoB1RxX97oeEWy45UlFZqsb/4aDlX0oCqdTc29fPwf/6EE1UhYQ1LXvnb
         bCgf0ZSuMIOqKoDS6lc/OAvKIYOhSoFuLtuoha/fyykoRrobktFGjDtXhqagifRevH
         LhLi6fg4nO6QfIpUzd/x7CBDsSqI5qs0iemUWglz1tv2vPw49glcSNw4IPg6Fr4O8R
         uoaG/27ijU2pgaToxeIlmvwDZuXHelRLLScT2crInWoIC9eDCQ2Be4wrO1VK+yGPxV
         7Il2PU3lWKHaw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, imagedong@tencent.com,
        luiz.von.dentz@intel.com, vasily.averin@linux.dev,
        jk@codeconstruct.com.au, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 52/53] skbuff: don't mix ubuf_info from different sources
Date:   Sun,  7 Aug 2022 21:33:47 -0400
Message-Id: <20220808013350.314757-52-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013350.314757-1-sashal@kernel.org>
References: <20220808013350.314757-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 1b4b2b09d4fb451029b112f17d34792e0277aeb2 ]

We should not append MSG_ZEROCOPY requests to skbuff with non
MSG_ZEROCOPY ubuf_info, they might be not compatible.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index c90c74de90d5..7d35cee8b00e 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1210,6 +1210,10 @@ struct ubuf_info *msg_zerocopy_realloc(struct sock *sk, size_t size,
 		const u32 byte_limit = 1 << 19;		/* limit to a few TSO */
 		u32 bytelen, next;
 
+		/* there might be non MSG_ZEROCOPY users */
+		if (uarg->callback != msg_zerocopy_callback)
+			return NULL;
+
 		/* realloc only when socket is locked (TCP, UDP cork),
 		 * so uarg->len and sk_zckey access is serialized
 		 */
-- 
2.35.1

