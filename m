Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00EA93DA9E9
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 19:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232355AbhG2RSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 13:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbhG2RR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 13:17:58 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5A0C0613CF;
        Thu, 29 Jul 2021 10:17:53 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id ec13so8686112edb.0;
        Thu, 29 Jul 2021 10:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dKO55E0o1kF4F3RMyrhd+pzfE7Q/IIGF/2bJhhnokKU=;
        b=u+NcAVHIT5GUbREOE0ILfCjBFsxLHS0UEHi8qUa5L68GYwQ+8rJDdvKW16+MGvrUtt
         G54LybL7CDDQ88pqQvB2I6jPsYcugozsppeKrKSqqxANuHz3OW1BuUnvn+iWq0jo9cMJ
         7L3S/G/DR8ExeCla/njXUcu5vDST/45xSuQhx+/cfV3VlfTdHdtBruwMJIVp7aSaPrRi
         Vtdl78rYFJgzgP0xA5moEVC0Z8FZY4VqpLvMklG1OhTlmqoVfjOgpjaWqX/J/aC+vgl6
         opGD+fENo93q+c5OeTLSuUXshLO/AhPaSqxfvL2bMLrixmd0vpybNpnZj5BiRZ+98BMp
         gLzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dKO55E0o1kF4F3RMyrhd+pzfE7Q/IIGF/2bJhhnokKU=;
        b=P0LGHTTS/Jc89gHTf7k4ycunX7Z8fs6KZeY3jqLmvnIr+EoCwFeb9rR1xcwMaxr7XB
         gK3wp78WI2BZA9nbyGSsJ+etVbZRNfUHAc9gM/aFrpLEDHPdlex5cnWK1LCxWLOtU6Ua
         NEdqQ4G9MDl1saCctbnaSBs3m2mYMcqBw0gnHCXgsrKgFHebDWk1s59CsOk5/V6TivPJ
         Kf/A+aOLr7ltC4m3Pv7NpU4Si8ts68ytr4lmeNlY5vzZsLQFGdHL5V4GVRa/MC4y6X1O
         jOMDYavzh+YsGMqmUNvFdpU3KwGKw/Zb+ZEnzNrMa7lm31ncVrDrPpdEBzWfRW3Iy0kJ
         ualg==
X-Gm-Message-State: AOAM532bc8uRJuu8YR+lS0I5wvyOEElcXo2Xz2mnhSl6p/tZZ8REaN3b
        +Z+OX92VPklYsBHNw41V3k0=
X-Google-Smtp-Source: ABdhPJwV/dxKKXrPxlVApwUXRry0M8DdkgN9tnk4X3li+gVPd5VlrTXGTlH8S9ppnQPz8SHN22B5XQ==
X-Received: by 2002:aa7:d3ca:: with SMTP id o10mr4642915edr.383.1627579072073;
        Thu, 29 Jul 2021 10:17:52 -0700 (PDT)
Received: from yoga-910.localhost ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id df14sm1451612edb.90.2021.07.29.10.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 10:17:51 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     corbet@lwn.net, netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 4/9] dpaa2-switch: reorganize dpaa2_switch_cls_matchall_replace
Date:   Thu, 29 Jul 2021 20:18:56 +0300
Message-Id: <20210729171901.3211729-5-ciorneiioana@gmail.com>
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
in a separate function - dpaa2_switch_cls_matchall_replace_acl().

This is intended to help with the code readability when the mirroring
support is added.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../freescale/dpaa2/dpaa2-switch-flower.c     | 31 +++++++++++++++----
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
index 38a321be58ff..637291060fd5 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
@@ -457,7 +457,8 @@ int dpaa2_switch_cls_flower_destroy(struct dpaa2_switch_filter_block *block,
 	return dpaa2_switch_acl_tbl_remove_entry(block, entry);
 }
 
-int dpaa2_switch_cls_matchall_replace(struct dpaa2_switch_filter_block *block,
+static int
+dpaa2_switch_cls_matchall_replace_acl(struct dpaa2_switch_filter_block *block,
 				      struct tc_cls_matchall_offload *cls)
 {
 	struct netlink_ext_ack *extack = cls->common.extack;
@@ -466,11 +467,6 @@ int dpaa2_switch_cls_matchall_replace(struct dpaa2_switch_filter_block *block,
 	struct flow_action_entry *act;
 	int err;
 
-	if (!flow_offload_has_one_action(&cls->rule->action)) {
-		NL_SET_ERR_MSG(extack, "Only singular actions are supported");
-		return -EOPNOTSUPP;
-	}
-
 	if (dpaa2_switch_acl_tbl_is_full(block)) {
 		NL_SET_ERR_MSG(extack, "Maximum filter capacity reached");
 		return -ENOMEM;
@@ -501,6 +497,29 @@ int dpaa2_switch_cls_matchall_replace(struct dpaa2_switch_filter_block *block,
 	return err;
 }
 
+int dpaa2_switch_cls_matchall_replace(struct dpaa2_switch_filter_block *block,
+				      struct tc_cls_matchall_offload *cls)
+{
+	struct netlink_ext_ack *extack = cls->common.extack;
+	struct flow_action_entry *act;
+
+	if (!flow_offload_has_one_action(&cls->rule->action)) {
+		NL_SET_ERR_MSG(extack, "Only singular actions are supported");
+		return -EOPNOTSUPP;
+	}
+
+	act = &cls->rule->action.entries[0];
+	switch (act->id) {
+	case FLOW_ACTION_REDIRECT:
+	case FLOW_ACTION_TRAP:
+	case FLOW_ACTION_DROP:
+		return dpaa2_switch_cls_matchall_replace_acl(block, cls);
+	default:
+		NL_SET_ERR_MSG_MOD(extack, "Action not supported");
+		return -EOPNOTSUPP;
+	}
+}
+
 int dpaa2_switch_cls_matchall_destroy(struct dpaa2_switch_filter_block *block,
 				      struct tc_cls_matchall_offload *cls)
 {
-- 
2.31.1

