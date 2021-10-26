Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6AA43B904
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 20:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238068AbhJZSKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 14:10:17 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:57551 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236798AbhJZSKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 14:10:16 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by smtp.orange.fr with ESMTPA
        id fQrPm4JMzBazofQrVmL3f7; Tue, 26 Oct 2021 20:07:51 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Tue, 26 Oct 2021 20:07:51 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v1] can: etas_es58x: es58x_rx_err_msg: fix memory leak in error path
Date:   Wed, 27 Oct 2021 03:07:40 +0900
Message-Id: <20211026180740.1953265-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In es58x_rx_err_msg(), if can->do_set_mode() fails, the function
directly returns without calling netif_rx(skb). This means that the
skb previously allocated by alloc_can_err_skb() is not freed. In other
terms, this is a memory leak.

This patch simply removes the return statement in the error branch and
let the function continue.

* Appendix: how the issue was found *

This issue was found using GCC's static analysis tool: -fanalyzer:
https://gcc.gnu.org/onlinedocs/gcc/Static-Analyzer-Options.html

The step to reproduce are:

  1. Install GCC 11.

  2. Hack the kernel's Makefile to add the -fanalyzer flag (we leave
  it as an exercise for the reader to figure out the details of how to
  do so).

  3. Decorate the function alloc_can_err_skb() with
  __attribute__((__malloc__ (dealloc, netif_rx))). This step helps the
  static analyzer to figure out the constructor/destructor pairs (not
  something it can deduce by himself).

  4. Compile.

The compiler then throws below warning:

| In function 'es58x_rx_err_msg':
| drivers/net/can/usb/etas_es58x/es58x_core.c:826:28: warning: leak of 'skb' [CWE-401] [-Wanalyzer-malloc-leak]
|   826 |                         if (ret)
|       |                            ^
|   'es58x_rx_err_msg': events 1-9
|     |
|     |  659 | int es58x_rx_err_msg(struct net_device *netdev, enum es58x_err error,
|     |      |     ^~~~~~~~~~~~~~~~
|     |      |     |
|     |      |     (1) entry to 'es58x_rx_err_msg'
|     |......
|     |  669 |         if (!netif_running(netdev)) {
|     |      |            ~
|     |      |            |
|     |      |            (2) following 'true' branch...
|     |......
|     |  677 |         if (error == ES58X_ERR_OK && event == ES58X_EVENT_OK) {
|     |      |         ~~ ~
|     |      |         |  |
|     |      |         |  (4) following 'false' branch...
|     |      |         (3) ...to here
|     |......
|     |  683 |         skb = alloc_can_err_skb(netdev, &cf);
|     |      |         ~~~
|     |      |         |
|     |      |         (5) ...to here
|     |......
|     |  861 |         if (cf) {
|     |      |            ~
|     |      |            |
|     |      |            (6) following 'false' branch...
|     |......
|     |  875 |         if ((event & ES58X_EVENT_CRTL_PASSIVE) &&
|     |      |         ~~ ~
|     |      |         |  |
|     |      |         |  (8) following 'true' branch...
|     |      |         (7) ...to here
|     |  876 |             priv->err_passive_before_rtx_success == ES58X_CONSECUTIVE_ERR_PASSIVE_MAX) {
|     |      |             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
|     |      |                 |
|     |      |                 (9) ...to here
|     |
|   'es58x_rx_err_msg': events 10-12
|     |
|     |  875 |         if ((event & ES58X_EVENT_CRTL_PASSIVE) &&
|     |  876 |             priv->err_passive_before_rtx_success == ES58X_CONSECUTIVE_ERR_PASSIVE_MAX) {
|     |  877 |                 netdev_info(netdev,
|     |      |                 ~~~~~~~~~~~
|     |      |                 |
|     |      |                 (11) ...to here
|     |......
|     |  880 |                 return es58x_rx_err_msg(netdev, ES58X_ERR_OK,
|     |      |                        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
|     |      |                        |
|     |      |                        (12) calling 'es58x_rx_err_msg' from 'es58x_rx_err_msg'
|     |  881 |                                         ES58X_EVENT_BUSOFF, timestamp);
|     |      |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
|     |
|     +--> 'es58x_rx_err_msg': events 13-23
|            |
|            |  659 | int es58x_rx_err_msg(struct net_device *netdev, enum es58x_err error,
|            |      |     ^~~~~~~~~~~~~~~~
|            |      |     |
|            |      |     (13) entry to 'es58x_rx_err_msg'
|            |......
|            |  669 |         if (!netif_running(netdev)) {
|            |      |            ~
|            |      |            |
|            |      |            (14) following 'true' branch...
|            |......
|            |  677 |         if (error == ES58X_ERR_OK && event == ES58X_EVENT_OK) {
|            |      |         ~~ ~
|            |      |         |  |
|            |      |         |  (16) following 'false' branch...
|            |      |         (15) ...to here
|            |......
|            |  683 |         skb = alloc_can_err_skb(netdev, &cf);
|            |      |         ~~~   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
|            |      |         |     |
|            |      |         |     (18) allocated here
|            |      |         (17) ...to here
|            |  684 |
|            |  685 |         switch (error) {
|            |      |         ~~~~~~
|            |      |         |
|            |      |         (19) following 'case 0:' branch...
|            |......
|            |  764 |         switch (event) {
|            |      |         ~~~~~~
|            |      |         |
|            |      |         (20) ...to here
|            |      |         (21) following 'case 8:' branch...
|            |......
|            |  815 |         case ES58X_EVENT_BUSOFF:
|            |      |         ~~~~
|            |      |         |
|            |      |         (22) ...to here
|            |......
|            |  826 |                         if (ret)
|            |      |                            ~
|            |      |                            |
|            |      |                            (23) 'skb' leaks here; was allocated at (18)
|            |


Fixes: 8537257874e9 ("can: etas_es58x: add core support for ETAS ES58X CAN USB interfaces")
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 403de7e9d084..8508a73d648e 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -664,7 +664,7 @@ int es58x_rx_err_msg(struct net_device *netdev, enum es58x_err error,
 	struct can_device_stats *can_stats = &can->can_stats;
 	struct can_frame *cf = NULL;
 	struct sk_buff *skb;
-	int ret;
+	int ret = 0;
 
 	if (!netif_running(netdev)) {
 		if (net_ratelimit())
@@ -823,8 +823,6 @@ int es58x_rx_err_msg(struct net_device *netdev, enum es58x_err error,
 			can->state = CAN_STATE_BUS_OFF;
 			can_bus_off(netdev);
 			ret = can->do_set_mode(netdev, CAN_MODE_STOP);
-			if (ret)
-				return ret;
 		}
 		break;
 
@@ -881,7 +879,7 @@ int es58x_rx_err_msg(struct net_device *netdev, enum es58x_err error,
 					ES58X_EVENT_BUSOFF, timestamp);
 	}
 
-	return 0;
+	return ret;
 }
 
 /**
-- 
2.32.0

