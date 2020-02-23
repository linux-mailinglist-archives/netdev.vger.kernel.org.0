Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 907C0169741
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 11:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgBWKxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 05:53:37 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:38938 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgBWKxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 05:53:37 -0500
Received: by mail-pj1-f67.google.com with SMTP id e9so2784816pjr.4;
        Sun, 23 Feb 2020 02:53:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=OEEW1DTnBFbnlO66oXY98scwTWu597r8Ev8ViVHpyjY=;
        b=lAtq8oy7ZbFUvK4mz2/eececVa4oaLqY/H+M5CQXdYP4afRefZsPdaon55bltTSMIv
         Ct5Q+tAqUpLNDsi3rKHVSXINgwHIlTuwXVqVu+Ihmt1heNqAbcPZcgXmnaMgAkol0hdG
         7Y4dTpdiV1N84jV+dbCAQeJoVgr5rco0ESE0YJHW8z9ejkDgrXcZTsRHY/MrzrTrNJLg
         aXiPGUjixjxqxmZBb/NmGIN++5cS66GvvaLKO92yXYBpRkbXxSK2uEfXkfVV5dBzr9/S
         WUSsOeuKCLfuHBHs+uvSUzDwW7YYyUFbV1oO2ZUv2F8YPYrvYwbMKCFZK3Jn8j/DorQT
         d8ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=OEEW1DTnBFbnlO66oXY98scwTWu597r8Ev8ViVHpyjY=;
        b=qF3JxA8NTAKHPmVEb4+KPv2Uj3oIv/8v6FIbxn5vVL+WU56j8Eej7As0UIj7UVCSop
         lZlxNROB17jh5NTyI8pbSa3HkbNvx9STaXX4ob7c7bPlwJ3lSzCCxJXlKnM1IPdwwW3j
         k9xAUl0uwkNF20x3C06IXk1MOKTg5TQZaemv7fTmTIEivULDq3m2ZU4IWaCKFnofXCQc
         sre9nMIwwhiKaqKkKuWtA3S+YBnNLikt5nTezqQLz6I2bVVD8P+wrZ3+f/sDSC6TpCCt
         VYhCosULC4Zd/uH32DLE/5W5cg0PLzk4nJBbyc/sY0/gDbYb10X4tJvP3zOri4W9QWn6
         uK8g==
X-Gm-Message-State: APjAAAWsC8DBtZddcsDzk52JFZcj+IdtNDF5ddgOjrc9ulX+dY+Ljwum
        ndOyZ8JzwQEQ9FFuWCGGFtJjhOo=
X-Google-Smtp-Source: APXvYqwNX2gq8OJNtybbXhKPh2g63AGm/Zg0Us7nmGCHpT6shOf99h31rxsenrwhSWOhYH1C7vz5fw==
X-Received: by 2002:a17:902:204:: with SMTP id 4mr46168201plc.266.1582455216243;
        Sun, 23 Feb 2020 02:53:36 -0800 (PST)
Received: from madhuparna-HP-Notebook.nitk.ac.in ([2402:3a80:515:9a49:e8ed:fa6e:a613:7ebf])
        by smtp.gmail.com with ESMTPSA id v8sm8842150pgt.52.2020.02.23.02.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 02:53:35 -0800 (PST)
From:   madhuparnabhowmik10@gmail.com
To:     jiri@mellanox.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        joel@joelfernandes.org,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH] net: core: devlink.c: Hold devlink->lock from the beginning of devlink_dpipe_table_register()
Date:   Sun, 23 Feb 2020 16:22:53 +0530
Message-Id: <20200223105253.30469-1-madhuparnabhowmik10@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

devlink_dpipe_table_find() should be called under either
rcu_read_lock() or devlink->lock. devlink_dpipe_table_register()
calls devlink_dpipe_table_find() without holding the lock
and acquires it later. Therefore hold the devlink->lock
from the beginning of devlink_dpipe_table_register().

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
---
 net/core/devlink.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 4c63c9a4c09e..61a350f59741 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6838,26 +6838,35 @@ int devlink_dpipe_table_register(struct devlink *devlink,
 				 void *priv, bool counter_control_extern)
 {
 	struct devlink_dpipe_table *table;
+	int err = 0;
 
-	if (devlink_dpipe_table_find(&devlink->dpipe_table_list, table_name))
-		return -EEXIST;
+	mutex_lock(&devlink->lock);
 
-	if (WARN_ON(!table_ops->size_get))
-		return -EINVAL;
+	if (devlink_dpipe_table_find(&devlink->dpipe_table_list, table_name)) {
+		err = -EEXIST;
+		goto unlock;
+	}
+
+	if (WARN_ON(!table_ops->size_get)) {
+		err = -EINVAL;
+		goto unlock;
+	}
 
 	table = kzalloc(sizeof(*table), GFP_KERNEL);
-	if (!table)
-		return -ENOMEM;
+	if (!table) {
+		err = -ENOMEM;
+		goto unlock;
+	}
 
 	table->name = table_name;
 	table->table_ops = table_ops;
 	table->priv = priv;
 	table->counter_control_extern = counter_control_extern;
 
-	mutex_lock(&devlink->lock);
 	list_add_tail_rcu(&table->list, &devlink->dpipe_table_list);
+unlock:
 	mutex_unlock(&devlink->lock);
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_dpipe_table_register);
 
-- 
2.17.1

