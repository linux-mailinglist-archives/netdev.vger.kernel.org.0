Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C248341147E
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 14:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhITMcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 08:32:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238306AbhITMcQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 08:32:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FA0760F58;
        Mon, 20 Sep 2021 12:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632141049;
        bh=fiiOgJh7EqR6CDg1SraGUGYNQfeg02MhMllonKVAqBY=;
        h=From:To:Cc:Subject:Date:From;
        b=umVoqvb4jL6F3VLNlC6Vd7QpKwQd0cY6wW5Y7UMHVx0D9oazhIJMcFdxa/B3IB3IH
         mGvZHcjHbVg2UxtTiFvu6/uaDpsJjTL7gt+NxLBzuQY3QdvMiVOSRCU9WE1qo3j9iv
         D5n+F6c5rtaRmznaqW4q1A+srU65Ryf1O+DDTbmbkqEhe+q8evejrZUj/fYXc94gbI
         hIMpv/ptgwfw+V7QmSUFrcZj44lGnwFygzY1cwa7zCFkkaY58ep410F3A7AMwOHvkw
         BASk+iKcQX8/EZCiMIE720UrcMjls101kA+XNvHlED3nFI8flpj4R7tLRS+6wyOLwh
         KgVHAVGFa0VjQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] can: etas_es58x: avoid -Wzero-length-bounds warning
Date:   Mon, 20 Sep 2021 14:30:29 +0200
Message-Id: <20210920123045.795228-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

gcc complains when writing into a zero-length array:

drivers/net/can/usb/etas_es58x/es581_4.c: In function 'es581_4_tx_can_msg':
drivers/net/can/usb/etas_es58x/es581_4.c:374:42: warning: array subscript 65535 is outside the bounds of an interior zero-length array 'u8[0]' {aka 'unsigned char[]'} [-Wzero-length-bounds]
  374 |         tx_can_msg = (typeof(tx_can_msg))&es581_4_urb_cmd->raw_msg[msg_len];
      |                                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from drivers/net/can/usb/etas_es58x/es58x_core.h:21,
                 from drivers/net/can/usb/etas_es58x/es581_4.c:15:
drivers/net/can/usb/etas_es58x/es581_4.h:195:20: note: while referencing 'raw_msg'
  195 |                 u8 raw_msg[0];
      |                    ^~~~~~~
  CC [M]  drivers/net/can/usb/etas_es58x/es58x_fd.o
drivers/net/can/usb/etas_es58x/es58x_fd.c: In function 'es58x_fd_tx_can_msg':
drivers/net/can/usb/etas_es58x/es58x_fd.c:360:42: warning: array subscript 65535 is outside the bounds of an interior zero-length array 'u8[0]' {aka 'unsigned char[]'} [-Wzero-length-bounds]
  360 |         tx_can_msg = (typeof(tx_can_msg))&es58x_fd_urb_cmd->raw_msg[msg_len];
      |                                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from drivers/net/can/usb/etas_es58x/es58x_core.h:22,
                 from drivers/net/can/usb/etas_es58x/es58x_fd.c:17:
drivers/net/can/usb/etas_es58x/es58x_fd.h:222:20: note: while referencing 'raw_msg'
  222 |                 u8 raw_msg[0];
      |                    ^~~~~~~

The solution is usually to use a flexible-array member the struct, but
we can't directly have that inside of a union, nor can it be the only
member of a struct, so add a dummy struct with another zero-length
member to get the intended behavior.

If someone has a better workaround, let me know and I can send a new
patch, as this version is rather ugly.

Fixes: f4f5247daa45 ("can: etas_es58x: rewrite the message cast in es58{1,_fd}_tx_can_msg to increase readability")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/can/usb/etas_es58x/es581_4.h  | 5 ++++-
 drivers/net/can/usb/etas_es58x/es58x_fd.h | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/etas_es58x/es581_4.h b/drivers/net/can/usb/etas_es58x/es581_4.h
index 4bc60a6df697..ac5ef88db565 100644
--- a/drivers/net/can/usb/etas_es58x/es581_4.h
+++ b/drivers/net/can/usb/etas_es58x/es581_4.h
@@ -192,7 +192,10 @@ struct es581_4_urb_cmd {
 		struct es581_4_rx_cmd_ret rx_cmd_ret;
 		__le64 timestamp;
 		u8 rx_cmd_ret_u8;
-		u8 raw_msg[0];
+		struct {
+			u8 __pad[0];
+			u8 raw_msg[];
+		};
 	} __packed;
 
 	__le16 reserved_for_crc16_do_not_use;
diff --git a/drivers/net/can/usb/etas_es58x/es58x_fd.h b/drivers/net/can/usb/etas_es58x/es58x_fd.h
index a191891b8777..253e7bafd0b6 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_fd.h
+++ b/drivers/net/can/usb/etas_es58x/es58x_fd.h
@@ -219,7 +219,10 @@ struct es58x_fd_urb_cmd {
 		struct es58x_fd_tx_ack_msg tx_ack_msg;
 		__le64 timestamp;
 		__le32 rx_cmd_ret_le32;
-		u8 raw_msg[0];
+		struct {
+			u8 __pad[0];
+			u8 raw_msg[];
+		};
 	} __packed;
 
 	__le16 reserved_for_crc16_do_not_use;
-- 
2.29.2

