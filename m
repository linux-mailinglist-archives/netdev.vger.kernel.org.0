Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76F66DF000
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 16:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729567AbfJUOid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 10:38:33 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:57638 "EHLO
        michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729411AbfJUOh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 10:37:56 -0400
Received: from ramsan ([84.194.98.4])
        by michel.telenet-ops.be with bizsmtp
        id GEdo2100R05gfCL06Edorl; Mon, 21 Oct 2019 16:37:54 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iMYoe-0007cv-Bm; Mon, 21 Oct 2019 16:37:48 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iMYoe-0003mY-7w; Mon, 21 Oct 2019 16:37:48 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 0/7] debugfs: Add and use debugfs_create_xul()
Date:   Mon, 21 Oct 2019 16:37:35 +0200
Message-Id: <20191021143742.14487-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	Hi all,

The existing debugfs_create_ulong() function supports objects of
type "unsigned long", which are 32-bit or 64-bit depending on the
platform, in decimal form.  To format objects in hexadecimal, various
debugfs_create_x*() functions exist, but all of them take fixed-size
types.

To work around this, some drivers call one of debugfs_create_x{32,64}(),
depending on the size of unsigned long.
Other driver just cast the value pointer to "u32 *" or "u64 *",
introducing portability bugs or data leaks in the process.

Hence this patch series adds a debugfs helper for "unsigned long"
objects in hexadecimal format, and converts drivers to make use of it.
It also contains two cleanups removing superfluous casts, which I added
to this series to avoid conflicts.

Thanks for your comments!

Geert Uytterhoeven (7):
  debugfs: Add debugfs_create_xul() for hexadecimal unsigned long
  mac80211: Use debugfs_create_xul() helper
  net: caif: Fix debugfs on 64-bit platforms
  mmc: atmel-mci: Fix debugfs on 64-bit platforms
  mmc: atmel-mci: Remove superfluous cast in debugfs_create_u32() call
  mmc: dw_mmc: Fix debugfs on 64-bit platforms
  mmc: dw_mmc: Remove superfluous cast in debugfs_create_u32() call

 drivers/mmc/host/atmel-mci.c   | 10 +++++-----
 drivers/mmc/host/dw_mmc.c      | 10 +++++-----
 drivers/net/caif/caif_serial.c |  4 ++--
 include/linux/debugfs.h        | 10 ++++++++++
 net/mac80211/debugfs_sta.c     | 17 +++--------------
 5 files changed, 25 insertions(+), 26 deletions(-)

-- 
2.17.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
