Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFFE117CDD9
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 12:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgCGLke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 06:40:34 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40530 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgCGLkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 06:40:33 -0500
Received: by mail-wr1-f65.google.com with SMTP id p2so4552135wrw.7
        for <netdev@vger.kernel.org>; Sat, 07 Mar 2020 03:40:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oFM6SyE2aER0WnJ4MqNWu0vHBsyzC8hOSSYUb5aNdbM=;
        b=zH0M3DJ5iD/RSYD6pQjeOlTxvHx0KqB79dS+s9wrucX/yQ6arXYrNiZ62at8Of3aGK
         1rI0hfsli/z4FGW0yqTXiqnnlcyR4Q3WlrECcyF8XnSQNLqNrLux+T6BLDfxWaTUUOrs
         TZJN/7Mro9/fXgMpHNRc4AEIVaavCuMz1c7W/Zeb+6Hv/HHCdd/O4qAY2t3BUQkVWdST
         m2GXliLEibo1PgZRJvsgB8qGF+TKHZfcsB5UAbnX2rUSrvu9EE+T/XKbVRN3taZGuShF
         c86UN+5brVbSdwr4hSDgCkU9hA/b21DGCfzqi9gw33IuFn0GuSvcb5h4qOsXtJ8D4N8X
         I8lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oFM6SyE2aER0WnJ4MqNWu0vHBsyzC8hOSSYUb5aNdbM=;
        b=PCpDl7URE9Il8jT14e54viTuzBdkgq+dBhzXuUPCwGrxKi23s90XV4ji3iW2RYww4h
         l8uh/MjJI5g57HnUswz6hoP1RJXkfmHwSxpw5h3xUG7G5he9kCcsxV37ed2rn/YPZ3gj
         8dtLRjW3dpwMTRo2MWhD/mh2THly/SkjzszwuCF8q88DjJJZ741GYxHqEnTikAoMdWVT
         de22WxMfS+0aRZnM6BExkEAxfNTIzPKpHHFj5Gapx9Rl4JFi1Auejvx/b6HJs/0+VHAq
         HpvX9d0+eIoB+CdP42pYJnOWiWSUWcbYrlt0T1Lyqq95nSRS3Hk5lbZ4LDeoSPRX2uvk
         5zOg==
X-Gm-Message-State: ANhLgQ2ZfGOsnwVrXwqUtAzBKr17uaJIWYmeo9V+jc7tG4tmKjUmU8EA
        xOPaeAOvRhfPfAQ4nhOarfPrIMl5X2Q=
X-Google-Smtp-Source: ADFU+vtfZCH6YK0yLGDaTe2uvG8e6RYnUHTpcM7YM1VIACbuoxRpC32IthGevluZAj5KV/s8i0vwWw==
X-Received: by 2002:adf:f544:: with SMTP id j4mr3038152wrp.183.1583581228923;
        Sat, 07 Mar 2020 03:40:28 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id o26sm16754024wmc.33.2020.03.07.03.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2020 03:40:28 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v4 04/10] mlxsw: spectrum_flower: Do not allow mixing HW stats types for actions
Date:   Sat,  7 Mar 2020 12:40:14 +0100
Message-Id: <20200307114020.8664-5-jiri@resnulli.us>
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

As there is one set of counters for the whole action chain, forbid to
mix the HW stats types.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- new patch
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 0011a71114e3..7435629c9e65 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -26,6 +26,8 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 
 	if (!flow_action_has_entries(flow_action))
 		return 0;
+	if (!flow_action_mixed_hw_stats_types_check(flow_action, extack))
+		return -EOPNOTSUPP;
 
 	/* Count action is inserted first */
 	err = mlxsw_sp_acl_rulei_act_count(mlxsw_sp, rulei, extack);
-- 
2.21.1

