Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A83822FD3F
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 01:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgG0XZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 19:25:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728553AbgG0XZR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 19:25:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AD8C22BEB;
        Mon, 27 Jul 2020 23:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595892316;
        bh=Jcg2bOCFaxvQaQmqPtBJ/NnpJgFsRnFkdboU3XNsS4Q=;
        h=From:To:Cc:Subject:Date:From;
        b=NeSdWxYDQT4paYMX66sgers1wlV/b8tGIJ+JFDRBhMEISsEnVlkEcB/zuPjO185nf
         Yssg61Vyfx42kSxsnMZk1YT7PHuVvpHwkHDcSgEg+zGfH1StYCh1f3lhRyX4y0N7ND
         QAviQl1ZOwoesiSiR6Ez7l/UBBpYp5kjzzbgNaWg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 1/7] usb: hso: Fix debug compile warning on sparc32
Date:   Mon, 27 Jul 2020 19:25:08 -0400
Message-Id: <20200727232514.718265-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit e0484010ec05191a8edf980413fc92f28050c1cc ]

On sparc32, tcflag_t is "unsigned long", unlike on all other
architectures, where it is "unsigned int":

    drivers/net/usb/hso.c: In function ‘hso_serial_set_termios’:
    include/linux/kern_levels.h:5:18: warning: format ‘%d’ expects argument of type ‘unsigned int’, but argument 4 has type ‘tcflag_t {aka long unsigned int}’ [-Wformat=]
    drivers/net/usb/hso.c:1393:3: note: in expansion of macro ‘hso_dbg’
       hso_dbg(0x16, "Termios called with: cflags new[%d] - old[%d]\n",
       ^~~~~~~
    include/linux/kern_levels.h:5:18: warning: format ‘%d’ expects argument of type ‘unsigned int’, but argument 5 has type ‘tcflag_t {aka long unsigned int}’ [-Wformat=]
    drivers/net/usb/hso.c:1393:3: note: in expansion of macro ‘hso_dbg’
       hso_dbg(0x16, "Termios called with: cflags new[%d] - old[%d]\n",
       ^~~~~~~

As "unsigned long" is 32-bit on sparc32, fix this by casting all tcflag_t
parameters to "unsigned int".
While at it, use "%u" to format unsigned numbers.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/hso.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 27fc699d8be5b..2ae30db06bfa1 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -1404,8 +1404,9 @@ static void hso_serial_set_termios(struct tty_struct *tty, struct ktermios *old)
 	unsigned long flags;
 
 	if (old)
-		hso_dbg(0x16, "Termios called with: cflags new[%d] - old[%d]\n",
-			tty->termios.c_cflag, old->c_cflag);
+		hso_dbg(0x16, "Termios called with: cflags new[%u] - old[%u]\n",
+			(unsigned int)tty->termios.c_cflag,
+			(unsigned int)old->c_cflag);
 
 	/* the actual setup */
 	spin_lock_irqsave(&serial->serial_lock, flags);
-- 
2.25.1

