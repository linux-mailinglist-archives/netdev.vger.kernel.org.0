Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3479C364BE5
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 22:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241346AbhDSUrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 16:47:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242790AbhDSUph (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 16:45:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB616613E2;
        Mon, 19 Apr 2021 20:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865102;
        bh=6Qc/Da3dRb/UdVG4q50oDReBLc8kQByQo/gnEgPYf1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tPArSsPHStnIWMWDOldu9Yvs+08LPMYwdlB8WHiXmNPu3h+uMQvossu8FAsJdTza1
         dJ+tn3LDjQ7wjFgWzjMwLUAf6sn1AsKTrUdowBQ9nVaREAbAyUIIbe5XPzPpS8/nn3
         +bQzerQ4j04chGfk9bZOjiTjgn+R5FutpV1fXbghBSq3/Qv/D2lBsQZichjfJNF0tr
         bGc1lZlF2MSzXaROoxLK41cYRCsUY8SFJPgvbI5kMEJT13KvGvYBKYwBcpH0yVdTiu
         oPi5bSb3hh2LG64lrIJDdG8Pcgn4bcV0ToS3SxC9w7MgMMOvnzAml1tqKhbwoZT1yo
         aRo8iex/jEVPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Phillip Potter <phil@philpotter.co.uk>,
        Eric Dumazet <edumazet@google.com>,
        syzbot+2e406a9ac75bb71d4b7a@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 05/14] net: geneve: check skb is large enough for IPv4/IPv6 header
Date:   Mon, 19 Apr 2021 16:44:45 -0400
Message-Id: <20210419204454.6601-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419204454.6601-1-sashal@kernel.org>
References: <20210419204454.6601-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phillip Potter <phil@philpotter.co.uk>

[ Upstream commit 6628ddfec7580882f11fdc5c194a8ea781fdadfa ]

Check within geneve_xmit_skb/geneve6_xmit_skb that sk_buff structure
is large enough to include IPv4 or IPv6 header, and reject if not. The
geneve_xmit_skb portion and overall idea was contributed by Eric Dumazet.
Fixes a KMSAN-found uninit-value bug reported by syzbot at:
https://syzkaller.appspot.com/bug?id=abe95dc3e3e9667fc23b8d81f29ecad95c6f106f

Suggested-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot+2e406a9ac75bb71d4b7a@syzkaller.appspotmail.com
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/geneve.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index c7ec3d24eabc..c33a08d65208 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -891,6 +891,9 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	__be16 sport;
 	int err;
 
+	if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
+		return -EINVAL;
+
 	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
 	rt = geneve_get_v4_rt(skb, dev, gs4, &fl4, info,
 			      geneve->info.key.tp_dst, sport);
@@ -954,6 +957,9 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	__be16 sport;
 	int err;
 
+	if (!pskb_network_may_pull(skb, sizeof(struct ipv6hdr)))
+		return -EINVAL;
+
 	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
 	dst = geneve_get_v6_dst(skb, dev, gs6, &fl6, info,
 				geneve->info.key.tp_dst, sport);
-- 
2.30.2

