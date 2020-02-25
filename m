Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE2916C0C7
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 13:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729899AbgBYM2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 07:28:00 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:35046 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729444AbgBYM2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 07:28:00 -0500
Received: by mail-pj1-f67.google.com with SMTP id q39so1221415pjc.0;
        Tue, 25 Feb 2020 04:27:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+QtbxlvdjtvFda/vLl5OBW1XulRAqxs8RhN83qn/HyM=;
        b=VAAaWZsH9ff4hCxWAWkbiQ66n9p2Wfea3aJP0p5rAMk8NtghSBZBJFxxx7ljudMPLT
         AJ2d3jPOF8pyGPIk1V5WEb3bi3IYGdsBQJU6kiEaM34JGP8SMVnJ6mQFIosIVPY72qON
         LNX+bb9RO1twk9ho41qpq1BqNqR+CfU5dMOezxJ2sNFFY/wZ+Q3aM3jA8h4hwnlB4nTF
         B0G7ofOSTG7D8+ilvq/JGjHr4E+ckzwR418BILmJuQ7IfunCV5Ls8MmeFUucFvFHslsK
         bxXc6niBU6BZPgHFTSEuTP+quZpDy/Q1VRFmDiR4VsnEHQTHR+89nfGV0PMSfAhv7BHi
         aQ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+QtbxlvdjtvFda/vLl5OBW1XulRAqxs8RhN83qn/HyM=;
        b=R9zwSRtlgxCHZd7o7oguSUZTvZnWm1sBPC3XeoCZPhGvVXUewDhy5YRBXMQQ/UzhPP
         nkiT6bMhFXitRu/ujKZuA3OP0HPH9w4jv6EFdgheq+iT/DF/1I4ytvRpl656sSVUEn1u
         n7oTZVB/av2zgq//Ehps08mbubv2RTALwcSXaZj8VSmwbcoQloJhWsQuH5I/CAqRtENA
         WX/MolK+9luAbHJPJYWggdbQwq55TUWlHorVcpWYOmRmoxCjbmYUV4JMFpht8nBDKV1e
         I4EPxWOQm+/2Qdoi3RJu4kNoLgRc74OXndDn6ziX69+DXwRNK6FWAlEqmjSfhmPQX56M
         jPng==
X-Gm-Message-State: APjAAAV46MLqfbonGMW+nSCbYRj9IoF4q7EXmGtSG4/QJ6ZWYrYTvPA4
        nleC4JufBRPpokG+caPPAQ==
X-Google-Smtp-Source: APXvYqztBpN7FmSWeDOyFVt+VeM03oK0FL5OGPHFt8Rl0M+/B0gDYwwZenbSWw35AEfaNoYTNLjtTw==
X-Received: by 2002:a17:90b:90d:: with SMTP id bo13mr4942999pjb.54.1582633678246;
        Tue, 25 Feb 2020 04:27:58 -0800 (PST)
Received: from madhuparna-HP-Notebook.nitk.ac.in ([2402:3a80:1ee1:f355:e8e5:803b:cde8:bccc])
        by smtp.gmail.com with ESMTPSA id s7sm16508981pgp.44.2020.02.25.04.27.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 04:27:57 -0800 (PST)
From:   madhuparnabhowmik10@gmail.com
To:     jiri@mellanox.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        joel@joelfernandes.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        frextrite@gmail.com, paulmck@kernel.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH] net: core: devlink.c: Use built-in RCU list checking
Date:   Tue, 25 Feb 2020 17:57:45 +0530
Message-Id: <20200225122745.31095-1-madhuparnabhowmik10@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

list_for_each_entry_rcu() has built-in RCU and lock checking.

Pass cond argument to list_for_each_entry_rcu() to silence
false lockdep warning when CONFIG_PROVE_RCU_LIST is enabled.

The devlink->lock is held when devlink_dpipe_table_find()
is called in non RCU read side section. Therefore, pass struct devlink
to devlink_dpipe_table_find() for lockdep checking.

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
---
 net/core/devlink.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index e82750bdc496..a92ab58304e5 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -2103,11 +2103,11 @@ static int devlink_dpipe_entry_put(struct sk_buff *skb,
 
 static struct devlink_dpipe_table *
 devlink_dpipe_table_find(struct list_head *dpipe_tables,
-			 const char *table_name)
+			 const char *table_name, struct devlink *devlink)
 {
 	struct devlink_dpipe_table *table;
-
-	list_for_each_entry_rcu(table, dpipe_tables, list) {
+	list_for_each_entry_rcu(table, dpipe_tables, list,
+				lockdep_is_held(&devlink->lock)) {
 		if (!strcmp(table->name, table_name))
 			return table;
 	}
@@ -2226,7 +2226,7 @@ static int devlink_nl_cmd_dpipe_entries_get(struct sk_buff *skb,
 
 	table_name = nla_data(info->attrs[DEVLINK_ATTR_DPIPE_TABLE_NAME]);
 	table = devlink_dpipe_table_find(&devlink->dpipe_table_list,
-					 table_name);
+					 table_name, devlink);
 	if (!table)
 		return -EINVAL;
 
@@ -2382,7 +2382,7 @@ static int devlink_dpipe_table_counters_set(struct devlink *devlink,
 	struct devlink_dpipe_table *table;
 
 	table = devlink_dpipe_table_find(&devlink->dpipe_table_list,
-					 table_name);
+					 table_name, devlink);
 	if (!table)
 		return -EINVAL;
 
@@ -6814,7 +6814,7 @@ bool devlink_dpipe_table_counter_enabled(struct devlink *devlink,
 
 	rcu_read_lock();
 	table = devlink_dpipe_table_find(&devlink->dpipe_table_list,
-					 table_name);
+					 table_name, devlink);
 	enabled = false;
 	if (table)
 		enabled = table->counters_enabled;
@@ -6845,7 +6845,8 @@ int devlink_dpipe_table_register(struct devlink *devlink,
 
 	mutex_lock(&devlink->lock);
 
-	if (devlink_dpipe_table_find(&devlink->dpipe_table_list, table_name)) {
+	if (devlink_dpipe_table_find(&devlink->dpipe_table_list, table_name,
+				     devlink)) {
 		err = -EEXIST;
 		goto unlock;
 	}
@@ -6881,7 +6882,7 @@ void devlink_dpipe_table_unregister(struct devlink *devlink,
 
 	mutex_lock(&devlink->lock);
 	table = devlink_dpipe_table_find(&devlink->dpipe_table_list,
-					 table_name);
+					 table_name, devlink);
 	if (!table)
 		goto unlock;
 	list_del_rcu(&table->list);
@@ -7038,7 +7039,7 @@ int devlink_dpipe_table_resource_set(struct devlink *devlink,
 
 	mutex_lock(&devlink->lock);
 	table = devlink_dpipe_table_find(&devlink->dpipe_table_list,
-					 table_name);
+					 table_name, devlink);
 	if (!table) {
 		err = -EINVAL;
 		goto out;
-- 
2.17.1

