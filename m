Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E56D717BE70
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 14:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727411AbgCFN3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 08:29:12 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40464 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbgCFN3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 08:29:11 -0500
Received: by mail-wm1-f67.google.com with SMTP id e26so2362465wme.5
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 05:29:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VU33TGmAHDRw9cxZMdyOnE87qrhlGEYqfNtmeKEMiFk=;
        b=0jkz8v3eGwX7p0hagdU9dR3P+pgWQ945Rmbiz0+XAy/Ka6GtTxJfc9gVJCku7WLzMp
         e6gQQQVgJXeKt7O6cX7t0aGDElFo2JQ3F3/9LilVHvj7AZrmp1nNnnLHnML96DBG3hZW
         jbJGB7xxfElGqudRpvZ0FRVtVzY5N+TiMjEghZyqkYzP6ise4CpuE7KHQUaWSMDyjmKu
         81J1ZJqJ8Sy9ellT6OFO6QS4dUam88D/O9OkamJ9v/Nzx6tOLW7DVDXLTIbbN5w0FmL9
         teDudj9Fw2Ckdh8xYch5xR9FpGFWB4SjuZt+lPeed41HWFH5Aio/0Yha5puSJiYxBx7I
         AaDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VU33TGmAHDRw9cxZMdyOnE87qrhlGEYqfNtmeKEMiFk=;
        b=FP1mY/Or3jZaIBY9+iDghF/zYPQ3WRTe72Np254AHJnW+0M3S3m/bcK/XJqVWax9OR
         vSbMmD0+89AdPp7qgKjLJY8BpivDm716h23Drga4DNnnBfzfV/CrqtDRjbAzh2iOd2nj
         x9M9SjrYISG0cWO90YxK5Vp3mQBZUQ1xZnTQ+XL21DlVq+e6dScWKEDWALGavFSwzEaS
         zpL/v/FkDqHTaZ7FT/DG426TiHHblSCiAqbRnQvFyOqM748sZUabG1oQ1KEFQMWnWMR6
         8KshAosfrs8MIPJlFUZgrZNyd8jI6UHOylLo4xzIhKtXxCtC3++Y5tGVOe2NWrDu4yfA
         aAJg==
X-Gm-Message-State: ANhLgQ1U14Ru6FFdDgNYVI6un2+cRy3lcw+6jCO0Qd0wh4PcjUoIRGlI
        6JpnvZKdm8K/qsO3c1K9ENWD7RjcrZQ=
X-Google-Smtp-Source: ADFU+vuoPX0NHw12OU/r3Ye/j+NB7So/OLTqFNXPO1pKpwsRzyaSBRVdTyry7oYXQSd3Q1DKM+6wlg==
X-Received: by 2002:a7b:c2a2:: with SMTP id c2mr3986760wmk.19.1583501349501;
        Fri, 06 Mar 2020 05:29:09 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id t14sm16919542wrp.63.2020.03.06.05.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 05:29:09 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v3 09/10] flow_offload: introduce "disabled" HW stats type and allow it in mlxsw
Date:   Fri,  6 Mar 2020 14:28:55 +0100
Message-Id: <20200306132856.6041-10-jiri@resnulli.us>
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
index d597d500a5df..b700c570f7f1 100644
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

