Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C00F169754
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 12:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbgBWLWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 06:22:43 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36118 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgBWLWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 06:22:42 -0500
Received: by mail-pf1-f194.google.com with SMTP id 185so3784862pfv.3;
        Sun, 23 Feb 2020 03:22:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sN5H5uRLxodeA5ftMsFKjGciLDtvEDOcbHLiiCvT97A=;
        b=uuOFmCqu1d9sfG86Qiyc9owige0Ou0kvZAf7Aloq6yU5Vs9Jlp+tPaOTsRCcUfJhGv
         WF2zjCuWOg3RVOe+XDokcsT4rBZyHm7gMWSrS1xYkHaRLFlpxtjW1JbdrslewMQRcddP
         vaOUjmx5cMva+W5QjX9cNqHMZ1KGYYum6ncoZz+hGhS9J+X4a5zJroahnMULLMNwh6xZ
         z/Il2UJV4GzTC8L9RTzNNxNNy5F7wyTsi724lok/8K5gM/TnhGMkJzRaluxAr9GAQgyS
         7vFmi5vd8UJ4iEHPNQrjMIcQEx1C6QU4jh3eCKHcgfUyMyeqQ9PkqvgCBxbEnZ2nJpHJ
         ZFYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sN5H5uRLxodeA5ftMsFKjGciLDtvEDOcbHLiiCvT97A=;
        b=Qshy3r8q02w75WDT3pdaGJCRkZpNed5PVn++l08w2wvb5HMJeaHA4BAww4dSKWFLlX
         apevnZtrnih8hQGkx5rRywTGO5SQuFBV8R6tkkKNb0Iyb3VZe1r4/R/dW956PD1yAMXO
         3sL38Q42Ng677Yq1eUhmIpSP+wD5sVVY//EQJalbU+toDf/HsmJipJ18sCB3dGpV8AjR
         S6vJv6CZYRwaBHZYUIhHgHcV6bZQaZxpX0y8ei/P5AAgqMGidyEXNp6DvzL5EqwI3AJD
         Y2Hg/RMPDGHm4BNuTVR8Eb0V+llfC6scay5BhNPR9IIXTF3NIY2ry7CCGIao5aDn8+RV
         adbw==
X-Gm-Message-State: APjAAAVRzzHKQc/adL69mm7ntY36EzSgojIW9B3XdU8fnSdgt42p+8f4
        a3A7u1N9TVP0LTRTsGtneg==
X-Google-Smtp-Source: APXvYqzFWkFdZrObvg5gTMa7MV1O7ZL7rM1c9JISPyZ95Uyl7uXVnez3GO1zSfXywPpVHNl48+/+8A==
X-Received: by 2002:a63:ec07:: with SMTP id j7mr47290312pgh.187.1582456960948;
        Sun, 23 Feb 2020 03:22:40 -0800 (PST)
Received: from madhuparna-HP-Notebook.nitk.ac.in ([2402:3a80:515:9a49:e8ed:fa6e:a613:7ebf])
        by smtp.gmail.com with ESMTPSA id j8sm8641078pjb.4.2020.02.23.03.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 03:22:40 -0800 (PST)
From:   madhuparnabhowmik10@gmail.com
To:     jiri@mellanox.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        joel@joelfernandes.org,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH] net: core: devlink.c: Hold devlink->lock from the beginning of devlink_dpipe_table_register()
Date:   Sun, 23 Feb 2020 16:52:33 +0530
Message-Id: <20200223112233.13417-1-madhuparnabhowmik10@gmail.com>
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
 net/core/devlink.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 4c63c9a4c09e..e82750bdc496 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6838,26 +6838,33 @@ int devlink_dpipe_table_register(struct devlink *devlink,
 				 void *priv, bool counter_control_extern)
 {
 	struct devlink_dpipe_table *table;
-
-	if (devlink_dpipe_table_find(&devlink->dpipe_table_list, table_name))
-		return -EEXIST;
+	int err = 0;
 
 	if (WARN_ON(!table_ops->size_get))
 		return -EINVAL;
 
+	mutex_lock(&devlink->lock);
+
+	if (devlink_dpipe_table_find(&devlink->dpipe_table_list, table_name)) {
+		err = -EEXIST;
+		goto unlock;
+	}
+
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

