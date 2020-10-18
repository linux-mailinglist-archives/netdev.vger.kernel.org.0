Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D92472918E7
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 20:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbgJRSnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 14:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbgJRSnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 14:43:14 -0400
Received: from valentin-vidic.from.hr (valentin-vidic.from.hr [IPv6:2001:470:1f0b:3b7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577E6C061755;
        Sun, 18 Oct 2020 11:43:13 -0700 (PDT)
X-Virus-Scanned: Debian amavisd-new at valentin-vidic.from.hr
Received: by valentin-vidic.from.hr (Postfix, from userid 1000)
        id 03CD7408F; Sun, 18 Oct 2020 20:43:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=valentin-vidic.from.hr; s=2020; t=1603046582;
        bh=gRzHD+oSUHpkztyZmdldRMqm3tZdYir04yyrrfQNfX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=viPMi1YdG9dmmH2ANBu+MCdM/WReOw/DHXlYYl7jwTaqMTKp6A9qe9qY255w04JqK
         SCZxiOIEoqroiaVjqZFaqQ8kOgt6FdmQ2GXwJCmGSXbAtC5Oiv9bjcFsXmxVECsfrx
         dEHm2z4zO2oSnCijXWTLMu5a7YSfdYwQ0jQH+85732i3Td7L2F6vwzBFd63HWaOwEL
         5Z0B4A5b0jJFjP6SXGes6MwPLJzGrL6Hq3m/u1VH5HD56lk5k8R8+Z9BnSpYqD3eaG
         fpzM12BQFa6SmGgWLCkQUy7nJrkVGTWc5sw7/hviCBoDg4iS3jBeWAKyX+ZWlmGUg+
         JjZd+SjyLEZ87bQ7fVh0R6Z7xqIDVGNIDfBbSGhBZy20OfFbeb+zLRqVy9k7mEnSrd
         ladi2caC4nVERtJxq2rdN88YRwNeNFJ9OkYKaaNKTWdYc98cE5lGKVpNgNWUg7wc/r
         Q/NQkyHSyy5yJbqk333SYL5y9V/tpdJt6D22HlGrgkZVYVWY0bebDLdzdCUoMGQDCp
         FDApFpJHvpCaH0YUIGJzv60/FX+9URXomv2s468uJrVr3pOvuIiz6mlW5vdFYDN/h2
         ir5Wt1fFamYTa8l5+lvvLGvTkIbSFLKzBMJXqVv8SIGWMZJw4KyilmjrqHtCPJy4gn
         K2EL8vbdfkTruZCRbinG55YU=
From:   Valentin Vidic <vvidic@valentin-vidic.from.hr>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Philip Rischel <rischelp@idt.com>,
        Florian Fainelli <florian@openwrt.org>,
        Roman Yeryomin <roman@advem.lv>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Martin Habets <mhabets@solarflare.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Valentin Vidic <vvidic@valentin-vidic.from.hr>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] net: korina: cast KSEG0 address to pointer in kfree
Date:   Sun, 18 Oct 2020 20:42:55 +0200
Message-Id: <20201018184255.28989-1-vvidic@valentin-vidic.from.hr>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201016194611.GK8773@valentin-vidic.from.hr>
References: <20201016194611.GK8773@valentin-vidic.from.hr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc warning:

passing argument 1 of 'kfree' makes pointer from integer without a cast

Fixes: 3af5f0f5c74e ("net: korina: fix kfree of rx/tx descriptor array")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>
---
 drivers/net/ethernet/korina.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index af441d699a57..bf48f0ded9c7 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -1113,7 +1113,7 @@ static int korina_probe(struct platform_device *pdev)
 	return rc;
 
 probe_err_register:
-	kfree(KSEG0ADDR(lp->td_ring));
+	kfree((struct dma_desc *)KSEG0ADDR(lp->td_ring));
 probe_err_td_ring:
 	iounmap(lp->tx_dma_regs);
 probe_err_dma_tx:
@@ -1133,7 +1133,7 @@ static int korina_remove(struct platform_device *pdev)
 	iounmap(lp->eth_regs);
 	iounmap(lp->rx_dma_regs);
 	iounmap(lp->tx_dma_regs);
-	kfree(KSEG0ADDR(lp->td_ring));
+	kfree((struct dma_desc *)KSEG0ADDR(lp->td_ring));
 
 	unregister_netdev(bif->dev);
 	free_netdev(bif->dev);
-- 
2.20.1

