Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7A858BF59
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 03:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242341AbiHHBiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Aug 2022 21:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242221AbiHHBg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Aug 2022 21:36:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BFDD130;
        Sun,  7 Aug 2022 18:33:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D330860DEE;
        Mon,  8 Aug 2022 01:33:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9962C433C1;
        Mon,  8 Aug 2022 01:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922421;
        bh=zZLDHHd0Qdeu6E00S1cCsh+AbJ9Lh/8AnVD2hHiK58M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PeqWfIZLvC5sxFVDJxYUHm9RB+WVoeeQy9UuKn0ZWHt21CYv+mB+m4KqlTViHR1sN
         UfUiVS46hYP4s/VGyOKpKT3E2ZEkB8CjGoVnf+5TS5TcVDUJqMF6LJ7csEO1OBphW3
         /qIi/RbnZNg1CpU60h36BUNUauwcoa6yCui9vPzuvCDRGSUGmyxn11iHYe5YXpxqXg
         /nWJ4Q4bf3xO6Za7CUj/QZDfqIvmw/WJHGjc37XnCplg+9cGaxugVFGi4m+U+QDqH9
         +IWD08UELI2kT01ZufRS8+NUvA+sZBuQcICgjP2g+oC3cJkygBZ76/O317kh8+lMU5
         7K+YLl+IeIZHg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, imagedong@tencent.com,
        luiz.von.dentz@intel.com, vasily.averin@linux.dev,
        jk@codeconstruct.com.au, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 55/58] skbuff: don't mix ubuf_info from different sources
Date:   Sun,  7 Aug 2022 21:31:13 -0400
Message-Id: <20220808013118.313965-55-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013118.313965-1-sashal@kernel.org>
References: <20220808013118.313965-1-sashal@kernel.org>
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
index 5b3559cb1d82..09f56bfa2771 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1212,6 +1212,10 @@ struct ubuf_info *msg_zerocopy_realloc(struct sock *sk, size_t size,
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

