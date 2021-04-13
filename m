Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1C335DFFF
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 15:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239012AbhDMN0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 09:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231673AbhDMN0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 09:26:10 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DDB8C061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 06:25:50 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id t22so11950600pgu.0
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 06:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dbyYSeZ4DCwW15hK/P0qMTsNp1GqAKx21GZyS5WmjkQ=;
        b=eaOVMMvsdI2/wqVhMskHzdbzEXIRW+KN4Nzm39pNJ5s352l8LUHi0ETuul/ghnq7Wk
         bxdhQsOVT9YqIjXFyBIwUzG9lPD5wS+/g/xBs0232Uj2TYP5IRyfnssdmySKQHOWbCW4
         L+/e2gj9Kofe81zBWROyBHzN5+m+1nZTwLo8mQundSwAxg9dKrVMZMH9Jnpqpe0IEVJ1
         sjmr+hupq08F3dlc+oDXsPzqg5pOQwx4yny8vnzPCR+X5X3JBYkQfQZrr2qDWdx/YvkA
         k2+EBo/G2+L0Q5ECywEhYFIB+7PqkEjlbQGcOxSD235G1VS9kvO836FWL1+MG7osqjZH
         53Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dbyYSeZ4DCwW15hK/P0qMTsNp1GqAKx21GZyS5WmjkQ=;
        b=UpXYMHapbT2OllWlfRHfZzS8iFafVoHHJue6b/2HUY9K0QrJr04tqOaO684Yc1BNqn
         szjzEbo7tHPNP0k9eIzBy/meFtRNLekl8ZAQGE4AKXItRqTzsZF5vIW/QUz1ruVRWOyZ
         0N+2bGMx3hEax+eLJq5Une6hJMGF1cLAKQaJg4meO8CzGUiSO0KkVyWfCGmUe2/rnm+W
         rFlgeqGSd+V6kKUfUrM+Z1jPMvSeAzLjTwXarIyjXCw95rfN+pIuH/Cf15FI/8YxodGt
         iQCBPWgq8eCt4p8JssNsM+hYqmkot4xDZ6bk2p9bgS2NxBIn2uddY+VeB3hdhA+ki5Ot
         XWgQ==
X-Gm-Message-State: AOAM530DxOWJvlsw928R+utshACiUSYo9ghzdfFe2TVWXCVRGENPdfFM
        oQzVGByq4lhXmaiuTx9R9dc=
X-Google-Smtp-Source: ABdhPJwlIZOwKOxBt/Lckj3qRG6ByToJCJmdWSNiI6j8aI/b4jDD9L1W3/xW3SYMziyZGtX0li7oOg==
X-Received: by 2002:a05:6a00:1743:b029:215:225d:9e78 with SMTP id j3-20020a056a001743b0290215225d9e78mr29104622pfc.18.1618320350069;
        Tue, 13 Apr 2021 06:25:50 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id z18sm12417650pfa.39.2021.04.13.06.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 06:25:49 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ruxandra.radulescu@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 1/5] dpaa2-switch: create a central dpaa2_switch_acl_tbl structure
Date:   Tue, 13 Apr 2021 16:24:44 +0300
Message-Id: <20210413132448.4141787-2-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210413132448.4141787-1-ciorneiioana@gmail.com>
References: <20210413132448.4141787-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Introduce a new structure - dpaa2_switch_acl_tbl - to hold all data
related to an ACL table: number of rules added, ACL table id, etc.
This will be used more in the next patches when adding support for
sharing an ACL table between ports.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 44 +++++++++++++++----
 .../ethernet/freescale/dpaa2/dpaa2-switch.h   | 10 ++++-
 2 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 80efc8116963..351ee8f7461c 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -40,6 +40,17 @@ static struct dpaa2_switch_fdb *dpaa2_switch_fdb_get_unused(struct ethsw_core *e
 	return NULL;
 }
 
+static struct dpaa2_switch_acl_tbl *
+dpaa2_switch_acl_tbl_get_unused(struct ethsw_core *ethsw)
+{
+	int i;
+
+	for (i = 0; i < ethsw->sw_attr.num_ifs; i++)
+		if (!ethsw->acls[i].in_use)
+			return &ethsw->acls[i];
+	return NULL;
+}
+
 static u16 dpaa2_switch_port_set_fdb(struct ethsw_port_priv *port_priv,
 				     struct net_device *bridge_dev)
 {
@@ -2689,7 +2700,7 @@ static int dpaa2_switch_port_trap_mac_addr(struct ethsw_port_priv *port_priv,
 	acl_h = &acl_key.match;
 	acl_m = &acl_key.mask;
 
-	if (port_priv->acl_num_rules >= DPAA2_ETHSW_PORT_MAX_ACL_ENTRIES) {
+	if (port_priv->acl_tbl->num_rules >= DPAA2_ETHSW_PORT_MAX_ACL_ENTRIES) {
 		netdev_err(netdev, "ACL full\n");
 		return -ENOMEM;
 	}
@@ -2707,7 +2718,7 @@ static int dpaa2_switch_port_trap_mac_addr(struct ethsw_port_priv *port_priv,
 	dpsw_acl_prepare_entry_cfg(&acl_key, cmd_buff);
 
 	memset(&acl_entry_cfg, 0, sizeof(acl_entry_cfg));
-	acl_entry_cfg.precedence = port_priv->acl_num_rules;
+	acl_entry_cfg.precedence = port_priv->acl_tbl->num_rules;
 	acl_entry_cfg.result.action = DPSW_ACL_ACTION_REDIRECT_TO_CTRL_IF;
 	acl_entry_cfg.key_iova = dma_map_single(dev, cmd_buff,
 						DPAA2_ETHSW_PORT_ACL_CMD_BUF_SIZE,
@@ -2719,7 +2730,7 @@ static int dpaa2_switch_port_trap_mac_addr(struct ethsw_port_priv *port_priv,
 
 	err = dpsw_acl_add_entry(port_priv->ethsw_data->mc_io, 0,
 				 port_priv->ethsw_data->dpsw_handle,
-				 port_priv->acl_tbl, &acl_entry_cfg);
+				 port_priv->acl_tbl->id, &acl_entry_cfg);
 
 	dma_unmap_single(dev, acl_entry_cfg.key_iova, sizeof(cmd_buff),
 			 DMA_TO_DEVICE);
@@ -2728,7 +2739,7 @@ static int dpaa2_switch_port_trap_mac_addr(struct ethsw_port_priv *port_priv,
 		return err;
 	}
 
-	port_priv->acl_num_rules++;
+	port_priv->acl_tbl->num_rules++;
 
 	return 0;
 }
@@ -2743,12 +2754,13 @@ static int dpaa2_switch_port_init(struct ethsw_port_priv *port_priv, u16 port)
 	};
 	struct net_device *netdev = port_priv->netdev;
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
+	struct dpaa2_switch_acl_tbl *acl_tbl;
 	struct dpsw_fdb_cfg fdb_cfg = {0};
 	struct dpsw_acl_if_cfg acl_if_cfg;
 	struct dpsw_if_attr dpsw_if_attr;
 	struct dpaa2_switch_fdb *fdb;
 	struct dpsw_acl_cfg acl_cfg;
-	u16 fdb_id;
+	u16 fdb_id, acl_tbl_id;
 	int err;
 
 	/* Get the Tx queue for this specific port */
@@ -2792,7 +2804,7 @@ static int dpaa2_switch_port_init(struct ethsw_port_priv *port_priv, u16 port)
 	/* Create an ACL table to be used by this switch port */
 	acl_cfg.max_entries = DPAA2_ETHSW_PORT_MAX_ACL_ENTRIES;
 	err = dpsw_acl_add(ethsw->mc_io, 0, ethsw->dpsw_handle,
-			   &port_priv->acl_tbl, &acl_cfg);
+			   &acl_tbl_id, &acl_cfg);
 	if (err) {
 		netdev_err(netdev, "dpsw_acl_add err %d\n", err);
 		return err;
@@ -2801,13 +2813,19 @@ static int dpaa2_switch_port_init(struct ethsw_port_priv *port_priv, u16 port)
 	acl_if_cfg.if_id[0] = port_priv->idx;
 	acl_if_cfg.num_ifs = 1;
 	err = dpsw_acl_add_if(ethsw->mc_io, 0, ethsw->dpsw_handle,
-			      port_priv->acl_tbl, &acl_if_cfg);
+			      acl_tbl_id, &acl_if_cfg);
 	if (err) {
 		netdev_err(netdev, "dpsw_acl_add_if err %d\n", err);
 		dpsw_acl_remove(ethsw->mc_io, 0, ethsw->dpsw_handle,
-				port_priv->acl_tbl);
+				acl_tbl_id);
 	}
 
+	acl_tbl = dpaa2_switch_acl_tbl_get_unused(ethsw);
+	acl_tbl->id = acl_tbl_id;
+	acl_tbl->in_use = true;
+	acl_tbl->num_rules = 0;
+	port_priv->acl_tbl = acl_tbl;
+
 	err = dpaa2_switch_port_trap_mac_addr(port_priv, stpa);
 	if (err)
 		return err;
@@ -2858,6 +2876,7 @@ static int dpaa2_switch_remove(struct fsl_mc_device *sw_dev)
 	}
 
 	kfree(ethsw->fdbs);
+	kfree(ethsw->acls);
 	kfree(ethsw->ports);
 
 	dpaa2_switch_takedown(sw_dev);
@@ -2983,6 +3002,13 @@ static int dpaa2_switch_probe(struct fsl_mc_device *sw_dev)
 		goto err_free_ports;
 	}
 
+	ethsw->acls = kcalloc(ethsw->sw_attr.num_ifs, sizeof(*ethsw->acls),
+			      GFP_KERNEL);
+	if (!ethsw->acls) {
+		err = -ENOMEM;
+		goto err_free_fdbs;
+	}
+
 	for (i = 0; i < ethsw->sw_attr.num_ifs; i++) {
 		err = dpaa2_switch_probe_port(ethsw, i);
 		if (err)
@@ -3031,6 +3057,8 @@ static int dpaa2_switch_probe(struct fsl_mc_device *sw_dev)
 err_free_netdev:
 	for (i--; i >= 0; i--)
 		free_netdev(ethsw->ports[i]->netdev);
+	kfree(ethsw->acls);
+err_free_fdbs:
 	kfree(ethsw->fdbs);
 err_free_ports:
 	kfree(ethsw->ports);
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
index 0ae1d27c811e..a2c0ff23c7e9 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
@@ -101,6 +101,12 @@ struct dpaa2_switch_fdb {
 	bool			in_use;
 };
 
+struct dpaa2_switch_acl_tbl {
+	u16			id;
+	u8			num_rules;
+	bool			in_use;
+};
+
 /* Per port private data */
 struct ethsw_port_priv {
 	struct net_device	*netdev;
@@ -118,8 +124,7 @@ struct ethsw_port_priv {
 	bool			ucast_flood;
 	bool			learn_ena;
 
-	u16			acl_tbl;
-	u8			acl_num_rules;
+	struct dpaa2_switch_acl_tbl *acl_tbl;
 };
 
 /* Switch data */
@@ -145,6 +150,7 @@ struct ethsw_core {
 	int				napi_users;
 
 	struct dpaa2_switch_fdb		*fdbs;
+	struct dpaa2_switch_acl_tbl	*acls;
 };
 
 static inline bool dpaa2_switch_supports_cpu_traffic(struct ethsw_core *ethsw)
-- 
2.30.0

