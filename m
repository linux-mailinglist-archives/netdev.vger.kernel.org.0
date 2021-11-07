Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F326447176
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 06:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbhKGFLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 01:11:09 -0400
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:56094 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbhKGFLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 01:11:08 -0400
Received: from localhost.localdomain ([114.149.34.46])
        by smtp.orange.fr with ESMTPA
        id jaPOmihyw3ptZjaPmm9Zak; Sun, 07 Nov 2021 06:08:25 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Sun, 07 Nov 2021 06:08:25 +0100
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Matt Kline <matt@bitbashing.io>
Subject: [PATCH v2] can: m_can: m_can_read_fifo: fix memory leak in error branch
Date:   Sun,  7 Nov 2021 14:07:55 +0900
Message-Id: <20211107050755.70655-1-mailhol.vincent@wanadoo.fr>
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

This patch adds a goto label to destroy the skb if an error occurs.

Issue was found with GCC -fanalyzer, please follow the link below for
details.

Fixes: e39381770ec9 ("can: m_can: Disable IRQs on FIFO bus errors")
CC: Matt Kline <matt@bitbashing.io>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
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
---
 drivers/net/can/m_can/m_can.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 2470c47b2e31..f4f54012dea7 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -517,7 +517,7 @@ static int m_can_read_fifo(struct net_device *dev, u32 rxfs)
 		err = m_can_fifo_read(cdev, fgi, M_CAN_FIFO_DATA,
 				      cf->data, DIV_ROUND_UP(cf->len, 4));
 		if (err)
-			goto out_fail;
+			goto out_free_skb;
 	}
 
 	/* acknowledge rx fifo 0 */
@@ -532,6 +532,8 @@ static int m_can_read_fifo(struct net_device *dev, u32 rxfs)
 
 	return 0;
 
+out_free_skb:
+	kfree_skb(skb);
 out_fail:
 	netdev_err(dev, "FIFO read returned %d\n", err);
 	return err;
-- 
2.32.0

