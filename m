Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20E8E538042
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238693AbiE3NxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239254AbiE3NvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:51:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8900B92D0F;
        Mon, 30 May 2022 06:35:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C86C2B80DB7;
        Mon, 30 May 2022 13:35:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11129C341C4;
        Mon, 30 May 2022 13:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917732;
        bh=+DRNotNOdlynsftO2MlivAufm6vmg4x5Is++M6rcBXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fygxk0+jpzFK+H1VcHHKURtlcEJuHt95NC0c2gkUoSvodgjHLfpqJzyNU/rHJouxL
         16BJc40E/D2MzibH4ZaKM+rKluco83gkLWdEA2EQ4I+4nDvLuyAXSjqeb/WNxAU8Lj
         usN7zkhFrTitzaUt9Ay2mjIG/Z3mg8EFkOLiFOmil6eyc9urvOA9hcJMki5GhP6zz8
         AS1Jbsr0KJWYBbnINKvCnVOB664J+IDZbCK6VIWLeKm8ciy52cUOXrgm/82qZuFe6m
         riboUADpmV6usFQj/MfNkoam44+3kKyS++2liSvRoubZCGWzILyjN9MieC1e9UzEse
         6WqCczIEBD6wA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        pabeni@redhat.com, bigeasy@linutronix.de, imagedong@tencent.com,
        petrm@nvidia.com, memxor@gmail.com, arnd@arndb.de,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 078/135] net: remove two BUG() from skb_checksum_help()
Date:   Mon, 30 May 2022 09:30:36 -0400
Message-Id: <20220530133133.1931716-78-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d7ea0d9df2a6265b2b180d17ebc64b38105968fc ]

I have a syzbot report that managed to get a crash in skb_checksum_help()

If syzbot can trigger these BUG(), it makes sense to replace
them with more friendly WARN_ON_ONCE() since skb_checksum_help()
can instead return an error code.

Note that syzbot will still crash there, until real bug is fixed.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 80dbbd5f6a73..178400e4d13e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3156,11 +3156,15 @@ int skb_checksum_help(struct sk_buff *skb)
 	}
 
 	offset = skb_checksum_start_offset(skb);
-	BUG_ON(offset >= skb_headlen(skb));
+	ret = -EINVAL;
+	if (WARN_ON_ONCE(offset >= skb_headlen(skb)))
+		goto out;
+
 	csum = skb_checksum(skb, offset, skb->len - offset, 0);
 
 	offset += skb->csum_offset;
-	BUG_ON(offset + sizeof(__sum16) > skb_headlen(skb));
+	if (WARN_ON_ONCE(offset + sizeof(__sum16) > skb_headlen(skb)))
+		goto out;
 
 	ret = skb_ensure_writable(skb, offset + sizeof(__sum16));
 	if (ret)
-- 
2.35.1

