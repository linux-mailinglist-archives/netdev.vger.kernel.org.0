Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9D1A168CFC
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 07:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgBVGxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 01:53:09 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37813 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbgBVGxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 01:53:09 -0500
Received: by mail-pf1-f194.google.com with SMTP id p14so2465547pfn.4;
        Fri, 21 Feb 2020 22:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=O8dGjw47rBMTaYq9ZdIJC+Ct6bZIAQqAuCZjvsrgZq8=;
        b=UWf3o/nEx+XZVQxA8TbPakPz+HWWS1vWyxffSLKKOmh+vtB76WPi9666TVY80DE/54
         yg78oRlOJ2rdlUSabRRdLed8VYF+rMDwp5eKKRnbaaXgAgu3f7/Chf8CK/lukAacHOF/
         P6AQsNmXhOlxvgTgdWidnw0QYm/ZpAj8NLRccYR+wWCODSJPt+HRtt88Z+3YNwSmf0mc
         FvgILHFFOr+fHt13B30aqvt4SFTrhr3udX6vMgo75SeWR3aXipNHfm0W6r7rUi+izf+z
         y3Piw82miHXfGGz9IWG9hzgrsuBOswaCUIDloVHoPfjDMD8+b5CRhlP//O6kGC3nGYMl
         6rAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=O8dGjw47rBMTaYq9ZdIJC+Ct6bZIAQqAuCZjvsrgZq8=;
        b=XMQn7ki7BJeGNuz0UeObzvK/If+4ML6m9LVXR7TCwcy5CoTAyBxvzivXFcnm71L3s5
         JIxXmpTVzmEqGDQ01GSfZwdxqqnG+Dh2Zr/yF2WfamAMcJ+mdsZ0yNfdW5xSakyxkvlH
         MZ6hGYRZEapmjHCrltZBwcncDs5Bce6SXevN4mGiceu878Gziyh0bFfZuUhZ1krw7XEo
         YgpEwfg//+SI0bAM2U3t1MWZDzdazDJ/TFqkcoi04VUX6y3tZ4ONJJ16gARpHo/nrx+H
         CwvYlyQaIXY4ZXdIasWFbBjDJV7jHRN0KvHNJoKURgnaa//YBcGAsRLOOnGetyetOBfd
         GxcA==
X-Gm-Message-State: APjAAAX+o51JdRntTULEAYCmH8BlJhNLMru93nOOQALH603cwEJ/ENqK
        XImLc6XcLZX/YVySXzn+Iw==
X-Google-Smtp-Source: APXvYqxCu6MyWMp3NdwLGo82GJR7m2KUSumjYRTil3dfhsgIWR7CGlVVNIztSQdZsszDa4hWCju4GA==
X-Received: by 2002:a63:5e07:: with SMTP id s7mr41011057pgb.261.1582354388478;
        Fri, 21 Feb 2020 22:53:08 -0800 (PST)
Received: from madhuparna-HP-Notebook.nitk.ac.in ([2402:3a80:536:efd4:3cf2:2ab1:f2dc:185c])
        by smtp.gmail.com with ESMTPSA id d14sm4708631pjz.12.2020.02.21.22.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 22:53:07 -0800 (PST)
From:   madhuparnabhowmik10@gmail.com
To:     jiri@mellanox.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        joel@joelfernandes.org, frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH] net: core: devlink.c: Hold devlink->lock from the beginning of devlink_dpipe_table_register()
Date:   Sat, 22 Feb 2020 12:22:34 +0530
Message-Id: <20200222065234.8829-1-madhuparnabhowmik10@gmail.com>
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

Suggested-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
---
 net/core/devlink.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 3e8c94155d93..ba9dd8cb98c3 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6840,22 +6840,29 @@ int devlink_dpipe_table_register(struct devlink *devlink,
 {
 	struct devlink_dpipe_table *table;
 
-	if (devlink_dpipe_table_find(&devlink->dpipe_table_list, table_name))
+	mutex_lock(&devlink->lock);
+
+	if (devlink_dpipe_table_find(&devlink->dpipe_table_list, table_name)) {
+		mutex_unlock(&devlink->lock);
 		return -EEXIST;
+	}
 
-	if (WARN_ON(!table_ops->size_get))
+	if (WARN_ON(!table_ops->size_get)) {
+		mutex_unlock(&devlink->lock);
 		return -EINVAL;
+	}
 
 	table = kzalloc(sizeof(*table), GFP_KERNEL);
-	if (!table)
+	if (!table) {
+		mutex_unlock(&devlink->lock);
 		return -ENOMEM;
+	}
 
 	table->name = table_name;
 	table->table_ops = table_ops;
 	table->priv = priv;
 	table->counter_control_extern = counter_control_extern;
 
-	mutex_lock(&devlink->lock);
 	list_add_tail_rcu(&table->list, &devlink->dpipe_table_list);
 	mutex_unlock(&devlink->lock);
 	return 0;
-- 
2.17.1

