Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B25135E003
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 15:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345975AbhDMN0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 09:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345966AbhDMN0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 09:26:31 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA52DC061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 06:26:11 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id o123so11425256pfb.4
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 06:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SWxGpoV3SCRWa+W6YjE4yu30JcgXPuVhZUtCPgreIz0=;
        b=gDGB2t75LFPCtJQmpjKPwDHJldS/E/k913VpTKDvpG5O0bmQTIWywK8WC2mZHj+n8u
         VZKGAsifbKVa3VE1jo6VeMNsB5+wwGuQRelnKOX8kL2qDdjuQLqaQYbDKvEZ5mk/QSrW
         vR6t52v3kLNTw8Er6sc2bRAovp5al1peTLtqIcpkIA+4HHcSkUoaK1vhiTHkPk6kWlvs
         Tv/k9QMlmwD/RfKX+VihqNZkENTU7sa8Kx4PhDyKwhyGnMV8LMiKugx8kPqKFSn0BmQB
         q8o10AMkIKme06xn6Y1ASrCeqIX7izXIrUEeim9Phjb+8x+tCaTaa8d1NHHf4a7IKChw
         w9cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SWxGpoV3SCRWa+W6YjE4yu30JcgXPuVhZUtCPgreIz0=;
        b=pksHfGNhdXLPNWIDzv6ONhZ2Ek+XyB8LWUDuG8DaDVtix/gxr8vozUbdSfxHjz4h+J
         TRWZgKyciyLPf5xF2HcxaJLJ9UntjlVnNt7Tln7X0koyUfNfEvlGuvMSF3xhCK6Z38Fu
         8zlc27263y1fNJZJXqJql8jEsJ+WTQoiWLJnSkhZsm7wIlHBDi/jFfbWSPDYi2yY5dvy
         OG+2iRGa/CafFfGIQfJKuws51pW1FTWo5cGSo8L10eD3DOn+yPjS95R8+X2hgbKEDm07
         3anVrzWyoy4M2pVfmVq2b68sQbPCuljmBSG5rQPGL5OWkezvm34ka0GhDVdwCw8vGp9E
         TtoQ==
X-Gm-Message-State: AOAM532rRG3K8BetZ8TOxrw9WdNevO4L20fL5ORE0TJ78hsPVbMv8qyL
        cF4Qz/Jlr1ETfbI5C4a895c=
X-Google-Smtp-Source: ABdhPJzzQFmAN2dBVXD0aaKKxexC0wwiaoPotMAEcbR76zZe/cn55cjDuOPhyp/x6TT8JAXviSDDgw==
X-Received: by 2002:a65:4281:: with SMTP id j1mr3408951pgp.348.1618320371293;
        Tue, 13 Apr 2021 06:26:11 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id z18sm12417650pfa.39.2021.04.13.06.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 06:26:10 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ruxandra.radulescu@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 5/5] dpaa2-switch: reuse dpaa2_switch_acl_entry_add() for STP frames trap
Date:   Tue, 13 Apr 2021 16:24:48 +0300
Message-Id: <20210413132448.4141787-6-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210413132448.4141787-1-ciorneiioana@gmail.com>
References: <20210413132448.4141787-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Since we added the dpaa2_switch_acl_entry_add() function in the previous
patches to hide all the details of actually adding the ACL entry by
issuing a firmware command, let's use it also for adding a CPU trap for
the STP frames.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../freescale/dpaa2/dpaa2-switch-flower.c     |  4 +-
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 51 +++----------------
 .../ethernet/freescale/dpaa2/dpaa2-switch.h   |  3 ++
 3 files changed, 12 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
index b4807ddc2011..f9451ec5f2cb 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
@@ -111,8 +111,8 @@ static int dpaa2_switch_flower_parse_key(struct flow_cls_offload *cls,
 	return 0;
 }
 
-static int dpaa2_switch_acl_entry_add(struct dpaa2_switch_acl_tbl *acl_tbl,
-				      struct dpaa2_switch_acl_entry *entry)
+int dpaa2_switch_acl_entry_add(struct dpaa2_switch_acl_tbl *acl_tbl,
+			       struct dpaa2_switch_acl_entry *entry)
 {
 	struct dpsw_acl_entry_cfg *acl_entry_cfg = &entry->cfg;
 	struct ethsw_core *ethsw = acl_tbl->ethsw;
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index adf9e5880d89..5250d51d783c 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -2942,54 +2942,17 @@ static int dpaa2_switch_init(struct fsl_mc_device *sw_dev)
 static int dpaa2_switch_port_trap_mac_addr(struct ethsw_port_priv *port_priv,
 					   const char *mac)
 {
-	struct net_device *netdev = port_priv->netdev;
-	struct dpsw_acl_entry_cfg acl_entry_cfg;
-	struct dpsw_acl_fields *acl_h;
-	struct dpsw_acl_fields *acl_m;
-	struct dpsw_acl_key acl_key;
-	struct device *dev;
-	u8 *cmd_buff;
-	int err;
-
-	dev = port_priv->netdev->dev.parent;
-	acl_h = &acl_key.match;
-	acl_m = &acl_key.mask;
-
-	memset(&acl_entry_cfg, 0, sizeof(acl_entry_cfg));
-	memset(&acl_key, 0, sizeof(acl_key));
+	struct dpaa2_switch_acl_entry acl_entry = {0};
 
 	/* Match on the destination MAC address */
-	ether_addr_copy(acl_h->l2_dest_mac, mac);
-	eth_broadcast_addr(acl_m->l2_dest_mac);
-
-	cmd_buff = kzalloc(DPAA2_ETHSW_PORT_ACL_CMD_BUF_SIZE, GFP_KERNEL);
-	if (!cmd_buff)
-		return -ENOMEM;
-	dpsw_acl_prepare_entry_cfg(&acl_key, cmd_buff);
+	ether_addr_copy(acl_entry.key.match.l2_dest_mac, mac);
+	eth_broadcast_addr(acl_entry.key.mask.l2_dest_mac);
 
-	memset(&acl_entry_cfg, 0, sizeof(acl_entry_cfg));
-	acl_entry_cfg.precedence = 0;
-	acl_entry_cfg.result.action = DPSW_ACL_ACTION_REDIRECT_TO_CTRL_IF;
-	acl_entry_cfg.key_iova = dma_map_single(dev, cmd_buff,
-						DPAA2_ETHSW_PORT_ACL_CMD_BUF_SIZE,
-						DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(dev, acl_entry_cfg.key_iova))) {
-		netdev_err(netdev, "DMA mapping failed\n");
-		return -EFAULT;
-	}
+	/* Trap to CPU */
+	acl_entry.cfg.precedence = 0;
+	acl_entry.cfg.result.action = DPSW_ACL_ACTION_REDIRECT_TO_CTRL_IF;
 
-	err = dpsw_acl_add_entry(port_priv->ethsw_data->mc_io, 0,
-				 port_priv->ethsw_data->dpsw_handle,
-				 port_priv->acl_tbl->id, &acl_entry_cfg);
-
-	dma_unmap_single(dev, acl_entry_cfg.key_iova, sizeof(cmd_buff),
-			 DMA_TO_DEVICE);
-	if (err) {
-		netdev_err(netdev, "dpsw_acl_add_entry() failed %d\n", err);
-		return err;
-	}
-
-	return 0;
+	return dpaa2_switch_acl_entry_add(port_priv->acl_tbl, &acl_entry);
 }
 
 static int dpaa2_switch_port_init(struct ethsw_port_priv *port_priv, u16 port)
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
index 8575eed02d15..bdef71f234cb 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
@@ -240,4 +240,7 @@ int dpaa2_switch_cls_matchall_replace(struct dpaa2_switch_acl_tbl *acl_tbl,
 
 int dpaa2_switch_cls_matchall_destroy(struct dpaa2_switch_acl_tbl *acl_tbl,
 				      struct tc_cls_matchall_offload *cls);
+
+int dpaa2_switch_acl_entry_add(struct dpaa2_switch_acl_tbl *acl_tbl,
+			       struct dpaa2_switch_acl_entry *entry);
 #endif	/* __ETHSW_H */
-- 
2.30.0

