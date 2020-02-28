Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5717173E72
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 18:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgB1RZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 12:25:27 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39391 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgB1RZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 12:25:23 -0500
Received: by mail-wr1-f68.google.com with SMTP id y17so3856648wrn.6
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 09:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q+/8XFiELLnPTzk9UD4aWUQN80ABra/fExvaMD/f8l0=;
        b=O98XmHGfXzFy0R1BFjkspGW00VYOCAsE7nNV51rd85K3tSIVJZrdGmJEIRsasd4kcG
         DV/djrZl69VVh6AmdqU5B/ED6EoX6PBWarifM6cU0PHhseN89pAsdOWoqghAH0GanOn8
         zuy+pJqefgLBaAD+2sn2QUIEYt9+XQliBLxwiRSNhwmgS1ZynTlwpvfi1QiWq143jELX
         J+H0vYVf9Yf4Md/EqCC+KudLlEl487qIe91Hz2VayzZFkUoLeQjHHXT8dapB0/H+Xg7p
         whU4incWC6V4oSTKRnFK5mF3K66LzPD+mOgMwNm8tDf1PDuK5fiE8gi2sA6+fnRtvEHo
         tdYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q+/8XFiELLnPTzk9UD4aWUQN80ABra/fExvaMD/f8l0=;
        b=d3Tv6NGKbcWyHxFZqBf3yT8fp93BUyaHCIqQaHj/H+HhPxzTk27jpPSQnvxvWaDgXz
         ou0nx0ufkysMO4dlYn4eILbI2laNGvW68jifKBOZKHV7tbNhsONT+JYKJJjK168HROIV
         txy6cwGn7zhYmMUo1b6QqfyYdCs8urejefUROJwHU9n45WGRFJq3pGreLRboXpX6BTDv
         4lDLlFGv7znxnLKPp3lB7hDSFI9BTBHG8iUCqX/zZ4zNaWPMdP5+6Eb3RHZnaCJdrpxf
         8ZN21kjNmEazhevQKGbPfc+iJDrliW6oP3aVnuzh9a/Onz5+mokWlvT6BI4zvBscRS3g
         YJqA==
X-Gm-Message-State: APjAAAXhmt7OzuYV7QDvkg0//bNuE6elAobmRb8rutnddcEW/tDeCASn
        EwGWzmEgB5TNRQOkvjVf5xq52X9bwMA=
X-Google-Smtp-Source: APXvYqxh5LXQuTCLX+G4oahyrKzC+nDJ5J/CSgig6wIYAtsofzwp1KUbWCHojlNN4UaVPHDr49szFQ==
X-Received: by 2002:a5d:5224:: with SMTP id i4mr5324469wra.285.1582910720854;
        Fri, 28 Feb 2020 09:25:20 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id o27sm13571288wro.27.2020.02.28.09.25.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 09:25:20 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v2 11/12] flow_offload: introduce "disabled" HW stats type and allow it in mlxsw
Date:   Fri, 28 Feb 2020 18:25:04 +0100
Message-Id: <20200228172505.14386-12-jiri@resnulli.us>
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

Introduce new type for disabled HW stats and allow the value in
mlxsw offload.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- moved to action
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 2 ++
 include/net/flow_offload.h                            | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index dcf04fae0c59..2f87b7c1e28e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -38,6 +38,8 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 		if (err)
 			return err;
 		break;
+	case FLOW_ACTION_HW_STATS_TYPE_DISABLED:
+		break;
 	default:
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported action HW stats type");
 		return -EOPNOTSUPP;
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 79a0fda9b7bd..a5b50d8abc0a 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -159,6 +159,7 @@ enum flow_action_hw_stats_type {
 	FLOW_ACTION_HW_STATS_TYPE_ANY,
 	FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE,
 	FLOW_ACTION_HW_STATS_TYPE_DELAYED,
+	FLOW_ACTION_HW_STATS_TYPE_DISABLED,
 };
 
 typedef void (*action_destr)(void *priv);
-- 
2.21.1

