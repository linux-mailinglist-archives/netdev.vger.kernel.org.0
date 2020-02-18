Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5D0163106
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 20:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgBRT6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 14:58:34 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39734 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728179AbgBRT6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 14:58:30 -0500
Received: by mail-pl1-f196.google.com with SMTP id g6so8511100plp.6;
        Tue, 18 Feb 2020 11:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=QiZww/RzBIiqsbrHHxIYSu/iuDgV4YFLQLrfy6sFiNk=;
        b=Cjnbef0k4m3B/ywmq6dWoUbGU3Ag1/Zc52LYCXAhwdYSC+or3uUZwbzROS2iVMTzAi
         YLO/erejLW1NG2U06RoeMfO1zgQmJmqz+yEvzqfRgMJQ0vvXzD2K0qAYliuPrqsSu7+t
         71G2NPYLlCmUTztI1DY+qu3oCHsl+Ww+xbdsUfnr6DHkjxmkyutlIF+MufPXN1YNzqVa
         PAmYLF77yJwYfhVIasqfzPGJUeU7bmVxrvWjLK8Rx+T8YdhMhn4Fxpb5gfsrZtiXywAH
         DWI5q18zqSpsKLE1sCtbYUZdsP+g8qrmRnqK3okYMZcAjNqktRCVduYKjHvFRkg0K6BR
         v+FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QiZww/RzBIiqsbrHHxIYSu/iuDgV4YFLQLrfy6sFiNk=;
        b=bpoCdpDXG3SsgQsd9TD4rNAHyoSXcl4dv5w9VA3JRvntuFH+l+pDfKZ6lvU4Gr0pyW
         KG0Ru6KYdQVWptk3Wgy588sOzfj3RJchpyoIQbzmlnNsILexWYgDx5XjDGkvOFqRVIJS
         QvF9p4n6ZoYKYzyfRRoEUTS7oY/sgO70hK+OsRikxTG5TXSoyqEJei5NPexzImJr8xM8
         NXWAtstTverRINi+h3BFGkZs2bO+uyz6oYe4XQmnFm2K2oyqB4QuDselIcXTq9VU5ihV
         Zx9ThtAX9LQDEmNnhdktCjcYxEWcq2eYThU6D77g6FLc4pipzkWbb8NBAy55DlOpYWRq
         pkog==
X-Gm-Message-State: APjAAAWogzaVEdXlbBgI63cCwwzYVOscuvRp2liOfKPX03M/Huez8R25
        gMzT0rhzj8re67RJSlBZzxl52m0=
X-Google-Smtp-Source: APXvYqwH1nOirlZGhvmTOw16Nv7wur/YGu3iaddjnmcqplevu4ou6GC57/7gKbJ/RXghEymI4BH9uA==
X-Received: by 2002:a17:902:6ac2:: with SMTP id i2mr22116151plt.221.1582055909574;
        Tue, 18 Feb 2020 11:58:29 -0800 (PST)
Received: from madhuparna-HP-Notebook.nitk.ac.in ([2402:3a80:1ee3:ff08:f869:e1e5:121e:cdbf])
        by smtp.gmail.com with ESMTPSA id k4sm5118883pfg.40.2020.02.18.11.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 11:58:28 -0800 (PST)
From:   madhuparnabhowmik10@gmail.com
To:     pshelar@ovn.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH 4/4] flow_table.c: Use built-in RCU list checking
Date:   Wed, 19 Feb 2020 01:28:20 +0530
Message-Id: <20200218195820.2769-1-madhuparnabhowmik10@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

hlist_for_each_entry_rcu() has built-in RCU and lock checking.

Pass cond argument to list_for_each_entry_rcu() to silence
false lockdep warning when CONFIG_PROVE_RCU_LIST is enabled
by default.

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
---
 net/openvswitch/flow_table.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 5904e93e5765..fd8a01ca7a2d 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -585,7 +585,8 @@ static struct sw_flow *masked_flow_lookup(struct table_instance *ti,
 	head = find_bucket(ti, hash);
 	(*n_mask_hit)++;
 
-	hlist_for_each_entry_rcu(flow, head, flow_table.node[ti->node_ver]) {
+	hlist_for_each_entry_rcu(flow, head, flow_table.node[ti->node_ver],
+				lockdep_ovsl_is_held()) {
 		if (flow->mask == mask && flow->flow_table.hash == hash &&
 		    flow_cmp_masked_key(flow, &masked_key, &mask->range))
 			return flow;
@@ -769,7 +770,8 @@ struct sw_flow *ovs_flow_tbl_lookup_ufid(struct flow_table *tbl,
 
 	hash = ufid_hash(ufid);
 	head = find_bucket(ti, hash);
-	hlist_for_each_entry_rcu(flow, head, ufid_table.node[ti->node_ver]) {
+	hlist_for_each_entry_rcu(flow, head, ufid_table.node[ti->node_ver],
+				lockdep_ovsl_is_held()) {
 		if (flow->ufid_table.hash == hash &&
 		    ovs_flow_cmp_ufid(flow, ufid))
 			return flow;
-- 
2.17.1

