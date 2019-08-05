Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C50C281069
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 04:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbfHEC4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 22:56:19 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34642 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbfHEC4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 22:56:18 -0400
Received: by mail-pl1-f195.google.com with SMTP id i2so35885540plt.1
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 19:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=AvdsAxisVTOVBShJEUJGZbAvdFOrcvBJAg0W5ePnH4I=;
        b=UywIu7knNU6xFqY9vGfN8JgG/ZxsK5mU7MSwhB+CFBj7Sk1wH5AQGy3Jsjk/KVL+a6
         FgT/o4MOlv9ZzU4RmcxrEjgTY4swtdpG+JDmtXmUXo/ttVC4zzYCB8FlOBIY23vVfFxR
         6rDMKvKtLHQweQldJHLVivI6Yk0wMUsoAXIxrEw4dL+6ah0HCfIoDulSq7YKdLNMTveb
         0AZ7+qDWPsrq+wDl9LOqWi/l6KItjrv9J6sd5m0PvSI9UriSKSJ9mhqhl1vCaztDDwhz
         oaW2y/lRFqK6DfKHVJ0JrI4UmpVxQxKkSKHdVN1byCf3j9FTWYI+E89nE5GmdWm3yYr+
         hVxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=AvdsAxisVTOVBShJEUJGZbAvdFOrcvBJAg0W5ePnH4I=;
        b=o21QYGPKpIi9BQgMk0mtQKzD80RCJnDIykI3R0uARAHFN74PeMMWTXW/cqO/AQLcVC
         OLQQUq30CBSlma6hsLYWtMeKof3jbXH3MtF5fxWZGYI3qlqsO4ZwW7qoHz56SymIEy6y
         L7BLDZO7umc1gMls0acZnzIFxLKYt2SdNYp/ATG3YsHz8QuigQHe0t1qxY9q0yjXJkFu
         sGWKyzvQfQXmWYTK4zU16RrVZbuEglulytuQ2rp0Tu7OqyVPcnf9oVTe8urOedBiqkKa
         OsKLxwogQuAeq1eYVVjIav35P5uTXgJZp14GQXFi3V9FZAPHnq+3apJHHIMk4Dwp6e0s
         0Zxw==
X-Gm-Message-State: APjAAAXZKK4SmdaHWT0Af6xHLqyAl25EXLlBCRm6dfDEF1a38AmUemgZ
        LH555kQILKcUNBYVG6HD7f+8mXzUgPk=
X-Google-Smtp-Source: APXvYqwYzFAUyJf8U6Inuvuab2xWtBhjR1KvYgk4nt6lYTDIr49KmHo+pblp5PdkuCyaoo6VAAYy/g==
X-Received: by 2002:a17:902:e58b:: with SMTP id cl11mr138588695plb.24.1564973777787;
        Sun, 04 Aug 2019 19:56:17 -0700 (PDT)
Received: from kern417.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id u97sm15782421pjb.26.2019.08.04.19.56.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 04 Aug 2019 19:56:17 -0700 (PDT)
From:   Yifeng Sun <pkusunyifeng@gmail.com>
To:     netdev@vger.kernel.org, pshelar@ovn.org, gvrose8192@gmail.com
Cc:     Yifeng Sun <pkusunyifeng@gmail.com>
Subject: [PATCH net-next v2] openvswitch: Print error when ovs_execute_actions() fails
Date:   Sun,  4 Aug 2019 19:56:11 -0700
Message-Id: <1564973771-22542-1-git-send-email-pkusunyifeng@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently in function ovs_dp_process_packet(), return values of
ovs_execute_actions() are silently discarded. This patch prints out
an debug message when error happens so as to provide helpful hints
for debugging.
---
v1->v2: Fixed according to Pravin's review.

 net/openvswitch/datapath.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 892287d..12d9850 100644
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
+		net_dbg_ratelimited("ovs: action execution error on datapath %s: %d\n",
+							ovs_dp_name(dp), error);
 
 	stats_counter = &stats->n_hit;
 
-- 
2.7.4

