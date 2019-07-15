Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92F1E68F3F
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388864AbfGOONG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:13:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733247AbfGOONE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:13:04 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17207212F5;
        Mon, 15 Jul 2019 14:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199983;
        bh=B1v2OsN6L9EDm2etO6b8CYhfs0qfQYsntn++nNCFePs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CZBxCDPLvqg4UqHgXg9rskMui6op3kXhHjlRZoePq5pAvxjBfCReQ0YHhrpMQ4Jmj
         dx7nbmUKgeHk3ojrhpJTUiyZP0dCsqVijG346vY0dv9flFHaat7WRLPkPRrHLxOzny
         2e4kCGHAzIfiVgPhO5ns//jYLw89volgEzbmc49U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Kaechele <felix@kaechele.ca>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 153/219] netfilter: ctnetlink: Fix regression in conntrack entry deletion
Date:   Mon, 15 Jul 2019 10:02:34 -0400
Message-Id: <20190715140341.6443-153-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Kaechele <felix@kaechele.ca>

[ Upstream commit e7600865db32b69deb0109b8254244dca592adcf ]

Commit f8e608982022 ("netfilter: ctnetlink: Resolve conntrack
L3-protocol flush regression") introduced a regression in which deletion
of conntrack entries would fail because the L3 protocol information
is replaced by AF_UNSPEC. As a result the search for the entry to be
deleted would turn up empty due to the tuple used to perform the search
is now different from the tuple used to initially set up the entry.

For flushing the conntrack table we do however want to keep the option
for nfgenmsg->version to have a non-zero value to allow for newer
user-space tools to request treatment under the new behavior. With that
it is possible to independently flush tables for a defined L3 protocol.
This was introduced with the enhancements in in commit 59c08c69c278
("netfilter: ctnetlink: Support L3 protocol-filter on flush").

Older user-space tools will retain the behavior of flushing all tables
regardless of defined L3 protocol.

Fixes: f8e608982022 ("netfilter: ctnetlink: Resolve conntrack L3-protocol flush regression")
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Felix Kaechele <felix@kaechele.ca>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d2715b4d2e72..061bdab37b1a 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1254,7 +1254,6 @@ static int ctnetlink_del_conntrack(struct net *net, struct sock *ctnl,
 	struct nf_conntrack_tuple tuple;
 	struct nf_conn *ct;
 	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	u_int8_t u3 = nfmsg->version ? nfmsg->nfgen_family : AF_UNSPEC;
 	struct nf_conntrack_zone zone;
 	int err;
 
@@ -1264,11 +1263,13 @@ static int ctnetlink_del_conntrack(struct net *net, struct sock *ctnl,
 
 	if (cda[CTA_TUPLE_ORIG])
 		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_ORIG,
-					    u3, &zone);
+					    nfmsg->nfgen_family, &zone);
 	else if (cda[CTA_TUPLE_REPLY])
 		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_REPLY,
-					    u3, &zone);
+					    nfmsg->nfgen_family, &zone);
 	else {
+		u_int8_t u3 = nfmsg->version ? nfmsg->nfgen_family : AF_UNSPEC;
+
 		return ctnetlink_flush_conntrack(net, cda,
 						 NETLINK_CB(skb).portid,
 						 nlmsg_report(nlh), u3);
-- 
2.20.1

