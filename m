Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011702C6272
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 11:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbgK0KD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 05:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgK0KD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 05:03:59 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32578C0613D1
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 02:03:59 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kiabd-0007aC-Rj
        for netdev@vger.kernel.org; Fri, 27 Nov 2020 11:03:57 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id E123759DE76
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 10:03:54 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id C891D59DE67;
        Fri, 27 Nov 2020 10:03:53 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 2c0a48aa;
        Fri, 27 Nov 2020 10:03:53 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2020-11-27
Date:   Fri, 27 Nov 2020 11:02:55 +0100
Message-Id: <20201127100301.512603-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
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

here's a pull request of 6 patches for net/master.

The first patch is by me and target the gs_usb driver and fixes the endianess
problem with candleLight firmware.

Another patch by me for the mcp251xfd driver add sanity checking to bail out if
no IRQ is configured.

The next three patches target the m_can driver. A patch by me removes the
hardcoded IRQF_TRIGGER_FALLING from the request_threaded_irq() as this clashes
with the trigger level specified in the DT. Further a patch by me fixes the
nominal bitiming tseg2 min value for modern m_can cores. Pankaj Sharma's patch
add support for cores version 3.3.x.

The last patch by Oliver Hartkopp is for af_can and converts a WARN() into a
pr_warn(), which is triggered by the syzkaller. It was able to create a
situation where the closing of a socket runs simultaneously to the notifier
call chain for removing the CAN network device in use.

regards,
Marc

---

The following changes since commit cbf3d60329c4e11edcecac0c8fc6767b0f05e3a7:

  ch_ktls: lock is not freed (2020-11-25 17:44:42 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.10-20201127

for you to fetch changes up to d73ff9b7c4eacaba0fd956d14882bcae970f8307:

  can: af_can: can_rx_unregister(): remove WARN() statement from list operation sanity check (2020-11-27 10:49:28 +0100)

----------------------------------------------------------------
linux-can-fixes-for-5.10-20201127

----------------------------------------------------------------
Marc Kleine-Budde (4):
      can: gs_usb: fix endianess problem with candleLight firmware
      can: mcp251xfd: mcp251xfd_probe(): bail out if no IRQ was given
      can: m_can: m_can_open(): remove IRQF_TRIGGER_FALLING from request_threaded_irq()'s flags
      can: m_can: fix nominal bitiming tseg2 min for version >= 3.1

Oliver Hartkopp (1):
      can: af_can: can_rx_unregister(): remove WARN() statement from list operation sanity check

Pankaj Sharma (1):
      can: m_can: m_can_dev_setup(): add support for bosch mcan version 3.3.0

 drivers/net/can/m_can/m_can.c                  |   6 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c |   4 +
 drivers/net/can/usb/gs_usb.c                   | 131 +++++++++++++------------
 net/can/af_can.c                               |   7 +-
 4 files changed, 83 insertions(+), 65 deletions(-)


