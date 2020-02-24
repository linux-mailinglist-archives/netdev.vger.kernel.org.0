Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6696169F62
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 08:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbgBXHgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 02:36:14 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45225 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbgBXHgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 02:36:11 -0500
Received: by mail-wr1-f68.google.com with SMTP id g3so9046517wrs.12
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 23:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PcuM2irR1zMdzxRW+Yq4CJObRfclIkWLrBBlEjxaO5k=;
        b=fYnsbloOBgabhWxX6Rh414PXApZdmvmo/EIDzhAMdkjxZMM12/AhPtcvcnS/qmAtga
         MPtnfqSdLH8iIEj1J6lt3403B4T86uL24tBXKk2YUElN8b3U29MA7n4zVzwQ48i3LSNR
         F+wPG6AamVjPBnOr45TcF5wKJUqnW4H4eLXjxz/M2aQ9Xam5jh5uCY0ZhYlOtxzdn50x
         8pUwzTUafdLqf7FsGIzpwwR/oz0Fd3nVBc7102SvAA25/aslM4jl6Yu53cE47Im0TAKX
         89UDMkJT19y59vz90g+kzwnzHqVN9dpKA9aO0CNluKfUUoVoanH6PuhgIGBxer7n+JzT
         sXfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PcuM2irR1zMdzxRW+Yq4CJObRfclIkWLrBBlEjxaO5k=;
        b=HvJFF9am/SFiTMRUlRVcUxC58WeKIIid8Q6j3lc+byB0d6QL0QFa3g4LthhxaXzsiB
         Gc2a0wkpkYRRQt2MMx53jVyDcpuZWTPHcWf6S7XvjsggmQjjZc5mWB1+9cT1912Rnt3m
         fmcSKmTppqiONVcqG7gUStaWIpFoO3AWw24hBgQBG+nA6gSM/2adgW4iEUtr3wNJ4LMU
         GFqa9nQR67HzLgBrirzjJfZIf5Lf++LQ8fc/sgZ0iPlzWA8tzrgPTajAyggyVXlF0e95
         mEWtbItLkNB59auug7JKic/VNtq+VbMP5xpnHsXU85xtC3Mgvgp1bUzJjVBgDo5jrClT
         DeNQ==
X-Gm-Message-State: APjAAAWmwAQeR/iyhKXJBXc8KYb5ApnMXVDobQMTARN/sWvgqYm/UX6a
        jYV5jZ9bAVlOMh1rzZFk7iT7Lcn1Jyg=
X-Google-Smtp-Source: APXvYqyRLv85CmYmgLpQboiKKZci4pF/oQI5WgxqpG8sKJraQipgbikJRaaFQ8UP1TRuyiADWc7g6Q==
X-Received: by 2002:adf:b7c2:: with SMTP id t2mr65776490wre.269.1582529769682;
        Sun, 23 Feb 2020 23:36:09 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id d22sm15943646wmd.39.2020.02.23.23.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 23:36:09 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 08/16] mlxsw: spectrum_acl: Pass the ingress indication down to flex action
Date:   Mon, 24 Feb 2020 08:35:50 +0100
Message-Id: <20200224073558.26500-9-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200224073558.26500-1-jiri@resnulli.us>
References: <20200224073558.26500-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

The ACL flex action will have to know if it is in ingress or egress,
so it can use correct trap ID. Pass the ingress indication down to it.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h              | 3 ++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c          | 5 +++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c       | 2 +-
 5 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
index b9e2193848dd..b0e587583528 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
@@ -813,7 +813,7 @@ mlxsw_afa_trap_mirror_pack(char *payload, bool mirror_enable,
 	mlxsw_afa_trap_mirror_agent_set(payload, mirror_agent);
 }
 
-int mlxsw_afa_block_append_drop(struct mlxsw_afa_block *block)
+int mlxsw_afa_block_append_drop(struct mlxsw_afa_block *block, bool ingress)
 {
 	char *act = mlxsw_afa_block_append_action(block, MLXSW_AFA_TRAP_CODE,
 						  MLXSW_AFA_TRAP_SIZE);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
index 0e3a59dda12e..28b2576ea272 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
@@ -42,7 +42,7 @@ int mlxsw_afa_block_activity_get(struct mlxsw_afa_block *block, bool *activity);
 int mlxsw_afa_block_continue(struct mlxsw_afa_block *block);
 int mlxsw_afa_block_jump(struct mlxsw_afa_block *block, u16 group_id);
 int mlxsw_afa_block_terminate(struct mlxsw_afa_block *block);
-int mlxsw_afa_block_append_drop(struct mlxsw_afa_block *block);
+int mlxsw_afa_block_append_drop(struct mlxsw_afa_block *block, bool ingress);
 int mlxsw_afa_block_append_trap(struct mlxsw_afa_block *block, u16 trap_id);
 int mlxsw_afa_block_append_trap_and_forward(struct mlxsw_afa_block *block,
 					    u16 trap_id);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 4b34276c7e0d..cb3ff8d021a4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -725,7 +725,8 @@ int mlxsw_sp_acl_rulei_act_continue(struct mlxsw_sp_acl_rule_info *rulei);
 int mlxsw_sp_acl_rulei_act_jump(struct mlxsw_sp_acl_rule_info *rulei,
 				u16 group_id);
 int mlxsw_sp_acl_rulei_act_terminate(struct mlxsw_sp_acl_rule_info *rulei);
-int mlxsw_sp_acl_rulei_act_drop(struct mlxsw_sp_acl_rule_info *rulei);
+int mlxsw_sp_acl_rulei_act_drop(struct mlxsw_sp_acl_rule_info *rulei,
+				bool ingress);
 int mlxsw_sp_acl_rulei_act_trap(struct mlxsw_sp_acl_rule_info *rulei);
 int mlxsw_sp_acl_rulei_act_mirror(struct mlxsw_sp *mlxsw_sp,
 				  struct mlxsw_sp_acl_rule_info *rulei,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index b01fdfa22ffb..abd749adb0f5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -535,9 +535,10 @@ int mlxsw_sp_acl_rulei_act_terminate(struct mlxsw_sp_acl_rule_info *rulei)
 	return mlxsw_afa_block_terminate(rulei->act_block);
 }
 
-int mlxsw_sp_acl_rulei_act_drop(struct mlxsw_sp_acl_rule_info *rulei)
+int mlxsw_sp_acl_rulei_act_drop(struct mlxsw_sp_acl_rule_info *rulei,
+				bool ingress)
 {
-	return mlxsw_afa_block_append_drop(rulei->act_block);
+	return mlxsw_afa_block_append_drop(rulei->act_block, ingress);
 }
 
 int mlxsw_sp_acl_rulei_act_trap(struct mlxsw_sp_acl_rule_info *rulei)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 2ca5314fa702..17368ef8cee0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -49,7 +49,7 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 				return -EOPNOTSUPP;
 			}
 			ingress = mlxsw_sp_acl_block_is_ingress_bound(block);
-			err = mlxsw_sp_acl_rulei_act_drop(rulei);
+			err = mlxsw_sp_acl_rulei_act_drop(rulei, ingress);
 			if (err) {
 				NL_SET_ERR_MSG_MOD(extack, "Cannot append drop action");
 				return err;
-- 
2.21.1

