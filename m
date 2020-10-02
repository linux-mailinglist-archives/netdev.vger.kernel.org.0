Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E090281701
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387999AbgJBPq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:46:28 -0400
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:50173 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387768AbgJBPq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 11:46:28 -0400
Received: from tomoyo.flets-east.jp ([153.230.197.127])
        by mwinf5d76 with ME
        id b3mJ2300C2lQRaH033mMF8; Fri, 02 Oct 2020 17:46:25 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Fri, 02 Oct 2020 17:46:25 +0200
X-ME-IP: 153.230.197.127
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        linux-usb@vger.kernel.org (open list:USB ACM DRIVER)
Subject: [PATCH v3 2/7] can: dev: fix type of get_can_dlc() and get_canfd_dlc() macros
Date:   Sat,  3 Oct 2020 00:41:46 +0900
Message-Id: <20201002154219.4887-3-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201002154219.4887-1-mailhol.vincent@wanadoo.fr>
References: <20200926175810.278529-1-mailhol.vincent@wanadoo.fr>
 <20201002154219.4887-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The macros get_can_dlc() and get_canfd_dlc() are not visible in
userland. As such, type u8 should be preferred over type __u8.

Reference: https://lkml.org/lkml/2020/10/1/708
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 include/linux/can/dev.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index 5e3d45525bd3..132b4133f9d0 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -84,13 +84,13 @@ struct can_priv {
 
 /*
  * get_can_dlc(value) - helper macro to cast a given data length code (dlc)
- * to __u8 and ensure the dlc value to be max. 8 bytes.
+ * to u8 and ensure the dlc value to be max. 8 bytes.
  *
  * To be used in the CAN netdriver receive path to ensure conformance with
  * ISO 11898-1 Chapter 8.4.2.3 (DLC field)
  */
-#define get_can_dlc(i)		(min_t(__u8, (i), CAN_MAX_DLC))
-#define get_canfd_dlc(i)	(min_t(__u8, (i), CANFD_MAX_DLC))
+#define get_can_dlc(i)		(min_t(u8, (i), CAN_MAX_DLC))
+#define get_canfd_dlc(i)	(min_t(u8, (i), CANFD_MAX_DLC))
 
 /* Check for outgoing skbs that have not been created by the CAN subsystem */
 static inline bool can_skb_headroom_valid(struct net_device *dev,
-- 
2.26.2

