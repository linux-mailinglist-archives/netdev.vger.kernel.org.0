Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D793343E43
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 11:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbhCVKpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 06:45:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230174AbhCVKpU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 06:45:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C438B61937;
        Mon, 22 Mar 2021 10:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616409919;
        bh=PSDbuiA+J5uMCeFxNECOcgTK5RynWKPdyMjFLLCjnfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rRd+pWoue2HUGEFYmUF+B3GtWuJQn66Ps+jiriHMjPCnr05onQqvhfaCGn4vWIxKU
         og5ldKlnYmjxZWzPD1/IiVFPd7FBtwCXOWgvKswbueFHmufOY+4HdU65C6bPDcNr3O
         Afy+xSSVy3PMyYWko06pmweU3MQbGIFWgIzBo8plxdlwDQHTu66I6kH5owKoGO25Oe
         2YSWMVBk1vzeHxLvFxFpMfpC+z1ACCw3y8YWSq/1XJcxVoR8A1v0JiDAo6VZn41/8P
         BGcZqQepkqZy9hWUnXrDkr6sUuzgMDzwhKHGhovQ82Y7gvgu77Q402IE3qOo+iSbmz
         GWpNZb8nuS7Ag==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Jason Yan <yanaijie@huawei.com>,
        Lubomir Rintel <lkundrak@v3.sk>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/5] libertas: avoid -Wempty-body warning
Date:   Mon, 22 Mar 2021 11:43:34 +0100
Message-Id: <20210322104343.948660-4-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210322104343.948660-1-arnd@kernel.org>
References: <20210322104343.948660-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Building without mesh supports shows a couple of warnings with
'make W=1':

drivers/net/wireless/marvell/libertas/main.c: In function 'lbs_start_card':
drivers/net/wireless/marvell/libertas/main.c:1068:37: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
 1068 |                 lbs_start_mesh(priv);

Change the macros to use the usual "do { } while (0)" instead to shut up
the warnings and make the code a litte more robust.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/marvell/libertas/mesh.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/mesh.h b/drivers/net/wireless/marvell/libertas/mesh.h
index d49717b20c09..44c4cd0230a8 100644
--- a/drivers/net/wireless/marvell/libertas/mesh.h
+++ b/drivers/net/wireless/marvell/libertas/mesh.h
@@ -60,13 +60,13 @@ void lbs_mesh_ethtool_get_strings(struct net_device *dev,
 
 #else
 
-#define lbs_init_mesh(priv)
-#define lbs_deinit_mesh(priv)
-#define lbs_start_mesh(priv)
-#define lbs_add_mesh(priv)
-#define lbs_remove_mesh(priv)
+#define lbs_init_mesh(priv)	do { } while (0)
+#define lbs_deinit_mesh(priv)	do { } while (0)
+#define lbs_start_mesh(priv)	do { } while (0)
+#define lbs_add_mesh(priv)	do { } while (0)
+#define lbs_remove_mesh(priv)	do { } while (0)
 #define lbs_mesh_set_dev(priv, dev, rxpd) (dev)
-#define lbs_mesh_set_txpd(priv, dev, txpd)
+#define lbs_mesh_set_txpd(priv, dev, txpd) do { } while (0)
 #define lbs_mesh_set_channel(priv, channel) (0)
 #define lbs_mesh_activated(priv) (false)
 
-- 
2.29.2

