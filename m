Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2F053834D
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240871AbiE3OcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 10:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240077AbiE3O2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 10:28:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B3D40A08;
        Mon, 30 May 2022 06:51:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86785B80DBB;
        Mon, 30 May 2022 13:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BC6C385B8;
        Mon, 30 May 2022 13:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918701;
        bh=Ly+ayFbDpYKgIvfA09SGWZMWgYm0O9/vI2D9atANTEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nCIjTuJiBXODZZnIUytEQx/MN6epcL1SQvk+MJHi2hKAZkO2lgQTak2hjEArW0T2z
         ImatZteSAZ85hnFNm8ZiHGJj57L2nvritAHeaN0IcKRrljD0+46qFobWv+gAsdwhqL
         wRh2C+vHJZ/2+A/l5aUhCEqr2F+pzK4UFbU0XgH/aGR6F2Fsk0phgl3wfxu1VL5Kr7
         YGb9h9lUX5mprwkO0HiuXG0Kvg2wuwiqExW2pGSBQhMgmIKqwUJBEwzZdraeTCBeM5
         o4DMVPXLJH58AoZNA+sym5mO49/IY49R2XPoEul99Yy575BA6G5YmBKCVWWUlxQVKm
         Mr2V9i1toNDCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        pabeni@redhat.com, bigeasy@linutronix.de, imagedong@tencent.com,
        petrm@nvidia.com, memxor@gmail.com, arnd@arndb.de,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 17/29] net: remove two BUG() from skb_checksum_help()
Date:   Mon, 30 May 2022 09:50:44 -0400
Message-Id: <20220530135057.1937286-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530135057.1937286-1-sashal@kernel.org>
References: <20220530135057.1937286-1-sashal@kernel.org>
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
index ea09e0809c12..d99dce0efedc 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2641,11 +2641,15 @@ int skb_checksum_help(struct sk_buff *skb)
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
 
 	if (skb_cloned(skb) &&
 	    !skb_clone_writable(skb, offset + sizeof(__sum16))) {
-- 
2.35.1

