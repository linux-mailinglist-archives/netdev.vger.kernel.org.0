Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 394D74E33AF
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 00:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbiCUXBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 19:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231544AbiCUW5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 18:57:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87213AF77C;
        Mon, 21 Mar 2022 15:37:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FDF961316;
        Mon, 21 Mar 2022 21:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8140C340F3;
        Mon, 21 Mar 2022 21:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647899594;
        bh=+q5RxOojXK2aXmj1sCA0/CjcBuKfUCjtIPk+ZhVoxD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffycKT0Z9koMzT4nddYh3Sx6XXQMagcCroqqpjf7bhRRdZQSj3ALvLXp05FsDFdlL
         fXtpa6WkKld5Y7/z6vRQdsayVZ2jFxHFQsT+FUGyKGghn2TNEJKxLCMpPGxrVwmBcT
         zRFQ5YWQ7XVQusQSAU1YNzsRf8r5m6dGi+J+ziP59xjFPkmuzSlK+W5Xk6YSIRT45N
         pCP1bPQ5zeBfrKxG1VlqZ7gksByw5e+jtj0h8s7M7cMh1wXqflMBgm2QyKKKq5Z8Nk
         U/LweafetvS8gz0kbU6B6FbbZ31MwN76czWDSohE4JHX9eid76TDu5W9SPhUhaduH9
         84U5cW72irwuw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 3/4] net: ipv6: fix skb_over_panic in __ip6_append_data
Date:   Mon, 21 Mar 2022 17:53:04 -0400
Message-Id: <20220321215308.490358-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220321215308.490358-1-sashal@kernel.org>
References: <20220321215308.490358-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tadeusz Struk <tadeusz.struk@linaro.org>

[ Upstream commit 5e34af4142ffe68f01c8a9acae83300f8911e20c ]

Syzbot found a kernel bug in the ipv6 stack:
LINK: https://syzkaller.appspot.com/bug?id=205d6f11d72329ab8d62a610c44c5e7e25415580
The reproducer triggers it by sending a crafted message via sendmmsg()
call, which triggers skb_over_panic, and crashes the kernel:

skbuff: skb_over_panic: text:ffffffff84647fb4 len:65575 put:65575
head:ffff888109ff0000 data:ffff888109ff0088 tail:0x100af end:0xfec0
dev:<NULL>

Update the check that prevents an invalid packet with MTU equal
to the fregment header size to eat up all the space for payload.

The reproducer can be found here:
LINK: https://syzkaller.appspot.com/text?tag=ReproC&x=1648c83fb00000

Reported-by: syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
Acked-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20220310232538.1044947-1-tadeusz.struk@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_output.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index d6f2126f4618..2aa39ce7093d 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1500,8 +1500,8 @@ static int __ip6_append_data(struct sock *sk,
 		      sizeof(struct frag_hdr) : 0) +
 		     rt->rt6i_nfheader_len;
 
-	if (mtu < fragheaderlen ||
-	    ((mtu - fragheaderlen) & ~7) + fragheaderlen < sizeof(struct frag_hdr))
+	if (mtu <= fragheaderlen ||
+	    ((mtu - fragheaderlen) & ~7) + fragheaderlen <= sizeof(struct frag_hdr))
 		goto emsgsize;
 
 	maxfraglen = ((mtu - fragheaderlen) & ~7) + fragheaderlen -
-- 
2.34.1

