Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16A6818E175
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 14:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgCUNJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 09:09:08 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.220]:26217 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbgCUNJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 09:09:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1584796146;
        s=strato-dkim-0002; d=hartkopp.net;
        h=Message-Id:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=Bwk1OApukrJ9RA4OD9GidqxuDPWVuaVLTTLE5xru0uw=;
        b=sPbhomknLLD7StPSnw3L53EYqfmR1jl5Q709QZ2mVMvnCU2FahVql5WoT0Gh3F0wpf
        HH6SDQmYJ0vmU8pVhcAA4LR28P1M4zfgdTYgEtAPP+xX77LLbZqoEoeFjAogBzVXuQbA
        nFQ2gzlBDELp0SLUJlTURzL14TTMUa+ecDBQ9oy2BIo2I0IwYdVW5V5etbdgKHl/2v2X
        32QhPltF8FVpEb35QiHUPpjB9K1aKtCgNA1wU4ccDy8ExI67RH2EB7ADNzVBygH3W22V
        CP0xxpvlkCDHpV7wg6Jw1KO8RL1d8YNBZN2F8lrIAdiToGGRirT/cxDDhxNzeCk63rAU
        Yxug==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS0lO8DsfULo/S2TWr5zH4="
X-RZG-CLASS-ID: mo00
Received: from silver.lan
        by smtp.strato.de (RZmta 46.2.1 DYNA|AUTH)
        with ESMTPSA id R0105bw2LD8t6c1
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sat, 21 Mar 2020 14:08:55 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     netdev@vger.kernel.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        yangerkun <yangerkun@huawei.com>
Subject: [PATCH net] slcan: not call free_netdev before rtnl_unlock in slcan_open
Date:   Sat, 21 Mar 2020 14:08:29 +0100
Message-Id: <20200321130829.12859-1-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the description before netdev_run_todo, we cannot call free_netdev
before rtnl_unlock, fix it by reorder the code.

This patch is a 1:1 copy of upstream slip.c commit f596c87005f7
("slip: not call free_netdev before rtnl_unlock in slip_open").

Reported-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
---
 drivers/net/can/slcan.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index 2f5c287eac95..a3664281a33f 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -625,7 +625,10 @@ static int slcan_open(struct tty_struct *tty)
 	tty->disc_data = NULL;
 	clear_bit(SLF_INUSE, &sl->flags);
 	slc_free_netdev(sl->dev);
+	/* do not call free_netdev before rtnl_unlock */
+	rtnl_unlock();
 	free_netdev(sl->dev);
+	return err;
 
 err_exit:
 	rtnl_unlock();
-- 
2.20.1

