Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 657512FA42C
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 16:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393217AbhARPIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 10:08:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393180AbhARPHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 10:07:46 -0500
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BAF5C0613C1
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 07:07:03 -0800 (PST)
Received: from ramsan.of.borg ([84.195.186.194])
        by laurent.telenet-ops.be with bizsmtp
        id JF6y240084C55Sk01F6y0M; Mon, 18 Jan 2021 16:07:02 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1l1W7O-004cpY-1A; Mon, 18 Jan 2021 16:06:58 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1l1W7N-003LEv-JJ; Mon, 18 Jan 2021 16:06:57 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH net v2 0/2] sh_eth: Fix reboot crash
Date:   Mon, 18 Jan 2021 16:06:54 +0100
Message-Id: <20210118150656.796584-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	Hi,

This patch fixes a regression v5.11-rc1, where rebooting while a sh_eth
device is not opened will cause a crash.

Changes compared to v1:
  - Export mdiobb_{read,write}(),
  - Call mdiobb_{read,write}() now they are exported,
  - Use mii_bus.parent to avoid bb_info.dev copy,
  - Drop RFC state.

Alternatively, mdio-bitbang could provide Runtime PM-aware wrappers
itself, and use them either manually (through a new parameter to
alloc_mdio_bitbang(), or a new alloc_mdio_bitbang_*() function), or
automatically (e.g. if pm_runtime_enabled() returns true).  Note that
the latter requires a "struct device *" parameter to operate on.
Currently there are only two drivers that call alloc_mdio_bitbang() and
use Runtime PM: the Renesas sh_eth and ravb drivers.  This series fixes
the former, while the latter is not affected (it keeps the device
powered all the time between driver probe and driver unbind, and
changing that seems to be non-trivial).

Thanks for your comments!

Geert Uytterhoeven (2):
  net: mdio-bitbang: Export mdiobb_{read,write}()
  sh_eth: Make PHY access aware of Runtime PM to fix reboot crash

 drivers/net/ethernet/renesas/sh_eth.c | 26 ++++++++++++++++++++++++++
 drivers/net/mdio/mdio-bitbang.c       |  6 ++++--
 include/linux/mdio-bitbang.h          |  3 +++
 3 files changed, 33 insertions(+), 2 deletions(-)

-- 
2.25.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
