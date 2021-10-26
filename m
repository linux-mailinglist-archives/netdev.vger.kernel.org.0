Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A5443B90E
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 20:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbhJZSLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 14:11:47 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:58598 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238079AbhJZSLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 14:11:47 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by smtp.orange.fr with ESMTPA
        id fQssm4KE0BazofQsxmL3wM; Tue, 26 Oct 2021 20:09:22 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Tue, 26 Oct 2021 20:09:22 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Matt Kline <matt@bitbashing.io>
Subject: [RFC PATCH v1] can: m_can: m_can_read_fifo: fix memory leak in error branch
Date:   Wed, 27 Oct 2021 03:09:09 +0900
Message-Id: <20211026180909.1953355-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In m_can_read_fifo(), if the second call to m_can_fifo_read() fails,
the function jump to the out_fail label and returns without calling
m_can_receive_skb(). This means that the skb previously allocated by
alloc_can_skb() is not freed. In other terms, this is a memory leak.

This patch adds a new goto statement: out_receive_skb and do some
small code refactoring to fix the issue.

* Appendix: how the issue was found *

This issue was found using GCC's static analysis tool: -fanalyzer:
https://gcc.gnu.org/onlinedocs/gcc/Static-Analyzer-Options.html

The step to reproduce are:

  1. Install GCC 11.

  2. Hack the kernel's Makefile to add the -fanalyzer flag (we leave
  it as an exercise for the reader to figure out the details of how to
  do so).

  3. Decorate the function alloc_can_skb() with
  __attribute__((__malloc__ (dealloc, netif_rx))). This step helps the
  static analyzer to figure out the constructor/destructor pairs (not
  something it can deduce by himself).

  4. Compile.

The compiler then throws below warning:

| drivers/net/can/m_can/m_can.c: In function 'm_can_read_fifo':
| drivers/net/can/m_can/m_can.c:537:9: warning: leak of 'skb' [CWE-401] [-Wanalyzer-malloc-leak]
|   537 |         return err;
|       |         ^~~~~~
|   'm_can_rx_handler': events 1-6
|     |
|     |  899 | static int m_can_rx_handler(struct net_device *dev, int quota)
|     |      |            ^~~~~~~~~~~~~~~~
|     |      |            |
|     |      |            (1) entry to 'm_can_rx_handler'
|     |......
|     |  907 |         if (!irqstatus)
|     |      |            ~
|     |      |            |
|     |      |            (2) following 'false' branch (when 'irqstatus != 0')...
|     |......
|     |  920 |         if (cdev->version <= 31 && irqstatus & IR_MRAF &&
|     |      |         ~~
|     |      |         |
|     |      |         (3) ...to here
|     |......
|     |  939 |         if (irqstatus & IR_RF0N) {
|     |      |            ~
|     |      |            |
|     |      |            (4) following 'true' branch...
|     |  940 |                 rx_work_or_err = m_can_do_rx_poll(dev, (quota - work_done));
|     |      |                 ~~~~~~~~~~~~~~   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
|     |      |                 |                |
|     |      |                 |                (6) calling 'm_can_do_rx_poll' from 'm_can_rx_handler'
|     |      |                 (5) ...to here
|     |
|     +--> 'm_can_do_rx_poll': events 7-8
|            |
|            |  540 | static int m_can_do_rx_poll(struct net_device *dev, int quota)
|            |      |            ^~~~~~~~~~~~~~~~
|            |      |            |
|            |      |            (7) entry to 'm_can_do_rx_poll'
|            |......
|            |  548 |         if (!(rxfs & RXFS_FFL_MASK)) {
|            |      |            ~
|            |      |            |
|            |      |            (8) following 'false' branch...
|            |
|          'm_can_do_rx_poll': event 9
|            |
|            |cc1:
|            | (9): ...to here
|            |
|          'm_can_do_rx_poll': events 10-12
|            |
|            |  553 |         while ((rxfs & RXFS_FFL_MASK) && (quota > 0)) {
|            |      |                ~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~
|            |      |                                       |
|            |      |                                       (10) following 'true' branch...
|            |  554 |                 err = m_can_read_fifo(dev, rxfs);
|            |      |                 ~~~   ~~~~~~~~~~~~~~~~~~~~~~~~~~
|            |      |                 |     |
|            |      |                 |     (12) calling 'm_can_read_fifo' from 'm_can_do_rx_poll'
|            |      |                 (11) ...to here
|            |
|            +--> 'm_can_read_fifo': events 13-24
|                   |
|                   |  470 | static int m_can_read_fifo(struct net_device *dev, u32 rxfs)
|                   |      |            ^~~~~~~~~~~~~~~
|                   |      |            |
|                   |      |            (13) entry to 'm_can_read_fifo'
|                   |......
|                   |  484 |         if (err)
|                   |      |            ~
|                   |      |            |
|                   |      |            (14) following 'false' branch...
|                   |......
|                   |  487 |         if (fifo_header.dlc & RX_BUF_FDF)
|                   |      |         ~~ ~
|                   |      |         |  |
|                   |      |         |  (16) following 'true' branch...
|                   |      |         (15) ...to here
|                   |  488 |                 skb = alloc_canfd_skb(dev, &cf);
|                   |      |                 ~~~   ~~~~~~~~~~~~~~~~~~~~~~~~~
|                   |      |                 |     |
|                   |      |                 |     (18) allocated here
|                   |      |                 (17) ...to here
|                   |......
|                   |  491 |         if (!skb) {
|                   |      |            ~
|                   |      |            |
|                   |      |            (19) assuming 'skb' is non-NULL
|                   |      |            (20) following 'false' branch (when 'skb' is non-NULL)...
|                   |......
|                   |  496 |         if (fifo_header.dlc & RX_BUF_FDF)
|                   |      |         ~~
|                   |      |         |
|                   |      |         (21) ...to here
|                   |......
|                   |  519 |                 if (err)
|                   |      |                    ~
|                   |      |                    |
|                   |      |                    (22) following 'true' branch...
|                   |  520 |                         goto out_fail;
|                   |      |                         ~~~~
|                   |      |                         |
|                   |      |                         (23) ...to here
|                   |......
|                   |  537 |         return err;
|                   |      |         ~~~~~~
|                   |      |         |
|                   |      |         (24) 'skb' leaks here; was allocated at (18)
|                   |

Fixes: e39381770ec9 ("can: m_can: Disable IRQs on FIFO bus errors")
CC: Matt Kline <matt@bitbashing.io>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/m_can/m_can.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 2470c47b2e31..4e81ff9dd5c6 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -476,7 +476,7 @@ static int m_can_read_fifo(struct net_device *dev, u32 rxfs)
 	struct id_and_dlc fifo_header;
 	u32 fgi;
 	u32 timestamp = 0;
-	int err;
+	int err = 0;
 
 	/* calculate the fifo get index for where to read data */
 	fgi = FIELD_GET(RXFS_FGI_MASK, rxfs);
@@ -517,7 +517,7 @@ static int m_can_read_fifo(struct net_device *dev, u32 rxfs)
 		err = m_can_fifo_read(cdev, fgi, M_CAN_FIFO_DATA,
 				      cf->data, DIV_ROUND_UP(cf->len, 4));
 		if (err)
-			goto out_fail;
+			goto out_receive_skb;
 	}
 
 	/* acknowledge rx fifo 0 */
@@ -528,12 +528,12 @@ static int m_can_read_fifo(struct net_device *dev, u32 rxfs)
 
 	timestamp = FIELD_GET(RX_BUF_RXTS_MASK, fifo_header.dlc);
 
+out_receive_skb:
 	m_can_receive_skb(cdev, skb, timestamp);
 
-	return 0;
-
 out_fail:
-	netdev_err(dev, "FIFO read returned %d\n", err);
+	if (err)
+		netdev_err(dev, "FIFO read returned %d\n", err);
 	return err;
 }
 
-- 
2.32.0

