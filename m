Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7FB3169F58
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 08:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbgBXHgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 02:36:12 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36772 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727282AbgBXHgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 02:36:10 -0500
Received: by mail-wm1-f65.google.com with SMTP id p17so8191656wma.1
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 23:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=517Pj07x/vIrm6slScx8S1N2iUt1bHjBYZbI61SmLZg=;
        b=L99Wdo+1d1UdyinOOvGZ4JcweKwsjXA8DfbYcRnCq3KIghirlInIDvinW9l5fU0glA
         xlwXWgd/hsjXlFxFJ4ujbj0R7TcbdXVK93HJ7GQqz31vhWkTIydYZVQhLQa26r1lhxYd
         M2pZMatehURiXxj4RBkaiyA1vP9id2a6cxcwL4f8vbs5PaxCe1Z8JZKcxpDb9iWecCPY
         gbljRdPOaEdPOZOgw43s8agaoaEKau1GiM3VR4iHWw+CAGPD1pgu+NyGqlxOxznR4cXj
         OJvdwr1Bl1ATOtKVBhPY3NF6jwuT6pQBDQtc/jXUiWnARiPhiL3SR7ymI0WmdjqGtZxH
         GTdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=517Pj07x/vIrm6slScx8S1N2iUt1bHjBYZbI61SmLZg=;
        b=gOA9xTTrgTKrqxac01lXiE9s+nBzh2rF8gTFzrU+B0VDwrfcPggTOIRiBU8zYiqase
         yZaoQRguYyb7z5tlRAfn+0XS9lAtda7OqDL5ZCE+BZ0hbuB7Qu/PiCdUJzWe4cGNL8E6
         jlGXOWKZn0CYcFfwIAjilNqUt8We9Zwb5bNeGZWS0/ygcdRLg0Vo+0giRQdInyBDYxyt
         tt31cgK5H/ropiAl9ngl1IDopPCPFdA1WOR2jiIrjcQBQ2zMWOqRQKD0dW8v/09kH0xP
         AuQs5DeUmi76Z+TTnBAQwXt/0ux7iqc2wScfSPNpq00nI4l3JInb4ulbQSuPogQyC2pM
         2lyQ==
X-Gm-Message-State: APjAAAWCJVdFZwB4cQEp0L2w6zeplD8J3TtvscJyUKknLrshagHzTsFK
        dFsbN0geOVvZhW/8tQsbnbmMOF/wX3k=
X-Google-Smtp-Source: APXvYqxXW3LYJ8gTRmXrxHtGIZ+7orfM47IuOaUed5dYs/JH+r+Tl9qke7aZaPpPgeu3h7lFX0hgaw==
X-Received: by 2002:a7b:c778:: with SMTP id x24mr21392176wmk.59.1582529767795;
        Sun, 23 Feb 2020 23:36:07 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id c13sm17420606wrn.46.2020.02.23.23.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 23:36:07 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 07/16] mlxsw: spectrum_flower: Disable mixed bound blocks to contain action drop
Date:   Mon, 24 Feb 2020 08:35:49 +0100
Message-Id: <20200224073558.26500-8-jiri@resnulli.us>
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

Action drop is going to be tracked by two separate traps, one for
ingress and one for egress. Prepare for it and disallow the possibility
to have drop action in blocks which are bound to both ingress and
egress.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  2 ++
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    |  7 +++++++
 .../ethernet/mellanox/mlxsw/spectrum_flower.c | 19 ++++++++++++++++++-
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 79dc7b5947c4..4b34276c7e0d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -645,6 +645,7 @@ struct mlxsw_sp_acl_rule_info {
 	struct mlxsw_afk_element_values values;
 	struct mlxsw_afa_block *act_block;
 	u8 action_created:1,
+	   ingress_bind_blocker:1,
 	   egress_bind_blocker:1;
 	unsigned int counter_index;
 };
@@ -664,6 +665,7 @@ struct mlxsw_sp_acl_block {
 	struct mlxsw_sp *mlxsw_sp;
 	unsigned int rule_count;
 	unsigned int disable_count;
+	unsigned int ingress_blocker_rule_count;
 	unsigned int egress_blocker_rule_count;
 	unsigned int ingress_binding_count;
 	unsigned int egress_binding_count;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index 3b455c629f6d..b01fdfa22ffb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -256,6 +256,11 @@ int mlxsw_sp_acl_block_bind(struct mlxsw_sp *mlxsw_sp,
 	if (WARN_ON(mlxsw_sp_acl_block_lookup(block, mlxsw_sp_port, ingress)))
 		return -EEXIST;
 
+	if (ingress && block->ingress_blocker_rule_count) {
+		NL_SET_ERR_MSG_MOD(extack, "Block cannot be bound to ingress because it contains unsupported rules");
+		return -EOPNOTSUPP;
+	}
+
 	if (!ingress && block->egress_blocker_rule_count) {
 		NL_SET_ERR_MSG_MOD(extack, "Block cannot be bound to egress because it contains unsupported rules");
 		return -EOPNOTSUPP;
@@ -722,6 +727,7 @@ int mlxsw_sp_acl_rule_add(struct mlxsw_sp *mlxsw_sp,
 	list_add_tail(&rule->list, &mlxsw_sp->acl->rules);
 	mutex_unlock(&mlxsw_sp->acl->rules_lock);
 	block->rule_count++;
+	block->ingress_blocker_rule_count += rule->rulei->ingress_bind_blocker;
 	block->egress_blocker_rule_count += rule->rulei->egress_bind_blocker;
 	return 0;
 
@@ -741,6 +747,7 @@ void mlxsw_sp_acl_rule_del(struct mlxsw_sp *mlxsw_sp,
 	struct mlxsw_sp_acl_block *block = ruleset->ht_key.block;
 
 	block->egress_blocker_rule_count -= rule->rulei->egress_bind_blocker;
+	block->ingress_blocker_rule_count -= rule->rulei->ingress_bind_blocker;
 	ruleset->ht_key.block->rule_count--;
 	mutex_lock(&mlxsw_sp->acl->rules_lock);
 	list_del(&rule->list);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index b607919c8ad0..2ca5314fa702 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -41,12 +41,29 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 				return err;
 			}
 			break;
-		case FLOW_ACTION_DROP:
+		case FLOW_ACTION_DROP: {
+			bool ingress;
+
+			if (mlxsw_sp_acl_block_is_mixed_bound(block)) {
+				NL_SET_ERR_MSG_MOD(extack, "Drop action is not supported when block is bound to ingress and egress");
+				return -EOPNOTSUPP;
+			}
+			ingress = mlxsw_sp_acl_block_is_ingress_bound(block);
 			err = mlxsw_sp_acl_rulei_act_drop(rulei);
 			if (err) {
 				NL_SET_ERR_MSG_MOD(extack, "Cannot append drop action");
 				return err;
 			}
+
+			/* Forbid block with this rulei to be bound
+			 * to ingress/egress in future. Ingress rule is
+			 * a blocker for egress and vice versa.
+			 */
+			if (ingress)
+				rulei->egress_bind_blocker = 1;
+			else
+				rulei->ingress_bind_blocker = 1;
+			}
 			break;
 		case FLOW_ACTION_TRAP:
 			err = mlxsw_sp_acl_rulei_act_trap(rulei);
-- 
2.21.1

