Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6FC345D492
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 07:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346821AbhKYGOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 01:14:02 -0500
Received: from pi.codeconstruct.com.au ([203.29.241.158]:57904 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347376AbhKYGMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 01:12:01 -0500
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 6F51C20294; Thu, 25 Nov 2021 14:08:49 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH net-next v2 1/3] mctp: serial: cancel tx work on ldisc close
Date:   Thu, 25 Nov 2021 14:07:37 +0800
Message-Id: <20211125060739.3023442-2-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211125060739.3023442-1-jk@codeconstruct.com.au>
References: <20211125060739.3023442-1-jk@codeconstruct.com.au>
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
v2:
 - cancel work after netdev unregister
---
 drivers/net/mctp/mctp-serial.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/mctp/mctp-serial.c b/drivers/net/mctp/mctp-serial.c
index 9ac0e187f36e..85b407f4df11 100644
--- a/drivers/net/mctp/mctp-serial.c
+++ b/drivers/net/mctp/mctp-serial.c
@@ -479,6 +479,7 @@ static void mctp_serial_close(struct tty_struct *tty)
 	int idx = dev->idx;
 
 	unregister_netdev(dev->netdev);
+	cancel_work_sync(&dev->tx_work);
 	ida_free(&mctp_serial_ida, idx);
 }
 
-- 
2.30.2

