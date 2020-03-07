Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 354D917CDDC
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 12:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgCGLkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 06:40:42 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33022 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbgCGLkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 06:40:37 -0500
Received: by mail-wr1-f66.google.com with SMTP id a25so1572729wrd.0
        for <netdev@vger.kernel.org>; Sat, 07 Mar 2020 03:40:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XC3MOYrsHIJz6yAyoMDyFHWk/L6tyCnnjSyXPN5344c=;
        b=CYoKAK58podyOo0zWuAuZZabDNKiZjjT33Zqqqwf7JZmQS6r9t7IMZ+L5/b+WPVJ04
         5nB9KyuQeFlAVKZYgg+c2dE0p9plA5SmuIMKFAu7EdjjADtN543aG7UiRe+JMH+weUAh
         gX9LQYIsQ7E6T9zUfh1QhkYJYwI3Pr46fgCqFd2PhLpfjuU1imKny63veuzcYm1bamVQ
         dJQ3u+lSrP7BlIw6a5YuSR1xu1Ofal1Y2qyOcm6PeDA6bxqMInXjkKNUheDEYOaN4r2R
         0ZvMeTQy4d3zScUqiP+qmcDFGnirXeY0Q4haONFJ25prHqo2ouDj1tvxcn+QDLc/9Y1o
         TJ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XC3MOYrsHIJz6yAyoMDyFHWk/L6tyCnnjSyXPN5344c=;
        b=EhGstn4lE9R/ZOIHgYCNm0Nk0tRuiwMYhhQWonuQE0KR35JbUlI6Eb5WT54Fb5HlyH
         QI8EzI+rY4qEdXNXVok9KYUvefr43eUAO2dOQN76r2i2OoukrohOfU64gCcb3RfiGQc8
         GlhC3D3vexqxSMjIzVG3Fy7wE1xFvQgSNd6EbFI/4oFpQ6pcNQZ0gFHok6Z+TAvPbIwR
         dsxGfFScHbjOhawVdutOghCc8Yg49fp04z8AuyUIlOnNBSE0Dfd6hByf5LVbyq8pa29X
         g0Th7jlzZlq6jzx58Nn6hW0PAf1hvKSENyf2/FCDcfs3GiE4ZlHuBR1/0Hv7WAqWdXee
         PewQ==
X-Gm-Message-State: ANhLgQ3/6XlaF03DJBwMqaRJREk7bO6jRprmGHCXr5yPnhqrxvcsQU9/
        wRew3ppj+7CYfkAhQj6gWRt8vpRJme0=
X-Google-Smtp-Source: ADFU+vvnli8U8ik69j0A6riDIo7w79xL/WbZ2oUEYuFTwfNVGxxjEwEo0kIwJ9OncJeOK+kboUBTSw==
X-Received: by 2002:a05:6000:149:: with SMTP id r9mr8879049wrx.147.1583581233694;
        Sat, 07 Mar 2020 03:40:33 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id w81sm3019765wmg.19.2020.03.07.03.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2020 03:40:33 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v4 08/10] mlxsw: spectrum_acl: Ask device for rule stats only if counter was created
Date:   Sat,  7 Mar 2020 12:40:18 +0100
Message-Id: <20200307114020.8664-9-jiri@resnulli.us>
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

