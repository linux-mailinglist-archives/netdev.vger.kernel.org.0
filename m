Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC6FC13989
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 13:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbfEDLrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 07:47:11 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:40676 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbfEDLrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 07:47:09 -0400
Received: by mail-qk1-f195.google.com with SMTP id w20so5204341qka.7
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 04:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IiULQ2GcMoMqnoewPPpD4vNptOziSzbX/olbMWY+w4c=;
        b=uQ/DVUNJqsmN5ZWHsgBieKhrKeHzW9vKCAACoiVkx60r+lSZeKdLRfZeQrNnEPodIc
         wCrXgbnO4wmHPip2z6HSrDF+OK6j4m52+g8T/3PGbtT+SR0SpM+tTSPBSKg7NBrjLxD8
         1IbP3Z2nDDZz3KARwQtbwIe2P6/gARoTR3ku/CGQ0Zx3CtCUhFzisMW9Pze2b/rWTCdz
         LvR8euaHakZ0v+xrGXZvzvw5SpmKx4YJDfn4zPetD/P32PER26CBmRcPUn3UxlzbQhcG
         fH3LnLsEt+sHoldxbytaGOFhV/SEvnm7343v1WPqgN/MknnsUxQ1WUL1RLlUYyEHJ7Ju
         aSCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IiULQ2GcMoMqnoewPPpD4vNptOziSzbX/olbMWY+w4c=;
        b=ds0rzdDHk7Hh04nfVeDcRuT26u6P9x197jA63MUCJARdGa99KqaL2WYJnq6HD8XWyR
         qtM2RnXUeRNBTUo3yxgupGY2VNYh/oZWpTUhw+szofsJov/rYMz8QXWZ1c3Yy4Jaq6t6
         VbKFU+lNPW6f6gsKo9Mx1mTCa4kJQe0i5dJnZFM18Ie6j0lU0BKrlCoRg69tEEZpmTze
         y6KzdBvVm3Yc0micxL6U/puQ56L+a24OBwj7N3pNFmyaiGYDK0/gXt950M4k5yiNWE2C
         FpPOJRI2tp2ftv0OJjEUfPLODGfCgrAVR+Iz0UgWIlB8G8loWJIc1jNrFrbpsvszvAeR
         7zDA==
X-Gm-Message-State: APjAAAWd8slHjmenbVDBfh8aVNg3CbdCylq+zoFcNOCQ+k94xm4H3aln
        zlwymCQT7CZRBmwAY098lf5W0qdZDyDmVQ==
X-Google-Smtp-Source: APXvYqyE/1CAP7SsknR8lpesGRJzcRRnRkyveoXa+dz7WgkYFmKiAEj99lqyT/zMiSybimeCQ5iJGw==
X-Received: by 2002:a37:5a05:: with SMTP id o5mr11663257qkb.94.1556970428223;
        Sat, 04 May 2019 04:47:08 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g19sm2847276qkk.17.2019.05.04.04.47.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 04:47:07 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        gerlitz.or@gmail.com, simon.horman@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 04/13] net/dsa: use intermediate representation for matchall offload
Date:   Sat,  4 May 2019 04:46:19 -0700
Message-Id: <20190504114628.14755-5-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504114628.14755-1-jakub.kicinski@netronome.com>
References: <20190504114628.14755-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>

Updates dsa hardware switch handling infrastructure to use the newer
intermediate representation for flow actions in matchall offloads.

Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 net/dsa/slave.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 8ad9bf957da1..6ce2fdb64db0 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -778,27 +778,25 @@ static int dsa_slave_add_cls_matchall(struct net_device *dev,
 	struct dsa_mall_tc_entry *mall_tc_entry;
 	__be16 protocol = cls->common.protocol;
 	struct dsa_switch *ds = dp->ds;
-	struct net_device *to_dev;
-	const struct tc_action *a;
+	struct flow_action_entry *act;
 	struct dsa_port *to_dp;
 	int err = -EOPNOTSUPP;
 
 	if (!ds->ops->port_mirror_add)
 		return err;
 
-	if (!tcf_exts_has_one_action(cls->exts))
+	if (!flow_offload_has_one_action(&cls->rule->action))
 		return err;
 
-	a = tcf_exts_first_action(cls->exts);
+	act = &cls->rule->action.entries[0];
 
-	if (is_tcf_mirred_egress_mirror(a) && protocol == htons(ETH_P_ALL)) {
+	if (act->id == FLOW_ACTION_MIRRED && protocol == htons(ETH_P_ALL)) {
 		struct dsa_mall_mirror_tc_entry *mirror;
 
-		to_dev = tcf_mirred_dev(a);
-		if (!to_dev)
+		if (!act->dev)
 			return -EINVAL;
 
-		if (!dsa_slave_dev_check(to_dev))
+		if (!dsa_slave_dev_check(act->dev))
 			return -EOPNOTSUPP;
 
 		mall_tc_entry = kzalloc(sizeof(*mall_tc_entry), GFP_KERNEL);
@@ -809,7 +807,7 @@ static int dsa_slave_add_cls_matchall(struct net_device *dev,
 		mall_tc_entry->type = DSA_PORT_MALL_MIRROR;
 		mirror = &mall_tc_entry->mirror;
 
-		to_dp = dsa_slave_to_port(to_dev);
+		to_dp = dsa_slave_to_port(act->dev);
 
 		mirror->to_local_port = to_dp->index;
 		mirror->ingress = ingress;
-- 
2.21.0

