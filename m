Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A562251FB
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 15:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbgGSNgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 09:36:48 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:40940 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726073AbgGSNgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 09:36:47 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 19 Jul 2020 16:36:40 +0300
Received: from vnc1.mtl.labs.mlnx (vnc1.mtl.labs.mlnx [10.7.2.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 06JDaeBD018651;
        Sun, 19 Jul 2020 16:36:40 +0300
Received: from vnc1.mtl.labs.mlnx (localhost [127.0.0.1])
        by vnc1.mtl.labs.mlnx (8.14.4/8.14.4) with ESMTP id 06JDaeQT013803;
        Sun, 19 Jul 2020 16:36:40 +0300
Received: (from moshe@localhost)
        by vnc1.mtl.labs.mlnx (8.14.4/8.14.4/Submit) id 06JDaeoj013802;
        Sun, 19 Jul 2020 16:36:40 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>,
        Vladyslav Tarasiuk <vladyslavt@mellanox.com>
Subject: [PATCH iproute2-next 1/3] devlink: Add a possibility to print arrays of devlink port handles
Date:   Sun, 19 Jul 2020 16:36:01 +0300
Message-Id: <1595165763-13657-2-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1595165763-13657-1-git-send-email-moshe@mellanox.com>
References: <1595165763-13657-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@mellanox.com>

Add a capability of printing port handles for arrays in non-JSON format
in devlink-health manner.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 6768149..bb4588e 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -2112,7 +2112,19 @@ static void __pr_out_port_handle_start(struct dl *dl, const char *bus_name,
 			open_json_object(buf);
 		}
 	} else {
-		pr_out("%s:", buf);
+		if (array) {
+			if (should_arr_last_port_handle_end(dl, bus_name, dev_name, port_index))
+				__pr_out_indent_dec();
+			if (should_arr_last_port_handle_start(dl, bus_name,
+							      dev_name, port_index)) {
+				pr_out("%s:", buf);
+				__pr_out_newline();
+				__pr_out_indent_inc();
+				arr_last_port_handle_set(dl, bus_name, dev_name, port_index);
+			}
+		} else {
+			pr_out("%s:", buf);
+		}
 	}
 }
 
-- 
1.7.1

