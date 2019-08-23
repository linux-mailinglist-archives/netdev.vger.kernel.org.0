Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C766C9B1A0
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 16:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388772AbfHWOIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 10:08:39 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:50141 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389796AbfHWOIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 10:08:38 -0400
Received: from [192.168.1.41] ([90.126.160.115])
        by mwinf5d06 with ME
        id se8M200092Vh0YS03e8M18; Fri, 23 Aug 2019 16:08:36 +0200
X-ME-Helo: [192.168.1.41]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 23 Aug 2019 16:08:36 +0200
X-ME-IP: 90.126.160.115
Subject: =?UTF-8?Q?Re=3a_=5bPATCH=5d_ethernet=3a_Delete_unnecessary_checks_b?=
 =?UTF-8?Q?efore_the_macro_call_=e2=80=9cdev=5fkfree=5fskb=e2=80=9d?=
To:     Markus Elfring <Markus.Elfring@web.de>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        intel-wired-lan@lists.osuosl.org,
        bcm-kernel-feedback-list@broadcom.com,
        UNGLinuxDriver@microchip.com,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Allison Randal <allison@lohutok.net>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Berger <opendmb@gmail.com>,
        Douglas Miller <dougmill@linux.ibm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jilayne Lovejoy <opensource@jilayne.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Kate Stewart <kstewart@linuxfoundation.org>
Cc:     kernel-janitors@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <af1ae1cf-4a01-5e3a-edc2-058668487137@web.de>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <4ab7f2a5-f472-f462-9d4c-7c8d5237c44e@wanadoo.fr>
Date:   Fri, 23 Aug 2019 16:08:20 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <af1ae1cf-4a01-5e3a-edc2-058668487137@web.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

in this patch, there is one piece that looked better before. (see below)

Removing the 'if (skb)' is fine, but concatening everything in one 
statement just to save 2 variables and a few LOC is of no use, IMHO, and 
the code is less readable.

just my 2c.


CJ


diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c 
b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index d3a0b614dbfa..8b19ddcdafaa 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2515,19 +2515,14 @@ static int bcmgenet_dma_teardown(struct 
bcmgenet_priv *priv)
  static void bcmgenet_fini_dma(struct bcmgenet_priv *priv)
  {
      struct netdev_queue *txq;
-    struct sk_buff *skb;
-    struct enet_cb *cb;
      int i;

      bcmgenet_fini_rx_napi(priv);
      bcmgenet_fini_tx_napi(priv);

-    for (i = 0; i < priv->num_tx_bds; i++) {
-        cb = priv->tx_cbs + i;
-        skb = bcmgenet_free_tx_cb(&priv->pdev->dev, cb);
-        if (skb)
-            dev_kfree_skb(skb);
-    }
+    for (i = 0; i < priv->num_tx_bds; i++)
+ dev_kfree_skb(bcmgenet_free_tx_cb(&priv->pdev->dev,
+                          priv->tx_cbs + i));

      for (i = 0; i < priv->hw_params->tx_queues; i++) {
          txq = netdev_get_tx_queue(priv->dev, priv->tx_rings[i].queue);
