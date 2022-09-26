Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2B765E9F59
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 12:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235115AbiIZKZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 06:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235665AbiIZKYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 06:24:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B59C4DB46;
        Mon, 26 Sep 2022 03:18:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 748D7B80936;
        Mon, 26 Sep 2022 10:17:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B943AC4314B;
        Mon, 26 Sep 2022 10:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187476;
        bh=aPkn8qEGPPOgAxRGlG5ronfsQ/tTwSJPOGcRU1zvwQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CQdPAcywrsGTfWUAMNjGjchsHWhdlBssYxMCKsHIgSMu4vb87kiAj0sdG5RMDVONz
         MD34U5NlxB+DG3lNXKnGTiJv8RFZmUsSOE1D4r0byRKKLe4jMwZjwCUj+8O1lSWfmL
         WelIuI0/m4mHYFSlvlbdAkfO9pPPlc7Kyl6r6IN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Huckleberry <nhuck@google.com>, netdev@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 08/58] mvpp2: no need to check return value of debugfs_create functions
Date:   Mon, 26 Sep 2022 12:11:27 +0200
Message-Id: <20220926100741.719639256@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100741.430882406@linuxfoundation.org>
References: <20220926100741.430882406@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit e6882aa623f6fe0d80fa82ebf3ee78c353bffbe1 ]

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nathan Huckleberry <nhuck@google.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: fe2c9c61f668 ("net: mvpp2: debugfs: fix memory leak when using debugfs_lookup()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/mvpp2/mvpp2_debugfs.c    | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
index f9744a61e5dd..87d9cbe10cec 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
@@ -484,8 +484,6 @@ static int mvpp2_dbgfs_flow_port_init(struct dentry *parent,
 	struct dentry *port_dir;
 
 	port_dir = debugfs_create_dir(port->dev->name, parent);
-	if (IS_ERR(port_dir))
-		return PTR_ERR(port_dir);
 
 	/* This will be freed by 'hash_opts' release op */
 	port_entry = kmalloc(sizeof(*port_entry), GFP_KERNEL);
@@ -515,8 +513,6 @@ static int mvpp2_dbgfs_flow_entry_init(struct dentry *parent,
 	sprintf(flow_entry_name, "%02d", flow);
 
 	flow_entry_dir = debugfs_create_dir(flow_entry_name, parent);
-	if (!flow_entry_dir)
-		return -ENOMEM;
 
 	/* This will be freed by 'type' release op */
 	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
@@ -554,8 +550,6 @@ static int mvpp2_dbgfs_flow_init(struct dentry *parent, struct mvpp2 *priv)
 	int i, ret;
 
 	flow_dir = debugfs_create_dir("flows", parent);
-	if (!flow_dir)
-		return -ENOMEM;
 
 	for (i = 0; i < MVPP2_N_FLOWS; i++) {
 		ret = mvpp2_dbgfs_flow_entry_init(flow_dir, priv, i);
@@ -579,8 +573,6 @@ static int mvpp2_dbgfs_prs_entry_init(struct dentry *parent,
 	sprintf(prs_entry_name, "%03d", tid);
 
 	prs_entry_dir = debugfs_create_dir(prs_entry_name, parent);
-	if (!prs_entry_dir)
-		return -ENOMEM;
 
 	/* The 'valid' entry's ops will free that */
 	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
@@ -618,8 +610,6 @@ static int mvpp2_dbgfs_prs_init(struct dentry *parent, struct mvpp2 *priv)
 	int i, ret;
 
 	prs_dir = debugfs_create_dir("parser", parent);
-	if (!prs_dir)
-		return -ENOMEM;
 
 	for (i = 0; i < MVPP2_PRS_TCAM_SRAM_SIZE; i++) {
 		ret = mvpp2_dbgfs_prs_entry_init(prs_dir, priv, i);
@@ -636,8 +626,6 @@ static int mvpp2_dbgfs_port_init(struct dentry *parent,
 	struct dentry *port_dir;
 
 	port_dir = debugfs_create_dir(port->dev->name, parent);
-	if (IS_ERR(port_dir))
-		return PTR_ERR(port_dir);
 
 	debugfs_create_file("parser_entries", 0444, port_dir, port,
 			    &mvpp2_dbgfs_port_parser_fops);
@@ -671,15 +659,10 @@ void mvpp2_dbgfs_init(struct mvpp2 *priv, const char *name)
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
 
-- 
2.35.1



