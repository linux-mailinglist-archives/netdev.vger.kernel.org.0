Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFA72816E8
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387768AbgJBPmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:42:46 -0400
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:49516 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387692AbgJBPmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 11:42:46 -0400
Received: from tomoyo.flets-east.jp ([153.230.197.127])
        by mwinf5d76 with ME
        id b3iL230022lQRaH033iZfK; Fri, 02 Oct 2020 17:42:43 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Fri, 02 Oct 2020 17:42:43 +0200
X-ME-IP: 153.230.197.127
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        linux-usb@vger.kernel.org (open list:USB ACM DRIVER)
Subject: [PATCH v3 0/7] can: add support for ETAS ES58X CAN USB
Date:   Sat,  3 Oct 2020 00:41:44 +0900
Message-Id: <20201002154219.4887-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200926175810.278529-1-mailhol.vincent@wanadoo.fr>
References: <20200926175810.278529-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of this patch series is to introduce a new CAN USB
driver to support ETAS USB interfaces (ES58X series).

During development, issues in drivers/net/can/dev.c where discovered,
the fix for those issues are included in this patch series.

We also propose to add two helper functions in include/linux/can/dev.h
which we think can benefit other drivers: get_can_len() and
can_bit_time().

The driver indirectly relies on https://lkml.org/lkml/2020/9/26/251
([PATCH] can: raw: add missing error queue support) for the call to
skb_tx_timestamp() to work but can still compile without it.

*Side notes*: scripts/checkpatch.pl returns 4 'checks' findings in
[PATCH 5/6]. All those findings are of type: "Macro argument reuse 'x'
possible side-effects?".  Those arguments reuse are actually made by
calling either __stringify() or sizeof_field() which are both
pre-processor constant. Furthermore, those macro are never called with
arguments sensible to side-effects. So no actual side effect would
occur.

Changes in v3:
  - Added one additional patch: [PATCH v3 2/7] can: dev: fix type of
 get_can_dlc() and get_canfd_dlc() macros.
  - Make get_can_len() return u8 and make the skb const in PATCH 3/7.
  - Remove all the calls to likely() and unlikely() in PATCH 6/7.

Changes in v2:
  - Fixed -W1 warnings in PATCH 6/7 (v1 was tested with GCC -WExtra
  but not with -W1).
  - Added lsusb -v information in PATCH 7/7 and rephrased the comment.
  - Take care to put everyone in CC of each of the patch of the series
  (sorry for the mess in v1...)

Vincent Mailhol (7):
  can: dev: can_get_echo_skb(): prevent call to kfree_skb() in hard IRQ
    context
  can: dev: fix type of get_can_dlc() and get_canfd_dlc() macros
  can: dev: add a helper function to get the correct length of Classical
    frames
  can: dev: __can_get_echo_skb(): fix the return length
  can: dev: add a helper function to calculate the duration of one bit
  can: usb: etas_es58X: add support for ETAS ES58X CAN USB interfaces
  usb: cdc-acm: add quirk to blacklist ETAS ES58X devices

 drivers/net/can/dev.c                       |   26 +-
 drivers/net/can/usb/Kconfig                 |    9 +
 drivers/net/can/usb/Makefile                |    1 +
 drivers/net/can/usb/etas_es58x/Makefile     |    3 +
 drivers/net/can/usb/etas_es58x/es581_4.c    |  559 ++++
 drivers/net/can/usb/etas_es58x/es581_4.h    |  237 ++
 drivers/net/can/usb/etas_es58x/es58x_core.c | 2725 +++++++++++++++++++
 drivers/net/can/usb/etas_es58x/es58x_core.h |  700 +++++
 drivers/net/can/usb/etas_es58x/es58x_fd.c   |  648 +++++
 drivers/net/can/usb/etas_es58x/es58x_fd.h   |  243 ++
 drivers/usb/class/cdc-acm.c                 |   11 +
 include/linux/can/dev.h                     |   44 +-
 12 files changed, 5189 insertions(+), 17 deletions(-)
 create mode 100644 drivers/net/can/usb/etas_es58x/Makefile
 create mode 100644 drivers/net/can/usb/etas_es58x/es581_4.c
 create mode 100644 drivers/net/can/usb/etas_es58x/es581_4.h
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_core.c
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_core.h
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_fd.c
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_fd.h

-- 
2.26.2

