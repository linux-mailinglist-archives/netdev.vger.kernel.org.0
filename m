Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A163017CDDE
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 12:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgCGLkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 06:40:47 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39690 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgCGLke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 06:40:34 -0500
Received: by mail-wm1-f68.google.com with SMTP id f7so655878wml.4
        for <netdev@vger.kernel.org>; Sat, 07 Mar 2020 03:40:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZV1OAjtFuFntGAAt75OOGrGInSNGoLqWj92PEA7sZXE=;
        b=d5N2ZSOnrP0LnZVuTGwASi0mIFi5CxAr2oBobRn0srV9ET4zbSPi2K9H0Qc2sZMily
         dkBiU32uHCIvGGrTuIMSr678Q0V4H1HWF0sToz1OiplHDe2iu/+s+VpHo+QTJNrFVrWm
         3olY1XTKwehGu0K8na0+fckWTLe1/l9WLMsvxwv54kmgCXQnyoV5nWNHfygnab2QsRCp
         /bLr+E74yTOW7S0xfKmsLIVl5cpD4guy/6LZ9h7+iJibxAZx5rLdhltMpU2f4fJYxJr2
         /Tz+pnsaXbAbVsLNuhirI+QgZYDccx9ojewL/GG5uD/mmXJYbhODp9hPZSx1UCqO9M65
         oLqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZV1OAjtFuFntGAAt75OOGrGInSNGoLqWj92PEA7sZXE=;
        b=NUfC8TW3dISy6IwfSwZDcIhqKS4vD6P+IkRItHCFepmbAhSBvVM5lFFabvV51XT1TD
         L6KQUZyZXlyhgKwBJY6Z+nvH9XNFZCKGjGZA/y2CD65w91DRiVMLgNP0L0WLrxGRoipl
         MlByuSlyNvVtJTQCYKYnW9mCYI6ogVZYkWjwUo2tUh9FIpkkpcnEYMpnwPPsiDnsxSL5
         9aFekkJiOeVSsRY7vB4ggglxyAYHDLfPu/ozkWIk6YmfLVOKeh+WMmrfMHQer6Rm2600
         d1w1Ul5UOcjn6HXmDLv0mLywPGYdTFZy9TkCstUKGHAw/4rizSlkU94kqsMhLjsPlOXQ
         JRvg==
X-Gm-Message-State: ANhLgQ3Lf3U+0B1YtbJPQuJHL/FDFlQhevTaK/OvxvtovHgKfG0yu5uJ
        IeLr+tfR8DqyqlvYBPa3oPwU1exS2ZA=
X-Google-Smtp-Source: ADFU+vsMihhcjHbyf79C3QEjJ3tsHSS97pf7jhi2QqbrZX/IjrT/hZC+aWScIQj/6LRC4yAmb/vPig==
X-Received: by 2002:a1c:e0d6:: with SMTP id x205mr8969620wmg.29.1583581232549;
        Sat, 07 Mar 2020 03:40:32 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id q16sm37784516wrj.73.2020.03.07.03.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2020 03:40:32 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v4 07/10] flow_offload: introduce "delayed" HW stats type and allow it in mlx5
Date:   Sat,  7 Mar 2020 12:40:17 +0100
Message-Id: <20200307114020.8664-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200307114020.8664-1-jiri@resnulli.us>
References: <20200307114020.8664-1-jiri@resnulli.us>
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
index 6580c58b368f..1b6500f0fbca 100644
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

