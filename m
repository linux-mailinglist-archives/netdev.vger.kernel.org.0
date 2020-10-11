Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C11428A742
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 13:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387710AbgJKLqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 07:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387489AbgJKLqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 07:46:18 -0400
X-Greylist: delayed 344 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 11 Oct 2020 04:46:16 PDT
Received: from valentin-vidic.from.hr (valentin-vidic.from.hr [IPv6:2001:470:1f0b:3b7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A0EC0613CE;
        Sun, 11 Oct 2020 04:46:16 -0700 (PDT)
X-Virus-Scanned: Debian amavisd-new at valentin-vidic.from.hr
Received: by valentin-vidic.from.hr (Postfix, from userid 1000)
        id DA40A3FDF; Sun, 11 Oct 2020 13:40:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=valentin-vidic.from.hr; s=2020; t=1602416424;
        bh=kLUtzGm/mOxFRk7ierRj4MOQrCli4dPiEbdR2LcWxqQ=;
        h=From:To:Cc:Subject:Date:From;
        b=VO6MnSAqm52dlNEvak1+TarsFGx++KHwe8G77UO/GINYWz/HdyMa/AX/vg1ax5mvJ
         r4CaUeakpPDerkySy8MlUWeFT+WA03ra1eDS8n9z6Fi/ez+Lsmbg6GoSZ/gBbz8Rl0
         C0lzn2hBLlcOBpKt30RPRiwXvv5myNsE/fTPW39YxmKpvyv54OYuz5SNQoIK+Yz7xy
         +vrSmtngv1SHBr9oUDUy+Au1zwWCr/l8XiY8QOxHlhHGRpCV5xXanVGv8cghMTvFZ2
         OR1chuKQwEoP+eN0lBUt9qIKzg4fqFgNUyNWF1wW54Ml9XOy3pH+3iv5pD9c9YRXru
         MZ3cn2er1CYnrg3YVTv/sBLwXF6eaUbT/OnwpsXBbF3eXjWOfHN2IRA+6SL3R20BcD
         WtMgTsM1fj4l/WbYY2iDv5OYnqfFukSZWDXh17AszFyW+C+7XLgwwP3phdrxmsg00+
         EjXYGVV73tXzgv/hI/q2qTme+DVvVv1rpcPYkN4+mtp2FddtDR9m/rU19qu95wr5YI
         VA6rA/l38++n5JpQ9pZgSeI3Z8nnDEejJw9ht8q3E8qsco/KryHCWnjPqPdX/t8THj
         ydps+fgAihbOe0EsOA865TXFSy9hmQpV8P67LZKEyiuNygXmFjSqMa3R9LkBsWtOLU
         VmvHIqu4NgpmcptE98ZG0/nU=
From:   Valentin Vidic <vvidic@valentin-vidic.from.hr>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Philip Rischel <rischelp@idt.com>, Felix Fietkau <nbd@openwrt.org>,
        Florian Fainelli <florian@openwrt.org>,
        Roman Yeryomin <roman@advem.lv>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Martin Habets <mhabets@solarflare.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Valentin Vidic <vvidic@valentin-vidic.from.hr>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: korina: free array used for rx/tx descriptors
Date:   Sun, 11 Oct 2020 13:39:55 +0200
Message-Id: <20201011113955.19511-1-vvidic@valentin-vidic.from.hr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Memory was not freed when driver is unloaded from the kernel.

Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>
---
 drivers/net/ethernet/korina.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index 03e034918d14..99146145f020 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -1133,6 +1133,7 @@ static int korina_remove(struct platform_device *pdev)
 	iounmap(lp->eth_regs);
 	iounmap(lp->rx_dma_regs);
 	iounmap(lp->tx_dma_regs);
+	kfree(lp->td_ring);
 
 	unregister_netdev(bif->dev);
 	free_netdev(bif->dev);
-- 
2.20.1

