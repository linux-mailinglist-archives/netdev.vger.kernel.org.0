Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDED438E343
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 11:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbhEXJ1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 05:27:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:33542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232545AbhEXJ1U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 05:27:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89A05610A5;
        Mon, 24 May 2021 09:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621848352;
        bh=RSHJgBS3LNUrrKLwv3RtAYVq8H74gynoFF6n2my1Voo=;
        h=From:To:Cc:Subject:Date:From;
        b=Hz2VroHhV7WJSJoUYvaBLvlC/Q621K0jANyT3JzjK1yADyqFshc8DC6K7/5rVn1GO
         6pzLdw5X0GktvBNNeFKFFOYn/SuuslJjOJsYFaQOZoRnnxEoW46TfeU61ORRIWyjSP
         Z6sbraJwFPVkNiq2SMsgTwcDsfIfye4HAyik7VszYOG2r7b7LX+rVd7ZzqGzq7YODs
         A5oo6sQMK7/rlhz3F9GljzVyZITGd3CzdImZ0eVtysAM+un+BQ//QL5Gdbo7+4juim
         M2ogpB9WZZ/E/G8DqLNNmt4bgmu4/smKIEfNtQtULPrgVQ4ZMZL2nJRbS8VZQAcejb
         Ty9HO7PdwlNXQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1ll6qM-0001ED-5N; Mon, 24 May 2021 11:25:50 +0200
From:   Johan Hovold <johan@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH net] net: hso: fix control-request directions
Date:   Mon, 24 May 2021 11:25:11 +0200
Message-Id: <20210524092511.4657-1-johan@kernel.org>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The direction of the pipe argument must match the request-type direction
bit or control requests may fail depending on the host-controller-driver
implementation.

Fix the tiocmset and rfkill requests which erroneously used
usb_rcvctrlpipe().

Fixes: 72dc1c096c70 ("HSO: add option hso driver")
Cc: stable@vger.kernel.org      # 2.6.27
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/usb/hso.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 3ef4b2841402..ba366e9347f7 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -1689,7 +1689,7 @@ static int hso_serial_tiocmset(struct tty_struct *tty,
 	spin_unlock_irqrestore(&serial->serial_lock, flags);
 
 	return usb_control_msg(serial->parent->usb,
-			       usb_rcvctrlpipe(serial->parent->usb, 0), 0x22,
+			       usb_sndctrlpipe(serial->parent->usb, 0), 0x22,
 			       0x21, val, if_num, NULL, 0,
 			       USB_CTRL_SET_TIMEOUT);
 }
@@ -2436,7 +2436,7 @@ static int hso_rfkill_set_block(void *data, bool blocked)
 	if (hso_dev->usb_gone)
 		rv = 0;
 	else
-		rv = usb_control_msg(hso_dev->usb, usb_rcvctrlpipe(hso_dev->usb, 0),
+		rv = usb_control_msg(hso_dev->usb, usb_sndctrlpipe(hso_dev->usb, 0),
 				       enabled ? 0x82 : 0x81, 0x40, 0, 0, NULL, 0,
 				       USB_CTRL_SET_TIMEOUT);
 	mutex_unlock(&hso_dev->mutex);
-- 
2.26.3

