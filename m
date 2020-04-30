Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75881C07DF
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 22:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbgD3UZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 16:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727832AbgD3UZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 16:25:52 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C187C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 13:25:51 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id d17so8792458wrg.11
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 13:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ApjSk/50jRjyhk0cZtIwoXWTq09wjHoGSh17ig0ay5c=;
        b=YWC+O+LdWhsqzyspxUM7YjSVEcHKKIWGhyKRmoxLF3TIJV8c4MeMhbtYGLomwahSjF
         lZazMZBGKto/+A7rheZZ50HmYYRGMhg188zw1hZozb1rzn9WZ7dcHUC1NaY2VDBSWEHt
         XsiMDwqK5boYRZOyJprKdUOGNlL79MXfTGcDP5wrlXryzQLxEzi05nDqgn67MB6LzQAD
         nWHn8V7hDrH++5+QVQeABmtdSJGl2zw4H3t7mno+JTcoN0oR2ZPgZwKo65nIkQuICOuP
         LDxeXPix5MN6up5RjLmn/8E2wWwoMF+MZsUPZMijtJu/mlBrBeyklce/rGUO4kjFNXI3
         YTaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ApjSk/50jRjyhk0cZtIwoXWTq09wjHoGSh17ig0ay5c=;
        b=KpAJADNWRxIv32/0nhPJEyHI97vbW/LSdmhSAv45lWtcrIcB4PukPpxDpyOunu+nny
         eYNBg/Yhxc4b2tzF5pCsfCEvuFC7SPgnaMKLoHrldKUKmMe5MUBsc9dM5TjTY+CeVKlZ
         BR0B4zdnjMhGCU2v0cFs540hwMD2Eyv8DsO7PZy75nGmp1PMqYHUSR0foVzfE+RapOeT
         1hiJIOVyqtnUMAW68EApY+WKbE2pFu1ifYRd+jgPPT6E8UUPjzdFNrFX7W/3Rq8OQD4H
         KAVRuIgY2alPu4bsAafxIa3AVsW/wstZb9kso0HK+fQp9/JXFy464QljaP+IqoFl+raX
         gHow==
X-Gm-Message-State: AGi0PuZyvtUTVP2TDxu19WKf8/8S6fLzYx2ys92e6oUREF7KSvXANVuT
        e7qo/HNMoYg5mGNIST8Fz88=
X-Google-Smtp-Source: APiQypJYeGGDytoOIHHatQgRUjsXh4dq/L9xSXlHWi6l0xWP4C+vhz5rYdk9/jd4jU0KqeEPXjcWnQ==
X-Received: by 2002:adf:dcca:: with SMTP id x10mr361797wrm.212.1588278350080;
        Thu, 30 Apr 2020 13:25:50 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id f8sm1188462wrm.14.2020.04.30.13.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 13:25:49 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, leoyang.li@nxp.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH v2 net-next 3/4] net: dsa: introduce a dsa_switch_find function
Date:   Thu, 30 Apr 2020 23:25:41 +0300
Message-Id: <20200430202542.11797-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430202542.11797-1-olteanv@gmail.com>
References: <20200430202542.11797-1-olteanv@gmail.com>
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

