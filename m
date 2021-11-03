Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1067444911
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 20:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhKCTlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 15:41:15 -0400
Received: from todd.t-8ch.de ([159.69.126.157]:38537 "EHLO todd.t-8ch.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230460AbhKCTlI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 15:41:08 -0400
From:   =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=weissschuh.net;
        s=mail; t=1635968309;
        bh=bXuf1Fnll4HQ6OApxVeazk1FgKp+3wfoq7NhsxXZiy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rGlqzH+SLKMzu7H/ocY4KlIzi9xr/EW2+zV2jo1HuMmI6hVkMiNmbnK/dli9tn3/7
         yDnUaYKiQvxgt/NufZd+gnBOZRqtOLHHMVo7F6a9KMuzqMS0pmuzhPW/yGiMVL1Ui/
         pENNVyqQ09IBrFLfZrMYcx3010GPJoByx5oRzXc4=
To:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Stabellini <stefano@aporeto.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] net/p9: load default transports
Date:   Wed,  3 Nov 2021 20:38:23 +0100
Message-Id: <20211103193823.111007-5-linux@weissschuh.net>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211103193823.111007-1-linux@weissschuh.net>
References: <20211103193823.111007-1-linux@weissschuh.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that all transports are split into modules it may happen that no
transports are registered when v9fs_get_default_trans() is called.
When that is the case try to load more transports from modules.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 net/9p/mod.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/9p/mod.c b/net/9p/mod.c
index 8f1d067b272e..7bb875cd279f 100644
--- a/net/9p/mod.c
+++ b/net/9p/mod.c
@@ -128,6 +128,10 @@ struct p9_trans_module *v9fs_get_trans_by_name(const char *s)
 }
 EXPORT_SYMBOL(v9fs_get_trans_by_name);
 
+static const char * const v9fs_default_transports[] = {
+	"virtio", "tcp", "fd", "unix", "xen", "rdma",
+};
+
 /**
  * v9fs_get_default_trans - get the default transport
  *
@@ -136,6 +140,7 @@ EXPORT_SYMBOL(v9fs_get_trans_by_name);
 struct p9_trans_module *v9fs_get_default_trans(void)
 {
 	struct p9_trans_module *t, *found = NULL;
+	int i;
 
 	spin_lock(&v9fs_trans_lock);
 
@@ -153,6 +158,10 @@ struct p9_trans_module *v9fs_get_default_trans(void)
 			}
 
 	spin_unlock(&v9fs_trans_lock);
+
+	for (i = 0; !found && i < ARRAY_SIZE(v9fs_default_transports); i++)
+		found = v9fs_get_trans_by_name(v9fs_default_transports[i]);
+
 	return found;
 }
 EXPORT_SYMBOL(v9fs_get_default_trans);
-- 
2.33.1

