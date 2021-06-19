Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422293ADBE3
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 00:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhFSWDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 18:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbhFSWDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 18:03:36 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316BCC061756
        for <netdev@vger.kernel.org>; Sat, 19 Jun 2021 15:01:25 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1luj1n-0005VX-KT
        for netdev@vger.kernel.org; Sun, 20 Jun 2021 00:01:23 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 7231863F7FA
        for <netdev@vger.kernel.org>; Sat, 19 Jun 2021 22:01:20 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id C1AA563F7E2;
        Sat, 19 Jun 2021 22:01:18 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id f1e7984f;
        Sat, 19 Jun 2021 22:01:18 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2021-06-19
Date:   Sun, 20 Jun 2021 00:01:10 +0200
Message-Id: <20210619220115.2830761-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, hello David,

this is a pull request of 5 patches for net/master.

The first patch is by Thadeu Lima de Souza Cascardo and fixes a
potential use-after-free in the CAN broadcast manager socket, by
delaying the release of struct bcm_op after synchronize_rcu().

Oliver Hartkopp's patch fixes a similar potential user-after-free in
the CAN gateway socket by synchronizing RCU operations before removing
gw job entry.

Another patch by Oliver Hartkopp fixes a potential use-after-free in
the ISOTP socket by omitting unintended hrtimer restarts on socket
release.

Oleksij Rempel's patch for the j1939 socket fixes a potential
use-after-free by setting the SOCK_RCU_FREE flag on the socket.

The last patch is by Pavel Skripkin and fixes a use-after-free in the
ems_usb CAN driver.

All patches are intended for stable and have stable@v.k.o on Cc.

regards,
Marc

---

The following changes since commit dda2626b86c2c1813b7bfdd10d2fdd849611fc97:

  Merge branch 'ezchip-fixes' (2021-06-19 11:46:24 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.13-20210619

for you to fetch changes up to ab4a0b8fcb9a95c02909b62049811bd2e586aaa4:

  net: can: ems_usb: fix use-after-free in ems_usb_disconnect() (2021-06-19 23:54:00 +0200)

----------------------------------------------------------------
linux-can-fixes-for-5.13-20210619

----------------------------------------------------------------
Oleksij Rempel (1):
      can: j1939: j1939_sk_init(): set SOCK_RCU_FREE to call sk_destruct() after RCU is done

Oliver Hartkopp (2):
      can: gw: synchronize rcu operations before removing gw job entry
      can: isotp: isotp_release(): omit unintended hrtimer restart on socket release

Pavel Skripkin (1):
      net: can: ems_usb: fix use-after-free in ems_usb_disconnect()

Thadeu Lima de Souza Cascardo (1):
      can: bcm: delay release of struct bcm_op after synchronize_rcu()

 drivers/net/can/usb/ems_usb.c | 3 ++-
 net/can/bcm.c                 | 7 ++++++-
 net/can/gw.c                  | 3 +++
 net/can/isotp.c               | 7 ++++---
 net/can/j1939/main.c          | 4 ++++
 net/can/j1939/socket.c        | 3 +++
 6 files changed, 22 insertions(+), 5 deletions(-)



