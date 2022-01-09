Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F711488D10
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 00:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237378AbiAIXQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 18:16:58 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42112 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237386AbiAIXQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 18:16:55 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0E0A46428F;
        Mon, 10 Jan 2022 00:14:04 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 08/32] netfilter: conntrack: tag conntracks picked up in local out hook
Date:   Mon, 10 Jan 2022 00:16:16 +0100
Message-Id: <20220109231640.104123-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220109231640.104123-1-pablo@netfilter.org>
References: <20220109231640.104123-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This allows to identify flows that originate from local machine
in a followup patch.

It would be possible to make this a ->status bit instead.
For now I did not do that yet because I don't have a use-case for
exposing this info to userspace.

If one comes up the toggle can be replaced with a status bit.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack.h | 1 +
 net/netfilter/nf_conntrack_core.c    | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index d24b0a34c8f0..871489df63c6 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -95,6 +95,7 @@ struct nf_conn {
 	unsigned long status;
 
 	u16		cpu;
+	u16		local_origin:1;
 	possible_net_t ct_net;
 
 #if IS_ENABLED(CONFIG_NF_NAT)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index d7e313548066..bed0017cadb0 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1747,6 +1747,9 @@ resolve_normal_ct(struct nf_conn *tmpl,
 			return 0;
 		if (IS_ERR(h))
 			return PTR_ERR(h);
+
+		ct = nf_ct_tuplehash_to_ctrack(h);
+		ct->local_origin = state->hook == NF_INET_LOCAL_OUT;
 	}
 	ct = nf_ct_tuplehash_to_ctrack(h);
 
-- 
2.30.2

