Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE0584BB6C8
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 11:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbiBRKXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 05:23:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbiBRKXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 05:23:23 -0500
Received: from smtp1.axis.com (smtp1.axis.com [195.60.68.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424B52B1AA1;
        Fri, 18 Feb 2022 02:23:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1645179787;
  x=1676715787;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0t0ig3q6Sp2mvoezO0JaagGhH+DGXuT456KDBH79FZ0=;
  b=pHI6jFzvxoi0j3ne7wO34lrazDpzu6REhaVP5x9nJ/IpQKNqL3FS4GKH
   rf/wpDyUIngYpdO87FBPTLInPxtDaQO/tCBvjvr7L0/JxybMwot6yZqJa
   KmhKeD3ttWqwp5B0BSf/ip0MKs8h1l1yU6/Z/SZlngGwHVjwmQ+SrYJd6
   uKfIZ9wdMECVwEmXyL3lBipUF6zMQC1KZdm1o7h/RBynLF5iH3HFP+dlS
   UZiUFrZ+MPLmYGI+x3DEqLhBf3DyQVoPZ3b3Bwe6U17rxSi624TbfVLW+
   uE5Ca0jqMRc1VuoWPj4MMZLfpLkFvuKJGsMlJiSEJG0Fti4ytTI6fBfC3
   g==;
Date:   Fri, 18 Feb 2022 11:23:03 +0100
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        kernel <kernel@axis.com>, Lars Persson <Lars.Persson@axis.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: stmmac: Enable NAPI before interrupts go live
Message-ID: <20220218102303.GA21458@axis.com>
References: <20220217145527.2696444-1-vincent.whitchurch@axis.com>
 <20220217203604.39e318d0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220217203604.39e318d0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 05:36:04AM +0100, Jakub Kicinski wrote:
> On Thu, 17 Feb 2022 15:55:26 +0100 Vincent Whitchurch wrote:
> > The stmmac_open function has a race window between enabling the RX
> > path and its interrupt to the point where napi_enabled is called.
> > 
> > A chatty network with plenty of broadcast/multicast traffic has the
> > potential to completely fill the RX ring before the interrupt handler
> > is installed. In this scenario the single interrupt taken will find
> > napi disabled and the RX ring will not be processed. No further RX
> > interrupt will be delivered because the ring is full.
> > 
> > The RX stall could eventually clear because the TX path will trigger a
> > DMA interrupt once the tx_coal_frames threshold is reached and then
> > NAPI becomes scheduled.
> 
> LGTM, although now the ndo_open and ndo_stop paths are not symmetrical.
> Is there no way to mask the IRQs so that they don't fire immediately?

The initial enabling of the DMA irqs is done as part of the
->init_chan() callback inside the various variants.  We could use the
->disable_dma_irq() callback to to disable the DMA irqs and only enable
them at the end of the init sequence with a stmmac_enable_all_dma_irq().

This avoids having to change all the variants and there should be no
problem in calling ->disable_dma_irq() after the interrupts have been
momentarily enabled in ->stmmac_init_chan() since the DMA is reset
before these calls and not started until later.

Note that I haven't added a symmetrical stmmac_disable_all_dma_irq() at
the top of stmmac_release() before the NAPI disable since I can't see
that it would do any good there since NAPI can re-enable DMA irqs.

> More common flow (IMO) would be:
>  - request irq
>  - mask irq
>  - populate rings
>  - start dma
>  - enable napi
>  - unmask irq

I don't think this driver has ever followed this exact sequence, but the
request_irq() was done before the "start dma" and the "enable napi"
before the commit mentioned in the Fixes: tag.  But that's quite a while
ago and the driver has changed a lot since then and gotten support for a
lot of variants and features which I can't test, so I didn't dare to
rewrite the entire init sequence.

> Other than the difference in flow between open/stop there may also be
> some unpleasantness around restarting tx queues twice with the patch
> as is.

New patch below, it works for me (though I don't have hardware with
working suspend/resume support).  I will send it out as a v2 if there
are no objections.  Thanks.

8<-----
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 6708ca2aa4f7..43978558d6c0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2260,6 +2260,23 @@ static void stmmac_stop_tx_dma(struct stmmac_priv *priv, u32 chan)
 	stmmac_stop_tx(priv, priv->ioaddr, chan);
 }
 
+static void stmmac_enable_all_dma_irq(struct stmmac_priv *priv)
+{
+	u32 rx_channels_count = priv->plat->rx_queues_to_use;
+	u32 tx_channels_count = priv->plat->tx_queues_to_use;
+	u32 dma_csr_ch = max(rx_channels_count, tx_channels_count);
+	u32 chan;
+
+	for (chan = 0; chan < dma_csr_ch; chan++) {
+		struct stmmac_channel *ch = &priv->channel[chan];
+		unsigned long flags;
+
+		spin_lock_irqsave(&ch->lock, flags);
+		stmmac_enable_dma_irq(priv, priv->ioaddr, chan, 1, 1);
+		spin_unlock_irqrestore(&ch->lock, flags);
+	}
+}
+
 /**
  * stmmac_start_all_dma - start all RX and TX DMA channels
  * @priv: driver private structure
@@ -2902,8 +2919,10 @@ static int stmmac_init_dma_engine(struct stmmac_priv *priv)
 		stmmac_axi(priv, priv->ioaddr, priv->plat->axi);
 
 	/* DMA CSR Channel configuration */
-	for (chan = 0; chan < dma_csr_ch; chan++)
+	for (chan = 0; chan < dma_csr_ch; chan++) {
 		stmmac_init_chan(priv, priv->ioaddr, priv->plat->dma_cfg, chan);
+		stmmac_disable_dma_irq(priv, priv->ioaddr, chan, 1, 1);
+	}
 
 	/* DMA RX Channel Configuration */
 	for (chan = 0; chan < rx_channels_count; chan++) {
@@ -3759,6 +3778,7 @@ static int stmmac_open(struct net_device *dev)
 
 	stmmac_enable_all_queues(priv);
 	netif_tx_start_all_queues(priv->dev);
+	stmmac_enable_all_dma_irq(priv);
 
 	return 0;
 
@@ -6508,8 +6528,10 @@ int stmmac_xdp_open(struct net_device *dev)
 	}
 
 	/* DMA CSR Channel configuration */
-	for (chan = 0; chan < dma_csr_ch; chan++)
+	for (chan = 0; chan < dma_csr_ch; chan++) {
 		stmmac_init_chan(priv, priv->ioaddr, priv->plat->dma_cfg, chan);
+		stmmac_disable_dma_irq(priv, priv->ioaddr, chan, 1, 1);
+	}
 
 	/* Adjust Split header */
 	sph_en = (priv->hw->rx_csum > 0) && priv->sph;
@@ -6570,6 +6592,7 @@ int stmmac_xdp_open(struct net_device *dev)
 	stmmac_enable_all_queues(priv);
 	netif_carrier_on(dev);
 	netif_tx_start_all_queues(dev);
+	stmmac_enable_all_dma_irq(priv);
 
 	return 0;
 
@@ -7447,6 +7470,7 @@ int stmmac_resume(struct device *dev)
 	stmmac_restore_hw_vlan_rx_fltr(priv, ndev, priv->hw);
 
 	stmmac_enable_all_queues(priv);
+	stmmac_enable_all_dma_irq(priv);
 
 	mutex_unlock(&priv->lock);
 	rtnl_unlock();
