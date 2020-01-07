Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDD271330D2
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 21:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbgAGUom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 15:44:42 -0500
Received: from mout.kundenserver.de ([217.72.192.73]:54201 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbgAGUol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 15:44:41 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MvJwN-1jfnHF0bPV-00rIcC; Tue, 07 Jan 2020 21:44:08 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Chas Williams <3chas3@gmail.com>
Cc:     Oleksandr Natalenko <oleksandr@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] atm: eni: fix uninitialized variable warning
Date:   Tue,  7 Jan 2020 21:43:59 +0100
Message-Id: <20200107204405.1422392-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:TULl6mCWkNiAv5gxPXgAs79zlyz2CnZQ3KHOTQwLVhohs0SX6Jk
 635/RcyQ672j8iOwYflEsNPY3GZy3Sa3cxjLx21sdZGGDuw0B2SLPMgFbx7y9dhFOEX2ava
 ThSXBB22GBsmZaf8421yU2sT5IHI5NFSr0KUTlhpFNOQb1b+PvhTO3AdydIn8Xc9AgmbXQA
 fMyWIdUZIPI0xyPKibNqw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:kVeW3gESbxE=:XXOuJlHEUO5YI8v8Kwlpih
 4i/HnjhwF9rKJOIwC7J+j00TzQp3ZC9ZXAsXWZSKD2+vHbC2jPofn7yYIoakUBrd1Vousz9Y4
 J/VPgbq+Rou1w/habACrK2uvSIX2XwJAC7xPsFx9xu294iVc4jWFNEmsSVnxX+bUtb58EqeoV
 UlWOHdAyTvsUUPKBtGpFGK/lfkadZ6GNevkJoTY+Lq6wuduU1SLuUcxevqLCq6Cbv8jEgHinm
 EcXGDaIFWb1d9e8v6JQoMTsye7xhTvUq5gs9pMgx8RMTKaLlm5S6CA0ilHShzZMi9zgRzX7+a
 8hyyB26HY9rUND3nGgVAfp1bZ1aalm4O028XlZ74zD95IGqaeAAoAIhjQ6SLdu8C4Cxw6Z7T8
 x0HBKDig+T0J5p0JRM9+hB87PrR+jubsy6JpNao8CchGgGkSwaRLKrdpp/18p3ZbRUhizQW8/
 pyKrC1VNPKtuPn5cz4oqOCOuMo3tgDTbyPxUGdwHIoyWV073797s8OCMLQ/2MzFUsHFvCByxu
 c/H53N2bnLyan7JTpvFAZPnPC2ug9mMqLxQqQanrmRV+6EzZ1NWkQjH4/7SQXitsQ5E/7iC+9
 cHEyCBMMmHxPW8VuiAWzwv6MinatLCogJGg7R2FNsqKWgsth7dBiupQTmUzI8ZTVphbakGuhI
 3lobEJZcLyH0bP+EH+Us0Z8weohuNpDZYyeK3bVvPuo6+AWIvzrj8fzcPBbUjEbXJf6pgQfzf
 MscZpkjndV/iomUZqVH3+vF1+TY0fS0Y9NnHlZ8+242P014i4L65bZzcgrwBYRw1Jp3hQG+K7
 F1uwxyzwH/q0adP/KL6OaUoOBO/3f2xkfCjIrazX08KttAue2+ToZGd5g6yjsHi+SKUcGPkMm
 oZjM08tTakOJKTVBCqRA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With -O3, gcc has found an actual unintialized variable stored
into an mmio register in two instances:

drivers/atm/eni.c: In function 'discard':
drivers/atm/eni.c:465:13: error: 'dma[1]' is used uninitialized in this function [-Werror=uninitialized]
   writel(dma[i*2+1],eni_dev->rx_dma+dma_wr*8+4);
             ^
drivers/atm/eni.c:465:13: error: 'dma[3]' is used uninitialized in this function [-Werror=uninitialized]

Change the code to always write zeroes instead.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/atm/eni.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index 8fad56f185ba..17d47ad03ab7 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -368,7 +368,7 @@ static int do_rx_dma(struct atm_vcc *vcc,struct sk_buff *skb,
 		here = (eni_vcc->descr+skip) & (eni_vcc->words-1);
 		dma[j++] = (here << MID_DMA_COUNT_SHIFT) | (vcc->vci
 		    << MID_DMA_VCI_SHIFT) | MID_DT_JK;
-		j++;
+		dma[j++] = 0;
 	}
 	here = (eni_vcc->descr+size+skip) & (eni_vcc->words-1);
 	if (!eff) size += skip;
@@ -441,7 +441,7 @@ static int do_rx_dma(struct atm_vcc *vcc,struct sk_buff *skb,
 	if (size != eff) {
 		dma[j++] = (here << MID_DMA_COUNT_SHIFT) |
 		    (vcc->vci << MID_DMA_VCI_SHIFT) | MID_DT_JK;
-		j++;
+		dma[j++] = 0;
 	}
 	if (!j || j > 2*RX_DMA_BUF) {
 		printk(KERN_CRIT DEV_LABEL "!j or j too big!!!\n");
-- 
2.20.0

