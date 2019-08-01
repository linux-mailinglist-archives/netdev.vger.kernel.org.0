Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51C7D7E4A6
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 23:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732372AbfHAVOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 17:14:16 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36752 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731215AbfHAVOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 17:14:16 -0400
Received: by mail-pl1-f194.google.com with SMTP id k8so32761253plt.3
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 14:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=mF+1MFpI5ahOYLWOyqAI/6auUSWzCNOlTk+1t9AU1XE=;
        b=oBSfTJvGyoy8kTPA3McRhsAc3AhRA07EDB7gA3KxjAYqlOnTP0Z2FFaYvvJnxt6rKO
         +WdfPSN8XzJIbfFBSz7Wa6PGp3i9vIDgtJwq6lK36ricpGFPyxF8HrSDik75SRYqqnCG
         XOts+dkLU9Wt+PAxxBgusWxRsNGYdlX3fPnEuBKbxaml1/SIUx+1px9q8B9ICl0FGjgb
         NqJcJkPuqIDRbLjA7rPOW50dPaL9ALgKXimtt5uOP0T+7vdcuYF5NVqc8mWC8hQ8VaWh
         PDnF+6f1CO7j15j+TrYB64SrI6dV7xCjcM7Fl1hTddRPkffxmVAWs+w2rqHJB+x1KjWQ
         /X1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mF+1MFpI5ahOYLWOyqAI/6auUSWzCNOlTk+1t9AU1XE=;
        b=WF1AXEjV15Pw16bFu3abjlqGcyq4D1qLQYY4AUkplNOuaTwzmuUU844n4VZDqzGzwM
         GZuINgx56hEvJgDu6iWcLO2qLXgfhTHPNgj0gH0UAXqS8dcflfJmLvqUYZI2OuJzY2Zw
         oeSRdG356mnpO3jifkSKBCunsWYBX85BT01xIspcYf5H2ZDc0lNwWYAxOljdZCiq0iGr
         m52Q5GvQ4epcBgWKaJEDiR6j60oWAz0dKrHZvHwZFvRl79WAFRIiSBa1yyxu1grblFQ6
         G9CvEi93W7tMNtI6q9MXUK5ZEM+YbJ5My0xBdt0ymeFgRuwvJT3UaYACEe02pA3PBTM0
         P0iw==
X-Gm-Message-State: APjAAAV1b/4MTKQOg1XQThpCnJtMlIH5YJkr0arPbt8hbBI+533P5Uie
        ElEoATYjGY4oMLZwP5kE8T7oYJPvXMs=
X-Google-Smtp-Source: APXvYqyjecD6DUzw8EQfGdpB5KDSLXifF7dyQiCtiSZ2z58iDoTlYuTJQ3BDCHtRcaNjhfV/bELwrg==
X-Received: by 2002:a17:902:290b:: with SMTP id g11mr125775771plb.26.1564694055322;
        Thu, 01 Aug 2019 14:14:15 -0700 (PDT)
Received: from kern417.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id k25sm60680813pgt.53.2019.08.01.14.14.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 01 Aug 2019 14:14:14 -0700 (PDT)
From:   Yifeng Sun <pkusunyifeng@gmail.com>
To:     netdev@vger.kernel.org, pshelar@ovn.org
Cc:     Yifeng Sun <pkusunyifeng@gmail.com>
Subject: [PATCH net-next] openvswitch: Print error when ovs_execute_actions() fails
Date:   Thu,  1 Aug 2019 14:14:07 -0700
Message-Id: <1564694047-4859-1-git-send-email-pkusunyifeng@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently in function ovs_dp_process_packet(), return values of
ovs_execute_actions() are silently discarded. This patch prints out
an error message when error happens so as to provide helpful hints
for debugging.

Signed-off-by: Yifeng Sun <pkusunyifeng@gmail.com>
---
 net/openvswitch/datapath.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 892287d..603c533 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -222,6 +222,7 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
 	struct dp_stats_percpu *stats;
 	u64 *stats_counter;
 	u32 n_mask_hit;
+	int error;
 
 	stats = this_cpu_ptr(dp->stats_percpu);
 
@@ -229,7 +230,6 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
 	flow = ovs_flow_tbl_lookup_stats(&dp->table, key, &n_mask_hit);
 	if (unlikely(!flow)) {
 		struct dp_upcall_info upcall;
-		int error;
 
 		memset(&upcall, 0, sizeof(upcall));
 		upcall.cmd = OVS_PACKET_CMD_MISS;
@@ -246,7 +246,10 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
 
 	ovs_flow_stats_update(flow, key->tp.flags, skb);
 	sf_acts = rcu_dereference(flow->sf_acts);
-	ovs_execute_actions(dp, skb, sf_acts, key);
+	error = ovs_execute_actions(dp, skb, sf_acts, key);
+	if (unlikely(error))
+		net_err_ratelimited("ovs: action execution error on datapath %s: %d\n",
+							ovs_dp_name(dp), error);
 
 	stats_counter = &stats->n_hit;
 
-- 
2.7.4

