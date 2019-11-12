Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC18F8DD6
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 12:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbfKLLRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 06:17:42 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:46657 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfKLLRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 06:17:42 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iUU9T-0003F6-Oi; Tue, 12 Nov 2019 12:16:03 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iUU9S-0004xl-7M; Tue, 12 Nov 2019 12:16:02 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     dev.kurt@vandijck-laurijssen.be, mkl@pengutronix.de,
        wg@grandegger.com
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v1 0/9] can: j1939: fix multiple issues found by syzbot
Date:   Tue, 12 Nov 2019 12:15:51 +0100
Message-Id: <20191112111600.18719-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.24.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most of this issues was found by test provided with following syzbot report:
https://syzkaller.appspot.com/bug?extid=d9536adc269404a984f8

Other syzbot reports are probably different incarnation of the same or
combination of bugs:

https://syzkaller.appspot.com/bug?extid=07bb74aeafc88ba7d5b4
https://syzkaller.appspot.com/bug?extid=4857323ec1bb236f6a45
https://syzkaller.appspot.com/bug?extid=6d04f6a1b31a0ae12ca9
https://syzkaller.appspot.com/bug?extid=7044ea77452b6f92b4fd
https://syzkaller.appspot.com/bug?extid=95c8e0d9dffde15b6c5c
https://syzkaller.appspot.com/bug?extid=db4869ba599c0de9b13e
https://syzkaller.appspot.com/bug?extid=feff46f1778030d14234

Oleksij Rempel (9):
  can: af_can: export can_sock_destruct()
  can: j1939: move j1939_priv_put() into sk_destruct callback
  can: j1939: main: j1939_ndev_to_priv(): avoid crash if can_ml_priv is
    NULL
  can: j1939: socket: rework socket locking for j1939_sk_release() and
    j1939_sk_sendmsg()
  can: j1939: transport: make sure the aborted session will be
    deactivated only once
  can: j1939: make sure socket is held as long as session exists
  can: j1939: transport: j1939_cancel_active_session(): use
    hrtimer_try_to_cancel() instead of hrtimer_cancel()
  can: j1939: j1939_can_recv(): add priv refcounting
  can: j1939: warn if resources are still linked on destroy

 include/linux/can/core.h  |  1 +
 net/can/af_can.c          |  3 +-
 net/can/j1939/main.c      |  9 ++++
 net/can/j1939/socket.c    | 94 ++++++++++++++++++++++++++++++---------
 net/can/j1939/transport.c | 36 +++++++++++----
 5 files changed, 113 insertions(+), 30 deletions(-)

-- 
2.24.0.rc1

