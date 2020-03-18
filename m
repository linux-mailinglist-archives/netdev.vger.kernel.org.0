Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8266118A667
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgCRVH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 17:07:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:53544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727536AbgCRUyJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:54:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D27292098B;
        Wed, 18 Mar 2020 20:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564848;
        bh=+3PT5ixSSczOWYJFYGUU1q4HgAMEEfKeUtxBoxFqb20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UknWaNHzdJBWeiPr8MQFiRXhbaHfEIerLhru2B1ZJvKAt5zNC9v13B7nqbJ5SiGvq
         OUWCnMVudzpiOrOi9bP9r1B1gNG1u/VXq8Vhqq37+wGXmgj3DBeFEf/sCO+8OfyIMU
         dGfFtMBAQpmY2M4UFLLeats0u5ZAHQVSKZwV73BY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 26/73] netfilter: nf_tables: dump NFTA_CHAIN_FLAGS attribute
Date:   Wed, 18 Mar 2020 16:52:50 -0400
Message-Id: <20200318205337.16279-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205337.16279-1-sashal@kernel.org>
References: <20200318205337.16279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit d78008de6103c708171baff9650a7862645d23b0 ]

Missing NFTA_CHAIN_FLAGS netlink attribute when dumping basechain
definitions.

Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 23544842b6923..bd76ef77c03f5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1309,6 +1309,11 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 					      lockdep_commit_lock_is_held(net));
 		if (nft_dump_stats(skb, stats))
 			goto nla_put_failure;
+
+		if ((chain->flags & NFT_CHAIN_HW_OFFLOAD) &&
+		    nla_put_be32(skb, NFTA_CHAIN_FLAGS,
+				 htonl(NFT_CHAIN_HW_OFFLOAD)))
+			goto nla_put_failure;
 	}
 
 	if (nla_put_be32(skb, NFTA_CHAIN_USE, htonl(chain->use)))
-- 
2.20.1

