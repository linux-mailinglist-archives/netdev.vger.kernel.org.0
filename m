Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3045D1C2FE6
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 00:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729185AbgECWMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 18:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729182AbgECWMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 18:12:44 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81415C061A0E
        for <netdev@vger.kernel.org>; Sun,  3 May 2020 15:12:44 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id v4so14155607wme.1
        for <netdev@vger.kernel.org>; Sun, 03 May 2020 15:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PKWJfGIHtLWuN5jwDyBBGWfr52u7WQX+Z65ojM6uIqI=;
        b=JZt+C9MgXpQEy9pve090Wq4SPQ5IwwHMl+Z51LaAyB+uJAD4I2qGdMnmBJXENQHW1a
         KbF8EgQGSbutCAip01u0vlRRt4Kycb1PgDFqm503BzpAz1Dnk65fNPSAOoa0ksruVhK0
         x6+Kw24f+aPaXpX7saIly6wlx1UHtxkohTEIdE4sTlmftSPaV2LcNypu96vdMa6Mma9Q
         Bqlp3vb41Sxbum1rDHM5Sff08BsqU9gaY0ZDXmzFSMrDtiVdXlZR0XtwWYFGp9oSw1Ix
         Zg84pKuzLrtCxl8LTtHh/ZxFgpVBcZEqoLXI2cpmVT4a4VQ+gcKVsWuykj2bm7wG4gxL
         MLKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PKWJfGIHtLWuN5jwDyBBGWfr52u7WQX+Z65ojM6uIqI=;
        b=EBmJMmb8mzZwhqgHFF3qsDZKP09INAph58GDDyCl/UWUdEDj2ljks/om/6f5lhxz7y
         XK5cKWx/iC1JESgcwyQ+7mHuMgax1dYoav4QjPpp2e14zRAOTScuJBQ3cWNdM47wKbsJ
         g/kOn3vNOz8ZXp1psJRCtUgN9WnT6XgjO5jkLwyvOnf91d7bZeztYxcPmSf4ck9XllgL
         YJvTOuhwIYKj7yxeJGKlKs9ftgBerDFSIFx5vpAYMBpxm/8wJ681oGePXuBA0VkOLuq+
         8kHTGggUztu/J2nPwS5d3gLp1Tu6ISveLnXXzh5RTqSnbJUtOtXl8r9kdPwus1xEOhV0
         hzkg==
X-Gm-Message-State: AGi0PubgsYXllihTRGvlPbSyTgcXPxMjD3Kc8jE187cSz5Uo53hvAzzp
        2/YWuH5VL4NcnsJDoPMs9Vo=
X-Google-Smtp-Source: APiQypKGR1dT8P6B94ZZAz35EheOFEVec3XwVPI7xzGTrh5PeC5rkwkTeK+pecMJRt5lIGxZC7iJXA==
X-Received: by 2002:a7b:c941:: with SMTP id i1mr10386715wml.132.1588543959175;
        Sun, 03 May 2020 15:12:39 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id q143sm10692188wme.31.2020.05.03.15.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2020 15:12:38 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, mingkai.hu@nxp.com
Subject: [PATCH v3 net-next 3/4] net: dsa: introduce a dsa_switch_find function
Date:   Mon,  4 May 2020 01:12:27 +0300
Message-Id: <20200503221228.10928-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200503221228.10928-1-olteanv@gmail.com>
References: <20200503221228.10928-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Somewhat similar to dsa_tree_find, dsa_switch_find returns a dsa_switch
structure pointer by searching for its tree index and switch index (the
parameters from dsa,member). To be used, for example, by drivers who
implement .crosschip_bridge_join and need a reference to the other
switch indicated to by the tree_index and sw_index arguments.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v2:
None.

 include/net/dsa.h |  1 +
 net/dsa/dsa2.c    | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index bd5561dacb13..c5e2530f54c9 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -671,6 +671,7 @@ static inline bool dsa_can_decode(const struct sk_buff *skb,
 
 void dsa_unregister_switch(struct dsa_switch *ds);
 int dsa_register_switch(struct dsa_switch *ds);
+struct dsa_switch *dsa_switch_find(int tree_index, int sw_index);
 #ifdef CONFIG_PM_SLEEP
 int dsa_switch_suspend(struct dsa_switch *ds);
 int dsa_switch_resume(struct dsa_switch *ds);
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 9a271a58a41d..07e01b195975 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -24,6 +24,27 @@ LIST_HEAD(dsa_tree_list);
 static const struct devlink_ops dsa_devlink_ops = {
 };
 
+struct dsa_switch *dsa_switch_find(int tree_index, int sw_index)
+{
+	struct dsa_switch_tree *dst;
+	struct dsa_port *dp;
+
+	list_for_each_entry(dst, &dsa_tree_list, list) {
+		if (dst->index != tree_index)
+			continue;
+
+		list_for_each_entry(dp, &dst->ports, list) {
+			if (dp->ds->index != sw_index)
+				continue;
+
+			return dp->ds;
+		}
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(dsa_switch_find);
+
 static struct dsa_switch_tree *dsa_tree_find(int index)
 {
 	struct dsa_switch_tree *dst;
-- 
2.17.1

