Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51BDC422885
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 15:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235542AbhJENwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 09:52:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235448AbhJENwj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 09:52:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A7A961BB1;
        Tue,  5 Oct 2021 13:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441848;
        bh=RsL4ZYa4qQbh0UbeB0TEVBdhhViW5xlD3Tz4/lStPr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sWnmY9T5RYw55MZiLoWiinVXxxy2tZNFFEQhHDRLpGT74vILX3qu1aDs4z62WpxAj
         axH5KU5G2ZrqiNpyyktYRRjpmORFHzQl/Kh1vEqQfjFxIZTAi/GhzKw0Lr2EzH0mSP
         LpwpDHX80yA6mmE7sWYnq7odE/lpwKcq8cp3q0PJr2Hwh9xY5POeUUvBDmelXPWtHF
         LnFOaHapfFHWm0+lOL2I7U0vt71IfvWnCjT8ijvzH+SkmM7Mt4ypa4qh2AvAD7/utG
         JbhWCYgRIG7qCfdshzop5Qsj7iIwY9N6OKuaGCUc/K9xIiaaTX0PtBgutnVGOYTxmO
         KSj3vWepZjt4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeremy Sowden <jeremy@azazel.net>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>, kadlec@netfilter.org,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 12/40] netfilter: ip6_tables: zero-initialize fragment offset
Date:   Tue,  5 Oct 2021 09:49:51 -0400
Message-Id: <20211005135020.214291-12-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

[ Upstream commit 310e2d43c3ad429c1fba4b175806cf1f55ed73a6 ]

ip6tables only sets the `IP6T_F_PROTO` flag on a rule if a protocol is
specified (`-p tcp`, for example).  However, if the flag is not set,
`ip6_packet_match` doesn't call `ipv6_find_hdr` for the skb, in which
case the fragment offset is left uninitialized and a garbage value is
passed to each matcher.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/netfilter/ip6_tables.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index de2cf3943b91..a579ea14a69b 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -273,6 +273,7 @@ ip6t_do_table(struct sk_buff *skb,
 	 * things we don't know, ie. tcp syn flag or ports).  If the
 	 * rule is also a fragment-specific rule, non-fragments won't
 	 * match it. */
+	acpar.fragoff = 0;
 	acpar.hotdrop = false;
 	acpar.state   = state;
 
-- 
2.33.0

