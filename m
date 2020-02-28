Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0B5173E6F
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 18:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgB1RZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 12:25:25 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33224 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgB1RZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 12:25:20 -0500
Received: by mail-wr1-f67.google.com with SMTP id x7so3897859wrr.0
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 09:25:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mb5KCiafsFveyqQDX0IptVfqm0oji8kzFPhEvCexstQ=;
        b=Rm425MjZxnewJMh76Vh9atIW/VIJEXfki04PHYxAVwCApCVBwwqX3IjRAeTzqux2H4
         xK/eWNA+sxxsYs7og/yLtkRAONbZmDvrpDNp8F2tHI8mrT6sbm0RZzDW9VI3psimNNMJ
         iA+Ad+DpYAqw6Ehfwa7BiQF9FVVdIqa331UmDcVdtnsh1bIcp6AvFJB4Jzvh4KhGwvh0
         5dcPs+/2TviTEWUdpX//GRXsGU2o//PhYKUgu5RbUP5sIakberG1dRSRR6E9+ZF5l3HA
         1yGBsX681cD8E5mgqN9PHbusMZsvqtLK9SN0APbgrt1uYMTcZO4mlbltoqn2JQcni8g1
         Cw3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mb5KCiafsFveyqQDX0IptVfqm0oji8kzFPhEvCexstQ=;
        b=IcjSUwKTZp2fZNWxluJleVfphjwzd4CpE97zCNhu/aLWPJRM7+KUqKWxavSL8miPm5
         SqwnIHH6AUDe/vBvTbFWmzR8JSR2HdrZVXZhHNv2Bm9FlFZJFRm4f8bykXCDRmk1CqMs
         T8q8etQog0kzB2vVXK7SdkGHF7Xb/qjW96QhVz5SFGtG9dcSyDVxNjBm3YqhyIMPdUee
         ZOCoxbisuQEAmpFnhM8MyH3vanlURoBw4MfwCKZVgq81TSQVy8E/2IOBKYaFWX/qUfie
         FbdJUaebBrokZ8+nAASGQnolCBaOXXtE+qSOXJSqwoXkkWZoxGg6n5HDLSP5nuurzAU0
         Md8g==
X-Gm-Message-State: APjAAAXpucf1Y+rMgcPQpf1HV8KE0p2BazsGKkWmmhwoljOEzbaNCA3y
        hNUEvzhp19LVqObE440S0y2GZ2iH2p0=
X-Google-Smtp-Source: APXvYqypP3vgLoJAvJ447BNZJa4nujCwQMJ4VrdrFSXZEvy/S+anVN+eu8twXYSxLOGQuYcLay8FIg==
X-Received: by 2002:adf:de0d:: with SMTP id b13mr5738492wrm.297.1582910718355;
        Fri, 28 Feb 2020 09:25:18 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id g10sm13829098wrr.13.2020.02.28.09.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 09:25:17 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v2 09/12] flow_offload: introduce "delayed" HW stats type and allow it in mlx5
Date:   Fri, 28 Feb 2020 18:25:02 +0100
Message-Id: <20200228172505.14386-10-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200228172505.14386-1-jiri@resnulli.us>
References: <20200228172505.14386-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Introduce new type for delayed HW stats and allow the value in
mlx5 offload.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- moved to action
- fixed c&p error in patch description
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 6 ++++--
 include/net/flow_offload.h                      | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 9a8da84e88c9..81242ed4f0ca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2886,7 +2886,8 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 
 	act = flow_action_first_entry_get(flow_action);
-	if (act->hw_stats_type != FLOW_ACTION_HW_STATS_TYPE_ANY) {
+	if (act->hw_stats_type != FLOW_ACTION_HW_STATS_TYPE_ANY &&
+	    act->hw_stats_type != FLOW_ACTION_HW_STATS_TYPE_DELAYED) {
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported HW stats type");
 		return -EOPNOTSUPP;
 	}
@@ -3347,7 +3348,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 
 	act = flow_action_first_entry_get(flow_action);
-	if (act->hw_stats_type != FLOW_ACTION_HW_STATS_TYPE_ANY) {
+	if (act->hw_stats_type != FLOW_ACTION_HW_STATS_TYPE_ANY &&
+	    act->hw_stats_type != FLOW_ACTION_HW_STATS_TYPE_DELAYED) {
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported HW stats type");
 		return -EOPNOTSUPP;
 	}
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 7f0e2a20078f..79a0fda9b7bd 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -158,6 +158,7 @@ enum flow_action_mangle_base {
 enum flow_action_hw_stats_type {
 	FLOW_ACTION_HW_STATS_TYPE_ANY,
 	FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE,
+	FLOW_ACTION_HW_STATS_TYPE_DELAYED,
 };
 
 typedef void (*action_destr)(void *priv);
-- 
2.21.1

