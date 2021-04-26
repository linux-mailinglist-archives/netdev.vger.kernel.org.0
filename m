Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E98336AC79
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 08:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbhDZGzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 02:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232077AbhDZGzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 02:55:41 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E33C061761
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 23:55:00 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lav91-00040L-9U
        for netdev@vger.kernel.org; Mon, 26 Apr 2021 08:54:59 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 262A5616F8C
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 06:54:56 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 7DEDF616F6E;
        Mon, 26 Apr 2021 06:54:54 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 1642f94a;
        Mon, 26 Apr 2021 06:54:53 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Erik Flodin <erik@flodin.me>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 4/4] can: proc: fix rcvlist_* header alignment on 64-bit system
Date:   Mon, 26 Apr 2021 08:54:52 +0200
Message-Id: <20210426065452.3411360-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210426065452.3411360-1-mkl@pengutronix.de>
References: <20210426065452.3411360-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Erik Flodin <erik@flodin.me>

Before this fix, the function and userdata columns weren't aligned:
  device   can_id   can_mask  function  userdata   matches  ident
   vcan0  92345678  9fffffff  0000000000000000  0000000000000000         0  raw
   vcan0     123    00000123  0000000000000000  0000000000000000         0  raw

After the fix they are:
  device   can_id   can_mask      function          userdata       matches  ident
   vcan0  92345678  9fffffff  0000000000000000  0000000000000000         0  raw
   vcan0     123    00000123  0000000000000000  0000000000000000         0  raw

Link: Link: https://lore.kernel.org/r/20210425141440.229653-1-erik@flodin.me
Signed-off-by: Erik Flodin <erik@flodin.me>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/proc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/can/proc.c b/net/can/proc.c
index b15760b5c1cc..d1fe49e6f16d 100644
--- a/net/can/proc.c
+++ b/net/can/proc.c
@@ -205,8 +205,10 @@ static void can_print_recv_banner(struct seq_file *m)
 	 *                  can1.  00000000  00000000  00000000
 	 *                 .......          0  tp20
 	 */
-	seq_puts(m, "  device   can_id   can_mask  function"
-			"  userdata   matches  ident\n");
+	if (IS_ENABLED(CONFIG_64BIT))
+		seq_puts(m, "  device   can_id   can_mask      function          userdata       matches  ident\n");
+	else
+		seq_puts(m, "  device   can_id   can_mask  function  userdata   matches  ident\n");
 }
 
 static int can_stats_proc_show(struct seq_file *m, void *v)
-- 
2.30.2


