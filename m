Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB5DF168429
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 17:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgBUQxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 11:53:10 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44229 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbgBUQxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 11:53:09 -0500
Received: by mail-pf1-f195.google.com with SMTP id y5so1506579pfb.11;
        Fri, 21 Feb 2020 08:53:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2hY9rIiih8tmdugozlZsp7q9G6E5pP7+c2/8u13UX8A=;
        b=LQEmUwErip2nQCUkW0HJOVtYZuDA/PNx8tbnf+qcUjlmDRz4It46DzTFWcf2S4EGIE
         /s6JUGUihBgs1Lma2v/xZ6eeVNL1+cSzGsqtNINMYWc7Mxj21e9B4kcZA+hwCl6J5CEk
         MKsmP1qR4BVUS5kAA+5YlTbIQsWLGzwH6rLx6DvfNAhiR+v16g3Fp/e6Cfi2LI03fy0/
         OoqPMUwUwKPwlG/qU4zq64qbPkydQ0vzuXEPuQTr1d8B8m66k+GGZaY+0rbMo2Q0iRD7
         mJ0C4lIScO2lcxg9gC7Q3kx6CN9qfie17KdVk4QpsOTKxqyCPBr4YaLWAqXEsy6SXCnA
         sjhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2hY9rIiih8tmdugozlZsp7q9G6E5pP7+c2/8u13UX8A=;
        b=HYE2Gg9xkGxFbq1hWC7iuvkn9cOCxvzspNszRzSoNzgQFl2Ud8i6gL30s3J5dLxUD0
         hdbz9OJUHNaF5lj+erH7cT9hxgHtoV6GqmA+qgVhBurE86SWuLDFR10byLvCEbinvRwi
         jOyZtP0P36Tp8r4eAoqmTWV0J8ilYVLrXUceRMwP64rDOmZhcTMTbbU2l297c/eM5HVn
         mfkbWDrTCUO1Ssuh3tPGqOjGPfqgLbdc2u2Hucu0iQx8FBw1XW3wIsTF7DID/IszZYSY
         KZKZp0M4bmZ/j5i2bF/sIj9vXGa3vApAiNi2vLBfCgTBhE/qYKfA9A4YLGv0yO3CVRPR
         XmxQ==
X-Gm-Message-State: APjAAAWxSfgum1qP+t6jPsDcrOOJ+f6/nQKSO46vN1P+efEss2QBweqo
        mLJWNtvTmyJNKLef+RCO0A==
X-Google-Smtp-Source: APXvYqzzkLEq3JUDwv5Bq1ToF86o+d9OVUW1fYL6S8Dqm2aM5Sb5Qk2tn+/yVtkRiCdg/G1uA2ggGA==
X-Received: by 2002:aa7:8bda:: with SMTP id s26mr39031993pfd.194.1582303989009;
        Fri, 21 Feb 2020 08:53:09 -0800 (PST)
Received: from madhuparna-HP-Notebook.nitk.ac.in ([2402:3a80:1ee0:fe5e:d03d:769b:c838:c146])
        by smtp.gmail.com with ESMTPSA id l13sm3150484pjq.23.2020.02.21.08.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 08:53:08 -0800 (PST)
From:   madhuparnabhowmik10@gmail.com
To:     jiri@mellanox.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        joel@joelfernandes.org, frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH] net: core: devlink.c: Use built-in RCU list checking
Date:   Fri, 21 Feb 2020 22:21:41 +0530
Message-Id: <20200221165141.24630-1-madhuparnabhowmik10@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

list_for_each_entry_rcu() has built-in RCU and lock checking.

Pass cond argument to list_for_each_entry_rcu() to silence
false lockdep warning when CONFIG_PROVE_RCU_LIST is enabled
by default.

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
---
 net/core/devlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 4c63c9a4c09e..3e8c94155d93 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -2107,7 +2107,8 @@ devlink_dpipe_table_find(struct list_head *dpipe_tables,
 {
 	struct devlink_dpipe_table *table;
 
-	list_for_each_entry_rcu(table, dpipe_tables, list) {
+	list_for_each_entry_rcu(table, dpipe_tables, list,
+				lockdep_is_held(&devlink->lock)) {
 		if (!strcmp(table->name, table_name))
 			return table;
 	}
-- 
2.17.1

