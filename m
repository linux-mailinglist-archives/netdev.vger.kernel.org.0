Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9C9290A5B
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 19:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732589AbgJPRO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 13:14:59 -0400
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:55268 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732408AbgJPRO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 13:14:59 -0400
Received: from tomoyo.flets-east.jp ([153.230.197.127])
        by mwinf5d46 with ME
        id ghEh2300Y2lQRaH03hEsCJ; Fri, 16 Oct 2020 19:14:57 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Fri, 16 Oct 2020 19:14:57 +0200
X-ME-IP: 153.230.197.127
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH v4 0/4] can: add support for ETAS ES58X CAN USB
Date:   Sat, 17 Oct 2020 02:13:29 +0900
Message-Id: <20201016171402.229001-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of this patch series is to introduce a new CAN USB
driver to support ETAS USB interfaces (ES58X series).

During development, issues in drivers/net/can/dev.c were discovered,
the fix for those issues are included in this patch series.

We also propose to add one helper functions in include/linux/can/dev.h
which we think can benefit other drivers: get_can_len().

*Side notes*: scripts/checkpatch.pl returns 4 'checks' findings in
[PATCH 4/4]. All those findings are of type: "Macro argument reuse 'x'
possible side-effects?".  Those arguments reuse are actually made by
calling either __stringify() or sizeof_field() which are both
pre-processor constant. Furthermore, those macro are never called with
arguments sensible to side-effects. So no actual side effect would
occur.

Changes in v4:
  - Remove from the series the patches with have already been merged
  into net-next.
Reference: https://lkml.org/lkml/2020/10/4/78
Reference: https://lkml.org/lkml/2020/10/5/355
  - Modify [PATCH 4/4] according to comments from Marc.
Reference: https://lkml.org/lkml/2020/10/4/80)

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

Vincent Mailhol (4):
  can: dev: can_get_echo_skb(): prevent call to kfree_skb() in hard IRQ
    context
  can: dev: add a helper function to get the correct length of Classical
    frames
  can: dev: __can_get_echo_skb(): fix the return length
  can: usb: etas_es58X: add support for ETAS ES58X CAN USB interfaces

 drivers/net/can/dev.c                       |   13 +-
 drivers/net/can/usb/Kconfig                 |    9 +
 drivers/net/can/usb/Makefile                |    1 +
 drivers/net/can/usb/etas_es58x/Makefile     |    3 +
 drivers/net/can/usb/etas_es58x/es581_4.c    |  556 ++++
 drivers/net/can/usb/etas_es58x/es581_4.h    |  209 ++
 drivers/net/can/usb/etas_es58x/es58x_core.c | 2639 +++++++++++++++++++
 drivers/net/can/usb/etas_es58x/es58x_core.h |  704 +++++
 drivers/net/can/usb/etas_es58x/es58x_fd.c   |  657 +++++
 drivers/net/can/usb/etas_es58x/es58x_fd.h   |  241 ++
 include/linux/can/dev.h                     |   23 +
 11 files changed, 5048 insertions(+), 7 deletions(-)
 create mode 100644 drivers/net/can/usb/etas_es58x/Makefile
 create mode 100644 drivers/net/can/usb/etas_es58x/es581_4.c
 create mode 100644 drivers/net/can/usb/etas_es58x/es581_4.h
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_core.c
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_core.h
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_fd.c
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_fd.h

-- 
2.26.2

