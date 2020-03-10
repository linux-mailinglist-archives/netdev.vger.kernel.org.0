Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD7EA18025C
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 16:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgCJPtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 11:49:21 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43689 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbgCJPtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 11:49:18 -0400
Received: by mail-wr1-f66.google.com with SMTP id v9so16497229wrf.10
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 08:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fmg5i4Wrlqy+49tBQ54gjFrzLB14LILCTZv44ZYLop4=;
        b=sR/CQ+DxULm0vlhbPpe6aUWiAJ4LOLM00waE0RJeRk4O/sujSkI9rEpbgJF6Mais0I
         cWCX3x8rOB4JWiPF8IoF2Xaqn9OfXUA7V/2HV6kMQSgGFkW8klE7ZF124wCLWzIEKG8B
         5lBkCZBSOVvh3NBQzsCGaxY3t6i6GboDCMnt8AM3lOkmeZc6TtZVxKlshvEq1Jjx+qBh
         2aTABC60sgdPYV6/zJSl9efG6rImCzALchdzYcxmiaIsICqeJAv8innahSs2K5ZJxg6a
         RHY6FHHLkE8NuSw9NPothYXOpEIEsLF/9Hhjqo2bA5tO1EUzAhTf6DEWFnCWTB6beOEu
         G6EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fmg5i4Wrlqy+49tBQ54gjFrzLB14LILCTZv44ZYLop4=;
        b=ijxo4okl1nIchlQZ26fZPGCdZEXSMZWuHUstAwGzUVhc1NEp3wsd+BxjissGABsD+x
         M0evMmgOyfP9fNvI8xwoZGSDRe/mauzOVNq32Dfs174OSh608LQiUaFNGqbnOIQcTZBG
         huHDorF0UC+bHsZvJ3vhpNy5jN6KjRCIIuQi++EN/zbViC9ukrblWElLWPLM51Opd3td
         XYaCbf4JwKbEUy1NgG2ezSV0VJ8jqXO8HlTs8+TzULG7Ya2v3PFex2tuNtQLIdIxAYHV
         RH0pzocAm0gbn9f/ZE+QdzCQlAixJ1bkQKHas46IQ4XE9AqefaAzJFSVaUFG0AQQnWdN
         kfpQ==
X-Gm-Message-State: ANhLgQ0I8eKwQ7QgTiM02CT42sZLZM2TbjCtFjknQPGvA2Awey+ne0V4
        z7mLOloyZBshRH0M1wAkP2kNxuaCc/E=
X-Google-Smtp-Source: ADFU+vuJrM6sTfTFrRLcmRRMIUN2vQVPCml08KekfpkN2f9mGb0WnLRkUxqGMFbWsPaJZstSGn+Idg==
X-Received: by 2002:a5d:68ce:: with SMTP id p14mr20510985wrw.197.1583855355082;
        Tue, 10 Mar 2020 08:49:15 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id a5sm5984854wrw.62.2020.03.10.08.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 08:49:14 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        pablo@netfilter.org, ecree@solarflare.com
Subject: [patch net-next 3/3] flow_offload: restrict driver to pass one allowed bit to flow_action_hw_stats_types_check()
Date:   Tue, 10 Mar 2020 16:49:09 +0100
Message-Id: <20200310154909.3970-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200310154909.3970-1-jiri@resnulli.us>
References: <20200310154909.3970-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The intention of this helper was to allow driver to specify one type
that it supports, so not only "any" value would pass. So make the API
more strict and allow driver to pass only 1 bit that is going
to be checked.

Signed-off-by: Jiri Pirko <jiri@resnulli.us>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  4 ++--
 include/net/flow_offload.h                    | 24 +++++++++++++------
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 33d3e70418fb..f285713def77 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2879,7 +2879,7 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 		return -EINVAL;
 
 	if (!flow_action_hw_stats_types_check(flow_action, extack,
-					      FLOW_ACTION_HW_STATS_TYPE_DELAYED))
+					      FLOW_ACTION_HW_STATS_TYPE_DELAYED_BIT))
 		return -EOPNOTSUPP;
 
 	attr->flow_tag = MLX5_FS_DEFAULT_FLOW_TAG;
@@ -3374,7 +3374,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 		return -EINVAL;
 
 	if (!flow_action_hw_stats_types_check(flow_action, extack,
-					      FLOW_ACTION_HW_STATS_TYPE_DELAYED))
+					      FLOW_ACTION_HW_STATS_TYPE_DELAYED_BIT))
 		return -EOPNOTSUPP;
 
 	flow_action_for_each(i, act, flow_action) {
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 6849cb5d4883..d1b1e4aa310a 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -300,9 +300,10 @@ flow_action_first_entry_get(const struct flow_action *action)
 }
 
 static inline bool
-flow_action_hw_stats_types_check(const struct flow_action *action,
-				 struct netlink_ext_ack *extack,
-				 u8 allowed_hw_stats_type)
+__flow_action_hw_stats_types_check(const struct flow_action *action,
+				   struct netlink_ext_ack *extack,
+				   bool check_allow_bit,
+				   enum flow_action_hw_stats_type_bit allow_bit)
 {
 	const struct flow_action_entry *action_entry;
 
@@ -311,23 +312,32 @@ flow_action_hw_stats_types_check(const struct flow_action *action,
 	if (!flow_action_mixed_hw_stats_types_check(action, extack))
 		return false;
 	action_entry = flow_action_first_entry_get(action);
-	if (allowed_hw_stats_type == 0 &&
+	if (!check_allow_bit &&
 	    action_entry->hw_stats_type != FLOW_ACTION_HW_STATS_TYPE_ANY) {
 		NL_SET_ERR_MSG_MOD(extack, "Driver supports only default HW stats type \"any\"");
 		return false;
-	} else if (allowed_hw_stats_type != 0 &&
-		   !(action_entry->hw_stats_type & allowed_hw_stats_type)) {
+	} else if (check_allow_bit &&
+		   !(action_entry->hw_stats_type & BIT(allow_bit))) {
 		NL_SET_ERR_MSG_MOD(extack, "Driver does not support selected HW stats type");
 		return false;
 	}
 	return true;
 }
 
+static inline bool
+flow_action_hw_stats_types_check(const struct flow_action *action,
+				 struct netlink_ext_ack *extack,
+				 enum flow_action_hw_stats_type_bit allow_bit)
+{
+	return __flow_action_hw_stats_types_check(action, extack,
+						  true, allow_bit);
+}
+
 static inline bool
 flow_action_basic_hw_stats_types_check(const struct flow_action *action,
 				       struct netlink_ext_ack *extack)
 {
-	return flow_action_hw_stats_types_check(action, extack, 0);
+	return __flow_action_hw_stats_types_check(action, extack, false, 0);
 }
 
 struct flow_rule {
-- 
2.21.1

