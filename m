Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3063565E6
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 10:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236354AbhDGIBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 04:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhDGIBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 04:01:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CBDC061756
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 01:01:24 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lU37r-0001rr-4n
        for netdev@vger.kernel.org; Wed, 07 Apr 2021 10:01:23 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 207546097D7
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 08:01:21 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 2BCB96097CA;
        Wed,  7 Apr 2021 08:01:20 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id f454e5fb;
        Wed, 7 Apr 2021 08:01:19 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can-next 2021-04-07
Date:   Wed,  7 Apr 2021 10:01:12 +0200
Message-Id: <20210407080118.1916040-1-mkl@pengutronix.de>
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

this is a pull request of 6 patches for net-next/master.

The first patch targets the CAN driver infrastructure, it improves the
alloc_can{,fd}_skb() function to set the pointer to the CAN frame to
NULL if skb allocation fails.

The next patch adds missing error handling to the m_can driver's RX
path (the code was introduced in -next, no need to backport).

In the next patch an unused constant is removed from an enum in the
c_can driver.

The last 3 patches target the mcp251xfd driver. They add BQL support
and try to work around a sometimes broken CRC when reading the TBC
register.

regards,
Marc

---

The following changes since commit 0b35e0deb5bee7d4882356d6663522c1562a8321:

  docs: ethtool: correct quotes (2021-04-06 16:56:58 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.13-20210407

for you to fetch changes up to c7eb923c3caf4c6a183465cc012dc368b199a4b2:

  can: mcp251xfd: mcp251xfd_regmap_crc_read(): work around broken CRC on TBC register (2021-04-07 09:31:28 +0200)

----------------------------------------------------------------
linux-can-next-for-5.13-20210407

----------------------------------------------------------------
Marc Kleine-Budde (6):
      can: skb: alloc_can{,fd}_skb(): set "cf" to NULL if skb allocation fails
      can: m_can: m_can_receive_skb(): add missing error handling to can_rx_offload_queue_sorted() call
      can: c_can: remove unused enum BOSCH_C_CAN_PLATFORM
      can: mcp251xfd: add BQL support
      can: mcp251xfd: mcp251xfd_regmap_crc_read_one(): Factor out crc check into separate function
      can: mcp251xfd: mcp251xfd_regmap_crc_read(): work around broken CRC on TBC register

 drivers/net/can/c_can/c_can.h                    |  1 -
 drivers/net/can/dev/skb.c                        | 10 +++-
 drivers/net/can/m_can/m_can.c                    | 13 +++--
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c   | 23 +++++++--
 drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c | 64 ++++++++++++++++++++----
 5 files changed, 90 insertions(+), 21 deletions(-)


