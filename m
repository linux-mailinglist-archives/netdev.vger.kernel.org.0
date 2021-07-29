Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 154043DA9E6
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 19:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbhG2RSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 13:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbhG2RR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 13:17:57 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A186C0613C1;
        Thu, 29 Jul 2021 10:17:52 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id x90so9179117ede.8;
        Thu, 29 Jul 2021 10:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mexWpS9membpfpEMVkvPqq34nqnW8espLqwSfZmOINs=;
        b=iowmubl9ShnBWvSMOj1arerfUDxxrEKK32g/xVkuTKYxIG2cp0iKcJMEnXmU+CWYqa
         WjkTQ2YxlfkhhZhRvBSbpqXZwL0wExn2wlmA1yQ5ZssGuiAeDW1H+TXnRU8w/LiuOfF+
         VnIWVpHSSkNLUeexLUbtI2v5nd4TBptoDQ3TOZ/B3ccjgwFiio0wm24J/sikBRSdndZo
         1LIVFkt0Qu5EZBCmuuGWAPwyYDC01xJs57cI1BwCh/R8tacOjBBBkRlfthZ2ef5PlX09
         DhBeBA+woH7LtMh2plWTtUdUQ1bYHO5yzS9vDpVs9T6pmYeKGWdLCSai2b1qchN5Q+aU
         Yssg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mexWpS9membpfpEMVkvPqq34nqnW8espLqwSfZmOINs=;
        b=QLz0IT5XAZdngqXctz6aHnN/QG/bIv5i2b1L5fWL++pjRECKaUvzZMeLOS5hI0M4T+
         owsYx1Xcg6Aml7Lq0b8QFcdjiHN+Zu31YV+USJyo+WWKAsRhjPqLdpFGcZY/Q+6e1fOs
         i3VfUOSDpSO7knGUT+dUYu4emCoMVsjHX4NzwZ1sYp9/8qn0CVg+XbEbdbWrJYqVhZHy
         eKpV+QYa3//+WZoMcHR1namfoeZEbJpjLKFKfWH9RWgeposeQqgHe8m1XJXyZTQw2Khv
         e9tFc0QpiYbswIUeriixVqd6PsBcwCKAvtbWWQOANZPMe2b7AlEKOZBbN6/YIJjwxZ8M
         sUNA==
X-Gm-Message-State: AOAM531yOyiQIv3rukuGVBwDeGOTRy+WRF3DLhMYT/ezuHJyMLcUnXwU
        RRrRYwduEy5R1R/648SRT7c=
X-Google-Smtp-Source: ABdhPJwzhlTOEjJHBniwYDmXdbXTncQ/jXHSeVWSIoIb5QGV+imS/8s5kb+9JbaV8/0FpZr+EkA1SA==
X-Received: by 2002:a05:6402:206a:: with SMTP id bd10mr7129913edb.263.1627579070932;
        Thu, 29 Jul 2021 10:17:50 -0700 (PDT)
Received: from yoga-910.localhost ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id df14sm1451612edb.90.2021.07.29.10.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 10:17:50 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     corbet@lwn.net, netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 3/9] dpaa2-switch: reorganize dpaa2_switch_cls_flower_replace
Date:   Thu, 29 Jul 2021 20:18:55 +0300
Message-Id: <20210729171901.3211729-4-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729171901.3211729-1-ciorneiioana@gmail.com>
References: <20210729171901.3211729-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Extract the necessary steps to offload a filter by using the ACL table
in a separate function - dpaa2_switch_cls_flower_replace_acl().
This is intended to help with the code readability when the mirroring
support is added.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../freescale/dpaa2/dpaa2-switch-flower.c     | 32 +++++++++++++++----
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
index 80fe09ac9d5f..38a321be58ff 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
@@ -376,7 +376,8 @@ static int dpaa2_switch_tc_parse_action_acl(struct ethsw_core *ethsw,
 	return err;
 }
 
-int dpaa2_switch_cls_flower_replace(struct dpaa2_switch_filter_block *block,
+static int
+dpaa2_switch_cls_flower_replace_acl(struct dpaa2_switch_filter_block *block,
 				    struct flow_cls_offload *cls)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
@@ -386,11 +387,6 @@ int dpaa2_switch_cls_flower_replace(struct dpaa2_switch_filter_block *block,
 	struct flow_action_entry *act;
 	int err;
 
-	if (!flow_offload_has_one_action(&rule->action)) {
-		NL_SET_ERR_MSG(extack, "Only singular actions are supported");
-		return -EOPNOTSUPP;
-	}
-
 	if (dpaa2_switch_acl_tbl_is_full(block)) {
 		NL_SET_ERR_MSG(extack, "Maximum filter capacity reached");
 		return -ENOMEM;
@@ -425,6 +421,30 @@ int dpaa2_switch_cls_flower_replace(struct dpaa2_switch_filter_block *block,
 	return err;
 }
 
+int dpaa2_switch_cls_flower_replace(struct dpaa2_switch_filter_block *block,
+				    struct flow_cls_offload *cls)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
+	struct netlink_ext_ack *extack = cls->common.extack;
+	struct flow_action_entry *act;
+
+	if (!flow_offload_has_one_action(&rule->action)) {
+		NL_SET_ERR_MSG(extack, "Only singular actions are supported");
+		return -EOPNOTSUPP;
+	}
+
+	act = &rule->action.entries[0];
+	switch (act->id) {
+	case FLOW_ACTION_REDIRECT:
+	case FLOW_ACTION_TRAP:
+	case FLOW_ACTION_DROP:
+		return dpaa2_switch_cls_flower_replace_acl(block, cls);
+	default:
+		NL_SET_ERR_MSG_MOD(extack, "Action not supported");
+		return -EOPNOTSUPP;
+	}
+}
+
 int dpaa2_switch_cls_flower_destroy(struct dpaa2_switch_filter_block *block,
 				    struct flow_cls_offload *cls)
 {
-- 
2.31.1

