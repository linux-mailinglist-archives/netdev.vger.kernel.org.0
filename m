Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA4F6C3C38
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388993AbfJAQuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:50:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726860AbfJAQof (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:44:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4802721906;
        Tue,  1 Oct 2019 16:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948274;
        bh=EeiAg+K/3A2Za8StxoLCNIy6rbE/vHV061xjoJvSjzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gKj9PfWFI6mF23wa536yj7WdqpJUNjPaB2laZuzkxXa1tYWNC8OKKECWs7E2wc7gp
         +OlAIoEsgAsb3/6sUIF+oSHKSpzGCyM5iCTLiaU0Ov3ee+q0HwPM894FncfKXBO28j
         5I4mp/FfeIoFuvxFYHZ1vutyKNAK34RxsJikgWvY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 09/29] netfilter: nf_tables: allow lookups in dynamic sets
Date:   Tue,  1 Oct 2019 12:44:03 -0400
Message-Id: <20191001164423.16406-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001164423.16406-1-sashal@kernel.org>
References: <20191001164423.16406-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit acab713177377d9e0889c46bac7ff0cfb9a90c4d ]

This un-breaks lookups in sets that have the 'dynamic' flag set.
Given this active example configuration:

table filter {
  set set1 {
    type ipv4_addr
    size 64
    flags dynamic,timeout
    timeout 1m
  }

  chain input {
     type filter hook input priority 0; policy accept;
  }
}

... this works:
nft add rule ip filter input add @set1 { ip saddr }

-> whenever rule is triggered, the source ip address is inserted
into the set (if it did not exist).

This won't work:
nft add rule ip filter input ip saddr @set1 counter
Error: Could not process rule: Operation not supported

In other words, we can add entries to the set, but then can't make
matching decision based on that set.

That is just wrong -- all set backends support lookups (else they would
not be very useful).
The failure comes from an explicit rejection in nft_lookup.c.

Looking at the history, it seems like NFT_SET_EVAL used to mean
'set contains expressions' (aka. "is a meter"), for instance something like

 nft add rule ip filter input meter example { ip saddr limit rate 10/second }
 or
 nft add rule ip filter input meter example { ip saddr counter }

The actual meaning of NFT_SET_EVAL however, is
'set can be updated from the packet path'.

'meters' and packet-path insertions into sets, such as
'add @set { ip saddr }' use exactly the same kernel code (nft_dynset.c)
and thus require a set backend that provides the ->update() function.

The only set that provides this also is the only one that has the
NFT_SET_EVAL feature flag.

Removing the wrong check makes the above example work.
While at it, also fix the flag check during set instantiation to
allow supported combinations only.

Fixes: 8aeff920dcc9b3f ("netfilter: nf_tables: add stateful object reference to set elements")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 7 +++++--
 net/netfilter/nft_lookup.c    | 3 ---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b149a72190846..7ef126489d4ed 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3131,8 +3131,11 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 			      NFT_SET_OBJECT))
 			return -EINVAL;
 		/* Only one of these operations is supported */
-		if ((flags & (NFT_SET_MAP | NFT_SET_EVAL | NFT_SET_OBJECT)) ==
-			     (NFT_SET_MAP | NFT_SET_EVAL | NFT_SET_OBJECT))
+		if ((flags & (NFT_SET_MAP | NFT_SET_OBJECT)) ==
+			     (NFT_SET_MAP | NFT_SET_OBJECT))
+			return -EOPNOTSUPP;
+		if ((flags & (NFT_SET_EVAL | NFT_SET_OBJECT)) ==
+			     (NFT_SET_EVAL | NFT_SET_OBJECT))
 			return -EOPNOTSUPP;
 	}
 
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 475570e89ede7..44015a151ad69 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -76,9 +76,6 @@ static int nft_lookup_init(const struct nft_ctx *ctx,
 	if (IS_ERR(set))
 		return PTR_ERR(set);
 
-	if (set->flags & NFT_SET_EVAL)
-		return -EOPNOTSUPP;
-
 	priv->sreg = nft_parse_register(tb[NFTA_LOOKUP_SREG]);
 	err = nft_validate_register_load(priv->sreg, set->klen);
 	if (err < 0)
-- 
2.20.1

