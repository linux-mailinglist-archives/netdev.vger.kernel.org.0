Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55A0B16A24E
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 10:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbgBXJah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 04:30:37 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:33541 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbgBXJah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 04:30:37 -0500
Received: by mail-pj1-f68.google.com with SMTP id m7so3872656pjs.0;
        Mon, 24 Feb 2020 01:30:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=TzHPIC1N5lujx/c4PdrT0qr3lBEBYRGEgiiSQgfxX0Q=;
        b=F+kebht7CIAgDDYDNVPs2fj7BHGZsc+fhhFSV+NHv2vm5iiUu2tp/euw0/qQG4I5FM
         p+pXewsBFekfJ6VLvLbOqKIBI+ORiDTkEhWjUyDXmeo3tCHMEhZ64xHe5jl6gWGnbHiN
         E6hlBEgdffHZk/lQbYUfeMa/joFXOhtyNEnCMY0k0ALp/FhBJll+X0lf5wS/CL4NSsZH
         2vDlrCjxS1uYnuhdFwz2eZDgSifrkcAo1dgVgt8oHYxaMIMPd+jJDfwnkm/8TkP/1reO
         Ep7+E+L0zseAiflDfxekb3+X5tLnk+dY2er5czPgHZnaoe43dqoZBX7sFCHBzmMVKC3r
         8XfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TzHPIC1N5lujx/c4PdrT0qr3lBEBYRGEgiiSQgfxX0Q=;
        b=QpH/QtauDv/OObeG+PIPDn4gOoO4afeEzDd+uM77nTOT+ipinItJZe09SXjuj+wTRW
         6msxZkiG7+JZbzt8sH/WLgP0B7JQldoq3Hrj6qzGxqbcpZCXTJSMh9AhtuyqUTeACWZS
         S+2YiL6J6PfPhGemMpKQX0BIhHFgKTXSEOWH0E/obacOlNyFyTvEteky50VLHGQAN8sU
         YjyD2/K20dFekOAfLKmQsjaLQl9xA1MMEzHyYKjTBNi/YbcW9SiienuhUyUKfTYL0Wdj
         4sFGs8U9C66YXdmap4V0o50keZQo7pBLohmR0zaEuFI6rWC1ffwtHuldh/KjOK8UWM0U
         RMpw==
X-Gm-Message-State: APjAAAXQGmhSyxgeUfOSwKMzQeZNSRgi21dz3Y4byw8UrelbZSThXSik
        k2GQuciRqvvdh7bfT3ngeQ==
X-Google-Smtp-Source: APXvYqwKi/xOhNp1DVmUj92WivktpNFQDkOR3l3um1lBMxrFlN6G4zpoD6kqG/y6XoPfmYGnQAxcGg==
X-Received: by 2002:a17:902:fe8d:: with SMTP id x13mr50387571plm.232.1582536635071;
        Mon, 24 Feb 2020 01:30:35 -0800 (PST)
Received: from madhuparna-HP-Notebook.nitk.ac.in ([2402:3a80:1ee7:f49b:e8e5:803b:cde8:bccc])
        by smtp.gmail.com with ESMTPSA id 11sm12119680pfz.25.2020.02.24.01.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 01:30:33 -0800 (PST)
From:   madhuparnabhowmik10@gmail.com
To:     jiri@mellanox.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        joel@joelfernandes.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        frextrite@gmail.com, paulmck@kernel.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH] net: core: devlink.c: Use built-in RCU list checking
Date:   Mon, 24 Feb 2020 15:00:13 +0530
Message-Id: <20200224093013.25700-1-madhuparnabhowmik10@gmail.com>
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
 net/core/devlink.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index e82750bdc496..dadf5fa79bb1 100644
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
@@ -6845,7 +6845,7 @@ int devlink_dpipe_table_register(struct devlink *devlink,
 
 	mutex_lock(&devlink->lock);
 
-	if (devlink_dpipe_table_find(&devlink->dpipe_table_list, table_name)) {
+	if (devlink_dpipe_table_find(&devlink->dpipe_table_list, table_name, devlink)) {
 		err = -EEXIST;
 		goto unlock;
 	}
@@ -6881,7 +6881,7 @@ void devlink_dpipe_table_unregister(struct devlink *devlink,
 
 	mutex_lock(&devlink->lock);
 	table = devlink_dpipe_table_find(&devlink->dpipe_table_list,
-					 table_name);
+					 table_name, devlink);
 	if (!table)
 		goto unlock;
 	list_del_rcu(&table->list);
@@ -7038,7 +7038,7 @@ int devlink_dpipe_table_resource_set(struct devlink *devlink,
 
 	mutex_lock(&devlink->lock);
 	table = devlink_dpipe_table_find(&devlink->dpipe_table_list,
-					 table_name);
+					 table_name, devlink);
 	if (!table) {
 		err = -EINVAL;
 		goto out;
-- 
2.17.1

