Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2768D494EBF
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 14:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245635AbiATNSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 08:18:21 -0500
Received: from hust.edu.cn ([202.114.0.240]:24149 "EHLO hust.edu.cn"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S231658AbiATNSV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 08:18:21 -0500
X-Greylist: delayed 609 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Jan 2022 08:18:20 EST
Received: from localhost.localdomain ([172.16.0.254])
        (user=dzm91@hust.edu.cn mech=LOGIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 20KD670M007780-20KD670P007780
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Thu, 20 Jan 2022 21:06:13 +0800
From:   Dongliang Mu <dzm91@hust.edu.cn>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: net: remove a dangling pointer in peak_usb_create_dev
Date:   Thu, 20 Jan 2022 21:05:58 +0800
Message-Id: <20220120130605.55741-1-dzm91@hust.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-FEAS-AUTH-USER: dzm91@hust.edu.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

The error handling code of peak_usb_create_dev forgets to reset the
next_siblings of previous entry.

Fix this by nullifying the (dev->prev_siblings)->next_siblings in the
error handling code.

Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 drivers/net/can/usb/peak_usb/pcan_usb_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
index b850ff8fe4bd..f858810221b6 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -894,6 +894,9 @@ static int peak_usb_create_dev(const struct peak_usb_adapter *peak_usb_adapter,
 		dev->adapter->dev_free(dev);
 
 lbl_unregister_candev:
+	/* remove the dangling pointer in next_siblings */
+	if (dev->prev_siblings)
+		(dev->prev_siblings)->next_siblings = NULL;
 	unregister_candev(netdev);
 
 lbl_restore_intf_data:
-- 
2.25.1

