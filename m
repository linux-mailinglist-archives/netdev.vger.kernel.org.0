Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96FAC173E68
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 18:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgB1RZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 12:25:15 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50865 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbgB1RZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 12:25:14 -0500
Received: by mail-wm1-f67.google.com with SMTP id a5so4035372wmb.0
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 09:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+60plgscXLsPzD35N9d0uETeKnl0GXqDqVhrTrmun3w=;
        b=pTxqteP8sqYSf3T3wakRdRi8iEaLRB9PLJbcc3UNGoRhFw+L6nkVMe9V+vqrm7CFdE
         doeUO7xCXNZ+IWgiw1a3AcxtEJM9tCicLwDKUqC1eI4N+f/Q0aZFMDOUcMhPjZg/aC0k
         v0fz0RTFW9VZIZjQ0kEQlSHTiAyGnL09ijqkKzH7dOUMHoitqA/OGCzKDSfgI3xATNlk
         ri+FIyHNHYGgVW7qORa/lcYk9CNZiKmwqFlg7qx53YBlVfvP6/s3vhXJP6Zyb5u1ciSb
         o92z5xCzlZBBETxsXUwdMoQ1w/V1cjU9k/NwsxdiavaNbwQ3peZsz0E3Gfancc8buJ7a
         wdGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+60plgscXLsPzD35N9d0uETeKnl0GXqDqVhrTrmun3w=;
        b=AzJkt3PfWhwMz+jm0pEh7N/Zc00WxGCjZ7ixeBB9wq5f3cwsoZXACqP7Rl2kACCdhH
         yvKnZUpcHbLVRAVfiOaoc/aPnHjfPVlo7gWXdO2kYIz/zmqZK/fp7YgjLcwIdls2h5T6
         JMGKtZ2R5Df1k57KJLIEoRRy+MAiO9Fs7YJTiI020GIWilY1XFf2brIPQ/zrPBG8kyFq
         rSgEapb/YIQhbFSn9PGQXrYlSgDcXhwlS7VvYb2fsAxUY3D1t0zIovj9ikrs87qt7q7b
         0Ly/bhYuZjQVtSp9iqznTspGEZ/R0Qm6Mi4M4iLczRL50dCzm8V7KOt0sbVEwg9qYijR
         wVoA==
X-Gm-Message-State: APjAAAURg5AXHwibXPntX28XJm8Wzac0+KBWtVfDeimAXFoFWY0XNgZz
        oPNm+XPLRYvelkcFsNS+MzuN6Go1tuI=
X-Google-Smtp-Source: APXvYqwiMlYHgpdk6HriHUte0s4Um0nqV1sRqtqdZqgF3z4PxIkjoukX9nEuWFzeuPq8lO70oMcj3g==
X-Received: by 2002:a1c:5441:: with SMTP id p1mr6022621wmi.161.1582910711885;
        Fri, 28 Feb 2020 09:25:11 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id s5sm11295150wru.39.2020.02.28.09.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 09:25:11 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v2 04/12] mlx5: en_tc: Do not allow mixing HW stats types for actions
Date:   Fri, 28 Feb 2020 18:24:57 +0100
Message-Id: <20200228172505.14386-5-jiri@resnulli.us>
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

As there is one set of counters for the whole action chain, forbid to
mix the HW stats types.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- new patch
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index ae8bb77b262e..82e08b10598f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2882,6 +2882,9 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 	if (!flow_action_has_entries(flow_action))
 		return -EINVAL;
 
+	if (!flow_action_mixed_hw_stats_types_check(flow_action, extack))
+		return -EOPNOTSUPP;
+
 	attr->flow_tag = MLX5_FS_DEFAULT_FLOW_TAG;
 
 	flow_action_for_each(i, act, flow_action) {
@@ -3334,6 +3337,9 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	if (!flow_action_has_entries(flow_action))
 		return -EINVAL;
 
+	if (!flow_action_mixed_hw_stats_types_check(flow_action, extack))
+		return -EOPNOTSUPP;
+
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
 		case FLOW_ACTION_DROP:
-- 
2.21.1

