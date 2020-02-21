Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5512168622
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 19:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgBUSJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 13:09:56 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:56242 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbgBUSJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 13:09:56 -0500
Received: by mail-pj1-f68.google.com with SMTP id d5so1086657pjz.5;
        Fri, 21 Feb 2020 10:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=YnVHKaoJO1HX1P3NwrYh2l54OzBJ4vkSrlh4+CAHtGg=;
        b=hO+B1xyxXHmcprcyOZM3Cy0x+2O3VQsdZjPTe+ekQC7GFiaiWjd8FyaNONdKkg3T/t
         +2NAXkZ6mbo4wtvB8xBdIV4NrJs8TgXNSfzBUAAH2A9ZOR0gyFmB8mk+R4bGgM/sRkkT
         KF3fmjik6hIhZFmPnqUH9EhRaJFnTE08Xg13MVZzcLSJCbEZq8KPvt59pr6NLkMfMj2y
         IWgl1BCkSi7UPCaEdwwSkCyef472NQWEcpc/VBIZ1fKdf/m0/x1J3a7QsHCKZ19beETK
         ZKAjShshl2w5hRyoJS2BZ6GFLemmWtsnNQzsQ91/yMUmQtK21LLt7FECYeEWnVqgwGk0
         7e9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YnVHKaoJO1HX1P3NwrYh2l54OzBJ4vkSrlh4+CAHtGg=;
        b=ryDgeQ7fjWudArEwSD4UJ27ssQ/ONAkD3S3SBBMLOYuuJwb6vdkNphFEj6AalqzpHp
         CbftHzT2XBwp3LiKijSoxZ/NlTNDlB/2AO7U0mFV3NyhqYDMujms0TE8G6u9+Q7h10rF
         fkRVI+aVkmwH1u4VtmEC2kUAodDh549GqCJSgnpVGz50YZBykXgy7z5FnWA8A+Mht/35
         oHzRWgXPPFiL3zHsSyVGqFB1u1exwVz0Rj7WhoTtavy/GEiGfNx+WVMeJCSmRF25B2XT
         +2z2SLrk5S+nxAdej7DE5JDkof3FAzLACqR017DSvHsbe7R873oaEKDHACRnkbIbSkLG
         9bNg==
X-Gm-Message-State: APjAAAV2Hl+tr0LGzI+T3/d5CKCErzRsHCPCbpwjdJaUdPjwU8mXhl3h
        MKZZvi4sEwvfD4wbhPuo2uhISV8=
X-Google-Smtp-Source: APXvYqwJhe7ghkmt0lMpu8J3qCpPScB3kKurmtqaq6raB9yrlGmcE021hxheks/b4wl7pzkD7yAQYg==
X-Received: by 2002:a17:902:ab81:: with SMTP id f1mr38545653plr.5.1582308594745;
        Fri, 21 Feb 2020 10:09:54 -0800 (PST)
Received: from madhuparna-HP-Notebook.nitk.ac.in ([2402:3a80:1ee0:fe5e:d03d:769b:c838:c146])
        by smtp.gmail.com with ESMTPSA id x65sm3639043pfb.171.2020.02.21.10.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 10:09:54 -0800 (PST)
From:   madhuparnabhowmik10@gmail.com
To:     jiri@mellanox.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        joel@joelfernandes.org, frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH] net: core: devlink.c: Hold devlink->lock from the beginning of devlink_dpipe_table_register()
Date:   Fri, 21 Feb 2020 23:39:43 +0530
Message-Id: <20200221180943.17415-1-madhuparnabhowmik10@gmail.com>
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
 net/core/devlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 3e8c94155d93..d54e1f156b6f 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6840,6 +6840,8 @@ int devlink_dpipe_table_register(struct devlink *devlink,
 {
 	struct devlink_dpipe_table *table;
 
+	mutex_lock(&devlink->lock);
+
 	if (devlink_dpipe_table_find(&devlink->dpipe_table_list, table_name))
 		return -EEXIST;
 
@@ -6855,7 +6857,6 @@ int devlink_dpipe_table_register(struct devlink *devlink,
 	table->priv = priv;
 	table->counter_control_extern = counter_control_extern;
 
-	mutex_lock(&devlink->lock);
 	list_add_tail_rcu(&table->list, &devlink->dpipe_table_list);
 	mutex_unlock(&devlink->lock);
 	return 0;
-- 
2.17.1

