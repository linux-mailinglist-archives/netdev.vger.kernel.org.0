Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19C3687A22
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 14:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406989AbfHIMcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 08:32:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406975AbfHIMcC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 08:32:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D537F21883;
        Fri,  9 Aug 2019 12:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565353921;
        bh=B0YYq3qTN5sSv/aD79fKAGihiKaq+gdS7BCyvv9nVVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sbxn7ahIVkKipD9PS8H3ve2pHPtNfpfxnw4buJ+OUjSRK/9EH9Y7yA5EzJJ67Y3k+
         Zr5y9u9ewNUTKbCdyA9J7a1tCs2HG0b3B6TEgrDdolQ6Y417cN3rBbEEWeCAGmEY5K
         XwHva09smqntoLzjSTjOasio64jpDvB9Vq1Ob2Hk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Huckleberry <nhuck@google.com>
Subject: [PATCH v2 13/17] mvpp2: no need to check return value of debugfs_create functions
Date:   Fri,  9 Aug 2019 14:31:04 +0200
Message-Id: <20190809123108.27065-14-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809123108.27065-1-gregkh@linuxfoundation.org>
References: <20190809123108.27065-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nathan Huckleberry <nhuck@google.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../ethernet/marvell/mvpp2/mvpp2_debugfs.c    | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
index 274fb07362cb..4a3baa7e0142 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
@@ -452,8 +452,6 @@ static int mvpp2_dbgfs_flow_port_init(struct dentry *parent,
 	struct dentry *port_dir;
 
 	port_dir = debugfs_create_dir(port->dev->name, parent);
-	if (IS_ERR(port_dir))
-		return PTR_ERR(port_dir);
 
 	port_entry = &port->priv->dbgfs_entries->port_flow_entries[port->id];
 
@@ -480,8 +478,6 @@ static int mvpp2_dbgfs_flow_entry_init(struct dentry *parent,
 	sprintf(flow_entry_name, "%02d", flow);
 
 	flow_entry_dir = debugfs_create_dir(flow_entry_name, parent);
-	if (!flow_entry_dir)
-		return -ENOMEM;
 
 	entry = &priv->dbgfs_entries->flow_entries[flow];
 
@@ -514,8 +510,6 @@ static int mvpp2_dbgfs_flow_init(struct dentry *parent, struct mvpp2 *priv)
 	int i, ret;
 
 	flow_dir = debugfs_create_dir("flows", parent);
-	if (!flow_dir)
-		return -ENOMEM;
 
 	for (i = 0; i < MVPP2_N_PRS_FLOWS; i++) {
 		ret = mvpp2_dbgfs_flow_entry_init(flow_dir, priv, i);
@@ -539,8 +533,6 @@ static int mvpp2_dbgfs_prs_entry_init(struct dentry *parent,
 	sprintf(prs_entry_name, "%03d", tid);
 
 	prs_entry_dir = debugfs_create_dir(prs_entry_name, parent);
-	if (!prs_entry_dir)
-		return -ENOMEM;
 
 	entry = &priv->dbgfs_entries->prs_entries[tid];
 
@@ -578,8 +570,6 @@ static int mvpp2_dbgfs_prs_init(struct dentry *parent, struct mvpp2 *priv)
 	int i, ret;
 
 	prs_dir = debugfs_create_dir("parser", parent);
-	if (!prs_dir)
-		return -ENOMEM;
 
 	for (i = 0; i < MVPP2_PRS_TCAM_SRAM_SIZE; i++) {
 		ret = mvpp2_dbgfs_prs_entry_init(prs_dir, priv, i);
@@ -688,8 +678,6 @@ static int mvpp2_dbgfs_port_init(struct dentry *parent,
 	struct dentry *port_dir;
 
 	port_dir = debugfs_create_dir(port->dev->name, parent);
-	if (IS_ERR(port_dir))
-		return PTR_ERR(port_dir);
 
 	debugfs_create_file("parser_entries", 0444, port_dir, port,
 			    &mvpp2_dbgfs_port_parser_fops);
@@ -716,15 +704,10 @@ void mvpp2_dbgfs_init(struct mvpp2 *priv, const char *name)
 	int ret, i;
 
 	mvpp2_root = debugfs_lookup(MVPP2_DRIVER_NAME, NULL);
-	if (!mvpp2_root) {
+	if (!mvpp2_root)
 		mvpp2_root = debugfs_create_dir(MVPP2_DRIVER_NAME, NULL);
-		if (IS_ERR(mvpp2_root))
-			return;
-	}
 
 	mvpp2_dir = debugfs_create_dir(name, mvpp2_root);
-	if (IS_ERR(mvpp2_dir))
-		return;
 
 	priv->dbgfs_dir = mvpp2_dir;
 	priv->dbgfs_entries = kzalloc(sizeof(*priv->dbgfs_entries), GFP_KERNEL);
-- 
2.22.0

