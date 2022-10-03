Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF1D5F3350
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 18:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiJCQTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 12:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiJCQTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 12:19:41 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A115246
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 09:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mqxcj0ie9NNAsZtNRQSptCTioTUrj3/KztIAPVBGHWg=; b=Zv/8SF/E41K4JDLn0/vbFdKMb4
        VdygryNCy6PZgMw/wX61JCSm45p5Y/kVptR+omr+M6ZPwR7uLF+pi/yv3FErPPuigiAHDaDNGhklx
        uK0DhKkEVCeGdsoSsangI0hixjU8G52D55HAcr02WRowE8Cr+Xeq5VFnXV62bbD2j8RL6N8UTXvuc
        qfvBgwzs31SOwez7hTILtJNDRNyv1y2hjU0ydU9LMCOiAGdKcn+ViMtuuWENOnUE/xJN1aqQY5qbs
        sPOXSKrIMRoZ4Pj6io53010dhFkTIKF2PXp2La8Lny5XxZWEbwZYKKh8pmoccfK0yklFz1rsKTvyu
        x2m/svrw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:42300 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ofOAC-0007Hp-JY; Mon, 03 Oct 2022 17:19:28 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1ofOAB-00CzkG-UO; Mon, 03 Oct 2022 17:19:27 +0100
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marcin Wojtas <mw@semihalf.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org
Subject: [PATCH net] net: mvpp2: fix mvpp2 debugfs leak
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ofOAB-00CzkG-UO@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 03 Oct 2022 17:19:27 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When mvpp2 is unloaded, the driver specific debugfs directory is not
removed, which technically leads to a memory leak. However, this
directory is only created when the first device is probed, so the
hardware is present. Removing the module is only something a developer
would to when e.g. testing out changes, so the module would be
reloaded. So this memory leak is minor.

The original attempt in commit fe2c9c61f668 ("net: mvpp2: debugfs: fix
memory leak when using debugfs_lookup()") that was labelled as a memory
leak fix was not, it fixed a refcount leak, but in doing so created a
problem when the module is reloaded - the directory already exists, but
mvpp2_root is NULL, so we lose all debugfs entries. This fix has been
reverted.

This is the alternative fix, where we remove the offending directory
whenever the driver is unloaded.

Fixes: 21da57a23125 ("net: mvpp2: add a debugfs interface for the Header Parser")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h         |  1 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c | 10 ++++++++--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    | 13 ++++++++++++-
 3 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index ad73a488fc5f..11e603686a27 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -1530,6 +1530,7 @@ u32 mvpp2_read(struct mvpp2 *priv, u32 offset);
 void mvpp2_dbgfs_init(struct mvpp2 *priv, const char *name);
 
 void mvpp2_dbgfs_cleanup(struct mvpp2 *priv);
+void mvpp2_dbgfs_exit(void);
 
 void mvpp23_rx_fifo_fc_en(struct mvpp2 *priv, int port, bool en);
 
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
index 4a3baa7e0142..75e83ea2a926 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
@@ -691,6 +691,13 @@ static int mvpp2_dbgfs_port_init(struct dentry *parent,
 	return 0;
 }
 
+static struct dentry *mvpp2_root;
+
+void mvpp2_dbgfs_exit(void)
+{
+	debugfs_remove(mvpp2_root);
+}
+
 void mvpp2_dbgfs_cleanup(struct mvpp2 *priv)
 {
 	debugfs_remove_recursive(priv->dbgfs_dir);
@@ -700,10 +707,9 @@ void mvpp2_dbgfs_cleanup(struct mvpp2 *priv)
 
 void mvpp2_dbgfs_init(struct mvpp2 *priv, const char *name)
 {
-	struct dentry *mvpp2_dir, *mvpp2_root;
+	struct dentry *mvpp2_dir;
 	int ret, i;
 
-	mvpp2_root = debugfs_lookup(MVPP2_DRIVER_NAME, NULL);
 	if (!mvpp2_root)
 		mvpp2_root = debugfs_create_dir(MVPP2_DRIVER_NAME, NULL);
 
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index b84128b549b4..eaa51cd7456b 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -7706,7 +7706,18 @@ static struct platform_driver mvpp2_driver = {
 	},
 };
 
-module_platform_driver(mvpp2_driver);
+static int __init mvpp2_driver_init(void)
+{
+	return platform_driver_register(&mvpp2_driver);
+}
+module_init(mvpp2_driver_init);
+
+static void __exit mvpp2_driver_exit(void)
+{
+	platform_driver_unregister(&mvpp2_driver);
+	mvpp2_dbgfs_exit();
+}
+module_exit(mvpp2_driver_exit);
 
 MODULE_DESCRIPTION("Marvell PPv2 Ethernet Driver - www.marvell.com");
 MODULE_AUTHOR("Marcin Wojtas <mw@semihalf.com>");
-- 
2.30.2

