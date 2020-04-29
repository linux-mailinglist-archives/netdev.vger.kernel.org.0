Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E751BD78A
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 10:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgD2IsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 04:48:08 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:36793 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgD2IsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 04:48:07 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MZCOl-1jgegV2MXh-00V7l9; Wed, 29 Apr 2020 10:47:54 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] dpaa2-eth: debugfs: use div64_u64 for division
Date:   Wed, 29 Apr 2020 10:47:22 +0200
Message-Id: <20200429084740.2665893-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:JfNeeEx0olSSRzhxiQEp15g+QVP6cDJNVOOCYktX9TalmzZn3hd
 z2oYTqndiXg/znyl2mxXOxFj7KS9ryp18cKZor6IT+ivkN9a0jsy2CYNqvh4E/NHdMwPkyA
 n9KqnRTc97pMM/bgE4GfpLcr59CLE/v9wfnud1d3J3+rZJIsMOdlSSkwC7zPyHyCpZJ2AMz
 qcYy3sqIkRgkF9rMq42uQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:95pt5O6yTM0=:dYCSEoJZBytA9RaJU0hG1/
 B7Y1bI/hIalo/N/UrY5WGsa7F6DQkyM7TE+KP1ym/+6Nnt8SteugYBLQRqCdoQ1H3MUdNGL+z
 NktN1U9CEvf+m+KXfh33zKHQh6Dh08uusCP+GNvrFc/wwOfIuUm5qSzgnJAdZUNzMXfRuAFk3
 Mg8pjIHyTIgYS1zhczCf0Buqltn4MwxEG9QIsXiFhi+7n9/qFcCipRLaCJuNVi5xtfJgfgBFl
 jbh/XtKCF++HsSRvxTezwYiGGehPjR1KDNJ2dT6zCB07+sfXsjXq+S4ugMkgz17+UiiPv7n92
 dmMECdJ/yt2yOWa1At026X4/6edpuIS6QJVVlDEFZ7MbXuukFefSpvE0u/NzDRbEd6a8uRoQz
 q5JeiC2+hPNTDYfGnwxB6QmvsQZYqclYRfMO5BDOWxn7oBlXWIIYz48tZqs4x4WAqpmB+HL1U
 TF82/bKIG5HOZiq4ki04ghOyWiptBMc4zjhYAFa2yQP2c8uPzoVVrypyRKCbymrtJ+2znVV9F
 RGi58Wlvsdxp29WHdAWX1SlHwqGRKgvXG1oFySZ5k4Nd/Gog4B6+kUkD+zeaq4H7G0TYNwR9B
 W1mAIWRSwtsvzWf/cAIVaVvqdCU1UmFSIOav0r15Z5tImXjC6slhM+IO/B2JJtxOU3NTOZ+JR
 aJ6eJubQkpeDyYs3UF5/w3IFE2sqbRPFozHjt3Al1r5L1BW8jL5cRXzYeJYwUE0c3Ed5JHLrt
 bLJwsOmpnndNw9kQFxf4lQLf/NTu1ZHg4MvOBvMuhOTfZxKTkSSROkdt+YqUKIz9mldfUpJ4+
 JKFtNeprj/gXFXLIcjk61v7y1QI8ScRuWXW84dY7JbJMQ4OKis=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A plain 64-bit division breaks building on 32-bit architectures:

ERROR: modpost: "__aeabi_uldivmod" [drivers/net/ethernet/freescale/dpaa2/fsl-dpaa2-eth.ko] undefined!

As this function is not performance critical, just use the external
helper instead.

Fixes: 460fd830dd9d ("dpaa2-eth: add channel stat to debugfs")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
index 80291afff3ea..0a31e4268dfb 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
@@ -139,7 +139,7 @@ static int dpaa2_dbg_ch_show(struct seq_file *file, void *offset)
 			   ch->stats.dequeue_portal_busy,
 			   ch->stats.frames,
 			   ch->stats.cdan,
-			   ch->stats.frames / ch->stats.cdan,
+			   div64_u64(ch->stats.frames, ch->stats.cdan),
 			   ch->buf_count);
 	}
 
-- 
2.26.0

