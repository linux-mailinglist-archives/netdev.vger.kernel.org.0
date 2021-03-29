Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389CE34DA83
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbhC2WWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:22:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231938AbhC2WV7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 18:21:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47C6061989;
        Mon, 29 Mar 2021 22:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056518;
        bh=PRaURuqiqrFk5Bglodz4syjHt/uqpDu7BKqVxMG4Kdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ugtAGZUYDsvL0mQpp86/5/PUklpJJV0ciW1pqZc2kP8Y8UzYFR+oQOWu1zXCNgMG4
         rE1HZsns/Nz4k8ydiXAC5YhZXP6nGuox7CjRn2knXtUe62RjBtvsMRuQX+9MlEOr5z
         oSo9gg2iXnqmuyeB/xsaFkiKpkAfvzpCPqYwPsSsg1PYezS21D8zDdub9zQMgfcpsM
         tYv1W4aDcoF5Pl75hnmL2OZgpel7nXs++OM/Jr6ZkrsMkWKqU8EdNqmoYYGtCFbnqt
         epwL5halMQG5Y2kpoWEsqdagcJkABk/BtTjEt/FFWlwUo1adIEDGMXe9nJ1GbqfevM
         dr53I4tU3hjPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 20/38] netfilter: nftables: skip hook overlap logic if flowtable is stale
Date:   Mon, 29 Mar 2021 18:21:15 -0400
Message-Id: <20210329222133.2382393-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222133.2382393-1-sashal@kernel.org>
References: <20210329222133.2382393-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 86fe2c19eec4728fd9a42ba18f3b47f0d5f9fd7c ]

If the flowtable has been previously removed in this batch, skip the
hook overlap checks. This fixes spurious EEXIST errors when removing and
adding the flowtable in the same batch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8ee9f40cc0ea..f18e54d3ca51 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6749,6 +6749,9 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 
 	list_for_each_entry(hook, hook_list, list) {
 		list_for_each_entry(ft, &table->flowtables, list) {
+			if (!nft_is_active_next(net, ft))
+				continue;
+
 			list_for_each_entry(hook2, &ft->hook_list, list) {
 				if (hook->ops.dev == hook2->ops.dev &&
 				    hook->ops.pf == hook2->ops.pf) {
-- 
2.30.1

