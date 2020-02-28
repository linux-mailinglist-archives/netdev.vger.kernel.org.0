Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34581173E6B
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 18:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgB1RZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 12:25:23 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46877 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbgB1RZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 12:25:16 -0500
Received: by mail-wr1-f68.google.com with SMTP id j7so3779994wrp.13
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 09:25:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NG5K05N11XaPTdvejQYs+YX5yZc4z0gYOOR7cCu0MH0=;
        b=nODkpBvyBj2oSTpyUYA0nrfQTaRVFXh3oto2CGAS6bNH4tYS7r38Q1/N+ngj9lFXMc
         JwimUAumJk78gOix7KD2FJcvK11Zha79gizS5KAg0ZaaZlYp3OtyIgOg5K+kCQ6d/eGm
         UqriOrjHzO9B9vs65cjTXrE5lvm8E7hXZw1/gnlW8Bg5Suq+FZrRGxGE5fQKpykrZBiK
         +g+qWO8NtgCrHhl+NHxXbie8mqK6zVDpJYrd7jkptXLbWujSQBdJQPw9bcdjriMutN1T
         sFM05Mk9RegPJFjH3hl5gJ3XN6AG+IqTAYgFTf5Pc1BLMJJ1xUitGBIealG2RUinP0DU
         gnEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NG5K05N11XaPTdvejQYs+YX5yZc4z0gYOOR7cCu0MH0=;
        b=YBeRD7d/bfaOSfK9GMW3YJWJ6nRlVlxLeYwS4qCLN4tjtf3aVe2LN9KczwRcvyYaqB
         TnZ0cS/orArRM7x0PGA8X2+WQsniDyCD+YlZA+WXYnPTyo/seCcvY58WnoR7xniTcn2l
         5aZAHKf+vGgvwKuLk8e3EKgrF47R6m+9nQ6uKJzg/qm+G7wUA59oOrSBTRbkFRd8j6p1
         PQV2AIg1B9+M7FGICpc03OYsfpGFzY0Tjwp2p0QmNr4Q6+xM7XflaXwYAFwSV7wjVjo7
         RGZGDERZk/ac7DClTVfosCUJtcH6wTDYIjKwF5xznytfXu79AIqAF+O71a/1SygqFtgD
         sv3Q==
X-Gm-Message-State: APjAAAXOYYrMMxdWc0vXOuV/vp7sy74Jfk/zPNGzfVHX3XX4PPibM3Cr
        PQJFom//N6oSjMMO7D0VmYV638mEgZA=
X-Google-Smtp-Source: APXvYqwqDkovwezXBMPgte9B08GEkWr7ez0jwUygFBt3vRagylrutnSfWAeJWPoNoOZy+BNs+y5LVQ==
X-Received: by 2002:a5d:534f:: with SMTP id t15mr5465882wrv.190.1582910714416;
        Fri, 28 Feb 2020 09:25:14 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id h81sm2474917wme.12.2020.02.28.09.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 09:25:14 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v2 06/12] mlx5: restrict supported HW stats type to "any"
Date:   Fri, 28 Feb 2020 18:24:59 +0100
Message-Id: <20200228172505.14386-7-jiri@resnulli.us>
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

Currently don't allow action with any other type than "any"
to be inserted.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- moved the check to action
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 82e08b10598f..9a8da84e88c9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2885,6 +2885,12 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 	if (!flow_action_mixed_hw_stats_types_check(flow_action, extack))
 		return -EOPNOTSUPP;
 
+	act = flow_action_first_entry_get(flow_action);
+	if (act->hw_stats_type != FLOW_ACTION_HW_STATS_TYPE_ANY) {
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported HW stats type");
+		return -EOPNOTSUPP;
+	}
+
 	attr->flow_tag = MLX5_FS_DEFAULT_FLOW_TAG;
 
 	flow_action_for_each(i, act, flow_action) {
@@ -3340,6 +3346,12 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	if (!flow_action_mixed_hw_stats_types_check(flow_action, extack))
 		return -EOPNOTSUPP;
 
+	act = flow_action_first_entry_get(flow_action);
+	if (act->hw_stats_type != FLOW_ACTION_HW_STATS_TYPE_ANY) {
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported HW stats type");
+		return -EOPNOTSUPP;
+	}
+
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
 		case FLOW_ACTION_DROP:
-- 
2.21.1

