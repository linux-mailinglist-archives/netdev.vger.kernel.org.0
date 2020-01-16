Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2EE813E37D
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388335AbgAPRCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:02:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:54840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387586AbgAPRCT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:02:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58602207FF;
        Thu, 16 Jan 2020 17:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194138;
        bh=Vu2GNXNXW2Lq/MQh8E+8TwQcdIpv8XQTS4u624FWLZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FxBSnMVbvfzR5aZU1SCkSeKgHAXr3o858HbgnA9z7RXBur/p5TPGlAklUqoj2aZni
         xA4qZGpX+DSJQHyIzJ3Q83Q1IBUTASqib4tLb1aWuYvMwzOEDmr8aqqaQ3LDHrWfWY
         uknYH1I3kzcw4YZzUkyKaNTL5RGc845aZ+Dsvj1Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 226/671] netfilter: nft_set_hash: bogus element self comparison from deactivation path
Date:   Thu, 16 Jan 2020 11:52:15 -0500
Message-Id: <20200116165940.10720-109-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit a01cbae57ec29b161d42ee1caa4ffffda5d519c2 ]

Use the element from the loop iteration, not the same element we want to
deactivate otherwise this branch always evaluates true.

Fixes: 6c03ae210ce3 ("netfilter: nft_set_hash: add non-resizable hashtable implementation")
Reported-by: Florian Westphal <fw@strlen.de>
Tested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 8dde4bfe8b8a..05118e03c3e4 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -555,7 +555,7 @@ static void *nft_hash_deactivate(const struct net *net,
 
 	hash = nft_jhash(set, priv, &this->ext);
 	hlist_for_each_entry(he, &priv->table[hash], node) {
-		if (!memcmp(nft_set_ext_key(&this->ext), &elem->key.val,
+		if (!memcmp(nft_set_ext_key(&he->ext), &elem->key.val,
 			    set->klen) &&
 		    nft_set_elem_active(&he->ext, genmask)) {
 			nft_set_elem_change_active(net, set, &he->ext);
-- 
2.20.1

