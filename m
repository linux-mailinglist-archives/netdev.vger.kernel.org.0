Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD8A4C2D6A
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 14:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235178AbiBXNld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 08:41:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235181AbiBXNlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 08:41:32 -0500
Received: from smtp2.axis.com (smtp2.axis.com [195.60.68.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 274994FC54;
        Thu, 24 Feb 2022 05:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1645710061;
  x=1677246061;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=yj/Kubo401FMKbYI1pppYqnrVxPghG1puNDBjNlL3v4=;
  b=Tfxk0qcV30k6vLmf+RFBL3okXk9GjrgRQpD7MIbfle2dzKeKsSzOKRLj
   2gUrsJbWCoJVsMJSrEhQRL9HHT+TLkHk4Z+UWlX1omYqBdF7I8ee/Z4A7
   hy6wo12yBaaoxU6cAOYNRzD7+WfdAm9WcMd+6eGZHTS3VVKYtn+IKaTZS
   FpMI4BXk/ksTnyyaUYzkqY7ScXKI+HuhnfkTJdyorSreXM93erfxz4yiX
   LQP50LOziXCxAX4NKVh4rtTk6k+KU3fTMY/VG/BIBceHLhr0tsnXM5aic
   CfehDl7aAMsxm0jscbiw2Zbjw/BfSzlZaoc2qtT7mZSwgrSSUsn94fixv
   A==;
Date:   Thu, 24 Feb 2022 14:40:57 +0100
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     Denis Kirjanov <dkirjanov@suse.de>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        kernel <kernel@axis.com>, Lars Persson <Lars.Persson@axis.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net: stmmac: only enable DMA interrupts when ready
Message-ID: <20220224134057.GA4994@axis.com>
References: <20220224113829.1092859-1-vincent.whitchurch@axis.com>
 <f62148d7-6f7a-3557-e3ca-3a261b61ac9d@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f62148d7-6f7a-3557-e3ca-3a261b61ac9d@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 01:53:33PM +0100, Denis Kirjanov wrote:
> 2/24/22 14:38, Vincent Whitchurch пишет:
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > index 6708ca2aa4f7..43978558d6c0 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > @@ -2260,6 +2260,23 @@ static void stmmac_stop_tx_dma(struct stmmac_priv *priv, u32 chan)
> >   	stmmac_stop_tx(priv, priv->ioaddr, chan);
> >   }
> >   
> > +static void stmmac_enable_all_dma_irq(struct stmmac_priv *priv)
> > +{
> > +	u32 rx_channels_count = priv->plat->rx_queues_to_use;
> > +	u32 tx_channels_count = priv->plat->tx_queues_to_use;
> > +	u32 dma_csr_ch = max(rx_channels_count, tx_channels_count);
> > +	u32 chan;
> > +
> > +	for (chan = 0; chan < dma_csr_ch; chan++) {
> > +		struct stmmac_channel *ch = &priv->channel[chan];
> > +		unsigned long flags;
> > +
> > +		spin_lock_irqsave(&ch->lock, flags);
> > +		stmmac_enable_dma_irq(priv, priv->ioaddr, chan, 1, 1);
> > +		spin_unlock_irqrestore(&ch->lock, flags);
> > +	}
> > +}
> > +
> >   /**
> >    * stmmac_start_all_dma - start all RX and TX DMA channels
> >    * @priv: driver private structure
> > @@ -2902,8 +2919,10 @@ static int stmmac_init_dma_engine(struct stmmac_priv *priv)
> >   		stmmac_axi(priv, priv->ioaddr, priv->plat->axi);
> >   
> >   	/* DMA CSR Channel configuration */
> > -	for (chan = 0; chan < dma_csr_ch; chan++)
> > +	for (chan = 0; chan < dma_csr_ch; chan++) {
> >   		stmmac_init_chan(priv, priv->ioaddr, priv->plat->dma_cfg, chan);
> Did you miss to take a channel lock?

I didn't add it on purpose.  At this point during initialization there
is no-one who can race with the register write in
stmmac_disable_dma_irq().  The call to stmmac_init_chan() (in the
existing code) writes the same register without the lock. 

> > +		stmmac_disable_dma_irq(priv, priv->ioaddr, chan, 1, 1);
> > +	}
> >   
