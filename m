Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B52DC17CDDB
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 12:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgCGLkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 06:40:39 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43520 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbgCGLkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 06:40:36 -0500
Received: by mail-wr1-f66.google.com with SMTP id v9so5346211wrf.10
        for <netdev@vger.kernel.org>; Sat, 07 Mar 2020 03:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hRRmxLuEk05sgVp2at+yzser7wFMFga5gusCRSow7xo=;
        b=vzcCkD9yJjkbxtuu29+WVliQFxZVKF/W3mBsd7id7nQyurtBwQyiBjd/6rM+xkt9oU
         1o0LRe1Ut5jwqJKI9GYaHYafucV2zvAV+nFA+JiL5qCHdQlQXupHiYxjaTmZjVGvnqaP
         AynMVgx0WlVyjnat8VzUxZ6WHARF2zvWtLTbzpNP4k5ZR5NFMeeloyk5RYuk/D0PUnSc
         1rso+fouMxC8qTs1DF2jcl7qOj/SLlixt2JIR0yTFiEJlDRrC9OOrijtVgF23LUROFfg
         SbDSrvesxsfUnwHxBjkwXXd/MFqS6N0EGlAR2X8LJye6JSWg4mixHYwW+BKlwtPnSHn7
         fArQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hRRmxLuEk05sgVp2at+yzser7wFMFga5gusCRSow7xo=;
        b=DGLr9lX9boIAFNnSD/SJ2KWHbCGrkY98THJFnKfKhmDVy15Wfp8tyZijn26gpNlvNi
         rxExICLBao5iK1KIqwND5HM6ofLsMWuktyqHrvoUBemSPGuQJSrNV083zLRDuzMhSTKD
         FOxP5j5FTWe1o+rvYysAWjb4cZJh4IOlD+xNKNBw0XAWxhKHZMqYhayEsRGMxQlbfO24
         P319bxwhlF6a8/i76xOxnUF0rwPsuSfgZKCzp7UjVKngz6UlylHXmWFR1GguD9YznNYm
         S/BbL66TCU5V0F/svGh/l/M3RE+rQ7DfBZp1L6XL2GwoZBvIYCWsJ50pGZ+weT08N3Iu
         jlAg==
X-Gm-Message-State: ANhLgQ08bTapUnO52XciDxjGtqobMCI+F8u1Zf2+eC4pXwMbwGjXqzW1
        YPebTBmdhSxqhMQnYkyXDG6mdOAtRbs=
X-Google-Smtp-Source: ADFU+vtFdlKTWvvZH/PHPyFaflaB40UggfuxualxIGXCyl8nT8eUXzOGzF+u9T5paja181Bvy8Lkqw==
X-Received: by 2002:a5d:5089:: with SMTP id a9mr9598318wrt.187.1583581234743;
        Sat, 07 Mar 2020 03:40:34 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id u17sm28679525wrq.74.2020.03.07.03.40.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2020 03:40:34 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v4 09/10] flow_offload: introduce "disabled" HW stats type and allow it in mlxsw
Date:   Sat,  7 Mar 2020 12:40:19 +0100
Message-Id: <20200307114020.8664-10-jiri@resnulli.us>
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

Introduce new type for disabled HW stats and allow the value in
mlxsw offload.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v2->v3:
- moved to bitfield
v1->v2:
- moved to action
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 2 +-
 include/net/flow_offload.h                            | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 4bf3ac1cb20d..88aa554415df 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -36,7 +36,7 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 		err = mlxsw_sp_acl_rulei_act_count(mlxsw_sp, rulei, extack);
 		if (err)
 			return err;
-	} else {
+	} else if (act->hw_stats_type != FLOW_ACTION_HW_STATS_TYPE_DISABLED) {
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported action HW stats type");
 		return -EOPNOTSUPP;
 	}
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 1b6500f0fbca..64807aa03cee 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -159,6 +159,7 @@ enum flow_action_mangle_base {
 #define FLOW_ACTION_HW_STATS_TYPE_DELAYED BIT(1)
 #define FLOW_ACTION_HW_STATS_TYPE_ANY (FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE | \
 				       FLOW_ACTION_HW_STATS_TYPE_DELAYED)
+#define FLOW_ACTION_HW_STATS_TYPE_DISABLED 0
 
 typedef void (*action_destr)(void *priv);
 
-- 
2.21.1

