Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82971CCC43
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 18:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbgEJQh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 12:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728892AbgEJQh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 12:37:58 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD4AC061A0C
        for <netdev@vger.kernel.org>; Sun, 10 May 2020 09:37:58 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id e26so15397404wmk.5
        for <netdev@vger.kernel.org>; Sun, 10 May 2020 09:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rH53CFBSBWJ7e00gOYK8G86J64m2HwFSCMB/ra3QTk8=;
        b=fAnKRTnobUWtBMyDeaV7BFsAA2vj0QZexf83iASvfKBaLQgDAk1TaAEfDktl+M6BpQ
         XjCqpVTF2A/LJjG2K8w3ig4/y2lezbDsYkQyGDlcnxW8wJFgwy9iblwuUsLxRKW2eKJj
         QQD0x3iA5Gws/sxDDtqOi7cXIr4RL5nEZHQbUc47AuZ3h4Ftk0IhJE6p6Fq0sKSa2pBs
         wBG5v1oab1xKZO8ZQwgKx2xHRUiLbMbWCychKAWRfBc5Cad3Gp/G2Nishove9I9KbbWs
         LYKRilsai97YVwFsINYos5cqbSvj1BAUonOGliARZdoqwr5mG2CstqBv8kYeYDCa8HYa
         oPUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rH53CFBSBWJ7e00gOYK8G86J64m2HwFSCMB/ra3QTk8=;
        b=kKzhk1Pvzil/tpRqph1eoodGgrhtZA/P7BpnvTkR79QvV4H2qmYNJvjJ3Bjlz0H1p0
         pmHU6IW3qt0SDz4LnkZFC5yO0JNzEgVbDzcFZ4W9T9qD0J/T3VEvGMqsEvf0VsZ4IXi1
         alnPQPMfY9IhT6ZFYRHkGxaaTf5+4ixyYrYUoMm1SeGCkVR/oUEQ9uLGQ+QoeNVp0D0X
         QloujNjPKkTD5ARxN0z3FPDTxdxgfguvcpIhsoduIMhZ4XEpneXnKgEBnMHz3UsYuHN4
         CIyDaD0MKUv1mW/fj5LkAdY0do86XMZjdVNBwaPul6QgTRZG+wXeuMLeID5usHoqF6E8
         w5Iw==
X-Gm-Message-State: AGi0Publ0mTSiOkHbnu6hxsqzJKwZ0dzA2kVebkJf0aQTLwhvG/pq29J
        ymqCJ0x+I5+G6h+pguAVXWI=
X-Google-Smtp-Source: APiQypKT1Xbmy2RL2M7YZSfBEkbtnDPNMwuCgTACxPeFSOdiEF/q7KAX6FuYfvDa0L07PpISV0lIVg==
X-Received: by 2002:a1c:a793:: with SMTP id q141mr5872471wme.135.1589128677236;
        Sun, 10 May 2020 09:37:57 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id d133sm25472394wmc.27.2020.05.10.09.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2020 09:37:56 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com
Subject: [PATCH v4 resend net-next 3/4] net: dsa: introduce a dsa_switch_find function
Date:   Sun, 10 May 2020 19:37:42 +0300
Message-Id: <20200510163743.18032-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200510163743.18032-1-olteanv@gmail.com>
References: <20200510163743.18032-1-olteanv@gmail.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
None.

 include/net/dsa.h |  1 +
 net/dsa/dsa2.c    | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 0f4fc00239d9..312c2f067e65 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -672,6 +672,7 @@ static inline bool dsa_can_decode(const struct sk_buff *skb,
 
 void dsa_unregister_switch(struct dsa_switch *ds);
 int dsa_register_switch(struct dsa_switch *ds);
+struct dsa_switch *dsa_switch_find(int tree_index, int sw_index);
 #ifdef CONFIG_PM_SLEEP
 int dsa_switch_suspend(struct dsa_switch *ds);
 int dsa_switch_resume(struct dsa_switch *ds);
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index d90665b465b8..076908fdd29b 100644
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

