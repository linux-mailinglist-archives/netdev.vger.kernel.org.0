Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7EF42C376
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 16:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233870AbhJMOiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 10:38:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230488AbhJMOiV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 10:38:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BDDB610C8;
        Wed, 13 Oct 2021 14:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634135778;
        bh=OG5wRgqcAA5noLWxd5C6pZdRgKJkpA9IWZbgpEqWuMU=;
        h=From:To:Cc:Subject:Date:From;
        b=Wy9qyQ51KU6s4/u0fwnEXWMd7cBozkE2/nnssaj1oWz4/nbKJ7GCcfP6TGpg3byfS
         rXrj0v52nAPmEmp9jnI+U65RZv+86FnOd1ZiWypQyX/TykQPIskwcFCERs8XI0J4vy
         FHX/HbaeiO1Rv5/4N6WBFefCzfk/HisxUcrPfkM9sXFvJiWD5SG4oCuAg8rWcW0VFK
         AB8jRpXUlonAEw5fKGl+oZHiSspFI5beNkkTp4el8DUb67QkizcBYEH4cPdeq+eTlR
         wpufgFklbSv6eHTH7w1J6Uvut/dn1yMQcsyFaRNfEF/L7Frr4SrKUY0Ohu/oI4k+Nh
         mqVZy+5Vbp70Q==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Jon Mason <jdmason@kudzu.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sreenivasa Honnur <sreenivasa.honnur@neterion.com>,
        Jeff Garzik <jeff@garzik.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ethernet: s2io: fix setting mac address during resume
Date:   Wed, 13 Oct 2021 16:35:49 +0200
Message-Id: <20211013143613.2049096-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

After recent cleanups, gcc started warning about a suspicious
memcpy() call during the s2io_io_resume() function:

In function '__dev_addr_set',
    inlined from 'eth_hw_addr_set' at include/linux/etherdevice.h:318:2,
    inlined from 's2io_set_mac_addr' at drivers/net/ethernet/neterion/s2io.c:5205:2,
    inlined from 's2io_io_resume' at drivers/net/ethernet/neterion/s2io.c:8569:7:
arch/x86/include/asm/string_32.h:182:25: error: '__builtin_memcpy' accessing 6 bytes at offsets 0 and 2 overlaps 4 bytes at offset 2 [-Werror=restrict]
  182 | #define memcpy(t, f, n) __builtin_memcpy(t, f, n)
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
include/linux/netdevice.h:4648:9: note: in expansion of macro 'memcpy'
 4648 |         memcpy(dev->dev_addr, addr, len);
      |         ^~~~~~

What apparently happened is that an old cleanup changed the calling
conventions for s2io_set_mac_addr() from taking an ethernet address
as a character array to taking a struct sockaddr, but one of the
callers was not changed at the same time.

Change it to instead call the low-level do_s2io_prog_unicast() function
that still takes the old argument type.

Fixes: 2fd376884558 ("S2io: Added support set_mac_address driver entry point")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/neterion/s2io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 5454c1c2f8ad..ade47c4fdae0 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -8566,7 +8566,7 @@ static void s2io_io_resume(struct pci_dev *pdev)
 			return;
 		}
 
-		if (s2io_set_mac_addr(netdev, netdev->dev_addr) == FAILURE) {
+		if (do_s2io_prog_unicast(netdev, netdev->dev_addr) == FAILURE) {
 			s2io_card_down(sp);
 			pr_err("Can't restore mac addr after reset.\n");
 			return;
-- 
2.29.2

