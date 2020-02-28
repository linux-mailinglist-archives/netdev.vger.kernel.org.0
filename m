Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDE97173E6E
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 18:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgB1RZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 12:25:25 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:56033 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726838AbgB1RZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 12:25:19 -0500
Received: by mail-wm1-f68.google.com with SMTP id q9so3986256wmj.5
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 09:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NeSmQKIgZp56BwxdiIkgg7968msRb96pmXslgMwwgNU=;
        b=cFZFyWa4ij52Z30NQ9+C/nowXbDIYm5wKGPsmGo0fqxMXRsVPPbbDGfGkbKT+uEVWs
         yI8kcDjcVLir6PRxN3GtHrLLv3YLX26DwVfYSxMOuUPlTO9PEpK0rlm5nZcfGa7rRmN2
         PXBCIKYB6yiLfa4mGV73o+ZT0LxXDY78WkbXNRy+gJnc4sMzCqy6Rtl23UWX2FLUnx9U
         Ry/2wcJAakTTyHklI7J0Sb2YcGTTJyuC7m5ITQxfX3V67dboGiO25876C9zzNQrisrQ1
         3I4hCTX4mtZF56LXGLdD1OzXb1nzuLfDrJ4fhWQVftgtbRoPG4sdlCuIPDASUV9D66lr
         tdHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NeSmQKIgZp56BwxdiIkgg7968msRb96pmXslgMwwgNU=;
        b=btQcTgQl6cRG6ORGaaeY/+J1eTrioc5op/GoO0nJMn8e11+6LlvPOu43qFJsln+sHa
         klhq6Xs0hqQr/iiiK65K1KgTbdvTss4Li1l3fo4hWObFprRFOoLfiozTOSd2rM1D3+Bn
         Bclozwu7+0fa11Hwjn+x01c9BSEAfsWRt7zr/oUOgB/cFJ2aTkfFliL6T9/2gq2Yeby+
         /Ss75xEbJ9ucebnpIUNaeWqeQ7ZCUi4p38dwLF9SlFfzOHqKaMvIVt3seGYC9YqePU6z
         8J1TEXgTxAbDrmoDWSctLo1jYxugwVPYOg7jovDQjFvilADqr+p3TvHRE9RsO/6Qt9sd
         JwzA==
X-Gm-Message-State: APjAAAU/9MJwStqkki5VflXgExULTkrbkqwIeRjbYyNt7FTLy4QXN2G9
        y0w0mfW2dwyXHIH7zI4I8kZ3c/pA5rc=
X-Google-Smtp-Source: APXvYqxiSU1qfvLk3l63KSwBhk0YZ2tGj0CqY8fx4nacyvvQZNZRrdaUcv4YKzI3xg/piGJfi91Rng==
X-Received: by 2002:a1c:6884:: with SMTP id d126mr5613206wmc.38.1582910716873;
        Fri, 28 Feb 2020 09:25:16 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id j12sm13519034wrt.35.2020.02.28.09.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 09:25:16 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v2 08/12] flow_offload: introduce "immediate" HW stats type and allow it in mlxsw
Date:   Fri, 28 Feb 2020 18:25:01 +0100
Message-Id: <20200228172505.14386-9-jiri@resnulli.us>
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

Introduce new type for immediate HW stats and allow the value in
mlxsw offload.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- moved to action
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 3 ++-
 include/net/flow_offload.h                            | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 40d3ed2f4961..dcf04fae0c59 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -31,7 +31,8 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 
 	act = flow_action_first_entry_get(flow_action);
 	switch (act->hw_stats_type) {
-	case FLOW_ACTION_HW_STATS_TYPE_ANY:
+	case FLOW_ACTION_HW_STATS_TYPE_ANY: /* fall-through */
+	case FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE:
 		/* Count action is inserted first */
 		err = mlxsw_sp_acl_rulei_act_count(mlxsw_sp, rulei, extack);
 		if (err)
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 69791494efc5..7f0e2a20078f 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -157,6 +157,7 @@ enum flow_action_mangle_base {
 
 enum flow_action_hw_stats_type {
 	FLOW_ACTION_HW_STATS_TYPE_ANY,
+	FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE,
 };
 
 typedef void (*action_destr)(void *priv);
-- 
2.21.1

