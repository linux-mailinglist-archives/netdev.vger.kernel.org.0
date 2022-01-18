Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0E44923B6
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 11:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiARKWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 05:22:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiARKWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 05:22:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C900C061574;
        Tue, 18 Jan 2022 02:22:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C5E5612AF;
        Tue, 18 Jan 2022 10:22:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A21C00446;
        Tue, 18 Jan 2022 10:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642501335;
        bh=n2ayBOICvyWrfihLlmR5uPt2RCYfBgx6AyMG9eDIMXI=;
        h=From:To:Cc:Subject:Date:From;
        b=fxhlKW8hjLsNcLv+INfK5RAzcSqP1grlZZna7L++9ABVsrwAWZsiv8vmtsjQjl5Gt
         JhopABXU/Q2TpE6w88+EDvC6HHDWoMy894MBZArTZsBJgHxayuFYZlxzn6hxZ5ZVw0
         q/wkhoAON751sH5z3u7L+PcEAtS2d3ZjORE0m6spLhUlS0C3HNty1IC63ZnrujkMd9
         6mhzOX+kVciQqjqYlIwQ56FCWVoxmkmuJFkQluvfks7vP8haTCSANkhVTQ3E+jgBdH
         FaUV7VDttvZ9a7Mc98OuHU0aBm+aam5XvafHdS408roI7fmHAk94XH28sU5FGmau81
         XbQhawVDlJlnw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-omap@vger.kernel.org, arnd@arndb.de, davem@davemloft.net,
        kuba@kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [PATCH net] net: cpsw: avoid alignment faults by taking NET_IP_ALIGN into account
Date:   Tue, 18 Jan 2022 11:22:04 +0100
Message-Id: <20220118102204.1258645-1-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3834; h=from:subject; bh=n2ayBOICvyWrfihLlmR5uPt2RCYfBgx6AyMG9eDIMXI=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBh5pTLcARWy9ZVS7+03uNKavkkDy7NTmTWxwE4Y3f+ oTey+b+JAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYeaUywAKCRDDTyI5ktmPJJX7C/ 9ZcVoAWfoxnTJfDvpXi//ALHBSyu8soO+OaLPONzKFGLW8zZu66friwkbmcENqlPLVPj7J2JPtITkv J6k5tYiiRnzqTBMvls20rY19S/LKSEQ8Wzj130cqgAgGoOpQtmxSwi8xUQag1kIU9e5U0WK4ZN05Ed 8zX2UUYZYuG5ftBfReszXV8m1+4z9iRJv8Xpqum38lHpHtaXNFrMzBhf0tTyB5pGYOGsZmNkcDFUBe Fqch/JsQFu01OeBZh2Z8oBPzQcHtOBbstYWWl+WcXFOxNsEdmNpw7yIg+065eJ4tk1T2PeoE6F+Gb/ VjmwsDtzwT0H5UIME9uRzJddx/gOP8yCM1pGYUU5YS6QDSGb1rGjqfxoR+ipA6cNZPcXldu9H3VIQC MGCVDqezd/n9MOWpPB4YhLDrvhYKq2FTqJUXRYUoFNgYLTIrRfv5MhWrttDu5QrZA4/SSk1VQ2hzJ6 P6pBKqJN9PRTIQjnOmZ5Fkak6SynDVS7mJpNU+8heKWD0=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both versions of the CPSW driver declare a CPSW_HEADROOM_NA macro that
takes NET_IP_ALIGN into account, but fail to use it appropriately when
storing incoming packets in memory. This results in the IPv4 source and
destination addresses to appear misaligned in memory, which causes
aligment faults that need to be fixed up in software.

So let's switch from CPSW_HEADROOM to CPSW_HEADROOM_NA where needed.
This gets rid of any alignment faults on the RX path on a Beaglebone
White.

Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/net/ethernet/ti/cpsw.c      | 6 +++---
 drivers/net/ethernet/ti/cpsw_new.c  | 6 +++---
 drivers/net/ethernet/ti/cpsw_priv.c | 2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 33142d505fc8..03575c017500 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -349,7 +349,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 	struct cpsw_common	*cpsw = ndev_to_cpsw(xmeta->ndev);
 	int			pkt_size = cpsw->rx_packet_max;
 	int			ret = 0, port, ch = xmeta->ch;
-	int			headroom = CPSW_HEADROOM;
+	int			headroom = CPSW_HEADROOM_NA;
 	struct net_device	*ndev = xmeta->ndev;
 	struct cpsw_priv	*priv;
 	struct page_pool	*pool;
@@ -392,7 +392,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 	}
 
 	if (priv->xdp_prog) {
-		int headroom = CPSW_HEADROOM, size = len;
+		int size = len;
 
 		xdp_init_buff(&xdp, PAGE_SIZE, &priv->xdp_rxq[ch]);
 		if (status & CPDMA_RX_VLAN_ENCAP) {
@@ -442,7 +442,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 	xmeta->ndev = ndev;
 	xmeta->ch = ch;
 
-	dma = page_pool_get_dma_addr(new_page) + CPSW_HEADROOM;
+	dma = page_pool_get_dma_addr(new_page) + CPSW_HEADROOM_NA;
 	ret = cpdma_chan_submit_mapped(cpsw->rxv[ch].ch, new_page, dma,
 				       pkt_size, 0);
 	if (ret < 0) {
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 279e261e4720..bd4b1528cf99 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -283,7 +283,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 {
 	struct page *new_page, *page = token;
 	void *pa = page_address(page);
-	int headroom = CPSW_HEADROOM;
+	int headroom = CPSW_HEADROOM_NA;
 	struct cpsw_meta_xdp *xmeta;
 	struct cpsw_common *cpsw;
 	struct net_device *ndev;
@@ -336,7 +336,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 	}
 
 	if (priv->xdp_prog) {
-		int headroom = CPSW_HEADROOM, size = len;
+		int size = len;
 
 		xdp_init_buff(&xdp, PAGE_SIZE, &priv->xdp_rxq[ch]);
 		if (status & CPDMA_RX_VLAN_ENCAP) {
@@ -386,7 +386,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 	xmeta->ndev = ndev;
 	xmeta->ch = ch;
 
-	dma = page_pool_get_dma_addr(new_page) + CPSW_HEADROOM;
+	dma = page_pool_get_dma_addr(new_page) + CPSW_HEADROOM_NA;
 	ret = cpdma_chan_submit_mapped(cpsw->rxv[ch].ch, new_page, dma,
 				       pkt_size, 0);
 	if (ret < 0) {
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index 3537502e5e8b..ba220593e6db 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -1122,7 +1122,7 @@ int cpsw_fill_rx_channels(struct cpsw_priv *priv)
 			xmeta->ndev = priv->ndev;
 			xmeta->ch = ch;
 
-			dma = page_pool_get_dma_addr(page) + CPSW_HEADROOM;
+			dma = page_pool_get_dma_addr(page) + CPSW_HEADROOM_NA;
 			ret = cpdma_chan_idle_submit_mapped(cpsw->rxv[ch].ch,
 							    page, dma,
 							    cpsw->rx_packet_max,
-- 
2.30.2

