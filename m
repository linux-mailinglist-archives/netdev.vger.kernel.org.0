Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79DBE5BFD1C
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 13:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiIULow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 07:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiIULov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 07:44:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B63C33A2B;
        Wed, 21 Sep 2022 04:44:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35A0F619FA;
        Wed, 21 Sep 2022 11:44:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DADC7C433C1;
        Wed, 21 Sep 2022 11:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663760688;
        bh=/tbJTi9/02amWLtKi6PiKt6XhkOGfU3qTWHFXCHiyBE=;
        h=From:To:Cc:Subject:Date:From;
        b=vxZF89frSEksxNtFHednNbN5ogomkPxdfDsaGwKQdMa01yv2MM83LF2jCwr8FKzsr
         +j1MVhk9TD7R2B3aKA2kxv5tQCbx3Tg7pnN+QLRUbFaCEU8DQjaKag5b/HQFrdRuOG
         d61a3P8WsvxfuxNCo6F/jYjTdcgfOYqGbUQjav3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@armlinux.org.uk>,
        Marcin Wojtas <mw@semihalf.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, stable <stable@kernel.org>
Subject: [PATCH net] net: mvpp2: debugfs: fix problem with previous memory leak fix
Date:   Wed, 21 Sep 2022 13:44:44 +0200
Message-Id: <20220921114444.2247083-1-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3274; i=gregkh@linuxfoundation.org; h=from:subject; bh=/tbJTi9/02amWLtKi6PiKt6XhkOGfU3qTWHFXCHiyBE=; b=owGbwMvMwCRo6H6F97bub03G02pJDMlaP7UyNzn7x6yyfCVgu/PfxNTyG6LT9TRCsjdMe/UgR955 48WDHbEsDIJMDLJiiixftvEc3V9xSNHL0PY0zBxWJpAhDFycAjCR6lCGubLL5BR5v8ulv87dL9JT8O elgdv5BoYF51mDg+5xlOk5HfApC+t6biIz/UQjAA==
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit fe2c9c61f668 ("net: mvpp2: debugfs: fix memory leak when using
debugfs_lookup()"), if the module is unloaded, the directory will still
be present if the module is loaded again and creating the directory will
fail, causing the creation of additional child debugfs entries for the
individual devices to fail.

As this module never cleaned up the root directory it created, even when
loaded, and unloading/loading a module is not a normal operation, none
of would normally happen.

To clean all of this up, use a tiny reference counted structure to hold
the root debugfs directory for the driver, and then clean it up when the
last user of it is removed from the system.  This should resolve the
previously reported problems, and the original memory leak that
fe2c9c61f668 ("net: mvpp2: debugfs: fix memory leak when using
debugfs_lookup()") was attempting to fix.

Reported-by: Russell King <linux@armlinux.org.uk>
Cc: Marcin Wojtas <mw@semihalf.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Cc: stable <stable@kernel.org>
Fixes: fe2c9c61f668 ("net: mvpp2: debugfs: fix memory leak when using debugfs_lookup()")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Note, test-built only, I do not have access to this hardware so please
review it for any foolish mistakes I might have again made.

 .../ethernet/marvell/mvpp2/mvpp2_debugfs.c    | 32 ++++++++++++++++---
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
index 0eec05d905eb..16c303048f25 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
@@ -691,23 +691,47 @@ static int mvpp2_dbgfs_port_init(struct dentry *parent,
 	return 0;
 }
 
+static struct mvpp2_debug_dir {
+	struct dentry *dir;
+	struct kref kref;
+} *mvpp2_root;
+
+static void mvpp2_release(struct kref *kref)
+{
+	struct mvpp2_debug_dir *mvpp2_root = container_of(kref, struct mvpp2_debug_dir, kref);
+
+	debugfs_remove(mvpp2_root->dir);
+	kfree(mvpp2_root);
+}
+
 void mvpp2_dbgfs_cleanup(struct mvpp2 *priv)
 {
 	debugfs_remove_recursive(priv->dbgfs_dir);
 
 	kfree(priv->dbgfs_entries);
+
+	if (mvpp2_root)
+		kref_put(&mvpp2_root->kref, mvpp2_release);
 }
 
 void mvpp2_dbgfs_init(struct mvpp2 *priv, const char *name)
 {
-	static struct dentry *mvpp2_root;
 	struct dentry *mvpp2_dir;
 	int ret, i;
 
-	if (!mvpp2_root)
-		mvpp2_root = debugfs_create_dir(MVPP2_DRIVER_NAME, NULL);
+	if (!mvpp2_root) {
+		mvpp2_root = kzalloc(sizeof(mvpp2_root), GFP_KERNEL);
+		if (!mvpp2_root) {
+			mvpp2_root = NULL;
+			return;
+		}
+		mvpp2_root->dir = debugfs_create_dir(MVPP2_DRIVER_NAME, NULL);
+		kref_init(&mvpp2_root->kref);
+	} else {
+		kref_get(&mvpp2_root->kref);
+	}
 
-	mvpp2_dir = debugfs_create_dir(name, mvpp2_root);
+	mvpp2_dir = debugfs_create_dir(name, mvpp2_root->dir);
 
 	priv->dbgfs_dir = mvpp2_dir;
 	priv->dbgfs_entries = kzalloc(sizeof(*priv->dbgfs_entries), GFP_KERNEL);
-- 
2.37.3

