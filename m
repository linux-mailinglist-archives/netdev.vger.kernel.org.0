Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63333D122C
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 17:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239788AbhGUOjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 10:39:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232808AbhGUOjS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 10:39:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E36360E0C;
        Wed, 21 Jul 2021 15:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626880795;
        bh=UZmUgiq+0zQRbNJ0Kg61Zjq+ze+yjskbVrAwJ89o1Gw=;
        h=From:To:Cc:Subject:Date:From;
        b=dg4lDZVW9E0iR/8jYLE/BGJ1d18WPys91V3j2iVk3/jwODmV2AKf/TooI6VXV2NqD
         K7QrxzPBwNPP2AT0uTi9y5lRA+ZwgDjftQtWMRET0F0q/hshMO1bch7nJif6nKuM3o
         BTqF+VbcOpk+LcEozOKV1p7Od5aAYLpNsCj9FZ0IS4AlKaPhFTTsJGv9Ejb+dK6cK5
         dd/Le1z60tHMUFV57T7jDy1VEo2e+icLNUxWZReF8GR+W8DHnN6k+/uPd12Mdoma7J
         bnYWQzCfSoRqi/Dv9lYXHVmU8/n4x+KdhRNY00MiXUROt4H0EHOpN4XxzBmFTqNaom
         mjNBS0K9dElxQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: ixp46x: fix ptp build failure
Date:   Wed, 21 Jul 2021 17:19:32 +0200
Message-Id: <20210721151951.2558679-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The rework of the ixp46x cpu detection left the network driver in
a half broken state:

drivers/net/ethernet/xscale/ptp_ixp46x.c: In function 'ptp_ixp_init':
drivers/net/ethernet/xscale/ptp_ixp46x.c:290:51: error: 'IXP4XX_TIMESYNC_BASE_VIRT' undeclared (first use in this function)
  290 |                 (struct ixp46x_ts_regs __iomem *) IXP4XX_TIMESYNC_BASE_VIRT;
      |                                                   ^~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/xscale/ptp_ixp46x.c:290:51: note: each undeclared identifier is reported only once for each function it appears in
drivers/net/ethernet/xscale/ptp_ixp46x.c: At top level:
drivers/net/ethernet/xscale/ptp_ixp46x.c:323:1: error: data definition has no type or storage class [-Werror]
  323 | module_init(ptp_ixp_init);

I have patches to complete the transition for a future release, but
for the moment, add the missing include statements to get it to build
again.

Fixes: 09aa9aabdcc4 ("soc: ixp4xx: move cpu detection to linux/soc/ixp4xx/cpu.h")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/xscale/ptp_ixp46x.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/xscale/ptp_ixp46x.c b/drivers/net/ethernet/xscale/ptp_ixp46x.c
index 99d4d9439d05..a6fb88fd42f7 100644
--- a/drivers/net/ethernet/xscale/ptp_ixp46x.c
+++ b/drivers/net/ethernet/xscale/ptp_ixp46x.c
@@ -14,6 +14,8 @@
 #include <linux/kernel.h>
 #include <linux/ptp_clock_kernel.h>
 #include <linux/soc/ixp4xx/cpu.h>
+#include <linux/module.h>
+#include <mach/ixp4xx-regs.h>
 
 #include "ixp46x_ts.h"
 
-- 
2.29.2

