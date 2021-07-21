Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D423D0D94
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 13:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240260AbhGUKqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 06:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238540AbhGUJgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 05:36:41 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3806C0613DE
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 03:17:17 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m69Hw-0003ka-Eu
        for netdev@vger.kernel.org; Wed, 21 Jul 2021 12:17:16 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 8CCD5653A39
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 10:17:15 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 52DC6653A35;
        Wed, 21 Jul 2021 10:17:15 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id ce2f8a4b;
        Wed, 21 Jul 2021 10:17:14 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next v2] net: switchdev: switchdev_handle_fdb_del_to_device(): fix no-op function for disabled CONFIG_NET_SWITCHDEV
Date:   Wed, 21 Jul 2021 12:17:14 +0200
Message-Id: <20210721101714.78977-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In patch 8ca07176ab00 ("net: switchdev: introduce a fanout helper for
SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE") new functionality including static
inline no-op functions if CONFIG_NET_SWITCHDEV is disabled was added.

This patch fixes the following build error for disabled
CONFIG_NET_SWITCHDEV:

| In file included from include/net/dsa.h:23,
|                  from net/core/flow_dissector.c:8:
| include/net/switchdev.h:410:1: error: expected identifier or ‘(’ before ‘{’ token
|   410 | {
|       | ^
| include/net/switchdev.h:399:1: warning: ‘switchdev_handle_fdb_del_to_device’ declared ‘static’ but never defined [-Wunused-function]
|   399 | switchdev_handle_fdb_del_to_device(struct net_device *dev,
|       | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fixes: 8ca07176ab00 ("net: switchdev: introduce a fanout helper for SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE")
Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
changes since v1:
- added net-next to patch subject

 include/net/switchdev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 6f57eb2e89cc..66468ff8cc0a 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -406,7 +406,7 @@ switchdev_handle_fdb_del_to_device(struct net_device *dev,
 			      const struct switchdev_notifier_fdb_info *fdb_info),
 		int (*lag_del_cb)(struct net_device *dev,
 				  const struct net_device *orig_dev, const void *ctx,
-				  const struct switchdev_notifier_fdb_info *fdb_info));
+				  const struct switchdev_notifier_fdb_info *fdb_info))
 {
 	return 0;
 }
-- 
2.30.2


