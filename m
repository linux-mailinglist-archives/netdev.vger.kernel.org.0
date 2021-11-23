Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4533245A349
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 13:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235777AbhKWMyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 07:54:18 -0500
Received: from pi.codeconstruct.com.au ([203.29.241.158]:55716 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235122AbhKWMyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 07:54:16 -0500
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 2591720271; Tue, 23 Nov 2021 20:51:07 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/3] mctp: serial: cancel tx work on ldisc close
Date:   Tue, 23 Nov 2021 20:50:40 +0800
Message-Id: <20211123125042.2564114-2-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211123125042.2564114-1-jk@codeconstruct.com.au>
References: <20211123125042.2564114-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We want to ensure that the tx work has finished before returning from
the ldisc close op, so do a synchronous cancel.

Reported-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 drivers/net/mctp/mctp-serial.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/mctp/mctp-serial.c b/drivers/net/mctp/mctp-serial.c
index 9ac0e187f36e..c958d773a82a 100644
--- a/drivers/net/mctp/mctp-serial.c
+++ b/drivers/net/mctp/mctp-serial.c
@@ -478,6 +478,7 @@ static void mctp_serial_close(struct tty_struct *tty)
 	struct mctp_serial *dev = tty->disc_data;
 	int idx = dev->idx;
 
+	cancel_work_sync(&dev->tx_work);
 	unregister_netdev(dev->netdev);
 	ida_free(&mctp_serial_ida, idx);
 }
-- 
2.33.0

