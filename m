Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE79935E002
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 15:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345965AbhDMN0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 09:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345738AbhDMN00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 09:26:26 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C725CC061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 06:26:06 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id lr1-20020a17090b4b81b02900ea0a3f38c1so1327925pjb.0
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 06:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cgu8hmxXAkpNCdeO9Q62EwQ7P/NjTWNkUUJyq5bafN0=;
        b=n3F68KbhRBZP1fuv/TbJA8EywHCVUc+GprP7hEjdxc5Vd1PMFbqpSmzcqa85aEr8b1
         zBx0szrcz90jq1NZf1eUjGIg3f0juKiduCo/a6aNYO1XPsRjaBitCbDx2Q9ZrpqLhfXs
         ydL7YTV4/E4rsBorrNDFl987o/TaH3f/D2ZrBn4Egg601GyrlgSFbYFmYlvN60UQxQ98
         BUyFlgEb4oj0XP+1MJPjy+Ysq4Tb6vVaS3UgC80osVuVP8a+1usVwUoPypd/bRxmPWhJ
         KNzk3k+/byMtzHopQmy9RaGoeyipj5Rdt8V8kcdT37eRxQPr+sQw5AddHieXfHoLiofZ
         HdOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cgu8hmxXAkpNCdeO9Q62EwQ7P/NjTWNkUUJyq5bafN0=;
        b=AAwhhKvPILYl3GPUQmuFM/vW0QKNUxrBPM6LPzf0O5LssK68fr/sjd0hNH8NizFwKn
         6wXOO8rpZmQwFUrw2LCWA6gLq+suwQpbch4IBSV8E0JGlLNHpYYSa0Qe/QHyHSjoJEec
         i7SNt2ponQvQEhhNt2EAzTACeangG76mxPQ2kTeF0ZAlqSoPM2cm62cHyxy9jzZo9F4b
         jOaPQLSl33R2emolM5teTMItoTSOEv2PC9LiVlzFv2C5GkX71eD769MxdPxpCPX0QIe6
         t23G2m66bZvvru04cDssjTg5cb0rx82avva237rO8IUKcabIMqz8rIH7/muR9Fi5iBo3
         NNpg==
X-Gm-Message-State: AOAM530idDHVJNmIMGrH3S/jpzkZlMGabpP5OPcATjzoyPZTDFZ3KUrb
        WRQVpEqjC4oWSG6NelFOW24=
X-Google-Smtp-Source: ABdhPJw91tUHyxIOOL+ms25PUmCnuMTJo7bcoCrU+avgxmi8fBcg8qp4oBg1pFCPO98VG8ALcY2Fmw==
X-Received: by 2002:a17:90b:714:: with SMTP id s20mr43206pjz.62.1618320366303;
        Tue, 13 Apr 2021 06:26:06 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id z18sm12417650pfa.39.2021.04.13.06.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 06:26:05 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ruxandra.radulescu@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 4/5] dpaa2-switch: add tc matchall filter support
Date:   Tue, 13 Apr 2021 16:24:47 +0300
Message-Id: <20210413132448.4141787-5-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210413132448.4141787-1-ciorneiioana@gmail.com>
References: <20210413132448.4141787-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Add support TC_SETUP_CLSMATCHALL by using the same ACL table entries
framework as for tc flower. Adding a matchall rule is done by installing
an entry which has a mask of all zeroes, thus matching on any packet.

This can be used as a catch-all type of rule if used correctly, ie the
priority of the matchall filter should be kept as the lowest one in the
entire filter block.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../freescale/dpaa2/dpaa2-switch-flower.c     | 56 +++++++++++++++++++
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 16 ++++++
 .../ethernet/freescale/dpaa2/dpaa2-switch.h   |  7 +++
 3 files changed, 79 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
index ee987fa02f0d..b4807ddc2011 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
@@ -434,3 +434,59 @@ int dpaa2_switch_cls_flower_destroy(struct dpaa2_switch_acl_tbl *acl_tbl,
 
 	return dpaa2_switch_acl_tbl_remove_entry(acl_tbl, entry);
 }
+
+int dpaa2_switch_cls_matchall_replace(struct dpaa2_switch_acl_tbl *acl_tbl,
+				      struct tc_cls_matchall_offload *cls)
+{
+	struct netlink_ext_ack *extack = cls->common.extack;
+	struct ethsw_core *ethsw = acl_tbl->ethsw;
+	struct dpaa2_switch_acl_entry *acl_entry;
+	struct flow_action_entry *act;
+	int err;
+
+	if (!flow_offload_has_one_action(&cls->rule->action)) {
+		NL_SET_ERR_MSG(extack, "Only singular actions are supported");
+		return -EOPNOTSUPP;
+	}
+
+	if (dpaa2_switch_acl_tbl_is_full(acl_tbl)) {
+		NL_SET_ERR_MSG(extack, "Maximum filter capacity reached");
+		return -ENOMEM;
+	}
+
+	acl_entry = kzalloc(sizeof(*acl_entry), GFP_KERNEL);
+	if (!acl_entry)
+		return -ENOMEM;
+
+	act = &cls->rule->action.entries[0];
+	err = dpaa2_switch_tc_parse_action(ethsw, act,
+					   &acl_entry->cfg.result, extack);
+	if (err)
+		goto free_acl_entry;
+
+	acl_entry->prio = cls->common.prio;
+	acl_entry->cookie = cls->cookie;
+
+	err = dpaa2_switch_acl_tbl_add_entry(acl_tbl, acl_entry);
+	if (err)
+		goto free_acl_entry;
+
+	return 0;
+
+free_acl_entry:
+	kfree(acl_entry);
+
+	return err;
+}
+
+int dpaa2_switch_cls_matchall_destroy(struct dpaa2_switch_acl_tbl *acl_tbl,
+				      struct tc_cls_matchall_offload *cls)
+{
+	struct dpaa2_switch_acl_entry *entry;
+
+	entry = dpaa2_switch_acl_tbl_find_entry_by_cookie(acl_tbl, cls->cookie);
+	if (!entry)
+		return 0;
+
+	return  dpaa2_switch_acl_tbl_remove_entry(acl_tbl, entry);
+}
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 5080788c692b..adf9e5880d89 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -1140,6 +1140,20 @@ dpaa2_switch_setup_tc_cls_flower(struct dpaa2_switch_acl_tbl *acl_tbl,
 	}
 }
 
+static int
+dpaa2_switch_setup_tc_cls_matchall(struct dpaa2_switch_acl_tbl *acl_tbl,
+				   struct tc_cls_matchall_offload *f)
+{
+	switch (f->command) {
+	case TC_CLSMATCHALL_REPLACE:
+		return dpaa2_switch_cls_matchall_replace(acl_tbl, f);
+	case TC_CLSMATCHALL_DESTROY:
+		return dpaa2_switch_cls_matchall_destroy(acl_tbl, f);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static int dpaa2_switch_port_setup_tc_block_cb_ig(enum tc_setup_type type,
 						  void *type_data,
 						  void *cb_priv)
@@ -1147,6 +1161,8 @@ static int dpaa2_switch_port_setup_tc_block_cb_ig(enum tc_setup_type type,
 	switch (type) {
 	case TC_SETUP_CLSFLOWER:
 		return dpaa2_switch_setup_tc_cls_flower(cb_priv, type_data);
+	case TC_SETUP_CLSMATCHALL:
+		return dpaa2_switch_setup_tc_cls_matchall(cb_priv, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
index 629186208b58..8575eed02d15 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
@@ -18,6 +18,7 @@
 #include <net/switchdev.h>
 #include <linux/if_bridge.h>
 #include <linux/fsl/mc.h>
+#include <net/pkt_cls.h>
 #include <soc/fsl/dpaa2-io.h>
 
 #include "dpsw.h"
@@ -233,4 +234,10 @@ int dpaa2_switch_cls_flower_replace(struct dpaa2_switch_acl_tbl *acl_tbl,
 
 int dpaa2_switch_cls_flower_destroy(struct dpaa2_switch_acl_tbl *acl_tbl,
 				    struct flow_cls_offload *cls);
+
+int dpaa2_switch_cls_matchall_replace(struct dpaa2_switch_acl_tbl *acl_tbl,
+				      struct tc_cls_matchall_offload *cls);
+
+int dpaa2_switch_cls_matchall_destroy(struct dpaa2_switch_acl_tbl *acl_tbl,
+				      struct tc_cls_matchall_offload *cls);
 #endif	/* __ETHSW_H */
-- 
2.30.0

