Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD63192B2B
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 15:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbgCYOcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 10:32:14 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:34769 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbgCYOcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 10:32:13 -0400
Received: by mail-qk1-f195.google.com with SMTP id i6so2751380qke.1
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 07:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TF9iJBiO0AuQd8nd0BlphkST/Pt9KVdxrtvPH4as2h8=;
        b=Lz6jH6Md1qAZCC/5tbCU1I+Dtky/ug5dvJDwjhk6TclPOXVHde1FZwa31s1yiEI6ci
         8jM9Q/9ov0fXa9sA1erX232HFwUXgZgaPhoVuf861MsT44CC0f6DVaElHgtbHEv3EYUJ
         lKlG2H7wcqWdiRwEXKi9+aBBNHmsgfWaJ5E+p4WrBEH3R+4s/FgqnAcIAfdYpH/DqfAf
         7tyj+SlrsRzTJ6mlKtfXpfpbgDZ0Fm/+f3gruIF0EVRqrIfJ9hD7sKEqXFbPg7sHZvKN
         vuhDgTET/1fZX02IlXcA7jSy7EZeNGb4UVctN+3wGxXbNcd7bSZVQI2XhUdiGwg9ROND
         ghRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TF9iJBiO0AuQd8nd0BlphkST/Pt9KVdxrtvPH4as2h8=;
        b=o9vpGQFVTczIxsbgIBX0nXbbLLmPizgpzJVCjEeSAABKhDEBbbnOoeaTqR2oNW7NdD
         rjKJ37iR8IMOsPsMmrGp0eek4Mk+e/7VMfHjNYF4/ZwMfkrhlwq5G++gA9WoJ04DBpGY
         3x6lNCw8wgFru6gqKjRMSCDgRM6mCwvkJqDBNhYD3Mb5QRYOT17Viyy2xpK/kjYSKLmO
         5gMgmvL6Olk6zwsgW6j61DjGnnk8jQWC4K4JrxZ3kbEgGU7ra8XgPiLZnnszjPHdUhFo
         gcgnup2Xpsu1qNSnMKQuA28OfjY9eDp3XIdPHBZl6yKJu6TCBlhXbJYFYFYxZ3vm1Y0J
         vvXA==
X-Gm-Message-State: ANhLgQ0fo1Fh9X0RBVsAf7x78fZDHGQrLcOWjhOOOJA+4+iG90AfrvYZ
        LqYwj6I8herinSAA0uLmK2iHrh4DdFEPKw==
X-Google-Smtp-Source: ADFU+vslIu4ym3oWBVgsGOjHnZWCwTiIQHGRt1uueBxGQSZBviKE1ph/j83kf3q1XH4TpTCuWS0u/w==
X-Received: by 2002:a37:a597:: with SMTP id o145mr3175372qke.106.1585146731697;
        Wed, 25 Mar 2020 07:32:11 -0700 (PDT)
Received: from ovpn-66-69.rdu2.redhat.com (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id v76sm342432qka.32.2020.03.25.07.32.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Mar 2020 07:32:11 -0700 (PDT)
From:   Qian Cai <cai@lca.pw>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Cc:     davem@davemloft.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
Subject: [PATCH] netfilter/nf_tables: silence a RCU-list warning
Date:   Wed, 25 Mar 2020 10:31:42 -0400
Message-Id: <20200325143142.6955-1-cai@lca.pw>
X-Mailer: git-send-email 2.21.0 (Apple Git-122.2)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is safe to traverse &net->nft.tables with &net->nft.commit_mutex
held using list_for_each_entry_rcu(). Silence the PROVE_RCU_LIST false
positive,

WARNING: suspicious RCU usage
net/netfilter/nf_tables_api.c:523 RCU-list traversed in non-reader section!!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
1 lock held by iptables/1384:
 #0: ffffffff9745c4a8 (&net->nft.commit_mutex){+.+.}, at: nf_tables_valid_genid+0x25/0x60 [nf_tables]

Call Trace:
 dump_stack+0xa1/0xea
 lockdep_rcu_suspicious+0x103/0x10d
 nft_table_lookup.part.0+0x116/0x120 [nf_tables]
 nf_tables_newtable+0x12c/0x7d0 [nf_tables]
 nfnetlink_rcv_batch+0x559/0x1190 [nfnetlink]
 nfnetlink_rcv+0x1da/0x210 [nfnetlink]
 netlink_unicast+0x306/0x460
 netlink_sendmsg+0x44b/0x770
 ____sys_sendmsg+0x46b/0x4a0
 ___sys_sendmsg+0x138/0x1a0
 __sys_sendmsg+0xb6/0x130
 __x64_sys_sendmsg+0x48/0x50
 do_syscall_64+0x69/0xf4
 entry_SYSCALL_64_after_hwframe+0x49/0xb3

Signed-off-by: Qian Cai <cai@lca.pw>
---
 net/netfilter/nf_tables_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 38c680f28f15..e398d1491057 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -520,7 +520,8 @@ static struct nft_table *nft_table_lookup(const struct net *net,
 	if (nla == NULL)
 		return ERR_PTR(-EINVAL);
 
-	list_for_each_entry_rcu(table, &net->nft.tables, list) {
+	list_for_each_entry_rcu(table, &net->nft.tables, list,
+				lockdep_is_held(&net->nft.commit_mutex)) {
 		if (!nla_strcmp(nla, table->name) &&
 		    table->family == family &&
 		    nft_active_genmask(table, genmask))
-- 
2.21.0 (Apple Git-122.2)

