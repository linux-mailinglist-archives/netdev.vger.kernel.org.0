Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963BF3BC117
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 17:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbhGEPlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 11:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233362AbhGEPld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 11:41:33 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D662BC061574
        for <netdev@vger.kernel.org>; Mon,  5 Jul 2021 08:38:56 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id t9so18625365pgn.4
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 08:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=T4dhU4vNUYUMAfVdjNq0yBk3ipIhsnfg40hCltrxSNQ=;
        b=g9AjZANKI1igS+w4HK69J8zGtHKAt9N7mTpeFAJqN+JqKAViqng1Wuszbq45xLglOP
         86C4nLehp/oIPsUZgMcljPJVgna782qZdhZnyTry4J0O6sKRpGZ9371rPjtcjQEAfs/K
         GhEJGBS/yIdPT2xlE5eEASu9pyMwNfAksleShLn5/9BwICgRvRJLFP1Tzpig0fzNiNAG
         H2lhF/K47LLgqVN+DsGvRJLdbphgLXhH6YWc++7/qLRGC4BgcV1wYOKMS3wKsyc/m4gi
         zI2ablOF37ALQzaFnPpEK/R2PS9O9gCn8e9AgEzZCNnecF+fs3yKN7F1pyFXTr2J2F0J
         6GPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=T4dhU4vNUYUMAfVdjNq0yBk3ipIhsnfg40hCltrxSNQ=;
        b=TFqDgUpxvYqG/Auq9LsMMChTT6yUM/5HcIvZKROYzQ2yhoOZR8ysR5xMKByafMl8gt
         K2ucxUsrmEMPItcg8GNpVw/WGH1vRU/gwRzL21+FrmNG9JkCtZpnjrKrIzNpWzAaTtUK
         TyOxCCPG/UiKsamdV5gIqFxYoCtJQyfRj+SeFi/AwyswNmKOr/a19VEL2tPQ5j7anF1X
         tuz7oXiUNkT5V+Kc70iCifr7jHylVOgAEgFfTcsMG6KrMEOjiOKw//0E6RGoeZQ0i8F3
         JNdu/5CvrLrrIqVVTL/jLkNHn7oy7uXYjR1PbEV3RkGc7arhbXagoNqhY/d2gb9S5fqC
         8C2Q==
X-Gm-Message-State: AOAM530KdafZQ4ybjCsmAszGdZSZOCIGkUHZySWD8jme5J9zmBAq/uWA
        hmK+CQHhH0sRsMmY1fB1siM=
X-Google-Smtp-Source: ABdhPJzv6bT6qCiLVBujxoVeW+4yFJCwanlBmfDWu3/3/Gv7xnM61NnFSiRXhgivVfvYtA7IZ0SiLA==
X-Received: by 2002:a62:8309:0:b029:312:d19:ac8b with SMTP id h9-20020a6283090000b02903120d19ac8bmr15771559pfe.63.1625499536445;
        Mon, 05 Jul 2021 08:38:56 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id k10sm9310353pfp.63.2021.07.05.08.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 08:38:55 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, jarod@redhat.com,
        intel-wired-lan@lists.osuosl.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 6/9] bonding: disallow setting nested bonding + ipsec offload
Date:   Mon,  5 Jul 2021 15:38:11 +0000
Message-Id: <20210705153814.11453-7-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210705153814.11453-1-ap420073@gmail.com>
References: <20210705153814.11453-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bonding interface can be nested and it supports ipsec offload.
So, it allows setting the nested bonding + ipsec scenario.
But code does not support this scenario.
So, it should be disallowed.

interface graph:
bond2
   |
bond1
   |
eth0

The nested bonding + ipsec offload may not a real usecase.
So, disallowing this scenario is fine.

Fixes: 18cb261afd7b ("bonding: support hardware encryption offload to slaves")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
v1 -> v2:
 - no change

 drivers/net/bonding/bond_main.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 7659e1fab19e..f268e67cb2f0 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -419,8 +419,9 @@ static int bond_ipsec_add_sa(struct xfrm_state *xs)
 	xs->xso.real_dev = slave->dev;
 	bond->xs = xs;
 
-	if (!(slave->dev->xfrmdev_ops
-	      && slave->dev->xfrmdev_ops->xdo_dev_state_add)) {
+	if (!slave->dev->xfrmdev_ops ||
+	    !slave->dev->xfrmdev_ops->xdo_dev_state_add ||
+	    netif_is_bond_master(slave->dev)) {
 		slave_warn(bond_dev, slave->dev, "Slave does not support ipsec offload\n");
 		rcu_read_unlock();
 		return -EINVAL;
@@ -453,8 +454,9 @@ static void bond_ipsec_del_sa(struct xfrm_state *xs)
 
 	xs->xso.real_dev = slave->dev;
 
-	if (!(slave->dev->xfrmdev_ops
-	      && slave->dev->xfrmdev_ops->xdo_dev_state_delete)) {
+	if (!slave->dev->xfrmdev_ops ||
+	    !slave->dev->xfrmdev_ops->xdo_dev_state_delete ||
+	    netif_is_bond_master(slave->dev)) {
 		slave_warn(bond_dev, slave->dev, "%s: no slave xdo_dev_state_delete\n", __func__);
 		goto out;
 	}
@@ -479,8 +481,9 @@ static bool bond_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *xs)
 	if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP)
 		return true;
 
-	if (!(slave_dev->xfrmdev_ops
-	      && slave_dev->xfrmdev_ops->xdo_dev_offload_ok)) {
+	if (!slave_dev->xfrmdev_ops ||
+	    !slave_dev->xfrmdev_ops->xdo_dev_offload_ok ||
+	    netif_is_bond_master(slave_dev)) {
 		slave_warn(bond_dev, slave_dev, "%s: no slave xdo_dev_offload_ok\n", __func__);
 		return false;
 	}
-- 
2.17.1

