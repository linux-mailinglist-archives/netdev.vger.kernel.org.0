Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 809414E33C1
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 00:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbiCUXAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 19:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232031AbiCUW57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 18:57:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB4A470760;
        Mon, 21 Mar 2022 15:37:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24A2F614FE;
        Mon, 21 Mar 2022 21:53:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7F5C340F2;
        Mon, 21 Mar 2022 21:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647899618;
        bh=IQULkUGvHtz5hhQCsHz0NF5N2mpPZcmPQN2C7Ay6gJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=adijprrdvsLi9dHvKaRJi6tBMd2Iy3izj4+HkNv0P5GxI+BSiQBC+MWboqvLYulZC
         1hcdFDSbJtLruiK5dTgWSQatzgSZjZbDqmz7572xIodrInRIa6grSk1M3X5tCrCt/a
         dSk65pWs1v4f0CGtOhJvKhWSWNIeyGe/DOdpQ+lXU5aV7EgwMGrqEEp+j6NJNhwwiU
         UueMdOCvd0c2ToxbJbpLAYewslwv5dAaf2PdruVkodYH9+7hblkmiSMRLiP0NOs3WN
         JhvX5gBceT3MikgkxvLONCONoY39JmjjNN1JMiyI0RvRDKKE9iBBEv4Vxz4XoYr0E4
         Qt3iumrJ5NmFw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 2/2] net: ipv6: fix skb_over_panic in __ip6_append_data
Date:   Mon, 21 Mar 2022 17:53:23 -0400
Message-Id: <20220321215323.490478-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220321215323.490478-1-sashal@kernel.org>
References: <20220321215323.490478-1-sashal@kernel.org>
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
index fd496bda7ec7..373df391dc93 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1325,8 +1325,8 @@ static int __ip6_append_data(struct sock *sk,
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

