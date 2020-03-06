Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 392DC17BE6E
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 14:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbgCFN3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 08:29:10 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56108 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727350AbgCFN3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 08:29:10 -0500
Received: by mail-wm1-f65.google.com with SMTP id 6so2410231wmi.5
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 05:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XC3MOYrsHIJz6yAyoMDyFHWk/L6tyCnnjSyXPN5344c=;
        b=tQ6LXrR41ShqB0CL9DkntwMKrlo1/4u7Dy5t3RUxxNdyurk+TfHWqgvlHlKFE7yLqD
         9MRUV0VDFuW+rcqPDDjL6sN5o6m8mgN7ZpKYAUIAliUxIUDpZDBM0UejRn8lyo/ek8S7
         chNXKNIVMNhOwaE7VwNax52tqCi9EuXsOFQNrv2lKNCx2ALxzcvO10AyLzT/+PIAVxOf
         QKoUZaCxCFMQRQ/vHpqGPJIyjK+X6KfBLf4cBdZLHs0vO/Ndne4rPnpZnf4m+gSYSueL
         EHLSTGuVR+h6bs7dn54IQ5NvOlcqM9f+tzbxdStvr4G/zeV6U/bOLBHriH8zRQsTAdwv
         gE6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XC3MOYrsHIJz6yAyoMDyFHWk/L6tyCnnjSyXPN5344c=;
        b=RM4Tw/tleFmMQnq7TpFI8h2bx2T9iKAs8ktaFoFrQPFCuB6R8js6aQMQVxbADTJjAz
         NT0kglbGKf3Lv6zL0MrFVNhVzypQx8ALy9LPRYYunZYUbbb8aiCq35WXGXz8TkE3MLfk
         49Vb34wKH9dFjJozsQ6+b7ZNuBFmYEC8placP8o12JwMHSZgPFrXodINlgtV9FS3W6Wx
         0ICi8CPcsFWNROFR2vnsTC1Q02HF1cFwpZdAmdDGiet8i/lPqIdskO/hhOHCX6nkpRNv
         3ckJ5UiGFk5sBkTH5nY8TB3QSBFvy0rdFXuVjKNS47DS2tULq7vXaEbMUgYf7ZO2z/hX
         j6wQ==
X-Gm-Message-State: ANhLgQ1HQhOd/k/iWziEswXjc8pqXGCWe3iAWl7ebukWICHQnfryTqeM
        Cp/lqXWuksBX8vDeBPATZxawN+Eevc8=
X-Google-Smtp-Source: ADFU+vtT98xrQvkA5VgfqwixEW7920+K0RUPAwS630eEgkQVKUOuULD66lFKCahzU/1ZHxgZfGUTJQ==
X-Received: by 2002:a05:600c:410a:: with SMTP id j10mr4199821wmi.59.1583501348411;
        Fri, 06 Mar 2020 05:29:08 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id y3sm14470029wmi.14.2020.03.06.05.29.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 05:29:08 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v3 08/10] mlxsw: spectrum_acl: Ask device for rule stats only if counter was created
Date:   Fri,  6 Mar 2020 14:28:54 +0100
Message-Id: <20200306132856.6041-9-jiri@resnulli.us>
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

Set a flag in case rule counter was created. Only query the device for
stats of a rule, which has the valid counter assigned.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v2->v3:
- init current values to 0 in case of disabled counters.
v1->v2:
- new patch
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  3 ++-
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    | 26 ++++++++++++-------
 2 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index ff61cad74bb0..81801c6fb941 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -641,7 +641,8 @@ struct mlxsw_sp_acl_rule_info {
 	struct mlxsw_afa_block *act_block;
 	u8 action_created:1,
 	   ingress_bind_blocker:1,
-	   egress_bind_blocker:1;
+	   egress_bind_blocker:1,
+	   counter_valid:1;
 	unsigned int counter_index;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index 36b264798f04..6f8d5005ff36 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -642,8 +642,14 @@ int mlxsw_sp_acl_rulei_act_count(struct mlxsw_sp *mlxsw_sp,
 				 struct mlxsw_sp_acl_rule_info *rulei,
 				 struct netlink_ext_ack *extack)
 {
-	return mlxsw_afa_block_append_counter(rulei->act_block,
-					      &rulei->counter_index, extack);
+	int err;
+
+	err = mlxsw_afa_block_append_counter(rulei->act_block,
+					     &rulei->counter_index, extack);
+	if (err)
+		return err;
+	rulei->counter_valid = true;
+	return 0;
 }
 
 int mlxsw_sp_acl_rulei_act_fid_set(struct mlxsw_sp *mlxsw_sp,
@@ -857,16 +863,18 @@ int mlxsw_sp_acl_rule_get_stats(struct mlxsw_sp *mlxsw_sp,
 
 {
 	struct mlxsw_sp_acl_rule_info *rulei;
-	u64 current_packets;
-	u64 current_bytes;
+	u64 current_packets = 0;
+	u64 current_bytes = 0;
 	int err;
 
 	rulei = mlxsw_sp_acl_rule_rulei(rule);
-	err = mlxsw_sp_flow_counter_get(mlxsw_sp, rulei->counter_index,
-					&current_packets, &current_bytes);
-	if (err)
-		return err;
-
+	if (rulei->counter_valid) {
+		err = mlxsw_sp_flow_counter_get(mlxsw_sp, rulei->counter_index,
+						&current_packets,
+						&current_bytes);
+		if (err)
+			return err;
+	}
 	*packets = current_packets - rule->last_packets;
 	*bytes = current_bytes - rule->last_bytes;
 	*last_use = rule->last_used;
-- 
2.21.1

