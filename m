Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95A83E2D59
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 17:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243978AbhHFPM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 11:12:26 -0400
Received: from mail.netfilter.org ([217.70.188.207]:33786 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242642AbhHFPMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 11:12:20 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0AE326005A;
        Fri,  6 Aug 2021 17:11:24 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 6/9] netfilter: nfnetlink_hook: use the sequence number of the request message
Date:   Fri,  6 Aug 2021 17:11:46 +0200
Message-Id: <20210806151149.6356-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210806151149.6356-1-pablo@netfilter.org>
References: <20210806151149.6356-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sequence number allows to correlate the netlink reply message (as
part of the dump) with the original request message.

The cb->seq field is internally used to detect an interference (update)
of the hook list during the netlink dump, do not use it as sequence
number in the netlink dump header.

Fixes: e2cf17d3774c ("netfilter: add new hook nfnl subsystem")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_hook.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
index e0ff2973fd14..7b0d4a317457 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -264,7 +264,8 @@ static int nfnl_hook_dump(struct sk_buff *nlskb,
 	ops = nf_hook_entries_get_hook_ops(e);
 
 	for (; i < e->num_hook_entries; i++) {
-		err = nfnl_hook_dump_one(nlskb, ctx, ops[i], cb->seq);
+		err = nfnl_hook_dump_one(nlskb, ctx, ops[i],
+					 cb->nlh->nlmsg_seq);
 		if (err)
 			break;
 	}
-- 
2.20.1

