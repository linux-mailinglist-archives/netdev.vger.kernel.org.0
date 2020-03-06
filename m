Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3F317BE6F
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 14:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbgCFN3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 08:29:10 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34225 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbgCFN3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 08:29:09 -0500
Received: by mail-wr1-f65.google.com with SMTP id z15so2388466wrl.1
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 05:29:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cUgCn3fHJBTTmxSr75wLtJPd79IOA5d4VE+X0iIzpC8=;
        b=D+i4HHo81aYrZIMmWPUjF3SMvxTb9UUmDCJyTiTskS1BZzU0zVftA17a2XiUORy9qe
         gaK6WK7DdKHIVz77gkZhzvPB2T8Qo0UTz2mLK/NmpGzuXaORtR+BypCs+1+ek3H7cp4d
         Q70/7QUqDHguIUDMRM4e2G0oOOCX+c8bzn1WqSdb7Vg5VLkbbd41TNkmdASSdCFDyQS4
         JfjnHlA9ebXsvirTT2JkvIc5kuZs1serdqHYfNK64BoDtIt5pZZ8es+varG/HMUvnmrU
         QyUS3N2qcEm4RU9scdoAoa+CSLTdno8g3FJa1cPuBRlG2177IcNhOawgnNO8oQAOUs8K
         gfYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cUgCn3fHJBTTmxSr75wLtJPd79IOA5d4VE+X0iIzpC8=;
        b=juT9jfQj7EzN4FCLxdtn6mJJYsFdxQgZ6RuIUrT7Jmg8uDszWEDRAxhHiRsEtzDV8X
         ehQ1KLId90qvQnklxYgpJIdcm8RxItNQIsaS4NN0GijJ44LJi3dqWWviDXzRkirwxHrQ
         3GLGgEegE8zfku35TKbl68wbjS7Ebr9+uLP1pwFIkOyah4BOtTzEt6dgg3IEQfeNuf7U
         HL2VxcGSGQm32+oWJ8qC2k18gSdP7QhInDQWmRoeMdaq9uKHCtG0XkNEOt0FT9gESsHC
         96EvnUxhXn4VOu/K8VmDxUCvKiOcvUAj4uOo6iwUUQEhcWjZlxV5U0qMtWnmMHngva7g
         jeyQ==
X-Gm-Message-State: ANhLgQ1k2oVRjy+VjxDMFxksuCesh0TVuleONmaWMxxiHM3FumxmPjkV
        ErPSdeeBFLiGldfptwI3xmN9QhrqkMk=
X-Google-Smtp-Source: ADFU+vsZnlo8jvrXaHo7cV7KdZmT97bZMkQyOlJk7d93POXb4ZEbSXNGgo+pzXcfdp7vhc5k6rRmjA==
X-Received: by 2002:adf:fa50:: with SMTP id y16mr4252087wrr.41.1583501347265;
        Fri, 06 Mar 2020 05:29:07 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id b13sm14119964wme.2.2020.03.06.05.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 05:29:06 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v3 07/10] flow_offload: introduce "delayed" HW stats type and allow it in mlx5
Date:   Fri,  6 Mar 2020 14:28:53 +0100
Message-Id: <20200306132856.6041-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200306132856.6041-1-jiri@resnulli.us>
References: <20200306132856.6041-1-jiri@resnulli.us>
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
v2->v3:
- converted to newly introduced flow_action_hw_stats_types_check()
- moved to bitfield
v1->v2:
- moved to action
- fixed c&p error in patch description
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 6 ++++--
 include/net/flow_offload.h                      | 4 +++-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index cfe393cb4026..cdc63dd59867 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2878,7 +2878,8 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 	if (!flow_action_has_entries(flow_action))
 		return -EINVAL;
 
-	if (!flow_action_basic_hw_stats_types_check(flow_action, extack))
+	if (!flow_action_hw_stats_types_check(flow_action, extack,
+					      FLOW_ACTION_HW_STATS_TYPE_DELAYED))
 		return -EOPNOTSUPP;
 
 	attr->flow_tag = MLX5_FS_DEFAULT_FLOW_TAG;
@@ -3333,7 +3334,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	if (!flow_action_has_entries(flow_action))
 		return -EINVAL;
 
-	if (!flow_action_basic_hw_stats_types_check(flow_action, extack))
+	if (!flow_action_hw_stats_types_check(flow_action, extack,
+					      FLOW_ACTION_HW_STATS_TYPE_DELAYED))
 		return -EOPNOTSUPP;
 
 	flow_action_for_each(i, act, flow_action) {
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index e60100f9fa63..d597d500a5df 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -156,7 +156,9 @@ enum flow_action_mangle_base {
 };
 
 #define FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE BIT(0)
-#define FLOW_ACTION_HW_STATS_TYPE_ANY FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE
+#define FLOW_ACTION_HW_STATS_TYPE_DELAYED BIT(1)
+#define FLOW_ACTION_HW_STATS_TYPE_ANY (FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE | \
+				       FLOW_ACTION_HW_STATS_TYPE_DELAYED)
 
 typedef void (*action_destr)(void *priv);
 
-- 
2.21.1

