Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3AD9167A01
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 10:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbgBUJ4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 04:56:55 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44401 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728429AbgBUJ4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 04:56:54 -0500
Received: by mail-wr1-f66.google.com with SMTP id m16so1245856wrx.11
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 01:56:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+lwTtgXb9srnnNzcDA0PEVOTtVzJMfEAHR0zweTM3NQ=;
        b=sTIPJTqK6JNZhe0R31vc7oi8kV4wN/x6/6ymhLEeANP1DlLirPyAaz10d/fG4Hv5s5
         GUbW/YtZan0ikFNXc3jAzUaQ+E8dP8dfQ6mVpakzOGxmFk+U/Rk56LUZE1tbfy1DL4Sh
         I8WHf09aAo/mUMNkszzV9NuPapnxDjWbSImp8ZLOnOJUYu3n4S7Z0cTQL9Bk1hvZ2uXE
         mgP9N7/A6xOjk8YpOg1PW/Gd2ZqjAsPMms7SJin16eQD7s3fCPxHaMn23wVy5ZFdwcG/
         ndANgfBFS/6sPhlw78l1MAzU8tuc3rKwuYUkL5vp/WdVVfyvGw2V2ydWDc0PPkdEcEwt
         tQBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+lwTtgXb9srnnNzcDA0PEVOTtVzJMfEAHR0zweTM3NQ=;
        b=sTlMRCs3MsTeqazA5yiFguokNwwZOXHmVwMBAQrX7H9nv+j0LN9E1vEYFmHJuGjx6V
         kh2mS0gR0iNR7rpylYVFUSUyUJ1reFJn4NubZ0iuASWYvUSLtVObAvEbErMPSykWVoOs
         aWVzz+kxtorXSoSfv8GENxoTWttHb2oB6Q8/SoyvcrZl++G1PZlMhrHfEs0E8tzwIJ2H
         6TOOoffrNkadK6bB1T2l27ezhpj/kaLZqApcIGK2VzihD/VOnuyyuwdjSwxZEiK4JD0e
         JgUmX/cSUkB7TmL2WIgkoIoWu/38i8hwSnf75DMEWW9PSq1mvmtpIkVTl4+JSvWv8fG5
         /gpQ==
X-Gm-Message-State: APjAAAUnLerdB9ygxdR7BQW8CNBrWrpx5+alYWtnOjIfS4cFAmxpz+mZ
        pWfuBgnoN+LZ3Jyr4tSIt0d7JpmXIYQ=
X-Google-Smtp-Source: APXvYqztOH5SInPwyuD/vf5pKD82kOO4G/b7STAq4IHykGwCJgQRj1ZujqeAdqBMV1EDdTh6NxD93g==
X-Received: by 2002:adf:ea42:: with SMTP id j2mr20091148wrn.139.1582279012412;
        Fri, 21 Feb 2020 01:56:52 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id x10sm3160387wrv.60.2020.02.21.01.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 01:56:51 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org, mlxsw@mellanox.com
Subject: [patch net-next 06/10] mlxsw: restrict supported HW stats type to "any"
Date:   Fri, 21 Feb 2020 10:56:39 +0100
Message-Id: <20200221095643.6642-7-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200221095643.6642-1-jiri@resnulli.us>
References: <20200221095643.6642-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Currently don't allow rules with any other type to be inserted.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_flower.c | 28 +++++++++++++------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index b607919c8ad0..ef0799a539d2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -14,11 +14,13 @@
 #include "spectrum.h"
 #include "core_acl_flex_keys.h"
 
-static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
-					 struct mlxsw_sp_acl_block *block,
-					 struct mlxsw_sp_acl_rule_info *rulei,
-					 struct flow_action *flow_action,
-					 struct netlink_ext_ack *extack)
+static int
+mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
+			      struct mlxsw_sp_acl_block *block,
+			      struct mlxsw_sp_acl_rule_info *rulei,
+			      struct flow_action *flow_action,
+			      enum flow_cls_hw_stats_type hw_stats_type,
+			      struct netlink_ext_ack *extack)
 {
 	const struct flow_action_entry *act;
 	int mirror_act_count = 0;
@@ -27,10 +29,17 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 	if (!flow_action_has_entries(flow_action))
 		return 0;
 
-	/* Count action is inserted first */
-	err = mlxsw_sp_acl_rulei_act_count(mlxsw_sp, rulei, extack);
-	if (err)
-		return err;
+	switch (hw_stats_type) {
+	case FLOW_CLS_HW_STATS_TYPE_ANY:
+		/* Count action is inserted first */
+		err = mlxsw_sp_acl_rulei_act_count(mlxsw_sp, rulei, extack);
+		if (err)
+			return err;
+		break;
+	default:
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported HW stats type");
+		return -EOPNOTSUPP;
+	}
 
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
@@ -449,6 +458,7 @@ static int mlxsw_sp_flower_parse(struct mlxsw_sp *mlxsw_sp,
 
 	return mlxsw_sp_flower_parse_actions(mlxsw_sp, block, rulei,
 					     &f->rule->action,
+					     f->common.hw_stats_type,
 					     f->common.extack);
 }
 
-- 
2.21.1

