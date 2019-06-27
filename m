Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1C857692
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729236AbfF0AkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:40:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728155AbfF0AkD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:40:03 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD147205ED;
        Thu, 27 Jun 2019 00:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561596003;
        bh=nLlFqg5KO2/WNwbDcbQbSwsk6pUXyLSYlEn8F/TGQ5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=poTNf8TiZDhwV0Oj1uqKJfCmQ7vCY8nojAxjk3GuGOzqbnCtKpn/NdSZgq27gwKSs
         XwCGGZ7/yWjCG/f49Uo6YvSJrKd4xiGn+AkfHhVQDW9p64XkMCIPVLmPFaGHnWfHNp
         D10xe+RCx0vvixGITztoYRcNnzkxBQRuTSDSi3TE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guillaume Nault <gnault@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 11/35] netfilter: ipv6: nf_defrag: fix leakage of unqueued fragments
Date:   Wed, 26 Jun 2019 20:38:59 -0400
Message-Id: <20190627003925.21330-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003925.21330-1-sashal@kernel.org>
References: <20190627003925.21330-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit a0d56cb911ca301de81735f1d73c2aab424654ba ]

With commit 997dd9647164 ("net: IP6 defrag: use rbtrees in
nf_conntrack_reasm.c"), nf_ct_frag6_reasm() is now called from
nf_ct_frag6_queue(). With this change, nf_ct_frag6_queue() can fail
after the skb has been added to the fragment queue and
nf_ct_frag6_gather() was adapted to handle this case.

But nf_ct_frag6_queue() can still fail before the fragment has been
queued. nf_ct_frag6_gather() can't handle this case anymore, because it
has no way to know if nf_ct_frag6_queue() queued the fragment before
failing. If it didn't, the skb is lost as the error code is overwritten
with -EINPROGRESS.

Fix this by setting -EINPROGRESS directly in nf_ct_frag6_queue(), so
that nf_ct_frag6_gather() can propagate the error as is.

Fixes: 997dd9647164 ("net: IP6 defrag: use rbtrees in nf_conntrack_reasm.c")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index cb1b4772dac0..73c29ddcfb95 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -293,7 +293,11 @@ static int nf_ct_frag6_queue(struct frag_queue *fq, struct sk_buff *skb,
 		skb->_skb_refdst = 0UL;
 		err = nf_ct_frag6_reasm(fq, skb, prev, dev);
 		skb->_skb_refdst = orefdst;
-		return err;
+
+		/* After queue has assumed skb ownership, only 0 or
+		 * -EINPROGRESS must be returned.
+		 */
+		return err ? -EINPROGRESS : 0;
 	}
 
 	skb_dst_drop(skb);
@@ -481,12 +485,6 @@ int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user)
 		ret = 0;
 	}
 
-	/* after queue has assumed skb ownership, only 0 or -EINPROGRESS
-	 * must be returned.
-	 */
-	if (ret)
-		ret = -EINPROGRESS;
-
 	spin_unlock_bh(&fq->q.lock);
 	inet_frag_put(&fq->q);
 	return ret;
-- 
2.20.1

